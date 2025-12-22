#ifndef GADTOOLSBOX_TEXTCLASS_H
#define GADTOOLSBOX_TEXTCLASS_H
/*
**      $VER: gadtoolsbox/textclass.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      Definitions for the TEXT BOOPSI class.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/* tags for the text class system */
#define TX_TagBase          (TAG_USER+1)

#define TX_TextAttr         (TX_TagBase+1)
#define TX_Style            (TX_TagBase+2)
#define TX_ForceTextPen     (TX_TagBase+3)
#define TX_Underscore       (TX_TagBase+4)
#define TX_Flags            (TX_TagBase+5)
#define TX_Text             (TX_TagBase+6)
#define TX_NoBox            (TX_TagBase+7)

#endif
