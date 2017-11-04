/*
 * main.c
 * Copyright (c) 2017 seafly_dennis <seafly0616@qq.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>

void secret_buf (char *buf, int nr, char *key)
{
    if (buf == NULL || key == NULL || nr < 0)
    {
        printf ("Error: buf == NULL || key == NULL");
        exit (2);
    }

    int i = 0;
    char    *key_start = key;
    int     key_len = strlen(key);

    i = 0;
    while (i < nr)  // !!!!!!!! while (buf[i] != 0) :error
    {
        buf[i] ^= *key;
        key++;
        i++;
        if ((i % key_len) == 0) 
            key = key_start;
    }                                           //pass:i, buf[i]

    return ;
}

void transform (char *src, char *dst, char *key)
{
    if (src == NULL || dst == NULL || key == NULL)
    {
        printf ("src == NULL || dst == NULL || key == NULL\n");
        exit (1);
    }

    int ifd = 0;
    int ofd = 0;
    int nr = 0;
    char    buf[4096] = {0};        //4KB speed

    ifd = open (src, O_RDONLY);
    ofd = open (dst, O_RDWR|O_APPEND|O_CREAT, 0644); //rwxrw-rw-

    nr = read (ifd, &buf[0], sizeof(buf));
    while (nr > 0)  //pass: buf, len
    {
        secret_buf (buf, nr, key);
        write(ofd, &buf[0], nr);
        lseek (ifd, 0, SEEK_CUR);
        lseek (ofd, 0, SEEK_CUR);
        memset (buf, 0, sizeof(buf));
        nr = 0;
        nr = read(ifd,&buf[0],sizeof(buf));  //pass: buf, len
    }

    close (ifd);
    close (ofd);
    return ;
}

int main(int argc, char *argv[])
{ 
/* use the function */
    transform (argv[1], argv[2], argv[3]);//src dst key
    printf ("\nSuccess: The file that you have handled successfully!\n");
	return 0;
}

