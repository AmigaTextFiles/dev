/*
 *	File:					ProjectIO.c
 *	Description:	Defines the structure of the configuration and events.
 *								Reads and writes the project as an IFF-FORM.
 *
 *	(C) 1993,1994,1995 Ketil Hunn
 *
 */

#ifndef PROJECTIO_C
#define	PROJECTIO_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "System_Prefs.h"
#include "ProjectIO.h"
#include <clib/iffparse_protos.h>
#include <libraries/iffparse.h>
#include "myinclude:MyIFFfunctions.h"

/*** DEFINES *************************************************************************/
#define ID_EVNT	MAKE_ID('E','V','N','T')
#define ID_FOLD	MAKE_ID('F','O','L','D')
#define ID_DONE	MAKE_ID('D','O','N','E')
#define ID_ETXT	MAKE_ID('E','T','X','T')
#define ID_DATE	MAKE_ID('D','A','T','E')

#define ID_FLAG	MAKE_ID('F','L','A','G')
#define ID_STMP	MAKE_ID('S','T','M','P')

#define ID_TYPE	MAKE_ID('T','Y','P','E')
#define ID_SHOW	MAKE_ID('S','H','O','W')
#define ID_ESCR	MAKE_ID('E','S','C','R')
#define ID_PDIR	MAKE_ID('P','D','I','R')
#define ID_STAC	MAKE_ID('S','T','A','C')
#define ID_PRIO	MAKE_ID('P','R','I','O')
#define ID_TOUT	MAKE_ID('T','O','U','T')

/*** GLOBALS *************************************************************************/
struct PrefHeader PrefHdrChunk={VERSION,0,0};

/*** FUNCTIONS ***********************************************************************/
__stackext LONG ReadEventChunks(struct IFFHandle *iff, struct List *list)
{
	struct ContextNode	*cn;
	struct EventNode		*node, *folder;
	char 								name[MAXCHARS];
	LONG								error;
	register BYTE				success=TRUE;

#ifdef MYDEBUG_H
	DebugOut("ReadEventChunks");
#endif
	while(success)
	{
		error=ParseIFF(iff, IFFPARSE_RAWSTEP);
		if(error==IFFERR_EOC)
			continue;
		else if(error)
			break;

		if(cn=CurrentChunk(iff))
		{
			switch(cn->cn_ID)
			{
				case ID_EVNT:
					ReadChunkBytes(iff, (APTR)&name, cn->cn_Size);
					success=(BYTE)(node=AddEventNode(list, NULL, name));
					break;
				case ID_STMP:
					ReadChunkBytes(iff, (APTR)&node->datestamp, cn->cn_Size);
					break;
				case ID_FLAG:
					ReadChunkBytes(iff, (APTR)&node->flags, cn->cn_Size);
					break;
				case ID_TYPE:
					ReadChunkBytes(iff, (APTR)&node->type, cn->cn_Size);
					break;
				case ID_SHOW:
					ReadChunkBytes(iff, (APTR)&node->show, cn->cn_Size);
					break;
				case ID_ESCR:
					ReadChunkBytes(iff, (APTR)&name, cn->cn_Size);
					RenameText(&node->screen, name);
					break;
				case ID_PDIR:
					ReadChunkBytes(iff, (APTR)&name, cn->cn_Size);
					RenameText(&node->dir, name);
					break;
				case ID_STAC:
					ReadChunkBytes(iff, (APTR)&node->stack, cn->cn_Size);
					break;
				case ID_PRIO:
					ReadChunkBytes(iff, (APTR)&node->priority, cn->cn_Size);
					break;
				case ID_TOUT:
					ReadChunkBytes(iff, (APTR)&node->timeout, cn->cn_Size);
					break;

				case ID_FOLD:
					ReadChunkBytes(iff, (APTR)&name, cn->cn_Size);
					if(success=(BYTE)(folder=AddDirNode(list, NULL, name)))
						ReadEventChunks(iff, folder->children);
					break;
				case ID_DONE:
					return error;
					break;

				case ID_ETXT:
					ReadChunkBytes(iff, (APTR)&name, cn->cn_Size);
					if(node)
						success=(BYTE)(AddNode(node->textlist, NULL, name));
					break;
				case ID_DATE:
					if(node)
					{
						struct DateNode dnode, *date;

						success=(BYTE)(date=AddDateNode(node->datelist, NULL, ""));
						if(ReadChunkBytes(iff, (APTR)&dnode, cn->cn_Size)==sizeof(struct DateNode))
						{


							date->whendate		=dnode.whendate;
							date->day					=dnode.day;
							date->month				=dnode.month;
							date->year				=dnode.year;
							date->dateperiod	=dnode.dateperiod;
							date->daterepeat	=dnode.daterepeat;

							date->whentime		=dnode.whentime;
							date->hour				=dnode.hour;
							date->minutes			=dnode.minutes;
							date->year				=dnode.year;
							date->timeperiod	=dnode.timeperiod;
							date->timerepeat	=dnode.timerepeat;
							date->weekdays		=dnode.weekdays;

							date->week=dnode.week;
/*
#ifndef RECALL_CHECKER
							SetWhenString(date, FALSE);
#endif
*/
						}
					}
					break;
			}
		}
	}
	if(!success)
		FailAlert(MSG_OUTOFMEMORY);	
	return error;
}

LONG ReadIFF(struct List *list, char *file)
{
	struct IFFHandle		*iff;
	struct ContextNode	*cn;
	struct PrefHeader		header;
	LONG								error=IFFERR_EOF;

#ifdef MYDEBUG_H
	DebugOut("ReadIFF");
#endif
	if(iff=AllocIFF())
	{
		if(iff->iff_Stream=Open(file, MODE_OLDFILE))
		{
			InitIFFasDOS (iff);
			if(!(error=OpenIFF(iff, IFFF_READ)))
			{
				ParseIFF(iff, IFFPARSE_RAWSTEP);
				if(cn=CurrentChunk(iff))
				{
					if(cn->cn_ID!=ID_FORM & cn->cn_Type!=ID_PREF)
						error=2;
					else
					{
						ParseIFF(iff, IFFPARSE_RAWSTEP);
						cn=CurrentChunk(iff);
						if(cn->cn_ID!=ID_PRHD)
							error=2;
						else
						{
							ReadChunkBytes(iff, (APTR)&header, cn->cn_Size);
							error=ReadEventChunks(iff, list);
						}
					}
				}
				else
					error=2;
				CloseIFF (iff);
			}
			Close (iff->iff_Stream);
		}
		else
			DisplayBeep(NULL);
		FreeIFF (iff);
	}
	return error;
}

__stackext void WriteEventDates(struct IFFHandle *iff, struct List *list)
{
	struct Node *node;

#ifdef MYDEBUG_H
	DebugOut("WriteEventDates");
#endif
	for(every_node)
	{
		struct DateNode *datenode=(struct DateNode *)node;

		myWriteChunkStruct(iff, ID_DATE, (APTR)datenode, sizeof(struct DateNode));
	}
}

__stackext void WriteEventTexts(struct IFFHandle *iff, struct List *list)
{
	struct Node *node;

#ifdef MYDEBUG_H
	DebugOut("WriteEventTexts");
#endif
	for(every_node)
		myWriteChunkText(iff, ID_ETXT, node->ln_Name);
}

__stackext void WriteEventChunks(struct IFFHandle *iff, struct List *list)
{
	struct Node *node;

#ifdef MYDEBUG_H
	DebugOut("WriteEventChunks");
#endif

	for(every_node)
	{
		struct EventNode *enode=(struct EventNode *)node;

		if(node->ln_Type==REC_DIR)
		{
			myWriteChunkText(iff, ID_FOLD, node->ln_Name);
			WriteEventChunks(iff, enode->children);
			myWriteID(iff, ID_DONE);
		}
		else
		{
			myWriteChunkText(iff, ID_EVNT, node->ln_Name);
			if(enode->datestamp)
				myWriteChunkData(iff, ID_STMP, (APTR)&enode->datestamp);
			if(enode->flags)
				myWriteChunkData(iff, ID_FLAG, (APTR)&enode->flags);

			if(enode->type)
				myWriteChunkData(iff, ID_TYPE, (APTR)&enode->type);
			if(enode->show)
				myWriteChunkData(iff, ID_SHOW,(APTR)&enode->show);
			if(enode->screen)
				myWriteChunkText(iff, ID_ESCR, enode->screen);
			if(enode->dir)
				myWriteChunkText(iff, ID_PDIR, enode->dir);
			if(enode->stack)
				myWriteChunkData(iff, ID_STAC, (APTR)&enode->stack);
			if(enode->priority)
				myWriteChunkData(iff, ID_PRIO, (APTR)&enode->priority);
			if(enode->timeout)
				myWriteChunkData(iff, ID_TOUT, (APTR)&enode->timeout);

			WriteEventDates(iff, enode->datelist);
			WriteEventTexts(iff, enode->textlist);

		}
	}
}

LONG WriteIFF(struct List *list, char *file)
{
	struct IFFHandle *iff;
	LONG error;

#ifdef MYDEBUG_H
	DebugOut("WriteIFF");
#endif

	if(iff=AllocIFF())
	{
		if(iff->iff_Stream=Open(file, MODE_NEWFILE))
		{
			InitIFFasDOS(iff);
			if(!(error=OpenIFF(iff, IFFF_WRITE)))
			{
				PushChunk(iff, ID_PREF, ID_FORM, IFFSIZE_UNKNOWN);

				myWriteChunkStruct(iff, ID_PRHD, (APTR)&PrefHdrChunk, sizeof(struct PrefHeader));
				WriteEventChunks(iff, list);

				PopChunk(iff);
				CloseIFF(iff);
			}
			Close(iff->iff_Stream);
		}
		FreeIFF(iff);
	}
	return error;
}

#endif
