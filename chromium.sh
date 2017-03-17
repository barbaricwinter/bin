#!/bin/sh

docker run \
    --privileged \
    --interactive \
    --tty \
    --rm \
    --shm-size=256m \
    --env DISPLAY=unix$DISPLAY \
    --env TARGETUID=$HOST_UID \
    --env XDG_RUNTIME_DIR=/run/user/$HOST_UID \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume /run/user/$HOST_UID/pulse:/run/user/$HOST_UID/pulse \
    --volume /etc/machine-id:/etc/machine-id \
    --volume /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
    --volume /var/lib/dbus:/var/lib/dbus \
    --volume /tmp:/tmp \
    --volume ~/.config/pulse:/home/chromium/.config/pulse \
    --volume 7f35d5a45e5a7a28e0a3ebd5ab0da654854b7487e6bf4348bfa858d821b9052a:/data \
    --volume /dev/video0:/dev/video0:ro \
    urgemerge/chromium-pulseaudio:latest