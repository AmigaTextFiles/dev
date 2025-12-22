/* $VER: keymap.h 53.17 (31.1.2010) */
OPT NATIVE
PUBLIC MODULE 'target/libraries/keymap'
MODULE 'target/exec/types', 'target/exec/lists'
MODULE 'target/exec/nodes'
{#include <devices/keymap.h>}
NATIVE {DEVICES_KEYMAP_H} CONST

/* the structure of keymap.resource */
/* OBSOLETE, use keymap.library     */
NATIVE {KeyMapResource} OBJECT keymapresource
    {kr_Node}	node	:ln
    {kr_List}	list	:lh /* a list of KeyMapNodes */
ENDOBJECT
