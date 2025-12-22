
-> wbCommodity is an abstraction of commodities.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'commodities','libraries/commodities'
MODULE 'fw/wbObject','fw/wbMessagePort'

OBJECT wbCommodity OF wbMessagePort
  broker
ENDOBJECT

-> Create a commodity.
-> Return FALSE if failed.
PROC create(name,line1,line2,hotkey,eventId,priority) OF wbCommodity HANDLE
  DEF broker,filter,sender,translate
  IF cxbase=NIL THEN Raise(0)
  IF self.makePort()=FALSE THEN Raise(0)
  IF (broker:=CxBroker([NB_VERSION,0,
    name,
    line1,
    line2,
    NBU_UNIQUE OR NBU_NOTIFY,
    COF_SHOW_HIDE,
    priority,
    0,self.port,0]:newbroker,NIL))=NIL THEN Raise(0)

  IF (filter:=CreateCxObj(CX_FILTER,hotkey,0))=NIL THEN Raise(0)
  AttachCxObj(broker,filter)
  IF (sender:=CreateCxObj(CX_SEND,self.port,eventId))=NIL THEN Raise(0)
  AttachCxObj(filter,sender)
  IF (translate:=CreateCxObj(CX_TRANSLATE,NIL,0))=NIL THEN Raise(0)
  AttachCxObj(sender,translate)
  IF CxObjError(filter) THEN Raise(0)
  ActivateCxObj(broker,TRUE)
  self.broker:=broker
  RETURN TRUE
EXCEPT
  self.remove()
ENDPROC FALSE

-> Handle the receipt of a message at the object's MsgPort.
PROC handleMessage(msg) OF wbCommodity
  DEF type,info
  type:=CxMsgType(msg)
  info:=CxMsgID(msg)
  SELECT type
  CASE CXM_IEVENT
    RETURN self.handleIEvent(info)
  CASE CXM_COMMAND
    SELECT info
    CASE CXCMD_DISABLE
      RETURN self.handleDisable()
    CASE CXCMD_ENABLE
      RETURN self.handleEnable()
    CASE CXCMD_APPEAR
      RETURN self.handleAppear()
    CASE CXCMD_DISAPPEAR
      RETURN self.handleDisappear()
    CASE CXCMD_KILL
      RETURN self.handleKill()
    CASE CXCMD_LIST_CHG
      RETURN self.handleListChange()
    CASE CXCMD_UNIQUE
      RETURN self.handleUnique()
    DEFAULT
      RETURN self.defaultHandler()
    ENDSELECT
  ENDSELECT
ENDPROC

PROC handleIEvent(info) OF wbCommodity IS PASS

PROC handleDisable() OF wbCommodity IS PASS

PROC handleEnable() OF wbCommodity IS PASS

PROC handleAppear() OF wbCommodity IS PASS

PROC handleDisappear() OF wbCommodity IS PASS

PROC handleKill() OF wbCommodity IS STOPALL

PROC handleListChange() OF wbCommodity IS PASS

PROC handleUnique() OF wbCommodity IS PASS

-> Default handler for message classes that don't have their own handler.
-> Calling this should be considered a bug, leading to program halting.
PROC defaultHandler() OF wbCommodity IS PASS

-> Remove the commodity.
PROC remove() OF wbCommodity
  IF self.broker THEN DeleteCxObjAll(self.broker)
  IF self.port THEN self.deletePort()
  self.broker:=NIL
ENDPROC

