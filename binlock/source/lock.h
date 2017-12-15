#ifndef _lock_h_
#define _lock_h_

#define MAGIC 0x60     //following code version !!!
#define CONTSIZE 4032  //following code version !!!
//#define BITSIZE 0x6    //following code version !!!

typedef struct _lock
{
    char password[256];
    char id[256];
} LOCK;

typedef struct _head512
{
    char buf512[512];
} HEAD512;

#endif

