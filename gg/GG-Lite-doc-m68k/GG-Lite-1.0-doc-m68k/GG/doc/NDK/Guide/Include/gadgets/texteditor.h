@DATABASE "gg:doc/NDK/Guide/Include/gadgets/texteditor.h"
@MASTER   "gg:os-include/gadgets/texteditor.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:47
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/texteditor.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/texteditor.h" LINK File}


@{b}Structures@{ub}

@{"ClickMessage" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 134}              @{"GP_TEXTEDITOR_ARexxCmd" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 82}
@{"GP_TEXTEDITOR_BlockInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 83}   @{"GP_TEXTEDITOR_ClearText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 84}
@{"GP_TEXTEDITOR_ExportText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 85}  @{"GP_TEXTEDITOR_HandleError" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 86}
@{"GP_TEXTEDITOR_InsertText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 87}  @{"GP_TEXTEDITOR_MarkText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 88}
@{"GP_TEXTEDITOR_Replace" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 89}     @{"GP_TEXTEDITOR_Search" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 90}


@{b}#defines@{ub}

@{"Error_BookmarkHasBeenLost" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 132}            @{"Error_ClipboardIsEmpty" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 121}
@{"Error_ClipboardIsNotFTXT" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 122}             @{"Error_MacroBufferIsFull" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 123}
@{"Error_MemoryAllocationFailed" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 124}         @{"Error_NoAreaMarked" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 125}
@{"Error_NoBookmarkInstalled" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 131}            @{"Error_NoMacroDefined" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 126}
@{"Error_NotEnoughUndoMem" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 129}               @{"Error_NothingToRedo" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 127}
@{"Error_NothingToUndo" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 128}                  @{"Error_StringNotFound" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 130}
@{"GA_TEXTEDITOR_AreaMarked" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 31}             @{"GA_TEXTEDITOR_ColorMap" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 32}
@{"GA_TEXTEDITOR_Contents" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 33}               @{"GA_TEXTEDITOR_CursorX" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 34}
@{"GA_TEXTEDITOR_CursorY" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 35}                @{"GA_TEXTEDITOR_DoubleClickHook" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 36}
@{"GA_TEXTEDITOR_ExportHook" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 37}             @{"GA_TEXTEDITOR_ExportWrap" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 38}
@{"GA_TEXTEDITOR_FixedFont" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 39}              @{"GA_TEXTEDITOR_Flow" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 40}
@{"GA_TEXTEDITOR_HasChanged" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 41}             @{"GA_TEXTEDITOR_HorizontalScroll" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 42}
@{"GA_TEXTEDITOR_ImportHook" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 43}             @{"GA_TEXTEDITOR_ImportWrap" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 44}
@{"GA_TEXTEDITOR_InsertMode" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 45}             @{"GA_TEXTEDITOR_KeyBindings" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 46}
@{"GA_TEXTEDITOR_NumLock" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 47}                @{"GA_TEXTEDITOR_Pen" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 48}
@{"GA_TEXTEDITOR_PopWindow_Open" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 49}         @{"GA_TEXTEDITOR_Prop_DeltaFactor" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 50}
@{"GA_TEXTEDITOR_Prop_Entries" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 51}           @{"GA_TEXTEDITOR_Prop_First" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 52}
@{"GA_TEXTEDITOR_Prop_Release" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 53}           @{"GA_TEXTEDITOR_Prop_Visible" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 54}
@{"GA_TEXTEDITOR_Quiet" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 55}                  @{"GA_TEXTEDITOR_ReadOnly" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 56}
@{"GA_TEXTEDITOR_RedoAvailable" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 57}          @{"GA_TEXTEDITOR_Separator" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 58}
@{"GA_TEXTEDITOR_StyleBold" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 59}              @{"GA_TEXTEDITOR_StyleItalic" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 60}
@{"GA_TEXTEDITOR_StyleUnderline" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 61}         @{"GA_TEXTEDITOR_TypeAndSpell" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 62}
@{"GA_TEXTEDITOR_UndoAvailable" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 63}          @{"GA_TEXTEDITOR_WrapBorder" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 64}
@{"GF_TEXTEDITOR_Search_Backwards" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 118}       @{"GF_TEXTEDITOR_Search_CaseSensitive" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 116}
@{"GF_TEXTEDITOR_Search_DOSPattern" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 117}      @{"GF_TEXTEDITOR_Search_FromTop" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 114}
@{"GF_TEXTEDITOR_Search_Next" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 115}            @{"GM_TEXTEDITOR_AddKeyBindings" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 69}
@{"GM_TEXTEDITOR_ARexxCmd" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 70}               @{"GM_TEXTEDITOR_BlockInfo" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 71}
@{"GM_TEXTEDITOR_ClearText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 72}              @{"GM_TEXTEDITOR_ExportText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 73}
@{"GM_TEXTEDITOR_HandleError" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 74}            @{"GM_TEXTEDITOR_InsertText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 75}
@{"GM_TEXTEDITOR_MacroBegin" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 76}             @{"GM_TEXTEDITOR_MacroEnd" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 77}
@{"GM_TEXTEDITOR_MacroExecute" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 78}           @{"GM_TEXTEDITOR_MarkText" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 79}
@{"GM_TEXTEDITOR_Replace" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 80}                @{"GM_TEXTEDITOR_Search" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 81}
@{"GV_TEXTEDITOR_ExportHook_EMail" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 93}       @{"GV_TEXTEDITOR_ExportHook_Plain" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 92}
@{"GV_TEXTEDITOR_Flow_Center" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 96}            @{"GV_TEXTEDITOR_Flow_Justified" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 98}
@{"GV_TEXTEDITOR_Flow_Left" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 95}              @{"GV_TEXTEDITOR_Flow_Right" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 97}
@{"GV_TEXTEDITOR_ImportHook_EMail" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 101}       @{"GV_TEXTEDITOR_ImportHook_MIME" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 102}
@{"GV_TEXTEDITOR_ImportHook_MIMEQuoted" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 103}  @{"GV_TEXTEDITOR_ImportHook_Plain" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 100}
@{"GV_TEXTEDITOR_InsertText_Bottom" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 107}      @{"GV_TEXTEDITOR_InsertText_Cursor" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 105}
@{"GV_TEXTEDITOR_InsertText_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 106}         @{"GV_TEXTEDITOR_LengthHook_ANSI" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 110}
@{"GV_TEXTEDITOR_LengthHook_HTML" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 111}        @{"GV_TEXTEDITOR_LengthHook_MAIL" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 112}
@{"GV_TEXTEDITOR_LengthHook_Plain" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 109}       @{"LNSB_Bottom" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 144}
@{"LNSB_Middle" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 143}                          @{"LNSB_StrikeThru" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 145}
@{"LNSB_Thick" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 146}                           @{"LNSB_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 142}
@{"LNSF_Bottom" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 150}                          @{"LNSF_Middle" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 149}
@{"LNSF_StrikeThru" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 151}                      @{"LNSF_Thick" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 152}
@{"LNSF_Top" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 148}                             @{"TEXTEDITOR_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/texteditor.h/File" 29}

@ENDNODE
@NODE File "gadgets/texteditor.h"
#ifndef GADGETS_TEXTEDITOR_H
#define GADGETS_TEXTEDITOR_H
/*
**      $VER: texteditor.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for @{"texteditor.gadget" LINK "gg:doc/NDK/Guide/texteditor_gc/texteditor.gadget"} BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif

#ifndef IMAGES_BEVEL_H
#include <@{"images/bevel.h" LINK "gg:doc/NDK/Guide/Include/images/bevel.h/File"}>
#endif

/*****************************************************************************/

#define   @{"TEXTEDITOR_Dummy" LINK "File" 67}   (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x26000)

#define   @{"GA_TEXTEDITOR_AreaMarked" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_AreaMarked"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x14)
#define   @{"GA_TEXTEDITOR_ColorMap" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_ColorMap"}          (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2f)
#define   @{"GA_TEXTEDITOR_Contents" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Contents"}          (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x02)
#define   @{"GA_TEXTEDITOR_CursorX" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_CursorX"}           (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x04)
#define   @{"GA_TEXTEDITOR_CursorY" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_CursorY"}           (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x05)
#define   @{"GA_TEXTEDITOR_DoubleClickHook" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_DoubleClickHook"}   (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x06)
#define   @{"GA_TEXTEDITOR_ExportHook" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_ExportHook"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x08)
#define   @{"GA_TEXTEDITOR_ExportWrap" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_ExportWrap"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x09)
#define   @{"GA_TEXTEDITOR_FixedFont" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_FixedFont"}         (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x0a)
#define   @{"GA_TEXTEDITOR_Flow" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Flow"}              (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x0b)
#define   @{"GA_TEXTEDITOR_HasChanged" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_HasChanged"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x0c)
#define   GA_TEXTEDITOR_HorizontalScroll  (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2d) /* Private and experimental! */
#define   @{"GA_TEXTEDITOR_ImportHook" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_ImportHook"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x0e)
#define   @{"GA_TEXTEDITOR_ImportWrap" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_ImportWrap"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x10)
#define   @{"GA_TEXTEDITOR_InsertMode" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_InsertMode"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x0f)
#define   GA_TEXTEDITOR_KeyBindings       (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x11)
#define   GA_TEXTEDITOR_NumLock           (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x18)
#define   @{"GA_TEXTEDITOR_Pen" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Pen"}               (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2e)
#define   GA_TEXTEDITOR_PopWindow_Open    (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x03) /* Private!!! */
#define   @{"GA_TEXTEDITOR_Prop_DeltaFactor" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Prop_DeltaFactor"}  (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x0d)
#define   @{"GA_TEXTEDITOR_Prop_Entries" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Prop_Entries"}      (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x15)
#define   @{"GA_TEXTEDITOR_Prop_First" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Prop_First"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x20)
#define   GA_TEXTEDITOR_Prop_Release      (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x01) /* Private!!! */
#define   @{"GA_TEXTEDITOR_Prop_Visible" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Prop_Visible"}      (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x16)
#define   @{"GA_TEXTEDITOR_Quiet" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Quiet"}             (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x17)
#define   @{"GA_TEXTEDITOR_ReadOnly" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_ReadOnly"}          (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x19)
#define   @{"GA_TEXTEDITOR_RedoAvailable" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_RedoAvailable"}     (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x13)
#define   @{"GA_TEXTEDITOR_Separator" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_Separator"}         (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2c)
#define   @{"GA_TEXTEDITOR_StyleBold" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_StyleBold"}         (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x1c)
#define   @{"GA_TEXTEDITOR_StyleItalic" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_StyleItalic"}       (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x1d)
#define   @{"GA_TEXTEDITOR_StyleUnderline" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_StyleUnderline"}    (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x1e)
#define   @{"GA_TEXTEDITOR_TypeAndSpell" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_TypeAndSpell"}      (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x07)
#define   @{"GA_TEXTEDITOR_UndoAvailable" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_UndoAvailable"}     (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x12)
#define   @{"GA_TEXTEDITOR_WrapBorder" LINK "gg:doc/NDK/Guide/texteditor_gc/GA_TEXTEDITOR_WrapBorder"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x21)

#undef    TEXTEDITOR_Dummy
#define   @{"TEXTEDITOR_Dummy" LINK "File" 29}   (0x45000)

#define   GM_TEXTEDITOR_AddKeyBindings    (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x22)
#define   @{"GM_TEXTEDITOR_ARexxCmd" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_ARexxCmd"}          (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x23)
#define   GM_TEXTEDITOR_BlockInfo         (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x30)
#define   @{"GM_TEXTEDITOR_ClearText" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_ClearText"}         (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x24)
#define   @{"GM_TEXTEDITOR_ExportText" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_ExportText"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x25)
#define   @{"GM_TEXTEDITOR_HandleError" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_HandleError"}       (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x1f)
#define   @{"GM_TEXTEDITOR_InsertText" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_InsertText"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x26)
#define   @{"GM_TEXTEDITOR_MacroBegin" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_MacroBegin"}        (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x27)
#define   @{"GM_TEXTEDITOR_MacroEnd" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_MacroEnd"}          (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x28)
#define   @{"GM_TEXTEDITOR_MacroExecute" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_MacroExecute"}      (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x29)
#define   @{"GM_TEXTEDITOR_MarkText" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_MarkText"}          (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2c)
#define   GM_TEXTEDITOR_Replace           (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2a)
#define   @{"GM_TEXTEDITOR_Search" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_Search"}            (@{"TEXTEDITOR_Dummy" LINK File 29} + 0x2b)
struct    GP_TEXTEDITOR_ARexxCmd          { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} command; };
struct    GP_TEXTEDITOR_BlockInfo         { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *startx; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *starty; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *stopx; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *stopy; };
struct    GP_TEXTEDITOR_ClearText         { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; };
struct    GP_TEXTEDITOR_ExportText        { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; };
struct    GP_TEXTEDITOR_HandleError       { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} errorcode; }; /* See below for error codes */
struct    GP_TEXTEDITOR_InsertText        { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} text; @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pos; }; /* See below for positions */
struct    GP_TEXTEDITOR_MarkText          { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} start_crsr_x; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} start_crsr_y; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} stop_crsr_x; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} stop_crsr_y; };
struct    GP_TEXTEDITOR_Replace           { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} newstring; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags; };
struct    GP_TEXTEDITOR_Search            { @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} MethodID; @{"struct GadgetInfo" LINK "gg:doc/NDK/Guide/Include/intuition/cghooks.h/File" 25} *GInfo; @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} string; @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags; }; /* See below for flags */

#define   GV_TEXTEDITOR_ExportHook_Plain       0x00000000
#define   GV_TEXTEDITOR_ExportHook_EMail       0x00000001

#define   GV_TEXTEDITOR_Flow_Left              0x00000000
#define   GV_TEXTEDITOR_Flow_Center            0x00000001
#define   GV_TEXTEDITOR_Flow_Right             0x00000002
#define   GV_TEXTEDITOR_Flow_Justified         0x00000003

#define   GV_TEXTEDITOR_ImportHook_Plain       0x00000000
#define   GV_TEXTEDITOR_ImportHook_EMail       0x00000002
#define   GV_TEXTEDITOR_ImportHook_MIME        0x00000003
#define   GV_TEXTEDITOR_ImportHook_MIMEQuoted  0x00000004

#define   GV_TEXTEDITOR_InsertText_Cursor      0x00000000
#define   GV_TEXTEDITOR_InsertText_Top         0x00000001
#define   GV_TEXTEDITOR_InsertText_Bottom      0x00000002

#define   GV_TEXTEDITOR_LengthHook_Plain       0x00000000
#define   GV_TEXTEDITOR_LengthHook_ANSI        0x00000001
#define   GV_TEXTEDITOR_LengthHook_HTML        0x00000002
#define   GV_TEXTEDITOR_LengthHook_MAIL        0x00000003

#define   GF_TEXTEDITOR_Search_FromTop       (1 << 0)
#define   GF_TEXTEDITOR_Search_Next          (1 << 1)
#define   GF_TEXTEDITOR_Search_CaseSensitive (1 << 2)
#define   GF_TEXTEDITOR_Search_DOSPattern    (1 << 3)
#define   GF_TEXTEDITOR_Search_Backwards     (1 << 4)

/* Error codes given as argument to @{"GM_TEXTEDITOR_HandleError" LINK "gg:doc/NDK/Guide/texteditor_gc/GM_TEXTEDITOR_HandleError"} */
#define   Error_ClipboardIsEmpty         0x01
#define   Error_ClipboardIsNotFTXT       0x02
#define   Error_MacroBufferIsFull        0x03
#define   Error_MemoryAllocationFailed   0x04
#define   Error_NoAreaMarked             0x05
#define   Error_NoMacroDefined           0x06
#define   Error_NothingToRedo            0x07
#define   Error_NothingToUndo            0x08
#define   Error_NotEnoughUndoMem         0x09 /* This will cause all the stored undos to be freed */
#define   Error_StringNotFound           0x0a
#define   Error_NoBookmarkInstalled      0x0b
#define   Error_BookmarkHasBeenLost      0x0c

struct ClickMessage
{
   @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}  LineContents;  /* This field is ReadOnly!!! */
   @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   ClickPosition;
};

/* Definitions for Separator type */

#define LNSB_Top             0 /* Mutual exclude: */
#define LNSB_Middle          1 /* Placement of    */
#define LNSB_Bottom          2 /*  the separator  */
#define LNSB_StrikeThru      3 /* Let separator go thru the textfont */
#define LNSB_Thick           4 /* Extra thick separator */

#define LNSF_Top             (1<<@{"LNSB_Top" LINK File 142})
#define LNSF_Middle          (1<<@{"LNSB_Middle" LINK File 143})
#define LNSF_Bottom          (1<<@{"LNSB_Bottom" LINK File 144})
#define LNSF_StrikeThru      (1<<@{"LNSB_StrikeThru" LINK File 145})
#define LNSF_Thick           (1<<@{"LNSB_Thick" LINK File 146})

#endif /* GADGETS_TEXTEDITOR_H */
@ENDNODE
