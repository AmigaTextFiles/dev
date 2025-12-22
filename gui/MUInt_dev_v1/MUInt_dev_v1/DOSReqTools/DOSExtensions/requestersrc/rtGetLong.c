
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/reqtools_protos.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>

#include <libraries/reqtools.h>

#ifdef AZTEC_C
#include <functions.h>
#endif

static char version_string[] = "$VER: rtGetLong 2.4 (9.1.95)";

char MyExtHelp[] =
"\n"
"Usage : rtGetLong\n"
"\n"
" TITLE/A,BODY/A,BUTTONTEXT=BUTTON,DEFAULT/K,MIN/N/K,MAX/N/K,INVISIBLE/S,\n"
" ALLOWEMPTY/S,CENTERTEXT=CENTER/S,HIGHLIGHTTEXT=HIGHLIGHT/S,BACKFILL/S,\n"
" WIDTH/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,TO/K,PUBSCREEN/K\n"
"\n"
"Arguments:\n"
"\n"
"  TITLE     <text> - Title text for requester window.\n"
"  BODY      <text> - Body text for requester window.\n"
"  BUTTONTEXT <text> - Button text for requester window.\n"
"  or BUTTON\n"
"  DEFAULT    <text> - Initial value.\n"
"  MIN        <num>  - Minimum allowed value.\n"
"  MAX        <num>  - Maximum allowed value.\n"
"  INVISIBLE         - Do not echo keypresses (useful for passwords etc.).\n"
"  ALLOWEMPTY        - Empty string returns TRUE.\n"
"  CENTERTEXT        - Center body text in requester window.\n"
" >or CENTER\n"
"  HIGHLIGHTTEXT     - Highlight body text in requester window.\n"
" >or HIGHLIGHT\n"
"  BACKFILL          - Turn on backfill.\n"
"  WIDTH       <num> - Width of requester window. (ignored)\n"
"  POSITION    <pos> - Open requester window at <pos>.  Permissible values are:\n"
" >or POS              CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET   <num> - Offset position relative to above.\n"
" >or TOP\n"
"  LEFFTOFFSET <num> - Offset position relative to above.\n"
" >or LEFT\n"
"  TO          <file>- Send result (string) to <file>.\n"
"  PUBSCREEN <screen>- Public screen name.\n";


#define TEMPLATE "TITLE/A,BODY/A,BUTTONTEXT=BUTTON,DEFAULT/N/K,MIN/N/K,MAX/N/K,INVISIBLE/S,CENTERTEXT=CENTER/S,HIGHLIGHTTEXT=HIGHLIGHT/S,BACKFILL/S,WIDTH/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,TO/K,PUBSCREEN/K"

#define OPT_TITLE  0
#define OPT_BODY   1
#define OPT_BUTTONTEXT 2
#define OPT_DEFAULT 3
#define OPT_MIN 4
#define OPT_MAX 5
#define OPT_INVISIBLE 6
#define OPT_CENTERTEXT  7
#define OPT_HIGHLIGHTTEXT 8
#define OPT_BACKFILL 9
#define OPT_WIDTH 10
#define OPT_POSITION 11
#define OPT_TOPOFFSET 12
#define OPT_LEFTOFFSET 13
#define OPT_TO 14
#define OPT_PUBSCREEN 15
#define OPT_COUNT 16

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

  while (src[0])
/*** copy remainder of src ***/
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
	      if (ReadArgs (TEMPLATE, result, myrda))
		{
		  if (ReqToolsBase = (struct Library *) OpenLibrary ("reqtools.library", LIBRARY_MINIMUM))
		    {
		      struct rtReqInfo *requester;

		      if (requester = (struct rtReqInfo *) rtAllocRequest (RT_REQINFO, NULL))
			{
			  LONG val;

			  val = (result[OPT_DEFAULT]) ? *((LONG *) result[OPT_DEFAULT]) : 0;

			  /*
			     * Take care of requester positioning -
			     * These flags common to most rt requesters
			   */
			  if (stricmp ((char *) result[OPT_POSITION], "POINTER") == 0)
			    requester->ReqPos = REQPOS_POINTER;
			  if (stricmp ((char *) result[OPT_POSITION], "CENTERSCR") == 0)
			    requester->ReqPos = REQPOS_CENTERSCR;
			  else if (stricmp ((char *) result[OPT_POSITION], "TOPLEFTSCR") == 0)
			    requester->ReqPos = REQPOS_TOPLEFTSCR;
			  else if (stricmp ((char *) result[OPT_POSITION], "CENTERWIN") == 0)
			    requester->ReqPos = REQPOS_CENTERWIN;
			  else if (stricmp ((char *) result[OPT_POSITION], "TOPLEFTWIN") == 0)
			    requester->ReqPos = REQPOS_TOPLEFTWIN;
			  else
			    requester->ReqPos = REQPOS_CENTERSCR;


			  /*
			     * take care of some rtGetLong () requester specific flags
			   */
			  requester->Flags =
			    ((result[OPT_HIGHLIGHTTEXT]) ? GLREQF_HIGHLIGHTTEXT : NULL) |
			    ((result[OPT_CENTERTEXT]) ? GLREQF_CENTERTEXT : NULL);

			  /*
			     * Fix body text - Map *n to '\n'
			   */
			  adjust ((char *) result[OPT_BODY], (char *) result[OPT_BODY]);

			  {
			    struct Process *process = (struct Process *) FindTask (NULL);
			    APTR windowptr = process->pr_WindowPtr;

			    /*
			       * Tags will be used to take care of attributes not directly
			       * settable in the rtReqInfo structure
			     */

			    retval = rtGetLong (&val, (char *) result[OPT_TITLE], requester,

			    /*
			       * set some rtGetLong() requrster specific tags
			     */
						(result[OPT_BODY]) ? RTGL_TextFmt : TAG_IGNORE,
						(char *) result[OPT_BODY],
						(result[OPT_BUTTONTEXT]) ? RTGL_GadFmt : TAG_IGNORE,
						(char *) result[OPT_BUTTONTEXT],
						(result[OPT_MIN]) ? RTGL_Min : TAG_IGNORE,
						*((LONG *) result[OPT_MIN]),
						(result[OPT_MAX]) ? RTGL_Max : TAG_IGNORE,
						*((LONG *) result[OPT_MAX]),
						(result[OPT_INVISIBLE]) ? RTGL_Invisible : TAG_IGNORE,
						TRUE,
						(result[OPT_WIDTH]) ? RTGL_Width : TAG_IGNORE,
						(LONG *) result[OPT_WIDTH],

						RTGL_BackFill, (result[OPT_BACKFILL]) ? TRUE : FALSE,

			    /*
			       * Finally,
			       * set some more general tags shared by most requesters
			     */
						RT_Underscore, '_',
						(result[OPT_TOPOFFSET]) ? RT_TopOffset : TAG_IGNORE,
						*((LONG *)  result[OPT_TOPOFFSET]),
						(result[OPT_LEFTOFFSET]) ? RT_LeftOffset : TAG_IGNORE,
						*((LONG *)  result[OPT_LEFTOFFSET]),
						(windowptr) ? RT_Window : TAG_IGNORE,
						windowptr,
						(result[OPT_PUBSCREEN]) ? RT_PubScrName : TAG_IGNORE,
						(char *) result[OPT_PUBSCREEN],
						TAG_END);

			    if (result[OPT_TO])
			      {
				FILE *file;

				if (file = fopen ((char *) result[OPT_TO], "w"))
				  {
				    fprintf (file, "%ld", val);
				    fclose (file);
				  }
				else
				  {
				    /* something wrong here */
				    fprintf (stderr, "rtGetLong: FALAL ERROR: Unable to open output file.\n");
				    retval = 20;
				  }
			      }
			    else
			      {
				fprintf (stdout, "%ld", val);
			      }
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
		      fprintf (stderr, "rtGetLong: Unable to open reqtools.library.\n");
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
		      fprintf (stderr, "rtGetLong: Required argument missing.\n");
		    }
		  else
		    {
		      /* something else is wrong */
		      fprintf (stderr, "rtGetLong: Command syntax error.\n");
		    }

		  fprintf (stderr, "Try - rtGetLong help.\n");

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
      /* We were started from workbench */
    }
  return (retval);
}
