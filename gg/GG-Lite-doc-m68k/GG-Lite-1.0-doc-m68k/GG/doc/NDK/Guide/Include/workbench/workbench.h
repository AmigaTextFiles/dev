@DATABASE "gg:doc/NDK/Guide/Include/workbench/workbench.h"
@MASTER   "gg:os-include/workbench/workbench.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "workbench/workbench.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"workbench/workbench.h" LINK File}


@{b}Structures@{ub}

@{"AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163}            @{"AppIconRenderMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 454}      @{"AppMenu" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 165}
@{"AppMenuItem" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 164}        @{"AppMessage" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 116}            @{"AppWindow" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 161}
@{"AppWindowDropZone" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 162}  @{"AppWindowDropZoneMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 475}  @{"CopyBeginMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 545}
@{"CopyDataMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 553}        @{"CopyEndMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 585}            @{"DeleteBeginMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 604}
@{"DeleteDataMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 612}      @{"DeleteEndMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 627}          @{"DiskObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 65}
@{"DrawerData" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 42}         @{"FreeList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 86}              @{"IconSelectMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 490}
@{"OldDrawerData" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 34}      @{"SetupCleanupHookMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 376}   @{"TextInputMsg" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 662}


@{b}#defines@{ub}

@{"ADZMACTION_Enter" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 484}                @{"ADZMACTION_Leave" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 485}
@{"AM_VERSION" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 114}                      @{"AMCLASSICON_Copy" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 143}
@{"AMCLASSICON_Delete" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 150}              @{"AMCLASSICON_EmptyTrash" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 152}
@{"AMCLASSICON_FormatDisk" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 151}          @{"AMCLASSICON_Information" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 145}
@{"AMCLASSICON_LeaveOut" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 148}            @{"AMCLASSICON_Open" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 139}
@{"AMCLASSICON_PutAway" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 149}             @{"AMCLASSICON_Rename" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 144}
@{"AMCLASSICON_Selected" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 154}            @{"AMCLASSICON_Snapshot" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 146}
@{"AMCLASSICON_Unselected" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 155}          @{"AMCLASSICON_UnSnapshot" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 147}
@{"AMTYPE_APPICON" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 134}                  @{"AMTYPE_APPMENUITEM" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 135}
@{"AMTYPE_APPWINDOW" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 133}                @{"AMTYPE_APPWINDOWZONE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 136}
@{"CPACTION_Begin" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 591}                  @{"CPACTION_Copy" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 594}
@{"CPACTION_End" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 597}                    @{"DDFLAGS_SHOWALL" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 63}
@{"DDFLAGS_SHOWDEFAULT" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 61}             @{"DDFLAGS_SHOWICONS" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 62}
@{"DDVM_BYDATE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 56}                     @{"DDVM_BYDEFAULT" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 53}
@{"DDVM_BYICON" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 54}                     @{"DDVM_BYNAME" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 55}
@{"DDVM_BYSIZE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 57}                     @{"DDVM_BYTYPE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 58}
@{"DLACTION_BeginDiscard" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 633}           @{"DLACTION_BeginEmptyTrash" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 640}
@{"DLACTION_DeleteContents" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 644}         @{"DLACTION_DeleteObject" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 650}
@{"DLACTION_End" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 655}                    @{"DRAWERDATAFILESIZE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 50}
@{"GADGBACKFILL" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 99}                    @{"GFLG_GADGBACKFILL" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 98}
@{"ISMACTION_Ignore" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 537}                @{"ISMACTION_Select" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 536}
@{"ISMACTION_Stop" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 538}                  @{"ISMACTION_Unselect" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 535}
@{"NO_ICON_POSITION" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 104}                @{"OLDDRAWERDATAFILESIZE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 40}
@{"SCHMSTATE_Cleanup" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 383}               @{"SCHMSTATE_Setup" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 384}
@{"SCHMSTATE_TryCleanup" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 382}            @{"TIACTION_Execute" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 683}
@{"TIACTION_NewDrawer" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 682}              @{"TIACTION_RelabelVolume" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 681}
@{"TIACTION_Rename" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 678}                 @{"UPDATEWB_ObjectAdded" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 692}
@{"UPDATEWB_ObjectRemoved" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 691}          @{"WB_DISKMAGIC" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 80}
@{"WB_DISKREVISION" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 82}                 @{"WB_DISKREVISIONMASK" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 84}
@{"WB_DISKVERSION" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 81}                  @{"WBA_Dummy" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 169}
@{"WBA_LAST_TAG" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 449}                    @{"WBA_Reserved1" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 425}
@{"WBA_Reserved10" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 434}                  @{"WBA_Reserved11" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 435}
@{"WBA_Reserved12" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 436}                  @{"WBA_Reserved13" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 437}
@{"WBA_Reserved14" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 438}                  @{"WBA_Reserved15" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 439}
@{"WBA_Reserved16" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 440}                  @{"WBA_Reserved17" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 441}
@{"WBA_Reserved18" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 442}                  @{"WBA_Reserved19" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 443}
@{"WBA_Reserved2" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 426}                   @{"WBA_Reserved20" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 444}
@{"WBA_Reserved21" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 445}                  @{"WBA_Reserved3" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 427}
@{"WBA_Reserved4" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 428}                   @{"WBA_Reserved5" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 429}
@{"WBA_Reserved6" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 430}                   @{"WBA_Reserved7" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 431}
@{"WBA_Reserved8" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 432}                   @{"WBA_Reserved9" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 433}
@{"WBAPPICON" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 32}                       @{"WBAPPICONA_NotifySelectState" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 215}
@{"WBAPPICONA_PropagatePosition" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 209}    @{"WBAPPICONA_RenderHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 212}
@{"WBAPPICONA_SupportsCopy" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 179}         @{"WBAPPICONA_SupportsDelete" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 200}
@{"WBAPPICONA_SupportsEmptyTrash" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 206}   @{"WBAPPICONA_SupportsFormatDisk" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 203}
@{"WBAPPICONA_SupportsInformation" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 185}  @{"WBAPPICONA_SupportsLeaveOut" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 194}
@{"WBAPPICONA_SupportsOpen" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 176}         @{"WBAPPICONA_SupportsPutAway" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 197}
@{"WBAPPICONA_SupportsRename" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 182}       @{"WBAPPICONA_SupportsSnapshot" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 188}
@{"WBAPPICONA_SupportsUnSnapshot" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 191}   @{"WBAPPMENUA_CommandKeyString" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 222}
@{"WBAPPMENUA_GetKey" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 227}               @{"WBAPPMENUA_GetTitleKey" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 237}
@{"WBAPPMENUA_UseKey" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 232}               @{"WBCTRLA_AddHiddenDeviceName" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 311}
@{"WBCTRLA_AddSetupCleanupHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 366}     @{"WBCTRLA_DuplicateSearchPath" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 270}
@{"WBCTRLA_FreeHiddenDeviceList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 306}    @{"WBCTRLA_FreeOpenDrawerList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 300}
@{"WBCTRLA_FreeProgramList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 288}         @{"WBCTRLA_FreeSearchPath" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 273}
@{"WBCTRLA_FreeSelectedIconList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 294}    @{"WBCTRLA_GetCopyHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 331}
@{"WBCTRLA_GetDefaultStackSize" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 276}     @{"WBCTRLA_GetDeleteHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 342}
@{"WBCTRLA_GetHiddenDeviceList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 303}     @{"WBCTRLA_GetOpenDrawerList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 297}
@{"WBCTRLA_GetProgramList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 285}          @{"WBCTRLA_GetSelectedIconList" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 291}
@{"WBCTRLA_GetTextInputHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 354}        @{"WBCTRLA_GetTypeRestartTime" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 320}
@{"WBCTRLA_IsOpen" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 267}                  @{"WBCTRLA_RedrawAppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 282}
@{"WBCTRLA_RemoveHiddenDeviceName" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 314}  @{"WBCTRLA_RemSetupCleanupHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 371}
@{"WBCTRLA_SetCopyHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 336}             @{"WBCTRLA_SetDefaultStackSize" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 279}
@{"WBCTRLA_SetDeleteHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 348}           @{"WBCTRLA_SetTextInputHook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 360}
@{"WBCTRLA_SetTypeRestartTime" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 326}      @{"WBDEVICE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 30}
@{"WBDISK" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 25}                          @{"WBDRAWER" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 26}
@{"WBDZA_Box" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 417}                       @{"WBDZA_Height" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 411}
@{"WBDZA_Hook" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 420}                      @{"WBDZA_Left" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 393}
@{"WBDZA_RelBottom" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 402}                 @{"WBDZA_RelHeight" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 414}
@{"WBDZA_RelRight" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 396}                  @{"WBDZA_RelWidth" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 408}
@{"WBDZA_Top" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 399}                       @{"WBDZA_Width" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 405}
@{"WBGARBAGE" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 29}                       @{"WBKICK" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 31}
@{"WBOPENA_ArgLock" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 244}                 @{"WBOPENA_ArgName" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 247}
@{"WBOPENA_Show" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 253}                    @{"WBOPENA_ViewBy" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 260}
@{"WBPROJECT" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 28}                       @{"WBTOOL" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 27}
@{"WORKBENCH_NAME" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 107}                  

@ENDNODE
@NODE File "workbench/workbench.h"
#ifndef WORKBENCH_WORKBENCH_H
#define WORKBENCH_WORKBENCH_H
/*
**      $VER: workbench.h 45.6 (23.11.2000)
**      Includes Release 45.1
**
**      @{"workbench.library" LINK "gg:doc/NDK/Guide/wb/MAIN"} general definitions
**
**      Copyright © 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TASKS_H
#include <@{"exec/tasks.h" LINK "gg:doc/NDK/Guide/Include/exec/tasks.h/File"}>
#endif

#ifndef DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

#define WBDISK          1
#define WBDRAWER        2
#define WBTOOL          3
#define WBPROJECT       4
#define WBGARBAGE       5
#define WBDEVICE        6
#define WBKICK          7
#define WBAPPICON       8

struct OldDrawerData { /* pre V36 definition */
    @{"struct NewWindow" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1087}    dd_NewWindow;   /* args to open window */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dd_CurrentX;    /* current x coordinate of origin */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dd_CurrentY;    /* current y coordinate of origin */
};
/* the amount of DrawerData actually written to disk */
#define OLDDRAWERDATAFILESIZE   (sizeof(@{"struct OldDrawerData" LINK File 34}))

struct DrawerData {
    @{"struct NewWindow" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1087}    dd_NewWindow;   /* args to open window */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dd_CurrentX;    /* current x coordinate of origin */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                dd_CurrentY;    /* current y coordinate of origin */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               dd_Flags;       /* flags for drawer */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}               dd_ViewModes;   /* view mode for drawer */
};
/* the amount of DrawerData actually written to disk */
#define DRAWERDATAFILESIZE      (sizeof(@{"struct DrawerData" LINK File 42}))

/* definitions for dd_ViewModes */
#define DDVM_BYDEFAULT          0       /* default (inherit parent's view mode) */
#define DDVM_BYICON             1       /* view as icons */
#define DDVM_BYNAME             2       /* view as text, sorted by name */
#define DDVM_BYDATE             3       /* view as text, sorted by date */
#define DDVM_BYSIZE             4       /* view as text, sorted by size */
#define DDVM_BYTYPE             5       /* view as text, sorted by type */

/* definitions for dd_Flags */
#define DDFLAGS_SHOWDEFAULT     0       /* default (show only icons) */
#define DDFLAGS_SHOWICONS       1       /* show only icons */
#define DDFLAGS_SHOWALL         2       /* show all files */

struct DiskObject {
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}               do_Magic; /* a magic number at the start of the file */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}               do_Version; /* a version number, so we can change it */
    @{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214}       do_Gadget;      /* a copy of in core gadget */
    @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}               do_Type;
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}              do_DefaultTool;
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} *            do_ToolTypes;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                do_CurrentX;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                do_CurrentY;
    @{"struct DrawerData" LINK File 42} * do_DrawerData;
    @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}              do_ToolWindow;  /* only applies to tools */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                do_StackSize;   /* only applies to tools */

};

#define WB_DISKMAGIC    0xe310  /* a magic number, not easily impersonated */
#define WB_DISKVERSION  1       /* our current version number */
#define WB_DISKREVISION 1       /* our current revision number */
/* I only use the lower 8 bits of Gadget.UserData for the revision # */
#define WB_DISKREVISIONMASK     255

struct FreeList {
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                fl_NumFree;
    @{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20}         fl_MemList;
};

/* workbench does different complement modes for its gadgets.
** It supports separate images, complement mode, and backfill mode.
** The first two are identical to intuitions @{"GFLG_GADGIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 297} and @{"GFLG_GADGHCOMP" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 292}.
** backfill is similar to @{"GFLG_GADGHCOMP" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 292}, but the region outside of the
** image (which normally would be color three when complemented)
** is flood-filled to color zero.
*/
#define GFLG_GADGBACKFILL 0x0001
#define GADGBACKFILL      0x0001    /* an old synonym */

/* if an icon does not really live anywhere, set its current position
** to here
*/
#define NO_ICON_POSITION        (0x80000000)

/* workbench now is a library.  this is it's name */
#define WORKBENCH_NAME          "workbench.library"

/****************************************************************************/

/* If you find am_Version >= @{"AM_VERSION" LINK File 114}, you know this structure has
 * at least the fields defined in this version of the include file
 */
#define AM_VERSION      1

struct AppMessage {
    @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47} am_Message;  /* standard message structure */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} am_Type;              /* message type */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} am_UserData;          /* application specific */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} am_ID;                /* application definable ID */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} am_NumArgs;            /* # of elements in arglist */
    @{"struct WBArg" LINK "gg:doc/NDK/Guide/Include/workbench/startup.h/File" 34} *am_ArgList;   /* the arguments themselves */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} am_Version;           /* will be >= @{"AM_VERSION" LINK File 114} */
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} am_Class;             /* message class */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} am_MouseX;             /* mouse x position of event */
    @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} am_MouseY;             /* mouse y position of event */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} am_Seconds;           /* current system clock time */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} am_Micros;            /* current system clock time */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} am_Reserved[8];       /* avoid recompilation */
};

/* types of app messages */
#define AMTYPE_APPWINDOW        7       /* app window message    */
#define AMTYPE_APPICON          8       /* app icon message      */
#define AMTYPE_APPMENUITEM      9       /* app menu item message */
#define AMTYPE_APPWINDOWZONE   10       /* app window drop zone message    */

/* Classes of AppIcon messages (V44) */
#define AMCLASSICON_Open        0       /* The "Open" menu item was invoked,
                                         * the icon got double-clicked or an
                                         * icon got dropped on it.
                                         */
#define AMCLASSICON_Copy        1       /* The "Copy" menu item was invoked */
#define AMCLASSICON_Rename      2       /* The "Rename" menu item was invoked */
#define AMCLASSICON_Information 3       /* The "Information" menu item was invoked */
#define AMCLASSICON_Snapshot    4       /* The "Snapshot" menu item was invoked */
#define AMCLASSICON_UnSnapshot  5       /* The "UnSnapshot" menu item was invoked */
#define AMCLASSICON_LeaveOut    6       /* The "Leave Out" menu item was invoked */
#define AMCLASSICON_PutAway     7       /* The "Put Away" menu item was invoked */
#define AMCLASSICON_Delete      8       /* The "Delete" menu item was invoked */
#define AMCLASSICON_FormatDisk  9       /* The "Format Disk" menu item was invoked */
#define AMCLASSICON_EmptyTrash  10      /* The "Empty Trash" menu item was invoked */

#define AMCLASSICON_Selected    11      /* The icon is now selected */
#define AMCLASSICON_Unselected  12      /* The icon is now unselected */

/*
 * The following structures are private.  These are just stub
 * structures for code compatibility...
 */
struct AppWindow                { void * aw_PRIVATE;   };
struct AppWindowDropZone        { void * awdz_PRIVATE; };
struct AppIcon                  { void * ai_PRIVATE;   };
struct AppMenuItem              { void * ami_PRIVATE;  };
struct AppMenu                  { void * am_PRIVATE;  };

/****************************************************************************/

#define WBA_Dummy (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0xA000)

/****************************************************************************/

/* Tags for use with @{"AddAppIconA()" LINK "gg:doc/NDK/Guide/wb/AddAppIconA"} */

/* AppIcon responds to the "Open" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsOpen         (@{"WBA_Dummy" LINK File 169}+1)

/* AppIcon responds to the "Copy" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsCopy         (@{"WBA_Dummy" LINK File 169}+2)

/* AppIcon responds to the "Rename" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsRename       (@{"WBA_Dummy" LINK File 169}+3)

/* AppIcon responds to the "Information" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsInformation  (@{"WBA_Dummy" LINK File 169}+4)

/* AppIcon responds to the "Snapshot" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsSnapshot     (@{"WBA_Dummy" LINK File 169}+5)

/* AppIcon responds to the "UnSnapshot" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsUnSnapshot   (@{"WBA_Dummy" LINK File 169}+6)

/* AppIcon responds to the "LeaveOut" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsLeaveOut     (@{"WBA_Dummy" LINK File 169}+7)

/* AppIcon responds to the "PutAway" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsPutAway      (@{"WBA_Dummy" LINK File 169}+8)

/* AppIcon responds to the "Delete" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsDelete       (@{"WBA_Dummy" LINK File 169}+9)

/* AppIcon responds to the "FormatDisk" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsFormatDisk   (@{"WBA_Dummy" LINK File 169}+10)

/* AppIcon responds to the "EmptyTrash" menu item (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_SupportsEmptyTrash   (@{"WBA_Dummy" LINK File 169}+11)

/* AppIcon position should be propagated back to original DiskObject (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_PropagatePosition    (@{"WBA_Dummy" LINK File 169}+12)

/* Callback hook to be invoked when rendering this icon (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *). */
#define WBAPPICONA_RenderHook           (@{"WBA_Dummy" LINK File 169}+13)

/* AppIcon wants to be notified when its select state changes (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}). */
#define WBAPPICONA_NotifySelectState    (@{"WBA_Dummy" LINK File 169}+14)

/****************************************************************************/

/* Tags for use with AddAppMenuA() */

/* Command key string for this AppMenu (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}). */
#define WBAPPMENUA_CommandKeyString      (@{"WBA_Dummy" LINK File 169}+15)

/* Item to be added should get sub menu items attached to; make room for it,
 * then return the key to use later for attaching the items (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *).
 */
#define WBAPPMENUA_GetKey               (@{"WBA_Dummy" LINK File 169}+65)

/* This item should be attached to a sub menu; the key provided refers to
 * the sub menu it should be attached to (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}).
 */
#define WBAPPMENUA_UseKey               (@{"WBA_Dummy" LINK File 169}+66)

/* Item to be added is in fact a new menu title; make room for it, then
 * return the key to use later for attaching the items (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *).
 */
#define WBAPPMENUA_GetTitleKey          (@{"WBA_Dummy" LINK File 169}+77)

/****************************************************************************/

/* Tags for use with @{"OpenWorkbenchObjectA()" LINK "gg:doc/NDK/Guide/wb/OpenWorkbenchObjectA"} */

/* Corresponds to the wa_Lock member of a @{"struct WBArg" LINK "gg:doc/NDK/Guide/Include/workbench/startup.h/File" 34} */
#define WBOPENA_ArgLock                 (@{"WBA_Dummy" LINK File 169}+16)

/* Corresponds to the wa_Name member of a @{"struct WBArg" LINK "gg:doc/NDK/Guide/Include/workbench/startup.h/File" 34} */
#define WBOPENA_ArgName                 (@{"WBA_Dummy" LINK File 169}+17)

/* When opening a drawer, show all files or only icons?
 * This must be one out of @{"DDFLAGS_SHOWICONS" LINK File 62},
 * or @{"DDFLAGS_SHOWALL" LINK File 63}; (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}); (V45)
 */
#define WBOPENA_Show                    (@{"WBA_Dummy" LINK File 169}+75)

/* When opening a drawer, view the contents by icon, name,
 * date, size or type? This must be one out of @{"DDVM_BYICON" LINK File 54},
 * @{"DDVM_BYNAME" LINK File 55}, @{"DDVM_BYDATE" LINK File 56}, @{"DDVM_BYSIZE" LINK File 57} or @{"DDVM_BYTYPE" LINK File 58};
 * (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}); (V45)
 */
#define WBOPENA_ViewBy                  (@{"WBA_Dummy" LINK File 169}+76)

/****************************************************************************/

/* Tags for use with @{"WorkbenchControlA()" LINK "gg:doc/NDK/Guide/wb/WorkbenchControlA"} */

/* Check if the named drawer is currently open (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *). */
#define WBCTRLA_IsOpen                  (@{"WBA_Dummy" LINK File 169}+18)

/* Create a duplicate of the Workbench private search path list (@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} *). */
#define WBCTRLA_DuplicateSearchPath     (@{"WBA_Dummy" LINK File 169}+19)

/* Free the duplicated search path list (@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}). */
#define WBCTRLA_FreeSearchPath          (@{"WBA_Dummy" LINK File 169}+20)

/* Get the default stack size for launching programs with (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *). */
#define WBCTRLA_GetDefaultStackSize     (@{"WBA_Dummy" LINK File 169}+21)

/* Set the default stack size for launching programs with (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}). */
#define WBCTRLA_SetDefaultStackSize     (@{"WBA_Dummy" LINK File 169}+22)

/* Cause an AppIcon to be redrawn (@{"struct AppIcon" LINK "gg:doc/NDK/Guide/Include/workbench/workbench.h/File" 163} *). */
#define WBCTRLA_RedrawAppIcon           (@{"WBA_Dummy" LINK File 169}+23)

/* Get a list of currently running Workbench programs (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} **). */
#define WBCTRLA_GetProgramList          (@{"WBA_Dummy" LINK File 169}+24)

/* Release the list of currently running Workbench programs (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *). */
#define WBCTRLA_FreeProgramList         (@{"WBA_Dummy" LINK File 169}+25)

/* Get a list of currently selected icons (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} **). */
#define WBCTRLA_GetSelectedIconList     (@{"WBA_Dummy" LINK File 169}+36)

/* Release the list of currently selected icons (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *). */
#define WBCTRLA_FreeSelectedIconList    (@{"WBA_Dummy" LINK File 169}+37)

/* Get a list of currently open drawers (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} **). */
#define WBCTRLA_GetOpenDrawerList       (@{"WBA_Dummy" LINK File 169}+38)

/* Release the list of currently open icons (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *). */
#define WBCTRLA_FreeOpenDrawerList      (@{"WBA_Dummy" LINK File 169}+39)

/* Get the list of hidden devices (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} **). */
#define WBCTRLA_GetHiddenDeviceList     (@{"WBA_Dummy" LINK File 169}+42)

/* Release the list of hidden devices (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *). */
#define WBCTRLA_FreeHiddenDeviceList    (@{"WBA_Dummy" LINK File 169}+43)

/* Add the name of a device which Workbench should never try to
 * read a disk icon from (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}).
 */
#define WBCTRLA_AddHiddenDeviceName     (@{"WBA_Dummy" LINK File 169}+44)

/* Remove a name from list of hidden devices (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}). */
#define WBCTRLA_RemoveHiddenDeviceName  (@{"WBA_Dummy" LINK File 169}+45)

/* Get the number of seconds that have to pass before typing
 * the next character in a drawer window will restart
 * with a new file name (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *).
 */
#define WBCTRLA_GetTypeRestartTime      (@{"WBA_Dummy" LINK File 169}+47)

/* Set the number of seconds that have to pass before typing
 * the next character in a drawer window will restart
 * with a new file name (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}).
 */
#define WBCTRLA_SetTypeRestartTime      (@{"WBA_Dummy" LINK File 169}+48)

/* Obtain the hook that will be invoked when Workbench starts
 * to copy files and data (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} **); (V45)
 */
#define WBCTRLA_GetCopyHook             (@{"WBA_Dummy" LINK File 169}+69)

/* Install the hook that will be invoked when Workbench starts
 * to copy files and data (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *); (V45)
 */
#define WBCTRLA_SetCopyHook             (@{"WBA_Dummy" LINK File 169}+70)

/* Obtain the hook that will be invoked when Workbench discards
 * files and drawers or empties the trashcan (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} **);
 * (V45).
 */
#define WBCTRLA_GetDeleteHook           (@{"WBA_Dummy" LINK File 169}+71)

/* Install the hook that will be invoked when Workbench discards
 * files and drawers or empties the trashcan (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *);
 * (V45).
 */
#define WBCTRLA_SetDeleteHook           (@{"WBA_Dummy" LINK File 169}+72)

/* Obtain the hook that will be invoked when Workbench requests
 * that the user enters text, such as when a file is to be renamed
 * or a new drawer is to be created (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} **); (V45)
 */
#define WBCTRLA_GetTextInputHook        (@{"WBA_Dummy" LINK File 169}+73)

/* Install the hook that will be invoked when Workbench requests
 * that the user enters text, such as when a file is to be renamed
 * or a new drawer is to be created (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *); (V45)
 */
#define WBCTRLA_SetTextInputHook        (@{"WBA_Dummy" LINK File 169}+74)

/* Add a hook that will be invoked when Workbench is about
 * to shut down (cleanup), and when Workbench has returned
 * to operational state (setup) (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *); (V45)
 */
#define WBCTRLA_AddSetupCleanupHook     (@{"WBA_Dummy" LINK File 169}+78)

/* Remove a hook that has been installed with the
 * @{"WBCTRLA_AddSetupCleanupHook" LINK File 366} tag (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *); (V45)
 */
#define WBCTRLA_RemSetupCleanupHook     (@{"WBA_Dummy" LINK File 169}+79)

/****************************************************************************/

/* The message your setup/cleanup hook gets invoked with. */
struct SetupCleanupHookMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   schm_Length;    /* Size of this data structure (in bytes). */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    schm_State;     /* See below for definitions. */
};

#define SCHMSTATE_TryCleanup    0       /* Workbench will attempt to shut down now. */
#define SCHMSTATE_Cleanup       1       /* Workbench will really shut down now. */
#define SCHMSTATE_Setup         2       /* Workbench is operational again or
                                         * could not be shut down.
                                         */

/****************************************************************************/

/* Tags for use with @{"AddAppWindowDropZoneA()" LINK "gg:doc/NDK/Guide/wb/AddAppWindowDropZoneA"} */

/* Zone left edge (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_Left      (@{"WBA_Dummy" LINK File 169}+26)

/* Zone left edge, if relative to the right edge of the window (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_RelRight  (@{"WBA_Dummy" LINK File 169}+27)

/* Zone top edge (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_Top       (@{"WBA_Dummy" LINK File 169}+28)

/* Zone top edge, if relative to the bottom edge of the window (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_RelBottom (@{"WBA_Dummy" LINK File 169}+29)

/* Zone width (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_Width     (@{"WBA_Dummy" LINK File 169}+30)

/* Zone width, if relative to the window width (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_RelWidth  (@{"WBA_Dummy" LINK File 169}+31)

/* Zone height (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_Height    (@{"WBA_Dummy" LINK File 169}+32)

/* Zone height, if relative to the window height (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) */
#define WBDZA_RelHeight (@{"WBA_Dummy" LINK File 169}+33)

/* Zone position and size (@{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *). */
#define WBDZA_Box       (@{"WBA_Dummy" LINK File 169}+34)

/* Hook to invoke when the mouse enters or leave a drop zone (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *). */
#define WBDZA_Hook      (@{"WBA_Dummy" LINK File 169}+35)

/****************************************************************************/

/* Reserved tags; don't use! */
#define WBA_Reserved1   (@{"WBA_Dummy" LINK File 169}+40)
#define WBA_Reserved2   (@{"WBA_Dummy" LINK File 169}+41)
#define WBA_Reserved3   (@{"WBA_Dummy" LINK File 169}+46)
#define WBA_Reserved4   (@{"WBA_Dummy" LINK File 169}+49)
#define WBA_Reserved5   (@{"WBA_Dummy" LINK File 169}+50)
#define WBA_Reserved6   (@{"WBA_Dummy" LINK File 169}+51)
#define WBA_Reserved7   (@{"WBA_Dummy" LINK File 169}+52)
#define WBA_Reserved8   (@{"WBA_Dummy" LINK File 169}+53)
#define WBA_Reserved9   (@{"WBA_Dummy" LINK File 169}+54)
#define WBA_Reserved10  (@{"WBA_Dummy" LINK File 169}+55)
#define WBA_Reserved11  (@{"WBA_Dummy" LINK File 169}+56)
#define WBA_Reserved12  (@{"WBA_Dummy" LINK File 169}+57)
#define WBA_Reserved13  (@{"WBA_Dummy" LINK File 169}+58)
#define WBA_Reserved14  (@{"WBA_Dummy" LINK File 169}+59)
#define WBA_Reserved15  (@{"WBA_Dummy" LINK File 169}+60)
#define WBA_Reserved16  (@{"WBA_Dummy" LINK File 169}+61)
#define WBA_Reserved17  (@{"WBA_Dummy" LINK File 169}+62)
#define WBA_Reserved18  (@{"WBA_Dummy" LINK File 169}+63)
#define WBA_Reserved19  (@{"WBA_Dummy" LINK File 169}+64)
#define WBA_Reserved20  (@{"WBA_Dummy" LINK File 169}+67)
#define WBA_Reserved21  (@{"WBA_Dummy" LINK File 169}+68)

/****************************************************************************/

#define WBA_LAST_TAG (@{"WBA_Dummy" LINK File 169}+79)

/****************************************************************************/

/* The message your AppIcon rendering hook gets invoked with. */
struct AppIconRenderMsg
{
        @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *       arm_RastPort;   /* RastPort to render into */
        @{"struct DiskObject" LINK File 65} *     arm_Icon;       /* The icon to be rendered */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}                  arm_Label;      /* The icon label txt */
        @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *        arm_Tags;       /* Further tags to be passed on
                                                 * to @{"DrawIconStateA()" LINK "gg:doc/NDK/Guide/icon/DrawIconStateA"}.
                                                 */

        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    arm_Left;       /* \\ Rendering origin, not taking the */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    arm_Top;        /* / button border into account. */

        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    arm_Width;      /* \\ Limit your rendering to */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    arm_Height;     /* / this area. */

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   arm_State;      /* @{"IDS_SELECTED" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 198}, @{"IDS_NORMAL" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 197}, etc. */
};

/****************************************************************************/

/* The message your drop zone hook gets invoked with. */
struct AppWindowDropZoneMsg
{
        @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *       adzm_RastPort;          /* RastPort to render into. */
        @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896}             adzm_DropZoneBox;       /* Limit your rendering to this area. */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   adzm_ID;                /* \\ These come from straight */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   adzm_UserData;          /* / from @{"AddAppWindowDropZoneA()" LINK "gg:doc/NDK/Guide/wb/AddAppWindowDropZoneA"}. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    adzm_Action;            /* See below for a list of actions. */
};

#define ADZMACTION_Enter        (0)
#define ADZMACTION_Leave        (1)

/****************************************************************************/

/* The message your icon selection change hook is invoked with. */
struct IconSelectMsg
{
        /* Size of this data structure (in bytes). */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   ism_Length;

        /* Lock on the drawer this object resides in,
         * @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} for Workbench backdrop (devices).
         */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}                    ism_Drawer;

        /* Name of the object in question. */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}                  ism_Name;

        /* One of @{"WBDISK" LINK File 25}, @{"WBDRAWER" LINK File 26}, @{"WBTOOL" LINK File 27}, @{"WBPROJECT" LINK File 28},
         * @{"WBGARBAGE" LINK File 29}, @{"WBDEVICE" LINK File 30}, @{"WBKICK" LINK File 31} or @{"WBAPPICON" LINK File 32}.
         */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   ism_Type;

        /* @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} if currently selected, @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98} otherwise. */
        @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}                    ism_Selected;

        /* Pointer to the list of tag items passed to
         * @{"ChangeWorkbenchSelectionA()" LINK "gg:doc/NDK/Guide/wb/ChangeWorkbenchSelectionA"}.
         */
        @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *        ism_Tags;

        /* Pointer to the window attached to this icon,
         * if the icon is a drawer-like object.
         */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *         ism_DrawerWindow;

        /* Pointer to the window the icon resides in. */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *         ism_ParentWindow;

        /* Position and size of the icon; note that the
         * icon may not entirely reside within the visible
         * bounds of the parent window.
         */
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    ism_Left;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    ism_Top;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    ism_Width;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}                    ism_Height;
};

/* These are the values your hook code can return. */
#define ISMACTION_Unselect      (0)     /* Unselect the icon */
#define ISMACTION_Select        (1)     /* Select the icon */
#define ISMACTION_Ignore        (2)     /* Do not change the selection state. */
#define ISMACTION_Stop          (3)     /* Do not invoke the hook code again,
                                         * leave the icon as it is.
                                         */

/****************************************************************************/

/* The messages your copy hook is invoked with. */
struct CopyBeginMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cbm_Length;             /* Size of this data structure in bytes. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    cbm_Action;             /* Will be set to @{"CPACTION_Begin" LINK File 591} (see below). */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    cbm_SourceDrawer;       /* A lock on the source drawer. */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    cbm_DestinationDrawer;  /* A lock on the destination drawer. */
};

struct CopyDataMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cdm_Length;             /* Size of this data structure in bytes. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    cdm_Action;             /* Will be set to @{"CPACTION_Copy" LINK File 594} (see below). */

        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    cdm_SourceLock;         /* A lock on the parent directory of the
                                         * source file/drawer.
                                         */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  cdm_SourceName;         /* The name of the source file or drawer. */

        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    cdm_DestinationLock;    /* A lock on the parent directory of the
                                         * destination file/drawer.
                                         */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  cdm_DestinationName;    /* The name of the destination file/drawer.
                                         * This may or may not match the name of
                                         * the source file/drawer in case the
                                         * data is to be copied under a different
                                         * name. For example, this is the case
                                         * with the Workbench "Copy" command which
                                         * creates duplicates of file/drawers by
                                         * prefixing the duplicate's name with
                                         * "Copy_XXX_of".
                                         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    cdm_DestinationX;       /* When the icon corresponding to the
                                         * destination is written to disk, this
                                         * is the position (put into its
                                         * DiskObject->do_CurrentX/DiskObject->do_CurrentY
                                         * fields) it should be placed at.
                                         */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    cdm_DestinationY;
};

struct CopyEndMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cem_Length;             /* Size of this data structure in bytes. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    cem_Action;             /* Will be set to @{"CPACTION_End" LINK File 597} (see below). */
};

#define CPACTION_Begin          (0)     /* This message arrives when the copying
                                         * process is started.
                                         */
#define CPACTION_Copy           (1)     /* This message arrives for each file or
                                         * drawer to be copied.
                                         */
#define CPACTION_End            (2)     /* This message arrives when all files/drawers
                                         * have been copied.
                                         */

/****************************************************************************/

/* The messages your delete hook is invoked with. */
struct DeleteBeginMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dbm_Length;             /* Size of this data structure in bytes. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dbm_Action;             /* Will be set to either @{"DLACTION_BeginDiscard" LINK File 633}
                                         * or @{"DLACTION_BeginEmptyTrash" LINK File 640} (see below).
                                         */
};

struct DeleteDataMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ddm_Length;             /* Size of this data structure in bytes. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    ddm_Action;             /* Will be set to either @{"DLACTION_DeleteContents" LINK File 644}
                                         * or @{"DLACTION_DeleteObject" LINK File 650} (see below).
                                         */
        @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130}    ddm_Lock;               /* A Lock on the parent directory of the object
                                         * whose contents or which itself should be
                                         * deleted.
                                         */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  ddm_Name;               /* The name of the object whose contents or
                                         * which itself should be deleted.
                                         */
};

struct DeleteEndMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dem_Length;             /* Size of this data structure in bytes. */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    dem_Action;             /* Will be set to @{"DLACTION_End" LINK File 655} (see below). */
};

#define DLACTION_BeginDiscard           (0)     /* This indicates that a number of
                                                 * files and drawers should be
                                                 * discarded; note that you will
                                                 * receive a different kind of message
                                                 * if the trashcan is to be emptied
                                                 * (see below).
                                                 */
#define DLACTION_BeginEmptyTrash        (1)     /* This indicates that the following
                                                 * delete operations are intended to
                                                 * empty the trashcan.
                                                 */
#define DLACTION_DeleteContents         (3)     /* This indicates that the object
                                                 * described by lock and name refers
                                                 * to a drawer; you should empty its
                                                 * contents but *DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500}* delete the
                                                 * drawer itself!
                                                 */
#define DLACTION_DeleteObject           (4)     /* This indicates that the object
                                                 * described by lock and name should
                                                 * be deleted; this could be a file
                                                 * or an empty drawer.
                                                 */
#define DLACTION_End                    (5)     /* This indicates that the
                                                 * deletion process is finished.
                                                 */

/****************************************************************************/

/* The messages your text input hook is invoked with. */
struct TextInputMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   tim_Length;                     /* Size of this data structure
                                                 * in bytes.
                                                 */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}    tim_Action;                     /* One of the TIACTION_...
                                                 * values listed below.
                                                 */
        @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  tim_Prompt;                     /* The Workbench suggested
                                                 * result, depending on what
                                                 * kind of input is requested
                                                 * (as indicated by the
                                                 * tim_Action member).
                                                 */
};

#define TIACTION_Rename         (0)             /* A file or drawer is to be
                                                 * renamed.
                                                 */
#define TIACTION_RelabelVolume  (1)             /* A volume is to be relabeled. */
#define TIACTION_NewDrawer      (2)             /* A new drawer is to be created. */
#define TIACTION_Execute        (3)             /* A program or script is to be
                                                 * executed.
                                                 */

/****************************************************************************/

/* Parameters for the @{"UpdateWorkbench()" LINK "gg:doc/NDK/Guide/wb/UpdateWorkbench"} function. */

#define UPDATEWB_ObjectRemoved  (0)     /* Object has been deleted. */
#define UPDATEWB_ObjectAdded    (1)     /* Object is new or has changed. */

/****************************************************************************/

#endif  /* !WORKBENCH_WORKBENCH_H */
@ENDNODE
