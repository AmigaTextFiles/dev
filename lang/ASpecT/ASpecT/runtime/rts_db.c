/*============================================================================*/
/* The Runtime Library 1.2 for ASpecT_to_C_Compiler                           */
/*=DEBUGGER-PACK==============================================================*/

#define VERSION "ASpecT V2.0   Runtime Debugger V2.01 92/06/23\n\n"

#define DEBUG
#define NO_TIME_IMPORT
#include <runtime.h>

unsigned D_WRITEDEPTH,/* global variable for writing a term via debugger     */
	 D_LISTMODE,  /* if 1 a list is seen as a flat structure             */
	 D_TCMODE,    /* if 1 the termcount is printed too                   */
	 D_WRITEDEBUG,/* if 1 a term is been printed by debugger             */
	 D_ROW,       /* here's the colum of the current call (set by D_POS) */
	 D_COL,       /* here's the row   of the current call (set by D_POS) */
	 NODBX;       /* used in generated programs to load a textfile       */



  

static 
unsigned D_LEVEL,	/* current call-level */
	 D_SKIP,	/* is a skip active? */
	 D_SPEC_LEAP,	/* is a special-leap active? (leap at init) */
	 D_LEAP,	/* is a leap active? */
	 D_SOURCE_LINE, /* is the source line debugger in action? */
	 D_DEPTH,
	 D_cmd,
	 D_param,
	 D_cmdptr,
	 D_PROMPT,
	 D_p_at_entry;
static
int	 D_int_lev;
static
TERM	 D_AC,
	 D_CC,
	 D_CT;

static SORTRECP D_MASKofCT;
#define D_TYPEofCT (*D_MASKofCT)

#define D_Lv(C) (((unsigned) C->ARGS[3])/4)
#define COPNREC(T) ((OPNREC)T->ARGS[0])
#define GOPNREC(T) ((OPNREC)COPNREC(TOP(T)))
#define  D_isCall(C)   (((unsigned)C->ARGS[3]&1)==0)
#define  D_isReturn(C) (((unsigned)C->ARGS[3]&1)==1)
#define  D_isCR     (D_MASKofCT==(SORTRECP)0)
#define  D_isFN     (D_TYPEofCT==_S_FUNC)
static
char	 D_cmdline[255],
	 D_srtname[255],
	 D_opname[255];

char *D_currfile;	 


#define allargs(o) (o->numargs+o->numres)



/*********************  Stack Operations ***********************************/

#define    MT_STACK (TERM)(MT_TERM)
static
STACK	 D_CALL_STACK,	/* anchestors */
         D_CFILE_STACK,
         D_SORT_STACK,
	 D_LOOK_STACK,
	 D_FILE_STACK,
	 D_BRK_STACK;
STACK    D_OPN_STACK;

#define PUSH(D,L) MK(2,1,D,L)
#define TOP(S)    (S->ARGS[0])
#define SKIP(S)   (S->ARGS[1])

static void
DEFUN(CLEAR,(S),
      STACK *S)
 { TERM H=(*S);
   while (OPN(H)) {
     *S = SKIP(H);
     MDEALLOC(2,H);
     H = *S;
   }
 }

static TERM
DEFUN(POP,(S),
      STACK *S)
 { TERM H,H1=(*S);

   if (OPN(H1)) {
     H = TOP(H1);
     *S = SKIP(H1);
     MDEALLOC(2,H1);
   }
   return H;
 }

#define  PUSH_LOOK_STACK D_LOOK_STACK = PUSH(D_CT,      D_LOOK_STACK);\
                         D_LOOK_STACK = PUSH(D_MASKofCT,D_LOOK_STACK)
                           
#define  POP_LOOK_STACK  D_MASKofCT   = (SORTRECP) POP(&D_LOOK_STACK);\
	                 D_CT         = (TERM)     POP(&D_LOOK_STACK)


void
DEFUN(D_NEW_FILE,(fn),
      char *fn)
  { D_FILE_STACK = PUSH((TERM)fn,D_FILE_STACK); }


/*********************  String Compare Wildcards **************************/

static unsigned
DEFUN(WCSTRCMP,(s,w),
      char *s AND
      char *w)
{ if (*w=='\0') return *s=='\0';
  if (*w==*s) return WCSTRCMP(++s,++w);
  if ((*w=='?') && (*s!='\0'))return WCSTRCMP(++s,++w);
  if (*w=='*') {
    w++;
    while(*w=='*') w++;
    if (*w=='\0') return 1;
    while (*s!='\0') {
      if (WCSTRCMP(s,w))return 1;
      s++;
    }
  }
  return 0;
}

/*********************  Printing of Signatures *****************************/

static SORTRECP
EXFUN(D_print_opnsig_sort,(SORTRECP,unsigned));

static SORTRECP
DEFUN(D_print_opnsig_func,(o,needpar),
      SORTRECP o       AND
      unsigned needpar)
 { if (needpar) printf("(");
   o=D_print_opnsig_sort(o,TRUE);
   printf(" -> ");
   o=D_print_opnsig_sort(o,FALSE);
   if (needpar) printf(")");
   return o;
 }
 
static SORTRECP
DEFUN(D_print_opnsig_comp,(o),
      SORTRECP o)
 { printf("(");
   for (;;){
     o=D_print_opnsig_sort(o,FALSE);
     if (*o==_S_COFF) { printf(")"); return ++o; }
     printf(",");
 }}
 
static SORTRECP
DEFUN(D_print_opnsig_sort,(o,needpar),
      SORTRECP o       AND
      unsigned needpar)
 { if (*o==_S_IR) o++;
     if (*o==_S_CON)        o=D_print_opnsig_comp(++o);
else if (*o==_S_FUNC)       o=D_print_opnsig_func(++o,needpar);
else if (*o==_S_COFF)       ++o;
else if (*o==_S_CONST)      ++o;
else { if ((unsigned)(*o)<20) printf("X%u",-(unsigned)_S_IR+(unsigned)(*o));
       else if ((*o)->numcons == -30000)
                        D_print_opnsig_sort(&(((*o)->consarr[0])->
                               argsarr[((*o)->consarr[0])->numargs]),FALSE);
       else                   printf("%s",(*o)->name); 
       o++;
     }
   return o;
 }
 
static void
DEFUN(D_print_opnsig,(o),
      OPNREC o)
 { printf("%s :: ",o->name);
   D_print_opnsig_sort(&(o->args_arr[allargs(o)]),FALSE);
 }
 
static void
DEFUN(D_print_consig,(sort,term),
      SORTREC sort AND
      TERM term)
 { if (sort->numcons == -30000) {
     CONSREC cr = sort->consarr[0];
     D_print_opnsig_sort(&(cr->argsarr[cr->numargs]),FALSE);
   } else if (sort->numcons >= 0){
     CONSREC cr = sort->consarr[OPN(term)];
     printf("constructor %s :: ",cr->name);
     if (cr->numargs==0) 
       D_print_opnsig_sort(&(sort),FALSE);
     else 
       D_print_opnsig_sort(&(cr->argsarr[cr->numargs]),FALSE);
   } 
   else
     printf("%s",sort->name);
 }
 
 
/*********************  Command Handling of Debugger ************************/

static char D_err_msg[255];

void
DEFUN(errmsg,(msg),
      char *msg)
 { if (D_SOURCE_LINE)
      printf("%c%c%s\n",(char)127,(char)3,msg);
   else
      printf("%s\n",msg);
 }
  

#define D_DELIM ((D_cmdline[D_cmdptr+1]==' ')||(D_cmdline[D_cmdptr+1]=='\0'))

static unsigned
DEFUN_VOID(D_getnum)
 { unsigned ok=0;
   D_param=0;
   while ((D_cmdline[D_cmdptr]>='0') && (D_cmdline[D_cmdptr]<='9'))
     { D_param = D_param*10 + D_cmdline[D_cmdptr] - '0';
       D_cmdptr++;ok++;
     }
   D_cmdptr--;
   if (ok && D_DELIM) { D_cmdptr++; return 1;}
   if (D_param)
     sprintf(D_err_msg,"bad number %u%c... - skipped!\n",
             D_param,D_cmdline[D_cmdptr+1]);
   else
     sprintf(D_err_msg,"bad number %c%c... - skipped!",
             D_cmdline[D_cmdptr],D_cmdline[D_cmdptr+1]);
   errmsg(D_err_msg);
   return 0;
 }

static unsigned
DEFUN_VOID(D_getopn)
  { unsigned i=0;
    if (((D_cmdline[D_cmdptr]>='a') && (D_cmdline[D_cmdptr]<='z')) ||
         (D_cmdline[D_cmdptr]=='?') || (D_cmdline[D_cmdptr]=='*')){
      i=1;
      D_opname[0]=D_cmdline[D_cmdptr++];
      while (((D_cmdline[D_cmdptr]>='a') && (D_cmdline[D_cmdptr]<='z'))||
	     ((D_cmdline[D_cmdptr]>='0') && (D_cmdline[D_cmdptr]<='9'))||
	     (D_cmdline[D_cmdptr]=='_') || 
             (D_cmdline[D_cmdptr]=='?') || (D_cmdline[D_cmdptr]=='*')
            )
	D_opname[i++]=D_cmdline[D_cmdptr++];
      D_opname[i++]='\0';
      D_cmdptr--;
      if (D_DELIM) { D_cmdptr++; return 1;}
      sprintf(D_err_msg,"bad opname :%s%c... - skipped!",
              D_opname,D_cmdline[D_cmdptr]);
      errmsg(D_err_msg);
      return 0;
    }
    sprintf(D_err_msg,"bad opname :%c... - skipped!",
            D_cmdline[D_cmdptr]);
    errmsg(D_err_msg);
    return 0;
  }

static unsigned
DEFUN_VOID(D_getfilespy)
  { unsigned i=1;
    while ((D_cmdline[D_cmdptr]!=':') && (D_cmdline[D_cmdptr]!='\0'))
	D_opname[i++]=D_cmdline[D_cmdptr++];
    D_opname[0]='*';
    D_opname[i++]='\0';
    if(D_cmdline[D_cmdptr]!=':') {
      sprintf(D_err_msg,"bad filespy :%s%c... - skipped!",
              D_opname,D_cmdline[D_cmdptr]);
      errmsg(D_err_msg);
      return 0;
    }
    D_cmdptr++;
    if (!D_getnum()) return 0;
    D_cmdptr--;
    if (D_DELIM) { D_cmdptr++; return 1;}
    sprintf(D_err_msg,"bad filespy :%s%c... - skipped!",
            D_opname,D_cmdline[D_cmdptr]);
    errmsg(D_err_msg);
    return 0;
  }

static unsigned
DEFUN_VOID(D_getsrt)
  { unsigned i=0;
    if ((D_cmdline[D_cmdptr]>='a') && (D_cmdline[D_cmdptr]<='z')){
      i=1;
      D_srtname[0]=D_cmdline[D_cmdptr++];
      while (((D_cmdline[D_cmdptr]>='a') && (D_cmdline[D_cmdptr]<='z'))||
	     ((D_cmdline[D_cmdptr]>='0') && (D_cmdline[D_cmdptr]<='9'))||
	     (D_cmdline[D_cmdptr]=='_') 
            )
	D_srtname[i++]=D_cmdline[D_cmdptr++];
      D_srtname[i++]='\0';
      D_cmdptr--;
      if (D_DELIM) { D_cmdptr++; return 1;}
      sprintf(D_err_msg,"bad sort :%s%c... - skipped!",
              D_srtname,D_cmdline[D_cmdptr]);
      errmsg(D_err_msg);
      return 0;
    }
    sprintf(D_err_msg,"bad sort :%c... - skipped!",
            D_cmdline[D_cmdptr]);
    errmsg(D_err_msg);
    return 0;
  }

#define DP_N(S) if (!D_getnum()) goto D_next;return S
#define DP_O(S) if (!D_getopn()) goto D_next;return S
#define DP_D(S) if (D_DELIM){ D_cmdptr++; return S; }
#define toNext    D_cmdptr++;goto D_parse

static unsigned
DEFUN_VOID(D_PARSECMD)
  {
D_parse:
    if (!D_cmdptr) /* consume trailing blanks */
      { unsigned i=0;
        while (D_cmdline[i]!='\0') i++;
        while (i>0) if (D_cmdline[i-1]==' ') D_cmdline[i--]='\0'; else break;
        if (D_cmdline[i]==' ') D_cmdline[i]='\0';
      }

    switch (D_cmdline[D_cmdptr]){
      case (char)   0: if (!D_cmdptr)           /* <cr> command           */
                         { D_cmdline[++D_cmdptr]='\0';
                           return 01;
                         }
                       else
                         { unsigned i,l;
                           int c;
D_next:                    l=255;i=0;
#ifndef DBXTOOL
			   printf("?> ");fflush(stdout); fflush(stdin);
	                   while(--l>0 && (c=getchar()) != EOF && c != '\n')
	                    if   (i) D_cmdline[i++]=c;
	                    else if   (c==' ') l++;
	                         else D_cmdline[i++]=c; 
#endif	
	                   D_cmdline[i]='\0';
	                   D_cmdptr = 0;
	                   goto D_parse;
	                 } 
      case (char)   1: toNext;                   /* 'do-nothing' command   */
      case (char) 126: if (!D_PROMPT) {
      		          _RUNTIME_argc = 2;
      		          _RUNTIME_argv[0] = "";
      		          _RUNTIME_argv[1] =         
                               (char *) malloc(strlen(&D_cmdline[D_cmdptr+1]));
                          (void)strcpy(_RUNTIME_argv[1],&D_cmdline[D_cmdptr+1]);
                          goto D_next;
                       }
      case (char) 127: D_SOURCE_LINE = 1; toNext;/* send by source line db */
      case        ' ': toNext;
      case        't': DP_D(0);
                       D_cmdptr++;
	               if (D_cmdline[D_cmdptr]=='c') DP_D(31);
	               goto D_err;
      case        'a': D_cmdptr++;DP_N(9);
      case        '-': D_cmdptr++;
	               if (!D_getnum()) goto D_next;
	               if (D_param==0) return 19;
	               else return 18;
      case        'd': DP_D(11);
	               D_cmdptr++;
	               switch (D_cmdline[D_cmdptr]){
	                 case 's': D_cmdptr++;
	                           switch (D_cmdline[D_cmdptr]){
	                             case ':': D_cmdptr++;
	                                       DP_O(05);
	                             default : goto D_err2;
	                           }
	                 case ':': D_cmdptr++;
	                           if (!D_getfilespy()) goto D_next;
	                           return 36;
	                 default : goto D_errA;
	               }
      case        '1':
      case        '2':
      case        '3':
      case        '4':
      case        '5':
      case        '6':
      case        '7':
      case        '8':
      case        '9': DP_N(17);
      case        'p': if (D_DELIM){ D_cmdptr++; D_param = D_DEPTH; return 20; }
	               D_cmdptr++;
	               switch (D_cmdline[D_cmdptr]){
	                 case 'd': if (D_DELIM)
	                             { D_cmdptr++;
	                               D_param = 99999; return 24; }
	                           D_cmdptr++;
	                           DP_N(24);
	                 case 'o': D_cmdptr++;
	                           switch (D_cmdline[D_cmdptr]){
	                             case ':': D_cmdptr++;
	                                       DP_O(06);
	                             default : goto D_err2;
	                           }
	                 case 'm': DP_D(37); goto D_err1;
	                 case 'p': if (D_DELIM)
	                             { D_cmdptr++;
	                               D_param = D_DEPTH; return 21; }
	                           goto D_err1;
	                 case '0':
	                 case '1':
	                 case '2':
	                 case '3':
	                 case '4':
	                 case '5':
	                 case '6':
	                 case '7':
	                 case '8':
	                 case '9': DP_N(20);
	                 case 's': DP_D(07); goto D_err1;
	                 default : goto D_errA;
	               }
      case        'l': DP_D(8);
	               D_cmdptr++;
	               if (D_cmdline[D_cmdptr]=='m') {
	                  DP_D(25);goto D_err1;
	               }
	               goto D_errA;
      case        'n': D_cmdptr++;
                       switch (D_cmdline[D_cmdptr]) {
                         case 's': DP_D(30);
                                   goto D_err1;
                         case 'p': D_cmdptr++;
	                           switch(D_cmdline[D_cmdptr]) {
	                             case ':': D_cmdptr++;
	                                       if (!D_getsrt()) goto D_next;
	                                       return 32;
	                             case '?': DP_D(33);
	                                       goto D_err1;
	                             case 'c': DP_D(34);
	                                       goto D_err1;
	                             default:  goto D_err2;
	                           }
	                 default : goto D_errA;
                       }
      case        'u': DP_D(10); goto D_err;
      case        'c': DP_D(16); goto D_err;
      case        '0': DP_D(19); goto D_err;
      case        'i': DP_D(26); goto D_err;
      case        '?': DP_D(27); goto D_err;
      case        'q': DP_D(28); goto D_err;
      case        's': if (D_DELIM) { D_cmdptr++; D_param = 1; return 02; }
	               D_cmdptr++;
	               switch (D_cmdline[D_cmdptr]){
	                 case '-': D_cmdptr++;
	                           DP_N(2);
	                 case 'p': DP_D(29); goto D_err1;
	                 case 'm': DP_D(22); goto D_err1;
	                 case 'c': D_cmdptr++;
	                           if (D_cmdline[D_cmdptr]!=':') goto D_err2;
	                           D_cmdptr++;
	                           DP_O(23);
	                 case 's': D_cmdptr++;
	                           if (D_cmdline[D_cmdptr]!=':') goto D_err2;
	                           D_cmdptr++;
	                           DP_O(04);
	                 case ':': D_cmdptr++;
	                           if (!D_getfilespy()) goto D_next;
	                           return 35;
	                 case '0':
	                 case '1':
	                 case '2':
	                 case '3':
	                 case '4':
	                 case '5':
	                 case '6':
	                 case '7':
	                 case '8':
	                 case '9': DP_N(3);
	                 default : goto D_errA;
	               }
      default        :
	  sprintf(D_err_msg,"bad command %c... - skipped!",
	          D_cmdline[D_cmdptr]);
	  errmsg(D_err_msg);
	  goto D_next;
    }

D_errA:   sprintf(D_err_msg,"bad command %c%c... - skipped!",
                  D_cmdline[D_cmdptr-1],D_cmdline[D_cmdptr ]);
          errmsg(D_err_msg);
          goto D_next;
D_err:    sprintf(D_err_msg,"bad command %c%c... - skipped!",
                  D_cmdline[D_cmdptr],D_cmdline[D_cmdptr+1]);
          errmsg(D_err_msg);
          goto D_next;
D_err1:   sprintf(D_err_msg,"bad command %c%c%c... - skipped!",
                  D_cmdline[D_cmdptr-1],
                  D_cmdline[D_cmdptr],
                  D_cmdline[D_cmdptr+1]);
          errmsg(D_err_msg);
	  goto D_next;
D_err2:   sprintf(D_err_msg,"bad command %c%c%c... - skipped!",
                  D_cmdline[D_cmdptr-2],
                  D_cmdline[D_cmdptr-1],
                  D_cmdline[D_cmdptr]);
          errmsg(D_err_msg);
          goto D_next;
  }


static void
DEFUN_VOID(D_HELP)
 {printf(VERSION);
  printf("- AC is the call/return where the execution stopped\n");
  printf("- AL is the level of AC, increased by call, decreased by return\n");
  printf("- CC is the current call/return being examined\n");
  printf("- CL is the level of CC\n");
  printf("- CT is the current term being examined\n");
  printf("- PD is a variable used as maximal term-depth while printing\n");
  printf("- no blanks are allowed within a command\n");
  printf("- more than on command per line should be seperated by blanks\n");
  printf("- all commands after t and l are skipped - exception:<cr>\n");
  printf(" t       run one step, CC=AC, 'c'\n");
  printf(" <cr>    't p'\n");
  printf(" s[-<n>] AL-n>=0, default n=-1, run until AL=AL-n, CC=AC, 'c p'\n");
  printf(" s<n>    n<AL, run until AL=n, CC=AC, 'c p'\n");
  printf(" s:<fn>:<n> set file-spypoint in file <fn> column <n>.\n");
  printf(" d:<fn>:<n> remove file-spypoint\n");
  printf(" ss:<op> set spypoint on operation op (wildcards possible)\n");
  printf(" ds:<op> delete spypoint on operation op (wildcards possible)\n");
  printf(" ps      print all spypoints\n");
  printf(" sp      set spypoint on CC if not there\n");
  printf(" ns      delete spypoint from CC if existent\n");
  printf(" l       leap to next spypoint, CC=AC, 'c p'\n");
  printf(" a<n>    print n entries of the call-stack relative CC, 0=all.\n");
  printf(" u       CL=CL+1, 'c', if CC=AC do nothing\n");
  printf(" d       CL=CL-1, 'c', if CL=0 do nothing\n");
  printf(" c       CT=CC\n");
  printf(" <n>     n>0, CT=the nth subterm of CT\n");
  printf(" -<n>    same as <n> but counted from the end\n");
  printf(" 0       or '-0', CT=the father of CT\n");
  printf(" p[<n>]  print CT with depth n (0=whole), without n PD is used\n");
  printf(" pp      shows the sort of CT.\n");
  printf(" pm      shows all modulenames compiled with debugger\n");
  printf(" po:<op> shows signature of operation op (wildcards possible)\n");
  printf(" sm      print statistics on memory management\n");
  printf(" sc:<op> print statistics on operation op (wildcards possible)\n");
  printf(" np:<sr> toggle do-not-print-flag of sort sr\n");
  printf(" np?     show all do-not-print-flags of sorts\n");
  printf(" npc     clear all do-not-print-flags of sorts\n");
  printf(" pd[<n>] PD=n, without n the current value is printed\n");
  printf(" lm      toggle flat-list-mode/deep-list-mode\n");
  printf(" tc      toggle term-count-mode\n");
  printf(" i       call interpreter\n");
  printf(" ?       this help\n");
  printf(" q       halt program\n");
 }
 
 
 
/********************* Free What has been Copied ****************************/

static void
DEFUN(DB_FREE,(cont),
      TERM cont)
 { OPNREC opn=COPNREC(cont);
   unsigned i;
   if (--(cont->NAME)==0) {
     if (D_isReturn(cont))
       for (i=0; i<allargs(opn); i++)
           FREE(opn->args_arr[i],cont->ARGS[i+4]);
     else
       for (i=0; i<opn->numargs; i++)
           FREE(opn->args_arr[i],cont->ARGS[i+4]);
     MDEALLOC(allargs(opn)+4,cont);
   }
 }

/********************* Walking in the Typemask *******************************/

#define GET_TYPE(o,i,idx) \
          i=0,\
          D_MASKofCT=FALSE,TYPOF_global(FALSE,FALSE,&(o),&i,idx)

static SORTRECP TYPOF_global();
static SORTRECP
EXFUN(TYPOF_global,(unsigned,unsigned,SORTRECP,unsigned *,unsigned));

static void
DEFUN(TYPOF_doit,(i,o,idx),
      unsigned *i  AND
      SORTRECP o   AND
      unsigned idx)
 {
     if (*i==idx) D_MASKofCT=(--o);
     (*i)++;
 }
 
static SORTRECP
DEFUN(TYPOF_function,(infunc,truef,o,i,idx),
      unsigned infunc AND
      unsigned truef  AND
      SORTRECP o      AND 
      unsigned *i     AND
      unsigned idx)
 { 
   if (truef) { if (!infunc) TYPOF_doit(i,o,idx);
                    o=TYPOF_global(TRUE,TRUE,o,i,idx);
               return TYPOF_global(TRUE,TRUE,o,i,idx);
             }
   else      {      o=TYPOF_global(infunc,TRUE ,o,i,idx);
               return TYPOF_global(infunc,FALSE,o,i,idx);
             }
 }
static SORTRECP
DEFUN(TYPOF_tuple,(infunc,o,i,idx),
      unsigned infunc AND
      SORTRECP o      AND
      unsigned *i     AND
      unsigned idx)
 { for (;;) {
     if (*o==_S_COFF || D_MASKofCT) {o++; return o;}
     o=TYPOF_global(infunc,TRUE,o,i,idx);
   }
 }
 
static SORTRECP
DEFUN(TYPOF_global,(infunc,truef,o,i,idx),
      unsigned infunc AND
      unsigned truef  AND
      SORTRECP o      AND
      unsigned *i     AND
      unsigned idx)
 { if (D_MASKofCT) return o;
   if (*o==_S_FUNC) 
     return TYPOF_function(infunc,truef,++o,i,idx);
else
   if (*o==_S_CON) 
     return TYPOF_tuple(infunc,++o,i,idx); 
else { o++;
       if (!infunc) TYPOF_doit(i,o,idx);
       return o;
     }
 }
 
 
/********************* Print Term (Debuggers Version) ***********************/

static void
EXFUN(WRD_global,(char *,unsigned,unsigned,unsigned,unsigned,unsigned,
                  TERM,OPNREC,unsigned *,unsigned *));

static void
DEFUN(WRD_doit,(needpar,cr,o,i),
      unsigned needpar AND
      TERM     cr      AND
      OPNREC   o       AND
      unsigned *i)
 {
     if (needpar) C_OUT('(');
     NCWRITE(o->args_arr[*i],cr->ARGS[*i+4]);(*i)++;
     if (needpar) C_OUT(')');
 }
 
static void
DEFUN(WRD_function,(on,infunc,truef,needpar,lst,cr,o,i,j),
      char     *on     AND
      unsigned infunc  AND
      unsigned truef   AND
      unsigned needpar AND
      unsigned lst     AND
      TERM     cr      AND
      OPNREC   o       AND
      unsigned *i      AND
      unsigned *j)
 { 
   if (truef) { if (!infunc) { 
                  WRD_doit(needpar,cr,o,i);
                  (*i)--; /* to prevent skipping in WRD_global */
                }
                WRD_global(on,FALSE,TRUE ,TRUE ,TRUE ,lst,cr,o,i,j);
                WRD_global(on,FALSE,TRUE ,TRUE ,FALSE,lst,cr,o,i,j);
                if (!infunc) 
                  (*i)++; /* undo the above patch */
              }
   else       { WRD_global(on,FALSE,infunc,TRUE ,TRUE ,lst,cr,o,i,j);
                WRD_global(on,FALSE,infunc,FALSE,FALSE,lst,cr,o,i,j);
              }
 }
static void
DEFUN(WRD_tuple,(on,infunc,lst,cr,o,i,j),
      char     *on     AND
      unsigned infunc  AND
      unsigned lst     AND
      TERM     cr      AND
      OPNREC   o       AND
      unsigned *i      AND
      unsigned *j)
 { unsigned comma=FALSE;
   if (!infunc) C_OUT('(');
   for (;;) {
     if (o->args_arr[*j]==_S_COFF || *i>=lst) 
        {(*j)++; if (!infunc) C_OUT(')'); return;}
     if ((comma) && (!infunc)) 
       if (*on) S_OUT(on);
       else C_OUT(',');
     WRD_global("",FALSE,infunc,TRUE,FALSE,lst,cr,o,i,j);comma=TRUE ;
   }
 }
 
static void
DEFUN(WRD_global,(on,first,infunc,truef,needpar,lst,cr,o,i,j),
      char     *on     AND
      unsigned first   AND
      unsigned infunc  AND
      unsigned truef   AND
      unsigned needpar AND
      unsigned lst     AND
      TERM     cr      AND
      OPNREC   o       AND
      unsigned *i      AND
      unsigned *j)
 { if (*i>=lst) return;
   if (o->args_arr[*j]==_S_FUNC) 
     {(*j)++; WRD_function(on,infunc,truef,needpar,lst,cr,o,i,j); } 
else
   if (o->args_arr[*j]==_S_CON) 
        {(*j)++; WRD_tuple(on,infunc,lst,cr,o,i,j);} 
else
   { (*j)++; 
     if (first) return;
     if (infunc) return;
     WRD_doit(needpar,cr,o,i);
   }
 }

 
static void
DEFUN(D_PCALL,(callrec),
      TERM callrec)
 { OPNREC opn = COPNREC(callrec); unsigned i,j;
   D_WRITEDEBUG=TRUE;
   if (D_int_lev!= -1) printf("%u> ",D_int_lev);
   printf("%u",D_Lv(callrec)-1);
   if (D_isReturn(callrec)) printf("<--");else printf("-->");
   printf("%u %s",D_Lv(callrec),opn->name);
   i=0;j=allargs(opn)+opn->is_param;
   WRD_global("",TRUE,FALSE,FALSE,FALSE,opn->numargs,callrec,opn,&i,&j);
   if (D_isReturn(callrec)){
      printf(" -> ");
      WRD_global("",FALSE,FALSE,FALSE,FALSE,allargs(opn),callrec,opn,&i,&j);
   }
   D_WRITEDEBUG=FALSE;
 } 


/********************* the rest *******************************************/

static void
DEFUN_VOID(D_CMD_C)
 { D_CT=TOP(D_CC);
   D_MASKofCT = (SORTRECP) 0;
   CLEAR(&D_LOOK_STACK);
 }
 
static void
EXFUN(D_COM,(void));


void
DEFUN(LDFILE,(f),
      char *f)
 {  D_currfile = f;
    if (D_SOURCE_LINE && !D_SKIP && !D_LEAP)
         printf("%c%c%s\n",(char)127,(char)2,D_currfile);
 }

void
DEFUN_VOID(D_CALL0)
 { printf(VERSION);
   D_COM();
   D_PROMPT=1;
 }

void
DEFUN(D_CALL,(opn,arg),
      OPNREC opn AND
      TERM *arg)
 { TERM callrec;
   unsigned i;
 OUTtoSYS_MODE();
   D_LEVEL++;
   callrec = NEW_CELL(4+allargs(opn));
   callrec->NAME = 1;
   callrec->ARGS[0]=(TERM) opn;
   callrec->ARGS[1]=(TERM) D_ROW;
   callrec->ARGS[2]=(TERM) D_COL;
   callrec->ARGS[3]=(TERM) (D_LEVEL*4);
   if(NODBX) callrec->ARGS[3] = (TERM)((unsigned)callrec->ARGS[3]+2);
   NODBX=FALSE; /* states that DBX has been called */
   for (i=0; i<opn->numargs; i++)
       callrec->ARGS[i+4]=COPY(opn->args_arr[i],arg[i+1]);
   D_CALL_STACK = PUSH(callrec,D_CALL_STACK);
   if(D_SOURCE_LINE) D_CFILE_STACK = PUSH((TERM)D_currfile,D_CFILE_STACK);
   if (!D_SKIP && !D_LEAP) 
     if (D_SOURCE_LINE) printf("%c%c%d %d\n",(char)127,(char)0,D_ROW,D_COL);
   if (!D_SKIP) D_COM();
 OUTreturnMODE();
 }

void
DEFUN(D_EXIT,(res),
      TERM *res)
 { unsigned i,j,ndbx;
   TERM callrec = TOP(D_CALL_STACK);
   OPNREC opn = COPNREC(callrec);
 OUTtoSYS_MODE();
   D_LEVEL--;
   if (D_LEVEL<D_SKIP) D_SKIP=0;
   if (opn->numres==1) j=0; else j=opn->numargs+1;
   for (i=0; i<opn->numres; i++,j++)
       callrec->ARGS[i+4+opn->numargs] = 
          COPY(opn->args_arr[i+opn->numargs],
               ((j==0) ? (TERM)res[j] : *(TERM *)res[j]));
   callrec->ARGS[3] = (TERM)((unsigned)callrec->ARGS[3]+1);
   if(((unsigned)callrec->ARGS[3]&2)==2) ndbx = TRUE; else ndbx = FALSE;
   if (!D_SKIP) D_COM();
   DB_FREE(TOP(D_CALL_STACK));
   POP(&D_CALL_STACK);
   if(D_SOURCE_LINE) {
     LDFILE((char *)TOP(D_CFILE_STACK));
     POP(&D_CFILE_STACK);
   }
   NODBX = ndbx;
 OUTreturnMODE();
 }

static void
DEFUN(IDBX,(op,p),
      OPNREC op AND
      TERM   p)
  { unsigned i,i0=0,ndbx=NODBX;
   /* extern void EXFUN(exit,(unsigned)); */
    OPNREC opn;
    TERM *a;
    TERM *b;
    NODBX=FALSE;
    if (allargs(op) > 25) {
      errmsg("DEBUGGER ERROR (too many arguments) !");
      for (i=0;i<op->numargs;i++) 
        FREE(op->args_arr[i],p->ARGS[i]);
      return;
    }
    
    if (op->is_param) {
      i0=1;
      errmsg("DEBUGGER ERROR (parametrized opn) !");
      for (i=0;i<op->numargs;i++) 
        FREE(op->args_arr[i],p->ARGS[i]);
      return;
    }
    
    a = (TERM *) NEW_CELL(allargs(op)+i0+1);
    b = (TERM *) NEW_CELL(allargs(op)+i0+1);
    for (i=0;i<op->numargs+i0;i++) a[i+1]= p->ARGS[i];
    for (;i<allargs(op)+i0;i++) a[i+1]= (TERM)&(b[i+1]);
    *(op->calls)++;
    if (i0==1) if (op->numres==1) opn=INST_OPR(op,(INSTREC)a[op->numargs+i0]);
               else               opn=INST_OPR(op,(INSTREC)a[allargs(op)+i0]); 
    else opn=op;
    D_CALL(opn,a);  
    callswitch(allargs(op)+i0)
    NODBX=ndbx;
    D_EXIT(a);
    if (op->numres == 1)
      FREE(op->args_arr[op->numargs],a[0]);
    else
      for (i=op->numargs; i<allargs(op); i++)
        FREE(op->args_arr[i],*((TERM *)a[i+1]));
    MDEALLOC(allargs(op)+i0+1,(TERM)a);
    MDEALLOC(allargs(op)+i0+1,(TERM)b);
    if (i0==1) FREE_OPN(opn);
  }
  
static void
DEFUN_VOID(D_interpret)
 {
  TERM H1,p=(TERM)0,dummy,ok; OPNREC o; char *fn; int oldD_int_lev;
  unsigned first,i,j,gotarg=0;
  extern int EXFUN(strcmp,(CONST char *,CONST char *));
  printf("Enter call (terminated by <cr>)\n");
  toBUFFER_MODE();
  if (!READ_IDENTIFIER()) { errmsg("bad call"); goto end; }
  H1 = D_OPN_STACK;
  fn = ID;
  while (OPN(H1)) {
    o = (OPNREC)TOP(H1);
    if (strcmp(o->name,fn) == 0){
      if (READ_LP()) {
        if (o->numargs == 0) goto next;
      }
      else if (o->numargs > 0) goto next;
      if (o->numargs > 0) {
        p = NEW_CELL(o->numargs);
        p->NAME= 0;
	gotarg=0;
        first = TRUE; ok=true; 
        for (j=0;j<o->numargs;j++){
          if ((!first) && !READ_COMMA()) goto next;
          if ((unsigned)o->args_arr[j] < 25) 
            goto next; /* parametrized opn */
          _RUNTIME_READ(o->args_arr[j],(TERM)0,dummy,&ok,&(p->ARGS[j]),&dummy);
          if (ok==false) goto next; else gotarg++;
          first = FALSE;
        }
	 
        if (!READ_RP()) goto next;
      } 
      else {
      }
      cancleBUFFER_MODE();
      oldD_int_lev = D_int_lev;
      D_int_lev = D_LEVEL;
      IDBX(o,p);
      D_int_lev = oldD_int_lev;   
      MDEALLOC(o->numargs,p);
    
      return;
    } /* of if (strcmp) */
next:
    if (p!=(TERM)0) {
     for (i=0;i<gotarg;i++) FREE(o->args_arr[i],p->ARGS[i]);
     MDEALLOC(o->numargs,p);
     p=(TERM)0;
     to_POS(0);
    }
    H1 = SKIP(H1);
  } /* of while */
  
  errmsg("bad call");
  
end:
  cancleBUFFER_MODE();
}



char *
DEFUN(spy_module,(name),
      char *name)
 { TERM H1;
   char *rname;
   char NAME[255];
   unsigned num=0;
   (void)strcpy(NAME,name);
   H1 = D_FILE_STACK;
   while (OPN(H1)) {
     if (WCSTRCMP((char *)TOP(H1),NAME)) { num++; rname = (char *)TOP(H1); }
     H1 = SKIP(H1);
   }
   if (num==0) {
     strncat(NAME,".AS",3);
     H1 = D_FILE_STACK;
     while (OPN(H1)) {
       if (WCSTRCMP((char *)TOP(H1),NAME)) { num++; rname = (char *)TOP(H1); }
       H1 = SKIP(H1);
     }
     if (num==0) {
       errmsg("Filename is not in list of modules compiled with debugger");
       return NULL;
     }
   }
   if (num>1) {
     errmsg("There is more than one module which matches the filename");
     return NULL;
   }
   return rname;
 }

static unsigned
DEFUN_VOID(is_filebreak)
 { TERM H1;
   H1 = D_BRK_STACK;
   while (OPN(H1)) {
      if(D_ROW == (unsigned)TOP(H1)) {
        H1 = SKIP(H1);
        if (strcmp(D_currfile,(char *)TOP(H1))==0) 
           return 1;
        H1 = SKIP(H1);
      } else {
        H1 = SKIP(H1);
        H1 = SKIP(H1);
      }
   }
   return 0;
 }


static void
DEFUN_VOID(D_COM)
 { unsigned i,j,ss,fs,row; OPNREC opn;
   char *fn;
   TERM H1,H2;
   FILE *HF;
   unsigned isin;
   if (D_PROMPT) opn = GOPNREC(D_CALL_STACK);
   if (D_LEAP) {
      if (is_filebreak())   goto SPYPOINT;
      if (*(opn->spypoint)) goto SPYPOINT;
      return;
   }
SPYPOINT:
   if (D_PROMPT) {
       D_cmdline[0] = 'c';
       D_cmdline[1] = ' ';
       if (D_p_at_entry) { if(D_SPEC_LEAP) {
                                D_cmdline[2] = 'l';
                                D_SPEC_LEAP = 0;
                           }
                           else D_cmdline[2] = 'p';
                         }
       else 	         D_cmdline[2] = ' ';
       D_cmdline[3] = '\0';
   } else {
       D_cmdline[0] = '\1';
       D_cmdline[1] = '\0';
   }
   D_cmdptr=0;
   if(D_LEAP) LDFILE(D_currfile);
   D_LEAP = 0;
   D_AC = D_CALL_STACK;
   D_CC = D_AC;
   while (1) {
    D_cmd=D_PARSECMD();
#define CHK_CMD if (!D_PROMPT) goto do_not_now
    switch (D_cmd) {
      case 00: CHK_CMD;
	D_p_at_entry=0;
	return;
      case 01:
	D_p_at_entry=1;
	return;
      case 03: CHK_CMD;
	if (D_param>D_LEVEL) {
	   errmsg("skiplevel should be less AL, skip canceled!");
	   break;
	} 
	D_SKIP = D_param+1;
	return;
      case 02: CHK_CMD;
      	if (D_param>D_LEVEL) {
      	    errmsg("skiprange to large, skip canceled!");
	    break;
	}
	D_SKIP = D_LEVEL-D_param+1;
	return;
      case 04:
        ss = 0;
	H1 = D_OPN_STACK;
	printf("Spypoint set on ...\n");
	while (OPN(H1)) {
	   opn = (OPNREC)TOP(H1);
	   if (*(opn->name) != '_')
	    if (WCSTRCMP(opn->name,D_opname)) 
              {printf("%u. ",++ss);
               D_print_opnsig(opn);
               printf("\n");
               *(opn->spypoint)=1;}
	   H1 = SKIP(H1);
	}
	if (!ss) printf("none operation.\n");
	break;
      case 05:
        ss = 0;
	H1 = D_OPN_STACK;
	printf("Spypoints removed on ...\n");
	while (OPN(H1)) {
	   opn = (OPNREC)TOP(H1);
	   if ((*(opn->spypoint)) & (WCSTRCMP(opn->name,D_opname)))
             {printf("%u. ",++ss);
              D_print_opnsig(opn);
              printf("\n");
              *(opn->spypoint)=0;}
	   H1 = SKIP(H1);
	}
	if (!ss) printf("none operation.\n");
	break;
      case 06:
        ss = 0;
	H1 = D_OPN_STACK;
	while (OPN(H1)) {
	   opn = (OPNREC)TOP(H1);
	   if (*(opn->name) != '_')
	     if (WCSTRCMP(opn->name,D_opname)) 
               {printf("%u. ",++ss);D_print_opnsig(opn);printf("\n");}
	   H1 = SKIP(H1);
	}
	if (!ss) errmsg("no such operation found.");
	break;
      case 07:
	H1 = D_OPN_STACK;
	ss = 0;
	fs = 0;
	printf("There are spypoints on...\n");
	while (OPN(H1)) {
	   opn = (OPNREC)TOP(H1);
	   if (*(opn->spypoint)) { printf(" %u. ",++ss);
	                         D_print_opnsig(opn);
	                         printf("\n");}
	   H1 = SKIP(H1);
	}
	if (!ss) printf("none operations.\n");
	H1 = D_BRK_STACK;
	while (OPN(H1)) {
	   row = (unsigned) TOP(H1);
	   H1  = SKIP(H1);
	   fn  = (char *) TOP(H1);
	   H1  = SKIP(H1);
	   fs++;
	   printf(" %u. module '%s' line %d\n",fs+ss,fn,row);
	}
	if (!fs) printf("none filepositions.\n");
	break;
      case 8: 
	if (!D_PROMPT) { D_SPEC_LEAP=1; D_p_at_entry=1; return; }
	printf("leaping...\n");
	D_LEAP = 1;
	D_p_at_entry = 1;
	return;
      case 9: CHK_CMD;
        H1=D_CC; CHK_CMD;
        if (D_param==0) D_param=D_Lv(D_CC)+2;
        while(D_param>0) {
          HF = STDOUT;
          STDOUT=stdout;
          D_WRITEDEPTH = D_DEPTH;
          D_PCALL(TOP(H1));
          printf("\n");
          STDOUT = HF;
          D_WRITEDEPTH = 0;
          if (SKIP(H1) == MT_STACK) break;
          H1=SKIP(H1);
          D_param--;
        }
	break;
      case 10: CHK_CMD;
	if (D_CC==D_AC) break;
	D_CT=D_AC;
	while(SKIP(D_CT)!=D_CC) D_CT=SKIP(D_CT);
	D_CC=D_CT;
	D_CMD_C();
	break;
      case 11: CHK_CMD;
        if (SKIP(D_CC) == MT_STACK) break;
        D_CC=SKIP(D_CC);
        D_CMD_C();
	break;
      case 16: CHK_CMD;
        D_CMD_C();
	break;
      case 17: CHK_CMD;
        if (D_isCR){
         OPNREC opn = COPNREC(D_CT);
         if (((D_param>opn->numargs)&&D_isCall(D_CT)) ||
             ((D_param>allargs(opn))&&D_isReturn(D_CT)))
           { sprintf(D_err_msg,"illegal term address (%u)",D_param);
             errmsg(D_err_msg);
             break;}
         GET_TYPE(opn->args_arr[allargs(opn)+opn->is_param],i,D_param-1);
         D_CT = D_CT->ARGS[3+D_param];
        } 
        else if (D_isFN){ errmsg("currently not implemented");break;}
        else if (D_LISTMODE && listsort(D_TYPEofCT,&i)) {
          TERM TRM=D_CT;
          unsigned u=D_param,f=0;
          while(OPN(TRM)==1)
            if (D_param==1)
             { PUSH_LOOK_STACK;
               GET_TYPE(D_TYPEofCT->consarr[1]->
                                argsarr[D_TYPEofCT->consarr[1]->numargs],i,0);
               D_CT = TRM->ARGS[0];f=1;
               break;
             }
            else
             { D_param--;
               TRM=TRM->ARGS[1];
             }
          if (f==0) { sprintf(D_err_msg,"illegal list-term index (%u)",u);
                      errmsg(D_err_msg);
                    }
        } else {
          CONSREC CR;
          if (D_TYPEofCT->numcons == -30000)
            CR=D_TYPEofCT->consarr[0];
          else if (D_TYPEofCT->numcons<0) {
            sprintf(D_err_msg,"illegal term address (%u)",D_param);
            errmsg(D_err_msg);
            break;
          } else
            CR = D_TYPEofCT->consarr[OPN(D_CT)];
          if (D_param>CR->numargs)
          { sprintf(D_err_msg,"illegal term address (%u)",D_param);
            errmsg(D_err_msg);
            break;
          }
          PUSH_LOOK_STACK;
          GET_TYPE(CR->argsarr[CR->numargs],i,D_param-1);
          D_CT = D_CT->ARGS[D_param-1];
        }
	break;
      case 18: CHK_CMD;
        if (D_isCR){
         OPNREC opn = COPNREC(D_CT);
         if (((D_param>opn->numargs)&&D_isCall(D_CT)) ||
             ((D_param>allargs(opn))&&D_isReturn(D_CT)))
           { sprintf(D_err_msg,"illegal term address (-%u)",D_param);
             errmsg(D_err_msg);
             break;
           }
         if (D_isCall(D_CT)) j=opn->numargs; else j=allargs(opn);
         GET_TYPE(opn->args_arr[allargs(opn)+opn->is_param],i,j-D_param);
         D_CT = D_CT->ARGS[4+j-D_param];
        }
        else if (D_isFN){ errmsg("currently not implemented");break;}
        else if (D_LISTMODE && listsort(D_TYPEofCT,&i)) {
          TERM TRM=D_CT;
          unsigned u=0;
          while(OPN(TRM)==1) u++,TRM=TRM->ARGS[1];
          if (D_param>u) {
           sprintf(D_err_msg,"illegal list-term index (-%u)",D_param);
           errmsg(D_err_msg);
          } else {
           TRM=D_CT; D_param=u-D_param+1;
           while(D_param!=1) D_param--,TRM=TRM->ARGS[1];
           PUSH_LOOK_STACK;
           GET_TYPE(D_TYPEofCT->consarr[1]->
                            argsarr[D_TYPEofCT->consarr[1]->numargs],i,0);
           D_CT = TRM->ARGS[0];
          }
        } else {
          CONSREC CR;
          if (D_TYPEofCT->numcons == -30000)
            CR=D_TYPEofCT->consarr[0];
          else if (D_TYPEofCT->numcons<0) {
            sprintf(D_err_msg,"illegal term address (-%u)",D_param);
            errmsg(D_err_msg);
            break;
          } else
            CR = D_TYPEofCT->consarr[OPN(D_CT)];
          if (D_param>CR->numargs)
          { sprintf(D_err_msg,"illegal term address (-%u)",D_param);
            errmsg(D_err_msg);
            break;
          }
          PUSH_LOOK_STACK;
          GET_TYPE(CR->argsarr[CR->numargs],i,CR->numargs-D_param);
          D_CT = D_CT->ARGS[CR->numargs-D_param];
        }
	break;
      case 19: CHK_CMD;
        if (D_LOOK_STACK==MT_STACK) {
           D_CMD_C();
        } else {
	  POP_LOOK_STACK;
	}
	break;
      case 20: CHK_CMD;
        HF = STDOUT;
        STDOUT=stdout;
        D_WRITEDEBUG = 1;
        D_WRITEDEPTH = D_param;
        if (D_isCR) D_PCALL(D_CT); 
        else { if (D_WRITEDEPTH>0) D_WRITEDEPTH++;
               if (D_int_lev!= -1) printf("%u> ",D_int_lev);
               NCWRITE(D_TYPEofCT,D_CT);}
        printf("\n");
        STDOUT = HF;
        D_WRITEDEBUG = 0;
        D_WRITEDEPTH = 0;
	break;
      case 21: CHK_CMD;
	if (D_isCR) D_print_opnsig(COPNREC(D_CT));
	else	   
	if (D_isFN) D_print_opnsig_sort(D_MASKofCT,FALSE);
	else
                    D_print_consig(D_TYPEofCT,D_CT);
	printf("\n");
	break;
      case 22:
        if (STATISTICS_def) 
         STATISTIC();
        else 
         errmsg("Memory statistics are off due compiler switch");
	break;
      case 23:
	H1 = D_OPN_STACK;
	printf("Call Statistics\n");
	printf("---------------\n");
	while (OPN(H1)) {
	   opn = (OPNREC)TOP(H1);
	   if (*(opn->name) != '_')
	     if (WCSTRCMP(opn->name,D_opname)) 
	       if (*(opn->calls)) printf("%s (%u)\n",opn->name,*(opn->calls));
	   H1 = SKIP(H1);
	}
	break;
      case 24:
	if (D_param!=99999) D_DEPTH = D_param;
	printf("PD = %u\n",D_DEPTH);
	break;
      case 25:
	printf("Lists are now seen as ");
	if (D_LISTMODE) { D_LISTMODE=0; printf("deep terms\n"); }
	else		{ D_LISTMODE=1; printf("flat terms\n"); }
	break;
      case 26: CHK_CMD;
        D_interpret();
        D_cmdptr=0;
        D_LEAP = 0;
        (void)strcpy(D_cmdline,(D_p_at_entry)?"c p":"c");
        D_AC = D_CALL_STACK;
        D_CC = D_AC;
	break;
      case 27:
	D_HELP();
	break;
      case 28:
#ifdef IBM
	errmsg("halt not implemented yet");
#else
	errmsg("use ^C to halt");
#endif
	break;
      case 29: CHK_CMD;
        *(GOPNREC(D_CC)->spypoint)=1;
        break;
      case 30: CHK_CMD;
        *(GOPNREC(D_CC)->spypoint)=0;
        break;
      case 31:
	printf("Terms are now printed ");
	if (D_TCMODE) { D_TCMODE=0; printf("with"); }
	else	      { D_TCMODE=1; printf("without"); }
	printf(" reference-counts.\n");
	break;
      case 32:
        H1 = D_SORT_STACK;
        while (OPN(H1)) {
           fn = (char *)TOP(H1);
           if (strcmp(D_srtname,fn)==0) {
             if (H1==D_SORT_STACK) POP(&D_SORT_STACK);
             else POP(&H1);
             free(fn);
             printf("Sort %s is printed again.\n",D_srtname);
             goto we_are_done;
           }
           H1 = SKIP(H1);
        }
        fn = (char *) malloc(strlen(D_srtname));
        (void)strcpy(fn,D_srtname);
        D_SORT_STACK = PUSH(fn,D_SORT_STACK);
        printf("Sort %s is not printed now.\n",D_srtname);
we_are_done:
        break;
      case 33:
        printf("Sorts which are suppressed via np:<srt>\n");
        H1 = D_SORT_STACK;
        while (OPN(H1)) {
          printf(" %s\n",(char *)TOP(H1));
          H1 = SKIP(H1);
        }
        break;
      case 34:
        while (OPN(D_SORT_STACK)) {
           fn = (char *)TOP(H1);
           POP(&D_SORT_STACK);
           free(fn);
        }
        break;
      case 35:
        if (fn=spy_module(D_opname)) {
          isin = 0;
          H1 = D_BRK_STACK;
          while (OPN(H1)) {
             if((unsigned) TOP(H1) == D_param) {
               H1  = SKIP(H1);
               if ((char *) TOP(H1) == fn) isin=1;
               H1  = SKIP(H1);
             } else {
               H1  = SKIP(H1);
               H1  = SKIP(H1);
             }
          }
          if(!isin) {
             D_BRK_STACK=PUSH((TERM)fn,     D_BRK_STACK);
             D_BRK_STACK=PUSH((TERM)D_param,D_BRK_STACK);
          }
          printf("Spypoint set in file '%s' line %d.\n",
                 fn,D_param);
        }
        break;
      case 36:
        if (fn=spy_module(D_opname)) {
          isin = 0;
          H1 = D_BRK_STACK;
          while (OPN(H1)) {
             if((unsigned) TOP(H1) == D_param) {
               H2  = H1;
               H1  = SKIP(H1);
               if ((char *) TOP(H1) == fn)
                 { isin=1; 
                   if(H2==D_BRK_STACK) {
                     POP(&D_BRK_STACK);
                     POP(&D_BRK_STACK);
                     H1 = D_BRK_STACK;
                   } else {
                     POP(&H2);
                     POP(&H2);
                     H1 = H2;
                   }
                 }
               else 
                 H1  = SKIP(H1);
             } else {
               H1  = SKIP(H1);
               H1  = SKIP(H1);
             }
          }
          if(isin)
            printf("Spypoint removed in file '%s' line %d.\n",
                   fn,D_param);
          else
            { sprintf(D_err_msg,"There is no spypoint in file '%s' line %d.",
                      fn,D_param);
              errmsg(D_err_msg);
            }
        }
        break;
      case 37: 
        printf("Modules compiled with debugger\n");
        H1 = D_FILE_STACK;
        while (OPN(H1)) {
          printf(" %s\n",(char *)TOP(H1));
          H1 = SKIP(H1);
        }
        break;
      default:
	errmsg("Command not recognized!");
	break;
do_not_now:
        errmsg("Command not recognized at this time!");
        break;
    }
   }
 }

unsigned
DEFUN(D_show_sort,(S),
      char *S)
 { TERM H1 = D_SORT_STACK;
   while (OPN(H1)) {
     if (strcmp((char *)TOP(H1),S)==0) return FALSE;
     H1 = SKIP(H1);
   }
   return TRUE;
 }

 
void
DEFUN_VOID(D_INIT)
 {
   D_LEVEL	= 0;
   D_SKIP	= 0;
   D_SPEC_LEAP  = 0;
   D_LEAP	= 0;
   D_LISTMODE	= 0;
   D_SOURCE_LINE= 0;
   D_TCMODE	= 0;
   D_DEPTH	= 4;
   D_p_at_entry = 1;
   D_int_lev    = -1;
   NODBX        = TRUE;
   D_CALL_STACK = MT_STACK;
   D_CFILE_STACK= MT_STACK;
   D_SORT_STACK = MT_STACK;
   D_OPN_STACK	= MT_STACK;
   D_FILE_STACK	= MT_STACK;
   D_LOOK_STACK = MT_STACK;
   D_BRK_STACK  = MT_STACK;
   D_WRITEDEPTH = 0;
   D_WRITEDEBUG = 0;
   D_COL        = 0;
   D_ROW        = 0;
   D_currfile   = "<none>";
   D_PROMPT     = 0;
   CREATE_FREELIST(2); /* due to stack operations while NEW_OPN */
 }

void 
DEFUN_VOID(D_FINISH)
 {
 }
