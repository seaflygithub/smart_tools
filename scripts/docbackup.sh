#!/bin/bash
# docbackup.sh
# Copyright (c) 2016 seafly <seafly0616@qq.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


#The shell script introduction:
#01. copy your file for backup
#02. sensitive accuration of time
#03. you can use it to backup your important file
#04. usage: ./docbackup.sh  your_file
#05. example: ./docbackup.sh  my_data.doc
#06. after above operating you will see my_data-20170106123025.doc


last_mod_time=""
curr_mod_time=""
mod_time=""
PWD=`pwd`
SUDO=""
LOG_FILE=backup.log


function write_log ()
{
    echo "$curr_mod_time" > $LOG_FILE
}

#instruction: get last modified time of your file
#usage: get_last_mod_time  dstfile
function get_last_mod_time ()
{
    local dstfile="$1"
    echo "PWD: $PWD"

    if [ -f $LOG_FILE ] ;
    then
        last_mod_time=`cat backup.log`
        echo "Got last: $last_mod_time"
    else
        echo "Rewrite backup.log"
        get_curr_mod_time $dstfile
        write_log
        get_last_mod_time $dstfile
        return 1
    fi
}

#instruction: get current modified time of your file
#usage: get_curr_mod_time  dstfile
function get_curr_mod_time ()
{
    local dstfile="$1"
    curr_mod_time=`stat $dstfile | \
    grep -i Modify | \
    awk -F . '{print $1}' | \
    awk '{print $2$3}' | \
    awk -F - '{print $1$2$3}' | \
    awk -F : '{print $1$2$3}'`
    echo "current_mod_time: $curr_mod_time"
}


#instruction: rename your file use the time
#usage: mod_filename dstfile
function mod_filename ()
{
    local old_name=$1
    local new_name=""
    echo "old_name: $old_name"

    #Get the prefix name of your file
    prefix_name=`echo "$old_name" | awk -F . '{print $1}'`

    #Get the suffix name of your file
    suffix_name=`echo "$old_name" | awk -F . '{print $2}'`


###################################################################
#judgement of suffix_name and get newname

#if [ curr_mod_time != last_mod_time ]
#mod_time = curr_mod_time
#else
#mod_time = last_mod_time
    if [ $curr_mod_time == $last_mod_time ] ;
    then
        mod_time=$curr_mod_time
    else
        mod_time=$curr_mod_time
    fi



    if [ -z $suffix_name ] ;        #filename
    then
        echo "your filename has no dot(point)"
        echo "old_name: $old_name"
        new_name="$prefix_name-$mod_time"
        echo "newname: $new_name"
    else
        temp_name3=`echo "$old_name" | awk -F . '{print $3}'`
        if [ -z $temp_name3 ] ;        #filename.tar
        then
            new_name="$prefix_name-$mod_time.$suffix_name"
            echo "new_name: $new_name"
        else
            temp_name4=`echo "$old_name" | awk -F . '{print $4}'`
            if [ -z $temp_name4 ] ;        #filename.tar.gz
            then
                suffix_name=$suffix_name.$temp_name3
                new_name="$prefix_name-$mod_time.$suffix_name"
                echo "new_name: $new_name"
            else
                temp_name5=`echo "$old_name" | awk -F . '{print $5}'`
                if [ -z $temp_name5 ] ;        #filename.tar.gz.xz
                then
                    suffix_name=$suffix_name.$temp_name3.$temp_name4
                    new_name="$prefix_name-$mod_time.$suffix_name"
                    echo "new_name: $new_name"
                else
                    temp_name6=`echo "$old_name" | awk -F . '{print $6}'`
                    if [ -z $temp_name6 ] ;        #filename.tar.gz.xz.zip
                    then
                        suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5
                        new_name="$prefix_name-$mod_time.$suffix_name"
                        echo "new_name: $new_name"
                    else
                        temp_name7=`echo "$old_name" | awk -F . '{print $7}'`
                        if [ -z $temp_name7 ] ;        #filename.tar.gz.xz.zip.rar
                        then
                            suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6
                            new_name="$prefix_name-$mod_time.$suffix_name"
                            echo "new_name: $new_name"
                        else
                            temp_name8=`echo "$old_name" | awk -F . '{print $8}'`
                            if [ -z $temp_name8 ] ;        #filename.tar.gz.xz.zip.rar.01
                            then
                                suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7
                                new_name="$prefix_name-$mod_time.$suffix_name"
                                echo "new_name: $new_name"
                            else
                                temp_name9=`echo "$old_name" | awk -F . '{print $9}'`
                                if [ -z $temp_name9 ] ;        #filename.tar.gz.xz.zip.rar.01.08
                                then
                                    suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8
                                    new_name="$prefix_name-$mod_time.$suffix_name"
                                    echo "new_name: $new_name"
                                else
                                    temp_name10=`echo "$old_name" | awk -F . '{print $10}'`
                                    if [ -z $temp_name10 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09
                                    then
                                        suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9
                                        new_name="$prefix_name-$mod_time.$suffix_name"
                                        echo "new_name: $new_name"
                                    else
                                        temp_name11=`echo "$old_name" | awk -F . '{print $11}'`
                                        if [ -z $temp_name11 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10
                                        then
                                            suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10
                                            new_name="$prefix_name-$mod_time.$suffix_name"
                                            echo "new_name: $new_name"
                                        else
                                            temp_name12=`echo "$old_name" | awk -F . '{print $12}'`
                                            if [ -z $temp_name12 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10.11
                                            then
                                                suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10.$temp_name11
                                                new_name="$prefix_name-$mod_time.$suffix_name"
                                                echo "new_name: $new_name"
                                            else
                                                temp_name13=`echo "$old_name" | awk -F . '{print $13}'`
                                                if [ -z $temp_name13 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10.11.12
                                                then
                                                    suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10.$temp_name11.$temp_name12
                                                    new_name="$prefix_name-$mod_time.$suffix_name"
                                                    echo "new_name: $new_name"
                                                else
                                                    temp_name14=`echo "$old_name" | awk -F . '{print $14}'`
                                                    if [ -z $temp_name14 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10.11.12.13
                                                    then
                                                        suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10.$temp_name11.$temp_name12.$temp_name13
                                                        new_name="$prefix_name-$mod_time.$suffix_name"
                                                        echo "new_name: $new_name"
                                                    else
                                                        temp_name15=`echo "$old_name" | awk -F . '{print $15}'`
                                                        if [ -z $temp_name15 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10.11.12.13.14
                                                        then
                                                            suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10.$temp_name11.$temp_name12.$temp_name13.$temp_name14
                                                            new_name="$prefix_name-$mod_time.$suffix_name"
                                                            echo "new_name: $new_name"
                                                        else
                                                            temp_name16=`echo "$old_name" | awk -F . '{print $16}'`
                                                            if [ -z $temp_name16 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10.11.12.13.14.15
                                                            then
                                                                suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10.$temp_name11.$temp_name12.$temp_name13.$temp_name14.$temp_name15
                                                                new_name="$prefix_name-$mod_time.$suffix_name"
                                                                echo "new_name: $new_name"
                                                            else
                                                                temp_name17=`echo "$old_name" | awk -F . '{print $17}'`
                                                                if [ -z $temp_name17 ] ;        #filename.tar.gz.xz.zip.rar.01.08.09.10.11.12.13.14.15.16
                                                                then
                                                                    suffix_name=$suffix_name.$temp_name3.$temp_name4.$temp_name5.$temp_name6.$temp_name7.$temp_name8.$temp_name9.$temp_name10.$temp_name11.$temp_name12.$temp_name13.$temp_name14.$temp_name15.$temp_name16
                                                                    new_name="$prefix_name-$mod_time.$suffix_name"
                                                                    echo "new_name: $new_name"
                                                                fi
                                                            fi
                                                        fi
                                                    fi
                                                fi
                                            fi
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi

###################################################################

    cp  $old_name  $new_name
    echo "$curr_mod_time" > backup.log
    return 0;
}


#command format check: docbackup.sh  dstfile
if [ $UID -ne 0 ] ;
then
    SUDO=sudo
fi

[ -f /usr/bin/docbackup.sh ]
if [ $? -ne 0 ] ;
then
    $SUDO chmod +x docbackup.sh
    $SUDO cp -v docbackup.sh /usr/bin
fi

if [ $# -ne 1 ] ;
then
    echo "Usage: $0 yourfile"
    exit  1
fi



#main function:
if [ -f  $1 ] ;
then
    echo "Getting last modified time ..."
    get_last_mod_time $1
    echo "Getting current modified time ..."
    get_curr_mod_time $1

    mod_filename $1

    write_log
    exit 0

else
    echo "Destination file open error !"
    exit 3
fi


