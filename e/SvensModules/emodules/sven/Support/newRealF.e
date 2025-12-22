/* Better RealF(). No longer these ugly 1.000 results.
*/

OPT MODULE

EXPORT PROC newRealF(estr,value,n)
DEF i

  RealF(estr,value,n)
  IF InStr(estr,'.')<>-1
    i:=EstrLen(estr)-1
    WHILE estr[i]="0" DO DEC i
    IF estr[i]="." THEN DEC i
    SetStr(estr,i+1)
  ENDIF

ENDPROC estr

