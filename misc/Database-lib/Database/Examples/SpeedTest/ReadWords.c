/* ReadWords
 *
 * This module is used by SpeedTest.
 * It reads the contents of any ASCII-file word by word.
 * A word is any number of characters, terminated by any of the following
 * characters: A character with an ASCII-value below or equal 32.
 *
 * Leading whitespaces are skipped. The line and position in the line, where
 * the word starts is remembered and could also be requested.
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

/* Prototypes of functions located in ReadWords.o
 */
BOOL CreateReadBuffer (void);
void DestroyReadBuffer (void);
STRPTR NextWord (BPTR fh, ULONG *lineNo, UWORD *pos);

/***************************************************************************/
/*																									*/
/*										Global data												*/
/*																									*/
/***************************************************************************/

static UBYTE *buffer = NULL;
static ULONG bytesInBuffer = 0;
static UWORD bufPos = 0;
static UWORD lineOffset = 0;
static ULONG line = 0;

#define TEST_IOBUF_SIZE 1024

/***************************************************************************/
/*																									*/
/*					functions accessing the data of the ASCII-file					*/
/*																									*/
/***************************************************************************/

STRPTR NextWord (BPTR fh, ULONG *lineNo, UWORD *pos)
{
	STRPTR word = NULL;

	if (buffer && fh)
	{
		UWORD nextWord = bufPos;
		BOOL skipSpaces = TRUE;

		do
		{
			if (bytesInBuffer == nextWord)
			{
				/* Need to read next data...
				 */
				ULONG toRead = TEST_IOBUF_SIZE;
				ULONG bRead;
				ULONG remain = nextWord - bufPos;

				if (remain)
				{
					if (remain < toRead)
					{
						/* Presave the unprocessed contents of the buffer...
						 */
						MoveMem (buffer + bufPos, buffer, remain);
						if (!skipSpaces) word = buffer;
					}
					toRead -= remain;
				}
				nextWord = remain;
				bufPos = 0;
				if (toRead)
				{
					if ((bRead = Read (fh, buffer + nextWord, toRead)) >= 0)
					{
						if (bRead == 0)
						{
							/* Reached EOF ->
							 * Restart reading at the begin of the file...
							 */
							if (!skipSpaces)
							{
								/* Terminate the string...
								 */
								*(buffer + remain) = '\0';
								remain += 1;
								toRead -= 1;
								nextWord = remain;
							}
							else
							{
								/* Forget the parsed whitespaces...
								 */
								bufPos = nextWord = bytesInBuffer = remain = 0;
								toRead = TEST_IOBUF_SIZE;
							}
//							line = 0;
							lineOffset = 0;

							if (Seek (fh, 0, OFFSET_BEGINNING) != -1)
							{
								if ((bRead = Read(fh, buffer + nextWord, toRead)) <= 0)
								{
									/* Error or empty file...
									 */
									bytesInBuffer = 0;
									nextWord = 0;
									*buffer = '\0';
								}
								else bytesInBuffer = remain + bRead;
							}
							else
							{
								/* Seek error...
								 */
								bytesInBuffer = 0;
								nextWord = 0;
								*buffer = '\0';
							}
						}
						else bytesInBuffer = remain + bRead;
					}
					else
					{
						/* I/O-error...
						 */
						bytesInBuffer = 0;
						nextWord = 0;
						*buffer = '\0';
						word = NULL;
					}
				}
				else
				{
					SetIOErr (ERROR_LINE_TOO_LONG);
					bytesInBuffer = 0;
					nextWord = 0;
					*buffer = '\0';
					word = NULL;
				}
			}
			if (bytesInBuffer)
			{
				if (skipSpaces)
				{
					if (*(buffer + nextWord) <= 32)
					{
						if (*(buffer + nextWord) == '\n')
						{
							line += 1;
							lineOffset = 0;
						}
						else lineOffset += 1;
						nextWord += 1;
					}
					else
					{
						/* Found begin of word...
						 */
						skipSpaces = FALSE;
						word = buffer + nextWord;
						*pos = lineOffset + 1;
						*lineNo = line + 1;
					}
				}
				if (!skipSpaces)
				{
					if (*(buffer + nextWord) > 32)
					{
						nextWord += 1;
						lineOffset += 1;
					}
					else
					{					
						/* Found end of the word...
						 */
						if (*(buffer + nextWord) == '\n')
						{
							line += 1;
							lineOffset = 0;
						}
						else lineOffset += 1;
						*(buffer + nextWord) = '\0';
						nextWord += 1;
						break;
					}
				}
			}
		}
		while (bytesInBuffer);

		if (bytesInBuffer)
		{
			bufPos = nextWord;
		}
		/* else: Error occured */
	}
	return word;
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
		{
			PrintFault (IoErr(), "Failed to allocate I/O-buffer");
			success = FALSE;
		}
	}
	return success;
}

void DestroyReadBuffer (void)
{
	if (buffer) FreeMem (buffer, TEST_IOBUF_SIZE);
	buffer = NULL;
	 bytesInBuffer = 0;
	bufPos = 0;
	lineOffset = 0;
	line = 0;
}
