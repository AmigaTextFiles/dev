MODULE 'dos/dos'
MODULE '*png'
PROC main() HANDLE
   DEF fh=NIL, fib:fileinfoblock, mem=NIL:PTR TO LONG, i, l
   WriteF('arg=\s\n', arg)
   fh := Open(arg, OLDFILE)
   IF fh = NIL THEN Raise("OPEN")
   IF ExamineFH(fh, fib) = FALSE THEN Raise("EXAM")
   mem := NewR(fib.size)
   IF Read(fh, mem, fib.size) <> fib.size THEN Raise("READ")
   IF mem[]++ <> PNGFILESIG1 THEN Raise("FORM")
   IF mem[]++ <> PNGFILESIG2 THEN Raise("FORM")

   WHILE i := uaLONG(mem+4)
      WriteF('datalen = \d\n', l := uaLONG(mem))
      WriteF('chunkid = \s\n', [i,NIL])
      mem := mem + 8
      IF i = "IHDR"
         WriteF('   width: \d\n', uaLONG(mem))
         WriteF('   height: \d\n', uaLONG(mem)+4)
         WriteF('   bitdepth: \d\n', Char(mem+8))
         WriteF('   colortype: \d\n', Char(mem+9))
         WriteF('   cmprmeth: \d\n', Char(mem+10))
         WriteF('   filtmeth: \d\n', Char(mem+11))
         WriteF('   ilacemeth: \d\n', Char(mem+12))
      ENDIF
      mem := mem + l
      WriteF('crc = $\h\n', uaLONG(mem))
      mem := mem + 4
      EXIT i = "IEND"
   ENDWHILE

EXCEPT DO

  IF fh THEN Close(fh)

  SELECT exception
  CASE "OPEN"  ; WriteF('error: open\n')
  CASE "EXAM"  ; WriteF('error: exam\n')
  CASE "READ"  ; WriteF('error: read\n')
  CASE "FORM"  ; WriteF('error: form\n')
  CASE "MEM"   ; WriteF('error: mem\n')
  CASE NIL
  DEFAULT      ; WriteF('error: ???\n')
  ENDSELECT

ENDPROC

PROC uaLONG(ptr)
   DEF long
   long := (ptr[]++ SHL 24) OR (ptr[]++ SHL 16) OR (ptr[]++ SHL 8) OR ptr[]
ENDPROC long