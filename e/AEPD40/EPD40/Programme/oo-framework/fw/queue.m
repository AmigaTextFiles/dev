
                                           ASLFR_NEGATIVETEXT,'Cancel',
                                           ASLFR_REJECTICONS,TRUE,
                                           ASLFR_DOSAVEMODE,TRUE,
                                           ASLFR_INITIALDRAWER,defsdir,
                                           TAG_DONE])

    sc:=LockPubScreen(NIL)

    IF Stricmp('yes',argString(ttypes,'CX_POPUP','yes'))=0 THEN opengui()

    WHILE res<0
        mask:=Shl(1,brokerPort.sigbit)
        IF gh THEN mask:=Or(mask,gh.sig)
        sig:=Wait(mask)
        IF And(sig,Shl(1,brokerPort.sigbit))
            WHILE msg:=GetMsg(brokerPort)
                msgtype:=CxMsgType(msg)
                msgid:=CxMsgID(msg)
                ReplyMsg(msg)
 