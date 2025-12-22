OPT MODULE

MODULE 'leifoo/nm'
MODULE 'leifoo/nmList'
MODULE 'leifoo/nmIList'
MODULE 'mymods/bits'

EXPORT CONST LEVEL_ON=1, LEVEL_OFF=2, LEVEL_X=4
SET ONBIT, OFFBIT, XBIT

EXPORT OBJECT element OF nmI
   PRIVATE
   inputs:PTR TO CHAR
   nrofinputs:CHAR
   output:CHAR
   transferlist:PTR TO nmList
ENDOBJECT

->the connectnodes in element.connectlist
OBJECT e_transfer OF nm
   toelement:PTR TO element
   toinput
ENDOBJECT

PROC new(nrofinputs) OF element
   self.nrofinputs := nrofinputs
   self.inputs := FastNew(nrofinputs)
   setAllInputsLevel(self, LEVEL_X)
   self.output := LEVEL_X
   NEW self.transferlist.new(NIL)
ENDPROC

PROC end() OF element
   FastDispose(self.inputs, self.nrofinputs)
   END self.transferlist
ENDPROC

PROC setAllInputsLevel(e:PTR TO element, level)
   DEF a
   FOR a := 0 TO e.nrofinputs - 1 DO e.inputs[a] := level
ENDPROC

PROC getInputsOR(e:PTR TO element)
   DEF a
   DEF temp=NIL
   FOR a := 0 TO e.nrofinputs - 1 DO temp := temp OR e.inputs[a]
ENDPROC temp

PROC computeOutput() OF element IS EMPTY

PROC getObjectName() OF element IS 'element'

PROC setInputLevel(inputnr, level) OF element
   self.inputs[inputnr] := level
ENDPROC

PROC getInputLevel(inputnr) OF element IS self.inputs[inputnr]

PROC getOutputLevel() OF element IS self.output

PROC getNrOfInputs() OF element IS self.nrofinputs

PROC tickTime() OF element IS NIL

PROC transferOutput() OF element
   DEF c:PTR TO e_transfer
   c := self.transferlist.first()
   WHILE c
      c.toelement.inputs[c.toinput] := self.output
      c := c.next
   ENDWHILE
ENDPROC

PROC setTransfer(toelement, toinput) OF element
   DEF c:PTR TO e_transfer
   c := findTransfer(self.transferlist, toelement, toinput)
   IF c = NIL
      c := self.transferlist.addLast(NEW c)
   ENDIF
   c.toelement := toelement
   c.toinput := toinput
ENDPROC

PROC unsetTransfer(toelement, toinput) OF element
   DEF c:PTR TO e_transfer
   c := findTransfer(self.transferlist, toelement, toinput)
   IF c THEN self.transferlist.delete(c)
ENDPROC

PROC clearTransfers() OF element IS self.transferlist.clear()

PROC findTransfer(clist:PTR TO nmList, toelement, toinput)
   DEF c:PTR TO e_transfer
   c := clist.first()
   WHILE c
      IF c.toelement = toelement
      IF c.toinput = toinput
         RETURN c
      ENDIF ; ENDIF
      c := c.next
   ENDWHILE
ENDPROC NIL


EXPORT OBJECT not OF element ; ENDOBJECT

PROC new(nrofinputs) OF not IS SUPER self.new(1)

PROC computeOutput() OF not
   DEF oldout
   oldout := self.output
   IF bitGet(self.inputs[0], ONBIT)
      self.output := bitSet(NIL, OFFBIT)
   ELSEIF bitGet(self.inputs[0], OFFBIT)
     self.output := bitSet(NIL, ONBIT)
   ELSE
      self.output := bitSet(NIL, XBIT)
   ENDIF
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE

PROC getObjectName() OF not IS 'not'

PROC getNrOfInputs() OF not IS 1

EXPORT OBJECT or OF element ; ENDOBJECT

PROC computeOutput() OF or
   DEF or
   DEF oldout
   oldout := self.output
   or := getInputsOR(self)
   IF bitGet(or, ONBIT)
      self.output := bitSet(NIL, ONBIT)
   ELSEIF bitGet(or, XBIT)
      self.output := bitSet(NIL, XBIT)
   ELSE
      self.output := bitSet(NIL, OFFBIT)
   ENDIF
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE

EXPORT OBJECT nor OF element ; ENDOBJECT

PROC getObjectName() OF nor IS 'nor'

PROC computeOutput() OF nor
   DEF or
   DEF oldout
   oldout := self.output
   or := getInputsOR(self)
   IF bitGet(or, ONBIT)
      self.output := bitSet(NIL, OFFBIT)
   ELSEIF bitGet(or, XBIT)
      self.output := bitSet(NIL, XBIT)
   ELSE
      self.output := bitSet(NIL, ONBIT)
   ENDIF
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE

EXPORT OBJECT and OF element ; ENDOBJECT

PROC getObjectName() OF and IS 'and'

PROC computeOutput() OF and
   DEF or
   DEF oldout
   oldout := self.output
   or := getInputsOR(self)
   IF bitGet(or, OFFBIT)
      self.output := bitSet(NIL, OFFBIT)
   ELSEIF bitGet(or, XBIT)
      self.output := bitSet(NIL, XBIT)
   ELSE
      self.output := bitSet(NIL, ONBIT)
   ENDIF
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE


EXPORT OBJECT nand OF element ; ENDOBJECT

PROC getObjectName() OF nand IS 'nand'

PROC computeOutput() OF nand
   DEF or
   DEF oldout
   oldout := self.output
   or := getInputsOR(self)
   IF bitGet(or, OFFBIT)
      self.output := bitSet(NIL, ONBIT)
   ELSEIF bitGet(or, XBIT)
      self.output := bitSet(NIL, XBIT)
   ELSE
      self.output := bitSet(NIL, OFFBIT)
   ENDIF
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE

EXPORT OBJECT xor OF element ; ENDOBJECT

PROC new(nrofinputs) OF xor IS SUPER self.new(2)

PROC getObjectName() OF xor IS 'xor'

PROC getNrOfInputs() OF xor IS 2

PROC computeOutput() OF xor
   DEF or
   DEF oldout
   oldout := self.output
   or := getInputsOR(self)
   IF bitGet(or, XBIT)
      self.output := bitSet(NIL, XBIT)
   ELSEIF self.inputs[0] <> self.inputs[1]
      self.output := bitSet(NIL, OFFBIT)
   ELSE
      self.output := bitSet(NIL, ONBIT)
   ENDIF
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE

EXPORT OBJECT delay OF element ; ENDOBJECT

PROC new(delay) OF delay
   DEF a
   self.output := LEVEL_X
   self.inputs := FastNew(delay + 1)
   FOR a := 0 TO delay DO self.inputs[a] := LEVEL_X
   self.nrofinputs := delay
ENDPROC

PROC getObjectName() OF delay IS 'delay'

PROC getNrOfInputs() OF delay IS 1

PROC computeOutput() OF delay
   DEF or
   DEF oldout
   oldout := self.output
   self.output := self.inputs[0]
ENDPROC IF oldout <> self.output THEN TRUE ELSE FALSE

PROC tickTime() OF delay
   DEF a:REG
   FOR a := self.nrofinputs TO 1 STEP -1 DO self.inputs[a-1] := self.inputs[a]
ENDPROC

PROC end() OF delay IS FastDispose(self.inputs, (self.nrofinputs) + 1)

