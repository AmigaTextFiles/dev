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
#include "RECALLV2.X_REV.h"
#include "Version.h"
#include "Modules.h"
#include "ProjectStructures.h"

/*** DEFINES *************************************************************************/
#define  ID_PREF	MAKE_ID('P','R','E','F')
#define  ID_CONF	MAKE_ID('C','O','N','F')
#define  ID_EVNT	MAKE_ID('E','V','N','T')
#define  ID_ETXT	MAKE_ID('E','T','X','T')

/*** GLOBALS *************************************************************************/

struct MsgPort	*port, *ioport;
struct RecallMsg	*recmsg;

struct Library *UtilityBase, *IFFParseBase;

const char version[]=VERSTAG;

struct List *list=NULL;
UBYTE *filename;
char	*whencl[]={"","","",NULL};

struct V2Config
{
	BOOL	centrerequesters;
	BOOL	groupevents;
	BOOL	flashscreen;
	BOOL	ack_events;
	BOOL	ack_alerts;
	BOOL  ask_before_execute;
	BOOL  putoff;
	BOOL	autodelete;
	BOOL	confirm;
	BOOL	autoopencalendar;
	BOOL	usereqtools;
	int		sortby;
} config;

struct V2EventNode
{
	char				name[30];
	short				whendate;
	short				day;
	short				month;
	int					year;
	short				whentime;
	short				hour;
	short				minutes;
	int					days;
	int					repeat;
	short				type;
	short				show;
	short				calc;
	long				datestamp;
	short				display;
	short				expansion1;
	short				expansion2;
	struct List	*textlist;
};

/*** FUNCTIONS ***********************************************************************/

UBYTE *ParseFields(short calc, UBYTE *newtext, UBYTE *text)
{
	register UBYTE	*c, *f=text, unit[MAXCHARS+1], tmp[MAXCHARS+1],
									day[3], month[3], year[3];

	while(c=strchr(f, '{'))
		if(strlen(f)>7)
		{
			*c='\0';
			strcat(newtext, f);

			strmid(c+1, day, 1, 2);
			strmid(c+1, month, 3, 2);
			strmid(c+1, year,	5, 2);

			sprintf(tmp, "{%s:%s/%s/19%s}", (calc ? "days": "years"), day, month, year);
			strcat(newtext, tmp);
			f=c+8;
			break;
		}
	if(*f!='\0')
		strcat(newtext, f);

	return newtext;
}

LONG ReadIFF(UBYTE *filename, struct List *list)
{
	struct IFFHandle		*iff;
	struct ContextNode	*cn;
	struct V2EventNode	tmpnode;
	struct EventNode		*eventnode=NULL;
	UBYTE								tmp[260];
	LONG								error;

	if(iff=AllocIFF())
	{
		if(iff->iff_Stream=Open(filename, MODE_OLDFILE))
		{
			InitIFFasDOS(iff);
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
						if(cn->cn_ID!=ID_CONF)
							error=2;
						else
						{
							ReadChunkBytes(iff,(APTR)&config, cn->cn_Size);

							while(TRUE)
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
											if(ReadChunkBytes(iff,(APTR)&tmpnode,cn->cn_Size)==sizeof(struct V2EventNode))
											{
												struct DateNode *datenode=NULL;
												recmsg->list=list;
												recmsg->name=tmpnode.name;
												SendMessage(ioport, recmsg,
																		REC_AddEvent,		&eventnode,
																		TAG_DONE);

												switch(tmpnode.type)
												{
													case 0:
														eventnode->type=REQUESTER_TYPE;
														if(config.ack_events)
															SETBIT(eventnode->flags, CONFIRM);
														break;
													case 1:
														eventnode->type=YELLOWALERT_TYPE;
														if(config.ack_alerts)
															SETBIT(eventnode->flags, CONFIRM);
														break;
													case 2:
														eventnode->type=CLI_TYPE;
														if(config.ask_before_execute)
															SETBIT(eventnode->flags, CONFIRM);
														break;
												}
												switch(tmpnode.show)
												{
													case 0:
														eventnode->show=STARTUP;
														break;
													case 2:
														eventnode->show=NEVER;
														break;
													default:
														eventnode->show=(BYTE)tmpnode.show;
														break;
												}

												if(config.centrerequesters)
													SETBIT(eventnode->flags, CENTRE);
												if(config.groupevents)
													SETBIT(eventnode->flags, GROUP);

												recmsg->name=strdup(" ");
												recmsg->list=eventnode->datelist;
												SendMessage(ioport, recmsg,
																		REC_AddDate,	&datenode,
																		TAG_DONE);
												free(recmsg->name);
												if(datenode)
												{
													switch(datenode->whendate=(BYTE)tmpnode.whendate)
													{
														case EXACT:
															datenode->day=(BYTE)tmpnode.day;
															break;
														case BEFORE:
															datenode->day=(BYTE)MAX(1, tmpnode.day-1);
															break;
														case AFTER:
															if(datenode->whendate<28)
																datenode->day=(BYTE)(tmpnode.day+1);
															break;
													}
													datenode->month				=(BYTE)tmpnode.month;
													datenode->whentime		=(BYTE)tmpnode.whentime;
													datenode->hour				=(BYTE)tmpnode.hour;
													datenode->minutes			=(BYTE)tmpnode.minutes;
													datenode->year				=(short)tmpnode.year;
													datenode->dateperiod	=MAX(0, (short)tmpnode.days-1);
													datenode->daterepeat	=MAX(0, (short)tmpnode.repeat-1);
												}
											}
											break;

										case ID_ETXT:
											if(eventnode)
												if(ReadChunkBytes(iff,(APTR)&tmp,cn->cn_Size)==cn->cn_Size)
												{
													struct Node *node=NULL;
													UBYTE newtext[300]="\0";

													recmsg->list=eventnode->textlist;
													recmsg->name=ParseFields(tmpnode.calc, newtext, tmp);
													SendMessage(ioport, recmsg,
																			REC_AddText,		&node,
																			TAG_DONE);
												}
											break;
									}
								}
							}
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
			error=IFFERR_EOF;
		FreeIFF (iff);
	}
	return error;
}

void __main(char *BE_NICE)
{
	whencl[0]="Exact";
	whencl[1]="Before";
	whencl[2]="After";

	if(UtilityBase=OpenLibrary("utility.library", 37L))
	{
		if(IFFParseBase=OpenLibrary("iffparse.library", 37L))
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
							ReadIFF(recmsg->name, list);

						SendMessage(ioport, recmsg,
												REC_UpdateData,		TRUE,
												REC_PutRootList,	list,
												TAG_DONE);
						FreeVec(recmsg);
					}
					DeleteMsgPort(port);
				}
			}
			CloseLibrary(IFFParseBase);
		}
		CloseLibrary(UtilityBase);
	}
}

