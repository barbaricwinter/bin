#!/bin/sh

docker \
    run \
    --interactive \
    --tty \
    --rm \
    --volume secrets:/secrets:ro \
    wildwarehouse/passmaster:1.0.3