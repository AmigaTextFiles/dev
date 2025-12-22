/*
 * Flush
 * Selectively remove unused libraries, devices and fonts from memory.
 *
 * Written by Septh (Stephan Schreiber)
 * FreeWare - Use at will!
 */

#include <string.h>
#include <exec/types.h>
#include <exec/nodes.h>
#include <exec/lists.h>
#include <exec/memory.h>
#include <exec/libraries.h>
#include <exec/devices.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <dos/dosasl.h>
#include <graphics/text.h>
#include <graphics/gfxbase.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/graphics_protos.h>

#include <pragmas/exec_sysbase_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/graphics_pragmas.h>

/******************************************************************************
 * Constants and macros
 ******************************************************************************/
#define	TEMPLATE	"NAMES/M,LIBS=LIBRARIES/S,DEVS=DEVICES/S,FONTS/S,ALL/S,QUIET/S"
enum
{	OPT_NAMES = 0,	// Name(s) of libs/devs/fonts to flush
	OPT_LIBS,		// Limit flush to libraries
	OPT_DEVS,		// Limit flush to devices
	OPT_FONTS,		// Limit flush to fonts
	OPT_ALL,		// Flush libs, devs AND fonts
	OPT_QUIET,		// Shut up!
	NUM_OPTS
};

/* Short-cuts */
#define	lib_Succ	lib_Node.ln_Succ
#define	lib_Name	lib_Node.ln_Name

#define	dd_Succ		dd_Library.lib_Node.ln_Succ
#define	dd_Name		dd_Library.lib_Node.ln_Name

#define	tf_Succ		tf_Message.mn_Node.ln_Succ
#define	tf_Name		tf_Message.mn_Node.ln_Name

/******************************************************************************
 * Globals
 ******************************************************************************/
UBYTE *version = "\0$VER: Flush 1.1b (12.11.95)";

struct Library *SysBase;
struct Library *DOSBase;
struct Library *GfxBase;

UBYTE *def_names[] =
{	"#?",
	NULL
};

/******************************************************************************
 * Prototypes
 ******************************************************************************/
LONG flush_fonts(UBYTE **names, LONG quiet);
LONG flush_devs(UBYTE **names, LONG quiet);
LONG flush_libs(UBYTE **names, LONG quiet);

/******************************************************************************
 * Program entry point
 ******************************************************************************/
LONG __saveds main(UBYTE *cmdline)
{
struct Process *me;
struct Message *wbmsg;
struct RDArgs *rda;
ULONG opts[NUM_OPTS];
LONG num_flushed, num;
BOOL again;

	/* Get SysBase */
	SysBase = *((struct Library **)4L);

	/* Minimal WB startup */
	me = (struct Process *)FindTask(NULL);
	if (me->pr_CLI == NULL)
	{	WaitPort(&me->pr_MsgPort);
		wbmsg = GetMsg(&me->pr_MsgPort);
	}
	else wbmsg = NULL;

	/* Open the libraries */
	if (DOSBase= OpenLibrary("dos.library", 37L))
	{	if (GfxBase = OpenLibrary("graphics.library", 0L))
		{	/* When run under Workbench,
			 * no arguments are usable.
			 */
			if (wbmsg)
			{	flush_fonts(def_names, TRUE);
				flush_devs(def_names, TRUE);
				flush_libs(def_names, TRUE);
			}
			else
			{	/* Get shell arguments */
				memset(opts, '\0', sizeof(opts));
				rda = ReadArgs(TEMPLATE, opts, NULL);

				/* Break ? */
				if (CheckSignal(SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
				{	if (rda)
					{	FreeArgs(rda);
						rda = NULL;
					}
					SetIoErr(ERROR_BREAK);
				}

				if (rda)
				{	/* ALL ? */
					if (opts[OPT_ALL] || (!opts[OPT_LIBS] && !opts[OPT_DEVS] && !opts[OPT_FONTS]))
					{	opts[OPT_LIBS]  = /*DOSTRUE;*/
						opts[OPT_DEVS]  = /*DOSTRUE;*/
						opts[OPT_FONTS] = DOSTRUE;
					}

					/* New to version 1.1:
					 * since libraries or devices may open other libraries, devices or fonts,
					 * and close them only when they are flushed (possibly leaving them
					 * with an open count of 0), we have to loop until everything really gets flushed.
					 */
					num_flushed = 0;

					do
					{	again = FALSE;

						/* Here we begin with fonts for aesthetics reasons:
						 * if we flushed the libraries before the fonts,
						 * then we could not report which fonts would get flushed.
						 * This is because when flushed, diskfont.library
						 * simply removes all unsued fonts still in memory.
						 */
						/* FONTS ? */
						if (opts[OPT_FONTS])
						{	if (num = flush_fonts((UBYTE **)opts[OPT_NAMES], opts[OPT_QUIET]))
							{	num_flushed += num;
								again = TRUE;
							}
						}

						/* These two could use a single function... */
						/* DEVS ? */
						if (opts[OPT_DEVS])
						{	if (num = flush_devs((UBYTE **)opts[OPT_NAMES], opts[OPT_QUIET]))
							{	num_flushed += num;
								again = TRUE;
							}
						}

						/* LIBS ? */
						if (opts[OPT_LIBS])
						{	if (num = flush_libs((UBYTE **)opts[OPT_NAMES], opts[OPT_QUIET]))
							{	num_flushed += num;
								again = TRUE;
							}
						}

						/* Loop until every flushable little thing is flushed */
					} while (again);

					/* Report what we did */
					if (!opts[OPT_QUIET])
						Printf("%ld elements flushed\n", num_flushed);

					FreeArgs(rda);
				}
				else PrintFault(IoErr(), NULL);
			}
			CloseLibrary(GfxBase);
		}
		CloseLibrary(DOSBase);
	}

	/* Back to WB ? */
	if (wbmsg)
	{	Forbid();
		ReplyMsg(wbmsg);
	}

	return(RETURN_OK);
}

/******************************************************************************
 * Flush unused fonts
 ******************************************************************************/
LONG flush_fonts(UBYTE **names, LONG quiet)
{
struct List *fonts_list;
struct TextFont *font;
UBYTE pat[256], font_name[256];
UWORD font_size;
struct TextFont *tmp_font;
LONG num = 0;

	/* Get the fonts list */
	fonts_list = &(((struct GfxBase *)GfxBase)->TextFonts);

	if (names == NULL)
		names = def_names;

	while (*names)
	{	/* Allow for wildcards in names */
		ParsePatternNoCase(*names++, pat, sizeof(pat));

		Forbid();

		/* For each font in the system... */
		for (font = (struct TextFont *)fonts_list->lh_Head; font->tf_Succ; font = (struct TextFont *)font->tf_Succ)
		{	/* Check number of accessors to this font
			 * See if name matches
			 */
			if ((font->tf_Accessors == 0) && MatchPatternNoCase(pat, font->tf_Name))
			{	/* Copy name in temp buffer */
				strcpy(font_name, font->tf_Name);

				/* Copy font size, too */
				font_size = font->tf_YSize;

				/* Ok, let's flush it */
				StripFont(font);	// Fonts won't flush without this!
				RemFont(font);

				/* Check if it really flushed */
				tmp_font = (struct TextFont *)fonts_list;
				while (tmp_font = (struct TextFont *)FindName((struct List *)tmp_font, font_name))
				{	if (tmp_font == font)
						break;
				}

				if (tmp_font == NULL)
				{	num++;

					/* Tell them it's done */
					if (!quiet)
					{	Permit();
						Printf("font \"%s\", size %ld flushed\n", font_name, font_size);
						Forbid();
					}

					/* Go back to start of list.
					 * Note that because we are in a for() loop,
					 * the 'font = font->tf_Succ' statement
					 * will be executed *after* this one.
					 * So we have to make 'font' point to
					 * the list header rather than to the head node,
					 * or we'll miss the first font in the list.
					 */
					font = (struct TextFont *)fonts_list;
				}
			}
		}

		Permit();
	}

	return(num);
}

/******************************************************************************
 * Flush unused devices
 ******************************************************************************/
LONG flush_devs(UBYTE **names, LONG quiet)
{
struct List *devs_list;
struct Device *dev;
UBYTE pat[256], dev_name[256];
LONG num = 0;

	/* Get the devices list */
	devs_list = &(((struct ExecBase *)SysBase)->DeviceList);

	if (names == NULL)
		names = def_names;

	while (*names)
	{	/* Allows for wildcards in names */
		ParsePatternNoCase(*names++, pat, sizeof(pat));

		Forbid();

		/* for each device in the list... */
		for (dev = (struct Device *)devs_list->lh_Head; dev->dd_Succ; dev = (struct Device *)dev->dd_Succ)
		{	/* Check opencount of this device.
			 * See if name matches.
			 */
			if ((dev->dd_Library.lib_OpenCnt == 0) && MatchPatternNoCase(pat, dev->dd_Name))
			{	/* Copy name in temp buffer */
				strcpy(dev_name, dev->dd_Name);

				/* Ok, let's flush it */
				RemDevice(dev);

				/* Check if it really flushed */
				if (FindName(devs_list, dev_name) == NULL)
				{	num++;

					/* Tell them it's done */
					if (!quiet)
					{	Permit();
						Printf("Device \"%s\" flushed\n", dev_name);
						Forbid();
					}

					/* Go back to start of list.
					 * Note that because we are in a for() loop,
					 * the 'dev = dev->dd_Succ' statement
					 * will be executed *after* this one.
					 * So we have to make 'dev' point to
					 * the list header rather than to the head node,
					 * or we'll miss the first device in the list.
					 */
					dev = (struct Device *)devs_list;
				}
			}
		}

		Permit();
	}

	return(num);
}

/******************************************************************************
 * Flush unused libraries
 ******************************************************************************/
LONG flush_libs(UBYTE **names, LONG quiet)
{
struct List *libs_list;
struct Library *lib;
UBYTE pat[256], lib_name[256];
LONG num = 0;

	/* Get the libraries list */
	libs_list = &(((struct ExecBase *)SysBase)->LibList);

	if (names == NULL)
		names = def_names;

	while (*names)
	{	/* Allows for wildcards in names */
		ParsePatternNoCase(*names++, pat, sizeof(pat));

		Forbid();

		/* for each library in the system... */
		for (lib = (struct Library *)libs_list->lh_Head; lib->lib_Succ; lib = (struct Library *)lib->lib_Succ)
		{	/* Check opencount of this library.
			 * See if name matches.
			 */
			if ((lib->lib_OpenCnt == 0) && MatchPatternNoCase(pat, lib->lib_Name))
			{	/* Copy name in temp buffer */
				strcpy(lib_name, lib->lib_Name);

				/* Ok, let's flush it */
				RemLibrary(lib);

				/* Check if it really flushed */
				if (FindName(libs_list, lib_name) == NULL)
				{	num++;

					/* Tell them it's done */
					if (!quiet)
					{	Permit();
						Printf("Library \"%s\" flushed\n", lib_name);
						Forbid();
					}

					/* Go back to start of list.
					 * Note that because we are in a for() loop,
					 * the 'lib = lib->lib_Succ' statement
					 * will be executed *after* this one.
					 * So we have to make 'lib' point to
					 * the list header rather than to the head node,
					 * or we'll miss the first library in the list.
					 */
					lib = (struct Library *)libs_list;
				}
			}
		}

		Permit();
	}

	return(num);
}
