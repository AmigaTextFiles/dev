/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	ViewPALIS

	this is a little example how to inform the user which patches
	are currently managed by PALIS

	FILE:	plView.c
	TASK:	upraisin'

	(c)1995 by Hans Bühler, h0348kil@rz.hu-berlin.de
*/

#include	"plView.h"

// ---------------------------
// defines
// ---------------------------

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

// ---------------------------
// vars
// ---------------------------

struct Library		*GadToolsBase	=	0,
						*CxBase			=	0,
						*DiskfontBase	=	0,
						*IconBase		=	0;
struct MsgPort		*CxPort			=	0,
						*MsgPort			=	0;

// ---------------------------

extern char			*__version		=	PROGNAME_VER;

// ---------------------------
// funx: system
// ---------------------------

static BOOL InitSys(void)
{
	if(!( GadToolsBase = OpenLibrary("gadtools.library",37) ) ||
		!( CxBase		 = OpenLibrary("commodities.library",37) ) ||
		!( IconBase		 = OpenLibrary("icon.library",37) ) ||
		!( DiskfontBase = OpenLibrary("diskfont.library",37) ))
	{
		return ErrorReq(	PROGNAME ": Cannot open\n"
								"gadtools.library    V37+ or\n"
								"icon.library        V37+ or\n"
								"commodities.library V37+ or\n"
							 	"diskfont.library    V37+ !",0,0,0,0);
	}

	if(!( MsgPort = CreateMsgPort() ) ||
		!( CxPort = CreateMsgPort() ))
	{
		return ErrorReq(PROGNAME ": No msg ports !",0,0,0,0);
	}

	return TRUE;
}

static void RemSys(void)
{
	struct Message	*msg;

	if(MsgPort)
		DeleteMsgPort(MsgPort);		// all msgs my own !

	if(CxPort)
	{
		while(msg = GetMsg(CxPort))
			ReplyMsg(msg);

		DeleteMsgPort(CxPort);
	}

	if(IconBase)
		CloseLibrary(IconBase);
	if(CxBase)
		CloseLibrary(CxBase);
	if(DiskfontBase)
		CloseLibrary(DiskfontBase);
	if(IconBase)
		CloseLibrary(IconBase);
}

// ---------------------------
// funx: main
// ---------------------------

void main(int argc, char *argv[])
{
	if(InitSys())
	{
		if(InitPrefs(argc,argv))
		{
			if(InitCom())
			{
				MainLoop();
			}
			RemCom();
		}
		RemPrefs();
	}
	RemSys();
}
