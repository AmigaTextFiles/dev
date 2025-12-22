/* List support functions
*/

OPT MODULE
OPT REG=5

RAISE "MEM" IF List()=NIL


/* Allocates an list.
** 'maxanz' is length of the list
** 'oldlist' is an other list or NIL
**
** If 'oldlist' exists and has 'maxanz' entries 'oldlist'
** is returned otherwise the old list id disposed and a new
** list is created.
**
** Automatical throws exceptions.
*/
EXPORT PROC allocList(maxanz,oldlist=NIL)

  IF oldlist
    IF ListMax(oldlist)=maxanz THEN RETURN oldlist
    DisposeLink(oldlist)
  ENDIF

ENDPROC List(maxanz)


/* Disposes an list.
** returns NIL (eq.: listi:=disposeList(listi)).
*/
EXPORT PROC disposeList(listi)
  IF listi THEN DisposeLink(listi)
ENDPROC NIL


/* creates an copy of 'listi'
*/
EXPORT PROC listCreateCopy(listi) IS ListCopy(allocList(ListMax(listi)),listi,ALL)


/* returns true if 'what' (LONG) is a member of 'listi'
*/
EXPORT PROC listExistsLong(listi,what)
DEF x
ENDPROC Exists({x},listi,`x=what)

