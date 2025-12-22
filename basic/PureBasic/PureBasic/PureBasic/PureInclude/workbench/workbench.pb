;
; ** $VER: workbench.h 40.1 (26.8.93)
; ** Includes Release 40.15
; **
; ** workbench.library general definitions
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; ** All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/tasks.pb"
XIncludeFile "intuition/intuition.pb"
XIncludeFile "workbench/startup.pb"

#WBDISK  = 1
#WBDRAWER = 2
#WBTOOL  = 3
#WBPROJECT = 4
#WBGARBAGE = 5
#WBDEVICE = 6
#WBKICK  = 7
#WBAPPICON = 8

Structure OldDrawerData  ;  pre V36 definition
    dd_NewWindow.NewWindow ;  args to open window
    dd_CurrentX.l ;  current x coordinate of origin
    dd_CurrentY.l ;  current y coordinate of origin
EndStructure

;  the amount of DrawerData actually written to disk

#OLDDRAWERDATAFILESIZE = 56  ; was SizeOf .OldDrawerData

Structure DrawerData
    dd_NewWindow.NewWindow ;  args to open window
    dd_CurrentX.l ;  current x coordinate of origin
    dd_CurrentY.l ;  current y coordinate of origin
    dd_Flags.l ;  flags for drawer
    dd_ViewModes.w ;  view mode for drawer
EndStructure
;  the amount of DrawerData actually written to disk

#DRAWERDATAFILESIZE = 62 ; (SizeOf(Structure DrawerData))

Structure DiskObject
    do_Magic.w ;  a magic number at the start of the file
    do_Version.w ;  a version number, so we can change it
    do_Gadget.Gadget ;  a copy of in core gadget
    do_Type.b
    *do_DefaultTool.b
    *do_ToolTypes.l
    do_CurrentX.l
    do_CurrentY.l
    *do_DrawerData.DrawerData
    *do_ToolWindow.b ;  only applies to tools
    do_StackSize.l ;  only applies to tools

EndStructure

#WB_DISKMAGIC = $e310 ;  a magic number, not easily impersonated
#WB_DISKVERSION = 1 ;  our current version number
#WB_DISKREVISION = 1 ;  our current revision number
;  I only use the lower 8 bits of Gadget.UserData for the revision #
#WB_DISKREVISIONMASK = 255

Structure FreeList
    fl_NumFree.w
    fl_MemList.List
EndStructure

;  workbench does different complement modes for its gadgets.
; ** It supports separate images, complement mode, and backfill mode.
; ** The first two are identical to intuitions GFLG_GADGIMAGE and GFLG_GADGHCOMP.
; ** backfill is similar to GFLG_GADGHCOMP, but the region outside of the
; ** image (which normally would be color three when complemented)
; ** is flood-filled to color zero.
;
#GFLG_GADGBACKFILL = $0001
#GADGBACKFILL   = $0001    ;  an old synonym

;  if an icon does not really live anywhere, set its current position
; ** to here
;
#NO_ICON_POSITION = ($80000000)

;  workbench now is a library. this is it's name
;#WORKBENCH_NAME  = "workbench.library"

;  If you find am_Version >= AM_VERSION, you know this structure has
;  * at least the fields defined in this version of the include file
;
#AM_VERSION = 1

Structure AppMessage
    am_Message.Message ;  standard message structure
    am_Type.w  ;  message type
    am_UserData.l  ;  application specific
    am_ID.l  ;  application definable ID
    am_NumArgs.l  ;  # of elements in arglist
    *am_ArgList.WBArg ;  the arguements themselves
    am_Version.w  ;  will be AM_VERSION
    am_Class.w  ;  message class
    am_MouseX.w  ;  mouse x position of event
    am_MouseY.w  ;  mouse y position of event
    am_Seconds.l  ;  current system clock time
    am_Micros.l  ;  current system clock time
    am_Reserved.l[8] ;  avoid recompilation
EndStructure

;  types of app messages
#AMTYPE_APPWINDOW   = 7 ;  app window message
#AMTYPE_APPICON    = 8 ;  app icon message
#AMTYPE_APPMENUITEM = 9 ;  app menu item message


;
;  * The following structures are private.  These are just stub
;  * structures for code compatibility...
;
;void *aw_PRIVATE  }.AppWindow
;void *ai_PRIVATE  }.AppIcon
;void *ami_PRIVATE }.AppMenuItem

