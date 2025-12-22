#ifndef SIMPLE_DEBUG_H
#define SIMPLE_DEBUG_H
/***************************************************************************
**
** SimpleDebug - A debugging/tracing tool
** print tracing messages when needed
**
** Copyright (C) 2009 by Mikko Koivunalho
**
** This software is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License as published by the Free Software Foundation; either
** version 2.1 of the License, or (at your option) any later version.
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
** Lesser General Public License for more details.
**
** $Id: SimpleDebug.h 37 2009-04-01 19:05:32Z svn.username $
**
***************************************************************************/


#ifdef SIMPLE_DEBUG
/* Activate the macros. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {OFF, ON} SD_STATE; /* For the On/Off switch */

struct SimpleDebugGlobals {
	FILE     *SD_FileHandle;
	int      (*SD_FunctionPointer)(char *);
	int      SD_IndentAmount;
	char     *SD_Name; /* Global name, by default filename. */
	int      SD_Indentation; /* number of indents, number of spaces! */
	SD_STATE SD_OnOff; /* On/Off switch */
};

struct SimpleDebugLocals {
	FILE *SD_FileHandle;
	int (*SD_FunctionPointer)(char *);
	char *SD_Name;
	char *SD_Buffer;
	char *SD_IndentationBuffer;
};

/* Use this outside any routine, including main().
** Put SD_SETUP() in the beginning of the file, e.g.
** #define SIMPLE_DEBUG
** #include <SimpleDebug/SimpleDebug.h>
** SD_SETUP
** Use this macro without curly braces, i.e. characters ().
*/
#define SD_SETUP																															\
	struct SimpleDebugGlobals SD_GLOBAL_PREFS = 																\
			{ stdout, NULL, 1, __FILE__, 0, OFF };

/* Use this in other files than the one containing main().
** Put SD_SETUP_EXTERNAL() in the beginning of the file, e.g.
** #define SIMPLE_DEBUG
** #include <SimpleDebug/SimpleDebug.h>
** SD_SETUP_EXTERNAL
** Use this macro without curly braces, i.e. characters ().
*/
#define SD_SETUP_EXTERNAL																											\
	extern struct SimpleDebugGlobals SD_GLOBAL_PREFS;

/* SD_BEGIN(name of routine, length of buffer to be reserved) */
#define SD_BEGIN(str, len) /* do { Can't use "do", causes wrong scope!!! */		\
	struct SimpleDebugLocals SD_LOCAL_PREFS;																		\
	SD_LOCAL_PREFS.SD_FileHandle = SD_GLOBAL_PREFS.SD_FileHandle;								\
	SD_LOCAL_PREFS.SD_FunctionPointer = SD_GLOBAL_PREFS.SD_FunctionPointer;			\
	SD_LOCAL_PREFS.SD_Name = str;																								\
	SD_LOCAL_PREFS.SD_Buffer = NULL;																						\
	SD_LOCAL_PREFS.SD_Buffer = malloc(SD_GLOBAL_PREFS.SD_Indentation + 					\
			strlen(SD_GLOBAL_PREFS.SD_Name) + 1 + 																	\
			strlen(SD_LOCAL_PREFS.SD_Name) + 8 + 1 + len);/*" - begin\0"==9 chars*/	\
	SD_LOCAL_PREFS.SD_Buffer[0] = '\0';																					\
	SD_GLOBAL_PREFS.SD_Indentation += SD_GLOBAL_PREFS.SD_IndentAmount;					\
	SD_LOCAL_PREFS.SD_IndentationBuffer = NULL;																	\
	SD_LOCAL_PREFS.SD_IndentationBuffer = 																			\
			malloc(SD_GLOBAL_PREFS.SD_Indentation + 1);															\
	memset(SD_LOCAL_PREFS.SD_IndentationBuffer, ' ', 														\
			SD_GLOBAL_PREFS.SD_Indentation);																				\
	SD_LOCAL_PREFS.SD_IndentationBuffer[SD_GLOBAL_PREFS.SD_Indentation] = '\0';	\
	SD_APPEND("%s", SD_LOCAL_PREFS.SD_IndentationBuffer);												\
	SD_APPEND("%s", SD_GLOBAL_PREFS.SD_Name);																		\
	SD_APPEND(":%s - begin\n", SD_LOCAL_PREFS.SD_Name);													\
	SD_PRINTBUFFER();

#define SD_END() do { 																												\
	SD_APPEND("%s", SD_GLOBAL_PREFS.SD_Name);																		\
	SD_APPEND(":%s - end\n", SD_LOCAL_PREFS.SD_Name);														\
	SD_PRINTBUFFER();																														\
	free(SD_LOCAL_PREFS.SD_IndentationBuffer);																	\
	free(SD_LOCAL_PREFS.SD_Buffer);																							\
	SD_GLOBAL_PREFS.SD_Indentation -= SD_GLOBAL_PREFS.SD_IndentAmount;					\
} while(0)

#define SD_PRINT(str) do {																										\
	SD_APPEND("%s", str);																												\
	SD_PRINTBUFFER();																														\
} while (0)

#define SD_PRINTBUFFER() do {																									\
/* Write the buffered string, then reset the buffer. */												\
	if (SD_GLOBAL_PREFS.SD_OnOff == ON) {																				\
		if (SD_LOCAL_PREFS.SD_FunctionPointer != NULL) {													\
			(*SD_LOCAL_PREFS.SD_FunctionPointer)(SD_LOCAL_PREFS.SD_Buffer);					\
		}																																					\
		else {																																		\
			fprintf(SD_LOCAL_PREFS.SD_FileHandle, "%s",															\
					SD_LOCAL_PREFS.SD_Buffer);																					\
		}																																					\
	}																																						\
	sprintf(SD_LOCAL_PREFS.SD_Buffer, "%s", /* reset buffer! */									\
			SD_LOCAL_PREFS.SD_IndentationBuffer);																		\
} while (0)

#define SD_APPEND(fmt, attr) do {																							\
/* fmt; as in sprintf(), attr to be included in the string (with %s/%d/%?) */	\
	sprintf(SD_LOCAL_PREFS.SD_Buffer + 																					\
			strlen(SD_LOCAL_PREFS.SD_Buffer), fmt, attr);														\
} while (0)

#define SD_DO(code) code

#define SD_SET_GLOBALS(fh, ptr, amount, str) do {															\
	/* params: filehandle *FILE, pointer to a routine, 													\
	** number of spaces for one indent, Global name string */										\
	if (fh != NULL) {																														\
		SD_GLOBAL_PREFS.SD_FileHandle = fh;																				\
	}																																						\
	if (ptr != NULL) {																													\
		SD_GLOBAL_PREFS.SD_FunctionPointer = NULL;																\
	}																																						\
	SD_GLOBAL_PREFS.SD_IndentAmount = amount;																		\
	if (str != NULL) {																													\
		SD_GLOBAL_PREFS.SD_Name = str;																						\
	}																																						\
} while (0)

#define SD_SET_LOCALS(fh, ptr, str) do {																			\
	/* params: filehandle *FILE, pointer to a routine, 													\
	** Global name string */																										\
	if (fh != NULL) {																														\
		SD_LOCAL_PREFS.SD_FileHandle = fh;																				\
	}																																						\
	if (ptr != NULL) {																													\
		SD_LOCAL_PREFS.SD_FunctionPointer = ptr;																	\
	}																																						\
	if (str != NULL) {																													\
		SD_LOCAL_PREFS.SD_Name = str;																							\
	}																																						\
} while (0)

#define SD_ON() do { SD_GLOBAL_PREFS.SD_OnOff = ON; } while (0)
#define SD_OFF() do { SD_GLOBAL_PREFS.SD_OnOff = OFF; } while (0)
#else
/* Strip all debugging from program. */
#define SD_SETUP /*Use these macros without curly braces, i.e. characters ().*/
#define SD_SETUP_EXTERNAL
#define SD_BEGIN(str, len)
#define SD_END()
#define SD_PRINT(str)
#define SD_PRINTBUFFER()
#define SD_APPEND(fmt, attr)
#define SD_DO(code)
#define SD_SET_GLOBALS(fh, ptr, amount, str)
#define SD_SET_LOCALS(fh, ptr, str)
#define SD_ON()
#define SD_OFF()
#endif

#endif
