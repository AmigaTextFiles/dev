/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	ViewPALIS

	this is a little example how to inform the user which patches
	are currently managed by PALIS

	FILE:	plView.h
	TASK:	include for PALIS view

	(c)1995 by Hans Bühler, h0348kil@rz.hu-berlin.de
*/

#include	"/Include.h"
#include	<PALIS.h>
#include	<ProcessArgs.h>
#include	"PalisViewGUI.h"

// ---------------------------
// defines
// ---------------------------

#define	PROGNAME			"ViewPALIS"
#define	PROGNAME_FULL	PROGNAME " V1.00 commodity"
#define	PROGNAME_VER	"$VER: " PROGNAME_FULL " by Codex Design (oct.95)"
#define	PROGNAME_WTIT	PROGNAME " V1.00 hotkey = "
#define	PROGNAME_CX		PROGNAME " V1.00 by Codex Design"

#define	MAX_LINELEN		44		// plus null-byte...;^)

// prefs
#define	ARG_CX_POPUP	0
#define	ARG_CX_PRI		1
#define	ARG_CX_HOTKEY	2
#define	ARG_WINX			3
#define	ARG_WINY			4
#define	ARG_NUM			5

// cx events
#define	CXE_POPUP		0

// various cmds
#define	CMD_OKAY			0			// DO NOT USE code1 => refresh() !!!
#define	CMD_QUIT			100
#define	CMD_HIDE			2
#define	CMD_ERRORBEEP	3
#define	CMD_REFRESH		4
#define	CMD_CANCEL		5

// ---------------------------

#define	LIST_PALIS		0
#define	LIST_ABOUT		1

// ---------------------------
// datatypes
// ---------------------------

/********************************************************************
 * these structure are used to hold a copy of what we're processing *
 ********************************************************************/

struct Line
	{
		struct Node	Node;			// see define below
	};

#define	Text	Node.ln_Name	// use Line->Name ...

// ---------------------------
// proto
// ---------------------------

// ---------------------------
// vars
// ---------------------------

extern struct Library		*GadToolsBase,*CxBase,*DiskfontBase,*IconBase;
extern struct MsgPort		*CxPort,*MsgPort;

extern CxObj					*CxMain;

extern struct ttToolType	tt[];

extern struct MinList		ActiveList;

// ---------------------------
// funx
// ---------------------------

extern void SetActiveList(UBYTE listID);
extern BOOL InitLists(void);
extern void RemLists(void);

extern LONG Req(char *txt, char *gad, APTR arg1, APTR arg2, APTR arg3, APTR arg4);
extern BOOL ErrorReq(char *txt, APTR arg1, APTR arg2, APTR arg3, APTR arg4);

extern BOOL OpenWin(void);
extern void CloseWin(void);

extern BOOL InitCom(void);
extern void RemCom(void);

extern void main(int argc, char *argv[]);

extern BOOL InitPrefs(int argc, char *argv[]);
extern void RemPrefs(void);

extern void MainLoop(void);
