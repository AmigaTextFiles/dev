
-> eventLoop is an abstraction of an application event loop .

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/any'
MODULE 'fw/wbObject'

OBJECT eventLoop OF any
  signalBits:LONG
  wbObjs[NUMSIGNALS]:ARRAY OF LONG
ENDOBJECT

-> Add a WorkBench object to the event loop.
PROC addWBObject(wbObj:PTR TO wbObject) OF eventLoop
  DEF signalBit
  IF (signalBit:=wbObj.signal())<>-1
    self.signalBits:=self.signalBits OR Shl(1,signalBit)
    self.wbObjs[signalBit]:=wbObj
  ENDIF
ENDPROC

-> Starts the processing of the event loop.
-> Do nothing if no AddWBObject() has been made before.
PROC do() OF eventLoop
  DEF signalsReceived,signalBit,result,wbObj:PTR TO wbObject
  WHILE self.signalBits<>0
    signalsReceived:=Wait(self.signalBits)
    FOR signalBit:=0 TO NUMSIGNALS-1
      IF Shl(1,signalBit) AND signalsReceived
        wbObj:=self.wbObjs[signalBit]
        result:=wbObj.handleActivation()
        IF result=STOPIT
          wbObj.remove()
          self.wbObjs[signalBit]:=NIL
          self.signalBits:=Eor(self.signalBits,Shl(1,signalBit))
        ELSEIF result=STOPALL
          FOR signalBit:=0 TO NUMSIGNALS-1
            IF wbObj:=self.wbObjs[signalBit] THEN wbObj.remove()
          ENDFOR
          self.signalBits:=0
        ENDIF
      ENDIF
    ENDFOR
  ENDWHILE
ENDPROC

