OPT MODULE
OPT REG=5


MODULE 'other/wbstart','exec/ports','dos/dos','exec/memory','dos/dostags',
       'workbench/startup'



EXPORT PROC runcli(name)
 DEF nil , in , out , result , id , cname[120]:ARRAY OF CHAR ,
     cd , lock , filename 

  nil:='NIL:'
  id:=FALSE
  
  IF (in:=Open(nil,OLDFILE))=NIL THEN BRA endrun
  IF (out:=Open(nil,OLDFILE))=NIL THEN BRA closein
  filename:=FilePart(name)
  MOVE.L   name,D0
  MOVE.L   filename,D1
  SUB.L    D0,D1
  MOVE.L   D1,lock
  MOVEQ    #34,D0
  MOVEA.L  filename,A1
  MOVEA.L  cname,A0
  MOVE.B   D0,(A0)+
  MOVEQ    #117,D1
copy:
  MOVE.B   (A1)+,(A0)+
  DBEQ     D1,copy
  TST.B    -1(A1)
  BNE.S    nosub
  SUBQ.W   #1,A0
nosub:
  MOVE.B   D0,(A0)+
  CLR.B    (A0)
  MOVE.L   lock,D0
  BEQ.S    nolock
  MOVEA.L  name,A0
  CLR.B    0(A0,D0.W)
  IF (lock:=Lock(name,SHARED_LOCK)) THEN cd:=CurrentDir(lock)
nolock:
  result:=SystemTagList(cname,[
                               SYS_INPUT,in,SYS_OUTPUT,out,
                               SYS_ASYNCH,TRUE,SYS_USERSHELL,TRUE,
                               NP_CONSOLETASK,NIL,NP_WINDOWPTR,NIL,
                               NIL])
   IF lock
      CurrentDir(cd)
      UnLock(lock)
   ENDIF
     
   MOVEQ    #-1,D1       ->  in D1 TRUE or RUNERROR code
   MOVE.L   result,D0
   BNE.S    error
   MOVE.L   D1,id        ->      id:=TRUE
   BRA.S    endrun
error:
   CMP.L    D0,D1
   BNE.S    endrun
   Close(out)
closein:
   Close(in)
endrun:

ENDPROC id



EXPORT PROC runwb(name)
 
 DEF fl , msg:PTR TO wbstartmsg , mp , hp , mpname , id , x ,
     rmsg:PTR TO wbstartup


  id:=FALSE
  
  IF (msg:=AllocMem(SIZEOF wbstartmsg,MEMF_CLEAR))
     IF (fl:=CurrentDir(NIL))
        IF (mp:=CreateMsgPort())
            msg.msg.replyport:=mp
            msg.msg.length:=SIZEOF wbstartmsg
            msg.dirlock:=fl
            msg.stack:=4096
            msg.name:=name
            mpname:='WBStart-Handler Port'
            Forbid()
            IF (hp:=FindPort(mpname)) THEN PutMsg(hp,msg)
            Permit()
            IF hp=NIL
               IF runcli('L:WBStart-Handler')
                  FOR x:=1 TO 10
                     Forbid()
                     IF (hp:=FindPort(mpname)) THEN PutMsg(hp,msg)
                     Permit()
                     EXIT hp<>NIL
                     Delay(25)
                  ENDFOR
               ENDIF
            ENDIF
            IF hp
               WaitPort(mp)
               rmsg:=GetMsg(mp)
               IF rmsg.numargs<>NIL THEN id:=TRUE
            ENDIF
            DeleteMsgPort(mp)
        ENDIF
        CurrentDir(fl)
     ENDIF
     FreeMem(msg,SIZEOF wbstartmsg)
  ENDIF   

ENDPROC id

