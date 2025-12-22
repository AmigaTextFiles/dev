OPT MODULE

MODULE '*ipc'
MODULE '*collectionX'
MODULE '*collectionYX'
MODULE '*collectionZYX'

EXPORT OBJECT newMsgServer
   configPort:PTR TO newPort ->make your orders here..(PUBLIC)
   nmPort:PTR TO newPort     ->send your msg's here..
   ohyeah:PTR TO collectionZYX
   nm:PTR TO newMsg
ENDOBJECT

OBJECT travmsg OF collectionX_travObj
   nms:PTR TO newMsgServer
   type
   cmnd
   data
ENDOBJECT

PROC sendmsg(travmsg:PTR TO travmsg)
   DEF node:PTR TO xniv
   node := travmsg.node
   travmsg.nms.nm.do(node.id, travmsg.type,
                     travmsg.cmnd, travmsg.data)
ENDPROC

PROC newMsgServer() OF newMsgServer
   DEF signals, cfgsig, nmsig, msg:PTR TO newMsg, command,
       exit=FALSE, type, data, nayx:PTR TO collectionYX,
       nax:PTR TO collectionX, travmsg:travmsg

   NEW self.configPort.newPort('newMsgServer-Config')
   NEW self.nmPort.newPort()
   NEW self.ohyeah.collectionZYX()
   NEW self.nm.newMsg()

   cfgsig := self.configPort.getSigF()
   nmsig := self.nmPort.getSigF()
   REPEAT
      signals:=Wait(cfgsig OR nmsig)

      IF signals AND nmsig
         WHILE (msg := self.nmPort.collect())
            command := msg.getCmnd()
            type := msg.getType()
            data := msg.getData()
            nayx := self.ohyeah.getCollectionYX(type)
            IF nayx
               nax := nayx.getCollectionX(command)
               IF nax
                  travmsg.nms := self
                  travmsg.type := type
                  travmsg.cmnd := command
                  travmsg.data := data
                  nax.travNodes({sendmsg}, travmsg)
               ENDIF
            ENDIF
            msg.reply()
         ENDWHILE
      ENDIF

      IF signals AND cfgsig
         WHILE (msg := self.nmPort.collect())
            command := msg.getCmnd()
            data := msg.getData()
            SELECT command
            CASE "CFG"
               IF data
                  self.ohyeah.applyAllFrom(data)
                  self.ohyeah.cleanUp()
               ENDIF
            CASE "DIE" -> kill this server..
               exit := TRUE
            ENDSELECT
            msg.reply(self.nmPort)
         ENDWHILE
      ENDIF
   UNTIL exit

ENDPROC

EXPORT PROC getMsgServerReceivePort()
   DEF cfgport
   DEF reply
   DEF msg:PTR TO newMsg
   cfgport := FindPort('newMsgServer-Config')
   IF cfgport = NIL THEN RETURN NIL
   NEW msg.newMsg()
   msg.do(cfgport, NIL, NIL, NIL)
   reply := msg.getReply()
   END msg
ENDPROC reply


