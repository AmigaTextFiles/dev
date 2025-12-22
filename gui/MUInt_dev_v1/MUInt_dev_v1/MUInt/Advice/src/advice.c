#include <exec/memory.h>
#include <libraries/reqtools.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/reqtools.h>

#include <stdio.h>
#include <string.h>

static char version_string[] = "$VER: Advice 2.4 (11.1.95)";

char myexthelp[] =
"\n"
"Advice, (c) 1995 Both Software\n"
"\n"
"Arguments:\n"
"\n"
"  TITLE      <text> - Title text for requester window.\n"
"  BODY       <file> - Body text for requester window.\n"
"  BUTTONTEXT <text> - Button text for requester window. (default \"Ok|Cancel\")\n"
"  or BUTTON\n"
"  DEFAULT     <num> - Default response if [RETURN] key pressed w/o selection.\n"
"  CENTERTEXT        - Center body text in requester window.\n"
"  NORETURNKEY       - Turn off [RETURN] key as positive response.\n"
"  POSITION    <pos> - Open requester window at <pos>.  Permissible values are:\n"
"                      CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET   <num> - Offset position relative to above.\n"
"  LEFFTOFFSET <num> - Offset position relative to above.\n"
"  PUBSCREEN <screen>- Public screen name.\n"
"\n";

struct ShellArgs
{
	STRPTR	 Title;
	STRPTR	 Body;
	STRPTR	 ButtonText;
	LONG	*Default;
	LONG	*CenterText;
	LONG	*NoReturnKey;
	STRPTR	 Position;
	LONG	*TopOffset;
	LONG	*LeftOffset;
	STRPTR	 PubScreen;
};



long __main (void)
{
 int			 retval		= 0;
 struct RDArgs		*myrda;
 struct ShellArgs	 shellargs	= { NULL, NULL, NULL, NULL, FALSE, FALSE, NULL, NULL, NULL, NULL };
 STRPTR			 Template	= "TITLE/K,BODY/A,BUTTONTEXT=BUTTON/K,DEFAULT/N/K,CENTERTEXT=CENTER/S,NORETURNKEY/S,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFTOFFSET=LEFT/N/K,PUBSCREEN/K";
 struct ReqToolsBase	*ReqToolsBase;

 /*
  * parse my command line
  */
 if (myrda = ReadArgs (Template, (LONG *)&shellargs, NULL))
 {
	if (ReqToolsBase = (struct ReqToolsBase *)OpenLibrary ("reqtools.library", LIBRARY_MINIMUM))
	{
		struct rtReqInfo *requester;

		if (requester = (struct rtReqInfo *) rtAllocRequest (RT_REQINFO, NULL))
		{
			char *body_text;
			LONG needed_buf_size;
			BPTR fd;
			struct Process *process = (struct Process *) FindTask (NULL);
			APTR windowptr = process->pr_WindowPtr;

			requester->ReqTitle = (shellargs.Title) ? (char *)shellargs.Title : "Request";

			if (fd = Open (shellargs.Body, MODE_OLDFILE))
			{
					Seek (fd, 0, OFFSET_END);
					needed_buf_size = Seek (fd, 0, OFFSET_BEGINNING);

					if (body_text = AllocVec (needed_buf_size + 1, MEMF_PUBLIC))
					{
						char *buf_ptr = body_text;
						char c;

						while ((c = FGetC (fd)) != EOF)
						{
							*buf_ptr++ = c;
						}
	
						*buf_ptr = '\0';	/* terminate body_text buffer */
					}

					Close (fd);

				/*
				 * Take care of requester positioning
				 */
				if (shellargs.Position)
				{
					if (stricmp (shellargs.Position, "POINTER") == 0)
						requester->ReqPos = REQPOS_POINTER;
					else if (stricmp (shellargs.Position, "CENTERSCR") == 0)
						requester->ReqPos = REQPOS_CENTERSCR;
					else if (stricmp (shellargs.Position, "TOPLEFTSCR") == 0)
						requester->ReqPos = REQPOS_TOPLEFTSCR;
					else if (stricmp (shellargs.Position, "CENTERWIN") == 0)
						requester->ReqPos = REQPOS_CENTERWIN;
					else if (stricmp (shellargs.Position, "TOPLEFTWIN") == 0)
						requester->ReqPos = REQPOS_TOPLEFTWIN;
					else
						requester->ReqPos = REQPOS_CENTERSCR;
				}

				if (shellargs.CenterText)
					requester->Flags |= EZREQF_CENTERTEXT;

				if (shellargs.NoReturnKey)
					requester->Flags |= EZREQF_NORETURNKEY;


				/*
				 * Tags will be used to take care ofattributes not directly
				 * settable in the rtReqInfo structure
				 */
				retval = rtEZRequestTags (body_text,
							 (shellargs.ButtonText) ? (char *)shellargs.ButtonText : "_Continue",
							 requester,
							 NULL,
							 (shellargs.Default) ? RTEZ_DefaultResponse : TAG_IGNORE,
							 shellargs.Default,

				/*
				 * Finally,
				 * set some more general tags shared by most requesters
				 */
							 RT_Underscore,		'_',
							 (shellargs.TopOffset) ? RT_TopOffset : TAG_IGNORE,
							 shellargs.TopOffset,
							 (shellargs.LeftOffset) ? RT_LeftOffset : TAG_IGNORE,
							 shellargs.LeftOffset,
							 (windowptr) ? RT_Window : TAG_IGNORE,
							 windowptr,
							 (shellargs.PubScreen) ? RT_PubScrName : TAG_IGNORE,
							 shellargs.PubScreen,
							 TAG_END);

				if (body_text)
					FreeVec (body_text);
			}

			rtFreeRequest (requester);
		}

		CloseLibrary ((struct Library *)ReqToolsBase);
	}
	else
	{
		/*
		 * Unable to open reqtools.library
		 */
		Printf ("\nAdvice: Unable to open reqtools.library.\n");

		retval = 21;
	}

	FreeArgs (myrda);
 }
 else
 {
	/*
	 * Something went wrong in the parse
	 */
	Printf ("%s", myexthelp);

	retval = 21;
 }

 return (retval);
}
