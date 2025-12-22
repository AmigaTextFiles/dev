;
; ** $VER: card.h 1.11 (14.12.92)
; ** Includes Release 40.15
; **
; ** card.resource include file
; **
; ** (C) Copyright 1991-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
; **
;

IncludePath   "PureInclude:"
XIncludeFile "exec/types.pb"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/interrupts.pb"

;#CARDRESNAME = "card\resource"

;  Structures used by the card.resource

Structure CardHandle
 cah_CardNode.Node
 *cah_CardRemoved.Interrupt
 *cah_CardInserted.Interrupt
 *cah_CardStatus.Interrupt
 cah_CardFlags.b
EndStructure

Structure DeviceTData
 dtd_DTsize.l ;  Size in bytes
 dtd_DTspeed.l ;  Speed in nanoseconds
 dtd_DTtype.b ;  Type of card
 dtd_DTflags.b ;  Other flags
EndStructure

Structure CardMemoryMap
 *cmm_CommonMemory.b
 *cmm_AttributeMemory.b
 *cmm_IOMemory.b

;  Extended for V39 - These are the size of the memory spaces above

 cmm_CommonMemSize.l
 cmm_AttributeMemSize.l
 cmm_IOMemSize.l

EndStructure

;  CardHandle.cah_CardFlags for OwnCard() function

#CARDB_RESETREMOVE = 0
#CARDF_RESETREMOVE = (1 << #CARDB_RESETREMOVE)

#CARDB_IFAVAILABLE = 1
#CARDF_IFAVAILABLE = (1 << #CARDB_IFAVAILABLE)

#CARDB_DELAYOWNERSHIP = 2
#CARDF_DELAYOWNERSHIP = (1 << #CARDB_DELAYOWNERSHIP)

#CARDB_POSTSTATUS = 3
#CARDF_POSTSTATUS = (1 << #CARDB_POSTSTATUS)

;  ReleaseCreditCard() function flags

#CARDB_REMOVEHANDLE = 0
#CARDF_REMOVEHANDLE = (1 << #CARDB_REMOVEHANDLE)

;  ReadStatus() return flags

#CARD_STATUSB_CCDET  = 6
#CARD_STATUSF_CCDET  = (1 << #CARD_STATUSB_CCDET)

#CARD_STATUSB_BVD1  = 5
#CARD_STATUSF_BVD1  = (1 << #CARD_STATUSB_BVD1)

#CARD_STATUSB_SC   = 5
#CARD_STATUSF_SC   = (1 << #CARD_STATUSB_SC)

#CARD_STATUSB_BVD2  = 4
#CARD_STATUSF_BVD2  = (1 << #CARD_STATUSB_BVD2)

#CARD_STATUSB_DA   = 4
#CARD_STATUSF_DA   = (1 << #CARD_STATUSB_DA)

#CARD_STATUSB_WR   = 3
#CARD_STATUSF_WR   = (1 << #CARD_STATUSB_WR)

#CARD_STATUSB_BSY  = 2
#CARD_STATUSF_BSY  = (1 << #CARD_STATUSB_BSY)

#CARD_STATUSB_IRQ  = 2
#CARD_STATUSF_IRQ  = (1 << #CARD_STATUSB_IRQ)

;  CardProgramVoltage() defines

#CARD_VOLTAGE_0V  = 0 ;  Set to default; may be the same as 5V
#CARD_VOLTAGE_5V  = 1
#CARD_VOLTAGE_12V = 2

;  CardMiscControl() defines

#CARD_ENABLEB_DIGAUDIO = 1
#CARD_ENABLEF_DIGAUDIO = (1 << #CARD_ENABLEB_DIGAUDIO)

#CARD_DISABLEB_WP = 3
#CARD_DISABLEF_WP = (1 << #CARD_DISABLEB_WP)

;
;  * New CardMiscControl() bits for V39 card.resource.  Use these bits to set,
;  * or clear status change interrupts for BVD1/SC, BVD2/DA, and BSY/IRQ.
;  * Write-enable/protect change interrupts are always enabled.  The defaults
;  * are unchanged (BVD1/SC is enabled, BVD2/DA is disabled, and BSY/IRQ is enabled).
;  *
;  * IMPORTANT -- Only set these bits for V39 card.resource or greater (check
;  * resource base VERSION)
;  *
;

#CARD_INTB_SETCLR = 7
#CARD_INTF_SETCLR = (1 << #CARD_INTB_SETCLR)

#CARD_INTB_BVD1  = 5
#CARD_INTF_BVD1  = (1 << #CARD_INTB_BVD1)

#CARD_INTB_SC  = 5
#CARD_INTF_SC  = (1 << #CARD_INTB_SC)

#CARD_INTB_BVD2  = 4
#CARD_INTF_BVD2  = (1 << #CARD_INTB_BVD2)

#CARD_INTB_DA  = 4
#CARD_INTF_DA  = (1 << #CARD_INTB_DA)

#CARD_INTB_BSY  = 2
#CARD_INTF_BSY  = (1 << #CARD_INTB_BSY)

#CARD_INTB_IRQ  = 2
#CARD_INTF_IRQ  = (1 << #CARD_INTB_IRQ)


;  CardInterface() defines

#CARD_INTERFACE_AMIGA_0 = 0

;
;  * Tuple for Amiga execute-in-place software (e.g., games, or other
;  * such software which wants to use execute-in-place software stored
;  * on a credit-card, such as a ROM card).
;  *
;  * See documentatin for IfAmigaXIP().
;

#CISTPL_AMIGAXIP = $91

Structure TP_AmigaXIP
 TPL_CODE.b
 TPL_LINK.b
 TP_XIPLOC.b[4]
 TP_XIPFLAGS.b
 TP_XIPRESRV.b
EndStructure
;
;
;  ; The XIPFLAGB_AUTORUN bit means that you want the machine
;  ; to perform a reset if the execute-in-place card is inserted
;  ; after DOS has been started.  The machine will then reset,
;  ; and execute your execute-in-place code the next time around.
;  ;
;  ; NOTE -- this flag may be ignored on some machines, in which
;  ; case the user will have to manually reset the machine in the
;  ; usual way.
;
;

#XIPFLAGSB_AUTORUN = 0
#XIPFLAGSF_AUTORUN = (1 << #XIPFLAGSB_AUTORUN)

