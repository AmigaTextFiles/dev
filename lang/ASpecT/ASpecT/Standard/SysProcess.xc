#include <sys/signal.h>

void
DEFUN(xx_SysProcessexist_0,(pid,sysi,res,syso),
      TERM pid  AND
      TERM sysi AND
      TERM *res AND
      TERM *syso)
 { extern int EXFUN(kill,(int,int));
   int errno;
   *syso= sysi;
   errno=kill((int)pid,0);
   if(errno!=0) *res=false; else *res=true; 
 }
 
void
DEFUN(xx_SysProcessfork_0,(sysi,res,syso),
      TERM sysi AND
      TERM *res AND
      TERM *syso)
 { extern int EXFUN(fork,(void));
   *syso= sysi;
   *res=(TERM)fork();
 }
 

TERM
DEFUN(xx_SysProcessexec_0,(FN,ARG,sysi),
      TERM FN   AND
      TERM ARG  AND
      TERM sysi)
{
  extern char * EXFUN(malloc,(unsigned));
#ifdef NEED_STD_DECL
  extern void EXFUN(free,(char *));
#endif
  char *FNC;
  char *ARGC;
  unsigned FLEN=(unsigned)Stringlength_0(CP(FN));
  unsigned ALEN=(unsigned)Stringlength_0(CP(ARG));
  int rv;
  extern int EXFUN(execlp,(char *,char *,char *,char *));
  extern void EXFUN(exit,(unsigned));
  FNC=malloc(FLEN+1);
  ARGC=malloc(ALEN+1);
  STRING_TERM_to_CHAR_ARRAY(FN,FLEN,FNC);
  STRING_TERM_to_CHAR_ARRAY(ARG,ALEN,ARGC);
  rv = execlp(FNC,FNC,ARGC,(char *) 0);
  free(FNC);
  free(ARGC);
  exit(0); /* just finishup dispite a possible crash */
}

XINITIALIZE(SysProcess_Xinitialize,__XINIT_SysProcess)

