/* RemoveTabs.c
 *
 * This function removes all tabulator signs from a source file (or all
 * files in a directory) and replaces them by the according number or
 * spaces.
 *
 * The tool expects up to 6 arguments:
 *
 * From - this is a recommended argument, specifying the source to be processed
 *			This has to be a string with the (optional) path and the filename of a
 *			single source file of any filename (and extension) or the path of a
 *			directory, where all files with the extension ".c" and ".h"should be
 *			scanned.
 *
 * To - this recommended argument is used to specify the destination path of
 *			the created file. The specified directory has to exist. Subdirectories
 *			will be created if required.
 *			A copy of every processed source file without any tabulator sign is
 *			placed in this directory (you should take care that there is enough
 *			space.
 *
 * Width - Every tabulator sign found in the source is replaced by spaces.
 *			This optional argument can be used to specify the width of a single
 *			tabulator (default is 3). Allowed values are in the range from 1
 *			upto 16, if the specified value is outside of this range, the tool
 *			will fail with a secondary result of ERROR_BAD_NUMBER.
 *
 * All - If a source directory is specified using the argument 'From' and this
 *			switch is set, all subdirectories are also scanned, otherwise only the
 *			files that are located direct in the specified directory are touched.
 *			If a single file is specified by 'From', this switch is ignored.
 *
 * If a whole directory tree is processed, the destination directory tree will
 * contain every directory of the source tree, regardless if the directories
 * contain C-source or header files or not.
 */

#include <joinOS/exec/defines.h>
#include <joinOS/exec/memory.h>
#include <joinOS/misc/TagItems.h>
#include <joinOS/misc/TextBox.h>
#include <joinOS/database/DataServer.h>
#include <joinOS/database/Index.h>

#include <joinOS/protos/ExecProtos.h>
#include <joinOS/Protos/AmigaDOSProtos.h>
#include <joinOS/protos/JoinOSProtos.h>
#include <joinOS/protos/DatabaseProtos.h>

#include <string.h>

struct Library *JoinOSBase = NULL;

/* Prototypes of functions located in ReadLines.o
 */
BOOL CreateReadBuffer (void);
void ResetReadBuffer (void);
void DestroyReadBuffer (void);
STRPTR NextLine (BPTR fh);

/* --- Defines ----------------------------------------------------------- */

#ifndef ZERO
#define ZERO 0L
#endif

#define MAX_LINE_LENGTH 132		/* maximum length of written line */

/* --- Global data ------------------------------------------------------- */

STRPTR appname = "RemoveTabs";
STRPTR version = "$VER: RemoveTabs 1.0 (06.05.04), © 2004, Peter Riede";
STRPTR description = "\nReplaces all tabulator signs with "
							"spaces without changing the layout.\n\n";

STRPTR extHelp =
	"Available commandline arguments:\n"
	"From:     the source file or directory;\n"
	"To:       the destination directory;\n"
	"Width:    with of a single TAB sign, default = 3;\n"
	"All:      switch, recurse subdirectories is set;\n"
	"Enter arguments: ";

STRPTR template = "FROM/A,TO/A,WIDTH/N,ALL/S";

STRPTR errorText[] =
{
	"Bad argument specified",								/*  0 */
	"This application has to be run from CLI only.",/*  1 */
	"Unable to open joinOS.library\n",					/*  2 */
	"Failed to allocated I/O buffer",					/*  3 */
	"Failed to parse commandline arguments",			/*  4 */
	"Failed to allocate RDArgs structure",				/*  5 */
	"Failed to examine destination object",			/*  6 */
	"Failed to examine source object",					/*  7 */
	"Failed to allocate FileInfoBlock",					/*  8 */
	"Failed to lock destination object",				/*  9 */
	"Failed to lock source object",						/* 10 */
	"Failed to open source file",							/* 11 */
	"Failed to create destination file",				/* 12 */
	"Failed to read from source file",					/* 13 */
	"Failed to write to destination file",				/* 14 */
	"Failed to examine subdirectory",					/* 15 */
	"Failed to lock subdirectory",						/* 16 */
	"Failed to examine the source directory",			/* 17 */
	"Failed to create destination directory"			/* 18 */
};

UBYTE *LineBuffer = NULL;

/* --- Parsing the source ------------------------------------------------ */

/* NAME
 *		ProcessFile - replace all tabulator signs in a single file
 *
 * SYNOPSIS
 *		LONG ProcessFile (BPTR, STRPTR, BPTR, STRPTR, ULONG)
 *		result = ProcessFile (sFl, from, dFl, to, width)
 *
 * FUNCTION
 *		This function copies a single file to the destination directory and
 *		replaces all tabulator signs found by the according number of spaces.
 *		The layout of the file (if the number of spaces per tabulator sign have
 *		been specified correct) is not changed by this operation.
 *
 *		Any 'CRLF' found in the file are also replaced by a single linefeed.
 *
 * INPUTS
 *		sFl - a BPTR to the FileLock of the source directory. If this is ZERO,
 *				the filenmane (and optionla path) specified by the second argument
 *				'sFn' is interpreted relative to the current directory.
 *				If this argument is non-NULL, it MUST be a directory lock.
 *		from - a pointer to a NUL-terminated C-string with the filename (and
 *				optional path) of the file to be scanned.
 *		dFl - a BPTR to the FileLock of the destination directory.
 *		to - a pointer to a NUL-terminated C-string with the filename (without
 *				a path) of the file to be created.
 *		width - this argument has to be used to specify the width of a single
 *				tabulator, it has to be a non-zero value.
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG ProcessFile (BPTR sFl, STRPTR from, BPTR dFl, STRPTR to, ULONG width)
{
	LONG result = RETURN_FAIL;
	LONG dosError = 0L;
	BPTR curDir;
	BPTR sFh;

	if (sFl) curDir = CurrentDir (sFl);

	Printf ("   Scanning file \"%s\"...\n", from);

	if ((sFh = Open (from, MODE_OLDFILE)) != ZERO)
	{
		BPTR dFh;

		if (sFl) (void)CurrentDir (dFl);
		else curDir = CurrentDir (dFl);

		if ((dFh = Open (to, MODE_NEWFILE)) != ZERO)
		{
			STRPTR line;

			result = RETURN_OK;

			while (result == RETURN_OK)
			{
				/* Get next line...
				 */
				if (line = NextLine (sFh))
				{
					ULONG offset = 0;

					do
					{
						ULONG slen;
						UBYTE *c;

						slen = 0;
						c = LineBuffer;

						while (*line && (slen < MAX_LINE_LENGTH))
						{
							if (*line == '\t')
							{
								/* a tabulator -> replace it...
								 */
								do
								{
									slen += 1;
									*c++ = ' ';
								}
								while (((slen + offset) % width) &&
											(slen < MAX_LINE_LENGTH));

								line += 1;
							}
							else
							{
								slen += 1;
								*c++ = *line++;
							}
						}

						/* Write the line...
						 */
						if (!*line)
						{
							slen += 1;
							*c = '\n';
						}
						if (Write (dFh, LineBuffer, slen) != slen)
						{
							dosError = IoErr();
							PrintError (dosError, errorText[14]);
							result = RETURN_FAIL;
						}
						else offset += slen;
					}
					while (*line && (result == RETURN_OK));
				}
				else
				{
					if (dosError = IoErr())
					{
						result = RETURN_FAIL;
						PrintError (dosError, errorText[13]);
					}
					break;
				}
			}
			Close (dFh);
		}
		else
		{
			dosError = IoErr();
			PrintError (dosError, errorText[12]);
		}
		Close (sFh);
		(void)CurrentDir (curDir);
	}
	else
	{
		dosError = IoErr();
		PrintError (dosError, errorText[11]);

		if (sFl) (void)CurrentDir (curDir);
	}
	SetIOErr (dosError);

	return result;
}

/* NAME
 *		ProcessAllFiles - process a whole directory
 *
 * SYNOPSIS
 *		LONG ProcessAllFiles (BPTR, BPTR, struct FileInfoBlock *, ULONG, BOOL)
 *		result = ProcessAllFiles (sFl, dFl, fib, width, all)
 *
 * FUNCTION
 *		This function processes all C-source and header files found in the
 *		specifed directory and copies them by replacing the tabulator signs
 *		by the according number of spaces to the destination directory.
 *		If specified, it recurses into the subdirectories.
 *
 * INPUTS
 *		sFl - a BPTR to the FileLock of the directory to be processed. This MUST
 *					be a valid directory lock.
 *		dFl - a BPTR to the FileLock of the destination directory, this MUST be
 *					a valid directory lock.
 *		fib - a pointer to the FileInfoBlock structure used to Examine() the
 *					directory previously.
 *		width - this argument has to be used to specify the width of a single
 *				tabulator, it has to be a non-zero value.
 *		all - a boolean value, TRUE indicates that all subdirectories of the
 *					processed directory should also be scanned recursively
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG ProcessAllFiles (BPTR sFl, BPTR dFl,
							struct FileInfoBlock *fib, ULONG width, BOOL all)
{
	LONG result = RETURN_OK;
	BPTR curDir;
	LONG dosError = 0L;

	Printf ("Scanning directory \"%s\"...\n", fib->fib_FileName);
	curDir = CurrentDir (sFl);

	while ((result == RETURN_OK) && !dosError)
	{
		if (ExNext (sFl, fib) == DOSTRUE)
		{
			/* Let's see what we have found...
			 */
			if (fib->fib_DirEntryType >= 0)
			{
				/* Found entry is a directory...
				 */
				if (all)
				{
					/* Process all files located in there...
					 */
					BPTR fLock;

					result = RETURN_FAIL;
					if (fLock = Lock (fib->fib_FileName, SHARED_LOCK))
					{
						struct FileInfoBlock *fInfo;

						if (fInfo = (struct FileInfoBlock *)
												AllocDOSObject (DOS_FIB, NULL))
						{
							if (Examine (fLock, fInfo) == DOSTRUE)
							{
								/* Create a subdirectory...
								 */
								BPTR dirLock;

								(void)CurrentDir (dFl);
								dirLock = CreateDir (fib->fib_FileName);
								dosError = IoErr();
								(void)CurrentDir (sFl);

								if (dirLock)
								{
									result = ProcessAllFiles (fLock, dirLock,
																		fInfo, width, all);
									dosError = IoErr();
								}
								else
								{
									PrintError (dosError, errorText[18]);
								}
							}
							else
							{
								dosError = IoErr();
								PrintError (dosError, errorText[15]);
							}
							FreeDOSObject (DOS_FIB, fInfo);
						}
						else
						{
							dosError = ERROR_NO_FREE_STORE;
							PrintError (dosError, errorText[8]);
						}
						UnLock (fLock);
					}
					else
					{
						dosError = IoErr();
						PrintError (dosError, errorText[16]);
					}
				}
			}
			else
			{
				/* This should be a file ->
				 * Determine if it is a C-source or header file...
				 */
				UBYTE *p;
				UBYTE lastChar = 0;

				p = fib->fib_FileName;

				while (*++p)
				{
					if (!lastChar)
					{
						if (*p == '.') lastChar = *p;
					}
					else
					{
						if (lastChar == '.')
						{
							if ((Upper(*p) == 'C') || (Upper(*p) == 'H'))
								lastChar = Upper(*p);
							else
								lastChar = 0;
						}
						else lastChar = 0;
					}
				}
				if ((lastChar == 'C') || (lastChar == 'H'))
				{
					/* This should be a C-source or header file...
					 */
					result = ProcessFile (sFl, fib->fib_FileName, dFl,
														fib->fib_FileName, width);
					dosError = IoErr();
				}
			}
		}
		else
		{
			if ((dosError = IoErr()) != ERROR_NO_MORE_ENTRIES)
			{
				PrintError (dosError, errorText[17]);
				result = RETURN_FAIL;
			}
		}
	}
	(void)CurrentDir(curDir);

	if (dosError != ERROR_NO_MORE_ENTRIES) SetIOErr(dosError);

	return result;
}

/* NAME
 *		RemoveTabs - replace all tabulator sign in the specified file(s)
 *
 * SYNOPSIS
 *		LONG RemoveTabs (STRPTR, STRPTR, ULONG, BOOL)
 *		result = RemoveTabs (from, to, width, all)
 *
 * FUNCTION
 *		This function does every preparation required for replacing the tabulator
 *		signs in the source file(s).
 *		It examines the source and determines if a whole directory or a single
 *		file should be processed, it examines the destination directory, and it
 *		allocates all required buffers.
 *
 * INPUTS
 *		from - a pointer to a NUL-terminated C-string specifying the source file
 *				or directory. This has to point to an existing C-source or header
 *				file or a directory containing C-source or header files.
 *		to - a pointer to a NUL-terminated C-string specifying the destination
 *				directory. This directory has to exist. Required subdirectories
 *				will be created.
 *		width - this argument has to be used to specify the width of a single
 *				tabulator, it has to be a non-zero value.
 *		all - if the source specified by 'From' is a directory, this boolean
 *				value indicates, weather the subdirectories should also be scanned
 *				(TRUE) or not (FALSE). If 'From' identifies a single file, this
 *				argument is ignored.
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG RemoveTabs (STRPTR from, STRPTR to, ULONG width, BOOL all)
{
	LONG result = RETURN_FAIL;
	BPTR sFl, dFl;

	/* Lock the destination directory...
	 */
	if (dFl = Lock (to, SHARED_LOCK))
	{
		struct FileInfoBlock *fib;
		LONG dosError = 0L;

		/* Determine weather the source is a file or a directory...
		 */
		if (fib = (struct FileInfoBlock *)AllocDOSObject (DOS_FIB, NULL))
		{
			if (Examine (dFl, fib) == DOSTRUE)
			{
				if (fib->fib_DirEntryType >= 0)
				{
					/* Destination is a directory ->
					 * Lock the source file or directory...
					 */
					if (sFl = Lock (from, SHARED_LOCK))
					{
						if (Examine (sFl, fib) == DOSTRUE)
						{
							if (CreateReadBuffer())
							{
								if (fib->fib_DirEntryType >= 0)
								{
									/* Source is a directory.
									 * -> Process all files located in there...
									 */
									result = ProcessAllFiles(sFl, dFl, fib, width, all);
									dosError = IoErr();
								}
								else
								{
									result = ProcessFile (ZERO, from, dFl,
																fib->fib_FileName, width);
									dosError = IoErr();
								}
								DestroyReadBuffer ();
							}
							else
							{
								dosError = IoErr();
								PrintError (dosError, errorText[3]);
							}

						}
						else
						{
							dosError = IoErr();
							PrintError (dosError, errorText[7]);
						}
						UnLock (sFl);
					}
					else
					{
						dosError = IoErr();
						PrintError (dosError, errorText[10]);
					}
				}
				else PrintError (ERROR_OBJECT_WRONG_TYPE, errorText[6]);
			}
			else
			{
				dosError = IoErr();
				PrintError (dosError, errorText[6]);
			}
			FreeDOSObject (DOS_FIB, fib);
		}
		else
		{
			dosError = ERROR_NO_FREE_STORE;
			PrintError (dosError, errorText[8]);
		}
		UnLock (dFl);

		SetIOErr (dosError);
	}
	else PrintError (IoErr(), errorText[9]);

	return result;
}

/* --- Application entry point ------------------------------------------- */


/* NAME
 *		Main - the application entry function
 *
 * SYNOPSIS
 *		result = Main (length, cmdline)
 *		LONG Main (LONG, char*)
 *
 * FUNCTION
 *		This is the entry point of the application; this function is directly
 *		called from the startup-code.
 *
 *		The function examines, whether the user has specified an argument string
 *		and evaluates this.
 *		If the user choses valid arguments and passes a gultiy filename and
 *		destination path, the test-routines are called.
 *
 *		If no commandline is passed, the user is asked to insert one.
 *
 * INPUTS
 *		length - the number of characters that are stored in the passed
 *					commandline.
 *		cmdline - the commandline the user specified at program-startup.
 *
 * RESULT
 *		The final application result is returned, which is RESULT_FAIL if the
 *		application completely failed; RETURN_WARN, if anything fails during
 *		the program execution (something like no free store); RETURN_OK if
 *		everything wents fine.
 */
LONG Main (LONG length, char* cmdline)
{
	LONG result = RETURN_FAIL;

	if (JoinOSBase = OpenLibrary ("joinOS.library",0L))
	{
		if (length >= 0)
		{
			/* This tool has to be run from CLI.
			 */
			LONG vec[4] = {0};
			struct RDArgs *rda;

			PutStr (version + 6);
			PutStr (description);

			/* First get the parsed arguments...
			 */
			result = RETURN_WARN;
			if ((rda = AllocDOSObject (DOS_RDARGS, NULL)) != NULL)
			{
				LONG dosError;

				if (cmdline && length)
				{
					rda->RDA_Source.CS_Buffer = cmdline;
					rda->RDA_Source.CS_Length = length;
				}
				rda->RDA_ExtHelp = extHelp;

				if (ParseArgs (template, vec, rda) != NULL)
				{
					ULONG width; 
					if (vec[2]) width = *((ULONG *)vec[2]);
					else width = 3;

					if (width && (width < 16))
					{
						/* Ok, arguments are parsed, start processing...
						 */
						if (LineBuffer = (UBYTE *)
												AllocMem(MAX_LINE_LENGTH + 1, MEMF_PUBLIC))
						{
							result = RemoveTabs ((STRPTR)vec[0], (STRPTR)vec[1],
																	width, (BOOL)vec[3]);
							dosError = IoErr();
							FreeMem (LineBuffer, MAX_LINE_LENGTH + 1);
						}
						else
						{
							dosError = ERROR_NO_FREE_STORE;
							PrintError (dosError, errorText[3]);
						}
					}
					else
					{
						dosError = ERROR_BAD_NUMBER;
						PrintError (dosError, errorText[0]);
					}
					FreeArguments (rda);
				}
				else
				{
					dosError = IoErr();
					PrintError (dosError, errorText[4]);
				}
				FreeDOSObject (DOS_RDARGS, rda);
				SetIOErr (dosError);
			}
			else PrintError (IoErr(), errorText[5]);
		}
		else TextBox (NULL, appname, errorText[1], MSG_INFO,0L);

		CloseLibrary (JoinOSBase);
	}
	else
	{
		/* Just produce an error-message, if the program is started from CLI...
		 */
		if (length >= 0) PutStr (errorText[2]);
	}
	return result;
} 
