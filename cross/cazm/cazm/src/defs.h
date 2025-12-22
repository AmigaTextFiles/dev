#include <stdio.h>
#include <string.h>
#include <assert.h>

#include <sys/types.h>

#include <stdlib.h>
#include <ctype.h>
#include <signal.h>

#include <stdarg.h>

#ifndef FILENAME_MAX
# define FILENAME_MAX 64
#endif

#ifndef SEEK_SET
# define SEEK_SET 0
#endif

typedef int BOOL;

/* sys/types
typedef unsigned long u_long;
typedef unsigned short u_short;
typedef unsigned char u_char;
*/

#include "caz.h"

#define INTERNAL_ERROR fprintf(stderr,"%s:%d Program Error\n",__FILE__,__LINE__);

int strtoint(struct listheader *plabel,char *pstr,u_short *pshort,int mode);
int calcexpr(struct listheader *plabel,char *expr,u_short *pshort);
struct labelitem *getlabel(struct listheader *plabel,char *name);
