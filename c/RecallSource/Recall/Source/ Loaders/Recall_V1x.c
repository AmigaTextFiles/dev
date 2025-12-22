/*
 *	File:					Recall_V1x.c
 *	Description:	Loader-module for Recall V1.x projects
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#ifndef	RECALL_V1X
#define	RECALL_V1X

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <stdlib.h>
#include <stdio.h>
#include <dos/dos.h>
#include <proto/dos.h>

#include "SafePutToPort().h"
#include "Version.h"

#define CONFIGHEADER	"Recall V1.x © Ketil Hunn"

struct Config14 {
	char	header[25];
	BOOL	CreateIcons,CentreRequesters;
	int		Dateformat,Sortby;
};

struct EventNode14 {
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

struct TextNode14 {
	char text[69];
};

BOOL ReadPrefs14(struct List *list, char *source)
{
	struct EventNode14	event;
	struct EventNode		*current;
	struct Config14			header;
	BPTR								fp;
	BOOL								success;
	struct TextNode14		textnode;
	char tmp[3],*dummy;
	short feof=1;

	if(fp=Open(source, MODE_OLDFILE))
	{
		if(Read(fp, &header, sizeof(header))==sizeof(header))
		{
			if(stricmp(CONFIGHEADER,header.header)==0)
			{
				globalConfig.centrerequesters=header.CentreRequesters;
				globalConfig.sortby=header.Sortby;

				while(feof>0)
				{
					if((feof=Read(fp, &event,sizeof(event)))==sizeof(event))
					{
						current=AddEvent(list, event.eventname);
						current->whendate		=event.prefixdate;

						if(strmid(event.date,tmp,1,2)==0)
						{
							current->day=strtol(tmp,&dummy,10);
							if(strmid(event.date,tmp,3,2)==0)
							{
								current->month=strtol(tmp,&dummy,10);
								if(strmid(event.date,tmp,5,2)==0)
									current->year=strtol(tmp,&dummy,10);
								if(current->year>0)
									current->year+=1900;
							}
						}
						current->whentime		=event.prefixtime;
						current->days				=event.days;
						current->repeat			=event.repeat;

						if(strmid(event.time,tmp,1,2)==0)
						{
							current->hour=strtol(tmp,&dummy,10);
							if(strmid(event.time,tmp,3,2)==0)
								current->minutes=strtol(tmp,&dummy,10);
						}
						current->type				=event.type;
						current->show				=event.show;
						current->calc				=event.calctype;

						while(event.lines--)
						{
							Read(fp, &textnode, sizeof(textnode));
							AddText(current->textlist,textnode.text);
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

struct Library *DosBase=NULL;

int main(int argc, char *argv[])
{
	if(DosBase=OpenLibrary("dos.library", LIBVER))
	{
		if(FindPort(PORTNAME))
		{
	
		}
		CloseLibrary(DosBase);
	}
}

#endif
