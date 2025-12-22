OPT LARGE 
 
MODULE '*lkw' 
MODULE '*lis' 
MODULE '*lib' 
MODULE '*lck' 
MODULE '*misc2' 
MODULE 'utility' 
 
LIBRARY 'littel_a68k.library', 5, 17, 'littel_a68k.library' IS 
 
lck_Const, 
lck_Incdir, 
lck_mInclude, 
lck_Include, 
lck_mLink, 
lck_Link, 
lck_Mode, 
lck_mXref, 
lck_Xref, 
lck_mXdef, 
lck_Xdef, 
lib_MakeFD, 
lib_MakeI, 
lib_MakeLVO, 
lib_Fdef, 
lib_EndFdef, 
lis_Copy, 
lis_Swap, 
lis_Shl, 
lis_Shr, 
lis_Div, 
lis_Mul, 
lis_And, 
lis_Or, 
lis_Xor, 
lis_Not, 
lis_Bset, 
lis_Bclr, 
lis_Bchg, 
lis_Bget, 
lis_Add, 
lis_Sub, 
lis_Inc, 
lis_Dec, 
lis_Abs, 
lis_Neg, 
lis_Max, 
lis_Min, 
lis_Lmt, 
lis_Geta4, 
lis_Ret, 
lis_Dpr, 
lis_Call, 
lis_Rems, 
lis_Push, 
lis_Pop, 
lis_Rtos, 
lis_Stor, 
lis_Padr, 
lkw_Proc, 
lkw_Var, 
lkw_Codestart, 
lkw_Endproc, 
lkw_Longs, 
lkw_Words, 
lkw_Bytes, 
lkw_String, 
lkw_Gvar, 
lkw_Lblk, 
lkw_Wblk, 
lkw_Bblk, 
lkw_IF, 
lkw_ELSE, 
lkw_ENDIF, 
lkw_WHILE, 
lkw_ENDWHILE, 
lkw_REPEAT, 
lkw_ENDREPEAT, 
lkw_SELECT, 
lkw_CASE, 
lkw_CONT, 
lkw_DEFAULT, 
lkw_ENDSELECT, 
lkw_Except, 
lis_Raise, -> in lkw.e 
lis_Check, -> in lkw.e 
lis_Throw, -> in lkw.e 
lis_Rthrw, -> in lkw.e 
lis_Dmf, 
lis_LOOP, 
lis_ENDLOOP, 
lis_FOR, 
lis_ENDFOR, 
lis_Cnd, 
lis_Lab, 
lis_Bic, 
lis_OpenLibrary, 
lis_CloseLibrary, 
lit_Start, 
lit_End, 
lit_Ass, 
lit_Lnk, 
lit_GetModeStr, 
lib_LibraryEnv, 
lib_RegPreserve,
lis_MkLBlk,
lis_Bal
 
DEF filename[200]:STRING 
DEF modestr[50]:STRING 
DEF linkfiles[1000]:STRING 
 
PROC main() 
   utilitybase := OpenLibrary('utility.library', 37) 
ENDPROC 
 
PROC close() 
   IF utilitybase THEN CloseLibrary(utilitybase) 
ENDPROC 
 
PROC lit_Start(name) 
   StrCopy(filename, name) 
   StrCopy(modestr, 'EXE') 
   misc_initmodule() 
   lkw_initmodule() 
   lis_initmodule() 
ENDPROC 
 
PROC lit_End() IS misc_endmodule() 
 
PROC lit_Ass() IS phxassIt() 
 
PROC lit_Lnk() IS linkIt() 
 
PROC lit_GetModeStr() IS modestr 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
