/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	PatchLibraries Utility / VIEW

	FILE:	ttype.h
	TASK:	load icon settings using my _supermagahyper_ processargs

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

struct ttToolType tt[ARG_NUM+1]	=
	{
		{	"CX_POPUP",		TTF_BOOLEAN|TTF_ICONONLY,	TTDEF TRUE,					0	},
		{	"CX_PRI",		TTF_INTEGER|TTF_ICONONLY,	TTDEF 0,						0	},
		{	"CX_HOTKEY",	TTF_STRING |TTF_ICONONLY,	TTDEF "lalt lshift p",	0	},
		{	"WINX",			TTF_INTEGER|TTF_ICONONLY,	TTDEF 40,					0	},
		{	"WINY",			TTF_INTEGER|TTF_ICONONLY,	TTDEF 20,					0	},
		{	0	}
	};

static char	*AddToolTypes[]	=	{	"DONOTWAIT",
												0
											};

static char	ProgName[TT_FILELEN]	=	{	0	};

static struct ttExtra	ttExtra	=
	{
		TTEX_VERSION,
		ProgName,
		0,0,0,
		0
	};

// ---------------------------

static char	*WindowTitle	=	0,
				*DefTit			=	PROGNAME_WTIT;

// ---------------------------
// funx
// ---------------------------

BOOL InitPrefs(int argc, char *argv[])
{
	char	*str;

	if(!TT_STATUSOK(ttProcessArgs(argc,argv,tt,&ttExtra,0)))
		return FALSE;

	if(!( WindowTitle = AllocVec(strlen(DefTit) + strlen(str = ttGetString(&tt[ARG_CX_HOTKEY])) + 1, MEMF_PUBLIC) ))
		return FALSE;

	strcpy(WindowTitle,DefTit);
	strcat(WindowTitle,str);

	MainWdt	=	WindowTitle;

	return TRUE;
}

void RemPrefs(void)
{
	ttWriteIcon(tt,&ttExtra,AddToolTypes);

	ttFreeArgs(tt,0);

	if(WindowTitle)
		FreeVec(WindowTitle);
}
