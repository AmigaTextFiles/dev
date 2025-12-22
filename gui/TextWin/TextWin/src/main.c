
#include <dos/dos.h>
#include <dos/dostags.h>

/* Libraries */
#include <libraries/mui.h>
#include <libraries/reqtools.h>

/* protos */
#include <clib/muimaster_protos.h>
#include <clib/reqtools_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>

/*  Pragmas  */
#include <pragmas/muimaster_pragmas.h>
#include <pragmas/reqtools.h>
#include <pragmas/exec_lib.h>

/*  Ansi  */
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/* MUIBuilder */
#include "TextWin.h"

static char version_string[] = "$VER: TextWin 1.00 (05.12.94)";

char MyExtHelp[] =
"\n"
"Usage : TextWin\n"
"\n"
"  TITLE/A,BODYTEXT=BODY/A\n"
"\n"
"Arguments:\n"
"\n"
"  TITLE      <text> - Title text for requester window.\n"
"  BODYTEXT   <text> -\n"
"  >or BODY\n";

char *CMD_TEMPLATE = "TITLE/A,BODYTEXT=BODY/A";

#define OPT_TITLE 0
#define OPT_BODYTEXT 1
#define OPT_COUNT 2

/* defines */
#define	ID_WINDOW_ACTIVATE 1
#define	ID_MYBUTTON  2

BOOL show_bodytext = FALSE;

char window_title[80] = "";
char *body_text = NULL;

struct ObjApp *App = NULL;	/* Application object */

struct Library *MUIMasterBase;
struct Library *ReqToolsBase;
struct Library *IntuitionBase;

/* Init function */
static int
init (int argc, char **argv)
{
  int retval = 0;

  if (!(MUIMasterBase = OpenLibrary (MUIMASTER_NAME, MUIMASTER_VMIN)))
    {
      printf ("Can't Open MUIMaster Library");
      retval = 20;
    }

  if (!(ReqToolsBase = OpenLibrary ("reqtools.library", 37)))
    {
      printf ("Can't Open Intuition Library");
      retval = 20;
    }

  if (!(IntuitionBase = OpenLibrary ("intuition.library", 37)))
    {
      printf ("Can't Open Intuition Library");
      retval = 20;
    }


  if ((retval == 0) && (argc))
    {
      /* see if the big dummy is asking for help? */
      if ((argc == 2) && (stricmp (argv[1], "HELP") == 0))
	{
	  /* yeh, wouldn't you know it - You Dumb Shit! */
	  fprintf (stdout, "%s", MyExtHelp);
	  retval = 20;
	}
      else
	/* this guy seems serious.... */
	{
	  /* My custom RDArgs */
	  struct RDArgs *myrda;

	  /* Need to ask DOS for a RDArgs structure */
	  if (myrda = (struct RDArgs *) AllocDosObject (DOS_RDARGS, NULL))
	    {
	      /*
	       * The array of LONGs where ReadArgs() will store the data from
	       * the command line arguments.  C guarantees that all the array
	       * entries will be set to zero.
	       */
	      LONG *result[OPT_COUNT] =
	      {
		NULL
	      };

	      /* lets see how serious he is - parse my command line */
	      if (ReadArgs (CMD_TEMPLATE, result, myrda))
		{
		  if ((result[OPT_TITLE]) ? TRUE : FALSE)
		    {
		      strcpy (window_title, result[OPT_TITLE]);
		    }

		  if (show_bodytext = (result[OPT_BODYTEXT]) ? TRUE : FALSE)
		    {
		      BPTR lock;

		      if (lock = Lock (result[OPT_BODYTEXT], SHARED_LOCK))
			{
			  struct FileInfoBlock *fib;

			  if (fib = (struct FileInfoBlock *) AllocDosObject (DOS_FIB, NULL))
			    {
			      if (Examine (lock, fib))
				{
				  ULONG line_cnt;

				  {
				    FILE *infile;

				    if (infile = fopen (result[OPT_BODYTEXT], "r"))
				      {
					char buf[512];

					for (line_cnt = 0; fgets (buf, 512, infile); line_cnt++)
					  {
					    /* do nothing - just count lines */ ;
					  }

					fclose (infile);
				      }
				  }

				  if (body_text = (char *) malloc (fib->fib_Size + line_cnt + 1))
				    {
				      FILE *infile;

				      if (infile = fopen (result[OPT_BODYTEXT], "r"))
					{
					  char buf[512];
					  LONG i;

					  *body_text = '\000';

					  for (i = 0; fgets (buf, 512, infile); i++)
					    {
					      strcat (body_text, buf);
					      strcat (body_text, " ");
					    }

					  fclose (infile);
					}
				      else
					{
					  /* unable to open infile */
					}
				    }
				  else
				    {
				    }
				}

			      FreeDosObject (DOS_FIB, fib);
			    }
			  else
			    {
			      /* unable to alloc dos object */
			    }
			  UnLock (lock);
			}
		      else
			{
			  if (body_text = (char *) malloc (strlen (result[OPT_BODYTEXT]) + 1))
			    {
			      strcpy (body_text, result[OPT_BODYTEXT]);
			    }
			  else
			    {
			      fprintf (stderr, "error: unable to alloc memory for bodytext\n");
			    }
			}

		      {
			char *s = body_text, *d = body_text, *t;

			while ((t = strchr (s, '\\')) && (strchr ("nrt", *(t + 1))))
			  {
			    while (s < t)
			      {
				if (isprint (*s))
				  *d++ = *s++;
				else
				  s++;
			      }

			    switch (*(t + 1))
			      {
			      case 'n':
				*d++ = '\n';
				break;

			      case 't':
				*d++ = '\t';
				break;
			      }

			    s++, s++;
			  }

			while (s[0])
			  *d++ = *s++;

			*d = '\0';
		      }
		    }

		  FreeArgs (myrda);
		}
	      else
		{
		  retval = 20;	/* nah, he screwed it up - something went wrong in the parse */
		}

	      if (retval >= 20)
		{
		  if (result[OPT_TITLE] == NULL)
		    {
		      fprintf (stderr, "TextWin: Required argument missing.\n");
		    }
		  else
		    {
		      /* something else is wrong */
		      fprintf (stderr, "TextWin: Command syntax error.\n");
		    }

		  fprintf (stderr, "Try - TextWin help.\n");
		}

	      FreeDosObject (DOS_RDARGS, myrda);
	    }
	  else
	    {
	      /* Unable to alloc readargs structure */
	      retval = 20;
	    }
	}
    }
  else
    {
      /* launched from workbench */
      retval = 20;
    }

  return (retval);
}

int
main (int argc, char **argv)
{
  int retval = 0;

  BOOL running = TRUE;
  ULONG signal;

  /* Program initialisation ( you need to write it yourself) */
  if ((retval = init (argc, argv)) != 0)
    {
      /* Ate shit and died! */
      goto oops;
    }

  /* Create Application : generated by MUIBuilder */
  if (App = CreateApp ())
    {
      if (window_title)		/*setup window title */
	set (App->WI_label_0, MUIA_Window_Title, window_title);
      else
	set (App->WI_label_0, MUIA_Window_Title, "Information");

      {
	if (DoMethod (App->GR_ListView, OM_ADDMEMBER,
		      ListviewObject,
		      MUIA_Weight, 50,
		      MUIA_Listview_Input, FALSE,
		      MUIA_Listview_List, FloattextObject,
		      MUIA_Frame, MUIV_Frame_ReadList,
		      MUIA_Floattext_Text, body_text,
		      MUIA_Floattext_TabSize, 4,
		      MUIA_Floattext_Justify, FALSE,
		      End, End))
	  {

	    APTR button;

	    char *hotkey = NULL;
	    char *ptr = "Continue";

	    DoMethod (App->GR_Buttons, OM_ADDMEMBER, HVSpace);

	    if (DoMethod (App->GR_Buttons, OM_ADDMEMBER,
			  button = (APTR) KeyButton (ptr, tolower (hotkey))))
	      {
		/* setup notification */
		DoMethod (button, MUIM_Notify, MUIA_Pressed, FALSE,
		       App->App, 2, MUIM_Application_ReturnID, ID_MYBUTTON);
	      }

	    DoMethod (App->GR_Buttons, OM_ADDMEMBER, HVSpace);

	    DoMethod (App->WI_label_0, MUIM_Notify, MUIA_Window_CloseRequest, TRUE,
		      App->App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

	    set (App->WI_label_0, MUIA_Window_Open, TRUE);

	    while (running)
	      {
		LONG value;

		switch (value = DoMethod (App->App, MUIM_Application_Input, &signal))
		  {
		  case 0:	/* I'm not sure what this signal is */
		    break;

		  case MUIV_Application_ReturnID_Quit:
		    retval = 0;
		    running = FALSE;
		    break;

		  case ID_MYBUTTON:
		    running = FALSE;
		    break;

		  default:
		    break;
		  }

		if (running && signal)
		  Wait (signal);
	      }

	    /* Close Window - Shouldn't really have to be done but ....... */

	    set (App->WI_label_0, MUIA_Window_Open, FALSE);

	  }
	else
	  {
	    /* unable to create bodytext object */
	  }

	DisposeApp (App);
      }
    }

oops:

  if (body_text)
    free (body_text);

  if (IntuitionBase)
    CloseLibrary (IntuitionBase);

  if (ReqToolsBase)
    CloseLibrary (ReqToolsBase);

  if (MUIMasterBase)
    CloseLibrary (MUIMasterBase);

  return (retval);
}
