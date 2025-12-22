/*-----------------------------------------------------------------*/
/* Filename : egsintui.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egs.def*/
/**/
/* (c) Copyright 1990/93 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. July 1992*/
/* Updated     : 14. July 1992*/
/*             : 26. July 1992  us*/
/*             : 05. Aug  1992  us*/
/*               17. Dec  1992  mvk*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGSIntuiBase EI_LockIntuition 1E 0
#pragma libcall EGSIntuiBase EI_UnlockIntuition 24 0
#pragma libcall EGSIntuiBase EI_OpenScreen 2A 801
#pragma libcall EGSIntuiBase EI_CloseScreen 30 801
#pragma libcall EGSIntuiBase EI_OpenWindow 36 801
#pragma libcall EGSIntuiBase EI_CloseWindow 3C 801
#pragma libcall EGSIntuiBase EI_ActivateWindow 42 801
#pragma libcall EGSIntuiBase EI_DeactivateWindow 48 801
#pragma libcall EGSIntuiBase EI_WindowToFront 4E 801
#pragma libcall EGSIntuiBase EI_WindowToBack 54 801
#pragma libcall EGSIntuiBase EI_MoveWindow 5A 10803
#pragma libcall EGSIntuiBase EI_ScrollWindow 60 10803
#pragma libcall EGSIntuiBase EI_SizeWindow 66 10803
#pragma libcall EGSIntuiBase EI_BeginRefresh 6C 0802
#pragma libcall EGSIntuiBase EI_EndRefresh 72 0802
/*pragma libcall EGSIntuiBase EI_Private0 78 0*/
/*pragma libcall EGSIntuiBase EI_Private1 7E 0*/
#pragma libcall EGSIntuiBase EI_RedrawGadgetList 84 10803
#pragma libcall EGSIntuiBase EI_ActivateGadget 8A 09803
#pragma libcall EGSIntuiBase EI_AddGadget 90 9802
#pragma libcall EGSIntuiBase EI_AddGList 96 09803
#pragma libcall EGSIntuiBase EI_RemoveGadget 9C 9802
#pragma libcall EGSIntuiBase EI_RemoveGList A2 09803
#pragma libcall EGSIntuiBase EI_RefreshGadget A8 9802
#pragma libcall EGSIntuiBase EI_RefreshGList AE 09803
#pragma libcall EGSIntuiBase EI_OnGadget B4 9802
#pragma libcall EGSIntuiBase EI_OnGList BA 09803
#pragma libcall EGSIntuiBase EI_OffGadget C0 9802
#pragma libcall EGSIntuiBase EI_OffGList C6 09803
#pragma libcall EGSIntuiBase EI_PutMenuHome CC 801
#pragma libcall EGSIntuiBase EI_PutMenuOut D2 109804
#pragma libcall EGSIntuiBase EI_SetPointer D8 9802
#pragma libcall EGSIntuiBase EI_ClearPointer DE 801
#pragma libcall EGSIntuiBase EI_DoubleClick E4 321004
#pragma libcall EGSIntuiBase EI_WindowBorder EA 10803
#pragma libcall EGSIntuiBase EI_SetWindowTitles F0 A9803
#pragma libcall EGSIntuiBase EI_SetMenuStrip F6 9802
#pragma libcall EGSIntuiBase EI_ModifyIDCMP FC 0802
#pragma libcall EGSIntuiBase EI_ReportMouse 102 0802
#pragma libcall EGSIntuiBase EI_Interpret 108 10BA9806
#pragma libcall EGSIntuiBase EI_InterpretStacked 10E 10A9805
#pragma libcall EGSIntuiBase EI_Interpret1Param 114 210A9806
#pragma libcall EGSIntuiBase EI_Interpret2Param 11A 3210A9807
#pragma libcall EGSIntuiBase EI_SysRequest 120 BA9804
#pragma libcall EGSIntuiBase EI_GetPrefFont 126 001
#pragma libcall EGSIntuiBase EI_GetDefaultScreen 12C 0
#pragma libcall EGSIntuiBase EI_RefreshWindow 132 801
#pragma libcall EGSIntuiBase EI_RefreshScreen 138 801
#pragma libcall EGSIntuiBase EI_SleepWindow 13E 801
#pragma libcall EGSIntuiBase EI_WakeWindow 144 801
#pragma libcall EGSIntuiBase EI_ObtainColor 14A 210804
#pragma libcall EGSIntuiBase EI_ReleaseColor 150 0802
#pragma libcall EGSIntuiBase EI_GetWinColor 156 0802
#pragma libcall EGSIntuiBase EI_GetDefaultColor 15C 1002
#pragma libcall EGSIntuiBase EI_CloneColor 162 0802
#pragma libcall EGSIntuiBase EI_FindMenuItem 168 0802
#pragma libcall EGSIntuiBase EI_FindSubMenu 16E 0802
#pragma libcall EGSIntuiBase EI_ToggleMenuItem 174 9802
#pragma libcall EGSIntuiBase EI_OnMenuItem 17A 9802
#pragma libcall EGSIntuiBase EI_OffMenuItem 180 9802
#pragma libcall EGSIntuiBase EI_FreeMenu 186 801
#pragma libcall EGSIntuiBase EI_CreateMenu 18C 0
#pragma libcall EGSIntuiBase EI_AddToMenu 192 9802
#pragma libcall EGSIntuiBase EI_AddToItem 198 9802
#pragma libcall EGSIntuiBase EI_CreateItem 19E 2109805
#pragma libcall EGSIntuiBase EI_CreateLeave 1A4 0
#pragma libcall EGSIntuiBase EI_GetPrefPointer 1AA 001
