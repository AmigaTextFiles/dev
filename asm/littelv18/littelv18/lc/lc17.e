-> Example 'Straight off' Compilator for littel_a68k.library (R5)
-> AUTHOR : leif_salomonsson@swipnet.se
-> STATUS : FREEWARE
->000517,000616
->000621 : \ newline : process1()

MODULE 'dos/dos'
MODULE '*extractwords'
MODULE '*littel_a68k'
MODULE 'utility'


   DEF mem:PTR TO CHAR
   DEF ew:PTR TO extractwords
   DEF linenum=1

RAISE "OPEN" IF Open() = NIL,
      "LIB" IF OpenLibrary() = NIL

PROC main() HANDLE
   DEF withext[100]:STRING
   DEF len
   DEF fh=NIL
   DEF rlen
   DEF ostr[100]:STRING
   StringF(withext, '\s.l', arg)
   NEW ew.new(20, 500)
   littel_a68kbase := OpenLibrary('littel_a68k.library', 5)
   utilitybase := OpenLibrary('utility.library', 37)
   len := FileLength(withext)
   mem := New(len)
   fh := Open(withext, MODE_OLDFILE)
   rlen := Read(fh, mem, len)
   IF rlen <> len THEN Raise("READ")
   process1(mem)
   Lit_Start(arg)
   WriteF(' Compiler Example For LITTEL v0.18b © Leif Salomonsson 99-00\n')
   WriteF('     Parsing and Compiling : \s\n', withext)
   do_commands()
   Lit_End()
   WriteF('\b     Assembling\n')
   Lit_Ass()
   WriteF('     Linking\n')
   Lit_Lnk()
   WriteF('     Finnished ')
   IF StrCmp(Lit_GetModeStr(), 'EXE')
      WriteF('EXE')
      WriteF(' \s : \d bytes!\n', arg, FileLength(arg))
   ELSEIF StrCmp(Lit_GetModeStr(), 'LIBRARY')
      WriteF('LIBRARY')
      WriteF(' \s : \d bytes!\n', arg, FileLength(arg))
   ELSEIF StrCmp(Lit_GetModeStr(), 'OBJECT')
      StringF(ostr, '\s.o', arg)
      WriteF('OBJECT')
      WriteF(' \s : \d bytes!\n', ostr, FileLength(ostr))
   ENDIF
EXCEPT DO
SELECT exception
CASE "^C" ; WriteF('ctrl c break!\n')
CASE "OPEN" ; WriteF('open error!\n')
CASE "READ" ; WriteF('read error!\n')
CASE "LIB"
ENDSELECT
   IF fh THEN Close(fh)
   IF littel_a68kbase
      CloseLibrary(littel_a68kbase)
   ENDIF
   IF utilitybase THEN CloseLibrary(utilitybase)
ENDPROC

PROC do_commands()
   DEF str
   DEF arg1, arg2, arg3, arg4, arg5, array
   mem := nextLine(mem)
   LOOP
      IF CtrlC() THEN Raise("^C")

         WriteF('\b\d[4]', linenum)

         ew.extract(mem)
         str := ew.getWord(0) ; arg1 := ew.getWord(1)
         arg2 := ew.getWord(2) ; arg3 := ew.getWord(3)
         arg4 := ew.getWord(4) ; arg5 := ew.getWord(5)
         array := ew.getArray() + 4

         IF str = NIL
            ->
     
         ELSEIF Stricmp(str, 'CODESTART')=NIL
            Lkw_Codestart()
         ELSEIF Stricmp(str, 'copy')=NIL
            Lis_Copy(arg1, arg2)
         ELSEIF Stricmp(str, 'WHILE')=NIL
            Lkw_WHILE(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'VAR')=NIL
            Lkw_Var(array)
         ELSEIF Stricmp(str, 'inc')=NIL
            Lis_Inc(arg1, arg2)
         ELSEIF Stricmp(str, 'dec')=NIL
            Lis_Dec(arg1, arg2)
         ELSEIF Stricmp(str, 'add')=NIL
            Lis_Add(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'sub')=NIL
            Lis_Sub(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'ENDSELECT')=NIL
            Lkw_ENDSELECT()
         ELSEIF Stricmp(str, 'ENDREPEAT')=NIL
            Lkw_ENDREPEAT(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'ENDWHILE')=NIL
            Lkw_ENDWHILE()
         ELSEIF Stricmp(str, 'ENDPROC')=NIL
            Lkw_Endproc(array)
         ELSEIF Stricmp(str, 'ENDIF')=NIL
            Lkw_ENDIF()
         ELSEIF Stricmp(str, 'END')=NIL
            RETURN
         ELSEIF Stricmp(str, 'REPEAT')=NIL
            Lkw_REPEAT()
         ELSEIF Stricmp(str, 'IF')=NIL
            Lkw_IF(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'SELECT')=NIL
            Lkw_SELECT(arg1)
         ELSEIF Stricmp(str, 'CASE')=NIL
            Lkw_CASE(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'Rtos')=NIL
            Lis_Rtos(arg1)
         ELSEIF Stricmp(str, 'Stor')=NIL
            Lis_Stor(arg1)
         ELSEIF Stricmp(str, 'padr')=NIL
            Lis_Padr(arg1, arg2)
         ELSEIF Stricmp(str, 'LONGS')=NIL
            Lkw_Longs(arg1, arg2)
         ELSEIF Stricmp(str, 'WORDS')=NIL
            Lkw_Words(arg1, arg2)
         ELSEIF Stricmp(str, 'BYTES')=NIL
            Lkw_Bytes(arg1, arg2)
         ELSEIF Stricmp(str, 'LBLK')=NIL
            Lkw_Lblk(arg1, arg2)
         ELSEIF Stricmp(str, 'WBLK')=NIL
            Lkw_Wblk(arg1, arg2)
         ELSEIF Stricmp(str, 'BBLK')=NIL
            Lkw_Bblk(arg1, arg2)
         ELSEIF Stricmp(str, 'PROC')=NIL
            Lkw_Proc(arg1, array)
         ELSEIF Stricmp(str, 'dpr')=NIL
            Lis_Dpr(arg1, array)
         ELSEIF Stricmp(str, 'cdpr')=NIL
            Lis_Dpr(arg1, array)
            Lis_Check()
         ELSEIF Stricmp(str, 'call')=NIL
            Lis_Call(arg1, arg2)
         ELSEIF Stricmp(str, 'ccall')=NIL
            Lis_Call(arg1, arg2)
            Lis_Check()
         ELSEIF Stricmp(str, 'shl')=NIL
            Lis_Shl(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'shr')=NIL
            Lis_Shr(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'div')=NIL
            Lis_Div(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'mul')=NIL
            Lis_Mul(arg1, arg2, arg3)
         ELSEIF Stricmp(str, '#incdir')=NIL
            Lck_Incdir(arg1)
         ->ELSEIF Stricmp(str, '#linkdir')=NIL
         ->   do_linkdir(arg1)
         ELSEIF Stricmp(str, '#include')=NIL
            Lck_mInclude(array)
         ELSEIF Stricmp(str, '#equ')=NIL
            Lck_Const(arg1, arg2)
         ELSEIF Stricmp(str, '#mode')=NIL
            Lck_Mode(arg1, arg2, arg3, arg4, arg5)
            IF StrCmp(arg1, 'LIBRARY') THEN ew.setMode(EW_MODE2)
         ELSEIF Stricmp(str, '#link')=NIL
            Lck_mLink(array)
         ELSEIF Stricmp(str, '#xdef')=NIL
            Lck_mXdef(array)
         ELSEIF Stricmp(str, '#xref')=NIL
            Lck_mXref(array)
         ELSEIF Stricmp(str, 'STRING')=NIL
            Lkw_String(arg1, arg2)
         ELSEIF Stricmp(str, 'GVAR')=NIL
            Lkw_Gvar(array)
         ELSEIF Stricmp(str, 'swap')=NIL
            Lis_Swap(arg1, arg2)
         ELSEIF Stricmp(str, 'ELSE')=NIL
            Lkw_ELSE()
         ELSEIF Stricmp(str, 'DEFAULT')=NIL
            Lkw_DEFAULT()
         ELSEIF Stricmp(str, 'and')=NIL
            Lis_And(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'or')=NIL
            Lis_Or(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'not')=NIL
            Lis_Not(arg1, arg2)
         ELSEIF Stricmp(str, 'xor')=NIL
            Lis_Xor(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'bset')=NIL
            Lis_Bset(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'bclr')=NIL
            Lis_Bclr(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'bget')=NIL
            Lis_Bget(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'bchg')=NIL
            Lis_Bchg(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'neg')=NIL
            Lis_Neg(arg1, arg2)
         ELSEIF Stricmp(str, 'lmt')=NIL
            Lis_Lmt(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'max')=NIL
            Lis_Max(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'min')=NIL
            Lis_Min(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'abs')=NIL
            Lis_Abs(arg1, arg2)
         ELSEIF Stricmp(str, 'ret')=NIL
            Lis_Ret(array)
         ELSEIF Stricmp(str, 'CONT')=NIL
            Lkw_CONT(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'geta4')=NIL
            Lis_Geta4()
         ELSEIF Stricmp(str, 'rems')=NIL
            Lis_Rems(arg1)
         ELSEIF Stricmp(str, 'Push')=NIL
            Lis_Push(array)
         ELSEIF Stricmp(str, 'Pop')=NIL
            Lis_Pop(array)
         ELSEIF Stricmp(str, '#fdef')=NIL
            Lib_Fdef(arg1, arg2)
         ELSEIF Stricmp(str, '#endfdef')=NIL
            Lib_EndFdef()
            ew.setMode(EW_MODE1)
         ELSEIF Stricmp(str, '#makefd')=NIL
            Lib_MakeFD(arg1, arg2)
         ELSEIF Stricmp(str, '#makei')=NIL
            Lib_MakeI(arg1)
         ELSEIF Stricmp(str, '#makelvo')=NIL
            Lib_MakeLVO(arg1)
         ELSEIF Stricmp(str, 'raise')=NIL
            Lis_Raise(arg1, arg2, arg3, arg4, arg5)
         ELSEIF Stricmp(str, 'check')=NIL
            Lis_Check()
         ELSEIF Stricmp(str, 'throw')=NIL
            Lis_Throw(arg1, arg2)
         ELSEIF Stricmp(str, 'rthrw')=NIL
            Lis_Rthrw()
         ELSEIF Stricmp(str, 'EXCEPT')=NIL
            Lkw_Except(arg1)
         ELSEIF Stricmp(str, 'dmf')=NIL
            Lis_Dmf(arg1, array)
         ELSEIF Stricmp(str, 'LOOP')=NIL
            Lis_LOOP(arg1)
         ELSEIF Stricmp(str, 'ENDLOOP')=NIL
            Lis_ENDLOOP()
         ELSEIF Stricmp(str, 'FOR')=NIL
            Lis_FOR(arg1, arg2, arg3, arg4)
         ELSEIF Stricmp(str, 'ENDFOR')=NIL
            Lis_ENDFOR()
         ELSEIF Stricmp(str, 'CND')=NIL
            Lis_Cnd(arg1, arg2, arg3, arg4)
         ELSEIF Stricmp(str, 'Lab')=NIL
            Lis_Lab(arg1)
         ELSEIF Stricmp(str, 'BIC')=NIL
            Lis_Bic(arg1, arg2, arg3, arg4)
         ELSEIF Stricmp(str, '#LibraryEnv')=NIL
            Lib_LibraryEnv(arg1)
         ELSEIF Stricmp(str, '#RegPreserve')=NIL
            Lib_RegPreserve(arg1)
         ELSEIF Stricmp(str, 'OpenLibrary')=NIL
            Lis_OpenLibrary(arg1, arg2, arg3)
         ELSEIF Stricmp(str, 'CloseLibrary')=NIL
            Lis_CloseLibrary(arg1)
         ELSEIF Stricmp(str, 'BAL')=NIL
            Lis_Bal(arg1)
         ELSEIF Stricmp(str, 'ASM')=NIL
            Lis_Asm(array)
         ELSE
            WriteF('   Warning! : \s[20]...\n', str)
         ENDIF
      ->ELSE
        -> WriteF('lc error parsing line \d: \s[10]..\n', linenum, mem)
      ->ENDIF
   mem := nextLine(mem)
   ENDLOOP
ENDPROC

PROC nextLine(str:PTR TO CHAR)
   WHILE str[] <> 10 DO str++
   linenum++
   str++
   WHILE str[] = 10
      str++
      linenum++
   ENDWHILE
ENDPROC str

PROC process1(mem_) -> make \ newline
   DEF insentence=FALSE, mem:REG PTR TO CHAR
   mem := mem_
   WHILE mem[] <> NIL
      IF mem[] = 34
         IF insentence = FALSE THEN insentence := TRUE ELSE insentence := FALSE
      ENDIF
      IF (mem[] = "\\") AND (insentence = FALSE) THEN mem[] := 10
      mem++
   ENDWHILE
ENDPROC


