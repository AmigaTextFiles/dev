MODULE 'oomodules/audio'

PROC main()
DEF ton:PTR TO audio
    ->DEF sounddaten[16]:ARRAY OF CHAR

  ->sounddaten := [1,44,2,44,2,55,2,66,2,66,2,77,22,88,22,99]:CHAR

  NEW ton

  IF ton.open([%1001,%1010]:CHAR)
    ton.play({sounddaten},16,440,64,34)
    WriteF('\d\n', ton.lasterror)
  ELSE
    WriteF('!\n')
  ENDIF
ENDPROC

->sounddaten: CHAR 1,23,67,89,112,89,45,23,1,-12,-56,-78,-112,-67,-45,-23
sounddaten: INCBIN 'C:Copy'
