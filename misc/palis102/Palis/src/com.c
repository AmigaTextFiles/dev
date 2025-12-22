/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE:	com.c
	TASK:	establish cx control

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

// ---------------------------
// vars
// ---------------------------

#ifndef FINAL

static struct NewBroker	NewBroker	=	{	NB_VERSION,
														PROGNAME,
														PROGNAME_FULL,
														"(c)1995 by Hans Bühler: Codex Design",
														NBU_UNIQUE|NBU_NOTIFY,
														0,
														0,					// PRI set by tooltypes
														0					// PORT set by prog
													};

CxObj							*CxMain		=	0;

// ---------------------------
// funx
// ---------------------------

/******************
 * run cx control *
 ******************/

BOOL InitCom(void)
{
	ULONG				ErrCode;

	NewBroker.nb_Port	=	CxPort;
	NewBroker.nb_Pri	=	0;			// getCX_PRI

	if(!( CxMain = CxBroker(&NewBroker,&ErrCode) ))
	{
		if(ErrCode != CBERR_DUP)
			ErrorReq("ERROR: Cannot create cxBroker !",0,0,0,0);
		return FALSE;
	}

	return TRUE;
}

/***********+************
 * terminate cx control *
 ***********+************/

void RemCom(void)
{
	if(CxMain)
	{
		ActivateCxObj(CxMain,FALSE);
		DeleteCxObjAll(CxMain);
	}
}

#endif
