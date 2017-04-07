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
        --dot-ssh)
            DOT_SSH=${2} &&
                shift &&
                shift
        ;;
        --gitlab-private-token)
            GITLAB_PRIVATE_TOKEN=${2} &&
                shift &&
                shift
        ;;
        --passphrase)
            PASSPHRASE=${2} &&
                shift &&
                shift
        ;;
        *)
            echo Unknown Options ${1} &&
                exit 64
        ;;
    esac
done &&
    [ ! -z "${DOT_SSH}" ] &&
    [ ! -z "${GITLAB_PRIVATE_TOKEN}" ] &&
    TITLE=$(docker \
        inspect \
        --format "{{ index .Labels \"com.deciphernow.emorymerryman.dot_ssh\"}}" \
        ${DOT_SSH}) && 
    [ ! -z "${TITLE}" ] &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /home/user/.ssh \
        --user user \
        barbaricwinter/alpine:0.0.0 \
        chmod 0700 . &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        --entrypoint ssh-keygen \
        tidyrailroad/openssh-client:0.0.0 \
        -f id_rsa -P "${PASSPHRASE}" -C "${TITLE}" &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        barbaricwinter/alpine:.0.0.0 \
        chown user:user id_rsa &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/root/.ssh \
        --workdir /root/.ssh \
        barbaricwinter/alpine:.0.0.0 \
        chown user:user id_rsa &&
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
IdentityFile ~/.ssh/id_rsa
EOF
    )| docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/home/user/.ssh \
        --workdir /home/user/.ssh \
        --user user \
        barbaricwinter/alpine:0.0.0 \
        config &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/home/user/.ssh \
        --workdir /home/user/.ssh \
        barbaricwinter/alpine:0.0.0 \
        chmod 0600 config &&
    sleep 1s &&
    KEY=$(docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/home/user/.ssh:ro \
        --workdir /home/user/.ssh \
        --user user \
        barbaricwinter/alpine:0.0.0 \
        cat id_rsa.pub) &&
    docker \
        run \
        --interactive \
        --volume ${DOT_SSH}:/home/user/.ssh:ro \
        --workdir /home/user/.ssh \
        --user user \
        tidyrailroad/curl:0.0.0 \
        --data-urlencode "key=${KEY}" --data-urlencode "title=${TITLE}" https://gitlab.363-283.io/api/v3/user/keys?private_token=${GITLAB_PRIVATE_TOKEN}
