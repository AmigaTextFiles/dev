;
; ** $VER: keymap.h 36.3 (13.4.90)
; ** Includes Release 40.15
; **
; ** key map definitions for keymap.resource, keymap.library, and
; ** console.device
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"

Structure  KeyMap
    *km_LoKeyMapTypes.b
    *km_LoKeyMap.l
    *km_LoCapsable.b
    *km_LoRepeatable.b
    *km_HiKeyMapTypes.b
    *km_HiKeyMap.l
    *km_HiCapsable.b
    *km_HiRepeatable.b
EndStructure

Structure KeyMapNode
    kn_Node.Node ;  including name of keymap
    kn_KeyMap.KeyMap
EndStructure

;  the structure of keymap.resource
Structure KeyMapResource
    kr_Node.Node
    kr_List.List ;  a list of KeyMapNodes
EndStructure

;  Key Map Types
#KC_NOQUAL   = 0
#KC_VANILLA  = 7  ;  note that SHIFT+ALT+CTRL is VANILLA
#KCB_SHIFT   = 0
#KCF_SHIFT   = $01
#KCB_ALT     = 1
#KCF_ALT     = $02
#KCB_CONTROL = 2
#KCF_CONTROL = $04
#KCB_DOWNUP  = 3
#KCF_DOWNUP  = $08

#KCB_DEAD    = 5  ;  may be dead or modified by dead key:
#KCF_DEAD    = $20 ;    use dead prefix bytes

#KCB_STRING  = 6
#KCF_STRING  = $40

#KCB_NOP     = 7
#KCF_NOP     = $80


;  Dead Prefix Bytes
#DPB_MOD = 0
#DPF_MOD = $01
#DPB_DEAD = 3
#DPF_DEAD = $08

#DP_2DINDEXMASK = $0f ;  mask for index for 1st of two dead keys
#DP_2DFACSHIFT = 4 ;  shift for factor for 1st of two dead keys

