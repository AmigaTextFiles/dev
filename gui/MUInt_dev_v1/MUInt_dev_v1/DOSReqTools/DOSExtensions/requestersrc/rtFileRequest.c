
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

static char version_string[] = "$VER: rtFileRequest 2.4 (10.1.95)";

char MyExtHelp[] =
"\n"
"Usage rtFileRequest\n"
"\n"
"  TITLE/A,DRAWER,FILE,PATTERN=PAT/K,NOBUFFER/S,MULTISELECT/S,SELECTDIRS/S,\n"
"  SAVE/S,NOFILES/S,PATGAD/S,HEIGHT/N/K,OKTEXT/K,VOLUMEREQUEST/S,NOASSIGNS/S,\n"
"  NODISKS/S,ALLDISKS/S,ALLOWEMPTY/S,POSITION = POS/K,TOPOFFSET=TOP/N/K,\n"
"  LEFTOFFSET=LEFT/N/K,TO/K,PUBSCREEN/K\n"
"\n"
"Arguments:\n"
"\n"
"  TITLE   <text>- Requester window title.\n"
"  DRAWER  <text>- Preload requester with this drawer.\n"
"  FILE    <text>- Preload with DRAWER and this file.\n"
"  PATTERN <text>- Use with PATGAD\n"
"  NOBUFFER      - Do _not_ use a buffer to remember directory contents\n"
"                   for the next time the file requester is used.\n"
"  MULTISELECT   - Allow multiple files to be selected.\n"
"  SELECTDIRS    - Allow selecting of dirs as well as files.\n"
"  SAVE          - Set this if you are using the requester to save or\n"
"                   delete something.  Double-clicking will be disabled\n"
"                   so it is harder to make a mistake or select a wrong file.\n"
"  NOFILES       - Select a directory rather than a file.\n"
"  PATGAD        - Add pattern gadget to the requester.\n"
"  HEIGHT  <num> - Suggested height of file requester window.\n"
"  OKTEXT  <text>- Replacement text for \"Ok\" gadget, max 6 chars.\n"
"  VOLUMEREQUEST - Turn the file requester into a volume/assign disk requester.\n"
"                   This requester can be used to get a device name (\"DF0:\",\n"
"                   \"DH1:\",..) or an assign (\"C:\", \"FONTS:\",...) from the user.\n"
"  NOASSIGNS     - Do not include assigns in the list, only the real devices.\n"
"  NODISKS       - Do not include devices, just show the assigns.\n"
"  ALLDISKS      - Show _all_ devices.  Default behavior is to show only those\n"
"                   devices which have valid disks inserted into them. So if\n"
"                   you have no disk in drive DF0: it will not show up. Set\n"
"                   this flag if you do want these devices included.\n"
"  ALLOWEMPTY    - An empty file string will also be accepted and returned.\n"
"  POSITION    <pos> - Open requester window at <pos>.  Permissible values are:\n"
" >or POS                CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET   <num> - Offset position relative to above.\n"
" >or TOP\n"
"  LEFFTOFFSET <num> - Offset position relative to above.\n"
" >or LEFT\n"
"  TO         <file> - Send result to <file>.\n"
"  PUBSCREEN <screen>- Public screen name.\n";

#define TEMPLATE "TITLE/A,DRAWER,FILE,PATTERN=PAT/K,NOBUFFER/S,MULTISELECT/S,SELECTDIRS/S,SAVE/S,NOFILES/S,PATGAD/S,HEIGHT/N/K,OKTEXT/K,VOLUMEREQUEST/S,NOASSIGNS/S,NODISKS/S,ALLDISKS/S,ALLOWEMPTY/S,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,TO/K,PUBSCREEN/K"

#define OPT_TITLE 0
#define OPT_DRAWER 1
#define OPT_FILE 2
#define OPT_PATTERN 3
#define OPT_NOBUFFER 4
#define OPT_MULTISELECT 5
#define OPT_SELECTDIRS 6
#define OPT_SAVE 7
#define OPT_NOFILES 8
#define OPT_PATGAD 9
#define OPT_HEIGHT 10
#define OPT_OKTEXT 11
#define OPT_VOLUMEREQUEST 12
#define OPT_NOASSIGNS 13
#define OPT_NODISKS 14
#define OPT_ALLDISKS 15
#define OPT_ALLOWEMPTY 16
#define OPT_POSITION 17
#define OPT_TOPOFFSET 18
#define OPT_LEFTOFFSET 19
#define OPT_TO 20
#define OPT_PUBSCREEN 21
#define OPT_COUNT 22

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
		      struct rtFileRequester *requester;

		      if (requester = (struct rtFileRequester *) rtAllocRequest (RT_FILEREQ, NULL))
			{
			  char filename[256];

			  if (result[OPT_DRAWER])
			    rtChangeReqAttr (requester, RTFI_Dir, (char *) result[OPT_DRAWER], TAG_END);

			  strcpy (filename, ((result[OPT_FILE]) ? (char *) result[OPT_FILE] : ""));

			  if (result[OPT_PATTERN])
			    rtChangeReqAttr (requester, RTFI_MatchPat, result[OPT_PATTERN], TAG_END);

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


			  /*
			   * take care of some rtFileRequest () specific flags
			   */
			  requester->Flags =
			    ((result[OPT_NOBUFFER]) ? FREQF_NOBUFFER : NULL) |
			    ((result[OPT_MULTISELECT]) ? FREQF_MULTISELECT : NULL) |
			    ((result[OPT_SELECTDIRS]) ? FREQF_SELECTDIRS : NULL) |
			    ((result[OPT_SAVE]) ? FREQF_SAVE : NULL) |
			    ((result[OPT_NOFILES]) ? FREQF_NOFILES : NULL) |
			    ((result[OPT_PATGAD]) ? FREQF_PATGAD : NULL);

			  {
			    struct Process *process = (struct Process *) FindTask (NULL);
			    APTR windowptr = process->pr_WindowPtr;

			    APTR func_return;

			    /*
			     * Tags will be used to take care ofattributes not directly
			     * settable in the rtReqInfo structure
			     */

			    retval = (func_return = (APTR) rtFileRequest (requester, filename, (char *) result[OPT_TITLE],

			    /*
			     * Set some rtFileRequest() requrster specific tags
			     */
									  (result[OPT_VOLUMEREQUEST]) ? RTFI_VolumeRequest : TAG_IGNORE,
									  ((result[OPT_NOASSIGNS]) ? VREQF_NOASSIGNS : NULL) |
			    ((result[OPT_NODISKS]) ? VREQF_NODISKS : NULL) |
			    ((result[OPT_ALLDISKS]) ? VREQF_ALLDISKS : NULL),



			    (result[OPT_HEIGHT]) ? RTFI_Height : TAG_IGNORE,
						*((LONG *) result[OPT_HEIGHT]),
			    (result[OPT_OKTEXT]) ? RTFI_OkText : TAG_IGNORE,
						(char *) result[OPT_OKTEXT],

									  (result[OPT_ALLOWEMPTY]) ? RTFI_AllowEmpty : TAG_IGNORE,
								       TRUE,
			    /*
			     * Finally,
			     * set some more general tags shared by most requesters
			     */

							 RT_Underscore, '_',

									  (result[OPT_TOPOFFSET]) ? RT_TopOffset : TAG_IGNORE,
					     *((LONG *) result[OPT_TOPOFFSET]),
									  (result[OPT_LEFTOFFSET]) ? RT_LeftOffset : TAG_IGNORE,
					    *((LONG *) result[OPT_LEFTOFFSET]),
				       (windowptr) ? RT_Window : TAG_IGNORE,
								  windowptr,
									  (result[OPT_PUBSCREEN]) ? RT_PubScrName : TAG_IGNORE,
					     (char *) result[OPT_PUBSCREEN],
						   TAG_END)) ? TRUE : FALSE;


			    if ((func_return) && ((result[OPT_MULTISELECT]) || (result[OPT_SELECTDIRS])))
			      {
				char buf[512];

				{
				  int i;

				  struct rtFileList *file_list;

				  strcpy (buf, "");	/* initialize buffer */

				  for (file_list = (struct rtFileList *) func_return, i = 0;
				       file_list;
				       file_list = file_list->Next, i++)
				    {
				      if (strchr (file_list->Name, ' '))
					strcat (buf, "\"");

				      strcat (buf, file_list->Name);

				      if (strchr (file_list->Name, ' '))
					strcat (buf, "\"");

				      strcat (buf, " ");
				    }
				}

				if (result[OPT_TO])
				  {
				    FILE *file;

				    if (file = fopen ((char *) result[OPT_TO], "w"))
				      {
					fprintf (file, "%s", buf);
					fclose (file);
				      }
				    else
				      {
					/* something wrong here */
					fprintf (stderr, "rtFileRequest: FALAL ERROR: Unable to open output file.\n");
					retval = 20;
				      }
				  }
				else
				  {
				    fprintf (stdout, "%s", buf);
				  }

				rtFreeFileList (func_return);

			      }
			    else if (func_return)
			      {
				char buf[512];

				strcpy (buf, requester->Dir);
				AddPart (buf, filename, 512);

				if (result[OPT_TO])
				  {
				    FILE *file;

				    if (file = fopen ((char *) result[OPT_TO], "w"))
				      {
					if (strchr (buf, ' '))
					  fprintf (file, "\"");

					fprintf (file, "%s", buf);

					if (strchr (buf, ' '))
					  fprintf (file, "\"");

					fclose (file);
				      }
				    else
				      {
					/* something wrong here */
					fprintf (stderr, "rtFileRequest: FALAL ERROR: Unable to open output file.\n");
					retval = 20;
				      }
				  }
				else
				  {

				    if (strchr (buf, ' '))
				      fprintf (stdout, "\"");

				    fprintf (stdout, "%s", buf);

				    if (strchr (buf, ' '))
				      fprintf (stdout, "\"");
				  }
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
		      fprintf (stderr, "rtGetString: Unable to open reqtools.library.\n");
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
		      fprintf (stderr, "rtFileRequest: Required argument missing.\n");
		    }
		  else
		    {
		      /* something else is wrong */
		      fprintf (stderr, "rtFileRequest: Command syntax error.\n");
		    }

		  fprintf (stderr, "Try - rtFileRequest help.\n");

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
