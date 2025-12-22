@DATABASE "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h"
@MASTER   "gg:os-include/intuition/gadgetclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/gadgetclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/gadgetclass.h" LINK File}


@{b}Structures@{ub}

@{"gpDomain" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 476}    @{"gpGoInactive" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 436}  @{"gpHitTest" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 344}  @{"gpInput" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 393}   @{"gpKeyGoInactive" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 538}
@{"gpKeyInput" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 522}  @{"gpKeyTest" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 503}     @{"gpLayout" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 460}   @{"gpRender" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 377}  


@{b}#defines@{ub}

@{"GA_ActivateKey" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 197}         @{"GA_BackFill" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 201}            @{"GA_Border" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 68}
@{"GA_BottomBorder" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 134}        @{"GA_Bounds" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 177}              @{"GA_Disabled" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 78}
@{"GA_DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 159}            @{"GA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 30}               @{"GA_EndGadget" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 100}
@{"GA_FollowMouse" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 115}         @{"GA_GadgetHelp" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 173}          @{"GA_GadgetHelpText" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 205}
@{"GA_GZZGadget" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 82}           @{"GA_Height" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 55}              @{"GA_Highlight" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 74}
@{"GA_ID" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 87}                  @{"GA_Image" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 65}               @{"GA_Immediate" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 105}
@{"GA_IntuiText" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 163}           @{"GA_LabelImage" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 166}          @{"GA_Left" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 32}
@{"GA_LeftBorder" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 126}          @{"GA_Next" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 156}                @{"GA_Previous" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 150}
@{"GA_ReadOnly" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 189}            @{"GA_RelBottom" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 44}           @{"GA_RelHeight" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 58}
@{"GA_RelRight" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 36}            @{"GA_RelSpecial" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 181}          @{"GA_RelVerify" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 110}
@{"GA_RelWidth" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 51}            @{"GA_RightBorder" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 122}         @{"GA_Selected" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 96}
@{"GA_SelectRender" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 71}        @{"GA_SpecialInfo" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 93}         @{"GA_SysGadget" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 142}
@{"GA_SysGType" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 146}            @{"GA_TabCycle" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 169}            @{"GA_Text" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 62}
@{"GA_TextAttr" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 185}            @{"GA_ToggleSelect" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 138}        @{"GA_Top" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 40}
@{"GA_TopBorder" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 130}           @{"GA_Underscore" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 193}          @{"GA_UserData" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 90}
@{"GA_UserInput" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 209}           @{"GA_Width" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 48}               @{"GDOMAIN_MAXIMUM" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 492}
@{"GDOMAIN_MINIMUM" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 486}        @{"GDOMAIN_NOMINAL" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 489}        @{"GM_DOMAIN" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 323}
@{"GM_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 295}               @{"GM_GOACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 305}            @{"GM_GOINACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 311}
@{"GM_HANDLEINPUT" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 308}         @{"GM_HELPTEST" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 314}            @{"GM_HITTEST" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 298}
@{"GM_KEYGOACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 331}         @{"GM_KEYGOINACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 333}       @{"GM_KEYTEST" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 327}
@{"GM_LAYOUT" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 318}              @{"GM_RENDER" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 302}              @{"GMR_GADGETHIT" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 368}
@{"GMR_HELPCODE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 372}           @{"GMR_HELPHIT" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 371}            @{"GMR_KEYACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 530}
@{"GMR_KEYVERIFY" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 531}          @{"GMR_MEACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 420}           @{"GMR_NEXTACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 430}
@{"GMR_NOHELPHIT" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 370}          @{"GMR_NOREUSE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 421}            @{"GMR_PREVACTIVE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 431}
@{"GMR_REUSE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 422}              @{"GMR_VERIFY" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 423}             @{"GREDRAW_REDRAW" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 387}
@{"GREDRAW_TOGGLE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 388}         @{"GREDRAW_UPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 386}         @{"LAYOUTA_ChildMaxHeight" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 283}
@{"LAYOUTA_ChildMaxWidth" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 280}  @{"LAYOUTA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 275}          @{"LAYOUTA_LayoutObj" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 276}
@{"LAYOUTA_Orientation" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 278}    @{"LAYOUTA_Spacing" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 277}        @{"LORIENT_HORIZ" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 289}
@{"LORIENT_NONE" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 288}           @{"LORIENT_VERT" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 290}           @{"PGA_Borderless" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 220}
@{"PGA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 217}              @{"PGA_Freedom" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 218}            @{"PGA_HorizBody" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 222}
@{"PGA_HorizPot" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 221}           @{"PGA_NewLook" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 229}            @{"PGA_Top" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 227}
@{"PGA_Total" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 225}              @{"PGA_VertBody" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 224}           @{"PGA_VertPot" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 223}
@{"PGA_Visible" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 226}            @{"SG_DEFAULTMAXCHARS" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 270}     @{"STRINGA_ActivePens" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 251}
@{"STRINGA_AltKeyMap" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 248}      @{"STRINGA_Buffer" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 243}         @{"STRINGA_BufferPos" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 246}
@{"STRINGA_DispPos" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 247}        @{"STRINGA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 234}          @{"STRINGA_EditHook" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 252}
@{"STRINGA_EditModes" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 253}      @{"STRINGA_ExitHelp" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 265}       @{"STRINGA_FixedFieldMode" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 257}
@{"STRINGA_Font" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 249}           @{"STRINGA_Justification" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 260}  @{"STRINGA_LongVal" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 262}
@{"STRINGA_MaxChars" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 235}       @{"STRINGA_NoFilterMode" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 258}   @{"STRINGA_Pens" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 250}
@{"STRINGA_ReplaceMode" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 256}    @{"STRINGA_TextVal" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 263}        @{"STRINGA_UndoBuffer" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 244}
@{"STRINGA_WorkBuffer" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File" 245}     

@ENDNODE
@NODE File "intuition/gadgetclass.h"
#ifndef INTUITION_GADGETCLASS_H
#define INTUITION_GADGETCLASS_H
/*
**      $VER: gadgetclass.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Custom and 'boopsi' gadget class interface
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/*****************************************************************************/

/* NOTE:  <@{"intuition/iobsolete.h" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File"}> is included at the END of this file! */

/*****************************************************************************/

/* Gadget class attributes */
#define GA_Dummy                (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x30000)

#define GA_Left                 (@{"GA_Dummy" LINK File 30}+1)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Left edge of the gadget relative to the left edge of
     * the window */

#define GA_RelRight             (@{"GA_Dummy" LINK File 30}+2)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Left edge of the gadget relative to the right edge of
     * the window */

#define GA_Top                  (@{"GA_Dummy" LINK File 30}+3)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Top edge of the gadget relative to the top edge of
     * the window */

#define GA_RelBottom            (@{"GA_Dummy" LINK File 30}+4)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Top edge of the gadget relative to the bottom edge
     * of the window */

#define GA_Width                (@{"GA_Dummy" LINK File 30}+5)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Width of the gadget */

#define GA_RelWidth             (@{"GA_Dummy" LINK File 30}+6)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Width of the gadget relative to the width of the
     * window */

#define GA_Height               (@{"GA_Dummy" LINK File 30}+7)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Height of the gadget */

#define GA_RelHeight            (@{"GA_Dummy" LINK File 30}+8)
    /* (@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}) Height of the gadget relative to the height of
     * the window */

#define GA_Text                 (@{"GA_Dummy" LINK File 30}+9)
    /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Gadget imagry is @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} terminated string */

#define GA_Image                (@{"GA_Dummy" LINK File 30}+10)
    /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Gadget imagry is an image */

#define GA_Border               (@{"GA_Dummy" LINK File 30}+11)
    /* (@{"struct Border" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 684} *) Gadget imagry is a border */

#define GA_SelectRender         (@{"GA_Dummy" LINK File 30}+12)
    /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Selected gadget imagry */

#define GA_Highlight            (@{"GA_Dummy" LINK File 30}+13)
    /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) One of @{"GFLG_GADGHNONE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 295}, @{"GFLG_GADGHBOX" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 293}, @{"GFLG_GADGHCOMP" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 292},
     * or @{"GFLG_GADGHIMAGE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 294} */

#define GA_Disabled             (@{"GA_Dummy" LINK File 30}+14)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether gadget is disabled or not.
     * Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_GZZGadget            (@{"GA_Dummy" LINK File 30}+15)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is for
     * @{"WFLG_GIMMEZEROZERO" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1042} window borders or not.  Defaults
     * to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_ID                   (@{"GA_Dummy" LINK File 30}+16)
    /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Gadget ID assigned by the application */

#define GA_UserData             (@{"GA_Dummy" LINK File 30}+17)
    /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) Application specific data */

#define GA_SpecialInfo          (@{"GA_Dummy" LINK File 30}+18)
    /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) Gadget specific data */

#define GA_Selected             (@{"GA_Dummy" LINK File 30}+19)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is selected or not.
     * Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98} */

#define GA_EndGadget            (@{"GA_Dummy" LINK File 30}+20)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) When set tells the system that when this gadget
     * is selected causes the requester that it is in to be
     * ended.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_Immediate            (@{"GA_Dummy" LINK File 30}+21)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) When set indicates that the gadget is to
     * notify the application when it becomes active.  Defaults
     * to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_RelVerify            (@{"GA_Dummy" LINK File 30}+22)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) When set indicates that the application wants to
     * verify that the pointer was still over the gadget when
     * the select button is released.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_FollowMouse          (@{"GA_Dummy" LINK File 30}+23)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) When set indicates that the application wants to
     * be notified of mouse movements while the gadget is active.
     * It is recommmended that @{"GA_Immediate" LINK File 105} and @{"GA_RelVerify" LINK File 110} are
     * also used so that the active gadget can be tracked by the
     * application.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_RightBorder          (@{"GA_Dummy" LINK File 30}+24)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is in the right border
     * or not.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_LeftBorder           (@{"GA_Dummy" LINK File 30}+25)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is in the left border
     * or not.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_TopBorder            (@{"GA_Dummy" LINK File 30}+26)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is in the top border
     * or not.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_BottomBorder         (@{"GA_Dummy" LINK File 30}+27)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is in the bottom border
     * or not.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_ToggleSelect         (@{"GA_Dummy" LINK File 30}+28)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether the gadget is toggle-selected
     * or not.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_SysGadget            (@{"GA_Dummy" LINK File 30}+29)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Reserved for system use to indicate that the
     * gadget belongs to the system.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define GA_SysGType             (@{"GA_Dummy" LINK File 30}+30)
    /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Reserved for system use to indicate the
     * gadget type. */

#define GA_Previous             (@{"GA_Dummy" LINK File 30}+31)
    /* (@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *) Previous gadget in the linked list.
     * NOTE: This attribute CANNOT be used to link new gadgets
     * into the gadget list of an open window or requester.
     * You must use @{"AddGList()" LINK "gg:doc/NDK/Guide/intuition/AddGList"}. */

#define GA_Next                 (@{"GA_Dummy" LINK File 30}+32)
    /* (@{"struct Gadget" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 214} *) Next gadget in the linked list. */

#define GA_DrawInfo             (@{"GA_Dummy" LINK File 30}+33)
    /* (@{"struct DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 66} *) Some gadgets need a DrawInfo at creation time */

/* You should use at most ONE of @{"GA_Text" LINK File 62}, @{"GA_IntuiText" LINK File 163}, and @{"GA_LabelImage" LINK File 166} */
#define GA_IntuiText            (@{"GA_Dummy" LINK File 30}+34)
    /* (@{"struct IntuiText" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 656} *) Label is an IntuiText. */

#define GA_LabelImage           (@{"GA_Dummy" LINK File 30}+35)
    /* (Object *) Label is an image object. */

#define GA_TabCycle             (@{"GA_Dummy" LINK File 30}+36)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether gadget is part of TAB/SHIFT-TAB cycle
     * activation.  Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}.  New for V37. */

#define GA_GadgetHelp           (@{"GA_Dummy" LINK File 30}+37)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether gadget is to send @{"IDCMP_GADGETHELP" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 861}.
     * Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}.  New for V39. */

#define GA_Bounds               (@{"GA_Dummy" LINK File 30}+38)
    /* (@{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896} *) Copied into the extended gadget's bounds.
     * New for V39. */

#define GA_RelSpecial           (@{"GA_Dummy" LINK File 30}+39)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate whether gadget has special relativity.  Defaults to
     * @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}.  New for V39. */

#define GA_TextAttr             (@{"GA_Dummy" LINK File 30}+40)
    /* (@{"struct TextAttr" LINK "gg:doc/NDK/Guide/Include/graphics/text.h/File" 65} *) Indicate the font to use for the gadget.
     * New for V42. */

#define GA_ReadOnly             (@{"GA_Dummy" LINK File 30}+41)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Indicate that the gadget is read-only (non-selectable).
     * Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. New for V42. */

#define GA_Underscore           (@{"GA_Dummy" LINK File 30}+42)
    /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Underscore/escape character for keyboard shortcuts.
     * Defaults to '_' . New for V44. */

#define GA_ActivateKey          (@{"GA_Dummy" LINK File 30}+43)
    /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Set/Get the gadgets shortcut/activation key(s)
     * Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. New for V44. */

#define GA_BackFill             (@{"GA_Dummy" LINK File 30}+44)
    /* (@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) Backfill pattern hook.
     * Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. New for V44. */

#define GA_GadgetHelpText               (@{"GA_Dummy" LINK File 30}+45)
    /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) **RESERVERD/PRIVATE DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE**
     * Defaults to @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101}. New for V44. */

#define GA_UserInput            (@{"GA_Dummy" LINK File 30}+46)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Notification tag indicates this notification is from the activite
         * gadget receiving user input - an attempt to make @{"IDCMPUPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File" 132} more efficient.
     * Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. New for V44. */

/*****************************************************************************/

/* @{"PROPGCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 46} attributes */
#define PGA_Dummy       (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x31000)
#define PGA_Freedom     (@{"PGA_Dummy" LINK File 217}+0x0001)
        /* only one of @{"FREEVERT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 591} or @{"FREEHORIZ" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 590} */
#define PGA_Borderless  (@{"PGA_Dummy" LINK File 217}+0x0002)
#define PGA_HorizPot    (@{"PGA_Dummy" LINK File 217}+0x0003)
#define PGA_HorizBody   (@{"PGA_Dummy" LINK File 217}+0x0004)
#define PGA_VertPot     (@{"PGA_Dummy" LINK File 217}+0x0005)
#define PGA_VertBody    (@{"PGA_Dummy" LINK File 217}+0x0006)
#define PGA_Total       (@{"PGA_Dummy" LINK File 217}+0x0007)
#define PGA_Visible     (@{"PGA_Dummy" LINK File 217}+0x0008)
#define PGA_Top         (@{"PGA_Dummy" LINK File 217}+0x0009)
/* New for V37: */
#define PGA_NewLook     (@{"PGA_Dummy" LINK File 217}+0x000A)

/*****************************************************************************/

/* @{"STRGCLASS" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 47} attributes */
#define STRINGA_Dummy           (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}     +0x32000)
#define STRINGA_MaxChars        (@{"STRINGA_Dummy" LINK File 234}+0x0001)
/* Note:  There is a minor problem with Intuition when using boopsi integer
 * gadgets (which are requested by using STRINGA_LongInt).  Such gadgets
 * must not have a @{"STRINGA_MaxChars" LINK File 235} to be bigger than 15.  Setting
 * @{"STRINGA_MaxChars" LINK File 235} for a boopsi integer gadget will cause a mismatched
 * @{"FreeMem()" LINK "gg:doc/NDK/Guide/exec/FreeMem"} to occur.
 */

#define STRINGA_Buffer          (@{"STRINGA_Dummy" LINK File 234}+0x0002)
#define STRINGA_UndoBuffer      (@{"STRINGA_Dummy" LINK File 234}+0x0003)
#define STRINGA_WorkBuffer      (@{"STRINGA_Dummy" LINK File 234}+0x0004)
#define STRINGA_BufferPos       (@{"STRINGA_Dummy" LINK File 234}+0x0005)
#define STRINGA_DispPos         (@{"STRINGA_Dummy" LINK File 234}+0x0006)
#define STRINGA_AltKeyMap       (@{"STRINGA_Dummy" LINK File 234}+0x0007)
#define STRINGA_Font            (@{"STRINGA_Dummy" LINK File 234}+0x0008)
#define STRINGA_Pens            (@{"STRINGA_Dummy" LINK File 234}+0x0009)
#define STRINGA_ActivePens      (@{"STRINGA_Dummy" LINK File 234}+0x000A)
#define STRINGA_EditHook        (@{"STRINGA_Dummy" LINK File 234}+0x000B)
#define STRINGA_EditModes       (@{"STRINGA_Dummy" LINK File 234}+0x000C)

/* booleans */
#define STRINGA_ReplaceMode     (@{"STRINGA_Dummy" LINK File 234}+0x000D)
#define STRINGA_FixedFieldMode  (@{"STRINGA_Dummy" LINK File 234}+0x000E)
#define STRINGA_NoFilterMode    (@{"STRINGA_Dummy" LINK File 234}+0x000F)

#define STRINGA_Justification   (@{"STRINGA_Dummy" LINK File 234}+0x0010)
        /* @{"GACT_STRINGCENTER" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 425}, @{"GACT_STRINGLEFT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 424}, @{"GACT_STRINGRIGHT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 426} */
#define STRINGA_LongVal         (@{"STRINGA_Dummy" LINK File 234}+0x0011)
#define STRINGA_TextVal         (@{"STRINGA_Dummy" LINK File 234}+0x0012)

#define STRINGA_ExitHelp        (@{"STRINGA_Dummy" LINK File 234}+0x0013)
        /* @{"STRINGA_ExitHelp" LINK File 265} is new for V37, and ignored by V36.
         * Set this if you want the gadget to exit when Help is
         * pressed.  Look for a code of 0x5F, the rawkey code for Help */

#define SG_DEFAULTMAXCHARS      (128)

/*****************************************************************************/

/* Gadget layout related attributes */
#define LAYOUTA_Dummy           (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x38000)
#define LAYOUTA_LayoutObj       (@{"LAYOUTA_Dummy" LINK File 275}+0x0001)
#define LAYOUTA_Spacing         (@{"LAYOUTA_Dummy" LINK File 275}+0x0002)
#define LAYOUTA_Orientation     (@{"LAYOUTA_Dummy" LINK File 275}+0x0003)

#define LAYOUTA_ChildMaxWidth   (@{"LAYOUTA_Dummy" LINK File 275}+0x0004)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Child objects are of equal width.  Should default to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} for
     * gadgets with a horizontal orientation.  New for V42. */
#define LAYOUTA_ChildMaxHeight  (@{"LAYOUTA_Dummy" LINK File 275}+0x0005)
    /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Child objects are of equal height.  Should default to @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} for
     * gadgets with a vertical orientation.  New for V42. */

/* orientation values */
#define LORIENT_NONE    0
#define LORIENT_HORIZ   1
#define LORIENT_VERT    2

/*****************************************************************************/

/* Gadget Method ID's */
#define GM_Dummy        (-1)
    /* not used for anything */

#define GM_HITTEST      (0)
    /* return @{"GMR_GADGETHIT" LINK File 368} if you are clicked on (whether or not you
     * are disabled). */

#define GM_RENDER       (1)
    /* draw yourself, in the appropriate state */

#define GM_GOACTIVE     (2)
    /* you are now going to be fed input */

#define GM_HANDLEINPUT  (3)
    /* handle that input */

#define GM_GOINACTIVE   (4)
    /* whether or not by choice, you are done */

#define GM_HELPTEST     (5)
    /* Will you send gadget help if the mouse is at the specified coordinates?
     * See below for possible GMR_ values. */

#define GM_LAYOUT       (6)
    /* re-evaluate your size based on the GadgetInfo domain.
     * Do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} re-render yourself yet, you will be called when it is
     * time... */

#define GM_DOMAIN       (7)
    /* Used to obtain the sizing requirements of an object.  Does not
     * require an object. */

#define GM_KEYTEST      (8)
    /* return @{"GMR_GADGETHIT" LINK File 368} if you activation key matches (whether or not you
     * are disabled). */

#define GM_KEYGOACTIVE  (9)

#define GM_KEYGOINACTIVE        (10)

/*****************************************************************************/

/* Parameter "Messages" passed to gadget class methods  */

/* @{"GM_HITTEST" LINK File 298} and @{"GM_HELPTEST" LINK File 314} send this message.
 * For @{"GM_HITTEST" LINK File 298}, gpht_Mouse are coordinates relative to the gadget
 * select box.  For @{"GM_HELPTEST" LINK File 314}, the coordinates are relative to
 * the gadget bounding box (which defaults to the select box).
 */
struct gpHitTest
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpht_GInfo;
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    X;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Y;
    }                   gpht_Mouse;
};

/* For @{"GM_HITTEST" LINK File 298}, return @{"GMR_GADGETHIT" LINK File 368} if you were indeed hit,
 * otherwise return zero.
 *
 * For @{"GM_HELPTEST" LINK File 314}, return @{"GMR_NOHELPHIT" LINK File 370} (zero) if you were not hit.
 * Typically, return @{"GMR_HELPHIT" LINK File 371} if you were hit.
 * It is possible to pass a @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} to the application via the Code field
 * of the @{"IDCMP_GADGETHELP" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 861} message.  Return @{"GMR_HELPCODE" LINK File 372} or'd with
 * the @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}-sized result you wish to return.
 *
 * @{"GMR_HELPHIT" LINK File 371} yields a Code value of ((@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) ~0), which should
 * mean "nothing particular" to the application.
 */

#define GMR_GADGETHIT   (0x00000004)    /* @{"GM_HITTEST" LINK File 298} hit */

#define GMR_NOHELPHIT   (0x00000000)    /* @{"GM_HELPTEST" LINK File 314} didn't hit */
#define GMR_HELPHIT     (0xFFFFFFFF)    /* @{"GM_HELPTEST" LINK File 314} hit, return code = ~0 */
#define GMR_HELPCODE    (0x00010000)    /* @{"GM_HELPTEST" LINK File 314} hit, return low word as code */

/*****************************************************************************/

/* @{"GM_RENDER" LINK File 302}    */
struct gpRender
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpr_GInfo;     /* gadget context               */
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}     *gpr_RPort;     /* all ready for use            */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                gpr_Redraw;     /* might be a "highlight pass"  */
};

/* values of gpr_Redraw */
#define GREDRAW_UPDATE  (2)     /* incremental update, e.g. prop slider */
#define GREDRAW_REDRAW  (1)     /* redraw gadget        */
#define GREDRAW_TOGGLE  (0)     /* toggle highlight, if applicable      */

/*****************************************************************************/

/* @{"GM_GOACTIVE" LINK File 305}, @{"GM_HANDLEINPUT" LINK File 308}  */
struct gpInput
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpi_GInfo;
    @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257}   *gpi_IEvent;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                *gpi_Termination;
    struct
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    X;
        @{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}    Y;
    }                   gpi_Mouse;

    /* (V39) Pointer to TabletData structure, if this event originated
     * from a tablet which sends @{"IESUBCLASS_NEWTABLET" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 84} events, or @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} if
     * not.
     *
     * DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} ATTEMPT TO READ THIS FIELD UNDER INTUITION PRIOR TO V39!
     * IT WILL BE INVALID!
     */
    @{"struct TabletData" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1652}   *gpi_TabletData;
};

/* @{"GM_HANDLEINPUT" LINK File 308} and @{"GM_GOACTIVE" LINK File 305}  return code flags    */
/* return @{"GMR_MEACTIVE" LINK File 420} (0) alone if you want more input.
 * Otherwise, return ONE of @{"GMR_NOREUSE" LINK File 421} and @{"GMR_REUSE" LINK File 422}, and optionally
 * @{"GMR_VERIFY" LINK File 423}.
 */
#define GMR_MEACTIVE    (0)
#define GMR_NOREUSE     (1 << 1)
#define GMR_REUSE       (1 << 2)
#define GMR_VERIFY      (1 << 3)        /* you MUST set gpi_Termination */

/* New for V37:
 * You can end activation with one of @{"GMR_NEXTACTIVE" LINK File 430} and @{"GMR_PREVACTIVE" LINK File 431},
 * which instructs Intuition to activate the next or previous gadget
 * that has @{"GFLG_TABCYCLE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 347} set.
 */
#define GMR_NEXTACTIVE  (1 << 4)
#define GMR_PREVACTIVE  (1 << 5)

/*****************************************************************************/

/* @{"GM_GOINACTIVE" LINK File 311} */
struct gpGoInactive
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpgi_GInfo;

    /* V37 field only!  DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} attempt to read under V36! */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               gpgi_Abort;     /* gpgi_Abort=1 if gadget was aborted
                                         * by Intuition and 0 if gadget went
                                         * inactive at its own request
                                         */
};

/*****************************************************************************/

/* New for V39: Intuition sends @{"GM_LAYOUT" LINK File 318} to any GREL_ gadget when
 * the gadget is added to the window (or when the window opens, if
 * the gadget was part of the NewWindow.FirstGadget or the @{"WA_Gadgets" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1217}
 * list), or when the window is resized.  Your gadget can set the
 * @{"GA_RelSpecial" LINK File 181} property to get @{"GM_LAYOUT" LINK File 318} events without Intuition
 * changing the interpretation of your gadget select box.  This
 * allows for completely arbitrary resizing/repositioning based on
 * window size.
 */
/* @{"GM_LAYOUT" LINK File 318} */
struct gpLayout
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpl_GInfo;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}               gpl_Initial;    /* non-zero if this method was invoked
                                         * during @{"AddGList()" LINK "gg:doc/NDK/Guide/intuition/AddGList"} or @{"OpenWindow()" LINK "gg:doc/NDK/Guide/intuition/OpenWindow"}
                                         * time.  zero if this method was invoked
                                         * during window resizing. */
};

/*****************************************************************************/

/* The @{"GM_DOMAIN" LINK File 323} method is used to obtain the sizing requirements of an
 * object for a class before ever creating an object. */

/* @{"GM_DOMAIN" LINK File 323} */
struct gpDomain
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpd_GInfo;
    @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52}     *gpd_RPort;     /* RastPort to layout for */
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                 gpd_Which;
    @{"struct IBox" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 896}          gpd_Domain;    /* Resulting domain */
    @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32}      *gpd_Attrs;     /* Additional attributes */
};

#define GDOMAIN_MINIMUM         (0)
    /* Minimum size */

#define GDOMAIN_NOMINAL         (1)
    /* Nominal size */

#define GDOMAIN_MAXIMUM         (2)
    /* Maximum size */


/*****************************************************************************/

/* The @{"GM_KEYTEST" LINK File 327} method is used to determin if a key press matches an
 * object's activation key(s). */

/* @{"GM_KEYTEST" LINK File 327} send this message.
 */
struct gpKeyTest
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                MethodID;
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpkt_GInfo;
    @{"struct IntuiMessage" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 763} *gpkt_IMsg;     /* The IntuiMessage that triggered this */
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                gpkt_VanillaKey;
};

/*****************************************************************************/

/* The @{"GM_KEYGOACTIVE" LINK File 331} method is called to "simulate" a gadget going down.
 * A gadget should render itself in a selected state when receiving
 * this message. If the class supports this method, it must return
 * @{"GMR_KEYACTIVE" LINK File 530}.
 *
 * If a gadget returns zero for this method, it will subsequently be
 * activated via @{"ActivateGadget()" LINK "gg:doc/NDK/Guide/intuition/ActivateGadget"} with a @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} IEvent.
 */

struct gpKeyInput
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                     /* @{"GM_KEYGOACTIVE" LINK File 331} */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25}   *gpk_GInfo;
    @{"struct InputEvent" LINK "gg:doc/NDK/Guide/Include/devices/inputevent.h/File" 257}   *gpk_IEvent;
    @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                *gpk_Termination;
};

#define GMR_KEYACTIVE   (1 << 4)
#define GMR_KEYVERIFY   (1 << 5)        /* you MUST set gpk_Termination */

/* The @{"GM_KEYGOINACTIVE" LINK File 333} method is called to simulate the gadget release.
 * Upon receiving this message, the gadget should do everything a
 * normal gadget release would do.
 */

struct gpKeyGoInactive
{
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID;                     /* @{"GM_KEYGOINACTIVE" LINK File 333} */
    @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *gpki_GInfo;
    @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} gpki_Abort;                   /* @{"TRUE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 95} if input was aborted */
};

/*****************************************************************************/

/* Include obsolete identifiers: */
#ifndef INTUITION_IOBSOLETE_H
#include <@{"intuition/iobsolete.h" LINK "gg:doc/NDK/Guide/Include/intuition/iobsolete.h/File"}>
#endif

/*****************************************************************************/

#endif
@ENDNODE
