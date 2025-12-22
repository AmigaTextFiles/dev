OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{#include <mui/TextEditor_mcc.h>}
NATIVE {TEXTEDITOR_MCC_H} CONST

/***************************************************************************

 TextEditor.mcc - Textediting MUI Custom Class
 Copyright (C) 1997-2000 Allan Odgaard
 Copyright (C) 2005-2007 by TextEditor.mcc Open Source Team

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.

 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.

 TextEditor class Support Site:  http://www.sf.net/projects/texteditor-mcc

 $Id: TextEditor_mcc.h 441 2008-01-04 10:45:21Z thboeckel $

***************************************************************************/

NATIVE {MUIC_TextEditor}     CONST
#define MUIC_TextEditor muic_texteditor
STATIC muic_texteditor     = 'TextEditor.mcc'

NATIVE {TextEditorObject}    CONST
#define TextEditorObject    Mui_NewObject(MUIC_TextEditor

NATIVE {TextEditor_Dummy}   CONST TEXTEDITOR_DUMMY   = ($ad000000)

NATIVE {MUIA_TextEditor_AreaMarked}            CONST MUIA_TextEditor_AreaMarked            = (TEXTEDITOR_DUMMY + $14)
NATIVE {MUIA_TextEditor_ColorMap}              CONST MUIA_TextEditor_ColorMap              = (TEXTEDITOR_DUMMY + $2f)
NATIVE {MUIA_TextEditor_Contents}              CONST MUIA_TextEditor_Contents              = (TEXTEDITOR_DUMMY + $02)
NATIVE {MUIA_TextEditor_CursorX}               CONST MUIA_TextEditor_CursorX               = (TEXTEDITOR_DUMMY + $04)
NATIVE {MUIA_TextEditor_CursorY}               CONST MUIA_TextEditor_CursorY               = (TEXTEDITOR_DUMMY + $05)
NATIVE {MUIA_TextEditor_DoubleClickHook}       CONST MUIA_TextEditor_DoubleClickHook       = (TEXTEDITOR_DUMMY + $06)
NATIVE {MUIA_TextEditor_ExportHook}            CONST MUIA_TextEditor_ExportHook            = (TEXTEDITOR_DUMMY + $08)
NATIVE {MUIA_TextEditor_ExportWrap}            CONST MUIA_TextEditor_ExportWrap            = (TEXTEDITOR_DUMMY + $09)
NATIVE {MUIA_TextEditor_FixedFont}             CONST MUIA_TextEditor_FixedFont             = (TEXTEDITOR_DUMMY + $0a)
NATIVE {MUIA_TextEditor_Flow}                  CONST MUIA_TextEditor_Flow                  = (TEXTEDITOR_DUMMY + $0b)
NATIVE {MUIA_TextEditor_HasChanged}            CONST MUIA_TextEditor_HasChanged            = (TEXTEDITOR_DUMMY + $0c)
NATIVE {MUIA_TextEditor_ImportHook}            CONST MUIA_TextEditor_ImportHook            = (TEXTEDITOR_DUMMY + $0e)
NATIVE {MUIA_TextEditor_ImportWrap}            CONST MUIA_TextEditor_ImportWrap            = (TEXTEDITOR_DUMMY + $10)
NATIVE {MUIA_TextEditor_InsertMode}            CONST MUIA_TextEditor_InsertMode            = (TEXTEDITOR_DUMMY + $0f)
NATIVE {MUIA_TextEditor_InVirtualGroup}        CONST MUIA_TextEditor_InVirtualGroup        = (TEXTEDITOR_DUMMY + $1b)
NATIVE {MUIA_TextEditor_KeyBindings}           CONST MUIA_TextEditor_KeyBindings           = (TEXTEDITOR_DUMMY + $11)
NATIVE {MUIA_TextEditor_MultiColorQuoting}     CONST MUIA_TextEditor_MultiColorQuoting     = (TEXTEDITOR_DUMMY + $31)
NATIVE {MUIA_TextEditor_NumLock}               CONST MUIA_TextEditor_NumLock               = (TEXTEDITOR_DUMMY + $18)
NATIVE {MUIA_TextEditor_Pen}                   CONST MUIA_TextEditor_Pen                   = (TEXTEDITOR_DUMMY + $2e)
NATIVE {MUIA_TextEditor_Prop_DeltaFactor}      CONST MUIA_TextEditor_Prop_DeltaFactor      = (TEXTEDITOR_DUMMY + $0d)
NATIVE {MUIA_TextEditor_Prop_Entries}          CONST MUIA_TextEditor_Prop_Entries          = (TEXTEDITOR_DUMMY + $15)
NATIVE {MUIA_TextEditor_Prop_First}            CONST MUIA_TextEditor_Prop_First            = (TEXTEDITOR_DUMMY + $20)
NATIVE {MUIA_TextEditor_Prop_Visible}          CONST MUIA_TextEditor_Prop_Visible          = (TEXTEDITOR_DUMMY + $16)
NATIVE {MUIA_TextEditor_Quiet}                 CONST MUIA_TextEditor_Quiet                 = (TEXTEDITOR_DUMMY + $17)
NATIVE {MUIA_TextEditor_ReadOnly}              CONST MUIA_TextEditor_ReadOnly              = (TEXTEDITOR_DUMMY + $19)
NATIVE {MUIA_TextEditor_RedoAvailable}         CONST MUIA_TextEditor_RedoAvailable         = (TEXTEDITOR_DUMMY + $13)
NATIVE {MUIA_TextEditor_Separator}             CONST MUIA_TextEditor_Separator             = (TEXTEDITOR_DUMMY + $2c)
NATIVE {MUIA_TextEditor_Slider}                CONST MUIA_TextEditor_Slider                = (TEXTEDITOR_DUMMY + $1a)
NATIVE {MUIA_TextEditor_StyleBold}             CONST MUIA_TextEditor_StyleBold             = (TEXTEDITOR_DUMMY + $1c)
NATIVE {MUIA_TextEditor_StyleItalic}           CONST MUIA_TextEditor_StyleItalic           = (TEXTEDITOR_DUMMY + $1d)
NATIVE {MUIA_TextEditor_StyleUnderline}        CONST MUIA_TextEditor_StyleUnderline        = (TEXTEDITOR_DUMMY + $1e)
NATIVE {MUIA_TextEditor_TypeAndSpell}          CONST MUIA_TextEditor_TypeAndSpell          = (TEXTEDITOR_DUMMY + $07)
NATIVE {MUIA_TextEditor_UndoAvailable}         CONST MUIA_TextEditor_UndoAvailable         = (TEXTEDITOR_DUMMY + $12)
NATIVE {MUIA_TextEditor_WrapBorder}            CONST MUIA_TextEditor_WrapBorder            = (TEXTEDITOR_DUMMY + $21)
NATIVE {MUIA_TextEditor_Rows}                  CONST MUIA_TextEditor_Rows                  = (TEXTEDITOR_DUMMY + $32)
NATIVE {MUIA_TextEditor_Columns}               CONST MUIA_TextEditor_Columns               = (TEXTEDITOR_DUMMY + $33)
NATIVE {MUIA_TextEditor_AutoClip}              CONST MUIA_TextEditor_AutoClip              = (TEXTEDITOR_DUMMY + $34)
NATIVE {MUIA_TextEditor_CursorPosition}        CONST MUIA_TextEditor_CursorPosition        = (TEXTEDITOR_DUMMY + $35)
NATIVE {MUIA_TextEditor_KeyUpFocus}            CONST MUIA_TextEditor_KeyUpFocus            = (TEXTEDITOR_DUMMY + $36)
NATIVE {MUIA_TextEditor_UndoLevels}            CONST MUIA_TextEditor_UndoLevels            = (TEXTEDITOR_DUMMY + $38)
NATIVE {MUIA_TextEditor_WrapMode}              CONST MUIA_TextEditor_WrapMode              = (TEXTEDITOR_DUMMY + $39)
NATIVE {MUIA_TextEditor_ActiveObjectOnClick}   CONST MUIA_TextEditor_ActiveObjectOnClick   = (TEXTEDITOR_DUMMY + $3a)

NATIVE {MUIM_TextEditor_AddKeyBindings}        CONST MUIM_TextEditor_AddKeyBindings        = (TEXTEDITOR_DUMMY + $22)
NATIVE {MUIM_TextEditor_ARexxCmd}              CONST MUIM_TextEditor_ARexxCmd              = (TEXTEDITOR_DUMMY + $23)
NATIVE {MUIM_TextEditor_BlockInfo}             CONST MUIM_TextEditor_BlockInfo             = (TEXTEDITOR_DUMMY + $30)
NATIVE {MUIM_TextEditor_ClearText}             CONST MUIM_TextEditor_ClearText             = (TEXTEDITOR_DUMMY + $24)
NATIVE {MUIM_TextEditor_ExportBlock}           CONST MUIM_TextEditor_ExportBlock           = (TEXTEDITOR_DUMMY + $37)
NATIVE {MUIM_TextEditor_ExportText}            CONST MUIM_TextEditor_ExportText            = (TEXTEDITOR_DUMMY + $25)
NATIVE {MUIM_TextEditor_HandleError}           CONST MUIM_TextEditor_HandleError           = (TEXTEDITOR_DUMMY + $1f)
NATIVE {MUIM_TextEditor_InsertText}            CONST MUIM_TextEditor_InsertText            = (TEXTEDITOR_DUMMY + $26)
NATIVE {MUIM_TextEditor_MacroBegin}            CONST MUIM_TextEditor_MacroBegin            = (TEXTEDITOR_DUMMY + $27)
NATIVE {MUIM_TextEditor_MacroEnd}              CONST MUIM_TextEditor_MacroEnd              = (TEXTEDITOR_DUMMY + $28)
NATIVE {MUIM_TextEditor_MacroExecute}          CONST MUIM_TextEditor_MacroExecute          = (TEXTEDITOR_DUMMY + $29)
NATIVE {MUIM_TextEditor_Replace}               CONST MUIM_TextEditor_Replace               = (TEXTEDITOR_DUMMY + $2a)
NATIVE {MUIM_TextEditor_Search}                CONST MUIM_TextEditor_Search                = (TEXTEDITOR_DUMMY + $2b)
NATIVE {MUIM_TextEditor_MarkText}              CONST MUIM_TextEditor_MarkText              = (TEXTEDITOR_DUMMY + $2c)
NATIVE {MUIM_TextEditor_QueryKeyAction}        CONST MUIM_TextEditor_QueryKeyAction        = (TEXTEDITOR_DUMMY + $2d)

NATIVE {MUIP_TextEditor_ARexxCmd} OBJECT muip_texteditor_arexxcmd
	{MethodID}	methodid	:ULONG
	{command}	command	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

NATIVE {MUIP_TextEditor_BlockInfo} OBJECT muip_texteditor_blockinfo
	{MethodID}	methodid	:ULONG
	{startx}	startx	:PTR TO ULONG
	{starty}	starty	:PTR TO ULONG
	{stopx}	stopx	:PTR TO ULONG
	{stopy}	stopy	:PTR TO ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_ClearText} OBJECT muip_texteditor_cleartext
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_ExportBlock} OBJECT muip_texteditor_exportblock
	{MethodID}	methodid	:ULONG
	{flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_ExportText} OBJECT muip_texteditor_exporttext
	{MethodID}	methodid	:ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_HandleError} OBJECT muip_texteditor_handleerror
	{MethodID}	methodid	:ULONG
	{errorcode}	errorcode	:ULONG
ENDOBJECT /* See below for error codes */

NATIVE {MUIP_TextEditor_InsertText} OBJECT muip_texteditor_inserttext
	{MethodID}	methodid	:ULONG
	{text}	text	:/*STRPTR*/ ARRAY OF CHAR
	{pos}	pos	:VALUE
ENDOBJECT /* See below for positions */

NATIVE {MUIP_TextEditor_Replace} OBJECT muip_texteditor_replace
	{MethodID}	methodid	:ULONG
	{NewString}	newstring	:/*STRPTR*/ ARRAY OF CHAR
	{Flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_Search} OBJECT muip_texteditor_search
	{MethodID}	methodid	:ULONG
	{SearchString}	searchstring	:/*STRPTR*/ ARRAY OF CHAR
	{Flags}	flags	:ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_MarkText} OBJECT muip_texteditor_marktext
	{MethodID}	methodid	:ULONG
	{start_crsr_x}	start_crsr_x	:ULONG
	{start_crsr_y}	start_crsr_y	:ULONG
	{stop_crsr_x}	stop_crsr_x	:ULONG
	{stop_crsr_y}	stop_crsr_y	:ULONG
ENDOBJECT

NATIVE {MUIP_TextEditor_QueryKeyAction} OBJECT muip_texteditor_querykeyaction
	{MethodID}	methodid	:ULONG
	{keyAction}	keyaction	:ULONG
ENDOBJECT

NATIVE {MUIV_TextEditor_ExportHook_Plain}       CONST MUIV_TextEditor_ExportHook_Plain       = $00000000
NATIVE {MUIV_TextEditor_ExportHook_EMail}       CONST MUIV_TextEditor_ExportHook_EMail       = $00000001
NATIVE {MUIV_TextEditor_ExportHook_NoStyle}     CONST MUIV_TextEditor_ExportHook_NoStyle     = $00000002

NATIVE {MUIV_TextEditor_Flow_Left}              CONST MUIV_TextEditor_Flow_Left              = $00000000
NATIVE {MUIV_TextEditor_Flow_Center}            CONST MUIV_TextEditor_Flow_Center            = $00000001
NATIVE {MUIV_TextEditor_Flow_Right}             CONST MUIV_TextEditor_Flow_Right             = $00000002
NATIVE {MUIV_TextEditor_Flow_Justified}         CONST MUIV_TextEditor_Flow_Justified         = $00000003

NATIVE {MUIV_TextEditor_ImportHook_Plain}       CONST MUIV_TextEditor_ImportHook_Plain       = $00000000
NATIVE {MUIV_TextEditor_ImportHook_EMail}       CONST MUIV_TextEditor_ImportHook_EMail       = $00000002
NATIVE {MUIV_TextEditor_ImportHook_MIME}        CONST MUIV_TextEditor_ImportHook_MIME        = $00000003
NATIVE {MUIV_TextEditor_ImportHook_MIMEQuoted}  CONST MUIV_TextEditor_ImportHook_MIMEQuoted  = $00000004

NATIVE {MUIV_TextEditor_InsertText_Cursor}      CONST MUIV_TextEditor_InsertText_Cursor      = $00000000
NATIVE {MUIV_TextEditor_InsertText_Top}         CONST MUIV_TextEditor_InsertText_Top         = $00000001
NATIVE {MUIV_TextEditor_InsertText_Bottom}      CONST MUIV_TextEditor_InsertText_Bottom      = $00000002

/* Values for MUIA_TextEditor_WrapMode */
NATIVE {MUIV_TextEditor_WrapMode_NoWrap}        CONST MUIV_TextEditor_WrapMode_NoWrap        = $00000000
NATIVE {MUIV_TextEditor_WrapMode_SoftWrap}      CONST MUIV_TextEditor_WrapMode_SoftWrap      = $00000001
NATIVE {MUIV_TextEditor_WrapMode_HardWrap}      CONST MUIV_TextEditor_WrapMode_HardWrap      = $00000002

/* Values for MUIM_TextEditor_MarkText */
NATIVE {MUIV_TextEditor_MarkText_All}           CONST MUIV_TextEditor_MarkText_All           = -1
NATIVE {MUIV_TextEditor_MarkText_None}          CONST MUIV_TextEditor_MarkText_None          = -1

/* Flags for MUIM_TextEditor_Search */
NATIVE {MUIF_TextEditor_Search_FromTop}         CONST MUIF_TextEditor_Search_FromTop         = 1 SHL 0
NATIVE {MUIF_TextEditor_Search_Next}            CONST MUIF_TextEditor_Search_Next            = 1 SHL 1
NATIVE {MUIF_TextEditor_Search_CaseSensitive}   CONST MUIF_TextEditor_Search_CaseSensitive   = 1 SHL 2
NATIVE {MUIF_TextEditor_Search_DOSPattern}      CONST MUIF_TextEditor_Search_DOSPattern      = 1 SHL 3
NATIVE {MUIF_TextEditor_Search_Backwards}       CONST MUIF_TextEditor_Search_Backwards       = 1 SHL 4

/* Flags for MUIM_TextEditor_ExportBlock */
NATIVE {MUIF_TextEditor_ExportBlock_FullLines}  CONST MUIF_TextEditor_ExportBlock_FullLines  = 1 SHL 0

/* Error codes given as argument to MUIM_TextEditor_HandleError */
NATIVE {Error_ClipboardIsEmpty}         CONST ERROR_ClipboardIsEmpty         = $01
NATIVE {Error_ClipboardIsNotFTXT}       CONST ERROR_ClipboardIsNotFTXT       = $02
NATIVE {Error_MacroBufferIsFull}        CONST ERROR_MacroBufferIsFull        = $03
NATIVE {Error_MemoryAllocationFailed}   CONST ERROR_MemoryAllocationFailed   = $04
NATIVE {Error_NoAreaMarked}             CONST ERROR_NoAreaMarked             = $05
NATIVE {Error_NoMacroDefined}           CONST ERROR_NoMacroDefined           = $06
NATIVE {Error_NothingToRedo}            CONST ERROR_NothingToRedo            = $07
NATIVE {Error_NothingToUndo}            CONST ERROR_NothingToUndo            = $08
NATIVE {Error_NotEnoughUndoMem}         CONST ERROR_NotEnoughUndoMem         = $09 /* This will cause all the stored undos to be freed */
NATIVE {Error_StringNotFound}           CONST ERROR_StringNotFound           = $0a
NATIVE {Error_NoBookmarkInstalled}      CONST ERROR_NoBookmarkInstalled      = $0b
NATIVE {Error_BookmarkHasBeenLost}      CONST ERROR_BookmarkHasBeenLost      = $0c

NATIVE {ClickMessage} OBJECT clickmessage
  {LineContents}	linecontents	:/*STRPTR*/ ARRAY OF CHAR  /* This field is ReadOnly!!! */
  {ClickPosition}	clickposition	:ULONG
  {Qualifier}	qualifier	:ULONG     /* V15.26+, a possible qualifier that was pressed during the double click */
ENDOBJECT

/* Definitions for Separator type */
NATIVE {LNSB_Top}             CONST LNSB_Top             = 0 /* Mutual exclude: */
NATIVE {LNSB_Middle}          CONST LNSB_Middle          = 1 /* Placement of    */
NATIVE {LNSB_Bottom}          CONST LNSB_Bottom          = 2 /*  the separator  */
NATIVE {LNSB_StrikeThru}      CONST LNSB_StrikeThru      = 3 /* Let separator go thru the textfont */
NATIVE {LNSB_Thick}           CONST LNSB_Thick           = 4 /* Extra thick separator */

NATIVE {LNSF_Top}             CONST LNSF_Top             = (1 SHL LNSB_Top)
NATIVE {LNSF_Middle}          CONST LNSF_Middle          = (1 SHL LNSB_Middle)
NATIVE {LNSF_Bottom}          CONST LNSF_Bottom          = (1 SHL LNSB_Bottom)
NATIVE {LNSF_StrikeThru}      CONST LNSF_StrikeThru      = (1 SHL LNSB_StrikeThru)
NATIVE {LNSF_Thick}           CONST LNSF_Thick           = (1 SHL LNSB_Thick)

/* Keyaction definitions */
NATIVE {MUIV_TextEditor_KeyAction_Up}              CONST MUIV_TextEditor_KeyAction_Up              = $00
NATIVE {MUIV_TextEditor_KeyAction_Down}            CONST MUIV_TextEditor_KeyAction_Down            = $01
NATIVE {MUIV_TextEditor_KeyAction_Left}            CONST MUIV_TextEditor_KeyAction_Left            = $02
NATIVE {MUIV_TextEditor_KeyAction_Right}           CONST MUIV_TextEditor_KeyAction_Right           = $03
NATIVE {MUIV_TextEditor_KeyAction_PageUp}          CONST MUIV_TextEditor_KeyAction_PageUp          = $04
NATIVE {MUIV_TextEditor_KeyAction_PageDown}        CONST MUIV_TextEditor_KeyAction_PageDown        = $05
NATIVE {MUIV_TextEditor_KeyAction_StartOfLine}     CONST MUIV_TextEditor_KeyAction_StartOfLine     = $06
NATIVE {MUIV_TextEditor_KeyAction_EndOfLine}       CONST MUIV_TextEditor_KeyAction_EndOfLine       = $07
NATIVE {MUIV_TextEditor_KeyAction_Top}             CONST MUIV_TextEditor_KeyAction_Top             = $08
NATIVE {MUIV_TextEditor_KeyAction_Bottom}          CONST MUIV_TextEditor_KeyAction_Bottom          = $09
NATIVE {MUIV_TextEditor_KeyAction_PrevWord}        CONST MUIV_TextEditor_KeyAction_PrevWord        = $0a
NATIVE {MUIV_TextEditor_KeyAction_NextWord}        CONST MUIV_TextEditor_KeyAction_NextWord        = $0b
NATIVE {MUIV_TextEditor_KeyAction_PrevLine}        CONST MUIV_TextEditor_KeyAction_PrevLine        = $0c
NATIVE {MUIV_TextEditor_KeyAction_NextLine}        CONST MUIV_TextEditor_KeyAction_NextLine        = $0d
NATIVE {MUIV_TextEditor_KeyAction_PrevSentence}    CONST MUIV_TextEditor_KeyAction_PrevSentence    = $0e
NATIVE {MUIV_TextEditor_KeyAction_NextSentence}    CONST MUIV_TextEditor_KeyAction_NextSentence    = $0f
NATIVE {MUIV_TextEditor_KeyAction_SuggestWord}     CONST MUIV_TextEditor_KeyAction_SuggestWord     = $10
NATIVE {MUIV_TextEditor_KeyAction_Backspace}       CONST MUIV_TextEditor_KeyAction_BackSpace       = $11
NATIVE {MUIV_TextEditor_KeyAction_Delete}          CONST MUIV_TextEditor_KeyAction_Delete          = $12
NATIVE {MUIV_TextEditor_KeyAction_Return}          CONST MUIV_TextEditor_KeyAction_Return          = $13
NATIVE {MUIV_TextEditor_KeyAction_Tab}             CONST MUIV_TextEditor_KeyAction_Tab             = $14
NATIVE {MUIV_TextEditor_KeyAction_Cut}             CONST MUIV_TextEditor_KeyAction_Cut             = $15
NATIVE {MUIV_TextEditor_KeyAction_Copy}            CONST MUIV_TextEditor_KeyAction_Copy            = $16
NATIVE {MUIV_TextEditor_KeyAction_Paste}           CONST MUIV_TextEditor_KeyAction_Paste           = $17
NATIVE {MUIV_TextEditor_KeyAction_Undo}            CONST MUIV_TextEditor_KeyAction_Undo            = $18
NATIVE {MUIV_TextEditor_KeyAction_Redo}            CONST MUIV_TextEditor_KeyAction_Redo            = $19
NATIVE {MUIV_TextEditor_KeyAction_DelBOL}          CONST MUIV_TextEditor_KeyAction_DelBOL          = $1a
NATIVE {MUIV_TextEditor_KeyAction_DelEOL}          CONST MUIV_TextEditor_KeyAction_DelEOL          = $1b
NATIVE {MUIV_TextEditor_KeyAction_DelBOW}          CONST MUIV_TextEditor_KeyAction_DelBOW          = $1c
NATIVE {MUIV_TextEditor_KeyAction_DelEOW}          CONST MUIV_TextEditor_KeyAction_DelEOW          = $1d
NATIVE {MUIV_TextEditor_KeyAction_NextGadget}      CONST MUIV_TextEditor_KeyAction_NextGadget      = $1e
NATIVE {MUIV_TextEditor_KeyAction_GotoBookmark1}   CONST MUIV_TextEditor_KeyAction_GotoBookmark1   = $1f
NATIVE {MUIV_TextEditor_KeyAction_GotoBookmark2}   CONST MUIV_TextEditor_KeyAction_GotoBookmark2   = $20
NATIVE {MUIV_TextEditor_KeyAction_GotoBookmark3}   CONST MUIV_TextEditor_KeyAction_GotoBookmark3   = $21
NATIVE {MUIV_TextEditor_KeyAction_SetBookmark1}    CONST MUIV_TextEditor_KeyAction_SetBookmark1    = $22
NATIVE {MUIV_TextEditor_KeyAction_SetBookmark2}    CONST MUIV_TextEditor_KeyAction_SetBookmark2    = $23
NATIVE {MUIV_TextEditor_KeyAction_SetBookmark3}    CONST MUIV_TextEditor_KeyAction_SetBookmark3    = $24
NATIVE {MUIV_TextEditor_KeyAction_DelLine}         CONST MUIV_TextEditor_KeyAction_DelLine         = $25
NATIVE {MUIV_TextEditor_KeyAction_SelectAll}       CONST MUIV_TextEditor_KeyAction_SelectAll       = $26
NATIVE {MUIV_TextEditor_KeyAction_SelectNone}      CONST MUIV_TextEditor_KeyAction_SelectNone      = $27

/* result structure for MUIM_TextEditor_QueryKeyAction */
NATIVE {MUIP_TextEditor_Keybinding} OBJECT muip_texteditor_keybinding
  {code}	code	:UINT       -> the RAWKEY code      read only
  {qualifier}	qualifier	:ULONG  -> the Qualifier flags  read only
  {action}	action	:UINT     -> the keyaction        read only
ENDOBJECT
