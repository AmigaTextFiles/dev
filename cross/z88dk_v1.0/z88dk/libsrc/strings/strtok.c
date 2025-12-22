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

/*
 *      WARNING! This function has a static in it - no longer ROMable!
 */

#pragma proto HDRPRTYPE

extern char *strtok();
extern char *strspn();
extern char *strcspn();

#pragma unproto HDRPRTYPE

#asm
        LIB     strchr
        LIB     strspn
        LIB     strcspn
#endasm


#define NULL 0


strtok(unsigned char *s1,unsigned char *s2)
{
  static unsigned char *t;
  if(s1!=NULL)
    t=s1;
  else
    s1=t;
  s1+=strspn(s1,s2);
  if(*s1=='\0')
    return NULL;
  t=s1;
  t+=strcspn(s1,s2);
  if(*t!='\0')
    *t++='\0';
  return s1;
}
  
