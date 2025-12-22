/*
 *      Small C+ String Library
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */

/*
 *      A little black magic..
 */

#pragma proto HDRPRTYPE

extern int strspn();
extern char *strchr();

#pragma unproto HDRPRTYPE

#asm
        LIB     strchr
#endasm


strspn(unsigned char *s1,unsigned char *s2)
{
    int n;
    n=0;
    while(*s1&&strchr(s2,*s1++)) n++;
    return(n);
}
