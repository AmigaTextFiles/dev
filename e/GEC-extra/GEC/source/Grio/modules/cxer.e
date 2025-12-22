OPT MODULE
OPT REG=5
OPT PREPROCESS


MODULE 'commodities','libraries/commodities'
MODULE 'exec/ports'


EXPORT OBJECT cxer
 signal
 msgid
 msgtype
 PRIVATE
 port:PTR TO mp
 nb:PTR TO newbroker
 broker
ENDOBJECT


EXPORT CONST EVT_HOTKEY="CXH"


EXPORT ENUM CXERROR_NONE,CXERROR_BADOS,CXERROR_PORT,CXERROR_LIB,CXERROR_MEMNB,
            CXERROR_BROKER,CXERROR_CXOBJ,CXERROR_DUPLICATE


PROC new() OF cxer
DEF res
IF KickVersion(36)=FALSE
   RETURN CXERROR_BADOS
ENDIF
res:=CXERROR_PORT
IF (self.port:=CreateMsgPort())
   self.signal:=Shl(1,self.port.sigbit)
   res:=CXERROR_LIB
   IF (cxbase:=OpenLibrary('commodities.library',37))
      res:=CXERROR_MEMNB
      IF (self.nb:=New(SIZEOF newbroker))
         res:=CXERROR_NONE
      ENDIF
   ENDIF
ENDIF
IF res<>CXERROR_NONE
   self.end()
ENDIF
ENDPROC res


PROC end() OF cxer
DEF msg
IF self.broker THEN DeleteCxObjAll(self.broker)
IF self.port
   WHILE (msg:=GetMsg(self.port)) DO ReplyMsg(msg)
   DeleteMsgPort(self.port)
ENDIF
Dispose(self.nb)
CloseLibrary(cxbase)
ENDPROC D0


PROC install(name,title,descr,showhide=FALSE,hotkey=NIL,pri=0) OF cxer
DEF nb:PTR TO newbroker,broker,filter,sender,translate,err
nb:=self.nb
nb.version:=NB_VERSION
nb.port:=self.port
nb.name:=name
nb.title:=title
nb.descr:=descr
nb.flags:=IF showhide THEN COF_SHOW_HIDE ELSE NIL
nb.pri:=pri
nb.unique:=NBU_UNIQUE OR NBU_NOTIFY
IF (broker:=CxBroker(nb,{err}))
   self.broker:=broker
   IF hotkey
      IF (filter:=CxFilter(hotkey))
         AttachCxObj(broker,filter)
         IF (sender:=CxSender(self.port,EVT_HOTKEY))
            AttachCxObj(filter,sender)
            IF (translate:=CxTranslate(NIL))
               AttachCxObj(filter,translate)
               IF CxObjError(filter)=CBERR_OK
                  JUMP quit
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      RETURN CXERROR_CXOBJ
   ENDIF
   JUMP quit
ENDIF
IF err=CBERR_DUP
   RETURN CXERROR_DUPLICATE
ENDIF
RETURN CXERROR_BROKER
quit:
ENDPROC CXERROR_NONE


PROC handlemsg() OF cxer
DEF msg
IF (msg:=GetMsg(self.port))
   self.msgid:=CxMsgID(msg)
   self.msgtype:=CxMsgType(msg)
   ReplyMsg(msg)
   IF self.msgtype=CXM_COMMAND
      IF self.msgid=CXCMD_DISABLE
         self.activate(FALSE)
      ELSEIF self.msgid=CXCMD_ENABLE
         self.activate(TRUE)
      ENDIF
   ENDIF
ENDIF
ENDPROC NIL


PROC activate(mode) OF cxer
IF self.broker
   ActivateCxObj(self.broker,mode)
ENDIF
ENDPROC mode













