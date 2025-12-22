/* The original TextEditor_mcc.h converted and edited
** by Miklós Németh (06.06.2000)
** I used h2m in first pass ;)
*/

#define MUIC_TextEditor      'TextEditor.mcc'
#define TextEditorObject     MUI_NewObjectA(MUIC_TextEditor,[TAG_IGNORE,0

CONST TextEditor_Dummy                   =$ad000000

CONST MUIA_TextEditor_AreaMarked         =$ad000014
CONST MUIA_TextEditor_ColorMap           =$ad00002f
CONST MUIA_TextEditor_Contents           =$ad000002
CONST MUIA_TextEditor_CursorX            =$ad000004
CONST MUIA_TextEditor_CursorY            =$ad000005
CONST MUIA_TextEditor_DoubleClickHook    =$ad000006
CONST MUIA_TextEditor_ExportHook         =$ad000008
CONST MUIA_TextEditor_ExportWrap         =$ad000009
CONST MUIA_TextEditor_FixedFont          =$ad00000a
CONST MUIA_TextEditor_Flow               =$ad00000b
CONST MUIA_TextEditor_HasChanged         =$ad00000c
CONST MUIA_TextEditor_HorizontalScroll   =$ad00002d
CONST MUIA_TextEditor_ImportHook         =$ad00000e
CONST MUIA_TextEditor_ImportWrap         =$ad000010
CONST MUIA_TextEditor_InsertMode         =$ad00000f
CONST MUIA_TextEditor_InVirtualGroup     =$ad00001b
CONST MUIA_TextEditor_KeyBindings        =$ad000011
CONST MUIA_TextEditor_NumLock            =$ad000018
CONST MUIA_TextEditor_Pen                =$ad00002e
CONST MUIA_TextEditor_PopWindow_Open     =$ad000003
CONST MUIA_TextEditor_Prop_DeltaFactor   =$ad00000d
CONST MUIA_TextEditor_Prop_Entries       =$ad000015
CONST MUIA_TextEditor_Prop_First         =$ad000020
CONST MUIA_TextEditor_Prop_Release       =$ad000001
CONST MUIA_TextEditor_Prop_Visible       =$ad000016
CONST MUIA_TextEditor_Quiet              =$ad000017
CONST MUIA_TextEditor_ReadOnly           =$ad000019
CONST MUIA_TextEditor_RedoAvailable      =$ad000013
CONST MUIA_TextEditor_Separator          =$ad00002c
CONST MUIA_TextEditor_Slider             =$ad00001a
CONST MUIA_TextEditor_StyleBold          =$ad00001c
CONST MUIA_TextEditor_StyleItalic        =$ad00001d
CONST MUIA_TextEditor_StyleUnderline     =$ad00001e
CONST MUIA_TextEditor_TypeAndSpell       =$ad000007
CONST MUIA_TextEditor_UndoAvailable      =$ad000012
CONST MUIA_TextEditor_WrapBorder         =$ad000021
CONST MUIA_TextEditor_Rows               =$ad000032
CONST MUIA_TextEditor_Columns            =$ad000033
CONST MUIM_TextEditor_AddKeyBindings     =$ad000022
CONST MUIM_TextEditor_ARexxCmd           =$ad000023
CONST MUIM_TextEditor_ClearText          =$ad000024
CONST MUIM_TextEditor_ExportText         =$ad000025
CONST MUIM_TextEditor_HandleError        =$ad00001f
CONST MUIM_TextEditor_InsertText         =$ad000026
CONST MUIM_TextEditor_MacroBegin         =$ad000027
CONST MUIM_TextEditor_MacroEnd           =$ad000028
CONST MUIM_TextEditor_MacroExecute       =$ad000029
CONST MUIM_TextEditor_Replace            =$ad00002a
CONST MUIM_TextEditor_Search             =$ad00002b

OBJECT MUIP_TextEditor_ARexxCmd
        MethodID:ULONG,
        command:PTR TO UBYTE

OBJECT MUIP_TextEditor_ClearText
        MethodID:ULONG

OBJECT MUIP_TextEditor_ExportText
        MethodID:ULONG

OBJECT MUIP_TextEditor_HandleError
        MethodID:ULONG,
        errorcode:ULONG

OBJECT MUIP_TextEditor_InsertText
        MethodID:ULONG,
        text:PTR TO UBYTE,
        pos:LONG

OBJECT MUIP_TextEditor_Search
        MethodID:ULONG,
        string:PTR TO UBYTE,
        flags:LONG

CONST MUIV_TextEditor_ExportHook_Plain        =$00000000
CONST MUIV_TextEditor_ExportHook_EMail        =$00000001
CONST MUIV_TextEditor_Flow_Left               =$00000000
CONST MUIV_TextEditor_Flow_Center             =$00000001
CONST MUIV_TextEditor_Flow_Right              =$00000002
CONST MUIV_TextEditor_Flow_Justified          =$00000003
CONST MUIV_TextEditor_ImportHook_Plain        =$00000000
CONST MUIV_TextEditor_ImportHook_EMail        =$00000002
CONST MUIV_TextEditor_ImportHook_MIME         =$00000003
CONST MUIV_TextEditor_ImportHook_MIMEQuoted   =$00000004
CONST MUIV_TextEditor_InsertText_Cursor       =$00000000
CONST MUIV_TextEditor_InsertText_Top          =$00000001
CONST MUIV_TextEditor_InsertText_Bottom       =$00000002
CONST MUIV_TextEditor_LengthHook_Plain        =$00000000
CONST MUIV_TextEditor_LengthHook_ANSI         =$00000001
CONST MUIV_TextEditor_LengthHook_HTML         =$00000002
CONST MUIV_TextEditor_LengthHook_MAIL         =$00000003

CONST MUIF_TextEditor_Search_FromTop        =1
CONST MUIF_TextEditor_Search_Next           =2
CONST MUIF_TextEditor_Search_CaseSensitive  =4
CONST MUIF_TextEditor_Search_DOSPattern     =8
CONST MUIF_TextEditor_Search_Backwards      =16

CONST Error_ClipboardIsEmpty          =$01
CONST Error_ClipboardIsNotFTXT        =$02
CONST Error_MacroBufferIsFull         =$03
CONST Error_MemoryAllocationFailed    =$04
CONST Error_NoAreaMarked              =$05
CONST Error_NoMacroDefined            =$06
CONST Error_NothingToRedo             =$07
CONST Error_NothingToUndo             =$08
CONST Error_NotEnoughUndoMem          =$09
CONST Error_StringNotFound            =$0a
CONST Error_NoBookmarkInstalled       =$0b
CONST Error_BookmarkHasBeenLost       =$0c

OBJECT ClickMessage
        LineContents:PTR TO UBYTE,
        ClickPosition:ULONG

CONST LNSB_Top              =0
CONST LNSB_Middle           =1
CONST LNSB_Bottom           =2
CONST LNSB_StrikeThru       =3
CONST LNSB_Thick            =4

CONST LNSF_Top              =1
CONST LNSF_Middle           =2
CONST LNSF_Bottom           =4
CONST LNSF_StrikeThru       =8
CONST LNSF_Thick            =16

