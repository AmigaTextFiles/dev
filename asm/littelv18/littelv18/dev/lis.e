OPT MODULE 
 
MODULE '*misc2' 
MODULE '*s2d' 
 
EXPORT DEF procnum 
 
       DEF absnum, 
           maxnum, 
           minnum, 
           limitnum, 
           condnum,
           strcmpnum,
           strlennum
 
-> added DMF 
-> added CND 
-> added lis_initmodule. 
-> 0.18b 
-> added lis_DivF() (32/32:=q32,r32) 
-> fixed BUG in lis_Div() (now : 32/32:=32) 
-> both Div and DivF are 020+ ! 
-> D0 is used by DivF() ! 
-> made lis_Mul() 020 + (handles 32*32:=32) 
-> OpenLibrary and CloseLibrary is back! 
->000514 : addd mklblk ! (MakeLocalBlock)
->000617 : lis_Dmf reversed Rtos/Stor sometimes.. no more.

EXPORT PROC lis_initmodule() 
   absnum := NIL 
   maxnum := NIL 
   minnum := NIL 
   limitnum := NIL 
   condnum := NIL 
ENDPROC 

-> this is an INSTRUCTION! : create a block on stack
-> must be used AFTER CodeStart, but really before 
-> other stuff! 000514
EXPORT PROC lis_MkLBlk(lvarname, size) -> MaKeLocalBlocK
   lis_Copy('A7', lvarname) ->   ^size MUST be div by four (4) !
   lis_Inc('A7', size)
ENDPROC   
 
EXPORT PROC lis_OpenLibrary(gvarlibname, ver, gvarname) 
      lis_Copy(gvarlibname, 'A1') 
      lis_Copy(ver, 'D0') 
      lis_Call('_SysBase', '-552') 
      lis_Copy('D0', gvarname) 
ENDPROC 
 
EXPORT PROC lis_CloseLibrary(gvarname) 
   lis_Copy(gvarname, 'A1') 
   lis_Call('_SysBase', '-414') 
ENDPROC 
 
 
 
EXPORT PROC lis_Pop(array:PTR TO LONG) 
   WHILE array[] DO lis_Copy('STACK+', array[]++) 
ENDPROC 
 
EXPORT PROC lis_Cnd(a, c, b, dest) 
   DEF str[100]:STRING 
   condnum++ 
   IF dest = NIL THEN dest := 'D0' 
   StringF(str, 'cond_\d_true', condnum) 
   cmpAndBranch(a, b, c, TRUE, str) 
   lis_Copy('0', dest) 
   StringF(str, ' BRA cond_\d_end\n', condnum) 
   write3(str) 
   StringF(str, 'cond_\d_true:\n', condnum) 
   write3(str) 
   lis_Copy('-1', dest) 
   StringF(str, 'cond_\d_end:\n', condnum) 
   write3(str) 
ENDPROC 
 
          
EXPORT PROC lis_Dmf(name, array:PTR TO LONG) 
   DEF nrofpars=NIL 
   DEF a=12 
   array[]++ 
   WHILE array[nrofpars] DO nrofpars++ 
   IF nrofpars > 3 
      lis_Rtos('a4-a5/d4-d5') 
   ELSEIF nrofpars > 2 
      lis_Rtos('a4/d4')
   ENDIF 
   WHILE a <> -1 
      IF array[a] THEN lis_Copy(array[a], '-STACK') 
      a-- 
   ENDWHILE 
   write3(' x') 
   write3(name) 
   write3('\n') 
   IF nrofpars > 3 
      lis_Stor('a4-a5/d4-d5') 
   ELSEIF nrofpars > 2 
      lis_Stor('a4/d4')
   ENDIF 
ENDPROC 
 
EXPORT PROC lis_Copy(source, dest) IS source2dest(source, dest) 
 
EXPORT PROC lis_Swap(source, dest) 
   lis_Copy(source, 'D4') 
   lis_Copy(dest, source) 
   lis_Copy('D4', dest) 
ENDPROC 
 
EXPORT PROC lis_Shl(steps, target, altdest=NIL) 
   lis_Copy(steps, 'D5') 
   lis_Copy(target, 'D4') 
   write3(' LSL.L d5, D4\n') 
   lis_Copy('D4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Shr(steps, target, altdest=NIL) 
   lis_Copy(steps, 'd5') 
   lis_Copy(target, 'd4') 
   write3(' LSR.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Div(with, target, altdest=NIL) 
   lis_Copy(target, 'd4') 
   lis_Copy(with, 'd5') 
   write3(' DIVS.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_DivF(with, target, qdest, rdest) 
   lis_Copy(target, 'd4') 
   lis_Copy(with, 'a6')
   write3(' DIVSL.L a6, d4:d5\n')
   lis_Copy('d5', qdest)
   lis_Copy('d4', rdest) 
ENDPROC 
 
 
 
EXPORT PROC lis_Mul(with, target, altdest=NIL) 
   lis_Copy(target, 'd4') 
   lis_Copy(with, 'd5') 
   write3(' MULS.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_And(source, dest, altdest=NIL) 
   lis_Copy(source, 'd5') 
   lis_Copy(dest, 'd4') 
   write3(' AND.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE dest) 
ENDPROC 
 
EXPORT PROC lis_Or(source, dest, altdest=NIL) 
   lis_Copy(source, 'd5') 
   lis_Copy(dest, 'd4') 
   write3(' OR.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE dest) 
ENDPROC 
 
EXPORT PROC lis_Xor(source, dest, altdest=NIL) 
   lis_Copy(source, 'd5') 
   lis_Copy(dest, 'd4') 
   write3(' EOR.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE dest) 
ENDPROC 
 
EXPORT PROC lis_Not(target, altdest=NIL) 
   lis_Copy(target, 'd4') 
   write3(' NOT.L d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Bset(bit, target, altdest=NIL) 
   lis_Copy(target, 'd4') 
   lis_Copy(bit, 'd5') 
   write3(' BSET.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Bclr(bit, target, altdest=NIL) 
   lis_Copy(target, 'd4') 
   lis_Copy(bit, 'd5') 
   write3(' BCLR.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Bchg(bit, target, altdest=NIL) 
   lis_Copy(target, 'd4') 
   lis_Copy(bit, 'd5') 
   write3(' BCHG.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Bget(bit, target, dest) 
   lis_Copy(bit, 'd5') 
   lis_Copy('1', 'd4') 
   lis_Shl('d5', 'd4') -> mask i d5 
   lis_Copy(target, 'd5') 
   lis_And('d5', 'd4') 
   lis_Copy('d4', dest) 
ENDPROC 
 
EXPORT PROC lis_Add(source, target, altdest) 
   lis_Copy(source, 'd5') 
   lis_Copy(target, 'd4') 
   write3(' ADD.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Sub(source, target, altdest) 
   DEF str[70]:STRING 
   lis_Copy(source, 'd5') 
   lis_Copy(target, 'd4') 
   write3(' SUB.L d5, d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Inc(source, valstr) 
   DEF str[60]:STRING 
   DEF at 
   IF valstr = NIL THEN valstr := '1' 
   at := chk_argtype(source) 
   SELECT at 
   CASE 1 ; StringF(str, ' ADD.L #\s, \s\n', valstr, source) 
   CASE 2 ; StringF(str, ' ADD.L #\s, \s\n', valstr, source) 
   CASE 4 
   StringF(str, ' ADD.L #\s, -PROC_\d_var_\s(A5)\n', 
   valstr, procnum, source) 
   CASE 5 ; StringF(str, ' ADD.L #\s, \s(A4)\n', valstr, source) 
   DEFAULT 
      lis_Copy(source, 'd4') 
      StringF(str, ' ADD.L #\s, d4\n', valstr) 
      write3(str) 
      lis_Copy('d4', source) 
      RETURN 
   ENDSELECT 
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Dec(source, valstr) 
   DEF str[60]:STRING 
   DEF at 
   IF valstr = NIL THEN valstr := '1' 
   at := chk_argtype(source) 
   SELECT at 
   CASE 1 ; StringF(str, ' SUB.L #\s, \s\n', valstr, source) 
   CASE 2 ; StringF(str, ' SUB.L #\s, \s\n', valstr, source) 
   CASE 4 ; StringF(str, ' SUB.L #\s, -PROC_\d_var_\s(A5)\n', 
   valstr, procnum, source) 
   CASE 5 ; StringF(str, ' SUB.L #\s, \s(A4)\n', valstr, source) 
   DEFAULT 
      lis_Copy(source, 'd4') 
      StringF(str, ' SUB.L #\s, d4\n', valstr) 
      write3(str) 
      lis_Copy('d4', source) 
      RETURN 
   ENDSELECT 
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Abs(target, altdest) 
   DEF str[50]:STRING 
   lis_Copy(target, IF altdest THEN altdest ELSE 'd4')
   StringF(str, ' BGE abs_\d_end\n', absnum) 
   write3(str) 
   lis_Neg(IF altdest THEN altdest ELSE 'd4', NIL)
   StringF(str, 'abs_\d_end:\n', absnum) 
   write3(str) 
   absnum++ 
ENDPROC 
 
EXPORT PROC lis_Neg(target, altdest) 
   lis_Copy(target, 'd4') 
   write3(' NEG d4\n') 
   lis_Copy('d4', IF altdest THEN altdest ELSE target) 
ENDPROC 
 
EXPORT PROC lis_Max(source1, source2, dest) 
   DEF str[50]:STRING 
   lis_Copy(source1, 'd4') 
   lis_Copy(source2, 'd5') 
   lis_Copy('d5', dest) 
   StringF(str, ' CMP.L d4, d5\n BGE endmax_\d\n', maxnum) 
   write3(str) 
   lis_Copy('d4', dest) 
   write3('endmax_\d:\n') 
   maxnum++ 
ENDPROC 
 
EXPORT PROC lis_Min(source1, source2, dest) 
   DEF str[50]:STRING 
   lis_Copy(source1, 'd4') 
   lis_Copy(source2, 'd5') 
   lis_Copy('d5', dest) 
   StringF(str, ' CMP.L d4, d5\n BLE endmin_\d\n', minnum) 
   write3(str) 
   lis_Copy('d4', dest) 
   write3('endmin_\d:\n') 
   minnum++ 
ENDPROC 
 
EXPORT PROC lis_Lmt(min, max, target) 
   DEF str[50]:STRING 
   lis_Copy(min, 'd4') 
   lis_Copy(target, 'd5') 
   StringF(str, ' CMP.L d4, d5\n BGT limit_\d_max\n', limitnum) 
   write3(str) 
   lis_Copy('d4', target) 
   StringF(str, ' BRA limit_\d_end\n', limitnum) 
   write3(str) 
   StringF(str, 'limit_\d_max:\n', limitnum) 
   write3(str) 
   lis_Copy(max, 'd4') 
   StringF(str, ' CMP.L d4, d5\n BLE limit_\d_end\n', limitnum) 
   write3(str) 
   lis_Copy('d4', target) 
   StringF(str, 'limit_\d_end:\n', limitnum) 
   write3(str) 
   limitnum++ 
ENDPROC 
 
EXPORT PROC lis_Geta4() IS write3(' MOVE.L littel_a4, A4\n') 
 
 
 
EXPORT PROC lis_Ret(array:PTR TO LONG) 
   DEF str[100]:STRING 
   DEF a=0 
   WHILE array[a] 
      StringF(str, 'D\d', a) 
      lis_Copy(array[a], str) 
      a++ 
   ENDWHILE 
   StringF(str, ' BRA endproc_\d\n', procnum) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Dpr(label, array:PTR TO LONG) 
   DEF str[50]:STRING, a=16, flush=FALSE 
   DEF b 
   array[]++ 
   WHILE a <> -1 
      IF array[a] 
      IF StrCmp(array[a], 'FLUSH') 
         flush := TRUE 
      ELSE 
         lis_Copy(array[a], '-STACK') 
      ENDIF 
      ENDIF 
      a-- 
   ENDWHILE 
   StringF(str, 
   ' BSR \s\n', label) 
   write3(str) 
   IF flush =TRUE 
      ->b := ew.getNrOfWords() - 3 
      array := array + 4 
      b := 0 
      WHILE array[]++ DO b++ 
      StringF(str, '\d', b) 
      lis_Rems(str) 
   ENDIF 
ENDPROC 
 
EXPORT PROC lis_Rems(nrofstr) 
   DEF str[50]:STRING 
   IF Val(nrofstr) > 0 
      StringF(str, ' LEA \s*4(A7), A7\n', nrofstr) 
      write3(str) 
   ENDIF 
ENDPROC 
 
EXPORT PROC lis_Push(array:PTR TO LONG) 
   WHILE array[] DO lis_Copy(array[]++, '-STACK') 
ENDPROC 
 
EXPORT PROC lis_Rtos(reglist) 
   DEF str[50]:STRING 
   IF reglist = NIL 
      StringF(str, ' MOVEM.L D1-D5/A0-A3, -(A7)\n') 
   ELSE 
      StringF(str, ' MOVEM.L \s, -(A7)\n', reglist) 
   ENDIF 
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Stor(reglist) 
   DEF str[60]:STRING 
   IF reglist = NIL 
      StringF(str, ' MOVEM.L (A7)+, D1-D5/A0-A3\n') 
   ELSE 
      StringF(str, ' MOVEM.L (A7)+, \s\n', reglist) 
   ENDIF 
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Padr(labelname, dest) 
   DEF str[100]:STRING 
   StringF(str, '#\s', labelname) 
   lis_Copy(str, dest) 
ENDPROC 
 
 
EXPORT PROC lis_Call(adr, offset) /* CALL _utilityBase MapTags */ 
   DEF str[100]:STRING 
   lis_Copy(adr, 'A6') 
   StringF(str, 
   ' JSR \s(A6)\n', offset) 
   write3(str) 
ENDPROC 
  
