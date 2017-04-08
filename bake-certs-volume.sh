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
        --confluence-user-id)
            CONFLUENCE_USER_ID=${2} &&
                shift &&
                shift
        ;;
        --confluence-password)
            CONFLUENCE_PASSWORD=${2} &&
                shift &&
                shift
        ;;
        *)
            echo Unknown Options ${1} &&
                exit 64
        ;;
    esac
done &&
    ( [ ! -z "${CERTS}" ] || (echo Missing Certs && exit 65)) &&
    ( [ ! -z "${CONFLUENCE_USER_ID}" ] || (echo Missing Confluence ID && exit 66)) &&
    ( [ ! -z "${CONFLUENCE_PASSWORD}" ] || (echo Missing Confluence Password && exit 67)) &&
    TEMP_VOLUME=$(docker volume create --label com.deciphernow.emorymerryman.tstamp=$(date +%s) --label com.deciphernow.emorymerryman.temporary=true) &&
    echo TEMP_VOLUME=${TEMP_VOLUME} &&
    docker \
        run \
        --interactive \
        --rm \
        --volume ${TEMP_VOLUME}:/usr/local/src \
        --workdir /usr/local/src \
        tidyrailroad/curl:0.0.0 \
        -u ${CONFLUENCE_USER_ID} -p ${CONFLUENCE_PASSWORD} --output ChimeraTestCerts_v2.zip "https://confluence.363-283.io/download/attachments/2458486/ChimeraTestCerts_v2.zip?version=1&modificationDate=1450375419090&api=v2&download=true" &&
    echo docker \
        run \
        --interactive \
        --rm \
        --volume ${TEMP_VOLUME}:/input:ro \
        --volume ${CERTS}:/output \
        --workdir /input \
        --entrypoint unzip \
        tidyrailroad/zip:0.0.0 \
        ChimeraTestCerts_v2.zip -d /output
    docker \
        run \
        --interactive \
        --rm \
        --volume ${TEMP_VOLUME}:/input:ro \
        --volume ${CERTS}:/output \
        --workdir /input \
        --entrypoint unzip \
        tidyrailroad/zip:0.0.0 \
        ChimeraTestCerts_v2.zip -d /output
