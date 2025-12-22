/*
**
** $VER: HotkeyString_mcc.h V11.0 (28-Sep-97)
** Copyright © 1997 Allan Odgaard. All rights reserved.
**
*/

#ifndef   HOTKEYSTRING_MCC_H
#define   HOTKEYSTRING_MCC_H

#ifndef   EXEC_TYPES_H
#include  <exec/types.h>
#endif

#define   MUIC_HotkeyString	  "HotkeyString.mcc"
#define   HotkeyStringObject    MUI_NewObject(MUIC_HotkeyString

#define MUIA_HotkeyString_Snoop 0xad001000	/* V11 ISG (FALSE) */
#define MUIA_HotkeyString_Mode  0xad001001	/* V12 ISG (0x0e)  */
#define MUIA_HotkeyString_IX    0xad001002	/* V12 IS. 		  */

#define MUIF_HotkeyString_Mode_MouseButtons		(1 << 0)
#define MUIF_HotkeyString_Mode_NonPrintableKeys	(1 << 1)
#define MUIF_HotkeyString_Mode_PrintableKeys		(1 << 2)
#define MUIF_HotkeyString_Mode_Qualifiers			(1 << 3)
#define MUIF_HotkeyString_Mode_LonelyQualifiers	(1 << 4)
#define MUIF_HotkeyString_Mode_OneShot				(1 << 5)

#endif /* HOTKEYSTRING_MCC_H */
