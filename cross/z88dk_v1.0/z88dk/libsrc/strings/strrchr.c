/*
 *      Small C+ String Library
 *
 *      strrchr - search for character in string (backwards)
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */

/*
 *      A little black magic..
 */

#pragma proto HDRPRTYPE

extern char *strrchr();

#pragma unproto HDRPRTYPE



strrchr(unsigned char *s,unsigned char c)
{
    unsigned char *p;
    p=0;
    while(*s){
        if(*s==c) p=s;
        s++;
    }
    return(p);
}
