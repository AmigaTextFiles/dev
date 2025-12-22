/* This file contains empty template routines that
 * the IDCMP handler will call uppon. Fill out these
 * routines with your code or use them as a reference
 * to create your program.
 */

#include <dos/dos.h>
#include <exec/memory.h>
#include <libraries/asl.h>
#include <libraries/gadtools.h>
#include <intuition/intuition.h>
#include <libraries/tddbase.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/intuition.h>
#include <proto/tddbase.h>
#include <stdio.h>

#include "Control.h"
#include "MMBase.h"

/* This is the node that we are curently showing. */
static ULONG NodeNr=NULL;

/* The about requester */
struct EasyStruct About=
{
	sizeof(struct EasyStruct),
	0,
	"MMBase",
	"MultiMedia DataBase 1.0\n"
	"\n"
	"This is a small demo of\n"
	"how easy it is to create\n"
	"complete database apps\n"
	"using tddbase.library",
	"OK"
};

int ScrollerClicked( void )
{
struct DBNode *Node;
STRPTR Name,Comment;

	NodeNr=MainWindowMsg.Code;

	/* Get the right node from database. */
	if(!(Node=TDDB_GetNode(DBase, NodeNr, MODEF_READ)))
	{
		printf("Cant get node %d, error %d\n",NodeNr, DBase->Error);
		return FALSE;
	}

	/* Set deafult values. */
	Name=Comment="";
	TDDB_GetDataList(Node, ID_Name, &Name, ID_Comment, &Comment,NULL);

	GT_SetGadgetAttrs(MainWindowGadgets[GD_Name], MainWindowWnd,NULL,
									GTTX_Text,Name,
									TAG_DONE);

	GT_SetGadgetAttrs(MainWindowGadgets[GD_Comments], MainWindowWnd,NULL,
									GTST_String, Comment,
									TAG_DONE);

	TDDB_FreeNode(DBase, Node);

	return TRUE;
}

int CommentsClicked( void )
{
struct DBNode *Node;
STRPTR String;

	/* Get the right node from database. */
	if(!(Node=TDDB_GetNode(DBase, NodeNr, MODEF_WRITE)))
	{
		printf("Cant get node %d, error %d\n",NodeNr, DBase->Error);
		return FALSE;
	}

	/* Store the new comments string in database */
	String=GetString(MainWindowGadgets[GD_Comments]);
	TDDB_SetData(DBase, Node, ID_Comment, (ULONG)String);

	TDDB_FreeNode(DBase, Node);

	return TRUE;
}

int ShowClicked( void )
{
BPTR File;
ULONG *Data,Size;
struct DBNode *Node;

	/* Get the right node from database. */
	if(!(Node=TDDB_GetNode(DBase, NodeNr, MODEF_WRITE)))
	{
		printf("Cant get node %d, error %d\n",NodeNr, DBase->Error);
		return FALSE;
	}

	if(Data=(ULONG *)TDDB_GetDataValue(Node, ID_Data))
	{
		Size=*Data-4;
	}
	else
	{
		puts("No data storaged...");

		/* No need to quit app because there are no data storaged... */
		return TRUE; 
	}

	if(File=Open("T:MMBase_tempfile", MODE_NEWFILE))
	{
		if(Size!=Write(File, &Data[1], Size))
		{
			puts("Write error");
			Close(File);
			return TRUE;	/* No need to quit here either... */
		}

		Close(File);

		/* And now we invoke Multiview to show the file. */
		System("Multiview T:MMBase_tempfile", TAG_DONE);

		/* And the delete it. */
		DeleteFile("T:MMBase_tempfile");
	}
	else
	{
		puts("Cant open \"T:MMBase_tempfil\" ");
	}

	return TRUE;
}

int MainWindowMenu_NewNode( void )
{
struct DBNode *Node;
char Buffer[256];
ULONG *Data,Size;
BPTR File;

/*
 * __aligned is a special SAS/C option that makes shure that the data is
 * always longword aligned on stack, only works with stackcheck turned on.
 */
__aligned struct FileInfoBlock fib;

	if(GetFile(Buffer, 256))
	{
		if(!(File=Open(Buffer, MODE_OLDFILE)))
		{
			printf("Cant open file \"%s\"\n",Buffer);

			/* no need to bail out just because we cant open file... */
			return TRUE;
		}

		ExamineFH(File, &fib);

		Size=fib.fib_Size;

		/* Allocates 4 extra bytes to store size. */
		if(!(Data=AllocMem(Size+4, MEMF_ANY)))
		{
			puts("Cant allocate memory");
			return FALSE;
		}
		/* Stores size. */
		Data[0]=Size+4;

		/* Loads contents */
		Read(File, &Data[1], Size);

		Close(File);

		if(!(Node=TDDB_NewNode(DBase)))
		{
			puts("Cant create new node - exiting");
			return FALSE;
		}

		NodeNr=Node->NodeNr;

		/* stores it in i database. */
		TDDB_SetDataList(DBase,Node,ID_Data, Data,
									ID_Name, FilReq->fr_File,
									TAG_DONE);
		TDDB_FreeNode(DBase, Node);

		/* Updates GUI. */
		GT_SetGadgetAttrs(MainWindowGadgets[GD_Scroller], MainWindowWnd, NULL,
									GTSC_Total, DBase->DBase->Nodes+1,
									GTSC_Top, DBase->DBase->Nodes+1,
									TAG_DONE);

		InitGUI(NodeNr);
	}

	return TRUE;
}

int MainWindowItem0( void )
{
	/* routine when (sub)item "About..." is selected. */
    EasyRequest(NULL, &About, NULL);

	return TRUE;
}

int MainWindowItem1( void )
{
	/* routine when (sub)item "Quit" is selected. */
	return FALSE;
}

int MainWindowCloseWindow( void )
{
	return FALSE;
}
