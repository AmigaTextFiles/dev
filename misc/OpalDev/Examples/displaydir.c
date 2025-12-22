#define OPAL_PRIVATE
#include "opal/opallib.h"
#include <exec/memory.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#ifndef	AZTEC_C
#include <proto/all.h>
#endif

struct OpalBase *OpalBase;
struct OpalScreen *OScrn;

BOOL Display_Directory (char *Path);
char *Make_FileName (char *Path,char *FileName);
long OldOSFlags;
long OldUpdCount;

#define AND &&
#define OR ||

#define TNWIDTH	 48		/* Multiply this by 2 for hires */
#define TNLINES  30		/* Multiply this by 2 for interlace */
#define XSPACING 10		/* Multiply this by 2 for hires */
#define YSPACING 5		/* Multiply this by 2 for interlace */
#define XSTART 20
#define YSTART 6


BOOL Display_Directory (char *Path);
char *Make_FileName (char *Path,char *FileName);
void Set_Lores (int Top,int Lines);
void Restore_Res (void);


void main (int argc,char *argv[])
{

	if (argc!=2)
		{ puts ("Usage: DisplayDir Directory\n");
		  exit (0);
		}

	OpalBase = (struct OpalBase *) OpenLibrary ("opal.library",0L);
	if (OpalBase==NULL)
		{ puts ("Can't open opal.library\n");
		  exit (0);
		}

	OScrn = OpenScreen24 (0);
	if (OScrn!=NULL)
		{ Display_Directory (argv[1]);
		  Refresh24();
		  AutoSync24 (TRUE);
		  Delay (150L);
		  CloseScreen24 ();
		}
	CloseLibrary ((struct Library *)OpalBase);
}


BOOL Display_Directory (char *Path)
{
   struct FileLock *FL;
   struct FileInfoBlock *FIB;
   register int x,y;
   long Error;
   BOOL Aborted;
   char *Name;


	FIB = AllocMem ((long)sizeof(struct FileInfoBlock),MEMF_CLEAR);
	if (FIB==NULL)
		return (FALSE);

	FL = (struct FileLock *) Lock (Path,ACCESS_READ);
	if (FL==NULL)
		{ printf ("Couldn't open Directory !!");
		  FreeMem (FIB,(long)sizeof(struct FileInfoBlock));
		  return (FALSE);
		}

	x = XSTART;
	y = YSTART;
	Aborted = FALSE;
	Examine ((BPTR)FL,FIB);
	Error = 0;
	if (ExNext ((BPTR)FL,FIB)==NULL)
		Error = IoErr();
	while ((Error!=ERROR_NO_MORE_ENTRIES) AND (!Aborted))
		{ Name = Make_FileName (Path,FIB->fib_FileName);
		  if (DisplayThumbnail24 (OScrn,Name,x,y)==0)
			{ x = x + TNWIDTH + XSPACING;
			  if (x+TNWIDTH>OScrn->Width)
				{ x = XSTART;
				  y = y + TNLINES+YSPACING;
				  if (y+TNLINES>OScrn->Height) Aborted = TRUE;
				}
			}
		  if (ExNext ((BPTR)FL,FIB)==NULL)
			Error = IoErr();
  		}

	UnLock ((BPTR)FL);
	FreeMem (FIB,(long)sizeof(struct FileInfoBlock));
	return (TRUE);
}

char TempStr[200];

char *Make_FileName (char *Path,char *FileName)
{
   register int i;

	strcpy (TempStr,Path);
	i = strlen (TempStr);
	if ((i!=0) AND (TempStr[i-1]!=':'))
		strcat (TempStr,"/");
	strcat (TempStr,FileName);
	return (TempStr);
}


/*  The following routines are useful for displaying
 * thumbnails in hires/interlaces screens. Thumbnails
 * are always lores non-interlace, so to get around this
 * the following routine sets a number of lines into lo-res
 * mode, and clears the field bit in the control line of the
 * odd NODMA copper list. This forces both fields to display
 * the same lines. The thumbnails will then be displayed 
 * correctly.
 */

void Set_Lores (int Top,int Lines)
{
  register int i;

	OldOSFlags = OScrn->Flags;
	OldUpdCount = OScrn->Update_Cycles;

	OScrn->Flags &= ~(HIRES24|ILACE24);
	OScrn->Update_Cycles = 3;
	if (OldOSFlags & HIRES24)
		{ for (i=Top; (i<Top+Lines) AND (i<OScrn->LastCoProIns); i++)
			OScrn->CoProData[i+OScrn->CoProOffset] &= (~HIRESDISP);
		  UpdateCoPro24();
		}
	if (OldOSFlags & ILACE24)
		SetControlBit24 (13L,11L,0L);	  /* Display field 0 */
}

void Restore_Res (void)
{
   register int i;

	OScrn->Flags = OldOSFlags;
	OScrn->Update_Cycles = OldUpdCount;
	if (OldOSFlags & HIRES24)
		{ for (i=0; i<OScrn->LastCoProIns; i++)
			OScrn->CoProData[i+OScrn->CoProOffset] |= HIRESDISP;
		  UpdateCoPro24();
		}
	if (OldOSFlags & ILACE24)
		SetControlBit24 (13L,11L,1L);	/* Restore field 1 display */
}
