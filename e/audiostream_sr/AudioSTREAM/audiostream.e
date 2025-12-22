/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     audiostream.e
      Description:    main source
      Contains:   startup,cleanup,project menu,setting menu
                  play options,main control,info window,CG_SYSTEM
      Version:    1.0
 --------------------------------------------------------------------
*/

      OPT OSVERSION = 39
      OPT PREPROCESS,LARGE

      MODULE 'muimaster' , 'libraries/mui','utility'
      MODULE 'utility/tagitem' , 'utility/hooks','amigalib/ports'
      MODULE 'tools/boopsi' , 'tools/installhook','other/ecode'
      MODULE 'exec','exec/interrupts','exec/nodes','hardware/intbits'
      MODULE 'icon','exec/io','exec/ports','devices/ahi','dos/dos'
      MODULE 'exec/memory','libraries/asl','exec/execbase','mpega'

      MODULE '*GUI_DECLARATIONS'
      MODULE '*libs/asguisetup'
      MODULE '*libs/asevents'
      MODULE '*libs/asmisc'
      MODULE '*DECLARATIONS','*customclasses','*tracks','*common'
      MODULE '*songs','*dsp','*samples','*global','*rta'


      OBJECT obj_module OF obj_base
            PRIVATE
            author[32]:ARRAY
            annotation[64]:ARRAY
            infotext:PTR TO CHAR
            infotextlength

            PUBLIC
            sglist:PTR TO obj_sglist
            trlist:PTR TO obj_trlist
            smlist:PTR TO obj_smlist
      ENDOBJECT




->      ***
->    GLOBAL VARIABLES
->      *** 

      DEF arexx : obj_arexx , hooks : obj_hooks
      DEF icihook:hook

      DEF _appl: obj_application
      DEF _appm: obj_appmenu
      DEF _main: objw_maincontrol
      DEF _info: objw_info
      DEF _about: objw_about
      DEF _sels: objw_selectsong
      DEF _mopt: objw_moduleoptions
      DEF _sged: objw_songeditor
      DEF _sgop: objw_songoptions
      DEF _sdsp: objw_songdsp
      DEF _inst: objw_instrument
      DEF _idsp: objw_instrumentdsp
      DEF _smed: objw_sampleeditor
      DEF _smme: obj_sampleedmenu
      DEF _wved: objw_waveeditor
      DEF _wvme: obj_waveedmenu
      DEF _popt: objw_playoptions
      DEF _pcki: objw_pickinstrument
      DEF _pcks: objw_picksample
      DEF _pckw: objw_pickwave
      DEF _pckt: objw_picktrack
      DEF _lofl: objw_loadfromlist
      DEF _lied: objw_listeditor
      DEF _cvol: objw_changevolume
      DEF _cpit: objw_changepitch
      DEF _crch: objw_createchord
      DEF _tran: objw_transpose
      DEF _dspm: objw_dspmanager
      DEF _tred: objw_trackeditor
      DEF _trop: objw_trackoptions
      DEF _sect: objw_sectioneditor
      DEF _tdsp: objw_trackdsp
      DEF _mpeg: objw_mpegdecoder


      -> ----------------------------------------------------------

      -> RETARGETABLE AUDIO GLOBAL VARIABLES
      DEF soundhook:hook
      DEF playertask


      -> GENERAL GLOBAL VARIABLES

      DEF upd=TRUE,lck=FALSE,rxm=FALSE,rxr=0

      -> MISC SPPECIFIC DECLARATIONS, MODULE LOCAL

      
      DEF vbint:PTR TO is, guisetup:obj_guisetup
      DEF osig:PTR TO obj_sigs, cfg:PTR TO obj_cfg
      DEF ahimaxf,ahiminf

      -> DATA STORAGE GLOBAL VARIABLES

      DEF module:PTR TO obj_module
      DEF curtrackp:PTR TO obj_track
      DEF csamplep:PTR TO obj_sample

      -> STORAGE SYSTEMS
      DEF sgl:PTR TO obj_sglist
      DEF trl:PTR TO obj_trlist
      DEF sml:PTR TO obj_smlist

      -> MISC GLOBAL FLAGS
      DEF changed=TRUE,shiftflg=FALSE
           
      DEF mdata:obj_mdata
      DEF loadeddsps=0
      
      DEF sections -> sections present
      DEF cursectp:PTR TO obj_section  
      DEF cursect -> NUMBER of current section

      -> REQUESTERS

      DEF samplereq:PTR TO filerequester



      -> important global variables

      DEF reckey=TRUE
      DEF miscinfo[8]:ARRAY

      DEF mainwindowtitle[80]:STRING
      DEF infotitle[80]:STRING

      DEF ts[40]:STRING   -> temporary string for universal use

      ->   CUSTOM CLASSES

      DEF myeater,chaneditor,dslist,effclass,eatflag,eatflag2,eatflag3
      DEF sampleed
      DEF table:PTR TO CHAR


      -> INTERCOMMUNICATION STUFF
      DEF icp:PTR TO mp

      DEF data:obj_ptdata
      DEF sigmask2
-> ---------------------------------------------------------------

PROC main() HANDLE    -> STARTUP

      DEF running = TRUE , result_domethod , sigs=0,temp
      DEF signum1,signum2,sigbit1=0,mywindow
      DEF icon = NIL,mainsigmask
      DEF i,cfghandle,notify_opened=FALSE,gui_opened=FALSE
      DEF eb:PTR TO execbase,cpubits,icpsb

      -> open debug window
      #ifdef CONDEBUG
            stdout:=OPENDEBUG
            conout:=stdout
      #endif

      CDEBUG(SYSTEM: Starting program...,0)

      mpegabase:=0

      -> cpu test
      eb:=execbase
      cpubits:=eb.attnflags
      CDEBUG(SYSTEM: CPU flags are $\h,cpubits)
      IF (cpubits AND AFF_68020)=0 THEN Raise("CPU")
      CDEBUG(SYSTEM: required 68020+ found,0)
      CDEBUG(---,0)

      -> setup icp
      IF NIL=(icp:=createPort(0, 0)) THEN Raise("ICPE")
      icpsb:=Shl(1,icp.sigbit)
      IF -1=(signum2:=AllocSignal(-1)) THEN Throw("MISC",0)
      sigmask2:=Shl(1,signum2)
      -> needed libraries and icon init
      IF open_rta() = FALSE THEN Throw ("LIB", "ahi")
      CDEBUG(SYSTEM: Retargetable audio OK,0)

      IF (playertask:=run_playertask())=NIL THEN Raise("PTSK")

      IF (utilitybase := OpenLibrary('utility.library', 0)) = NIL THEN Throw("LIB","UTIL")
      CDEBUG(SYSTEM: utility.library OK at \h,utilitybase)
      IF ( muimasterbase := OpenLibrary( 'muimaster.library' , 16 ) ) = NIL THEN Throw( "LIB" , "muim" )
      CDEBUG(SYSTEM: muimaster.library OK at \h ,muimasterbase)
      CDEBUG(---,0)
      -> init custom classes
      CDEBUG(SYSTEM: Init custom classes...,0)
      IF (myeater:=init_eater())=NIL THEN Throw("MUI",0)
      CDEBUG(SYSTEM: myeater class OK at \h,myeater)
      IF (chaneditor:=init_channel())=NIL THEN Throw("MUI",0)
      CDEBUG(SYSTEM: chaneditor class OK at \h,chaneditor)
      IF (effclass:=init_effect())=NIL THEN Throw("MUI",0)
      CDEBUG(SYSTEM: eff class OK at \h,effclass)
      IF (dslist:=init_dslist())=NIL THEN Throw("MUI",0)
      CDEBUG(SYSTEM: dslist class OK at \h,dslist)
      IF (sampleed:=init_sampleed())=NIL THEN Throw("MUI",0)
      CDEBUG(SYSTEM: sampleed class OK at \h,sampleed)
      CDEBUG(---,0)

      -> init disk icon
      IF ( iconbase := OpenLibrary( 'icon.library' , 0 ) ) THEN icon := GetDiskObject( 'PROGDIR:AudioStream' ) ELSE Throw( "LIB" , "icon" )
      CDEBUG(SYSTEM: icon.library OK at \h,iconbase)

      -> open custom libraries
      IF ( asmiscbase := OpenLibrary('PROGDIR:Libs/asmisc.library',1))=NIL THEN Throw ("LIB","strg")
      CDEBUG(SYSTEM: asmisc.library OK at \h,asmiscbase)
      Strginit()  -> init asmisc.library, dummy now
      IF ( asguisetupbase := OpenLibrary( 'PROGDIR:Libs/asguisetup.library', 1)) = NIL THEN Throw ("LIB","agui")
      CDEBUG(SYSTEM: asguisetup.library OK at \h,asguisetupbase)
      IF ( aseventsbase := OpenLibrary ('PROGDIR:Libs/asevents.library',1)) = NIL THEN Throw("LIB","anot")
      CDEBUG(SYSTEM: asevents.library OK at \h,aseventsbase)
      notify_opened:=TRUE
      gui_opened:=TRUE
      CDEBUG(---,0)

      -> ARexx init NOT YET USED
      -> FOR ARexx init you must fill an "app_arexx" OBJECT defined in GUI.em line 17
      -> this OBJECT gets 2 fields : one FOR the commands AND one FOR the arexx error hoo

      installhook( icihook, {icihookentry})
      installhook( arexx.error , {arexx_error} )
      init_callbacks()
      CDEBUG(SYSTEM: Callback hooks installed,0)

      -> install vertical blank interrupt
      NEW osig
      IF -1=(signum1:=AllocSignal(-1)) THEN Throw("MISC",0)
      
      osig.mytask:=FindTask(NIL)
      sigbit1:=Shl(1,signum1)
      osig.signal1:=sigbit1;
      osig.enable1:=FALSE;osig.enable2:=FALSE;osig.counter:=0
      vbint:=NewM(SIZEOF is, MEMF_PUBLIC OR MEMF_CLEAR)
      vbint.ln.type:=NT_INTERRUPT;vbint.ln.pri:=-60
      vbint.ln.name:='AudioSTREAM'; vbint.data:=osig
      vbint.code:=eCodeIntServer({vertBServer})
      AddIntServer(INTB_VERTB, vbint)
      CDEBUG(SYSTEM: VBeam interrupt server installed,0)

      -> gui setup init - required FOR calling custom libraries
      init_guisetup(icon)
   
      -> create MUI GUI
      IF Gui_create( guisetup,hooks ) = NIL THEN Throw( "MUI" , Mui_Error() )
      CDEBUG(SYSTEM: MUI init OK,0)
      Notify_init( guisetup,hooks,icihook)
      CDEBUG(SYSTEM: MUI notifications installed OK,0)

      -> libs are not needed now,closing
      CloseLibrary(aseventsbase)
      notify_opened:=FALSE
      CDEBUG(SYSTEM: asevents.library closed,0)
      ->CloseLibrary(asguisetupbase)
      ->gui_opened:=FALSE
      ->CDEBUG(SYSTEM: asguisetuplibrary closed,0)
      -> !!!!!!  from 981107, asguisetup library CAN'T BE CLOSED

      CDEBUG(---,0)


      logit('Welcome TO \eiAudioSTREAM Professional\en')

      -> load cfg
      -> CDEBUG(SYSTEM: Loading configuration,0)
      
      /*
      IF NIL<>(cfghandle:=Open('PROGDIR:AudioSTREAM.Config',OLDFILE))
            Read(cfghandle,cfg,SIZEOF obj_cfg)
            Close(cfghandle)
            CDEBUG(SYSTEM: cfg file loaded,0)
            logit('Configuration loaded')
      ELSE
            CDEBUG(SYSTEM: cfg file not found,0)
            logit('WARNING: Config file not found')
      ENDIF */

      /*awake()
      examine_audiomode(cfg.ahimodeid,cfg.ahimixfreq)
      set(_popt.sltimeres,MUIA_Slider_Level,cfg.timeresolution)
      IF cfg.mono THEN set(_popt.chmonomode,MUIA_Selected,MUI_TRUE)
      status_idle() */

      -> filerequester initialization
      get(_main.base,MUIA_Window_Window,{mywindow})
      samplereq:=Mui_AllocAslRequest(ASL_FILEREQUEST,[ASLFR_WINDOW,mywindow,
           ASLFR_TITLETEXT,'Select sample',
           ASLFR_INITIALDRAWER,'RAM:',
           ASLFR_INITIALPATTERN,'~(#?.(info|backdrop))',
           ASLFR_DOPATTERNS,TRUE])
      IF samplereq=NIL THEN Throw("NREQ",0)
      CDEBUG(SYSTEM: Sample requester allocated \h,samplereq)

      NEW module.create()
      module.activate()

      icc([CG_SYSTEM,IC_UPDATEINFO])
      changed:=FALSE
      icc([CG_SYSTEM,IC_UPDATEMAINTITLE])

      initsectionstuff()

      ->    ***
      ->    MUI EVENT LOOP
      ->    ***

      CDEBUG(SYSTEM: Setup OK !,0)

      mainsigmask:=(sigbit1 OR icpsb OR sigmask2 OR SIGBREAKF_CTRL_C)
      osig.enable1:=TRUE
superloop:      WHILE (domethod(_appl.app,[MUIM_Application_NewInput,{sigs}]) <> MUIV_Application_ReturnID_Quit)
            IF (sigs) THEN sigs:=Wait(sigs OR mainsigmask )
            IF (sigs AND sigbit1) THEN updategui1()
            IF (sigs AND icpsb) THEN process_icp_msg()
            IF (sigs AND sigmask2)
                  icc([CG_SED,IC_PLAYCURSOR,data.cursor])
                  ENDIF
            EXIT (sigs AND SIGBREAKF_CTRL_C)
      ENDWHILE
      osig.enable1:=FALSE


      ->    ***
      ->    MAIN exception HANDLER
      ->    ***


      EXCEPT DO

      SELECT exception
            CASE "LIB"
                  SELECT exceptioninfo
                        CASE "muim"
                              error_simple( 'Can''t open muimaster.library v16+' )
                        CASE "icon"
                              error_simple( 'Can''t open icon.library' )
                        CASE "UTIL"
                              error_simple( 'Can''t open utility library')
                        CASE "ahi"
                              error_simple( 'Can''t open ahi.device V4+')
                        CASE "agui"
                              error_simple( 'Can''t open asguisetup.library')
                        CASE "anot"
                              error_simple( 'Can''t open asevents.library')
                        CASE "strg"
                              error_simple( 'Can''t open asmisc.library')
                   ENDSELECT

            CASE "MEM"
                  error( 'Fatal: Out OF memory' )
            CASE "NIL"
                  error( 'Fatal: NIL pointer access detected' )

            CASE "MUI"
                  SELECT exceptioninfo
                        CASE MUIE_OutOfMemory
                             error_simple( 'MUI out OF memory' )
                        CASE MUIE_OutOfGfxMemory
                             error_simple( 'MUI out OF gfx memory' )
                        CASE MUIE_MissingLibrary
                             error_simple( 'Can''t open required MUI library' )
                        CASE MUIE_NoARexx
                             error_simple( 'Can''t create Arexx port' )
                        DEFAULT
                             error_simple( 'Unknown MUI problem' )
                 ENDSELECT

            CASE "CPU"
                  error_simple( '68020+ required')
            CASE "NREQ"
                  error_simple( 'Can''t allocate file requesters')
            CASE "PTSK"
                  error_simple( 'Can''t create player subtask')
            CASE "MISC"
                  error_simple( 'Unknown error?! What IS that - PC?')
            CASE "ICPE"
                  error_simple( 'Can''t create message port')
   ENDSELECT

      ->    ***
      ->    CLEANUP
      ->    ***

      CDEBUG(--- Cleaning up,0)

      IF data.playing
            stop_playing()
            CDEBUG(SYSTEM: Player stopped,0)
      ENDIF

      -> requester check
      get(_mpeg.pampeg,MUIA_Popasl_Active,{temp})
      IF temp
            logit('ERROR: Close all ASL requesters first')
            JUMP superloop
      ENDIF


      -> flush the module
      END module

      -> free file requesters
      IF samplereq THEN Mui_FreeAslRequest(samplereq)

      -> flush ALL DSP plugins
      logit('Closing DSP PlugIns...')
      flush_all_dsp_plugins() 
      CDEBUG(SYSTEN: DSP plugins have been flushed,0)

      RemIntServer(INTB_VERTB,vbint)
      CDEBUG(SYSTEM: VBEAM server removed,0)

      IF signum1>-1 THEN FreeSignal(signum1)
      IF signum2>-1 THEN FreeSignal(signum2)
      dispose_myapp()
      IF icon     THEN FreeDiskObject( icon )
      IF iconbase   THEN CloseLibrary( iconbase )

      ->remove custom classes
      IF myeater    THEN Mui_DeleteCustomClass (myeater)
      IF chaneditor  THEN Mui_DeleteCustomClass (chaneditor)
      IF dslist  THEN Mui_DeleteCustomClass (dslist)
      IF sampleed  THEN Mui_DeleteCustomClass (sampleed)
      CDEBUG(SYSTEM: Custom classes removed,0)

      ->close MUI
      IF muimasterbase  THEN CloseLibrary( muimasterbase )
      IF asguisetupbase THEN CloseLibrary (asguisetupbase)
      CDEBUG(SYSTEM: MUI closed,0)

      -> close asmisc.library memory pools
      Strgflush()

      IF asmiscbase THEN CloseLibrary (asmiscbase)
      IF notify_opened THEN CloseLibrary (aseventsbase)
      IF utilitybase THEN CloseLibrary(utilitybase)
      
      IF mpegabase
            icc([CG_SED,ICP_FLUSH])
            CloseLibrary(mpegabase)
      ENDIF
      IF playertask THEN kill_playertask()
      close_rta()

      IF icp THEN deletePort(icp)
      CDEBUG(SYSTEM: Cleanup completed & libraries closed OK,0)
      CDEBUG(---,0)
      CDEBUG(SYSTEM: Program terminated. Press ENTER...,0)

ENDPROC


-> --------------------------------------------------------------

#define ICPC_UNLOCKSAMPLE 1024

PROC process_icp_msg()
      DEF incoming:PTR TO icpmsg
      DEF a

      WHILE (incoming:=GetMsg(icp))
            CDEBUG(SYSTEM: ICP message received - command $\h,incoming.command)
            a:=incoming.command
            SELECT a
                  CASE ICPC_UNLOCKSAMPLE
                        icc([CG_SED,IC_PLAYCURSOR,-1])
                        icc([CG_SED,IC_UNLOCK])
                        

            ENDSELECT
            ReplyMsg(incoming)
      ENDWHILE

ENDPROC




PROC init_guisetup(icon)
      guisetup.mmbase:=muimasterbase
      guisetup.intbase:=intuitionbase
      guisetup.icon:=icon
      guisetup.class:=myeater
      guisetup.editor:=chaneditor
      guisetup.effclass:=effclass
      guisetup.dslist:=dslist
      guisetup.sampleed:=sampleed
      guisetup.strgbase:=asmiscbase

      guisetup._appl:=_appl
      guisetup._appm:=_appm
      guisetup._main:=_main
      guisetup._info:=_info
      guisetup._about:=_about
      guisetup._sels:=_sels
      guisetup._mopt:=_mopt
      guisetup._sged:=_sged
      guisetup._sgop:=_sgop
      guisetup._sdsp:=_sdsp
      guisetup._inst:=_inst
      guisetup._idsp:=_idsp
      guisetup._smed:=_smed
      guisetup._smme:=_smme
      guisetup._wved:=_wved
      guisetup._wvme:=_wvme
      guisetup._popt:=_popt
      guisetup._pcki:=_pcki
      guisetup._pcks:=_pcks
      guisetup._pckw:=_pckw
      guisetup._pckt:=_pckt
      guisetup._lofl:=_lofl
      guisetup._lied:=_lied
      guisetup._cvol:=_cvol
      guisetup._cpit:=_cpit
      guisetup._crch:=_crch
      guisetup._tran:=_tran
      guisetup._dspm:=_dspm
      guisetup._tred:=_tred
      guisetup._trop:=_trop
      guisetup._sect:=_sect
      guisetup._tdsp:=_tdsp
      guisetup._mpeg:=_mpeg
ENDPROC



->/////////////////////////////////////////////////////////////////////////////
->//////////////////////// Hook function called by ARexx in case of error /////
->/////////////////////////////////////////////////////////////////////////////
PROC arexx_error( hook , obj , msg ) IS error_simple( 'Unknown ARexx command recieved' )



PROC dispose_myapp()

   IF _appl.app THEN Mui_DisposeObject( _appl.app )

ENDPROC


PROC status_change(status:PTR TO CHAR)

   set (_info.txstatus , MUIA_Text_Contents , status)

ENDPROC


PROC status_idle()

   set (_info.txstatus, MUIA_Text_Contents, '- Idle -')

ENDPROC


/*PROC examine_audiomode(aid,freq)

DEF minmixfreq,maxmixfreq,thisid,actual,stereo
DEF modename[64]:STRING

AhI_GetAudioAttrsA(aid,NIL,
        [AHIDB_MINMIXFREQ,{minmixfreq},
        AHIDB_MAXMIXFREQ,{maxmixfreq},
        AHIDB_STEREO,{stereo},
        AHIDB_BUFFERLEN,64,
        AHIDB_NAME,modename,
        AHIDB_AUDIOID,{thisid},
            TAG_DONE])
   IF freq=0 THEN freq:=maxmixfreq
   actual:=scan_afreq(freq)
   IF stereo=0
     cfg.mono:=TRUE
     set (_popt.chmonomode,MUIA_Selected,MUI_TRUE)
     set (_popt.chmonomode,MUIA_Disabled,MUI_TRUE)
   ELSE
     set (_popt.chmonomode,MUIA_Disabled,FALSE)
        ENDIF
   ahimaxf:=maxmixfreq
   ahiminf:=minmixfreq
   set (_popt.slmixfreq,MUIA_Slider_Min,minmixfreq)
   set (_popt.slmixfreq,MUIA_Slider_Max,maxmixfreq)
   set (_popt.slmixfreq,MUIA_Slider_Level,freq)
   set (_popt.txaudiomode,MUIA_Text_Contents,modename)
   domethod(_popt.txactual,[MUIM_SetAsString,MUIA_Text_Contents,
     '%ld',actual])
   cfg.ahimodeid:=thisid
   cfg.ahimixfreq:=actual

ENDPROC*/





/*PROC scan_afreq(freq)

DEF actualindex,actualfreq

      AhI_GetAudioAttrsA(cfg.ahimodeid,NIL,[AHIDB_INDEXARG,freq,AHIDB_INDEX,{actualindex},
               TAG_DONE])
      AhI_GetAudioAttrsA (cfg.ahimodeid,NIL,[AHIDB_FREQUENCYARG,actualindex,
             AHIDB_FREQUENCY,{actualfreq},TAG_DONE])

ENDPROC actualfreq*/


->  VERTICAL BLANK INTERRUPT

PROC vertBServer(data:PTR TO obj_sigs)

   data.counter:=data.counter+1
   IF (data.counter>50) AND (data.enable1)
       data.counter:=0
       Signal(data.mytask,data.signal1)
   ENDIF

ENDPROC


PROC updategui1()
DEF tmp[50]:STRING
      StringF(tmp,'\d \eiChip\en \d \eiFast\en',
            AvailMem(MEMF_CHIP),AvailMem(MEMF_FAST))
      set(_info.txmemory,MUIA_Text_Contents,tmp)

ENDPROC


      
            /* ---------------------
               CALLBACK PROCEDURES
               ---------------------   */ 


/* ----------------------- PLAY OPTIONS window */

/*



            O     B     S     O     L     E     T     E     !




PROC pf_po_slider(hook,obj,msg)

   cfg.ahimixfreq:=scan_afreq(^msg)
   domethod(_popt.txactual,[MUIM_SetAsString,MUIA_Text_Contents,
     '%ld',cfg.ahimixfreq])

ENDPROC



PROC pf_po_pick(hook,obj,msg)

      DEF req:PTR TO ahiaudiomoderequester,mywindow

      get (_popt.base,MUIA_Window_Window,{mywindow})
         req:=NIL
         req:=AhI_AllocAudioRequestA([AHIR_WINDOW,mywindow,
            AHIR_TITLETEXT,'Select Audio Mode',
             TAG_DONE])
        IF req=NIL THEN RETURN
         sleep()
         IF AhI_AudioRequestA(req,[TAG_DONE])
                cfg.ahimodeid:=req.audioid
            examine_audiomode(cfg.ahimodeid,0)
         ENDIF
         awake()
         AhI_FreeAudioRequest(req)

ENDPROC


PROC pf_po_timeres(hook,obj,msg)

      cfg.timeresolution:=^msg

ENDPROC

PROC pf_po_monoon(hook,obj,msg)

      cfg.mono:=TRUE

ENDPROC

PROC pf_po_monooff(hook,obj,msg)

      cfg.mono:=FALSE

ENDPROC

PROC pf_po_enter(hook,obj,msg)

      DEF mixf

   mixf:=Val(^msg,ALL)
   IF mixf>ahimaxf THEN mixf:=ahimaxf
   IF mixf<ahiminf THEN mixf:=ahiminf
   set(_popt.slmixfreq,MUIA_Slider_Level,mixf)
   cfg.ahimixfreq:=scan_afreq(mixf)
   domethod(_popt.txactual,[MUIM_SetAsString,MUIA_Text_Contents,
     '%ld',cfg.ahimixfreq])

ENDPROC

PROC pf_po_presets(hook,obj,msg)
      DEF mixf
      DEF presets[6]:LIST

      ListCopy(presets,[15000,22050,24000,28400,44100,48000],ALL)

   mixf:=presets[^msg]
   IF mixf>ahimaxf THEN mixf:=ahimaxf
   IF mixf<ahiminf THEN mixf:=ahiminf
   set(_popt.slmixfreq,MUIA_Slider_Level,mixf)
   cfg.ahimixfreq:=scan_afreq(mixf)
   domethod(_popt.txactual,[MUIM_SetAsString,MUIA_Text_Contents,
     '%ld',cfg.ahimixfreq])

ENDPROC
*/


-> ---------------------   MENU STUFF



PROC pfm_saveasdefault(hook,obj,msg)
DEF cfghandle

sleep()
logit('Saving configuration...')
IF cfghandle:=Open('PROGDIR:AudioSTREAM.Config',NEWFILE)
   Write(cfghandle,cfg,SIZEOF obj_cfg )
   Close(cfghandle)
   ENDIF
awake()
status_idle()
ENDPROC



PROC pfm_quit(hook,obj,msg)
IF changed
   IF confirm('Current project has been changed. Quit anyway ?') THEN
     domethod(_appl.app,[MUIM_Application_ReturnID,
       MUIV_Application_ReturnID_Quit])
   ELSE
   domethod(_appl.app,[MUIM_Application_ReturnID,
       MUIV_Application_ReturnID_Quit])
    ENDIF
ENDPROC


-> ------------------------------ MODULE SECTION

-> constructor

PROC create() OF obj_module
      SUPER self.create()
      AstrCopy(self.author,'Anonymous',32)
      AstrCopy(self.annotation,'AudioSTREAM rulez!',64)
      NEW sgl.create(16,NIL,NIL)
      self.sglist:=sgl
      NEW trl.create(256,NIL)
      self.trlist:=trl
      NEW sml.create(256,NIL)
      self.smlist:=sml
ENDPROC

-> destructor
PROC end() OF obj_module
      SUPER self.end()
      IF self.infotext THEN END self.infotext[self.infotextlength]
      END sgl
      self.sglist:=NIL
      END trl
      self.trlist:=NIL
      END sml
      self.smlist:=NIL
ENDPROC

-> methods


PROC setname(x:PTR TO CHAR) OF obj_module

       SUPER self.setname(x)
       IF upd THEN nset(_mopt.stname,MUIA_String_Contents,self.getname())
ENDPROC


PROC setauthor(x:PTR TO CHAR) OF obj_module

       AstrCopy(self.author,x,32)
       IF upd THEN nset(_mopt.stauthor,MUIA_String_Contents,self.author)
ENDPROC

PROC setannotation(x:PTR TO CHAR) OF obj_module

       AstrCopy(self.annotation,x,64)
       IF upd THEN nset(_mopt.stannotation,MUIA_String_Contents,self.annotation)
ENDPROC


PROC activate() OF obj_module

       SUPER self.activate()
       IF upd
             nset(_mopt.stname,MUIA_String_Contents,self.getname())
             nset(_mopt.stauthor,MUIA_String_Contents,self.author)
             nset(_mopt.stannotation,MUIA_String_Contents,self.annotation)
             icc([CG_SYSTEM,IC_UPDATEMAINTITLE])
       ENDIF

ENDPROC



PROC matrixor(hook,obj,msg)

logit('Starting MatriXOR...')
error('\ec\eb\e8MatriXor v1.1\en\e0\n\n\ecHeavy matrix has not \n\ecxored your FAT correctly.\n' + 
      '\n\ec\eiFor more detailed informations ask \n\ec\e8xmichal1@br.fjfi.cvut.cz')
ENDPROC



-> ===============================================================



PROC s_keyboard(hook,obj,msg) -> special keyboard event handler
DEF p:PTR TO LONG
DEF c,q,temp

rxm:=FALSE

p:=msg
c:=p[]
q:=p[1]   -> code,qualifier
q:=q AND $00000dff

domethod(_info.txstatus,[MUIM_SetAsString,MUIA_Text_Contents,
   '%lx/%lx',p[],p[1]])

IF q=$10  -> LEFT ALT - F1-F8 = SELECT current command layer
   IF (c>$49) AND (c<$58) THEN icc([CG_TED,IC_SETTPARAM,TRCURCL,c-$50])

ENDIF

      shiftflg:=q AND 1


IF q=$00000100
      SELECT c

      CASE $2d    -> prev track slot
      icc([CG_TED,IC_GOPREV])
      eatflag:=1
      CASE $2e    -> next track slot
      icc([CG_TED,IC_GONEXT])
      eatflag:=1
      CASE $1d    -> prev section
      domethod(_sect.imleft,[MUIM_CallHook,hooks.sect_pressbutton])
      eatflag:=1
      CASE $1e    -> next section
      domethod(_sect.imright,[MUIM_CallHook,hooks.sect_pressbutton])
      eatflag:=1

      ENDSELECT  

ENDIF




IF (q=0)

   SELECT c
     CASE $50
     set(_tred.cyoct,MUIA_Cycle_Active,0)
     eatflag:=1
     CASE $51
     set(_tred.cyoct,MUIA_Cycle_Active,1)
     eatflag:=1
     CASE $52
     set(_tred.cyoct,MUIA_Cycle_Active,2)
     eatflag:=1
     CASE $53
     set(_tred.cyoct,MUIA_Cycle_Active,3)
     eatflag:=1
     CASE $54
     set(_tred.cyoct,MUIA_Cycle_Active,4)
     eatflag:=1



     CASE $40;     icc([CG_SYSTEM,IC_STOP])  -> SPACE
   ENDSELECT

   -> EAT FILTER
SELECT c
      CASE $41  -> backspace
      eatflag:=1
      /* CASE $44  -> enter
      eatflag:=1 */
      CASE $46  -> del
      eatflag:=1
ENDSELECT         



   IF (c>$54) AND (c<$5a) THEN eatflag:=1  -> eat F6-F10 (temporarily)
   IF c<64
     temp:=table[c*2]
     IF temp<>255 THEN eatflag:=1    -> eat notes
   ENDIF
ENDIF

ENDPROC





-> ===============================================================


->   INSTALL ALL HOOKS FOR NOTIFICATIONS






PROC init_callbacks()



/* display hooks */

installhook(hooks.sdsp_disphook,{sdsp_disphook})
installhook(hooks.tdsp_disphook,{tdsp_disphook})

/* other */


installhook(hooks.fm_saveasdefault,{pfm_saveasdefault})


->installhook(hooks.fm_delallsongs,{pfm_delallsongs})
installhook(hooks.fm_quit,{pfm_quit})

installhook(hooks.fm_smakeclone,{pfm_smakeclone})

installhook(hooks.f_dm_load,{pf_dm_load})
installhook(hooks.f_dm_flush,{pf_dm_flush})
installhook(hooks.f_dm_flushall,{pf_dm_flushall})
installhook(hooks.f_dm_active,{f_dspm_active})

/*
installhook(hooks.f_dspe_add,{pf_dspe_add})
installhook(hooks.f_dspe_insert,{pf_dspe_insert})
installhook(hooks.f_dspe_delete,{pf_dspe_delete})
installhook(hooks.f_dspe_delall,{pf_dspe_delall})

installhook(hooks.sdsp_action,{sdsp_action})
installhook(hooks.sdsp_lactive,{sdsp_lactive})
installhook(hooks.sdsp_dragdrop,{sdsp_dragdrop})

installhook(hooks.tdsp_action,{tdsp_action})
installhook(hooks.tdsp_lactive,{tdsp_lactive})
installhook(hooks.tdsp_dragdrop,{tdsp_dragdrop})
*/


-> keyboard special hook
installhook(hooks.s_keyboard,{s_keyboard})
installhook(hooks.ted_editorevent,{ted_keyboard})

-> matrixor hook
installhook(hooks.fm_matrixor,{matrixor})


installhook(hooks.sect_pressbutton,{f_sect_pressbutton})
installhook(hooks.sect_listactive,{f_sect_listactive})
->installhook(hooks.sect_doubleclick,{f_sect_doubleclick})
installhook(hooks.sect_dragdrop,{f_sect_dragdrop})

installhook(hooks.sged_listactive,{f_sged_listactive})
installhook(hooks.sged_pressbutton,{f_sged_pressbutton})
installhook(hooks.sged_dragdrop,{f_sged_dragdrop})


ENDPROC

/* ----------------------------------------------------------
             this IS the magic PROC called as a hook
   ---------------------------------------------------------- */

PROC icihookentry(hook,obj,param:PTR TO LONG) HANDLE
      DEF sg,ic

      sg:=param[0]
      ic:=param[1]
      rxr:=ERR_OK

      SELECT sg
            CASE CG_SYSTEM
                  icisystem(obj,ic,param+8)
            CASE CG_SONG
                  icisong(obj,ic,param+8)
            CASE CG_TED
                  icited(obj,ic,param+8)
            CASE CG_SED
                  icised(obj,ic,param+8)
      ENDSELECT

      rxm:=FALSE
EXCEPT
      SELECT exception
            CASE "MEM"
                  errnomem()
            ENDSELECT
     rxm:=FALSE

ENDPROC rxr

->-------------------------------------

PROC icisystem(obj,ic,param:PTR TO LONG)
      DEF sgl:PTR TO obj_sglist,csp:PTR TO obj_song

      sgl:=module.sglist
      csp:=sgl.geta()
      SELECT ic

            CASE IC_UPDATEINFO
                  StrCopy(infotitle,'Info Window | ',ALL)
                  IF csp
                        StringF(ts,'Tempo: \d',csp.getparam(SGTEMPO))
                        StrAdd(infotitle,ts,ALL)
                  ENDIF
                  set(_info.base,MUIA_Window_Title,infotitle)

            CASE IC_UPDATEMAINTITLE
                  StrCopy(mainwindowtitle,'Main Control | ',ALL)
                  StrAdd(mainwindowtitle,module.getname(),ALL)
                  IF changed THEN StrAdd(mainwindowtitle,'  (CHANGED!)',ALL)
                  set(_main.base,MUIA_Window_Title,mainwindowtitle)

            CASE IC_STOP
                  stop_playing()
            CASE IC_WAITPLMSG
                  Wait(Shl(1,icp.sigbit))
                  process_icp_msg()
            CASE IC_FLUSHMEM
                  AllocMem(-1,0)
                  logit('Unused libs & devs flushed.')

            CASE IC_SLEEP
                  set (_appl.app,MUIA_Application_Sleep,MUI_TRUE)

            CASE IC_AWAKE
                  set (_appl.app,MUIA_Application_Sleep,FALSE)
            CASE IC_SETMNAME
                  module.setname(^param)
                  CHANGED
            CASE IC_SETMAUTHOR
                  module.setauthor(^param)
                  CHANGED
            CASE IC_SETMANNOT
                  module.setannotation(^param)
                  CHANGED
      ENDSELECT

ENDPROC


progver:
   CHAR  '$VER: AudioStream 0.0 (981112)\n',0
