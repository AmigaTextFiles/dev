/* ReadLines
 *
 * This module is used by ExtractAutodoc..
 * It reads the contents of any ASCII-file line by line.
 * A line is any number of characters, terminated by a linefeed or the end of
 * the file.
 *
 * If the linefeeds are preceded by a "carriage return" (as usual in the DOS-
 * world), this character is removed silently.
 *
 * The returned lines are terminated by a NUL-byte instead of a linefeed.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _MEMORY_H_
#include <joinOS/exec/memory.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifndef _EXEC_PROTOS_H_
#include <joinOS/protos/ExecProtos.h>
#endif

#ifndef _AMIGA_DOS_PROTOS_H_
#include <joinOS/Protos/AmigaDOSProtos.h>
#endif

#ifndef _JOINOS_PROTOS_H_
#include <joinOS/protos/joinOSProtos.h>
#endif

/* Prototypes of functions located in ReadLines.o
 */
BOOL CreateReadBuffer (void);
void ResetReadBuffer (void);
void DestroyReadBuffer (void);
STRPTR NextLine (BPTR fh);

/***************************************************************************/
/*																									*/
/*										Global data												*/
/*																									*/
/***************************************************************************/

static UBYTE *buffer = NULL;
static ULONG bytesInBuffer = 0;
static UWORD bufPos = 0;

#define TEST_IOBUF_SIZE 1024

/***************************************************************************/
/*																									*/
/*					functions accessing the data of the ASCII-file					*/
/*																									*/
/***************************************************************************/

STRPTR NextLine (BPTR fh)
{
	STRPTR line;

	if (buffer && fh)
	{
		UWORD nextLine = bufPos;

		line = buffer + nextLine;
		do
		{
			if (bytesInBuffer == nextLine)
			{
				/* Need to read next data...
				 */
				ULONG toRead = TEST_IOBUF_SIZE;
				ULONG bRead;
				ULONG remain = nextLine - bufPos;

//Printf ("Need to read next data from file...\n");
				if (remain)
				{
					if (remain < toRead)
					{
						/* Presave the unprocessed contents of the buffer...
						 */
						MoveMem (buffer + bufPos, buffer, remain);
					}
					toRead -= remain;
				}
				nextLine = remain;
				line = buffer;
				bufPos = 0;
				if (toRead)
				{
//Printf ("Have to read %ld bytes...\n", toRead);
					if ((bRead = Read (fh, buffer + nextLine, toRead)) >= 0)
					{
						if (bRead == 0)
						{
							/* Reached EOF...
							 * Terminate the string...
							 */
//Printf ("Reached EOF.\n");
							if (remain)
							{
//Printf ("%ld bytes remained in the buffer...\n");
								*(buffer + remain) = '\n';
								remain += 1;
							}
							else line = NULL;
							bytesInBuffer = remain;
						}
						else
						{
							bytesInBuffer = remain + bRead;
//Printf ("Currently stored %ld bytes in the buffer\n", bytesInBuffer);
						}
					}
					else
					{
						/* I/O-error...
						 */
						bytesInBuffer = 0;
						nextLine = 0;
						*buffer = '\0';
						line = NULL;
					}
				}
				else
				{
					SetIOErr (ERROR_LINE_TOO_LONG);
					bytesInBuffer = 0;
					nextLine = 0;
					*buffer = '\0';
					line = NULL;
				}
			}
			if (bytesInBuffer)
			{
				if (*(buffer + nextLine) != '\n')
				{
					if (*(buffer + nextLine) == '\r')
					{
						if (bytesInBuffer > nextLine + 1)
						{
							if (*(buffer + nextLine + 1) == '\n')
							{
								/* 'CRLF' -> clear 'CR'
								 */
								*(buffer + nextLine) = '\0';
							}
						}
						else
						{
							/* 'CR' but don't know if it is followed by a linefeed ->
							 * replace it with a space instead of a NUL-byte...
							 */
							*(buffer + nextLine) = ' ';
						}
					}
					nextLine += 1;
				}
				else
				{					
					/* Found end of the line...
					 */
					*(buffer + nextLine) = '\0';
					nextLine += 1;
					break;
				}
			}
		}
		while (bytesInBuffer);

		if (bytesInBuffer)
		{
			bufPos = nextLine;
		}
		/* else: Error occured */
	}
	else line = NULL;

	return line;
}

/***************************************************************************/
/*																									*/
/*						functions for initialization/termination						*/
/*																									*/
/***************************************************************************/

BOOL CreateReadBuffer (void)
{
	BOOL success = TRUE;

	if (!buffer)
	{
		if ((buffer = (UBYTE *)AllocMem (TEST_IOBUF_SIZE, MEMF_PUBLIC)) == NULL)
			success = FALSE;
	}
	return success;
}

void ResetReadBuffer (void)
{
	bytesInBuffer = 0;
	bufPos = 0;
}

void DestroyReadBuffer (void)
{
	if (buffer) FreeMem (buffer, TEST_IOBUF_SIZE);
	buffer = NULL;
	bytesInBuffer = 0;
	bufPos = 0;
}
