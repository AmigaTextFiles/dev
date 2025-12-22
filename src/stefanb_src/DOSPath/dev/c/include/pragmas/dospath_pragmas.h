#ifndef PRAGMAS_DOSPATH_PRAGMAS_H
#define PRAGMAS_DOSPATH_PRAGMAS_H

/*
 * dospath_pragmas.h  V1.0
 *
 * Inline library calls for dospath.library functions
 *
 * (c) 1996 Stefan Becker
 */

#pragma libcall DOSPathBase FreePathList 24 801
#pragma libcall DOSPathBase CopyPathList 2a 9802
#pragma libcall DOSPathBase BuildPathListTagList 30 9802
#pragma libcall DOSPathBase FindFileInPathList 36 9802
#pragma libcall DOSPathBase RemoveFromPathList 3c 9802
#pragma libcall DOSPathBase GetProcessPathList 42 801
#pragma libcall DOSPathBase SetProcessPathList 48 9802
#pragma libcall DOSPathBase CopyWorkbenchPathList 4e 9802

#ifdef __SASC_60
#pragma libcall DOSPathBase BuildPathListTags 30 9802
#endif

#endif /* PRAGMAS_DOSPATH_PRAGMAS_H */
