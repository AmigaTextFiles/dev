OPT MODULE

/* searchs value 'searchvalue' in list 'listi'. returns the position in
** the list or -1 on failure.
** 'procptr' is a procedure that is used for comparing. It gets the
** 2 values and should return true/false. If you pass NIL as 'procptr'
** only longs are compared.
**
** Example:
**    searchListValue([1,2,3,4],3) returns 2.
**
**    searchListValue(['1','2','3'],'4',{proc_strcmp}) returns -1
**    PROC proc_strcmp(str1,str2) IS StrCmp(str1,str2)
*/
EXPORT PROC searchListValue(listi,searchvalue,procptr=NIL)
DEF len:REG,
    pos=0:REG,
    value:REG

  IF procptr=NIL THEN procptr:={compi}
  len:=ListLen(listi)-1
  WHILE pos<=len
    value:=ListItem(listi,pos)
    IF procptr(value,searchvalue) THEN RETURN pos
    INC pos
  ENDWHILE

ENDPROC -1

PROC compi(value1,value2) IS value1=value2

