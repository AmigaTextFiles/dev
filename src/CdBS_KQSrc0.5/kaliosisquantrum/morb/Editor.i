*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Include file for text editor engine and related classes
* $Id: Editor.i 0.0 1998/01/05 22:14:08 MORB Exp MORB $
*

***** RawEditorClass *****
         CLASS     RawEditorClass,ScrollAreaClass

         METHOD    REM_DigestBuffer
         METHOD    REM_VomitBuffer
         METHOD    REM_MoveCursorLeft
         METHOD    REM_MoveCursorRight
         METHOD    REM_MoveCursorUp
         METHOD    REM_MoveCursorDown
         METHOD    REM_UnSelectLine
         METHOD    REM_SelectLine
         METHOD    REM_InsertChar
         METHOD    REM_MakeCursorVisible
         METHOD    REM_Clicked

         DATA_LONG red,REDT_AlignType,1

         DATA_LONG red,REDT_BufListMemPool,1

         DATA_LONG red,REDT_RebuildDTbl,1
         DATA_LONG red,REDT_DispTable,1
         DATA_LONG red,REDT_DispEntNum,1

         DATA_LONG red,REDT_Reformat,1
         DATA_LONG red,REDT_Buffer,1
         DATA_BYTE red,REDT_BufferList,MLH_SIZE
         DATA_LONG red,REDT_NumBufLines,1

         DATA_LONG red,REDT_FLOffset,1
         DATA_LONG red,REDT_FirstLine,1
         DATA_LONG red,REDT_FLineNumSC,1
         DATA_LONG red,REDT_FLCharOffset,1

         DATA_LONG red,REDT_CursorEnabled,1
         DATA_LONG red,REDT_CursorAlwayVisible,1
         DATA_LONG red,REDT_CursorLine,1
         DATA_LONG red,REDT_CursorOffset,1
         DATA_LONG red,REDT_CursorDLine,1
         DATA_LONG red,REDT_CursorDLOffset,1
         DATA_LONG red,REDT_CursorDLCharOffset,1
         DATA_LONG red,REDT_CursorX,1
         DATA_LONG red,REDT_CursorY,1
         DATA_LONG red,REDT_CursorDLNum,1

         DATA_LONG red,REDT_SelectedLine,1

         DATA_LONG red,REDT_Width,1
         DATA_LONG red,REDT_Right,1
         DATA_SIZE red_DataSize

TXTA_NOWRAP        = 0
TXTA_SIMPLEWRAP    = 4
TXTA_WWLEFT        = 8
TXTA_WWRIGHT       = 12
TXTA_WWCENTER      = 16
TXTA_JUSTIFY       = 20

         rsreset
BufListEntry       rs.b      0
ble_Next           rs.l      1
ble_Prev           rs.l      1
ble_Length         rs.l      1
ble_String         rs.l      1
ble_ChunksNS       rs.l      1
ble_ChunksSC       rs.l      1
ble_Refresh        rs.l      1
ble_Size           rs.b      0

         rsreset
DispTblEntry       rs.b      0
dte_Text           rs.l      1
dte_NumChars       rs.l      1
dte_XPos           rs.l      1
dte_BLEntry        rs.l      1
dte_Offset         rs.l      1
dte_Check          rs.l      1
dte_Update         rs.l      1
dte_Size           rs.b      0

RAWEDIT  macro
         dc.l      OBJ_Begin,_RawEditorClass
         dc.l      OBJ_End
         endm
**************************

***** FloatTextClass *****
         CLASS     FloatTextClass,RawEditorClass

         DATA_LONG flt,FLTX_FData,1
         DATA_SIZE flt_DataSize

FLOATTEXT          macro     ; Text,datastream
         dc.l      OBJ_Begin,_FloatTextClass
         dc.l      REDT_Buffer,\1
         dc.l      FLTX_FData,\2
         dc.l      OBJ_End
         endm
**************************

***** EditorClass *****
         CLASS     EditorClass,RawEditorClass

EDITOR   macro
         dc.l      OBJ_Begin,_EditorClass
         dc.l      OBJ_End
         endm
***********************

***** ConsoleClass *****
         CLASS     ConsoleClass,RawEditorClass

         ;METHOD    CNM_PutC
         METHOD    CNM_PutS
         ;METHOD    CNM_Printf
         ;METHOD    CNM_GetC
         METHOD    CNM_GetS

         DATA_LONG con,COND_GetSBuffer,1
         DATA_LONG con,COND_CallBack,1
         DATA_SIZE con_DataSize

CONSOLE  macro
         dc.l      OBJ_Begin,_ConsoleClass
         dc.l      OBJ_End
         endm
***********************
