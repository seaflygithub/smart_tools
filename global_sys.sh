##################################################
# Filename: global_sys.sh
# Author: ChrisZZ
# E-mail: zchrissirhcz@163.com
# Created Time: 2017年09月17日 星期日 09时37分57秒
##################################################
#!/bin/bash
HOSTOS=""
SUDO=""
FLAG_NETWORK_STATUS=0

function get_hostos()   # >> HOSTOS
{
    HOSTOS="`uname -v | \
        awk -F ' ' '{print $1}' | \
        awk -F '-' '{print $2}' | \
        tr '[:upper:]' '[:lower:]'`"
}

function check_access() # >> SUDO
{
    if [ $UID -ne 0 ] ;
    then
        SUDO=sudo
    fi
}

function get_network_status()
{
    host www.baidu.com 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ];
    then
        echo "Success: Network available!"
        FLAG_NETWORK_STATUS=1
    else
        echo "Warning: Network unavailable!"
        FLAG_NETWORK_STATUS=0
    fi
}

get_hostos
check_access
get_network_status
export HOSTOS
export SUDO
export FLAG_NETWORK_STATUS
