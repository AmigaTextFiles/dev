;
; ** $VER: expansionbase.h 36.15 (21.10.91)
; ** Includes Release 40.15
; **
; ** Definitions for the expansion library base
; **
; ** (C) Copyright 1987-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/libraries.pb"
XIncludeFile "exec/semaphores.pb"
XIncludeFile "libraries/configvars.pb"


;  BootNodes are scanned by dos.library at startup.  Items found on the
;    list are started by dos. BootNodes are added with the AddDosNode() or
;    the V36 AddBootNode() calls.
Structure BootNode

 bn_Node.Node
 bn_Flags.w
 *bn_DeviceNode.l
EndStructure


;  expansion.library has functions to manipulate most of the information in
;    ExpansionBase.  Direct access is not permitted.  Use FindConfigDev()
;    to scan the board list.
Structure ExpansionBase

 LibNode.Library
 Flags.b    ;  read only (see below)
 eb_Private01.b   ;  private
 eb_Private02.l   ;  private
 eb_Private03.l   ;  private
 eb_Private04.CurrentBinding ;  private
 eb_Private05.List  ;  private
 MountList.List ;  contains struct BootNode entries
 ;  private
EndStructure

;  error codes
#EE_OK  = 0
#EE_LASTBOARD = 40  ;  could not shut him up
#EE_NOEXPANSION = 41  ;  not enough expansion mem; board shut up
#EE_NOMEMORY = 42  ;  not enough normal memory
#EE_NOBOARD = 43  ;  no board at that address
#EE_BADMEM = 44  ;  tried to add bad memory card

;  Flags
#EBB_CLOGGED = 0 ;  someone could not be shutup
#EBF_CLOGGED = (1 << 0)
#EBB_SHORTMEM = 1;  ran out of expansion mem
#EBF_SHORTMEM = (1 << 1)
#EBB_BADMEM = 2 ;  tried to add bad memory card
#EBF_BADMEM = (1 << 2)
#EBB_DOSFLAG = 3 ;  reserved for use by AmigaDOS
#EBF_DOSFLAG = (1 << 3)
#EBB_KICKBACK33 = 4 ;  reserved for use by AmigaDOS
#EBF_KICKBACK33 = (1 << 4)
#EBB_KICKBACK36 = 5 ;  reserved for use by AmigaDOS
#EBF_KICKBACK36 = (1 << 5)
;  If the following flag is set by a floppy's bootblock code, the initial
;    open of the initial shell window will be delayed until the first output
;    to that shell.  Otherwise the 1.3 compatible behavior applies.
#EBB_SILENTSTART = 6
#EBF_SILENTSTART = (1 << 6)

;  Magic kludge for CC0 use
#EBB_START_CC0 = 7
#EBF_START_CC0 = (1 << 7)


