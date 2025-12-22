OPT MODULE 
 
MODULE '*misc2'   -> copy3.e .. 
MODULE 'utility' 
           /* fr†n huvudprogget */ 
              EXPORT DEF procnum, utilitybase 
  
 
 
EXPORT PROC chk_argtype(str1:PTR TO CHAR) 
   DEF r 
   DEF at1 
   Val(str1, {r}) -> for the later valuecheck.. 
   IF (str1[] = "D") AND (str1[1] > 47) AND (str1[1] < 56) ->Dx 
      at1 := 1 
   ELSEIF (str1[] = "d") AND (str1[1] > 47) AND (str1[1] < 56) ->Dx 
      at1 := 1 
   ELSEIF str1[] = "A" AND (str1[1] > 47) AND (str1[1] < 56)  ->Ax 
      at1 := 2 
   ELSEIF str1[] = "a" AND (str1[1] > 47) AND (str1[1] < 56)  ->Ax 
      at1 := 2 
   ELSEIF StrCmp(str1, 'STACK+') 
      at1 := 7 -> stackptr 
   ELSEIF StrCmp(str1, '-STACK') 
      at1 := 8 
   ELSEIF (r > NIL) OR (chkifConstant(str1) = TRUE)-> value or constant 
      at1 := 3 
   ELSEIF chkiflVar(str1) = TRUE    ->LOCAL var 
      at1 := 4 
   ELSEIF str1[] = "_" 
      at1 := 5 -> GLOBAL var 
   ELSEIF str1[] = "%" 
      at1 := 6  -> %param 
   ENDIF 
   IF InStr(str1, '[') <> -1 THEN at1 := Not(at1) + 1  ->ptr 
ENDPROC at1 
 
 
PROC chkif_A_Z(char) 
   IF (char > 64) AND (char < 91) 
      RETURN TRUE 
   ENDIF 
ENDPROC FALSE 
 
PROC chkif_a_z(char) 
   IF (char > 96) AND (char < 123) 
      RETURN TRUE 
   ENDIF 
ENDPROC FALSE 
 
PROC chkifConstant(str) 
   IF chkif_A_Z(str[0]) = FALSE THEN RETURN FALSE 
   ->IF chkif_A_Z(str[1]) = FALSE THEN RETURN FALSE 
ENDPROC TRUE 
 
PROC chkiflVar(str) 
   IF chkif_a_z(str[0]) = FALSE THEN RETURN FALSE 
   ->IF chkif_a_z(str[1]) = FALSE THEN RETURN FALSE 
ENDPROC TRUE 
 
EXPORT PROC cmp(arg1, arg2) 
   DEF at1 
   DEF at2 
   DEF str[70]:STRING 
   at1 := chk_argtype(arg1) 
   at2 := chk_argtype(arg2) 
 
  
   IF (at1 = 1) AND (at2 = 1) 
      StringF(str, ' CMP.L \s, \s\n', arg2, arg1) 
   ELSEIF (at2 = 3) AND (at1 = 1) 
      StringF(str, ' CMP.L #\s, \s\n', arg2, arg1) 
   ELSEIF at2 = 1 
      source2dest(arg1, 'D4') 
      StringF(str, ' CMP.L D4, \s\n', arg2) 
   ELSEIF at1 = 3 
      source2dest(arg2, 'D4') 
      StringF(str, ' CMP.L #\s, D4\n', arg1) 
   ELSE 
      source2dest(arg1, 'D4') 
      source2dest(arg2, 'D5') 
      StringF(str, ' CMP.L D5, D4\n') 
   ENDIF 
   write3(str) 
ENDPROC 
 
 
EXPORT PROC cmpAndBranch(a, b, c, true, l) 
   DEF str[100]:STRING 
   cmp(a, b) 
   IF StrCmp(c, '=') 
      StringF(str, IF true THEN ' BEQ ' ELSE ' BNE ') 
   ELSEIF StrCmp(c, '<>', 2)
      StringF(str, IF true THEN ' BNE ' ELSE ' BEQ ') 
   ELSEIF StrCmp(c, '>=', 2)
      StringF(str, IF true THEN ' BGE ' ELSE ' BLT ') 
   ELSEIF StrCmp(c, '<', 1)
      StringF(str, IF true THEN ' BLT ' ELSE ' BGE ') 
   ELSEIF StrCmp(c, '>', 1)
      StringF(str, IF true THEN ' BGT ' ELSE ' BLE ') 
   ELSEIF StrCmp(c, '<=', 2)
      StringF(str, IF true THEN ' BLE ' ELSE ' BGT ') 
   ENDIF 
   write3(str) 
   write3(l) 
   write3('\n') 
ENDPROC 
 
 
 
/* get info from PTRs... xx[size]*/ 
PROC getPtrSize(source) 
   DEF size 
   IF InStr(source, '[]') <> -1 
   size:= 4 
   ELSEIF InStr(source, '[B') <> -1 
   size:= 1 
   ELSEIF InStr(source, '[W') <> -1 
   size:= 2 
   ELSE ; size := 4 
   ENDIF 
ENDPROC size 
 
PROC getPtrOffset(source, offsetstr) 
   DEF pos 
   StringF(offsetstr, '') 
   pos := InStr(source, '.') 
   IF pos = -1 THEN RETURN StringF(offsetstr, '') 
   pos++ 
   StrCopy(offsetstr, source + pos, StrLen(source) - pos) 
ENDPROC 
 
PROC isolateBeforePtr(str, varstr) 
   DEF pos 
   pos := InStr(str, '[') 
   IF pos = -1 THEN RETURN StrCopy(varstr, str) 
   StrCopy(varstr, str, pos) 
ENDPROC 
 
 
EXPORT PROC source2dest(source, dest) 
   DEF at1, at2 
   DEF s1, s2 
   IF Stricmp(source, dest) = NIL THEN RETURN ->if eq 
   at1 := chk_argtype(source) 
   at2 := chk_argtype(dest) 
   s1 := getPtrSize(source) 
   s2 := getPtrSize(dest) 
   IF (at1 > 0) AND (at2 > 0) 
      simple2simple(source, dest) 
   ELSEIF (at1 < 0) AND (at2 > 0) 
      ptr2simple(source, dest) 
   ELSEIF (at1 > 0) AND (at2 < 0) 
      simple2ptr(source, dest) 
   ELSEIF (at1 = -2) AND (at2 = -2) AND (s1 = s2) 
      axptr2axptr(source, dest, s1) 
   ELSE 
      ptr2ptr(source, dest) 
   ENDIF  
ENDPROC 
 
PROC simple2ptr(source, dest) 
   DEF at1 
   DEF at2 
   DEF sizestr[4]:STRING, size 
   DEF ofsstr[100]:STRING 
   getPtrOffset(dest, ofsstr) 
   at1 := chk_argtype(source) 
   at2 := chk_argtype(dest) 
   size := getPtrSize(dest) 
 
   SELECT size 
   CASE 1 ; StringF(sizestr, 'B') 
   CASE 2 ; StringF(sizestr, 'W') 
   CASE 4 ; StringF(sizestr, 'L') 
   ENDSELECT 
 
   IF at2 <> -2 -> AxPtr 
      move('L') 
      SELECT at2 
      CASE -1 ; reg(dest) 
      ->CASE -2 ; reg(dest) 
      CASE -3 ; directval(dest) 
      CASE -4 ; localvar(dest) 
      CASE -5 ; globalvar(dest) 
      CASE -6 ; param(dest) 
      ENDSELECT 
      comma() 
      reg('A6') 
      newline() 
   ENDIF 
 
   move(sizestr) 
   SELECT at1 
   CASE 1 ; reg(source) 
   CASE 2 ; reg(source) 
   CASE 3 ; directval(source) 
   CASE 4 ; localvar(source) 
   CASE 5 ; globalvar(source) 
   CASE 6 ; param(source) 
   CASE 7 ; anystr('(A7)+') 
   ENDSELECT 
   comma() 
   offset(ofsstr) 
   IF at2 <> -2 
      anystr('(A6)') 
   ELSE 
      anystr('(') 
      reg(dest) 
      anystr(')') 
   ENDIF 
   newline() 
ENDPROC 
 
PROC ptr2simple(source, dest) 
   DEF at1 
   DEF at2 
   DEF sizestr[4]:STRING, size 
   DEF ofsstr[100]:STRING 
   getPtrOffset(source, ofsstr) 
   at1 := chk_argtype(source) 
   at2 := chk_argtype(dest) 
   size := getPtrSize(source) 
 
   SELECT size 
   CASE 1 ; StringF(sizestr, 'B') 
   CASE 2 ; StringF(sizestr, 'W') 
   CASE 4 ; StringF(sizestr, 'L') 
   ENDSELECT 
 
   IF at1 <> -2 
      move('L') 
      SELECT at1 
      CASE -1 ; reg(source) 
      ->CASE -2 ; reg(source) 
      CASE -3 ; directval(source) 
      CASE -4 ; localvar(source) 
      CASE -5 ; globalvar(source) 
      CASE -6 ; param(source) 
      ENDSELECT 
      comma() 
      reg('A6') 
      newline() 
   ENDIF 
 
   IF size < 4 THEN simple2simple('0', dest) 
   move(sizestr) 
   offset(ofsstr) 
   IF at1 <> -2 
      anystr('(A6)') 
   ELSE 
      anystr('(') 
      reg(source) 
      anystr(')') 
   ENDIF 
   comma() 
   SELECT at2 
   CASE 1 ; reg(dest) 
   CASE 2 ; reg(dest) 
   CASE 4 ; localvar(dest) 
   CASE 5 ; globalvar(dest) 
   CASE 6 ; param(dest) 
   CASE 8 ; anystr('-(A7)') 
   ENDSELECT 
   newline() 
ENDPROC 
 
PROC ptr2ptr(source, dest) 
   DEF at1 
   DEF at2 
   DEF sizestr[4]:STRING, size 
   DEF ofsstr1[100]:STRING 
   DEF ofsstr2[100]:STRING 
   getPtrOffset(source, ofsstr1) 
   getPtrOffset(dest, ofsstr2) 
   at1 := chk_argtype(source) 
   at2 := chk_argtype(dest) 
   size := getPtrSize(source) 
 
   SELECT size 
   CASE 1 ; StringF(sizestr, 'B') 
   CASE 2 ; StringF(sizestr, 'W') 
   CASE 4 ; StringF(sizestr, 'L') 
   ENDSELECT 
 
   move('L') 
   SELECT at1 
   CASE -1 ; reg(source) 
   CASE -2 ; reg(source) 
   CASE -3 ; directval(source) 
   CASE -4 ; localvar(source) 
   CASE -5 ; globalvar(source) 
   CASE -6 ; param(source) 
   ENDSELECT 
   comma() 
   reg('A6') 
   newline() 
 
   ->--- 
 
   IF size < 4 THEN simple2simple('0', 'D5') 
   move(sizestr) 
   offset(ofsstr1) 
   anystr('(A6)') 
   comma() 
   reg('D7') 
   newline() 
 
   ->-- 
 
   size := getPtrSize(dest) 
   SELECT size 
   CASE 1 ; StringF(sizestr, 'B') 
   CASE 2 ; StringF(sizestr, 'W') 
   CASE 4 ; StringF(sizestr, 'L') 
   ENDSELECT 
 
   move('L') 
   SELECT at2 
   CASE -1 ; reg(dest) 
   CASE -2 ; reg(dest) 
   CASE -3 ; directval(dest) 
   CASE -4 ; localvar(dest) 
   CASE -5 ; globalvar(dest) 
   CASE -6 ; param(dest) 
   ENDSELECT 
   comma() 
   offset(ofsstr2) 
   reg('A6') 
   newline() 
 
   move(sizestr) 
   reg('D5') 
   comma() 
   anystr('(A6)') 
   newline() 
ENDPROC 
 
PROC axptr2axptr(source, dest, size) 
   DEF sizestr[4]:STRING 
   DEF ofs1[100]:STRING 
   DEF ofs2[100]:STRING 
 
   SELECT size 
   CASE 1 ; StringF(sizestr, 'B') 
   CASE 2 ; StringF(sizestr, 'W') 
   CASE 4 ; StringF(sizestr, 'L') 
   ENDSELECT 
 
   getPtrOffset(source, ofs1) 
   getPtrOffset(dest, ofs2) 
 
   move(sizestr) 
   offset(ofs1) 
   anystr('(') 
   reg(source) 
   anystr(')') 
   comma() 
   offset(ofs2) 
   anystr('(') 
   reg(dest) 
   anystr(')') 
   newline() 
ENDPROC 
  
PROC simple2simple(source, dest) 
   DEF at1 
   DEF at2 
   at1 := chk_argtype(source) 
   at2 := chk_argtype(dest) 
   move('L') 
   SELECT at1 
   CASE 1 ; reg(source) 
   CASE 2 ; reg(source) 
   CASE 3 ; directval(source) 
   CASE 4 ; localvar(source) 
   CASE 5 ; globalvar(source) 
   CASE 6 ; param(source) 
   CASE 7 ; reg('(A7)+') 
   ENDSELECT 
   comma() 
   SELECT at2 
   CASE 1 ; reg(dest) 
   CASE 2 ; reg(dest) 
   CASE 4 ; localvar(dest) 
   CASE 5 ; globalvar(dest) 
   CASE 6 ; param(dest) 
   CASE 8 ; reg('-(A7)') 
   ENDSELECT 
   newline() 
ENDPROC 
 
 
PROC move(sizestr) 
   DEF str[100]:STRING 
   StringF(str, ' MOVE.\s ', sizestr) 
   write3(str) 
ENDPROC 
 
PROC offset(ofsstr) IS write3(ofsstr) 
 
PROC comma() IS write3(', ') 
 
PROC newline() IS write3('\n') 
 
PROC localvar(varstr) 
   DEF str[100]:STRING 
   DEF ison[100]:STRING 
   isolateBeforePtr(varstr, ison) 
   StringF(str, '-PROC_\d_var_\s(A5)', procnum, ison) 
   write3(str) 
ENDPROC 
 
PROC globalvar(varstr) 
   DEF str[100]:STRING 
   DEF ison[100]:STRING 
   isolateBeforePtr(varstr, ison) 
   StringF(str, '\s(A4)', ison) 
   write3(str) 
ENDPROC 
 
PROC directval(valstr) 
   DEF str[100]:STRING 
   DEF ison[100]:STRING 
   isolateBeforePtr(valstr, ison) 
   StringF(str, '#\s', ison) 
   write3(str) 
ENDPROC 
 
PROC param(parstr) 
   DEF str[100]:STRING 
   DEF ison[100]:STRING 
   isolateBeforePtr(parstr, ison) 
   StringF(str, 'PROC_\d_par_\s(A5)', procnum, ison) 
   write3(str) 
ENDPROC 
 
PROC reg(regstr) 
   DEF str[100]:STRING 
   DEF ison[100]:STRING 
   isolateBeforePtr(regstr, ison) 
   StringF(str, '\s', ison) 
   write3(str) 
ENDPROC 
 
PROC anystr(str) IS write3(str) 
 
 
 
 
 
 
 
 
