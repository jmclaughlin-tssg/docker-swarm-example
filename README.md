# Simple Docker Swarm Example

This is an an example to get a 2 node with manager Docker Swarm up and running quickly, using Vagrant to fire up the necessary VMs (provisioned by Ansible), self signed TLS certs - using a provided CA - to secure the connections to the Docker engine instances, and the Docker provided service discovery backend for test purposes

This example assumes running on Ubuntu 14.04 - modifications would be necessary to run on Windows or OS-X

It could of course be modified to automate a lot more stuff, but hiding the implementation details completely would miss the point :-)

## Prerequisites

* Ubuntu 14.04 host OS
* Vagrant
* Docker Engine installed on host (1.10 or later)

## Creating A Swarm

For test purposes, we'll use the Docker public discovery backend. Create a test cluster as follows (doesn't matter where this is run) :

```bash
docker run --rm swarm create
```

**Output (similar):**

```
:
Status: Downloaded newer image for swarm:latest
0ac50ef75c9739f5bfeeaf00503d4e6e
```

Save the hex key on the last line of the output. This is the CLUSTER_ID that will be necessary for the rest of the example

## Using

1. Generate certs as per the instructions in [ssl/README.md](../blob/master/ssl/README.md)
1. Start up and provision the VMs:
  1. [Swarm Manager](../blob/master/manager/README.md)
  1. [Swarm Node 1](../blob/master/node1/README.md)
  1. [Swarm Node 2](../blob/master/node2/README.md)

## Testing

With nodes up and running, list the nodes as follows (on client - i.e. the host)

```bash
docker run --rm swarm list token://CLUSTER_ID
```

**Output:**

```
192.168.33.12:2376
192.168.33.11:2376
```

Get info on the Swarm (again, run on client - assumes you're in the top level directory of repo)

```bash
docker \
    --tlsverify \
    --tlscacert=`pwd`/ssl/client/ca.pem \
    --tlscert=`pwd`/ssl/client/cert.pem \
    --tlskey=`pwd`/ssl/client/key.pem \
    -H 192.168.33.10:3376 \
    info
```
**Output (should be similar):**

```
Containers: 2
Images: 2
Role: primary
Strategy: spread
Filters: health, port, dependency, affinity, constraint
Nodes: 2
 node1: 192.168.33.11:2376
  └ Status: Healthy
  └ Containers: 1
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 2.053 GiB
  └ Labels: executiondriver=, kernelversion=3.13.0-68-generic, name=node1, operatingsystem=Ubuntu 14.04.3 LTS, storagedriver=devicemapper
  └ Error: (none)
  └ UpdatedAt: 2016-04-18T10:51:21Z
  └ ServerVersion: 1.11.0
 node2: 192.168.33.12:2376
  └ Status: Healthy
  └ Containers: 1
  └ Reserved CPUs: 0 / 2
  └ Reserved Memory: 0 B / 2.053 GiB
  └ Labels: executiondriver=, kernelversion=3.13.0-68-generic, name=node2, operatingsystem=Ubuntu 14.04.3 LTS, storagedriver=devicemapper
  └ Error: (none)
  └ UpdatedAt: 2016-04-18T10:51:26Z
  └ ServerVersion: 1.11.0
Kernel Version: 3.13.0-68-generic
Operating System: linux
CPUs: 4
Total Memory: 4.105 GiB
Name: 9f785da5aac6
Edit
```

## Running Images

Run the 'hello-world' image on the swarm as follows (again top level directory of repo):

```bash
docker \
    --tlsverify \
    --tlscacert=`pwd`/ssl/client/ca.pem \
    --tlscert=`pwd`/ssl/client/cert.pem \
    --tlskey=`pwd`/ssl/client/key.pem \
    -H 192.168.33.10:3376 \
    run hello-world
```

**Output:**

```
Hello from Docker.
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/userguide/
```

To verify it ran

```bash
docker --tlsverify \
    --tlscacert=`pwd`/ssl/client/ca.pem \
    --tlscert=`pwd`/ssl/client/cert.pem \
    --tlskey=`pwd`/ssl/client/key.pem \
    -H 192.168.33.10:3376 \
    ps -a
```

**Output (similar):**

```
CONTAINER ID        IMAGE               COMMAND                CREATED              STATUS                          PORTS               NAMES
33910106c611        hello-world         "/hello"               About a minute ago   Exited (0) About a minute ago                       node1/tiny_roentgen        
f018d1257230        swarm               "/swarm join --addr=   3 minutes ago        Up 3 minutes                    2375/tcp            node2/pensive_jepsen       
b2107eef97e9        swarm               "/swarm join --addr=   4 minutes ago        Up 4 minutes                    2375/tcp            node1/backstabbing_jones   
```