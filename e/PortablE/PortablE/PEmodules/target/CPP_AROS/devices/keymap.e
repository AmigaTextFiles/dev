/* $Id: keymap.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/lists', 'target/exec/nodes'
MODULE 'target/exec/types'
{#include <devices/keymap.h>}
NATIVE {DEVICES_KEYMAP_H} CONST


NATIVE {KeyMapResource} OBJECT keymapresource
    {kr_Node}	node	:ln
    {kr_List}	list	:lh
ENDOBJECT

NATIVE {KeyMap} OBJECT keymap
    {km_LoKeyMapTypes}	lokeymaptypes	:PTR TO UBYTE
    {km_LoKeyMap}	lokeymap	:PTR TO IPTR
    {km_LoCapsable}	locapsable	:PTR TO UBYTE
    {km_LoRepeatable}	lorepeatable	:PTR TO UBYTE
    {km_HiKeyMapTypes}	hikeymaptypes	:PTR TO UBYTE
    {km_HiKeyMap}	hikeymap	:PTR TO IPTR
    {km_HiCapsable}	hicapsable	:PTR TO UBYTE
    {km_HiRepeatable}	hirepeatable	:PTR TO UBYTE
ENDOBJECT

NATIVE {KeyMapNode} OBJECT keymapnode
    {kn_Node}	node	:ln
    {kn_KeyMap}	keymap	:keymap
ENDOBJECT

NATIVE {KC_NOQUAL}   CONST KC_NOQUAL   = 0
NATIVE {KC_VANILLA}  CONST KC_VANILLA  = 7
NATIVE {KCB_SHIFT}       CONST KCB_SHIFT       = 0
NATIVE {KCF_SHIFT}   CONST KCF_SHIFT   = 1 SHL 0
NATIVE {KCB_ALT}         CONST KCB_ALT         = 1
NATIVE {KCF_ALT}     CONST KCF_ALT     = 1 SHL 1
NATIVE {KCB_CONTROL}     CONST KCB_CONTROL     = 2
NATIVE {KCF_CONTROL} CONST KCF_CONTROL = 1 SHL 2
NATIVE {KCB_DOWNUP}      CONST KCB_DOWNUP      = 3
NATIVE {KCF_DOWNUP}  CONST KCF_DOWNUP  = 1 SHL 3
NATIVE {KCB_DEAD}        CONST KCB_DEAD        = 5
NATIVE {KCF_DEAD}    CONST KCF_DEAD    = 1 SHL 5
NATIVE {KCB_STRING}      CONST KCB_STRING      = 6
NATIVE {KCF_STRING}  CONST KCF_STRING  = 1 SHL 6
NATIVE {KCB_NOP}         CONST KCB_NOP         = 7
NATIVE {KCF_NOP}     CONST KCF_NOP     = 1 SHL 7

NATIVE {DPB_MOD}      CONST DPB_MOD      = 0
NATIVE {DPF_MOD}  CONST DPF_MOD  = 1 SHL 0
NATIVE {DPB_DEAD}     CONST DPB_DEAD     = 3
NATIVE {DPF_DEAD} CONST DPF_DEAD = 1 SHL 3

NATIVE {DP_2DINDEXMASK} CONST DP_2DINDEXMASK = $0f
NATIVE {DP_2DFACSHIFT} CONST DP_2DFACSHIFT = 4
