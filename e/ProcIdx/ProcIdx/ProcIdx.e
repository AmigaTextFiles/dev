/*  Procedure Index v1.0
     2/5/96  J. Tierney

  Usage: ProcIdx [FROM] <file> [TO <file>]
    - Output defaults to the current CON:
*/

MODULE 'dos/dos',
       'exec/libraries'

CONST MAXSTRLEN = 256

ENUM OK=0, ER_ARGS, ER_SRC, ER_DST,
     RA_SRC=0, RA_DEST, RA_COUNT

RAISE ER_ARGS IF ReadArgs() = NIL

PROC main() HANDLE
  DEF rc=RETURN_OK, rdargs=NIL, opts:PTR TO LONG,
      dest, fhs=NIL, fhd=NIL, dlib:PTR TO lib,
      fbuf[MAXSTRLEN]:ARRAY OF CHAR, fbuflen, outstr[80]:STRING,
      linecnt=1, proccnt=0, l, so, eo

  NEW opts[RA_COUNT]
  rdargs:=ReadArgs('FROM/A,TO/K', opts, NIL)
  dest:=IF opts[RA_DEST] THEN opts[RA_DEST] ELSE 'CONSOLE:'

  fhs:=Open(opts[RA_SRC], MODE_OLDFILE)
  IF fhs = NIL THEN Raise(ER_SRC)
  fhd:=Open(dest, MODE_NEWFILE)
  IF fhd = NIL THEN Raise(ER_DST)

  dlib:=dosbase
  fbuflen:=IF dlib < 39 THEN MAXSTRLEN - 1 ELSE MAXSTRLEN

  WHILE Fgets(fhs, fbuf, fbuflen)
    l:=StrLen(fbuf)
    IF l > 7
      FOR so:=0 TO l DO EXIT fbuf[so] <> 32
      IF StrCmp(fbuf + so, 'PROC ', 5)
        eo:=InStr(fbuf, '(')
        StrCopy(outstr, fbuf + so + 5, eo - so - 5)
        StringF(outstr, '\l\s[30]\r\d[4]\n', outstr, linecnt)
        IF Fputs(fhd, outstr) THEN Raise(ER_DST)
        INC proccnt
      ENDIF
    ENDIF
    INC linecnt
  ENDWHILE

  StringF(outstr, '\nProcedures:  \d\n', proccnt)
  IF Fputs(fhd, outstr) THEN Raise(ER_DST)

  EXCEPT DO
    IF fhd THEN Close(fhd)
    IF fhs THEN Close(fhs)
    IF rdargs THEN FreeArgs(rdargs)
    IF exception
      SELECT exception
        CASE ER_ARGS
          so:='- Bad Args.'
        CASE ER_SRC
          so:='opening/reading source file.'
        CASE ER_DST
          so:='opening/writing destination file.'
        CASE "MEM"
          so:='allocating memory.'
      ENDSELECT
      WriteF('Error \s\n', so)
      rc:=RETURN_ERROR
    ENDIF
ENDPROC rc

CHAR '$VER: ProcIdx 1.0 (5.2.96) by J. Tierney', 0

