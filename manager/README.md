# Swarm Manager node

Bring up the swarm manager

```bash
cd manager
vagrant up
```

Alternatively, if already up, (re)provision it:

```bash
vagrant provision
```

## Launch Swarm Manager

Launch the manager as follows (assumes node is provisioned with certs and up):

```bash
vagrant ssh
#
# On VM command line (replace CLUSTER_ID with actual cluster ID from 'swarm create')
#
docker run --name=swarm_manager -d \
    -p 3376:3376 \
    -v /etc/docker/certs:/certs:ro \
    swarm manage \
        --tlsverify \
        --tlscacert=/certs/ca.pem \
        --tlscert=/certs/cert.pem \
        --tlskey=/certs/key.pem \
        --host=0.0.0.0:3376 \
        token://CLUSTER_ID
```
