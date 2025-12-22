/* Prototypes for functions defined in
test.c
 */


#ifndef __NOPROTO

#ifndef __PROTO
#define __PROTO(a) a
#endif

#else
#ifndef __PROTO
#define __PROTO(a) ()

#endif
#endif


int func __PROTO((int ));

extern int globa;

extern int globb;

extern int globc;

int main __PROTO((int , char ** ));

