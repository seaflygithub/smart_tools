#!/bin/bash
# File: smart_kill.sh
# Author: SeaflyDennis <seafly0616@qq.com>
# Date: 2017.08.11
# Last Modified Date: 2017.08.11
# Last Modified By: SeaflyDennis <seafly0616@qq.com>

process_name=""
process_id=
process_ids=
SUDO=""
temp_file="${HOME}/smart_kill.temp"

if [ $# -ne 1 ]; then
    echo "Usage: $0 <process_name_keyword>"
    echo "Example: $0 samba"
    rm -rf ${temp_file}
    exit 1
else
    process_name="$1"
    if [ "${process_name}" = "" ]; then
        echo "Error: process_name == NULL"
        rm -rf ${temp_file}
        exit 2
    fi
    # Get process_id and write into a temp file
    ps -aux | grep "${process_name}" | egrep -v "grep" | awk -F ' ' '{print $2}' > ${temp_file}
    process_ids=`cat ${HOME}/smart_kill.temp`
    if [ "${process_ids}" = "" ]; then
        echo "No such process ..."
        rm -rf ${temp_file}
        exit 0
    fi

    user_access="`ps -aux | grep "${process_name}" | egrep -v "grep" | awk -F ' ' '{print $1}'`"
    if [ ${UID} -eq 0 ]; then
        SUDO=""
    elif [ ${UID} -ne 0 -a "${user_access}" != "root" ]; then
        SUDO=""
    elif [ ${UID} -ne 0 -a "${user_access}" = "root" ]; then
        SUDO="sudo"
    fi

    cat ${temp_file} | xargs -i -d '\n' ${SUDO} kill -s SIGKILL {}
    rm -rf ${temp_file}
    echo "kill destination successfully!"
    exit 0
fi
