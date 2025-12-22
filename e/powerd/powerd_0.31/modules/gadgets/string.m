/*****************************************************************************/
/* string.gadget accepts the same tag parameters as the ROM strgclass
 * in addition to those listed below.
 */
#define STRINGA_MinVisible    (REACTION_Dummy+$0055000)
/* (UWORD) Minimum character length to domain min size on.
     *         In a layout, a nominal domain would be 2 times this value. */

#define STRINGA_HookType    (REACTION_Dummy+$0055001)
/* (UWORD) Use which built-in hook function? */

/* The following tags are new for v45 */
#define STRINGA_GetBlockPos   (REACTION_Dummy+$0055010)
  /* (ULONG) Returns the position of the first and last character
   * of the marked block. The upper 16bit (WORD) of the long-word contain
   * the start position and the lower 16bit (WORD) the end position.
   * When nothing is marked both values will be -1. [G] */

#define STRINGA_Mark      (REACTION_Dummy+$0055011)
  /* (ULONG) Mark the given block. The upper 16bit of the longword contain
   * the start position and the lower one the end position. If one or both
   * values are -1, the current block will be unmarked. [ISU] */
   
#define STRINGA_AllowMarking  (REACTION_Dummy+$0055012) 
  /* (BOOL) Enable/disable marking, defaults to TRUE. [ISUG] */

/* Support hook types for STRINGA_HookType
 */
CONST SHK_CUSTOM=0,
 SHK_PASSWORD=1,
 SHK_IPADDRESS=2,
 SHK_FLOAT=3,
 SHK_HEXIDECIMAL=4,
 SHK_TELEPHONE=5,
 SHK_POSTALCODE=6,
 SHK_AMOUNT=7,
 SHK_UPPERCASE=8,
 SHK_HOTKEY=9, /* new for v45 */
 SHK_HEXADECIMAL=SHK_HEXIDECIMAL
