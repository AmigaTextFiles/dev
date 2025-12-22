#include <exec/types.h>
#include <opal/opallib.h>
#include <proto/all.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

struct OpalBase *OpalBase;
struct OpalScreen *OScrn;

#define VERSION "1.1"


	/* 2.0 style version string for the VERSION command */
char Version[] = "\0$VER: Convert24 "VERSION " (5.11.92)";


char Usage[] =
	"Usage: Convert24 SourceFile [to] DestFile [as] [FAST|IFF24|JPEG] [QUALITY nn] \n";

char Banner[] = "[33mConvert24[31m V"VERSION" by Martin Boyd, ©1992 Opal Technology Pty Ltd.\n";

#define OR ||
#define AND &&

void Clean_Up (char *String,int RetCode);


void main (int argc,char *argv[])
{
   register int i;
   int Quality;
   long Err;
   BOOL FastFormat,JPEG,Error;
   char *SourceFile,*DestFile;

	puts (Banner);
	if (argc<3)
		Clean_Up (Usage,0);
	FastFormat = FALSE;
	JPEG = FALSE;
	SourceFile = NULL;
	DestFile = NULL;
	Quality = 75;
	for (i=1; i<argc; i++)
		{ if ((stricmp (argv[i],"to")) AND (stricmp (argv[i],"as"))
			AND (stricmp(argv[i],"IFF24")))
			{ if (!stricmp(argv[i],"FAST"))
				FastFormat = TRUE;
			  else
				if (!stricmp(argv[i],"JPEG"))
					JPEG = TRUE;
			  else
				if (!stricmp(argv[i],"QUALITY"))
					{ i++;
					  Quality = -1;
					  if (i>=argc)
						Clean_Up (Usage,0);
					  sscanf (argv[i],"%d",&Quality);
					  if ((Quality<0) OR (Quality>100))
						Clean_Up ("Invalid Quality level, must be 0 to 100",10);
					}
			  else
				if (SourceFile==NULL)
					SourceFile = argv[i];
			  else
				if (DestFile==NULL)
					DestFile = argv[i];
			}
		}

	if ((SourceFile==NULL) OR (DestFile==NULL))
		Clean_Up (Usage,0);

	OpalBase = (struct OpalBase *) OpenLibrary ("opal.library",0L);
	if (OpalBase==0L)
		Clean_Up ("Can't open opal.library\n",10);

	
	puts ("loading..");
	OScrn = NULL;
	Err = LoadIFF24 (NULL,SourceFile,VIRTUALSCREEN24|FORCE24);
	if (Err < OL_ERR_MAXERR)
		{ if (Err==OL_ERR_OPENFILE)
			Clean_Up ("Error opening file!!\n",10);
		  else if ((Err==OL_ERR_NOTILBM) OR (Err==OL_ERR_BADIFF)
			OR (Err==OL_ERR_NOTIFF))
			Clean_Up ("Not an IFF ILBM file!!\n",10);
		  else if (Err==OL_ERR_OUTOFMEM)
			Clean_Up ("Out of memory!!\n",10);
		  else if (Err==OL_ERR_CTRLC)
			Clean_Up ("",0);
		  else
			Clean_Up ("Error displaying file!!\n",10);
		}

	OScrn = (struct OpalScreen *)Err;
	puts ("Saving..");
	Error = FALSE;
	if (FastFormat)
		{ if (SaveIFF24 (OScrn,DestFile,NULL,OVFASTFORMAT))
			Error = TRUE;
		}
	else if (JPEG)
		{ if (SaveJPEG24 (OScrn,DestFile,NULL,Quality))
			Error = TRUE;
		}
	else
		{ if (SaveIFF24 (OScrn,DestFile,NULL,NULL))
			Error = TRUE;
		}
	if (Error)
		Clean_Up ("Error Saving File\n",10);
	Clean_Up ("Conversion complete.\n",0);
}

void _abort (void)
{
	Clean_Up ("Aborted\n",5);
}

void Clean_Up (char *String,int RetCode)
{
	if (OScrn!=NULL)
		FreeScreen24 (OScrn);
	if (OpalBase!=NULL)
		CloseLibrary ((struct Library *)OpalBase);
	puts (String);
	exit (RetCode);
}


