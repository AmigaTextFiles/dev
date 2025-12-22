MODULE 'dos/dos'

-> bcause of the PC adding $0D in the newlines

-> i had to write this proggy to remove such

-> shit from the sources. (eg, it replaces it with " ")

-> usage : rem0d filename

PROC main()

   DEF fh, buf, flen

   fh := Open(arg, MODE_READWRITE)

   flen := FileLength(arg)

   buf := FastNew(flen+1)
   Read(fh, buf,flen)
   repChar(buf, $0D, " ")
   Seek(fh, 0, OFFSET_BEGINNING)
   Write(fh, buf, flen)
   Close(fh)
ENDPROC

PROC repChar(buf:PTR TO CHAR, ochar, nchar)
   WHILE buf[] <> NIL
      IF buf[] = ochar THEN buf[] := nchar
      buf++
   ENDWHILE
ENDPROC
