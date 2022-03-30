# Nats cluster

Docker compose with nats cluster and jetstream with Work Queue mode.

Operations
```shell
# run
docker compose up -d

# show logs and follow
docker compose logs --follow

# stop
docker compose down

# enter the setup container
docker exec -it nats-cluster-nats-setup-1 /bin/bash
# show consumer info for stream EVENTS and CONSUMER (see ./nats-bashrc file)
nci
```

### Links
- https://docs.nats.io/nats-concepts/jetstream