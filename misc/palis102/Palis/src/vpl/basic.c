/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	PatchLibraries Utility / VIEW

	FILE:	basic.c
	TASK:	requesters & stuff

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

static char		*TitleTxt	=	PROGNAME " message";

// ---------------------------
// funx
// ---------------------------

/*****************************************/
/* Requester; uses reqtools if available */
/*****************************************/

LONG Req(char *txt, char *gad, APTR arg1, APTR arg2, APTR arg3, APTR arg4)
{
	register struct rtReqInfo	*rInfo;
	register LONG					ret;
	struct ReqToolsBase			*ReqToolsBase;

	if((ReqToolsBase = (APTR)OldOpenLibrary("reqtools.library")) &&
		(rInfo = rtAllocRequestA(RT_REQINFO,0)) )
	{
		APTR		args[4];

		args[0]	=	arg1;
		args[1]	=	arg2;
		args[2]	=	arg3;
		args[3]	=	arg4;

		ret	=	rtEZRequestTags(txt,gad,rInfo,args,
											RT_WaitPointer,TRUE,
											RT_ShareIDCMP,	TRUE,
											RTEZ_ReqTitle,	TitleTxt,
											RTEZ_Flags,		EZREQF_CENTERTEXT,
											TAG_DONE);

		rtFreeRequest(rInfo);
	}
	else
	{
		register struct EasyStruct		easy;

		easy.es_StructSize	=	sizeof(struct EasyStruct);
		easy.es_Flags			=	0;
		easy.es_Title			=	TitleTxt;
		easy.es_TextFormat	=	txt;
		easy.es_GadgetFormat	=	gad;

		ret	=	EasyRequest(0,&easy,0,arg1,arg2,arg3,arg4);
	}

	if(ReqToolsBase)
		CloseLibrary((APTR)ReqToolsBase);		// we don't want to make use of too much memory !

	return ret;
}

/*****************************/
/* error requester short cut */
/*****************************/

BOOL ErrorReq(char *txt, APTR arg1, APTR arg2, APTR arg3, APTR arg4)
{
	Req(txt,"Cancel",arg1,arg2,arg3,arg4);
	return FALSE;
}

