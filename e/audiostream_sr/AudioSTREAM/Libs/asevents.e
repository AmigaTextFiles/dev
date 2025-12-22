
/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     asevents.e
      Description:    asevents.library source
      Contains:   notifications definitions
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT PREPROCESS,LARGE

LIBRARY 'asevents.library',1,1,'asevents.library v1.1 (1.2.3345)' IS notify_init

MODULE 'muimaster','libraries/mui','*adst:gui_declarations' 
MODULE 'tools/boopsi','*adst:global'


      DEF ih

      DEF _appl:PTR TO obj_application
      DEF _appm:PTR TO obj_appmenu
      DEF _main:PTR TO objw_maincontrol
      DEF _info:PTR TO objw_info
      DEF _about:PTR TO objw_about
      DEF _sels:PTR TO objw_selectsong
      DEF _mopt:PTR TO objw_moduleoptions
      DEF _sged:PTR TO objw_songeditor
      DEF _sgop:PTR TO objw_songoptions
      DEF _sdsp:PTR TO objw_songdsp
      DEF _inst:PTR TO objw_instrument
      DEF _idsp:PTR TO objw_instrumentdsp
      DEF _smed:PTR TO objw_sampleeditor
      DEF _smme:PTR TO obj_sampleedmenu
      DEF _wved:PTR TO objw_waveeditor
      DEF _wvme:PTR TO obj_waveedmenu
      DEF _popt:PTR TO objw_playoptions
      DEF _pcki:PTR TO objw_pickinstrument
      DEF _pcks:PTR TO objw_picksample
      DEF _pckw:PTR TO objw_pickwave
      DEF _pckt:PTR TO objw_picktrack
      DEF _lofl:PTR TO objw_loadfromlist
      DEF _lied:PTR TO objw_listeditor
      DEF _cvol:PTR TO objw_changevolume
      DEF _cpit:PTR TO objw_changepitch
      DEF _crch:PTR TO objw_createchord
      DEF _tran:PTR TO objw_transpose
      DEF _dspm:PTR TO objw_dspmanager
      DEF _tred:PTR TO objw_trackeditor
      DEF _trop:PTR TO objw_trackoptions
      DEF _sect:PTR TO objw_sectioneditor
      DEF _tdsp:PTR TO objw_trackdsp
      DEF _mpeg:PTR TO objw_mpegdecoder

/* special PROC FOR instaling ici callhook */


PROC install(obj,trigattr,trig,cg,ic,params=0,param1=0,param2=0,param3=0)

domethod (obj,[MUIM_Notify,trigattr,trig,MUIV_Notify_Self,params+4,
      MUIM_CallHook,ih,cg,ic,param1,param2,param3])

ENDPROC


PROC crequest(window)
      domethod( window , [
            MUIM_Notify , MUIA_Window_CloseRequest , MUI_TRUE ,
            window ,
            3 ,
            MUIM_Set , MUIA_Window_Open , FALSE ] )
ENDPROC


PROC old_init(x:PTR TO obj_guisetup,hooks:PTR TO obj_hooks)

domethod( _appm.dspmanager , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _dspm.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )
      
      crequest(_dspm.base)
            

      domethod( _appm.tedit , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _tred.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      domethod(_tred.base ,[MUIM_Window_SetCycleChain,
            _tred.lv0,_tred.st0,_tred.lv1,_tred.st1,
            _tred.lv2,_tred.st2,_tred.lv3,_tred.st3,0])
            

      crequest(_tred.base)
      crequest(_trop.base)
      crequest(_sect.base)
      crequest(_mpeg.base)

      domethod( _appm.aboutmui , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,
            2 ,
            MUIM_Application_AboutMUI , NIL ] )


      domethod( _appm.aboutaudiostream , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _about.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.sleep , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,
            3 ,
            MUIM_Set , MUIA_Application_Iconified , MUI_TRUE ] )

      domethod( _appm.quit , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,
            2 ,
            MUIM_CallHook , hooks.fm_quit ] )

      domethod( _appm.infowindow , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _info.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.moduleoptions , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _mopt.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.sampleeditor , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _smed.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.waveeditor , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _wved.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.listeditor , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lied.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.select , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _sels.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.sedit , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _sged.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.soptions , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _sgop.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      domethod( _appm.sdsp , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _sdsp.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.tpick , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _pckt.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.toptions , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _trop.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.tdsp , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _tdsp.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.pick , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _pcki.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.cytype ,
            3 ,
            MUIM_Set , MUIA_Cycle_Active , 0 ] )

      domethod( _appm.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.cytype ,
            3 ,
            MUIM_Set , MUIA_Disabled , FALSE ] )

      domethod( _appm.iproperties , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _inst.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.idsp , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _idsp.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.playoptions , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _popt.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _appm.muisettings , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,
            2 ,
            MUIM_Application_OpenConfigWindow , 0 ] )


      /* end of menu notifications #1 */



      domethod( _main.base , [
            MUIM_Notify , MUIA_Window_CloseRequest , MUI_TRUE ,
            _main.base ,
            2 ,MUIM_CallHook , hooks.fm_quit ] )

/*    domethod( _main.btplay , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _main.btplay ,
            2 ,
            MUIM_CallHook , hooks.f_playsong ] )

      domethod( _main.btstop , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _main.btstop ,
            2 ,
            MUIM_CallHook , hooks.f_stop ] )

      domethod( _main.btcontinue , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _main.btcontinue ,
            2 ,
            MUIM_CallHook , hooks.f_continue ] )    

                  !UNUSED!

*/

      domethod( _main.btselect , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _sels.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _main.btplayoptions , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _popt.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _main.btsongeditor , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _sged.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _main.btsampleeditor , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _smed.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _main.bttrackeditor , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _tred.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _main.btsectioneditor , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _sect.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _main.btinstrprop , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _inst.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      crequest(_info.base)

      domethod( _about.btresume , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _about.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , FALSE ] )


      crequest(_sels.base)

      domethod( _sels.btedit , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _sged.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _sels.btoptions , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _sgop.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      crequest(_mopt.base)
 
      crequest(_sged.base)

      crequest(_sgop.base)

      domethod( _sgop.stname , [
            MUIM_Notify , MUIA_String_Acknowledge , MUIV_EveryTime ,
            _info.txcursong ,
            3 ,
            MUIM_Set , MUIA_Text_Contents , MUIV_TriggerValue ] )


      domethod( _sgop.btedit , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _sdsp.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      crequest(_sdsp.base)

      crequest(_inst.base)

      domethod( _inst.btpick , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _pcki.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      domethod(_inst. btdspedit , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _idsp.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      crequest(_idsp.base)


      domethod( _smme.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _smme.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.cytype ,
            3 ,
            MUIM_Set , MUIA_Cycle_Active , 1 ] )

      domethod( _smme.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.cytype ,
            3 ,
            MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

      domethod( _smme.quit , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _smed.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , FALSE ] )

      domethod( _smme.changevolume , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _cvol.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _smme.changepitch , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _cpit.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _smme.mpegdecoder , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _mpeg.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _smme.makechord , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _crch.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      crequest(_smed.base)

      domethod( _smed.btpick , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _pcks.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      domethod( _wvme.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )

      domethod( _wvme.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.cytype ,
            3 ,
            MUIM_Set , MUIA_Cycle_Active , 2 ] )

      domethod( _wvme.loadfromlist , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _lofl.cytype ,
            3 ,
            MUIM_Set , MUIA_Disabled , MUI_TRUE ] )

      domethod( _wvme.quit , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _wved.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , FALSE ] )

      crequest(_wved.base)

      domethod( _wved.btpick , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _pckw.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open , MUI_TRUE ] )


      crequest(_popt.base)

      crequest(_pcki.base)
      
      crequest(_pcks.base)
      
      crequest(_pckw.base)

      crequest(_pckt.base)

      crequest(_lofl.base)

      crequest(_lied.base)

      crequest(_cvol.base)
      
      crequest(_cpit.base)

      crequest(_crch.base)
      
      crequest(_tran.base)

ENDPROC


->/////////////////////////////////////////////////////////////////////////////
->/////////////////////////////////////////////// PROC init_notifications /////
->/////////////////////////////////////////////////////////////////////////////
PROC notify_init( x:PTR TO obj_guisetup , hooks : PTR TO obj_hooks,icihook )

      ih:=icihook
      muimasterbase:=x.mmbase
      _appl:=x._appl
      _appm:=x._appm
      _main:=x._main
      _info:=x._info
      _about:=x._about
      _sels:=x._sels
      _mopt:=x._mopt
      _sged:=x._sged
      _sgop:=x._sgop
      _sdsp:=x._sdsp
      _inst:=x._inst
      _idsp:=x._idsp
      _smed:=x._smed
      _smme:=x._smme
      _wved:=x._wved
      _wvme:=x._wvme
      _popt:=x._popt
      _pcki:=x._pcki
      _pcks:=x._pcks
      _pckw:=x._pckw
      _pckt:=x._pckt
      _lofl:=x._lofl
      _lied:=x._lied
      _cvol:=x._cvol
      _cpit:=x._cpit
      _crch:=x._crch
      _tran:=x._tran
      _dspm:=x._dspm
      _tred:=x._tred
      _trop:=x._trop
      _sect:=x._sect
      _tdsp:=x._tdsp
      _mpeg:=x._mpeg

      old_init(x,hooks)

      
-> #################################################################
-> =================================================
-> SPECIAL NOTIFICATIONS
-> =================================================


-> PLAY OPTS  -------------------------------------------

/*domethod( _popt.slmixfreq , [
            MUIM_Notify , MUIA_Slider_Level , MUIV_EveryTime ,
            _popt.slmixfreq ,
            3 ,
            MUIM_CallHook , hooks.f_po_slider,MUIV_TriggerValue ])
domethod( _popt.btpick, [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _popt.btpick ,
            2 ,
            MUIM_CallHook , hooks.f_po_pick ] )
domethod (_popt.sltimeres,[
            MUIM_Notify , MUIA_Slider_Level,MUIV_EveryTime,
            _popt.sltimeres,3,
            MUIM_CallHook, hooks.f_po_timeres,MUIV_TriggerValue])
domethod (_popt.chmonomode,[
            MUIM_Notify , MUIA_Selected,MUI_TRUE,
            _popt.chmonomode,2,
            MUIM_CallHook, hooks.f_po_monoon])
domethod (_popt.chmonomode,[
            MUIM_Notify , MUIA_Selected,FALSE,
            _popt.chmonomode,2,
            MUIM_CallHook, hooks.f_po_monooff])
domethod (_popt.stmixfreq,[
            MUIM_Notify , MUIA_String_Acknowledge,MUIV_EveryTime,
            _popt.stmixfreq,3,
            MUIM_CallHook, hooks.f_po_enter,MUIV_TriggerValue])
domethod (_popt.cypresets,[
            MUIM_Notify , MUIA_Cycle_Active,MUIV_EveryTime,
            _popt.cypresets,3,
            MUIM_CallHook, hooks.f_po_presets,MUIV_TriggerValue])
*/

-> MODULE OPTIONS ------------------------------------------------

install(_mopt.stname,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SYSTEM,IC_SETMNAME,1,MUIV_TriggerValue)

install (_mopt.stauthor, MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SYSTEM,IC_SETMAUTHOR,1,MUIV_TriggerValue)

install (_mopt.stannotation,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SYSTEM,IC_SETMANNOT,1,MUIV_TriggerValue)



-> special MATRIXOR

domethod( _appm.matrixor , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,
            2 ,
            MUIM_CallHook , hooks.fm_matrixor ] )



-> saveprefs

domethod( _appm.saveasdefault , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,
            2 ,
            MUIM_CallHook , hooks.fm_saveasdefault ] )

 
-> add song,menus

install( _appm.addnew, MUIA_Menuitem_Trigger, MUIV_EveryTime,
      CG_SONG,IC_NEWSG)
install( _appm.deletecurrent, MUIA_Menuitem_Trigger, MUIV_EveryTime,
      CG_SONG,IC_DELSG)
domethod( _appm.smakeclone , [
            MUIM_Notify , MUIA_Menuitem_Trigger , MUIV_EveryTime ,
            _appl.app ,2 ,    MUIM_CallHook , hooks.fm_smakeclone ] )

install(_appm.tnewhere,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_NEWT)
install(_appm.tdelcurrent,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_DELT)
install(_appm.tcopy,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_COPYT)
install(_appm.tpaste,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_PASTET)
install(_appm.tcut ,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_CUTT)



-> edit

install(_appm.copyrange,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MCOPYRANGE)
install( _appm.copyrange2,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MCOPYRANGEAL)
install(_appm.cutrange,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MCUTRANGE)
install(_appm.cutrange2,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MCUTRANGEAL)
install(_appm.pasterange,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MPASTERANGE)
install(_appm.clearrange,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MCLEARRANGE)
install(_appm.transposerange,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_OPNTRNRNGWIN)
install(_appm.selectchannel,MUIA_Menuitem_Trigger , MUIV_EveryTime ,
      CG_TED,IC_MSELCHANNEL)

-> SONG OPTIONS

install(_sgop.stname,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SONG,IC_SETSNAME,1,MUIV_TriggerValue)
install(_sgop.stannotation,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SONG,IC_SPARAM,2,SGANNOT,MUIV_TriggerValue)
install(_sgop.sltempo,MUIA_Slider_Level,MUIV_EveryTime,
      CG_SONG,IC_SPARAM,2,SGTEMPO,MUIV_TriggerValue)
install(_sgop.sltranspose,MUIA_Slider_Level,MUIV_EveryTime,
      CG_SONG,IC_SPARAM,2,SGTRNSPS,MUIV_TriggerValue)
install(_sgop.slleft,MUIA_Slider_Level,MUIV_EveryTime,
      CG_SONG,IC_SPARAM,2,SGLEFTVOL,MUIV_TriggerValue)
install(_sgop.slright,MUIA_Slider_Level,MUIV_EveryTime,
      CG_SONG,IC_SPARAM,2,SGRIGHTVOL,MUIV_TriggerValue)
install(_sgop.chusedsp,MUIA_Selected,MUIV_EveryTime,
      CG_SONG,IC_SPARAM,2,SGDSPFLG,MUIV_TriggerValue)

-> ---------------  MAIN CONTROL

domethod( _main.txinstr , [
            MUIM_Notify , MUIA_Pressed , FALSE ,
            _pcki.base ,
            3 ,
            MUIM_Set , MUIA_Window_Open, MUI_TRUE ] )
install(_main.btstop,MUIA_Pressed,FALSE,CG_SYSTEM,IC_STOP)


-> ---------------- INFO WINDOW
install(_info.imsongleft, MUIA_Pressed, FALSE, CG_SONG, IC_PREVSG)
install(_info.imsongright,MUIA_Pressed, FALSE, CG_SONG, IC_NEXTSG)
install( _info.txmemory ,MUIA_Pressed,FALSE,CG_SYSTEM,IC_FLUSHMEM)

domethod( _info.txcursong , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _sels.base ,3 ,  MUIM_Set , MUIA_Window_Open, MUI_TRUE ] )
domethod( _info.lv,[MUIM_Notify, MUIA_Listview_DoubleClick, MUI_TRUE,
            _info.lv,1,MUIM_List_Clear])


-> ------------------ SELECT SONG
install(_sels.btnew, MUIA_Pressed, FALSE, CG_SONG, IC_NEWSG)
install(_sels.btdelete, MUIA_Pressed, FALSE, CG_SONG,IC_DELSG)
install(_sels.btdeleteall, MUIA_Pressed, FALSE, CG_SONG,IC_DELALLSG)
install(_sels.lvsongs,MUIA_List_Active, MUIV_EveryTime,
      CG_SONG,IC_SETACTIVE,1,MUIV_TriggerValue)

->-------------------- DSP MANAGER
domethod( _dspm.btload , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _dspm.btload ,2 ,
            MUIM_CallHook , hooks.f_dm_load ] )
domethod( _dspm.btflush , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _dspm.btflush ,2 ,
            MUIM_CallHook , hooks.f_dm_flush ] )
domethod( _dspm.btflushall , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _dspm.btflushall ,2 ,
            MUIM_CallHook , hooks.f_dm_flushall ] )
domethod( _dspm.lvdsps,[MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
      _dspm.lvdsps,3,MUIM_CallHook, hooks.f_dm_active,MUIV_TriggerValue])


->------------------- DSP EDITOR
/*domethod( _sdsp.btadd , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _sdsp.btadd ,2 ,
            MUIM_CallHook , hooks.f_dspe_add ] )
domethod( _sdsp.btinsert , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _sdsp.btinsert ,2 ,
            MUIM_CallHook , hooks.f_dspe_insert ] )
domethod( _sdsp.btdelete , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _sdsp.btdelete ,2 ,
            MUIM_CallHook , hooks.f_dspe_delete ] )
domethod( _sdsp.btdeleteall , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _sdsp.btdeleteall ,2 ,
            MUIM_CallHook , hooks.f_dspe_delall ] )

domethod( _sdsp.cyccassign , [MUIM_Notify ,MUIA_Cycle_Active,MUIV_EveryTime,
            _sdsp.cyccassign ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.lvdspsequence, [MUIM_Notify , MUIA_List_Active, MUIV_EveryTime,
            _sdsp.lvdspsequence,3 ,
            MUIM_CallHook , hooks.sdsp_lactive, MUIV_TriggerValue]) 
domethod( _sdsp.lvparams, [MUIM_Notify , MUIA_List_Active, MUIV_EveryTime,
            _sdsp.lvparams,3 ,
            MUIM_CallHook , hooks.sdsp_lactive, MUIV_TriggerValue]) 

domethod( _sdsp.cylfotype , [MUIM_Notify ,MUIA_Cycle_Active,MUIV_EveryTime,
            _sdsp.cylfotype ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.sloffset , [MUIM_Notify ,MUIA_Numeric_Value,MUIV_EveryTime,
            _sdsp.sloffset ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.slcoef , [MUIM_Notify ,MUIA_Numeric_Value,MUIV_EveryTime,
            _sdsp.slcoef ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.sllfoper , [MUIM_Notify ,MUIA_Numeric_Value,MUIV_EveryTime,
            _sdsp.sllfoper ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.stoffset , [MUIM_Notify ,MUIA_String_Acknowledge,MUIV_EveryTime,
            _sdsp.stoffset ,2 ,
            MUIM_CallHook , hooks.sdsp_action] )
domethod( _sdsp.stcoef , [MUIM_Notify ,MUIA_String_Acknowledge,MUIV_EveryTime,
            _sdsp.stcoef ,2 ,
            MUIM_CallHook , hooks.sdsp_action] )
domethod( _sdsp.chtempo , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _sdsp.chtempo ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.chlfotempo , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _sdsp.chlfotempo ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.chlfo , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _sdsp.chlfo ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
domethod( _sdsp.chforce , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _sdsp.chforce ,3 ,
            MUIM_CallHook , hooks.sdsp_action, MUIV_TriggerValue ] )
  */
-> tRACK EDITOR
install(_tred.chedit,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_EDITON,1,MUIV_TriggerValue)
install(_tred.chspc,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_SPCON,1,MUIV_TriggerValue)
install(_tred.chon0,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_CHON,2,0,MUIV_TriggerValue)
install(_tred.chon1,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_CHON,2,1,MUIV_TriggerValue)
install(_tred.chon2,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_CHON,2,2,MUIV_TriggerValue)
install(_tred.chon3,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_CHON,2,3,MUIV_TriggerValue)
install(_tred.stname,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_RENAME,1,MUIV_TriggerValue)
install(_tred.btfirst, MUIA_Pressed , FALSE ,CG_TED,IC_GOFIRST)
install(_tred.btlast , MUIA_Pressed , FALSE ,CG_TED,IC_GOLAST)
install(_tred.imleft , MUIA_Pressed , FALSE ,CG_TED,IC_GOPREV)
install(_tred.imright, MUIA_Pressed , FALSE ,CG_TED,IC_GONEXT)
domethod( _tred.btpick , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _pckt.base ,3 ,
            MUIM_Set , MUIA_Window_Open ,MUI_TRUE ] )
install(_tred.cyoct,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_OCTAVE,1,MUIV_TriggerValue)
install(_tred.cyted,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TRCHANNELS,MUIV_TriggerValue)
install(_tred.cycom,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TRCOMLS,MUIV_TriggerValue)
install(_tred.sttempo0,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAM,3,0,CHTEMPOC,MUIV_TriggerValue)
install(_tred.sttempo1,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAM,3,1,CHTEMPOC,MUIV_TriggerValue)
install(_tred.sttempo2,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAM,3,2,CHTEMPOC,MUIV_TriggerValue)
install(_tred.sttempo3,MUIA_Cycle_Active,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAM,3,3,CHTEMPOC,MUIV_TriggerValue)
install(_tred.stlines0,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAMISTR,2,0,CHLINES)
install(_tred.stlines1,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAMISTR,2,1,CHLINES)
install(_tred.stlines2,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAMISTR,2,2,CHLINES)
install(_tred.stlines3,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_SETCHPARAMISTR,2,3,CHLINES)
install(_pckt.lv,MUIA_List_Active,MUIV_EveryTime,
      CG_TED,IC_SETACTIVEUSED,1,MUIV_TriggerValue)
install(_tred.lv0,MUIA_List_Active, MUIV_EveryTime,
      CG_TED,IC_JMPLINECH,2,0,MUIV_TriggerValue)
install(_tred.lv1,MUIA_List_Active, MUIV_EveryTime,
      CG_TED,IC_JMPLINECH,2,1,MUIV_TriggerValue)
install(_tred.lv2,MUIA_List_Active, MUIV_EveryTime,
      CG_TED,IC_JMPLINECH,2,2,MUIV_TriggerValue)
install(_tred.lv3,MUIA_List_Active, MUIV_EveryTime,
      CG_TED,IC_JMPLINECH,2,3,MUIV_TriggerValue)
install( _tred.lv0,MUIA_Listview_DoubleClick,MUI_TRUE,CG_TED,IC_ACTIVATECH)
install( _tred.lv1,MUIA_Listview_DoubleClick,MUI_TRUE,CG_TED,IC_ACTIVATECH)
install( _tred.lv2,MUIA_Listview_DoubleClick,MUI_TRUE,CG_TED,IC_ACTIVATECH)
install( _tred.lv3,MUIA_Listview_DoubleClick,MUI_TRUE,CG_TED,IC_ACTIVATECH)

install(_tred.st0,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_GPUTCMD,2,0,MUIV_TriggerValue)
install(_tred.st1,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_GPUTCMD,2,1,MUIV_TriggerValue)
install(_tred.st2,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_GPUTCMD,2,2,MUIV_TriggerValue)
install(_tred.st3,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_TED,IC_GPUTCMD,2,3,MUIV_TriggerValue)

      -> track options

install(_trop.slleft,MUIA_Numeric_Value,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TRLVOL,MUIV_TriggerValue)
install(_trop.slright,MUIA_Numeric_Value,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TRRVOL,MUIV_TriggerValue)
install(_trop.sltempoc,MUIA_Numeric_Value,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TRTEMPOC,MUIV_TriggerValue)
install(_trop.chusedsp,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TRDSPFLG,MUIV_TriggerValue)
install(_trop.chexclude,MUIA_Selected,MUIV_EveryTime,
      CG_TED,IC_SETTPARAM,2,TREXCL,MUIV_TriggerValue)
domethod(_trop.btdsp,[MUIM_Notify,MUIA_Pressed,FALSE,
       _tdsp.base,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])

      -> section editor

domethod(_sect.btfirst,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btfirst,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btlast,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btlast,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btdel,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btdel,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btnew,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btnew,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btplay,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btplay,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btdelpos,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btdelpos,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.rplus,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.rplus,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.rminus,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.rminus,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btnewpos,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btnewpos,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btinspos,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btinspos,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btdeltrack,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btdeltrack,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btaddtrack,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btaddtrack,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btclear,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btclear,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.playtracks,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.playtracks,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btcopy,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btcopy,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.btpaste,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.btpaste,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.imleft,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.imleft,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.imright,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sect.imright,2,MUIM_CallHook,hooks.sect_pressbutton])
domethod(_sect.stname,[MUIM_Notify,MUIA_String_Acknowledge,MUIV_EveryTime,
       _sect.stname,3,MUIM_CallHook,hooks.sect_pressbutton,MUIV_TriggerValue]) 
domethod( _sect.lv1,[MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
            _sect.lv1,3,MUIM_CallHook, hooks.sect_listactive,MUIV_TriggerValue])
domethod( _sect.lv3,[MUIM_Notify, MUIA_Listview_DoubleClick, MUI_TRUE,
            _sect.lv3,2,MUIM_CallHook, hooks.sect_doubleclick])


      /* song editor */

domethod( _sged.lvsectionlist2,[MUIM_Notify, MUIA_List_Active, MUIV_EveryTime,
      _sged.lvsectionlist2,3,MUIM_CallHook, hooks.sged_listactive,MUIV_TriggerValue])

domethod(_sged.btadd,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.btadd,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.btinsert,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.btinsert,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.btdelete,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.btdelete,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.btdeleteall,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.btdeleteall,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.btrepeatplus,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.btrepeatplus,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.btrepeatminus,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.btrepeatminus,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.bttransposeplus,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.bttransposeplus,2,MUIM_CallHook,hooks.sged_pressbutton])
domethod(_sged.bttransposeminus,[MUIM_Notify,MUIA_Pressed,FALSE,
       _sged.bttransposeminus,2,MUIM_CallHook,hooks.sged_pressbutton])


      /* track dsp */
crequest(_tdsp.base)    

domethod( _tdsp.btadd , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _tdsp.btadd ,2 ,
            MUIM_CallHook , hooks.tdsp_action ] )
domethod( _tdsp.btinsert , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _tdsp.btinsert ,2 ,
            MUIM_CallHook , hooks.tdsp_action ] )
domethod( _tdsp.btdelete , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _tdsp.btdelete ,2 ,
            MUIM_CallHook , hooks.tdsp_action ] )
domethod( _tdsp.btdeleteall , [MUIM_Notify , MUIA_Pressed , FALSE ,
            _tdsp.btdeleteall ,2 ,
            MUIM_CallHook , hooks.tdsp_action ] )

domethod( _tdsp.cyccassign , [MUIM_Notify ,MUIA_Cycle_Active,MUIV_EveryTime,
            _tdsp.cyccassign ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.lvdspsequence, [MUIM_Notify , MUIA_List_Active, MUIV_EveryTime,
            _tdsp.lvdspsequence,3 ,
            MUIM_CallHook , hooks.tdsp_lactive, MUIV_TriggerValue]) 
domethod( _tdsp.lvparams, [MUIM_Notify , MUIA_List_Active, MUIV_EveryTime,
            _tdsp.lvparams,3 ,
            MUIM_CallHook , hooks.tdsp_lactive, MUIV_TriggerValue]) 

domethod( _tdsp.cylfotype , [MUIM_Notify ,MUIA_Cycle_Active,MUIV_EveryTime,
            _tdsp.cylfotype ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.sloffset , [MUIM_Notify ,MUIA_Numeric_Value,MUIV_EveryTime,
            _tdsp.sloffset ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.slcoef , [MUIM_Notify ,MUIA_Numeric_Value,MUIV_EveryTime,
            _tdsp.slcoef ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.sllfoper , [MUIM_Notify ,MUIA_Numeric_Value,MUIV_EveryTime,
            _tdsp.sllfoper ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.stoffset , [MUIM_Notify ,MUIA_String_Acknowledge,MUIV_EveryTime,
            _tdsp.stoffset ,2 ,
            MUIM_CallHook , hooks.tdsp_action] )
domethod( _tdsp.stcoef , [MUIM_Notify ,MUIA_String_Acknowledge,MUIV_EveryTime,
            _tdsp.stcoef ,2 ,
            MUIM_CallHook , hooks.tdsp_action] )
domethod( _tdsp.chtempo , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _tdsp.chtempo ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.chlfotempo , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _tdsp.chlfotempo ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )
domethod( _tdsp.chlfo , [MUIM_Notify ,MUIA_Selected,MUIV_EveryTime,
            _tdsp.chlfo ,3 ,
            MUIM_CallHook , hooks.tdsp_action, MUIV_TriggerValue ] )


-> Sample editor


install(_smme.load ,MUIA_Menuitem_Trigger,MUIV_EveryTime ,
      CG_SED,IC_LOADSAMPLE)
install(_smme.saveas ,MUIA_Menuitem_Trigger,MUIV_EveryTime ,
      CG_SED,IC_SAVESAMPLE)
install(_smme.flush,MUIA_Menuitem_Trigger,MUIV_EveryTime ,
      CG_SED,IC_DELSAMPLE)

install(_smme.centralize ,MUIA_Menuitem_Trigger,MUIV_EveryTime ,
      CG_SED,IC_CENTRALIZE)
install(_smme.swapbyteorder ,MUIA_Menuitem_Trigger,MUIV_EveryTime ,
      CG_SED,IC_SWPBYTEORDER)
install(_smme.signedunsigned ,MUIA_Menuitem_Trigger,MUIV_EveryTime ,
      CG_SED,IC_SIGNEDUNSIGNED)

install(_smed.imleft,MUIA_Pressed,FALSE,CG_SED,IC_GOPREV)
install(_smed.imright,MUIA_Pressed,FALSE,CG_SED,IC_GONEXT)
install(_smed.btfirst,MUIA_Pressed,FALSE,CG_SED,IC_GOFIRST)
install(_smed.btlast,MUIA_Pressed,FALSE,CG_SED,IC_GOLAST)
install(_smed.ch16bit,MUIA_Selected,MUIV_EveryTime,
      CG_SED,IC_SETPARAM,2,SMTYPE,MUIV_TriggerValue)
install(_smed.chstereo,MUIA_Selected,MUIV_EveryTime,
      CG_SED,IC_SETPARAM,2,SMSTEREO,MUIV_TriggerValue)


install(_smed.strngstart,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SED,IC_GUIINPUT,1,SMRNGSTART)
install(_smed.strnglen,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SED,IC_GUIINPUT,1,SMRNGLEN)
install(_smed.stpitch,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SED,IC_GUIINPUT,1,SMRATE)
install(_smed.stbuffer,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SED,IC_GUIINPUT,1,SMFRAMES)

install(_smed.proffset,MUIA_Prop_First,MUIV_EveryTime,
      CG_SED,IC_SETPARAM,2,SMOFFSET,MUIV_TriggerValue)
install(_smed.przoom,MUIA_Prop_First,MUIV_EveryTime,
      CG_SED,IC_SETPARAM,2,SMZOOM,MUIV_TriggerValue)

install(_smed.btplaydisplay,MUIA_Pressed,FALSE,CG_SED,IC_PLAY)
install(_smed.btplayrange,MUIA_Pressed,FALSE,CG_SED,IC_PLAYRNG)
install(_smed.btshowall,MUIA_Pressed,FALSE,CG_SED,IC_SHOWALL)
install(_smed.btshowrange,MUIA_Pressed,FALSE,CG_SED,IC_SHOWRNG)
install(_smed.btrangeall,MUIA_Pressed,FALSE,CG_SED,IC_RNGALL)

install(_smed.btcopy,MUIA_Pressed,FALSE,CG_SED,IC_COPYRNG)
install(_smed.btpaste,MUIA_Pressed,FALSE,CG_SED,IC_PASTERNG)
install(_smed.btclear,MUIA_Pressed,FALSE,CG_SED,IC_CLEARRNG)
install(_smed.bterase,MUIA_Pressed,FALSE,CG_SED,IC_ERASERNG)
install(_smed.btcut,MUIA_Pressed,FALSE,CG_SED,IC_CUTRNG)
install(_smed.btplace,MUIA_Pressed,FALSE,CG_SED,IC_PLACERNG)
install(_smed.btreverse,MUIA_Pressed,FALSE,CG_SED,IC_REVRNG)

install(_smed.btzoomin,MUIA_Pressed,FALSE,CG_SED,IC_ZIN)
install(_smed.btzoomout,MUIA_Pressed,FALSE,CG_SED,IC_ZOUT)

install(_smed.stname,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SED,IC_RENAME,1,MUIV_TriggerValue)

-> mpeg decoder stuff
install(_mpeg.stfile,MUIA_String_Acknowledge,MUIV_EveryTime,
      CG_SED,IC_MPEGGETFILE,1,MUIV_TriggerValue)
install(_mpeg.chstereo,MUIA_Selected,MUIV_EveryTime,
      CG_SED,IC_MPEGPARAM,2,MPSTEREO,MUIV_TriggerValue)
install(_mpeg.ch16bit,MUIA_Selected,MUIV_EveryTime,
      CG_SED,IC_MPEGPARAM,2,MPTYPE,MUIV_TriggerValue)
install(_mpeg.slstart,MUIA_Numeric_Value,MUIV_EveryTime,
      CG_SED,IC_MPEGPARAM,2,MPSTART,MUIV_TriggerValue)
install(_mpeg.slend,MUIA_Numeric_Value,MUIV_EveryTime,
      CG_SED,IC_MPEGPARAM,2,MPEND,MUIV_TriggerValue)
install(_mpeg.btstart,MUIA_Pressed,FALSE,CG_SED,IC_MPEGSTART)
install(_mpeg.btabort,MUIA_Pressed,FALSE,CG_SED,IC_MPEGABORT)

-> change volume stuff

install(_cvol.btchange,MUIA_Pressed,FALSE,CG_SED,IC_CVOL)
install(_cvol.btdouble,MUIA_Pressed,FALSE,CG_SED,IC_CVOLDOUBLE)
install(_cvol.bthalve,MUIA_Pressed,FALSE,CG_SED,IC_CVOLHALVE)
install(_cvol.btmaximum,MUIA_Pressed,FALSE,CG_SED,IC_CVOLMAX)


install(_pcks.lv,MUIA_List_Active,MUIV_EveryTime,
      CG_SED,IC_SETACTIVEUSED,1,MUIV_TriggerValue)

      set( _main.base ,MUIA_Window_Open , MUI_TRUE )

      set( _info.base ,MUIA_Window_Open , MUI_TRUE )


ENDPROC

PROC main()
ENDPROC


