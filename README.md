# Simple Docker Swarm Example

This is an an example to get a 2 node with manager Docker Swarm up and running quickly, using Vagrant to fire up the necessary VMs, TLS to secure the connections to the Docker engine instances, and the Docker provided service discovery backend for test purposes

## Using

1. Generate certs as per the instructions in [ssl/README.md](../blob/master/ssl/README.md)
1. Start up and provision the VMs:
⋅⋅1. [Swarm Manager](../blob/master/manager/README.md)
⋅⋅1. [Swarm Node 1](../blob/master/node1/README.md)
⋅⋅1. [Swarm Node 2](../blob/master/node2/README.md)