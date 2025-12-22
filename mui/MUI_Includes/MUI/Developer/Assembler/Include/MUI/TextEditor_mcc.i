	IFND	TEXTEDITOR_MCC_I
TEXTEDITOR_MCC_I	SET	1

** $VER: TextEditor_mcc.h V15.1 (12-Aug-97)
** Copyright © 1997 Allan Odgaard. All rights reserved.
**
** Assembler version by Ilkka Lehtoranta (29-Nov-99)

	IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
	ENDC

;#define   MUIC_TextEditor     "TextEditor.mcc"
;#define   TextEditorObject    MUI_NewObject(MUIC_TextEditor

TextEditor_Dummy	EQU	($ad000000)

MUIA_TextEditor_AreaMarked	EQU	(TextEditor_Dummy + $14)
MUIA_TextEditor_ColorMap	EQU	(TextEditor_Dummy + $2f)
MUIA_TextEditor_Contents	EQU	(TextEditor_Dummy + $02)
MUIA_TextEditor_CursorX		EQU	(TextEditor_Dummy + $04)
MUIA_TextEditor_CursorY		EQU	(TextEditor_Dummy + $05)
MUIA_TextEditor_DoubleClickHook	EQU	(TextEditor_Dummy + $06)
MUIA_TextEditor_ExportHook	EQU	(TextEditor_Dummy + $08)
MUIA_TextEditor_ExportWrap	EQU	(TextEditor_Dummy + $09)
MUIA_TextEditor_FixedFont	EQU	(TextEditor_Dummy + $0a)
MUIA_TextEditor_Flow		EQU	(TextEditor_Dummy + $0b)
MUIA_TextEditor_HasChanged	EQU	(TextEditor_Dummy + $0c)
MUIA_TextEditor_HorizontalScroll	EQU	(TextEditor_Dummy + $2d) ; Private and experimental!
MUIA_TextEditor_ImportHook	EQU	(TextEditor_Dummy + $0e)
MUIA_TextEditor_ImportWrap	EQU	(TextEditor_Dummy + $10)
MUIA_TextEditor_InsertMode	EQU	(TextEditor_Dummy + $0f)
MUIA_TextEditor_InVirtualGroup	EQU	(TextEditor_Dummy + $1b)
MUIA_TextEditor_KeyBindings	EQU	(TextEditor_Dummy + $11)
MUIA_TextEditor_NumLock		EQU	(TextEditor_Dummy + $18)
MUIA_TextEditor_Pen		EQU	(TextEditor_Dummy + $2e)
MUIA_TextEditor_PopWindow_Open	EQU	(TextEditor_Dummy + $03) ; Private!!!
MUIA_TextEditor_Prop_DeltaFactor	EQU	(TextEditor_Dummy + $0d)
MUIA_TextEditor_Prop_Entries	EQU	(TextEditor_Dummy + $15)
MUIA_TextEditor_Prop_First	EQU	(TextEditor_Dummy + $20)
MUIA_TextEditor_Prop_Release	EQU	(TextEditor_Dummy + $01) ; Private!!!
MUIA_TextEditor_Prop_Visible	EQU	(TextEditor_Dummy + $16)
MUIA_TextEditor_Quiet		EQU	(TextEditor_Dummy + $17)
MUIA_TextEditor_ReadOnly	EQU	(TextEditor_Dummy + $19)
MUIA_TextEditor_RedoAvailable	EQU	(TextEditor_Dummy + $13)
MUIA_TextEditor_Separator	EQU     (TextEditor_Dummy + $2c)
MUIA_TextEditor_Slider		EQU	(TextEditor_Dummy + $1a)
MUIA_TextEditor_StyleBold	EQU	(TextEditor_Dummy + $1c)
MUIA_TextEditor_StyleItalic	EQU	(TextEditor_Dummy + $1d)
MUIA_TextEditor_StyleUnderline	EQU	(TextEditor_Dummy + $1e)
MUIA_TextEditor_TypeAndSpell	EQU	(TextEditor_Dummy + $07)
MUIA_TextEditor_UndoAvailable	EQU	(TextEditor_Dummy + $12)
MUIA_TextEditor_WrapBorder	EQU	(TextEditor_Dummy + $21)
MUIA_TextEditor_Rows		EQU	(TextEditor_Dummy + $32)
MUIA_TextEditor_Columns		EQU	(TextEditor_Dummy + $33)

MUIM_TextEditor_AddKeyBindings	EQU	(TextEditor_Dummy + $22)
MUIM_TextEditor_ARexxCmd	EQU	(TextEditor_Dummy + $23)
MUIM_TextEditor_ClearText	EQU	(TextEditor_Dummy + $24)
MUIM_TextEditor_ExportText	EQU	(TextEditor_Dummy + $25)
MUIM_TextEditor_HandleError	EQU	(TextEditor_Dummy + $1f)
MUIM_TextEditor_InsertText	EQU	(TextEditor_Dummy + $26)
MUIM_TextEditor_MacroBegin	EQU	(TextEditor_Dummy + $27)
MUIM_TextEditor_MacroEnd	EQU	(TextEditor_Dummy + $28)
MUIM_TextEditor_MacroExecute	EQU	(TextEditor_Dummy + $29)
MUIM_TextEditor_Replace		EQU	(TextEditor_Dummy + $2a)
MUIM_TextEditor_Search		EQU	(TextEditor_Dummy + $2b)
;struct    MUIP_TextEditor_ARexxCmd          { ULONG MethodID; STRPTR command; };
;struct    MUIP_TextEditor_ClearText         { ULONG MethodID; };
;struct    MUIP_TextEditor_ExportText        { ULONG MethodID; };
;struct    MUIP_TextEditor_HandleError       { ULONG MethodID; ULONG errorcode; }; /* See below for error codes */
;struct    MUIP_TextEditor_InsertText        { ULONG MethodID; STRPTR text; LONG pos; }; /* See below for positions */
;struct    MUIP_TextEditor_Search	    { ULONG MethodID; STRPTR string; LONG flags; }; /* See below for flags */

MUIV_TextEditor_ExportHook_Plain	EQU	$00000000
MUIV_TextEditor_ExportHook_EMail	EQU	$00000001

MUIV_TextEditor_Flow_Left		EQU	$00000000
MUIV_TextEditor_Flow_Center		EQU	$00000001
MUIV_TextEditor_Flow_Right		EQU	$00000002
MUIV_TextEditor_Flow_Justified		EQU	$00000003

MUIV_TextEditor_ImportHook_Plain	EQU	$00000000
MUIV_TextEditor_ImportHook_EMail	EQU	$00000002
MUIV_TextEditor_ImportHook_MIME		EQU	$00000003
MUIV_TextEditor_ImportHook_MIMEQuoted	EQU	$00000004

MUIV_TextEditor_InsertText_Cursor	EQU	$00000000
MUIV_TextEditor_InsertText_Top		EQU	$00000001
MUIV_TextEditor_InsertText_Bottom	EQU	$00000002

MUIV_TextEditor_LengthHook_Plain	EQU	$00000000
MUIV_TextEditor_LengthHook_ANSI		EQU	$00000001
MUIV_TextEditor_LengthHook_HTML		EQU	$00000002
MUIV_TextEditor_LengthHook_MAIL		EQU	$00000003

* Flags for MUIM_TextEditor_Search *
MUIF_TextEditor_Search_FromTop		EQU	(1 << 0)
MUIF_TextEditor_Search_Next		EQU	(1 << 1)
MUIF_TextEditor_Search_CaseSensitive	EQU	(1 << 2)
MUIF_TextEditor_Search_DOSPattern	EQU	(1 << 3)
MUIF_TextEditor_Search_Backwards	EQU	(1 << 4)

* Error codes given as argument to MUIM_TextEditor_HandleError *
Error_ClipboardIsEmpty		EQU	$01
Error_ClipboardIsNotFTXT	EQU	$02
Error_MacroBufferIsFull		EQU	$03
Error_MemoryAllocationFailed	EQU	$04
Error_NoAreaMarked		EQU	$05
Error_NoMacroDefined		EQU	$06
Error_NothingToRedo		EQU	$07
Error_NothingToUndo		EQU	$08
Error_NotEnoughUndoMem		EQU	$09 ; This will cause all the stored undos to be freed
Error_StringNotFound		EQU	$0a
Error_NoBookmarkInstalled	EQU	$0b
Error_BookmarkHasBeenLost	EQU	$0c

	ENDASM
struct ClickMessage
{
   STRPTR  LineContents;  /* This field is ReadOnly!!! */
   ULONG   ClickPosition;
};
	ASM

* Definitions for Separator type *

LNSB_Top	EQU	0 ; Mutual exclude:
LNSB_Middle	EQU	1 ; Placement of
LNSB_Bottom	EQU	2 ;  the separator
LNSB_StrikeThru	EQU	3 ; Let separator go thru the textfont
LNSB_Thick	EQU	4 ; Extra thick separator

LNSF_Top	EQU	(1<<LNSB_Top)
LNSF_Middle	EQU	(1<<LNSB_Middle)
LNSF_Bottom	EQU	(1<<LNSB_Bottom)
LNSF_StrikeThru	EQU	(1<<LNSB_StrikeThru)
LNSF_Thick	EQU	(1<<LNSB_Thick)


	ENDC	; TEXTEDITOR_MCC_H