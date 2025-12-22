OPT MODULE

MODULE 'myoo/d1da', 'mymods/bits'

EXPORT OBJECT dbf
   PRIVATE
   d1da:PTR TO d1da
ENDOBJECT

PROC dbf() OF dbf
   NEW self.d1da
ENDPROC

PROC end() OF dbf
   END self.d1da
ENDPROC

PROC set(bitnum) OF dbf
   DEF nodenum, nodebitnum, bits
   nodenum:=bitnum/32
   nodebitnum:=bitnum - (nodenum * 32)
   bits:=self.d1da.get(nodenum)
   bits:=bitset(bits, nodebitnum)
   self.d1da.set(nodenum, bits)
ENDPROC

PROC clr(bitnum) OF dbf
   DEF nodenum, nodebitnum, bits
   nodenum:=bitnum/32
   nodebitnum:=bitnum - (nodenum * 32)
   bits:=self.d1da.get(nodenum)
   bits:=bitclr(bits, nodebitnum)
   IF bits = NIL
      self.d1da.unset(nodenum)
   ELSE
      self.d1da.set(nodenum, bits)
   ENDIF
ENDPROC

PROC get(bitnum) OF dbf
   DEF nodenum, nodebitnum
   nodenum:=bitnum/32
   nodebitnum:=bitnum-(nodenum*32)
ENDPROC bitget(self.d1da.get(nodenum), nodebitnum)


