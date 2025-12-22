/*

      AudioSTREAM Professional
      (c) 1997 Immortal SYSTEMS

      Source codes for version 1.0

      =================================================

      Source:     rta.e
      Description:    retargetable audio support
      Contains:   all audio hardware stuff
      Version:    1.0
 --------------------------------------------------------------------
*/


-> USES AHI at this moment

->    ***
->    OPTIONS AND MODULES
->    ***

            OPT MODULE
            OPT PREPROCESS


      MODULE 'utility'
      MODULE 'utility/tagitem' , 'utility/hooks'
      MODULE 'tools/installhook','other/ecode'
      MODULE 'ahi','exec','exec/interrupts','exec/nodes','hardware/intbits'
      MODULE 'devices/ahi','exec/io','exec/ports'
      MODULE 'exec/memory','dos/dos'
      MODULE '*common','*global'

-> --- player task stuff

EXPORT OBJECT obj_ptdata
      subtask:PTR TO subtask
      dbsnd
      spos
      lcount
      sigmask
      sig
      cursor
      sigmask2 -> for cursor updating
      maintask
      sref
      playing
      icp:PTR TO mp
      actrl:PTR TO ahiaudioctrl
      buffer0,buffer1,buflen,buflen2
      sample0:ahisampleinfo
      sample1:ahisampleinfo
ENDOBJECT


EXPORT OBJECT playparam
      sbuf,slen,srate,stype
ENDOBJECT


-> ---



#define STC_STARTUP  -2
#define STC_SHUTDOWN -1
#define STC_START    -3
#define STC_STOP     -4


      DEF ahiport:PTR TO mp,ahiio:PTR TO ahirequest,ahidevice
      DEF audioctrl:PTR TO ahiaudioctrl


      EXPORT DEF soundhook:PTR TO hook
      EXPORT DEF icp:PTR TO mp
      EXPORT DEF sigmask2

      EXPORT DEF data:PTR TO obj_ptdata

      CONST MINBUFLEN=4096



EXPORT PROC open_rta() -> will open retargetable audio

   ahidevice:=-1;ahiio:=NIL;ahiport:=NIL
   IF NIL=(ahiport:=CreateMsgPort()) THEN RETURN NIL
   IF NIL=(ahiio:=CreateIORequest(ahiport,SIZEOF ahirequest)) THEN RETURN NIL
   ahiio.version:=4  -> minimum is version 4.0
   IF 0<>(ahidevice:=OpenDevice('ahi.device',AHI_NO_UNIT,ahiio,0)) THEN RETURN NIL
   ahibase:=ahiio.std::iostd.device
   IF ahibase
         CDEBUG(RTA: Opened AHI device at \h,ahibase)
         RETURN TRUE
   ENDIF

ENDPROC FALSE


EXPORT PROC close_rta()

   IF ahidevice=0 THEN CloseDevice(ahiio)
   IF ahiio<>NIL THEN DeleteIORequest(ahiio)
   IF ahiport<>NIL THEN DeleteMsgPort(ahiport)
   CDEBUG(RTA: AHI device closed,0)
ENDPROC


EXPORT PROC alloc_rta(modeid,mixfreq,soundfunc,userdata)
      DEF temp
      temp:=AhI_AllocAudioA([
            AHIA_AUDIOID,modeid,
            AHIA_MIXFREQ,mixfreq,
            AHIA_CHANNELS,1,
            AHIA_SOUNDS,2,
            AHIA_SOUNDFUNC,soundfunc,
            AHIA_USERDATA,userdata,
            TAG_DONE])
      CDEBUG(RTA: Hardware allocation result \h,temp)
ENDPROC temp

EXPORT PROC free_rta()
      AhI_FreeAudio(data.actrl)
      CDEBUG(RTA: Hardware deallocated,0)
ENDPROC


-> error codes....0=OK, 1=NOMEM, 2=NOSIG, 3=NO AUDIO
ENUM DB_OK=0,DB_NOMEM,DB_NOSIG,DB_NOAUD

EXPORT PROC alloc_rta_dbuf(modeid,mixfreq,type) HANDLE -> type=as defined in AHI
      DEF mixf,playsamples,framesize

      SELECT type
            CASE AHIST_M8S;framesize:=1
            CASE AHIST_M16S;framesize:=2
            CASE AHIST_S8S;framesize:=2
            CASE AHIST_S16S;framesize:=4
      ENDSELECT

      data.dbsnd:=0
      data.actrl:=0

      data.buffer0:=0;data.buffer1:=0
      installhook(soundhook,{db_soundfunc})
      data.actrl:=alloc_rta(modeid,mixfreq,soundhook,data)
      IF data.actrl=0 THEN Raise(DB_NOAUD)
      AhI_GetAudioAttrsA(AHI_INVALID_ID,audioctrl,[AHIDB_MAXPLAYSAMPLES,
                       {playsamples},TAG_DONE])
      AhI_ControlAudioA(data.actrl,[AHIC_MIXFREQ_QUERY,{mixf},TAG_DONE])
      data.buflen:=Div(Mul(playsamples,17640),mixf)
      IF (data.buflen<MINBUFLEN) THEN data.buflen:=MINBUFLEN

      -> buflen is in FRAMES! we have to convert it
      data.buflen2:=Mul(data.buflen,framesize)
      CDEBUG(RTA: Double buffering used - buffer size \d,data.buflen2)

      data.buffer0:=AllocVec(data.buflen2,MEMF_PUBLIC+MEMF_CLEAR)
      IF data.buffer0=NIL THEN Raise(DB_NOMEM)
      data.buffer1:=AllocVec(data.buflen2,MEMF_PUBLIC+MEMF_CLEAR)
      IF data.buffer1=NIL THEN Raise(DB_NOMEM)

      data.sample0.type:=type;data.sample0.address:=data.buffer0;data.sample0.length:=data.buflen
      data.sample1.type:=type;data.sample1.address:=data.buffer1;data.sample1.length:=data.buflen

      AhI_LoadSound(0,AHIST_DYNAMICSAMPLE,data.sample0,data.actrl)
      AhI_LoadSound(1,AHIST_DYNAMICSAMPLE,data.sample1,data.actrl)


      data.sig:=AllocSignal(-1)
      IF data.sig=-1 THEN Raise(DB_NOSIG)
      data.sigmask:=Shl(1,data.sig)

EXCEPT
      IF data.buffer0 THEN FreeVec(data.buffer0)
      IF data.buffer1 THEN FreeVec(data.buffer1)
      IF data.sig<>-1 THEN FreeSignal(data.sig)
      data.sig:=-1
      IF data.actrl THEN free_rta()
      RETURN exception
ENDPROC 0


EXPORT PROC free_rta_dbuf()
      IF data.buffer0 THEN FreeVec(data.buffer0)
      IF data.buffer1 THEN FreeVec(data.buffer1)
      IF data.sig<>-1 THEN FreeSignal(data.sig)
      data.sig:=-1
      IF data.actrl THEN free_rta()
ENDPROC


EXPORT PROC run_playertask()


      storea4()
      data.icp:=icp
      data.sigmask2:=sigmask2
      data.maintask:=FindTask(NIL)
      data.cursor:=-1
      data.subtask:= spawnsubtask('AudioSTREAM_SamplePlayer',{playerfunc},data)
      IF data.subtask
            SetTaskPri(data.subtask.st_Task,10)
            CDEBUG(RTA: Player subtask created,0)
      ENDIF

ENDPROC data.subtask

EXPORT PROC kill_playertask()

      killsubtask(data.subtask)
      CDEBUG(RTA: Player subtask killed,0)
ENDPROC



EXPORT PROC start_playing(sbuf,slen,srate,stype,sref)
      DEF result

      data.sref:=sref
      IF data.playing
            stop_playing()
            
      ENDIF

      result:=sendsubtaskmsg(data.subtask,STC_START,[sbuf,slen,srate,stype]:playparam)
ENDPROC result

EXPORT PROC stop_playing()
      DEF played
      played:=data.playing
      Signal(data.subtask.st_Task,SIGBREAKF_CTRL_C)
      IF played THEN icc([CG_SYSTEM,IC_WAITPLMSG])
ENDPROC



PROC readsample(dest,size,data:PTR TO obj_ptdata)
      DEF bytes

      IF data.lcount=0 THEN RETURN 0
      IF data.lcount<size THEN bytes:=data.lcount ELSE bytes:=size
      data.lcount:=data.lcount-bytes
      CopyMem(data.spos,dest,bytes)
      data.spos:=data.spos+bytes

ENDPROC bytes

PROC cleararea(addr,bytes)

                  MOVE.L addr,A0
                  MOVE.L bytes,D0
            _clraloop:TST.L D0
                  BEQ _clraend
                  CLR.B (A0)+
                  SUBQ.L #1,D0
                  BRA _clraloop
            _clraend:
ENDPROC


-> !!!!!! CALLED FROM SUBTASK

EXPORT PROC playerfunc()
      DEF sbuf,slen,srate,stype
      DEF st=NIL:PTR TO subtask
      DEF data=NIL:PTR TO obj_ptdata
      DEF running=TRUE,command
      DEF stm=NIL:PTR TO subtaskmsg
      DEF signals,readbytes,flag
      DEF result
      DEF icpm:icpmsg

      geta4()
      
      IF (st:= initsubtask())
            data:= st.st_Data

      data.playing:=FALSE
      LOOP


        /*
        ** after the sub task is up and running, we go into
        ** a loop and process the messages from the main task.
        */
            WHILE (stm:= GetMsg(st.st_Port))
            command:=stm.stm_Command

            SELECT command
                  CASE STC_SHUTDOWN
                        running:= FALSE
                  CASE STC_START
                        sbuf:=stm.stm_Parameter::playparam.sbuf
                        slen:=stm.stm_Parameter::playparam.slen
                        srate:=stm.stm_Parameter::playparam.srate
                        stype:=stm.stm_Parameter::playparam.stype
                        result:=alloc_rta_dbuf(0,0,stype)
                        IF result=0 THEN data.playing:=TRUE
                        stm.stm_Result:=result

          ENDSELECT
          /*
          ** If we received a shutdown message, we do not reply it
          ** immediately. First, we need to free our resources.
          */
          IF (running=FALSE) THEN BRA exit
          ReplyMsg(stm)
        ENDWHILE
        IF (running=FALSE) THEN BRA exit
        IF (data.playing)
            SetSignal(0,SIGBREAKF_CTRL_C)

            data.cursor:=data.sref
            Signal(data.maintask,data.sigmask2)
            
            flag:=FALSE
            data.spos:=sbuf;data.lcount:=slen
            AhI_ControlAudioA(data.actrl,[AHIC_PLAY,TRUE,TAG_DONE])

            readsample(data.buffer0,data.buflen2,data)

            AhI_PlayA(data.actrl,[AHIP_BEGINCHANNEL,0,AHIP_FREQ,srate,
                        AHIP_VOL,$10000,AHIP_PAN,$8000,
                        AHIP_SOUND,0,AHIP_OFFSET,0,
                        AHIP_LENGTH,0,AHIP_ENDCHANNEL,NIL,
                        TAG_DONE])
            WHILE TRUE
                  signals:=Wait(data.sigmask OR SIGBREAKF_CTRL_C)
                  flag:=(signals AND SIGBREAKF_CTRL_C)
                  data.cursor:=data.spos-data.sref
                  Signal(data.maintask,data.sigmask2)
                  IF data.dbsnd=1
                        readbytes:=readsample(data.buffer1,data.buflen2,data)
                        IF readbytes<data.buflen2
                            -> Clear rest of buffer
                            cleararea(data.buffer1+readbytes,data.buflen2-readbytes)
                            Wait(data.sigmask)
                            -> Clear other buffer
                            cleararea(data.buffer0,data.buflen2)
                            flag:=TRUE
                        ENDIF


                  ELSE
                        readbytes:=readsample(data.buffer0,data.buflen2,data)
                        IF readbytes<data.buflen2
                            -> Clear rest of buffer
                            cleararea(data.buffer0+readbytes,data.buflen2-readbytes)
                            Wait(data.sigmask)
                            -> Clear other buffer
                            cleararea(data.buffer1,data.buflen2)
                            flag:=TRUE
                        ENDIF
                  ENDIF
                  EXIT flag
            ENDWHILE
                  Wait(data.sigmask)   -> Wait for half-loaded buffer to finish.
      data.cursor:=-1
      AhI_ControlAudioA(data.actrl,[AHIC_PLAY,FALSE,TAG_DONE])
      free_rta_dbuf()
      data.playing:=FALSE

      icpm.msg.ln.type:=NT_MESSAGE
      icpm.msg.length:=SIZEOF icpmsg
      icpm.msg.replyport:=st.st_Port
      icpm.command:=1024  -> unlock
      PutMsg(data.icp,icpm)
      WaitPort(st.st_Port)
      GetMsg(st.st_Port)

          /* Since we are very busy working, we do not Wait() for signals. */
        ELSE
          /* We have nothing to do, just sit quietly and wait for something to happen */
          WaitPort(st.st_Port)
        ENDIF
      ENDLOOP
exit:
      exitsubtask(st,stm)
    ENDIF
ENDPROC



      

      




PROC db_soundfunc(hook:PTR TO hook,actrl:PTR TO ahiaudioctrl,
                  smsg:PTR TO ahisoundmessage)
      DEF data:PTR TO obj_ptdata
      data:=actrl.userdata

      IF data.dbsnd=0 THEN data.dbsnd:=1 ELSE data.dbsnd:=0
      AhI_SetSound(0,data.dbsnd,0,0,actrl,NIL)
      Signal(data.subtask.st_Task,data.sigmask)
ENDPROC 0








-> geta4.e - store and get the global data pointer kept in register A4
-> (C) Leon Woestenberg

PROC storea4()
  LEA a4storage(PC),A0
  MOVE.L A4,(A0)
ENDPROC

PROC geta4()
  LEA a4storage(PC),A0
  MOVE.L (A0),A4
ENDPROC

a4storage:
  LONG NIL
