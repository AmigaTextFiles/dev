; yaec.i v0.2   (010110)

; yaec2.4 (011006)

; yaec v2.5b

   MACHINE 68020

   FPU 1

   ;predefined globals following..

   
   xref GLOBAL_dosbase
   xref GLOBAL_execbase
   xref GLOBAL_gfxbase
   xref GLOBAL_intuitionbase
   xref GLOBAL_mathbase
   xref GLOBAL_mathieeedoubbasbase
   xref GLOBAL_mathieeedoubtransbase
   xref GLOBAL_mathieeesingbasbase
   xref GLOBAL_mathieeesingtransbase
   xref GLOBAL_mathtransbase
   
   
   xref GLOBAL_arg
   xref GLOBAL_stdin
   xref GLOBAL_stdout
   ;xref GLOBAL_mempool       ;(private)
   xref GLOBAL_exception
   xref GLOBAL_exceptioninfo
   xref GLOBAL_initialstack  ;private
   xref GLOBAL_stacksize     ;private
   xref GLOBAL_stdrast
   xref GLOBAL_libbase       ;our librarybase when in LIBRARY [DEVICE] mode.

   xref a4storage  ; private

 ; predefined (internal) procedures following..

 xref PROC_Abs
 xref PROC_Bounds
 xref PROC_Char
 xref PROC_CloneList
 xref PROC_CloneStr
 xref PROC_CtrlC
 xref PROC_Dispose
 xref PROC_DisposeLink
 xref PROC_Div
 xref PROC_Eor
 xref PROC_EstrLen
 xref PROC_Even
 xref PROC_FastDispose
 xref PROC_FastDisposeList
 xref PROC_EndString  ; new
 xref PROC_EndList  ; new
 xref PROC_FastNew
 xref PROC_FileLength
 xref PROC_Forward
 xref PROC_FreeStack
 xref PROC_Inp
 xref PROC_InStr
 xref PROC_Int
 xref PROC_Link
 xref PROC_List
 xref PROC_ListAdd
 xref PROC_ListCmp
 xref PROC_ListCopy
 xref PROC_ListItem
 xref PROC_ListLen
 xref PROC_ListMax
 xref PROC_Long
 xref PROC_LowerStr
 xref PROC_Max
 xref PROC_MidStr
 xref PROC_Min
 xref PROC_Mod
 xref PROC_Mul
 xref PROC_New
 xref PROC_Next
 xref PROC_Not
 xref PROC_Odd
 xref PROC_Out
 xref PROC_PrintF
 xref PROC_PutChar
 xref PROC_PutFmt
 xref PROC_PutInt
 xref PROC_PutLong
 xref PROC_ReadStr
 xref PROC_RightStr
 xref PROC_SetList
 xref PROC_SetStdIn
 xref PROC_SetStdOut
 xref PROC_SetStr
 xref PROC_Shl
 xref PROC_Shr
 xref PROC_Sign
 xref PROC_StrAdd
 xref PROC_StrCmp
 xref PROC_StrCopy
 xref PROC_StrFmt
 ;xref PROC_StrFmtS
 xref PROC_String
 xref PROC_StringF
 xref PROC_StrLen
 xref PROC_StrMax
 xref PROC_TrimStr
 xref PROC_UpperStr
 xref PROC_Val
 xref PROC_WriteF
 ;xref PROC_NewCell       ; (private)
 xref PROC_KickVersion
 ;xref PROC_InitCells

 xref PROC_ForAll
 xref PROC_SelectList
 xref PROC_MapList
 xref PROC_Exists

 xref __ClearMemL     ; private

 ; theese functions are stubs for mathieeesing#? library

 xref PROC_Fabs
 xref PROC_Facos
 xref PROC_Fasin
 xref PROC_Fatan
 xref PROC_Fceil
 xref PROC_Fcos
 xref PROC_Fcosh
 xref PROC_Fexp
 xref PROC_Ffieee
 xref PROC_Ffloor
 xref PROC_Flog
 xref PROC_Flog10
 xref PROC_Fpow
 xref PROC_Fsin
 xref PROC_Fsincos
 xref PROC_Fsinh
 xref PROC_Fsqrt
 xref PROC_Ftan
 xref PROC_Ftanh
 xref PROC_Ftieee

 ; theese functions are stubs for mathieeedoub#? library

 xref PROC_Dabs
 xref PROC_Dacos
 xref PROC_Dasin
 xref PROC_Datan
 xref PROC_Dceil
 xref PROC_Dcos
 xref PROC_Dcosh
 xref PROC_Dexp
 xref PROC_Dfieee
 xref PROC_Dfloor
 xref PROC_Dlog
 xref PROC_Dlog10
 xref PROC_Dpow
 xref PROC_Dsin
 xref PROC_Dsincos
 xref PROC_Dsinh
 xref PROC_Dsqrt
 xref PROC_Dtan
 xref PROC_Dtanh
 xref PROC_Dtieee

 ; intuition support functions

 xref PROC_OpenS
 xref PROC_CloseS
 xref PROC_OpenW
 xref PROC_CloseW
 xref PROC_WaitIMessage
 xref PROC_MsgCode
 xref PROC_MsgQualifier
 xref PROC_MsgIAddr
 xref PROC_Mouse
 xref PROC_LeftMouse
 xref PROC_WaitLeftMouse

 ; graphics functions

 xref PROC_Plot
 xref PROC_Line
 xref PROC_Box
 xref PROC_Colour
 xref PROC_SetColour
 xref PROC_TextF
 xref PROC_Hbox
 xref PROC_SetStdRast

 xref __CallEndMethod ; private

 xref PROC_ObjectName
 xref PROC_ObjectSize


 xref __EndObject ; private

 xref __MemCopy   ; private

 xref PROC_StrRem
 xref PROC_StrIns

 xref PROC_RealF
 xref PROC_RealVal
 xref PROC_Rnd
 xref PROC_RndQ

 ;xref PROC_InstallHook

 xref __MemCopyL    ; private
 xref __MemCopyW    ; private
 xref __CloneObject ; private
 xref __CloneMem    ; private

 ; v2.5d+

 xref PROC_Start
 xref PROC_Stop
 xref PROC_Release
 xref PROC_GetA4






