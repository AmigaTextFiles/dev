/*============================================================================*/
/* The Runtime Library 1.2 for ASpecT_to_C_Compiler                           */
/*=DEBUGGER-PACK==============================================================*/

#define __IMPORTED_rts_db

#ifndef __IMPORTED_runtime
#include <runtime.h>
#endif

#define D_POS(row,col) D_COL=col,D_ROW=row

extern void EXFUN(D_CALL,(OPNREC,TERM *));
extern void EXFUN(D_EXIT,(TERM *));
extern void EXFUN(D_INIT,(void));
extern void EXFUN(D_FINISH,(void));
extern unsigned EXFUN(D_show_sort,(char *));

extern STACK D_OPN_STACK;

extern
unsigned D_WRITEDEPTH,/* global variable for writing a term via debugger     */
	 D_LISTMODE,  /* if 1 a list is seen as a flat structure             */
	 D_TCMODE,    /* if 1 the termcount is printed too                   */
	 D_WRITEDEBUG,/* if 1 a term is been printed by debugger             */
	 D_ROW,       /* here's the colum of the current call (set by D_POS) */
	 D_COL,       /* here's the row   of the current call (set by D_POS) */
	 NODBX;       /* used in generated programs to load a textfile       */
