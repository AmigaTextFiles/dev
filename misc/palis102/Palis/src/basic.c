/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE:	Basic.c
	TASK:	basix for my use

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

static char		*TitleTxt	=	PROGNAME " request";

// ---------------------------
// funx: lists
// ---------------------------

/*******************
 * init empty list *
 *******************/

void InitEmptyList(struct MinList *List)
{
	List->mlh_Head		=	(struct MinNode *)&List->mlh_Tail;
	List->mlh_Tail		=	0;
	List->mlh_TailPred=	(struct MinNode *)&List->mlh_Head;
}

// ------------------------------------
// funx: I/O
// ------------------------------------

/*****************************************/
/* Requester; uses reqtools if available */
/*****************************************/

LONG Req(char *txt, char *gad, APTR arg1, APTR arg2, APTR arg3, APTR arg4)
{
	struct EasyStruct		easy;

	easy.es_StructSize	=	sizeof(struct EasyStruct);
	easy.es_Flags			=	0;
	easy.es_Title			=	TitleTxt;
	easy.es_TextFormat	=	txt;
	easy.es_GadgetFormat	=	gad;

	return	EasyRequest(0,&easy,0,arg1,arg2,arg3,arg4);
}

/*****************************/
/* error requester short cut */
/*****************************/

BOOL ErrorReq(char *txt, APTR arg1, APTR arg2, APTR arg3, APTR arg4)
{
	Req(txt,"Cancel",arg1,arg2,arg3,arg4);
	return FALSE;
}

