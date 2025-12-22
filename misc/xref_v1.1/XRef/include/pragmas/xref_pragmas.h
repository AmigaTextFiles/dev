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
#pragma libcall XRefBase XR_LoadXRef 24 9802
#pragma tagcall XRefBase XR_LoadXRefTags 24 9802
#pragma libcall XRefBase XR_ExpungeXRef 2A 801
#pragma tagcall XRefBase XR_ExpungeXRefTags 2A 801
#pragma libcall XRefBase ParseXRef 30 9802
#pragma tagcall XRefBase ParseXRefTags 30 9802
#pragma libcall XRefBase AddXRefDynamicNode 36 0
#pragma libcall XRefBase RemoveXRefDynamicNode 3C 0
#pragma libcall XRefBase LoadXRefPrefs 42 801
/* --- global library base functions ---*/
#pragma libcall XRefBase LockXRefBase 48 001
#pragma libcall XRefBase UnlockXRefBase 4E 001
#pragma libcall XRefBase GetXRefBaseAttrsA 54 801
#pragma tagcall XRefBase GetXRefBaseAttrs 54 801
#pragma libcall XRefBase SetXRefBaseAttrsA 5A 801
#pragma tagcall XRefBase SetXRefBaseAttrs 5A 801
/* --- create xreffile functions ---*/
#pragma libcall XRefBase CreateXRefFileA 60 9802
#pragma tagcall XRefBase CreateXRefFile 60 9802
#pragma libcall XRefBase CloseXRefFile 66 801
#pragma libcall XRefBase WriteXRefFileEntryA 6C 9802
#pragma tagcall XRefBase WriteXRefFileEntry 6C 9802
/* --- xreffile functions ---*/
#pragma libcall XRefBase FindXRefFile 72 801
#pragma libcall XRefBase GetXRefFileAttrsA 78 9802
#pragma tagcall XRefBase GetXRefFileAttrs 78 9802
#pragma libcall XRefBase SetXRefFileAttrsA 7E 9802
#pragma tagcall XRefBase SetXRefFileAttrs 7E 9802
/* --- xrefconfig dir*/
#pragma libcall XRefBase GetXRefConfigDir 84 0802
