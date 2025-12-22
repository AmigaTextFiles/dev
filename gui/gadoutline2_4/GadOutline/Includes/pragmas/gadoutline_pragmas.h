/**/
/* This slot is reserved for future ARexx possibilities...*/
/**/
#pragma libcall GadOutlineBase resv0 1E 0
/**/
/* GadOutline basic functions*/
/**/
#pragma libcall GadOutlineBase AllocGadOutlineA 24 9802
#pragma libcall GadOutlineBase FreeGadOutline 2A 801
#pragma libcall GadOutlineBase DimenGadOutlineA 30 9802
#pragma libcall GadOutlineBase RebuildGadOutlineA 36 9802
#pragma libcall GadOutlineBase ResizeGadOutlineA 3C 9802
#pragma libcall GadOutlineBase UpdateGadOutlineA 42 9802
#pragma libcall GadOutlineBase DestroyGadOutlineA 48 9802
#pragma libcall GadOutlineBase DrawGadOutlineA 4E 9802
#pragma libcall GadOutlineBase HookGadOutlineA 54 9802
#pragma libcall GadOutlineBase UnhookGadOutlineA 5A 9802
/**/
/* GadOutline functions for command hooks*/
/**/
#pragma libcall GadOutlineBase GO_CallCmdHookA 60 9802
#pragma libcall GadOutlineBase GO_ContCmdHookA 66 9802
#pragma libcall GadOutlineBase GO_InterpretTypedSize 6C 10803
#pragma libcall GadOutlineBase GO_ParseTypedSizeListA 72 90803
/**/
/* GadOutline functions for translation hooks*/
/**/
#pragma libcall GadOutlineBase GO_CallTransHookA 78 9802
#pragma libcall GadOutlineBase GO_ContTransHookA 7E 9802
/**/
/* GadOutline resource functions*/
/**/
#pragma libcall GadOutlineBase GO_AllocMem 84 210804
#pragma libcall GadOutlineBase GO_FreeMem 8A 801
#pragma libcall GadOutlineBase GO_OpenLibrary 90 190804
#pragma libcall GadOutlineBase GO_CloseLibrary 96 9802
/**/
/* GadOutline interface to data structures*/
/**/
#pragma libcall GadOutlineBase GO_GetCmdInfo 9C 90803
#pragma libcall GadOutlineBase GO_GetBoxAttr A2 90803
#pragma libcall GadOutlineBase GO_GetObjectAttr A8 90803
#pragma libcall GadOutlineBase GO_GetImageAttr AE 90803
/**/
/* GadOutline error routines*/
/**/
#pragma libcall GadOutlineBase GO_SetErrorA B4 A90804
#pragma libcall GadOutlineBase GO_GetErrorCode BA 801
#pragma libcall GadOutlineBase GO_GetErrorText C0 801
#pragma libcall GadOutlineBase GO_GetErrorObject C6 801
#pragma libcall GadOutlineBase GO_ShowErrorA CC A90804
/**/
/* GadOutline screen/window interface functions*/
/**/
#pragma libcall GadOutlineBase GO_OpenScreenA D2 9802
#pragma libcall GadOutlineBase GO_OpenWindowA D8 9802
#pragma libcall GadOutlineBase GO_CloseScreen DE 801
#pragma libcall GadOutlineBase GO_CloseWindow E4 801
/**/
/* GadOutline attribute functions*/
/**/
#pragma libcall GadOutlineBase GO_SetCmdAttrsA EA 910804
#pragma libcall GadOutlineBase GO_SetCmdGrpAttrsA F0 910804
#pragma libcall GadOutlineBase GO_SetObjAttrsA F6 910804
#pragma libcall GadOutlineBase GO_SetObjGrpAttrsA FC 910804
#pragma libcall GadOutlineBase GO_GetCmdAttrsA 102 910804
#pragma libcall GadOutlineBase GO_GetCmdAttr 108 3210805
#pragma libcall GadOutlineBase GO_GetObjAttrsA 10E 910804
#pragma libcall GadOutlineBase GO_GetObjAttr 114 3210805
#pragma libcall GadOutlineBase GO_ResetCmdAttrsA 11A 910804
#pragma libcall GadOutlineBase GO_ResetCmdGrpAttrsA 120 910804
#pragma libcall GadOutlineBase GO_ResetObjAttrsA 126 910804
#pragma libcall GadOutlineBase GO_ResetObjGrpAttrsA 12C 910804
/**/
/* GadOutline IDCMP message processing functions*/
/**/
#pragma libcall GadOutlineBase GO_GetGOFromIMsg 132 801
#pragma libcall GadOutlineBase GO_GetGOFromGOIMsg 138 801
#pragma libcall GadOutlineBase GO_DupGOIMsg 13E 9802
#pragma libcall GadOutlineBase GO_UndupGOIMsg 144 801
#pragma libcall GadOutlineBase GO_AttachHotKey 14A 10803
#pragma libcall GadOutlineBase GO_ParseGOIMsgA 150 A90804
#pragma libcall GadOutlineBase GO_CmdAtPointA 156 BA9804
/**/
/* GadTools kind-of look-alike message / refresh functions*/
/**/
#pragma libcall GadOutlineBase GO_GetGOIMsg 15C 801
#pragma libcall GadOutlineBase GO_ReplyGOIMsg 162 801
#pragma libcall GadOutlineBase GO_FilterGOIMsg 168 9802
#pragma libcall GadOutlineBase GO_PostFilterGOIMsg 16E 801
#pragma libcall GadOutlineBase GO_BeginRefresh 174 801
#pragma libcall GadOutlineBase GO_EndRefresh 17A 0802


/* Pragmas to define VarArg calls. */

#ifndef _NOTAGCALL
#pragma tagcall GadOutlineBase AllocGadOutline 24 9802
#pragma tagcall GadOutlineBase DimenGadOutline 30 9802
#pragma tagcall GadOutlineBase RebuildGadOutline 36 9802
#pragma tagcall GadOutlineBase ResizeGadOutline 3C 9802
#pragma tagcall GadOutlineBase UpdateGadOutline 42 9802
#pragma tagcall GadOutlineBase DestroyGadOutline 48 9802
#pragma tagcall GadOutlineBase DrawGadOutline 4E 9802
#pragma tagcall GadOutlineBase HookGadOutline 54 9802
#pragma tagcall GadOutlineBase UnhookGadOutline 5A 9802
#pragma tagcall GadOutlineBase GO_CallCmdHook 60 9802
#pragma tagcall GadOutlineBase GO_ContCmdHook 66 9802
#pragma tagcall GadOutlineBase GO_ParseTypedSizeList 72 90803
#pragma tagcall GadOutlineBase GO_CallTransHook 78 9802
#pragma tagcall GadOutlineBase GO_ContTransHook 7E 9802
#pragma tagcall GadOutlineBase GO_SetError B4 A90804
#pragma tagcall GadOutlineBase GO_ShowError CC A90804
#pragma tagcall GadOutlineBase GO_OpenScreen D2 9802
#pragma tagcall GadOutlineBase GO_OpenWindow D8 9802
#pragma tagcall GadOutlineBase GO_SetCmdAttrs EA 910804
#pragma tagcall GadOutlineBase GO_SetCmdGrpAttrs F0 910804
#pragma tagcall GadOutlineBase GO_SetObjAttrs F6 910804
#pragma tagcall GadOutlineBase GO_SetObjGrpAttrs FC 910804
#pragma tagcall GadOutlineBase GO_GetCmdAttrs 102 910804
#pragma tagcall GadOutlineBase GO_GetObjAttrs 10E 910804
#pragma tagcall GadOutlineBase GO_ResetCmdAttrs 11A 910804
#pragma tagcall GadOutlineBase GO_ResetCmdGrpAttrs 120 910804
#pragma tagcall GadOutlineBase GO_ResetObjAttrs 126 910804
#pragma tagcall GadOutlineBase GO_ResetObjGrpAttrs 12C 910804
#pragma tagcall GadOutlineBase GO_ParseGOIMsg 150 A90804
#pragma tagcall GadOutlineBase GO_CmdAtPoint 156 BA9804
#endif
