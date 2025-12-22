MODULE '*steallong', '*stealchip', 'exec/memory'

CONST BLOCKSIZE=40960

DEF chip, fast, chipend, ptr:PTR TO LONG, errs

PROC main()
  DEF x, rnd=$83493220

  Vprintf('test block \d longwords (\d bytes)\n', [BLOCKSIZE/4, BLOCKSIZE])

  IF chip := AllocMem(BLOCKSIZE, MEMF_CHIP)
    IF fast := AllocMem(BLOCKSIZE, MEMF_ANY)
      -> muddle up memory blocks
      FOR x := 0 TO BLOCKSIZE-1 DO chip[x] := rnd := RndQ(rnd)
      FOR x := 0 TO BLOCKSIZE-1 DO fast[x] := rnd := RndQ(rnd)

      chipend := chip + BLOCKSIZE

      errs := 0; testchip();  Vprintf('stealchip(): \d errors\n', {errs})
      errs := 0; teststeal(); Vprintf('steallong(): \d errors\n', {errs})
      errs := 0; testplace(); Vprintf('placelong(): \d errors\n', {errs})

      FreeMem(fast, BLOCKSIZE)
    ENDIF
    FreeMem(chip, BLOCKSIZE)
  ENDIF
ENDPROC


-> compare longword at ptr with results of steallong(ptr)
PROC teststeal()
  ptr := chip
  WHILE ptr++ < chipend DO IF ptr[]<>steallong(ptr) THEN INC errs
ENDPROC

-> make random numbers and store them with placelong().
-> compare them with what was stored
PROC testplace()
  DEF rnd=$FACADE88

  ptr := chip
  WHILE ptr++ < chipend
    placelong(ptr, rnd := RndQ(rnd))
    IF ptr[] <> rnd THEN INC errs
  ENDWHILE
ENDPROC


-> stealchip() from chip block to fast block
-> compare chip contents vs fast contents
PROC testchip()
  DEF ptr2:PTR TO LONG, result

  ptr  := chip
  ptr2 := fast
  IF (result := stealchip(chip, fast, BLOCKSIZE)) = STEAL_OK
    WHILE ptr < chipend DO IF ptr[]++ <> ptr2[]++ THEN INC errs
  ELSE
    errs := result -> return negative stealchip() errorcode as no. of errors
  ENDIF
ENDPROC
