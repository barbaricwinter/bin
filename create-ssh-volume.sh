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

while [ ${#} -gt 0 ]
do
    case ${1} in
        --title)
            TITLE=${2} &&
                shift &&
                shift
        ;;
        *)
            echo Unknown Option ${1} &&
                exit 64
        ;;
    esac
done &&
    ( [ ! -z "${TITLE}" ] || (echo "Missing Title" && exit 65)) &&
    ( [ -z "$(docker volume ls --filter label=com.deciphernow.emorymerryman.dot_ssh --quiet)" ] || (echo "Volume Already Exists" && exit 66)) &&
    docker volume create --label com.deciphernow.emorymerryman.tstamp=$(date +%s) --label com.deciphernow.emorymerryman.dot_ssh="${TITLE}"