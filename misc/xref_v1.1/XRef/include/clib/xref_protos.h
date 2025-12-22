#ifndef CLIB_XREF_PROTOS_H
#define CLIB_XREF_PROTOS_H
/*
** $PROJECT: xref.library
**
** $VER: xref_protos.h 1.5 (10.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

struct XRefFileNode *XR_LoadXRef(STRPTR file,struct TagItem *tagList);
struct XRefFileNode *XR_LoadXRefTags(STRPTR file,ULONG Tag1,...);

ULONG XR_ExpungeXRef(struct TagItem *tagList);
ULONG XR_ExpungeXRefTags(ULONG Tag1,...);

ULONG ParseXRef(STRPTR string,struct TagItem *tagList);
ULONG ParseXRefTags(STRPTR string,ULONG Tag1,...);

BOOL AddXRefDynamicNode(void);
BOOL RemoveXRefDynamicNode(void);

ULONG LoadXRefPrefs(STRPTR file);

ULONG LockXRefBase(ULONG key);
void UnlockXRefBase(ULONG handle);

ULONG GetXRefBaseAttrsA(struct TagItem *tagList);
ULONG GetXRefBaseAttrs(ULONG Tag1,...);

ULONG SetXRefBaseAttrsA(struct TagItem *tagList);
ULONG SetXRefBaseAttrs(ULONG Tag1,...);

APTR CreateXRefFileA(STRPTR file,struct TagItem *tagList);
APTR CreateXRefFile(STRPTR file,ULONG Tag1,...);

void CloseXRefFile(APTR handle);

ULONG WriteXRefFileEntryA(APTR handle,struct TagItem *tagList);
ULONG WriteXRefFileEntry(APTR handle,ULONG Tag1,...);

struct XRefFileNode *FindXRefFile(STRPTR name);

ULONG GetXRefFileAttrsA(struct XRefFileNode *handle,struct TagItem *tagList);
ULONG GetXRefFileAttrs(struct XRefFileNode *handle,ULONG Tag1,...);

ULONG SetXRefFileAttrsA(struct XRefFileNode *handle,struct TagItem *tagList);
ULONG SetXRefFileAttrs(struct XRefFileNode *handle,ULONG Tag1,...);

void GetXRefConfigDir(STRPTR buffer,ULONG length);

#endif /* !CLIB_XREF_PROTOS_H */

