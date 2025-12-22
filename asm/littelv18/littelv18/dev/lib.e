OPT MODULE 
 
-> module for littel_a68k.library : librarycreation 
 
MODULE '*misc2' 
MODULE 'dos/dos' 
   DEF fdmode 
   DEF ofsmode 
   DEF fdfh 
   DEF ofsfh 
   DEF ofscount 
   DEF lvomode 
   DEF lvofh 
 
   EXPORT DEF filename, libraryEnv, regPreserve 
 
EXPORT PROC lib_LibraryEnv(env) 
   StrCopy(libraryEnv, env) 
ENDPROC 
 
EXPORT PROC lib_RegPreserve(rp) 
   StrCopy(regPreserve, rp) 
ENDPROC 
 
EXPORT PROC lib_MakeFD(name, libbasename) 
   DEF str[100]:STRING 
   fdfh := Open(name, MODE_NEWFILE) 
   fdmode := TRUE 
   StringF(str, '##base \s\n##bias 30\n##public\n', libbasename) 
   Write(fdfh, str, StrLen(str)) 
ENDPROC 
 
EXPORT PROC lib_MakeI(name) 
   ofsfh := Open(name, MODE_NEWFILE) 
   ofsmode := TRUE 
ENDPROC 
 
EXPORT PROC lib_MakeLVO(name) 
   lvofh := Open(name, MODE_NEWFILE) 
   lvomode := TRUE 
ENDPROC 
 
/* 
EXPORT PROC lib_LIBGLOBS() 
   write3(' MOVE.L A4, -(A7)\n') 
   write3(' MOVE.L littel_a4, A4\n') 
ENDPROC 
 
EXPORT PROC lib_ENDLIBGLOBS() 
   write3(' MOVE.L (A7)+, A4\n') 
ENDPROC 
*/ 
 
EXPORT PROC lib_Fdef(name, info)
   DEF str[200]:STRING 
   StringF(str, ' dc.l \s\n', name) 
   write3(str) 
   IF fdmode AND fdfh 
      StringF(str, '\s\s\n', name, info)
      write(fdfh, str) 
   ENDIF 
   IF ofsmode AND ofsfh 
      StringF(str, '\s EQU \d\n', name, ofscount) 
      write(ofsfh, str) 
   ENDIF 
   IF lvomode AND lvofh 
      StringF(str, '_LVO\s EQU \d\n XDEF _LVO\s\n', name, ofscount, name) 
      write(lvofh, str) 
   ENDIF 
 
   ofscount := ofscount - 6 
ENDPROC 
 
PROC write(fh, str) IS Write(fh, str, StrLen(str)) 
 
EXPORT PROC lib_EndFdef() 
   write3(' dc.l -1\n') 
   IF fdmode AND fdfh THEN write(fdfh, '##end\n') 
   IF fdfh THEN Close(fdfh) 
   IF ofsfh THEN Close(ofsfh) 
   IF lvomode AND lvofh THEN write(lvofh, ' end\n') 
   IF lvofh THEN Close(lvofh) 
ENDPROC 
 
              -> gaaahh! a little hedgehog is eating  my foot! 
 
EXPORT PROC libsrc(verstr, revstr, namestr, idstr) 
   DEF str[100]:STRING 
 
   fdmode := FALSE 
   ofsmode := FALSE 
   fdfh := NIL 
   ofsfh := NIL 
   ofscount := -30 
   lvomode := FALSE 
   lvofh := NIL 
 
   /* the startupglobals offsets via A4*/ 
   write1(' xref _SysBase, _DOSBase, _IntuitionBase\n') 
   write1(' xref _GraphicsBase, _UtilityBase, _arg, _stdin, _stdout\n') 
   write1(' xref _exception, _exceptioninfo\n') 
   write1(' xref _LITTEL, _G1, _G2, _G3, _G4\n') 
   write1(' xref littel_a4\n') 
 
   write1(' xdef init, open, close, expunge\n ') 


   write1(' xdef Lib.Name\n') 
   write4(' EVEN\n') 
   write4('Lib.Name:\n') 
   StringF(str, ' dc.b \s,0\n', namestr) 
   write4(str) 
   write1(' xdef Lib.IDString\n') 
   write4(' EVEN\n') 
   write4('Lib.IDString:\n') 
   StringF(str, ' dc.b \s,13,10,0\n', idstr) 
   write4(str) 
   write1(' xdef Lib.VERSION\n') 
   write1('Lib.VERSION EQU ') 
   write1(verstr) 
   write1('\n') 
   write1(' xdef Lib.REVISION\n') 
   write1('Lib.REVISION EQU ') 
   write1(revstr) 
   write1('\n') 
   write1(' xref Lib.Open\n') 
   write1(' xref Lib.Close\n') 
   write1(' xref Lib.Expunge\n') 
   write1(' xref Lib.Extfunc\n') 
   write1(' xdef Lib.funcTable\n') 
   ->000517------------- ; theese functions now must be declared..
   ->write1(' xdef init\n') 
   ->write1(' xdef open\n')
   ->write1(' xdef close\n')
   ->write1(' xdef expunge\n')
   ->----------------------
   write3('Lib.funcTable:\n') 
   write3(' dc.l Lib.Open\n') 
   write3(' dc.l Lib.Close\n') 
   write3(' dc.l Lib.Expunge\n') 
   write3(' dc.l Lib.Extfunc\n') 
ENDPROC 
