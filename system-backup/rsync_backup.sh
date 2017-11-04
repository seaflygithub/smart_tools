#!/bin/bash
# File              : system-backup/rsync_backup.sh
# Author            : SeaflyGithub <seafly0616@qq.com>
# Date              : 2017.10.23 07时13分37秒
# Last Modified Date: 2017.10.23 07时13分37秒
# Last Modified By  : SeaflyGithub <seafly0616@qq.com>

# 使用方法:
#   01. 直接执行该脚本: bash ./rsync_recovery.sh
#   02. 提示输入你移动盘的绝对路径
#   03. 提示输入sudo密码
#   04. 开始恢复

# 优点1: 系统在备份还原过程中，可以保存文件原有属性
# 优点2: 再次备份或还原系统时，只需要复制修改过的文件
# 优点3: rsync是一个非常优秀的文件同步工具，它支持远程同步
# 优点4: 它支持系统运行时同步，即不需要LiveUSB也可恢复环境
# 缺点1: 根目录占用多少空间,备份目录就占多大空间
# 缺点2: 首次备份时，需要复制所有文件

if [ $UID -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi
DIR_UDISK_ROOT_PATH=/media/seafly/SSD_128

#******备份系统******
#1.首先挂载一个移动硬盘（最好是ext3文件系统）
echo -e "U-disk root path: \c" ; read DIR_UDISK_ROOT_PATH
ls ${DIR_UDISK_ROOT_PATH} 2>/dev/null 1>/dev/null
if [ $? -eq 0 ] ; then
#2.其次rsync备份
${SUDO} mkdir -p ${DIR_UDISK_ROOT_PATH}/backup_linux
${SUDO} rsync -Pa / ${DIR_UDISK_ROOT_PATH}/backup_linux \
    --exclude=/media/* \
    --exclude=/sys/* \
    --exclude=/proc/* \
    --exclude=/mnt/* \
    --exclude=/tmp/* \
    --exclude=/lost+found/* \
    --exclude=/home/seafly/Tempdata/* \
    --exclude=/home/seafly/.cache/* 
else
    echo "${DIR_UDISK_ROOT_PATH}: No such file or dir..."
    exit 1
fi

#******恢复系统******
#${SUDO} rsync -Pa ${DIR_UDISK_ROOT_PATH}/backup_ubuntu /
