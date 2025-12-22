/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	PatchLibraries Utility / VIEW

	FILE:	pl.c
	TASK:	control stuff

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

static struct NewBroker	NewBroker	=
	{
		NB_VERSION,
		PROGNAME,
		PROGNAME_CX,
		"See what PALIS has done for you !",
		NBU_UNIQUE|NBU_NOTIFY,
		COF_SHOW_HIDE,
		0,		// pri
		0		// port
	};

CxObj		*CxMain			=	0;

// ---------------------------
// funx
// ---------------------------

BOOL InitCom(void)
{
	CxObj		*fil		=	0,
				*sen		=	0,
				*trans	=	0;
	ULONG		ErrCode;

	NewBroker.nb_Pri		=	ttGetInt(&tt[ARG_CX_PRI]) % 10;
	NewBroker.nb_Port		=	CxPort;

	if(!( CxMain = CxBroker(&NewBroker,&ErrCode) ))
		if(ErrCode == CBERR_DUP)
			return FALSE;				// be quiet

	if(CxMain)
		if(fil = CxFilter(ttGetString(&tt[ARG_CX_HOTKEY])))
		{
			AttachCxObj(CxMain,fil);

			if(sen = CxSender(CxPort,CXE_POPUP))
			{
				AttachCxObj(fil,sen);

				if(trans = CxTranslate(0))
					AttachCxObj(fil,trans);
			}
		}

	if(!trans)
	{
		return ErrorReq(PROGNAME " error:\n"
							"Cannot crate commodities communication !",0,0,0,0);
	}

	return TRUE;
}

void RemCom(void)
{
	struct Message	*msg;

	if(CxMain)
	{
		Forbid();

		while(msg = GetMsg(CxPort))
			ReplyMsg(msg);

		ActivateCxObj(CxMain,FALSE);
		DeleteCxObjAll(CxMain);			// will rem all allocated objects !

		Permit();
	}
}
