OPT MODULE  -> mymem.e emodules:mymisc/mymem

OPT EXPORT

PROC findString(_mem, _memlen, _string, _stringlen)
   DEF end:REG, mem:REG PTR TO CHAR,
       str:REG PTR TO CHAR,
       sl:REG, sp:REG

   mem := _mem
   str := _string
   sl := _stringlen - 1
   sp := 0

   end := mem + _memlen - _stringlen - 1

   WHILE mem <> end
      WHILE mem[sp] = str[sp]
         IF sp = sl THEN RETURN mem
         sp++
      ENDWHILE
         sp := 0
         mem++
   ENDWHILE
ENDPROC NIL

EXPORT PROC lwedsize(size)
   WHILE (size AND %11) DO size++
ENDPROC size

EXPORT PROC copyMemQuick(to:PTR TO LONG, from:PTR TO LONG, len)
   len--
   MOVE.L len, D0
   LSR.L #2, D0 -> /4
   MOVE.L to, A0
   MOVE.L from, A1
cpy:
   MOVE.L (A1)+, (A0)+
   DBRA D0, cpy

   ->len:=len/4
   ->len++
   ->WHILE (len--) DO to[]++ := from[]++
ENDPROC

/* longwordfill */
PROC fillMemL(_mem, _value32, _llen)
   DEF m:REG PTR TO LONG, v:REG, l:REG
   m:=_mem
   v:=_value32
   l:=_llen + 1
   WHILE (l--) DO m[]++ := v
ENDPROC

/* wordfill */
PROC fillMemW(_mem, _value16, _wlen)
   DEF m:REG PTR TO INT, v:REG, l:REG
   m:=_mem
   v:=_value16
   l:=_wlen + 1
   WHILE (l--) DO m[]++ := v
ENDPROC

/* bytefill */
PROC fillMemB(_mem, _value8, _blen)
   DEF m:REG PTR TO CHAR, v:REG, l:REG
   m:=_mem
   v:=_value8
   l:=_blen + 1
   WHILE (l--) DO m[]++ := v
ENDPROC



