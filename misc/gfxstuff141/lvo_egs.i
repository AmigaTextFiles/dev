       IFND            LVO_EGS_I
LVO_EGS_I       SET     1
*
*  $
*  $ FILE     : lvo_egs.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 21-Mar-95 20:46
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
* Modified Revision 1 by S.P. Häuser
* Because Viona was not capable to do this themselves...
*
*

_LVOE_OpenScreen                EQU     -30
_LVOE_CloseScreen               EQU     -36
_LVOE_MouseOn                   EQU     -42
_LVOE_MouseOff                  EQU     -48
_LVOE_ModifyMouse               EQU     -54
_LVOE_ScreenToFront             EQU     -60
_LVOE_ScreenToBack              EQU     -66
_LVOE_ActivateEGSScreen         EQU     -72
_LVOE_ActivateAmigaScreen       EQU     -78
_LVOE_SetRGB8                   EQU     -84
_LVOE_ModifyEDCMP               EQU     -90
_LVOE_Private0                  EQU     -96
_LVOE_Private1                  EQU     -102
_LVOE_Private2                  EQU     -108
_LVOE_Private3                  EQU     -114
_LVOE_Private4                  EQU     -120
_LVOE_Private5                  EQU     -126
_LVOE_DisposeBitMap             EQU     -132
_LVOE_ClearBitMap               EQU     -138
_LVOE_SetMouseExcept            EQU     -144
_LVOE_ResetMouseExcept          EQU     -150
_LVOE_GetRGB8                   EQU     -156
_LVOE_Private6                  EQU     -162
_LVOE_FlipMap                   EQU     -168
_LVOE_SetRGB8CM                 EQU     -174
_LVOE_GetHardInfo               EQU     -180
_LVOE_GetRGB8CM                 EQU     -186
_LVOE_OldWaitTOF                EQU     -192
_LVOE_AllocBitMap               EQU     -198
_LVOE_CreateEMemPool            EQU     -204
_LVOE_DeleteEMemPool            EQU     -210
_LVOE_AllocEMemPool             EQU     -216
_LVOE_FreeEMemPool              EQU     -222
_LVOE_ObtainPublicClass         EQU     -228
_LVOE_AddPublicClass            EQU     -234
_LVOE_GetSymbol                 EQU     -240
_LVOE_AddMethod                 EQU     -246
_LVOE_CreateSubClass            EQU     -252
_LVOE_Dispatch                  EQU     -258
_LVOE_isSubClass                EQU     -264
_LVOE_SendEGSMsg                EQU     -270
_LVOE_AllocBitMapFrame          EQU     -276
_LVOE_DisposeBitMapFrame        EQU     -282
_LVOE_AllocBitMapClass          EQU     -288
_LVOE_MoveMouse                 EQU     -294
_LVOE_AddPublicVideoNode        EQU     -300
_LVOE_AddVideoLink              EQU     -306
_LVOE_RemVideoLink              EQU     -312
_LVOE_LockEGSVideo              EQU     -318
_LVOE_UnlockEGSVideo            EQU     -324
_LVOE_SetUserFocus              EQU     -330
_LVOE_CrossMouseBorder          EQU     -336
_LVOE_AddScreenMode             EQU     -342
_LVOE_WaitTOF                   EQU     -348
_LVOE_WhichScreen               EQU     -354
_LVOE_WhichMonitor              EQU     -360
_LVOE_CanDisplayOnMonitor       EQU     -366
_LVOE_CreateObject              EQU     -372
_LVOE_DeleteObject              EQU     -378
_LVOE_FindPublicVideoNode       EQU     -384
_LVOE_NewMapType                EQU     -390
_LVOE_Private7                  EQU     -396
_LVOE_MouseOffRect              EQU     -402
_LVOE_ObtainClass               EQU     -408
_LVOE_ReleaseClass              EQU     -414
_LVOE_ObtainObjectClass         EQU     -420
_LVOE_GetSymName                EQU     -426
_LVOE_AddClassMethod            EQU     -432
_LVOE_DispatchClass             EQU     -438
_LVOE_GetClassMethod            EQU     -444
_LVOE_isSubType                 EQU     -450
_LVOE_CreateMonitorSpecTagList  EQU     -456
_LVOE_ChangeMonitorSpecTagList  EQU     -462
_LVOE_SaveMonitorSpec           EQU     -468
_LVOE_ObtainMonitorSpec         EQU     -474
_LVOE_ReleaseMonitorSpec        EQU     -480
_LVOE_DeleteMonitorSpec         EQU     -486
_LVOE_RenameMonitorSpec         EQU     -492
_LVOE_CreateScreenSpecTagList   EQU     -498
_LVOE_DeleteScreenSpec          EQU     -504
_LVOE_ChangeScreenSpecTagList   EQU     -510
_LVOE_ObtainScreenSpec          EQU     -516
_LVOE_ReleaseScreenSpec         EQU     -522
_LVOE_CreateScreenParamTagList  EQU     -528
_LVOE_DeleteScreenParam         EQU     -534
_LVOE_ChangeScreenParamTagList  EQU     -540
_LVOE_GetRealTimings            EQU     -546
_LVOE_AddMonitorSpec            EQU     -552
_LVOE_RemMonitorSpec            EQU     -558
_LVOE_SaveMonitorPrefs          EQU     -564
_LVOE_LoadMonitorPrefs          EQU     -570
_LVOE_OpenScreenTagList         EQU     -576
_LVOE_DefinePublicObject        EQU     -582
_LVOE_ObtainPublicObject        EQU     -588
_LVOE_LoadDriver                EQU     -594
_LVOE_ReloadPrefs               EQU     -600
_LVOE_ReleasePublicObject       EQU     -606
_LVOE_ObtainObject              EQU     -612
_LVOE_CreateObjectMsg           EQU     -618
ENDC  * LVO_EGS_I
