/**
 * File              : main.c
 * Author            : seafly <seafly0616@qq.com>
 * Date              : 2017.12.09 09时50分59秒
 * Last Modified Date: 2017.12.09 09时54分18秒
 * Last Modified By  : seafly <seafly0616@qq.com>
 */
/**
 * File              : main.c
 * Author            : seafly <seafly0616@qq.com>
 * Date              : 2017.12.09 09时48分11秒
 * Last Modified By  : seafly <seafly0616@qq.com>
 */
#include<stdio.h>
#include"dict.h"
#include <string.h>

static void dict_usage(char *argv)
{
    printf("usage: %-10s %-10s %-16s\n", argv, "word", "--search word");
    printf("usage: %-10s %-10s %-16s\n", argv, "+ word", "--add new word");
    printf("usage: %-10s %-10s %-16s\n", argv, "- word", "--delete word");
    printf("usage: %-10s %-10s %-16s\n", argv, "= word", "--modify word");
}

int main(int argc, char *argv[])
{
    /* win_dict.txt --> linux_dict.txt: cat win_dict.txt | col -b > linux_dict.txt */

    char *dict_lib = "/etc/dict.txt";

	char translate[1024] = {0};

    /* 命令行参数判断 */
    if (argc < 2)
    {
        dict_usage(argv[0]);
        return 1;
    }
    else if (argc == 2)  /* 添加或删除单词 */
    {
        printf("Words: %s\n",argv[1]);
        if (searchword(dict_lib, argv[1], translate, 1024) != 0)
        {
            printf("未找到目标词条...\n");
            return 1;
        }
        printf("Trans: %s",translate);
        return 0;
    }
    else
    {

        if ((strcmp(argv[1],"+")==0)||(strcmp(argv[1],"add")==0))
        {
            add_word(dict_lib, argv[2]);
            return 0;
        }
        else if ((strcmp(argv[1],"-")==0)||(strcmp(argv[1],"del")==0))
        {
            del_word(dict_lib, argv[2]);
            return 0;
        }
        else if ((strcmp(argv[1],"=")==0)||(strcmp(argv[1],"mod")==0))
        {
            mod_word(dict_lib, argv[2]);
            return 0;
        }
        else
        {
            dict_usage(argv[0]);
            return 1;
        }
    }
    return 0;
}

