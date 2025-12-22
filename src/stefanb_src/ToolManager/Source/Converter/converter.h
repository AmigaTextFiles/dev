/*
 * converter.h  V3.1
 *
 * ToolManager preferences file converter include file
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

/* OS include files */
#include <exec/memory.h>
#include <graphics/text.h>
#include <prefs/prefhdr.h>

/* OS function prototypes */
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/iffparse_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/iffparse_pragmas.h>

/* ANSI C include files */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Debugging */
#ifdef DEBUG
/* Global data */
#define DEBUGFLAGENTRIES 1

/* Macros */
#define MAIN_LOG(x)   _LOG(0,  0, (x))
#define MEMORY_LOG(x) _LOG(0,  1, (x))
#define SCAN_LOG(x)   _LOG(0,  2, (x))
#define EXEC_LOG(x)   _LOG(0,  3, (x))
#define IMAGE_LOG(x)  _LOG(0,  4, (x))
#define SOUND_LOG(x)  _LOG(0,  5, (x))
#define MENU_LOG(x)   _LOG(0,  6, (x))
#define ICON_LOG(x)   _LOG(0,  7, (x))
#define DOCK_LOG(x)   _LOG(0,  8, (x))
#define ACCESS_LOG(x) _LOG(0,  9, (x))
#define MISC_LOG(x)   _LOG(0, 10, (x))
#else
#define MAIN_LOG(x)
#define MEMORY_LOG(x)
#define SCAN_LOG(x)
#define EXEC_LOG(x)
#define IMAGE_LOG(x)
#define SOUND_LOG(x)
#define MENU_LOG(x)
#define ICON_LOG(x)
#define DOCK_LOG(x)
#define ACCESS_LOG(x)
#define MISC_LOG(x)
#endif

/* Globale ToolManager definitions */
#include "/global.h"

/* Global data */
extern struct Library *DOSBase;
extern struct Library *IFFParseBase;
extern struct Library *SysBase;

/* Function prototypes */
BOOL   ScanOldConfig(struct IFFHandle *, struct IFFHandle *);
void   InitExecIDList(void);
void   FreeExecIDList(void);
ULONG  FindExecID(const char *);
BOOL   ConvertExecConfig(void *chunk, struct IFFHandle *, ULONG);
void   InitImageIDList(void);
void   FreeImageIDList(void);
ULONG  FindImageID(const char *);
BOOL   ConvertImageConfig(void *chunk, struct IFFHandle *, ULONG);
void   InitSoundIDList(void);
void   FreeSoundIDList(void);
ULONG  FindSoundID(const char *);
BOOL   ConvertSoundConfig(void *chunk, struct IFFHandle *, ULONG);
BOOL   ConvertMenuConfig(void *chunk, struct IFFHandle *, ULONG);
BOOL   ConvertIconConfig(void *chunk, struct IFFHandle *, ULONG);
BOOL   ConvertDockConfig(void *chunk, struct IFFHandle *, ULONG);
BOOL   ConvertAccessConfig(void *chunk, struct IFFHandle *, ULONG);
char  *ConvertConfigString(char *, struct IFFHandle *, ULONG);
BOOL   AddIDToList(struct MinList *, const char *, ULONG);
ULONG  FindIDInList(struct MinList *, const char *);
void   FreeIDList(struct MinList *);
