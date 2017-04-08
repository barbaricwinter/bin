#!/bin/sh
# This file is part of bin.
#
#    bin is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    bin is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with bin.  If not, see <http://www.gnu.org/licenses/>.

while [ "${#}" -gt 0 ]
do
    case ${1} in
        --certs)
            CERTS=${2} &&
                shift &&
                shift
        ;;
        --chrome-home)
            CHROME_HOME=${2} &&
                shift &&
                shift
        ;;
        *)
            echo Unknown Options ${1} &&
                exit 64
        ;;
    esac
done &&
    ( [ ! -z "${CERTS}" ] || (echo MISSING CERTS VOLUME && exit 65)) &&
    ( [ ! -z "${CHROME_HOME}" ] || (echo MISSING CHROME HOME VOLUME && exit 65)) &&
    docker \
        run \
        --interactive \
        --rm \
        --volume ${CERTS}:/certs:ro \
        --volume ${CHROME_HOME}:/home/user \
        --env DISPLAY=$DISPLAY \
        --volume /tmp/.X11-unix:/tmp/.X11-unix \
        --device /dev/dri/card0 \
        --volume /run/user/$UID/pulse/native:/tmp/pulse \
        docker.io/sassmann/debian-chromium
    docker \
        run \
        --interactive \
        --volume ${CHROME_HOME}:/volume \
        --workdir /volume \
        --entrypoint chown \
        barbaricwinter/chown:0.0.0 \
        -R user:user .
