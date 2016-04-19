# Swarm Node #1

Bring up a Swarm node

```bash
vagrant up
```

Alternatively, if already up, (re)provision it:

```bash
vagrant provision
```

## Join the swarm

Join the swarm as follows (assumes node is provisioned with certs and up): 

```bash
vagrant ssh
#
# On VM command line (replace CLUSTER_ID with actual cluster ID from 'swarm create')
#
docker run -d --name swarm_node1 -t \
    swarm join \
        --addr=192.168.33.11:2376 \
        token://CLUSTER_ID
```
