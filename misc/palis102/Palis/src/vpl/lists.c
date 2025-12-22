/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	PatchLibraries Utility / VIEW

	FILE:	lists.c
	TASK:	do list work

	(c)1995 by Hans Bühler, h0348kil@rz.hu-berlin.de
*/

#include	"plView.h"

// ---------------------------
// defines
// ---------------------------

#define	BUFLEN	199

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

static BOOL MakeTxtList(char *txtLines[]);
static BOOL MakePalisList(void);
static BOOL ConvertPalisList(struct plBase *plBase);
static struct Line *AllocLine(struct MinList *list, WORD len);
static void InitEmptyList(struct MinList *List);
static void RemList(void);

// ---------------------------
// vars
// ---------------------------

// ---------------------------
// funx
// ---------------------------

static char	*InfoLines[]	=
	{
//		"12345678901234567890123456789012345678901234"
		"",
		" ·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·",
		"    presents:",
		"",
		" " PROGNAME_FULL,
		"",
		" This little commodity has  been designed to",
		"view all patches PALIS V1+ had tracked.",
		" PALIS is required to use this program.",
		" PALIS (The PatchLib Solution!! ;^) had been",
		"programmed in order to avoid conflicts  when",
		"some programs patch libraries. It will track",
		"all patches  and will take  appropiate steps",
		"when a program  attempts to remove its patch",
		"later.",
		" PALIS  might be  ordered from the author or",
		"copied from the aminet (dev/misc).",
		" PALIS and ViewPALIS are freely copyable !",
		"",
		"Programmed by Hans Bühler,",
		"              Codex Design Software",
		"              Kirchstr.22",
		"              D-10557 Berlin",
		"   [codex@stern.mathematik.hu-berlin.de]",0
	},
	*NoPatchesLines[]	=
	{
		"No patch reported from PALIS !",
		0
	},
	*NoPalisLines[]	=
	{
//		"12345678901234567890123456789012345678901234"
		"--------------------------------------------",
		"ERROR: PALIS V1+ not found.",
		"--------------------------------------------",
		"",
		"Please run PALIS \"The PatchLib Solution\" and",
		"retry.",
		0
	},
	*NoMemLines[]	=
	{
		"--------------------------------------------",
		"ERROR: Out of memory !",
		"--------------------------------------------",
		0
	},
	*NoReadLines[]	=
	{
		"--------------------------------------------",
		"ERROR: PALIS refused to answer !",
		"       Have you commanded to quit PALIS ?",
		"--------------------------------------------",
		0
	},
	*GurkLines[]	=
	{
		"Unknown command.",
		0
	};

char	*RemovedTxt		=	"<removed> ",
		*EndTxt			=	"[END]";

// ---------------------------

struct MinList	ActiveList	=	{	0	};

// ---------------------------
// funx: global
// ---------------------------

#define	iSetAttrs(GDX)	if(MainWnd)	GT_SetGadgetAttrs(MainGadgets[GDX],MainWnd,0,
#define	ADONE				TAG_DONE)

void SetActiveList(UBYTE listID)
{
	BOOL	ok;

	iSetAttrs(GDX_GadList)	GTLV_Labels,	~0,	ADONE;

	switch(listID)
	{
		case	LIST_PALIS	:	ok	=	MakePalisList();
									break;
		case	LIST_ABOUT	:	ok	=	MakeTxtList(InfoLines);
									break;
		default				:	ok	=	MakeTxtList(GurkLines);
									break;
	}

	if(!ok)
		if(!MakeTxtList(NoMemLines))		// frees all allocated lines
			ErrorReq("Out of memory !",0,0,0,0);

	iSetAttrs(GDX_GadList)	GTLV_Labels,	&ActiveList,	ADONE;
}

BOOL InitLists(void)
{
	InitEmptyList(&ActiveList);

	return TRUE;
}

void RemLists(void)
{
	RemList();
}

// ---------------------------
// funx: local
// ---------------------------

/************************************************
 * delete active list									*
 * Each node will be freed by AllocVec()			*
 * => be sure a node and all data are allocated	*
 * by one step.											*
 ************************************************/

static void RemList(void)
{
	struct Line	*line;

	while(line = (struct Line *)RemHead((struct List *)&ActiveList))
		FreeVec(line);
}

/**********************************************
 * Eine liste aus einem string-array aufbauen *
 **********************************************/

static BOOL MakeTxtList(char *txtLines[])
{
	struct Line		*line;
	int				i;

	RemList();

	for(i=0; txtLines[i]; i++)
	{
		if(!( line = AllocVec(sizeof(struct Line), MEMF_PUBLIC|MEMF_CLEAR) ))
			return FALSE;

		line->Text	=	txtLines[i];

		AddTail((struct List *)&ActiveList, &line->Node);
	}

	return TRUE;
}

/************************************
 * Die PALIS process list erstellen *
 ************************************/

static BOOL MakePalisList(void)
{
	struct plBase		*plBase;
	BOOL					erg;

	RemList();

	// -- erstmal neue Liste --

	if(!(plBase = (struct plBase *)FindSemaphore(PALIS_SEMAPHORE_NAME)))
		return MakeTxtList(NoPalisLines);

	ObtainSemaphoreShared(&plBase->Sem);

	if(!plBase->PatchCnt)
		erg	=	MakeTxtList(NoPatchesLines);
	else
		erg	=	ConvertPalisList(plBase);

	ReleaseSemaphore(&plBase->Sem);

	return erg;
}

// ----------------------------

static BOOL ConvertPalisList(struct plBase *plBase)
{
	struct plLib		*plLib;
	struct plOffset	*plOff;
	struct plPatch		*plPatch;
	struct Line			*line;
	char					buf[BUFLEN+1];
	int					i;
	BOOL					first;

	// -- now start --

	for(	plLib = (APTR)plBase->LibList.mlh_Head;
			plLib->Node.mln_Succ;
			plLib = (APTR)plLib->Node.mln_Succ)
	{
		// -- "library [1 offset(s) patched]" --

		sprintf(buf,"%s [%ld offset(s) patched]",	plLib->Lib->lib_Node.ln_Name,
																plLib->OffCnt);

		if(!( line = AllocLine(&ActiveList,strlen(buf)+1) ))
			return FALSE;

		strcpy(line->Text,buf);

		// -- "----------------------------" --

		if(!( line = AllocLine(&ActiveList,strlen(buf)+1) ))
			return FALSE;

		for(i=0; i<strlen(buf); i++)
			line->Text[i]	=	'-';

		line->Text[i]	=	0;

		// -- "" --

		if(!( line = AllocLine(&ActiveList,1) ))
			return FALSE;

		line->Text[0]	=	0;

		for(	plOff = (APTR)plLib->OffList.mlh_Head;
				plOff->Node.mln_Succ;
				plOff	= (APTR)plOff->Node.mln_Succ)
		{
			// -- offset selbst nicht ausgeben --

			first	=	TRUE;

			for(	plPatch = (APTR)plOff->PatchList.mlh_Head;
					plPatch->Node.mln_Succ;
					plPatch = (APTR)plPatch->Node.mln_Succ)
			{
//				ErrorReq("offset $%lx: %ld ('%s')",plOff,(APTR)plOff->Offset,plPatch->ProcName,0);

				if(first)
				{
					sprintf(buf,"%6ld %s%s",
								plOff->Offset,
								PL_ACTIVE(plPatch) ? 0 : RemovedTxt,
								plPatch->ProcName);
				}
				else
					sprintf(buf,"       %s%s",
								PL_ACTIVE(plPatch) ? 0 : RemovedTxt,
								plPatch->ProcName);

				first	=	FALSE;

				// -- "  -120 Process" --

				if(!( line = AllocLine(&ActiveList,strlen(buf)+1) ))
					return FALSE;

				strcpy(line->Text,buf);
			}
		}

		if(!( line = AllocLine(&ActiveList,1) ))
			return FALSE;

		line->Text[0]	=	0;
	}

	if( line = AllocLine(&ActiveList,0) )
		line->Text	=	EndTxt;

	return TRUE;
}

// ---------------------------

static struct Line *AllocLine(struct MinList *list, WORD len)
{
	struct Line	*line;

	if(!( line = AllocVec(sizeof(struct Line) + len, MEMF_PUBLIC) ))
		return 0;

	line->Text	=	&((char *)line)[sizeof(struct Line)];

	AddTail((struct List *)list,&line->Node);

	return line;
}

// ---------------------------
// funx: list set
// ---------------------------

/*******************
 * init empty list *
 *******************/

static void InitEmptyList(struct MinList *List)
{
	List->mlh_Head		=	(struct MinNode *)&List->mlh_Tail;
	List->mlh_Tail		=	0;
	List->mlh_TailPred=	(struct MinNode *)&List->mlh_Head;
}
