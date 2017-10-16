DIR_CUR="`pwd`"
SUDO="sudo"
DIR_TMP="/tmp"
LIST="${DIR_CUR}/HOME.tar.xz ${DIR_CUR}/apps.list ${DIR_CUR}/sources.list"

function backup_environment()
{
    #1.生成列表
    dpkg --get-selections > /tmp/apps.list

    #2.打包HOME目录
    cd ${HOME} ; tar -cJpvf /tmp/HOME.tar.xz *

    #3.备份软件源
    cp /etc/apt/sources.list /tmp/

    ls -shl /tmp/HOME.tar.xz
    ls -shl /tmp/apps.list
    ls -shl /tmp/sources.list
    echo "完成: 备份完成,请把上述文件和本脚本放在同意目录保存好."
}

function recovery_environment()
{
    #0.检查脚本所在当前目录的必要文件
    ls -shl ${LIST} 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ] ; then
        echo "错误: 必要的文件缺失!"
        exit 1
    fi
    
    #1.恢复软件源
    ${SUDO} cp sources.list /etc/apt/
    ${SUDO} apt-get update

    #2.重新下载安装之前系统中的软件
    ${SUDO} dpkg --set-selections apps.list && apt-get dselect-upgrade

    #3.解压HOME备份
    cd /tmp/ ; tar -xJpvf /tmp/HOME.tar.xz -C ${HOME}
}


