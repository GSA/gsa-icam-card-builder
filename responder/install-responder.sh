#!/bin/bash
#
#vim: set ts=2 nowrap
# Copy this file to the directory on the VM where you've copied the
# tar file, responder-certs.tar.  Then run it by typing "sh install-responder.sh"

# Usage: -d option will just install data

if [ $# -eq 1 -a $1 == "-d" ]; then 
  echo "Certificates and revocation data update."
  DATAONLY=1
else
  DATAONLY=0
fi

##

CRLHOST=1 # Change to zero if not hosting CRL/AIA/SIA on this VM

# Extract the .p12 and index files into the responder VM's /etc/pki/CA
# directory

CWD=$(pwd)
cp responder-certs.tar /etc/pki/CA
cd /etc/pki/CA
tar xvf responder-certs.tar

# Then, run this script to create OCSP response signer keys and certs.  
# Split .p12 files from ICAM_CA_and_Signer files to be used in
# on the responder VM.

cat << %% >splitp12.sh
COUNT=0
for F in \\
  ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Invalid_Signature_gen3.p12 \\
  ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12
do
    COUNT=\$(expr \$COUNT + 1)
    case \$COUNT in
    1) N=ocsp ;;
    2) N=ocspExpired ;;
    3) N=ocspNocheckNotPresent ;;
    4) N=ocspRevoked ;;
    5) N=ocspInvalidSig ;;
    6) N=ocsp-pivi ;;
    esac

    # Get the signer private and public keys

    openssl pkcs12 \\
    -in \$F \\
    -nocerts \\
    -nodes \\
    -passin pass: \\
    -passout pass: \\
    -out \$(basename \$N .p12).key

    openssl pkcs12 \\
    -in \$F \\
    -clcerts \\
    -passin pass: \\
    -nokeys \\
    -out \$(basename \$N .p12).crt
 
    /bin/rm \$F
done
%%

sh splitp12.sh
chmod 600 *.key

mv ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt PIV_Signing_CA.crt
mv ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt PIV-I_Signing_CA.crt

echo "unique_subject = no" >index.txt.attr

if [ $DATAONLY -eq 1 -a -d /var/www/http.apl-test.cite.fpki-lab.gov ]; then
  pushd http.apl-test.cite.fpki-lab.gov >/dev/null 2>&1
    if [ -f $CWD/aiacrlssia.tar ]; then
      tar xv --no-same-owner --no-same-permissions -f $CWD/aiacrlssia.tar
    fi
  popd >/dev/null 2>&1
  echo "Data has been updated. Exiting."
  exit 0
fi

# General:

# Hosts file aliases. x.x.x.x is the NAT'd IP address of the box. The rest are aliases
# recognized by Apache2.

IPADDR=$(ifconfig -a | grep "inet " | head -n1 | awk '{ print $2 }')
HOSTNAME=$(hostname)

GC=0
grep $IPADDR /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep $HOSTNAME /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)

if [ $CRLHOST -eq 1 ]; then
  grep http.apl-test.cite.fpki-lab.gov /etc/host >/dev/null 2>&1; GC=$(expr $? + $GC)
fi
grep ocsp.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep ocspExpired.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep ocspInvalidSig.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1 >/dev/null 2>&1; GC=$(expr $? + $GC)
grep ocspRevoked.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep ocsp-pivi.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)

if [ $GC -gt 0 ]; then
  cp -p /etc/hosts /etc/hosts.$$
  grep -v lab.gov /etc/hosts >/tmp/hosts
  echo "$IPADDR $HOSTNAME http.apl-test.cite.fpki-lab.gov ocsp.apl-test.cite.fpki-lab.gov ocspExpired.apl-test.cite.fpki-lab.gov ocspInvalidSig.apl-test.cite.fpki-lab.gov ocspRevoked.apl-test.cite.fpki-lab.gov ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov ocsp-pivi.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  /bin/mv /tmp/hosts /etc/hosts
fi

# Firewall:

systemctl status firewalld.service >/dev/null 2>&1
if [ $? -ne 0 ]; then
  yum install firewalld -y
  systemctl start firewalld.service
fi

yum install iptables-services -y

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --permanent --zone=trusted --add-interface=lo
firewall-cmd --permanent --zone=trusted --add-port=2560/tcp
firewall-cmd --permanent --zone=trusted --add-port=2561/tcp
firewall-cmd --permanent --zone=trusted --add-port=2562/tcp
firewall-cmd --permanent --zone=trusted --add-port=2563/tcp
firewall-cmd --permanent --zone=trusted --add-port=2564/tcp
firewall-cmd --permanent --zone=trusted --add-port=2565/tcp
firewall-cmd --reload

# Apache2:

yum install httpd -y

cd /var/www/ || (echo "Failed to access /var/www"; exit 1)
for D in \
  ocsp.apl-test.cite.fpki-lab.gov/logs \
  ocspExpired.apl-test.cite.fpki-lab.gov/logs \
  ocspRevoked.apl-test.cite.fpki-lab.gov/logs \
  ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov/logs \
  ocspInvalidSig.apl-test.cite.fpki-lab.gov/logs \
  ocsp-pivi.apl-test.cite.fpki-lab.gov/logs
do
    mkdir -p $D
    chmod 755 $D
    chmod 755 $(dirname $D)
    semanage fcontext -a -t httpd_sys_rw_content_t $D
    restorecon -v $D
done
setsebool -P httpd_unified 1

if [ $CRLHOST -eq 1 ]; then
  mkdir -p http.apl-test.cite.fpki-lab.gov
  mkdir -p http.apl-test.cite.fpki-lab.gov/aia
  mkdir -p http.apl-test.cite.fpki-lab.gov/sia
  mkdir -p http.apl-test.cite.fpki-lab.gov/crls
  mkdir -p http.apl-test.cite.fpki-lab.gov/logs
  pushd http.apl-test.cite.fpki-lab.gov >/dev/null 2>&1
    if [ -f $CWD/aiacrlssia.tar ]; then
      tar xv --no-same-owner --no-same-permissions -f $CWD/aiacrlssia.tar
    fi
  popd >/dev/null 2>&1
fi

chmod -R 755 .

# SELinux:

semanage port -a -t http_port_t -p tcp 2560
semanage port -a -t http_port_t -p tcp 2561
semanage port -a -t http_port_t -p tcp 2562
semanage port -a -t http_port_t -p tcp 2563
semanage port -a -t http_port_t -p tcp 2564
semanage port -a -t http_port_t -p tcp 2565

# Scripts to install Apache virtual hosts

cd /etc/httpd
mkdir sites-available
mkdir sites-enabled

cd sites-available

if [ $CRLHOST -eq 1 ]; then
  cat << %% >http.apl-test.cite.fpki-lab.gov.conf
<VirtualHost http.apl-test.cite.fpki-lab.gov:80>
  ServerName http.apl-test.cite.fpki-lab.gov
  DocumentRoot /var/www/http.apl-test.cite.fpki-lab.gov
  ErrorLog /var/www/http.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/http.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%
fi

cat << %% >ocsp.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocsp.apl-test.cite.fpki-lab.gov:80>
  ServerName ocsp.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2560/ [P]
  ErrorLog /var/www/ocsp.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocsp.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%

cat << %% >ocspExpired.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspExpired.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspExpired.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2561/ [P]
  ErrorLog /var/www/ocspExpired.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspExpired.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%

cat << %% >ocspInvalidSig.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspInvalidSig.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspInvalidSig.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2562/ [P]
  ErrorLog /var/www/ocspInvalidSig.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspInvalidSig.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%

cat << %% >ocspRevoked.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspRevoked.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspRevoked.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2563/ [P]
  ErrorLog /var/www/ocspRevoked.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspRevoked.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%

cat << %% >ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2564/ [P]
  ErrorLog /var/www/ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%

cat << %% >ocsp-pivi.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocsp-pivi.apl-test.cite.fpki-lab.gov:80>
  ServerName ocsp-pivi.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2565/ [P]
  ErrorLog /var/www/ocsp-pivi.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocsp-pivi.apl-test.cite.fpki-lab.gov/logs/requests.log combined
</VirtualHost>
%%

cd ../sites-enabled

for F in $(ls /etc/httpd/sites-available/*.conf); do ln -s $F .; done

# Edit main httpd.conf file

# Edit /etc/httpd/conf/httpd.conf
# Change #ServerName to:
#     http.apl-test.cite.fpki-lab.gov
# Add to end: 
#     IncludeOptional sites-enabled/*.conf

egrep "^#ServerName|^# ServerName" /etc/httpd/conf/httpd.conf >/dev/null 2>&1
if [ $? -eq 0 ]; then
  /bin/cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.$$
  cat /etc/httpd/conf/httpd.conf | sed 's/#ServerName.*$/ServerName '$(hostname)':80/g' >/tmp/httpd.conf
fi
grep "IncludeOptional sites-enabled/*.conf" /tmp/httpd.conf >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "IncludeOptional sites-enabled/*.conf" >>/tmp/httpd.conf
  /bin/mv /tmp/httpd.conf /etc/httpd/conf/httpd.conf
fi

# Apache should start up.

systemctl start httpd.service
systemctl status httpd.service
echo -n "Press <RETURN> to continue or <CTL-Z> to grab a shell: "
read ans

# OSCP

# Create ocspd service daemon

mkdir -p /usr/local/bin
chmod 755 /usr/local/bin

cat << %% >/usr/local/bin/ocspd
#!/bin/bash
#vim: set ts=2 nowwrap nohlsearh

# This is minimalist script to start/stop OCSP responder listeners for
# each of the types of response signatures we want to respond with.

CADIR=/etc/pki/CA

mkdir -p /var/run/ocsp
rm -f /var/run/ocsp/*

# Start listeners

# ocsp.apl-test.cite.fpki-lab.gov -> http://localhost:2560
(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/index.txt \\
  -port 2560 \\
  -rsigner \$CADIR/ocsp.crt \\
  -rkey \$CADIR/ocsp.key \\
  -CA \$CADIR/PIV_Signing_CA.crt \\
  -text \\
  -out /var/log/ocsp-log.txt >>/var/log/ocsp-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 1 2 15
  wait
  sleep 60
done
) &
echo \$! >/var/run/ocsp/ocsp.pid

# ocspExpired.apl-test.cite.fpki-lab.gov -> http://localhost:2561

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/index.txt \\
  -port 2561 \\
  -rsigner \$CADIR/ocspExpired.crt \\
  -rkey \$CADIR/ocspExpired.key \\
  -CA \$CADIR/PIV_Signing_CA.crt \\
  -text \\
  -out /var/log/ocspExpired-log.txt >>/var/log/ocspExpired-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 15
  wait
  sleep 60
done
) &
echo \$! >/var/run/ocsp/ocspExpired.pid

# ocspInvalidSig.apl-test.cite.fpki-lab.gov -> http://localhost:2562

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/index.txt \\
  -port 2562 \\
  -rsigner \$CADIR/ocspInvalidSig.crt \\
  -rkey \$CADIR/ocspInvalidSig.key \\
  -CA \$CADIR/PIV_Signing_CA.crt \\
  -text \\
  -out /var/log/ocspInvalidSig-log.txt >>/var/log/ocspInvalidSig-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocspInvalidSig.pid

# ocspRevoked.apl-test.cite.fpki-lab.gov ->  http://localhost:2563

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/index.txt \\
  -port 2563 \\
  -rsigner \$CADIR/ocspRevoked.crt \\
  -rkey \$CADIR/ocspRevoked.key \\
  -CA \$CADIR/PIV_Signing_CA.crt \\
  -text \\
  -out /var/log/ocspRevoked-log.txt >>/var/log/ocspRevoked-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocspRevoked.pid

# ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov -> http://localhost:2564

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/index.txt \\
  -port 2564 \\
  -rsigner \$CADIR/ocspNocheckNotPresent.crt \\
  -rkey \$CADIR/ocspNocheckNotPresent.key \\
  -CA \$CADIR/PIV_Signing_CA.crt \\
  -text \\
  -out /var/log/ocspNocheckNotPresent-log.txt >>/var/log/ocspNocheckNotPresent-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocspNocheckNotPresent.pid

# ocsp-pivi.apl-test.cite.fpki-lab.gov -> http://localhost:2565

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/index.txt \\
  -port 2565 \\
  -rsigner \$CADIR/ocsp-pivi.crt \\
  -rkey \$CADIR/ocsp-pivi.key \\
  -CA \$CADIR/PIV-I_Signing_CA.crt \\
  -text \\
  -out /var/log/ocsp-pivi-log.txt >>/var/log/ocsp-pivi-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocsp-pivi.pid

sleep infinity
%%
chmod 755 /usr/local/bin/ocspd

# Set up systemd file
cd /usr/lib/systemd/system

cat << %% >ocspd.service
[Unit]
Description=ocspd Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/ocspd
Restart=on-abort
ExecStop=/bin/kill -TERM "\`cat /var/run/ocsp/*.pid\`"

[Install]
WantedBy=multi-user.target
%%

cd /etc/systemd/system/multi-user.target.wants
ln -s /usr/lib/systemd/system/ocspd.service .
systemctl daemon-reload
systemctl start ocspd.service
systemctl status ocspd.service
