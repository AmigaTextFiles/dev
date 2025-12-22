/* $VER: keymap.h 53.11 (31.1.2010) */
OPT NATIVE
MODULE 'target/exec/nodes', 'target/exec/lists'
MODULE 'target/exec/types', 'target/utility/tagitem'
{#include <libraries/keymap.h>}
NATIVE {LIBRARIES_KEYMAP_H} CONST

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
    {kn_Node}	node	:ln   /* including name of keymap */
    {kn_KeyMap}	keymap	:keymap
ENDOBJECT

/* Key Map Types */
NATIVE {KC_NOQUAL}   CONST KC_NOQUAL   = 0
NATIVE {KC_VANILLA}  CONST KC_VANILLA  = 7    /* note that SHIFT+ALT+CTRL is VANILLA */
NATIVE {KCB_SHIFT}   CONST KCB_SHIFT   = 0
NATIVE {KCF_SHIFT}   CONST KCF_SHIFT   = $01
NATIVE {KCB_ALT}     CONST KCB_ALT     = 1
NATIVE {KCF_ALT}     CONST KCF_ALT     = $02
NATIVE {KCB_CONTROL} CONST KCB_CONTROL = 2
NATIVE {KCF_CONTROL} CONST KCF_CONTROL = $04
NATIVE {KCB_DOWNUP}  CONST KCB_DOWNUP  = 3
NATIVE {KCF_DOWNUP}  CONST KCF_DOWNUP  = $08

NATIVE {KCB_DEAD}    CONST KCB_DEAD    = 5    /* may be dead or modified by dead key: */
NATIVE {KCF_DEAD}    CONST KCF_DEAD    = $20 /*   use dead prefix bytes              */

NATIVE {KCB_STRING}  CONST KCB_STRING  = 6
NATIVE {KCF_STRING}  CONST KCF_STRING  = $40

NATIVE {KCB_NOP}     CONST KCB_NOP     = 7
NATIVE {KCF_NOP}     CONST KCF_NOP     = $80


/* Dead Prefix Bytes */
NATIVE {DPB_MOD}   CONST DPB_MOD   = 0
NATIVE {DPF_MOD}   CONST DPF_MOD   = $01
NATIVE {DPB_DEAD}  CONST DPB_DEAD  = 3
NATIVE {DPF_DEAD}  CONST DPF_DEAD  = $08

NATIVE {DP_2DINDEXMASK} CONST DP_2DINDEXMASK = $0f /* mask for index for 1st of two dead keys   */
NATIVE {DP_2DFACSHIFT}  CONST DP_2DFACSHIFT  = 4    /* shift for factor for 1st of two dead keys */


/* Some useful definitions for rawkey codes which are assumed
 * to be the same on all keyboards so no call of MapRawKey()
 * is necessary. These are the keydown codes only.
 */
NATIVE {RAWKEY_SPACE}     CONST RAWKEY_SPACE     = $40
NATIVE {RAWKEY_BACKSPACE} CONST RAWKEY_BACKSPACE = $41
NATIVE {RAWKEY_TAB}       CONST RAWKEY_TAB       = $42
NATIVE {RAWKEY_ENTER}     CONST RAWKEY_ENTER     = $43 /* Numeric pad */
NATIVE {RAWKEY_RETURN}    CONST RAWKEY_RETURN    = $44
NATIVE {RAWKEY_ESC}       CONST RAWKEY_ESC       = $45
NATIVE {RAWKEY_DEL}       CONST RAWKEY_DEL       = $46
NATIVE {RAWKEY_INSERT}    CONST RAWKEY_INSERT    = $47 /* Not on classic keyboards */
NATIVE {RAWKEY_PAGEUP}    CONST RAWKEY_PAGEUP    = $48 /* Not on classic keyboards */
NATIVE {RAWKEY_PAGEDOWN}  CONST RAWKEY_PAGEDOWN  = $49 /* Not on classic keyboards */
NATIVE {RAWKEY_F11}       CONST RAWKEY_F11       = $4B /* Not on classic keyboards */
NATIVE {RAWKEY_CRSRUP}    CONST RAWKEY_CRSRUP    = $4C
NATIVE {RAWKEY_CRSRDOWN}  CONST RAWKEY_CRSRDOWN  = $4D
NATIVE {RAWKEY_CRSRRIGHT} CONST RAWKEY_CRSRRIGHT = $4E
NATIVE {RAWKEY_CRSRLEFT}  CONST RAWKEY_CRSRLEFT  = $4F
NATIVE {RAWKEY_F1}        CONST RAWKEY_F1        = $50
NATIVE {RAWKEY_F2}        CONST RAWKEY_F2        = $51
NATIVE {RAWKEY_F3}        CONST RAWKEY_F3        = $52
NATIVE {RAWKEY_F4}        CONST RAWKEY_F4        = $53
NATIVE {RAWKEY_F5}        CONST RAWKEY_F5        = $54
NATIVE {RAWKEY_F6}        CONST RAWKEY_F6        = $55
NATIVE {RAWKEY_F7}        CONST RAWKEY_F7        = $56
NATIVE {RAWKEY_F8}        CONST RAWKEY_F8        = $57
NATIVE {RAWKEY_F9}        CONST RAWKEY_F9        = $58
NATIVE {RAWKEY_F10}       CONST RAWKEY_F10       = $59
NATIVE {RAWKEY_HELP}      CONST RAWKEY_HELP      = $5F
NATIVE {RAWKEY_LSHIFT}    CONST RAWKEY_LSHIFT    = $60
NATIVE {RAWKEY_RSHIFT}    CONST RAWKEY_RSHIFT    = $61
NATIVE {RAWKEY_CAPSLOCK}  CONST RAWKEY_CAPSLOCK  = $62
NATIVE {RAWKEY_LCTRL}     CONST RAWKEY_LCTRL     = $63 /* Right Ctrl is the same for now */
NATIVE {RAWKEY_LALT}      CONST RAWKEY_LALT      = $64
NATIVE {RAWKEY_RALT}      CONST RAWKEY_RALT      = $65
NATIVE {RAWKEY_LCOMMAND}  CONST RAWKEY_LCOMMAND  = $66 /* LAmiga|LWin|LApple|LMeta */
NATIVE {RAWKEY_RCOMMAND}  CONST RAWKEY_RCOMMAND  = $67 /* RAmiga|RWin|RApple|RMeta */
NATIVE {RAWKEY_MENU}      CONST RAWKEY_MENU      = $6B /* Not on classic keyboards */
                              /* Menu|Win|Compose         */
                              /* Dont use, its reserved   */
NATIVE {RAWKEY_PRINTSCR}  CONST RAWKEY_PRINTSCR  = $6D /* Not on classic keyboards */
NATIVE {RAWKEY_BREAK}     CONST RAWKEY_BREAK     = $6E /* Not on classic keyboards */
                              /* Pause/Break              */
NATIVE {RAWKEY_F12}       CONST RAWKEY_F12       = $6F /* Not on classic keyboards */
NATIVE {RAWKEY_HOME}      CONST RAWKEY_HOME      = $70 /* Not on classic keyboards */
NATIVE {RAWKEY_END}       CONST RAWKEY_END       = $71 /* Not on classic keyboards */

/* The following keys can exist on CDTV, CD32 and "multimedia" keyboards:
 *
 * Rawkey         |CD32 color&key     |CDTV key  |Comment
 * ---------------+-------------------+----------+-----------
 * 0x72 Stop      |Blue     Stop      |Stop      |
 * 0x73 Play/Pause|Grey     Play/Pause|Play/Pause|
 * 0x74 Prev Track|Charcoal Reverse   |<< REW    |
 * 0x75 Next Track|Charcoal Forward   |>> FF     |
 * 0x76 Shuffle   |Green    Shuffle   |          |Random Play
 * 0x77 Repeat    |Yellow   Repeat    |          |
 */
NATIVE {RAWKEY_MEDIA_STOP}       CONST RAWKEY_MEDIA_STOP       = $72
NATIVE {RAWKEY_MEDIA_PLAY_PAUSE} CONST RAWKEY_MEDIA_PLAY_PAUSE = $73
NATIVE {RAWKEY_MEDIA_PREV_TRACK} CONST RAWKEY_MEDIA_PREV_TRACK = $74
NATIVE {RAWKEY_MEDIA_NEXT_TRACK} CONST RAWKEY_MEDIA_NEXT_TRACK = $75
NATIVE {RAWKEY_MEDIA_SHUFFLE}    CONST RAWKEY_MEDIA_SHUFFLE    = $76
NATIVE {RAWKEY_MEDIA_REPEAT}     CONST RAWKEY_MEDIA_REPEAT     = $77


/* Tags for keymap.library/ObtainKeyMapInfo() */
NATIVE {KEYMAPINFO_KEYMAPNODE}         CONST KEYMAPINFO_KEYMAPNODE         = (TAG_USER + 0) /* (struct KeyMapNode *)
                                                      */
NATIVE {KEYMAPINFO_GETCLASSICKEYBOARD} CONST KEYMAPINFO_GETCLASSICKEYBOARD = (TAG_USER + 1) /* Private, dont use */
NATIVE {KEYMAPINFO_SETCLASSICKEYBOARD} CONST KEYMAPINFO_SETCLASSICKEYBOARD = (TAG_USER + 2) /* Private, dont use */
/* The following tags were added in V51 */
NATIVE {KEYMAPINFO_INFOTEXT_ENGLISH}   CONST KEYMAPINFO_INFOTEXT_ENGLISH   = (TAG_USER + 3) /* (STRPTR *) */
NATIVE {KEYMAPINFO_INFOTEXT_LOCAL}     CONST KEYMAPINFO_INFOTEXT_LOCAL     = (TAG_USER + 4) /* (STRPTR *) */
NATIVE {KEYMAPINFO_INFOTEXT_CHARSET}   CONST KEYMAPINFO_INFOTEXT_CHARSET   = (TAG_USER + 5) /* (ULONG *) */
NATIVE {KEYMAPINFO_CLASSIC_ONLY}       CONST KEYMAPINFO_CLASSIC_ONLY       = (TAG_USER + 6) /* (ULONG *) */
NATIVE {KEYMAPINFO_PC_ONLY}            CONST KEYMAPINFO_PC_ONLY            = (TAG_USER + 7) /* (ULONG *) */
NATIVE {KEYMAPINFO_SETCHARSET}         CONST KEYMAPINFO_SETCHARSET         = (TAG_USER + 8) /* (ULONG) */


/* Tags for keymap.library/ObtainRawKeyInfo() (V51.7) */
NATIVE {RKI_SET_TYPE}       CONST RKI_SET_TYPE       = (TAG_USER + 0) /* (ULONG)          */
NATIVE {RKI_SET_VALUE}      CONST RKI_SET_VALUE      = (TAG_USER + 1) /* (ULONG)          */
NATIVE {RKI_GET_RAWKEY}     CONST RKI_GET_RAWKEY     = (TAG_USER + 2) /* (ULONG *)        */
NATIVE {RKI_GET_EXT_RAWKEY} CONST RKI_GET_EXT_RAWKEY = (TAG_USER + 3) /* (ULONG *)        */
NATIVE {RKI_GET_PS2_SET1}   CONST RKI_GET_PS2_SET1   = (TAG_USER + 4) /* (ULONG *)        */
NATIVE {RKI_GET_PS2_SET2}   CONST RKI_GET_PS2_SET2   = (TAG_USER + 5) /* (ULONG *)        */
NATIVE {RKI_GET_USB}        CONST RKI_GET_USB        = (TAG_USER + 6) /* (ULONG *)        */
NATIVE {RKI_GET_FLAGS}      CONST RKI_GET_FLAGS      = (TAG_USER + 7) /* (ULONG *)        */
NATIVE {RKI_GET_NAME}       CONST RKI_GET_NAME       = (TAG_USER + 8) /* (CONST_STRPTR *) */

/* Types for RKI_SET_TYPE */
NATIVE {RKITYPE_RAWKEY}     CONST RKITYPE_RAWKEY     = 1 /* Amiga 8bit rawkey code                */
NATIVE {RKITYPE_EXT_RAWKEY} CONST RKITYPE_EXT_RAWKEY = 2 /* Amiga 16bit extended rawkey code      */
NATIVE {RKITYPE_PS2_SET1}   CONST RKITYPE_PS2_SET1   = 3 /* PS/2 Set1 make or break code          */
NATIVE {RKITYPE_PS2_SET2}   CONST RKITYPE_PS2_SET2   = 4 /* PS/2 Set2 make or break code          */
NATIVE {RKITYPE_USB}        CONST RKITYPE_USB        = 5 /* USB HID Usage page and ID code (down) */
NATIVE {RKITYPE_USB_UPCODE} CONST RKITYPE_USB_UPCODE = 6 /* USB HID Usage page and ID code (up)   */
