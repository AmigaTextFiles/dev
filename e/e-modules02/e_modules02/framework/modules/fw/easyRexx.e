-> moduî OO definiujâcy dostëp do easyrexxa z poziomu FW!
-> (c) Piotr Gapiïski (31.03.96)
-> NIE UÛYWAê do obsîugi ArexxShella i asynchronicznego przesyîania
-> wiadomoôci...

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'easyrexx','libraries/easyrexx','libraries/easyrexx_macros'
MODULE 'exec/ports','utility/tagitem','intuition/intuition'
MODULE 'fw/wbObject'

OBJECT easyRexx OF wbObject
  commandtable:PTR TO arexxcommandtable
  context:PTR TO arexxcontext
  portname: PTR TO CHAR
ENDOBJECT

-> konstruktor
-> zwraca FALSE w przypadku niepowodzenia
PROC create(commandtable,tags) OF easyRexx HANDLE
  IF easyrexxbase=NIL THEN Raise(0)
  self.commandtable:=commandtable
  self.context:=AllocARexxContextA([
    IF commandtable THEN ER_CommandTable ELSE TAG_IGNORE,commandtable,
    IF tags THEN TAG_MORE ELSE TAG_IGNORE,tags,TAG_DONE])
  IF self.context=NIL THEN Raise(0)
  self.portname:=self.context.portname
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> destruktor
PROC remove() OF easyRexx
  IF self.context THEN FreeARexxContext(self.context)
  self.context:=NIL
  self.portname:=NIL
  self.commandtable:=NIL
ENDPROC

-> obsîuguje zdarzenia gdy obiekt jest aktywowany
PROC handleActivation() OF easyRexx
  DEF done
  ER_SETSIGNALS(self.context,Shl(1,self.signal()))
ENDPROC self.handleMessage(self.context)

-> obsîuguje wiadomoôci napîywajâce do obiektu
PROC handleMessage(msg: PTR TO arexxcontext) OF easyRexx IS PASS

-> bit sygnalizacyjny EXECa naleûâcy do obiektu
PROC signal() OF easyRexx IS self.context.port.sigbit
-> niestety - program nie bedzie reagowaî na informacje z ArexxShella i
-> asynchronicznego portu easyrexxa
