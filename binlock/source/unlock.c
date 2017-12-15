
/*
 * copyright (c) seafly 2016/06/28 1989291498@qq.com
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "strnum.h"
#include "lock.h"
#include "contents.h"
#include <unistd.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>

//sequence:
// 检查文件是否存在
// 根据用户输入密码 inpass[32]
// (先核对密码是否正确)
// 先读出文件头部结构体lock2
// 解密密码
// 判断两个结构体中的密码是否相同
// 正确
//
// 从文件尾部读取512字节数据存入head512结构中
// 将文件截断到尾部512字节处
// 将head512中的数据写入文件头512字节
// 紧接着解密接下来的数据块
// 退出程序
//
// 错误
//输入身份证号码来打开文件
//将输入的号码填充至结构体1

//对比结构体1 和 结构体2 中的号码是否相等
// 解密帐号

// 正确
// 直接解密文件
// 从文件尾部读取512字节数据存入head512结构中
// 将文件截断到尾部512字节处
// 将head512中的数据写入文件头512字节
// 紧接着解密接下来的数据块

// 截去文件尾部512字节数据
//
// 错误
// 提示用户输入ID错误并退出程序

extern int filename_prefix_del(char *filename, char *prefix);

int main (int argc, char *argv[])
{
    // usage: prog dstfile
    if (argc != 2)
    {
        fprintf (stderr, "usage: %s %s\n", argv[0], "<dst_file>");
        return -1;
    }


    // 检查文件是否存在
    FILE	*fp = NULL;
    char	*dstfile = argv[1];
    fp = fopen (dstfile, "r");
    if (fp == NULL)
    {
        fprintf (stderr, "Error: %s open error\n", argv[1]);
        exit (-1);
    }
    fclose (fp);

    // 根据用户输入密码 inpass[32]
    LOCK	lock;
    int		locksize = sizeof(lock);

    memset (lock.password, 0, sizeof(lock.password));
    memset (lock.id, 0, sizeof(lock.id));

    printf ("Please Input Password: ");
    scanf ("%s", lock.password);
    // (先核对密码是否正确)
    // 先读出文件头部结构体lock2
    LOCK	lock2;


    memset (lock2.password, 0, sizeof(lock2.password));
    memset (lock2.id, 0, sizeof(lock2.id));

    fp = fopen (dstfile, "r");
    fseek (fp, 0, SEEK_SET);
    fread (&lock2, locksize, 1, fp);
    fclose (fp);

    // 解密密码
    strcpy(lock2.password,\
            strnum (lock2.password, sizeof(lock2.password), MAGIC));

    // 判断两个结构体中的密码是否相同
    if (strcmp(lock.password, lock2.password)==0)
        // 正确
    {


        // 从文件尾部读取512字节数据存入head512结构中
        HEAD512		head512;

        fp = fopen (dstfile, "r");
        fseek (fp, -512, SEEK_END);
        fread (&head512, sizeof(head512), 1, fp);
        fclose (fp);
        // 截断文件至尾部512字节处
        int 	fd = 0;
        long	fsize = 0;
        fp = fopen (dstfile, "r");
        fseek (fp, 0, SEEK_END);
        fsize = ftell (fp);
        fclose (fp);

        fd = open (dstfile, O_RDWR);
        fsize -= 512;
        fd = ftruncate (fd, fsize);
        if (fd != 0)
        {
            fprintf (stderr, "Error: %s\n", "ftruncate returns -1");
            close (fd);
            return -1;
        }
        close (fd);
        // 将head512中的数据写入文件头512字节
        fp = fopen (dstfile, "r+");
        fseek (fp, 0, SEEK_SET);
        fwrite (&head512, sizeof(head512), 1, fp);
        fclose (fp);

        // 紧接着解密接下来的4032B数据块
        contents (dstfile);
        // 截去文件尾部512字节数据
        if ((strstr(dstfile,"blv2-") != NULL))
        {
            filename_prefix_del(dstfile, "blv2-");
        }

        if ((strstr(dstfile,"binv2-") != NULL))
        {
            filename_prefix_del(dstfile, "binv2-");
        }

        printf ("file unlocked successfully!\n");
        // 退出程序
    }

    //
    // 错误
    else
    {
        //输入身份证号码来打开文件
        //将输入的号码填充至结构体1
        printf ("Password: error\n");
        printf ("Enter Your ID-card-Number:");
        scanf ("%s", lock.id);
        //对比结构体1 和 结构体2 中的号码是否相等
        // 解密帐号
        strcpy(lock2.id,\
                strnum (lock2.id, sizeof(lock2.id), MAGIC));
        if (strcmp(lock.id, lock2.id)==0)
        {
            // 正确
            // 直接解密文件


            // 从文件尾部读取512字节数据存入head512结构中
            HEAD512		head512;

            fp = fopen (dstfile, "r");
            fseek (fp, -512, SEEK_END);
            fread (&head512, sizeof(head512), 1, fp);
            fclose (fp);
            // 将head512中的数据写入文件头512字节
            fp = fopen (dstfile, "r+");
            fseek (fp, 0, SEEK_SET);
            fwrite (&head512, sizeof(head512), 1, fp);
            fclose (fp);

            // 截去文件尾部512字节数据
            int 	fd = 0;
            long	fsize = 0;
            fp = fopen (dstfile, "r");
            fseek (fp, 0, SEEK_END);
            fsize = ftell (fp);
            fclose (fp);

            fd = open (dstfile, O_RDWR);
            fsize -= 512;
            fd = ftruncate (fd, fsize);
            if (fd != 0)
            {
                fprintf (stderr, "Error: %s\n", "ftruncate returns -1");
                close (fd);
                exit (-1);
            }
            close (fd);


            // 紧接着解密接下来的4032B数据块
            contents (dstfile);

            // rename filename
            if ((strstr(dstfile,"blv2-") != NULL))
            {
                filename_prefix_del(dstfile, "blv2-");
            }

            if ((strstr(dstfile,"binv2-") != NULL))
            {
                filename_prefix_del(dstfile, "binv2-");
            }
            printf ("file unlocked successfully!\n");

            return 0;
            ;
        }
        else
        {
            // 错误
            // 提示用户输入ID错误并退出程序
            printf ("ID-Card-Number: error\n");
            printf ("Program Terminaled\n");
            return -1;
        }

    }

    return 0;
}

extern int filename_prefix_del(char *filename, char *prefix)
{
    char *newname = filename;
    char cmd_line[1024] = {0};

    while(*newname != '-')
    {
        newname++;
    }
    newname++;

    strcat(cmd_line, "mv ");
    strcat(cmd_line, "-v ");
    strcat(cmd_line, filename);
    strcat(cmd_line, " ");
    strcat(cmd_line, newname);
    printf("cmd_line:%s\n", cmd_line);
    system(cmd_line);
    return 0;
}
