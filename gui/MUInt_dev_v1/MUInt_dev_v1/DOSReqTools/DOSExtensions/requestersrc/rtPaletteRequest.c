
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

static char version_string[] = "$VER: rtPaletteRequest 2.4 (9.1.95)";

char MyExtHelp[] =
"\n"
"Useage: rtPaletteRequest\n"  
"\n"
" TITLE/A,COLOR/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,\n"
" PUBSCREEN/K\n" 
"\n"
"Arguments:\n"
"\n"
"  TITLE      <text> - Title text for requester window.\n"
"  COLOR             - Default color register.\n"
"  POSITION    <pos> - Open requester window at <pos>.  Permissible values are:\n"
" >or POS              CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET   <num> - Offset position relative to above.\n"
" >or TOP\n"
"  LEFFTOFFSET <num> - Offset position relative to above.\n"
" >or LEFT\n"
"  PUBSCREEN <screen>- Public screen name.\n";

#define TEMPLATE "TITLE/A,COLOR/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,PUBSCREEN/K"

#define OPT_TITLE  0
#define OPT_COLOR   1
#define OPT_POSITION 2
#define OPT_TOPOFFSET 3
#define OPT_LEFTOFFSET 4
#define OPT_PUBSCREEN 5
#define OPT_COUNT 6

struct Library *ReqToolsBase;

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
	    /*
	       * The array of LONGs where ReadArgs() will store the data from
	       * the command line arguments.  C guarantees that all the array
	       * entries will be set to zero.
	     */
	    LONG result[OPT_COUNT] =
	    {NULL};

	    /* parse my command line */
	    if (ReadArgs (TEMPLATE, result, myrda))
	      {
		if (ReqToolsBase = (struct Library *) OpenLibrary ("reqtools.library", LIBRARY_MINIMUM))
		  {
		    struct rtReqInfo *requester;

		    if (requester = (struct rtReqInfo *) rtAllocRequest (RT_REQINFO, NULL))
		      {
			/*
			   * Take care of requester positioning -
			   * These flags common to most rt requesters
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


			{
			    struct Process *process = (struct Process *) FindTask (NULL);
			    APTR windowptr = process->pr_WindowPtr;

			  /*
			     * Tags will be used to take care ofattributes not directly
			     * settable in the rtReqInfo structure
			   */

			  retval = (rtPaletteRequest ((result[OPT_TITLE]) ? (char *) result[OPT_TITLE] : NULL, requester,

						      (result[OPT_COLOR]) ? RTPA_Color : TAG_IGNORE,
						     result[OPT_COLOR],
			  /*
			     * Finally,
			     * set some more general tags shared by most requesters
			   */
						     (result[OPT_TOPOFFSET]) ? RT_TopOffset : TAG_IGNORE,
						     result[OPT_TOPOFFSET],
						     (result[OPT_LEFTOFFSET]) ? RT_LeftOffset : TAG_IGNORE,
						     result[OPT_LEFTOFFSET],
						      (windowptr) ? RT_Window : TAG_IGNORE,
						      windowptr,
						     (result[OPT_PUBSCREEN]) ? RT_PubScrName : TAG_IGNORE,
						     (char *) result[OPT_PUBSCREEN],
						     TAG_END)) ? TRUE : FALSE;

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
		    fprintf (stderr, "rtPalletRequest: Unable to open reqtools.library.\n");
		    retval = 20;
		  }
		FreeArgs (myrda);
	      }
	    else
	      {
		/*
		   * Something went wrong in the parse
		 */

		if (result[OPT_TITLE] == NULL)
		  {
		    fprintf (stderr, "rtPaletteRequest: Required argument missing.\n");
		  }
		else
		  {
		    /* something else is wrong */
		    fprintf (stderr, "rtPaletteRequest: Command syntax error.\n");
		  }

		  fprintf (stderr, "Try - rtPaletteRequest help.\n");

		retval = 20;
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
    }

  return (retval);
}
