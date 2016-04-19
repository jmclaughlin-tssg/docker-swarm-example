# Generating Certs

**IMPORTANT!!!**

The ca/ directory contains a sample CA to generate the certs. *DON'T* use this to secure anything other than this example and especially anything public

## Generate The Node Certs

Use the gencerts.sh script in this directory to generate certs for the nodes as follows

```bash
./gencerts.sh swarm 192.168.33.10 # Manager node
./gencerts.sh node1 192.168.33.11 # Swarm node 1
./gencerts.sh node2 192.168.33.12 # Swarm node 2
```

Copy the certs to the appropriate place in the Ansible tree:

```bash
cp swarm/*.pem ../manager/roles/docker-config/files/certs
cp node1/*.pem ../node1/roles/docker-config/files/certs
cp node2/*.pem ../node2/roles/docker-config/files/certs
```

Generate a cert for the client as follows, replacing CLIENT_IP_ADDR with the actual IP address of the client

```bash
$ gencerts.sh swarm CLIENT_IP_ADDR
```
Leave these in the client directory and reference them using the Docker command line when invoking