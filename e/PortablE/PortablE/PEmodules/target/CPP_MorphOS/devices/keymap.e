/* $VER: keymap.h 36.3 (13.4.1990) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/types'
{#include <devices/keymap.h>}
NATIVE {DEVICES_KEYMAP_H} CONST

NATIVE {KeyMap} OBJECT keymap
    {km_LoKeyMapTypes}	lokeymaptypes	:PTR TO UBYTE
    {km_LoKeyMap}	lokeymap	:PTR TO ULONG
    {km_LoCapsable}	locapsable	:PTR TO UBYTE
    {km_LoRepeatable}	lorepeatable	:PTR TO UBYTE
    {km_HiKeyMapTypes}	hikeymaptypes	:PTR TO UBYTE
    {km_HiKeyMap}	hikeymap	:PTR TO ULONG
    {km_HiCapsable}	hicapsable	:PTR TO UBYTE
    {km_HiRepeatable}	hirepeatable	:PTR TO UBYTE
ENDOBJECT

NATIVE {KeyMapNode} OBJECT keymapnode
    {kn_Node}	node	:ln	/* including name of keymap */
    {kn_KeyMap}	keymap	:keymap
ENDOBJECT

/* the structure of keymap.resource */
NATIVE {KeyMapResource} OBJECT keymapresource
    {kr_Node}	node	:ln
    {kr_List}	list	:lh	/* a list of KeyMapNodes */
ENDOBJECT

/* Key Map Types */
NATIVE {KC_NOQUAL}   CONST KC_NOQUAL   = 0
NATIVE {KC_VANILLA}  CONST KC_VANILLA  = 7		/* note that SHIFT+ALT+CTRL is VANILLA */
NATIVE {KCB_SHIFT}   CONST KCB_SHIFT   = 0
NATIVE {KCF_SHIFT}   CONST KCF_SHIFT   = $01
NATIVE {KCB_ALT}     CONST KCB_ALT     = 1
NATIVE {KCF_ALT}     CONST KCF_ALT     = $02
NATIVE {KCB_CONTROL} CONST KCB_CONTROL = 2
NATIVE {KCF_CONTROL} CONST KCF_CONTROL = $04
NATIVE {KCB_DOWNUP}  CONST KCB_DOWNUP  = 3
NATIVE {KCF_DOWNUP}  CONST KCF_DOWNUP  = $08

NATIVE {KCB_DEAD}    CONST KCB_DEAD    = 5		/* may be dead or modified by dead key: */
NATIVE {KCF_DEAD}    CONST KCF_DEAD    = $20	/*   use dead prefix bytes		*/

NATIVE {KCB_STRING}  CONST KCB_STRING  = 6
NATIVE {KCF_STRING}  CONST KCF_STRING  = $40

NATIVE {KCB_NOP}     CONST KCB_NOP     = 7
NATIVE {KCF_NOP}     CONST KCF_NOP     = $80


/* Dead Prefix Bytes */
NATIVE {DPB_MOD}	CONST DPB_MOD	= 0
NATIVE {DPF_MOD}	CONST DPF_MOD	= $01
NATIVE {DPB_DEAD}	CONST DPB_DEAD	= 3
NATIVE {DPF_DEAD}	CONST DPF_DEAD	= $08

NATIVE {DP_2DINDEXMASK}	CONST DP_2DINDEXMASK	= $0f	/* mask for index for 1st of two dead keys */
NATIVE {DP_2DFACSHIFT}	CONST DP_2DFACSHIFT	= 4	/* shift for factor for 1st of two dead keys */
