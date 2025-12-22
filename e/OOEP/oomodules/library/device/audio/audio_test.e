MODULE 'oomodules/library/device/audio','exec/memory'

PROC main() HANDLE
DEF ton:PTR TO audio,
    sounddaten=NIL:PTR TO CHAR,index,liste

  WriteF('Adresse Sounddaten = \d\n', sounddaten)

  WriteF('Allokiere objekt\n')
  Delay(50)
  NEW ton.new(["cmap",[%1001,%1010]:CHAR])
  WriteF('Allokiere speicher\n')
  Delay(50)

  sounddaten  := AllocMem(400,MEMF_CLEAR)
  Delay(50)
  liste := [1,23,67,89,112,89,45,23,1,-12,-56,-78,-112,-67,-45,-23]:CHAR

  WriteF('Kopiere Daten ins Chip RAM\n')
  Delay(50)

  FOR index := 0 TO 15 DO sounddaten[index] := liste[index]
  WriteF('öffne device\n')
  Delay(50)

  IF ton.open_audio([%1111]:CHAR)
    WriteF('Adresse Sounddaten = \d\n', sounddaten)
    Delay(50)
    ton.play(sounddaten,16,440,64,34)
    WriteF('\d\n', ton.lasterror)
  ELSE
    WriteF('!\n')
  ENDIF

EXCEPT

  WriteF('Fehler!\n')
ENDPROC

