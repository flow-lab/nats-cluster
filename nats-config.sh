#!/bin/bash -e

# NATS_USERNAME must be set in env
if [ -z "${NATS_USERNAME}" ]
then
      printf "Error: NATS_USERNAME env required\n";
      exit 1;
fi

# NATS_PASSWORD must be set in env
if [ -z "${NATS_PASSWORD}" ]
then
      printf "Error: NATS_PASSWORD env required\n";
      exit 1;
fi

# NATS_ADMIN_USER must be set in env
if [ -z "${NATS_ADMIN_USER}" ]
then
      printf "Error: NATS_ADMIN_USER env required\n";
      exit 1;
fi

# NATS_ADMIN_PASSWORD must be set in env
if [ -z "${NATS_ADMIN_PASSWORD}" ]
then
      printf "Error: NATS_ADMIN_PASSWORD env required\n";
      exit 1;
fi

# create a stream
nats stream add EVENTS --subjects "EVENTS.*" --ack --max-msgs=-1 --max-bytes=-1 --max-age=1M --storage file --retention workq --max-msg-size=-1 --discard=old --replicas 3 --dupe-window 2m --max-msgs-per-subject=-1 --no-allow-rollup --no-deny-delete --no-deny-purge --server=nats --user=${NATS_USERNAME} --password=${NATS_PASSWORD}

# create a consumer
nats consumer add EVENTS CONSUMER --filter EVENTS.received --ack explicit --pull --deliver all --sample 100 --replay instant --max-pending=0 --max-deliver=-1 --no-headers-only --backoff=linear --backoff-max=1h --backoff-min=30s --backoff-steps=20 --server=nats --user=${NATS_USERNAME} --password=${NATS_PASSWORD}

# print streams config
nats server report jetstream --server=nats --user=${NATS_ADMIN_USER} --password=${NATS_ADMIN_PASSWORD}