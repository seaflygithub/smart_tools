
#ifndef _unlock_h_
#define _unlock_h_

#define MAGIC	0x60

typedef struct _lock
{
    char	password[32];
    char	id[32];
} LOCK;

#endif


