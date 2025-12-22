
/*

      AudioSTREAM Professional
      (c) 1997-98 Immortal SYSTEMS

      Source codes for version 1.0
      
      =================================================

      Source:     asguisetup.e
      Description:    asguisetup.library source
      Contains:   setup of the whole gui
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT PREPROCESS
OPT LARGE
LIBRARY 'asguisetup.library',1,1,'asguisetup v1.1 (1.2.3456)' IS gui_create

MODULE 'muimaster' , 'libraries/mui'
MODULE 'tools/boopsi' , 'libraries/gadtools'
MODULE 'utility/tagitem' , 'utility/hooks' 
MODULE '*adst:gui_declarations','intuition','*adst:libs/asmisc','*adst:global'


/* custom macros */

#define EaterObject     NewObjectA(class,NIL,[ MUIA_ShowMe,FALSE,TAG_DONE])
#define EditorObject    NewObjectA(editor,NIL,[ TAG_IGNORE,0
#define EffObject NewObjectA(effclass,NIL,[ TAG_IGNORE,0
#define DSListObject    NewObjectA(dslist,NIL,[ TAG_IGNORE,0
#define SampleEdObject  NewObjectA(sampleed,NIL,[ TAG_IGNORE,0

#define Chain           MUIA_CycleChain,1

#define BarLabel  Mui_MakeObjectA( MUIO_Menuitem , [ NM_BARLABEL , 0 , 0 , 0 ] )


/* object global variables, must be filled from asguisetup */

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

DEF cmenustrip,cmenu,cmenuitem,cwindow,cimage,ctext,crectangle,clist
DEF cstring,cscrollbar,clistview,cslider,ccycle,cgroup

DEF ccenter,cint1,cint2,cscreentitle

DEF class
DEF editor
DEF effclass,dslist,sampleed

DEF hooks:PTR TO obj_hooks

DEF g1,g2,g3,g4,g5,g6,g7,g8,g9,ga,gb,gc,gd,ge,gf,gg,gh,gi,gj,gk  -> temporary
DEF gz,gy,gx,gw,gv,gu,gt,gs

            DEF x:PTR TO obj_guisetup

/* string arrays */

DEF __modifytypes,__instrtypes,__windowsizes,__loops,__editing,__wsizes
DEF __presets,__lists,__transposes,__ccassigns,__lfotypes,__tempoctypes
DEF __savefmts

/* useful procedures */


/* procedure keybutton(text,[controlchar],[disabled],[weight],[help])
*/

PROC keybutton( text:PTR TO CHAR, cchar=NIL,disabled=FALSE,weight=100,help=NIL) IS TextObject ,
            ButtonFrame ,MUIA_Background , MUII_ButtonBack ,
            MUIA_Font,MUIV_Font_Button,MUIA_ControlChar , cchar ,
            MUIA_Text_Contents , Gs(text) ,
            MUIA_Text_PreParse , ccenter ,
            MUIA_Weight, weight ,
            MUIA_Disabled,disabled,
            ( IF help THEN MUIA_ShortHelp ELSE TAG_IGNORE ) , help ,
            MUIA_InputMode , MUIV_InputMode_RelVerify ,Chain,
      End

      
/* procedure simplebutton(text,[help])
*/

PROC mysimplebutton(text:PTR TO CHAR , help=NIL,weight=100) IS TextObject,
      ButtonFrame ,
            MUIA_Background , MUII_ButtonBack ,
            MUIA_Text_Contents , text ,
            MUIA_Font,MUIV_Font_Button,
            MUIA_Text_PreParse , ccenter ,
            ( IF help THEN MUIA_ShortHelp ELSE TAG_IGNORE ) , help ,
            MUIA_Weight,weight,
            MUIA_InputMode , MUIV_InputMode_RelVerify ,Chain,
      End


PROC imgright () IS ImageObject ,
            MUIA_Image_Spec , 30 ,
            MUIA_InputMode , MUIV_InputMode_RelVerify ,
            MUIA_Weight , 5 ,
            MUIA_Frame , MUIV_Frame_ImageButton ,
            MUIA_Image_FreeVert , MUI_TRUE ,
            MUIA_Image_FreeHoriz , MUI_TRUE ,
            MUIA_FixHeight , 10 ,
            MUIA_FixWidth , 8 ,Chain,
      End

PROC imgleft () IS ImageObject ,
            MUIA_Image_Spec , 31 ,
            MUIA_InputMode , MUIV_InputMode_RelVerify ,
            MUIA_Weight , 5 ,
            MUIA_Frame , MUIV_Frame_ImageButton ,
            MUIA_Image_FreeVert , MUI_TRUE ,
            MUIA_Image_FreeHoriz , MUI_TRUE ,
            MUIA_FixHeight , 10 ,
            MUIA_FixWidth , 8 ,Chain,
      End


PROC lstring (gptr:PTR TO LONG,label:PTR TO CHAR,maxlen=33,intvalue=-1,accept=NIL)    /* string with label */

DEF s

      s:=StringObject ,
            MUIA_Frame , MUIV_Frame_String ,
            MUIA_String_AdvanceOnCR , MUI_TRUE,
            MUIA_String_MaxLen , maxlen ,
            ( IF intvalue<>-1 THEN MUIA_String_Integer ELSE TAG_IGNORE ) , intvalue ,
            ( IF accept THEN MUIA_String_Accept ELSE TAG_IGNORE) , accept,    
            Chain,
      End
      gptr[]:=GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , Label2 (label) ,
            Child , s,
      End
ENDPROC s

/* syntax group,string:=lastring(label,[maxlen],[integer value]) */


PROC lslider(gptr:PTR TO LONG,label:PTR TO CHAR,min,max,level,format=NIL) -> labeled slider
DEF s
      IF format THEN format:=Gs(format)
      s :=  SliderObject ,
            MUIA_Frame , MUIV_Frame_Slider ,
            MUIA_Slider_Min , min ,
            MUIA_Slider_Max , max ,
            MUIA_Numeric_Value , level ,
            MUIA_Numeric_Default , level ,
            ( IF format THEN MUIA_Numeric_Format ELSE TAG_IGNORE) , format,    
            Chain ,
      End

      gptr[] :=   GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , Label2( label ) ,
            Child , s ,
      End
ENDPROC s

PROC lcheck (gptr:PTR TO LONG,label: PTR TO CHAR, state,weight=100) -> labeled checkmark
DEF s

      s := ImageObject,
                ImageButtonFrame,
                MUIA_InputMode        , MUIV_InputMode_Toggle,
                MUIA_Image_Spec       , MUII_CheckMark,
                MUIA_Image_FreeVert   , MUI_TRUE,
                MUIA_Selected         , state,
                MUIA_Background       , MUII_ButtonBack,
                MUIA_ShowSelState     , FALSE,
            Chain,
                End

      gptr[] := GroupObject ,
            MUIA_Weight,weight,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , HVSpace ,
            Child , GroupObject ,
                  MUIA_Group_Columns , 2 ,
                  Child , Label2( label) ,
                  Child , s ,
            End ,
      End

ENDPROC s

-> lcheck with small hspace
PROC lcheck2 (gptr:PTR TO LONG,label: PTR TO CHAR, state) -> labeled checkmark
DEF s

      s := ImageObject,
                ImageButtonFrame,
                MUIA_InputMode        , MUIV_InputMode_Toggle,
                MUIA_Image_Spec       , MUII_CheckMark,
                MUIA_Image_FreeVert   , MUI_TRUE,
                MUIA_Selected         , state,
                MUIA_Background       , MUII_ButtonBack,
                MUIA_ShowSelState     , FALSE,
            Chain,
                End

      gptr[] := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , HSpace(5) ,
            Child , GroupObject ,
                  MUIA_Group_Columns , 2 ,
                  Child , Label2( label) ,
                  Child , s ,
            End ,
      End

ENDPROC s

PROC lmenu(menu:PTR TO CHAR,shortcut=NIL) IS
            MenuitemObject ,
            MUIA_Menuitem_Title , Gs(menu) ,
            ( IF shortcut THEN MUIA_Menuitem_Shortcut ELSE TAG_IGNORE) , shortcut,    
      End

PROC balance() IS BalanceObject,End


PROC lnumeric(gptr:PTR TO LONG,label:PTR TO CHAR,min,max,level,format=NIL) 
DEF s

      IF format THEN format:=Gs(format)
      s:=   NumericbuttonObject,
            MUIA_Numeric_Default, level,
            MUIA_Numeric_Value, level,
            MUIA_Numeric_Max,max,
            MUIA_Numeric_Min,min,
            ( IF format THEN MUIA_Numeric_Format ELSE TAG_IGNORE) , format,    
            Chain,
            End
      gptr[] :=  HGroup,
               Child,GroupObject ,
                  MUIA_Group_Columns , 2 ,
                  Child , Label2( label) ,
                  Child , s ,
                  End,
              -> Child,HVSpace,
      End
ENDPROC s

PROC xnumeric(min,max,level,format=NIL) -> lnumeric without label
DEF s

      IF format THEN format:=Gs(format)
      s:=   NumericbuttonObject,
            MUIA_Numeric_Default, level,
            MUIA_Numeric_Value, level,
            MUIA_Numeric_Max,max,
            MUIA_Numeric_Min,min,
            ( IF format THEN MUIA_Numeric_Format ELSE TAG_IGNORE) , format,
            Chain,
            End
ENDPROC s


PROC lknob(gptr:PTR TO LONG,label:PTR TO CHAR,min,max,level)
DEF s

      s:= KnobObject,
            MUIA_Numeric_Value,level,
            MUIA_Numeric_Default,level,
            MUIA_Numeric_Max,max,
            MUIA_Numeric_Min,min,
            Chain,
      End

      gptr[]:=GroupObject,
            Child,      Label(label),
            Child,s,
      End
ENDPROC s




PROC init_stuff()    -> fills string arrays

__modifytypes:=[ Gs('Linear'),Gs('SpeedUp'),Gs('SlowDown'),NIL ]
__instrtypes:=[ Gs('Sample'),Gs('Wave') ,NIL ]
__windowsizes:=[ Gs('256 Bytes'),Gs('512 Bytes') ,Gs('1024 Bytes'),NIL]
__loops:= [ Gs('Off') ,Gs('On') ,      NIL ]
__editing:= [ Gs('Offset') ,Gs('Start') ,Gs('Length') ,NIL ]
__wsizes:= [ Gs('32') ,Gs('64') ,Gs('128') ,Gs('256') ,Gs('512') ,   NIL ]
__presets:= [ Gs('Ugly/15000') ,Gs('HalfCD/22050') ,Gs('HalfDAT/24000') ,
            Gs('MaxPAL/28400') ,Gs('CD/44100') ,Gs('DAT/48000') ,NIL ]
__lists:=[ Gs('Instruments') ,Gs('Samples') ,Gs('Waves') ,NIL ]
__transposes:=[Gs('Transposable Instruments') ,Gs('All Instruments') ,
            Gs('Current Instrument') ,NIL ]
__ccassigns:=[Gs('N/A'),Gs('#0'),Gs('#1'),Gs('#2'),Gs('#3'),Gs('#4'),Gs('#5'),
            Gs('#6'),Gs('#7'),Gs('#8'),Gs('#9'),0]
__lfotypes:=[Gs('Sine'),Gs('Triangle'),Gs('SawTooth'),0]
__tempoctypes:=[Gs('25%'),Gs('50%'),Gs('100%'),Gs('200%'),Gs('400%'),Gs('Other'),0]
__savefmts:=[Gs('AIFF'),Gs('WAVE'),Gs('MAUD'),Gs('8SVX'),Gs('RAW'),0]
cmenustrip:=MUIC_Menustrip
cmenu:=MUIC_Menu
cmenuitem:=MUIC_Menuitem
cwindow:=MUIC_Window
cimage:=MUIC_Image
ctext:=MUIC_Text
crectangle:=MUIC_Rectangle
clist:=MUIC_List
cstring:=MUIC_String
cscrollbar:=MUIC_Scrollbar
clistview:=MUIC_Listview
cslider:=MUIC_Slider
ccycle:=MUIC_Cycle
cgroup:=MUIC_Group


ccenter:=Gs('\ec')
cint1:=Gs('0123456789')
cint2:=Gs('-0123456789')

cscreentitle:=Gs('AudioSTREAM Professional v0.0          Copyright © 1997/98 IMMORTAL Systems')


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

ENDPROC







/* GUI SETUP */


                  /*---------*/
                  /* %part 1 */
                  /*---------*/


PROC createpart1()


/* main window setup */
/* %maincontrol */


      _main.btplay := keybutton('\euP\enlay',"¶",MUI_TRUE)
      _main.btstop := keybutton('\euS\entop',"ß",FALSE,100)
      _main.btcontinue := keybutton('\euC\enontinue',"ç",MUI_TRUE)
      _main.btselect := keybutton('Select....',0,MUI_TRUE )
      _main.btplayoptions := keybutton('Play \euO\enptions',"ø",FALSE)
      _main.bttrackeditor := mysimplebutton( 'Track Ed' )
      _main.btsectioneditor := mysimplebutton( 'Section Ed' )
      _main.btsongeditor := keybutton('Song Ed',NIL,MUI_TRUE)
      _main.btsampleeditor := mysimplebutton('Sample Ed')
      _main.btinstrprop := keybutton('P\eur\enop',"®",FALSE,20)
      _main.bteditinstr := keybutton('\euE\endit',"©",FALSE,20)

      _main.txinstr:= TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_PreParse , ccenter ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_InputMode , MUIV_InputMode_RelVerify, 
      End
      _main.imleft:=imgleft()
      _main.imright:=imgright()

      _main.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child,HGroup,
                        MUIA_Weight,50,
                        Child , Label('Song'),
                        Child , _main.btplay ,
                        Child , _main.btcontinue ,
                        Child , _main.btstop ,
                        End,
                  Child,HGroup,
                        Child, Label('Instr'),
                        Child, _main.txinstr,
                        Child, HGroup,
                              MUIA_Weight,10,
                              Child,_main.imleft,
                              Child,_main.imright,
                              End,
                        Child , _main.btinstrprop ,
                        Child , _main.bteditinstr ,
                        End,
            End ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , Label('Open'),
                  Child , _main.bttrackeditor ,
                  Child , _main.btsectioneditor ,
                  Child , _main.btsampleeditor ,
                  Child , _main.btsongeditor ,
                  Child , _main.btplayoptions ,
                  
                  
            End ,
            Child, EaterObject,
      End

      _main.base:= WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('AudioSTREAM Main Control') ,
            MUIA_Window_ID , "0WIN" ,
            WindowContents , _main.root,
            MUIA_HelpNode,'MAINWINDOW',
      End



/* infowindow setup */
/* %info */


      _info.txcursong := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_InputMode , MUIV_InputMode_RelVerify, 
      End
      _info.imsongleft := imgleft()
      _info.imsongright := imgright()
      _info.txmisc := TextObject ,
            MUIA_Weight,30,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _info.txstatus := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_PreParse , ccenter ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _info.txmemory := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Text_PreParse , ccenter ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_InputMode , MUIV_InputMode_RelVerify, 
      End
      _info.txtimer := TextObject,MUIA_Weight,15,MUIA_Background,MUII_ButtonBack,
            MUIA_Frame , MUIV_Frame_Button,     MUIA_Text_Contents,'00:00' ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Font,MUIV_Font_Button,
            MUIA_InputMode , MUIV_InputMode_RelVerify, 
      End

      _info.lv := ListviewObject ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,Chain,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
                  End ,
      End

      _info.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child,HGroup,
                  Child,GroupObject,
                        Child,HGroup,
                              Child,Label('Song'),
                              Child,_info.txcursong,        
                              Child,HGroup,
                                    MUIA_Weight,20,
                                    Child,_info.imsongleft,
                                    Child,_info.imsongright,
                                    End,
                              End,
                        Child,HGroup,
                              Child,Label('Mem'),
                              Child,_info.txmemory,
                              Child,_info.txmisc,
                              End,
                        Child,HGroup,
                              Child,Label('Status'),
                              Child,_info.txstatus,
                              
                              Child,_info.txtimer,
                              End,
                        End,
                  Child,_info.lv,
                  End,
                 Child, EaterObject,            
                 End

      _info.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Info Window') ,
            MUIA_Window_ID , "1WIN" ,
            WindowContents , _info.root ,
      End
            


/* about window setup */
/* %about */


      _about.tx1 := TextObject ,
            MUIA_Background , MUII_WindowBack ,
            MUIA_Text_PreParse,ccenter,
            MUIA_Text_Contents ,'\ei\e8Copyright © 1997/98 IMMORTAL Systems' ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _about.tx2 := TextObject ,
            MUIA_Background , MUII_WindowBack ,
            MUIA_Text_PreParse,ccenter,
            MUIA_Text_Contents ,'\ei\e8All Rights Reserved' ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _about.btresume := keybutton('\euR\enesume',"®",FALSE)

      _about.root:= GroupObject ,
            MUIA_Background , /*MUII_BACKGROUND*/ '2:00000000,00000000,00000000' ,
            Child , HGroup,
                  -> MUIA_Background , MUII_BACKGROUND ,
                  -> MUIA_Frame , MUIV_Frame_Group ,
                  Child , HVSpace,
                  Child , AboutImg(muimasterbase),
                  Child, HVSpace,
                  End,
            Child , VSpace(5) ,
            Child , _about.tx1 ,
            Child , VSpace(2) ,
            Child , _about.tx2 ,
            Child , VSpace(5),
            Child , TextObject ,
                  MUIA_Background , MUII_WindowBack ,
                  MUIA_Text_PreParse,ccenter,
                  MUIA_Text_Contents ,'\ei\e8Developer Version #980917\n\n',
                  MUIA_Text_SetMin , MUI_TRUE ,
                  End,
            Child , VSpace(5) ,
            Child , _about.btresume ,
            Child, EaterObject,
      End

      _about.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('About AudioSTREAM') ,
            MUIA_Window_ID , "2WIN" ,
            MUIA_Window_CloseGadget , FALSE ,
            MUIA_Window_DepthGadget , FALSE ,
            MUIA_Window_SizeGadget , FALSE ,
            MUIA_Window_NoMenus , MUI_TRUE ,
            WindowContents ,_about.root ,
      End

 
/* select song window setup */
/* %selectsong */


      _sels.lvsongs := ListviewObject ,
            MUIA_FrameTitle , Gs('Song Pool') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
            Chain ,
      End

      _sels.btnew := keybutton('\euN\enew',"­",0)
      _sels.btdelete := keybutton('\euD\enelete',"ð",MUI_TRUE)
      _sels.btdeleteall := keybutton( 'Delete All',NIL,MUI_TRUE)
      _sels.btedit := keybutton( 'Edit...' ,NIL,MUI_TRUE)
      _sels.btoptions := keybutton( 'Options...',NIL,MUI_TRUE )
      
      _sels.root:= GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _sels.lvsongs ,
                  Child ,GroupObject ,
                        MUIA_Weight , 50 ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Operations') ,
                        Child , _sels.btnew ,
                        Child , HVSpace ,
                        Child , _sels.btdelete ,
                        Child , _sels.btdeleteall ,
                        Child , HVSpace ,
                        Child , _sels.btedit ,
                        Child , HVSpace ,
                        Child , _sels.btoptions ,
                  End ,
            End ,
            Child, EaterObject,
      End

      _sels.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Select Song') ,
            MUIA_Window_ID , "3WIN" ,
            WindowContents , _sels.root ,
      End

/* module options window setup */
/* %moduleoptions */

      _mopt.stname:=lstring({g1},'Name')
      _mopt.stauthor :=lstring({g2},'Author')
      _mopt.stannotation :=lstring({g3},'Annotation')

      _mopt.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , g1 ,
            Child , VSpace(5) ,
            Child , g2,
            Child , VSpace(5) ,
            Child , g3 ,
            Child, EaterObject,
      End

      _mopt.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Project Properties') ,
            MUIA_Window_ID , "4WIN" ,
            WindowContents , _mopt.root ,
      End

/* song editor window setup */
/* %songeditor */


      _sged.lvsectionlist := ListviewObject ,
            MUIA_FrameTitle , Gs('Section Sequence') ,
            MUIA_Dropable,MUI_TRUE,
            MUIA_Listview_DragType, 1,
            MUIA_Listview_List , DSListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_List_DragSortable , MUI_TRUE,
                  MUIA_UserData, hooks.sged_dragdrop,
            End ,
      End


      _sged.btadd := keybutton('\eI[6:31]  \euA\endd',"æ",0)
      _sged.btinsert := keybutton('\eI[6:31] \euI\ennsert',"¡",0)
      _sged.btdelete := keybutton('\euD\enelete',"ð",0)
      _sged.btdeleteall := mysimplebutton( 'Delete All' )
      _sged.btrepeatplus := mysimplebutton( '+' )
      _sged.btrepeatminus := mysimplebutton( '-' )
      g1 := GroupObject ,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('Repeat') ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , _sged.btrepeatplus ,
            Child , _sged.btrepeatminus ,
      End
      _sged.bttransposeminus := mysimplebutton( '-' )
      _sged.bttransposeplus := mysimplebutton( '+' )
      g2:= GroupObject ,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('Transpose') ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , _sged.bttransposeplus ,
            Child , _sged.bttransposeminus ,
      End
      _sged.lvsectionlist2 := ListviewObject ,
            MUIA_FrameTitle , Gs('Section Pool') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
            End ,
      End

      _sged.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _sged.lvsectionlist ,
                  Child , GroupObject ,
                        MUIA_Weight , 33 ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Operations') ,
                        Child , _sged.btadd ,
                        Child , HVSpace ,
                        Child , _sged.btinsert ,
                        Child , HVSpace ,
                        Child , _sged.btdelete ,
                        Child , _sged.btdeleteall ,
                        Child , HVSpace ,
                        Child , g1,
                        Child , HVSpace ,
                        Child , g2 ,
                  End ,
                  Child , _sged.lvsectionlist2 ,
            End ,
            Child, EaterObject,
      End

      _sged.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Song Editor') ,
            MUIA_Window_ID , "5WIN" ,
            WindowContents , _sged.root ,
      End


/* song options window setup */
/* %songoptions */


      _sgop.stname:= lstring({g1},'Name')
      _sgop.stannotation:=lstring({g4},'Annotation')
      _sgop.sltempo:=lslider({g2},'Tempo',20,1000,120)
      _sgop.sltranspose := lslider({g3},'Transpose',-32,32,0)
      _sgop.slleft := lknob({g5},'Left',0,1024,256)
      _sgop.slright := lknob({g6},'Right',0,1024,256)
      _sgop.chusedsp := lcheck({g7},'Use',FALSE )
      _sgop.btedit := keybutton('Edit...',NIL,0)

      _sgop.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , g1 ,  -> name
            Child , HVSpace ,
            Child , g4,
            Child , HVSpace ,
            Child , g2 ,  -> tempo
            Child , HVSpace ,
            Child , g3 ,  -> transp
            Child , HVSpace ,
            Child , HGroup ,
                  Child , HGroup ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Volume Control') ,
                        Child , HVSpace,
                        Child , g5 ,
                        Child , HVSpace,
                        Child , g6 ,
                        Child , HVSpace,  
                  End ,
                  Child , GroupObject ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('DSP Sequence') ,
                        Child , g7 ,
                        Child , _sgop.btedit ,
                  End ,
            End ,
            Child, EaterObject,
      End

      _sgop.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Song Options') ,
            MUIA_Window_ID , "6WIN" ,
            WindowContents , _sgop.root ,
      End



/* song dsp sequence window setup */
/* %songdsp */

      _sdsp.lvdspsequence := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Sequence') ,
            MUIA_Dropable,MUI_TRUE,
            MUIA_Listview_DragType, 1,
            MUIA_Listview_List , DSListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_List_DisplayHook, hooks.sdsp_disphook,
                  MUIA_List_Format,Gs('MIW=10 P=\e8 BAR,MIW=70 BAR,MIW=20 P=\er'),
                  MUIA_List_Title,MUI_TRUE,
                  MUIA_List_DragSortable , MUI_TRUE,
                  MUIA_UserData,hooks.sdsp_dragdrop,
            End ,
            Chain ,

      End
      _sdsp.btadd := keybutton('\eI[6:31]  \euA\endd',"æ",0)
      _sdsp.btinsert := keybutton('\eI[6:31] \euI\ennsert',"¡",0)
      _sdsp.btdelete := keybutton('\euD\enelete',"ð",0)
      _sdsp.btdeleteall := mysimplebutton( 'Delete All' )
      _sdsp.lvdsppool := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Pool') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
            Chain ,
      End

      _sdsp.lvparams := ListviewObject ,
            MUIA_Weight,50,
            MUIA_FrameTitle , Gs('Parameters') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
            Chain ,
      End

      _sdsp.sloffset:=lslider({g1},'Offset',-256,256,0)
      _sdsp.slcoef:=lslider({g2},'Coef',-1024,1024,256,'%ld/256')
      _sdsp.stoffset:=StringObject,
            MUIA_Frame,MUIV_Frame_String,
            MUIA_String_Accept,cint2,
            MUIA_String_MaxLen,7,
            MUIA_String_Integer,0,
            MUIA_Weight,25,
            MUIA_String_AdvanceOnCR,MUI_TRUE,
            Chain,
            End

      _sdsp.stcoef:=StringObject,
            MUIA_Frame,MUIV_Frame_String, 
            MUIA_String_Accept,cint2,
            MUIA_String_MaxLen,7,
            MUIA_String_Integer,256,
            MUIA_Weight,25,
            MUIA_String_AdvanceOnCR,MUI_TRUE,
            Chain,
            End
      _sdsp.txparam:=TextObject,
                  ->MUIA_Background , MUII_TextBack ,
                  ->MUIA_Frame , MUIV_Frame_Text ,
                  MUIA_Text_SetMin,MUI_TRUE,
                  MUIA_Text_PreParse,ccenter,
                  End

      _sdsp.cylfotype:=CycleObject,
            MUIA_Cycle_Entries ,__lfotypes ,
            MUIA_Weight ,10 ,
            Chain,
      End

      _sdsp.sllfoper:=lnumeric({g3},'Period',5,300,50,'%ld/5s')
      _sdsp.chtempo:=lcheck({g4},'Parameter Depends On Tempo',FALSE)
      _sdsp.chlfo:=lcheck({g5},'LFO',FALSE)
      _sdsp.chlfotempo:=lcheck({g6},'By Lines',FALSE)
      _sdsp.chforce:=lcheck({g7},'Affect Excluded Tracks',FALSE)
      

      _sdsp.cyccassign:=CycleObject,
            MUIA_Cycle_Entries,__ccassigns,
            Chain,End

      _sdsp.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _sdsp.lvdspsequence ,
                  Child , GroupObject ,
                        MUIA_Weight , 80 ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Operations') ,
                        Child , _sdsp.btadd ,
                        Child , HVSpace ,
                        Child , _sdsp.btinsert ,
                        Child , HVSpace ,
                        Child , _sdsp.btdelete ,
                        Child , _sdsp.btdeleteall ,
                        Child , HVSpace ,
                        Child , Label ('\ecCmd Assign:'),
                        Child ,_sdsp.cyccassign,
                        Child, HVSpace,
                  End ,
                  Child , _sdsp.lvdsppool ,
            End ,
            Child , HGroup,
                  MUIA_Frame,MUIV_Frame_Group,
                  Child,_sdsp.lvparams,
                  Child, VGroup,
                        Child, _sdsp.txparam,
                        Child, HGroup,
                              Child, g1,
                              Child, _sdsp.stoffset,
                              End,
                        Child, HGroup,
                              Child, g2,
                              Child, _sdsp.stcoef,
                              End,
                        Child, HGroup,
                              Child,g4,
                              Child,HVSpace,
                              Child,g7,
                              End,
                        Child, HGroup,
                              MUIA_Frame , MUIV_Frame_Group ,     
                              Child,g5,
                              Child,g6,    
                              Child,g3,
                              Child,Label('Type'),
                              Child,_sdsp.cylfotype,
                              End,
                        
                        End,
                  End,
            Child, EaterObject,
            
      End

      _sdsp.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Song DSP Sequence') ,
            MUIA_Window_ID , "7WIN" ,
            WindowContents , _sdsp.root ,
      End


ENDPROC


                  /*---------*/
                  /* %part 2 */
                  /*---------*/

PROC createpart2()


/* instrument properties */
/* %instrument */


      _inst.txslot := TextObject ,
            MUIA_Weight , 10 ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _inst.stname := lstring({g1}, '')
      _inst.imleft := imgleft()
      _inst.imright := imgright()
      _inst.btfirst := keybutton('First',NIL,0,10)
      _inst.btlast := keybutton('Last',NIL,0,10)
      _inst.btpick := keybutton('\euP\enick...',"¶",0,10)

      _inst.txlinked := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_Contents , '<none>' ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _inst.imleftlinked := imgleft()
      _inst.imrightlinked := imgright()
      _inst.btpicklinked := keybutton('P\eui\enck...',"¡",0,10)
      _inst.btedit := keybutton('\euE\endit...',"©",0,10)
      _inst.cytype := CycleObject,
            MUIA_Weight,10,
            MUIA_Disabled,MUI_TRUE,
            MUIA_Cycle_Entries , __instrtypes ,Chain,
      End

      _inst.lvparams:= ListviewObject ,
            ->MUIA_FrameTitle , Gs('Dynamic params') ,
            MUIA_Weight,200,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
                  MUIA_List_SourceArray, [ Gs('Volume'),Gs('Panning'),
                  Gs('Pitch L'),Gs('Pitch R'),NIL],
            End ,
            Chain ,
      End

      _inst.txinfo1 := TextObject ,
            MUIA_Background , MUII_RegisterBack ,
            ->MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End

      _inst.slstatic:=lslider({g2},'Static value',0,0,0)
      _inst.slmodulation:=lslider({g3},'Modulation',0,0,0)
      _inst.chnegative := lcheck({g4}, 'Negative',FALSE,10 )

      _inst.sledepth:=lslider({g5},'Depth',0,256,0)
      _inst.chenegative := lcheck({g6}, 'Negative',FALSE,10 )
      _inst.chhold := lcheck({g7}, 'Hold Mode',FALSE )
      _inst.slinitl := xnumeric(0,256,0)
      _inst.slattackl := xnumeric(0,256,0)
      _inst.slattackt := xnumeric(0,100,0,'%ld/10 s')
      _inst.cyattack := CycleObject ,
            MUIA_Cycle_Entries , __modifytypes ,Chain,
      End
      _inst.sldecayl := xnumeric(0,256,0)
      _inst.sldecayt := xnumeric(0,100,0,'%ld/10 s')
      _inst.cydecay := CycleObject ,
            MUIA_Cycle_Entries , __modifytypes ,Chain,
      End
      _inst.slsustainl := xnumeric(0,256,0)
      _inst.slsustaint := xnumeric(0,100,0,'%ld/10 s')
      _inst.cysustain := CycleObject ,
            MUIA_Cycle_Entries , __modifytypes ,Chain,
      End
      _inst.slreleasel := xnumeric(0,256,0)
      _inst.slreleaset := xnumeric(0,100,0,'%ld/10 s')
      _inst.cyrelease := CycleObject ,
            MUIA_Cycle_Entries , __modifytypes ,Chain,
      End

      gz := VGroup ,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('Envelope setup') ,
            Child, HGroup,
                  Child, g5,
                  Child,g6,
            End,
            Child, HGroup,
                  Child, Label2(Gs('\e8Attack: ')),
                  Child,HVSpace,
                  Child,Label2(Gs('Init Level')),
                  Child,_inst.slinitl,
                  Child, Label2(Gs('Level')),
                  Child, _inst.slattackl,
                  Child, Label2(Gs('Time')),
                  Child, _inst.slattackt,
                  Child, Label2(Gs('Type')),
                  Child, _inst.cyattack,
             End,
             Child, HGroup,
                  Child, Label2(Gs('\e8Decay: ')),
                  Child,HVSpace,
                  Child, Label2(Gs('Level')),
                  Child, _inst.sldecayl,
                  Child, Label2(Gs('Time')),
                  Child, _inst.sldecayt,
                  Child, Label2(Gs('Type')),
                  Child, _inst.cydecay,
             End,
             Child, HGroup,
                  Child, Label2(Gs('\e8Sustain: ')),
                  Child, HVSpace,
                  Child, g7, ->chhold
                  Child, Label2(Gs('Level')),
                  Child, _inst.slsustainl,
                  Child, Label2(Gs('Time')),
                  Child, _inst.slsustaint,
                  Child, Label2(Gs('Type')),
                  Child, _inst.cysustain,
                  
             End,
             Child, HGroup,
                  Child, Label2(Gs('\e8Release: ')),
                  Child,HVSpace,
                  Child, Label2(Gs('Level')),
                  Child, _inst.slreleasel,
                  Child, Label2(Gs('Time')),
                  Child, _inst.slreleaset,
                  Child, Label2(Gs('Type')),
                  Child, _inst.cyrelease,
             End,
             
      End

      _inst.slldepth:=lslider({g5},'Depth',0,256,0)
      _inst.chlnegative := lcheck({g6}, 'Negative',FALSE,10 )
      _inst.slperiod:=lslider({g7},'Period',1,1000,1,'%ld/10 s')
      _inst.sllattackt:=lslider({g8},'Attack Time',0,1000,0,'%ld/10 s')
      _inst.cywave := CycleObject ,
            MUIA_Cycle_Entries , __lfotypes ,Chain,
      End

      gy := VGroup,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('LFO setup') ,
            Child, HGroup,
                  Child, g5,
                  Child, g6,
            End,
            Child, g7,
            Child, g8,
            Child, HGroup,
                  Child, Label2(Gs('Wave Type')),
                  Child, _inst.cywave,
            End,
      End

      _inst.chtransposable := lcheck({g5}, 'Transposable',MUI_TRUE )
      _inst.cymtype := CycleObject ,
            MUIA_Cycle_Entries , [Gs('Normal'),Gs('Fixed Rate'),NIL] ,Chain,
      End
      _inst.sltranspose := lslider({g6},'Transpose',-24,24,0)
      _inst.slfinetune := lslider({g7},'Finetune',-8,8,0)
      _inst.stfixedrate := lstring({g8},'Rate',6,44100,cint1)
      _inst.btscanrate := mysimplebutton('Scan',0,10)

      gx:= VGroup,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('Transposition Setup') ,
            Child, HGroup,
                  Child, Label2(Gs('Instr Type')),
                  Child, _inst.cymtype,
                  Child, HVSpace,
                  Child, g8,
                  Child,_inst.btscanrate,
                  Child, HVSpace,
                  Child, g5,
            End,
            Child, HGroup,
                  Child, g6,
                  Child, g7,
            End,
      End

      _inst.slphasediff := lslider({g5},'Phase Diff',-50,50,0,'%ld ms')
      _inst.chinvertl := lcheck({g6}, 'Invert L',FALSE,10 )
      _inst.chinvertr := lcheck({g7}, 'Invert R',FALSE,10 )

      _inst.chloop := lcheck({g8}, 'Loop On',FALSE)
      _inst.chpingpong := lcheck({g9}, 'Ping Pong',FALSE)
      _inst.chreverse := lcheck({ga}, 'Reverse',FALSE)
      _inst.stoffset :=       lstring({gb},'Offset',11,-1,cint1)
      _inst.stloops :=    lstring({gc},'Loop Start',11,-1,cint1)
      _inst.stloopl :=      lstring({gd},'Loop Length',11,-1,cint1)
      _inst.chinteractive := lcheck({ge}, 'Interactive Editing',FALSE)

      gw:=  VGroup,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('Sample Setup') ,
            Child, HGroup,
                  Child, g8,
                  Child, g9,
                  Child, ga,
                  Child, ge,
            End,
            Child,HGroup,
                  Child, gb,
                  Child, gc,
                  Child, gd,
            End,
      End

      _inst.chinterpolation := lcheck({g8}, 'Interpolation',MUI_TRUE )
      _inst.chdsp := lcheck({g9}, 'DSP',FALSE )
      _inst.slkeyontimeout := lslider({ga}, 'KEYON Timeout',0,100,0,'%ld/10 sec')
      _inst.chkillonzero := lcheck({gb}, 'Kill Note On Zero Volume',MUI_TRUE )
      _inst.btdspedit:=mysimplebutton('Edit...')
      
      gv:= HGroup,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('Misc Setup') ,
            Child,VGroup,
                  MUIA_Weight,50,
                  Child,g8,
                  Child,gb,
            End,
            Child,HSpace(20),
            Child,VGroup,
                  Child,ga,
                  Child,HGroup,
                        ->Child,HVSpace,
                        Child,g9,
                        Child,_inst.btdspedit,
                  End,
            End,
            End

      _inst.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Instrument') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _inst.txslot ,
                  Child , g1 ,  -> str name
                  Child , _inst.imleft ,
                  Child , _inst.imright ,
                  Child , _inst.btfirst ,
                  Child , _inst.btlast ,
                  Child , _inst.btpick ,
            End ,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Used Sample') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _inst.cytype ,
                  Child , _inst.txlinked ,
                  Child , _inst.imleftlinked ,
                  Child , _inst.imrightlinked ,
                  Child , _inst.btpicklinked ,
                  Child , _inst.btedit ,
            End ,
            Child , HGroup ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Dynamic Parameters') ,
                  Child , _inst.lvparams,
                  Child , RegisterGroup([Gs('General'),Gs('Envelope'),Gs('LFO'),NIL]),
                        MUIA_Register_Frame, MUI_TRUE,
                        Child, VGroup,
                              MUIA_Frame , MUIV_Frame_Group ,
                              MUIA_FrameTitle , Gs('General Setup') ,
                              Child, _inst.txinfo1,
                              Child, g2, ->slstatic
                              Child, HGroup,
                                    Child, g3, ->slmodulation
                                    Child, g4, ->chnegative
                              End,
                        End,
                        Child, gz,
                        Child, gy,
                  End,
            End,
            Child,RegisterGroup([Gs('Transposition'),Gs('Stereo'),Gs('Sample'),Gs('Misc'),NIL]),
                  MUIA_Register_Frame, MUI_TRUE,
                  ->MUIA_FrameTitle , Gs('Static Properties') ,
                  Child, gx,
                  Child, HGroup,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Stereo Setup') ,
                        Child, g5,
                        Child, g6,
                        Child, g7,
                  End,
                  Child,gw,
                  Child,gv,
            End,
            Child, EaterObject,
      End

      _inst.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Instrument Properties') ,
            MUIA_Window_ID , "8WIN" ,
            WindowContents , _inst.root ,
      End




/* instrument dsp sequence setting */
/* %instrumentdsp */


      _idsp.lvdspsequence := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Sequence') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
            End ,
      End
      _idsp.btadd := keybutton('\eI[6:31]  \euA\endd',"æ",0)
      _idsp.btinsert := keybutton('\eI[6:31] \euI\ennsert',"¡",0)
      _idsp.btdelete := keybutton('\euD\enelete',"ð",0)
      _idsp.btdeleteall := mysimplebutton( 'Delete All' )
      _idsp.st0 := lstring( {g1},'#0',9,0,cint2)
      _idsp.st1 := lstring( {g2},'#1',9,0,cint2)
      _idsp.st2 := lstring( {g3},'#2',9,0,cint2)
      _idsp.st3 := lstring( {g4},'#3',9,0,cint2)
      _idsp.st4 := lstring( {g5},'#4',9,0,cint2)
      _idsp.st5 := lstring( {g6},'#5',9,0,cint2)
      _idsp.st6 := lstring( {g7},'#6',9,0,cint2)
      _idsp.st7 := lstring( {g8},'#7',9,0,cint2)
      g9 := GroupObject ,
            MUIA_Frame , MUIV_Frame_Group ,
            MUIA_FrameTitle , Gs('DSP Init') ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , GroupObject ,
                  MUIA_Group_SameSize , MUI_TRUE ,
                  Child , g1,
                  Child , g2 ,
                  Child , g3 ,
                  Child , g4 ,
            End ,
            Child , GroupObject ,
                  MUIA_Group_SameSize , MUI_TRUE ,
                  Child , g5 ,
                  Child , g6 ,
                  Child , g7 ,
                  Child , g8 ,
            End ,
      End
      _idsp.lvavailabledsps := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Pool') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
            End ,
      End
      _idsp.chenablemod:=lcheck( {ga} ,'Enable',FALSE)
      _idsp.btsetup:=mysimplebutton('Setup...')
      _idsp.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _idsp.lvdspsequence ,
                  Child , GroupObject ,
                        MUIA_Weight , 80 ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Operations') ,
                        Child , _idsp.btadd ,
                        Child , HVSpace ,
                        Child , _idsp.btinsert ,
                        Child , HVSpace ,
                        Child , _idsp.btdelete ,
                        Child , _idsp.btdeleteall ,
                        Child , HVSpace ,
                        Child , g9 ,
                  End ,
                  Child , _idsp.lvavailabledsps ,
            End ,
            Child , GroupObject,
                  MUIA_Group_Horiz,MUI_TRUE,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Modifications') ,
                  Child, ga,
                  Child, HSpace(20),
                  Child, _idsp.btsetup,
            End ,
            Child, EaterObject,
            
      End

      _idsp.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Instrument DSP Sequence') ,
            MUIA_Window_ID , "12WI" ,
            WindowContents , _idsp.root ,
      End


ENDPROC

                  /*---------*/
                  /* %part 3 */
                  /*---------*/




PROC createpart3()


/* sample editor setup */
/* %sampleeditor */


      _smed.txslot := TextObject ,
            MUIA_Weight , 10 ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _smed.stname := lstring({g1}, 'Name')
      _smed.cysavefmt:= CycleObject ,
            MUIA_Weight,10,
            MUIA_Cycle_Entries , __savefmts ,Chain,
      End
      _smed.imleft := imgleft()
      _smed.imright := imgright()
      _smed.btfirst := keybutton('First',NIL,0,10)
      _smed.btlast := keybutton('Last',NIL,0,10)
      _smed.btpick := keybutton('\euP\enick...',"¶",0,10)
      _smed.editarea := SampleEdObject ,
            MUIA_Frame , MUIV_Frame_ReadList ,
      End

      _smed.przoom:=    PropObject ,
                        MUIA_Frame,MUIV_Frame_Prop,
                        MUIA_FixWidth,8,
                        MUIA_Prop_Entries,1024,
                        MUIA_Prop_Visible,1,
                        MUIA_Prop_First,0,
                  End
      _smed.proffset:=  PropObject ,
                        MUIA_Frame,MUIV_Frame_Prop,
                        MUIA_FixHeight,8,
                        MUIA_Prop_Entries,1,
                        MUIA_Prop_Visible,1,
                        MUIA_Prop_First,0,
                        MUIA_Prop_Horiz,MUI_TRUE,
                  End

      _smed.stbuffer := lstring({g2},'Frames',11,-1,cint1)
      _smed.strngstart := lstring({g3},'RngS',11,-1,cint1)
      _smed.strnglen := lstring({g4},'RngL',11,-1,cint1)
      _smed.stpitch := lstring({g5},'Rate',6,-1,cint1)
      _smed.btscan := keybutton('Scan',0,0,10)
      _smed.ch16bit := lcheck2( {g6} ,'16-bit',FALSE )
      _smed.chstereo := lcheck2( {g7} ,'Stereo',FALSE )
      _smed.btplaydisplay := keybutton('P\eul\enay',"£")
      _smed.btrangeall := keybutton('Range \euA\enll',"æ")
      _smed.btshowrange := mysimplebutton( 'Show Range' )
      _smed.btshowall := keybutton('\euS\enhow All',"ß")
      _smed.btzoomin := keybutton('Zoom \euI\enn',"¡")
      _smed.btzoomout := keybutton('Zoom \euO\enut',"ø")
      _smed.txdispsize := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      ga := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , Label( 'Display' ) ,
            Child , HSpace( 5 ),
            Child , _smed.btplaydisplay ,
            Child , _smed.btrangeall ,
            Child , _smed.btshowrange ,
            Child , _smed.btshowall ,
            Child , _smed.btzoomin ,
            Child , _smed.btzoomout ,
            Child , Label( 'Disp.Size' ) ,
            Child , _smed.txdispsize ,
      End
      _smed.btplayrange := mysimplebutton( 'Play' )
      _smed.btcopy := keybutton('\euC\enopy', "ç")
      _smed.btcut := keybutton('Cut',"×")
      _smed.btpaste := keybutton('Pas\eut\ene',"þ")
      _smed.btplace := mysimplebutton( 'Place' )
      _smed.btclear := mysimplebutton( 'Clear' )
      _smed.bterase := keybutton('\euE\enrase',"©")
      _smed.btreverse := mysimplebutton( 'Reverse' )
      gb := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , Label( 'Range' ) ,
            Child , HSpace( 5 ) ,
            Child , _smed.btplayrange ,
            Child , _smed.btcopy ,
            Child , _smed.btcut ,
            Child , _smed.btpaste ,
            Child , _smed.btplace ,
            Child , _smed.btclear ,
            Child , _smed.bterase ,
            Child , _smed.btreverse ,
      End
      _smed.cyloop := CycleObject ,
            MUIA_Cycle_Entries , __loops ,Chain,
      End
      _smed.cyediting := CycleObject ,
            MUIA_Cycle_Entries , __editing ,Chain,
            
      End
      _smed.btstepleft := mysimplebutton( '<1' )
      _smed.btstepright := mysimplebutton( '1>' )
      _smed.btmoveleft := mysimplebutton( '<Mov' )
      _smed.btmoveright := mysimplebutton( 'Mov>' )
      _smed.btfindleft := mysimplebutton( '<Find0' )
      _smed.btfindright := mysimplebutton( 'Find0>' )
      _smed.btstart := mysimplebutton( 'Start' )
      _smed.btend := mysimplebutton( 'End' )
      _smed.btaccept := mysimplebutton( 'ACCEPT' )

      _smed.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Sample') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _smed.txslot ,
                  Child , g1 ,
                  Child , _smed.cysavefmt,
                  Child , _smed.imleft ,
                  Child , _smed.imright ,
                  Child , _smed.btfirst ,
                  Child , _smed.btlast ,
                  Child , _smed.btpick ,
            End ,
            Child , HGroup ,
                  Child ,  _smed.editarea ,
                  Child , _smed.przoom ,
                  End ,
            Child , _smed.proffset,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Properties') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , g2 ,
                  Child , g3 ,
                  Child , g4 ,
                  Child , g5 ,
                  Child , _smed.btscan ,
                  Child , g6 ,
                  Child , g7 ,
            End ,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Operations') ,
                  Child , ga ,
                  Child , gb ,
            End ,
            /*Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , Label ( 'LoopEd' ) ,
                  Child , HSpace (5) ,
                  Child , _smed.cyloop ,
                  Child , _smed.cyediting ,
                  Child , _smed.btstepleft ,
                  Child , _smed.btstepright ,
                  Child , _smed.btmoveleft ,
                  Child , _smed.btmoveright ,
                  Child , _smed.btfindleft ,
                  Child , _smed.btfindright ,
                  Child , _smed.btstart ,
                  Child , _smed.btend ,
                  Child , _smed.btaccept ,
            End , TEMPORARILY DISABLED */
            Child, EaterObject,
      End


/* sample editor menu setup */
/* %sampleedmenu */


      _smme.load        :=    lmenu ('Load...')
      _smme.loadfromlist      :=    lmenu('Load From List...',Gs('L'))
      _smme.save        :=    lmenu('Save',Gs('S'))
      _smme.saveas            :=    lmenu('Save As...')
      _smme.flush             :=    lmenu( 'Flush' )
      _smme.quit        :=    lmenu('Quit Editor',Gs('Q'))
      _smme._project:=MenuitemObject ,
                  MUIA_Menuitem_Title , Gs('Project') ,
                  MUIA_Family_Child , _smme.load ,
                  MUIA_Family_Child , _smme.loadfromlist ,
                  MUIA_Family_Child , _smme.save ,
                  MUIA_Family_Child , _smme.saveas ,
                  MUIA_Family_Child , _smme.flush ,
                  MUIA_Family_Child , _smme.quit ,
                  End
      _smme.invert            :=    lmenu('Invert')
      _smme.centralize  :=    lmenu('Centralize')
      _smme.signedunsigned    :=    lmenu('Signed/Unsigned')
      _smme.swapbyteorder     :=    lmenu('Swap Byte Order')
      _smme.mpegdecoder       :=    lmenu('MPEG Audio Decoder...')

      _smme._tools := MenuitemObject ,
                  MUIA_Menuitem_Title , Gs('Tools') ,
                  MUIA_Family_Child , _smme.invert ,
                  MUIA_Family_Child , _smme.centralize ,
                  MUIA_Family_Child , _smme.signedunsigned ,
                  MUIA_Family_Child , _smme.swapbyteorder ,
                  MUIA_Family_Child , BarLabel,
                  MUIA_Family_Child , _smme.mpegdecoder,
      End

      _smme.changevolume      :=    lmenu('Change volume...',Gs('V'))
      _smme.changepitch       :=    lmenu('Change Pitch')
      _smme.makechord   :=    lmenu('Make Chord')

      _smme._effects := MenuitemObject ,
                  MUIA_Menuitem_Title , Gs('Effects') ,
                  MUIA_Family_Child , _smme.changevolume ,
                  MUIA_Family_Child , _smme.changepitch ,
                  MUIA_Family_Child , _smme.makechord ,
      End



/* rubbbiiiiiishhhh  

      myapp2.mnSedInterpolation := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Interpolation') ,
            MUIA_Menuitem_Checkit , MUI_TRUE ,
            MUIA_Menuitem_Checked , MUI_TRUE ,
            MUIA_Menuitem_Toggle , MUI_TRUE ,
      End    */


      _smme._settings := MenuitemObject ,
            MUIA_Menuitem_Title ,Gs('Settings') ,
            -> MUIA_Family_Child , myapp2.mnSedInterpolation ,
      End
      _smme.base      := MenustripObject ,
            MUIA_Family_Child , _smme._project ,
            MUIA_Family_Child , _smme._tools ,
            MUIA_Family_Child , _smme._effects ,
            MUIA_Family_Child , _smme._settings ,
      End

      _smed.base  := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Sample Editor') ,
            MUIA_Window_Menustrip , _smme.base ,
            MUIA_Window_ID , "13WI" ,
            WindowContents , _smed.root ,
      End



/* wave editor window setup  */
/* %waveeditor */


        _wved.txslot := TextObject ,
                MUIA_Weight , 10 ,
                MUIA_Background , MUII_TextBack ,
                MUIA_Frame , MUIV_Frame_Text ,
                MUIA_Text_SetMin , MUI_TRUE ,
        End
        _wved.stname := lstring({g1},'Name')
        _wved.imleft := imgleft()
        _wved.imright := imgright()
        _wved.btfirst := keybutton('First',0,0,10)
        _wved.btlast := keybutton('Last',0,0,10)
        _wved.btpick := keybutton('\euP\enick...',"¶",0,10)
        _wved.btcopyfromtemp := mysimplebutton( 'Copy From Temp' )
        _wved.btcopytotemp := mysimplebutton( 'Copy To Temp' )
        _wved.btdouble := mysimplebutton( 'Double' )
        _wved.bthalve := mysimplebutton( 'Halve' )
        _wved.cysize := CycleObject ,
                MUIA_Cycle_Entries , __wsizes ,Chain,
        End
        _wved.btstretch := mysimplebutton( 'STRETCH' )
        _wved.btmixwithtemp := mysimplebutton( 'Mix With Temp' )
        _wved.btaddtemp := mysimplebutton( 'Add Temp' )
        _wved.btdoubletemp := mysimplebutton( 'Double Temp' )
        _wved.bthalvetemp := mysimplebutton( 'Halve Temp' )


        _wved.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Wave') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _wved.txslot ,
                  Child , g1 ,
                  Child , _wved.imleft ,
                        Child , _wved.imright ,
                        Child , _wved.btfirst ,
                  Child , _wved.btlast ,
                      Child , _wved.btpick ,
             End,
                Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Operations') ,
                        Child , GroupObject ,
                            MUIA_Group_Horiz , MUI_TRUE ,
                        Child , _wved.btcopyfromtemp ,
                          Child , _wved.btcopytotemp ,
                                    Child , _wved.btdouble ,
                              Child , _wved.bthalve ,
                              Child , HSpace(5) ,
                              Child , Label( 'Stretch Size' ) ,
                              Child , _wved.cysize ,
                              Child , _wved.btstretch ,
                    End ,
                  Child , GroupObject ,
                       MUIA_Group_Horiz , MUI_TRUE ,
                            Child , _wved.btmixwithtemp ,
                            Child , _wved.btaddtemp ,
                            Child , _wved.btdoubletemp ,
                            Child , _wved.bthalvetemp ,
                   End ,
                  End ,
                
                Child, EaterObject,
        End


/* wave editor menu */
/* %waveedmenu */


        _wvme.load := lmenu('Load...')
        _wvme.loadfromlist := lmenu('Load From List...', Gs('L'))
        _wvme.save := lmenu('Save',Gs( 'S'))
        _wvme.saveas := lmenu('Save As...') 
        _wvme.flush := lmenu('Flush') 
        _wvme.quit := lmenu ( 'Quit Editor' , Gs('Q') )

        _wvme._project := MenuitemObject ,
                MUIA_Menuitem_Title , Gs('Project') ,
                MUIA_Family_Child , _wvme.load ,
                MUIA_Family_Child , _wvme.loadfromlist ,
                MUIA_Family_Child , _wvme.save ,
                MUIA_Family_Child , _wvme.saveas ,
                MUIA_Family_Child , _wvme.flush ,
                MUIA_Family_Child , _wvme.quit ,
        End

        _wvme.base := MenustripObject ,
                MUIA_Family_Child , _wvme._project ,
        End

        _wved.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
                MUIA_Window_Title , Gs('Wave Editor') ,
                MUIA_Window_Menustrip , _wvme.base ,
                MUIA_Window_ID , "14WI" ,
                WindowContents , _wved.root ,
        End



/* play options setup */
/* % playoptions */



        _popt.txaudiomode := TextObject ,
                MUIA_Background , MUII_TextBack ,
                MUIA_Frame , MUIV_Frame_Text ,
                MUIA_Text_SetMin , MUI_TRUE ,
        End
        _popt.btpick := keybutton('\euP\enick...',"¶",0,10)
        _popt.stmixfreq := lstring ({g1},'Requested',6,-1,cint1)
        _popt.txactual := TextObject ,
                MUIA_Weight , 50 ,
                MUIA_Background , MUII_TextBack ,
                MUIA_Frame , MUIV_Frame_Text ,
                MUIA_Text_SetMin , MUI_TRUE ,
        End
        _popt.cypresets := CycleObject ,
                MUIA_Weight , 50 ,
                MUIA_Cycle_Entries , __presets ,Chain,
        End
        ga := GroupObject ,
                MUIA_Group_Horiz , MUI_TRUE ,
                Child , g1 ,
                Child , HSpace(20) ,
                Child , TextObject ,
                  MUIA_Text_PreParse , '\er' ,
                  MUIA_Text_Contents , 'Actual' ,
                  MUIA_Weight , 50 ,
                  MUIA_InnerLeft , 0 ,
                  MUIA_InnerRight , 0 ,
              End ,
                Child , _popt.txactual ,
                Child , HSpace(20) ,
                Child , TextObject ,
                  MUIA_Text_PreParse , '\er' ,
                  MUIA_Text_Contents , 'Presets' ,
                          MUIA_Weight , 50 ,
                        MUIA_InnerLeft , 0 ,
                          MUIA_InnerRight , 0 ,
              End ,
                Child , _popt.cypresets ,
        End

        _popt.slmixfreq := lslider({g2},'',2000,65535,44100)
        _popt.sltimeres := lslider({g3},'Time Resolution',1,10,1)
        _popt.chmonomode := lcheck({g4}, 'Mono Mode',FALSE )

        _popt.root := GroupObject ,
                  MUIA_Background,MUII_GroupBack,
                Child , GroupObject ,
                    MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Audio Mode') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _popt.txaudiomode ,
                  Child , _popt.btpick ,
              End ,
                Child , GroupObject ,
                    MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('MixFreq') ,
                  Child , ga ,
                  Child , g2 ,
            End ,
                Child , g3 ,
                Child , GroupObject ,
                           MUIA_Frame , MUIV_Frame_Group ,
                     MUIA_FrameTitle , Gs('Mixing Shortcuts') ,
                             MUIA_Group_Horiz , MUI_TRUE ,
                             Child , g4 ,
                       Child , HVSpace ,
              End ,
            Child, EaterObject,
        End

      _popt.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
                MUIA_Window_Title , Gs('Play Options') ,
                MUIA_Window_ID , "15WI" ,
                WindowContents , _popt.root ,
        End



ENDPROC




                  /*---------*/
                        /* %part 4 */
                        /*---------*/





PROC createpart4()

/* pick instrument */
/* %pickinstr */


      _pcki.lv := ListviewObject ,
            MUIA_FrameTitle , Gs('Instrument Pool') ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List ,ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End

      _pcki.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , _pcki.lv ,
            Child, EaterObject,
      End

      _pcki.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Pick Instrument') ,
            MUIA_Window_ID , "16WI" ,
            WindowContents , _pcki.root ,
      End


/* pick sample */
/* %picksample */


      _pcks.lv := ListviewObject ,
            MUIA_FrameTitle , Gs('Sample Pool') ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List ,ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End

      _pcks.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , _pcks.lv ,
            Child, EaterObject,
      End

      _pcks.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Pick Sample') ,
            MUIA_Window_ID , "17WI" ,
            WindowContents , _pcks.root ,
      End



/* pick wave */
/* %pickwave */


      _pckw.lv := ListviewObject ,
            MUIA_FrameTitle , Gs('Wave Pool') ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List ,ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End

      _pckw.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , _pckw.lv ,
            Child, EaterObject,
      End

      _pckw.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Pick Wave') ,
            MUIA_Window_ID , "18WI" ,
            WindowContents , _pckw.root ,
      End



/* pick track */
/* %picktrack */


      _pckt.lv := ListviewObject ,
            MUIA_FrameTitle , Gs('Track Pool') ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List ,ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End

      _pckt.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , _pckt.lv ,
            Child, EaterObject,
      End

      _pckt.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Pick Track') ,
            MUIA_Window_ID , "19WI" ,
            WindowContents , _pckt.root ,
      End



/* load from list */
/* %loadfromlist */


      _lofl.cytype := CycleObject ,
            MUIA_ControlChar , "þ" ,
            MUIA_Cycle_Entries , __lists ,Chain,
      End
      _lofl.lvitems := ListviewObject ,
            MUIA_FrameTitle , Gs('Items') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End
      _lofl.lvdirectories := ListviewObject ,
            MUIA_FrameTitle , Gs('Directories') ,
            MUIA_Listview_List ,ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End  ,
      End
      _lofl.txslot := TextObject ,
            MUIA_Weight , 10 ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _lofl.txname := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End

      _lofl.imleft := imgleft()
      _lofl.imright := imgright()
      _lofl.btfirst := keybutton('F\eui\enrst',"¡",0,10)
      _lofl.btlast := keybutton('\euL\enast',"£",0,10)
      _lofl.btpick := keybutton('\euP\enick...',"¶",0,10)

      _lofl.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , _lofl.cytype ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _lofl.lvitems ,
                  Child , HSpace(10) ,
                  Child , _lofl.lvdirectories ,
            End ,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Slot') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _lofl.txslot ,
                  Child , _lofl.txname ,
                  Child , _lofl.imleft ,
                  Child , _lofl.imright ,
                  Child , _lofl.btfirst ,
                  Child , _lofl.btlast ,
                  Child , _lofl.btpick ,
            End ,
            Child, EaterObject,
      End

      _lofl.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Load From List') ,
            MUIA_Window_ID , "20WI" ,
            WindowContents , _lofl.root ,
      End



/* list editor setup */
/* %listeditor */


      _lied.cytype := CycleObject ,
            MUIA_ControlChar , "þ" ,
            MUIA_Cycle_Entries , __lists ,Chain,
      End
      _lied.lvitems := ListviewObject ,
            MUIA_FrameTitle , Gs('Items') ,
            MUIA_Listview_List ,ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End
      _lied.lvdirs := ListviewObject ,
            MUIA_FrameTitle , Gs('Directories') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
      End
      _lied.btaddcuritem := keybutton('Add\euC\enurItem',"ç")
      _lied.btinscuritem := mysimplebutton( 'InsertCurItem' )
      _lied.btdelitem := keybutton('\euD\eneleteItem', "ð")
      _lied.btadddir := keybutton('\euA\enddDir',"æ")
      _lied.btinsdir := keybutton('I\eun\ensertDir',"­")
      _lied.btdeldir := keybutton('D\eue\enleteDir',"©")
      _lied.btclear := mysimplebutton( 'CLR' )
      _lied.btsavelist := mysimplebutton( 'SAVE' )
      _lied.txslot := TextObject ,
            MUIA_Weight , 10 ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _lied.txname := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _lied.imleft := imgleft()
      _lied.imright := imgright()
      _lied.btfirst := keybutton('F\eui\enrst',"¡",0,10)
      _lied.btlast := keybutton('\euL\enast',"£",0,10)
      _lied.btpick := keybutton('\euP\enick...',"¶",0,10)

      _lied.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , _lied.cytype ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _lied.lvitems ,
                  Child , HSpace(10) ,
                  Child , _lied.lvdirs ,
            End ,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Operations') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _lied.btaddcuritem ,
                  Child , _lied.btinscuritem ,
                  Child , _lied.btdelitem ,
                  Child , _lied.btadddir ,
                  Child , _lied.btinsdir ,
                  Child , _lied.btdeldir ,
                  Child , _lied.btclear ,
                  Child , _lied.btsavelist ,
            End ,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Slot') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _lied.txslot ,
                  Child , _lied.txname ,
                  Child , _lied.imleft ,
                  Child , _lied.imright ,
                  Child , _lied.btfirst ,
                  Child , _lied.btlast ,
                  Child , _lied.btpick ,
            End ,
            Child, EaterObject,
      End

      _lied.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Instr/Smpl/Wave List Editor') ,
            MUIA_Window_ID , "21WI" ,
            WindowContents , _lied.root ,
      End


/* changevolume  */
/* %changevolume */


      _cvol.slvolume := lslider({g1},'Volume (1/256)',0,2048,256)
      _cvol.btchange := keybutton('\euC\enhange Volume',"ç")
      _cvol.btdouble := keybutton('\euD\enouble',"ð")
      _cvol.bthalve := keybutton('H\eua\enlve',"æ")
      _cvol.btmaximum:= keybutton('\euM\enaximum volume',"¸")

      _cvol.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , g1 ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _cvol.btchange ,
                  Child , _cvol.btdouble ,
                  Child , _cvol.bthalve ,
                  Child , _cvol.btmaximum,
            End ,
            Child, EaterObject,
      End

      _cvol.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Change Volume') ,
            MUIA_Window_ID , "22WI" ,
            MUIA_Window_NoMenus , MUI_TRUE ,
            WindowContents , _cvol.root ,
      End


/* change pitch widow setup*/
/* %changepitch */



      _cpit.stsource := lstring({g1},'',6,-1,cint1)
      _cpit.btscans := mysimplebutton( 'Scan' )
      _cpit.stdest := lstring({g2},'',6,-1,cint1)
      _cpit.btscand := mysimplebutton( 'Scan' )
      _cpit.btchange := keybutton('\euC\enhange Pitch',"ç")
      _cpit.btoctup := keybutton('Octave \euU\enp',"µ")
      _cpit.btoctdown := keybutton('Octave \euD\enown',"ð")

      _cpit.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Source') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , g1 ,
                  Child , _cpit.btscans ,
            End ,
            Child , GroupObject ,
                  MUIA_Frame , MUIV_Frame_Group ,
                  MUIA_FrameTitle , Gs('Destination') ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , g2 ,
                  Child , _cpit.btscand ,
            End ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _cpit.btchange ,
                  Child , _cpit.btoctup ,
                  Child , _cpit.btoctdown ,
            End ,
            Child, EaterObject,
      End

      _cpit.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Change Pitch') ,
            MUIA_Window_ID , "23WI" ,
            MUIA_Window_NoMenus , MUI_TRUE ,
            WindowContents , _cpit.root ,
      End



/* create chord window setup */
/* %createchord */


      _crch.sl2nd := lslider ({g1},'2nd Tone Offset',-16,16,0)
      _crch.sl3rd := lslider ({g2},'3rd Tone Offset',-16,16,0)
      _crch.sl4th := lslider ({g3},'4th Tone Offset',-16,16,0)
      _crch.btcreate := keybutton('\euC\enreate Chord',"ç")

      _crch.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , g1 ,
            Child , g2 ,
            Child , g3 ,
            Child , _crch.btcreate ,
            Child, EaterObject,
      End

      _crch.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Chord Creation') ,
            MUIA_Window_ID , "24WI" ,
            MUIA_Window_NoMenus , MUI_TRUE ,
            WindowContents , _crch.root ,
      End


/* transpose window setup */
/* %transpose */


      _tran.cyapplyto := CycleObject ,
            MUIA_Cycle_Entries , __transposes ,Chain,
      End

      _tran.sllevel := lslider({g1},'Transpose Level',-32,32,0)
      _tran.bttranspose := keybutton('\euT\enranspose',"þ")
      _tran.btoctup := keybutton('Octave \euU\enp',"µ")
      _tran.btoctdown := keybutton('Octave \euD\enown',"ð")

      _tran.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , Label( 'Apply To' ) ,
                  Child , _tran.cyapplyto ,
            End ,
            Child , g1 ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _tran.bttranspose ,
                  Child , _tran.btoctup ,
                  Child , _tran.btoctdown ,
            End ,
            Child, EaterObject,
      End

      _tran.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Transposition') ,
            MUIA_Window_ID , "25WI" ,
            MUIA_Window_NoMenus , MUI_TRUE ,
            WindowContents , _tran.root ,
      End


/* dsp manager window setup */
/* %dspmanager */


      _dspm.lvdsps := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Pool') ,
            MUIA_Listview_Input , TRUE ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
             End ,
      End

      _dspm.lvinfo2 := FloattextObject,
                  MUIA_Frame , MUIV_Frame_ReadList ,  
                  MUIA_Floattext_TabSize,4,
                  MUIA_Floattext_Justify,MUI_TRUE,
                  End

      _dspm.lvinfo := ListviewObject ,
            MUIA_FrameTitle , Gs('Info') ,
            MUIA_Listview_List, _dspm.lvinfo2,
            MUIA_Listview_Input,FALSE,
      End

      _dspm.btload := keybutton('\euL\enoad DSP...',"£")
      _dspm.btflush := keybutton('Fl\euu\ensh',"µ")
      _dspm.btflushall := mysimplebutton( 'Flush All...' )

      _dspm.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child,VGroup,
                  MUIA_Frame,MUIV_Frame_Group,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _dspm.lvdsps ,
                  Child , GroupObject ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Operations') ,
                        MUIA_Weight , 50,
                        Child , HVSpace ,
                        Child , _dspm.btload ,
                        Child , HVSpace ,
                        Child , _dspm.btflush ,
                        Child , HVSpace ,
                        Child , _dspm.btflushall ,
                        Child , HVSpace ,
                  End ,
                  
            End ,
            End,
            
            Child, _dspm.lvinfo,
            Child, EaterObject,
      End

      _dspm.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('DSP Manager') ,
            MUIA_Window_ID , "30WI" ,
            WindowContents , _dspm.root ,
      End



/* track editor window setup */
/* %trackeditor */


      _tred.txslot := TextObject ,
            MUIA_Weight , 10 ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End
      _tred.stname := lstring({g1},'Name')
      _tred.imleft := imgleft()
      _tred.imright := imgright()
      _tred.btfirst := keybutton('F',0,0,10)
      _tred.btlast := keybutton('L',0,0,10)
      _tred.btpick := keybutton('\euP',"¶",0,10)
      _tred.chedit := KeyCheckMark( FALSE , "`" )

      _tred.chedit:=KeyCheckMark( FALSE , "`" )
      g2 := GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , KeyLabel2( 'Edit' , "`" ),
            Child , _tred.chedit ,
      End
      _tred.chspc := KeyCheckMark( FALSE , "~" )
      g3 := GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , KeyLabel2( 'Spc' , "~" ) ,
            Child , _tred.chspc ,
      End
      _tred.cyoct := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries , [
                  Gs('1/2') ,
                  Gs('2/3') ,
                  Gs('3/4') ,
                  Gs('4/5') ,
                  Gs('5/6') ,
                  NIL ] ,
      End
      _tred.cyted := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries ,[
                  Gs('1 Chan') ,
                  Gs('2 Chans') ,
                  Gs('3 Chans') ,
                  Gs('4 Chans') ,
                  NIL ] ,
      End

      _tred.cycom := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries , [
                  Gs('1 CL'),
                  Gs('2 CLs'),
                  Gs('3 CLs'),
                  Gs('4 CLs'),
                  Gs('5 CLs'),
                  Gs('6 CLs'),
                  Gs('7 CLs'),
                  Gs('8 CLs'),NIL ] ,
      End

      -> channel #0

      _tred.sttempo0 := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries ,__tempoctypes,
      End

      _tred.stlines0 := lstring({g5},'',4,-1,cint1)
      _tred.chon0 := KeyCheckMark( MUI_TRUE , "(" )
      g6 := GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , KeyLabel2( '' , "(" ) ,
            Child , _tred.chon0 ,
      End
      ga := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , _tred.sttempo0 ,
            Child , g5 ,
            Child , g6 ,
      End
      _tred.lv0 := EditorObject ,
            MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_Font,MUIV_Font_Fixed,
            End ,
      End
      _tred.st0 := EffObject ,
            MUIA_Frame , MUIV_Frame_String ,
            MUIA_String_MaxLen , 20 ,
            MUIA_String_AttachedList, _tred.lv0,
      End

      -> channel #1

      _tred.sttempo1 := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries ,__tempoctypes,
      End
      _tred.stlines1 := lstring({g5},'',4,-1,cint1)
      _tred.chon1 := KeyCheckMark( MUI_TRUE , ")" )
      g6 := GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , KeyLabel2( '' , ")" ) ,
            Child , _tred.chon1 ,
      End
      gb := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , _tred.sttempo1 ,
            Child , g5 ,
            Child , g6 ,
      End
      _tred.lv1 := EditorObject ,
            MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_Font,MUIV_Font_Fixed,
            End ,
      End
      _tred.st1 := EffObject ,
            MUIA_Frame , MUIV_Frame_String ,
            MUIA_String_MaxLen , 20 ,
            MUIA_String_AttachedList, _tred.lv1,
      End

      -> channel #2

      _tred.sttempo2 := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries ,__tempoctypes,
      End
      _tred.stlines2 := lstring({g5},'',4,-1,cint1)
      _tred.chon2 := KeyCheckMark( MUI_TRUE , "/" )
      g6 := GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , KeyLabel2( '' , "/" ) ,
            Child , _tred.chon2 ,
      End
      gc := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , _tred.sttempo2 ,
            Child , g5 ,
            Child , g6 ,
      End
      _tred.lv2 := EditorObject ,
            MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_Font,MUIV_Font_Fixed,
            End ,
      End
      _tred.st2 := EffObject ,
            MUIA_Frame , MUIV_Frame_String ,
            MUIA_String_MaxLen , 20 ,
            MUIA_String_AttachedList, _tred.lv2,
      End

      -> channel #3

      _tred.sttempo3 := CycleObject ,
            MUIA_Weight , 10 ,
            MUIA_Cycle_Entries ,__tempoctypes,
      End
      _tred.stlines3 := lstring({g5},'',4,-1,cint1)
      _tred.chon3 := KeyCheckMark( MUI_TRUE , "*" )
      g6 := GroupObject ,
            MUIA_Group_Columns , 2 ,
            Child , KeyLabel2( '' , "*" ) ,
            Child , _tred.chon3 ,
      End
      gd := GroupObject ,
            MUIA_Group_Horiz , MUI_TRUE ,
            Child , _tred.sttempo3 ,
            Child , g5 ,
            Child , g6 ,
      End
      _tred.lv3 := EditorObject ,
            MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_Font,MUIV_Font_Fixed,
            End ,
      End
      _tred.st3 := EffObject ,
            MUIA_Frame , MUIV_Frame_String ,
            MUIA_String_MaxLen , 20 ,
            MUIA_String_AttachedList, _tred.lv3,
      End

      _tred.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _tred.txslot ,
                  Child , g1 ,
                  Child , _tred.imleft ,
                  Child , _tred.imright ,
                  Child , _tred.btfirst ,
                  Child , _tred.btlast ,
                  Child , _tred.btpick ,
                  Child , g2 ,
                  Child , g3 ,
                  Child , _tred.cyoct ,
                  Child , _tred.cycom ,
                  Child , _tred.cyted ,
            End ,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  MUIA_Frame,MUIV_Frame_Group ,
                  Child , GroupObject ,
                        ->MUIA_Frame , MUIV_Frame_Group ,
                        ->MUIA_FrameTitle , Gs('#0') ,
                        ->MUIA_Background, MUII_GroupBack,
                        Child , ga ,
                        Child , _tred.lv0 ,
                        Child , _tred.st0 ,
                  End ,
                  Child, balance(),
                  Child , GroupObject ,
                        ->MUIA_Frame , MUIV_Frame_Group ,
                        ->MUIA_FrameTitle , Gs('#1') ,
                        ->MUIA_Background, MUII_GroupBack,
                        Child , gb ,
                        Child , _tred.lv1 ,
                        Child , _tred.st1 ,
                  End ,
                  Child, balance(),
                  Child , GroupObject ,
                        ->MUIA_Frame , MUIV_Frame_Group ,
                        ->MUIA_FrameTitle , Gs('#2') ,
                        ->MUIA_Background, MUII_GroupBack,
                        Child , gc ,
                        Child , _tred.lv2 ,
                        Child , _tred.st2 ,
                  End ,
                  Child, balance(),
                  Child , GroupObject ,
                        ->MUIA_Frame , MUIV_Frame_Group ,
                        ->MUIA_FrameTitle , Gs('#3') ,
                        ->MUIA_Background, MUII_GroupBack,
                        Child , gd ,
                        Child , _tred.lv3 ,
                        Child , _tred.st3 ,
                  End ,
            End ,
            Child , EaterObject,
      End

      _tred.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Track Editor') ,
            MUIA_Window_ID , "31WI" ,
            WindowContents , _tred.root ,
      End



/* track options window setup */
/* %trackoptions */



      _trop.slleft:=lknob({g1},'Left',0,1024,256)
      _trop.slright:=lknob({g2},'Right',0,1024,256)
      _trop.sltempoc:=lslider({g3}, 'Tempo',1,400,100,'%ld%%')
      _trop.chusedsp:=lcheck({g4},'Enabled',FALSE)
      _trop.btdsp:=mysimplebutton('Edit...')
      _trop.chexclude:=lcheck({g5},'Exclude From Song DSP',FALSE)
      _trop.root := GroupObject,
                  MUIA_Background,MUII_GroupBack,
                  Child ,HGroup,
                        Child, HGroup ,
                              MUIA_Frame , MUIV_Frame_Group ,
                              MUIA_FrameTitle , Gs('Volume') ,
                              Child, g1,
                              Child, g2,
                              End ,
                        Child,GroupObject,
                              Child , g3, 
                              
                              Child, HGroup ,
                                    MUIA_Frame , MUIV_Frame_Group ,
                                    MUIA_FrameTitle , Gs('DSP Sequence') ,
                                    Child, g4,
                                    Child, HSpace(10),
                                    Child, _trop.btdsp ,
                                    End,
                              Child , g5,
                              End ,
                        End ,
                  
                  Child , EaterObject,
      End

      _trop.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Track Options') ,
            MUIA_Window_ID , "32WI" ,
            WindowContents , _trop.root ,
      End


/* section editor setup */
/* %sectioneditor */
      


      _sect.txslot := TextObject ,
            MUIA_Weight , 20 ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_Text_SetMin , MUI_TRUE ,
      End

      _sect.stname := lstring({g1},'Name')

      _sect.btfirst := keybutton('F\eui\enrst',"¡",FALSE,20)
      _sect.btlast := keybutton('\euL\enast',"£",FALSE,20)
      _sect.btdel := keybutton('\euD\enel', "ð",FALSE,20)
      _sect.btnew := keybutton('\euN\enew',"­",FALSE,20)
      _sect.btplay := keybutton('\euP\enlay',"¶",FALSE,20)
      _sect.imleft:=imgleft()
      _sect.imright:=imgright()


      _sect.lv1 := ListviewObject ,
            MUIA_FrameTitle , Gs('Pos:Rep') ,
            MUIA_Dropable,MUI_TRUE,
            MUIA_Listview_DragType, 1,
            MUIA_Listview_DoubleClick , MUI_TRUE ,Chain,
            MUIA_Listview_List , DSListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_List_DragSortable , MUI_TRUE,
                  MUIA_UserData,hooks.sect_dragdrop,
                  End ,
      End

      _sect.btdelpos := mysimplebutton( 'Del' )
      _sect.rplus := mysimplebutton( 'R+' )
      _sect.rminus := mysimplebutton( 'R-' )
      _sect.btnewpos := mysimplebutton( 'New' )
      _sect.btinspos := mysimplebutton( 'Insert' )

      _sect.lv2 := ListviewObject ,
            MUIA_FrameTitle , Gs ('Used Tracks') ,
            MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,Chain,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  End ,
      End

      _sect.btdeltrack := mysimplebutton( 'DelT' )
      _sect.btaddtrack := keybutton('\euA\enddT',"æ")
      _sect.btclear := mysimplebutton( 'Clr' )
      _sect.playtracks := keybutton( 'Pla\euy\en',"±" )
      _sect.btcopy := mysimplebutton( '->Buf' )
      _sect.btpaste := mysimplebutton( 'Buf->' )

      _sect.lv3 := ListviewObject ,
            MUIA_FrameTitle , Gs('Track Pool') ,
            MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
            MUIA_Listview_DoubleClick , MUI_TRUE ,Chain,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  End ,
      End


      g2 := HGroup ,
            MUIA_Frame , MUIV_Frame_Group ,
            Child , GroupObject ,
                  MUIA_Weight , 50 ,
                  Child , _sect.lv1 ,
                  Child , HGroup ,
                        Child , _sect.btdelpos ,
                        Child , _sect.rplus ,
                        Child , _sect.rminus ,
                        End ,
                  Child , HGroup ,
                        Child , _sect.btnewpos ,
                        Child , _sect.btinspos ,
                        End ,
                  End ,
            Child , balance(),
            Child , GroupObject ,
                  Child , _sect.lv2 ,
                  Child , HGroup ,
                        Child , _sect.btdeltrack ,
                        Child , _sect.btaddtrack ,
                        Child , _sect.btclear ,
                        End ,
                  Child , HGroup ,
                        Child , _sect.playtracks ,
                        Child , _sect.btcopy ,
                        Child , _sect.btpaste ,
                        End ,
                  End ,
            Child , balance(),
            Child , GroupObject ,
                  Child , _sect.lv3 ,
                  End ,
      End

      _sect.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _sect.txslot ,
                  Child , g1 ,
                  Child , _sect.imleft,
                  Child , _sect.imright,  
                  Child , _sect.btfirst ,
                  Child , _sect.btlast ,
                  Child , _sect.btdel ,
                  Child , _sect.btnew ,
                  Child , _sect.btplay ,
                  End ,
            Child , g2 ,
            Child , EaterObject ,
      End

      _sect.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Section Editor') ,
            MUIA_Window_ID , "33WI" ,
            WindowContents , _sect.root ,
      End





ENDPROC


                  /*---------*/
                        /* %part 5 */
                        /*---------*/


PROC createpart5()


/* track dsp sequence window setup */
/* %trackdsp */

      _tdsp.lvdspsequence := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Sequence') ,
            MUIA_Dropable,MUI_TRUE,
            MUIA_Listview_DragType, 1,
            MUIA_Listview_List , DSListObject ,
                  MUIA_Frame , MUIV_Frame_InputList ,
                  MUIA_List_DisplayHook, hooks.tdsp_disphook,
                  MUIA_List_Format,Gs('MIW=10 P=\e8 BAR,MIW=70 BAR,MIW=20 P=\er'),
                  MUIA_List_Title,MUI_TRUE,
                  MUIA_List_DragSortable , MUI_TRUE,
                  MUIA_UserData,hooks.tdsp_dragdrop,
            End ,
            Chain ,

      End
      _tdsp.btadd := keybutton('\eI[6:31]  \euA\endd',"æ",0)
      _tdsp.btinsert := keybutton('\eI[6:31] \euI\ennsert',"¡",0)
      _tdsp.btdelete := keybutton('\euD\enelete',"ð",0)
      _tdsp.btdeleteall := mysimplebutton( 'Delete All' )
      _tdsp.lvdsppool := ListviewObject ,
            MUIA_FrameTitle , Gs('DSP Pool') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
            Chain ,
      End

      _tdsp.lvparams := ListviewObject ,
            MUIA_Weight,50,
            MUIA_FrameTitle , Gs('Parameters') ,
            MUIA_Listview_List , ListObject ,
                  MUIA_Frame , MUIV_Frame_ReadList ,
            End ,
            Chain ,
      End

      _tdsp.sloffset:=lslider({g1},'Offset',-256,256,0)
      _tdsp.slcoef:=lslider({g2},'Coef',-1024,1024,256,'%ld/256')
      _tdsp.stoffset:=StringObject,
            MUIA_Frame,MUIV_Frame_String,
            MUIA_String_Accept,cint2,
            MUIA_String_MaxLen,7,
            MUIA_String_Integer,0,
            MUIA_Weight,25,
            MUIA_String_AdvanceOnCR,MUI_TRUE,
            Chain,
            End

      _tdsp.stcoef:=StringObject,
            MUIA_Frame,MUIV_Frame_String, 
            MUIA_String_Accept,cint2,
            MUIA_String_MaxLen,7,
            MUIA_String_Integer,256,
            MUIA_Weight,25,
            MUIA_String_AdvanceOnCR,MUI_TRUE,
            Chain,
            End
      _tdsp.txparam:=TextObject,
                  ->MUIA_Background , MUII_TextBack ,
                  ->MUIA_Frame , MUIV_Frame_Text ,
                  MUIA_Text_SetMin,MUI_TRUE,
                  MUIA_Text_PreParse,ccenter,
                  End

      _tdsp.cylfotype:=CycleObject,
            MUIA_Cycle_Entries ,__lfotypes ,
            MUIA_Weight ,10 ,
            Chain,
      End

      _tdsp.sllfoper:=lnumeric({g3},'Period',5,300,50,'%ld/5s')
      _tdsp.chtempo:=lcheck({g4},'Parameter Depends On Tempo',FALSE)
      _tdsp.chlfo:=lcheck({g5},'LFO',FALSE)
      _tdsp.chlfotempo:=lcheck({g6},'By Lines',FALSE)
      

      _tdsp.cyccassign:=CycleObject,
            MUIA_Cycle_Entries,__ccassigns,
            Chain,End

      _tdsp.root := GroupObject ,
            MUIA_Background,MUII_GroupBack,
            Child , GroupObject ,
                  MUIA_Group_Horiz , MUI_TRUE ,
                  Child , _tdsp.lvdspsequence ,
                  Child , GroupObject ,
                        MUIA_Weight , 80 ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , Gs('Operations') ,
                        Child , _tdsp.btadd ,
                        Child , HVSpace ,
                        Child , _tdsp.btinsert ,
                        Child , HVSpace ,
                        Child , _tdsp.btdelete ,
                        Child , _tdsp.btdeleteall ,
                        Child , HVSpace ,
                        Child , Label ('\ecCmd Assign:'),
                        Child ,_tdsp.cyccassign,
                        Child, HVSpace,
                  End ,
                  Child , _tdsp.lvdsppool ,
            End ,
            Child , HGroup,
                  MUIA_Frame,MUIV_Frame_Group,
                  Child,_tdsp.lvparams,
                  Child, VGroup,
                        Child, _tdsp.txparam,
                        Child, HGroup,
                              Child, g1,
                              Child, _tdsp.stoffset,
                              End,
                        Child, HGroup,
                              Child, g2,
                              Child, _tdsp.stcoef,
                              End,
                        Child, HGroup,
                              Child,g4,
                              Child,HVSpace,
                              End,
                        Child, HGroup,
                              MUIA_Frame , MUIV_Frame_Group ,     
                              Child,g5,
                              Child,g6,    
                              Child,g3,
                              Child,Label('Type'),
                              Child,_tdsp.cylfotype,
                              End,
                        
                        End,
                  End,
            Child, EaterObject,
            
      End

      _tdsp.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , Gs('Track DSP Sequence') ,
            MUIA_Window_ID , "34WI" ,
            WindowContents , _tdsp.root ,
      End



/* mpeg audio decoder window setup */
/* %mpegdecoder */


      _mpeg.stfile:=StringMUI('',255)

      _mpeg.pampeg := PopaslObject ,
            MUIA_Popasl_Type , 0 ,
            MUIA_Popstring_String , _mpeg.stfile ,
            MUIA_Popstring_Button , PopButton( MUII_PopFile ) ,
            Chain,
      End

      _mpeg.txlayer := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Layer') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End

      _mpeg.txbitrate := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Bitrate') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End

      _mpeg.txfreq := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Frequency') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End

      _mpeg.txmode := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Mode') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End

      _mpeg.txduration := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Duration') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End


      _mpeg.slstart := lslider({g1},Gs('Start'),0,0,0,'%ld sec')
      _mpeg.slend := lslider({g2},Gs('End'),0,0,0,'%ld sec')

      _mpeg.ch16bit := lcheck2({g3},Gs('16-bit'),MUI_TRUE )
      _mpeg.chstereo :=lcheck2({g4},Gs('Stereo'),MUI_TRUE)

      _mpeg.gampeg := GaugeObject ,
            GaugeFrame ,
            MUIA_Gauge_Horiz , MUI_TRUE ,
            MUIA_Gauge_Max , 100 ,
            MUIA_Gauge_InfoText,'',
      End

      _mpeg.txmemory := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Required Memory') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End

      _mpeg.btstart := keybutton(Gs('\euS\enTART'),'ß',MUI_TRUE)

      ->_mpeg.btabort := keybutton(Gs('\euA\enBORT'),'æ',MUI_TRUE)

      _mpeg.txslot := TextObject ,
            MUIA_Background , MUII_TextBack ,
            MUIA_Frame , MUIV_Frame_Text ,
            MUIA_FrameTitle , Gs('Destination') ,
            MUIA_Text_SetMin , MUI_TRUE ,
            MUIA_Text_PreParse , ccenter ,
      End


      _mpeg.root := GroupObject ,
            MUIA_Background, MUII_GroupBack,
            Child , GroupObject ,
                        MUIA_Frame , MUIV_Frame_Group ,
                        MUIA_FrameTitle , 'MPEG File' ,
                        Child , _mpeg.pampeg ,
                        Child , HGroup ,
                              Child , _mpeg.txlayer ,
                              Child , _mpeg.txbitrate ,
                              Child , _mpeg.txfreq ,
                              Child , _mpeg.txmode ,
                              Child , _mpeg.txduration ,
                        End ,
                  End ,
            Child , HGroup ,
                        Child , VGroup ,
                              Child, g1,
                              Child, g2,
                        End,
                        Child , VGroup,
                              Child, g3,
                              Child, g4,
                        End,
                  End ,
            Child , _mpeg.gampeg ,
            Child , HGroup ,
                        Child , _mpeg.txmemory ,
                        Child , _mpeg.btstart ,
                        ->Child , _mpeg.btabort ,
                        Child , _mpeg.txslot ,
                  End ,
            Child, EaterObject,
      End

      _mpeg.base := WindowObject ,
            MUIA_Window_ScreenTitle,cscreentitle,
            MUIA_Window_Title , 'MPEG Audio Decoder' ,
            MUIA_Window_ID , "35WI" ,
            WindowContents , _mpeg.root ,
      End



/* APPLICATION MENU CREATION */





      _appm.open :=     lmenu ('Open...' , Gs('O'))
      _appm.save :=     lmenu ( 'Save' , Gs('S'))
      _appm.saveas := lmenu ('Save As...')
      _appm.clear :=    lmenu ('Clear...')
      _appm.aboutaudiostream := lmenu ('About AudioSTREAM...')
      _appm.aboutmui := lmenu ('About MUI...')
      _appm.matrixor := lmenu ('MatriXor v1.1...')
      _appm.sleep := lmenu ('Iconify')
      _appm.quit := lmenu ('Quit' , Gs('Q'))

      _appm.moduleoptions := lmenu ('Properties...')

      _appm._project := MenuitemObject ,
            MUIA_Menuitem_Title, Gs('Project') ,
            MUIA_Family_Child , _appm.open ,
            MUIA_Family_Child , _appm.save ,
            MUIA_Family_Child , _appm.saveas ,
            MUIA_Family_Child , _appm.clear ,
            MUIA_Family_Child , _appm.moduleoptions ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.aboutaudiostream ,
            MUIA_Family_Child , _appm.aboutmui ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.matrixor ,
            MUIA_Family_Child , _appm.sleep ,
            MUIA_Family_Child , _appm.quit ,
      End


      _appm.infowindow := lmenu ('Info Window')
      
      _appm.sampleeditor := lmenu ('Sample Editor' ,Gs('Z'))
      _appm.waveeditor := lmenu ('Wave Editor', Gs('W'))
      _appm.listeditor := lmenu ('List Editor' ,Gs('R'))
      _appm.dspmanager := lmenu ('DSP Manager',Gs('D'))

      _appm._display := MenuitemObject  ,
            MUIA_Menuitem_Title , Gs('Display') ,
            MUIA_Family_Child , _appm.infowindow ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.sampleeditor ,
            MUIA_Family_Child , _appm.waveeditor ,
            MUIA_Family_Child , _appm.listeditor ,
            MUIA_Family_Child , _appm.dspmanager ,
      End

      _appm.select := MenuitemObject,
            MUIA_Menuitem_Title, Gs ('Select...') ,
      End
      _appm.addnew := lmenu ( 'Add New')

      _appm.deletecurrent := MenuitemObject ,
             MUIA_Menuitem_Title, Gs('Delete Current...') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End
      _appm.sedit := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Edit...') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End
      _appm.soptions := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Options...') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End
      _appm.stranspose := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Transpose...') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End
      _appm.sdsp := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('DSP...') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End
      _appm.smakeclone := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Make Clone') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End

      _appm._song := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Song') ,
            MUIA_Family_Child , _appm.select ,
            MUIA_Family_Child , BarLabel,
            MUIA_Family_Child , _appm.addnew ,
            MUIA_Family_Child , _appm.deletecurrent ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.sedit ,
            MUIA_Family_Child , _appm.soptions ,
            MUIA_Family_Child , _appm.stranspose ,
            MUIA_Family_Child , _appm.sdsp ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.smakeclone ,
      End

      _appm.tpick := lmenu ('Pick...' , Gs('['))
      _appm.tnewhere := lmenu ('New Here' , Gs('/'))
      _appm.tdelcurrent := lmenu ('Delete Current')
      _appm.tplay := lmenu ('Play', Gs('P'))
      _appm.tedit := lmenu ('Edit...')
      _appm.toptions := lmenu ('Options...')
      _appm.ttranspose := lmenu ('Transpose...')
      _appm.tcopy := lmenu ( 'Copy')
      _appm.tcut := lmenu ('Cut')
      _appm.tpaste := lmenu ('Paste')
      _appm.tswap := lmenu ('Swap')
      _appm.tclear := lmenu ('Clear')
      _appm.tmakeclone := lmenu ('Make Clone')
      _appm.tdsp := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('DSP...') ,
      End

      _appm._track := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Track') ,
            MUIA_Family_Child , _appm.tpick ,
            MUIA_Family_Child , _appm.tnewhere ,
            MUIA_Family_Child , _appm.tdelcurrent ,
            MUIA_Family_Child , _appm.tplay ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.tedit ,
            MUIA_Family_Child , _appm.toptions ,
            MUIA_Family_Child , _appm.tdsp ,
            MUIA_Family_Child , _appm.ttranspose ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.tcopy ,
            MUIA_Family_Child , _appm.tcut ,
            MUIA_Family_Child , _appm.tpaste ,
            -> MUIA_Family_Child , _appm.tswap ,
            -> MUIA_Family_Child , _appm.tclear , !!! unused area
            -> MUIA_Family_Child , BarLabel ,
            -> MUIA_Family_Child , _appm.tmakeclone ,
            
      End

      _appm.pick := lmenu ('Pick...', Gs('U'))
      _appm.iload := lmenu ('Load...')
      _appm.loadfromlist := lmenu ('Load From List...', Gs('L'))
      _appm.isave := lmenu ( 'Save')
      _appm.isaveas := lmenu ('Save As...')
      _appm.iflush := lmenu ('Flush...')
      _appm.iedit := lmenu ('Edit...')
      _appm.iproperties := lmenu ('Properties...', Gs('I'))
      _appm.idsp := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('DSP...') ,
            MUIA_Menuitem_Enabled , FALSE ,
      End
      _appm.irender := lmenu ('Render...')
      _appm.imakeclone := lmenu ('Make Clone')

      _appm._instrument := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Instrument') ,
            MUIA_Family_Child , _appm.pick ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.iload ,
            MUIA_Family_Child , _appm.loadfromlist ,
            MUIA_Family_Child , _appm.isave ,
            MUIA_Family_Child , _appm.isaveas ,
            MUIA_Family_Child , _appm.iflush ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.iedit ,
            MUIA_Family_Child , _appm.iproperties ,
            MUIA_Family_Child , _appm.idsp ,
            MUIA_Family_Child , _appm.irender ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.imakeclone ,
      End

      _appm.copyrange := lmenu ('Copy Range', Gs('C'))
      _appm.copyrange2:= lmenu ('Copy Range/All CLists')
      _appm.cutrange := lmenu ('Cut Range', Gs('X'))
      _appm.cutrange2:= lmenu ('Cut Range/All CLists')
      _appm.clearrange := lmenu ('Clear Range')
      _appm.pasterange := lmenu ('Paste Range', Gs('V'))
      _appm.transposerange := lmenu ('Transpose Range')
      _appm.selectchannel := lmenu ('Select Channel', Gs('A'))

      _appm._edit := MenuitemObject ,
            MUIA_Menuitem_Title , Gs('Edit') ,
            MUIA_Family_Child , _appm.copyrange ,
            MUIA_Family_Child , _appm.copyrange2 ,
            MUIA_Family_Child , _appm.cutrange ,
            MUIA_Family_Child , _appm.cutrange2 ,
            MUIA_Family_Child , _appm.clearrange ,
            MUIA_Family_Child , _appm.pasterange ,
            MUIA_Family_Child , _appm.transposerange ,
            MUIA_Family_Child , BarLabel ,
            MUIA_Family_Child , _appm.selectchannel ,
      End

      _appm.playoptions := lmenu ('Play Options...')
      _appm.miscsettings := lmenu ('Misc Settings...')
      _appm.muisettings := lmenu ('MUI Settings...')
      _appm.loaddefault := lmenu ('Load Default')
      _appm.saveasdefault := lmenu ('Save As Default')
      _appm.pload := lmenu ('Load...')
      _appm.psaveas := lmenu ('Save As...')

      _appm._settings := MenuitemObject  ,
            MUIA_Menuitem_Title , Gs('Settings') ,
            MUIA_Family_Child , _appm.playoptions ,
            MUIA_Family_Child , _appm.miscsettings ,
            MUIA_Family_Child , _appm.muisettings ,
            MUIA_Family_Child , BarLabel,
            MUIA_Family_Child , _appm.loaddefault ,
            MUIA_Family_Child , _appm.saveasdefault ,
            MUIA_Family_Child , _appm.pload ,
            MUIA_Family_Child , _appm.psaveas ,
      End

      _appl.menu := MenustripObject ,
            MUIA_Family_Child , _appm._project ,
            MUIA_Family_Child , _appm._display ,
            MUIA_Family_Child , _appm._song ,
            MUIA_Family_Child , _appm._track ,
            MUIA_Family_Child , _appm._instrument ,
            MUIA_Family_Child , _appm._edit ,
            MUIA_Family_Child , _appm._settings ,
      End



ENDPROC



->/////////////////////////////////////////////////////////////////////////////
->/////////////////////////////////////////////////////////// PROC create /////
->/////////////////////////////////////////////////////////////////////////////
PROC gui_create( lb,h)

                  x:=lb   -> !!!!!!
                  hooks:=h

                  muimasterbase:=x.mmbase
                  intuitionbase:=x.intbase
                  asmiscbase:=x.strgbase
                  class:=x.class
                  effclass:=x.effclass
                  editor:=x.editor
                  dslist:=x.dslist
                  sampleed:=x.sampleed

      init_stuff()

      createpart1()
      createpart2()
      createpart3()
      createpart4()
      createpart5()


      _appl.app := ApplicationObject ,
            ( IF x.icon THEN MUIA_Application_DiskObject ELSE TAG_IGNORE ) , x.icon ,
            ( IF x.arexx THEN MUIA_Application_Commands ELSE TAG_IGNORE ) , ( IF x.arexx THEN x.arexx.commands ELSE NIL ) ,
            ( IF x.arexx THEN MUIA_Application_RexxHook ELSE TAG_IGNORE ) , ( IF x.arexx THEN x.arexx.error ELSE NIL ) ,
            -> ( IF x.menu THEN MUIA_Application_Menu ELSE TAG_IGNORE ) , x.menu ,
            MUIA_Application_Author , Gs('Karel Vavra (xvavra1@br.fjfi.cvut.cz)/iMMORTAl') ,
            MUIA_Application_Menustrip , _appl.menu ,
            MUIA_Application_Base , Gs('AUDIOSTREAM') ,
            MUIA_Application_Title , Gs('AudioSTREAM Pro') ,
            MUIA_Application_Version , Gs('$VER: 0.01 XX.XX (XX.XX.XX)') ,
            MUIA_Application_Copyright , Gs('(c) 1997,98 IMMORTAL Systems') ,
            MUIA_Application_Description , Gs('Music Editing Software') ,
            MUIA_Application_HelpFile , Gs('PROGDIR:Docs/Online.guide') ,
            SubWindow, _main.base ,
            SubWindow , _info.base ,
            SubWindow , _about.base ,
            SubWindow , _sels.base ,
            SubWindow , _mopt.base ,
            SubWindow , _sged.base ,
            SubWindow , _sgop.base ,
            SubWindow , _sdsp.base ,
            SubWindow , _inst.base ,
            SubWindow , _idsp.base ,
            SubWindow , _smed.base ,
            SubWindow , _wved.base ,
            SubWindow , _popt.base ,
            SubWindow , _pcki.base ,
            SubWindow , _pcks.base ,
            SubWindow , _pckw.base ,
            SubWindow , _pckt.base ,
            SubWindow , _lofl.base ,
            SubWindow , _lied.base ,
            SubWindow , _cvol.base ,
            SubWindow , _cpit.base ,
            SubWindow , _crch.base ,
            SubWindow , _tran.base ,
            SubWindow , _dspm.base ,
            SubWindow , _tred.base ,
            SubWindow , _trop.base ,
            SubWindow , _sect.base ,
            SubWindow , _tdsp.base ,
            SubWindow , _mpeg.base ,
      End



ENDPROC _appl.app




PROC main()
ENDPROC




