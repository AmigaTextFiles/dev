/* Aaaarghh, because of a heavy bug in the MUI system I
   had to write own routines: The MUI_List-Class and
   the MUI_String-Class must be bettered to work also for
   invisible popobjects ! */


OPT OSVERSION=39,LARGE

MODULE 'muimaster',
       'utility',
       'locale',
       'commodities',
       'icon',
       'wb',
       'datatypes',
       'datatypes/datatypes',
       'datatypes/datatypesclass',
       'dos/dos',
       'dos/dostags',
       'dos/dosextens',
       'dos/doshunks',
       'dos/exall',
       'devices/inputevent',
       'exec/memory',
       'exec/lists',
       'exec/nodes',
       'exec/ports',
       'exec/semaphores',
       'exec/tasks',
       'intuition/intuitionbase',
       'intuition/classusr',
       'intuition/classes',
       'intuition/intuition',
       'intuition/screens',
       'libraries/mui',
       'libraries/asl',
       'libraries/commodities',
       'libraries/gadtools',
       'mui/lamp_mcc',
       'mui/newstring_mcc',
       'utility/hooks',
       'utility/tagitem',
       'workbench/workbench',
       'workbench/startup'
       
OBJECT magicobj
    app:LONG
    win:LONG
    aboutmui:LONG
    menu:LONG
    locale:LONG
    catalog:LONG
    strings:LONG
 /* Gadget section */
    okgadget:LONG
    cancelgadget:LONG
    inputgadget:LONG
    lastinputgad:LONG
    newshellgadget:LONG
    popasl:LONG
    moreoptions:LONG
    outputstrg:LONG
    currdirstrg:LONG
    stackstrg:LONG
    priostrg:LONG
    shellnamestrg:LONG
    infomatch:LONG
    twlist:LONG
    toolorder:LONG
 /* Object section */
    findwin:LONG
    optionwin:LONG
    optionwinisopen:LONG
    mylv:LONG
    mylist:LONG
    findlist:LONG
    lamp1:LONG
    lamp2:LONG
    dtlevel:LONG
    helpfile:LONG
    flashexec:LONG
    reserved:LONG     /* First static dummy string buffer */
    inputstr:LONG
    input:LONG
    mysem:LONG
    filter:LONG
    mybroker:LONG
    priority:LONG
    popupkey:LONG
    maxlastinputs:LONG
    do:LONG
    popstate:LONG
    active:LONG
    keysig:LONG
    rawstring:LONG /* Second dynamical dummy string buffer */
    patstring:LONG
    dirstring:LONG
    tool:LONG
    toolfile:LONG
    sig1:LONG
    sig2:LONG
    defscr:LONG
    savemenu:LONG
    dosscan:LONG
    wbpathscan:LONG
    dtscan:LONG
 /* Hook section */
    addtolist:hook
    listmove:hook
    keylistmove:hook
    /*setpopstate:hook*/
    newshell:hook
    execcmd:hook
    brokerhook:hook
    constructhook:hook
    destructhook:hook
    edithook:hook
    getfound:hook
    /*aboutmehook:hook*/
    aslopenhook:hook
    aslclosehook:hook
    apphook:hook
    checkval:hook
    megacheck:hook
    rexxhook:hook
    popclose:hook
    windowhook:hook
ENDOBJECT

OBJECT mymn
    next:LONG
    last:LONG
    type:CHAR
    pri:CHAR
    dummy:LONG
    port:LONG
    structsize:INT
    msgid:LONG
    data:LONG
ENDOBJECT

OBJECT assignlist
    next:LONG
    lock:LONG
ENDOBJECT

OBJECT toolorder
    order:LONG
    num:LONG
ENDOBJECT

CONST ENDALL=0,
      WHOLE=1,
      PARTLY=2,
      NULL=0,
      NULLSIG=-1,
      TABKEY=$42,
      APPMSG=$1000

ENUM EVENNOTHING,NOLIB,NOAPP,NOMEM,NOTOPEN,NOSIG

ENUM MN_NOTHING,MN_ABOUT,MN_ABOUTMUI,MN_HIDE,MN_QUIT,MN_SAVE,MN_LOAD,MN_MOREOPTIONS,MN_DOSSCAN

ENUM ID_NONE,ID_OUTPUT,ID_CURRDIR,ID_STACK,ID_PRIO,ID_SHELLNAME,ID_INFO,ID_ASSIGNSCAN,
     ID_WBPATHSCAN,ID_DTSCAN,ID_FLASHEXEC

ENUM DT_LEVEL_NODT,DT_LEVEL_DT45COMP,DT_LEVEL_DT45ORIG
                 
ENUM MSG_NOMUILIB,
     MSG_NOICON,
     MSG_NOUTIL,
     MSG_NOCX,
     MSG_NOAPP,
     MSG_NOMEM,
     MSG_REQTITLE,
     MSG_REQGADGET,
     MSG_REQBODY,
     MSG_WBOUTPUT,
     MSG_DESCRIPTION,
     MSG_WINTITLE,
     MSG_BODYTEXT,
     MSG_STRINGTEXT,
     MSG_OKAY,
     MSG_CANCEL,
     MSG_HEAVYRECURSION,
     MSG_ABOUTTITLE,
     MSG_ABOUTGADGET,
     MSG_ABOUTBODY,
     MSG_FREQTITLE,
     MSG_NOTOPEN,
     MSG_NOWB,
     MSG_NOSIGNAL,
     MSG_ITEMSELECT,
     MSG_INFOMATCH,
     MSG_PRIORITY,
     MSG_SHELLNAME,
     MSG_CURRENTDIR,
     MSG_OUTPUT,
     MSG_MOREOPTIONS,
     MSG_MENU_PROJECT,
     MSG_MENU_ABOUTMUI,
     MSG_MENU_ABOUT,
     MSG_MENU_HIDE,
     MSG_MENU_QUIT,
     MSG_MENU_OPTIONS,
     MSG_MENU_SAVE,
     MSG_MENU_RELOAD,
     KEY_CMD,
     KEY_OKAY,
     KEY_CANCEL,
     KEY_MENU_ABOUTMUI,
     KEY_MENU_ABOUT,
     KEY_MENU_HIDE,
     KEY_MENU_QUIT,
     KEY_MENU_SAVE,
     KEY_MENU_RELOAD,
     KEY_MENU_OPTIONS,
     KEY_ASSIGNSCAN,
     KEY_INFOMATCH,
     KEY_WBPATHSCAN,
     KEY_DTSCAN,
     MSG_ASSIGNSCAN,
     MSG_NODT45,
     MSG_WBPATHSCAN,
     MSG_SELECTOP,
     MSG_OP_NOTHING,
     MSG_DTSCAN,
     MSG_LASTINPUTS,
     MSG_SELECTOP_APPICONIFIED,
     MSG_STACK,
     MSG_MENU_FLASHEXEC,
     KEY_FLASHEXEC,
     MSG_MAX

RAISE NOLIB IF OpenLibrary()=NULL,
      NOAPP IF Mui_NewObjectA()=NULL,
      NOMEM IF String()=NULL,
      NOMEM IF List()=NULL,
      NOSIG IF AllocSignal()=NULLSIG

DEF obj:magicobj,res=0,sig=0

PROC createapp(obj:PTR TO magicobj)
    DEF win=NIL,okgad,strgad,nsg,
        cancelgad,locarr:PTR TO LONG,lig,mylist,mylv,findlv,popasl,findlist,
        outputstrg=0,currdirg=0,stackg=0,priog=0,shellnameg=0,infomatch=0,
        moreopts=0,savemenu,lamp1,lamp2,dosscan,wbpathscan,dtscan,aboutwin,
        aboutokay,eightychars,flashexec,pop,mybroker,brokerprt

    locarr:=obj.strings

    eightychars:='                                                                                '

    obj.menu:=MenustripObject,
                MUIA_FAMILY_CHILD,MenuObject,
                                    MUIA_MENU_TITLE,locarr[MSG_MENU_PROJECT],
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_ABOUT],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_ABOUT],
                                                        MUIA_USERDATA,MN_ABOUT,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_ABOUTMUI],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_ABOUTMUI],
                                                        MUIA_USERDATA,MN_ABOUTMUI,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,NM_BARLABEL,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_HIDE],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_HIDE],
                                                        MUIA_USERDATA,MN_HIDE,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_QUIT],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_QUIT],
                                                        MUIA_USERDATA,MN_QUIT,
                                                      End,
                                 End,
                MUIA_FAMILY_CHILD,savemenu:=MenuObject,
                                    MUIA_MENU_TITLE,locarr[MSG_MENU_OPTIONS],
                                    MUIA_FAMILY_CHILD,dosscan:=MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_ASSIGNSCAN],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_ASSIGNSCAN],
                                                        MUIA_MENUITEM_CHECKIT,TRUE,
                                                        MUIA_OBJECTID,ID_ASSIGNSCAN,
                                                      End,
                                    MUIA_FAMILY_CHILD,wbpathscan:=MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_WBPATHSCAN],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_WBPATHSCAN],
                                                        MUIA_MENUITEM_CHECKIT,TRUE,
                                                        MUIA_OBJECTID,ID_WBPATHSCAN,
                                                      End,
                                    MUIA_FAMILY_CHILD,infomatch:=MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_INFOMATCH],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_INFOMATCH],
                                                        MUIA_MENUITEM_CHECKIT,TRUE,
                                                        MUIA_OBJECTID,ID_INFO,
                                                      End,
                                    MUIA_FAMILY_CHILD,dtscan:=MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_DTSCAN],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_DTSCAN],
                                                        MUIA_MENUITEM_CHECKIT,TRUE,
                                                        MUIA_MENUITEM_ENABLED,IF obj.dtlevel THEN TRUE ELSE FALSE,
                                                        MUIA_OBJECTID,ID_DTSCAN,
                                                      End,
                                    MUIA_FAMILY_CHILD,flashexec:=MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_FLASHEXEC],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_FLASHEXEC],
                                                        MUIA_MENUITEM_CHECKIT,TRUE,
                                                        MUIA_OBJECTID,ID_FLASHEXEC,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MOREOPTIONS],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_OPTIONS],
                                                        MUIA_USERDATA,MN_MOREOPTIONS,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,NM_BARLABEL,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_SAVE],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_SAVE],
                                                        MUIA_USERDATA,MN_SAVE,
                                                      End,
                                    MUIA_FAMILY_CHILD,MenuitemObject,
                                                        MUIA_MENUITEM_TITLE,locarr[MSG_MENU_RELOAD],
                                                        MUIA_MENUITEM_SHORTCUT,locarr[KEY_MENU_RELOAD],
                                                        MUIA_USERDATA,MN_LOAD,
                                                      End,
                                  End,
            End

    obj.app:=ApplicationObject,MUIA_APPLICATION_TITLE,'FinalExecute',
                               MUIA_APPLICATION_VERSION,'$VER: V1.21 (4.02.1998)',
                               MUIA_APPLICATION_COPYRIGHT,'©1997 by Matthias Faust',
                               MUIA_APPLICATION_AUTHOR,'Matthias Faust',
                               MUIA_APPLICATION_DESCRIPTION,locarr[MSG_DESCRIPTION],
                               MUIA_APPLICATION_BASE,'FINALEXECUTE',
                               MUIA_APPLICATION_COMMANDS,['CALLREQ','INPUTSTRING,PUBSCREEN',2,obj.rexxhook,0,0,0,0,0]:LONG,
                               MUIA_APPLICATION_HELPFILE,obj.helpfile,
                               MUIA_APPLICATION_BROKERHOOK,obj.brokerhook,
                               MUIA_APPLICATION_BROKERPRI,obj.priority,
                               MUIA_USERDATA,obj,
                               MUIA_APPLICATION_SINGLETASK,TRUE,
                               (IF obj.do THEN MUIA_APPLICATION_DISKOBJECT ELSE TAG_IGNORE),obj.do,
                               MUIA_APPLICATION_WINDOW,
                           win:=WindowObject,MUIA_WINDOW_SCREENTITLE,'FinalExecute V1.2 - ©1997 by Matthias Faust, FreeWare',
                                             MUIA_WINDOW_TITLE,locarr[MSG_WINTITLE],
                                             MUIA_WINDOW_ID,"FIEX",
                                             MUIA_WINDOW_MENUSTRIP,obj.menu,
                                             MUIA_WINDOW_APPWINDOW,TRUE,
                                             MUIA_WINDOW_ROOTOBJECT,
                                                VGroup,
                                                    MUIA_HELPNODE,'usage_gui',
                                                    Child,HGroup,
                                                        Child,lamp1:=LampObject,
                                                            MUIA_LAMP_COLORTYPE,MUIV_LAMP_COLORTYPE_USERDEFINED,
                                                            MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF,
                                                        End,
                                                        Child,TextObject,MUIA_TEXT_CONTENTS,locarr[MSG_BODYTEXT],End,
                                                        Child,lamp2:=LampObject,
                                                            MUIA_LAMP_COLORTYPE,MUIV_LAMP_COLORTYPE_USERDEFINED,
                                                            MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF,
                                                        End,
                                                    End,
                                                    Child,HGroup,
                                                        GroupFrame,
                                                        Child,KeyLabel(locarr[MSG_STRINGTEXT],Char(locarr[KEY_CMD])),
                                                        Child,pop:=PopobjectObject,
                                                            MUIA_POPSTRING_BUTTON,lig:=PopButton(MUII_POPUP),
                                                            MUIA_POPOBJECT_OBJSTRHOOK,obj.popclose,
                                                            MUIA_POPOBJECT_WINDOWHOOK,obj.windowhook,
                                                            MUIA_POPOBJECT_OBJECT,mylv:=ListviewObject,
                                                                                    InputListFrame,
                                                                                    MUIA_FIXWIDTHTXT,eightychars,   /* I hate this, it sucks, but it is needed :-(( */
                                                                                    MUIA_LISTVIEW_LIST,mylist:=ListObject,
                                                                                        MUIA_LIST_TITLE,locarr[MSG_LASTINPUTS],
                                                                                        MUIA_LIST_CONSTRUCTHOOK,obj.constructhook,
                                                                                        MUIA_LIST_DESTRUCTHOOK,obj.destructhook,
                                                                                        End,
                                                                                    End,
                                                        End,
                                                        Child,popasl:=PopaslObject,
                                                                MUIA_POPASL_TYPE,ASL_FILEREQUEST,
                                                                MUIA_POPASL_STARTHOOK,obj.aslopenhook,
                                                                MUIA_POPASL_STOPHOOK,obj.aslclosehook,
                                                                MUIA_POPSTRING_STRING,strgad:=NewstringObject,
                                                                                                StringFrame,
                                                                                                MUIA_CONTROLCHAR,Char(locarr[KEY_CMD]),
                                                                                                MUIA_STRING_MAXLEN,1025,
                                                                                                MUIA_STRING_CONTENTS,'',
                                                                                                /*MUIA_STRING_EDITHOOK,obj.edithook,  Unused until Ruediger Sopp will
                                                                                                                                       make an own edithook implementation */
                                                                                                MUIA_CYCLECHAIN,TRUE,
                                                                                                MUIA_WEIGHT,200,
                                                                                              End,
                                                                MUIA_POPSTRING_BUTTON,PopButton(MUII_POPFILE),
                                                                MUIA_USERDATA,obj,
                                                        End,
                                                    End,
                                                    Child,RectangleObject,MUIA_RECTANGLE_HBAR,TRUE,End,
                                                    Child,HGroup,
                                                        Child,okgad:=KeyButton(locarr[MSG_OKAY],Char(locarr[KEY_OKAY])),
                                                        Child,HVSpace,
                                                        Child,nsg:=KeyButton('NewShell',"s"),
                                                        Child,HVSpace,
                                                        Child,cancelgad:=KeyButton(locarr[MSG_CANCEL],Char(locarr[KEY_CANCEL])),
                                                    End,
                                                End,
                                   End,
                End

    obj.findwin:=WindowObject,MUIA_WINDOW_TITLE,locarr[MSG_ITEMSELECT],
                              MUIA_WINDOW_ID,"FIFW",
                              MUIA_WINDOW_REFWINDOW,win,
                              MUIA_WINDOW_ROOTOBJECT,
                                findlv:=ListviewObject,
                                            MUIA_LISTVIEW_LIST,findlist:=ListObject,
                                                                            InputListFrame,
                                                                            MUIA_LIST_CONSTRUCTHOOK,obj.constructhook,
                                                                            MUIA_LIST_DESTRUCTHOOK,obj.destructhook,
                                                                         End,
                                        End,
                End

    obj.optionwin:=WindowObject,MUIA_WINDOW_TITLE,locarr[MSG_MOREOPTIONS],
                                MUIA_WINDOW_ID,"OPFE",
                                MUIA_WINDOW_REFWINDOW,win,
                                MUIA_WINDOW_ROOTOBJECT,
                                  VGroup,
                                    MUIA_HELPNODE,'usage_menu',
                                    Child,HGroup,
                                        Child,TextObject,MUIA_TEXT_CONTENTS,locarr[MSG_OUTPUT],End,
                                        Child,outputstrg:=StringObject,
                                            StringFrame,
                                            MUIA_STRING_ADVANCEONCR,TRUE,
                                            MUIA_STRING_CONTENTS,obj.inputstr,
                                            MUIA_CYCLECHAIN,TRUE,
                                            MUIA_OBJECTID,ID_OUTPUT,
                                        End,
                                    End,
                                    Child,HGroup,
                                        Child,TextObject,MUIA_TEXT_CONTENTS,locarr[MSG_CURRENTDIR],End,
                                        Child,currdirg:=StringObject,
                                            StringFrame,
                                            MUIA_STRING_ADVANCEONCR,TRUE,
                                            MUIA_CYCLECHAIN,TRUE,
                                            MUIA_OBJECTID,ID_CURRDIR,
                                        End,
                                    End,
                                    Child,HGroup,
                                        Child,TextObject,MUIA_TEXT_CONTENTS,locarr[MSG_SHELLNAME],End,
                                        Child,shellnameg:=StringObject,
                                            StringFrame,
                                            MUIA_STRING_ADVANCEONCR,TRUE,
                                            MUIA_CYCLECHAIN,TRUE,
                                            MUIA_OBJECTID,ID_SHELLNAME,
                                        End,
                                    End,
                                    Child,HGroup,
                                        Child,TextObject,MUIA_TEXT_CONTENTS,locarr[MSG_STACK],End,
                                        Child,stackg:=SliderObject,
                                            SliderFrame,
                                            MUIA_NUMERIC_MIN,4096,
                                            MUIA_NUMERIC_MAX,1048576,
                                            MUIA_NUMERIC_VALUE,4096,
                                            MUIA_CYCLECHAIN,TRUE,
                                            MUIA_OBJECTID,ID_STACK,
                                        End,
                                    End,
                                    Child,HGroup,
                                        Child,TextObject,MUIA_TEXT_CONTENTS,locarr[MSG_PRIORITY],End,
                                        Child,priog:=StringObject,
                                            StringFrame,
                                            MUIA_STRING_INTEGER,0,
                                            MUIA_STRING_ACCEPT,'-0123456789',
                                            MUIA_STRING_ADVANCEONCR,TRUE,
                                            MUIA_CYCLECHAIN,TRUE,
                                            MUIA_OBJECTID,ID_PRIO,
                                        End,
                                    End,
                                End,
                        End

    aboutwin:=WindowObject,
                MUIA_WINDOW_TITLE,locarr[MSG_ABOUTTITLE],
                MUIA_WINDOW_ID,"ABOU",
                MUIA_WINDOW_REFWINDOW,win,
                MUIA_WINDOW_ROOTOBJECT,
                    GroupObject,
                        MUIA_BACKGROUND,MUII_REQUESTERBACK,
                        Child,TextObject,
                            TextFrame,
                            MUIA_BACKGROUND,MUII_TEXTBACK,
                            MUIA_TEXT_CONTENTS,locarr[MSG_ABOUTBODY],
                        End,
                        Child,HGroup,
                            Child,RectangleObject,
                                MUIA_WEIGHT,40,
                            End,
                            Child,aboutokay:=TextObject,
                                ButtonFrame,
                                    MUIA_TEXT_CONTENTS,locarr[MSG_ABOUTGADGET],
                                    MUIA_TEXT_PREPARSE,MUIX_C,
                                    MUIA_INPUTMODE    , MUIV_INPUTMODE_RELVERIFY,
                                    MUIA_BACKGROUND   , MUII_BUTTONBACK,
                                    MUIA_WEIGHT,20,
                                End,
                            Child,RectangleObject,
                                MUIA_WEIGHT,40,
                            End,
                        End,
                    End,
            End

    doMethod(obj.app,[OM_ADDMEMBER,obj.findwin])
    doMethod(obj.app,[OM_ADDMEMBER,obj.optionwin])
    doMethod(obj.app,[OM_ADDMEMBER,aboutwin])

    doMethod(aboutwin,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,aboutokay])
    doMethod(aboutwin,[MUIM_NOTIFY,MUIA_WINDOW_CLOSEREQUEST,MUI_TRUE,MUIV_NOTIFY_SELF,3,MUIM_SET,MUIA_WINDOW_OPEN,FALSE])

    obj.okgadget:=okgad
    obj.cancelgadget:=cancelgad
    obj.inputgadget:=strgad
    obj.mylist:=mylist
    obj.mylv:=mylv
    obj.newshellgadget:=nsg
    obj.lastinputgad:=lig
    obj.popasl:=popasl
    obj.win:=win

    obj.findlist:=findlist

    obj.outputstrg:=outputstrg
    obj.currdirstrg:=currdirg
    obj.stackstrg:=stackg
    obj.priostrg:=priog
    obj.shellnamestrg:=shellnameg
    obj.infomatch:=infomatch
    obj.moreoptions:=moreopts
    obj.savemenu:=savemenu
    obj.dosscan:=dosscan
    obj.wbpathscan:=wbpathscan
    obj.dtscan:=dtscan
    obj.flashexec:=flashexec
    obj.lamp1:=lamp1
    obj.lamp2:=lamp2

    doMethod(obj.app,[MUIM_APPLICATION_LOAD,MUIV_APPLICATION_LOAD_ENV])
    doMethod(obj.app,[MUIM_SET,MUIA_APPLICATION_DROPOBJECT,obj.win])

    doMethod(win,[MUIM_SET,MUIA_WINDOW_OPEN,TRUE])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_CLOSEREQUEST,MUI_TRUE,MUIV_NOTIFY_APPLICATION,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,TRUE])
    doMethod(win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,strgad])

    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_ABOUT,aboutwin,3,MUIM_SET,MUIA_WINDOW_OPEN,TRUE])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_ABOUTMUI,MUIV_NOTIFY_APPLICATION,2,MUIM_APPLICATION_ABOUTMUI,obj.win])

    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_HIDE,MUIV_NOTIFY_APPLICATION,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,TRUE])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_QUIT,MUIV_NOTIFY_APPLICATION,2,MUIM_APPLICATION_RETURNID,MUIV_APPLICATION_RETURNID_QUIT])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_MOREOPTIONS,obj.optionwin,3,MUIM_SET,MUIA_WINDOW_OPEN,TRUE])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_SAVE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.megacheck])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_SAVE,MUIV_NOTIFY_APPLICATION,2,MUIM_APPLICATION_SAVE,MUIV_APPLICATION_SAVE_ENV])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_SAVE,MUIV_NOTIFY_APPLICATION,2,MUIM_APPLICATION_SAVE,MUIV_APPLICATION_SAVE_ENVARC])

    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_LOAD,MUIV_NOTIFY_APPLICATION,2,MUIM_APPLICATION_LOAD,MUIV_APPLICATION_LOAD_ENV])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_MENUACTION,MN_LOAD,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.megacheck])

    /* As long as Ruediger still hasn`t implemented edithooks, I have to simulate */

    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_INPUTEVENT,'tab',MUIV_NOTIFY_APPLICATION,3,MUIM_CALLHOOK,obj.keylistmove,TABKEY])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_INPUTEVENT,'-repeat up',MUIV_NOTIFY_APPLICATION,3,MUIM_CALLHOOK,obj.keylistmove,CURSORUP])
    doMethod(win,[MUIM_NOTIFY,MUIA_WINDOW_INPUTEVENT,'-repeat down',MUIV_NOTIFY_APPLICATION,3,MUIM_CALLHOOK,obj.keylistmove,CURSORDOWN])

    /* End of simulation */

    doMethod(obj.findwin,[MUIM_NOTIFY,MUIA_WINDOW_CLOSEREQUEST,MUI_TRUE,MUIV_NOTIFY_SELF,3,MUIM_SET,MUIA_WINDOW_OPEN,FALSE])
    doMethod(obj.findwin,[MUIM_NOTIFY,MUIA_WINDOW_CLOSEREQUEST,MUI_TRUE,obj.findlist,1,MUIM_LIST_CLEAR])
    doMethod(obj.findwin,[MUIM_NOTIFY,MUIA_WINDOW_CLOSEREQUEST,MUI_TRUE,obj.win,3,MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,obj.inputgadget])
    doMethod(obj.findwin,[MUIM_SET,MUIA_WINDOW_DEFAULTOBJECT,findlv])
    doMethod(findlv,[MUIM_NOTIFY,MUIA_LISTVIEW_DOUBLECLICK,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,3,MUIM_CALLHOOK,obj.getfound])

    doMethod(mylv,[MUIM_NOTIFY,MUIA_LISTVIEW_DOUBLECLICK,MUI_TRUE,pop,2,MUIM_POPSTRING_CLOSE,TRUE])

    doMethod(mylv,[MUIM_NOTIFY,MUIA_LISTVIEW_SELECTCHANGE,TRUE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.listmove])
    doMethod(mylist,[MUIM_NOTIFY,MUIA_LIST_ACTIVE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.listmove])

    /*

    OBSOLETE since V1.2

    doMethod(lig,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.setpopstate])

    */
    doMethod(nsg,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,TRUE])
    doMethod(nsg,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.newshell])

    doMethod(okgad,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,TRUE])
    doMethod(okgad,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.execcmd])
    doMethod(okgad,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.addtolist])

    doMethod(cancelgad,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,TRUE])

    doMethod(obj.inputgadget,[MUIM_NOTIFY,MUIA_STRING_ACKNOWLEDGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,TRUE])
    doMethod(obj.inputgadget,[MUIM_NOTIFY,MUIA_STRING_ACKNOWLEDGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.execcmd])
    doMethod(obj.inputgadget,[MUIM_NOTIFY,MUIA_STRING_ACKNOWLEDGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.addtolist])

    doMethod(obj.win,[MUIM_NOTIFY,MUIA_APPMESSAGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,3,MUIM_CALLHOOK,obj.apphook,MUIV_TRIGGERVALUE])
    doMethod(obj.win,[MUIM_NOTIFY,MUIA_APPMESSAGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,6,MUIM_APPLICATION_PUSHMETHOD,obj.app,3,MUIM_SET,MUIA_APPLICATION_ICONIFIED,FALSE])

    /*  OBSOLETE since V1.2

        doMethod(obj.stackstrg,[MUIM_NOTIFY,MUIA_STRING_ACKNOWLEDGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,6,MUIM_CALLHOOK,obj.checkval,obj.stackstrg,FALSE,4096,-1])

    */
    doMethod(obj.priostrg,[MUIM_NOTIFY,MUIA_STRING_ACKNOWLEDGE,MUIV_EVERYTIME,MUIV_NOTIFY_APPLICATION,6,MUIM_CALLHOOK,obj.checkval,obj.priostrg,TRUE,-128,127])

    doMethod(obj.optionwin,[MUIM_NOTIFY,MUIA_WINDOW_CLOSEREQUEST,MUI_TRUE,MUIV_NOTIFY_SELF,3,MUIM_SET,MUIA_WINDOW_OPEN,FALSE])

    doMethod(obj.moreoptions,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,MUIV_NOTIFY_APPLICATION,2,MUIM_CALLHOOK,obj.megacheck])

    doMethod(obj.app,[MUIM_NOTIFY,MUIA_APPLICATION_ICONIFIED,FALSE,obj.win,3,MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,strgad])

    doMethod(aboutokay,[MUIM_NOTIFY,MUIA_PRESSED,FALSE,aboutwin,3,MUIM_SET,MUIA_WINDOW_OPEN,FALSE])

    get(obj.app,MUIA_APPLICATION_BROKER,{mybroker})
        obj.mybroker:=mybroker
        get(obj.app,MUIA_APPLICATION_BROKERPORT,{brokerprt})
        IF obj.mybroker
            obj.filter:=CreateCxObj(CX_FILTER,obj.popupkey,0)
            IF obj.filter
                    AttachCxObj(obj.filter,CreateCxObj(CX_SEND,brokerprt,"WAKE"))
                    AttachCxObj(obj.filter,CreateCxObj(CX_TRANSLATE,0,0))
                    AttachCxObj(obj.mybroker,obj.filter)
            ENDIF
        ENDIF

        IF (obj.filter=0) OR (obj.mybroker=0)
            Mui_RequestA(obj.app,obj.win,0,locarr[MSG_REQTITLE],locarr[MSG_REQGADGET],locarr[MSG_REQBODY],NIL)
            SetIoErr(RETURN_FAIL)
            Raise(ENDALL)
        ENDIF
ENDPROC


PROC readtt(obj:PTR TO magicobj)
    DEF mydir=0,myname=0,sm:PTR TO wbstartup,wa:PTR TO wbarg,
        do:PTR TO diskobject,val:PTR TO CHAR,read=0,slen=0,popupkey

    obj.popupkey:='rcommand shift e'
    obj.priority:=0
    obj.maxlastinputs:=32
    obj.dtlevel:=DT_LEVEL_DT45COMP /* compatible */
    obj.flashexec:=0
    obj.helpfile:='HELP:FinalExecute.guide'

    mydir:=String(1200)
    myname:=String(1024)

    IF wbmessage=NIL
        StrCopy(mydir,'PROGDIR:',ALL)
        GetProgramName(myname,1024)
    ELSE
        sm:=wbmessage
        wa:=sm.arglist
        NameFromLock(wa.lock,mydir,1200)
        StrCopy(myname,wa.name,ALL)
    ENDIF

    AddPart(mydir,myname,1200)

    obj.do:=GetDiskObject(mydir)
    IF obj.do
        do:=obj.do
        IF val:=FindToolType(do.tooltypes,'CX_PRIORITY')
            Val(val,{read})
            IF read>0
                read:=0
                obj.priority:=Val(val,{read})
            ENDIF
        ENDIF

        IF val:=FindToolType(do.tooltypes,'CX_ENVHOTKEY')

            popupkey:=String(StrLen(val))
            IF val[0]=34 THEN val++
            val:=TrimStr(val)

            slen:=StrLen(val)-1

            IF val[slen]=34 THEN val[slen]:=0

            StrCopy(popupkey,val,ALL)
            obj.popupkey:=popupkey
        ENDIF

        IF val:=FindToolType(do.tooltypes,'MAXLASTINPUTS')
            read:=0
            Val(val,{read})
            IF read>0
                read:=0
                IF Val(val,{read})>0
                    read:=0
                    obj.maxlastinputs:=Val(val,{read})
                ENDIF
            ENDIF
        ENDIF

        IF val:=FindToolType(do.tooltypes,'DTLEVEL')
            read:=0
            Val(val,{read})
            IF read>0
                read:=0
                obj.dtlevel:=Val(val,{read})
                IF obj.dtlevel>2 THEN obj.dtlevel:=2
                IF obj.dtlevel<0 THEN obj.dtlevel:=0
            ENDIF
        ENDIF

        IF val:=FindToolType(do.tooltypes,'HELPFILE')
            obj.helpfile:=String(StrLen(val))
            StrCopy(obj.helpfile,val,ALL)
        ENDIF

        DisposeLink(mydir)
        DisposeLink(myname)
        /*FreeDiskObject(obj.do)
        obj.do:=NIL*/
    ENDIF
ENDPROC

PROC main() HANDLE
        DEF str:PTR TO LONG,key,active,
            myss:ss,ln:PTR TO ln

        clearmem(obj,SIZEOF magicobj)

        localebase:=OpenLibrary('locale.library',38)
        
        obj.strings:=List(MSG_MAX)
        setstrings(obj,obj.strings,'finalexecute.catalog',
                                  ['Couldn`t open "muimaster.library" ',
                                   'Couldn`t open "icon.library" V39++ !\n',
                                   'Couldn`t open "utility.library" V39++ !\n',
                                   'Couldn`t open "commodities.library" !\n',
                                   'Couldn`t create application !\nLow memory ? Tried to start me twice ?\n',
                                   'No memory !\n',
                                   'Error',
                                   'Okay :(',
                                   'Cannot install as commodity !\n',
                                   'Output Window',
                                   'Replaces a well-known menupoint ! ;)',
                                   'Execute a File',
                                   '\ec\e8Enter Command and its Arguments:',
                                   'Command:',
                                   'Ok',
                                   'Cancel',
                                   '\ecToo heavy recursion level\nfor pattern-searching :(',
                                   'About',
                                   'Okay :)',
                                   '\ec\e8FinalExecute V1.2 ©1997 by Matthias "Joulupukk" Faust\e2\n\nThe final "Execute command" replacement !\n\n'+
                                   'This program is dedicated in memorial to Meeting Erfurt`97\n\n'+
                                   'It`s Freeware\nEnjoy it !\n\n'+
                                   'Lamp.mcc/Lamp.mcp and all according files are Copyright © 1997 by Maik\n'+
                                   'Schreiber/\ebIQ Computing\en\n'+
                                   'Updates are always available at http://home.pages.de/~bZ/projekte/mcc_lamp/\n\n'+
                                   'Datatypes.library V45 ©1996/1997 by Roland Mainz\n\n'+
                                   'NewString.mcc/NewString.mcp ©1995-1997 by Ruediger Sopp\n\n',
                                   'Select dir(s) or file(s)',
                                   '\ecCouldn`t open:\n%s',
                                   'Couldn`t open "workbench.library" V39++ !\n',
                                   'Couldn`t allocate signal !\n',
                                   'Select item:',
                                   'Include .info files',
                                   '\erPriority:',
                                   '\erShell name:',
                                   '\erCurrent directory:',
                                   '\erOutput:',
                                   'Edit command options...',
                                   'Project',
                                   'About MUI',
                                   'About',
                                   'Hide',
                                   'Quit',
                                   'Options',
                                   'Save',
                                   'Reload',
                                   'c','o','n','!','?','H','Q','S','R','O','A','I','W','T',
                                   'Scan assignlist',
                                   'Couldn`t open "datatypes.library" V45++ !\n',
                                   'Scan WB pathes',
                                   '\ec\e8Select desired operation:',
                                   '|Nothing',
                                   'Datatype scan',
                                   '\eu\ebLast inputs',
                                   'Select desired operation:',
                                   '\erStack:',
                                   'Flash execution',
                                   'F'])
        str:=obj.strings

        muimasterbase:=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN)
        utilitybase:=OpenLibrary('utility.library',39)
        iconbase:=OpenLibrary('icon.library',39)
        cxbase:=OpenLibrary('commodities.library',39)
        workbenchbase:=OpenLibrary('workbench.library',39)

        obj.reserved:=String(1028)
        obj.inputstr:=String(StrLen('CON:/25///\s/AUTO/WAIT')+StrLen(str[MSG_WBOUTPUT])+32)
        StringF(obj.inputstr,'CON:/25///\s/AUTO/WAIT',str[MSG_WBOUTPUT])
        obj.keysig:=AllocSignal(NULLSIG)
        obj.toolorder:=List(6)

        readtt(obj)

        IF obj.dtlevel
            datatypesbase:=OpenLibrary('datatypes.library',IF obj.dtlevel=DT_LEVEL_DT45COMP THEN 0 ELSE 45)
        ENDIF

        PutLong({task},FindTask(0))
        PutLong({keysig},Shl(1,obj.keysig))

        installhook(obj.addtolist,{addtolist})
        installhook(obj.constructhook,{construct})
        installhook(obj.destructhook,{destruct})
        installhook(obj.listmove,{listmove})
        installhook(obj.keylistmove,{keylistmove})
        installhook(obj.newshell,{newshell})
        installhook(obj.execcmd,{execcmd})
        /*installhook(obj.setpopstate,{setpopstate})*/
        installhook(obj.edithook,{edithook})
        installhook(obj.getfound,{getfound})
        /*installhook(obj.aboutmehook,{aboutme})*/
        installhook(obj.aslopenhook,{aslopen})
        installhook(obj.aslclosehook,{aslclose})
        installhook(obj.apphook,{apphook})
        installhook(obj.checkval,{checkval})
        installhook(obj.megacheck,{megacheck})
        installhook(obj.rexxhook,{rexxhook})
        installhook(obj.popclose,{popclose})
        installhook(obj.windowhook,{windowhook})
        installhook(obj.brokerhook,{brokerfunc})

        createapp(obj)

        ln:=myss.ln
        ln.name:='« FinalExecute »'
        AddSemaphore(myss)
        obj.mysem:=myss

        LOOP
            res:=doMethod(obj.app,[MUIM_APPLICATION_NEWINPUT,{sig}])
            IF res=MUIV_APPLICATION_RETURNID_QUIT
                get(obj.popasl,MUIA_POPASL_ACTIVE,{active})
                IF active=FALSE THEN Raise(ENDALL)
            ENDIF
            IF sig
                sig:=Wait(sig OR SIGBREAKF_CTRL_E OR Shl(1,obj.keysig))
                IF sig AND SIGBREAKF_CTRL_E THEN Raise(ENDALL)

                IF sig AND Shl(1,obj.keysig) THEN doMethod(obj.app,[MUIM_CALLHOOK,obj.keylistmove,key:=rawkey2key(Long({code}))])
            ENDIF
        ENDLOOP
EXCEPT
        SELECT exception
                CASE NOLIB
                        IF muimasterbase=NULL
                                WriteF('\s\d++ !\n',str[MSG_NOMUILIB],MUIMASTER_VMIN)
                        ELSEIF utilitybase=NULL
                                WriteF(str[MSG_NOUTIL])
                        ELSEIF iconbase=NULL
                                WriteF(str[MSG_NOICON])
                        ELSEIF localebase=NULL
                                WriteF('Can`t open "locale.library" !\n')
                        ELSEIF cxbase=NULL
                            WriteF(str[MSG_NOCX])
                        ELSEIF workbenchbase=NULL
                            WriteF(str[MSG_NOWB])
                        ELSEIF datatypesbase=NULL
                            WriteF(str[MSG_NODT45])
                        ENDIF
                CASE NOAPP
                        WriteF(str[MSG_NOAPP])
                CASE NOMEM
                        WriteF(str[MSG_NOMEM])
                CASE NOSIG
                        WriteF(str[MSG_NOSIGNAL])
        ENDSELECT

        IF muimasterbase 
            IF obj.findwin
                doMethod(obj.app,[OM_REMMEMBER,obj.findwin])
                Mui_DisposeObject(obj.findwin)
            ENDIF
            IF obj.optionwin
                doMethod(obj.app,[OM_REMMEMBER,obj.optionwin])
                Mui_DisposeObject(obj.optionwin)
            ENDIF
            IF obj.app THEN Mui_DisposeObject(obj.app)
            CloseLibrary(muimasterbase)
        ENDIF
        IF obj.keysig>NULLSIG THEN FreeSignal(obj.keysig)
        IF utilitybase THEN CloseLibrary(utilitybase)
        IF iconbase
            IF obj.do THEN FreeDiskObject(obj.do)
            CloseLibrary(iconbase)
        ENDIF
        IF localebase
                IF obj.locale 
                        IF obj.catalog THEN CloseCatalog(obj.catalog)
                        CloseLocale(obj.locale)
                ENDIF   
                CloseLibrary(localebase)
        ENDIF   
        IF cxbase THEN CloseLibrary(cxbase)
        IF workbenchbase THEN CloseLibrary(workbenchbase)
        IF datatypesbase THEN CloseLibrary(datatypesbase)

        IF myss:=FindSemaphore('« FinalExecute »')
            RemSemaphore(myss)
        ENDIF

        CleanUp(0)
ENDPROC

/* Yep, you can use one REXX Command :) */

PROC rexxhook()
    DEF app,mo:PTR TO magicobj,args:PTR TO LONG,name

    MOVE.L A2,app
    MOVE.L A1,args

    get(app,MUIA_USERDATA,{mo})

    IF args[1] THEN doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_PUBLICSCREEN,args[1]])

    IF args[0] THEN doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,args[0]])

    doMethod(mo.app,[MUIM_SET,MUIA_APPLICATION_ICONIFIED,FALSE])

    get(mo.win,MUIA_WINDOW_PUBLICSCREEN,{name})

    IF args[1]
        IF Stricmp(args[1],name)<>0 THEN RETURN 0
    ENDIF
ENDPROC TRUE

PROC popclose()
    DEF list,entry,app,mo:PTR TO magicobj

    MOVE.L A2,list

    get(list,MUIA_APPLICATIONOBJECT,{app})

    get(app,MUIA_USERDATA,{mo})

    IF app
        doMethod(list,[MUIM_LIST_GETENTRY,MUIV_LIST_GETENTRY_ACTIVE,{entry}])
        doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,entry])
        doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,mo.inputgadget])
        mo.popstate:=FALSE
    ENDIF
ENDPROC

PROC windowhook()
    DEF pop,win,mo:PTR TO magicobj,app

    MOVE.L  A2,pop
    MOVE.L  A1,win

    doMethod(win,[MUIM_SET,MUIA_WINDOW_DEFAULTOBJECT,pop])

    get(win,MUIA_APPLICATIONOBJECT,{app})

    IF app
        get(app,MUIA_USERDATA,{mo})
        doMethod(mo.mylist,[MUIM_NONOTIFYSET,MUIA_LIST_ACTIVE,MUIV_LIST_ACTIVE_TOP])
        mo.popstate:=TRUE
    ENDIF
ENDPROC

PROC getwbpath(obj:PTR TO magicobj)
    DEF sm:PTR TO wbstartup,
        mn:PTR TO mn,
        mp:PTR TO mp,
        tc:PTR TO tc,
        proc:PTR TO process,
        ln:PTR TO ln,
        cli:PTR TO commandlineinterface,
        locklist=NIL,
        oldlock=NIL:PTR TO LONG,
        last=NIL:PTR TO LONG,
        newlock=NIL:PTR TO LONG

    setmt(obj.mysem,FALSE)
    sm:=wbmessage
    IF sm.message
        mn:=sm.message
        IF mn.replyport
            mp:=mn.replyport
            IF (mp.flags AND PF_ACTION)=0
                tc:=mp.sigtask
                ln:=tc.ln
                IF ln.type=NT_PROCESS
                    proc:=tc
                    IF proc.cli
                        cli:=Shl(proc.cli,2)
                        oldlock:=Shl(cli.commanddir,2)
                        WHILE oldlock
                            newlock:=AllocVec(8,MEMF_ANY OR MEMF_CLEAR)
                            newlock[0]:=0
                            IF locklist=NIL THEN locklist:=newlock
                            IF newlock=NIL THEN JUMP returnwblocks
                            newlock[1]:=DupLock(oldlock[1])
                            IF last THEN last[0]:=Shr(newlock,2)
                            last:=newlock
                            oldlock:=Shl(oldlock[0],2)
                        ENDWHILE
                    ENDIF
                ENDIF
            ENDIF
        ENDIF
    ENDIF
returnwblocks:
    setmt(obj.mysem,TRUE)

ENDPROC Shr(locklist,2)

PROC execcmd()
    DEF caller,mo:PTR TO magicobj,str,myinput=NIL,
        locarr:PTR TO LONG,inputstr,
        shellname,stack,pri,currdir,currlock=0,
        locklist
    
    MOVE.L A2,caller
    get(caller,MUIA_USERDATA,{mo})

    get(mo.outputstrg,MUIA_STRING_CONTENTS,{inputstr})
    get(mo.inputgadget,MUIA_STRING_CONTENTS,{str})

    locarr:=mo.strings

    IF StrLen(TrimStr(str))=0
        doMethod(mo.mylist,[MUIM_LIST_GETENTRY,0,{str}])
        IF StrLen(str)
            doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,str])
        ENDIF
        RETURN
    ENDIF

    IF (myinput:=Open(inputstr,MODE_NEWFILE))=NIL
        request(mo,locarr[MSG_REQTITLE],locarr[MSG_OKAY],locarr[MSG_NOTOPEN],[inputstr])
        RETURN 0
    ENDIF

    get(mo.shellnamestrg,MUIA_STRING_CONTENTS,{shellname})

    /* OBSOLETE since V1.2

        get(mo.stackstrg,MUIA_STRING_INTEGER,{stack})

    */

    get(mo.stackstrg,MUIA_NUMERIC_VALUE,{stack})
    get(mo.priostrg,MUIA_STRING_INTEGER,{pri})
    get(mo.currdirstrg,MUIA_STRING_CONTENTS,{currdir})

    IF StrLen(currdir)
        currlock:=Lock(currdir,ACCESS_READ)
    ELSE
        currlock:=Lock('PROGDIR:',ACCESS_READ)
    ENDIF

    locklist:=getwbpath(mo)

    SystemTagList(str,[SYS_ASYNCH,TRUE,
                       SYS_INPUT,myinput,
                       SYS_OUTPUT,NIL,
                       (IF StrLen(TrimStr(shellname)) THEN SYS_CUSTOMSHELL ELSE TAG_IGNORE),shellname,
                       (IF stack>4096 THEN NP_STACKSIZE ELSE TAG_IGNORE),stack,
                       (IF (pri>-129) AND (pri<128) THEN NP_PRIORITY ELSE TAG_IGNORE),pri,
                       (IF currlock THEN NP_CURRENTDIR ELSE TAG_IGNORE),currlock,
                       (IF locklist THEN NP_PATH ELSE TAG_IGNORE),locklist,
                       NIL])
    /*doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_PUBLICSCREEN,'Workbench'])*/
ENDPROC TRUE

/*PROC aboutme()
    DEF caller,mo:PTR TO magicobj,locarr:PTR TO LONG

    MOVE.L A2,caller
    get(caller,MUIA_USERDATA,{mo})

    locarr:=mo.strings

    request(mo,locarr[MSG_ABOUTTITLE],locarr[MSG_ABOUTGADGET],locarr[MSG_ABOUTBODY],NIL)
ENDPROC*/

PROC newshell()
    DEF app,mo,locklist=0

    MOVE.L  A2,app

    get(app,MUIA_USERDATA,{mo})

    locklist:=getwbpath(mo)

    SystemTagList('NewShell',[SYS_INPUT,Input(),
                              SYS_OUTPUT,NIL,
                              (IF locklist>0 THEN NP_PATH ELSE TAG_IGNORE),locklist,
                              NIL])
ENDPROC

PROC brokerfunc(app,cxmsg)
  DEF id,obj:PTR TO magicobj,ib:PTR TO intuitionbase,scr,ilock

  id:=CxMsgID(cxmsg)
  get(app,MUIA_USERDATA,{obj})

  SELECT id
    CASE "WAKE"
        JUMP appear
    CASE CXCMD_APPEAR
     appear:
        ib:=intuitionbase
        ilock:=LockIBase(0)
        scr:=ib.activescreen
        UnlockIBase(ilock)
        doMethod(obj.win,[MUIM_SET,MUIA_WINDOW_SCREEN,scr])
        doMethod(obj.app,[MUIM_SET,MUIA_APPLICATION_ICONIFIED,FALSE])
  ENDSELECT
ENDPROC

/* Own ASL-Funcs */

PROC aslopen()
    DEF taglist:PTR TO LONG,i=0,myown:PTR TO LONG,pop,mo:PTR TO magicobj,
        infomatch=0,locarr:PTR TO LONG

    MOVE.L A1,taglist
    MOVE.L A2,pop

    get(pop,MUIA_USERDATA,{mo})
    locarr:=mo.strings
    get(mo.infomatch,MUIA_MENUITEM_CHECKED,{infomatch})

    WHILE taglist[i++] DO NOP
    i--

    taglist[i++]:=TAG_MORE

    myown:=[ASLFR_TITLETEXT,locarr[MSG_FREQTITLE],
            ASLFR_DOMULTISELECT,TRUE,
            ASLFR_REJECTICONS,Not(infomatch),
            NIL]

    taglist[i++]:=myown
    taglist[i]:=NIL
ENDPROC TRUE

PROC aslclose()
    DEF mo:PTR TO magicobj,pop,freq:PTR TO filerequester,dir,len,strobj,
        cursor,content:PTR TO CHAR,numentries=0,i,wa:PTR TO wbarg,
        type=1,num,locarr:PTR TO LONG

    MOVE.L A1,freq
    MOVE.L A2,pop

    get(pop,MUIA_USERDATA,{mo})

    locarr:=mo.strings

    clearstring(mo.reserved,1024)

    IF freq.numargs=1
        len:=StrLen(freq.drawer)+StrLen(freq.file)+64
        dir:=String(len)
        StrCopy(dir,freq.drawer,ALL)
        AddPart(dir,freq.file,len)
        get(pop,MUIA_POPSTRING_STRING,{strobj})
        get(strobj,MUIA_STRING_BUFFERPOS,{cursor})
        get(strobj,MUIA_STRING_CONTENTS,{content})
        StrCopy(mo.reserved,'',ALL)

        IF mo.dtlevel
            IF Not(hashunks(dir))
                num:=available(content,cursor,dir,mo)

                IF num>1 THEN type:=Mui_RequestA(mo.app,mo.win,0,0,mo.twlist,locarr[MSG_SELECTOP],NIL)

                DisposeLink(mo.twlist)

                IF type THEN gettool(content,cursor,dir,mo,ListItem(mo.toolorder,type-1))

                IF mo.tool
                    StrAdd(mo.reserved,mo.tool,ALL)
                    StrAdd(mo.reserved,' ',ALL)
                    DisposeLink(mo.tool)
                    mo.tool:=NIL
                ENDIF
            ENDIF
        ENDIF

        IF cursor>0 THEN StrAdd(mo.reserved,content,cursor)
        IF (content[cursor-1]<>" ") AND (cursor>1) THEN StrAdd(mo.reserved,' ',ALL)
        IF findspace(dir) THEN StrAdd(mo.reserved,'"',1)
        StrAdd(mo.reserved,dir,ALL)
        IF (StrLen(freq.file)>0) AND findspace(dir) THEN StrAdd(mo.reserved,'"',1)
        IF StrLen(content+cursor)<StrLen(content)
            IF content[cursor+1]<>" " THEN StrAdd(mo.reserved,' ',ALL)
            StrAdd(mo.reserved,content+cursor,ALL)
        ELSE
            IF (content[cursor+1]<>" ") AND (StrLen(FilePart(dir))>0) THEN StrAdd(mo.reserved,' ',ALL)
        ENDIF
        doMethod(strobj,[MUIM_SET,MUIA_STRING_CONTENTS,mo.reserved])
        doMethod(strobj,[MUIM_SET,MUIA_STRING_BUFFERPOS,cursor+StrLen(dir)+1])
    ELSEIF freq.numargs>1
        numentries:=freq.numargs-1
        wa:=freq.arglist
        dir:=String(1024)
        clearstring(mo.reserved,1024)
        FOR i:=0 TO numentries
            NameFromLock(wa.lock,dir,1024)
            AddPart(dir,wa.name,1024)
            get(pop,MUIA_POPSTRING_STRING,{strobj})
            get(strobj,MUIA_STRING_BUFFERPOS,{cursor})
            get(strobj,MUIA_STRING_CONTENTS,{content})

            IF cursor>0 THEN StrCopy(mo.reserved,content,cursor)
            IF (content[cursor-1]<>" ") AND (cursor>1) THEN StrAdd(mo.reserved,' ',ALL)
            IF findspace(dir) THEN StrAdd(mo.reserved,'"',1)
            StrAdd(mo.reserved,dir,ALL)
            IF (StrLen(freq.file)>0) AND findspace(dir) THEN StrAdd(mo.reserved,'"',1)
            IF (content[cursor+1]<>" ") AND (StrLen(FilePart(dir))>0) THEN StrAdd(mo.reserved,' ',ALL)
            StrAdd(mo.reserved,content+cursor,ALL)
            doMethod(strobj,[MUIM_SET,MUIA_STRING_CONTENTS,mo.reserved])
            doMethod(strobj,[MUIM_SET,MUIA_STRING_BUFFERPOS,cursor+StrLen(mo.reserved)])
            wa++
        ENDFOR
    ENDIF

    DisposeLink(dir)

    doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,mo.inputgadget])
ENDPROC

PROC apphook()
    DEF caller,mo:PTR TO magicobj,wa:PTR TO wbarg,strobj,cursor=0,
        content=NIL,dir,am:PTR TO appmessage,numentries,i,type=1,num,
        locarr:PTR TO LONG,appstate,flashexec,iconified

    MOVE.L A2,caller
    MOVE.L (A1),am

    get(caller,MUIA_USERDATA,{mo})

    locarr:=mo.strings

    dir:=String(1024)

    numentries:=am.numargs
    wa:=am.arglist
    dir:=String(1024)

    /* Flash execution = Erase gadget and fill with dropped data */

    get(mo.flashexec,MUIA_MENUITEM_CHECKED,{flashexec})

    IF flashexec
        get(mo.app,MUIA_APPLICATION_ICONIFIED,{iconified})
        IF iconified THEN doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,''])
    ENDIF

    clearstring(mo.reserved,1024)

    FOR i:=1 TO numentries
        NameFromLock(wa.lock,dir,1024)
        AddPart(dir,wa.name,1024)
        get(mo.popasl,MUIA_POPSTRING_STRING,{strobj})
        get(strobj,MUIA_STRING_BUFFERPOS,{cursor})
        get(strobj,MUIA_STRING_CONTENTS,{content})
        StrCopy(mo.reserved,'',ALL)

        IF numentries=1

            IF mo.dtlevel
                IF Not(hashunks(dir))
                    num:=available(content,cursor,dir,mo)

                    get(mo.app,MUIA_APPLICATION_ICONIFIED,{appstate})

                    IF num>1 THEN type:=Mui_RequestA(IF appstate THEN 0 ELSE mo.app,IF appstate THEN 0 ELSE mo.win,0,IF appstate THEN 'FinalExecute' ELSE 0,mo.twlist,locarr[MSG_SELECTOP_APPICONIFIED],NIL)

                    DisposeLink(mo.twlist)

                    IF type THEN gettool(content,cursor,dir,mo,ListItem(mo.toolorder,type-1))

                    IF mo.tool
                        StrAdd(mo.reserved,mo.tool,ALL)
                        StrAdd(mo.reserved,' ',ALL)
                        DisposeLink(mo.tool)
                        mo.tool:=NIL
                    ENDIF
                ENDIF
            ENDIF
        ENDIF

        IF cursor>0 THEN StrAdd(mo.reserved,content,cursor)
        IF (content[cursor-1]<>" ") AND (cursor>1) THEN StrAdd(mo.reserved,' ',ALL)
        IF findspace(dir) THEN StrAdd(mo.reserved,'"',1)
        StrAdd(mo.reserved,dir,ALL)
        IF (StrLen(wa.name)>0) AND findspace(dir) THEN StrAdd(mo.reserved,'"',1)
        IF (content[cursor+1]<>" ") AND (StrLen(FilePart(dir))>0) THEN StrAdd(mo.reserved,' ',ALL)
        StrAdd(mo.reserved,content+cursor,ALL)
        doMethod(strobj,[MUIM_SET,MUIA_STRING_CONTENTS,mo.reserved])
        doMethod(strobj,[MUIM_SET,MUIA_STRING_BUFFERPOS,cursor+StrLen(mo.reserved)])
        wa++
    ENDFOR

    DisposeLink(dir)
    doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVATE,TRUE])
    doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,mo.inputgadget])
ENDPROC

PROC available(input,cursor,file,mo:PTR TO magicobj)
    DEF tn:PTR TO toolnode,tool:PTR TO tool,
        dtn:PTR TO datatype,lock,lh:PTR TO lh,
        ln:PTR TO ln,cnt=0,
        type,order:PTR TO LONG,locarr:PTR TO LONG

    order:=mo.toolorder

    locarr:=mo.strings

    mo.twlist:=String(256)
    StrCopy(mo.twlist,'',ALL)

    IF isfirst(input,cursor)
        lock:=Lock(file,ACCESS_READ)
        IF lock
            IF dtn:=ObtainDataTypeA(DTST_FILE,lock,0)
                lh:=dtn.toollist
                tn:=lh.head
                ln:=tn
                WHILE ln.succ
                    tool:=tn.tool
                    type:=tool.which
                    IF type<6
                        IF cnt THEN StrAdd(mo.twlist,'|',ALL)
                        StrAdd(mo.twlist,ListItem(['Misc',
                                                   'Information',
                                                   'Browse',
                                                   'Edit',
                                                   'Print',
                                                   'Mail'],type),ALL)
                        order[cnt]:=type
                        cnt++
                    ENDIF
                    ln:=ln.succ
                    tn:=ln
                ENDWHILE
                StrAdd(mo.twlist,locarr[MSG_OP_NOTHING],ALL)
                ReleaseDataType(dtn)
            ENDIF
            UnLock(lock)
        ENDIF
    ENDIF
ENDPROC cnt

PROC gettool(input,cursor,file,mo:PTR TO magicobj,tooltype)
    DEF tn:PTR TO toolnode,tool:PTR TO tool,
        dtn:PTR TO datatype,lock

    mo.tool:=NIL
    IF isfirst(input,cursor)
        lock:=Lock(file,ACCESS_READ)
        IF lock
            IF dtn:=ObtainDataTypeA(DTST_FILE,lock,0)
                IF tn:=FindToolNodeA(dtn.toollist,[TOOLA_WHICH,tooltype,NIL])
                    tool:=tn.tool
                    IF tool.program
                        mo.tool:=String(StrLen(tool.program))
                        IF mo.tool
                            StrCopy(mo.tool,tool.program,ALL)
                        ENDIF
                    ENDIF
                ENDIF
                ReleaseDataType(dtn)
            ENDIF
            UnLock(lock)
        ENDIF
    ENDIF
ENDPROC

PROC hashunks(file)
    DEF fh,has=0,firsthunk=0

    IF fh:=Open(file,OLDFILE)
        Read(fh,{firsthunk},4)
        IF firsthunk=HUNK_HEADER THEN has:=TRUE
        Close(fh)
    ENDIF
ENDPROC has

/* The best thing in this program ? */

PROC dosmagic(strgad,popobject,application)
    DEF string:PTR TO CHAR,active,mo:PTR TO magicobj,pos,mode=0,
        lock=NIL,dir,locarr:PTR TO LONG,
        myead:PTR TO exalldata,dl:PTR TO doslist,entry:PTR TO doslist,
        ead=NIL:PTR TO exalldata,eac=NIL:PTR TO exallcontrol,more=0,found=0,
        numfound=0,start,end,dirlen,patlen,
        matchinfo=0,infomatch[20]:STRING,
        locklist:PTR TO LONG,lockentry:PTR TO LONG,
        force=0,pathdir[1024]:STRING,
        dosscan,wbpathscan,assignlock,
        al:PTR TO assignlist

    dir:='PROGDIR:'

    get(application,MUIA_USERDATA,{mo})

    mo.rawstring:=String(1050)
    mo.patstring:=String(2120)
    mo.dirstring:=String(1024) /* ca. 5.2 KByte for Strings */

    locarr:=mo.strings

    /* Check if I should match .info`s */

    get(mo.infomatch,MUIA_MENUITEM_CHECKED,{matchinfo})

    /* Check if I should scan all DOS units */

    get(mo.dosscan,MUIA_MENUITEM_CHECKED,{dosscan})

    /* Check if I should scan WB pathes */

    get(mo.wbpathscan,MUIA_MENUITEM_CHECKED,{wbpathscan})

    /* At first get the string from the string gadget */

    get(strgad,MUIA_STRING_CONTENTS,{string})

    /* If it is empty so call normal filerequester and return */

    IF StrLen(TrimStr(string))=0
     callasl:
        get(popobject,MUIA_POPASL_ACTIVE,{active})
        IF active=FALSE
            doMethod(popobject,[MUIM_POPSTRING_OPEN,NIL])
        ENDIF
        JUMP endsearch
    ENDIF

    /* Now copy the string to a raw buffer */

    StrCopy(mo.rawstring,string,ALL)

    /* Get the current buffer position of the cursor */

    get(strgad,MUIA_STRING_BUFFERPOS,{pos})

   /* Walk back until I will find me at position 0 or there is a
      space character or directory sign like "/" or ":" */

   /* At first we have to check, if there is an apostrophe,
      that could include my space-including path,
      a really hard work :( */

    IF findapostr(string,"-",pos-1)>-1
        start:=findapostr(string,"-",pos-1)
        start++
    ELSE
        start:=spacepos(string,"-",pos-1)
    ENDIF

    end:=string+pos

    IF (end-start)=0 THEN JUMP callasl

    StrCopy(mo.rawstring,start,end-start)
    StrCopy(mo.patstring,FilePart(mo.rawstring),ALL)
    StrCopy(mo.dirstring,mo.rawstring,PathPart(mo.rawstring)-mo.rawstring)

    dirlen:=StrLen(mo.dirstring)
    patlen:=StrLen(mo.patstring)

    IF (dirlen=0) AND (patlen=0)
        JUMP callasl
    ELSEIF (dirlen) AND (patlen=0)
        StrCopy(mo.patstring,'#?',ALL)
    ENDIF

     /* Now let`s start the fast search */

    IF dirlen=0 THEN mode:=1 ELSE mode:=0

    SELECT mode
        CASE 0
            lock:=Lock(mo.dirstring,ACCESS_READ)
            IF lock=NIL
                doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_FATALERROR])
                doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_FATALERROR])
                Delay(25)
                doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF])
                doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF])
                JUMP endsearch
            ENDIF
        CASE 1
            lock:=Lock(dir,ACCESS_READ)
            IF lock=NIL
                doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_FATALERROR])
                doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_FATALERROR])
                Delay(25)
                doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF])
                doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF])
                JUMP endsearch
            ENDIF
    ENDSELECT

    StrAdd(mo.patstring,'#?',ALL)

    StrCopy(mo.reserved,mo.patstring,ALL)

    IF ParsePatternNoCase(mo.reserved,mo.patstring,2120)=-1
        request(mo,locarr[MSG_REQTITLE],locarr[MSG_OKAY],locarr[MSG_HEAVYRECURSION],NIL)
        UnLock(lock)
        JUMP endsearch
    ENDIF

    ParsePatternNoCase('#?.info',infomatch,20)

    ead:=New(Mul(SIZEOF exalldata,32))

    IF (eac:=AllocDosObject(DOS_EXALLCONTROL,NIL))=NIL
        request(mo,locarr[MSG_REQTITLE],locarr[MSG_OKAY],locarr[MSG_NOMEM],NIL)
        UnLock(lock)
        JUMP endsearch
    ENDIF

    eac.entries:=0
    eac.lastkey:=0
    eac.matchstring:=mo.patstring

    doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_PROCESSING])
    doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_PROCESSING])

    REPEAT
        more:=ExAll(lock,ead,Mul(SIZEOF exalldata,32),ED_TYPE,eac)
        IF eac.entries
            myead:=ead
            WHILE myead
                IF matchinfo=FALSE
                    IF MatchPatternNoCase(infomatch,myead.name) THEN JUMP nextentry
                ENDIF
                StringF(mo.rawstring,'\s\s',myead.name,IF myead.type>0 THEN '/' ELSE '')
                doMethod(mo.findlist,[MUIM_LIST_INSERTSINGLE,mo.rawstring,MUIV_LIST_INSERT_SORTED])
                numfound++
              nextentry:
                myead:=myead.next
            ENDWHILE
            found:=TRUE
        ENDIF
    UNTIL Not(more)

    IF (numfound=0) AND (wbpathscan) AND (StrLen(mo.dirstring)=0)
        pathdir:=String(1024)
        locklist:=Shl(getwbpath(mo),2)
        IF locklist
            eac.entries:=0
            eac.lastkey:=0
            eac.matchstring:=mo.patstring
            lockentry:=locklist
            WHILE lockentry
                REPEAT
                    more:=ExAll(lockentry[1],ead,Mul(SIZEOF exalldata,32),ED_TYPE,eac)
                    IF eac.entries
                        myead:=ead
                        WHILE myead
                            IF matchinfo=FALSE
                                IF MatchPatternNoCase(infomatch,myead.name) THEN JUMP nextentry2
                            ENDIF
                            IF isfirst(string,pos)
                                StringF(mo.rawstring,'\s\s',myead.name,IF myead.type>0 THEN '/' ELSE '')
                            ELSE
                                NameFromLock(lockentry[1],pathdir,1024)
                                AddPart(pathdir,myead.name,1024)
                                StringF(mo.rawstring,'\s\s',pathdir,IF myead.type>0 THEN '/' ELSE '')
                            ENDIF
                            doMethod(mo.findlist,[MUIM_LIST_INSERTSINGLE,mo.rawstring,MUIV_LIST_INSERT_BOTTOM])
                            numfound++
                          nextentry2:
                            myead:=myead.next
                        ENDWHILE
                        found:=TRUE
                    ENDIF
                UNTIL Not(more)
                eac.entries:=0
                eac.lastkey:=0
                eac.matchstring:=mo.patstring
                UnLock(lockentry[1])
                lockentry:=Shl(lockentry[0],2)
            ENDWHILE
            free_evl(locklist)
        ENDIF
        IF pathdir THEN DisposeLink(pathdir)
        force:=TRUE
    ENDIF

    IF ((numfound=0) OR force) AND dosscan AND (StrLen(mo.dirstring)=0)
        dl:=LockDosList(LDF_READ OR LDF_ASSIGNS)
        entry:=dl

        WHILE entry:=NextDosEntry(entry,LDF_ASSIGNS)
            eac.entries:=0
            eac.lastkey:=0
            eac.matchstring:=mo.patstring
            al:=entry.list

            IF assignlock:=DupLock(entry.lock)
                REPEAT
                    more:=ExAll(assignlock,ead,Mul(SIZEOF exalldata,32),ED_TYPE,eac)
                    IF eac.entries
                        myead:=ead
                        WHILE myead
                            IF matchinfo=FALSE
                                IF MatchPatternNoCase(infomatch,myead.name) THEN JUMP nextentry3
                            ENDIF
                            StringF(mo.rawstring,'\s:\s\s',bcpl2aptr(entry.name),myead.name,IF myead.type>0 THEN '/' ELSE '')
                            doMethod(mo.findlist,[MUIM_LIST_INSERTSINGLE,mo.rawstring,MUIV_LIST_INSERT_SORTED])
                            numfound++
                          nextentry3:
                            myead:=myead.next
                        ENDWHILE
                        found:=TRUE
                    ENDIF
                UNTIL Not(more)
                UnLock(assignlock)
            ENDIF

            IF al.next THEN al:=al.next

            IF al.lock
                WHILE al
                    IF assignlock:=DupLock(al.lock)
                        eac.entries:=0
                        eac.lastkey:=0
                        eac.matchstring:=mo.patstring
                        REPEAT
                            more:=ExAll(assignlock,ead,Mul(SIZEOF exalldata,32),ED_TYPE,eac)
                            IF eac.entries
                                myead:=ead
                                WHILE myead
                                    IF matchinfo=FALSE
                                        IF MatchPatternNoCase(infomatch,myead.name) THEN JUMP nextentry4
                                    ENDIF
                                    StringF(mo.rawstring,'\s:\s\s',bcpl2aptr(entry.name),myead.name,IF myead.type>0 THEN '/' ELSE '')
                                    doMethod(mo.findlist,[MUIM_LIST_INSERTSINGLE,mo.rawstring,MUIV_LIST_INSERT_SORTED])
                                    numfound++
                                  nextentry4:
                                    myead:=myead.next
                                ENDWHILE
                                found:=TRUE
                            ENDIF
                        UNTIL Not(more)
                        UnLock(assignlock)
                    ENDIF
                    al:=al.next
                ENDWHILE
            ENDIF
        ENDWHILE

        UnLockDosList(LDF_READ OR LDF_ASSIGNS)

        force:=TRUE
    ENDIF

    IF ((numfound=0) OR force) AND (StrLen(mo.dirstring)=0)
        dl:=LockDosList(LDF_READ OR LDF_ALL)
        entry:=dl

        WHILE entry:=NextDosEntry(entry,LDF_ALL)
            IF MatchPatternNoCase(mo.patstring,bcpl2aptr(entry.name))
                StringF(mo.rawstring,'\s:',bcpl2aptr(entry.name))
                doMethod(mo.findlist,[MUIM_LIST_INSERTSINGLE,mo.rawstring,MUIV_LIST_INSERT_BOTTOM])
                found:=TRUE
                numfound++
            ENDIF
        ENDWHILE
        UnLockDosList(LDF_READ OR LDF_ALL)
    ENDIF

    IF found AND (numfound=1)
        doMethod(mo.findlist,[MUIM_SET,MUIA_LIST_ACTIVE,0])
        doMethod(mo.app,[MUIM_CALLHOOK,mo.getfound])
    ELSEIF found
        doMethod(mo.findlist,[MUIM_SET,MUIA_LIST_ACTIVE,0])
        doMethod(mo.findwin,[MUIM_SET,MUIA_WINDOW_OPEN,TRUE])
    ENDIF

    IF found
        doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OK])
        doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OK])
    ELSE
        doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_FATALERROR])
        doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_FATALERROR])
    ENDIF

    Delay(25)
    doMethod(mo.lamp1,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF])
    doMethod(mo.lamp2,[MUIM_SET,MUIA_LAMP_COLOR,MUIV_LAMP_COLOR_OFF])

endsearch:
    IF lock THEN UnLock(lock)
    IF ead THEN Dispose(ead)
    IF eac THEN FreeDosObject(DOS_EXALLCONTROL,eac)
    DisposeLink(mo.rawstring)
    DisposeLink(mo.patstring)
    DisposeLink(mo.dirstring)
ENDPROC

PROC getfound()
    DEF caller,mo:PTR TO magicobj,active=0,entry:PTR TO CHAR,
        input:PTR TO CHAR,start:PTR TO CHAR,end:PTR TO CHAR,
        cursor,found1=0,found2=0,bufstring=0:PTR TO CHAR,
        entrylen=0,type=1,num,
        pp:PTR TO CHAR,locarr:PTR TO LONG,dtscan=0,newcursorpos

    MOVE.L A2,caller

    get(caller,MUIA_USERDATA,{mo})

    get(mo.dtscan,MUIA_MENUITEM_CHECKED,{dtscan})

    locarr:=mo.strings

    get(mo.findlist,MUIA_LIST_ACTIVE,{active})

    IF active=MUIV_LIST_ACTIVE_OFF THEN RETURN 0

    doMethod(mo.findlist,[MUIM_LIST_GETENTRY,active,{entry}])
    get(mo.inputgadget,MUIA_STRING_CONTENTS,{input})

    mo.rawstring:=String(1030)
    StrCopy(mo.rawstring,'',ALL)

    /* Now I must do this: <Old string part I><New string><rest> */

    get(mo.inputgadget,MUIA_STRING_BUFFERPOS,{cursor})

    IF cursor=0
        start:=input
    ELSEIF (start:=findapostr(input,"-",cursor-1))=-1
        start:=spacepos(input,"-",cursor-1)
    ENDIF

    /* Add string before pattern */

    IF start-input THEN StrAdd(mo.rawstring,input,start-input)

    end:=input+cursor

    /* Cut out pattern */

    IF (end-start)>0
        bufstring:=String(end-start)
        StrCopy(bufstring,start,end-start)
    ENDIF

    /* Cut out string before pattern */

    clearstring(mo.reserved,1024)
    IF (start-input)>0 THEN StrCopy(mo.reserved,input,start-input)

    /* Test for white spaces in found entry */

    found1:=findspace(entry)
    found2:=findspace(bufstring)

    /* Add white space for spaces between words */

    IF (start[-1]<>32) AND (start>input) THEN StrAdd(mo.rawstring,' ',1)

    /* Check for toolnode ! */

    IF dtscan AND (mo.dtlevel>DT_LEVEL_NODT)

        mo.toolfile:=String(1024)
        StrCopy(mo.toolfile,'',ALL)

        IF bufstring
            pp:=PathPart(bufstring)
            IF FilePart(bufstring)>bufstring
                StrAdd(mo.toolfile,bufstring+IF bufstring[0]=34 THEN 1 ELSE 0,
                       pp-bufstring+(IF pp[0]="/" THEN 1 ELSE 0)-(IF bufstring[0]=34 THEN 1 ELSE 0))
            ENDIF
        ENDIF

        StrAdd(mo.toolfile,entry,ALL)

        IF hashunks(mo.toolfile) THEN JUMP endtoolnodecheck

        num:=available(input,cursor,mo.toolfile,mo)

        IF num>1 THEN type:=Mui_RequestA(mo.app,mo.win,0,0,mo.twlist,locarr[MSG_SELECTOP],NIL)

        DisposeLink(mo.twlist)

        IF type THEN gettool(input,cursor,mo.toolfile,mo,ListItem(mo.toolorder,type-1))

        IF mo.tool
            StrAdd(mo.rawstring,mo.tool,ALL)
            StrAdd(mo.rawstring,' ',ALL)
            DisposeLink(mo.tool)
            DisposeLink(mo.toolfile)
            mo.tool:=NIL
            mo.toolfile:=NIL
        ENDIF
    ENDIF

endtoolnodecheck:

    /* End of toolnode check */

    /* If there are white spaces in found entry, then add apostrophe */

    IF found1
        IF (entry[0]<>34) AND (start[0]<>34) THEN StrAdd(mo.rawstring,'"',ALL)
    ENDIF

    /* If there was a pattern, then add path of the pattern */

    IF bufstring
        pp:=PathPart(bufstring)
        IF FilePart(bufstring)>bufstring
            StrAdd(mo.rawstring,bufstring,pp-bufstring+IF pp[0]="/" THEN 1 ELSE 0)
        ENDIF
    ENDIF

    /* Add found entry */

    StrAdd(mo.rawstring,entry,ALL)

    /* Include all in apostrophes, if white spaces are found in found entry */

    entrylen:=StrLen(entry)-1

    IF found1 OR found2
        IF (entry[entrylen]<>"/") AND (entry[entrylen]<>":") THEN StrAdd(mo.rawstring,'"',ALL)
    ENDIF

    /* Add a white space */

    IF (end[0]<>32) AND (start[0]<>34) AND (entry[entrylen]<>"/") AND (entry[entrylen]<>":") OR (Char(mo.rawstring+StrLen(mo.rawstring)-1)=34) THEN StrAdd(mo.rawstring,' ',1)

    newcursorpos:=StrLen(mo.rawstring)

    /* Following lines are trashed, because they do thousands of steps
       which could be done in two short ones
---------------------------------------------------------------------

    StrCopy(mo.reserved,input,ALL)

    strshrink(mo.reserved,(mo.reserved)+(start-input),(mo.reserved)+(end-input),bufstring)

    strinsert(mo.rawstring,mo.reserved,bufstring,start-input)

    StrCopy(mo.rawstring,mo.reserved,ALL)


----------------------------------------------------------------------*/

    StrAdd(mo.rawstring,end,ALL)

    doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,mo.rawstring])
    doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_BUFFERPOS,newcursorpos])

    doMethod(mo.findwin,[MUIM_SET,MUIA_WINDOW_OPEN,FALSE])
    doMethod(mo.findlist,[MUIM_LIST_CLEAR])

    doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,mo.inputgadget])

    IF bufstring THEN DisposeLink(bufstring)
    DisposeLink(mo.rawstring)
ENDPROC

PROC addtolist()
    DEF caller,mo:PTR TO magicobj,numentries=0,string,i,entry

    MOVE.L A2,caller

    get(caller,MUIA_USERDATA,{mo})
    get(mo.mylist,MUIA_LIST_ENTRIES,{numentries})

    doMethod(mo.mylist,[MUIM_LIST_SELECT,MUIV_LIST_SELECT_ACTIVE,MUIV_LIST_SELECT_OFF,0])

    get(mo.inputgadget,MUIA_STRING_CONTENTS,{string})

    StrCopy(mo.reserved,string,ALL)

    IF StrLen(TrimStr(string))=0 THEN RETURN

    FOR i:=0 TO numentries-1
        doMethod(mo.mylist,[MUIM_LIST_GETENTRY,i,{entry}])
        IF Stricmp(entry,string)=0 THEN RETURN
    ENDFOR

    IF numentries=mo.maxlastinputs
        doMethod(mo.mylist,[MUIM_LIST_REMOVE,MUIV_LIST_REMOVE_LAST])
    ENDIF

    doMethod(mo.mylist,[MUIM_LIST_INSERTSINGLE,mo.reserved,MUIV_LIST_INSERT_TOP])

ENDPROC

PROC checkval()
    DEF strobj,ismax=TRUE,min,max,actual

    MOVE.L (A1),strobj
    MOVE.L 4(A1),ismax
    MOVE.L 8(A1),min
    MOVE.L 12(A1),max

    get(strobj,MUIA_STRING_INTEGER,{actual})

    IF ismax
        IF actual>max
            doMethod(strobj,[MUIM_SET,MUIA_STRING_INTEGER,max])
            RETURN
        ENDIF
    ENDIF

    IF actual<min THEN doMethod(strobj,[MUIM_SET,MUIA_STRING_INTEGER,min])
ENDPROC

PROC megacheck()
    DEF caller,mo:PTR TO magicobj,thing

    MOVE.L A2,caller

    get(caller,MUIA_USERDATA,{mo})

    mo.optionwinisopen:=Not(mo.optionwinisopen)
    IF mo.optionwinisopen=TRUE THEN RETURN

    get(mo.outputstrg,MUIA_STRING_CONTENTS,{thing})

    IF StrLen(TrimStr(thing))=0 THEN doMethod(mo.outputstrg,[MUIM_SET,MUIA_STRING_CONTENTS,mo.inputstr])

    get(mo.currdirstrg,MUIA_STRING_CONTENTS,{thing})

    IF StrLen(TrimStr(thing))=0 THEN doMethod(mo.currdirstrg,[MUIM_SET,MUIA_STRING_CONTENTS,'PROGDIR:'])

    /* OBSOLETE since V1.2

        doMethod(mo.app,[MUIM_CALLHOOK,mo.checkval,mo.stackstrg,FALSE,4096,-1])
    */

    doMethod(mo.app,[MUIM_CALLHOOK,mo.checkval,mo.priostrg,TRUE,-128,127])
ENDPROC

PROC listmove()
   DEF caller,str,mo:PTR TO magicobj,num

   MOVE.L A2,caller

   get(caller,MUIA_USERDATA,{mo})

   IF mo.popstate
       get(mo.mylist,MUIA_LIST_ACTIVE,{num})
       doMethod(mo.mylist,[MUIM_LIST_GETENTRY,num,{str}])
       doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,str])
       doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,mo.inputgadget])
   ENDIF

ENDPROC

PROC keylistmove()
    DEF caller,mo:PTR TO magicobj,direction,maxentries,
        entry,state=0

    MOVE.L A2,caller
    MOVE.L (A1),direction
    get(caller,MUIA_USERDATA,{mo})
    get(mo.mylist,MUIA_LIST_ENTRIES,{maxentries})

    IF mo.active>maxentries THEN mo.active:=(maxentries-1)

    IF direction=CURSORUP
        IF mo.active>0 THEN mo.active:=mo.active-1
    ELSEIF direction=CURSORDOWN
        IF mo.active<(maxentries-1) THEN mo.active:=mo.active+1
    ELSEIF direction=TABKEY
        get(mo.findwin,MUIA_WINDOW_OPEN,{state})
        IF state=0
            doMethod(mo.win,[MUIM_SET,MUIA_WINDOW_ACTIVEOBJECT,mo.inputgadget])
            dosmagic(mo.inputgadget,mo.popasl,mo.app)
        ENDIF
        RETURN 0
    ELSE
        RETURN 0
    ENDIF

    IF maxentries>0
        doMethod(mo.mylist,[MUIM_LIST_GETENTRY,mo.active,{entry}])
        doMethod(mo.inputgadget,[MUIM_SET,MUIA_STRING_CONTENTS,entry])
        /* Simulation */
        /*doMethod(mo.mylist,[MUIM_SET,MUIA_LIST_ACTIVE,mo.active])*/

        IF mo.popstate=TRUE THEN doMethod(mo.mylist,[MUIM_SET,MUIA_LIST_ACTIVE,mo.active])
    ENDIF
ENDPROC

/*PROC setpopstate()
    DEF caller,mo:PTR TO magicobj

    MOVE.L A2,caller
    get(caller,MUIA_USERDATA,{mo})

    /*mo.popstate:=Not(mo.popstate)*/

    IF mo.popstate
        doMethod(mo.mylist,[MUIM_SET,MUIA_LIST_ACTIVE,MUIV_LIST_ACTIVE_TOP]) /*mo.active])*/
    ENDIF
ENDPROC*/

PROC isfirst(str:PTR TO CHAR,cursor)
    DEF i=0,norm:PTR TO CHAR,start

    norm:=TrimStr(str)
    IF StrLen(norm)=0 THEN RETURN TRUE
    start:=norm-str
    IF norm[0]=34
        IF StrLen(TrimStr(norm+cursor))=0 THEN RETURN TRUE
    ELSE
        FOR i:=start TO (cursor-start-1)
            IF norm[i]<33 THEN RETURN FALSE
        ENDFOR
    ENDIF

ENDPROC TRUE

PROC free_evl(evl:PTR TO LONG)
    DEF next,this:PTR TO LONG

    this:=evl
    next:=this[0]

    LOOP
        FreeVec(this)
        IF next=0 THEN RETURN
        this:=Shl(next,2)
        next:=this[0]
    ENDLOOP
ENDPROC

PROC construct(pool,str)
    DEF new

    IF (new:=AllocPooled(pool,StrLen(str)+1))
        CopyMem(str,new,StrLen(str))
        PutChar(new+StrLen(str),0)
    ENDIF
ENDPROC new

PROC destruct(pool,entry)
    FreePooled(pool,entry,StrLen(entry)+1)
ENDPROC

PROC setstrings(obj:PTR TO magicobj,arr:PTR TO LONG,name,standard:PTR TO LONG)
        DEF i=0,max=MSG_MAX

        obj.strings:=standard

        IF localebase=NULL THEN RETURN

        obj.locale:=OpenLocale(NULL)
        IF obj.locale=NIL THEN RETURN
        obj.catalog:=OpenCatalogA(obj.locale,name,NIL)
        IF obj.catalog=NIL THEN RETURN

        FOR i:=0 TO max-1
                arr[i]:=GetCatalogStr(obj.catalog,i,standard[i])
        ENDFOR

        obj.strings:=arr
ENDPROC

PROC clearmem(mem,size)
        DEF i
        
        FOR i:=0 TO size-1 
                PutChar(mem+i,0)
        ENDFOR
ENDPROC 

PROC rawkey2key(in) RETURN Shr(in,16)

/* Make a special version for pre-MUI3.7-users :)
   Include this line */

PROC request(mo:PTR TO magicobj,title,gadget,text,args) RETURN Mui_RequestA(mo.app,mo.win,0,title,gadget,text,args)

/* This is the MUI3.8-Version
PROC request(mo:PTR TO magicobj,title,gadget,text,args)
    DEF handle
    handle:=doMethod(mo.win,[MUIM_CREATEBUBBLE,0,0,text,0])
    IF handle=0
        /* Fallback */
        RETURN Mui_RequestA(mo.app,mo.win,NIL,title,gadget,text,args)
    ENDIF
    Delay(100)
    doMethod(mo.win,[MUIM_DELETEBUBBLE,handle])
ENDPROC 0*/

PROC findspace(in:PTR TO CHAR)
    DEF i=0

    WHILE in[i]
        IF in[i]=" " THEN RETURN TRUE
        i++
    ENDWHILE
ENDPROC 0

PROC spacepos(in:PTR TO CHAR,dir,start)
    DEF i=0

    IF dir="+"
        WHILE in[i]
            IF in[i]=" " THEN RETURN in+i-1
            i++
        ENDWHILE
        RETURN i-1
    ELSE
       i:=start
        WHILE i>0
            IF in[i]=" " THEN RETURN in+i+1
            i--
        ENDWHILE
        RETURN in
    ENDIF
ENDPROC 0

PROC findapostr(in:PTR TO CHAR,dir,start)
    DEF i=0

    IF dir="+"
        WHILE in[i]
            IF in[i]=34
                IF i
                    IF in[i-1]=" " THEN RETURN in+i
                ELSE
                    RETURN in+i
                ENDIF
            ENDIF
            i++
        ENDWHILE
        RETURN -1
    ELSE
       i:=start
        WHILE i>-1
            IF in[i]=34
                IF i>0
                    IF in[i+1]<>" "
                        IF (in[i-1]=" ") OR ((in+i)=in) THEN RETURN in+i
                    ELSE
                        RETURN -1
                    ENDIF
                ELSE
                    RETURN in+i
                ENDIF
            ENDIF
            i--
        ENDWHILE
        RETURN -1
    ENDIF
ENDPROC -1

PROC bcpl2aptr(in) RETURN Shl(in,2)+1

/*
/* As result of missing StrInsert() I wrote this 8)
   I _have to_ care about enough string space ! :) */

PROC strinsert(string,into,bufstring,pos)
    IF pos
        StrCopy(bufstring,into,pos+1)
    ELSE
        StrCopy(bufstring,'',ALL)
    ENDIF
    StrAdd(bufstring,string,ALL)
    StrAdd(bufstring,into+pos,ALL)
    StrCopy(into,bufstring,ALL)
ENDPROC

/* That`s it: a routine to shrink a string ;) */

PROC strshrink(string,from,to:PTR TO CHAR,bufstring)
    StrCopy(bufstring,string,from-string)
    StrAdd(bufstring,to,ALL)
    StrCopy(string,bufstring,ALL)
ENDPROC
*/

PROC clearstring(ptr:PTR TO CHAR,bandwidth)

    MOVEM.L A0/D0,-(A7)
    MOVE.L ptr,A0
    MOVE.L bandwidth,D0
    SUBQ.L #1,D0
  clearloop:
    MOVE.B #0,(A0)+
    SUBQ.L #1,D0
    BNE.S clearloop
    MOVEM.L (A7)+,A0/D0
ENDPROC

/* Find a string in a gadget list */
/*
PROC findstring(glist)
    DEF g:PTR TO gadget,si:PTR TO stringinfo

    g:=glist

    WHILE g.nextgadget
        IF g.gadgettype AND GTYP_STRGADGET
            si:=g.specialinfo
            RETURN si.buffer
        ENDIF
        g:=g.nextgadget
    ENDWHILE
ENDPROC NIL
*/

/* State of art: Multitasking-Switching with semaphores ! :) */

PROC setmt(sem,state)
    IF state=0
        IF AttemptSemaphore(sem)=0
            ObtainSemaphore(sem)
        ENDIF
    ELSE
        ReleaseSemaphore(sem)
    ENDIF
ENDPROC

PROC doMethod( obj:PTR TO object, msg:PTR TO msg )

        DEF h:PTR TO hook, o:PTR TO object, dispatcher

        IF obj
                o := obj-SIZEOF object  /* instance data is to negative offset */
                h := o.class
                dispatcher := h.entry   /* get dispatcher from hook in iclass */
                MOVEA.L h,A0
                MOVEA.L msg,A1
                MOVEA.L obj,A2          /* probably should use CallHookPkt, but the */
                MOVEA.L dispatcher,A3   /*   original code (DoMethodA()) doesn't. */
                JSR (A3)                /* call classDispatcher() */
                MOVE.L D0,o
                RETURN o
        ENDIF
ENDPROC NIL
/*
PROC bptr2aptr(val)
    DEF out

    MOVE.L D0,-(A7)
    MOVE.L val,D0
    LSL.L #2,D0
    MOVE.L D0,out
    MOVE.L (A7)+,D0
ENDPROC out

PROC aptr2bptr(val)
    DEF out

    MOVE.L D0,-(A7)
    MOVE.L val,D0
    LSR.L #2,D0
    MOVE.L D0,out
    MOVE.L (A7)+,D0
ENDPROC out
*/

/*
** installhook() - Use it like this:
**
**   MODULE 'utility/hooks'
**
**   PROC main()
**      DEF myhook:hook
**      installhook(myhook, {myhookfunc})
**      /* do something with myhook */
**   ENDPROC
**
**   PROC myhookfunc(hook,obj,msg)
**      WriteF('hook:$\h, obj:\d, msg:\d\n',hook,obj,msg)
**   ENDPROC
**
** or if you don't need a ptr to the hook-structure:
**
**   PROC myhookfunc(obj,msg)
**     WriteF('obj:\d, msg:\d\n',obj,msg)
**   ENDPROC
*/

PROC installhook(hook,func)
   DEF r
   MOVE.L hook,A0
   MOVE.L func,12(A0)   /* store address of func in hook.subentry */
   LEA hookentry(PC),A1
   MOVE.L A1,8(A0)      /* store address of hookentry in hook.entry */
   MOVE.L A4,16(A0)     /* store ptr to vars in hook.data */
   MOVE.L A0,r
ENDPROC r

hookentry:
  MOVEM.L D2-D7/A2-A6,-(A7)
  MOVE.L 16(A0),A4      /* move ptr to vars to A4 */
  MOVE.L A0,-(A7)       /* move ptr to hookstructure to the stack */
  MOVE.L A2,-(A7)       /* move ptr to obj to the stack */
  MOVE.L A1,-(A7)       /* move msg to the stack */
  MOVE.L 12(A0),A0      /* move addr. of hookfunc. to A0 */
  JSR (A0)              /* call hookfunc. */
  LEA 12(A7),A7         /* remove the above from the stack */
  MOVEM.L (A7)+,D2-D7/A2-A6
  RTS                   /* go back to the caller (MUI) */

/* _My_ Edit-Hook: I`m very proud of it 8) */

edithook:
    MOVEM.L A0-A6/D0-D7,-(A7) /* all registers to stack */
    MOVE.L 20(A2),A1          /* load pointer to inputevent structure */
    MOVE.B 4(A1),D0           /* get class type */
    CMPI.B #IECLASS_RAWKEY,D0 /* Is it rawkey class ? */
    BNE.S nothing2do          /* If not then break */
    LEA.L code(PC),A0         /* else load pointer to keycode */
    MOVE.W 6(A1),(A0)         /* store received keycode to it */
    LEA.L task(PC),A0         /* load task address pointer */
    MOVE.L (A0),A1            /* read the address */
    LEA.L keysig(PC),A0       /* load key signal pointer */
    MOVE.L (A0),D0            /* read bitmask */
    MOVE.L 4,A6               /* load execbase */
    JSR -324(A6)              /* signal my task */
nothing2do:
    MOVEM.L (A7)+,A0-A6/D0-D7 /* restore registers from stack */
    RTS                       /* return */

task:
LONG 0
keysig:
LONG 0
code:
LONG 0


CHAR 0,0,0,0,'$VER: V1.21 (4.02.98)',0,0,0,0
