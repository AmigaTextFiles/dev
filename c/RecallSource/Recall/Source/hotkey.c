/*
 *	File:					HotKey.c
 *	Description:	Generates a hotkey
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef HOTKEY_C
#define HOTKEY_C

/*** INCLUDES ************************************************************************/
#include "System.h"
#include "Hotkey.h"
#include <clib/commodities_protos.h>

/*** GLOBALS *************************************************************************/
static struct InputXpression ParseBuffer={IX_VERSION};

/*** FUNCTIONS ***********************************************************************/
struct InputEvent *CreateInputEvent(UBYTE *command)
{
	struct InputEvent *ie;

	if(ie=AllocVec(sizeof(struct InputEvent), MEMF_CLEAR|MEMF_PUBLIC))
	{
		if(!ParseIX(command, &ParseBuffer))
		{
			ie->ie_Class    =ParseBuffer.ix_Class;
			ie->ie_Code     =ParseBuffer.ix_Code;
			ie->ie_Qualifier=ParseBuffer.ix_Qualifier;
		}
		else
			FreeVec(ie);
	}
	return ie;
}

void SendHotkey(UBYTE *command)
{
	register struct InputEvent	*ie;
	register BOOL								done=FALSE;
	register UBYTE							*line=command, *nextline;

	while(!done)
	{
		nextline=strchr(line, '\n');
		if(nextline==NULL)
			done=TRUE;
		else
		{
			*nextline='\0';
			++nextline;
		}
		if(ie=CreateInputEvent(line))
		{
			CurrentTime(&ie->ie_TimeStamp.tv_secs,
									&ie->ie_TimeStamp.tv_micro);
			AddIEvents(ie);

			FreeVec(ie);
		}
		line=nextline;
	}
}
#endif
