/*
**  $VER: string.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Definitions for the string.gadget BOOPSI class
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/*****************************************************************************/
//MODULE 'reaction/reaction','intuition/gadgetclass'
/*****************************************************************************/
/* string.gadget accepts the same tag parameters as the ROM strgclass
 * in addition to those listed below.
 */
#define STRINGA_MinVisible    (REACTION_Dummy+$0055000)
/* (UWORD) Minimum character length to domain min size on.
     *         In a layout, a nominal domain would be 2 times this value.
     */
#define STRINGA_HookType    (REACTION_Dummy+$0055001)
/* (UWORD) Use which built-in hook function?
   */
/* Support hook types for STRINGA_HookType
 */
#define SHK_CUSTOM    0
#define SHK_PASSWORD     1
#define SHK_IPADDRESS   2
#define SHK_FLOAT        3
#define SHK_HEXIDECIMAL   4
#define SHK_TELEPHONE   5
#define SHK_POSTALCODE  6
#define SHK_AMOUNT    7
#define SHK_UPPERCASE   8
#define SHK_HEXADECIMAL  SHK_HEXIDECIMAL
