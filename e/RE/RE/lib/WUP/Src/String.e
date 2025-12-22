OPT NOHEAD,NOEXE,CPU='WUP'
PROC String(maxlen)
  DEF mem:PTR TO LONG
  IF mem:=ReNewR(maxlen+8)
    mem[1]:=(maxlen<<16) AND $FFFF0000
    mem += 8
  ENDIF
ENDPROC mem
