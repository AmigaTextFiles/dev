-> string and unixish routines for Estrings (strdup also handles BSTRs)
-> like those seen in <stdlib.h> and <string.h>
-> also include module '*clr' if using calloc()

OPT PREPROCESS
OPT MODULE
OPT EXPORT

MODULE 'dos/dos'

RAISE "MEM" IF String()=NIL
CONST BSTR=TRUE

#define calloc(a,b)    clr(String(Mul(a,b)),Mul(a,b))
#define free(p)        DisposeLink(p)
#define malloc(s)      String(s)
#define memcmp(p,f,s)  OstrCmp(p,f,s)
#define memcpy(p,f,s)  AstrCopy(p,f,s)
#define realloc(p,s)   StrCopy(String(s),p)
#define strcat(p,f)    StrAdd(p,f)
#define strcmp(p,f)    OstrCmp(p,f)
#define strcpy(p,f)    StrCopy(p,f)
#define strlen(p)      EstrLen(p)
#define strncat(p,f,s) StrAdd(p,f,s)
#define strncmp(p,f,s) OstrCmp(p,f,s)
#define strncpy(p,f,s) StrCopy(p,f,s)

PROC strdup(str,is_bstr=FALSE)
  DEF bptr, len
  len := IF is_bstr THEN Char(bptr:=BADDR(str)) ELSE StrLen(str)
ENDPROC StrCopy(String(len), IF is_bstr THEN bptr+1 ELSE str, len)
