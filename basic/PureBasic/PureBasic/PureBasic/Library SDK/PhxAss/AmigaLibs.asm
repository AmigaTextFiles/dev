;****************************************************
;
;     Amiga Rom 3.1 library offsets for PhxAss
;
; Converted by AlphaSND - © 1999 Fantaisie Software
;
;****************************************************


;****************************************************
;             mathieeedoubbas.library
;****************************************************

_IEEEDPFix   = -$1e  ; - d0,d1
_IEEEDPFlt   = -$24  ; - d0
_IEEEDPCmp   = -$2a  ; - d0,d1,d2,d3
_IEEEDPTst   = -$30  ; - d0,d1
_IEEEDPAbs   = -$36  ; - d0,d1
_IEEEDPNeg   = -$3c  ; - d0,d1
_IEEEDPAdd   = -$42  ; - d0,d1,d2,d3
_IEEEDPSub   = -$48  ; - d0,d1,d2,d3
_IEEEDPMul   = -$4e  ; - d0,d1,d2,d3
_IEEEDPDiv   = -$54  ; - d0,d1,d2,d3
_IEEEDPFloor = -$5a  ; - d0,d1
_IEEEDPCeil  = -$60  ; - d0,d1


;****************************************************
;            mathieeedoubtrans.library
;****************************************************

_IEEEDPAtan   = -$1e  ; - d0,d1
_IEEEDPSin    = -$24  ; - d0,d1
_IEEEDPCos    = -$2a  ; - d0,d1
_IEEEDPTan    = -$30  ; - d0,d1
_IEEEDPSincos = -$36  ; - a0,d0,d1
_IEEEDPSinh   = -$3c  ; - d0,d1
_IEEEDPCosh   = -$42  ; - d0,d1
_IEEEDPTanh   = -$48  ; - d0,d1
_IEEEDPExp    = -$4e  ; - d0,d1
_IEEEDPLog    = -$54  ; - d0,d1
_IEEEDPPow    = -$5a  ; - d2,d3,d0,d1
_IEEEDPSqrt   = -$60  ; - d0,d1
_IEEEDPTieee  = -$66  ; - d0,d1
_IEEEDPFieee  = -$6c  ; - d0
_IEEEDPAsin   = -$72  ; - d0,d1
_IEEEDPAcos   = -$78  ; - d0,d1
_IEEEDPLog10  = -$7e  ; - d0,d1


;****************************************************
;             mathieeesingbas.library
;****************************************************

_IEEESPFix   = -$1e  ; - d0
_IEEESPFlt   = -$24  ; - d0
_IEEESPCmp   = -$2a  ; - d0,d1
_IEEESPTst   = -$30  ; - d0
_IEEESPAbs   = -$36  ; - d0
_IEEESPNeg   = -$3c  ; - d0
_IEEESPAdd   = -$42  ; - d0,d1
_IEEESPSub   = -$48  ; - d0,d1
_IEEESPMul   = -$4e  ; - d0,d1
_IEEESPDiv   = -$54  ; - d0,d1
_IEEESPFloor = -$5a  ; - d0
_IEEESPCeil  = -$60  ; - d0


;****************************************************
;            mathieeesingtrans.library
;****************************************************

_IEEESPAtan   = -$1e  ; - d0
_IEEESPSin    = -$24  ; - d0
_IEEESPCos    = -$2a  ; - d0
_IEEESPTan    = -$30  ; - d0
_IEEESPSincos = -$36  ; - a0,d0
_IEEESPSinh   = -$3c  ; - d0
_IEEESPCosh   = -$42  ; - d0
_IEEESPTanh   = -$48  ; - d0
_IEEESPExp    = -$4e  ; - d0
_IEEESPLog    = -$54  ; - d0
_IEEESPPow    = -$5a  ; - d1,d0
_IEEESPSqrt   = -$60  ; - d0
_IEEESPTieee  = -$66  ; - d0
_IEEESPFieee  = -$6c  ; - d0
_IEEESPAsin   = -$72  ; - d0
_IEEESPAcos   = -$78  ; - d0
_IEEESPLog10  = -$7e  ; - d0


;****************************************************
;                mathtrans.library
;****************************************************

_SPAtan   = -$1e  ; - d0
_SPSin    = -$24  ; - d0
_SPCos    = -$2a  ; - d0
_SPTan    = -$30  ; - d0
_SPSincos = -$36  ; - d1,d0
_SPSinh   = -$3c  ; - d0
_SPCosh   = -$42  ; - d0
_SPTanh   = -$48  ; - d0
_SPExp    = -$4e  ; - d0
_SPLog    = -$54  ; - d0
_SPPow    = -$5a  ; - d1,d0
_SPSqrt   = -$60  ; - d0
_SPTieee  = -$66  ; - d0
_SPFieee  = -$6c  ; - d0
_SPAsin   = -$72  ; - d0
_SPAcos   = -$78  ; - d0
_SPLog10  = -$7e  ; - d0


;****************************************************
;                   misc.library
;****************************************************

_AllocMiscResource = -$6   ; - d0,a1
_FreeMiscResource  = -$c   ; - d0


;****************************************************
;               nonvolatile.library
;****************************************************

_GetCopyNV       = -$1e  ; - a0,a1,d1
_FreeNVData      = -$24  ; - a0
_StoreNV         = -$2a  ; - a0,a1,a2,d0,d1
_DeleteNV        = -$30  ; - a0,a1,d1
_GetNVInfo       = -$36  ; - d1
_GetNVList       = -$3c  ; - a0,d1
_SetNVProtection = -$42  ; - a0,a1,d2,d1


;****************************************************
;                  potgo.library
;****************************************************

_AllocPotBits = -$6   ; - d0
_FreePotBits  = -$c   ; - d0
_WritePotgo   = -$12  ; - d0,d1


;****************************************************
;                 ramdrive.library
;****************************************************

_KillRAD0 = -$2a  ; -
_KillRAD  = -$30  ; - d0


;****************************************************
;                 realtime.library
;****************************************************

_LockRealTime      = -$1e  ; - d0
_UnlockRealTime    = -$24  ; - a0
_CreatePlayerA     = -$2a  ; - a0
_DeletePlayer      = -$30  ; - a0
_SetPlayerAttrsA   = -$36  ; - a0,a1
_SetConductorState = -$3c  ; - a0,d0,d1
_ExternalSync      = -$42  ; - a0,d0,d1
_NextConductor     = -$48  ; - a0
_FindConductor     = -$4e  ; - a0
_GetPlayerAttrsA   = -$54  ; - a0,a1


;****************************************************
;                rexxsyslib.library
;****************************************************

_CreateArgstring = -$7e  ; - a0,d0
_DeleteArgstring = -$84  ; - a0
_LengthArgstring = -$8a  ; - a0
_CreateRexxMsg   = -$90  ; - a0,a1,d0
_DeleteRexxMsg   = -$96  ; - a0
_ClearRexxMsg    = -$9c  ; - a0,d0
_FillRexxMsg     = -$a2  ; - a0,d0,d1
_IsRexxMsg       = -$a8  ; - a0
_LockRexxBase    = -$1c2 ; - d0
_UnlockRexxBase  = -$1c8 ; - d0


;****************************************************
;                  timer.library
;****************************************************

_AddTime    = -$2a  ; - a0,a1
_SubTime    = -$30  ; - a0,a1
_CmpTime    = -$36  ; - a0,a1
_ReadEClock = -$3c  ; - a0
_GetSysTime = -$42  ; - a0


;****************************************************
;                translator.library
;****************************************************

_Translate = -$1e  ; - a0,d0,a1,d1


;****************************************************
;                 utility.library
;****************************************************

_FindTagItem           = -$1e  ; - d0,a0
_GetTagData            = -$24  ; - d0,d1,a0
_PackBoolTags          = -$2a  ; - d0,a0,a1
_NextTagItem           = -$30  ; - a0
_FilterTagChanges      = -$36  ; - a0,a1,d0
_MapTags               = -$3c  ; - a0,a1,d0
_AllocateTagItems      = -$42  ; - d0
_CloneTagItems         = -$48  ; - a0
_FreeTagItems          = -$4e  ; - a0
_RefreshTagItemClones  = -$54  ; - a0,a1
_TagInArray            = -$5a  ; - d0,a0
_FilterTagItems        = -$60  ; - a0,a1,d0
_CallHookPkt           = -$66  ; - a0,a2,a1
_Amiga2Date            = -$78  ; - d0,a0
_DateToAmiga           = -$7e  ; - a0
_CheckDate             = -$84  ; - a0
_SMult32               = -$8a  ; - d0,d1
_UMult32               = -$90  ; - d0,d1
_SDivMod32             = -$96  ; - d0,d1
_UDivMod32             = -$9c  ; - d0,d1
_Stricmp               = -$a2  ; - a0,a1
_Strnicmp              = -$a8  ; - a0,a1,d0
_ToUpper               = -$ae  ; - d0
_ToLower               = -$b4  ; - d0
_ApplyTagChanges       = -$ba  ; - a0,a1
_SMult64               = -$c6  ; - d0,d1
_UMult64               = -$cc  ; - d0,d1
_PackStructureTags     = -$d2  ; - a0,a1,a2
_UnpackStructureTags   = -$d8  ; - a0,a1,a2
_AddNamedObject        = -$de  ; - a0,a1
_AllocNamedObjectA     = -$e4  ; - a0,a1
_AttemptRemNamedObject = -$ea  ; - a0
_FindNamedObject       = -$f0  ; - a0,a1,a2
_FreeNamedObject       = -$f6  ; - a0
_NamedObjectName       = -$fc  ; - a0
_ReleaseNamedObject    = -$102 ; - a0
_RemNamedObject        = -$108 ; - a0,a1
_GetUniqueID           = -$10e ; -


;****************************************************
;                    wb.library
;****************************************************

_AddAppWindowA     = -$30  ; - d0,d1,a0,a1,a2
_RemoveAppWindow   = -$36  ; - a0
_AddAppIconA       = -$3c  ; - d0,d1,a0,a1,a2,a3,a4
_RemoveAppIcon     = -$42  ; - a0
_AddAppMenuItemA   = -$48  ; - d0,d1,a0,a1,a2
_RemoveAppMenuItem = -$4e  ; - a0
_WBInfo            = -$5a  ; - a0,a1,a2


;****************************************************
;                amigaguide.library
;****************************************************

_LockAmigaGuideBase     = -$24  ; - a0
_UnlockAmigaGuideBase   = -$2a  ; - d0
_OpenAmigaGuideA        = -$36  ; - a0,a1
_OpenAmigaGuideAsyncA   = -$3c  ; - a0,d0
_CloseAmigaGuide        = -$42  ; - a0
_AmigaGuideSignal       = -$48  ; - a0
_GetAmigaGuideMsg       = -$4e  ; - a0
_ReplyAmigaGuideMsg     = -$54  ; - a0
_SetAmigaGuideContextA  = -$5a  ; - a0,d0,d1
_SendAmigaGuideContextA = -$60  ; - a0,d0
_SendAmigaGuideCmdA     = -$66  ; - a0,d0,d1
_SetAmigaGuideAttrsA    = -$6c  ; - a0,a1
_GetAmigaGuideAttr      = -$72  ; - d0,a0,a1
_LoadXRef               = -$7e  ; - a0,a1
_ExpungeXRef            = -$84  ; -
_AddAmigaGuideHostA     = -$8a  ; - a0,d0,a1
_RemoveAmigaGuideHostA  = -$90  ; - a0,a1
_GetAmigaGuideString    = -$d2  ; - d0


;****************************************************
;                   asl.library
;****************************************************

_AllocFileRequest = -$1e  ; -
_FreeFileRequest  = -$24  ; - a0
_RequestFile      = -$2a  ; - a0
_AllocAslRequest  = -$30  ; - d0,a0
_FreeAslRequest   = -$36  ; - a0
_AslRequest       = -$3c  ; - a0,a1


;****************************************************
;                battclock.library
;****************************************************

_ResetBattClock = -$6   ; -
_ReadBattClock  = -$c   ; -
_WriteBattClock = -$12  ; - d0


;****************************************************
;                 battmem.library
;****************************************************

_ObtainBattSemaphore  = -$6   ; -
_ReleaseBattSemaphore = -$c   ; -
_ReadBattMem          = -$12  ; - a0,d0,d1
_WriteBattMem         = -$18  ; - a0,d0,d1


;****************************************************
;                  bullet.library
;****************************************************

_OpenEngine   = -$1e  ; -
_CloseEngine  = -$24  ; - a0
_SetInfoA     = -$2a  ; - a0,a1
_ObtainInfoA  = -$30  ; - a0,a1
_ReleaseInfoA = -$36  ; - a0,a1


;****************************************************
;                 cardres.library
;****************************************************

_OwnCard            = -$6   ; - a1
_ReleaseCard        = -$c   ; - a1,d0
_GetCardMap         = -$12  ; -
_BeginCardAccess    = -$18  ; - a1
_EndCardAccess      = -$1e  ; - a1
_ReadCardStatus     = -$24  ; -
_CardResetRemove    = -$2a  ; - a1,d0
_CardMiscControl    = -$30  ; - a1,d1
_CardAccessSpeed    = -$36  ; - a1,d0
_CardProgramVoltage = -$3c  ; - a1,d0
_CardResetCard      = -$42  ; - a1
_CopyTuple          = -$48  ; - a1,a0,d1,d0
_DeviceTuple        = -$4e  ; - a0,a1
_IfAmigaXIP         = -$54  ; - a2
_CardForceChange    = -$5a  ; -
_CardChangeCount    = -$60  ; -
_CardInterface      = -$66  ; -


;****************************************************
;                   cia.library
;****************************************************

_AddICRVector = -$6   ; - a6,d0,a1
_RemICRVector = -$c   ; - a6,d0,a1
_AbleICR      = -$12  ; - a6,d0
_SetICR       = -$18  ; - a6,d0


;****************************************************
;                colorwheel.library
;****************************************************

_ConvertHSBToRGB = -$1e  ; - a0,a1
_ConvertRGBToHSB = -$24  ; - a0,a1


;****************************************************
;               commodities.library
;****************************************************

_CreateCxObj     = -$1e  ; - d0,a0,a1
_CxBroker        = -$24  ; - a0,d0
_ActivateCxObj   = -$2a  ; - a0,d0
_DeleteCxObj     = -$30  ; - a0
_DeleteCxObjAll  = -$36  ; - a0
_CxObjType       = -$3c  ; - a0
_CxObjError      = -$42  ; - a0
_ClearCxObjError = -$48  ; - a0
_SetCxObjPri     = -$4e  ; - a0,d0
_AttachCxObj     = -$54  ; - a0,a1
_EnqueueCxObj    = -$5a  ; - a0,a1
_InsertCxObj     = -$60  ; - a0,a1,a2
_RemoveCxObj     = -$66  ; - a0
_SetTranslate    = -$72  ; - a0,a1
_SetFilter       = -$78  ; - a0,a1
_SetFilterIX     = -$7e  ; - a0,a1
_ParseIX         = -$84  ; - a0,a1
_CxMsgType       = -$8a  ; - a0
_CxMsgData       = -$90  ; - a0
_CxMsgID         = -$96  ; - a0
_DivertCxMsg     = -$9c  ; - a0,a1,a2
_RouteCxMsg      = -$a2  ; - a0,a1
_DisposeCxMsg    = -$a8  ; - a0
_InvertKeyMap    = -$ae  ; - d0,a0,a1
_AddIEvents      = -$b4  ; - a0
_MatchIX         = -$cc  ; - a0,a1


;****************************************************
;                 console.library
;****************************************************

_CDInputHandler = -$2a  ; - a0,a1
_RawKeyConvert  = -$30  ; - a0,a1,d1,a2


;****************************************************
;                datatypes.library
;****************************************************

_ObtainDataTypeA     = -$24  ; - d0,a0,a1
_ReleaseDataType     = -$2a  ; - a0
_NewDTObjectA        = -$30  ; - d0,a0
_DisposeDTObject     = -$36  ; - a0
_SetDTAttrsA         = -$3c  ; - a0,a1,a2,a3
_GetDTAttrsA         = -$42  ; - a0,a2
_AddDTObject         = -$48  ; - a0,a1,a2,d0
_RefreshDTObjectA    = -$4e  ; - a0,a1,a2,a3
_DoAsyncLayout       = -$54  ; - a0,a1
_DoDTMethodA         = -$5a  ; - a0,a1,a2,a3
_RemoveDTObject      = -$60  ; - a0,a1
_GetDTMethods        = -$66  ; - a0
_GetDTTriggerMethods = -$6c  ; - a0
_PrintDTObjectA      = -$72  ; - a0,a1,a2,a3
_GetDTString         = -$8a  ; - d0


;****************************************************
;                   disk.library
;****************************************************

_AllocUnit  = -$6   ; - d0
_FreeUnit   = -$c   ; - d0
_GetUnit    = -$12  ; - a1
_GiveUnit   = -$18  ; -
_GetUnitID  = -$1e  ; - d0
_ReadUnitID = -$24  ; - d0


;****************************************************
;                 diskfont.library
;****************************************************

_OpenDiskFont        = -$1e  ; - a0
_AvailFonts          = -$24  ; - a0,d0,d1
_NewFontContents     = -$2a  ; - a0,a1
_DisposeFontContents = -$30  ; - a1
_NewScaledDiskFont   = -$36  ; - a0,a1


;****************************************************
;                   dos.library
;****************************************************

_Open               = -$1e  ; - d1,d2
_Close              = -$24  ; - d1
_Read               = -$2a  ; - d1,d2,d3
_Write              = -$30  ; - d1,d2,d3
_Input              = -$36  ; -
_Output             = -$3c  ; -
_Seek               = -$42  ; - d1,d2,d3
_DeleteFile         = -$48  ; - d1
_Rename             = -$4e  ; - d1,d2
_Lock               = -$54  ; - d1,d2
_UnLock             = -$5a  ; - d1
_DupLock            = -$60  ; - d1
_Examine            = -$66  ; - d1,d2
_ExNext             = -$6c  ; - d1,d2
_Info               = -$72  ; - d1,d2
_CreateDir          = -$78  ; - d1
_CurrentDir         = -$7e  ; - d1
_IoErr              = -$84  ; -
_CreateProc         = -$8a  ; - d1,d2,d3,d4
_Exit               = -$90  ; - d1
_LoadSeg            = -$96  ; - d1
_UnLoadSeg          = -$9c  ; - d1
_DeviceProc         = -$ae  ; - d1
_SetComment         = -$b4  ; - d1,d2
_SetProtection      = -$ba  ; - d1,d2
_DateStamp          = -$c0  ; - d1
_Delay              = -$c6  ; - d1
_WaitForChar        = -$cc  ; - d1,d2
_ParentDir          = -$d2  ; - d1
_IsInteractive      = -$d8  ; - d1
_Execute            = -$de  ; - d1,d2,d3
_AllocDosObject     = -$e4  ; - d1,d2
_FreeDosObject      = -$ea  ; - d1,d2
_DoPkt              = -$f0  ; - d1,d2,d3,d4,d5,d6,d7
_SendPkt            = -$f6  ; - d1,d2,d3
_WaitPkt            = -$fc  ; -
_ReplyPkt           = -$102 ; - d1,d2,d3
_AbortPkt           = -$108 ; - d1,d2
_LockRecord         = -$10e ; - d1,d2,d3,d4,d5
_LockRecords        = -$114 ; - d1,d2
_UnLockRecord       = -$11a ; - d1,d2,d3
_UnLockRecords      = -$120 ; - d1
_SelectInput        = -$126 ; - d1
_SelectOutput       = -$12c ; - d1
_FGetC              = -$132 ; - d1
_FPutC              = -$138 ; - d1,d2
_UnGetC             = -$13e ; - d1,d2
_FRead              = -$144 ; - d1,d2,d3,d4
_FWrite             = -$14a ; - d1,d2,d3,d4
_FGets              = -$150 ; - d1,d2,d3
_FPuts              = -$156 ; - d1,d2
_VFWritef           = -$15c ; - d1,d2,d3
_VFPrintf           = -$162 ; - d1,d2,d3
_Flush              = -$168 ; - d1
_SetVBuf            = -$16e ; - d1,d2,d3,d4
_DupLockFromFH      = -$174 ; - d1
_OpenFromLock       = -$17a ; - d1
_ParentOfFH         = -$180 ; - d1
_ExamineFH          = -$186 ; - d1,d2
_SetFileDate        = -$18c ; - d1,d2
_NameFromLock       = -$192 ; - d1,d2,d3
_NameFromFH         = -$198 ; - d1,d2,d3
_SplitName          = -$19e ; - d1,d2,d3,d4,d5
_SameLock           = -$1a4 ; - d1,d2
_SetMode            = -$1aa ; - d1,d2
_ExAll              = -$1b0 ; - d1,d2,d3,d4,d5
_ReadLink           = -$1b6 ; - d1,d2,d3,d4,d5
_MakeLink           = -$1bc ; - d1,d2,d3
_ChangeMode         = -$1c2 ; - d1,d2,d3
_SetFileSize        = -$1c8 ; - d1,d2,d3
_SetIoErr           = -$1ce ; - d1
_Fault              = -$1d4 ; - d1,d2,d3,d4
_PrintFault         = -$1da ; - d1,d2
_ErrorReport        = -$1e0 ; - d1,d2,d3,d4
_Cli                = -$1ec ; -
_CreateNewProc      = -$1f2 ; - d1
_RunCommand         = -$1f8 ; - d1,d2,d3,d4
_GetConsoleTask     = -$1fe ; -
_SetConsoleTask     = -$204 ; - d1
_GetFileSysTask     = -$20a ; -
_SetFileSysTask     = -$210 ; - d1
_GetArgStr          = -$216 ; -
_SetArgStr          = -$21c ; - d1
_FindCliProc        = -$222 ; - d1
_MaxCli             = -$228 ; -
_SetCurrentDirName  = -$22e ; - d1
_GetCurrentDirName  = -$234 ; - d1,d2
_SetProgramName     = -$23a ; - d1
_GetProgramName     = -$240 ; - d1,d2
_SetPrompt          = -$246 ; - d1
_GetPrompt          = -$24c ; - d1,d2
_SetProgramDir      = -$252 ; - d1
_GetProgramDir      = -$258 ; -
_SystemTagList      = -$25e ; - d1,d2
_AssignLock         = -$264 ; - d1,d2
_AssignLate         = -$26a ; - d1,d2
_AssignPath         = -$270 ; - d1,d2
_AssignAdd          = -$276 ; - d1,d2
_RemAssignList      = -$27c ; - d1,d2
_GetDeviceProc      = -$282 ; - d1,d2
_FreeDeviceProc     = -$288 ; - d1
_LockDosList        = -$28e ; - d1
_UnLockDosList      = -$294 ; - d1
_AttemptLockDosList = -$29a ; - d1
_RemDosEntry        = -$2a0 ; - d1
_AddDosEntry        = -$2a6 ; - d1
_FindDosEntry       = -$2ac ; - d1,d2,d3
_NextDosEntry       = -$2b2 ; - d1,d2
_MakeDosEntry       = -$2b8 ; - d1,d2
_FreeDosEntry       = -$2be ; - d1
_IsFileSystem       = -$2c4 ; - d1
_Format             = -$2ca ; - d1,d2,d3
_Relabel            = -$2d0 ; - d1,d2
_Inhibit            = -$2d6 ; - d1,d2
_AddBuffers         = -$2dc ; - d1,d2
_CompareDates       = -$2e2 ; - d1,d2
_DateToStr          = -$2e8 ; - d1
_StrToDate          = -$2ee ; - d1
_InternalLoadSeg    = -$2f4 ; - d0,a0,a1,a2
_InternalUnLoadSeg  = -$2fa ; - d1,a1
_NewLoadSeg         = -$300 ; - d1,d2
_AddSegment         = -$306 ; - d1,d2,d3
_FindSegment        = -$30c ; - d1,d2,d3
_RemSegment         = -$312 ; - d1
_CheckSignal        = -$318 ; - d1
_ReadArgs           = -$31e ; - d1,d2,d3
_FindArg            = -$324 ; - d1,d2
_ReadItem           = -$32a ; - d1,d2,d3
_StrToLong          = -$330 ; - d1,d2
_MatchFirst         = -$336 ; - d1,d2
_MatchNext          = -$33c ; - d1
_MatchEnd           = -$342 ; - d1
_ParsePattern       = -$348 ; - d1,d2,d3
_MatchPattern       = -$34e ; - d1,d2
_FreeArgs           = -$35a ; - d1
_FilePart           = -$366 ; - d1
_PathPart           = -$36c ; - d1
_AddPart            = -$372 ; - d1,d2,d3
_StartNotify        = -$378 ; - d1
_EndNotify          = -$37e ; - d1
_SetVar             = -$384 ; - d1,d2,d3,d4
_GetVar             = -$38a ; - d1,d2,d3,d4
_DeleteVar          = -$390 ; - d1,d2
_FindVar            = -$396 ; - d1,d2
_CliInitNewcli      = -$3a2 ; - a0
_CliInitRun         = -$3a8 ; - a0
_WriteChars         = -$3ae ; - d1,d2
_PutStr             = -$3b4 ; - d1
_VPrintf            = -$3ba ; - d1,d2
_ParsePatternNoCase = -$3c6 ; - d1,d2,d3
_MatchPatternNoCase = -$3cc ; - d1,d2
_SameDevice         = -$3d8 ; - d1,d2
_ExAllEnd           = -$3de ; - d1,d2,d3,d4,d5
_SetOwner           = -$3e4 ; - d1,d2


;****************************************************
;                 dtclass.library
;****************************************************

_ObtainEngine = -$1e  ; -


;****************************************************
;                   exec.library
;****************************************************

_Supervisor             = -30   ; - a5
_InitCode               = -$48  ; - d0,d1
_InitStruct             = -$4e  ; - a1,a2,d0
_MakeLibrary            = -$54  ; - a0,a1,a2,d0,d1
_MakeFunctions          = -$5a  ; - a0,a1,a2
_FindResident           = -$60  ; - a1
_InitResident           = -$66  ; - a1,d1
_Alert                  = -$6c  ; - d7
_Debug                  = -$72  ; - d0
_Disable                = -$78  ; -
_Enable                 = -$7e  ; -
_Forbid                 = -$84  ; -
_Permit                 = -$8a  ; -
_SetSR                  = -$90  ; - d0,d1
_SuperState             = -$96  ; -
_UserState              = -$9c  ; - d0
_SetIntVector           = -$a2  ; - d0,a1
_AddIntServer           = -$a8  ; - d0,a1
_RemIntServer           = -$ae  ; - d0,a1
_Cause                  = -$b4  ; - a1
_Allocate               = -$ba  ; - a0,d0
_Deallocate             = -$c0  ; - a0,a1,d0
_AllocMem               = -$c6  ; - d0,d1
_AllocAbs               = -$cc  ; - d0,a1
_FreeMem                = -$d2  ; - a1,d0
_AvailMem               = -$d8  ; - d1
_AllocEntry             = -$de  ; - a0
_FreeEntry              = -$e4  ; - a0
_Insert                 = -$ea  ; - a0,a1,a2
_AddHead                = -$f0  ; - a0,a1
_AddTail                = -$f6  ; - a0,a1
_Remove                 = -$fc  ; - a1
_RemHead                = -$102 ; - a0
_RemTail                = -$108 ; - a0
_Enqueue                = -$10e ; - a0,a1
_FindName               = -$114 ; - a0,a1
_AddTask                = -$11a ; - a1,a2,a3
_RemTask                = -$120 ; - a1
_FindTask               = -$126 ; - a1
_SetTaskPri             = -$12c ; - a1,d0
_SetSignal              = -$132 ; - d0,d1
_SetExcept              = -$138 ; - d0,d1
_Wait                   = -$13e ; - d0
_Signal                 = -$144 ; - a1,d0
_AllocSignal            = -$14a ; - d0
_FreeSignal             = -$150 ; - d0
_AllocTrap              = -$156 ; - d0
_FreeTrap               = -$15c ; - d0
_AddPort                = -$162 ; - a1
_RemPort                = -$168 ; - a1
_PutMsg                 = -$16e ; - a0,a1
_GetMsg                 = -$174 ; - a0
_ReplyMsg               = -$17a ; - a1
_WaitPort               = -$180 ; - a0
_FindPort               = -$186 ; - a1
_AddLibrary             = -$18c ; - a1
_RemLibrary             = -$192 ; - a1
_OldOpenLibrary         = -$198 ; - a1
_CloseLibrary           = -$19e ; - a1
_SetFunction            = -$1a4 ; - a1,a0,d0
_SumLibrary             = -$1aa ; - a1
_AddDevice              = -$1b0 ; - a1
_RemDevice              = -$1b6 ; - a1
_OpenDevice             = -$1bc ; - a0,d0,a1,d1
_CloseDevice            = -$1c2 ; - a1
_DoIO                   = -$1c8 ; - a1
_SendIO                 = -$1ce ; - a1
_CheckIO                = -$1d4 ; - a1
_WaitIO                 = -$1da ; - a1
_AbortIO                = -$1e0 ; - a1
_AddResource            = -$1e6 ; - a1
_RemResource            = -$1ec ; - a1
_OpenResource           = -$1f2 ; - a1
_RawDoFmt               = -$20a ; - a0,a1,a2,a3
_GetCC                  = -$210 ; -
_TypeOfMem              = -$216 ; - a1
_Procure                = -$21c ; - a0,a1
_Vacate                 = -$222 ; - a0,a1
_OpenLibrary            = -$228 ; - a1,d0
_InitSemaphore          = -$22e ; - a0
_ObtainSemaphore        = -$234 ; - a0
_ReleaseSemaphore       = -$23a ; - a0
_AttemptSemaphore       = -$240 ; - a0
_ObtainSemaphoreList    = -$246 ; - a0
_ReleaseSemaphoreList   = -$24c ; - a0
_FindSemaphore          = -$252 ; - a1
_AddSemaphore           = -$258 ; - a1
_RemSemaphore           = -$25e ; - a1
_SumKickData            = -$264 ; -
_AddMemList             = -$26a ; - d0,d1,d2,a0,a1
_CopyMem                = -$270 ; - a0,a1,d0
_CopyMemQuick           = -$276 ; - a0,a1,d0
_CacheClearU            = -$27c ; -
_CacheClearE            = -$282 ; - a0,d0,d1
_CacheControl           = -$288 ; - d0,d1
_CreateIORequest        = -$28e ; - a0,d0
_DeleteIORequest        = -$294 ; - a0
_CreateMsgPort          = -$29a ; -
_DeleteMsgPort          = -$2a0 ; - a0
_ObtainSemaphoreShared  = -$2a6 ; - a0
_AllocVec               = -$2ac ; - d0,d1
_FreeVec                = -$2b2 ; - a1
_CreatePool             = -$2b8 ; - d0,d1,d2
_DeletePool             = -$2be ; - a0
_AllocPooled            = -$2c4 ; - a0,d0
_FreePooled             = -$2ca ; - a0,a1,d0
_AttemptSemaphoreShared = -$2d0 ; - a0
_ColdReboot             = -$2d6 ; -
_StackSwap              = -$2dc ; - a0
_ChildFree              = -$2e2 ; - d0
_ChildOrphan            = -$2e8 ; - d0
_ChildStatus            = -$2ee ; - d0
_ChildWait              = -$2f4 ; - d0
_CachePreDMA            = -$2fa ; - a0,a1,d0
_CachePostDMA           = -$300 ; - a0,a1,d0
_AddMemHandler          = -$306 ; - a1
_RemMemHandler          = -$30c ; - a1
_ObtainQuickVector      = -$312 ; - a0


;****************************************************
;                expansion.library
;****************************************************

_AddConfigDev         = -$1e  ; - a0
_AddBootNode          = -$24  ; - d0,d1,a0,a1
_AllocBoardMem        = -$2a  ; - d0
_AllocConfigDev       = -$30  ; -
_AllocExpansionMem    = -$36  ; - d0,d1
_ConfigBoard          = -$3c  ; - a0,a1
_ConfigChain          = -$42  ; - a0
_FindConfigDev        = -$48  ; - a0,d0,d1
_FreeBoardMem         = -$4e  ; - d0,d1
_FreeConfigDev        = -$54  ; - a0
_FreeExpansionMem     = -$5a  ; - d0,d1
_ReadExpansionByte    = -$60  ; - a0,d0
_ReadExpansionRom     = -$66  ; - a0,a1
_RemConfigDev         = -$6c  ; - a0
_WriteExpansionByte   = -$72  ; - a0,d0,d1
_ObtainConfigBinding  = -$78  ; -
_ReleaseConfigBinding = -$7e  ; -
_SetCurrentBinding    = -$84  ; - a0,d0
_GetCurrentBinding    = -$8a  ; - a0,d0
_MakeDosNode          = -$90  ; - a0
_AddDosNode           = -$96  ; - d0,d1,a0


;****************************************************
;                 gadtools.library
;****************************************************

_CreateGadgetA      = -$1e  ; - d0,a0,a1,a2
_FreeGadgets        = -$24  ; - a0
_GT_SetGadgetAttrsA = -$2a  ; - a0,a1,a2,a3
_CreateMenusA       = -$30  ; - a0,a1
_FreeMenus          = -$36  ; - a0
_LayoutMenuItemsA   = -$3c  ; - a0,a1,a2
_LayoutMenusA       = -$42  ; - a0,a1,a2
_GT_GetIMsg         = -$48  ; - a0
_GT_ReplyIMsg       = -$4e  ; - a1
_GT_RefreshWindow   = -$54  ; - a0,a1
_GT_BeginRefresh    = -$5a  ; - a0
_GT_EndRefresh      = -$60  ; - a0,d0
_GT_FilterIMsg      = -$66  ; - a1
_GT_PostFilterIMsg  = -$6c  ; - a1
_CreateContext      = -$72  ; - a0
_DrawBevelBoxA      = -$78  ; - a0,d0,d1,d2,d3,a1
_GetVisualInfoA     = -$7e  ; - a0,a1
_FreeVisualInfo     = -$84  ; - a0
_GT_GetGadgetAttrsA = -$ae  ; - a0,a1,a2,a3


;****************************************************
;                 graphics.library
;****************************************************

_BltBitMap             = -$1e  ; - a0,d0,d1,a1,d2,d3,d4,d5,d6,d7,a2
_BltTemplate           = -$24  ; - a0,d0,d1,a1,d2,d3,d4,d5
_ClearEOL              = -$2a  ; - a1
_ClearScreen           = -$30  ; - a1
_TextLength            = -$36  ; - a1,a0,d0
_Text                  = -$3c  ; - a1,a0,d0
_SetFont               = -$42  ; - a1,a0
_OpenFont              = -$48  ; - a0
_CloseFont             = -$4e  ; - a1
_AskSoftStyle          = -$54  ; - a1
_SetSoftStyle          = -$5a  ; - a1,d0,d1
_AddBob                = -$60  ; - a0,a1
_AddVSprite            = -$66  ; - a0,a1
_DoCollision           = -$6c  ; - a1
_DrawGList             = -$72  ; - a1,a0
_InitGels              = -$78  ; - a0,a1,a2
_InitMasks             = -$7e  ; - a0
_RemIBob               = -$84  ; - a0,a1,a2
_RemVSprite            = -$8a  ; - a0
_SetCollision          = -$90  ; - d0,a0,a1
_SortGList             = -$96  ; - a1
_AddAnimOb             = -$9c  ; - a0,a1,a2
_Animate               = -$a2  ; - a0,a1
_GetGBuffers           = -$a8  ; - a0,a1,d0
_InitGMasks            = -$ae  ; - a0
_DrawEllipse           = -$b4  ; - a1,d0,d1,d2,d3
_AreaEllipse           = -$ba  ; - a1,d0,d1,d2,d3
_LoadRGB4              = -$c0  ; - a0,a1,d0
_InitRastPort          = -$c6  ; - a1
_InitVPort             = -$cc  ; - a0
_MrgCop                = -$d2  ; - a1
_MakeVPort             = -$d8  ; - a0,a1
_LoadView              = -$de  ; - a1
_WaitBlit              = -$e4  ; -
_SetRast               = -$ea  ; - a1,d0
_Move                  = -$f0  ; - a1,d0,d1
_Draw                  = -$f6  ; - a1,d0,d1
_AreaMove              = -$fc  ; - a1,d0,d1
_AreaDraw              = -$102 ; - a1,d0,d1
_AreaEnd               = -$108 ; - a1
_WaitTOF               = -$10e ; -
_QBlit                 = -$114 ; - a1
_InitArea              = -$11a ; - a0,a1,d0
_SetRGB4               = -$120 ; - a0,d0,d1,d2,d3
_QBSBlit               = -$126 ; - a1
_BltClear              = -$12c ; - a1,d0,d1
_RectFill              = -$132 ; - a1,d0,d1,d2,d3
_BltPattern            = -$138 ; - a1,a0,d0,d1,d2,d3,d4
_ReadPixel             = -$13e ; - a1,d0,d1
_WritePixel            = -$144 ; - a1,d0,d1
_Flood                 = -$14a ; - a1,d2,d0,d1
_PolyDraw              = -$150 ; - a1,d0,a0
_SetAPen               = -$156 ; - a1,d0
_SetBPen               = -$15c ; - a1,d0
_SetDrMd               = -$162 ; - a1,d0
_InitView              = -$168 ; - a1
_CBump                 = -$16e ; - a1
_CMove                 = -$174 ; - a1,d0,d1
_CWait                 = -$17a ; - a1,d0,d1
_VBeamPos              = -$180 ; -
_InitBitMap            = -$186 ; - a0,d0,d1,d2
_ScrollRaster          = -$18c ; - a1,d0,d1,d2,d3,d4,d5
_WaitBOVP              = -$192 ; - a0
_GetSprite             = -$198 ; - a0,d0
_FreeSprite            = -$19e ; - d0
_ChangeSprite          = -$1a4 ; - a0,a1,a2
_MoveSprite            = -$1aa ; - a0,a1,d0,d1
_SyncSBitMap           = -$1bc ; - a0
_CopySBitMap           = -$1c2 ; - a0
_OwnBlitter            = -$1c8 ; -
_DisownBlitter         = -$1ce ; -
_InitTmpRas            = -$1d4 ; - a0,a1,d0
_AskFont               = -$1da ; - a1,a0
_AddFont               = -$1e0 ; - a1
_RemFont               = -$1e6 ; - a1
_AllocRaster           = -$1ec ; - d0,d1
_FreeRaster            = -$1f2 ; - a0,d0,d1
_AndRectRegion         = -$1f8 ; - a0,a1
_OrRectRegion          = -$1fe ; - a0,a1
_NewRegion             = -$204 ; -
_ClearRectRegion       = -$20a ; - a0,a1
_ClearRegion           = -$210 ; - a0
_DisposeRegion         = -$216 ; - a0
_FreeVPortCopLists     = -$21c ; - a0
_FreeCopList           = -$222 ; - a0
_ClipBlit              = -$228 ; - a0,d0,d1,a1,d2,d3,d4,d5,d6
_XorRectRegion         = -$22e ; - a0,a1
_FreeCprList           = -$234 ; - a0
_GetColorMap           = -$23a ; - d0
_FreeColorMap          = -$240 ; - a0
_GetRGB4               = -$246 ; - a0,d0
_ScrollVPort           = -$24c ; - a0
_UCopperListInit       = -$252 ; - a0,d0
_FreeGBuffers          = -$258 ; - a0,a1,d0
_BltBitMapRastPort     = -$25e ; - a0,d0,d1,a1,d2,d3,d4,d5,d6
_OrRegionRegion        = -$264 ; - a0,a1
_XorRegionRegion       = -$26a ; - a0,a1
_AndRegionRegion       = -$270 ; - a0,a1
_SetRGB4CM             = -$276 ; - a0,d0,d1,d2,d3
_BltMaskBitMapRastPort = -$27c ; - a0,d0,d1,a1,d2,d3,d4,d5,d6,a2
_GfxNew                = -$294 ; - d0
_GfxFree               = -$29a ; - a0
_GfxAssociate          = -$2a0 ; - a0,a1
_BitMapScale           = -$2a6 ; - a0
_ScalerDiv             = -$2ac ; - d0,d1,d2
_TextExtent            = -$2b2 ; - a1,a0,d0,a2
_TextFit               = -$2b8 ; - a1,a0,d0,a2,a3,d1,d2,d3
_GfxLookUp             = -$2be ; - a0
_VideoControl          = -$2c4 ; - a0,a1
_OpenMonitor           = -$2ca ; - a1,d0
_CloseMonitor          = -$2d0 ; - a0
_FindDisplayInfo       = -$2d6 ; - d0
_NextDisplayInfo       = -$2dc ; - d0
_GetDisplayInfoData    = -$2f4 ; - a0,a1,d0,d1,d2
_FontExtent            = -$2fa ; - a0,a1
_ReadPixelLine8        = -$300 ; - a0,d0,d1,d2,a2,a1
_WritePixelLine8       = -$306 ; - a0,d0,d1,d2,a2,a1
_ReadPixelArray8       = -$30c ; - a0,d0,d1,d2,d3,a2,a1
_WritePixelArray8      = -$312 ; - a0,d0,d1,d2,d3,a2,a1
_GetVPModeID           = -$318 ; - a0
_ModeNotAvailable      = -$31e ; - d0
_WeighTAMatch          = -$324 ; - a0,a1,a2
_EraseRect             = -$32a ; - a1,d0,d1,d2,d3
_ExtendFont            = -$330 ; - a0,a1
_StripFont             = -$336 ; - a0
_CalcIVG               = -$33c ; - a0,a1
_AttachPalExtra        = -$342 ; - a0,a1
_ObtainBestPenA        = -$348 ; - a0,d1,d2,d3,a1
_SetRGB32              = -$354 ; - a0,d0,d1,d2,d3
_GetAPen               = -$35a ; - a0
_GetBPen               = -$360 ; - a0
_GetDrMd               = -$366 ; - a0
_GetOutlinePen         = -$36c ; - a0
_LoadRGB32             = -$372 ; - a0,a1
_SetChipRev            = -$378 ; - d0
_SetABPenDrMd          = -$37e ; - a1,d0,d1,d2
_GetRGB32              = -$384 ; - a0,d0,d1,a1
_AllocBitMap           = -$396 ; - d0,d1,d2,d3,a0
_FreeBitMap            = -$39c ; - a0
_GetExtSpriteA         = -$3a2 ; - a2,a1
_CoerceMode            = -$3a8 ; - a0,d0,d1
_ChangeVPBitMap        = -$3ae ; - a0,a1,a2
_ReleasePen            = -$3b4 ; - a0,d0
_ObtainPen             = -$3ba ; - a0,d0,d1,d2,d3,d4
_GetBitMapAttr         = -$3c0 ; - a0,d1
_AllocDBufInfo         = -$3c6 ; - a0
_FreeDBufInfo          = -$3cc ; - a1
_SetOutlinePen         = -$3d2 ; - a0,d0
_SetWriteMask          = -$3d8 ; - a0,d0
_SetMaxPen             = -$3de ; - a0,d0
_SetRGB32CM            = -$3e4 ; - a0,d0,d1,d2,d3
_ScrollRasterBF        = -$3ea ; - a1,d0,d1,d2,d3,d4,d5
_FindColor             = -$3f0 ; - a3,d1,d2,d3,d4
_AllocSpriteDataA      = -$3fc ; - a2,a1
_ChangeExtSpriteA      = -$402 ; - a0,a1,a2,a3
_FreeSpriteData        = -$408 ; - a2
_SetRPAttrsA           = -$40e ; - a0,a1
_GetRPAttrsA           = -$414 ; - a0,a1
_BestModeIDA           = -$41a ; - a0
_WriteChunkyPixels     = -$420 ; - a0,d0,d1,d2,d3,a2,d4


;****************************************************
;                   icon.library
;****************************************************

_FreeFreeList     = -$36  ; - a0
_AddFreeList      = -$48  ; - a0,a1,a2
_GetDiskObject    = -$4e  ; - a0
_PutDiskObject    = -$54  ; - a0,a1
_FreeDiskObject   = -$5a  ; - a0
_FindToolType     = -$60  ; - a0,a1
_MatchToolValue   = -$66  ; - a0,a1
_BumpRevision     = -$6c  ; - a0,a1
_GetDefDiskObject = -$78  ; - d0
_PutDefDiskObject = -$7e  ; - a0
_GetDiskObjectNew = -$84  ; - a0
_DeleteDiskObject = -$8a  ; - a0


;****************************************************
;                 iffparse.library
;****************************************************

_AllocIFF           = -$1e  ; -
_OpenIFF            = -$24  ; - a0,d0
_ParseIFF           = -$2a  ; - a0,d0
_CloseIFF           = -$30  ; - a0
_FreeIFF            = -$36  ; - a0
_ReadChunkBytes     = -$3c  ; - a0,a1,d0
_WriteChunkBytes    = -$42  ; - a0,a1,d0
_ReadChunkRecords   = -$48  ; - a0,a1,d0,d1
_WriteChunkRecords  = -$4e  ; - a0,a1,d0,d1
_PushChunk          = -$54  ; - a0,d0,d1,d2
_PopChunk           = -$5a  ; - a0
_EntryHandler       = -$66  ; - a0,d0,d1,d2,a1,a2
_ExitHandler        = -$6c  ; - a0,d0,d1,d2,a1,a2
_PropChunk          = -$72  ; - a0,d0,d1
_PropChunks         = -$78  ; - a0,a1,d0
_StopChunk          = -$7e  ; - a0,d0,d1
_StopChunks         = -$84  ; - a0,a1,d0
_CollectionChunk    = -$8a  ; - a0,d0,d1
_CollectionChunks   = -$90  ; - a0,a1,d0
_StopOnExit         = -$96  ; - a0,d0,d1
_FindProp           = -$9c  ; - a0,d0,d1
_FindCollection     = -$a2  ; - a0,d0,d1
_FindPropContext    = -$a8  ; - a0
_CurrentChunk       = -$ae  ; - a0
_ParentChunk        = -$b4  ; - a0
_AllocLocalItem     = -$ba  ; - d0,d1,d2,d3
_LocalItemData      = -$c0  ; - a0
_SetLocalItemPurge  = -$c6  ; - a0,a1
_FreeLocalItem      = -$cc  ; - a0
_FindLocalItem      = -$d2  ; - a0,d0,d1,d2
_StoreLocalItem     = -$d8  ; - a0,a1,d0
_StoreItemInContext = -$de  ; - a0,a1,a2
_InitIFF            = -$e4  ; - a0,d0,a1
_InitIFFasDOS       = -$ea  ; - a0
_InitIFFasClip      = -$f0  ; - a0
_OpenClipboard      = -$f6  ; - d0
_CloseClipboard     = -$fc  ; - a0
_GoodID             = -$102 ; - d0
_GoodType           = -$108 ; - d0
_IDtoStr            = -$10e ; - d0,a0


;****************************************************
;                  input.library
;****************************************************

_PeekQualifier = -$2a  ; -


;****************************************************
;                intuition.library
;****************************************************

_OpenIntuition        = -$1e  ; -
_Intuition            = -$24  ; - a0
_AddGadget            = -$2a  ; - a0,a1,d0
_ClearDMRequest       = -$30  ; - a0
_ClearMenuStrip       = -$36  ; - a0
_ClearPointer         = -$3c  ; - a0
_CloseScreen          = -$42  ; - a0
_CloseWindow          = -$48  ; - a0
_CloseWorkBench       = -$4e  ; -
_CurrentTime          = -$54  ; - a0,a1
_DisplayAlert         = -$5a  ; - d0,a0,d1
_DisplayBeep          = -$60  ; - a0
_DoubleClick          = -$66  ; - d0,d1,d2,d3
_DrawBorder           = -$6c  ; - a0,a1,d0,d1
_DrawImage            = -$72  ; - a0,a1,d0,d1
_EndRequest           = -$78  ; - a0,a1
_GetDefPrefs          = -$7e  ; - a0,d0
_GetPrefs             = -$84  ; - a0,d0
_InitRequester        = -$8a  ; - a0
_ItemAddress          = -$90  ; - a0,d0
_ModifyIDCMP          = -$96  ; - a0,d0
_ModifyProp           = -$9c  ; - a0,a1,a2,d0,d1,d2,d3,d4
_MoveScreen           = -$a2  ; - a0,d0,d1
_MoveWindow           = -$a8  ; - a0,d0,d1
_OffGadget            = -$ae  ; - a0,a1,a2
_OffMenu              = -$b4  ; - a0,d0
_OnGadget             = -$ba  ; - a0,a1,a2
_OnMenu               = -$c0  ; - a0,d0
_OpenScreen           = -$c6  ; - a0
_OpenWindow           = -$cc  ; - a0
_OpenWorkBench        = -$d2  ; -
_PrintIText           = -$d8  ; - a0,a1,d0,d1
_RefreshGadgets       = -$de  ; - a0,a1,a2
_RemoveGadget         = -$e4  ; - a0,a1
_ReportMouse          = -$ea  ; - d0,a0
_Request              = -$f0  ; - a0,a1
_ScreenToBack         = -$f6  ; - a0
_ScreenToFront        = -$fc  ; - a0
_SetDMRequest         = -$102 ; - a0,a1
_SetMenuStrip         = -$108 ; - a0,a1
_SetPointer           = -$10e ; - a0,a1,d0,d1,d2,d3
_SetWindowTitles      = -$114 ; - a0,a1,a2
_ShowTitle            = -$11a ; - a0,d0
_SizeWindow           = -$120 ; - a0,d0,d1
_ViewAddress          = -$126 ; -
_ViewPortAddress      = -$12c ; - a0
_WindowToBack         = -$132 ; - a0
_WindowToFront        = -$138 ; - a0
_WindowLimits         = -$13e ; - a0,d0,d1,d2,d3
_SetPrefs             = -$144 ; - a0,d0,d1
_IntuiTextLength      = -$14a ; - a0
_WBenchToBack         = -$150 ; -
_WBenchToFront        = -$156 ; -
_AutoRequest          = -$15c ; - a0,a1,a2,a3,d0,d1,d2,d3
_BeginRefresh         = -$162 ; - a0
_BuildSysRequest      = -$168 ; - a0,a1,a2,a3,d0,d1,d2
_EndRefresh           = -$16e ; - a0,d0
_FreeSysRequest       = -$174 ; - a0
_MakeScreen           = -$17a ; - a0
_RemakeDisplay        = -$180 ; -
_RethinkDisplay       = -$186 ; -
_AllocRemember        = -$18c ; - a0,d0,d1
_AlohaWorkbench       = -$192 ; - a0
_FreeRemember         = -$198 ; - a0,d0
_LockIBase            = -$19e ; - d0
_UnlockIBase          = -$1a4 ; - a0
_GetScreenData        = -$1aa ; - a0,d0,d1,a1
_RefreshGList         = -$1b0 ; - a0,a1,a2,d0
_AddGList             = -$1b6 ; - a0,a1,d0,d1,a2
_RemoveGList          = -$1bc ; - a0,a1,d0
_ActivateWindow       = -$1c2 ; - a0
_RefreshWindowFrame   = -$1c8 ; - a0
_ActivateGadget       = -$1ce ; - a0,a1,a2
_NewModifyProp        = -$1d4 ; - a0,a1,a2,d0,d1,d2,d3,d4,d5
_QueryOverscan        = -$1da ; - a0,a1,d0
_MoveWindowInFrontOf  = -$1e0 ; - a0,a1
_ChangeWindowBox      = -$1e6 ; - a0,d0,d1,d2,d3
_SetEditHook          = -$1ec ; - a0
_SetMouseQueue        = -$1f2 ; - a0,d0
_ZipWindow            = -$1f8 ; - a0
_LockPubScreen        = -$1fe ; - a0
_UnlockPubScreen      = -$204 ; - a0,a1
_LockPubScreenList    = -$20a ; -
_UnlockPubScreenList  = -$210 ; -
_NextPubScreen        = -$216 ; - a0,a1
_SetDefaultPubScreen  = -$21c ; - a0
_SetPubScreenModes    = -$222 ; - d0
_PubScreenStatus      = -$228 ; - a0,d0
_ObtainGIRPort        = -$22e ; - a0
_ReleaseGIRPort       = -$234 ; - a0
_GadgetMouse          = -$23a ; - a0,a1,a2
_GetDefaultPubScreen  = -$246 ; - a0
_EasyRequestArgs      = -$24c ; - a0,a1,a2,a3
_BuildEasyRequestArgs = -$252 ; - a0,a1,d0,a3
_SysReqHandler        = -$258 ; - a0,a1,d0
_OpenWindowTagList    = -$25e ; - a0,a1
_OpenScreenTagList    = -$264 ; - a0,a1
_DrawImageState       = -$26a ; - a0,a1,d0,d1,d2,a2
_PointInImage         = -$270 ; - d0,a0
_EraseImage           = -$276 ; - a0,a1,d0,d1
_NewObjectA           = -$27c ; - a0,a1,a2
_DisposeObject        = -$282 ; - a0
_SetAttrsA            = -$288 ; - a0,a1
_GetAttr              = -$28e ; - d0,a0,a1
_SetGadgetAttrsA      = -$294 ; - a0,a1,a2,a3
_NextObject           = -$29a ; - a0
_MakeClass            = -$2a6 ; - a0,a1,a2,d0,d1
_AddClass             = -$2ac ; - a0
_GetScreenDrawInfo    = -$2b2 ; - a0
_FreeScreenDrawInfo   = -$2b8 ; - a0,a1
_ResetMenuStrip       = -$2be ; - a0,a1
_RemoveClass          = -$2c4 ; - a0
_FreeClass            = -$2ca ; - a0
_AllocScreenBuffer    = -$300 ; - a0,a1,d0
_FreeScreenBuffer     = -$306 ; - a0,a1
_ChangeScreenBuffer   = -$30c ; - a0,a1
_ScreenDepth          = -$312 ; - a0,d0,a1
_ScreenPosition       = -$318 ; - a0,d0,d1,d2,d3,d4
_ScrollWindowRaster   = -$31e ; - a1,d0,d1,d2,d3,d4,d5
_LendMenus            = -$324 ; - a0,a1
_DoGadgetMethodA      = -$32a ; - a0,a1,a2,a3
_SetWindowPointerA    = -$330 ; - a0,a1
_TimedDisplayAlert    = -$336 ; - d0,a0,d1,a1
_HelpControl          = -$33c ; - a0,d0


;****************************************************
;                  keymap.library
;****************************************************

_SetKeyMapDefault = -$1e  ; - a0
_AskKeyMapDefault = -$24  ; -
_MapRawKey        = -$2a  ; - a0,a1,d1,a2
_MapANSI          = -$30  ; - a0,d0,a1,d1,a2


;****************************************************
;                  layers.library
;****************************************************

_InitLayers               = -$1e  ; - a0
_CreateUpfrontLayer       = -$24  ; - a0,a1,d0,d1,d2,d3,d4,a2
_CreateBehindLayer        = -$2a  ; - a0,a1,d0,d1,d2,d3,d4,a2
_UpfrontLayer             = -$30  ; - a0,a1
_BehindLayer              = -$36  ; - a0,a1
_MoveLayer                = -$3c  ; - a0,a1,d0,d1
_SizeLayer                = -$42  ; - a0,a1,d0,d1
_ScrollLayer              = -$48  ; - a0,a1,d0,d1
_BeginUpdate              = -$4e  ; - a0
_EndUpdate                = -$54  ; - a0,d0
_DeleteLayer              = -$5a  ; - a0,a1
_LockLayer                = -$60  ; - a0,a1
_UnlockLayer              = -$66  ; - a0
_LockLayers               = -$6c  ; - a0
_UnlockLayers             = -$72  ; - a0
_LockLayerInfo            = -$78  ; - a0
_SwapBitsRastPortClipRect = -$7e  ; - a0,a1
_WhichLayer               = -$84  ; - a0,d0,d1
_UnlockLayerInfo          = -$8a  ; - a0
_NewLayerInfo             = -$90  ; -
_DisposeLayerInfo         = -$96  ; - a0
_FattenLayerInfo          = -$9c  ; - a0
_ThinLayerInfo            = -$a2  ; - a0
_MoveLayerInFrontOf       = -$a8  ; - a0,a1
_InstallClipRegion        = -$ae  ; - a0,a1
_MoveSizeLayer            = -$b4  ; - a0,d0,d1,d2,d3
_CreateUpfrontHookLayer   = -$ba  ; - a0,a1,d0,d1,d2,d3,d4,a3,a2
_CreateBehindHookLayer    = -$c0  ; - a0,a1,d0,d1,d2,d3,d4,a3,a2
_InstallLayerHook         = -$c6  ; - a0,a1
_InstallLayerInfoHook     = -$cc  ; - a0,a1
_SortLayerCR              = -$d2  ; - a0,d0,d1
_DoHookClipRects          = -$d8  ; - a0,a1,a2


;****************************************************
;                  locale.library
;****************************************************

_CloseCatalog  = -$24  ; - a0
_CloseLocale   = -$2a  ; - a0
_ConvToLower   = -$30  ; - a0,d0
_ConvToUpper   = -$36  ; - a0,d0
_FormatDate    = -$3c  ; - a0,a1,a2,a3
_FormatString  = -$42  ; - a0,a1,a2,a3
_GetCatalogStr = -$48  ; - a0,d0,a1
_GetLocaleStr  = -$4e  ; - a0,d0
_IsAlNum       = -$54  ; - a0,d0
_IsAlpha       = -$5a  ; - a0,d0
_IsCntrl       = -$60  ; - a0,d0
_IsDigit       = -$66  ; - a0,d0
_IsGraph       = -$6c  ; - a0,d0
_IsLower       = -$72  ; - a0,d0
_IsPrint       = -$78  ; - a0,d0
_IsPunct       = -$7e  ; - a0,d0
_IsSpace       = -$84  ; - a0,d0
_IsUpper       = -$8a  ; - a0,d0
_IsXDigit      = -$90  ; - a0,d0
_OpenCatalogA  = -$96  ; - a0,a1,a2
_OpenLocale    = -$9c  ; - a0
_ParseDate     = -$a2  ; - a0,a1,a2,a3
_StrConvert    = -$ae  ; - a0,a1,a2,d0,d1
_StrnCmp       = -$b4  ; - a0,a1,a2,d0,d1


;****************************************************
;                 lowlevel.library
;****************************************************

_ReadJoyPort          = -$1e  ; - d0
_GetLanguageSelection = -$24  ; -
_GetKey               = -$30  ; -
_QueryKeys            = -$36  ; - a0,d1
_AddKBInt             = -$3c  ; - a0,a1
_RemKBInt             = -$42  ; - a1
_SystemControlA       = -$48  ; - a1
_AddTimerInt          = -$4e  ; - a0,a1
_RemTimerInt          = -$54  ; - a1
_StopTimerInt         = -$5a  ; - a1
_StartTimerInt        = -$60  ; - a1,d0,d1
_ElapsedTime          = -$66  ; - a0
_AddVBlankInt         = -$6c  ; - a0,a1
_RemVBlankInt         = -$72  ; - a1
_SetJoyPortAttrsA     = -$84  ; - d0,a1


;****************************************************
;                 mathffp.library
;****************************************************

_SPFix   = -$1e  ; - d0
_SPFlt   = -$24  ; - d0
_SPCmp   = -$2a  ; - d1,d0
_SPTst   = -$30  ; - d1
_SPAbs   = -$36  ; - d0
_SPNeg   = -$3c  ; - d0
_SPAdd   = -$42  ; - d1,d0
_SPSub   = -$48  ; - d1,d0
_SPMul   = -$4e  ; - d1,d0
_SPDiv   = -$54  ; - d1,d0
_SPFloor = -$5a  ; - d0
_SPCeil  = -$60  ; - d0



_CloseSocket = -120
_Dup2Socket = -264
_Errno = -162
_GetSocketEvents = -300
_Inet_LnaOf = -186
_Inet_MakeAddr = -198
_Inet_NetOf = -192
_Inet_NtoA = -174
_IoctlSocket = -114
_ObtainSocket = -144
_ReleaseCopyOfSocket = -156
_ReleaseSocket = -150
_SetErrnoPtr = -168
_SetSocketSignals = -132
_SocketBaseTagList = -294
_WaitSelect = -126
_accept = -48
_bind = -36
_connect = -54
_getdtablesize = -138
_gethostbyaddr = -216
_gethostbyname = -210
_gethostid = -288
_gethostname = -282
_getnetbyaddr = -228
_getnetbyname = -222
_getpeername = -108
_getprotobyname = -246
_getprotobynumber = -252
_getservbyname = -234
_getservbyport = -240
_getsockname = -102
_getsockopt = -96
_inet_addr = -180
_inet_network = -204
_listen = -42
_recv = -78
_recvfrom = -72
_recvmsg = -276
_send = -66
_sendmsg = -270
_sendto = -60
_setsockopt = -90
_shutdown = -84
_socket = -30
_vsyslog = -258
