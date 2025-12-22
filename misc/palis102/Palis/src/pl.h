/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE:	pl.h
	TASK:	include

	(c)1995 by Hans Bühler
*/

#include	"Include.h"
#include	"Palis.h"

// ---------------------------
// defines
// ---------------------------

#define	FINAL							1	// if defined, PALIS cannot be stopped !
												// execept using CTRL_C

// ---------------------------

// basic things
#define	PROGNAME						"PALIS V1.02"
#define	PROGNAME_FULL				"PALIS V1.02"
#define	PROGNAME_VER				"$VER: The_PatchLib_Solution:PALIS V1.02 (jan.96)"
#define	PROG_PRI						-5

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// vars
// ---------------------------

// com.c
#ifndef FINAL
extern CxObj				*CxMain;
// pl.c
extern struct Library	*CxBase;
extern struct MsgPort	*CxPort;
#endif

extern struct ExecBase	*SysBase;

// setman.c
extern struct plBase		plBase;

// ---------------------------
// proto
// ---------------------------

// basic.c
extern void InitEmptyList(struct MinList *List);
extern LONG Req(char *txt, char *gad, APTR arg1, APTR arg2, APTR arg3, APTR arg4);
extern BOOL ErrorReq(char *txt, APTR arg1, APTR arg2, APTR arg3, APTR arg4);

#ifndef FINAL
// com.c
extern BOOL InitCom(void);
extern void RemCom(void);
#endif

// main.c
extern void MainLoop(void);

// pl.c
extern void main(int argc, char *argv[]);

// setman.c
extern BOOL InitMyFunc(void);
extern void RemMyFunc(void);
