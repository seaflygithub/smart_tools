#!/bin/bash
# File: qcd.sh   [quick_cd]
# Author: seafly0616 <seafly0616@qq.com>
# Date: 2017.09.03
# Last Modified Date: 2017.09.03
# Last Modified By: seafly0616 <seafly0616@qq.com>
# usage:
#   qcd [dir_keyword1 dir_keyword2 ...]
arg=""
arg_list="$@"
#find_dir="/"
find_dir="${HOME}"
qcd_find_temp_file="${HOME}/qcd_find_temp_file.txt"
file_lines=0

if [ ${arg_list} != "" ]; then
    echo "arg_list=$@"
    for arg in ${arg_list}
    do
        find ${find_dir} -type d -name ${arg} \
            1>${qcd_find_temp_file} 2>/dev/null
        cat -n ${qcd_find_temp_file}

        #get total lines of file:
        file_lines=`sed -n '$=' ${qcd_find_temp_file}`
        echo "file_lines=${file_lines}"

        if [ ${file_lines} -gt 1 ]; then
            # choose menu
            echo ">1"
        elif [ ${file_lines} -eq 1 ]; then
            # choose 1st item
            echo "==1"
        elif [ ${file_lines} -lt 1 ]; then
            # no such dir
            echo "<1"
        fi
    done
else
    echo -e "input dir_keyword: \c"
    read dir_keyword
    echo "dir_keyword=${dir_keyword}"
fi
