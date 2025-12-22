@DATABASE "gg:doc/NDK/Guide/Include/reaction/reaction.h"
@MASTER   "gg:os-include/reaction/reaction.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:11
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "reaction/reaction.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"reaction/reaction.h" LINK File}


@{b}#defines@{ub}

@{"MAKE_ID()" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 20}          @{"REACTION_ChangePrefs" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 39}  @{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}  @{"REACTION_SpecialPens" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 43}
@{"REACTION_TextAttr" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 34}  

@ENDNODE
@NODE File "reaction/reaction.h"
#ifndef REACTION_REACTION_H
#define REACTION_REACTION_H
/*
**      $VER: reaction.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Reaction definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#ifndef MAKE_ID
#define @{"MAKE_ID" LINK "gg:doc/NDK/Guide/Include/libraries/iffparse.h/File" 182}(a,b,c,d) ((@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (a)<<24 | (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (b)<<16 | (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (c)<<8 | (@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}) (d))
#endif

/*****************************************************************************/

#ifndef REACTION_Dummy
#define REACTION_Dummy (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 0x5000000)
#endif

/* The Reaction tags below are used internally to layout and other
 * classes to make some magic happen. They are not intended for your
 * general usage.
 */

#define REACTION_TextAttr (@{"REACTION_Dummy" LINK File 26} + 5)
 /* (@{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} *) Class private tag set internally by layout
  * only. This tag sets a gadgets font, but does @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} override @{"GA_TextAttr" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 185}!
  */

#define REACTION_ChangePrefs (@{"REACTION_Dummy" LINK File 26} + 6)
 /* (@{"struct UIPrefs" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_prefs.h/File" 30} *) Signals classes of dynamic prefs change.
  */

#define REACTION_SpecialPens (@{"REACTION_Dummy" LINK File 26} + 7)
 /* (strut SpecialPens *) Pens used for Xen-style shadowing, etc.
  */

/*****************************************************************************/

#ifdef ALL_REACTION_CLASSES

#include <@{"proto/layout.h" LINK "gg:doc/NDK/Guide/Include/proto/layout.h/File"}>
#include <@{"gadgets/layout.h" LINK "gg:doc/NDK/Guide/Include/gadgets/layout.h/File"}>

#include <@{"proto/button.h" LINK "gg:doc/NDK/Guide/Include/proto/button.h/File"}>
#include <@{"gadgets/button.h" LINK "gg:doc/NDK/Guide/Include/gadgets/button.h/File"}>

#include <@{"proto/checkbox.h" LINK "gg:doc/NDK/Guide/Include/proto/checkbox.h/File"}>
#include <@{"gadgets/checkbox.h" LINK "gg:doc/NDK/Guide/Include/gadgets/checkbox.h/File"}>

#include <@{"proto/chooser.h" LINK "gg:doc/NDK/Guide/Include/proto/chooser.h/File"}>
#include <@{"gadgets/chooser.h" LINK "gg:doc/NDK/Guide/Include/gadgets/chooser.h/File"}>

#include <@{"proto/clicktab.h" LINK "gg:doc/NDK/Guide/Include/proto/clicktab.h/File"}>
#include <@{"gadgets/clicktab.h" LINK "gg:doc/NDK/Guide/Include/gadgets/clicktab.h/File"}>

#include <@{"proto/fuelgauge.h" LINK "gg:doc/NDK/Guide/Include/proto/fuelgauge.h/File"}>
#include <@{"gadgets/fuelgauge.h" LINK "gg:doc/NDK/Guide/Include/gadgets/fuelgauge.h/File"}>

#include <@{"proto/getfile.h" LINK "gg:doc/NDK/Guide/Include/proto/getfile.h/File"}>
#include <@{"gadgets/getfile.h" LINK "gg:doc/NDK/Guide/Include/gadgets/getfile.h/File"}>

#include <@{"proto/getfont.h" LINK "gg:doc/NDK/Guide/Include/proto/getfont.h/File"}>
#include <@{"gadgets/getfont.h" LINK "gg:doc/NDK/Guide/Include/gadgets/getfont.h/File"}>

#include <@{"proto/getscreenmode.h" LINK "gg:doc/NDK/Guide/Include/proto/getscreenmode.h/File"}>
#include <@{"gadgets/getscreenmode.h" LINK "gg:doc/NDK/Guide/Include/gadgets/getscreenmode.h/File"}>

#include <@{"proto/integer.h" LINK "gg:doc/NDK/Guide/Include/proto/integer.h/File"}>
#include <@{"gadgets/integer.h" LINK "gg:doc/NDK/Guide/Include/gadgets/integer.h/File"}>

#include <@{"proto/listbrowser.h" LINK "gg:doc/NDK/Guide/Include/proto/listbrowser.h/File"}>
#include <@{"gadgets/listbrowser.h" LINK "gg:doc/NDK/Guide/Include/gadgets/listbrowser.h/File"}>

#include <@{"proto/palette.h" LINK "gg:doc/NDK/Guide/Include/proto/palette.h/File"}>
#include <@{"gadgets/palette.h" LINK "gg:doc/NDK/Guide/Include/gadgets/palette.h/File"}>

#include <@{"proto/radiobutton.h" LINK "gg:doc/NDK/Guide/Include/proto/radiobutton.h/File"}>
#include <@{"gadgets/radiobutton.h" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File"}>

#include <@{"proto/scroller.h" LINK "gg:doc/NDK/Guide/Include/proto/scroller.h/File"}>
#include <@{"gadgets/scroller.h" LINK "gg:doc/NDK/Guide/Include/gadgets/scroller.h/File"}>

#include <@{"proto/slider.h" LINK "gg:doc/NDK/Guide/Include/proto/slider.h/File"}>
#include <@{"gadgets/slider.h" LINK "gg:doc/NDK/Guide/Include/gadgets/slider.h/File"}>

#include <@{"proto/space.h" LINK "gg:doc/NDK/Guide/Include/proto/space.h/File"}>
#include <@{"gadgets/space.h" LINK "gg:doc/NDK/Guide/Include/gadgets/space.h/File"}>

#include <@{"proto/speedbar.h" LINK "gg:doc/NDK/Guide/Include/proto/speedbar.h/File"}>
#include <@{"gadgets/speedbar.h" LINK "gg:doc/NDK/Guide/Include/gadgets/speedbar.h/File"}>

#include <@{"proto/string.h" LINK "gg:doc/NDK/Guide/Include/proto/string.h/File"}>
#include <@{"gadgets/string.h" LINK "gg:doc/NDK/Guide/Include/gadgets/string.h/File"}>

#include <@{"proto/bevel.h" LINK "gg:doc/NDK/Guide/Include/proto/bevel.h/File"}>
#include <@{"images/bevel.h" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File"}>

#include <@{"proto/bitmap.h" LINK "gg:doc/NDK/Guide/Include/proto/bitmap.h/File"}>
#include <@{"images/bitmap.h" LINK "gg:doc/NDK/Guide/Include/images/bitmap.h/File"}>

#include <@{"proto/drawlist.h" LINK "gg:doc/NDK/Guide/Include/proto/drawlist.h/File"}>
#include <@{"images/drawlist.h" LINK "gg:doc/NDK/Guide/Include/images/drawlist.h/File"}>

#include <@{"proto/glyph.h" LINK "gg:doc/NDK/Guide/Include/proto/glyph.h/File"}>
#include <@{"images/glyph.h" LINK "gg:doc/NDK/Guide/Include/images/glyph.h/File"}>

#include <@{"proto/label.h" LINK "gg:doc/NDK/Guide/Include/proto/label.h/File"}>
#include <@{"images/label.h" LINK "gg:doc/NDK/Guide/Include/images/label.h/File"}>

#include <@{"proto/penmap.h" LINK "gg:doc/NDK/Guide/Include/proto/penmap.h/File"}>
#include <@{"images/penmap.h" LINK "gg:doc/NDK/Guide/Include/images/penmap.h/File"}>

#include <@{"proto/window.h" LINK "gg:doc/NDK/Guide/Include/proto/window.h/File"}>
#include <@{"classes/window.h" LINK "gg:doc/NDK/Guide/Include/classes/window.h/File"}>

#include <@{"classes/requester.h" LINK "gg:doc/NDK/Guide/Include/classes/requester.h/File"}>
#include <@{"proto/requester.h" LINK "gg:doc/NDK/Guide/Include/proto/requester.h/File"}>

#include <@{"proto/arexx.h" LINK "gg:doc/NDK/Guide/Include/proto/arexx.h/File"}>
#include <@{"classes/arexx.h" LINK "gg:doc/NDK/Guide/Include/classes/arexx.h/File"}>

#endif /* ALL_REACTION_CLASSES */

/*****************************************************************************/

#ifdef ALL_REACTION_MACROS
#ifndef REACTION_MACROS_H
#include <@{"reaction/reaction_macros.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction_macros.h/File"}>
#endif /* REACTION_MACROS_H */
#endif /* ALL_REACTION_MACROS */

/*****************************************************************************/

#endif /* REACTION_REACTION_H */
@ENDNODE
