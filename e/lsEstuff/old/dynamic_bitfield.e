OPT MODULE ->bitfield.e

MODULE 'mymods/bits',
       'myoo/xl'

OBJECT bits32 OF xni
   bits32:LONG
ENDOBJECT


EXPORT OBJECT dynamic_bitfield
   PRIVATE
   xli:PTR TO xli
ENDOBJECT

PROC dynamic_bitfield() OF dynamic_bitfield
   NEW self.xli
ENDPROC

PROC end() OF dynamic_bitfield
   self.xli.fastdisposeall(SIZEOF bits32)
   END self.xli
ENDPROC

PROC set(bitnum) OF dynamic_bitfield
   DEF nodenum, node:PTR TO bits32, nodebitnum
   nodenum:=bitnum/32
   node:=self.xli.find(nodenum)
   IF node = NIL
      node:=FastNew(SIZEOF bits32)
      self.xli.addtail(node)
      node.id:=nodenum
   ENDIF
   nodebitnum:=bitnum - (nodenum * 32)
   node.bits32:=bitset(node.bits32, nodebitnum)
ENDPROC

PROC clr(bitnum) OF dynamic_bitfield
   DEF nodenum, node:PTR TO bits32, nodebitnum
   nodenum:=bitnum/32
   node:=self.xli.find(nodenum)
   IF node
      nodebitnum:=bitnum - (nodenum * 32)
      node.bits32:=bitclr(node.bits32, nodebitnum)
      IF node.bits32 = NIL
         self.xli.remove(node)
         FastDispose(node, SIZEOF bits32)
      ENDIF
   ENDIF
ENDPROC

PROC get(bitnum) OF dynamic_bitfield
   DEF nodenum, node:PTR TO bits32, nodebitnum
   nodenum:=bitnum/32
   node:=self.xli.find(nodenum)
   IF node
      nodebitnum:=bitnum - (nodenum * 32)
      RETURN bitget(node.bits32, nodebitnum)
   ENDIF
ENDPROC NIL


