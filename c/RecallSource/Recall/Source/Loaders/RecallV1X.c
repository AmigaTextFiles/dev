/*
 *	File:					RecallV2X.c
 *	Description:	Imports a Recall V2.x project
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
#include <libraries/iffparse.h>
#include <string.h>
#include <stdlib.h>

#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/utility_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/macros.h>
#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>

#include "myinclude:bitmacros.h"
#include "RECALLV1.X_REV.h"
#include "Version.h"
#include "Modules.h"
#include "ProjectStructures.h"

/*** DEFINES *************************************************************************/
#define CONFIGHEADER	"Recall V1.x © Ketil Hunn"

/*** GLOBALS *************************************************************************/
struct MsgPort	*port, *ioport;
struct RecallMsg	*recmsg;

struct Library *UtilityBase;

struct List *list=NULL;
UBYTE *filename;

const char version[]=VERSTAG;


struct Config14
{
	char	header[25];
	BOOL	CreateIcons, CentreRequesters;
	int		Dateformat, Sortby;
};

struct EventNode14
{
	struct Node nn_Node;
	char				eventname[30];
	short				prefixdate;
	char				date[7];
	char				sort[7];
	short				prefixtime;
	int					days;
	int					repeat;
	char				time[6];
	short				type;
	short				show;
	short				calctype;
	short				DD;
	short				MM;
	short				YY;
	BOOL				ask;
	short				lines;
	struct List	*textlist;
};

struct TextNode14
{
	char text[69];
};

/*** FUNCTIONS ***********************************************************************/
UBYTE *ParseFields(short calc, UBYTE *newtext, UBYTE *text)
{
	register UBYTE *c, *f=text, unit[MAXCHARS];

	while(c=strchr(f, '{'))
	{
		char day[3], month[3], year[3], tmp[MAXCHARS];

		*c='\0';
		strcat(newtext, f);

		strmid(c+1, day, 1, 2);
		strmid(c+1, month, 3, 2);
		strmid(c+1, year,	5, 2);

		switch(calc)
		{
			case 0:
				sprintf(tmp, "%s%s/%s/19%s}", "{years:", day, month, year);
				strcat(newtext, tmp);
				f=c+8;
				break;
			case 1:
				sprintf(tmp, "%s%s/%s/19%s}", "{days:", day, month, year);
				strcat(newtext, tmp);
				f=c+8;
				break;
		}
	}
	if(*f!='\0')
		strcat(newtext, f);

	return newtext;
}

BOOL ReadPrefs14(UBYTE *filename, struct List *list)
{
	struct EventNode14	event;
	struct EventNode		*current;
	struct Config14			config;
	BPTR								fp;
	BOOL								success;
	struct TextNode14		textnode;
	char tmp[3],*dummy;
	short feof=1;

	if(fp=Open(filename, MODE_OLDFILE))
	{
		if(Read(fp, &config, sizeof(config))==sizeof(config))
		{
			if(stricmp(CONFIGHEADER, config.header)==0)
			{
				while(feof>0)
				{
					if((feof=Read(fp, &event,sizeof(event)))==sizeof(event))
					{
						struct EventNode	*eventnode;
						struct DateNode *datenode=NULL;

						recmsg->list=list;
						recmsg->name=event.eventname;
						SendMessage(ioport, recmsg,
												REC_AddEvent,		&eventnode,
												TAG_DONE);

						if(eventnode)
						{
							switch(event.type)
							{
								case 0:
									eventnode->type=REQUESTER_TYPE;
									break;
								case 1:
									eventnode->type=YELLOWALERT_TYPE;
									break;
								case 2:
									eventnode->type=CLI_TYPE;
									break;
							}
							switch(event.show)
							{
								case 0:
									eventnode->show=STARTUP;
									break;
								case 1:
									eventnode->show=DAILY;
									break;
							}

							if(config.CentreRequesters)
								SETBIT(eventnode->flags, CENTRE);

							recmsg->name="";
							recmsg->list=eventnode->datelist;
							SendMessage(ioport, recmsg,
													REC_AddDate,	&datenode,
													TAG_DONE);

							if(datenode)
							{
								if(strmid(event.date,tmp,1,2)==0)
								{
									datenode->day=strtol(tmp,&dummy,10);
									if(strmid(event.date,tmp,3,2)==0)
									{
										datenode->month=strtol(tmp, &dummy, 10);
										if(strmid(event.date, tmp, 5, 2)==0)
											datenode->year=strtol(tmp, &dummy, 10);
										if(datenode->year>0)
											datenode->year+=1900;
									}
								}
								datenode->whentime=(BYTE)event.prefixtime;
								switch(datenode->whendate=(BYTE)event.prefixdate)
								{
									case BEFORE:
										datenode->day=MAX(1, datenode->day-1);
										break;
									case AFTER:
										if(datenode->whendate<28)
											datenode->day=MIN(1, datenode->day+1);
										break;
								}
								datenode->dateperiod=MAX(0, (short)event.days-1);
								datenode->daterepeat=MAX(0, (short)event.repeat-1);

								if(strmid(event.time, tmp, 1, 2)==0)
								{
									datenode->hour=(BYTE)strtol(tmp, &dummy, 10);
									if(strmid(event.time, tmp, 4, 2)==0)
										datenode->minutes=strtol(tmp, &dummy, 10);
								}
								SendMessage(ioport, recmsg,
														REC_SetWhenString,	datenode,
														TAG_DONE);
							}
						}
						while(event.lines--)
						{
							Read(fp, &textnode, sizeof(textnode));
							if(eventnode)
							{
								struct Node *node=NULL;
								UBYTE newtext[300]="\0";
								recmsg->list=eventnode->textlist;
								recmsg->name=ParseFields(event.calctype, newtext, textnode.text);
								SendMessage(ioport, recmsg,
														REC_AddText,		&node,
														TAG_DONE);
							}
						}
						success=TRUE;
					}
				}
			}
			else
				success=FALSE;
		}
	}
	Close(fp);
	return success;
}

void __main(char *BE_NICE)
{
	if(UtilityBase=OpenLibrary("utility.library", 37L))
	{
		Forbid();
		ioport=FindPort(RECALL_PORT);
		Permit();

		if(ioport)
		{
			if(port=CreateMsgPort())
			{
				if(recmsg=AllocMessage(port, LOADER_TYPE))
				{
					SendMessage(ioport, recmsg,
											REC_InitMessage,	TRUE,
											REC_GetEventList,	&list,
											TAG_DONE);

					if(list)
						ReadPrefs14(recmsg->name, list);

					SendMessage(ioport, recmsg,
											REC_UpdateData,		TRUE,
											REC_PutRootList,	list,
											TAG_DONE);
					FreeVec(recmsg);
				}
				DeleteMsgPort(port);
			}
		}
		CloseLibrary(UtilityBase);
	}
}

