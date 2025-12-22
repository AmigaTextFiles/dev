OPT NATIVE, PREPROCESS
MODULE 'target/exec/types'
{MODULE 'mui/TextEditor_mcc'}

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
#define TextEditorObject    Mui_NewObjectA(MUIC_TextEditor,[TAG_IGNORE,0

CONST TEXTEDITOR_DUMMY   = ($ad000000)

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
CONST MUIA_TextEditor_MultiColorQuoting     = (TEXTEDITOR_DUMMY + $31)
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
CONST MUIA_TextEditor_Rows                  = (TEXTEDITOR_DUMMY + $32)
CONST MUIA_TextEditor_Columns               = (TEXTEDITOR_DUMMY + $33)
CONST MUIA_TextEditor_AutoClip              = (TEXTEDITOR_DUMMY + $34)
CONST MUIA_TextEditor_CursorPosition        = (TEXTEDITOR_DUMMY + $35)
CONST MUIA_TextEditor_KeyUpFocus            = (TEXTEDITOR_DUMMY + $36)
CONST MUIA_TextEditor_UndoLevels            = (TEXTEDITOR_DUMMY + $38)
CONST MUIA_TextEditor_WrapMode              = (TEXTEDITOR_DUMMY + $39)
CONST MUIA_TextEditor_ActiveObjectOnClick   = (TEXTEDITOR_DUMMY + $3a)

NATIVE {MUIM_TextEditor_AddKeyBindings}        CONST MUIM_TextEditor_AddKeyBindings        = (TEXTEDITOR_DUMMY + $22)
NATIVE {MUIM_TextEditor_ARexxCmd}              CONST MUIM_TextEditor_ARexxCmd              = (TEXTEDITOR_DUMMY + $23)
CONST MUIM_TextEditor_BlockInfo             = (TEXTEDITOR_DUMMY + $30)
NATIVE {MUIM_TextEditor_ClearText}             CONST MUIM_TextEditor_ClearText             = (TEXTEDITOR_DUMMY + $24)
CONST MUIM_TextEditor_ExportBlock           = (TEXTEDITOR_DUMMY + $37)
NATIVE {MUIM_TextEditor_ExportText}            CONST MUIM_TextEditor_ExportText            = (TEXTEDITOR_DUMMY + $25)
NATIVE {MUIM_TextEditor_HandleError}           CONST MUIM_TextEditor_HandleError           = (TEXTEDITOR_DUMMY + $1f)
NATIVE {MUIM_TextEditor_InsertText}            CONST MUIM_TextEditor_InsertText            = (TEXTEDITOR_DUMMY + $26)
NATIVE {MUIM_TextEditor_MacroBegin}            CONST MUIM_TextEditor_MacroBegin            = (TEXTEDITOR_DUMMY + $27)
NATIVE {MUIM_TextEditor_MacroEnd}              CONST MUIM_TextEditor_MacroEnd              = (TEXTEDITOR_DUMMY + $28)
NATIVE {MUIM_TextEditor_MacroExecute}          CONST MUIM_TextEditor_MacroExecute          = (TEXTEDITOR_DUMMY + $29)
NATIVE {MUIM_TextEditor_Replace}               CONST MUIM_TextEditor_Replace               = (TEXTEDITOR_DUMMY + $2a)
NATIVE {MUIM_TextEditor_Search}                CONST MUIM_TextEditor_Search                = (TEXTEDITOR_DUMMY + $2b)
NATIVE {MUIM_TextEditor_MarkText}              CONST MUIM_TextEditor_MarkText              = (TEXTEDITOR_DUMMY + $2c)
CONST MUIM_TextEditor_QueryKeyAction        = (TEXTEDITOR_DUMMY + $2d)

NATIVE {muip_texteditor_arexxcmd} OBJECT muip_texteditor_arexxcmd
	{methodid}	methodid	:ULONG
	{command}	command	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT

OBJECT muip_texteditor_blockinfo
	methodid	:ULONG
	startx	:PTR TO ULONG
	starty	:PTR TO ULONG
	stopx	:PTR TO ULONG
	stopy	:PTR TO ULONG
ENDOBJECT

NATIVE {muip_texteditor_cleartext} OBJECT muip_texteditor_cleartext
	{methodid}	methodid	:ULONG
ENDOBJECT

OBJECT muip_texteditor_exportblock
	methodid	:ULONG
	flags	:ULONG
ENDOBJECT

NATIVE {muip_texteditor_exporttext} OBJECT muip_texteditor_exporttext
	{methodid}	methodid	:ULONG
ENDOBJECT

NATIVE {muip_texteditor_handleerror} OBJECT muip_texteditor_handleerror
	{methodid}	methodid	:ULONG
	{errorcode}	errorcode	:ULONG
ENDOBJECT /* See below for error codes */

NATIVE {muip_texteditor_inserttext} OBJECT muip_texteditor_inserttext
	{methodid}	methodid	:ULONG
	{text}	text	:/*STRPTR*/ ARRAY OF CHAR
	{pos}	pos	:VALUE
ENDOBJECT /* See below for positions */

OBJECT muip_texteditor_replace
	methodid	:ULONG
	newstring	:/*STRPTR*/ ARRAY OF CHAR
	flags	:ULONG
ENDOBJECT

OBJECT muip_texteditor_search
	methodid	:ULONG
	searchstring	:/*STRPTR*/ ARRAY OF CHAR
	flags	:ULONG
ENDOBJECT

NATIVE {muip_texteditor_marktext} OBJECT muip_texteditor_marktext
	{methodid}	methodid	:ULONG
	{start_crsr_x}	start_crsr_x	:ULONG
	{start_crsr_y}	start_crsr_y	:ULONG
	{stop_crsr_x}	stop_crsr_x	:ULONG
	{stop_crsr_y}	stop_crsr_y	:ULONG
ENDOBJECT

OBJECT muip_texteditor_querykeyaction
	methodid	:ULONG
	keyaction	:ULONG
ENDOBJECT

NATIVE {MUIV_TextEditor_ExportHook_Plain}       CONST MUIV_TextEditor_ExportHook_Plain       = $00000000
NATIVE {MUIV_TextEditor_ExportHook_EMail}       CONST MUIV_TextEditor_ExportHook_EMail       = $00000001
CONST MUIV_TextEditor_ExportHook_NoStyle     = $00000002

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
CONST MUIV_TextEditor_WrapMode_NoWrap        = $00000000
CONST MUIV_TextEditor_WrapMode_SoftWrap      = $00000001
CONST MUIV_TextEditor_WrapMode_HardWrap      = $00000002

/* Values for MUIM_TextEditor_MarkText */
CONST MUIV_TextEditor_MarkText_All           = -1
CONST MUIV_TextEditor_MarkText_None          = -1

/* Flags for MUIM_TextEditor_Search */
CONST MUIF_TextEditor_Search_FromTop         = 1 SHL 0
CONST MUIF_TextEditor_Search_Next            = 1 SHL 1
CONST MUIF_TextEditor_Search_CaseSensitive   = 1 SHL 2
CONST MUIF_TextEditor_Search_DOSPattern      = 1 SHL 3
CONST MUIF_TextEditor_Search_Backwards       = 1 SHL 4

/* Flags for MUIM_TextEditor_ExportBlock */
CONST MUIF_TextEditor_ExportBlock_FullLines  = 1 SHL 0

/* Error codes given as argument to MUIM_TextEditor_HandleError */
NATIVE {ERROR_ClipboardIsEmpty}         CONST ERROR_ClipboardIsEmpty         = $01
NATIVE {ERROR_ClipboardIsNotFTXT}       CONST ERROR_ClipboardIsNotFTXT       = $02
NATIVE {ERROR_MacroBufferIsFull}        CONST ERROR_MacroBufferIsFull        = $03
NATIVE {ERROR_MemoryAllocationFailed}   CONST ERROR_MemoryAllocationFailed   = $04
NATIVE {ERROR_NoAreaMarked}             CONST ERROR_NoAreaMarked             = $05
NATIVE {ERROR_NoMacroDefined}           CONST ERROR_NoMacroDefined           = $06
NATIVE {ERROR_NothingToRedo}            CONST ERROR_NothingToRedo            = $07
NATIVE {ERROR_NothingToUndo}            CONST ERROR_NothingToUndo            = $08
NATIVE {ERROR_NotEnoughUndoMem}         CONST ERROR_NotEnoughUndoMem         = $09 /* This will cause all the stored undos to be freed */
NATIVE {ERROR_StringNotFound}           CONST ERROR_StringNotFound           = $0a
NATIVE {ERROR_NoBookmarkInstalled}      CONST ERROR_NoBookmarkInstalled      = $0b
NATIVE {ERROR_BookmarkHasBeenLost}      CONST ERROR_BookmarkHasBeenLost      = $0c

NATIVE {clickmessage} OBJECT clickmessage
  {linecontents}	linecontents	:/*STRPTR*/ ARRAY OF CHAR  /* This field is ReadOnly!!! */
  {clickposition}	clickposition	:ULONG
  ->{qualifier}	qualifier	:ULONG     /* V15.26+, a possible qualifier that was pressed during the double click */
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
CONST MUIV_TextEditor_KeyAction_Up              = $00
CONST MUIV_TextEditor_KeyAction_Down            = $01
CONST MUIV_TextEditor_KeyAction_Left            = $02
CONST MUIV_TextEditor_KeyAction_Right           = $03
CONST MUIV_TextEditor_KeyAction_PageUp          = $04
CONST MUIV_TextEditor_KeyAction_PageDown        = $05
CONST MUIV_TextEditor_KeyAction_StartOfLine     = $06
CONST MUIV_TextEditor_KeyAction_EndOfLine       = $07
CONST MUIV_TextEditor_KeyAction_Top             = $08
CONST MUIV_TextEditor_KeyAction_Bottom          = $09
CONST MUIV_TextEditor_KeyAction_PrevWord        = $0a
CONST MUIV_TextEditor_KeyAction_NextWord        = $0b
CONST MUIV_TextEditor_KeyAction_PrevLine        = $0c
CONST MUIV_TextEditor_KeyAction_NextLine        = $0d
CONST MUIV_TextEditor_KeyAction_PrevSentence    = $0e
CONST MUIV_TextEditor_KeyAction_NextSentence    = $0f
CONST MUIV_TextEditor_KeyAction_SuggestWord     = $10
CONST MUIV_TextEditor_KeyAction_BackSpace       = $11
CONST MUIV_TextEditor_KeyAction_Delete          = $12
CONST MUIV_TextEditor_KeyAction_Return          = $13
CONST MUIV_TextEditor_KeyAction_Tab             = $14
CONST MUIV_TextEditor_KeyAction_Cut             = $15
CONST MUIV_TextEditor_KeyAction_Copy            = $16
CONST MUIV_TextEditor_KeyAction_Paste           = $17
CONST MUIV_TextEditor_KeyAction_Undo            = $18
CONST MUIV_TextEditor_KeyAction_Redo            = $19
CONST MUIV_TextEditor_KeyAction_DelBOL          = $1a
CONST MUIV_TextEditor_KeyAction_DelEOL          = $1b
CONST MUIV_TextEditor_KeyAction_DelBOW          = $1c
CONST MUIV_TextEditor_KeyAction_DelEOW          = $1d
CONST MUIV_TextEditor_KeyAction_NextGadget      = $1e
CONST MUIV_TextEditor_KeyAction_GotoBookmark1   = $1f
CONST MUIV_TextEditor_KeyAction_GotoBookmark2   = $20
CONST MUIV_TextEditor_KeyAction_GotoBookmark3   = $21
CONST MUIV_TextEditor_KeyAction_SetBookmark1    = $22
CONST MUIV_TextEditor_KeyAction_SetBookmark2    = $23
CONST MUIV_TextEditor_KeyAction_SetBookmark3    = $24
CONST MUIV_TextEditor_KeyAction_DelLine         = $25
CONST MUIV_TextEditor_KeyAction_SelectAll       = $26
CONST MUIV_TextEditor_KeyAction_SelectNone      = $27

/* result structure for MUIM_TextEditor_QueryKeyAction */
OBJECT muip_texteditor_keybinding
  code	:UINT       -> the RAWKEY code      read only
  qualifier	:ULONG  -> the Qualifier flags  read only
  action	:UINT     -> the keyaction        read only
ENDOBJECT
