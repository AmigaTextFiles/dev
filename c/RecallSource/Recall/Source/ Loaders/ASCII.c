/*
 *	File:					ASCII.c
 *	Description:	Imports an ASCII project
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

/*** PRIVATE INCLUDES ****************************************************************/
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <utility/utility.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#include <clib/dos_protos.h>
#include <clib/macros.h>
#include <clib/alib_protos.h>

#include "myinclude:bitmacros.h"
#include "Version.h"
#include "Modules.h"
#include "ProjectStructures.h"
#include "ASCII_REV.h"

/*** DEFINES *************************************************************************/
#define	ENDCHAR		-1

/*** GLOBALS *************************************************************************/
struct MsgPort	*port, *ioport;
struct RecallMsg	*recmsg;

const char version[]=VERSTAG;

struct Library *UtilityBase;

struct List *list=NULL;
UBYTE *filename;

short num;
BYTE done=FALSE;

/*** FUNCTIONS ***********************************************************************/

__asm int myfgetc(register __a0 BPTR fp)
{
	register int c=FGetC(fp);

	if(c==12 | c==13)
		c='\n';
	if(c==-1)
	{
		done=TRUE;
		c='\n';
	}
	if((c>31 & c<127) | (c>159 & c<256) | c=='\n')
		return c;

	return ENDCHAR;
}

__asm int GetText(register __a0 BPTR fp,
									register __a1 char *s)
{
	register int c, i=0, lim=MAXCHARS, inquote=0;

	while((c=myfgetc(fp))!=ENDCHAR && c!='\n' && --lim>0)
	{
		if(inquote==0 && c==',')
			break;
		else
		{
			if(c=='"')
				inquote^=1;
			else if(inquote)
				s[i++]=c;
		}
	}
	s[i]='\0';
	return c;
}

__asm LONG GetNumber(register __a0 BPTR fp)
{
	register int c, i=0, lim=MAXCHARS;
	char s[10], *dummy;

	while((c=myfgetc(fp))!=ENDCHAR && c!='\n' && c!='.' && c!=':' && --lim>0 && c!=',')
	{
		if(c!='"')
			s[i++]=c;
	}
	s[i]='\0';
	num=(short)strtol(s, &dummy,10);
	return c;
}

__asm void AddText(	register __a0 struct List *list,
										register __a1 UBYTE *text)
{
	struct Node *node=NULL;
	UBYTE newtext[MAXCHARS]="\0";

	recmsg->list=list;
	recmsg->name=text;
	SendMessage(ioport, recmsg,
							REC_AddText,		&node,
							TAG_DONE);
}

__asm void ReadASCII(	register __a0 UBYTE *filename,
											register __a1 struct List *list)
{
	BPTR	fp;
	struct EventNode *eventnode;
	char text[MAXCHARS];

	if(fp=Open(filename, MODE_OLDFILE))
	{
		while(GetText(fp, text)!=ENDCHAR & done==FALSE)
			if(strlen(text)>0 & text[0]!='\n')
			{
				struct EventNode	*eventnode=NULL;
				struct DateNode		*datenode=NULL;

				recmsg->list=list;
				recmsg->name=text;
				SendMessage(ioport, recmsg,
										REC_AddEvent,		&eventnode,
										TAG_DONE);

				if(eventnode)
				{
					eventnode->show=STARTUP;

					recmsg->name="";
					recmsg->list=eventnode->datelist;
					SendMessage(ioport, recmsg,
											REC_AddDate,	&datenode,
											TAG_DONE);

					if(datenode)
					{
						GetNumber(fp); datenode->day		=(BYTE)num;
						GetNumber(fp); datenode->month	=(BYTE)num;
						GetNumber(fp); datenode->year		=(short)num;
						GetNumber(fp); datenode->hour		=(BYTE)num;
						GetNumber(fp); datenode->minutes=(BYTE)num;

						while(GetText(fp, text)!='\n')
							AddText(eventnode->textlist, text);
						AddText(eventnode->textlist, text);

						SendMessage(ioport, recmsg,
												REC_SetWhenString,	datenode,
												TAG_DONE);
					}
				}
			}
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
						ReadASCII(recmsg->name, list);

					SendMessage(ioport, recmsg,
											REC_UpdateData,		TRUE,
											REC_PutRootList,	list,
											TAG_DONE);

					FreeVec(recmsg);
				}
				DeleteMsgPort(port);
			}
		CloseLibrary(UtilityBase);
	}
}
