

#include <dos/dos.h>
#include <dos/rdargs.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/reqtools_protos.h>
#include <stdio.h>
#include <string.h>
#include <exec/lists.h>

#include <libraries/reqtools.h>

#ifdef AZTEC_C
#include <functions.h>
#endif

static char version_string[] = "$VER: rtEZRequest 2.4 (9.1.95)";

char MyExtHelp[] =
"\n"
"Usage : rtEZRequest\n"  
"\n"
" TITLE/A,BODY/A,BUTTONTEXT=BUTTON,DEFAULT/N/K,CENTERTEXT/S,NORETURNKEY/S,\n"
" POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,PUBSCREEN/K\n"
"\n"
"Arguments:\n"
"\n"
"  TITLE      <text> - Title text for requester window.\n"
"  BODY       <text> - Body text for requester window.\n"
"  BUTTONTEXT <text> - Button text for requester window. (default \"Ok|Cancel\")\n"
"  >or BUTTON\n"
"  DEFAULT     <num> - Default response if [RETURN] key pressed w/o selection.\n"
"  CENTERTEXT        - Center body text in requester window.\n"
" >or CENTER\n"
"  NORETURNKEY       - Turn off [RETURN] key as positive response.\n"
"  POSITION    <pos> - Open requester window at <pos>.  Permissible values are:\n"
" >or POS              CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET   <num> - Offset position relative to above.\n"
" >or TOP\n"
"  LEFFTOFFSET <num> - Offset position relative to above.\n"
" >or LEFT\n"
"  PUBSCREEN <screen>- Public screen name.\n";

#define OPT_TITLE  0
#define OPT_BODY   1
#define OPT_BUTTONTEXT 2
#define OPT_DEFAULT 3
#define OPT_CENTERTEXT 4
#define OPT_NORETURNKEY 5
#define OPT_POSITION 6
#define OPT_TOPOFFSET 7
#define OPT_LEFTOFFSET 8
#define OPT_PUBSCREEN 9

#define OPT_COUNT 10

struct Library *ReqToolsBase;


BOOL
adjust (char *dest, char *src)
{
  char *s, *t;

  s = dest;

  if (src == NULL)		/* bypass */
    return FALSE;

  while ((t = strchr (src, '\\')) && (*(t + 1) == 'n'))
    {
      while (src < t)
	*s++ = *src++;

      *s++ = '\n';

      src++, src++;		/* bump source ptr .... twice */
    }

  while (src[0])			/*** copy remainder of src ***/
    *s++ = *src++;

  *s = '\0';

  return TRUE;
}

int
main (int argc, char **argv)
{
  int retval = 0;

  if (argc)
    {
      if ((argc == 2) && (stricmp (argv[1], "HELP") == 0))
	{
	  fprintf (stdout, "%s", MyExtHelp);
	}
      else
	{
	  /* My custom RDArgs */
	  struct RDArgs *myrda;

	  /* Need to ask DOS for a RDArgs structure */
	  if (myrda = (struct RDArgs *) AllocDosObject (DOS_RDARGS, NULL))
	    {
	      /* The array of LONGs where ReadArgs() will store the data from
	       * the command line arguments.  C guarantees that all the array
	       * entries will be set to zero.
	       */
	      LONG result[OPT_COUNT] =
	      {NULL};

	      /* parse my command line */
	      if (ReadArgs ("TITLE/A,BODY/A,BUTTONTEXT=BUTTON,DEFAULT/N/K,CENTERTEXT=CENTER/S,NORETURNKEY/S,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,PUBSCREEN/K", &result[0], myrda))
		{
		  if (ReqToolsBase = (struct Library *) OpenLibrary ("reqtools.library", LIBRARY_MINIMUM))
		    {
		      struct rtReqInfo *requester;

		      if (requester = (struct rtReqInfo *) rtAllocRequest (RT_REQINFO, NULL))
			{
			  requester->ReqTitle = (result[OPT_TITLE])
			    ? (char *) result[OPT_TITLE] : "Request";

			  /*
			   * Take care of requester positioning
			   */
			  if (stricmp ((char *) result[OPT_POSITION], "POINTER") == 0)
			    requester->ReqPos = REQPOS_POINTER;
			  else if (stricmp ((char *) result[OPT_POSITION], "CENTERSCR") == 0)
			    requester->ReqPos = REQPOS_CENTERSCR;
			  else if (stricmp ((char *) result[OPT_POSITION], "TOPLEFTSCR") == 0)
			    requester->ReqPos = REQPOS_TOPLEFTSCR;
			  else if (stricmp ((char *) result[OPT_POSITION], "CENTERWIN") == 0)
			    requester->ReqPos = REQPOS_CENTERWIN;
			  else if (stricmp ((char *) result[OPT_POSITION], "TOPLEFTWIN") == 0)
			    requester->ReqPos = REQPOS_TOPLEFTWIN;
			  else
			    requester->ReqPos = REQPOS_CENTERSCR;

			  requester->Flags =
			    ((result[OPT_CENTERTEXT]) ? EZREQF_CENTERTEXT : NULL) |
			    ((result[OPT_NORETURNKEY]) ? EZREQF_NORETURNKEY : NULL);

			  /*
			   * Fix body text - Map *n to '\n'
			   */
			  adjust ((char *) result[OPT_BODY], (char *) result[OPT_BODY]);

			  {
			    struct Process *process = (struct Process *) FindTask (NULL);
			    APTR windowptr = process->pr_WindowPtr;

			    /*
			     * Tags will be used to take care ofattributes not directly
			     * settable in the rtReqInfo structure
			     */

			    retval = rtEZRequestTags ((result[OPT_BODY])
						      ? (char *) result[OPT_BODY] : (char *) NULL,
						      (result[OPT_BUTTONTEXT])
						      ? (char *) result[OPT_BUTTONTEXT] : "_Ok|_Cancel",
						      requester, NULL,
						      
						      
						      (result[OPT_DEFAULT]) ? RTEZ_DefaultResponse : TAG_IGNORE,
						      *((LONG *)result[OPT_DEFAULT]),

			    /*
			     * Finally,
			     * set some more general tags shared by most requesters
			     */
						      RT_Underscore, '_',
						      (result[OPT_TOPOFFSET]) ? RT_TopOffset : TAG_IGNORE,
						      *((LONG *)result[OPT_TOPOFFSET]),
						      (result[OPT_LEFTOFFSET]) ? RT_LeftOffset : TAG_IGNORE,
						      *((LONG *)result[OPT_LEFTOFFSET]),
						      (windowptr) ? RT_Window : TAG_IGNORE,
						      windowptr,  
						      (result[OPT_PUBSCREEN]) ? RT_PubScrName : TAG_IGNORE,
						      (char *) result[OPT_PUBSCREEN],
						      TAG_END);

			  }
			  rtFreeRequest (requester);
			}
		      else
			{
			  /* Unable to allocate request structure */
			  retval = 20;
			}
		      CloseLibrary (ReqToolsBase);
		    }
		  else
		    {
		      /* Unable to open reqtools.library */
		      fprintf (stderr, "\nrtEZRequest: Unable to open reqtools.library.\n");

		      retval = 20;
		    }
		  FreeArgs (myrda);
		}
	      else
		{
		  /*
		   * Something went wrong in the parse
		   */

		  if ((result[OPT_TITLE] == NULL) || (result[OPT_BODY] == NULL))
		    {
		      fprintf (stderr, "\nrtEZRequest: Required argument missing.\n\n");
		    }
		  else
		    {
		      fprintf (stderr, "\nrtEZRequest: Command syntax error.\n\n");
		    }

		  fprintf (stderr, "Try - rtEZRequest help.\n");

		  retval = 20;
		}
	      FreeDosObject (DOS_RDARGS, myrda);
	    }
	  else
	    {
	      retval = 20;
	    }
	}
    }
  else
    {
      /* we got launched from WB */
    }

  return (retval);
}
