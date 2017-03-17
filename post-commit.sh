#!/bin/sh

while ! git push origin $(git rev-parse --abbrev-ref HEAD)
do
    sleep 10s
done