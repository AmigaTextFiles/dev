/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE:	pl.c
	TASK:	control stuff

	(c)1995 by Hans Bühler
*/

#include	"pl.h"

// ---------------------------
// defines
// ---------------------------

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

static BOOL InitSys(void);
static void RemSys(void);

// ---------------------------
// vars
// ---------------------------

#ifndef FINAL

struct Library			*CxBase			=	0;
struct MsgPort			*CxPort			=	0;

#endif

// ---------------------------

extern char				*__version		=	PROGNAME_VER,
							*__procname		=	PROGNAME;

// ---------------------------
// funx: init/rem system...
// ---------------------------

/***************************************************
 * Alle system-libs, die benötigt werden, öffnen ! *
 ***************************************************/

static BOOL InitSys(void)
{
	if(SysBase->LibNode.lib_Version < 37)
		return ErrorReq("AmigaOS V2.04+ required !",0,0,0,0);

	if(FindSemaphore(PALIS_SEMAPHORE_NAME))
		return ErrorReq(PROGNAME " is already running !",0,0,0,0);

#ifndef FINAL

	if(!( CxBase = OpenLibrary("commodities.library",37) ))
	{
		return ErrorReq(	"ERROR: Cannot open commodities.library V37+.",0,0,0,0);
	}

	if(!( CxPort  = CreateMsgPort() ))
	{
		return ErrorReq(	" ERROR: Cannot create msgports !",0,0,0,0);
	}

#endif

	return TRUE;
}

/*********************
 * weg mit den allox *
 *********************/

static void RemSys(void)
{
#ifndef FINAL

	if(CxPort)
	{
		struct Message		*msg;

		while(msg = GetMsg(CxPort))
			ReplyMsg(msg);

		DeleteMsgPort(CxPort);
	}

	if(CxBase)
		CloseLibrary(CxBase);

#endif
}

// ---------------------------
// funx: main()
// ---------------------------

void main(int argc, char *argv[])
{
	if(InitSys())
	{
#ifndef FINAL
		if(InitCom())
		{
#endif
			if(InitMyFunc())
			{
				MainLoop();
			}

			RemMyFunc();
#ifndef FINAL
		}
		RemCom();
#endif
	}
	RemSys();
}
