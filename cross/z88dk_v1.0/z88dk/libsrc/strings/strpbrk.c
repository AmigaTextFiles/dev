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

extern char *strpbrk();
extern char *strchr();

#pragma unproto HDRPRTYPE

#asm
        LIB     strchr
#endasm



strpbrk(unsigned char *s1,unsigned char *s2)
{
    while(*s1) if(strchr(s2,*s1)) return(s1); else s1++;
    return(0);
}
