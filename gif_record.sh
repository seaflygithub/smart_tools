#!/bin/bash
# File              : gif_record.sh
# Author            : SeaflyGithub <seafly0616@qq.com>
# Date              : 2017.10.26 10时59分47秒
# Last Modified Date: 2017.10.26 11时17分26秒
# Last Modified By  : SeaflyGithub <seafly0616@qq.com>
FILE_TEMP_XWINDINFO="${HOME}/xwininfo.txt"
GLOBAL_FILE_SYS="global_sys.sh"

DELAY=6
RECORD_TIME=10
SAVE_AS=""
START_X=""
START_Y=""
WIDTH=""
HEIGHT=""
FILE_TEMP_RECORD=${HOME}/temp.gif

HOSTOS=""
SUDO=""
FLAG_NETWORK_STATUS=0

# 获取系统发行版信息
function get_hostos()   # >> HOSTOS
{
    HOSTOS="`uname -v | \
        awk -F ' ' '{print $1}' | \
        awk -F '-' '{print $2}' | \
        tr '[:upper:]' '[:lower:]'`"
}

# 检查当前用户权限
function check_access() # >> SUDO
{
    if [ $UID -ne 0 ] ;
    then
        SUDO=sudo
    fi
}

# 获取网络状态
function get_network_status()
{
    # 首先检查是否已经安装了GIF录制工具，安装了就跳过网络检查
    dpkg -l | grep "byzanz-record" 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ] ; then
        return 0
    else
        # 检查网络连接状态
        echo "正在检查网络连接状态..."
        host www.baidu.com 1>/dev/null 2>/dev/null
        if [ $? -eq 0 ];
        then
            echo "Success: Network available!"
            FLAG_NETWORK_STATUS=1
        else
            echo "Warning: Network unavailable!"
            FLAG_NETWORK_STATUS=0
        fi
        return 0
    fi
}

# 安装GIF录制工具
function install_gif_record()
{
    #dpkg -l | grep "byzanz-record"
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

# 显示脚本基本信息
function show_toolinfo()
{
    echo "欢迎使用gif_record.sh: "
    echo "  0.用法: bash gif_record.sh"
    echo "  1.本工具将录制用户选中的窗口"
    echo "  2.录制之后的文件保存为: ~/temp.gif"
}

# 生成窗口信息临时文件
function generate_xwininfo_tempfile()
{
    echo "请选择你要录制的窗口..."
    xwininfo | col -b > ${FILE_TEMP_XWINDINFO}
}

# 清除脚本执行后产生的临时文件
function clean_temp_file()
{
    rm -rf ${FILE_TEMP_XWINDINFO}
}

# 从临时文件中获取窗口信息
function get_xwininfo()
{
    START_X=`grep "Absolute" ${FILE_TEMP_XWINDINFO} | grep "X:"`
    START_X="`echo ${START_X} | awk -F ' ' '{print $4}'`"
    echo "窗口X坐标=${START_X}"
    START_Y=`grep "Absolute" ${FILE_TEMP_XWINDINFO} | grep "Y:"`
    START_Y="`echo ${START_Y} | awk -F ' ' '{print $4}'`"
    echo "窗口Y坐标=${START_Y}"
    WIDTH=`grep "Width:" ${FILE_TEMP_XWINDINFO}`
    WIDTH="`echo ${WIDTH} | awk -F ' ' '{print $2}'`"
    echo "窗口宽度=${WIDTH}"
    HEIGHT=`grep "Height:" ${FILE_TEMP_XWINDINFO}`
    HEIGHT="`echo ${HEIGHT} | awk -F ' ' '{print $2}'`"
    echo "窗口高度=${HEIGHT}"
    echo -e "请输入录制秒数(不确定的尽量设置大点): \c"
    read RECORD_TIME
    if [ ${RECORD_TIME} = "" ] ; then
        RECORD_TIME=10
    fi
    echo "录制时间（秒）= ${RECORD_TIME}"
}

# 开始录制GIF
function start_record()
{
    seconds_left=6 
    while [ $seconds_left -ge 0 ];do  
        echo -n "$seconds_left 秒之后开始录制..."
      sleep 1  
      seconds_left=$(($seconds_left - 1))  
      echo -ne "\r     \r" #清除本行文字  
    done  

    byzanz-record --delay=3 -c -v \
        -x ${START_X} -y ${START_Y} \
        -w ${WIDTH} -h ${HEIGHT} \
        -d ${RECORD_TIME} \
        ${FILE_TEMP_RECORD}
    echo "录制完成: GIF文件保存在: ~/temp.gif"
}

get_hostos
check_access
get_network_status
clear
install_gif_record
show_toolinfo
generate_xwininfo_tempfile
head -n 6 ${FILE_TEMP_XWINDINFO}
get_xwininfo
start_record
clean_temp_file
