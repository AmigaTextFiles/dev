void DEFUN(xx_SysShellcall_arguments_0,(SysI,Res,SysO),
           TERM SysI AND
           TERM *Res AND
           TERM *SysO)
{
  *Res = (TERM)((unsigned)_RUNTIME_argc-1);
  *SysO = SysI;
}


void DEFUN(xx_SysShellcall_argument_0,(Arg,SysI,Res,SysO),
           TERM Arg  AND
           TERM SysI AND
           TERM *Res AND
           TERM *SysO)
{
  if(((unsigned)Arg < 1) || 
     ((unsigned)Arg > ((unsigned)_RUNTIME_argc-1))) {
    *Res = MT;
  } else {
    *Res = _RUNTIME_mk0STRING(_RUNTIME_argv[(unsigned)Arg]);
  }
  *SysO = SysI;
}


void DEFUN(xx_SysShellcall_name_0,(SysI,Res,SysO),
           TERM SysI AND
           TERM *Res AND
           TERM *SysO)
{
  *Res = _RUNTIME_mk0STRING(_RUNTIME_argv[0]);
  *SysO = SysI;
}


void
DEFUN(xx_SysShellgetenv_0,(STR,sysi,BOOL,SOUT,syso),
      TERM STR   AND
      TERM sysi  AND
      TERM *BOOL AND
      TERM *SOUT AND
      TERM *syso)
{ char *FNC,*ENV; unsigned LEN=(unsigned)Stringlength_0(CP(STR));
  extern char * EXFUN(malloc,(unsigned));
  extern char * EXFUN(getenv,(char *));
#ifdef NEED_STD_DECL
  extern void EXFUN(free,(char *));
#endif
  FNC=malloc(LEN+1);
  *syso=sysi;
  *BOOL=false;
  if (FNC == NULL) {
    *SOUT=MT;
  }
  else {
    STRING_TERM_to_CHAR_ARRAY(STR,LEN,FNC);
    ENV=getenv(FNC);
    if(ENV==NULL)
      *SOUT=MT;
    else {
      *SOUT=_RUNTIME_mk0STRING(ENV);
      *BOOL=true;
    }
    free(FNC);
  }
  free__RUNTIME_string(STR);
}


TERM
DEFUN(xx_SysShellset_returnvalue_0,(VAL,sysi),
      TERM VAL AND
      TERM sysi)
{
    _RUNTIME_exval = (unsigned) VAL;
    return sysi;
}


void
DEFUN(xx_SysShellexecute_0,(STR,sysi,BOOL,INT,syso),
      TERM STR   AND
      TERM sysi  AND
      TERM *BOOL AND
      TERM *INT  AND
      TERM *syso)
{ char *FNC; unsigned LEN=(unsigned)Stringlength_0(CP(STR));
  extern char * EXFUN(malloc,(unsigned));
  extern int EXFUN(system,(char *));
#ifdef NEED_STD_DECL
  extern void EXFUN(free,(char *));
#endif
  FNC=malloc(LEN+1);
  *syso= sysi;
  if (FNC == NULL) {
    *BOOL=false;
    *INT=(TERM)255;
  }
  else {
    STRING_TERM_to_CHAR_ARRAY(STR,LEN,FNC);
    *INT=(TERM)system(FNC);
    free(FNC);
    *BOOL=(TERM)(*INT==(TERM)0);
  }
  free__RUNTIME_string(STR);
}


#include <sys/param.h>

void
DEFUN(xx_SysShellgetwd_0,(sysi,ok,pw,syso),
      TERM sysi  AND
      TERM *ok   AND
      TERM *pw   AND
      TERM *syso)
 {
  extern char * EXFUN(malloc,(unsigned));
  char *pn = malloc(MAXPATHLEN);
  *syso = sysi;
  if ((char *)getwd(pn)==NULL) {
    *ok=false;
    *pw=MT;
  } else {
    *ok=true;
    *pw=_RUNTIME_mk1STRING(strlen(pn),pn,MT);
  }
 }

XINITIALIZE(SysShell_Xinitialize,__XINIT_SysShell)
