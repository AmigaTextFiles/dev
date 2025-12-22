/*
 *      Small C+ String Library
 *
 *      strchr - search for character in string
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */

/*
 *      A little black magic..
 */

#pragma proto HDRPRTYPE

extern char *strchr();

#pragma unproto HDRPRTYPE



strchr(unsigned char *s,unsigned char c)
{
    while(*s) if(*s==c) return(s); else s++;
    return(0);
}
