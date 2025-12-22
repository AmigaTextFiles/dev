-> newEventLoop abstrakcyjna klasa do obsîugi zdarzeï
-> uzupeîniona o procedure zwalniajâca pamiëci na wszystkie zdarzenia

OPT MODULE
OPT EXPORT

MODULE 'fw/wbObject','fw/eventLoop'

OBJECT newEventLoop OF eventLoop
ENDOBJECT

-> zwalnia pamiëê na wszystkie podîâczone zdarzenia (obiekty)
PROC discard() OF newEventLoop
  DEF signalBit,wbObj: PTR TO wbObject
  FOR signalBit:=0 TO NUMSIGNALS-1
    IF wbObj:=self.wbObjs[signalBit] THEN wbObj.remove()
  ENDFOR
ENDPROC
