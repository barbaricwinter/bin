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
        --title)
            TITLE=${2} &&
            shift &&
            shift
        ;;
        --dot-ssh)
            DOT_SSH=${2} &&
            shift &&
            shift
        ;;
        --gitlab-private-token)
            GITLAB_PRIVATE_TOKEN=${2} &&
            shift &&
            shift
    esac
done &&
    [ ! -z "${TITLE}" ] &&
    [ ! -z "${DOT_SSH}" ] &&
    [ ! -z "${GITLAB_PRIVATE_TOKEN}" ] &&
    echo docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        alpine:3.4 \
        chmod 0700 . &&
   echo hi && exit 64
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        alpine:3.4 \
        chown 1000:1000 . &&
   echo hi2 && exit 64
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        --entrypoint ssh-keygen \
        tidyrailroad/openssh-client:0.0.0 \
        -f id_rsa -P "" -C "${TITLE}" &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        alpine:3.4 \
        chown 1000:1000 id_rsa &&
    echo hi1 && exit 64
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        alpine:3.4 \
        chown 1000:1000 id_rsa.pub &&
    (cat <<EOF
Host origin
HostName gitlab.363-283.io
User git
Port 2252
StrictHostKeyChecking no
IdentityFile ~/.ssh/id_rsa

Host upstream
HostName gitlab.363-283.io
User git
Port 2252
StrictHostKeyChecking no
IdentityFile ~/.ssh/id_rsa[
EOF
    )| docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        tidyrailroad/tee:0.0.0 \
        config &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        alpine:3.4 \
        chmod 0600 config &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        alpine:3.4 \
        chown 1000:1000 config &&
    sleep 1s &&
    KEY=$(docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh:ro \
        --workdir /root/.ssh \
        alpine:3.4 \
        cat id_rsa.pub) &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh:ro \
        --workdir /root/.ssh \
        tidyrailroad/curl:0.0.0 \
        --data-urlencode "key=${KEY}" --data-urlencode "title=${TITLE}" https://gitlab.363-283.io/api/v3/user/keys?private_token=${GITLAB_PRIVATE_TOKEN}
