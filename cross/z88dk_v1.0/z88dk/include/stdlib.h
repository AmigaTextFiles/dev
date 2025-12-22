#ifndef STDLIB_H
#define STDLIB_H


/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE 

extern abs(int);
extern long labs(long);
extern atexit();
extern exit();          /* Now its found its true home! */

/* Non standard stdlib.h defs */

extern sleep(int);
extern mkdir(char *);
extern char *getcwd(char *buf, int maxlen);     /* link with -ls */

extern csleep(int);        /* Very non standard! sleep for centisecs! */

#pragma unproto HDRPRTYPE 


#endif
