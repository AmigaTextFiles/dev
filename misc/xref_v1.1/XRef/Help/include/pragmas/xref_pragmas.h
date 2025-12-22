@database pragmas/xref_pragmas.h
@master pragmas/xref_pragmas.h
@node main "pragmas/xref_pragmas.h"
@toc xref.library_xreffile@main
/* "xref.library"*/
/**/
/* by Stefan Ruppert*/
/**/
/* (C) Copyright 1994*/
/**/
/* $VER: xref_lib.fd 1.3 (10.09.94) */
/**/
/* --- functions in V1 or higher ---*/
/*#pragma libcall XRefBase XRefPrivate1 1E 0*/
#pragma libcall XRefBase @{"XR_LoadXRef" link "xref/XR_LoadXRef()"} 24 9802
#pragma tagcall XRefBase XR_LoadXRefTags 24 9802
#pragma libcall XRefBase XR_ExpungeXRef 2A 801
#pragma tagcall XRefBase @{"XR_ExpungeXRefTags" link "xref/XR_ExpungeXRef()"} 2A 801
#pragma libcall XRefBase @{"ParseXRef" link "xref/ParseXRef()"} 30 9802
#pragma tagcall XRefBase @{"ParseXRefTags" link "xref/ParseXRef()"} 30 9802
#pragma libcall XRefBase @{"AddXRefDynamicNode" link "xref/AddXRefDynamicNode()"} 36 0
#pragma libcall XRefBase @{"RemoveXRefDynamicNode" link "xref/RemoveXRefDynamicNode()"} 3C 0
#pragma libcall XRefBase @{"LoadXRefPrefs" link "xref/LoadXRefPrefs()"} 42 801
/* --- global library base functions ---*/
#pragma libcall XRefBase @{"LockXRefBase" link "xref/LockXRefBase()"} 48 001
#pragma libcall XRefBase @{"UnlockXRefBase" link "xref/UnlockXRefBase()"} 4E 001
#pragma libcall XRefBase @{"GetXRefBaseAttrsA" link "xref/GetXRefBaseAttrsA()"} 54 801
#pragma tagcall XRefBase @{"GetXRefBaseAttrs" link "xref/GetXRefBaseAttrsA()"} 54 801
#pragma libcall XRefBase @{"SetXRefBaseAttrsA" link "xref/SetXRefBaseAttrsA()"} 5A 801
#pragma tagcall XRefBase @{"SetXRefBaseAttrs" link "xref/SetXRefBaseAttrsA()"} 5A 801
/* --- create xreffile functions ---*/
#pragma libcall XRefBase @{"CreateXRefFileA" link "xref/CreateXRefFileA()"} 60 9802
#pragma tagcall XRefBase @{"CreateXRefFile" link "xref/CreateXRefFileA()"} 60 9802
#pragma libcall XRefBase @{"CloseXRefFile" link "xref/CloseXRefFile()"} 66 801
#pragma libcall XRefBase @{"WriteXRefFileEntryA" link "xref/WriteXRefFileEntryA()"} 6C 9802
#pragma tagcall XRefBase WriteXRefFileEntry 6C 9802
/* --- xreffile functions ---*/
#pragma libcall XRefBase @{"FindXRefFile" link "xref/FindXRefFile()"} 72 801
#pragma libcall XRefBase @{"GetXRefFileAttrsA" link "xref/GetXRefFileAttrsA()"} 78 9802
#pragma tagcall XRefBase @{"GetXRefFileAttrs" link "xref/GetXRefFileAttrsA()"} 78 9802
#pragma libcall XRefBase @{"SetXRefFileAttrsA" link "xref/SetXRefFileAttrsA()"} 7E 9802
#pragma tagcall XRefBase SetXRefFileAttrs 7E 9802
/* --- xrefconfig dir*/
#pragma libcall XRefBase @{"GetXRefConfigDir" link "xref/GetXRefConfigDir()"} 84 0802

@endnode
