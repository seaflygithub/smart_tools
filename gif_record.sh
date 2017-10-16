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

TEMP_FILE_XWINDINFO="${HOME}/xwininfo.txt"
GLOBAL_FILE_SYS="global_sys.sh"

DELAY=6
RECORD_TIME=10
SAVE_AS=""
START_X=""
START_Y=""
WIDTH=""
HEIGHT=""

source ${GLOBAL_FILE_SYS}

function install_gif_record()
{
    which byzanz-record
    if [ $? -eq 0 ] ; then
        return 0
    else
        if [ ${HOSTOS} = "ubuntu" ] ; then
            ${SUDO} apt-get install -y byzanz
        fi
        return 0
    fi
}

function show_toolinfo()
{
    echo "gif_record: "
    echo "           record window which be choosed "
    echo "           and save it as ~/Desktop/temp.gif"
}

function generate_xwininfo_tempfile()
{
    echo "Please choose window which you are recording ..."
    xwininfo | col -b > ${TEMP_FILE_XWINDINFO}
}

function clean_temp_file()
{
    rm -rf ${TEMP_FILE_XWINDINFO}
}

function get_xwininfo()
{
    START_X=`grep "Absolute" ${TEMP_FILE_XWINDINFO} | grep "X:"`
    START_X="`echo ${START_X} | awk -F ' ' '{print $4}'`"
    echo "START_X=${START_X}"
    START_Y=`grep "Absolute" ${TEMP_FILE_XWINDINFO} | grep "Y:"`
    START_Y="`echo ${START_Y} | awk -F ' ' '{print $4}'`"
    echo "START_Y=${START_Y}"
    WIDTH=`grep "Width:" ${TEMP_FILE_XWINDINFO}`
    WIDTH="`echo ${WIDTH} | awk -F ' ' '{print $2}'`"
    echo "WIDTH=${WIDTH}"
    HEIGHT=`grep "Height:" ${TEMP_FILE_XWINDINFO}`
    HEIGHT="`echo ${HEIGHT} | awk -F ' ' '{print $2}'`"
    echo "HEIGHT=${HEIGHT}"
    echo -e "Please input seconds record: \c"
    read RECORD_TIME
    if [ ${RECORD_TIME} = "" ] ; then
        RECORD_TIME=10
    fi
    echo "RECORD_TIME=${RECORD_TIME}"
}

function start_record()
{
    seconds_left=6 
    while [ $seconds_left -ge 0 ];do  
        echo -n "After $seconds_left seconds to start recording ..."
      sleep 1  
      seconds_left=$(($seconds_left - 1))  
      echo -ne "\r     \r" #清除本行文字  
    done  

    byzanz-record --delay=3 -c -v \
        -x ${START_X} -y ${START_Y} \
        -w ${WIDTH} -h ${HEIGHT} \
        -d ${RECORD_TIME} \
        ${HOME}/Desktop/temp.gif
    echo "finished: save as ~/Desktop/temp.gif"
}

get_hostos
check_access
clear
install_gif_record
show_toolinfo
generate_xwininfo_tempfile
head -n 6 ${TEMP_FILE_XWINDINFO}
get_xwininfo
start_record
clean_temp_file
