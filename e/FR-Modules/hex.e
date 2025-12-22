/* $VER: hex 1.0 (18.10.97) © Frédéric Rodrigues
   Transforms a string of binaries in hex view
*/

OPT MODULE

EXPORT PROC hex(estring,binstring,len)
DEF i,s[3]:STRING,t,c
  StrCopy(estring,'',ALL)
  FOR i:=0 TO len-1
    StringF(s,'\z\h[2]\s',binstring[i],IF Mod(i+1,4)=0 THEN ' ' ELSE '')
    StrAdd(estring,s,ALL)
  ENDFOR
  StrAdd(estring,'   ')
  t:=EstrLen(estring)
  FOR i:=0 TO len-1
    c:=binstring[i]
    estring[i+t]:=IF ((c>=$20) AND (c<=$7F)) OR ((c>=$A0) AND (c<=$FF)) THEN c ELSE "."
  ENDFOR
  SetStr(estring,t+len)
ENDPROC
