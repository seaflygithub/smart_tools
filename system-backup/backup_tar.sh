# dpkg -i xxx.deb
# 安装一个deb包

# dpkg -c xxx.deb
# 列出xxx.deb包内容

# dpkg -l
# 列出已安装的软件

# dpkg -r xxx
# 移除已安装的包裹

# dpkg -P xxx
# 完全清除一个已安装的包裹,remove只删除数据和可执行文件,而purge包括配置等.

# dpkg -L cmd
# 列出某程序的安装配置位置

# dpkg -s cmd
# 显示已安装包裹的头信息

# dpkg-reconfigure
# 重新配置一个已安装的包裹

# 用户数据程序相关存放位置
#1.下载的软件存放位置: /var/cache/apt/archives
#2.安装后软件默认位置: /usr/share
#3.可执行文件位置: /usr/bin
#4.配置文件位置: /etc
#5.lib文件位置: /usr/lib

# 打包当前所有文件
# tar -cJpf /tmp/xxx.tar.xz .

# 拷贝当前所有文件（包括隐藏文件）
# cp -ar ./. /tmp/

# 拷贝所有文件（不覆盖已存在文件）
# cp -nar ./. /tmp/

DIR_CUR="`pwd`"
DIR_UDISK_PATH=""
SUDO=""

#**********************方案1:使用tar命令备份***********************
# 备份环境
#1.打包根目录各个子目录: bin etc lib lib64 opt sbin srv usr var
if [ ${UID} -ne 0 ] ; then SUDO="sudo" else SUDO="" fi
echo -e "U-disk root_path: \c" ; DIR_UDISK_PATH ; read DIR_UDISK_PATH
ls ${DIR_UDISK_PATH} 2>/dev/null 1>/dev/null
if [ $? -ne 0 ] ; then echo "Error: No Such Path!" ; exit 1 ; \
else cd / ; \
    echo "Note: Single backuping /dev ..." ; \
    ${SUDO} tar -cJpvf \
    --exclude=/bin \
    --exclude=/boot \
    --exclude=/cdrom \
    --exclude=/etc \
    --exclude=/home \
    --exclude=/initrd.img \
    --exclude=/lib \
    --exclude=/lib64 \
    --exclude=/lost+found \
    --exclude=/media \
    --exclude=/mnt \
    --exclude=/opt \
    --exclude=/proc \
    --exclude=/root \
    --exclude=/run \
    --exclude=/sbin \
    --exclude=/srv \
    --exclude=/sys \
    --exclude=/tmp \
    --exclude=/usr \
    --exclude=/var \
    --exclude=/vmlinuz \
    ${DIR_UDISK_PATH}/root_dev.tar.xz / ; \
    echo "Note: backuping others dirs..." ; \
    ${SUDO} tar -cJpvf \
    --exclude=/run \
    --exclude=/home/seafly/Tempdata \
    --exclude=/home/seafly/.cache \
    --exclude=/boot \
    --exclude=/cdrom \
    --exclude=/lost+found \
    --exclude=/media \
    --exclude=/mnt \
    --exclude=/proc \
    --exclude=/sys \
    --exclude=/tmp \
    ${DIR_UDISK_PATH}/root_others.tar.xz / ; \
    return 0
    fi

    # 恢复环境
    #1.在移动盘根目录内创建一个临时目录dir_root
    #2.直接解压恢复dev目录
    #3.解压并无覆盖拷贝恢复其他目录
    echo "Please ready xxx.tar.xz in U-disk root..."
    echo -e "U-disk root path: \c" ; DIR_UDISK_PATH="" ; read DIR_UDISK_PATH
    ls ${DIR_UDISK_PATH} 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ] ; then echo "Error: No Such Path!" ; exit 1 ; \
    else mkdir -p ${DIR_UDISK_PATH}/temp_recovery ; \
        echo "Note: Single recoverying /dev ..." ; \
        ${SUDO} tar -xJpvf ${DIR_UDISK_PATH}/root_dev.tar.xz -C / ; \
        echo "Note: recoverying others dirs..." ; \
        ${SUDO} tar -xJpvf \
        ${DIR_UDISK_PATH}/root_others.tar.xz -C \
        ${DIR_UDISK_PATH}/temp_recovery ; \
        cp -avnr ${DIR_UDISK_PATH}/temp_recovery/. / ; \
        ${SUDO} rm -rf ${DIR_UDISK_PATH}/temp_recovery ; \
        return 0
fi

