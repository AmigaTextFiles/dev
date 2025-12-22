/*
 *      Small C+ Library
 *
 *      More Memory Functions
 *
 *      Added to Small C+ 12/3/99 djm
 *
 *      This one is writ by me!
 *
 *
 *      void *calloc(int num, int size_of_type)
 *
 *      Allocate memory for num*size and clear it (set to 0)
 */

/* Some black magic.. */


#pragma proto HDRPRTYPE
extern void *calloc(int, int);
extern void *malloc(int);
extern void clrmem(void *, int);
#pragma unproto HDRPRTYPE

#asm
                LIB     malloc
                LIB     clrmem
#endasm


void *calloc(int num, int size)
{
        void *ptr;
        int  tsize;

        tsize=size*num;

        if ( (ptr=malloc(tsize) ) ) {
                clrmem(ptr,tsize);
        }
        return (ptr);
}


