/*
**  $VER: texteditor.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Definitions for texteditor.gadget BOOPSI class
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/*****************************************************************************/
MODULE 'intuition/gadgetclass','images/bevel'
/*****************************************************************************/
#define TEXTEDITOR_Dummy  (REACTION_Dummy + $26000)
#define GA_TEXTEDITOR_AreaMarked         (TEXTEDITOR_Dummy + $14)
#define GA_TEXTEDITOR_ColorMap           (TEXTEDITOR_Dummy + $2f)
#define GA_TEXTEDITOR_Contents           (TEXTEDITOR_Dummy + $02)
#define GA_TEXTEDITOR_CursorX            (TEXTEDITOR_Dummy + $04)
#define GA_TEXTEDITOR_CursorY            (TEXTEDITOR_Dummy + $05)
#define GA_TEXTEDITOR_DoubleClickHook    (TEXTEDITOR_Dummy + $06)
#define GA_TEXTEDITOR_ExportHook         (TEXTEDITOR_Dummy + $08)
#define GA_TEXTEDITOR_ExportWrap         (TEXTEDITOR_Dummy + $09)
#define GA_TEXTEDITOR_FixedFont          (TEXTEDITOR_Dummy + $0a)
#define GA_TEXTEDITOR_Flow               (TEXTEDITOR_Dummy + $0b)
#define GA_TEXTEDITOR_HasChanged         (TEXTEDITOR_Dummy + $0c)
#define GA_TEXTEDITOR_HorizontalScroll   (TEXTEDITOR_Dummy + $2d)   /* Private and experimental! */
#define GA_TEXTEDITOR_ImportHook         (TEXTEDITOR_Dummy + $0e)
#define GA_TEXTEDITOR_ImportWrap         (TEXTEDITOR_Dummy + $10)
#define GA_TEXTEDITOR_InsertMode         (TEXTEDITOR_Dummy + $0f)
#define GA_TEXTEDITOR_KeyBindings        (TEXTEDITOR_Dummy + $11)
#define GA_TEXTEDITOR_NumLock            (TEXTEDITOR_Dummy + $18)
#define GA_TEXTEDITOR_Pen                (TEXTEDITOR_Dummy + $2e)
#define GA_TEXTEDITOR_PopWindow_Open     (TEXTEDITOR_Dummy + $03)   /* Private!!! */
#define GA_TEXTEDITOR_Prop_DeltaFactor   (TEXTEDITOR_Dummy + $0d)
#define GA_TEXTEDITOR_Prop_Entries       (TEXTEDITOR_Dummy + $15)
#define GA_TEXTEDITOR_Prop_First         (TEXTEDITOR_Dummy + $20)
#define GA_TEXTEDITOR_Prop_Release       (TEXTEDITOR_Dummy + $01)   /* Private!!! */
#define GA_TEXTEDITOR_Prop_Visible       (TEXTEDITOR_Dummy + $16)
#define GA_TEXTEDITOR_Quiet              (TEXTEDITOR_Dummy + $17)
#define GA_TEXTEDITOR_ReadOnly           (TEXTEDITOR_Dummy + $19)
#define GA_TEXTEDITOR_RedoAvailable      (TEXTEDITOR_Dummy + $13)
#define GA_TEXTEDITOR_Separator          (TEXTEDITOR_Dummy + $2c)
#define GA_TEXTEDITOR_StyleBold          (TEXTEDITOR_Dummy + $1c)
#define GA_TEXTEDITOR_StyleItalic        (TEXTEDITOR_Dummy + $1d)
#define GA_TEXTEDITOR_StyleUnderline     (TEXTEDITOR_Dummy + $1e)
#define GA_TEXTEDITOR_TypeAndSpell       (TEXTEDITOR_Dummy + $07)
#define GA_TEXTEDITOR_UndoAvailable      (TEXTEDITOR_Dummy + $12)
#define GA_TEXTEDITOR_WrapBorder         (TEXTEDITOR_Dummy + $21)
#undef TEXTEDITOR_Dummy
#define TEXTEDITOR_Dummy    ($45000)
#define GM_TEXTEDITOR_AddKeyBindings     (TEXTEDITOR_Dummy + $22)
#define GM_TEXTEDITOR_ARexxCmd           (TEXTEDITOR_Dummy + $23)
#define GM_TEXTEDITOR_BlockInfo          (TEXTEDITOR_Dummy + $30)
#define GM_TEXTEDITOR_ClearText          (TEXTEDITOR_Dummy + $24)
#define GM_TEXTEDITOR_ExportText         (TEXTEDITOR_Dummy + $25)
#define GM_TEXTEDITOR_HandleError        (TEXTEDITOR_Dummy + $1f)
#define GM_TEXTEDITOR_InsertText         (TEXTEDITOR_Dummy + $26)
#define GM_TEXTEDITOR_MacroBegin         (TEXTEDITOR_Dummy + $27)
#define GM_TEXTEDITOR_MacroEnd           (TEXTEDITOR_Dummy + $28)
#define GM_TEXTEDITOR_MacroExecute       (TEXTEDITOR_Dummy + $29)
#define GM_TEXTEDITOR_MarkText           (TEXTEDITOR_Dummy + $2c)
#define GM_TEXTEDITOR_Replace            (TEXTEDITOR_Dummy + $2a)
#define GM_TEXTEDITOR_Search             (TEXTEDITOR_Dummy + $2b)
OBJECT GP_TEXTEDITOR_ARexxCmd
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  command:PTR TO UBYTE

OBJECT GP_TEXTEDITOR_BlockInfo
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  startx:PTR TO ULONG,
  starty:PTR TO ULONG,
  stopx:PTR TO ULONG,
  stopy:PTR TO ULONG

OBJECT GP_TEXTEDITOR_ClearText
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo

OBJECT GP_TEXTEDITOR_ExportText
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo

OBJECT GP_TEXTEDITOR_HandleError
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  errorcode:ULONG

/* See below for error codes */
OBJECT GP_TEXTEDITOR_InsertText
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  text:PTR TO UBYTE,
  pos:LONG

/* See below for positions */
OBJECT GP_TEXTEDITOR_MarkText
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  start_crsr_x:ULONG,
  start_crsr_y:ULONG,
  stop_crsr_x:ULONG,
  stop_crsr_y:ULONG

OBJECT GP_TEXTEDITOR_Replace
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  newstring:PTR TO UBYTE,
  flags:ULONG

OBJECT GP_TEXTEDITOR_Search
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  string:PTR TO UBYTE,
  flags:ULONG

/* See below for flags */
#define GV_TEXTEDITOR_ExportHook_Plain        $00000000
#define GV_TEXTEDITOR_ExportHook_EMail        $00000001
#define GV_TEXTEDITOR_Flow_Left               $00000000
#define GV_TEXTEDITOR_Flow_Center             $00000001
#define GV_TEXTEDITOR_Flow_Right              $00000002
#define GV_TEXTEDITOR_Flow_Justified          $00000003
#define GV_TEXTEDITOR_ImportHook_Plain        $00000000
#define GV_TEXTEDITOR_ImportHook_EMail        $00000002
#define GV_TEXTEDITOR_ImportHook_MIME         $00000003
#define GV_TEXTEDITOR_ImportHook_MIMEQuoted   $00000004
#define GV_TEXTEDITOR_InsertText_Cursor       $00000000
#define GV_TEXTEDITOR_InsertText_Top          $00000001
#define GV_TEXTEDITOR_InsertText_Bottom       $00000002
#define GV_TEXTEDITOR_LengthHook_Plain        $00000000
#define GV_TEXTEDITOR_LengthHook_ANSI         $00000001
#define GV_TEXTEDITOR_LengthHook_HTML         $00000002
#define GV_TEXTEDITOR_LengthHook_MAIL         $00000003
#define GF_TEXTEDITOR_Search_FromTop        (1 << 0)
#define GF_TEXTEDITOR_Search_Next           (1 << 1)
#define GF_TEXTEDITOR_Search_CaseSensitive  (1 << 2)
#define GF_TEXTEDITOR_Search_DOSPattern     (1 << 3)
#define GF_TEXTEDITOR_Search_Backwards      (1 << 4)
/* Error codes given as argument to GM_TEXTEDITOR_HandleError */
#define Error_ClipboardIsEmpty          $01
#define Error_ClipboardIsNotFTXT        $02
#define Error_MacroBufferIsFull         $03
#define Error_MemoryAllocationFailed    $04
#define Error_NoAreaMarked              $05
#define Error_NoMacroDefined            $06
#define Error_NothingToRedo             $07
#define Error_NothingToUndo             $08
#define Error_NotEnoughUndoMem          $09   /* This will cause all the stored undos to be freed */
#define Error_StringNotFound            $0a
#define Error_NoBookmarkInstalled       $0b
#define Error_BookmarkHasBeenLost       $0c
OBJECT ClickMessage
  LineContents:PTR TO UBYTE,    /* This field is ReadOnly!!! */
  ClickPosition:ULONG

/* Definitions for Separator type */
#define LNSB_Top              0 /* Mutual exclude: */
#define LNSB_Middle           1 /* Placement of    */
#define LNSB_Bottom           2 /*  the separator  */
#define LNSB_StrikeThru       3 /* Let separator go thru the textfont */
#define LNSB_Thick            4 /* Extra thick separator */
#define LNSF_Top              (1<<LNSB_Top)
#define LNSF_Middle           (1<<LNSB_Middle)
#define LNSF_Bottom           (1<<LNSB_Bottom)
#define LNSF_StrikeThru       (1<<LNSB_StrikeThru)
#define LNSF_Thick            (1<<LNSB_Thick)
