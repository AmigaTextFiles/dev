/* estring support functions
*/

OPT MODULE
OPT REG=5

RAISE "MEM" IF String()=NIL


/* Allocates an new string.
** 'maxlen' is the maximum length of the string
** 'oldstri' is an old estring or NIL
** If 'oldstri' exists and his maximum length is equal to 'maxlen' the
** 'oldstri' is returned.
** Otherwise 'oldstri' is disposed and a new string is allocated.
*/
EXPORT PROC allocString(maxlen,oldstri=NIL)

  IF oldstri
    IF StrMax(oldstri)=maxlen THEN RETURN oldstri
    DisposeLink(oldstri)
  ENDIF

ENDPROC String(maxlen)


/* Disposes an estring
** Returns NIL (eq.: stri:=disposeString(stri))
*/
EXPORT PROC disposeString(stri)
  IF stri THEN DisposeLink(stri)
ENDPROC NIL


/* Deletes 'anz' characters starting from position 'pos' in estring
** 'stri'.
** Returns 'stri'
*/
EXPORT PROC strDelete(stri,pos,anz)
DEF strlen

  strlen:=EstrLen(stri)
  IF pos+anz>=strlen

    IF pos<=strlen THEN SetStr(stri,pos)

  ELSE

    WHILE pos<=strlen
      stri[pos]:=stri[pos+anz]
      INC pos
    ENDWHILE
    SetStr(stri,StrLen(stri))

  ENDIF

ENDPROC stri


/* Removes all spaces from estring 'stri'.
** Returns 'stri'.
*/
EXPORT PROC strRemoveSpaces(stri)
DEF sppos,strlen,i:REG

  strlen:=EstrLen(stri)
  sppos:=InStr(stri,' ')
  WHILE sppos>=0

    FOR i:=sppos TO strlen DO stri[i]:=stri[i+1]
    DEC strlen

    sppos:=InStr(stri,' ',sppos)

  ENDWHILE

  SetStr(stri,StrLen(stri))

ENDPROC stri


/* Creates an copy of estring 'stri'
** Takes care of NIL-strings.
*/
EXPORT PROC strCreateCopy(stri) IS
  IF stri THEN StrCopy(allocString(StrLen(stri)),stri,ALL) ELSE NIL

