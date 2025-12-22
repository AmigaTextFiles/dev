#ifndef _PARSEARGS_H_
#define _PARSEARGS_H_ 1

/* RDArgs.h Version 3.0
 * Copyright (c) 04.2001
 *
 * Changes from Version 1.0 to 2.0
 *	Changed to system independent code, working now on AmigaOS 1.3 and above and
 * every system using the dos.library (dll).
 *
 * Changes from Version 2.0 to 3.0
 *	Completely rewritten because of several incompatibilities to the AmigaDos
 * functions ReadArgs(), ReadItem(), FreeArgs() and FindArg().
 * Now the functions of this implementation are able to act like the AmigaDos
 * functions, using the same structures and function-prototypes.
 *
 * A few additional argument-types and flags for RDA_Flags are added, these
 *	parameters are only available for the ParseArgs() function NOT for
 * ReadArgs().
 * So use ParseArgs(), FreeArguments(), ParseItem(), and FindArgument() instead
 *	of ReadArgs(), FreeArgs(), ReadItem(), and FindArg(), if you wish to use
 *	these argument-types:
 *
 *		/D - Date. This parameter exspects a date-string. The result will be
 *			a pointer to a long with the number of days since 01.01.1978 (The
 *			value of the long could be placed in a DateStamp structures ds_Days
 *			field). If no date string is found, the entry in the array is not
 *			changed, if a found date string is not valid (see DateStamp() for
 *			details about valid dates), it would be parsed to a string argument!
 *			By default a date-string must be entered in the DOS format
 *			"dd-mmm-yy" (e.g. "12-May-01"). The format of the date string could
 *			be changed by setting a flag in the RDA_Flags field of the RDArgs
 *			structure passed to ParseArgs():
 *				RDAF_DATE_INT - international format "yy-mm-dd" (e.g. "01-05-12")
 *				RDAF_DATE_USA - US-American format "mm-dd-yy" (e.g. "05-12-01")
 *				RDAF_DATE_CDN - Canadian format "dd-mm-yy" (e.g. "12-05-01")
 *				RDAF_DATE_DEF - default format of current locale used (currently
 *									not supported, defaults to DOS format).
 *			As a result of this, a date string has to be entered always in DOS
 *			format if no RDArgs structure is passed to ParseArgs().
 *
 *		/H - Time. This parameter allows to enter a time in the format "00:00:00"
 *			or "00:00". If a valid time string is found, the result will be a long
 *			pointer to the number of seconds passed since midnight. If the entered
 *			time string is not valid (e.g. "25:34", "12:67", or "13:"), the
 *			argument is passed to an empty string parameter!
 *
 * Look for the Autodoc of ParseArgs() or ReadArgs() for details about the
 * other available argument-types and modifiers.
 */

#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifdef _AMIGA
	#ifndef DOS_RDARGS_H
	#include <dos/rdargs.h>
	#endif
#endif

#ifndef ARG_BUFFER_SIZE
#define ARG_BUFFER_SIZE 256		/* size of buffer for input */
#endif

#ifndef _AMIGA

#ifndef MAX_TEMPLATE_ITEMS
#define MAX_TEMPLATE_ITEMS 100
#endif

#ifndef MAX_MULTIARGS
#define MAX_MULTIARGS 128	/* maximum number of multiargs arguments */
#endif

/* The following data structure defines the input source for ReadItem() as well
 *	as the ReadArgs call.
 * If this structure should be passed do dos.library functions, the value
 * passed as struct CSource* is defined as follows:
 *	If NULL is passed, stdin is used as data source, else CSource is used for
 * input character stream.
 *	The following two pseudo-code routines define how the CSource structure is
 * used:
 *
 * long CS_ReadChar (struct CSource *CSource)
 * {
 * 	if (CSource == NULL) return ReadChar();
 *		if (CSource->CurChr <= CSource->Length) return ENDSTREAMCHAR;
 *		return CSource->Buffer[CSource->CurChr++];
 * }
 *
 * BOOL CS_UnReadChar (struct CSource *CSource)
 * {
 *		if (CSource == 0) return UnReadChar();
 *		if (CSource->CurChr <= 0) return FALSE;
 *		CSource->CurChr--;
 *		return TRUE;
 * }
 *
 * To initialize a struct CSource, you set CSource->CS_Buffer to a string which
 *	is used as the data source, and set CS_Length to the number of characters in
 * the string. Normally CS_CurChr should be initilized top ZERO, or left as it
 * was from prior use as a CSource.
 */

struct CSource
{
	UBYTE *CS_Buffer;
	LONG	CS_Length;
	LONG	CS_CurChr;
};

/* The RDArgs data structure is the input parameter passed to the dos
 * ReadArgs() function call.
 *
 * The RDA_Source structure is a CSource as defined above;
 * if RDA_Source.CS_Buffer is non-NULL,, RDA_Source is used as the input
 * character stream to parse, else the input comes from the (line-)buffered
 * STDIN calls ReadChar()/UnReadChar(). The source must be terminated by a
 * linefeed, which might or might not be changed in the future.
 *
 * The RDA_DAList is a private address which is used internally to track
 * allocations which are freed by FreeArgs(). This MUST be initialized to
 * NULL prior to the first call to ReadArgs().
 *
 * The RDA_Buffer and RDA_BufSiz fields allow the application to supply a
 * fixed-size buffer in which to store the parsed data. This allows the
 * application to pre-allocate a buffer rather than requiring buffer space
 * to be allocated. If either RDA_Buffer or RDA_BufSize is NULL, the
 * application has not supplied a buffer.
 * Usually, there is no reason not to let the dos.library allocate the string
 * space automatically. The buffer size required depends on the input data and
 * should be currently at a minimum the size of the argument-string (if the
 * arguments should be read from commandline, you should allocate a buffer of
 * 256 bytes, which is currently the maximum length of a commandline).
 * If the template has an multiple argument ("/M"), the buffer have an
 * additional space of MAX_MULTIARGS * 4 bytes.
 *
 * RDA_ExtHelp is a text string (C string) which will be displayed instead of
 * the template string, if the user prompted for input.
 *
 * The RDA_Flag bits control how ReadArgs() work. The flag bits are defined
 * below.
 * Defaults are initialized to zero.
 */
struct RDArgs
{
	struct CSource RDA_Source;		/* Select input source */
	LONG		RDA_DAList;				/* PRIVATE */
	UBYTE 	*RDA_Buffer;			/* optional string parsing space */
	LONG		RDA_BufSiz;				/* size of RDA_Buffer (0..n) */
	UBYTE		*RDA_ExtHelp;			/* optional extended help */
	LONG		RDA_Flags;				/* Flags for any required control */
};

#define RDAB_STDIN		0	/* get the arguments from STDIN (ignored if not*/
#define RDAF_STDIN (1L<<RDAB_STDIN)	 /* set, this is the default behaviour) */
#define RDAB_NOALLOC		1	/* RDA_Buffer is allocated from user-application */
#define RDAF_NOALLOC		(1L<<RDAB_NOALLOC)
#define RDAB_NOPROMPT	2		/* don't prompt template or extended help */
#define RDAF_NOPROMPT	(1L<<RDAB_NOPROMPT)

#endif		/* _AMIGA */

/* The next flags are specifying, how ParseArgs() (NOT ReadArgs()) will parse
 * date-strings for /D parameters. If none of this flags is set, the DOS date
 * format "dd-mmm-yy" is used (e.g. "12-May-01").
 * DON'T USE THIS FLAGS IN COMBINATION WITH ReadArgs() !
 */
#define RDAB_DATE_INT	25	/* dates must be passed in format "yy-mm-dd" */
#define RDAF_DATE_INT (1L<<RDAB_DATE_INT)
#define RDAB_DATE_USA	26	/* dates must be passed in format "mm-dd-yy" */
#define RDAF_DATE_USA (1L<<RDAB_DATE_USA)
#define RDAB_DATE_CDN	27	/* dates must be passed in format "dd-mm-yy" */
#define RDAF_DATE_CDN (1L<<RDAB_DATE_CDN)
#define RDAB_DATE_DEF	28	/* date format from locale (currently not supported*/
#define RDAF_DATE_DEF (1L<<RDAB_DATE_DEF) 	/* , defaults to DOS date format)*/
#define RDAB_FUTURE		29	/* weekdays refer to future */
#define RDAF_FUTURE (1L<<RDAB_FUTURE)

#endif		/* _PARSEARGS_H_ */
