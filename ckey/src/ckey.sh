#!/bin/bash
# ckey.sh
# Copyright (c) 2017 Your Name <your@mail>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

LOCK=ckey.elf
BIN_DIR=/usr/bin
program=${BIN_DIR}/${LOCK}
SUDO=

#judgement parameters
if [ $# -ne 2 ] ;
then
    echo "Usage: ckey <in_file> <out_file>"
    exit 1
fi

#judgement owner
if [ ${UID} -ne 0 ] ;
then
    SUDO=sudo
fi

#judgement of /home/bin
[ -d $BIN_DIR ] ;
if [ $? -ne 0 ] ;
then
    mkdir -p $BIN_DIR
fi

echo -e "Please input your password: \c"
stty -echo
read password1
stty echo

#judgement of length of password
length=`echo ${#password1}`
if [ $length -ne 18 ] ; #ID length
then
    echo ""
    echo "Error:invalid length!"
    exit 1
fi

echo ""
echo -e "Please input your password again: \c"
stty -echo
read password2
stty echo

if [ $password1 != $password2 ] ;
then
    echo ""
    echo "Error:different:"
    echo "2nd password: {${password2}}"
    echo "1st password: {${password1}}"
    exit 2
fi
$program $1 $2 $password2
