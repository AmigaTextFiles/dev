/*
**  $VER: integer.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Definitions for the integer.gadget BOOPSI class
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
//MODULE 'reaction/reaction','intuition/gadgetclass'
/* Additional attributes defined by the Integer class
 */
#define INTEGER_Dummy     (REACTION_Dummy+$0002000)
#define INTEGER_Number    (INTEGER_Dummy+1)
/* (LONG) The value in the gadget.  Defaults to 0. */
#define INTEGER_MaxChars  (INTEGER_Dummy+2)
/* (WORD) Maximum number of characters for the numer (including
   * negative sign.  Defaults to 10. */
#define INTEGER_Minimum     (INTEGER_Dummy+3)
/* (LONG) Minimum value for the number. */
#define INTEGER_Maximum     (INTEGER_Dummy+4)
/* (LONG) Maximum value for the number. */
#define INTEGER_Arrows    (INTEGER_Dummy+5)
/* (BOOL) Should arrows be available.  Defaults to TRUE. */
#define INTEGER_MinVisible  (INTEGER_Dummy+6)
/* (BOOL) Minimum number of digits to be visible.  Defaults to 0. (V41) */
