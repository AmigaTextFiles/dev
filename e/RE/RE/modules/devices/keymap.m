#ifndef	DEVICES_KEYMAP_H
#define	DEVICES_KEYMAP_H

#ifndef EXEC_NODES_H
MODULE 	'exec/nodes'
#endif
#ifndef EXEC_LISTS_H
MODULE 	'exec/lists'
#endif
OBJECT KeyMap
 
    LoKeyMapTypes:PTR TO UBYTE
    LoKeyMap:PTR TO LONG
    LoCapsable:PTR TO UBYTE
    LoRepeatable:PTR TO UBYTE
    HiKeyMapTypes:PTR TO UBYTE
    HiKeyMap:PTR TO LONG
    HiCapsable:PTR TO UBYTE
    HiRepeatable:PTR TO UBYTE
ENDOBJECT

OBJECT KeyMapNode
 
      Node:Node	
      KeyMap:KeyMap
ENDOBJECT


OBJECT KeyMapResource
 
      Node:Node
      List:List	
ENDOBJECT


#define  KC_NOQUAL   0
#define  KC_VANILLA  7		
#define  KCB_SHIFT   0
#define  KCF_SHIFT   $01
#define  KCB_ALT     1
#define  KCF_ALT     $02
#define  KCB_CONTROL 2
#define  KCF_CONTROL $04
#define  KCB_DOWNUP  3
#define  KCF_DOWNUP  $08
#define  KCB_DEAD    5		
#define  KCF_DEAD    $20	
#define  KCB_STRING  6
#define  KCF_STRING  $40
#define  KCB_NOP     7
#define  KCF_NOP     $80

#define DPB_MOD	0
#define DPF_MOD	$01
#define DPB_DEAD	3
#define DPF_DEAD	$08
#define DP_2DINDEXMASK	$0f	
#define DP_2DFACSHIFT	4	
#endif	
