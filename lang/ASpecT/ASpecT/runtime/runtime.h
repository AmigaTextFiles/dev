/*============================================================================*/
/* The Runtime Library 1.2 for ASpecT_to_C_Compiler                           */
/*============================================================================*/

#include <ansidecl.h>    /* for ANSI C support */

#define __IMPORTED_runtime

#ifdef __STDC__
#include <stdarg.h>
#else
#ifdef SUN4
#include <varargs.h>
#endif
#endif

/*#define STATISTICS*/
/*#define ADRCHECK 0x1234567 STATISTICS may not be defined */
/*----------------------------------------------------*/
/*                W A R N I N G  !!!                  */
/* The Runtime Library requires a (machine-dependent) */
/* datatype with a length of FOUR BYTES.              */
/*----------------------------------------------------*/

typedef long unsigned FOURBYTES;

typedef struct TERMREC *TERM;
struct TERMREC { FOURBYTES NAME;
                 TERM      ARGS[1];
               };
#define ONE           0x00001000           
#define OPN(t)        (unsigned)((t)->NAME & 0x00000FFF)
#define CP(ARG)       ((ARG)->NAME+= ONE,ARG)
#define DZ_REF(t)     (((t)->NAME & 0xFFFFF000)?(t)->NAME-= ONE,0:1)
#define ONE_REF(t)    !((t)->NAME & 0xFFFFF000)
#define IS_POINTER(t) ((unsigned)t>100)

#define REGISTER register

#define BLKSIZE 800

#define TNULL (TERM)0

extern TERM EXFUN(MK   ,(unsigned,unsigned,...));
extern TERM EXFUN(MKxx1,(unsigned,TERM          ));
extern TERM EXFUN(MKxx2,(unsigned,TERM,TERM     ));
extern TERM EXFUN(MKxx3,(unsigned,TERM,TERM,TERM));
extern TERM EXFUN(MK0,  (unsigned               ));

extern TERM *FREELIST;
extern unsigned FL_LEN;
extern unsigned D_WITHDEBUG;

typedef void TYPE_FUN(PROC,(        ));
typedef TERM TYPE_FUN(FUNC,(        ));
typedef TERM TYPE_FUN(FUNCn,(TERM,...));

typedef struct SORTRECORD *SORTREC;
typedef struct CONSRECORD *CONSREC;
typedef struct INSTRECORD *INSTREC;
typedef struct OPNRECORD  *OPNREC;
typedef TERM CLOSURE;
typedef SORTREC *SORTRECP;

extern char *  EXFUN(NAMEOFSORT,(SORTREC));
extern int     EXFUN(NUMCONS,(SORTREC));
extern CONSREC EXFUN(GETCONS,(SORTREC,int));

struct SORTRECORD { char    *name;
                    int     numcons;
                    CONSREC consarr[1];
                  };
struct CONSRECORD { char     *name;
                    unsigned numargs;
                    SORTREC  argsarr[1];
                  };
struct INSTRECORD { unsigned acts,sorts,opns;
                    TERM inst[1];
                  };
struct OPNRECORD {  
                    char     *name;
                    TERM     (*fn)();
		    unsigned numargs,numres,len,is_param;
#ifdef DEBUG
		    unsigned *calls,*spypoint;
#endif
		    SORTREC  args_arr[1];
		 };

typedef void TYPE_FUN(RPROC,(SORTREC,TERM,TERM,TERM *,TERM *,TERM *));
typedef void TYPE_FUN(WPROC,(SORTREC,TERM,TERM,TERM *,TERM *));
typedef void TYPE_FUN(FPROC,(SORTREC,TERM));
typedef TERM TYPE_FUN(CFUNC,(SORTREC,TERM));
typedef TERM TYPE_FUN(EFUNC,(SORTREC,TERM,TERM));

extern TERM     EXFUN(NEW_CELL,(unsigned));
extern TERM     EXFUN(ASPECT_MALLOC,(unsigned));
extern void     EXFUN(MDEALLOC,(unsigned,TERM));
extern TERM     EXFUN(COPY,(SORTREC,TERM));
extern void     EXFUN(FREE,(SORTREC,TERM));
extern TERM     EXFUN(CP_FREE0,(SORTREC,TERM,unsigned));
extern TERM     EXFUN(CP_FREE1,(SORTREC,TERM,unsigned));
extern TERM     EXFUN(CP_FREE2,(SORTREC,TERM,unsigned,SORTREC));
extern SORTREC  EXFUN(GET_SORT,(SORTREC,unsigned));
extern SORTREC  EXFUN(COPY_SORT,(SORTREC));
extern SORTREC  EXFUN(NEW_SORT,(int, char *));
extern SORTREC  EXFUN(NEW_ESORT,(RPROC,WPROC,CFUNC,FPROC,EFUNC,char *));
extern SORTREC  EXFUN(MK_SORT,(SORTREC, ...));
extern void     EXFUN(ADD_CONS,(SORTREC,unsigned,char *,SORTREC, ...));
extern OPNREC   EXFUN(NEW_OPN,(char *,TERM (*)(),SORTREC, ... ));
extern SORTREC  _S_FUNC,_S_CON,_S_COFF,_S_CONST,_S_END,_S_IR;
extern TERM     EXFUN(_RUNTIME_EQ,(SORTREC,TERM,TERM));
extern TERM     EXFUN(goal,(TERM));
extern void     EXFUN(INIT,(unsigned));
extern void     EXFUN(LDFILE,(char *));
extern void     EXFUN(D_NEW_FILE,(char *));
extern void     EXFUN(D_CALL0,(void));

#ifndef DEBUG
#define D_POS(row,col) /* not available */
#endif

extern TERM     MT_TERM[];
#define MT      (TERM)(MT_TERM)
extern int	_RUNTIME_argc;
extern char **  _RUNTIME_argv;
extern unsigned _RUNTIME_exval;

#ifdef DEBUG
#define STACK TERM
 extern unsigned STATISTICS_def;
 extern void EXFUN(CREATE_FREELIST,(unsigned));
 extern TERM EXFUN(NEW_CELL,(unsigned));
 extern void EXFUN(STATISTIC,(void));
#ifndef __IMPORTED_rts_db
#include <rts_db.h>
#endif
#endif

/* standard prototype for Xinitialize function *****************************/

#define XINITIALIZE(Func,Var)    \
 static unsigned Var = 2;        \
 void                            \
 DEFUN(Func,(MODE),unsigned MODE)\
  {                              \
    if (Var == MODE) return;     \
    Var = MODE;                  \
    if (MODE==0) {               \
       /* Phase 1 */             \
    } else {                     \
       /* Phase 2 */             \
    }                            \
    return;                      \
  }


/* signatures for extern functions *****************************************/

#define XCOPY(op)         \
 TERM                     \
 DEFUN(op,(S,A),          \
       SORTREC S AND      \
       TERM    A)

#define XFREE(op)         \
 void                     \
 DEFUN(op,(S,A),          \
       SORTREC S AND      \
       TERM    A)

#define XEQ(op)           \
 TERM                     \
 DEFUN(op,(S,A1,A2),      \
       SORTREC S  AND     \
       TERM    A1 AND     \
       TERM    A2)

#define XREAD(op)                  \
 void                              \
 DEFUN(op,(S,A,SYSI,OK,RES,SYSO),  \
       SORTREC S    AND            \
       TERM    A    AND            \
       TERM    SYSI AND            \
       TERM    *OK  AND            \
       TERM    *RES AND            \
       TERM    *SYSO)

#define XWRITE(op)                 \
 void                              \
 DEFUN(op,(S,A,SYSI,OK,SYSO),      \
       SORTREC S    AND            \
       TERM    A    AND            \
       TERM    SYSI AND            \
       TERM    *OK  AND            \
       TERM    *SYSO)

#define DEF_XCOPY(o) TERM EXFUN(o,(SORTREC,TERM))

#define DEF_XFREE(o) void EXFUN(o,(SORTREC,TERM))

#define DEF_XEQ(o) TERM EXFUN(o,(SORTREC,TERM,TERM))

#define DEF_XREAD(o) void EXFUN(o,(SORTREC,TERM,TERM,TERM *,TERM *,TERM *))

#define DEF_XWRITE(o) void EXFUN(o,(SORTREC,TERM,TERM,TERM *,TERM *))



/* Parametrization support *************************************************/
extern void     EXFUN(par_irec_s,(INSTREC,TERM,TERM));
extern void     EXFUN(par_irec_o,(INSTREC,TERM,TERM,TERM));
extern void     EXFUN(par_irec_fin,(INSTREC));
extern INSTREC  EXFUN(copy_instrec,(INSTREC));
extern INSTREC  EXFUN(new_instrec,(unsigned,unsigned,unsigned,...));
extern OPNREC   EXFUN(INST_OPR,(OPNREC,INSTREC));
extern void     EXFUN(FREE_OPN,(OPNREC));
extern TERM     EXFUN(_RUNTIMEapply_1,(unsigned,...));
extern void     EXFUN(_RUNTIMEapply_2,(unsigned,TERM,...));


/** dynamic call support **/
#define DARGS01         a[1]
#define DARGS02 DARGS01,a[2]
#define DARGS03 DARGS02,a[3]
#define DARGS04 DARGS03,a[4]
#define DARGS05 DARGS04,a[5]
#define DARGS06 DARGS05,a[6]
#define DARGS07 DARGS06,a[7]
#define DARGS08 DARGS07,a[8]
#define DARGS09 DARGS08,a[9]
#define DARGS10 DARGS09,a[10]
#define DARGS11 DARGS10,a[11]
#define DARGS12 DARGS11,a[12]
#define DARGS13 DARGS12,a[13]
#define DARGS14 DARGS13,a[14]
#define DARGS15 DARGS14,a[15]
#define DARGS16 DARGS15,a[16]
#define DARGS17 DARGS16,a[17]
#define DARGS18 DARGS17,a[18]
#define DARGS19 DARGS18,a[19]
#define DARGS20 DARGS19,a[20]
#define DARGS21 DARGS20,a[21]
#define DARGS22 DARGS21,a[22]
#define DARGS23 DARGS22,a[23]
#define DARGS24 DARGS23,a[24]
#define DARGS25 DARGS24,a[25]


#define callswitch(X) switch(X) {\
                   case 0: a[0] = ((FUNC)op->fn)(       );break;\
                   case 1: a[0] = ((FUNCn)op->fn)(DARGS01);break;\
                   case 2: a[0] = ((FUNCn)op->fn)(DARGS02);break;\
                   case 3: a[0] = ((FUNCn)op->fn)(DARGS03);break;\
                   case 4: a[0] = ((FUNCn)op->fn)(DARGS04);break;\
                   case 5: a[0] = ((FUNCn)op->fn)(DARGS05);break;\
                   case 6: a[0] = ((FUNCn)op->fn)(DARGS06);break;\
                   case 7: a[0] = ((FUNCn)op->fn)(DARGS07);break;\
                   case 8: a[0] = ((FUNCn)op->fn)(DARGS08);break;\
                   case 9: a[0] = ((FUNCn)op->fn)(DARGS09);break;\
                  case 10: a[0] = ((FUNCn)op->fn)(DARGS10);break;\
                  case 11: a[0] = ((FUNCn)op->fn)(DARGS11);break;\
                  case 12: a[0] = ((FUNCn)op->fn)(DARGS12);break;\
                  case 13: a[0] = ((FUNCn)op->fn)(DARGS13);break;\
                  case 14: a[0] = ((FUNCn)op->fn)(DARGS14);break;\
                  case 15: a[0] = ((FUNCn)op->fn)(DARGS15);break;\
                  case 16: a[0] = ((FUNCn)op->fn)(DARGS16);break;\
                  case 17: a[0] = ((FUNCn)op->fn)(DARGS17);break;\
                  case 18: a[0] = ((FUNCn)op->fn)(DARGS18);break;\
                  case 19: a[0] = ((FUNCn)op->fn)(DARGS19);break;\
                  case 20: a[0] = ((FUNCn)op->fn)(DARGS20);break;\
                  case 21: a[0] = ((FUNCn)op->fn)(DARGS21);break;\
                  case 22: a[0] = ((FUNCn)op->fn)(DARGS22);break;\
                  case 23: a[0] = ((FUNCn)op->fn)(DARGS23);break;\
                  case 24: a[0] = ((FUNCn)op->fn)(DARGS24);break;\
                  case 25: a[0] = ((FUNCn)op->fn)(DARGS25);break;\
                  default:printf("FATAL ERROR (too many args).\n");\
                          printf("EXECUTION STOPS HERE!\n");\
                          exit(1);\
                          break;}
                 
#include <readwrite.rh>
#include <closure.rh>
#include <boolean.rh>
#include <integer.rh>
#include <char.rh>
#include <string.rh>
#include <system.rh>

