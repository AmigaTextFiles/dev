/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *																		   *
 *						MultiMedia DataBase								   *
 * 						  © 1996 BetaSoft								   *
 *																		   *
 *																		   *
 * A small MultiMedia database and also a fine example for tddbase.library *
 *																		   *
 * Total time of contruction: 5 hours and 45 minutes!					   *
 *																		   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include <dos/dos.h>
#include <libraries/gadtools.h>
#include <intuition/intuition.h>
#include <libraries/asl.h>
#include <libraries/tddbase.h>
#include <proto/gadtools.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/asl.h>
#include <proto/tddbase.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Control.h"
#include "MMBase.h"

char VTAG[]="$VER: MMBase 1.0 "__AMIGADATE__;

/* Globals */
struct DBHandle *DBase;
struct FileRequester *FilReq;

/* local protos */
struct DBHandle *LocateBase(STRPTR Name);

/* Main point of entry :) */
void main(void)
{
	DBase=LocateBase("PROGDIR:MMBase.DBS");

	/*
	 * And we must check that we got a handle and that it actually is on
	 * a legal database. Actualy, the only time we get a NULL value from
	 * TDDB_OpenBase/TDDB_CreateBase is when it failed to allocate a Handle.
	 */
	if( (DBase==NULL) ||
		(DBase->Error!=NULL) )
	{
		/* We dont care much about _why_ it failed, do we? :) */
		puts("Cant open/create data base - exiting");

		/* If we got a partiall handler, we must close it to 
		 * free all its resources. */
		if(DBase)
			TDDB_CloseBase(DBase);

		exit(10);
	}

	/* Setup data about screen. */
	if(SetupScreen())
	{
		puts("Cant setup screen data");
		TDDB_CloseBase(DBase);
		exit(10);
	}

	/* Open window */
	if(OpenMainWindowWindow())
	{
		puts("Cant open window");
		CloseDownScreen();
		TDDB_CloseBase(DBase);
		exit(10);
	}

	/* Allocate a requester that we will need later. */
	FilReq=AllocAslRequestTags(ASL_FileRequest, ASLFR_Window, MainWindowWnd,
												ASLFR_RejectIcons, TRUE,
												TAG_DONE );

	/* Update scroller to represent the actual number of nodes. */
	if(DBase->DBase->Nodes)
	{
		GT_SetGadgetAttrs(MainWindowGadgets[GDX_Scroller], MainWindowWnd, NULL,
							GTSC_Total, DBase->DBase->Nodes+1,
							TAG_DONE);

		/* Time to initlize GUI for the first time... */
		if(!(InitGUI(0)))
		{
			CloseMainWindowWindow();
			CloseDownScreen();
			TDDB_CloseBase(DBase);
			exit(10);
		}
	}

	/* Handle all actions hereafter. */
	do
	{
		WaitPort(MainWindowWnd->UserPort);
	}
	while(HandleMainWindowIDCMP());

	/* Close all things. */
	CloseMainWindowWindow();
	CloseDownScreen();
	TDDB_CloseBase(DBase);
	exit(0);
}

/*
 * This functions is a small utility that either opens a database or if
 * it doesnt exist, create it.
 */
struct DBHandle *LocateBase(STRPTR Name)
{
BPTR lock;
struct DBHandle *DBase;

	if(lock=Lock(Name,SHARED_LOCK))
	{
		/* File exists, now open it */
		UnLock(lock);
		DBase=TDDB_OpenBase(Name);
	}
	else
	{
		/* File didnt exists, instead we must create this new database.
		 * TDDBCreateBaseA takes 4 arguments. The first one is the name of
		 * the database we want to create, the second one is the file/dbase
		 * format we want, the third is an specefic ID vale to identify
		 * the contents of database and the final argument is a list of tags
		 * to give better control over the creation, we want a simple
		 * database so we leave it NULL.
		 */
		DBase=TDDB_CreateBaseA(Name,FILID_STATIC,DBID_NOID,NULL);
	}

	return DBase;
}

/*
 * This routine is used to initilize GUI acording the selcted Node.
 */
int InitGUI(int NodeNr)
{
struct DBNode *Node;
STRPTR Name,Comment;

	/* Init to deafult values (these will be used if it is nothing stored
	 * in database. */
	Name="<Unknown>";
	Comment="";

	if(!(Node=TDDB_GetNode(DBase, NodeNr, MODEF_READ)))
	{
		puts("GetNode failed - exiting");
		return FALSE;
	}

	TDDB_GetDataList(Node, ID_Name, &Name,
							ID_Comment, &Comment,
							TAG_DONE);

	/* we must init all GUI's now since the string bufferns can become
	 * obsolete even before TDDB_FreeNode returns. */
	GT_SetGadgetAttrs(MainWindowGadgets[GDX_Name], MainWindowWnd, NULL,
									GTTX_Text, Name,
									TAG_DONE);

	GT_SetGadgetAttrs(MainWindowGadgets[GDX_Comments], MainWindowWnd, NULL,
									GTST_String, Comment,
									TAG_DONE);

	TDDB_FreeNode(DBase, Node);
	return TRUE;
}

/* This routine gets a file and stores the complete name in buffer. */
BOOL GetFile(STRPTR Buffer, ULONG StrLen)
{
	if(AslRequestTags(FilReq, ASLFR_InitialFile, NULL, TAG_DONE))
	{
		strcpy(Buffer, FilReq->fr_Drawer);
		AddPart(Buffer, FilReq->fr_File, StrLen);
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}