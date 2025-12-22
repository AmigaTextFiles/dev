OPT MODULE

/* Search 'value' in list 'list1'. If it is found it returns the
** item in list 'list2' that IS at the same position and the position itselfs.
** To compare the values it calls proecdure 'procptr'. If you pass NIL
** only longs are compared. The proc gets 2 entries and should return true/false.
** If not it returns the default value 'defi' and -1
**
** Eq. instead of inserting an SELECT statement you can use this thing.
**
**     SELECT value
**       CASE 1 ; res:='1'
**       CASE 2 ; res:='2'
**       CASE 5 ; res:='3'
**       DEFAULT; res:='Error'
**     ENDSELECT
**  is equal to
**     res:=getRelatedListValue(value,[1,2,5],['1','2','3'],'Error')
**
**  The other direction also works:
**     PROC stri_comp(stri1,stri2) IS StrCmp(stri1,stri2)
**     value:=getRelatedListValue(res,['1','2','3'],[1,2,5],-1,{stri_comp})
**  Nice, isn't it?
**
*/
EXPORT PROC getRelatedListValue(value,list1,list2,defi=0,procptr=NIL)
DEF x:REG

  IF procptr=NIL THEN procptr:={compi}
  x:=ListLen(list1)
  WHILE x-->=0
    IF procptr(value,ListItem(list1,x)) THEN RETURN ListItem(list2,x),x
  ENDWHILE

ENDPROC defi,-1

PROC compi(value1,value2) IS value1=value2

