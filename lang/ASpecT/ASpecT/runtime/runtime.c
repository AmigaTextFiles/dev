/*============================================================================*/
/* The Runtime Library 1.2 for ASpecT_to_C_Compiler                           */
/*============================================================================*/

/* Options (set in caller's main program by compiler)
    DEBUG       : the RTS is modified for use with the ASpecT-Debugger
    STATISTICS  : the RTS is modified to watch activities of memory
*/

#include <runtime.h>

#ifdef STATISTICS
 /* The statistic values are only treated if STATISTICS defined
    While the program is running the variable
     A contains the number of really allocated TERM cells,
     M contains the number of MKs and
     D contains the number of freed TERM cells
     APPLY contains the number of APPL-nodes in Functionals
     CCL contains (roughly) the number of shared closures
     UCL contains (roughly) the number of unshared closures
     MEMF is initialized by brks and contains the initial memory location
     USEDLIST is an array reporting the allocated cells of all sizes
 */

 FOURBYTES D,A,M,APPLY,CCL,UCL,MEMF;
 unsigned *USEDLIST;
#endif


FOURBYTES MAX_FL;

SORTREC _S_FUNC =(SORTREC) 1,
        _S_CON  =(SORTREC) 2,
        _S_COFF =(SORTREC) 3,
        _S_CONST=(SORTREC) 4,
        _S_END  =(SORTREC) 5,
        _S_IR   =(SORTREC) 6;

TERM *FREELIST;

unsigned FL_LEN=1;
  /* The minimal length of a freelist is 1             */
  /*  This variable is incremented by the generated    */
  /*  programs and is used to build the freelist later */

FILE *STDIN,*STDOUT;



extern char * EXFUN(malloc,(unsigned));


static SORTREC
DEFUN(ALLOC_SORTREC,(cons),
      int cons)
 { if (cons<0) cons=0;
   return (SORTREC) malloc(     sizeof(char *)+
				sizeof(int)+
				cons*sizeof(CONSREC));
 }

static CONSREC
DEFUN(ALLOC_CONSREC,(sorts),
      unsigned sorts)
 { return (CONSREC) malloc(	sizeof(char*)+
				sizeof(unsigned)+
				sorts*sizeof(SORTREC));
 }

static OPNREC
DEFUN(ALLOC_OPNREC,(sorts),
      int sorts)
 { return (OPNREC) malloc(	sizeof(char*)+
#ifdef DEBUG
				2*sizeof(unsigned*)+
#endif
				sizeof(TERM)+
				4*sizeof(unsigned)+
				sorts*sizeof(SORTREC));
 }

static INSTREC
DEFUN(ALLOC_INSTREC,(a,s,o),
      unsigned a AND
      unsigned s AND
      unsigned o)
 { return (INSTREC) malloc(3*sizeof(unsigned)+
			   (a+s+2*o)*sizeof(TERM));
 }

#define ALLOC_TERMS(n) (malloc((n)*sizeof(TERM)))


char *
DEFUN(NAMEOFSORT,(s),
      SORTREC s)
 { return s->name; }

int
DEFUN(NUMCONS,(s),
      SORTREC s)
 { return s->numcons; }

CONSREC
DEFUN(GETCONS,(s,i),
      SORTREC s AND
      int     i)
 { return s->consarr[i]; }

unsigned _RUNTIME_exval;

void
DEFUN(CREATE_FREELIST,(maxargs),
      unsigned maxargs)
 { unsigned i;
#ifdef STATISTICS
   D=A=M=APPLY=CCL=UCL=0;
   USEDLIST=(unsigned*)ALLOC_TERMS(maxargs);
   for (i=0;i<maxargs;USEDLIST[i++]=0);
#endif
   MAX_FL=maxargs;
   FREELIST=(TERM*)ALLOC_TERMS(maxargs);
   for (i=0;i<maxargs;FREELIST[i++]=NULL);
 }

void
DEFUN_VOID(STATISTIC)
 {
   long unsigned i,j,free_store;
   TERM ptr;

   printf("\n");
   printf("Statistics\n");
#ifdef STATISTICS
   printf(" allocated cells : %lu\n",A);
   printf(" used cells      : %lu\n",M);
   printf(" freed cells     : %lu\n",D);
   printf(" normal closures : %lu\n",UCL);
   printf(" apply closures  : %lu\n",APPLY);
   printf(" shared closures : %lu\n",CCL);
   printf(" cells in use    : ");
   for (i=0;i<MAX_FL;i++)
            printf("%lu ",USEDLIST[i]);
   printf("\n");
#endif
   printf(" free-cell-list  : ");
   free_store=0;
   for (i=0;i<MAX_FL;i++) {
     if (FREELIST[i]) {
       j=1; ptr=FREELIST[i];
       while (ptr=ptr->ARGS[0]) j++;
       printf("%lu ",j);
       free_store += j*(sizeof(FOURBYTES) + (i+1)*sizeof(TERM));
     }
     else printf("0 ");
   }
   printf("\n");
#ifdef STATISTICS
   printf("memory overhead       : %lu\n",sbrk(1)-MEMF-free_store);
   printf("(currently) free cells: %lu(%lu Bytes)\n\n",A-(M-D),free_store);
#else
   printf("(currently) free cells: %lu Bytes\n\n",free_store);
#endif
 }

static FOURBYTES *HEAP,REST;

#define ASPECT_MALLOC_x(numargs,numargs1)                \
 { extern void EXFUN(exit,(unsigned));                   \
   REGISTER TERM RES;                                    \
  if (numargs >= REST) {                                 \
    if (REST > 1) {                                      \
      ((TERM)HEAP)->ARGS[0]=FREELIST[REST -= 2];         \
      FREELIST[REST]=(TERM)HEAP;                         \
    }                                                    \
    if ((RES=(TERM) ALLOC_TERMS(BLKSIZE)) == NULL) {     \
      printf("Memory full !!!\n");                       \
      STATISTIC();                                       \
      exit(1);                                           \
    }                                                    \
    HEAP=(FOURBYTES *)RES + numargs1;                    \
    REST=BLKSIZE - numargs1;                             \
  }                                                      \
  else {                                                 \
    RES   = (TERM) HEAP;                                 \
    HEAP += numargs1;                                    \
    REST -= numargs1;                                    \
  }                                                      \
  return RES;                                            \
 }

TERM DEFUN_VOID(ASPECT_MALLOC_0) ASPECT_MALLOC_x(0,1)
TERM DEFUN_VOID(ASPECT_MALLOC_1) ASPECT_MALLOC_x(1,2)
TERM DEFUN_VOID(ASPECT_MALLOC_2) ASPECT_MALLOC_x(2,3)
TERM DEFUN_VOID(ASPECT_MALLOC_3) ASPECT_MALLOC_x(3,4)

#undef ASPECT_MALLOC_x

TERM
DEFUN(ASPECT_MALLOC,(numargs),
      unsigned numargs)
 { extern void EXFUN(exit,(unsigned));
   REGISTER TERM RES;
  if (numargs >= REST) {
    if (REST > 1) {
      ((TERM)HEAP)->ARGS[0]=FREELIST[REST -= 2];
      FREELIST[REST]=(TERM)HEAP;
    }
    if ((RES=(TERM) ALLOC_TERMS(BLKSIZE)) == NULL) {
      printf("Memory full !!!\n");
      STATISTIC();
      exit(1);
    }
    HEAP=(FOURBYTES *)RES + (++numargs);
    REST=BLKSIZE - numargs;
  }
  else {
    RES   = (TERM) HEAP;
    HEAP += (++numargs);
    REST -= numargs;
  }
  return RES;
 }

TERM
DEFUN(CCP,(ARG),
      TERM ARG)
 { ARG->NAME += ONE;return ARG;}

TERM
DEFUN(MK0,(opname),
      unsigned opname)
 { REGISTER TERM p=(TERM) ASPECT_MALLOC_0();
   p->NAME=opname;
   return p;
 }

#ifdef ADRCHECK
TERM
DEFUN(NEW_CELL,(numargs),
      unsigned numargs)
 { REGISTER TERM p;
   REGISTER TERM *h = &(FREELIST[numargs-1]);
   if (*h) {
     *h=(p= *h)->ARGS[0];}
   else p=ASPECT_MALLOC(numargs);
   if ((unsigned)p == ADRCHECK)
      printf(">>>free adr<<<\n");
   return p;
}
#else
#ifdef STATISTICS
TERM
DEFUN(NEW_CELL,(numargs),
      unsigned numargs)
 { REGISTER TERM *h = &(FREELIST[numargs-1]);
   USEDLIST[numargs-1]++;
   M++;
   if (*h) { REGISTER TERM p;
     *h=(p= *h)->ARGS[0];
     return p;
   }
   else { A++; return ASPECT_MALLOC(numargs); }
}
#else

#define NEW_CELL_x(numargs0,allocfunc)           \
 { REGISTER TERM *h = &(FREELIST[numargs0]);     \
   if (*h) { REGISTER TERM p;                    \
     *h=(p= *h)->ARGS[0];                        \
     return p;                                   \
   }                                             \
   else return allocfunc();                      \
}

TERM DEFUN_VOID(NEW_CELL_1) NEW_CELL_x(0,ASPECT_MALLOC_1)
TERM DEFUN_VOID(NEW_CELL_2) NEW_CELL_x(1,ASPECT_MALLOC_2)
TERM DEFUN_VOID(NEW_CELL_3) NEW_CELL_x(2,ASPECT_MALLOC_3)

TERM
DEFUN(NEW_CELL,(numargs),
      unsigned numargs)
 { REGISTER TERM *h = &(FREELIST[numargs-1]);
   if (*h) { REGISTER TERM p;
     *h=(p= *h)->ARGS[0];
     return p;
   }
   else return ASPECT_MALLOC(numargs);
}
#endif
#endif


#ifdef __STDC__
#define VAR_args  
#define VAR_decl    ...
#define VAR_decl1   va_list ap;
#define VAR_init(l) va_start(ap,l)
#define VAR_val     va_arg(ap,TERM)
#define VAR_end     va_end(ap)
#else
#ifdef SUN4
#define VAR_args    va_alist
#define VAR_decl    va_dcl
#define VAR_decl1   va_list ap;
#define VAR_init(l) va_start(ap)
#define VAR_val     (TERM)va_arg(ap, char *)
#define VAR_end     va_end(ap)
#else
#define VAR_args    args
#define VAR_decl    TERM args;
#define VAR_decl1   REGISTER TERM *arg;
#define VAR_init(l) arg = &args
#define VAR_val     *arg++
#define VAR_end
#endif
#endif

TERM
DEFUN_(MK,(numargs,opname,VAR_args),
      unsigned numargs AND
      unsigned opname  AND
      VAR_decl)
 { REGISTER TERM p=NEW_CELL(numargs);
   REGISTER unsigned i=0;
   VAR_decl1
   p->NAME=opname;
   VAR_init(opname);
   while(i<numargs) p->ARGS[i++] = VAR_val;
   VAR_end;
   return p;
 }

TERM
DEFUN(MKxx1,(opname,T1),
      unsigned opname AND
      TERM     T1)
 { REGISTER TERM p=
#ifdef NEW_CELL_x
                    NEW_CELL_1();
#else
                    NEW_CELL(1);
#endif
   p->NAME=opname;
   p->ARGS[0]=T1;
   return p;
 }

TERM
DEFUN(MKxx2,(opname,T1,T2),
      unsigned opname AND
      TERM     T1     AND
      TERM     T2)
 { REGISTER TERM p=
#ifdef NEW_CELL_x
                    NEW_CELL_2();
#else
                    NEW_CELL(2);
#endif
   p->NAME=opname;
   p->ARGS[0]=T1;
   p->ARGS[1]=T2;
   return p;
 }

TERM
DEFUN(MKxx3,(opname,T1,T2,T3), 
      unsigned opname AND
      TERM     T1     AND
      TERM     T2     AND
      TERM     T3)
 { REGISTER TERM p=
#ifdef NEW_CELL_x
                    NEW_CELL_3();
#else
                    NEW_CELL(3);
#endif
   p->NAME=opname;
   p->ARGS[0]=T1;
   p->ARGS[1]=T2;
   p->ARGS[2]=T3;
   return p;
 }

void
DEFUN(MDEALLOC,(numargs,term),
      unsigned numargs AND
      TERM     term)
 { REGISTER TERM *h;
#ifdef STATISTICS
   USEDLIST[numargs-1]--;
   D++;
#endif
#ifdef ADRCHECK
    if ((unsigned)term == ADRCHECK) 
      printf(">>>use adr<<<\n");
#endif
   h = &(FREELIST[numargs-1]);
   term->ARGS[0] = *h;
   *h = term;
 }

/* COPY - FREE Speedup ... works for normal constructors only.
   NEITHER closures NOR external sorts
*/

TERM
DEFUN(CP_FREE0,(sort,a_term,copyarg),
      SORTREC  sort   AND
      TERM     a_term AND
      unsigned copyarg)
 { 
#define CP_FREE_xx                                            \
   if (DZ_REF(a_term)){                                       \
     REGISTER       TERM     tmp;                             \
     REGISTER       unsigned i   = 0;                         \
     REGISTER CONST CONSREC  cr  = sort->consarr[OPN(a_term)];\
     REGISTER       SORTREC  *sr = cr->argsarr;               \
     REGISTER CONST unsigned na  = cr->numargs;               \
     while(i<copyarg) FREE(*sr++,a_term->ARGS[i++]);          \
     tmp=a_term->ARGS[i++];                                   \
     while(i<na) FREE(*(++sr),a_term->ARGS[i++]);             \
     MDEALLOC(na,a_term);                                     \
     return tmp;                                              \
   }
   CP_FREE_xx else
     return a_term->ARGS[copyarg];
 }

TERM
DEFUN(CP_FREE1,(sort,a_term,copyarg),
      SORTREC  sort    AND
      TERM     a_term  AND
      unsigned copyarg)
 { 
   CP_FREE_xx else
     return CP(a_term->ARGS[copyarg]);
}
 
TERM
DEFUN(CP_FREE2,(sort,a_term,copyarg,asort),
      SORTREC  sort    AND
      TERM     a_term  AND
      unsigned copyarg AND
      SORTREC  asort)
 { 
   CP_FREE_xx else {
     if (asort==_S_FUNC)
         return copy_CLOSURE((CLOSURE)a_term->ARGS[copyarg]);
     if (asort->numcons<0) {
        if(asort->numcons==-30000)
          return CP(a_term->ARGS[copyarg]);
        if(asort->numcons<-1)
          return a_term->ARGS[copyarg];
        return ((CFUNC)(asort->consarr[2]))(asort,a_term->ARGS[copyarg]);
     }
     return CP(a_term->ARGS[copyarg]);
   }
 }

#undef CP_FREE_xx
 
void
DEFUN(FREE,(sort,a_term),
      SORTREC sort   AND
      TERM    a_term)
 { REGISTER CONSREC cr;
   REGISTER unsigned na;
L0:
   if (sort==_S_FUNC) {free_CLOSURE((CLOSURE)a_term);return;}
   if (sort->numcons<0) {
     if (sort->numcons==-30000) {
       cr=sort->consarr[0];
       if((na=cr->numargs)==1) {free_CLOSURE((CLOSURE)a_term);return;}
     } else {
       if (sort->numcons==-1)
         ((FPROC)(sort->consarr[3]))(sort,a_term);
       return;
     }
   } else {
     cr=sort->consarr[OPN(a_term)];
     if ((na=cr->numargs)==0) return;
   }
   if (DZ_REF(a_term)){
     REGISTER unsigned i=na; 
     if(--i) {
       REGISTER SORTREC *sr=cr->argsarr;
       REGISTER TERM *p = &(a_term->ARGS[0]);
       FREE(*sr++,*p++);
       while(--i) FREE(*sr++,*p++);
       MDEALLOC(na,a_term);
       a_term = *p;
       sort = *sr;
     } else {
       REGISTER CONST TERM p = a_term->ARGS[0];
       MDEALLOC(na,a_term);
       a_term = p;
       sort = *(cr->argsarr);
     }
/* previous version
     REGISTER unsigned i=0; 
     REGISTER SORTREC *sr=cr->argsarr;
     REGISTER TERM p;
     na--;
     while(i<na) FREE(*sr++,a_term->ARGS[i++]);
     p = a_term->ARGS[i];
     MDEALLOC(na+1,a_term);
     a_term = p;
     sort = *sr;
*/
     goto L0;
 } }
 

TERM
DEFUN(COPY,(sort,a_term),
      SORTREC sort   AND
      TERM    a_term)
 { if (sort==_S_FUNC) return copy_CLOSURE((CLOSURE)a_term);
   else if (sort->numcons<0) {
      if(sort->numcons==-30000) return CP(a_term);
      else if(sort->numcons<-1) return a_term;
      else return ((CFUNC)(sort->consarr[2]))(sort,a_term);
   }
   else return CP(a_term);
 }
 
SORTREC
DEFUN(NEW_SORT,(cons,sn),
      int   cons AND
      char *sn)
 { SORTREC sr;
   sr=ALLOC_SORTREC(cons);
   sr->name=sn;
   sr->numcons=cons;
   return sr;
 }

SORTREC
DEFUN(NEW_ESORT,(r,w,c,f,e,sn),
      RPROC r AND
      WPROC w AND
      CFUNC c AND
      FPROC f AND
      EFUNC e AND
      char *sn)
 { SORTREC sr;
   sr=ALLOC_SORTREC(6);
   sr->name=sn;
   sr->numcons = -1;
   sr->consarr[0]=(CONSREC)r;
   sr->consarr[1]=(CONSREC)w;
   sr->consarr[2]=(CONSREC)c;
   sr->consarr[3]=(CONSREC)f;
   sr->consarr[4]=(CONSREC)e;
   sr->consarr[5]=NULL;
   return sr;
 }


static
void
DEFUN(FREE_SORT,(sr),
      SORTREC sr)
 { 
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(SORTREC));
#endif
   static void EXFUN(FREE_CONS,(CONSREC));
   if(sr->numcons == -30000) {
     FREE_CONS(sr->consarr[0]);
     free(sr);
   } else if(sr->numcons < 0) {
     if (sr->consarr[5]!=NULL) FREE_CONS(sr->consarr[5]);
     free(sr);
   }
 }

SORTREC
DEFUN(COPY_SORT,(sr),
      SORTREC sr)
 { REGISTER SORTREC nsr;
   REGISTER unsigned i;
   CONSREC EXFUN(COPY_CONS,(CONSREC));
   if (sr->numcons == -30000) {
     nsr=ALLOC_SORTREC(1);
     nsr->name=sr->name;
     nsr->numcons = sr->numcons;
     nsr->consarr[0]=COPY_CONS(sr->consarr[0]);
     return nsr;
   }
   if (sr->numcons < 0) {
     nsr=ALLOC_SORTREC(6);
     nsr->name=sr->name;
     nsr->numcons= sr->numcons;
     for (i=0;i<6;i++) nsr->consarr[i]=sr->consarr[i];
     if (nsr->consarr[5]!=NULL) nsr->consarr[5]=COPY_CONS(sr->consarr[5]);
     return nsr;
   }
   nsr=ALLOC_SORTREC(sr->numcons);
   nsr->name=sr->name;
   nsr->numcons = sr->numcons;
   if (sr->numcons>0)
    for (i=0;i<sr->numcons;i++) nsr->consarr[i]=COPY_CONS(sr->consarr[i]);
   return nsr;
 }

SORTREC
DEFUN(GET_SORT,(sr,i),
      SORTREC sr AND 
      unsigned i)
 { return (SORTREC)(sr->consarr[5]->argsarr[i]); }
 
#ifdef __STDC__
#define AC_argplus arg=va_arg(ap,SORTREC)
#define AC_argst   va_start(ap,parg); arg=parg
#define AC_argsdef 
#define AC_argsdec SORTREC parg, ...
#define AC_argacc  arg
#define AC_vardec  AC_argacc; va_list ap
#define AC_varend  va_end(ap)
#else
#ifdef SUN4
#define AC_argplus arg=(SORTREC)va_arg(ap,char *)
#define AC_argst   va_start(ap);AC_argplus
#define AC_argsdef va_alist
#define AC_argsdec va_dcl
#define AC_argacc  arg
#define AC_vardec  AC_argacc;va_list ap
#define AC_varend  va_end(ap)
#else
#define AC_argst   arg= &args
#define AC_argplus arg++
#define AC_argsdef args
#define AC_argsdec SORTREC args;
#define AC_argacc  *arg
#define AC_vardec  AC_argacc
#define AC_varend
#endif
#endif

static CONSREC  AC_cr;
static unsigned AC_m,AC_i,AC_j,AC_argnum,AC_resno,AC_argmax,AC_IR;
static SORTREC  *AC_argsarr,*AC_cr_argsarr;
static void EXFUN(AC_global,(unsigned,unsigned));

static void
DEFUN_VOID(AC_doit)
 { if (AC_m) { if (AC_i<AC_argmax) AC_cr_argsarr[AC_i++]=AC_argsarr[AC_j-1]; }
   else { AC_argnum++; AC_resno++; }
 }
 
static void
DEFUN(AC_function,(infunc,truef),
      unsigned infunc AND
      unsigned truef)
 { 
   if (truef) { if (!infunc) AC_doit();
               AC_global(TRUE ,TRUE);
               AC_global(TRUE ,TRUE);
             }
   else      { AC_global(infunc,TRUE);
               AC_resno=0;
               AC_global(infunc,FALSE);
             }
 }

static void
DEFUN(AC_tuple,(infunc),
      unsigned infunc)
 { for (;;) {
     if (AC_argsarr[AC_j]==_S_COFF) 
        { if (AC_m) AC_cr_argsarr[AC_argnum+AC_j+AC_IR]=AC_argsarr[AC_j];
          AC_j++;
          return;
        }
     AC_global(infunc,TRUE);
   }
 }
 
static void
DEFUN(AC_global,(infunc,truef),
      unsigned infunc AND
      unsigned truef)
 { 
   if (AC_m) AC_cr_argsarr[AC_argnum+AC_j+AC_IR]=AC_argsarr[AC_j]; 
   if (AC_argsarr[AC_j]==_S_FUNC) {AC_j++; AC_function(infunc,truef); } 
   else
   if (AC_argsarr[AC_j]==_S_CON ) {AC_j++; AC_tuple(infunc); } 
   else
   { AC_j++; 
     if (infunc) return;
     AC_doit();
   }
 }



#define CALC_IR_I	                                         \
 /* AC_IR setzen, AC_I auf Anzahl der TAGS */                    \
   AC_argst;                                                     \
    AC_IR=0; if (AC_argacc==_S_IR) { AC_IR=1; AC_argplus; }      \
    AC_i=0; while (AC_argacc!=_S_END) { AC_i++; AC_argplus; }    \
   AC_varend
 
#define GEN_ARR                                                  \
 /* AC_argsarr mit den TAGS initialisieren */                    \
   AC_argst;                                                     \
    AC_argsarr= (SORTREC*)malloc(AC_i*sizeof(SORTREC));          \
    if (AC_argacc==_S_IR) AC_argplus;                            \
    AC_i=0; while (AC_argacc!=_S_END)                            \
                  { AC_argsarr[AC_i++]=AC_argacc; AC_argplus; }  \
   AC_varend

#define COUNT_ARGS			\
   AC_m=FALSE; AC_argnum=0; AC_resno=0; \
   AC_i=0; AC_j=0;                      \
   AC_global(FALSE,FALSE)

#define FILLUP                                    \
   AC_m=TRUE;                                     \
   AC_i=0; AC_j=0;                                \
   if (AC_IR==1) AC_cr_argsarr[AC_argnum]=_S_IR;  \
   AC_global(FALSE,FALSE);                        \
   free(AC_argsarr)
	
SORTREC
DEFUN_(MK_SORT,(AC_argsdef),
      AC_argsdec)
 { SORTREC sort;
   SORTREC AC_vardec;
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(SORTREC *));
#endif
   sort=ALLOC_SORTREC(1);
   sort->name    = NULL;
   sort->numcons = -30000;


   AC_argst;
   if (AC_argacc==_S_CONST) { /* special case for constants */
          AC_cr=sort->consarr[0] = ALLOC_CONSREC(1);
          AC_cr->name=NULL;
          AC_cr->numargs=0;
          AC_argplus; AC_cr->argsarr[0]=AC_argacc;
          AC_varend;
          return sort;
   }
   
   CALC_IR_I;
   GEN_ARR;
   COUNT_ARGS;
   
   if(AC_argsarr[0]==_S_FUNC) {
     AC_argnum = 1;
   }
          
   AC_cr=sort->consarr[0]=ALLOC_CONSREC(AC_argnum+AC_j);
   AC_cr->name=NULL;
   AC_cr->numargs=AC_argnum;
   
   if(AC_argsarr[0]==_S_FUNC) {
     AC_argmax = 0; /* prevent anything to be inserted */
     AC_cr->argsarr[0] = _S_FUNC;
   } else
     AC_argmax = AC_argnum;
   
   AC_cr_argsarr= AC_cr->argsarr;
   FILLUP;
   return sort;
 }
 
void
DEFUN_(ADD_CONS,(sort,consno,consname,AC_argsdef),
      SORTREC  sort      AND
      unsigned consno    AND
      char     *consname AND
      AC_argsdec)
 { REGISTER SORTREC AC_vardec;
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(SORTREC *));
#endif
   AC_argst;
   if (AC_argacc==_S_CONST) { /* special case for constants */
          AC_cr=sort->consarr[consno] = ALLOC_CONSREC(1);
          AC_cr->name=consname;
          AC_cr->numargs=0;
          AC_argplus; AC_cr->argsarr[0]=AC_argacc;
          AC_varend;
          return;
   }
   
   CALC_IR_I;
   GEN_ARR;
   COUNT_ARGS;
   
   AC_argmax=AC_argnum;      
   AC_argnum=AC_argnum-AC_resno;
          
   AC_cr=sort->consarr[consno]=ALLOC_CONSREC(AC_argnum+AC_j);
   AC_cr->name=consname;
   AC_cr->numargs=AC_argnum;
   
   AC_argmax=AC_argnum; /* different to NEW_OPN: prevent res to be inserted */
   AC_cr_argsarr= AC_cr->argsarr;
   FILLUP;
}
 

#define PUSH(D,L) MK(2,1,D,L)

#ifndef DEBUG

/* These are the pseudo defines needed to run a 
   program compiled in DEBUG-mode without the
   rts_db-package
*/

unsigned D_ROW, D_COL, NODBX;

void
DEFUN(D_NEW_FILE,(fn),
      char *fn)
  { }

void
DEFUN(LDFILE,(fn),
      char *fn)
  { NODBX=FALSE; }

void
DEFUN_VOID(D_CALL0)
  { printf("* The ASpecT Runtime Debugger has not been linked.\n");
    printf("*  The execution continues normally but a bit slower,\n");
    printf("*  as it could be without debugger code.\n\n\n");
  }

#endif

OPNREC
DEFUN_(NEW_OPN,(opname,adr,AC_argsdef),
      char *opname  AND
      TERM (*adr)() AND
      AC_argsdec)
 { REGISTER OPNREC opn;
   REGISTER SORTREC AC_vardec;
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(SORTREC *));
#endif
   
   CALC_IR_I;
   GEN_ARR;
   COUNT_ARGS;
   
   AC_argmax=AC_argnum;      
   AC_argnum=AC_argnum-AC_resno;
   
 /* Maximale Closurelaenge anpassen */
   if (FL_LEN < (AC_argmax+4+AC_IR)) FL_LEN=AC_argmax+4+AC_IR;
 
   opn = ALLOC_OPNREC(AC_argmax+AC_IR+AC_j);
   opn->fn=adr;
   opn->numargs=AC_argnum;
   opn->numres=AC_resno;
   opn->len=AC_j;
   
   AC_argnum=AC_argmax;
   AC_cr_argsarr= opn->args_arr;
   FILLUP;
   
   opn->name=opname;
   opn->is_param=(AC_IR==1);
#ifdef DEBUG
   opn->spypoint=(unsigned*) malloc(sizeof(unsigned));
   *(opn->spypoint) = 0;
   opn->calls=(unsigned*) malloc(sizeof(unsigned));
   *(opn->calls) = 0;
   D_OPN_STACK=PUSH(opn,D_OPN_STACK);
#endif
   return opn;
 }
 
#undef CALC_IR_I
#undef GEN_ARR
#undef COUNT_ARGS
#undef FILLUP

#undef AC_argst
#undef AC_argplus
#undef AC_argsdef
#undef AC_argsdec
#undef AC_vardec
#undef AC_argacc
#undef AC_varend


static
unsigned
DEFUN(len_CONS,(cr),
      CONSREC cr)
 { REGISTER i=cr->numargs;
   REGISTER n=0;
   do {
     if (cr->argsarr[i]==_S_CON ) n++;
     if (cr->argsarr[i]==_S_COFF) n--;
     i++;
   } while (n>0);
   return i;
 }


static
void
DEFUN(FREE_CONS,(cr),
      CONSREC cr)
 { REGISTER unsigned i,j;
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(CONSREC));
#endif
   if (cr->numargs!=0) {
      j = len_CONS(cr);
      for (i=0;i<j;i++)
         if (IS_POINTER(cr->argsarr[i]))
            FREE_SORT(cr->argsarr[i]);
   }
   free(cr);
 }


CONSREC
DEFUN(COPY_CONS,(cr),
      CONSREC cr)
 { REGISTER CONSREC ncr;
   REGISTER unsigned i,j;
   if (cr->numargs==0) i=1; else j=i=len_CONS(cr);
   ncr=ALLOC_CONSREC(i);
   ncr->name=cr->name;
   ncr->numargs=cr->numargs;
   if (cr->numargs==0) ncr->argsarr[0]=cr->argsarr[0];
   else for (i=0;i<j;i++)
            if(IS_POINTER(cr->argsarr[i]))
              if(cr->argsarr[i]->numcons == -30000)
                ncr->argsarr[i]=COPY_SORT(cr->argsarr[i]);
              else
                ncr->argsarr[i]=cr->argsarr[i];
            else
              ncr->argsarr[i]=cr->argsarr[i];
   return ncr;
 }


/*
 * Generate a new instantiation record out of the given elements
 *
 *  !! Attention: Calls to this function are generated by the
 *  !!            ASpecT compiler.
 *
 *             nacts  == number of child-instantiation records
 *             nsorts == number of (formal) sorts
 *             nopns  == number of (formal) operations
 *             <...>  == sorts, operations and instrecs in that row
 */

INSTREC
DEFUN_(new_instrec,(nacts,nsorts,nopns,VAR_args),
       unsigned nacts  AND
       unsigned nsorts AND
       unsigned nopns  AND
       VAR_decl)
{ REGISTER INSTREC ir;
  REGISTER unsigned i,j;

/* set the args-pointer BEFORE the args */
  VAR_decl1
  VAR_init(nopns);


/* allocate memory for the record */
  ir = ALLOC_INSTREC(nacts,nsorts,nopns);

/* store the sorts */
  ir->sorts = nsorts;
  j = nsorts;
  for (i=0;i<j;i++) 
      ir->inst[i] = VAR_val;

/* store the operations */
  ir->opns = nopns;
  j += 2*nopns;
  for (;i<j;i++) {
      ir->inst[i++] = VAR_val; 
      ir->inst[i] = (TERM) 0;  /* none given yet */
  }

/* store the child-instantiation records */
  ir->acts = nacts;
  i = j;
  j += nacts;
  for (;i<j;i++) 
      ir->inst[i] = VAR_val;

  VAR_end;
  return ir;		
}


static
void
DEFUN(par_irec_s_tup,(cr,f,t),
      CONSREC cr AND
      TERM    f  AND
      TERM    t)
{ REGISTER unsigned i;
  REGISTER unsigned j = len_CONS(cr);
  for(i=0;i<j;i++)
    if (cr->argsarr[i]==(SORTREC)f)
       cr->argsarr[i]=(SORTREC)t;
    else
       if (IS_POINTER(cr->argsarr[i]))
          if(cr->argsarr[i]->numcons == -30000)
             par_irec_s_tup(cr->argsarr[i]->consarr[0],f,t);
}


void
DEFUN(par_irec_s,(ir,f,t),
      INSTREC ir AND
      TERM    f  AND
      TERM    t)
{ REGISTER unsigned i;
  for (i=0;i<ir->sorts;i++) 
      if (ir->inst[i]==f) ir->inst[i]=t;
      else if (IS_POINTER(ir->inst[i]))
              if (((SORTREC)ir->inst[i])->numcons == -30000)
                 par_irec_s_tup(((SORTREC)ir->inst[i])->consarr[0],f,t);
  for (i=ir->sorts+2*ir->opns;i<ir->acts+ir->sorts+2*ir->opns;i++) 
      par_irec_s((INSTREC)ir->inst[i],f,t);
}


void
DEFUN(par_irec_o,(ir,f,t,u),
      INSTREC ir AND
      TERM    f  AND
      TERM    t  AND
      TERM    u)
{ REGISTER unsigned i;
  for (i=ir->sorts;i<ir->sorts+2*ir->opns;i++,i++)
      if (ir->inst[i]==f) {ir->inst[i]=t;ir->inst[i+1]=u;}
  for (i=ir->sorts+2*ir->opns;i<ir->acts+ir->sorts+2*ir->opns;i++) 
      par_irec_o((INSTREC)ir->inst[i],f,t,u);
}


void
DEFUN(par_irec_fin,(ir),
      INSTREC ir)
{ 
}


/*
 * Make a copy (for later parametrisation) of an instantiation record
 *
 *  !! Attention: Calls to this function are generated by the
 *  !!            ASpecT compiler.
 *
 */

static INSTREC
DEFUN(copy_instrec_0,(ir), 
      INSTREC ir)
{ REGISTER unsigned i,j;
  REGISTER INSTREC c;

/* allocate memory for the new record as required by the record to copy */
  c = ALLOC_INSTREC(ir->acts,ir->sorts,ir->opns);

/* copy the sorts */
  c->sorts = ir->sorts;
  j = ir->sorts;
  for (i=0;i<j;i++)
      if(IS_POINTER(ir->inst[i])) /* is it a SORTREC? */
        if(((SORTREC)ir->inst[i])->numcons == -30000) /* tupel sort */
          c->inst[i] = (TERM)COPY_SORT((SORTREC)ir->inst[i]);
        else
          c->inst[i] = ir->inst[i];
      else 
        c->inst[i] = ir->inst[i];

/* copy the opns and their IRs */
  c->opns = ir->opns;
  j += 2*ir->opns;
  for (;i<j;i++)
      c->inst[i] = ir->inst[i];

/* copy the child-records (recursive descend) */
  c->acts = ir->acts;
  j += ir->acts;
  for (;i<j;i++) 
     c->inst[i] = (TERM)copy_instrec_0((INSTREC)ir->inst[i]);

  return c;
}

static void
DEFUN(update_opn_IRs_0,(ir,f,t),
      INSTREC ir AND
      TERM    f  AND
      TERM    t)
{ REGISTER unsigned i,j;

/* what out for the IRs of the formal opns stored here */
  i = ir->sorts;
  j = i + 2*ir->opns;
  for (i++;i<j;i++,i++)
      if (ir->inst[i]==f) ir->inst[i]=t;

/* recursive descend into the child-records */
  i = j;
  j += ir->acts;
  for (;i<j;i++) 
      update_opn_IRs_0((INSTREC)ir->inst[i],f,t);
}


static void
DEFUN(update_opn_IRs,(ir,c,root), 
      INSTREC ir   AND
      INSTREC c    AND
      INSTREC root)
{ REGISTER unsigned i,j;

/* if needed change ir to c everywhere in the whole structure */
  if (ir!=c)
     update_opn_IRs_0(root,(TERM)ir,(TERM)c);

/* recursive descend into the child-records */
  i = ir->sorts+2*ir->opns;
  j = i+ir->acts;
  for (;i<j;i++)
      update_opn_IRs((INSTREC)ir->inst[i],(INSTREC)c->inst[i],root);
}


INSTREC
DEFUN(copy_instrec,(ir), 
      INSTREC ir)
{ INSTREC c = copy_instrec_0(ir);
/* now change all IRs which belong to the formal opns to the new
   addresses - this cannot be done in the previous sweep because
   we have a cyclic graph structure */
  update_opn_IRs(ir,c,c);
  return c;
}


static
void
DEFUN(INST_SORTS,(from,to,ir,irlen,cnt),
      SORTREC  *from AND
      SORTREC  *to   AND
      INSTREC  ir    AND
      unsigned irlen AND
      unsigned cnt)
{  while(cnt>0)
    { if (IS_POINTER(*from))
         if ((*from)->numcons == -30000) {
            *to=COPY_SORT(*from);
            INST_SORTS((*from)->consarr[0]->argsarr,
                       (*to)  ->consarr[0]->argsarr,
                       ir,irlen,
                       len_CONS((*from)->consarr[0]));
            from++; to++; cnt--;
            continue;
         }
      (*to)=(*from);
      if (!(((*to)==_S_FUNC )||
            ((*to)==_S_CON  )||
            ((*to)==_S_COFF )||
            ((*to)==_S_IR   )||
            ((*to)==_S_CONST))){
         if ((unsigned)(*to)<=irlen)
            (*to)=(SORTREC) ir->inst[(unsigned)(*to)-1-(unsigned)_S_IR];
      }
      from++; to++; cnt--;
    }
}

OPNREC
DEFUN(INST_OPR,(opn,ir),
      OPNREC opn AND
      INSTREC ir)
 { REGISTER unsigned i;
   REGISTER OPNREC op=ALLOC_OPNREC(opn->numargs+opn->numres+1+opn->len);
   op->name     = opn->name;
   op->fn       = opn->fn;
#ifdef DEBUG
   op->spypoint = opn->spypoint;
   op->calls    = opn->calls;
#endif
   op->numargs  = opn->numargs;
   op->numres   = opn->numres;
   op->is_param = opn->is_param;
   op->len      = opn->len;
   INST_SORTS(opn->args_arr,op->args_arr,
              ir,ir->acts+ir->sorts+ir->opns+(unsigned)_S_IR+1,
              opn->numargs+opn->numres+1+opn->len);
   return op;
 }

void
DEFUN(FREE_OPN,(opn),
      OPNREC opn)
 { 
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(OPNREC));
#endif
   REGISTER unsigned i;
 /* for(i=0;i<opn->numargs+opn->numres+1+opn->len;i++)
      if (IS_POINTER(opn->args_arr[i]))
         FREE_SORT(opn->args_arr[i]);
 */ free(opn);
 }


TERM
DEFUN_(_RUNTIMEapply_1,(numargs,VAR_args),  /* tuple(N,T1,..,TN)   */
      unsigned numargs AND
      VAR_decl)
 { REGISTER TERM p=NEW_CELL(numargs);
   REGISTER unsigned i;
   VAR_decl1
   VAR_init(numargs);
   p->NAME=0;
   for (i=0;i<numargs;p->ARGS[i++] = VAR_val);
   VAR_end;
   return p;
 }

void
DEFUN_(_RUNTIMEapply_2,(numargs,T,VAR_args),  /* untuple(N,X,R1,..,RN) */
      unsigned numargs AND
      TERM     T       AND
      VAR_decl)
 { REGISTER unsigned i;
   VAR_decl1
   VAR_init(T);
   if(DZ_REF(T)) {
     for (i=0;i<numargs; (VAR_val),*(TERM *)(VAR_val) = T->ARGS[i++]);
     MDEALLOC(numargs,T);
   } else {
     REGISTER SORTREC srt;
     for (i=0;i<numargs;) {
       srt = (SORTREC)(VAR_val);
       *(TERM *)(VAR_val) = COPY(srt,T->ARGS[i++]);
     }
   }
   VAR_end;
 }

static int
DEFUN(NCEQ,(sort,a_term1,a_term2),
      SORTREC sort     AND
      TERM    a_term1  AND
      TERM    a_term2)
 { REGISTER CONSREC cr;
   REGISTER unsigned i;
   if (sort==_S_FUNC) return EQ_Closure((CLOSURE)a_term1,(CLOSURE)a_term2);
   if (sort->numcons<0) 
    { if (sort->numcons == -30000) {
        if (sort->consarr[0]->numargs==1) 
           return EQ_Closure((CLOSURE)a_term1,(CLOSURE)a_term2);
      } else
      if (sort->numcons<-1)
       return (int)
        ((EFUNC)(sort->consarr[4]))(sort,a_term1,a_term2);
      else
       return (int)
        ((EFUNC)(sort->consarr[4]))(sort,COPY(sort,a_term1),COPY(sort,a_term2));
    }
   if (OPN(a_term1) != OPN(a_term2)) return FALSE;
   cr=sort->consarr[OPN(a_term1)];
   for (i=0;i<cr->numargs;i++)
     if (!NCEQ(cr->argsarr[i],a_term1->ARGS[i],a_term2->ARGS[i])) return FALSE;
   return TRUE;
 }

TERM
DEFUN(_RUNTIME_EQ,(sort,a_term1,a_term2),
      SORTREC sort    AND
      TERM    a_term1 AND
      TERM    a_term2)
 { REGISTER int RES;
   RES=NCEQ(sort,a_term1,a_term2);
   FREE(sort,a_term1);
   FREE(sort,a_term2);
   return (TERM) RES;
 }
 
 
#ifdef DEBUG
unsigned STATISTICS_def;
#endif

static void
DEFUN_VOID(INIT_SORTREC)
 { HEAP=(FOURBYTES *)malloc(BLKSIZE*sizeof(TERM));
   REST=BLKSIZE;
#ifdef DEBUG
#ifdef STATISTICS
   STATISTICS_def=1;
#else
   STATISTICS_def=0;
#endif
   D_INIT();
#endif
 }

/*************************************************/

#include <readwrite.rc>
#include <closure.rc>
#include <boolean.rc>
#include <char.rc>
#include <integer.rc>
#include <string.rc>
#include <system.rc>

int _RUNTIME_argc; char **_RUNTIME_argv;

TERM MT_TERM[] = {TNULL,TNULL,(TERM)""};

void
DEFUN(INIT,(ARGS),
      unsigned ARGS)
 { REGISTER unsigned i;
#ifdef DEBUG
#ifdef NEED_STD_DECL
   extern void EXFUN(free,(TERM *));
#endif
   free(FREELIST); /* see D_INIT  */
#endif
   i=(MAXSTR >> 2)+1;if (ARGS<i)ARGS=i;
   CREATE_FREELIST(ARGS);
 }

TERM
DEFUN(goal,(ARG0),
      TERM ARG0)
 {return ARG0;}

#ifdef STATISTICS
#include <sys/types.h>
#endif

unsigned D_WITHDEBUG=FALSE;

int 
DEFUN(main,(argc,argv),
      int argc AND
      char *argv[])
{
  char* inbuf, *outbuf;
  extern void EXFUN(exit,(unsigned));
  extern void EXFUN(__MAIN,(void));
  if(sizeof(FOURBYTES)!=4) {
     printf("*** Unsuitable installation of the ASpecT runtime system.");
     printf("*** The size of FOURBYTES is %d and must be 4.",sizeof(FOURBYTES));
     printf("*** Check your runtime files and recompile.");
     exit(255);
  }
#ifdef STATISTICS
  MEMF = sbrk(1);
#endif
  _RUNTIME_argc= argc;
  _RUNTIME_argv= &argv[0];
  _RUNTIME_exval=0;
  inbuf = malloc(BUFSIZ);
  outbuf= malloc(BUFSIZ);
  setvbuf(stdin,inbuf,_IOLBF,BUFSIZ);
  setvbuf(stdout,outbuf,_IOLBF,BUFSIZ);
  INIT_READWRITE();
  INIT_SORTREC();
  
  BOOLEAN_RINITIALIZE();
  CHAR_RINITIALIZE();
  INTEGER_RINITIALIZE();
  STRING_RINITIALIZE();
  SYSTEM_RINITIALIZE();
  
  __MAIN();
#ifdef STATISTICS
  STATISTIC();
#endif
  exit(_RUNTIME_exval);
  return 0;
}
