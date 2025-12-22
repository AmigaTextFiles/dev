OPT MODULE 
 
MODULE '*misc2' 
MODULE '*s2d' 
MODULE '*lis' 
 
DEF rparam1 
DEF rparam2 
DEF rparam3 
DEF rparam4 
DEF rparam5 
DEF rparam6 
DEF rparam7 
 
-> making params adress via A5 instead of A7.. 
-> fnny how it is.. now im doing it like i 
-> did in the very beginnig, this time it works! :) 
-> using (like E) link/unlk in every proc.  (not every.. link/unlk can be omitted sometimes**) 
-> if no vars, link #0. 
-> this ilnk A5 stuff really works strange, 
-> but absolutely beautiful! dont get hjow it works 
-> but who cares now ?! 
-> hmm.. okey.. made it possible to not use 
-> CODESTART, if we dont, no params or locals can be 
-> used, but it will be faster!!, perfect for 
-> little 'asm' routines. 
->implementing 'Exception handling'! 
-> RAISE exc excinfo [condition]  :added 
-> CHECK     : added 
-> THROW exc [excinfo] 
-> RTHRW      :added 
-> EXCPT [DO] : added 
-> adderade SELECT IF 
-> optimerar SELECT/CASE/CONT... 
-> det 'selectade' objectet l„ggs i d4 (som f”rst sparas) 
-> g„ller inte SELECT IF utan bara SELECT xxx. 
-> CODESTART now is rquired in EVERY PROC! 
-> because of the way SELECT works.. it needs LINK/UNLK 
-> added LOOP, FOR.. 
-> cghanging d4 -> d6 d5 -> d7 
-> changing some stuff concerning library env/regpreserve: 
-> libraryEnv and libraryRP, the last one is for register preserve only, 
-> libraryEnv is for environment only. 
-> changed name of libraryRP -> RegPreserve. 
-> I realised it can be used not just in making libraries! 
-> deault is OFF for EXE, d2-d7/a2-a4/a6 for LIBRARY, OFF for .o-bjects 
-> added lis_Bal : Branch ALways.
-> BAL didnt write anything.. FIXED
-> changed the way exceptions work, a bit more like
-> how I originally thought it should work.

EXPORT DEF procnum, libraryEnv, regPreserve, modestr 
 
DEF varsize, paramsize, ifnum, endifnum, elsenum, 
    whilenum, endwhilenum, selectnum, repeatnum, 
    endrepeatnum, selectstrstack:PTR TO stringstack, 
    casenumstack:PTR TO longstack, endselectnum, 
    defaultnum, cstrue, exceptset, exceptdef, throw, 
    elsedefstack:PTR TO longstack, loopnum, endloopnum, 
    looptimes, fornum, endfornum, forstep, forvarstack:PTR TO stringstack 
 
EXPORT PROC lkw_initmodule() 
   rparam1 := String(50) 
   rparam2 := String(50) 
   rparam3 := String(50) 
   rparam4 := String(50) 
   rparam5 := String(50) 
   rparam6 := String(50) 
   rparam7 := String(50) 
   varsize := NIL 
   procnum := NIL 
   paramsize := NIL 
   ifnum := NIL 
   endifnum := NIL 
   elsenum := NIL 
   whilenum := NIL 
   endwhilenum := NIL 
   selectnum := NIL 
   repeatnum := NIL 
   endrepeatnum := NIL 
   NEW selectstrstack.new() 
   NEW casenumstack.new(100) 
   endselectnum := NIL 
   defaultnum := NIL 
   cstrue := FALSE 
   exceptdef := FALSE 
   exceptset := FALSE 
   throw := FALSE 
   NEW elsedefstack.new(100) 
   loopnum := NIL 
   endloopnum := NIL 
   looptimes := FALSE 
   fornum := NIL 
   endfornum := NIL 
   forstep:=String(10) 
   NEW forvarstack.new() 
   libraryEnv := String(100) 
   StrCopy(libraryEnv, 'OFF') 
   regPreserve := String(100) 
   StrCopy(regPreserve, 'OFF') 
ENDPROC 
 
 
EXPORT PROC lis_Lab(l) 
   DEF str[100]:STRING 
   StringF(str, 'lab_\d_\s:\n', procnum, l)
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Bic(a, c, b, l) 
   DEF str[100]:STRING 
   StringF(str, 'lab_\d_\s', procnum, l) 
   cmpAndBranch(a, b, c, TRUE, str) 
ENDPROC 

EXPORT PROC lis_Bal(label)
   DEF str[100]:STRING
   StringF(str, ' BRA lab_\d_\s\n', procnum, label)
   write3(str)
ENDPROC

EXPORT PROC lis_FOR(a, start, stop, step) 
   DEF str[70]:STRING 
   fornum++ 
   endfornum := fornum 
   lis_Copy(start, a) 
   lis_Copy('D6', '-STACK') 
   lis_Copy(stop, 'D6') 
   StringF(str, 'for_\d\n', fornum) 
   write3(str) 
   StringF(str, 'endfor_\d', fornum) 
   cmpAndBranch(a, 'D6', '<', TRUE, str) 
   IF step = NIL THEN step := '1' 
   StrCopy(forstep, step) 
   forvarstack.add(a) 
ENDPROC 
 
EXPORT PROC lis_ENDFOR() 
   DEF str[100]:STRING 
   IF Val(forstep) > 0 
      lis_Inc(forvarstack.get(), forstep) 
   ELSE 
      lis_Dec(forvarstack.get(), forstep) 
   ENDIF 
   StringF(str, ' BRA for_\d\n', endfornum) 
   write3(str) 
   StringF(str, 'endfor_\d:\n', endfornum) 
   write3(str) 
   lis_Copy('STACK+', 'D6') 
   endfornum-- 
   forvarstack.rem() 
ENDPROC 
 
EXPORT PROC lis_LOOP(times) 
   DEF str[50]:STRING 
   loopnum++ 
   IF times <> FALSE 
      looptimes := TRUE 
      lis_Copy('d6', '-STACK') 
      lis_Copy(times, 'D6') 
      lis_Dec('D6', '1') 
   ENDIF 
   endloopnum := loopnum 
   StringF(str, 'loop_\d:\n', loopnum) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_ENDLOOP() 
   DEF str[50]:STRING 
   IF looptimes = TRUE 
      StringF(str, ' DBRA D6, loop_\d\n', endloopnum) 
      write3(str) 
      lis_Copy('STACK+', 'D6') 
   ELSE 
      StringF(str, ' BRA loop_\d\n', endloopnum) 
      write3(str) 
   ENDIF 
   endloopnum-- 
ENDPROC 
 
/* now internal */
/* 000714 : going back to the old way of doing it */
/* because i just found out that Wouters E */
/* does it WAY sloower anyway..*/
/* so the old design is OK!, and betetr to */
/* as it lets ya use any values for exception, instead of just positive numbers */

EXPORT PROC lis_Check() 
   DEF str[100]:STRING 
   ->lis_COPY('_exception', 'D7')
   StringF(str, ' TST.L D7\n BNE excpt_\d\n', procnum)
   ->StringF(str, ' DBRA D7, excpt_\d\n', procnum)
   write3(str) 
ENDPROC 
 
EXPORT PROC lis_Raise(arg1, arg2, arg3, arg4, arg5) 
   DEF str[100]:STRING 
   IF arg3 AND arg4 AND arg5 
      lkw_IF(arg3, arg4, arg5) 
         lis_Throw(arg1, arg2) 
         StringF(str, ' BRA excpt_\d\n', procnum) 
         write3(str) 
      lkw_ENDIF() 
   ELSE 
      lis_Throw(arg1, arg2) 
      StringF(str, ' BRA excpt_\d\n', procnum) 
      write3(str) 
   ENDIF 
ENDPROC 
 
EXPORT PROC lis_Throw(arg1, arg2) 
   lis_Copy(arg1, '_exception') 
   lis_Copy(arg1, 'D7') -> return 'we have an exception'
   IF arg2 THEN lis_Copy(arg2, '_exceptioninfo') 
   exceptset := TRUE 
   throw := TRUE 
ENDPROC 
 
EXPORT PROC lis_Rthrw() 
   throw := TRUE 
ENDPROC 
 
 
EXPORT PROC lkw_Proc(name, params:PTR TO LONG) 
   DEF str[50]:STRING 
   StringF(str, '\s: ; PROC\n', name) 
   write3(str, EstrLen(str)) 
   StrCopy(rparam1, IF params[1] THEN params[1] ELSE '') 
   StrCopy(rparam2, IF params[2] THEN params[2] ELSE '') 
   StrCopy(rparam3, IF params[3] THEN params[3] ELSE '') 
   StrCopy(rparam4, IF params[4] THEN params[4] ELSE '') 
   StrCopy(rparam5, IF params[5] THEN params[5] ELSE '') 
   StrCopy(rparam6, IF params[6] THEN params[6] ELSE '') 
   StrCopy(rparam7, IF params[7] THEN params[7] ELSE '') 
 
   IF StrCmp(regPreserve, 'OFF') <> TRUE THEN lis_Rtos(regPreserve) 
 
   IF StrCmp(libraryEnv, 'SHARED') = TRUE THEN lis_Geta4() 
ENDPROC 
 
 
EXPORT PROC lkw_Var(array:PTR TO LONG) 
   WHILE array[] DO var(array[]++) 
ENDPROC 
 
PROC var(name) 
   DEF str[100]:STRING 
   StringF(str, 
   'PROC_\d_var_\s EQU \d\n', procnum, name, varsize) 
   write1(str) 
   varsize := varsize + 4 
ENDPROC 


-> should be renamed to `UseStack` 
EXPORT PROC lkw_Codestart() 
   linkA5() 
   cstrue := TRUE 
   IF EstrLen(rparam1) > 0 THEN param(rparam1) 
   IF EstrLen(rparam2) > 0 THEN param(rparam2) 
   IF EstrLen(rparam3) > 0 THEN param(rparam3) 
   IF EstrLen(rparam4) > 0 THEN param(rparam4) 
   IF EstrLen(rparam5) > 0 THEN param(rparam5) 
   IF EstrLen(rparam6) > 0 THEN param(rparam6) 
   IF EstrLen(rparam7) > 0 THEN param(rparam7) 
   IF EstrLen(rparam1) > 0 THEN endparam() 
ENDPROC 
 
PROC linkA5() 
   DEF str[50]:STRING 
   StringF(str, ' LINK A5, #-\d\n', varsize) 
   write3(str) 
ENDPROC 
 
PROC param(name) 
   DEF str[100]:STRING 
   StringF(str, 'PROC_\d_par_\s EQU \d\n', 
   procnum, name, paramsize + 8) 
   write1(str)                             ->16 
   paramsize := paramsize + 4 
ENDPROC 
 
PROC endparam() 
   ->does it need to do anything ?? 
ENDPROC 
 
EXPORT PROC lkw_Except(arg1) 
   DEF str[100]:STRING 
   exceptdef:= TRUE 
   IF StrCmp(arg1, 'DO') 
      -> 
   ELSE 
      StringF(str, ' BRA endproc_\d\n', procnum) 
      write3(str) 
   ENDIF 
   StringF(str, 'excpt_\d:\n', procnum) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_Endproc(array:PTR TO LONG) 
   DEF str[100]:STRING 
   DEF a=0 
   WHILE array[a] 
      StringF(str, 'D\d', a) 
      lis_Copy(array[a], str) 
      a++ 
   ENDWHILE 
 
   IF exceptdef = FALSE 
      StringF(str, 'excpt_\d:\n', procnum) 
      write3(str) 
   ENDIF 
 
   IF (throw = FALSE) AND exceptdef THEN lis_Copy('0', 'D7')
 
   StringF(str, 'endproc_\d:\n', procnum) 
   write3(str) 
 
   IF cstrue THEN write3(' UNLK A5\n') 
 
   IF StrCmp(regPreserve,'OFF') <> TRUE THEN lis_Stor(regPreserve) 
 
   IF paramsize > 0
      StringF(str, ' RTD #\d\n', paramsize) 
      write3(str) 
   ELSE 
      write3(' RTS\n') 
   ENDIF 
   procnum++ ->global 
   varsize := NIL 
   paramsize := NIL 
   cstrue := FALSE 
   exceptdef := FALSE 
   exceptset := FALSE 
   throw := FALSE 
ENDPROC 
 
EXPORT PROC lkw_Longs(name, longs) 
   DEF str[50]:STRING 
   StringF(str, ' EVEN\n\s__: ; LONGS\n DC.L \s\n', name, longs) 
   write4(str) 
   gvar(name) 
   StringF(str, ' LEA.L \s__, A6\n MOVE.L A6, \s(A4)\n', name, name) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_Words(name, words) 
   DEF str[50]:STRING 
   StringF(str, ' EVEN\n\s__: ; WORDS\n DC.W \s\n', name, words) 
   write4(str) 
   gvar(name) 
   StringF(str, ' LEA.L \s__, A6\n MOVE.L A6, \s(A4)\n', name, name) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_Bytes(name, bytes) 
   DEF str[50]:STRING 
   StringF(str, ' EVEN\n\s__: ; BYTES\n DC.B \s\n', name, bytes) 
   write4(str) 
   gvar(name) 
   StringF(str, ' LEA.L \s__, A6\n MOVE.L A6, \s(A4)\n', name, name) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_String(name, string) 
   DEF str[200]:STRING, a=2 
   StringF(str, ' EVEN\n\s__: ; STRING\n DC.B \s,0\n', name, string) 
   write4(str) 
   gvar(name) 
   StringF(str, ' LEA.L \s__, A6\n MOVE.L A6, \s(A4)\n', name, name) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_Gvar(array:PTR TO LONG) 
   WHILE array[] DO gvar(array[]++) 
ENDPROC 
 
PROC gvar(name) 
  DEF str[50]:STRING 
  StringF(str, ' EVEN\n\s: ; GVAR\n DS.L 1\n', name) 
  write5(str) 
ENDPROC 
 
EXPORT PROC lkw_Lblk(name, elements) IS blk('L', name, elements) 
 
EXPORT PROC lkw_Wblk(name, elements) IS blk('W', name, elements) 
 
EXPORT PROC lkw_Bblk(name, elements) IS blk('B', name, elements) 
 
PROC blk(kind, name, size) 
   DEF str[200]:STRING
   StringF(str, ' EVEN\n\s__: ; \sBLK\n DS.\s[1] \s \n', name, kind, kind, size) 
   write5(str) 
   gvar(name)
   StringF(str, ' LEA.L \s__, A6\n MOVE.L A6, \s(A4)\n', 
   name, name) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_IF(arg1, arg2, arg3) 
   DEF str[100]:STRING
   ifnum++           -> global 
   endifnum := ifnum -> global 
   elsenum := ifnum 
   StringF(str, 'if_\d:\n', ifnum) 
   write3(str) 
 
   StringF(str, 'else_\d', ifnum) 
   cmpAndBranch(arg1, arg3, arg2, FALSE, str) 
 
   elsedefstack.next() 
   elsedefstack.set(FALSE) 
ENDPROC 
 
EXPORT PROC lkw_ELSE() 
   DEF str[100]:STRING 
   StringF(str, ' BRA endif_\d\nelse_\d:\n', elsenum, elsenum) 
   write3(str) 
   elsenum-- 
   elsedefstack.set(TRUE) 
ENDPROC 
 
EXPORT PROC lkw_ENDIF() 
   DEF str[42]:STRING 
   IF elsedefstack.get() = FALSE 
      lkw_ELSE()
   ENDIF 
   StringF(str, 'endif_\d:\n', endifnum) 
   write3(str) 
   endifnum-- ->global 
   elsedefstack.prev() 
ENDPROC 
 
EXPORT PROC lkw_WHILE(arg1, arg2, arg3) 
   DEF str[70]:STRING 
   whilenum++               -> global 
   endwhilenum := whilenum -> global 
   StringF(str, 'while_loop_\d:\n', whilenum) 
   write3(str) 
 
   StringF(str, 'while_exit_\d', whilenum) 
   cmpAndBranch(arg1, arg3, arg2, FALSE, str) 
    
ENDPROC 
 
EXPORT PROC lkw_ENDWHILE() 
   DEF str[50]:STRING 
   StringF(str, ' BRA while_loop_\d\nwhile_exit_\d:\n', 
   endwhilenum, endwhilenum) 
   write3(str) 
   endwhilenum-- ->global 
ENDPROC 
 
EXPORT PROC lkw_REPEAT() 
   DEF str[50]:STRING 
   DEF arg1, arg2, arg3 
   repeatnum++               ->global 
   endrepeatnum := repeatnum ->global 
   StringF(str, 'repeat_label_\d:\n', repeatnum) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_ENDREPEAT(arg1, arg2, arg3) 
   DEF str[80]:STRING 
 
   StringF(str, 'repeat_label_\d', endrepeatnum) 
   cmpAndBranch(arg1, arg3, arg2, FALSE, str) 
    
   endrepeatnum-- ->global 
ENDPROC 
 
EXPORT PROC lkw_SELECT(arg1) 
   DEF str[70]:STRING 
   selectstrstack.add(arg1) 
   casenumstack.next() 
   casenumstack.set(1) 
   selectnum++ 
   endselectnum := selectnum 
   defaultnum := selectnum 
 
   IF StrCmp(arg1, 'IF') <> TRUE 
      lis_Copy('D6', '-STACK') 
      lis_Copy(arg1, 'D6') 
   ENDIF 
 
   StringF(str, 'SELECT_\d:\n', selectnum) 
   write3(str) 
ENDPROC 
 
EXPORT PROC lkw_CASE(arg1, arg2, arg3) 
   DEF str[50]:STRING 
   IF casenumstack.get() > 1 ->not first case 
      StringF(str, ' BRA select_\d_end\n', endselectnum) 
      write3(str) 
   ENDIF 
   StringF(str, 'select_\d_case_\d:\n', endselectnum, casenumstack.get()) 
   write3(str) 
 
   StringF(str, 'select_\d_case_\d', endselectnum, casenumstack.get() + 1) 
 
   IF StrCmp(selectstrstack.get(), 'IF') 
      cmpAndBranch(arg1, arg3, arg2, FALSE, str) 
   ELSE 
      cmpAndBranch('D6', arg1, '<>', TRUE, str) 
   ENDIF 
   casenumstack.set(casenumstack.get() + 1) 
ENDPROC 
 
EXPORT PROC lkw_CONT(arg1, arg2, arg3) 
   DEF str[50]:STRING 
   StringF(str, 'select_\d_case_\d:\n', endselectnum, casenumstack.get()) 
   write3(str) 
 
   StringF(str, 'select_\d_case_\d', endselectnum, casenumstack.get() + 1) 
 
   IF StrCmp(selectstrstack.get(), 'IF') 
      cmpAndBranch(arg1, arg3, arg2, FALSE, str) 
   ELSE 
      cmpAndBranch('D6', arg1, '<>', TRUE, str) 
   ENDIF 
 
   casenumstack.set(casenumstack.get() + 1) 
ENDPROC 
 
EXPORT PROC lkw_DEFAULT() 
   DEF str[100]:STRING 
   StringF(str, 'select_\d_case_\d:\nselect_\d_default:\n', 
   defaultnum, casenumstack.get(), defaultnum) 
   write3(str) 
   defaultnum-- 
   casenumstack.set(casenumstack.get() + 1) 
ENDPROC 
 
EXPORT PROC lkw_ENDSELECT() 
   DEF str[100]:STRING 
   StringF(str, 
   'select_\d_case_\d:\nselect_\d_end:\n', 
   endselectnum, casenumstack.get(), endselectnum) 
   write3(str) 
   endselectnum--  ->global 
 
   IF StrCmp(selectstrstack.get(), 'IF')<> TRUE THEN lis_Copy('STACK+', 'D6') 
 
   selectstrstack.rem() 
   casenumstack.prev() 
ENDPROC 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
