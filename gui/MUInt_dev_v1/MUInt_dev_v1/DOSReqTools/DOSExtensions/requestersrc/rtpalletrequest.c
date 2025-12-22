
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <clib/dos_protos.h>
#include <stdio.h>
#include <string.h>
#include <exec/lists.h>

#include <libraries/reqtools.h>

#include <functions.h>

static char version_string[] = "$VER: rtPaletteRequest 2.3 (16.11.94)";

char MyExtHelp[] =
"Usage : rtPalletRequest  TITLETEXT,COLOR/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,\n"
"                          PUBSCEREEN/K\n\n"
"Parameters:\n\n"
"  TITLETEXT  <text> - Title text for requester window.\n"
"  COLOR       <num> -\n"
"  POSITION    <pos> - Open requester window at <pos>.  Permissible values are:\n"
"                      CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET   <num> - Offset position relative to above.\n"
"  LEFFTOFFSET <num> - Offset position relative to above.\n"
"  PUBSCREEN <screen>- Public screen name.\n";

#define TEMPLATE "TITLETEXT,COLOR/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,PUBSCREEN/K"

#define OPT_TITLETEXT  0
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
		      if (stricmp (result[OPT_POSITION], "CENTERSCR") == 0)
			requester->ReqPos = REQPOS_CENTERSCR;
		      else if (stricmp (result[OPT_POSITION], "TOPLEFTSCR") == 0)
			requester->ReqPos = REQPOS_TOPLEFTSCR;
		      else if (stricmp (result[OPT_POSITION], "CENTERWIN") == 0)
			requester->ReqPos = REQPOS_CENTERWIN;
		      else if (stricmp (result[OPT_POSITION], "TOPLEFTWIN") == 0)
			requester->ReqPos = REQPOS_TOPLEFTWIN;
		      else
			requester->ReqPos = REQPOS_POINTER;

		      {
			/*
			 * Tags will be used to take care ofattributes not directly
			 * settable in the rtReqInfo structure
			 */

			retval = rtPaletteRequest ((result[OPT_TITLETEXT]) ? result[OPT_TITLETEXT] : NULL, requester,

						   (result[OPT_COLOR]) ? RTPA_Color : TAG_IGNORE,
						   *result[OPT_COLOR],
			/*
			 * Finally,
			 * set some more general tags shared by most requesters
			 */
					      (result[OPT_TOPOFFSET]) ? RT_TopOffset : TAG_IGNORE,
					      *result[OPT_TOPOFFSET],
					      (result[OPT_LEFTOFFSET]) ? RT_LeftOffset : TAG_IGNORE,
					      *result[OPT_LEFTOFFSET],
					      (result[OPT_PUBSCREEN]) ? RT_PubScrName : TAG_IGNORE,
					      result[OPT_PUBSCREEN],
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

	      if (result[OPT_TITLETEXT] == NULL)
		{
		  fprintf (stderr, "\nrtPalletRequest: Required argument missing.\n\n");
		}
	      else
		{
		  /* something else is wrong */
		  fprintf (stderr, "\nrtPalletRequest: Command syntax error.\n\n");
		}

	      fprintf (stderr, "%s", MyExtHelp);

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
  else
    {
      /* launched from workbench */
    }

  return (retval);
}
