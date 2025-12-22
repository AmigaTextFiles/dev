/* replaces all the format signs of E ('\x') within an
** estring. With this you can also use those format signs in
** external datas and then simply call this routine within your
** program.
*/

OPT MODULE
OPT REG=5

MODULE 'sven/support/string'

EXPORT CONST EXCEPTION_ReplaceFormatSigns="rfse"

/* replaces all format codes within estring (!) 'stri' and copies
** the result into estring (!) 'dest'.
**
** if 'dest' is NIL, it will be copied to 'stri'.
**
** May raise exceptions.
** if exception is equal to 'EXCEPTION_ReplaceFormatSigns' the exceptioninfo
** variables contains the position where the illegal format code was found.
**
** Returns the destination
*/
EXPORT PROC replaceFormatSigns(stri:PTR TO CHAR,dest=NIL:PTR TO CHAR) HANDLE
DEF hstri=NIL:PTR TO CHAR,
    spos=0,
    epos=0,
    dummy,
    c

  /* dummy string
  */
  hstri:=allocString(EstrLen(stri)*3)
  StrCopy(hstri,'')

  WHILE c:=stri[epos++]
    IF c="\\"

      /* found an format sign
      ** Copy the old string
      */
      IF epos-spos>1
        StrAdd(hstri,stri+spos,epos-spos-1)
      ENDIF

      c:=stri[epos++]
      SELECT c
        CASE "n"  ; dummy:='\n'   -> linefeed
        CASE "a"  ; dummy:='\a'   -> apostrophe
        CASE "q"  ; dummy:='\q'   -> doublequote
        CASE "e"  ; dummy:='\e'   -> escape
        CASE "t"  ; dummy:='\t'   -> tabulator
        CASE "\\" ; dummy:='\\'   -> backslash
        CASE "0"  ; dummy:='\0'   -> zero byte
        CASE "b"  ; dummy:='\b'   -> carriage RETURN
        DEFAULT   ; dummy:=NIL
      ENDSELECT

      IF dummy
        StrAdd(hstri,dummy)
      ELSE
        /* error! wrong format code
        */
        Throw(EXCEPTION_ReplaceFormatSigns,epos-2)
      ENDIF

      spos:=epos

    ENDIF
  ENDWHILE

  /* Copy rest of string
  */
  IF epos-spos>0
    StrAdd(hstri,stri+spos,epos-spos)
  ENDIF

  /* everything is done, copy the string
  */
  IF dest=NIL THEN dest:=stri
  StrCopy(dest,hstri)

EXCEPT DO
  disposeString(hstri)
  ReThrow()

ENDPROC dest

