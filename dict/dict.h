/**
 * File              : dict.h
 * Author            : seafly <seafly0616@qq.com>
 * Date              : 2017.12.09 09时47分59秒
 * Last Modified Date: 2017.12.09 09时49分47秒
 * Last Modified By  : seafly <seafly0616@qq.com>
 */
#ifndef  DICT_H
#define  DICT_H

extern int  searchword(char *path, char *input, char *output, int osize);
extern int  add_word(char *path, char *input);
extern int  del_word(char *path, char *input);
extern int  mod_word(char *path, char *input);

#endif  // DICT_H

