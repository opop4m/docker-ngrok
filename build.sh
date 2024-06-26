#!/bin/sh
set -e

if [ "${DOMAIN}" == "**None**" ]; then
    echo "Please set DOMAIN"
    exit 1
fi

cd ${MY_FILES}
if [ ! -f "${MY_FILES}/ca.crt" ]; then
    openssl genrsa -out ca.key 2048
    openssl req -new -x509 -nodes -key ca.key -days 10000 -subj "/CN=${DOMAIN}" -out ca.crt

    openssl req -new -sha256 \
    -key ca.key \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=UnitedStack/OU=Devops/CN=${DOMAIN}" \
    -reqexts SAN \
    -config <(cat /etc/pki/tls/openssl.cnf \
        <(printf "[SAN]\nsubjectAltName=DNS:${DOMAIN}")) \
    -out device.csr

    openssl x509 -req -days 365000 \
    -in device.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
    -extfile <(printf "subjectAltName=DNS:${DOMAIN}") \
    -out device.crt
    # openssl genrsa -out device.key 2048
    # openssl req -new -key device.key -subj "/CN=${DOMAIN}" -addext "subjectAltName = DNS:${DOMAIN}" -out device.csr
    # openssl x509 -req -in device.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out device.crt
fi

# cp -r ca.crt /ngrok/assets/client/tls/ngrokroot.crt
cp -r ${MY_FILES}/ca.crt /ngrok/internal/client/assets/tls/ngroxroot.crt
cp ${MY_FILES}/device.crt /ngrok/internal/server/assets/tls/snakeoil.crt
cp ${MY_FILES}/device.key /ngrok/internal/server/assets/tls/snakeoil.key

cd /ngrok

# go env -w GO111MODULE=off
git config --global http.sslverify false

make release-server
# GOOS=linux GOARCH=386 make release-client ARG_CLIENT_RELEASE=bin/ngrox_386
# GOOS=linux GOARCH=amd64 make release-client ARG_CLIENT_RELEASE=bin/ngrox_amd64
# GOOS=windows GOARCH=amd64 make release-client ARG_CLIENT_RELEASE=bin/ngrox_amd64_win
# GOOS=darwin GOARCH=amd64 make release-client ARG_CLIENT_RELEASE=bin/ngrox_amd64_mac
GOOS=darwin GOARCH=arm64 make release-client ARG_CLIENT_RELEASE=bin/ngrox_arm64_mac

# GOOS=linux GOARCH=arm make release-client ARG_CLIENT_RELEASE=bin/ngrox_386
# GOOS=windows GOARCH=386 make release-client ARG_CLIENT_RELEASE=bin/ngrox_386


cp -r /ngrok/bin ${MY_FILES}/bin

echo "build ok !"
