-> displayalert.e -  This program implements a recoverable alert

MODULE 'intuition/intuition'

PROC main()
  IF DisplayAlert(RECOVERY_ALERT, {alertMsg}, 52)
    WriteF('Alert returned TRUE\n')
  ELSE
    WriteF('Alert returned FALSE\n')
  ENDIF
ENDPROC

-> Each string requires its own positioning information, as explained in the
-> manual.  Hex notation has been used to specify the positions of the text.
-> Hex numbers start with a "$" and the characters that make up the number.
->
-> Each line needs 2 bytes of x position, and 1 byte of y position.
->   in our 1st line: x = 0 $f0 (2 bytes) and y = $14 (1 byte)
->   In our 2nd line: x = 0 $80 (2 bytes) and y = $24 (1 byte)
-> Each line is NIL terminated plus a continuation character (0=done).  The
-> entire alert must end in TWO NILs, one for the end of the string, and one
-> for the 0 continuation character.
-> E-Note: using static data is just one way of doing this neatly
alertMsg:
  CHAR 0, $f0, $14, 'OH NO, NOT AGAIN!', NIL, 1,
       0, $80, $24, 'PRESS MOUSEBUTTON:   LEFT=TRUE   RIGHT=FALSE', NIL, 0
