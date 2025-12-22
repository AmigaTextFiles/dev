/* $VER: string.h 53.21 (29.9.2013) */
OPT NATIVE
MODULE 'target/reaction/reaction', 'target/intuition/gadgetclass'
{#include <gadgets/string.h>}
NATIVE {GADGETS_STRING_H} CONST

/* string.gadget accepts the same tag parameters as the ROM strgclass
 * in addition to those listed below.
 */

NATIVE {STRINGA_MinVisible}       CONST STRINGA_MINVISIBLE       = (REACTION_DUMMY+$0055000)
    /* (UWORD) Minimum character length to domain min size on.
     * In a layout, a nominal domain would be 2 times this value. 
     */

NATIVE {STRINGA_HookType}         CONST STRINGA_HOOKTYPE         = (REACTION_DUMMY+$0055001)
    /* (UWORD) Use which built-in hook function? [IS] */

/* The following tags are new for v45 */

NATIVE {STRINGA_RelVerifySpecial} CONST STRINGA_RELVERIFYSPECIAL = (REACTION_DUMMY+$005500a)
    /* (BOOL) new for v45.14: Send IDCMP_GADGETUP whenever the gadget    
     * goes inactive. Don't not use this tag for ENDGADGET like
     * gadgets. 
     */
     
NATIVE {STRINGA_GetBlockPos}      CONST STRINGA_GETBLOCKPOS      = (REACTION_DUMMY+$0055010)
    /* (ULONG) Returns the position of the first and last character
     * of the marked block. The upper 16bit (WORD) of the long-word contain
     * the start position and the lower 16bit (WORD) the end position.
     * When nothing is marked both values will be -1. [G] 
     * OBSOLETE. Use tag below.
     */

NATIVE {STRINGA_Mark}             CONST STRINGA_MARK             = (REACTION_DUMMY+$0055011)
    /* (ULONG) Mark the given block. The upper 16bit of the longword contain
     * the start position and the lower one the end position. If one or both
     * values are -1, the current block will be unmarked. [ISU] 
     */
     
NATIVE {STRINGA_AllowMarking}     CONST STRINGA_ALLOWMARKING     = (REACTION_DUMMY+$0055012) 
    /* (BOOL) Enable/disable marking, defaults to TRUE. [ISUG] */
     
NATIVE {STRINGA_ASLTags}          CONST STRINGA_ASLTAGS          = (REACTION_DUMMY+$0055013)
    /* (struct TagItem *) Used internally by getfile.gadget
     * and the filename expansion code of string.gadget. [IS]
     */

NATIVE {STRINGA_MarkActive}       CONST STRINGA_MARKACTIVE       = (REACTION_DUMMY+$0055014)
    /* Mark contents of gadget when it goes active. Defaults to
     * FALSE. [IS] (V50) 
     */

NATIVE {STRINGA_DisablePopup}      CONST STRINGA_DISABLEPOPUP      = (REACTION_DUMMY+$0055015)
    /* Disable the right button popup context menu. Defaults to 
     * FALSE. [S] (V53)
     */
     
/* Support hook types for STRINGA_HookType */
NATIVE {SHK_CUSTOM}      CONST SHK_CUSTOM      = 0
NATIVE {SHK_PASSWORD}    CONST SHK_PASSWORD    = 1
NATIVE {SHK_IPADDRESS}   CONST SHK_IPADDRESS   = 2
NATIVE {SHK_FLOAT}       CONST SHK_FLOAT       = 3
NATIVE {SHK_HEXIDECIMAL} CONST SHK_HEXIDECIMAL = 4
NATIVE {SHK_TELEPHONE}   CONST SHK_TELEPHONE   = 5
NATIVE {SHK_POSTALCODE}  CONST SHK_POSTALCODE  = 6
NATIVE {SHK_AMOUNT}      CONST SHK_AMOUNT      = 7
NATIVE {SHK_UPPERCASE}   CONST SHK_UPPERCASE   = 8
NATIVE {SHK_HOTKEY}      CONST SHK_HOTKEY      = 9 /* new for v45 */

NATIVE {SHK_HEXADECIMAL} CONST SHK_HEXADECIMAL = SHK_HEXIDECIMAL
