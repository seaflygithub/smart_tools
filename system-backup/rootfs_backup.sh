#!/bin/bash
# File              : rootfs_backup.sh
# Author            : SeaflyGithub <seafly0616@qq.com>
# Date              : 2017.09.29
# Last Modified Date: 2017.09.30
# Last Modified By  : SeaflyGithub <seafly0616@qq.com>

#rootfs_backup.sh执行流程：
#   首先备份根目录
#       根据下面的DIR_INVERT_ROOT的值表示备份除这些目录之外
#       由于目录默认递归打包，因此上面的变量是必须要，否则无限备份!!!
#   然后备份home目录里的其他用户目录
#       根据下面的DIR_INVERT_HOME的值表示备份除这些目录之外
#       意思是备份/home目录除/home/USER_MAIN这个目录
#   然后备份当前登录用户里的特定目录
#       比如当前用户是seafly, 那么有/home/seafly
#       /home/seafly下不想备份目录就填到
#   最后备份产生的目录包存放在/tmp/rootfs_ubuntu（可更改）

#下面是用户可或需要更改的变量
############################################
USER_MAIN=`w | grep "init" | awk '{print $1}'`  #你的用户名
DIR_INVERT_ROOT="\.|\.\.|proc|lost|mnt|sys|media|home|tmp"  #排除备份目录
DIR_INVERT_HOME="\.|\.\.|${USER_MAIN}"
DIR_INVERT_USER="\.|\.\.|TempData|VMware|Videos" #你的home目录下要排除的目录
############################################

#rootfs_backup.sh用法：
#备份：bash rootfs_backup.sh
#恢复：bash rootfs_backup.sh -b

SUDO=""
DIR_BACKUP="/tmp/rootfs_ubuntu"
DIR_BACKUP_HOME="/tmp/rootfs_ubuntu/home"
DIR_BACKUP_HOME_USER="/tmp/rootfs_ubuntu/home/${USER_MAIN}"
DIR_BACKUP_HOME_USER_FILES="/tmp/rootfs_ubuntu/home/${USER_MAIN}/files"
TEMP_FILE_LIST="/tmp/list.txt"

if [ $UID -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

function init_backupdir()
{
    rm -rf ${DIR_BACKUP}
    mkdir -p ${DIR_BACKUP_HOME_USER_FILES}
}

function generate_dirs_list()
{
    DIR_LS="$1"
    DIR_INVERT="$2"
    ls -aF ${DIR_LS} | grep "/" | \
        egrep -v ${DIR_INVERT} > ${TEMP_FILE_LIST}
    sed -i 's/\///g' ${TEMP_FILE_LIST}
}

function generate_file_list()
{
    DIR_LS="$1"
    DIR_INVERT="$2"
    FILES="$3"
    ls -aF ${DIR_LS}/${FILES} | egrep -v "/" | egrep -v "${DIR_INVERT}" > ${TEMP_FILE_LIST}
}

function package_rootdir()
{
    #generate list.txt
    generate_dirs_list "/" ${DIR_INVERT_ROOT}

    #package dirs from list.txt
    cd / ; \
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i \
        ${SUDO} tar -cvpJf ${DIR_BACKUP}/{}.tar.xz {}

    cd / ; \
    ${SUDO} tar -cpJf ${DIR_BACKUP}/files.tar.xz initrd.img vmlinuz .viminfo
}

function package_other_users()
{
    #generate list.txt
    generate_dirs_list "/home" ${DIR_INVERT_HOME}

    #home other users
    cd /home ; \
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i \
        ${SUDO} tar -cvpJf ${DIR_BACKUP}/{}.tar.xz {}
}

function package_main_user()
{
    #TempData,VMware
    generate_dirs_list "/home/${USER_MAIN}" "${DIR_INVERT_USER}"

    cd /home/{$USER_MAIN} ; \
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i \
        ${SUDO} tar -cvpJf ${DIR_BACKUP_HOME_USER}/{}.tar.xz {}

    generate_file_list "/home/${USER_MAIN}" "/"
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i cp -rpvf /home/${USER_MAIN}/{} ${DIR_BACKUP_HOME_USER_FILES}
}

function package_home()
{
    #/home -v seafly/
    package_other_users

    #/home/owner(seafly)    dirs + files
    package_main_user
}

function unpackage_rootdir()
{
    #generate list.txt
    generate_file_list "${DIR_BACKUP}" "/" "*.tar.xz"

    #package dirs from list.txt
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i \
        ${SUDO} tar -xvpJf ${DIR_BACKUP}/{} -C /
}

function unpackage_home()
{
    #/home
    generate_file_list "${DIR_BACKUP_HOME}" "/" "*.tar.xz"
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i \
        ${SUDO} tar -xvpJf ${DIR_BACKUP}/{} -C /home

    #/home/seafly
    generate_file_list "${DIR_BACKUP_HOME_USER}" "/" "*.tar.xz"
    cat ${TEMP_FILE_LIST} | xargs -E '\n' -i \
        ${SUDO} tar -xvpJf ${DIR_BACKUP}/{} -C /home/${USER_MAIN}
    cp -rpvf ${DIR_BACKUP_HOME_USER_FILES}/* /home/${USER_MAIN}
}


#UNIX C
if [ "$1" == "-d" ]; then
    ls ./boot.tar.xz 2>/dev/null 1>/dev/null
    if [ $? -eq 0 ]; then
        DIR_CUR="`pwd`"
        DIR_BACKUP="${DIR_CUR}"
        DIR_BACKUP_HOME="${DIR_CUR}/home"
        DIR_BACKUP_HOME_USER="${DIR_BACKUP_HOME}/${USER_MAIN}"
        DIR_BACKUP_HOME_USER_FILES="${DIR_BACKUP_HOME_USER}/files"
        unpackage_rootdir
        unpackage_home
    else
        echo "Please copy this script into your rootfs dir..."
        exit 3
    fi
else
    init_backupdir
    package_rootdir
    package_home
fi
