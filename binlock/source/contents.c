
// dstfile size : 500MB~1GB
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "contents.h"
#include "strnum.h"
#include "lock.h"

extern int contents (const char *path)
{
    if (path == NULL)
    {
        printf ("Error: contents(): path == NULL\n");
        return -1;
    }

    enum {M200 = 102400, M10 = 1024, M100 = 10240, M500 = 102400};

    char	content[M500] = {0}; // 100KB (500MB)
/*
    char	content512b[512] = {0}; // 1KB       (10MB)
    char	content1k[1024] = {0}; // 1KB        (50MB)
    char	content10k[10240] = {0}; // 10KB     (100MB)
    char	content50k[51200] = {0}; // 50KB     (<500MB)
    char	content100k[102400] = {0}; // 100KB  (500MB)
    char	content1m[1048576] = {0}; // 1MB     (1GB)
    char	content10m[10485760] = {0}; // 10MB  (10GB)
*/

    char	dstfile[512] = {0};
    FILE	*fp = NULL;
    double	total = 0;
    double	curre = 0;

    strcpy (dstfile, path);
    fp = fopen (dstfile, "r+");

    fseek (fp, 0, SEEK_END);
    total = (double)ftell (fp);


    fseek (fp, 512, SEEK_SET);  //定位到512字节处

// total = ftell (fp);
// curre = ftell (fp);
// curre/total * 100 = mm
    while (fread (content, sizeof(content), 1, fp)!=0)
    {
        strcpy (content, \
            strnum (content, sizeof(content), MAGIC));
        fseek (fp, -sizeof(content), SEEK_CUR);
        fwrite (content, sizeof(content), 1, fp);
        memset (content, 0, sizeof(content));

        printf ("Finished: %%");
        curre = (double)ftell (fp);
        printf ("%3.2lf", (curre/total)*100);
        printf ("\r");
    }
        fseek (fp, 0, SEEK_END);
        curre = (double)ftell (fp);

        printf ("Finished: %%"); // print "Finished: %100.00
        printf ("%3.2lf", (curre/total)*100);
        printf ("\r");
        printf ("\n");

    fclose (fp);
    return 0;
}

