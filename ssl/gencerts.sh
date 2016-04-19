#!/bin/bash

ssl_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ca_dir="${ssl_dir}/ca"
cwd=$(pwd) 

node=$1
ip=$2

if [ -z "$node" -o -z "$ip" ]; then
	>&2 echo "Usage:"
	>&2 echo "    gencerts.sh NODE IP"
	exit 1
fi

if ! [[ "$node" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
	>&2 echo "Invalid node format, must contain start with a-z and contain only a-z, 0-9, '-' and '_'"
	exit 1
fi

if ! [[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	>&2 echo "Valid IP address required '${ip}'"
	exit 1
fi

#echo Generating $node

cd $ssl_dir
if [ ! -d "$ssl_dir/$node" ]; then
	mkdir -p "$ssl_dir/$node"
fi
cd "$ssl_dir/$node"

cnf=$(</etc/ssl/openssl.cnf)
cat <<EOF > $node.cnf
$cnf
[req]
req_extensions = v3_req

[ v3_req ]

# Extensions to add to a certificate request

basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = ${ip}
EOF

cp ${ca_dir}/ca.pem .
echo Generating private key for ${node}
openssl genrsa -out key.pem 4096
echo Generating CSR for ${node}
openssl req -subj "/CN=${node}" -new -key key.pem \
    -config  ${node}.cnf \
	-out ${node}.csr
#	-config <(cat /etc/ssl/openssl.cnf \
#        <(printf "[SAN]\nsubjectAltName=IP:${ip}\n")) \
echo Signing cert for ${node}
openssl x509 -req -days 1825 \
	-in ${node}.csr \
	-CA ${ca_dir}/ca.pem -CAkey ${ca_dir}/ca-priv-key.pem -CAcreateserial \
	-out cert.pem \
	-extensions v3_req \
	-extfile ${node}.cnf
openssl rsa -in key.pem -out key.pem
rm ${node}.csr ${node}.cnf

cd $cwd