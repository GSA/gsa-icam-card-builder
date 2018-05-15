#!/bin/bash
#
# vim: set ts=2 nowrap nohlsearch
#
# Copy this file to the directory on the VM where you've copied the
# tar file, responder-certs.tar.  Then run it by typing "./install-responder.sh"

# Usage: -d option will just install data

trap 'echo -e "\x0a**** Caught keyboard signaal *****"; exit 2' 2 3 15

timer() {
  SECS=120
  while [ $SECS -gt 0 ]; do
		if [ $SECS -ge 100 ]; then
		  echo -n "$SECS seconds."; echo -n $'\b\b\b\b\b\b\b\b\b\b\b\b'
		elif [ $SECS -ge 10 ]; then
		  echo -n "$SECS seconds."; echo -n $'\b\b\b\b\b\b\b\b\b\b\b'
		else
		  echo -n "$SECS seconds."; echo -n $'\b\b\b\b\b\b\b\b\b\b'
		fi
		sleep 1
		SECS=$(expr $SECS - 1)
  done
}

debug_output()
{
	export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
	VERSION=$(/bin/bash --version | grep ", version" | sed 's/^.*version //g; s/^\(...\).*$/\1/g')
	MAJ=$(expr $VERSION : "^\(.\).*$")
	MIN=$(expr $VERSION : "^..\(.\).*$")
	if [ $MAJ -ge 4 -a $MIN -ge 1 ]; then
		exec 10>|"$1"
		BASH_XTRACEFD=10
		set -x
	else
		exec 2>|"$1"
		set -x
	fi
}

## Start ##

debug_output /tmp/$(basename $0 .sh).log

if [ $# -eq 1 -a x$1 == x"-d" ]; then 
	echo "Certificates and revocation data update."
	DATAONLY=1
else
	DATAONLY=0
fi

OS=centos
HTTPD=httpd
CONF1=/etc/$HTTPD/conf/$HTTPD.conf
INSTALLER=yum
IPTABLES=iptables-services
SYSTEMD_DIR=/usr/lib/systemd/system
PKIDIR=/etc/pki/CA

uname -a | grep -y Ubuntu >/dev/null 2>&1
RESULT=$?

# Change top-level HTTPD directory to apache2 and a few other things if on Ubuntu
if [ $RESULT -eq 0 ]; then 
	OS=ubuntu
	HTTPD=apache2
	CONF1=/etc/$HTTPD/sites-available/000-default.conf
	CONF2=/etc/$HTTPD/$HTTPD.conf
	PKIDIR=/etc/ssl/CA
fi

if [ x$OS == x"ubuntu" ]; then
	INSTALLER=apt-get
	IPTABLES=iptables
	SYSTEMD_DIR=/lib/systemd/system
fi

CRLHOST=1 # Change to zero if not hosting CRL/AIA/SIA on this VM

# Extract the .p12 and index files into the responder VM's CA directory
# directory

CWD=$(pwd)
mkdir -p $PKIDIR
cp responder-certs.tar $PKIDIR #/etc/pki/CA or /etc/ssl/CA
cd $PKIDIR
tar xv --no-same-owner --no-same-permissions -f responder-certs.tar

# Add the legacy certs to the Gen1-2 signing CA

cat legacy-index.txt >>piv-gen1-2-index.txt

# Then, run this script to create OCSP response signer keys and certs.  
# Split .p12 files from ICAM_CA_and_Signer files to be used in
# on the responder VM.

cat << %% >splitp12.sh
COUNT=0
for F in \\
  ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen1-2.p12 \\
  ICAM_Test_Card_PIV_OCSP_Valid_Signer_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Expired_Signer_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Not_Present_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Revoked_Signer_No_Check_Present_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Invalid_Sig_Signer_gen3.p12 \\
  ICAM_Test_Card_PIV-I_OCSP_Valid_Signer_gen3.p12 \\
  ICAM_Test_Card_PIV_OCSP_Valid_Signer_P384_gen3.p12
do
		COUNT=\$(expr \$COUNT + 1)
		case \$COUNT in
		1) N=ocsp ;;
		2) N=ocspGen3 ;;
		3) N=ocspExpired ;;
		4) N=ocspNocheckNotPresent ;;
		5) N=ocspRevoked ;;
		6) N=ocspInvalidSig ;;
		7) N=ocsp-pivi ;;
		8) N=ocspGen3p384 ;;
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

mv ICAM_Test_Card_PIV_Signing_CA_-_gold_gen1-2.crt PIV_Signing_CA_gen1-2.crt
mv ICAM_Test_Card_PIV_Signing_CA_-_gold_gen3.crt PIV_Signing_CA_gen3.crt
mv ICAM_Test_Card_PIV-I_Signing_CA_-_gold_gen3.crt PIV-I_Signing_CA_gen3.crt
mv ICAM_Test_Card_PIV_P-384_Signing_CA_-_gold_gen3.crt PIV_Signing_CA_gen3_p384.crt
# Uncomment these when we have responders for them
#mv ICAM_Test_Card_PIV_RSA_2048_Signing_CA_-_gold_gen3 PIV_Signing_CA_gen3_rsa_2048.crt
#mv ICAM_Test_Card_PIV_P-256_Signing_CA_gold_gen3.crt PIV_Signing_CA_gen3_p256.crt

systemctl stop ocspd.service
systemctl disable ocspd.service
systemctl stop $HTTPD.service

if [ $DATAONLY -eq 1 -a $CRLHOST -eq 1 ]; then
  if [ -d /var/www/http.apl-test.cite.fpki-lab.gov ]; then
		pushd /var/www/http.apl-test.cite.fpki-lab.gov >/dev/null 2>&1
		if [ -f $CWD/aiacrlsia.tar ]; then
		  tar xv --no-same-owner --no-same-permissions -f $CWD/aiacrlsia.tar
		fi
		popd >/dev/null 2>&1
  fi
  
  echo -n "Data has been updated. The serivces will restart in "; timer
  echo
  nohup systemctl start $HTTPD.service >/dev/null 2>&1
  nohup systemctl start ocspd.service >/dev/null 2>&1
  echo
  echo "The services have been restarted."
  echo "----------------------------------------------------------------------------------"
  sleep 2
  systemctl status $HTTPD.service
  systemctl status ocspd.service
  echo "----------------------------------------------------------------------------------"
  exit 0
fi

# General:

# Hosts file aliases. x.x.x.x is the NAT'd IP address of the box. The rest are aliases
# recognized by Apache2.

IPADDR=$(ifconfig -a | grep "inet " | head -n1 | awk '{ print $2 }')
IPADDR=$(ip addr show | grep "inet " | grep -v 127.0.0 | sed 's/^.*inet //g; s!/.*$!!')
HOSTNAME=$(hostname)

GC=0
grep $IPADDR /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep $HOSTNAME /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)

if [ $CRLHOST -eq 1 ]; then
  grep crl.apl-test.cite.fpki-lab.gov /etc/host >/dev/null 2>&1; GC=$(expr $? + $GC)
  grep http.apl-test.cite.fpki-lab.gov /etc/host >/dev/null 2>&1; GC=$(expr $? + $GC)
fi
grep -i ocsp.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocspGen3.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocspExpired.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocspInvalidSig.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1 >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocspRevoked.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocsp-pivi.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)
grep -i ocspGen3p384.apl-test.cite.fpki-lab.gov /etc/hosts >/dev/null 2>&1; GC=$(expr $? + $GC)

if [ $GC -gt 0 ]; then
  cp -p /etc/hosts /etc/hosts.$$
  grep -v lab.gov /etc/hosts >/tmp/hosts
  echo "$IPADDR $HOSTNAME" >>/tmp/hosts
  echo "$IPADDR crl.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR http.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocsp.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocspGen3.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocspExpired.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocspInvalidSig.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocspRevoked.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocsp-pivi.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  echo "$IPADDR ocspGen3p384.apl-test.cite.fpki-lab.gov" >>/tmp/hosts
  /bin/mv /tmp/hosts /etc/hosts
fi

# Firewall:

systemctl status firewalld.service >/dev/null 2>&1
if [ $? -ne 0 ]; then
  $INSTALLER install firewalld -y
  systemctl start firewalld.service
fi

$INSTALLER install $IPTABLES -y

firewall-cmd --permanent --zone=trusted --add-port=80/tcp
firewall-cmd --permanent --zone=trusted --add-interface=lo
firewall-cmd --permanent --zone=trusted --add-port=2560/tcp
firewall-cmd --permanent --zone=trusted --add-port=2561/tcp
firewall-cmd --permanent --zone=trusted --add-port=2562/tcp
firewall-cmd --permanent --zone=trusted --add-port=2563/tcp
firewall-cmd --permanent --zone=trusted --add-port=2564/tcp
firewall-cmd --permanent --zone=trusted --add-port=2565/tcp
firewall-cmd --permanent --zone=trusted --add-port=2566/tcp
firewall-cmd --permanent --zone=trusted --add-port=2567/tcp
firewall-cmd --reload

# $HTTP, openssl

$INSTALLER install $HTTPD -y

if [ x$OS == x"ubuntu" ]; then
	a2enmod rewrite allowmethods proxy proxy_http
fi

cd /var/www/ || (echo "Failed to access /var/www"; exit 1)
for D in \
	ocsp.apl-test.cite.fpki-lab.gov/logs \
	ocspGen3.apl-test.cite.fpki-lab.gov/logs \
	ocspExpired.apl-test.cite.fpki-lab.gov/logs \
	ocspRevoked.apl-test.cite.fpki-lab.gov/logs \
	ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov/logs \
	ocspInvalidSig.apl-test.cite.fpki-lab.gov/logs \
	ocsp-pivi.apl-test.cite.fpki-lab.gov/logs \
	ocspGen3p384.apl-test.cite.fpki-lab.gov/logs
do
	mkdir -p $D
	chmod 755 $D
	chmod 755 $(dirname $D)
if [ x$OS == x"centos" ]; then
	semanage fcontext -a -t httpd_sys_rw_content_t $D
	restorecon -v $D
fi
done

if [ x$OS == x"centos" ]; then setsebool -P httpd_unified 1; fi

if [ $CRLHOST -eq 1 ]; then
	mkdir -p crl.apl-test.cite.fpki-lab.gov
	mkdir -p crl.apl-test.cite.fpki-lab.gov/crls
	mkdir -p crl.apl-test.cite.fpki-lab.gov/logs
	mkdir -p http.apl-test.cite.fpki-lab.gov
	mkdir -p http.apl-test.cite.fpki-lab.gov/aia
	mkdir -p http.apl-test.cite.fpki-lab.gov/sia
	mkdir -p http.apl-test.cite.fpki-lab.gov/crls
	mkdir -p http.apl-test.cite.fpki-lab.gov/roots
	mkdir -p http.apl-test.cite.fpki-lab.gov/logs
	pushd http.apl-test.cite.fpki-lab.gov >/dev/null 2>&1
		if [ -f $CWD/aiacrlsia.tar ]; then
		  tar xv --no-same-owner --no-same-permissions -f $CWD/aiacrlsia.tar
			for D in aia crls sia roots; do
				chmod 644 $D/*
				chmod 755 $D
			done
		fi
  popd >/dev/null 2>&1
	cp -p http.apl-test.cite.fpki-lab.gov/crls/ICAMTestCardRootCA.crl crl.apl-test.cite.fpki-lab.gov/crls
fi

# Prevent indexing

cat << %% >http.apl-test.cite.fpki-lab.gov/robots.txt
User-agent: *
Disallow: /
%%

# SELinux:

if [ x$OS == x"centos" ]; then
	semanage port -a -t http_port_t -p tcp 2560
	semanage port -a -t http_port_t -p tcp 2561
	semanage port -a -t http_port_t -p tcp 2562
	semanage port -a -t http_port_t -p tcp 2563
	semanage port -a -t http_port_t -p tcp 2564
	semanage port -a -t http_port_t -p tcp 2565
	semanage port -a -t http_port_t -p tcp 2566
	semanage port -a -t http_port_t -p tcp 2567
fi

# Remove the default web page

# Scripts to install Apache virtual hosts

cd /etc/$HTTPD
rm -f conf.d/welcome.conf
mkdir -p sites-available
mkdir -p sites-enabled

cd sites-available

if [ $CRLHOST -eq 1 ]; then
  cat << %% >crl.apl-test.cite.fpki-lab.gov.conf
<VirtualHost crl.apl-test.cite.fpki-lab.gov:80>
  ServerName crl.apl-test.cite.fpki-lab.gov
  DocumentRoot /var/www/crl.apl-test.cite.fpki-lab.gov
  ErrorLog /var/www/crl.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/crl.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Directory "/var/www/crl.apl-test.cite.fpki-lab.gov">
    Options -Indexes
    AllowOverride none
  </Directory>
</VirtualHost>
%%

  cat << %% >http.apl-test.cite.fpki-lab.gov.conf
<VirtualHost http.apl-test.cite.fpki-lab.gov:80>
  ServerName http.apl-test.cite.fpki-lab.gov
  DocumentRoot /var/www/http.apl-test.cite.fpki-lab.gov
  <Directory "/var/www/http.apl-test.cite.fpki-lab.gov">
    Options +Indexes
    IndexIgnore logs
    AllowOverride all
  </Directory>
  IndexOptions FancyIndexing HTMLTable VersionSort NameWidth=210 DescriptionWidth=0
  LogLevel debug
  ErrorLog /var/www/http.apl-test.cite.fpki-lab.gov/logs/error_log
  CustomLog /var/www/http.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  TransferLog /var/www/http.apl-test.cite.fpki-lab.gov/logs/access_log
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
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocspGen3.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspGen3.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspGen3.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2561/ [P]
  ErrorLog /var/www/ocspGen3.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspGen3.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocspExpired.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspExpired.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspExpired.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2562/ [P]
  ErrorLog /var/www/ocspExpired.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspExpired.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocspInvalidSig.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspInvalidSig.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspInvalidSig.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2563/ [P]
  ErrorLog /var/www/ocspInvalidSig.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspInvalidSig.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocspRevoked.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspRevoked.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspRevoked.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2564/ [P]
  ErrorLog /var/www/ocspRevoked.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspRevoked.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2565/ [P]
  ErrorLog /var/www/ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocsp-pivi.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocsp-pivi.apl-test.cite.fpki-lab.gov:80>
  ServerName ocsp-pivi.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2566/ [P]
  ErrorLog /var/www/ocsp-pivi.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocsp-pivi.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cat << %% >ocspGen3p384.apl-test.cite.fpki-lab.gov.conf
<VirtualHost ocspGen3p384.apl-test.cite.fpki-lab.gov:80>
  ServerName ocspGen3p384.apl-test.cite.fpki-lab.gov
  DocumentRoot /dev/null
  RewriteEngine on
  RewriteCond %{CONTENT_TYPE} !^application/ocsp-request$
  RewriteRule ^/(.*) http://localhost:2567/ [P]
  ErrorLog /var/www/ocspGen3p384.apl-test.cite.fpki-lab.gov/logs/error.log
  CustomLog /var/www/ocspGen3p384.apl-test.cite.fpki-lab.gov/logs/requests.log combined
  <Location "/">
    AllowMethods POST
  </Location>
</VirtualHost>
%%

cd ../sites-enabled

for F in $(ls /etc/$HTTPD/sites-available/*.conf)
do
	if [ ! -L $(basename $F) ]; then
		ln -s $F .
	fi
done

# Edit main $HTTPD.conf file

echo "Editing $CONF1..."

# Edit $CONF1
# Change #ServerName to:
#		http.apl-test.cite.fpki-lab.gov
# Add to end: 
#		IncludeOptional sites-enabled/*.conf
# For Ubuntu, edit the main conf file

grep "^.*ServerName.*:80" $CONF1 >/dev/null 2>&1
if [ $? -eq 0 ]; then
	/bin/cp -p $CONF1 $CONF1.$$
	cat $CONF1 | sed 's!^.*#ServerName.*:80!ServerName http.apl-test.cite.fpki-lab.gov:80!g' >/tmp/$(basename $CONF1)
	if [ $? -eq 0 ]; then
		/bin/mv /tmp/$(basename $CONF1) $CONF1
	else
		echo "Failed to update ServerName"
	fi
fi
grep "^.*DocumentRoot.*/" $CONF1 >/dev/null 2>&1
if [ $? -eq 0 ]; then
	/bin/cp -p $CONF1 $CONF1.$$
	cat $CONF1 | sed 's!^.*DocumentRoot.*".*$!DocumentRoot /var/www/http.apl-test.cite.fpki-lab.gov!g' >/tmp/$(basename $CONF1)
	if [ $? -eq 0 ]; then
		/bin/mv /tmp/$(basename $CONF1) $CONF1
	else
		echo "Failed to update DocumentRoot"
	fi
fi

if [ z$HTTPD == z"httpd" ]; then # CentOS only
	grep "^.*IncludeOptional sites-enabled/" $CONF1 >/dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo "IncludeOptional sites-enabled/*.conf" >>$CONF1
	fi
fi

if [ z$OS == z"ubuntu" ]; then # Ubuntu only
	cp $CONF2 $CONF2.$$
	grep -v ServerName $CONF2 >/tmp/$(basename $CONF2)
	ed /tmp/$(basename $CONF2) << %%
/# Global configuration
a
#
# Added by install-responder.sh
#
ServerName http.apl-test.cite.fpki-lab.gov
#
.
w
q
%%

if [ $? -eq 0 ]; then cp -p /tmp/$(basename $CONF2) $CONF2; fi

fi

# Start up at boot

systemctl enable $HTTPD.service

# Apache should start up.

systemctl start $HTTPD.service
if [ $? -ne 0 ]; then
	echo "Failed to start $HTTPD service. Exiting."
	exit 1
fi

# OSCP

# Create ocspd service daemon

mkdir -p /usr/local/bin
chmod 755 /usr/local/bin

cat << %% >/usr/local/bin/ocspd
#!/bin/bash
#vim: set ts=2 nowrap nohlsearh

# This is minimalist script to start/stop OCSP responder listeners for
# each of the types of response signatures we want to respond with.

CADIR=$PKIDIR

mkdir -p /var/run/ocsp
rm -f /var/run/ocsp/*

# Start listeners

# ocsp.apl-test.cite.fpki-lab.gov -> http://localhost:2560
(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen1-2-index.txt \\
  -port 2560 \\
  -rsigner \$CADIR/ocsp.crt \\
  -rkey \$CADIR/ocsp.key \\
  -CA \$CADIR/PIV_Signing_CA_gen1-2.crt \\
  -text \\
  -out /var/log/ocsp-log.txt >>/var/log/ocsp-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
) &
echo \$! >/var/run/ocsp/ocsp.pid

# ocspGen3.apl-test.cite.fpki-lab.gov -> http://localhost:2561
(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen3-index.txt \\
  -port 2561 \\
  -rsigner \$CADIR/ocspGen3.crt \\
  -rkey \$CADIR/ocspGen3.key \\
  -CA \$CADIR/PIV_Signing_CA_gen3.crt \\
  -text \\
  -out /var/log/ocspGen3-log.txt >>/var/log/ocspGen3-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
) &
echo \$! >/var/run/ocsp/ocspGen3.pid

# ocspExpired.apl-test.cite.fpki-lab.gov -> http://localhost:2562

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen3-index.txt \\
  -port 2562 \\
  -rsigner \$CADIR/ocspExpired.crt \\
  -rkey \$CADIR/ocspExpired.key \\
  -CA \$CADIR/PIV_Signing_CA_gen3.crt \\
  -text \\
  -out /var/log/ocspExpired-log.txt >>/var/log/ocspExpired-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
) &
echo \$! >/var/run/ocsp/ocspExpired.pid

# ocspInvalidSig.apl-test.cite.fpki-lab.gov -> http://localhost:2563

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen3-index.txt \\
  -port 2563 \\
  -rsigner \$CADIR/ocspInvalidSig.crt \\
  -rkey \$CADIR/ocspInvalidSig.key \\
  -CA \$CADIR/PIV_Signing_CA_gen3.crt \\
  -text \\
  -out /var/log/ocspInvalidSig-log.txt >>/var/log/ocspInvalidSig-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocspInvalidSig.pid

# ocspRevoked.apl-test.cite.fpki-lab.gov ->  http://localhost:2564

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen3-index.txt \\
  -port 2564 \\
  -rsigner \$CADIR/ocspRevoked.crt \\
  -rkey \$CADIR/ocspRevoked.key \\
  -CA \$CADIR/PIV_Signing_CA_gen3.crt \\
  -text \\
  -out /var/log/ocspRevoked-log.txt >>/var/log/ocspRevoked-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocspRevoked.pid

# ocspNocheckNotPresent.apl-test.cite.fpki-lab.gov -> http://localhost:2565

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen3-index.txt \\
  -port 2565 \\
  -rsigner \$CADIR/ocspNocheckNotPresent.crt \\
  -rkey \$CADIR/ocspNocheckNotPresent.key \\
  -CA \$CADIR/PIV_Signing_CA_gen3.crt \\
  -text \\
  -out /var/log/ocspNocheckNotPresent-log.txt >>/var/log/ocspNocheckNotPresent-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocspNocheckNotPresent.pid

# ocsp-pivi.apl-test.cite.fpki-lab.gov -> http://localhost:2566

(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/pivi-gen3-index.txt \\
  -port 2566 \\
  -rsigner \$CADIR/ocsp-pivi.crt \\
  -rkey \$CADIR/ocsp-pivi.key \\
  -CA \$CADIR/PIV-I_Signing_CA_gen3.crt \\
  -text \\
  -out /var/log/ocsp-pivi-log.txt >>/var/log/ocsp-pivi-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
)&
echo \$! >/var/run/ocsp/ocsp-pivi.pid

# ocspGen3p384.apl-test.cite.fpki-lab.gov -> http://localhost:2567
(\\
while true
do
  openssl ocsp \\
  -index \$CADIR/piv-gen3-p384-index.txt \\
  -port 2567 \\
  -rsigner \$CADIR/ocspGen3p384.crt \\
  -rkey \$CADIR/ocspGen3p384.key \\
  -CA \$CADIR/PIV_Signing_CA_gen3_p384.crt \\
  -text \\
  -out /var/log/ocspGen3p384-log.txt >>/var/log/ocspGen3p384-output 2>&1 &
  PID=\$!
  trap 'kill \$!; exit' 1 2 3 15
  wait
  sleep 60
done
) &
echo \$! >/var/run/ocsp/ocspGen3p384.pid

sleep infinity
%%
chmod 755 /usr/local/bin/ocspd

# Set up systemd file
cd $SYSTEMD_DIR

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

systemctl daemon-reload
systemctl enable ocspd.service
systemctl start ocspd.service
if [ $? -ne 0 ]; then
	echo "Failed to start ocspd service. Exiting."
	exit 1
fi

systemctl status $HTTPD >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "$HTTPD service successfully started"
else
	echo "$HTTPD service failed to start"
fi

systemctl status ocspd >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "ocspd service successfully started"
else
	echo "ocspd service failed to start"
fi

exit 0
