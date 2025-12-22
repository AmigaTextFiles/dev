OPT OSVERSION=37
OPT PREPROCESS

MODULE 'other/wbstart','dos/dostags','workbench/startup','other/wbstart',
       'exec/ports','dos/dos','utility/tagitem','exec/nodes'

PROC main()
 
 DEF fl , msg:PTR TO wbstartmsg , mp:PTR TO mp,hp , ifh ,ofh , nil , mpname


  IF arg[]=NIL
     PutStr('Usage: <file name>\n')
     CleanUp(0)
  ENDIF

  IF (mp:=CreateMsgPort())
     
     fl:=CurrentDir(NIL)
     
     NEW msg
     msg.msg.ln.pri:=0
     msg.msg.replyport:=mp
     msg.dirlock:=fl
     msg.stack:=4096
     msg.prio:=0
     msg.name:=arg
     msg.arglist:=0
     msg.numargs:=0
     
     mpname:=WBS_PORTNAME
     
     Forbid()
     IF (hp:=FindPort(mpname)) THEN PutMsg(hp,msg)
     Permit()
     
     IF hp=NIL
        nil:='NIL:'
        IF (ifh:=Open(nil,MODE_NEWFILE)) AND
           (ofh:=Open(nil,MODE_OLDFILE))
           IF SystemTagList(WBS_LOADNAME,[SYS_INPUT,ifh,SYS_OUTPUT,ofh,
                                    SYS_ASYNCH,TRUE,SYS_USERSHELL,TRUE,
                                   NP_CONSOLETASK,NIL,NP_WINDOWPTR,NIL,
                                   TAG_DONE])=NIL
              FOR nil:=0 TO 10
                 Forbid()
                 IF (hp:=FindPort(mpname)) THEN PutMsg(hp,msg)
                 Permit()
                 EXIT hp<>NIL
                 Delay(25)
              ENDFOR
           ELSE
              Close(ifh)
              Close(ofh)
           ENDIF
        ENDIF
     ENDIF

     IF hp
        WaitPort(mp)
        GetMsg(mp)
     ELSE
        PutStr('Can\at find "WBStart-Handler"!\n')
     ENDIF
     
     DeleteMsgPort(mp)
     CurrentDir(fl)
     END msg
  
  ELSE
     PutStr('Can\at create port!\n')
  
  ENDIF

ENDPROC

