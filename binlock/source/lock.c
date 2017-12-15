
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lock.h"
#include "strnum.h"
#include "contents.h"

//sequence:
// 读入目标文件，密码，ID
// 填充LOCK结构体
// 加密结构体中的密码和ID
// 打开文件并读取头64B内容存入结构体head512中
// 将密码和ID结构体写入文件头部
// 将结构体head512的内容写到{dstfile}.bin中
// 紧接着把文件头512B之后的内容+ 魔数加密


//sequence:
// 读入目标文件，密码，ID
// 填充LOCK结构体
// 加密结构体中的密码和ID
// 打开文件并读取头64B内容存入结构体head512中
// 将密码和ID结构体写入文件头部
//
// 紧接着把文件头512B之后的内容+ 魔数加密
// 将结构体head512的内容追加到目标文件尾部

extern int filename_prefix_add(char *filename, char *prefix);

int main(int argc, char *argv[])
{
// usage: prog dstfile password ID
    if (argc != 4)
    {
        fprintf (stderr, "usage: %s %s %s %s\n", \
        argv[0], "<src_file>", "<password>", "<ID>");
        exit (-1);
    }  ////////////////////////////////////////////////////////////pass!

// 读入目标文件，密码，ID
// 填充LOCK结构体
    char	dstfile[32] = {0};
    LOCK	lock;

    memset (lock.password, 0, sizeof(lock.password));
    memset (lock.id, 0, sizeof(lock.id));

    strcpy (dstfile, argv[1]);
    strcpy (lock.password, argv[2]);
    strcpy (lock.id, argv[3]);

// 加密结构体中的密码和ID
strcpy(lock.password,\
    strnum (lock.password, sizeof(lock.password), MAGIC));
strcpy(lock.id,\
    strnum (lock.id, sizeof(lock.id), MAGIC));

// 打开文件并读取头64B内容存入结构体head512中
    FILE	*fp = NULL;
    HEAD512	head512;

    memset (head512.buf512, 0, sizeof(head512.buf512));

    fp = fopen (dstfile, "r");
    fseek (fp, 0, SEEK_SET);
    fread (&head512, sizeof(head512), 1, fp);
    fclose (fp);

// 将加密后的密码和ID结构体写入文件头部
    fp = fopen (dstfile, "r+");
    fseek (fp, 0, SEEK_SET);
    fwrite (&lock, sizeof(lock), 1, fp);
    fclose (fp);

// 紧接着把文件头512B之后的内容+ 魔数加密
    contents (dstfile);
// 将结构体head512的内容追加到目标文件尾部
    fp = fopen (dstfile, "a");

    fseek (fp, 0, SEEK_END);
    fwrite (&head512, sizeof(head512), 1, fp);
    fclose (fp);

    if ((strstr(dstfile,"blv2-") == NULL))
    {
        filename_prefix_add(dstfile, "blv2-");
    }

    if ((strstr(dstfile,"binv2-") == NULL))
    {
        filename_prefix_add(dstfile, "binv2-");
    }
    printf ("file locked successfully!\n");

    return 0;
}

extern int filename_prefix_add(char *filename, char *prefix)
{
    const int new_len = strlen(filename) + strlen(prefix) + 1; //abc123.mp4 --> blv2-abc123.mp4
    char *newname = (char *)malloc(new_len);
    char cmd_line[1024] = {0};

    memset(newname, 0, new_len);

    //generic newname
    strcat(newname, prefix);
    strcat(newname, filename);

    strcat(cmd_line, "mv ");
    strcat(cmd_line, "-v ");
    strcat(cmd_line, filename);
    strcat(cmd_line, " ");
    strcat(cmd_line, newname);
    printf("cmd_line:%s\n", cmd_line);
    system(cmd_line);
    return 0;
}

