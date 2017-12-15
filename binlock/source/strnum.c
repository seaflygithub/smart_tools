
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "strnum.h"
/*
 * str: abcdefghijk... (size)
 * num: 66666666666...
 */
extern char *strnum (char *str, const int size, const int num)
{
    char	*ret = str;
    int 	i = 0;

    if (ret == NULL)
    {
        printf ("strnum return NULL\n");
        return NULL;;
    }

    while (i < size)
    {
        *ret = (*ret ^ num);
        ret++;
        i++;
    }

    ret = str;
    return ret;
}
