/*
 *	File:					ASCII.c
 *	Description:	Exports a Recall project as an ASCII file
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <utility/utility.h>
#include <string.h>
#include <stdlib.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/utility_protos.h>
#include <clib/dos_protos.h>
#include <clib/macros.h>
#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>

#include "myinclude:bitmacros.h"
#include "Version.h"
#include "Modules.h"
#include "ProjectStructures.h"
#include "myinclude:myList.h"

struct MsgPort	*port, *ioport;
struct RecallMsg	*recmsg;

#include "ASCII_REV.h"
const char version[]=VERSTAG;

struct Library *UtilityBase;
struct List *list=NULL;
UBYTE *filename;


void WriteTexts(BPTR fp, struct List *list)
{
	struct Node *node;

	for(every_node)
	{
		Write(fp, ",\"", 2);
		Write(fp, node->ln_Name, strlen(node->ln_Name));
		Write(fp, "\"", 1);
	}
	Write(fp, "\n", 1);
}

__stackext void WriteEvents(BPTR fp, struct List *list)
{
	register struct Node *node;
	UBYTE string[MAXCHARS*2];

	for(every_node)
	{
		register struct EventNode *eventnode=(struct EventNode *)node;

		if(node->ln_Type==REC_DIR)
			WriteEvents(fp, eventnode->children);
		else
		{
			register struct DateNode *datenode=NULL;

			if(!IsNil(eventnode->datelist))
				datenode=(struct DateNode *)eventnode->datelist->lh_Head;

			if(datenode==NULL)
				sprintf(string, "\"%s\",\"00.00.0000\",\"-1:-1\"", node->ln_Name);
			else
				sprintf(string, "\"%s\",\"%02ld.%02ld.%04ld\",\"%02ld:%02ld\"",
												node->ln_Name,
												datenode->day,
												datenode->month,
												datenode->year,
												datenode->hour,
												datenode->minutes);
			Write(fp, string, strlen(string));
			WriteTexts(fp, eventnode->textlist);
		}
	}
}

void WriteASCII(UBYTE *filename, struct List *list)
{
	BPTR fp;

	if(fp=Open(filename, MODE_NEWFILE))
	{
		WriteEvents(fp, list);
		Close(fp);
	}
}

void __main(char *BE_NICE)
{
	if(UtilityBase=OpenLibrary("utility.library", 37L))
	{
		Forbid();
		ioport=FindPort(RECALL_PORT);
		Permit();

		if(ioport)
			if(port=CreateMsgPort())
			{
				if(recmsg=AllocMessage(port, SAVER_TYPE))
				{
					SendMessage(ioport, recmsg,
											REC_InitMessage,	TRUE,
											REC_GetEventList,	&list,
											TAG_DONE);
					if(list)
						WriteASCII(recmsg->name, list);

					FreeVec(recmsg);
				}
				DeleteMsgPort(port);
			}
		CloseLibrary(UtilityBase);
	}
}

