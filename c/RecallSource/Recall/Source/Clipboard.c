/*
 *	File:					Clipboard.c
 *	Description:	
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef CLIPBOARD_C
#define CLIPBOARD_C

/*** PRIVATE INCLUDES ****************************************************************/
#include "System.h"
#include "System_Prefs.h"

#include <libraries/iffparse.h>
#include <clib/iffparse_protos.h>
#include <stdlib.h>
#include <string.h>

/*** DEFINES *************************************************************************/
#define  ID_FTXT	MAKE_ID('F','T','X','T')
#define  ID_CHRS	MAKE_ID('C','H','R','S')

/*** FUNCTIONS ***********************************************************************/
int StringToClipboard(ULONG unit, STRPTR string)
{
	struct IFFHandle	*iff;
	long							error=0;

	if(strlen(string))
		if(iff=AllocIFF())
		{
			if(iff->iff_Stream=(ULONG)OpenClipboard(unit))
			{
				InitIFFasClip(iff);
				if(!(error=OpenIFF(iff, IFFF_WRITE)))
				{
					if(!(error=PushChunk(iff, ID_FTXT, ID_FORM, IFFSIZE_UNKNOWN)))
					{
						if(!(error=PushChunk(iff, 0, ID_CHRS, IFFSIZE_UNKNOWN)))
						{
							WriteChunkBytes(iff, string, strlen(string));
							PopChunk(iff);
						}
						PopChunk(iff);
					}
					CloseIFF(iff);
				}
				CloseClipboard((struct ClipboardHandle *)iff->iff_Stream);
			}
			FreeIFF(iff);
		}

	return error;
}

struct Node *ClipboardToList(ULONG unit, struct List *list, struct Node *pnode)
{
	struct Node *node=NULL;
	struct IFFHandle		*iff;
	struct ContextNode	*cn;
	long								error;

	if(iff=AllocIFF())
	{
		if(iff->iff_Stream=(ULONG)OpenClipboard(unit))
		{
			InitIFFasClip(iff);
			if(!(error=OpenIFF(iff, IFFF_READ)))
			{
				if(!(error=StopChunk(iff, ID_FTXT, ID_CHRS)))
				{
					while(TRUE)
					{
						error=ParseIFF(iff, IFFPARSE_SCAN);
						if(error==IFFERR_EOC)
							continue;
						else if(error)
							break;

						cn=CurrentChunk(iff);
						if(cn && (cn->cn_Type==ID_FTXT) && (cn->cn_ID==ID_CHRS))
						{
							UBYTE readbuf[MAXCHARS];
							register int len=ReadChunkBytes(iff, readbuf, MAXCHARS);

							if(len>0 & len<MAXCHARS)
							{
								*(readbuf+len)='\0';
								node=AddNode(list, NULL, readbuf);
								if(pnode!=NULL & Count(list)-1>0)
								{
									Remove(node);
									Insert(list, node, pnode->ln_Pred);
								}
							}
							else
								FailRequest(mainTask.window, MSG_BUFFERTOOLARGE, (APTR)MAXCHARS, NULL);
						}
					}
				}
				CloseIFF(iff);
			}
			CloseClipboard((struct ClipboardHandle *)iff->iff_Stream);
		}
		FreeIFF(iff);
	}
	return node;
}

#endif
