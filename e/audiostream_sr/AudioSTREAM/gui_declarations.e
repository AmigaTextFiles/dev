 /*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     gui_declarations.e
      Description:    declarations of gui and hook objects
      Version:    1.0
 --------------------------------------------------------------------
*/




OPT MODULE
MODULE 'utility/hooks','libraries/mui','*global'





EXPORT OBJECT obj_arexx       -> arexx stuff
      commands :  PTR TO mui_command
      error  :    hook
ENDOBJECT


EXPORT OBJECT obj_guisetup

      -> windows objects

      _appl:PTR TO obj_application
      _appm:PTR TO obj_appmenu
      _main:PTR TO objw_maincontrol
      _info:PTR TO objw_info
      _about:PTR TO objw_about
      _sels:PTR TO objw_selectsong
      _mopt:PTR TO objw_moduleoptions
      _sged:PTR TO objw_songeditor
      _sgop:PTR TO objw_songoptions
      _sdsp:PTR TO objw_songdsp
      _inst:PTR TO objw_instrument
      _idsp:PTR TO objw_instrumentdsp
      _smed:PTR TO objw_sampleeditor
      _smme:PTR TO obj_sampleedmenu
      _wved:PTR TO objw_waveeditor
      _wvme:PTR TO obj_waveedmenu
      _popt:PTR TO objw_playoptions
      _pcki:PTR TO objw_pickinstrument
      _pcks:PTR TO objw_picksample
      _pckw:PTR TO objw_pickwave
      _pckt:PTR TO objw_picktrack
      _lofl:PTR TO objw_loadfromlist
      _lied:PTR TO objw_listeditor
      _cvol:PTR TO objw_changevolume
      _cpit:PTR TO objw_changepitch
      _crch:PTR TO objw_createchord
      _tran:PTR TO objw_transpose
      _dspm:PTR TO objw_dspmanager
      _tred:PTR TO objw_trackeditor
      _trop:PTR TO objw_trackoptions
      _sect:PTR TO objw_sectioneditor
      _tdsp:PTR TO objw_trackdsp
      _mpeg:PTR TO objw_mpegdecoder

      -> custom classes
      class
      editor
      effclass
      dslist
      sampleed
      -> library bases
      
      mmbase
      intbase
      strgbase

      -> misc

      icon
      menu
      arexx:PTR TO obj_arexx

ENDOBJECT


EXPORT OBJECT obj_hooks       -> gui callback hooks

      -> special
            s_keyboard:hook
            ted_editorevent:hook
            ted_stringevent:hook
            fm_matrixor:hook
            smed_mouseobject:hook

      -> display hooks

            sdsp_disphook:hook
            tdsp_disphook:hook

      -> Main Control

            f_playsong          :   hook
            f_stop                    :   hook
            f_continue          :   hook

      -> MENUS

            fm_open             :   hook
            fm_save             :   hook
            fm_saveas           :   hook
            fm_quit             :   hook

            fm_saveasdefault    :   hook

            fm_smakeclone             :   hook
            

      -> DSP MANAGER
             f_dm_load       :       hook
             f_dm_flush      :       hook
             f_dm_flushall   :       hook
            f_dm_active :     hook

      -> DSP EDIT
             f_dspe_add      :       hook
             f_dspe_insert   :       hook
             f_dspe_delete   :       hook
             f_dspe_delall   :       hook

            sdsp_action :     hook
            sdsp_lactive      :     hook
            sdsp_dragdrop     :     hook

      sect_pressbutton  :     hook
      sect_listactive         :     hook
      sect_doubleclick  :     hook
      sect_dragdrop           :     hook

      sged_listactive         :     hook
      sged_pressbutton  :     hook
      sged_dragdrop           :     hook

      tdsp_action :     hook
      tdsp_lactive      :     hook
      tdsp_dragdrop     :     hook


ENDOBJECT








/* now follow declaration of objects, sorted by windows     */





EXPORT OBJECT obj_application
       app    :         PTR TO LONG
       menu   :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT obj_appmenu
      base
      _project,aboutaudiostream,aboutmui,sleep,quit
       _module,open,save,saveas,clear
       _display,infowindow,moduleoptions,sampleeditor,waveeditor,listeditor,dspmanager,mpegdecoder
       _song,select,addnew,deletecurrent,sedit,soptions,stranspose,sdsp,smakeclone
       _track,tpick,tnewhere,tdelcurrent,tplay,tedit,toptions,ttranspose,tcopy,
tcut,tpaste,tswap,tclear,tmakeclone,tdsp
       _instrument,pick,iload,loadfromlist,isave,isaveas,iflush,iedit,
iproperties,idsp,irender,imakeclone
       _edit,copyrange,cutrange,clearrange,copyrange2,cutrange2,pasterange,
transposerange,selectchannel
       _settings,playoptions,miscsettings,muisettings,loaddefault,
saveasdefault,pload,psaveas
       matrixor
ENDOBJECT

EXPORT OBJECT objw_maincontrol
       base   :        PTR TO LONG  -> ptr to window
       root   :        PTR TO LONG  -> ptr to GROUP_ROOT
       btplay :        PTR TO LONG

      btstop                  :     PTR TO LONG
      btcontinue        :     PTR TO LONG
      btselect          :     PTR TO LONG
      btplayoptions           :     PTR TO LONG
      bttrackeditor           :     PTR TO LONG
      btsectioneditor       :     PTR TO LONG
      btsongeditor            :     PTR TO LONG
      btsampleeditor           :     PTR TO LONG
      btinstrprop       :     PTR TO LONG
      bteditinstr

      txinstr
      imleft
      imright
ENDOBJECT

EXPORT OBJECT objw_info
      base                :   PTR TO LONG
      root                :   PTR TO LONG
      txcursong         :     PTR TO LONG
      txmisc                  :     PTR TO LONG
      txstatus          :     PTR TO LONG
      txmemory          :     PTR TO LONG
      txtimer           :     PTR TO LONG
      lv
      imsongleft        
      imsongright
ENDOBJECT

EXPORT OBJECT objw_about
      base                :   PTR TO LONG
      root                :   PTR TO LONG
      tx1                 :   PTR TO LONG
      tx2                 :   PTR TO LONG
      btresume            :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_selectsong
      base                :   PTR TO LONG
      root                :   PTR TO LONG
      lvsongs           :     PTR TO LONG
      btnew             :     PTR TO LONG
      btdelete          :     PTR TO LONG
      btdeleteall       :     PTR TO LONG
      btedit                  :     PTR TO LONG
      btoptions         :     PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_moduleoptions
      base        :     PTR TO LONG
      root        :     PTR TO LONG
      stname                 :         PTR TO LONG
      stauthor         :         PTR TO LONG
      stannotation           :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_songeditor
      base             :         PTR TO LONG
      root             :         PTR TO LONG
      lvsectionlist          :         PTR TO LONG
      btadd            :         PTR TO LONG
      btinsert         :         PTR TO LONG
      btdelete         :         PTR TO LONG
      btdeleteall      :         PTR TO LONG
      btrepeatplus           :         PTR TO LONG
      btrepeatminus          :         PTR TO LONG
      bttransposeplus      :     PTR TO LONG
      bttransposeminus     :     PTR TO LONG
      lvsectionlist2         :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_songoptions
      base             :         PTR TO LONG
      root             :         PTR TO LONG
      
      stname               :   PTR TO LONG
      stannotation         :   PTR TO LONG      
      sltempo        :   PTR TO LONG
      sltranspose    :   PTR TO LONG
      slleft               :   PTR TO LONG
      slright        :   PTR TO LONG
      chusedsp       :   PTR TO LONG
      btedit               :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_songdsp
      base         :     PTR TO LONG
      root         :     PTR TO LONG
      
      lvdspsequence        :   PTR TO LONG
      btadd          :   PTR TO LONG
      btinsert       :   PTR TO LONG
      btdelete       :   PTR TO LONG
      btdeleteall    :   PTR TO LONG
      lvdsppool       :  PTR TO LONG

      lvparams    :     PTR TO LONG
      sloffset    :     PTR TO LONG
      slcoef            :     PTR TO LONG
      stoffset    :     PTR TO LONG
      stcoef            :     PTR TO LONG

      chtempo           :     PTR TO LONG
      chlfotempo  :     PTR TO LONG
      chlfo       :     PTR TO LONG
      cylfotype   :     PTR TO LONG
      sllfoper    :     PTR TO LONG 

      txparam           :     PTR TO LONG
      cyccassign  :     PTR TO LONG
      chforce           :     PTR TO LONG 
                  
ENDOBJECT

EXPORT OBJECT objw_instrument
      base         :     PTR TO LONG
      root         :     PTR TO LONG
      
      txslot                  :     PTR TO LONG
      stname                 :         PTR TO LONG
      imleft                  :     PTR TO LONG
      imright           :     PTR TO LONG
      btfirst           :     PTR TO LONG
      btlast                  :     PTR TO LONG
      btpick                  :     PTR TO LONG

      txlinked          :     PTR TO LONG
      imleftlinked            :     PTR TO LONG
      imrightlinked           :     PTR TO LONG
      btpicklinked            :     PTR TO LONG
      btedit                  :     PTR TO LONG
      cytype                  :     PTR TO LONG

      lvparams    :     PTR TO LONG

      txinfo1     :     PTR TO LONG
      slstatic    :     PTR TO LONG
      slmodulation:     PTR TO LONG
      chnegative  :     PTR TO LONG

      sledepth     :     PTR TO LONG
      chenegative  :     PTR TO LONG
      slinitl      :     PTR TO LONG
      slattackl   :     PTR TO LONG
      slattackt   :     PTR TO LONG
      cyattack    :     PTR TO LONG
      sldecayl   :     PTR TO LONG
      sldecayt   :     PTR TO LONG
      cydecay    :     PTR TO LONG
      slsustainl   :     PTR TO LONG
      slsustaint   :     PTR TO LONG
      cysustain    :     PTR TO LONG
      slreleasel   :     PTR TO LONG
      slreleaset   :     PTR TO LONG
      cyrelease    :     PTR TO LONG
      chhold      :     PTR TO LONG

      slldepth    :     PTR TO LONG
      cywave      :     PTR TO LONG
      slperiod    :     PTR TO LONG
      chlnegative :     PTR TO LONG
      sllattackt  :     PTR TO LONG

      chtransposable          :     PTR TO LONG
      cymtype     :     PTR TO LONG
      sltranspose       :     PTR TO LONG
      slfinetune        :     PTR TO LONG
      stfixedrate :     PTR TO LONG
      btscanrate  :     PTR TO LONG

      slphasediff            :     PTR TO LONG
      chinvertl      :  PTR TO LONG
      chinvertr     :    PTR TO LONG

      chloop      :     PTR TO LONG
      chpingpong  :     PTR TO LONG
      chreverse   :     PTR TO LONG
      chinteractive     :     PTR TO LONG
      stoffset    :     PTR TO LONG
      stloops     :     PTR TO LONG
      stloopl     :     PTR TO LONG


      chinterpolation       :     PTR TO LONG
      chdsp             :     PTR TO LONG
      slkeyontimeout    :     PTR TO LONG
      chkillonzero      :     PTR TO LONG
      btdspedit         :     PTR TO LONG
ENDOBJECT


EXPORT OBJECT objw_instrumentdsp
      base               :     PTR TO LONG
      root               :     PTR TO LONG
      
      lvdspsequence         :   PTR TO LONG
      btadd           :   PTR TO LONG
      btinsert        :   PTR TO LONG
      btdelete        :   PTR TO LONG
      btdeleteall     :   PTR TO LONG
      st0            :   PTR TO LONG
      st1            :   PTR TO LONG
      st2            :   PTR TO LONG
      st3            :   PTR TO LONG
      st4            :   PTR TO LONG
      st5            :   PTR TO LONG
      st6            :   PTR TO LONG
      st7            :   PTR TO LONG
      lvavailabledsps     :     PTR TO LONG
      chenablemod :     PTR TO LONG
      btsetup           :     PTR TO LONG 
ENDOBJECT

EXPORT OBJECT objw_sampleeditor
      base              :     PTR TO LONG
      root              :     PTR TO LONG

      editarea          :     PTR TO LONG
      przoom                  :     PTR TO LONG 
      proffset    : PTR TO LONG

      txslot                 :         PTR TO LONG
      stname                :   PTR TO LONG
      cysavefmt         : PTR TO LONG
      imleft                 :         PTR TO LONG
      imright          :         PTR TO LONG
      btfirst          :         PTR TO LONG
      btlast                 :         PTR TO LONG
      btpick                 :         PTR TO LONG
      stbuffer        :   PTR TO LONG
      strngstart      :   PTR TO LONG
      strnglen       :   PTR TO LONG
      stpitch         :   PTR TO LONG
      btscan                 :         PTR TO LONG
      ch16bit          :         PTR TO LONG
      chstereo         :         PTR TO LONG
      btplaydisplay          :         PTR TO LONG
      btrangeall       :         PTR TO LONG
      btshowrange      :         PTR TO LONG
      btshowall        :         PTR TO LONG
      btzoomin         :         PTR TO LONG
      btzoomout        :         PTR TO LONG
      txdispsize       :         PTR TO LONG
      btplayrange      :         PTR TO LONG
      btcopy                 :         PTR TO LONG
      btcut            :         PTR TO LONG
      btpaste          :         PTR TO LONG
      btplace          :         PTR TO LONG
      btclear          :         PTR TO LONG
      bterase          :         PTR TO LONG
      btreverse        :         PTR TO LONG
      cyloop                 :         PTR TO LONG
      cyediting        :         PTR TO LONG
      btstepleft       :         PTR TO LONG
      btstepright      :         PTR TO LONG
      btmoveleft       :         PTR TO LONG
      btmoveright      :         PTR TO LONG
      btfindleft       :         PTR TO LONG
      btfindright      :         PTR TO LONG
      btstart          :         PTR TO LONG
      btend            :         PTR TO LONG
      btaccept         :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT obj_sampleedmenu
       base 
       _project,load,loadfromlist,save,saveas,flush,quit
       _tools,invert,centralize,signedunsigned,swapbyteorder,mpegdecoder
       _effects,changevolume,changepitch,makechord
       _settings
ENDOBJECT

EXPORT OBJECT objw_waveeditor
      base              :     PTR TO LONG
      root              :     PTR TO LONG
      
      txslot                 :         PTR TO LONG
      stname                :   PTR TO LONG
      imleft                 :         PTR TO LONG
      imright          :         PTR TO LONG
      btfirst          :         PTR TO LONG
      btlast                 :         PTR TO LONG
      btpick                 :         PTR TO LONG
      btcopyfromtemp         :         PTR TO LONG
      btcopytotemp           :         PTR TO LONG
      btdouble         :         PTR TO LONG
      bthalve          :         PTR TO LONG
      cysize                 :         PTR TO LONG
      btstretch        :         PTR TO LONG
      btmixwithtemp          :         PTR TO LONG
      btaddtemp        :         PTR TO LONG
      btdoubletemp           :         PTR TO LONG
      bthalvetemp      :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT obj_waveedmenu
      base
       _project,load,loadfromlist,save,saveas,flush,quit
ENDOBJECT

EXPORT OBJECT objw_playoptions
      base          :   PTR TO LONG
      root          :   PTR TO LONG
      
      txaudiomode       :     PTR TO LONG
      btpick                  :     PTR TO LONG
      stmixfreq        :         PTR TO LONG
      txactual          :     PTR TO LONG
      cypresets         :     PTR TO LONG
      slmixfreq         :     PTR TO LONG
      sltimeres         :     PTR TO LONG
      chmonomode        :     PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_pickinstrument
      base          :   PTR TO LONG
      root          :   PTR TO LONG
      
      lv            :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_picksample
      base          :   PTR TO LONG
      root          :   PTR TO LONG
      
      lv            :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_pickwave
      base          :   PTR TO LONG
      root          :   PTR TO LONG
      
      lv            :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_picktrack
      base          :   PTR TO LONG
      root          :   PTR TO LONG
      
      lv            :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_loadfromlist
      base           :   PTR TO LONG
      root           :   PTR TO LONG
      
      cytype                 :         PTR TO LONG
      lvitems          :         PTR TO LONG
      lvdirectories          :         PTR TO LONG
      txslot                 :         PTR TO LONG
      txname                 :         PTR TO LONG
      imleft                 :         PTR TO LONG
      imright          :         PTR TO LONG
      btfirst          :         PTR TO LONG
      btlast                 :         PTR TO LONG
      btpick                 :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_listeditor
       base         :   PTR TO LONG
      root           :   PTR TO LONG
      
      cytype                 :         PTR TO LONG
      lvitems          :         PTR TO LONG
      lvdirs                 :         PTR TO LONG
      btaddcuritem           :         PTR TO LONG
      btinscuritem           :         PTR TO LONG
      btdelitem        :         PTR TO LONG
      btadddir         :         PTR TO LONG
      btinsdir         :         PTR TO LONG
      btdeldir         :         PTR TO LONG
      btclear          :         PTR TO LONG
      btsavelist       :         PTR TO LONG
      txslot                 :         PTR TO LONG
      txname                 :         PTR TO LONG
      imleft                 :         PTR TO LONG
      imright          :         PTR TO LONG
      btfirst          :         PTR TO LONG
      btlast                 :         PTR TO LONG
      btpick                 :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_changevolume
       base         :   PTR TO LONG
      root           :   PTR TO LONG
      
      slvolume          :     PTR TO LONG
      btchange          :     PTR TO LONG
      btdouble          :     PTR TO LONG
      bthalve           :     PTR TO LONG
      btmaximum   :     PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_changepitch
       base         :   PTR TO LONG
      root           :   PTR TO LONG
      
      stsource        :   PTR TO LONG
      btscans          :         PTR TO LONG
      stdest                :   PTR TO LONG
      btscand          :         PTR TO LONG
      btchange         :         PTR TO LONG
      btoctup          :         PTR TO LONG
      btoctdown        :         PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_createchord
      base           :   PTR TO LONG
      root           :   PTR TO LONG
      
      sl2nd          :   PTR TO LONG
      sl3rd          :   PTR TO LONG
      sl4th          :   PTR TO LONG
      btcreate       :   PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_transpose
       base         :   PTR TO LONG
      root           :   PTR TO LONG
      
      cyapplyto         :     PTR TO LONG
      sllevel           :     PTR TO LONG
      bttranspose       :     PTR TO LONG
      btoctup           :     PTR TO LONG
      btoctdown         :     PTR TO LONG
ENDOBJECT


/* now some stupid rubbish


      cy_iw_typeContent   :   PTR TO LONG
      cy_en_attacktypeContent   :   PTR TO LONG
      cy_en_decaytypeContent    :   PTR TO LONG
      cy_en_sustaintypeContent  :   PTR TO LONG
      cy_sas_windowsizeContent  :   PTR TO LONG
      cy_dspi_type0Content      :   PTR TO LONG
      cy_dspi_type1Content      :   PTR TO LONG
      cy_dspi_type2Content      :   PTR TO LONG
      cy_dspi_type3Content      :   PTR TO LONG
      cy_Sed_LoopContent        :   PTR TO LONG
      cy_Sed_EditingContent     :   PTR TO LONG
      cy_Wed_SizeContent        :   PTR TO LONG
      cy_po_presetsContent      :   PTR TO LONG
      cy_lfl_typeContent        :   PTR TO LONG
      cy_led_typeContent        :   PTR TO LONG
      cy_tr_applytoContent      :   PTR TO LONG */
      
EXPORT OBJECT objw_dspmanager
       base         :   PTR TO LONG
      root           :   PTR TO LONG
      
      lvdsps             :           PTR TO LONG
      lvinfo      :     PTR TO LONG
      lvinfo2 :   PTR TO LONG
      btload               :    PTR TO LONG
      btflush         :   PTR TO LONG
      btflushall    :     PTR TO LONG
ENDOBJECT

EXPORT OBJECT objw_trackeditor
       base         :   PTR TO LONG
      root           :   PTR TO LONG

      txslot            :    PTR TO LONG
      stname           :        PTR TO LONG
      imleft            :    PTR TO LONG
      imright       :    PTR TO LONG
      btfirst       :    PTR TO LONG
      btlast            :    PTR TO LONG
      btpick            :    PTR TO LONG
      chedit            :    PTR TO LONG
      chspc       :    PTR TO LONG
      cyoct       :    PTR TO LONG
      cyted         :    PTR TO LONG
      cycom       :    PTR TO LONG
      sttempo0     :      PTR TO LONG
      stlines0     :      PTR TO LONG
      chon0       :    PTR TO LONG
      lv0         :    PTR TO LONG
      st0        :        PTR TO LONG
      sttempo1     :      PTR TO LONG
      stlines1     :      PTR TO LONG
      chon1       :    PTR TO LONG
      lv1         :    PTR TO LONG
      st1        :        PTR TO LONG
      sttempo2     :      PTR TO LONG
      stlines2     :      PTR TO LONG
      chon2       :    PTR TO LONG
      lv2         :    PTR TO LONG
      st2        :        PTR TO LONG
      sttempo3     :      PTR TO LONG
      stlines3     :      PTR TO LONG
      chon3       :    PTR TO LONG
      lv3         :    PTR TO LONG
      st3        :        PTR TO LONG
ENDOBJECT


EXPORT OBJECT objw_trackoptions
      base  :     PTR TO LONG
      root  :     PTR TO LONG
      
      slleft      :     PTR TO LONG
      slright     :     PTR TO LONG
      sltempoc:   PTR TO LONG
      chusedsp:   PTR TO LONG
      btdsp :     PTR TO LONG
      chexclude:  PTR TO LONG
ENDOBJECT



EXPORT OBJECT objw_sectioneditor
      base        :     PTR TO LONG
      root        :     PTR TO LONG


      txslot      :     PTR TO LONG
      stname      :     PTR TO LONG
      btfirst     :     PTR TO LONG
      btlast      :     PTR TO LONG
      btdel       :     PTR TO LONG
      btnew       :     PTR TO LONG
      btplay      :     PTR TO LONG
      lv1         :     PTR TO LONG
      btdelpos    :     PTR TO LONG
      rplus       :     PTR TO LONG
      rminus      :     PTR TO LONG
      btnewpos    :     PTR TO LONG
      btinspos    :     PTR TO LONG
      lv2         :     PTR TO LONG
      btdeltrack  :     PTR TO LONG
      btaddtrack  :     PTR TO LONG
      btclear     :     PTR TO LONG
      playtracks  :     PTR TO LONG
      btcopy      :     PTR TO LONG
      btpaste     :     PTR TO LONG
      lv3         :     PTR TO LONG
      imleft
      imright
ENDOBJECT
      
EXPORT OBJECT objw_trackdsp
      base         :     PTR TO LONG
      root         :     PTR TO LONG
      
      lvdspsequence        :   PTR TO LONG
      btadd          :   PTR TO LONG
      btinsert       :   PTR TO LONG
      btdelete       :   PTR TO LONG
      btdeleteall    :   PTR TO LONG
      lvdsppool       :  PTR TO LONG

      lvparams    :     PTR TO LONG
      sloffset    :     PTR TO LONG
      slcoef            :     PTR TO LONG
      stoffset    :     PTR TO LONG
      stcoef            :     PTR TO LONG

      chtempo           :     PTR TO LONG
      chlfotempo  :     PTR TO LONG
      chlfo       :     PTR TO LONG
      cylfotype   :     PTR TO LONG
      sllfoper    :     PTR TO LONG 

      txparam           :     PTR TO LONG
      cyccassign  :     PTR TO LONG 
                  
ENDOBJECT

EXPORT OBJECT objw_mpegdecoder
      base  :     PTR TO LONG
      root  :     PTR TO LONG

      pampeg:     PTR TO LONG
      stfile:     PTR TO LONG
      txlayer:    PTR TO LONG
      txbitrate:  PTR TO LONG
      txfreq:     PTR TO LONG
      txmode:     PTR TO LONG
      txduration: PTR TO LONG
      slstart:    PTR TO LONG
      slend:      PTR TO LONG
      ch16bit:    PTR TO LONG
      chstereo:   PTR TO LONG
      gampeg:     PTR TO LONG
      txmemory:   PTR TO LONG
      txslot:     PTR TO LONG
      btstart:    PTR TO LONG
      btabort:    PTR TO LONG
ENDOBJECT


