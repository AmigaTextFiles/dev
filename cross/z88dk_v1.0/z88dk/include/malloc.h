#ifndef MALLOC_H
#define MALLOC_H


/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

/*
 * Heapsize is a macro which will create a heap of size bp
 */

#define HEAPSIZE(bp)    unsigned char heap[bp];

#pragma proto HDRPRTYPE 

extern void *calloc(int,int); 
extern void *malloc(int);
extern void free(void *);
extern int getfree();
extern int getlarge();
extern void heapinit(int);

#pragma unproto HDRPRTYPE 


#endif
