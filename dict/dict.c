/**
 * File              : dict.c
 * Author            : seafly <seafly0616@qq.com>
 * Date              : 2017.12.09 09时47分32秒
 * Last Modified Date: 2017.12.09 09时49分47秒
 * Last Modified By  : seafly <seafly0616@qq.com>
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dict.h"

extern int  add_word(char *path, char *input)
{
    if(NULL == input)
        return -1;
    char word[512] = {0};
    char sense[512] = {0};
    char translate[1024] = {0};

    /* 构造单词信息 */
    strcat(word,"#");
    strcat(word,input);
    strcat(word,"\n");
    strcat(translate, "Trans:");
    printf("请输入词条释义: ");
    //fgets(sense, sizeof(sense), stdin);
    scanf("%s", sense);
    strcat(translate, sense);
    strcat(translate, "\n");

    /* 打开文件并定位到文件尾部 */
    FILE *p = fopen(path,"a");//打开文件
    fseek(p, 0, SEEK_END);

    /* 将单词信息追加写入文件尾部 */
    fputs(word, p);
    fputs(translate, p);

    fclose(p);//关闭文件
    return 0;
}

extern int  del_word(char *path, char *input)
{
    FILE *fp_rd = fopen(path,"r");
    FILE *fp_wr = fopen("temp.txt","w+");
    char buf_rd[1024] = {0};
    char match[1024] = {0};
    char choose = 0;
    char flag_find_out = 0;

    while(!feof(fp_rd))	
    {
        /* 读取文件单词 */
        memset(buf_rd, 0, sizeof(buf_rd));
        fgets(buf_rd, sizeof(buf_rd), fp_rd);

        /* 处理单词 */
        memset(match, 0, sizeof(match));
        strcpy(match,buf_rd+1);   //去一个字符#
        *(match+(strlen(buf_rd)-2)) = '\0';   //去换行符

        /* 匹配单词 */
        if(strcmp(match,input) == 0)//表示找到单词，跳过该单词和释义
        {
            /* 再次确认是否删除该单词 */
            flag_find_out = 1;
            printf("已找到目标词条...\n");
            printf("请再次确认是否删除单词(默认不删除)?[Y/N]: ");
            scanf("%c", &choose);
            switch (choose)
            {
                case 'Y':
                case 'y':
                    memset(buf_rd, 0, sizeof(buf_rd));
                    fgets(buf_rd, sizeof(buf_rd), fp_rd);
                    memset(buf_rd, 0, sizeof(buf_rd));
                    fgets(buf_rd, sizeof(buf_rd), fp_rd);
                    break;
                case 'N':
                case 'n':
                    break;
                default:
                    break;
            }
        }
        fputs(buf_rd, fp_wr);
    }

    fclose(fp_rd);
    fclose(fp_wr);

    /* 重新生成词典数据文件 */
    if (flag_find_out==0)
    {
        printf("未找到目标词条...\n");
    }
    if (system("mv temp.txt dict.txt 2>/dev/null 1>/dev/null") < 0)
    {
        system("move temp.txt dict.txt");
    }



    return 0;
}

extern int  mod_word(char *path, char *input)
{
    FILE *fp_rd = fopen(path,"r");
    FILE *fp_wr = fopen("temp.txt","w+");
    char buf_rd[1024] = {0};
    char match[1024] = {0};
    char choose = 0;
    char flag_find_out = 0;

    while(!feof(fp_rd))	
    {
        /* 读取文件单词 */
        memset(buf_rd, 0, sizeof(buf_rd));
        fgets(buf_rd, sizeof(buf_rd), fp_rd);

        /* 处理单词 */
        memset(match, 0, sizeof(match));
        strcpy(match,buf_rd+1);   //去一个字符#
        *(match+(strlen(buf_rd)-2)) = '\0';   //去换行符

        /* 匹配单词: 删除单词和释义 */
        if(strcmp(match,input) == 0)//表示找到单词，跳过该单词和释义
        {
            /* 再次确认是否修改该单词 */
            flag_find_out = 1;
            printf("已找到目标词条...\n");
            printf("请再次确认是否修改该单词(默认不修改)?[Y/N]: ");
            scanf("%c", &choose);
            switch (choose)
            {
                case 'Y':
                case 'y':
                    /* 先删除旧的单词 */
                    /* 再在文件结尾追加新词 */
                    memset(buf_rd, 0, sizeof(buf_rd));
                    fgets(buf_rd, sizeof(buf_rd), fp_rd);
                    memset(buf_rd, 0, sizeof(buf_rd));
                    fgets(buf_rd, sizeof(buf_rd), fp_rd);
                    break;
                case 'N':
                case 'n':
                    break;
                default:
                    break;
            }

        }
        fputs(buf_rd, fp_wr);
    }

    fclose(fp_rd);
    fclose(fp_wr);

    /* 再在文件结尾追加新词 */
    if (flag_find_out==0)
    {
        printf("未找到目标词条...\n");
    }
    add_word("temp.txt", input);

    /* 重新生成词典数据文件 */
    if (system("mv temp.txt dict.txt 2>/dev/null 1>/dev/null") < 0)
    {
        system("move temp.txt dict.txt");
    }

    return 0;
}

//找翻译函数
extern int searchword(char *path, char *input, char *output, int osize)
{   
    char buf[1024] = {0};
    //char *output = (char *)malloc(1024);

    FILE *p = fopen(path,"r");//打开文件

    while(!feof(p))	
    {
        /* 获取单词 */
        memset(buf,0,sizeof(buf));
        fgets(buf,sizeof(buf),p);

        /* 处理单词 */
        strcpy(output,buf+1);   //去一个字符#
        *(output+(strlen(buf)-2)) = '\0';   //去换行符

        /* 匹配单词 */
        if(strcmp(input,output) == 0)//表示找到单词
        {
            memset(buf,0,sizeof(buf));
            fgets(buf,sizeof(buf),p);//读出翻译到buf
            strcpy(output,buf+6);
            fclose(p);//关闭文件
            return 0;
        }  
    }
    //printf("文件读取完毕: %ld字节\n", ftell(p));
    fclose(p);//关闭文件
    return 1;
}
