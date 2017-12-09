#!/bin/bash
# File              : github_server.sh
# Author            : seafly <seafly0616@qq.com>
# Date              : 2017.10.12 17时28分07秒
# Last Modified Date: 2017.10.23 07时43分25秒
# Last Modified By  : SeaflyGithub <seafly0616@qq.com>

# 脚本说明:
#   01. 该脚本功能实现参考于万能的互联网
#   02. 网上只提供本地服务器搭建方法文章或博客
#   03. 本作者索性把方法直接封装成脚本，方便自己，方便大家
#   04. 由于本作者用的Ubuntu,因而此脚本对其他发行版Linux可能有所限制
#
# 使用方法:
#   01.如果你想全局的那你自行把该脚本全局化
#   02.获取简单帮助，直接执行 bash github_server.sh
#

GIT_ACCOUNT=""
if [ $UID -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

# github_server.sh脚本设计总流程(参考于万能的互联网):
#
# 01.安装git和一些必要的工具
#   01. 首先检查是否已经安装
#   02. 其次检查网络连接状态并开始安装
#
# 02.注册一个本地账户
#   01. 根据用户输入创建一个本地用户即本地账户
#
# 03.创建ssh-key证书登录
#   （暂时还没实现）（待更新...）
#   说明:该功能主要是ssh-key的功能（不用频繁验证用户）
#
# 04. 创建本地仓库
#   01. 首先根据用户输入选中验证账户名
#   02. 其次根据账户名在该账户下创建并初始化一个仓库目录
#
# 05. 删除本地仓库
#   01. 通过当前git账户的许可删除账户下的仓库目录即可
#
# 06. 备份本地github账户数据
#   01. 首先根据用户输入选中验证账户名
#   02. 其次将该账户目录下的所有数据并打包压缩,并存放在当前用户HOME目录下
#   03. 输出备份后的提示信息
#
# 07. 恢复本地github账户数据
#   01. 首先把之前的备份包原样拷贝到当前HOME目录下
#   02. 其次根据用户输入选中验证账户名
#   03. 将备份包全部解压至目标账户名目录下
#
# 08. 删除本地github账户
#   01. 其实就是删除本地/home目录下相应用户即可
#

#01.安装git
function install_git()
{
    dpkg -l | grep "\<git-core\>" 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ]; then
        host www.baidu.com 2>/dev/null 1>/dev/null
        if [ $? -ne 0 ]; then
            echo "错误: 请检查您的网络连接..."
            exit 1
        else
            ${SUDO} apt-get install -y git git-core
        fi
    else
        return 0
    fi

    dpkg -l | grep "\<openssh-server\>" 2>/dev/null 1>/dev/null
    if [ $? -ne 0 ]; then
        host www.baidu.com 2>/dev/null 1>/dev/null
        if [ $? -ne 0 ]; then
            echo "错误: 请检查您的网络连接..."
            exit 1
        else
            ${SUDO} apt-get install -y openssh-client openssh-server --force-yes
        fi
    else
        return 0
    fi
}

#02.注册一个本地Github账户
function signup_for_local_github()
{
    echo "正在注册本地Github账户(每个账户单独管理自己的仓库)..."
    echo -e "请输入新账户用户名: \c"
    GIT_ACCOUNT=""
    read GIT_ACCOUNT
    if [ $GIT_ACCOUNT = "" ]; then
        echo "用户名无效，默认重置用户名为: github"
        GIT_ACCOUNT="github"
        ${SUDO} adduser ${GIT_ACCOUNT}
        echo "新的本地Github账户注册成功!"
        echo "请执行github_server.sh获取其他操作帮助..."
    else
        ${SUDO} adduser ${GIT_ACCOUNT}
        echo "git服务器管理员创建成功！"
        echo "请执行github_server.sh获取其他操作帮助..."
    fi
}

#03.创建证书登录
#cat /home/users/.ssh/id_rsa.pub >> /home/github/.ssh/authorized_keys

#04.初始化&创建git仓库
function create_repository()
{
    GIT_ACCOUNT=""
    echo -e "请输入本地Github用户名: \c"
    read GIT_ACCOUNT
    echo -e "请输入新仓库名: \c"
    read repository
    repo_path="/home/${GIT_ACCOUNT}/${repository}"
    ${SUDO} git init --bare ${repo_path}
    ${SUDO} chown -R ${GIT_ACCOUNT}:${GIT_ACCOUNT} ${repo_path}
    echo "新仓库: ${repository} 创建成功！！！"
}


#05.禁用shell登录
#vim /etc/passwd （.../bin/bash ---> .../bin/git-shell）

#06.克隆远程仓库
function github_clone_way()
{
    echo "克隆本地服务器仓库的方法如下："
    echo "git clone 账户名@服务器IP:/home/账户名/仓库名"
}

#07.删除仓库
function delete_repository()
{
    echo -e "\033[41;37m警告: 仓库很可能保存了你多年的心血,请谨慎操作!\033[0m"
    echo -e "确认删除该仓库？【Y/N】: \c"
    read sure
    if [ ${sure} = "Y" ]; then
        GIT_ACCOUNT=""
        echo -e "请输入本地Github用户名: \c"
        read GIT_ACCOUNT
        echo -e "请输入仓库名: \c"
        read repository
        ls /home/${GIT_ACCOUNT}/${repository} 2>/dev/null 1>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[41;37m错误: 不存在此仓库,请检查是否笔误...\033[0m"
        else
            cd /home/${GIT_ACCOUNT} ; ${SUDO} rm -rf ${repository}
            echo "仓库: ${repository} 删除成功!!!!!!"
        fi
    elif [ ${sure} = "y" ]; then
        GIT_ACCOUNT=""
        echo -e "请输入本地Github用户名: \c"
        read GIT_ACCOUNT
        echo -e "请输入仓库名: \c"
        read repository
        ls /home/${GIT_ACCOUNT}/${repository} 2>/dev/null 1>/dev/null
        if [ $? -ne 0 ]; then
            echo -e "\033[41;37m错误: 不存在此仓库,请检查是否笔误...\033[0m"
        else
            cd /home/${GIT_ACCOUNT} ; ${SUDO} rm -rf ${repository}
            echo "仓库: ${repository} 删除成功!!!!!!"
        fi
    else
        echo -e "\033[31m已成功取消该仓库的删除...\033[0m"
    fi
}

#08.删除git服务器
function destroy_gitserver()
{
    echo -e "\033[41;37m警告: 该本地Github账户很可能保存了你多年的心血,请谨慎操作!\033[0m"
    echo -e "确认删除本地Github账户？【Y/N】: \c"
    read sure
    if [ ${sure} = "Y" ]; then
        GIT_ACCOUNT=""
        echo -e "\033[31m请输入要删除的Github账户名: \c \033[0m"
        read GIT_ACCOUNT
        if [ ${GIT_ACCOUNT} == "" ]; then
            GIT_ACCOUNT="github"
            gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
            if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
                echo -e "\033[31m正在删除该本地Github账户...\033[0m"
                ${SUDO} userdel -r -f ${GIT_ACCOUNT}
                ${SUDO} rm -rf /home/${GIT_ACCOUNT}
                echo -e "\033[31m该本地Github账户删除成功!!!\033[0m"
                return 0
            else
                echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
            fi
        else
            gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
            if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
                echo -e "\033[31m正在删除该本地Github账户...\033[0m"
                ${SUDO} userdel -r -f ${GIT_ACCOUNT}
                ${SUDO} rm -rf /home/${GIT_ACCOUNT}
                echo -e "\033[31m该本地Github账户删除成功!!!\033[0m"
                return 0
            else
                echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
            fi
        fi
        echo "*************************************************"
    elif [ ${sure} = "y" ]; then
        GIT_ACCOUNT=""
        echo -e "\033[31m请输入要删除的Github账户名: \c \033[0m"
        read GIT_ACCOUNT
        if [ ${GIT_ACCOUNT} == "" ]; then
            GIT_ACCOUNT="github"
            gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
            if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
                echo -e "\033[31m正在删除该本地Github账户...\033[0m"
                ${SUDO} userdel -r -f ${GIT_ACCOUNT}
                ${SUDO} rm -rf /home/${GIT_ACCOUNT}
                echo -e "\033[31m该本地Github账户删除成功!!!\033[0m"
                return 0
            else
                echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
            fi
        else
            gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
            if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
                echo -e "\033[31m正在删除该本地Github账户...\033[0m"
                ${SUDO} userdel -r -f ${GIT_ACCOUNT}
                ${SUDO} rm -rf /home/${GIT_ACCOUNT}
                echo -e "\033[31m该本地Github账户删除成功!!!\033[0m"
                return 0
            else
                echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
            fi
        fi
        echo "*************************************************"
    else
        echo -e "\033[31m已成功取消本地Github账户的删除...\033[0m"
    fi
}

function backup_data()
{
    GIT_ACCOUNT=""
    echo -e "\033[31m请输入要备份账户的用户名: \c \033[0m"
    read GIT_ACCOUNT
    if [ ${GIT_ACCOUNT} == "" ]; then
        GIT_ACCOUNT="github"
        gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
        if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
            echo -e "\033[31m正在备份该账户数据...\033[0m"
            cd /home/${GIT_ACCOUNT} ; ${SUDO} tar -cvJpf ${HOME}/github_backup.tar.xz .
            echo -e "\033[31m该账户数据备份成功!!!\033[0m"
            echo -e "\033[31m备份包默认保存在当前用户【HOME】目录下...\033[0m"
            return 0
        else
            echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
        fi
    else
        gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
        if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
            echo -e "\033[31m正在备份该账户数据...\033[0m"
            cd /home/${GIT_ACCOUNT} ; ${SUDO} tar -cvJpf ${HOME}/github_backup.tar.xz .
            echo -e "\033[31m该账户数据备份成功!!!\033[0m"
            echo -e "\033[31m备份包默认保存在当前用户【HOME】目录下...\033[0m"
            return 0
        else
            echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
        fi
    fi
}

function recovery_data()
{
    GIT_ACCOUNT=""
    echo -e "\033[41;37m注意: 为了简化脚本编写,\033[0m"
    echo -e "\033[41;37m      包名必须为【github_backup.tar.xz】\033[0m"
    echo -e "\033[41;37m      并把该备份包拷贝至当前用户HOME目录下...\033[0m"
    echo -e "\033[31m      然后直接按回车键继续...\033[0m"
    read temp
    echo -e "\033[31m请输入恢复目标账户的用户名: \c \033[0m"
    read GIT_ACCOUNT
    if [ ${GIT_ACCOUNT} == "" ]; then
        GIT_ACCOUNT="github"
        gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
        if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
            echo -e "\033[31m正在把数据包数据导入到该账户目录下...\033[0m"
            ${SUDO} tar -xvJpf ${HOME}/github_backup.tar.xz -C /home/${GIT_ACCOUNT}
            echo -e "\033[31m该账户下已成功导入该备份数据包数据!!!\033[0m"
        else
            echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
        fi
    else
        gitaccount="`grep "\<${GIT_ACCOUNT}\>" /etc/passwd | awk -F ':' '{print $1}'`"
        if [ "${gitaccount}" == "${GIT_ACCOUNT}" ]; then
            echo -e "\033[31m正在把数据包数据导入到该账户目录下...\033[0m"
            ${SUDO} tar -xvJpf ${HOME}/github_backup.tar.xz -C /home/${GIT_ACCOUNT}
            echo -e "\033[31m该账户下已成功导入该备份数据包数据!!!\033[0m"
        else
            echo -e "\033[41;37m错误: 不存在此账户【${GIT_ACCOUNT}】!\033[0m"
        fi
    fi
}

function content_cn_readme()
{
    echo "# 项目名称"
    echo "# 项目大纲"
    echo "# 使用手册"
    echo "# 使用条件"
    echo "# 安装"
    echo "# 项目测试"
    echo "# 测试目的"
    echo "# 范例代码"
    echo "# 贡献者"
    echo "# 版本"
    echo "# 作者"
    echo "# 创作动机"
    echo "# 许可证"
    echo "# 特别鸣谢"
    return 0
}

function content_en_readme()
{
    echo "# Project Title"
    echo "# Synopsis"
    echo "# Getting Started"
    echo "# Prerequisites"
    echo "# Installing"
    echo "# Running the tests"
    echo "# Break down into end to end tests"
    echo "# And coding style tests"
    echo "# Code Example"
    echo "# Deployment"
    echo "# Built With"
    echo "# Contributors"
    echo "# Versionning"
    echo "# Authors"
    echo "# Motivation"
    echo "# License"
    echo "# Acknowledgments"
    return 0
}

function git_clone_local_repository()
{
    return 0
}

function github_server_usage()
{
    echo "脚本简介              : Github本地服务器管理脚本"
    echo "编码说明              : 终端得支持中文,本脚本默认utf-8编码"
    echo "获取简单帮助          : github_server.sh"
    echo "注册本地Github账户    : github_server.sh --sign-up"
    echo "创建本地仓库          : github_server.sh --create-repository"
    echo "删除本地仓库          : github_server.sh --delete-repository"
    echo "备份本地Github账户数据: github_server.sh --backup-data"
    echo "恢复本地Github账户数据: github_server.sh --recovery-data"
    echo "删除本地Github账户    : github_server.sh --destroy-gitserver"
    echo "" ; github_clone_way
}

function github_server_main()
{
    INSTALL_ARG="$1"
    case $INSTALL_ARG in
        "")
            github_server_usage
            ;;
        "--sign-up")
            install_git
            signup_for_local_github
            ;;
        "--create-repository")
            create_repository
            github_clone_way
            ;;
        "--delete-repository")
            delete_repository
            ;;
        "--destroy-gitserver")
            destroy_gitserver
            ;;
        "--backup-data")
            backup_data
            ;;
        "--recovery-data")
            recovery_data
            ;;
        *)
            $*
            if [ $? -ne 0 ] ;
            then
                github_server_usage
            fi
            ;;
    esac
    echo ""
}
github_server_main $@
