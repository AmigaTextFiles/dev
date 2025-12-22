/* ExtractAutodoc.c
 *
 * This function extracts the AutoDoc information from all C sourcefiles in a
 * specified directory.
 *
 * It uses an index to order the AutoDocs by name and create a
 * TABLE OF CONTENTS.
 *
 * This tool has been written, because I've documented my functions in the
 * sources without following the Autodoc style, so I could either rework all
 * documentation in every of my source-files, or write this little tool.
 * (And even if I had reformated my source-file documentation, the "autodoc"
 * tool didn't work properly.)
 *
 * Another benefit is that this is an example how flexible the database.library
 * could be used.
 *
 * Because no DataTable is created by this tool, it is also executable on
 * systems running AmigaOS 1.3 !
 *
 * The tool expects up to 6 arguments:
 *
 * From - this is a recommended argument, specifying the source to be processed
 *			This has to be a string with the (optional) path and the filename of a
 *			single C-source file of any filename (and extension) or the path of a
 *			directory, where all files with the extension ".c" should be scanned.
 *			If no Autodoc is found in the specifed source, the tool fails with a
 *			secondary result of ERROR_OBJECT_WRONG_TYPE.
 *
 * To - this optional filename (optionally including a path) specifies the name
 *			(and position) of the Autodoc file to be created. If this argument is
 *			not specified, the destination file will be created in the same
 *			directory as "From" and would have the same filename as the source file
 *			of\r directory specified by 'From' with the extension ".doc".
 *			If 'From' specifies the root directory of a device, this argument must
 *			be specified.
 *
 * Title - this recommend argument specifies the name of the command/library
 *			the Autodocs belong to, e.g. if the extracted Autodocs describe the
 *			functions of the database.library this would usually be named
 *			"database.library". (If the in-source documentation followes the
 *			official Autodoc-style, this string would be part of the line starting
 *			an Autodoc.
 *			This string has to have a maximum length that is shorter than a half
 *			line in the created file (i.e. shorter than half of the value
 *			specified using the argument 'Width'), or this tool will fail with a
 *			secondary result of ERROR_LINE_TOO_LONG.
 *
 * Width - This optional argument specifies the maximum width of a single line
 *			of the created Autodoc file (default is 80).
 *			Every line that is longer than this width will be "broken" without
 *			word-wrapping, so the result will be very ugly if you	choose a value
 *			that is too small. Allowed values are in the range from 40 upto 256,
 *			if the specified value is outside of this range, the tool will fail
 *			with a secondary result of ERROR_BAD_NUMBER.
 *
 * TabWidth - Every tabulator sign found in the source is replaced by spaces.
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
 * - This tool could either process "regular" Autodocs -- except for the
 * 	'modulename' where always the 'title' string is used instead -- as long
 *		as the lines are not preceded by a semicolon (as usual for assembler
 *		comments).
 * - This tool could only process C-style comments.
 * - Internal marks are currently ignored.
 * - The main goal of this tool was to create Autodocs from C-sources
 *		containing function descriptions as found in this file.
 *
 * A temporary file containing the extracted Autodocs is created in "T:" (and
 * deleted after program execution). If you have enough memory available, you
 * should take care that "T:" is assigned to a directory in the ram-disk to
 * speed up the program execution. If you are very low on memory, you should
 * assign "T:" to a directory on your harddisk, to save some memory.
 * The temporary file will contain the whole Autodoc file  except the
 * "TABLE OF CONTENTS", so you could approximate the size of this file and
 * therefore the required free memory.
 * The tools itself requires a stack of 4096 bytes (maybe much smaller,
 * depending if and how many subdirectories should be scanned). It allocates
 * about 6 KB for buffering plus additional 512 bytes per subdirectory level
 * that is scanned (plus three Filehandles (~1.5 KB) and one FileLock per
 * subdirectory level).
 *
 * It opens the "dos.library", "joinOS.library", and "database.library".
 * The "joinOS.library" opens "intuition.library" and "utility.library" (if
 * present).
 *
 * EXAMPLE
 *		To create the Autodoc of this source file for the "ExtractAD" tool:
 *
 *			ExtractAD ExtractAutodoc.c title=ExtractAD
 *
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
struct Library *DatabaseBase = NULL;

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

/* The following defines are the tokens that ,may be returned by Token()...
 */
#define T_STARTCOMMENT	1	/* a commend starts in this line */
#define T_ENDCOMMENT		2	/* a commend is terminated by this line
									 * (this also terminates any Autodoc) */
#define T_STARTDOC		3	/* a (regular) Autodoc is started in this line */
#define T_DOC				4	/* the line contains the string "* NAME\0" */
#define T_ENDDOC			5	/* a (regular) Autodoc is terminated by this line */


#define COPY_BUFFER_SIZE 4096	/* size of the buffer used for copying */

/* --- Global data ------------------------------------------------------- */

STRPTR appname = "ExtractAD";
STRPTR version = "$VER: ExtractAD 1.0 (06.05.04), © 2004, Peter Riede";
STRPTR description = "\nExtracts the Autodoc information from C source files.\n\n";

STRPTR extHelp =
	"Available commandline arguments:\n"
	"From:     the source file or directory;\n"
	"To:       the destination file;\n"
	"Title:    title of the Autodoc, e.g. \"database.library\";\n"
	"Width:    width of a line of text used for the headlines, default = 80;\n"
	"Tabwidth: with of a single TAB sign, default = 3;\n"
	"All:      switch, recurse subdirectories is set;\n"
	"Enter arguments: ";

STRPTR template = "FROM/A,TO,TITLE/A/K,WIDTH/N,TABWIDTH/N,ALL/S";

STRPTR errorText[] =
{
	"Failed to write to final file",						/*  0 */
	"Failed to read from temporary file",				/*  1 */
	"Failed to reposition temporary file",				/*  2 */
	"Failed to allocated I/O buffer",					/*  3 */
	"Failed to write the \"TABLE OF CONTENTS\"",		/*  4 */
	"Failed to lock source object",						/*  5 */
	"Failed to write Autodoc",								/*  6 */
	"Failed to read from source",							/*  7 */
	"Failed to examine subdirectory",					/*  8 */
	"Failed to allocate FileInfoBlock",					/*  9 */
	"Failed to lock subdirectory",						/* 10 */
	"Failed to open source file",							/* 11 */
	"Failed to examine the source directory",			/* 12 */
	"Failed to create temporary file",					/* 13 */
	"Failed to create Autodoc file",						/* 14 */
	"Failed to allocate filename buffer",				/* 15 */
	"Failed to access parent directory",				/* 16 */
	"Failed to examine source object",					/* 17 */
	"Failed to parse commandline arguments",			/* 18 */
	"Failed to allocate RDArgs structure",				/* 19 */
	"No Autodocs found",										/* 20 */
	"Bad argument specified",								/* 21 */
	"This application has to be run from CLI only.",/* 22 */
	"Unable to open joinOS.library\n",					/* 23 */
	"Unable to open database.library."					/* 24 */
};

struct DataColumn dataColumn =
{
	"Function",
	NULL,
	NULL,
	0,
	DC_CHAR,
	40,
	0,
	1,
	NULL,
	NULL,
	NULL,
	NULL
};

struct TagItem idxTags[] =
{
	{IDX_Name, (ULONG)"FunctionNames"},
	{IDX_Expression, (ULONG)"Function"},
	{IDX_Server, NULL},
	{TAG_DONE, 0}
};

ULONG Width = 80;
ULONG TabWidth = 3;
UBYTE *LineBuffer = NULL;
ULONG bytesWritten = 1;

/* --- Generic functions ------------------------------------------------- */

/* Open the required libraries
 */
BOOL OpenLibs(void)
{
	BOOL opened = FALSE;

	if (JoinOSBase = OpenLibrary ("joinOS.library",0L))
		if (DatabaseBase = OpenLibrary ("database.library",0L))
			opened = TRUE;

	return opened;
}

/* close the opened libraries
 */
void CloseLibs(void)
{
	if (JoinOSBase) CloseLibrary (JoinOSBase);
	if (DatabaseBase) CloseLibrary (DatabaseBase);
}

/* --- Update function of DataServer ------------------------------------- */

/* NAME
 *		DummyUpdate - callback function for processing some operations
 *
 * SYNOPSIS
 *		BOOL DummyUpdate (struct DataServer *, ULONG, APTR)
 *		success = DummyUpdate (server, operation, arg)
 *		  D0                    A0       D0       A1
 *
 * FUNCTION
 *		This function performs any operation on this dummy Dataserver.
 *		Any operation that is not performed by this function is passed to the
 *		DS_Update() function of the underlying DataServer.
 *
 *		The server can store a single row with a single column of the type
 *		DC_CHAR. The columns data is stored in a buffer pointed to by the
 *		'Device' field of the DataServer.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the dummy server.
 *		operation - the operation that should be performed.
 *					With the exception of DS_GETRAWDATA and DS_SETCOLUMNDATA, every
 *					required operation is already supported by the base DataServer
 *					class, so I only need to add the functionality required to store
 *					into and read from the DataColumn of the DataServer.
 *		arg - the type and contents of this argument depends on the 'operation'
 *					that should be performed.
 * RESULT
 *		If the operation succeeds, TRUE is returned. Depending on the type of
 *		operation performed, the address 'arg' points to may have changed.
 *		If the function fails, FALSE is returned, check 'DataServer.LastError'
 *		for the cause of the failure.
 *		
 * NOTE
 *		I don't perform any argument checking, this DataServer class is only used
 *		for extracting Autodocs from source-files.
 */
BOOL __saveds __asm DummyUpdate (register __a0 struct DataServer *server,
											register __d0 ULONG operation,
											register __a1 APTR arg)
{
	BOOL success = TRUE;
	ULONG error = 0L;

	server->LastError = DS_ERR_NO_ERROR;
	switch (operation)
	{
		case DS_GOTOROW:
			/* Skip direct to the specified row...
			 */
			server->CurrentRow = (ULONG)arg;
			break;
		case DS_GETRAWDATA:
			/* get the data of the column...
			 */
			if (arg)
			{
				*((ULONG *)arg) = (ULONG)server->Device;
			}
			else
			{
				error = DS_ERR_WRONG_ARG;
				success = FALSE;
			}
			break;
		case DS_GETCOLUMNDATA:
			/* get the data of the column...
			 */
			if (arg)
			{
				struct DataColumn *cc;

				server->CurrentColumn = 1;
				if (success = DS_Update (server, DS_CURRENTCOLUMN, (APTR)&cc))
				{
					success = DC_DefaultConvert(cc, server->Device);
					*((STRPTR *)arg) = cc->Buffer;
				}
			}
			else
			{
				error = DS_ERR_WRONG_ARG;
				success = FALSE;
			}
			break;
		case DS_SETRAWDATA:
			/* change the data of the column...
			 */
		case DS_SETCOLUMNDATA:
			/* change the data of the column...
			 */
			{
				struct DataColumn *dc;

				server->CurrentColumn = 1;
				if (success = DS_Update (server, DS_CURRENTCOLUMN, (APTR)&dc))
				{
					if ((operation == DS_SETRAWDATA) && arg)
					{
						CopyMem (arg, server->Device, dc->Length);
					}
					else
					{
						/* Convert the data to the RAW-format...
						 */
						success = DC_DefaultRevert(dc, (STRPTR)arg, server->Device);
						if (!success) error = DS_ERR_WRONG_ARG;
					}
				}
			}
			break;
		case DS_DISPOSE:
			/* Dispose the DataServer...
			 */
			if (server->Device) FreeVector (server->Device);

			/* Dispose the underlying DataServer...
			 */
		default:
			/* Unknown operation, or operation implemented in the DataServer ->
			 * Send it to the underlying DataServer...
			 */
			success = DS_Update (server, operation, arg);
			break;
	}
	if (error) server->LastError = error;

	return success;
}



/* --- Creating the dummy DataServer ------------------------------------- */

/* NAME
 *		CreateServer - create the dummy DataServer
 *
 * SYNOPSIS
 *		struct DataServer *CreateServer (void)
 *		dataServer = CreateServer ()
 *
 * FUNCTION
 *		This function creates the dummy DataServer used to fool the index. The
 *		index needs to accesss a DataServer that is able to process the
 *		following operations:
 *			DS_CURRENTCOLUMN, DS_GOTOCOLUMN, DS_FINDCOLUMN, and DS_GETRAWDATA
 *
 *		So this "DataServer" will support this commands and will be able to store
 *		a single data, a function name stored in a DataColumn of the type DC_CHAR
 *		of a half textline (as specified during start using the argument "WIDTH")
 *		in length (if a longer functionname is specified in any autodoc, it will
 *		be truncated).
 *		The single string could be stored using the function DS_SETCOLUMNDATA.
 *
 *		The string is stored in a buffer pointed to by the 'Device' field of the
 *		DataServer structure.
 *
 *		The number of the row is used as offset into the temporary file created
 *		with the Autodocs extracted from the source, so the according Autodocs
 *		could be located during joining with the "TABLE OF CONTENTS".
 *
 * RESULT
 *		A pointer to the DataServer structure is returned or NULL if the system
 *		is running out of memory.
 */
struct DataServer *CreateServer (void)
{
	struct DataServer *ds;

	if (ds = DS_InitA (NULL, NULL))
	{
		BOOL success;

		dataColumn.Length = Width >> 1;

		if (success = DS_DoUpdate (ds, DS_ADDCOLUMN, (APTR)&dataColumn))
		{
			if (ds->Device = AllocVector (dataColumn.Length, MEMF_ANY))
			{
				/* Replace the operation processing function...
				 */
				ds->Update = &DummyUpdate;
			}
			else success = FALSE;
		}

		if (!success)
		{
			DS_DoUpdate (ds, DS_DISPOSE, NULL);
			ds = NULL;
		}
	}
	return ds;
}

/* --- Writing to the file(s) -------------------------------------------- */

/* NAME
 *		AppendTempFile - append the docs to the file with the TABLE OF CONTENTS
 *
 * SYNOPSIS
 *		LONG AppendTempFile (struct DataServer *, BPTR, BPTR)
 *		result = AppendTempFile (server, dFh, sFh)
 * 
 * FUNCTION
 *		This function appends the contents of one file to another one.
 *		It is used to copy the text of all Autodocs from the temporary file
 *		behind the "TABLE OF CONTENTS" that has already been written to the
 *		final file.
 *		The Autodocs stored in the temporary file are copied in the same order
 *		as specified by the "TABLE OF CONTENTS" into the final file.
 *
 * INPUT
 *		server - a pointer to the DataServer structure, used in conjunction with
 *					the index attached to the 'Order' field of this structure to
 *					order the functions described in the "Autodoc" by their name.
 *		dFh - the BPTR to the FileHandle of the destination file, i.e. the file
 *				that should be appended to. The filepointer of this file has to be
 *				placed at the end of the file, i.e. the insertion position.
 *		sFh - the BPTR to the FileHandle of the source file, i.e. the file that
 *				should be appended behind the other file. The filepointer of this
 *				file could be positioned anywhere.
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG AppendTempFile (struct DataServer *server, BPTR dFh, BPTR sFh)
{
	LONG result = RETURN_OK;
	UBYTE *buffer;

	if (buffer = AllocMem (COPY_BUFFER_SIZE, MEMF_PUBLIC))
	{
		ULONG offset;

		offset = IDX_SkipTop ((struct IDXHeader *)server->Order);

		while (offset && (result == RETURN_OK))
		{
			/* Seek to the Autodoc...
			 */
			if (Seek (sFh, offset - 1, OFFSET_BEGINNING) != -1)
			{
				LONG bytesRead;
				LONG toWrite;

				/* Copy the Autodoc (terminated by a formfeed)...
				 */
				do
				{
					if ((bytesRead = Read (sFh, buffer, COPY_BUFFER_SIZE)) > 0)
					{
						UBYTE *p = buffer;

						/* Scan the buffer for a formfeed...
						 */
						toWrite = 1;
						while ((toWrite < bytesRead) && (*p != '\f'))
						{
							toWrite += 1;
							p += 1;
						}

						if (Write (dFh, buffer, toWrite) != toWrite)
						{
							PrintError (IoErr(), errorText[0]);
							result = RETURN_FAIL;
						}
					}
					else
					{
						PrintError (IoErr(), errorText[1]);
						result = RETURN_FAIL;
					}
				}
				while ((result == RETURN_OK) && (toWrite == COPY_BUFFER_SIZE));
			}
			else
			{
				PrintError (IoErr(), errorText[2]);
				result = RETURN_FAIL;
			}
			offset = IDX_SkipNext ((struct IDXHeader *)server->Order, 1);
		}
		FreeMem (buffer, COPY_BUFFER_SIZE);
	}
	else
	{
		PrintError (ERROR_NO_FREE_STORE, errorText[3]);
		result = RETURN_FAIL;
	}
	return result;
}

/* NAME
 *		WriteContentsTable - create the "TABLE OF CONTENTS"
 *
 * SYNOPSIS
 *		LONG WriteContentsTable (struct DataServer *, BPTR, STRPTR)
 *		result = WriteContentsTable (server, fh, title)
 *
 * FUNCTION
 *		This function writes the "TABLE OF CONTENTS" of the created Autodoc file,
 *		therefore the destination document file is created, the "TABLE OF
 *		CONTENTS" is written into this file amd the already created autodoc file
 *		is appended to this file.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure, used in conjunction with
 *					the index attached to the 'Order' field of this structure to
 *					order the functions described in the "Autodoc" by their name.
 *		fh - a BPTR to the FileHandle with the already extractedd Autodoc
 *					informations, that should be preceded by the "TABLE OF CONTENTS"
 *		title - a pointer to a NUL-terminated C-string with the modules name,
 *					i.e. if the Autodocs discribe the database.library's functions
 *					this will usually the string "database.library"
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG WriteContentsTable (struct DataServer *server, BPTR fh, STRPTR title)
{
	LONG result = RETURN_OK;

	/* This code is a little bit dirty, it accesses the structures of the index
	 * to get the functionnames stored as key-values in the index.
	 * Usually I would have to use a DataServer to store these strings and use
	 * the index for ordering but the data would be identically, so I save a lot
	 * of memory by going this way.
	 * I have some background information that makes this easier for me than for
	 * other users, but by carefully reading the manual and having a look at the
	 * include files and performing a few small tests, you should be able to
	 * follow this code and develop simular solutions, if required.
	 */
	if (Write (fh, "TABLE OF CONTENTS\n\n", 19) == 19)
	{
		ULONG offset;
		struct IDXHeader *index = (struct IDXHeader *)server->Order;

		if (offset = IDX_SkipTop(index))
		{
			struct IDXKeyEntry *keyEntry;

			while (offset && (result == RETURN_OK))
			{
				UBYTE *c;
				UBYTE *p;
				LONG slen = 2;

				/* Get access to the keyvalue of the current key (representing
				 * the name of the function)...
				 */
				keyEntry = (struct IDXKeyEntry *)
						(((UBYTE *)index->CurrentPage->PageData) +
								index->CurrentPage->KeyPtr[index->CurrentKeyPos - 1]);

				/* Copy the title into the write-buffer...
				 */
				c = LineBuffer;
				p = title;
				while (*p)
				{
					slen += 1;
					*c++ = *p++;
				}
				/* ...followed by the function name...
				 */
				*c++ = '/';
				p = keyEntry->KeyValue;
				while (*p >= 32)
				{
					slen += 1;
					*c++ = *p++;
				}
				*c = '\n';

				if (Write (fh, LineBuffer, slen) != slen)
				{
					PrintError(IoErr(), errorText[4]);
					result = RETURN_FAIL;
				}
				offset = IDX_SkipNext(index, 1);
			}
			if (result == RETURN_OK)
			{
				/* Terminate the "TABLE OF CONTENTS"...
				 */
				if (Write (fh, "\n\f", 2) != 2)
				{
					result = RETURN_FAIL;
					PrintError(IoErr(), errorText[4]);
				}
			}
		}
		else
		{
			SetIOErr(ERROR_OBJECT_WRONG_TYPE);
			PrintError (IoErr(), errorText[20]);
			result = RETURN_WARN;
		}
	}
	else
	{
		PrintError (IoErr(), errorText[4]);
		result = RETURN_FAIL;
	}
	return result;
}

/* NAME
 *		WriteLine - write a single line of an Autodoc
 *
 * SYNOPSIS
 *		LONG WriteLine (BPTR, STRPTR)
 *		result = WriteLine (fh, line)
 *
 * FUNCTION
 *		This function write a single line of an Autodoc. Every TAB is replaced
 *		by the defined number of spaces and every "\*" and "*\" is replaced by
 *		the according comment-mark.
 *		If the line is preceded by any number of spaces or tabulator signs,
 *		followed by any number of asterisks, these characters are removed from
 *		the written line, i.e. the written line starts behind the last asterisk.
 *
 * INPUTS
 *		fh - a BPTR to the FileHandle of the file to write to
 *		line - a pointer to the NUL-terminated C-string of the line to be written
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG WriteLine (BPTR fh, STRPTR line)
{
	LONG result = RETURN_OK;
	ULONG virtpos = 0;
	ULONG slen;
	UBYTE *c;
	UBYTE pred = 0;

	/* Skip leading spaces...
	 */
	while ((*line == ' ') || (*line == '\t') || (*line == '/'))
	{
		virtpos += 1;
		if (*line == '\t') while (virtpos % TabWidth) virtpos += 1;
		line += 1;
	}
	/* Skip the asterisks...
	 */
	while (*line == '*')
	{
		virtpos += 1;
		line += 1;
	}

	/* Copy the remaining line into the write buffer...
	 */
	do
	{
		c = LineBuffer;
		slen = 0;
		while ((slen < Width) && *line)
		{
			slen += 1;
			virtpos += 1;
			if (*line == '\t')
			{
				/* Replace TAB with spaces...
				 */
				*c++ = ' ';
				while ((virtpos % TabWidth) && (slen < Width))
				{
					*c++ = ' ';
					slen += 1;
					virtpos += 1;
				}
				pred = 0;
			}
			else
			{
				/* Replace '\*' and '*\' if required, else copy "as is"...
				 */
				if ((pred == '\\') && (*line == '*'))
				{
					/* opening comment...
					 */
					*(c-1) = '/';
					*c++ = '*';
				}
				else if ((pred == '*') && (*line == '\\'))
				{
					/* closing comment...
					 */
					*c++ = '/';
				}
				else *c++ = *line;

				pred = *line;
			}
			line += 1;
		}
		slen += 1;
		*c = '\n';

		/* Write the line...
		 */
		if (Write (fh, LineBuffer, slen) == slen)
		{
			virtpos = 0;
			bytesWritten += slen;
		}
		else
		{
			PrintError (IoErr(), errorText[6]);
			result = RETURN_FAIL;
		}
	}
	while (*line && (result == RETURN_OK));

	return result;
}

/* NAME
 *		WriteHeading - write the heading of a single Autodoc
 *
 * SYNOPSIS
 *		LONG WriteHeading (struct DataServer *, BPTR, BPTR, STRPTR, STRPTR)
 *		result = WriteHeading (server, sFh, dFh, line, title)
 *
 * FUNCTION
 *		This function writes the first four lines of an Autodoc.
 *		The first line contains the modulename followed by the functionname,
 *		the second line remains empty, the third line contains the string
 *		"NAME" and the fourth line the name of the funcion followed by the
 *		short description.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the dummy DataServer
 *					used to add the functionnames to the index with the purpose to
 *					sort the functions by name for the "TABLE OF CONTENTS".
 *		sFh - a BPTR to the FileHandle of the source file to read from
 *		dFh - a BPTR to the FileHandle of the destination file to write to
 *		line - a pointer to the NUL-terminated C-string containing the line with
 *					the "NAME" keyword.
 *		title - a pointer to the NUL-terminated C-string containing the string
 *					used as modulename.
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG WriteHeading (struct DataServer *server, BPTR sFh, BPTR dFh, STRPTR line, STRPTR title)
{
	LONG result = RETURN_OK;
	ULONG offset = 0;
	ULONG virtpos = 0;

	/* Skip leading spaces and tabulators...
	 */
	while ((*line == ' ') || (*line == '\t'))
	{
		virtpos += 1;
		if (*line == '\t') while (virtpos % TabWidth) virtpos += 1;
		line += 1;
	}

	/* Skip the asterisks and comment marks...
	 */
	while ((*line == '*') || (*line == '/'))
	{
		virtpos += 1;
		line += 1;
	}

	/* Count the spaces between asterisk and "NAME"...
	 */
	while ((*line == ' ') || (*line == '\t'))
	{
		offset += 1;
		virtpos += 1;
		if (*line == '\t')
		{
			while (virtpos % TabWidth)
			{
				offset += 1;
				virtpos += 1;
			}
		}
		line += 1;
	}
	if ((offset + 5) > Width) offset = Width - 5;

	/* Skip to next line and get the function name...
	 */
	if (line = NextLine (sFh))
	{
		UBYTE *c;
		UBYTE *p = title;
		ULONG slen = 0;

		/* Copy the title (modules name)...
		 */
		c = LineBuffer;
		while (*p && (slen < Width))
		{
			*c++ = *p++;
			slen += 1;
		}
		if (slen < Width)
		{
			*c++ = '/';
			slen += 1;
		}
		if (slen < Width)
		{
			UBYTE *name = line;
			LONG spaces;

			/* Skip leading spaces...
			 */
			while ((*name == ' ') || (*name == '\t')) name += 1;

			/* Skip the asterisks...
			 */
			while (*name == '*') name += 1;

			/* Skip spaces between asterisk and functionname...
			 */
			while ((*name == ' ') || (*name == '\t')) name += 1;

			/* The following word has to be the function name ->.
			 * Copy the functions name...
			 */
			p = c;
			while ((slen < Width) && *name &&
					(*name != '\t') && (*name != ' '))
			{
				*c++ = *name++;
				slen += 1;
			}

			/* Store the name in the DataServer...
			 */
			*c = '\0';
			DS_DoUpdate (server, DS_GOTOROW, (APTR)bytesWritten);
			DS_DoUpdate (server, DS_SETCOLUMNDATA, p);

			/* Create and insert the according key-entry...
			 * (ignoring any errors, this would be ERROR_NO_FRE_STORE and
			 * will occure again later)...
			 */
			IDX_InsertKey ((struct IDXHeader *)server->Order, server);

			if (slen < (Width >> 1))
			{
				/* Insert some spaces...
				 */
				spaces = Width - (slen << 1);
				while (spaces--) *c++ = ' ';

				/* Write the title and the functionname once more...
				 */
				p = LineBuffer;
				while (slen--) *c++ = *p++;
				slen = Width;
			}
			/* Terminate by a linefeed and write to the file...
			 */
			*c = '\n';
			slen += 1;
			if (Write (dFh, LineBuffer, slen) == slen)
			{
				/* Now write the "NAME" line...
				 */
				bytesWritten += slen;
				slen = offset + 6;
				c = LineBuffer;

				*c++ = '\n';
				while (offset--) *c++ = ' ';
				strncpy (c, "NAME\n", 5);

				if (Write (dFh, LineBuffer, slen) == slen)
				{
					/* Now write the current line...
					 */
					bytesWritten += slen;
					result = WriteLine (dFh, line);
				}
				else
				{
					result = RETURN_FAIL;
					PrintError (IoErr(), errorText[6]);
				}
			}
			else
			{
				result = RETURN_FAIL;
				PrintError (IoErr(), errorText[6]);
			}
		}
	}
	else
	{
		if (IoErr())
		{
			result = RETURN_FAIL;
			PrintError (IoErr(), errorText[7]);
		}
	}
	return result;
}

/* --- Parsing the source ------------------------------------------------ */

/* NAME
 *		Token - try to determine the contents/purpose of a line
 *
 * SYNOPSIS
 *		ULONG Token (UBYTE *)
 *		token = Token (tokenStart)
 * 
 * FUNCTION
 *		This function parses a single line of the source file to determine the
 *		contents, i.e. to detect the begin and the end of Autodocs in a source
 *		file.
 *
 * INPUT
 *		lineStart - a pointer to a NUL-terminated C-string containing the whole
 *						line to be parsed
 *
 * RESULT
 *		The token describing the contents of the line is returned.
 *		This would be zero, if the line doesn't contains any specific contents.
 */
ULONG Token (UBYTE *lineStart)
{
	ULONG token = 0;
	UBYTE *pToken;
	UBYTE pred = 0;

	while ((*lineStart == ' ') || (*lineStart == '\t')) lineStart += 1;
	pToken = lineStart;
	if (*pToken)
	{
		if (*pToken == '/')
		{
			/* starting commend ?
			 */
			if (*++pToken == '*')
			{
				/* Comment, may be the start of an Autodoc...
				 */
				token = T_STARTCOMMENT;
			}
		}
	}
	if (*pToken == '*')
	{
		ULONG i = 1;

		while (*++pToken == '*') i += 1;

		if ((i == 4) && (*pToken == 'i'))
		{
			/* maybe internal flag...
			 */
			if ((*++pToken != '*') || (*++pToken != ' '))
			{
				if (token != T_STARTCOMMENT) token = T_ENDDOC;
			}
		}
		else if ((i == 6) && (*pToken == ' '))
		{
			token = T_STARTDOC;
		}
		else if ((*pToken == '/') && (!token || (i > 1)))
		{
			token = T_ENDCOMMENT;
		}
		else if ((*pToken == ' ') || (*pToken == '\t'))
		{
			/* "NAME" ?
			 */
			while ((*pToken == ' ') || (*pToken == '\t')) pToken++;
			if (strncmp (pToken, "NAME", 4) == 0)
			{
				pToken += 4;
				while ((*pToken == ' ') || (*pToken == '\t')) pToken++;
				if (*pToken == '\0') token = T_DOC;
			}
		}
	}

	/* Let's have a look if this line terminates a comment...
	 */
	while (*pToken && (token != T_ENDCOMMENT))
	{
		if ((pred == '*') && (*pToken == '/'))
		{
			/* Yeah found the end of a comment...
			 */
			token = T_ENDCOMMENT;
		}
		else if ((pred == '/') && (*pToken == '*'))
		{
			/* Found the start of a comment...
			 */
			if (!token) token = T_STARTCOMMENT;
		}
		pred = *pToken;
		pToken += 1;
	}

	if ((token == T_STARTCOMMENT) || (token == T_ENDCOMMENT))
	{
		/* Lets look if another comment starts (and is terminated again)...
		 */
		pred = 0;

		while (*pToken)
		{
			if ((pred == '*') && (*pToken == '/'))
			{
				/* Found the end of a comment...
				 */
				token = T_ENDCOMMENT;
			}
			else if ((pred == '/') && (*pToken == '*'))
			{
				/* Found the start of a comment...
				 */
				token = T_STARTCOMMENT;
			}
			pred = *pToken;
			pToken += 1;
		}
	}
	return token;
}

/* NAME
 *		ProcessFile - process a single source file
 *
 * SYNOPSIS
 *		LONG ProcessFile (struct DataServer *, BPTR, BPTR, STRPTR)
 *		result = ProcessFile (server, sFh, dFh, title)
 *
 * FUNCTION
 *		This function examines a single source file and extracts every Autodoc
 *		function description found in there.
 *		An Autodoc is detected by the following rules:
 *
 *			- It has to be inside a comment
 *			- It may be started width "\******" but must not. If it starts with
 *				"\****i*" it is marked as internal and skipped.
 *			- It has to contain the keyword "NAME" at the first non-empty pos.
 *			- If it starts with "\******" it has to be terminated by a line
 *				starting with "******", else it is terminated by the closing
 *				comment.
 *
 *		I write every possible Autodoc found to the destination and remove it
 *		again, if I detect later that it isn't an Autodoc.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the dummy DataServer
 *					used to add the functionnames to the index with the purpose to
 *					sort the functions by name for the "TABLE OF CONTENTS".
 *		sFh - a BPTR to the FileHandle of the source file to read from
 *		dFh - a BPTR to the FileHandle of the destination file to write to
 *		title - a pointer to the NUL-terminated C-string containing the string
 *					used as modulename.
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG ProcessFile (struct DataServer *server, BPTR sFh, BPTR dFh, STRPTR title)
{
	LONG result = RETURN_OK;
	STRPTR line;
	BOOL comment = FALSE;
	BOOL foundAD = FALSE;
	BOOL regularAD = FALSE;
//UBYTE foo[10] = {0};

	ResetReadBuffer ();

	/* Process every line in the file...
	 */
	while (result == RETURN_OK)
	{
		/* Get next line...
		 */
/*if (foo[0] != 'y')
{
	Printf ("Read next line -> ");
	Flush (Output());
}*/
		if (line = NextLine (sFh))
		{
			ULONG token;

/*if (foo[0] != 'y')
{
	PutStr (line);
	Flush (Output());
	Read (Input(), foo, 10);
}*/
			token = Token (line);

//if (foo[0] != 'y') Printf ("Token = %ld\n", token);
			if (comment)
			{
				if (foundAD)
				{
					/* Check if the end of the Autodoc is found...
					 */
					if (regularAD)
					{
						/* This is a "regular" Autodoc, must be terminated by at
						 * least three asterisks at the start of the line...
						 */
						if ((token == T_ENDDOC) || (token == T_ENDCOMMENT))
							foundAD = FALSE;

						if (token == T_ENDCOMMENT)
						{
							comment = FALSE;
							regularAD = FALSE;
						}
					}
					else
					{
						/* Either my private style, Autodoc is terminated as a "normal"
						 * comment or no Autodoc at all, might be a normal comment...
						 */
						if (token == T_ENDCOMMENT)
						{
							foundAD = FALSE;
							comment = FALSE;
						}
					}
					if (foundAD)
					{
						/* Copy the line to the destination...
						 */
						result = WriteLine (dFh, line);
					}
					else
					{
						/* Terminate the currently written Autodoc...
						 */
						if (Write (dFh, "\n\f", 2) == 2)
						{
							bytesWritten += 2;
						}
						else
						{
							result = RETURN_FAIL;
							PrintError (IoErr(), errorText[6]);
						}
					}
				}
				else
				{
					/* Check if this starts a "regular" Autodoc or my private style
					 * Autodoc or the commend is terminated...
					 */
					if (token == T_STARTDOC)
					{
						regularAD = TRUE;
					}
					if (token == T_DOC)
					{
						foundAD = TRUE;
						result = WriteHeading (server, sFh, dFh, line, title);
					}
					if (token == T_ENDCOMMENT)
						comment = FALSE;
				}
			}
			else
			{
				/* Check if the begin of an Autodoc or commend is found...
				 */
				if (token == T_STARTDOC)
				{
					regularAD = TRUE;
				}
				else if (token == T_STARTCOMMENT)
				{
					comment = TRUE;
				}
				else if (token == T_DOC)
				{
					comment = TRUE;
					foundAD = TRUE;
					result = WriteHeading (server, sFh, dFh, line, title);
				}
			}
		}
		else
		{
			if (IoErr())
			{
				result = RETURN_FAIL;
				PrintError (IoErr(), errorText[7]);
			}
			else
			{
				if (foundAD)
				{
					/* Terminate the currently written Autodoc...
					 */
					if (Write (dFh, "\n\f", 2) == 2)
					{
						bytesWritten += 2;
					}
					else
					{
						result = RETURN_FAIL;
						PrintError (IoErr(), errorText[6]);
					}
				}
				break;	/* EOF */
			}
		}
	}
	return result;
}

/* NAME
 *		ProcessAllFiles - process a whole directory
 *
 * SYNOPSIS
 *		LONG ProcessAllFiles (struct DataServer *, BPTR, BPTR, STRPTR,
 *														struct FileInfoBlock *, BOOL)
 *		result = ProcessAllFiles (server, fl, fh, title, fib, all)
 *
 * FUNCTION
 *		This function processes all C-source files found in the specifed
 *		directory and extracts every Autodoc information found in there.
 *		If specified, it recurses into the subdirectories.
 *
 * INPUTS
 *		server - a pointer to the DataServer structure of the dummy DataServer
 *					used to add the functionnames to the index with the purpose to
 *					sort the functions by name for the "TABLE OF CONTENTS".
 *		fl - a BPTR to the FileLock of the directory to be processed.
 *		fh - a BPTR to the FileHandle of the destination file to write to
 *		title - a pointer to the NUL-terminated C-string containing the string
 *					used as modulename.
 *		fib - a pointer to the FileInfoBlock structure used to Examine() the
 *					directory previously.
 *		all - a boolean value, TRUE indicates that all subdirectories of the
 *					processed directory should also be scanned recursively
 *
 * RESULT
 *		If the function succeeds, RETURN_OK is returned.
 *		If the function fails, RETURN_WARN is returned is a uncritical error
 *		has occured or RETURN_FAIL if a critical error has occured. See IoErr()
 *		for a descriptive AmigaDos errorcode.
 */
LONG ProcessAllFiles(struct DataServer *server, BPTR fl, BPTR fh, STRPTR title,
															struct FileInfoBlock *fib, BOOL all)
{
	LONG result = RETURN_OK;
	BPTR curDir;
	LONG dosError = 0L;

	Printf ("Scanning directory \"%s\"...\n", fib->fib_FileName);
	curDir = CurrentDir (fl);

	while ((result == RETURN_OK) && !dosError)
	{
		if (ExNext (fl, fib) == DOSTRUE)
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
								result = ProcessAllFiles (server, fLock, fh,
																	title, fInfo, all);
								dosError = IoErr();
							}
							else
							{
								dosError = IoErr();
								PrintError (dosError, errorText[8]);
							}
							FreeDOSObject (DOS_FIB, fInfo);
						}
						else
						{
							dosError = ERROR_NO_FREE_STORE;
							PrintError (dosError, errorText[9]);
						}
						UnLock (fLock);
					}
					else
					{
						dosError = IoErr();
						PrintError (dosError, errorText[10]);
					}
				}
			}
			else
			{
				/* This should be a file ->
				 * Determine if it is a C-source file...
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
							if (Upper(*p) == 'C') lastChar = Upper(*p);
							else lastChar = 0;
						}
						else lastChar = 0;
					}
				}
				if (lastChar == 'C')
				{
					/* This should be a C-source file...
					 */
					BPTR sFh;

					if ((sFh = Open (fib->fib_FileName, MODE_OLDFILE)) != ZERO)
					{
						Printf ("   Scanning file \"%s\"...\n", fib->fib_FileName);
						result = ProcessFile (server, sFh, fh, title);
						dosError = IoErr();
						Close (sFh);
					}
					else
					{
						dosError = IoErr();
						PrintError (dosError, errorText[11]);
						result = RETURN_FAIL;
					}
				}
			}
		}
		else
		{
			if ((dosError = IoErr()) != ERROR_NO_MORE_ENTRIES)
			{
				PrintError (dosError, errorText[12]);
				result = RETURN_FAIL;
			}
		}
	}
	(void)CurrentDir(curDir);

	if (dosError != ERROR_NO_MORE_ENTRIES) SetIOErr(dosError);

	return result;
}

/* NAME
 *		ExtractAutodoc - prepare to extract the autodoc information
 *
 * SYNOPSIS
 *		LONG ExtractAutodoc (STRPTR, STRPTR, STRPTR, BOOL)
 *		result = ExtractAutodoc (from, to, title, all)
 *
 * FUNCTION
 *		This function does every preparation required for extracting the Autodocs
 *		from the source file(s).
 *		It examines the source and determines if a whole directory or a single
 *		file should be processed, it opens the temporary and the destination
 *		file, it allocates all required buffers.
 *
 * INPUTS
 *		from - a pointer to a NUL-terminated C-string specifying the source file
 *				or directory. This has to point to an existing C-source file or a
 *				directory containing C-source files.
 *		to - a pointer to a NUL-terminated C-string specifying the destination
 *				file to be created. If this is NULL, the destination file will be
 *				named as the directory or file specified by 'From' followed by the
 *				extension ".doc" and be located in the same directory as 'From'.
 *				If 'From' specifies the root-directory of a device, this argument
 *				must be not-NULL.
 *		title - a pointer to a NUL-terminated C-string specifying the modulename
 *				that should be used in the Autodoc file to be created.
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
LONG ExtractAutodoc (STRPTR from, STRPTR to, STRPTR title, BOOL all)
{
	LONG result = RETURN_FAIL;
	BPTR fl;

	/* Lock the source file or directory...
	 */
	if (fl = Lock (from, SHARED_LOCK))
	{
		struct FileInfoBlock *fib;
		LONG dosError = 0L;

		/* Determine weather the source is a file or a directory...
		 */
		if (fib = (struct FileInfoBlock *)AllocDOSObject (DOS_FIB, NULL))
		{
			if (Examine (fl, fib) == DOSTRUE)
			{
				UBYTE *fileName = NULL;
				ULONG slen;
				BPTR dFh = ZERO;
				BPTR finalFh = ZERO;

				if (!to)
				{
					BPTR parent;

					/* Destination not specified, create a destination from the
					 * source's filename.
					 */

					if (parent = ParentDir (fl))
					{
						slen = strlen (fib->fib_FileName);
						if (slen > 103) slen = 103;	/* supress buffer overrun */

						if (fib->fib_DirEntryType < 0)
						{
							/* This is a file, has to be a "#?.c" file...
							 */
							ULONG i = slen;

							/* Search the begin of the extension...
							 */
							fileName = fib->fib_FileName + slen;
							while (i && (*--fileName != '.')) i--;
							if (i) slen = i - 1;
						}

						if (fileName = (UBYTE *)AllocMem (slen + 8, MEMF_PUBLIC))
						{
							UBYTE *p = fileName;
							UBYTE *c = fib->fib_FileName;
							BPTR curDir;
							ULONG i;

							/* Copy the filename of the source without extension...
							 */
							*p++ = 'T';
							*p++ = ':';
							*p++ = '~';
							to = p;
							for (i = 0; i < slen; i++) *p++ = *c++;

							/* Add the extension ".doc" to the filename...
							 */
							c = ".doc";
							while (*c) *p++ = *c++;
							*p = '\0';
							slen += 8;

							/* Open the files...
							 */
							curDir = CurrentDir (parent);
							if ((dFh = Open (fileName, MODE_NEWFILE)) == ZERO)
							{
								dosError = IoErr();
								PrintError (dosError, errorText[13]);
							}
							else
							{
								if ((finalFh = Open (to, MODE_NEWFILE)) == ZERO)
								{
									dosError = IoErr();
									PrintError (dosError, errorText[14]);
									Close (dFh);
								}
							}
							(void)CurrentDir (curDir);
						}
						else
						{
							dosError = ERROR_NO_FREE_STORE;
							PrintError(dosError, errorText[15]);
						}
						/* Don't need the directory lock any more...
						 */
						UnLock (parent);
					}
					else
					{
						if ((dosError = IoErr()) == 0)
							dosError = ERROR_REQUIRED_ARG_MISSING;
						PrintError (dosError, errorText[16]);
					}
				}
				else
				{
					UBYTE *p = to;
					UBYTE *filePart = to;

					slen = 0;
					while (*p)
					{
						slen += 1;
						if ((*p == '/') || (*p == ':'))
						{
							filePart = p + 1;
							slen = 0;
						}
						p += 1;
					}
					slen += 4;
					if (fileName = (UBYTE *)AllocMem (slen, MEMF_PUBLIC))
					{
						UBYTE *c = fileName;
 
						/* Copy the filename of the destination file with a leading
						 * tilde to be used as temporary file in the directory "T:".
						 */
						p = filePart;

						*c++ = 'T';
						*c++ = ':';
						*c++ = '~';
						while (*p) *c++ = *p++;
						*c = '\0';

						if ((dFh = Open (fileName, MODE_NEWFILE)) == ZERO)
						{
							dosError = IoErr();
							PrintError (dosError, errorText[13]);
						}
						else
						{
							if ((finalFh = Open (to, MODE_NEWFILE)) == ZERO)
							{
								dosError = IoErr();
								PrintError (dosError, errorText[14]);
								Close (dFh);
							}
						}
					}
					else
					{
						dosError = ERROR_NO_FREE_STORE;
						PrintError (dosError, errorText[15]);
					}
				}
				if (finalFh)
				{
					struct DataServer *server;

					if (server = CreateServer())
					{
						idxTags[2].ti_Data = (ULONG)server;

						if (server->Order = (APTR)IDX_InitA (NULL, idxTags))
						{
							result = RETURN_WARN;

							if (CreateReadBuffer())
							{
								if (fib->fib_DirEntryType >= 0)
								{
									/* Source is a directory.
									 * -> Process all files located in there...
									 */
									result = ProcessAllFiles (server, fl, dFh,
																		title, fib, all);
									dosError = IoErr();
								}
								else
								{
									BPTR sFh;

									if ((sFh = Open (from, MODE_OLDFILE)) != ZERO)
									{
										result = ProcessFile (server, sFh, dFh, title);
										dosError = IoErr();
										Close (sFh);
									}
									else
									{
										dosError = IoErr();
										PrintError (dosError, errorText[11]);
									}
								}
								DestroyReadBuffer ();
							}
							else
							{
								dosError = IoErr();
								PrintError (dosError, errorText[3]);
							}
							if (result == RETURN_OK)
							{
								/* Write the "TABLE OF CONTENTS"...
								 */
								result = WriteContentsTable (server, finalFh, title);
								dosError = IoErr();

								if (result == RETURN_OK)
								{
									/* Append the written Autodocs...
									 */
									result = AppendTempFile (server, finalFh, dFh);
									dosError = IoErr();
								}
							}
							IDX_Dispose ((struct IDXHeader *)server->Order);
						}
						DS_DoUpdate (server, DS_DISPOSE, NULL);
					}
					Close (dFh);
					Close (finalFh);

					/* Delete the temporary file...
					 */
					Delete (fileName);
				}
				if (result == RETURN_OK)
				{
					Printf ("\nSuccessfully written the Autodoc file \"%s\".\n", to);
				}
				if (fileName)
				{
					/* Don't need the filename any more...
					 */
					FreeMem (fileName, slen);
				}
			}
			else
			{
				dosError = IoErr();
				PrintError (dosError, errorText[17]);
			}
			FreeDOSObject (DOS_FIB, fib);
		}
		else
		{
			dosError = ERROR_NO_FREE_STORE;
			PrintError (dosError, errorText[9]);
		}
		UnLock (fl);

		SetIOErr (dosError);
	}
	else PrintError (IoErr(), errorText[5]);

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

	if (OpenLibs())
	{
		if (length >= 0)
		{
			/* This tool has to be run from CLI.
			 */
			LONG vec[6] = {0};
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
					if (vec[3]) Width = *((ULONG *)vec[3]);
					if (vec[4]) TabWidth = *((ULONG *)vec[4]);

					if ((Width >= 40) && (Width <= 256) &&
						TabWidth && (TabWidth < 16))
					{
						if (strlen ((STRPTR)vec[2]) < (Width >> 1))
						{
							/* Ok, arguments are parsed, start processing...
							 */
							if (LineBuffer = (UBYTE *)AllocMem(Width + 1,MEMF_PUBLIC))
							{
								result = ExtractAutodoc ((STRPTR)vec[0],(STRPTR)vec[1],
													          (STRPTR)vec[2],(BOOL)vec[5]);
								dosError = IoErr();
								FreeMem (LineBuffer, Width + 1);
							}
							else
							{
								dosError = ERROR_NO_FREE_STORE;
								PrintError (dosError, errorText[3]);
							}
						}
						else
						{
							dosError = ERROR_LINE_TOO_LONG;
							PrintError (dosError, errorText[21]);
						}
					}
					else
					{
						dosError = ERROR_BAD_NUMBER;
						PrintError (dosError, errorText[21]);
					}
					FreeArguments (rda);
				}
				else
				{
					dosError = IoErr();
					PrintError (dosError, errorText[18]);
				}
				FreeDOSObject (DOS_RDARGS, rda);
				SetIOErr (dosError);
			}
			else PrintError (IoErr(), errorText[19]);
		}
		else TextBox (NULL, appname, errorText[22], MSG_INFO,0L);
	}
	else
	{
		if (!JoinOSBase)
		{
			/* Just produce an error-message, if the program is started from CLI...
			 */
			if (length >= 0) PutStr (errorText[23]);
		}
		else if (!DatabaseBase)
		{
			/* joinOS.library is opened, so TextBox() is available...
			 */
			TextBox (NULL, appname, errorText[24], MSG_INFO, 0L);
		}
	}
	CloseLibs();
	return result;
} 
