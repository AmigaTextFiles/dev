
/*

      AudioSTREAM Professional
      (c) 1997 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     common.e
      Description:    definitions & PROC common TO almost ALL modules
      Contains:   misc proc and object definitions, data management
      Version:    1.0
 --------------------------------------------------------------------
*/


->    ***
->    OPTIONS AND MODULES
->      ***       

            OPT MODULE
            OPT PREPROCESS

            MODULE 'muimaster' , 'libraries/mui','utility'
            MODULE 'utility/tagitem','tools/boopsi'
            MODULE '*GUI_DECLARATIONS','*declarations','*global'
            MODULE 'dos/dostags','dos/dosextens','exec/memory'
            MODULE 'exec/ports','exec/tasks'


->    ***
->    OBJECT DEFINITIONS
->      ***

EXPORT OBJECT obj_sigs        -> for VBEAMserver communication
      counter
      enable1,enable2
      signal1,signal2
      mytask
ENDOBJECT

EXPORT OBJECT obj_cfg         -> audiostream's configuration
      ahimodeid,ahimixfreq,timeresolution,mono
      defmoddir[80]:ARRAY OF CHAR
      definstrdir[80]:ARRAY OF CHAR
      defsmpldir[80]:ARRAY OF CHAR
      defwavdir[80]:ARRAY OF CHAR
      defdspdir[80]:ARRAY OF CHAR
ENDOBJECT 


EXPORT OBJECT obj_mdata       -> data needed mostly by player
      songlist[16]:ARRAY OF LONG
      seclist[256]:ARRAY OF LONG
      tracklist[256]:ARRAY OF LONG
      instrlist[256]:ARRAY OF LONG
      samplelist[256]:ARRAY OF LONG
      wavelist[256]:ARRAY OF LONG

      dsplist[32]:ARRAY OF LONG
      dspl[32]:ARRAY    -> pos 2 id
      dspu[32]:ARRAY OF INT -> usage table

      secl[256]:ARRAY -> pos 2 id for sections

      cursong  -> active song
      curtrack -> active track
      
      chon[4]:ARRAY OF LONG
ENDOBJECT

EXPORT OBJECT icpmsg
      msg:mn
      command
      param0
      param1
      param2
      param3
      result
ENDOBJECT





EXPORT OBJECT subtaskmsg
   stm_Message:mn
   stm_Command:INT
   stm_Parameter:LONG
   stm_Result:LONG
ENDOBJECT

EXPORT OBJECT subtask
  st_Task:PTR TO tc      /* sub task pointer */
  st_Port:PTR TO mp      /* allocated by sub task */
  st_Reply:PTR TO mp     /* allocated by main task */
  st_Data:LONG           /* more initial data to pass to the sub task */
  st_Message:subtaskmsg  /* Message buffer */
ENDOBJECT

#define STC_STARTUP  -2
#define STC_SHUTDOWN -1




->    ***
->    GLOBAL VARIABLES
->      ***

      EXPORT DEF icihook ->very important

      EXPORT DEF ahiport,ahiio,ahidevice   -> AHI specific

      EXPORT DEF rxr,rxm

->    gui objects

      EXPORT DEF _appl:PTR TO obj_application
      EXPORT DEF _appm:PTR TO obj_appmenu
      EXPORT DEF _main:PTR TO objw_maincontrol
      EXPORT DEF _info:PTR TO objw_info               
      EXPORT DEF _about:PTR TO objw_about
      EXPORT DEF _sels:PTR TO objw_selectsong
      EXPORT DEF _mopt:PTR TO objw_moduleoptions
      EXPORT DEF _sged:PTR TO objw_songeditor
      EXPORT DEF _sgop:PTR TO objw_songoptions
      EXPORT DEF _sdsp:PTR TO objw_songdsp
      EXPORT DEF _inst:PTR TO objw_instrument
      EXPORT DEF _idsp:PTR TO objw_instrumentdsp
      EXPORT DEF _smed:PTR TO objw_sampleeditor
      EXPORT DEF _smme:PTR TO obj_sampleedmenu
      EXPORT DEF _wved:PTR TO objw_waveeditor
      EXPORT DEF _wvme:PTR TO obj_waveedmenu
      EXPORT DEF _popt:PTR TO objw_playoptions
      EXPORT DEF _pcki:PTR TO objw_pickinstrument
      EXPORT DEF _pcks:PTR TO objw_picksample
      EXPORT DEF _pckw:PTR TO objw_pickwave
      EXPORT DEF _pckt:PTR TO objw_picktrack
      EXPORT DEF _lofl:PTR TO objw_loadfromlist
      EXPORT DEF _lied:PTR TO objw_listeditor
      EXPORT DEF _cvol:PTR TO objw_changevolume
      EXPORT DEF _cpit:PTR TO objw_changepitch
      EXPORT DEF _crch:PTR TO objw_createchord
      EXPORT DEF _tran:PTR TO objw_transpose
      EXPORT DEF _dspm:PTR TO objw_dspmanager
      EXPORT DEF _tred:PTR TO objw_trackeditor
      

      EXPORT DEF osig:PTR TO obj_sigs


      EXPORT DEF cfg:PTR TO obj_cfg

      EXPORT DEF changed      -> bool
      EXPORT DEF songs  -> songs present
      EXPORT DEF mdata:PTR TO obj_mdata
      EXPORT DEF loadeddsps   -> no. of loaded DSPs

      EXPORT DEF miscinfo:PTR TO CHAR     -> miscinfo gadget content
      EXPORT DEF mainwindowtitle:PTR TO CHAR
      EXPORT DEF infotitle:PTR TO CHAR
      EXPORT DEF ts:PTR TO CHAR


->    ***
->    CUSTOM CLASSES
->      ***

      EXPORT DEF mystring



->    **********************************************************

->    ***
->    COMMON PROCEDURES
->      ***


EXPORT PROC mulu(a,b)

      MOVE.L a,D0
      MOVE.L b,D1
      LONG $4c010000  -> mulu.l d1,d0
ENDPROC D0

EXPORT PROC divu(a,b)

      MOVE.L a,D0
      MOVE.L b,D1
      LONG $4c410000  -> divu.l d1,d0
ENDPROC D0



EXPORT PROC ext2long(what:PTR TO CHAR) -> will convert EXTENDED to LONG
      DEF mantissa

            MOVE.L what,A0
            MOVE.L 2(A0),D0 -> mantissa
            MOVE.B #30,D1
            SUB.B 1(A0),D1 ->exponent
      ex1:  TST.B D1
            BEQ ex2
            SUBQ.B #1,D1
            MOVE.L D0,D2 ->last
            LSR.L #1,D0
            BRA ex1
      ex2:  ANDI.L #1,D2
            BEQ ex3
            ADDQ.L #1,D0
      ex3:  MOVE.L D0,mantissa

ENDPROC mantissa

EXPORT PROC long2ext(buffer:PTR TO CHAR,value)
      DEF exp,i

      FOR i:=0 TO 9 DO buffer[i]:=0

      exp:=value
      MOVE.L exp,D0
      LSR.L #1,D0
      MOVE.L D0,exp

      FOR i:=0 TO 31
            MOVE.L exp,D0
            LSR.L #1,D0
            MOVE.L D0,exp
            EXIT exp=0
      ENDFOR
      buffer[1]:=i
      FOR i:=32 TO 1 STEP -1
            EXIT (value AND $80000000)
            MOVE.L value,D0
            LSL.L #1,D0
            MOVE.L D0,value
            PutLong(buffer+2,value)
      ENDFOR
ENDPROC




EXPORT PROC setdec(obj,number)      -> sets decimal no as an text content
      DEF strg[20]:STRING

      StringF(strg,'\d',number)
      set(obj,MUIA_Text_Contents,strg)
ENDPROC 


EXPORT PROC sleep() -> obsolete
      set (_appl.app,MUIA_Application_Sleep,MUI_TRUE)
ENDPROC

EXPORT PROC awake() -> obsolete
      set (_appl.app,MUIA_Application_Sleep,FALSE)
ENDPROC


EXPORT PROC setchanged(bool)

      changed:=bool
      icc([CG_SYSTEM,IC_UPDATEMAINTITLE,0])
ENDPROC           



/* --------------------  ERROR HANDLING ------------------- */

      
EXPORT PROC error_simple( message : PTR TO CHAR ) IS EasyRequestArgs( NIL , [ 20 , 0 ,
                   'Error' ,
                   message ,
                   'OK' ] , NIL , NIL )


EXPORT PROC error( message : PTR TO CHAR ) IS Mui_RequestA( _appl.app ,
               NIL ,
               NIL ,
               'Error' ,
               '*_OK' ,
               message ,
               NIL )

EXPORT PROC err(code)
      DEF temps[50]:STRING

      rxr:=code
      IF code=ERR_OK THEN RETURN rxr

      IF rxm=FALSE
            SELECT code
                  CASE ERR_NOTFOUND
                        error('File not found')
                  CASE ERR_NOMEM
                        error('Not enough memory available')
                  CASE ERR_NOPMEM
                        error('Not enough public memory available')
                  CASE ERR_READ
                        error('Error reading data')
                  CASE ERR_WRITE
                        error('Error writting data')
                  CASE ERR_IMP
                        error('Function not implemented')
                  CASE ERR_LCK
                        error('This can''t be done WHILE playing')
                  CASE ERR_AUD
                        error('Can''t allocate audio hardware')
                  CASE ERR_CANTOPEN
                        error('Can''t open file')
                  CASE ERR_UNRECOGNIZED
                        error('Can''t recognize the file')
                  CASE ERR_FSTRUCT
                        error('File structure error/Unsupported encoding type')
                  CASE ERR_SCBE
                        error('Sample copy buffer is empty')
                  CASE ERR_PLAYER
                        error('Can''t start the player')
                  CASE ERR_STDMEO
                        error('Sample types don''t match each other')
                  CASE ERR_16ONLY
                        error('16-bit sample required')

                  DEFAULT
                        StringF(temps,'Unknown error (code #\d) occured',code)
                        error(temps)
            ENDSELECT
      ENDIF
ENDPROC rxr



EXPORT PROC errnomem() IS err(ERR_NOMEM)
EXPORT PROC errnomemp() IS err(ERR_NOPMEM)
EXPORT PROC errunknown() IS err(-1)
EXPORT PROC errlck() IS err(ERR_LCK)
EXPORT PROC erraud() IS err(ERR_AUD)
EXPORT PROC errimp() IS err(ERR_IMP)





/* -------------------------------------------------- */

EXPORT PROC confirm(message: PTR TO CHAR) IS Mui_RequestA (_appl.app,
            NIL,NIL,'Request',
              '*_OK|_Cancel',message,NIL)

EXPORT PROC sethex(obj,num)
      DEF strg[10]:STRING

      StringF(strg,'\z\h[2]',num)
      set(obj,MUIA_Text_Contents,strg)
ENDPROC 

EXPORT PROC settas(obj,fmt,what) IS domethod(obj,[MUIM_SetAsString,
            MUIA_Text_Contents,fmt,what])


EXPORT PROC listq(object)

      set(object,MUIA_List_Quiet,MUI_TRUE)

ENDPROC

EXPORT PROC listnq(object)

      set(object,MUIA_List_Quiet,FALSE)

ENDPROC


EXPORT PROC status(prd) IS set(_info.txstatus,MUIA_Text_Contents,prd)

EXPORT PROC percent(text,b=1,a=1000) IS domethod(_info.txstatus,
            [MUIM_SetAsString,MUIA_Text_Contents,'%s (%ld%% done)',text,divu(mulu(100,b),a)])

EXPORT PROC sidle() IS set(_info.txstatus,MUIA_Text_Contents,'- Idle -')

-> no notify set

EXPORT PROC nset(obj,tag,data) IS 
      domethod(obj,[MUIM_NoNotifySet,
            tag,data])

EXPORT PROC logit(str:PTR TO CHAR) 

      domethod(_info.lv,[MUIM_List_InsertSingle,str,MUIV_List_Insert_Bottom])
      set(_info.lv,MUIA_List_Active,MUIV_List_Active_Bottom)
      set(_info.lv,MUIA_List_Active,MUIV_List_Active_Off)
ENDPROC


EXPORT PROC fslot(num)

      BRA labfstart

      labf1:      CMP.B #10,D0
            BGE bigger
            ADD.B #48,D0
            RTS
      bigger: ADD.B #55,D0
            RTS
      labfstart: MOVE.L num,D0
               LSR.B #4,D0
               BSR labf1
               MOVE.B D0,D1
               LSL.W #8,D1
               MOVE.L num,D0
               ANDI.B #$0000000f,D0
               BSR labf1
               OR.B D0,D1
               ANDI.L #$0000ffff,D1
               MOVE.L D1,D0
ENDPROC D0


EXPORT PROC interleave8(pcm1,pcm2,size,dest)
      DEF r

      IF size=0 THEN RETURN dest

            MOVE.L dest,A2
            MOVE.L pcm1,A0
            MOVE.L pcm2,A1
            MOVEQ.L #0,D2

i8loop:    MOVE.B (A0)+,(A2)+
            MOVE.B (A1)+,(A2)+
            ADDQ.L #1,A0
            ADDQ.L #1,A1
            ADDQ.L #1,D2
            CMP.L size,D2
            BNE i8loop

            MOVE.L A2,r
ENDPROC r

EXPORT PROC interleave16(pcm1,pcm2,size,dest)
      DEF r

      IF size=0 THEN RETURN dest

            MOVE.L dest,A2
            MOVE.L pcm1,A0
            MOVE.L pcm2,A1
            MOVEQ.L #0,D2

i16loop:    MOVE.W (A0)+,(A2)+
            MOVE.W (A1)+,(A2)+
            ADDQ.L #1,D2
            CMP.L size,D2
            BNE i16loop

            MOVE.L A2,r
ENDPROC r


EXPORT PROC copy16to8(pcm,size,dest)
      DEF r

      IF size=0 THEN RETURN dest

            MOVE.L dest,A2
            MOVE.L pcm,A0
            MOVEQ.L #0,D2

c8loop:     MOVE.B (A0)+,(A2)+
            ADDQ.L #1,A0
            ADDQ.L #1,D2
            CMP.L size,D2
            BNE c8loop

            MOVE.L A2,r
ENDPROC r



/* ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| 
            DATA MANAGEMENT 
      routines for easy list and music data management
   ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| */




-> universal low-lewel routines


EXPORT PROC movememup(srcbeg,srcend,dest)

            MOVE.L srcbeg,A0
            MOVE.L dest,A1
            MOVE.L srcend,A2

_uploop:    CMPA.L A2,A0
            BGT _upend
            MOVE.B (A0)+,(A1)+
            BRA _uploop
_upend:

ENDPROC


EXPORT PROC movememdown(srcbeg,srcend,dest)

            MOVE.L srcbeg,A0
            MOVE.L dest,A1
            MOVE.L srcend,A2
            ADDQ #1,A0
            ADDQ #1,A1

_downloop:  CMPA.L A2,A0
            BLE _downend
            MOVE.B -(A0),-(A1)
            BRA _downloop
_downend:

ENDPROC

/**************************************************************/
/* Functions for easy and secure spawning/killing of subtasks */
/**************************************************************/
-> GRABBED FOR MUI EXAMPLES ;-))))))




EXPORT PROC sendsubtaskmsg(st:PTR TO subtask,command,params)
  st.st_Message.stm_Message.replyport:= st.st_Reply
  st.st_Message.stm_Message.length   := SIZEOF subtaskmsg
  st.st_Message.stm_Command          := command
  st.st_Message.stm_Parameter        := params
  st.st_Message.stm_Result           := 0

  PutMsg(IF command=STC_STARTUP THEN st.st_Task::process.msgport ELSE st.st_Port,st.st_Message)
  WaitPort(st.st_Reply)
  GetMsg(st.st_Reply)
ENDPROC (st.st_Message.stm_Result)

EXPORT PROC spawnsubtask(name,func,data)
  DEF st=NIL:PTR TO subtask

  IF (st:=AllocVec(SIZEOF subtask,MEMF_PUBLIC OR MEMF_CLEAR))
    st.st_Reply:=CreateMsgPort()
    IF (st.st_Reply)
      st.st_Data:=data
      st.st_Task:= CreateNewProc([NP_ENTRY,func, -> = {renderfunc}
                                  NP_NAME,name,
                                  TAG_DONE])
      IF (st.st_Task)
        IF (sendsubtaskmsg(st,STC_STARTUP,st)) THEN RETURN (st)
      ENDIF
      DeleteMsgPort(st.st_Reply)
    ENDIF
    FreeVec(st)
  ENDIF
ENDPROC

EXPORT PROC killsubtask(st:PTR TO subtask)
  sendsubtaskmsg(st,STC_SHUTDOWN,st)
  DeleteMsgPort(st.st_Reply)
  FreeVec(st)
ENDPROC

EXPORT PROC exitsubtask(st:PTR TO subtask,stm:PTR TO subtaskmsg)
  /*
  ** We reply after a Forbid() to make sure we're really gone
  ** when the main task continues.
  */
  IF (st.st_Port) THEN DeleteMsgPort(st.st_Port)
  Forbid()
  stm.stm_Result:= FALSE
  ReplyMsg(stm)
ENDPROC

EXPORT PROC initsubtask()
  DEF me=NIL:PTR TO tc,
      st=NIL:PTR TO subtask,
      stm=NIL:PTR TO subtaskmsg

  me:= FindTask(NIL)

  /*
  ** Wait for our startup message from the SpawnSubTask() function.
  */

  WaitPort(me::process.msgport)
  stm:= GetMsg(me::process.msgport)
  st:= stm.stm_Parameter
  st.st_Port:=CreateMsgPort()
  IF (st.st_Port)
    /*
    ** Reply startup message, everything ok.
    ** Note that if the initialization fails, the code falls
    ** through and replies the startup message with a stm_Result
    ** of 0 after a Forbid(). This tells SpawnSubTask() that the
    ** sub task failed to run.
    */
    stm.stm_Result:= TRUE
    ReplyMsg(stm)
    RETURN (st)
  ELSE
    exitsubtask(st,stm)
    RETURN (NIL)
  ENDIF
ENDPROC






-> slot functions

EXPORT PROC fromslot(addr:PTR TO LONG,pos) IS addr[pos]

EXPORT PROC toslot(addr:PTR TO LONG,pos,v) 
      addr[pos]:=v
ENDPROC

EXPORT PROC nextusedslot(addr:PTR TO LONG,pos)
DEF i,lpos

      lpos:=pos
      FOR i:=pos TO 255 DO EXIT addr[i]
      IF addr[i] THEN lpos:=i 

ENDPROC lpos

EXPORT PROC prevusedslot(addr:PTR TO LONG,pos)
DEF i,lpos

      lpos:=pos
      FOR i:=pos TO 0 STEP -1 DO EXIT addr[i]
      IF addr[i] THEN lpos:=i 

ENDPROC lpos
      
/* ------------------------------------------------------------------
            ICC function FOR calling ICs    icc=internal command call
*/

EXPORT PROC callhook(hook,obj,msg) IS CallHookPkt(hook,obj,msg);


EXPORT PROC icc(param:PTR TO LONG,obj=NIL)
      DEF r

      rxm:=FALSE
      r:=CallHookPkt(icihook,obj,param)
ENDPROC r

EXPORT PROC icr(param:PTR TO LONG,obj=NIL)
      DEF r

      rxm:=TRUE
      r:=CallHookPkt(icihook,obj,param)
ENDPROC r


