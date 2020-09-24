#!/bin/bash

set -e
mkdir -p /tmp/certs
echo "${MAVEN_SETTINGS}" | base64 -d >/tmp/settings.xml

echo "${CERTIFICATE_P12}" | base64 -d > /tmp/certs/certificate.p12
echo "${ROOT_CA}" | base64 -d > /tmp/certs/rootca.crt

keytool -import -trustcacerts -keystore -cacerts -storepass changeit -noprompt -file /tmp/certs/rootca.crt -alias ts

cp /tmp/certs/rootca.crt /usr/local/share/ca-certificates/rootca.crt
update-ca-certificates

# Needed to be created to store cache of maven
mkdir -p /root/.m2/repository

export MAVEN_OPTS="-s /tmp/settings.xml -Djavax.net.ssl.keyStore=/tmp/certs/certificate.p12 -Djavax.net.ssl.keyStoreType=pkcs12 -Djavax.net.ssl.keyStorePassword=${KEYSTORE_PASSWORD}"
export MAVEN_HOME=${GITHUB_WORKSPACE}/.m2
echo "${MAVEN_SETTINGS}" | base64 -d > $MAVEN_HOME/settings.xml

IFS=$'\n'

for field in $1; do
    echo "Executing: $field"
    eval $field
done 
