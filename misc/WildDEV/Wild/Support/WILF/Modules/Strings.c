#ifndef FALSE
#define FALSE	0
#endif
#ifndef TRUE
#define TRUE	1
#endif

#include <exec/types.h>

ULONG ChkIn(char *a,char *in)
{
 while (in[0]!=0)
  {
   if (a[0]!=in[0]) return(FALSE);
   a++;
   in++;
  }
 return(TRUE);
}

ULONG *NextWord(char *b)
{
 while (b[0]!=9 & b[0]!=32 & b[0]!=0 & b[0]!=10)
  {
   b++;
  } 
 while (b[0]==9 | b[0]==32)				// skip spaces after word!
  {
   b++;
  }
 return(b);
}

ULONG CopyWord(char *fill,char *word)
{
 int n=NULL;
 while (word[0]!=9 & word[0]!=32 & word[0]!=0 & word[0]!=10)
  {
   fill[0]=word[0];
   fill++;
   word++;
   n++;
  }
 fill[0]=0L;
 return(n);
}

ULONG CopyStr(char *fill,char *from)
{
 int n=NULL;
 while (from[0]!=0)
  {
   fill[0]=from[0];
   fill++;
   from++;
   n++;
  }
 fill[0]=0L;
 return(n);
}

ULONG StrLen(char *str)
{
 int n=NULL;
 while (str[0]!=0 & str[0]!=10)
  {
   str++;
   n++;
  }
 return(n); 
}

ULONG StrCmp(char *a,char *b)
{
 while (a[0]!=0 & b[0]!=0 & a[0]!=10 & b[0]!=10)
  {
   if (a[0]!=b[0])
    {return(FALSE);}
   a++;
   b++;
  }
 return(TRUE);
}