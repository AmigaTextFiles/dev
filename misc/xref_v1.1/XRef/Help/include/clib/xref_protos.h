@database clib/xref_protos.h
@master clib/xref_protos.h
@node main "clib/xref_protos.h"
@toc xref.library_xreffile@main
#ifndef CLIB_XREF_PROTOS_H
#define @{b}CLIB_XREF_PROTOS_H@{ub}
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

#ifndef @{"EXEC_TYPES_H" link "AG:SysInc/exec/types.h/main" 2}
#include <@{"exec/types.h" link "AG:SysInc/exec/types.h/main"}>
#endif

struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *@{"XR_LoadXRef" link "xref/XR_LoadXRef()"}(STRPTR file,struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *XR_LoadXRefTags(STRPTR file,ULONG Tag1,...);

ULONG XR_ExpungeXRef(struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG @{"XR_ExpungeXRefTags" link "xref/XR_ExpungeXRef()"}(ULONG Tag1,...);

ULONG @{"ParseXRef" link "xref/ParseXRef()"}(STRPTR string,struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG @{"ParseXRefTags" link "xref/ParseXRef()"}(STRPTR string,ULONG Tag1,...);

BOOL @{"AddXRefDynamicNode" link "xref/AddXRefDynamicNode()"}(void);
BOOL @{"RemoveXRefDynamicNode" link "xref/RemoveXRefDynamicNode()"}(void);

ULONG @{"LoadXRefPrefs" link "xref/LoadXRefPrefs()"}(STRPTR file);

ULONG @{"LockXRefBase" link "xref/LockXRefBase()"}(ULONG key);
void @{"UnlockXRefBase" link "xref/UnlockXRefBase()"}(ULONG handle);

ULONG @{"GetXRefBaseAttrsA" link "xref/GetXRefBaseAttrsA()"}(struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG @{"GetXRefBaseAttrs" link "xref/GetXRefBaseAttrsA()"}(ULONG Tag1,...);

ULONG @{"SetXRefBaseAttrsA" link "xref/SetXRefBaseAttrsA()"}(struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG @{"SetXRefBaseAttrs" link "xref/SetXRefBaseAttrsA()"}(ULONG Tag1,...);

APTR @{"CreateXRefFileA" link "xref/CreateXRefFileA()"}(STRPTR file,struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
APTR @{"CreateXRefFile" link "xref/CreateXRefFileA()"}(STRPTR file,ULONG Tag1,...);

void @{"CloseXRefFile" link "xref/CloseXRefFile()"}(APTR handle);

ULONG @{"WriteXRefFileEntryA" link "xref/WriteXRefFileEntryA()"}(APTR handle,struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG WriteXRefFileEntry(APTR handle,ULONG Tag1,...);

struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *@{"FindXRefFile" link "xref/FindXRefFile()"}(STRPTR name);

ULONG @{"GetXRefFileAttrsA" link "xref/GetXRefFileAttrsA()"}(struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *handle,struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG @{"GetXRefFileAttrs" link "xref/GetXRefFileAttrsA()"}(struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *handle,ULONG Tag1,...);

ULONG @{"SetXRefFileAttrsA" link "xref/SetXRefFileAttrsA()"}(struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *handle,struct @{"TagItem" link "AG:SysInc/utility/tagitem.h/main" 32} *tagList);
ULONG SetXRefFileAttrs(struct @{"XRefFileNode" link "libraries/xref.h/main" 20} *handle,ULONG Tag1,...);

void @{"GetXRefConfigDir" link "xref/GetXRefConfigDir()"}(STRPTR buffer,ULONG length);

#endif /* !CLIB_XREF_PROTOS_H */


@endnode
