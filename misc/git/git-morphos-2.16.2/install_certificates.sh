#!/bin/sh

wget https://curl.haxx.se/ca/cacert.pem

awk 'BEGIN {c=0} v{v=v"\n"$0} /----BEGIN/{v=$0;c++}/----END/&&v { print v > "cert." c ".pem"; v=x}' cacert.pem
for file in *.pem; do mv "$file" "$(/gg/ssl/bin/openssl x509 -hash -noout -in "$file")".0; done

rm -rf cacert.pem
