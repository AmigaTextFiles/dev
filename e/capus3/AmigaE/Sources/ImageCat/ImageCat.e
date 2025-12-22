->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE ImageCat.e
 EDIR    Workbench:AmigaE/Sources/ImageCat
 ECOPT   ERRLINE
 EXENAME ImageCat
 MAKE    EC
 AUTHOR  NasGûl
 TYPE    EXEDOS
 =====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
OPT PREPROCESS
OPT LARGE
->> MODULES

MODULE 'muimaster','libraries/mui'
MODULE 'tools/boopsi','utility/tagitem','utility/hooks','icon'
MODULE 'wb','workbench/workbench','workbench/startup'
MODULE 'tools/ilbm','tools/ilbmdefs','iff','libraries/iff'
MODULE 'other/plist','intuition/screens','graphics/gfx','graphics/view','reqtools','libraries/reqtools'
MODULE 'dos/dos','dos/var','dos/dostags','tools/easygui','tools/exceptions'
MODULE 'exec/nodes','exec/lists','exec/ports'
MODULE 'rexxsyslib','rexx/rxslib','rexx/storage','rexx/errors'
MODULE '*errorarexx'

-><
->> OBJECTS

->> OBJECT ataimagecat
OBJECT dataimagecat
    mybitmap:LONG
    width:LONG
    height:LONG
    depth:LONG
    suffix:LONG
    imagepresent:LONG
    wbpal:LONG
    iconx:LONG
    icony:LONG
    viewer:LONG
    destg:LONG
    destd:LONG
    winbackdrop:LONG
    stampcommand:LONG
    patternreq:LONG
    scriptdir:LONG
    imagecattools:LONG
    toolslist:LONG
    currenttool:LONG
    screen:LONG
    screenid:LONG
    sigscreen:LONG
    baselock:LONG
    imagelist:LONG
    imageinfolist:LONG
    closearexxlib:LONG
ENDOBJECT
-><
->> OBJECT app_rexx
OBJECT app_arexx
    commands :  PTR TO mui_command
    error    :  hook
ENDOBJECT
-><
->> OBJECT app_display
OBJECT app_display
    getIconDef    : hook
    delIcondef    : hook
ENDOBJECT
-><
->> OBJECT app_obj
OBJECT app_obj
    app       : PTR TO LONG
    wi_stamp      : PTR TO LONG
    im_icon   : PTR TO LONG
    lv_texticon   : PTR TO LONG
    lv_name   : PTR TO LONG
    bt_loadcat    : PTR TO LONG
    bt_view   : PTR TO LONG
    bt_tools      : PTR TO LONG
    bt_copyram    : PTR TO LONG
    bt_copydf0    : PTR TO LONG
ENDOBJECT
-><

-><
->> DEFINITIONS GLOBALES


ENUM    ER_NONE,ER_ONLYWB,ER_LIBMUIMASTER,ER_LIBICON,ER_LIBWORKBENCH,ER_LIBIFF,ER_LIBREQTOOLS,
    ER_NOICON,ER_NOIMAGEPRESENT,ER_NOSTAMPSUFFIX,ER_BADIMAGEPRESENT,ER_NOSCREENID,
    ER_NOSCREEN,ER_NOSIG,ER_NOASSIGN,ER_LIBREXXSYSLIB

ENUM BT_LOADCAT=10,
     BT_VIEW,BT_TOOLS,BT_COPYRAM,BT_COPYDF0,BT_IMGDBL,BT_VIEWSTAMP

ENUM LOADCATA

ENUM ACTION_VIEW,ACTION_TOOLS,ACTION_COPYG,ACTION_COPYD

ENUM F_S,F_D

DEF mycat:PTR TO dataimagecat
DEF myapp:PTR TO app_obj
DEF textfilereq:PTR TO LONG
DEF arexxword:PTR TO LONG
-><

->> main() HANDLE
PROC main() HANDLE
    DEF t
    IF wbmessage=NIL THEN Raise(ER_ONLYWB)
    IF (t:=openLibraries())<>ER_NONE THEN Raise(t)
    IF (t:=initImageCat())<>ER_NONE THEN Raise(t)
    IF NEW myapp.create(NIL,NIL,NIL)
    myapp.init_notifications(NIL)
    setTextList(mycat.imageinfolist)
    lookMUIMessage()
    myapp.dispose()
    ELSE
    WriteF('application MUI failed\n')
    ENDIF
    Wait(Shl(1,mycat.sigscreen))
    Raise(ER_NONE)
EXCEPT
    IF mycat THEN remImageCat()
    closeLibraries()
    SELECT exception
    CASE ER_ONLYWB;         WriteF('Programme WB.\n')
    CASE ER_LIBMUIMASTER;       WriteF('muimaster.library ?\n')
    CASE ER_LIBICON;        WriteF('icon.library ?\n')
    CASE ER_LIBWORKBENCH;       WriteF('workbench.library ?\n')
    CASE ER_LIBIFF;         WriteF('iff.library ?\n')
    CASE ER_LIBREQTOOLS;             WriteF('reqtools.library ?\n')
    CASE ER_NOICON;         WriteF('pas d\aicône. ?\n')
    CASE ER_NOIMAGEPRESENT;       WriteF('ToolType IMAGE_PRESENT absent.\n')
    CASE ER_NOSTAMPSUFFIX;       WriteF('ToolType STAMP_SUFFIX absent.\n')
    CASE ER_BADIMAGEPRESENT;       WriteF('mauvaise image en IMAGE_PRESENT.\n')
    CASE ER_NOSCREENID;       WriteF('ToolType SCREEN_ID absent.\n')
    CASE ER_NOSCREEN;       WriteF('Ouverture de l\aécran impossible.\n')
    CASE ER_NOSIG;           WriteF('AllocSignal impossible.\n')
    CASE ER_NOASSIGN;       WriteF('ImageCat: doit être assigner.\n')
    CASE ER_LIBREXXSYSLIB;           WriteF('rexxsyslib.library ?\n')
    ENDSELECT
ENDPROC
-><->
->> openImageCatScreen() HANDLE
PROC openImageCatScreen() HANDLE
    DEF s=NIL,sig=-1
    IF sig:=AllocSignal(-1)
    mycat.sigscreen:=sig
    IF s:=OpenScreenTagList(0,
            [SA_DEPTH,mycat.depth,
             SA_DISPLAYID,mycat.screenid,
             SA_PUBNAME,'ImageCatScreen',
             SA_TITLE,'ImageCatScreen',
             SA_PUBSIG,mycat.sigscreen,
             SA_TYPE,CUSTOMSCREEN+PUBLICSCREEN,
             SA_PENS,[0,1,1,2,1,3,1,0,2,1,2,1]:INT,    /* Répartition de couleurs WB 2.0 */
             SA_DETAILPEN,1,        /* Detailpen */
             SA_BLOCKPEN,2,     /* BlockPen  */
             SA_PUBTASK,NIL,
             0,0])
        PubScreenStatus(s,0)
->        SetDefaultPubScreen('ImageCatScreen')
->        SetPubScreenModes(SHANGHAI)
        mycat.screen:=s
        loadPalette(s,mycat.imagepresent)
    ELSE
        Raise(ER_NOSCREEN)
    ENDIF
    ELSE
    Raise(ER_NOSIG)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
-><->
->> loadPalette(screen:PTR TO screen,fichier)
PROC loadPalette(screen:PTR TO screen,fichier)
    DEF count,colortable[768]:ARRAY OF INT,iff
    IF iff:=IfFL_OpenIFF(fichier,IFFL_MODE_READ)
    count:=IfFL_GetColorTab(iff,colortable)
    IF (IfFL_FindChunk(iff,"CMAP"))
        LoadRGB4(screen.viewport,colortable,count)
    ENDIF
    IF iff THEN IfFL_CloseIFF(iff)
    ENDIF
ENDPROC
-><->
->> remImageCat()
PROC remImageCat()
    deleteEnvFile()
    IF mycat.closearexxlib
    rexxExecute('Call remlib(''rexxsupport.library'')',RXFUNC+RXFF_STRING)
    rexxExecute('Call remlib(''rexxarplib.library'')',RXFUNC+RXFF_STRING)
    ENDIF
    IF mycat.screen<>NIL THEN CloseS(mycat.screen)
    IF mycat.sigscreen>=0 THEN FreeSignal(mycat.sigscreen)
    IF mycat.mybitmap THEN ilbm_FreeBitMap(mycat.mybitmap)
    IF mycat.suffix<>0 THEN DisposeLink(mycat.suffix)
    IF mycat.imagepresent<>0 THEN DisposeLink(mycat.imagepresent)
    IF mycat.scriptdir<>0 THEN DisposeLink(mycat.scriptdir)
    IF mycat.imagecattools<>0 THEN DisposeLink(mycat.imagecattools)
    IF mycat.viewer<>0 THEN DisposeLink(mycat.viewer)
    IF mycat.patternreq<>0 THEN DisposeLink(mycat.patternreq)
    IF mycat.baselock THEN UnLock(mycat.baselock)
    IF mycat.imagelist THEN cleanList(mycat.imagelist,FALSE,0,LIST_REMOVE)
    IF mycat.imageinfolist THEN cleanList(mycat.imageinfolist,FALSE,0,LIST_REMOVE)
    IF mycat.toolslist THEN cleanList(mycat.toolslist,FALSE,0,LIST_REMOVE)
ENDPROC
-><->
->> initImageCat() HANDLE
PROC initImageCat() HANDLE
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF do=NIL:PTR TO diskobject
    DEF prgname[32]:STRING
    DEF buffer[256]:STRING
    DEF baselock=NIL
    DEF testassign=NIL
    mycat:=New(SIZEOF dataimagecat)
    mycat.mybitmap:=0
    mycat.width:=0
    mycat.height:=0
    mycat.depth:=0
    mycat.suffix:=0
    mycat.winbackdrop:=FALSE
    mycat.screen:=0
    mycat.viewer:=0
    mycat.sigscreen:=-1
    mycat.imagelist:=initList()
    mycat.imageinfolist:=initList()
    mycat.toolslist:=initList()
    mycat.closearexxlib:=FALSE
    initTextList(mycat.imageinfolist)
    arexxword:=initErrorText()
    wb:=wbmessage
    args:=wb.arglist
    textfilereq:=['LoadCat','SaveCat','LoadImg']
    IF testassign:=Lock('ImageCat:',-2)
    UnLock(testassign)
    ELSE
    Raise(ER_NOASSIGN)
    ENDIF
    checkArexxLib()
    baselock:=CurrentDir(args[0].lock)
    StrCopy(prgname,args[0].name,ALL)
    IF do:=GetDiskObject(prgname)
    IF buffer:=FindToolType(do.tooltypes,'IMAGE_PRESENT')
        mycat.imagepresent:=String(EstrLen(buffer))
        StrCopy(mycat.imagepresent,buffer,ALL)
        setEnv('IC_IMAGE_PRESENT',mycat.imagepresent,F_S)
    ELSE
        Raise(ER_NOIMAGEPRESENT)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'STAMP_SUFFIX')
        mycat.suffix:=String(EstrLen(buffer))
        StrCopy(mycat.suffix,buffer,ALL)
        setEnv('IC_STAMP_SUFFIX',mycat.suffix,F_S)
    ELSE
        Raise(ER_NOSTAMPSUFFIX)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'VIEWER')
        mycat.viewer:=String(EstrLen(buffer))
        StrCopy(mycat.viewer,buffer,ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'PAT_REQ')
        mycat.patternreq:=String(EstrLen(buffer))
        StrCopy(mycat.patternreq,buffer,ALL)
    ELSE
        mycat.patternreq:=String(EstrLen('#?'))
        StrCopy(mycat.patternreq,'#?',ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'WBPALETTE')
        mycat.wbpal:=String(EstrLen(buffer))
        StrCopy(mycat.wbpal,buffer,ALL)
    ELSE
        mycat.wbpal:=String(EstrLen('ImageCat:WB.Palette'))
        StrCopy(mycat.wbpal,'ImageCat:WB.Palette',ALL)
    ENDIF
    setEnv('IC_WBPALETTE',mycat.wbpal,F_S)
    IF buffer:=FindToolType(do.tooltypes,'ICON_X')
        mycat.iconx:=Val(buffer,NIL)
    ELSE
        mycat.iconx:=144
    ENDIF
    setEnv('IC_ICONX',mycat.iconx,F_D)
    IF buffer:=FindToolType(do.tooltypes,'ICON_Y')
        mycat.icony:=Val(buffer,NIL)
    ELSE
        mycat.icony:=28
    ENDIF
    setEnv('IC_ICONY',mycat.icony,F_D)
    IF buffer:=FindToolType(do.tooltypes,'SCRIPT_DIR')
        mycat.scriptdir:=String(EstrLen(buffer))
        StrCopy(mycat.scriptdir,buffer,ALL)
    ELSE
        mycat.scriptdir:=String(EstrLen('ImageCat:Scripts/'))
        StrCopy(mycat.scriptdir,'ImageCat:Scripts/',ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'IMAGECAT_TOOLS')
        mycat.imagecattools:=String(EstrLen(buffer))
        StrCopy(mycat.imagecattools,buffer,ALL)
    ELSE
        mycat.imagecattools:=String(EstrLen('ImageCat:ImageCat.Tools'))
        StrCopy(mycat.imagecattools,'ImageCat:ImageCat.Tools',ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'DEST_LEFT')
        mycat.destg:=String(EstrLen(buffer))
        StrCopy(mycat.destg,buffer,ALL)
    ELSE
        mycat.destg:=String(EstrLen('Ram:'))
        StrCopy(mycat.destg,'Ram:',ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'DEST_RIGHT')
        mycat.destd:=String(EstrLen(buffer))
        StrCopy(mycat.destd,buffer,ALL)
    ELSE
        mycat.destd:=String(EstrLen('Df0:'))
        StrCopy(mycat.destd,'Df0:',ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'SCREEN_ID')
        mycat.screenid:=Val(buffer,NIL)
    ELSE
        Raise(ER_NOSCREENID)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'STAMP_COMMAND')
        mycat.stampcommand:=String(EstrLen(buffer))
        StrCopy(mycat.stampcommand,buffer,ALL)
    ENDIF
    IF buffer:=FindToolType(do.tooltypes,'CLOSE_AREXX_LIB') THEN mycat.closearexxlib:=TRUE
    IF buffer:=FindToolType(do.tooltypes,'WINDOW_BACKDROP') THEN mycat.winbackdrop:=MUI_TRUE
    IF Not(getStampBitmap(mycat.imagepresent))
        setEnv('IC_WIDTH',mycat.width,F_D)
        setEnv('IC_HEIGHT',mycat.height,F_D)
        setEnv('IC_DEPTH',mycat.depth,F_D)
        Raise(openImageCatScreen())
    ENDIF
    ELSE
    Raise(ER_NOICON)
    ENDIF
    mycat.baselock:=baselock
    Raise(ER_NONE)
EXCEPT
    IF do THEN FreeDiskObject(do)
    RETURN exception
ENDPROC
-><->
->> deleteEnvFile()
PROC deleteEnvFile()
    DeleteFile('Env:IC_DEPTH')
    DeleteFile('Env:IC_HEIGHT')
    DeleteFile('Env:IC_ICONX')
    DeleteFile('Env:IC_ICONY')
    DeleteFile('Env:IC_IMAGE_PRESENT')
    DeleteFile('Env:IC_STAMP_SUFFIX')
    DeleteFile('Env:IC_WBPALETTE')
    DeleteFile('Env:IC_WIDTH')
ENDPROC
-><->
->> setEnv(nom,data,format)
PROC setEnv(nom,data,format)
    DEF cmd[256]:STRING
    StringF(cmd,IF format=F_S THEN '\s' ELSE '\d',data)
    SetVar(nom,cmd,StrLen(cmd),GVF_GLOBAL_ONLY)
ENDPROC
-><->
->> initTextList(l:PTR TO lh)
PROC initTextList(l:PTR TO lh)
    cleanList(l,0,0,LIST_CLEAN)
    addNode(l,'ilbm.m             © Michael Zucchi',0,0)
    addNode(l,'iff.library        © Christian A. Weber',0,0)
    addNode(l,'reqtools.library   © Nico François',0,0)
    addNode(l,'muimaster.library  © Stefan Stuntz',0,0)
    addNode(l,'ARexx              © William S. Hames',0,0)
    addNode(l,'rexxarplib.library © W.G.L Langeveld',0,0)
    addNode(l,'AmigaE             © Wouter van Oortmerssen',0,0)
    addNode(l,'GoldED             © Dietmar Eilert',0,0)
    addNode(l,'ImageCat           © NasGûl',0,0)
ENDPROC
-><->
->> setTextList(l:PTR TO lh)
PROC setTextList(l:PTR TO lh)
    DEF n:PTR TO ln,nom
    n:=l.head
    getStampBitmap(mycat.imagepresent)
    set(myapp.im_icon,MUIA_Bitmap_Bitmap,mycat.mybitmap)
    domethod(myapp.lv_texticon,[MUIM_List_Clear])
    set(myapp.lv_texticon,MUIA_List_Quiet,MUI_TRUE)
    WHILE n
    IF n.succ<>0
        nom:=n.name
        domethod(myapp.lv_texticon,[MUIM_List_Insert,{nom},1,MUIV_List_Insert_Bottom])
    ENDIF
    n:=n.succ
    ENDWHILE
    set(myapp.lv_texticon,MUIA_List_Quiet,FALSE)
ENDPROC
-><->
->> updateBitmap(file)
PROC updateBitmap(file)
    DEF buf[256]:STRING
    DEF lock,fib:fileinfoblock,buffer[256]:STRING,n:PTR TO ln,nom,l:PTR TO lh
    StringF(buf,'\s\s',file,mycat.suffix)
    getStampBitmap(buf)
    cleanList(mycat.imageinfolist,0,0,LIST_CLEAN)
    IF lock:=Lock(file,-2)
    IF Examine(lock,fib)
        addNode(mycat.imageinfolist,file,0,0)
        StringF(buffer,'Taille :\d Octets.',fib.size)
        StrCopy(buf,buffer,ALL)
        StringF(buffer,'AmigaDos Comment :\s',fib.comment)
        StrCopy(buf,buffer,ALL)
        n:=addNode(mycat.imageinfolist,buf,0,0)
    ENDIF
    UnLock(lock)
    ENDIF
    domethod(myapp.lv_texticon,[MUIM_List_Clear])
    set(myapp.lv_texticon,MUIA_List_Quiet,TRUE)
    l:=mycat.imageinfolist
    n:=l.head
    WHILE n
    IF n.succ<>0
        nom:=n.name
        domethod(myapp.lv_texticon,[MUIM_List_Insert,{nom},1,MUIV_List_Insert_Bottom])
    ENDIF
    n:=n.succ
    ENDWHILE
    set(myapp.lv_texticon,MUIA_List_Quiet,FALSE)
ENDPROC
-><->
->> getStampBitmap(fichier) HANDLE
PROC getStampBitmap(fichier) HANDLE
    DEF ilbm,pi:PTR TO picinfo,bmh:PTR TO bmhd,bm
    IF FileLength(fichier)<>-1
        IF mycat.mybitmap<>0 THEN ilbm_FreeBitMap(mycat.mybitmap)
        IF ilbm:=ilbm_New(fichier,0)
            ilbm_LoadPicture(ilbm,[ILBML_GETBITMAP,{bm},0])
            pi:=ilbm_PictureInfo(ilbm)
            bmh:=pi.bmhd
            mycat.width:=bmh.w
            mycat.height:=bmh.h
            mycat.depth:=bmh.planes
            ilbm_Dispose(ilbm)
            IF bm
                mycat.mybitmap:=bm
                Raise(ER_NONE)
            ENDIF
        ELSE
            Raise(ER_BADIMAGEPRESENT)
        ENDIF
    ENDIF
EXCEPT
    RETURN exception
ENDPROC
-><->
->> openLibraries() HANDLE
PROC openLibraries() HANDLE
    IF (muimasterbase:=OpenLibrary('muimaster.library',9))=NIL THEN Raise(ER_LIBMUIMASTER)
    IF (iconbase:=OpenLibrary('icon.library',0))=NIL THEN Raise(ER_LIBICON)
    IF (workbenchbase:=OpenLibrary('workbench.library',0))=NIL THEN Raise(ER_LIBWORKBENCH)
    IF (iffbase:=OpenLibrary('iff.library',0))=NIL THEN Raise(ER_LIBIFF)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',0))=NIL THEN Raise(ER_LIBREQTOOLS)
    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',0))=NIL THEN Raise(ER_LIBREXXSYSLIB)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
-><->
->> closeLibraries()
PROC closeLibraries()
    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
    IF iffbase THEN CloseLibrary(iffbase)
    IF workbenchbase THEN CloseLibrary(workbenchbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF muimasterbase THEN CloseLibrary(muimasterbase)
ENDPROC
-><->
->> checkArexxLib()
PROC checkArexxLib()
    DEF rx:PTR TO rxslib
    DEF list:PTR TO lh
    rx:=rexxsysbase
    list:=rx.liblist
    IF FindName(list,'rexxsupport.library')
    NOP
    ELSE
    rexxExecute('Call addlib(''rexxsupport.library'',0,-30,0)',RXFUNC+RXFF_STRING)
    ENDIF
    IF FindName(list,'rexxarplib.library')
    NOP
    ELSE
    rexxExecute('Call addlib(\arexxarplib.library\a,0,-30,0)',RXFUNC+RXFF_STRING)
    ENDIF
ENDPROC
-><->
->> rexxExecute(commande,f)
PROC rexxExecute(commande,f)
    DEF myport:PTR TO mp
    DEF rxmsg:PTR TO rexxmsg
    DEF ap:PTR TO mp
    DEF execmsg:PTR TO mn
    DEF node:PTR TO ln
    DEF test,rc=FALSE,rc2
    DEF command[256]:STRING
    StringF(command,'\s',commande)
    IF myport:=CreateMsgPort()
    IF rxmsg:=CreateRexxMsg(myport,NIL,NIL)
        execmsg:=rxmsg
        node:=execmsg
        node.name:='TempImageCat'
        node.type:=NT_MESSAGE
        node.pri:=0
        execmsg.replyport:=myport
        IF test:=CreateArgstring(command,EstrLen(command))
        CopyMem({test},rxmsg.args,4)
        rxmsg.action:=f
        rxmsg.passport:=myport
        rxmsg.stdin:=Input()
        rxmsg.stdout:=Output()
        Forbid()
        ap:=FindPort('REXX')
        IF ap
            PutMsg(ap,rxmsg)
        ENDIF
        Permit()
        IF ap
            WaitPort(myport)
            GetMsg(myport)
            rc:=rxmsg.result1
            rc2:=rxmsg.result2
            IF rc<>0
            request('\s\nRETURN Error:\d Severity:\d\n','Arexx Error',[arexxword[rc2],rc2,rc])
            ENDIF
        ELSE
            request('REXX not Actif.','Ok',0)
        ENDIF
        ClearRexxMsg(rxmsg,16)
        ENDIF
        DeleteRexxMsg(rxmsg)
    ENDIF
    DeleteMsgPort(myport)
    ELSE
    request('Création du port impossible','Ok',0)
    ENDIF
ENDPROC
-><->
->> lookMUIMessage()
PROC lookMUIMessage()
    DEF runnig = TRUE,result,signal,active,line
    WHILE runnig
    result:=domethod(myapp.app,[MUIM_Application_Input,{signal}])
    SELECT result
        CASE MUIV_Application_ReturnID_Quit
        runnig := FALSE
        CASE BT_LOADCAT
        set(myapp.wi_stamp,MUIA_Window_Sleep,MUI_TRUE)
        IF fileRequester(LOADCATA)
            initTextList(mycat.imageinfolist)
            setTextList(mycat.imageinfolist)
        ENDIF
        set(myapp.wi_stamp,MUIA_Window_Sleep,FALSE)
        CASE BT_IMGDBL
        get(myapp.lv_name,MUIA_List_Active,{active})
        IF active<>-1
            domethod(myapp.lv_name,[MUIM_List_GetEntry,MUIV_List_GetEntry_Active,{line}])
            updateBitmap(line)
            set(myapp.im_icon,MUIA_Bitmap_Bitmap,mycat.mybitmap)
        ENDIF
        CASE BT_VIEW
        set(myapp.wi_stamp,MUIA_Window_Sleep,MUI_TRUE)
        actionSelectImage(ACTION_VIEW)
        set(myapp.wi_stamp,MUIA_Window_Sleep,FALSE)
        CASE BT_TOOLS
        set(myapp.wi_stamp,MUIA_Window_Sleep,MUI_TRUE)
        selectTools()
        IF mycat.currenttool<>0 THEN actionSelectImage(ACTION_TOOLS)
        set(myapp.wi_stamp,MUIA_Window_Sleep,FALSE)
        CASE BT_COPYRAM
        set(myapp.wi_stamp,MUIA_Window_Sleep,MUI_TRUE)
        actionSelectImage(ACTION_COPYG)
        set(myapp.wi_stamp,MUIA_Window_Sleep,FALSE)
        CASE BT_COPYDF0
        set(myapp.wi_stamp,MUIA_Window_Sleep,MUI_TRUE)
        actionSelectImage(ACTION_COPYD)
        set(myapp.wi_stamp,MUIA_Window_Sleep,FALSE)
        CASE BT_VIEWSTAMP
        set(myapp.wi_stamp,MUIA_Window_Sleep,MUI_TRUE)
        viewStamp()
        set(myapp.wi_stamp,MUIA_Window_Sleep,FALSE)
    ENDSELECT
    IF (signal AND runnig) THEN Wait(signal)
    ENDWHILE
ENDPROC
-><->
->> viewStamp()
PROC viewStamp()
    DEF l:PTR TO lh
    DEF n:PTR TO ln
    DEF name,cmd2[256]:STRING,cmd[256]:STRING
    l:=mycat.imageinfolist
    n:=l.head
    name:=getInfoNode(l,0,GETWITH_NUM,RETURN_NAME)
    StringF(cmd2,'\s\s',name,mycat.suffix)
    IF FileLength(cmd2)<>-1
    StringF(cmd,'\s \s',mycat.stampcommand,cmd2)
    Execute(cmd,NIL,NIL)
    ENDIF
ENDPROC
-><->
->> selectTools()
PROC selectTools()
    DEF fh,buf[1000]:ARRAY,s,buffer[256]:STRING
    addNode(mycat.toolslist,'IC_Cancel',0,0)
    IF FileLength(mycat.imagecattools)<>-1
    IF fh:=Open(mycat.imagecattools,1005)
        WHILE Fgets(fh,buf,1000)
        IF (s:=String(StrLen(buf)))=NIL THEN Raise("MEM")
        StrCopy(s,buf,StrLen(buf)-1)
        addNode(mycat.toolslist,s,0,0)
        ENDWHILE
        Close(fh)
    ENDIF
    StringF(buffer,'ImageCat Tools (\s)',mycat.currenttool)
    easygui(buffer,
            [BEVEL,
            [EQROWS,
                [LISTV,{getToolsName},NIL,50,10,mycat.toolslist,0,NIL,NIL],
                [SBUTTON,0,'Ok']
            ]
            ],NIL,mycat.screen,NIL)
    cleanList(mycat.toolslist,FALSE,0,LIST_CLEAN)
    ENDIF
ENDPROC
-><->
->> getToolsName(infos,num)
PROC getToolsName(infos,num)
    DEF name
    IF num<>0
    name:=getInfoNode(mycat.toolslist,num,GETWITH_NUM,RETURN_NAME)
    IF name<>-1
        IF mycat.currenttool<>0 THEN DisposeLink(mycat.currenttool)
        mycat.currenttool:=String(EstrLen(name))
        StrCopy(mycat.currenttool,name,ALL)
    ENDIF
    ELSE
    IF mycat.currenttool<>0
        DisposeLink(mycat.currenttool)
        mycat.currenttool:=0
    ENDIF
    ENDIF
ENDPROC
-><->
->> actionSelectImage(action)
PROC actionSelectImage(action)
    DEF sel,num,b,name
    DEF buffer[2048]:STRING
    DEF buf[256]:STRING,filesel=FALSE
    DEF source[256]:STRING,dest[256]:STRING
    DEF numsel=0
    StringF(buffer,'\s ',mycat.viewer)
    get(myapp.lv_name,MUIA_List_Entries,{num})
    FOR b:=0 TO num-1
        domethod(myapp.lv_name,[MUIM_List_Select,b,MUIV_List_Select_Ask,{sel}])
        IF sel THEN numsel:=numsel+1
    ENDFOR
    setEnv('IC_NUMSEL',numsel,F_D)
    get(myapp.lv_name,MUIA_List_Entries,{num})
    FOR b:=0 TO num-1
        domethod(myapp.lv_name,[MUIM_List_Select,b,MUIV_List_Select_Ask,{sel}])
        IF sel=1
            filesel:=TRUE
            domethod(myapp.lv_name,[MUIM_List_GetEntry,b,{name}])
            SELECT action
                CASE ACTION_VIEW
                    StringF(buf,'\s ',name)
                    StrAdd(buffer,buf,ALL)
                CASE ACTION_TOOLS
                    StringF(buf,'\s\s \s',mycat.scriptdir,mycat.currenttool,name)
                    rexxExecute(buf,RXCOMM)
                CASE ACTION_COPYG
                    /*== copy image ==*/
                    StringF(source,'\s',name)
                    StringF(dest,'\s',mycat.destg)
                    IF Not(copyFile(source,dest)) THEN request('Erreur durant la copie de \s','ok',[source])
                    /*== copy stamp ==*/
                    StringF(source,'\s\s',name,mycat.suffix)
                    IF Not(copyFile(source,dest)) THEN request('Erreur durant la copie de \s','ok',[source])
                    /*== copy icon ==*/
                    StringF(source,'\s.info',name)
                    copyFile(source,dest)
                CASE ACTION_COPYD
                    /*== copy image ==*/
                    StringF(source,'\s',name)
                    StringF(dest,'\s',mycat.destd)
                    IF Not(copyFile(source,dest)) THEN request('Erreur durant la copie de \s','ok',[source])
                    /*== copy stamp ==*/
                    StringF(source,'\s\s',name,mycat.suffix)
                    IF Not(copyFile(source,dest)) THEN request('Erreur durant la copie de \s','ok',[source])
                    /*== copy icon ==*/
                    StringF(source,'\s.info',name)
                    copyFile(source,dest)
            ENDSELECT
        ENDIF
    ENDFOR
    IF filesel=TRUE
        IF action=ACTION_VIEW THEN Execute(buffer,NIL,NIL)
    ELSE
        IF action=ACTION_VIEW
            get(myapp.lv_name,MUIA_List_Active,{num})
            IF num<>-1
            domethod(myapp.lv_name,[MUIM_List_GetEntry,num,{name}])
            StringF(buffer,'\s \s',mycat.viewer,name)
            Execute(buffer,NIL,NIL)
            ENDIF
        ELSEIF action=ACTION_TOOLS
            get(myapp.lv_name,MUIA_List_Active,{num})
            IF num<>-1
            setEnv('IC_NUMSEL',1,F_D)
            domethod(myapp.lv_name,[MUIM_List_GetEntry,num,{name}])
            StringF(buffer,'\s\s \s',mycat.scriptdir,mycat.currenttool,name)
            rexxExecute(buffer,RXCOMM)
            ELSE
            StringF(buf,'\s\s',mycat.scriptdir,mycat.currenttool)
            rexxExecute(buf,RXCOMM)
            ENDIF
        ENDIF
    ENDIF
ENDPROC
-><->
->> copyFile(source,dest)
PROC copyFile(source,dest)
    DEF buffer
    DEF fhs,fhd,n=1,rc=FALSE
    DEF s[256]:STRING,d[256]:STRING
    StringF(s,'\s',source)
    StringF(d,'\s',dest)
    AddPart(d,'',256)
    StrAdd(d,getName(source),ALL)
    IF buffer:=New(2048)
    IF fhs:=Open(s,1005)
        IF fhd:=Open(d,1006)
        WHILE (n>0)
            n:=Read(fhs,buffer,2048)
            Write(fhd,buffer,n)
        ENDWHILE
        IF n=0 THEN rc:=TRUE
        Close(fhd)
        ENDIF
        Close(fhs)
    ENDIF
    Dispose(buffer)
    ENDIF
ENDPROC rc
-><->
->> getName(file)
PROC getName(file)
    DEF buf[256]:STRING
    DEF lock,fib:fileinfoblock,buffer[256]:STRING
    IF lock:=Lock(file,-2)
    IF Examine(lock,fib)
        StringF(buffer,'\s',fib.filename)
    ENDIF
    UnLock(lock)
    ENDIF
    StrCopy(buf,buffer,ALL)
ENDPROC buf
-><->
->> create( display:PTR TO app_display ,icon=NIL ,arexx=NIL:PTR TO app_arexx ,menu=NIL ) OF app_obj
PROC create( display:PTR TO app_display ,icon=NIL ,arexx=NIL:PTR TO app_arexx ,menu=NIL ) OF app_obj
    DEF grOUP_ROOT_0 , gr_icontext , gr_listgad , gr_gad
    DEF gr_gad2 , gr_copy
    DEF strg[50]:STRING,strd[50]:STRING
    StringF(strg,'Copier en \s',mycat.destg)
    StringF(strd,'Copier en \s',mycat.destd)
    self.im_icon := BitmapObject ,
    MUIA_Frame , MUIV_Frame_Button ,
    MUIA_FixWidth,mycat.width,
    MUIA_FixHeight,mycat.height,
    MUIA_Bitmap_Bitmap,mycat.mybitmap,
    MUIA_Bitmap_Width,mycat.width,
    MUIA_Bitmap_Height,mycat.height,
    MUIA_InputMode,MUIV_InputMode_RelVerify,
    End
    self.lv_texticon := ListObject ,
    MUIA_Frame , MUIV_Frame_ReadList ,
    End
    self.lv_texticon := ListviewObject ,
    MUIA_HelpNode , 'LV_texticon' ,
    MUIA_Listview_Input , FALSE ,
    MUIA_Listview_List , self.lv_texticon ,
    End
    gr_icontext := GroupObject ,
    MUIA_HelpNode , 'GR_icontext' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.im_icon ,
    Child , self.lv_texticon ,
    End
    self.lv_name := ListObject ,
    MUIA_Frame , MUIV_Frame_InputList ,
    End
    self.lv_name := ListviewObject ,
    MUIA_HelpNode , 'LV_name' ,
    MUIA_Listview_MultiSelect , MUIV_Listview_MultiSelect_Default ,
    MUIA_Listview_DoubleClick , MUI_TRUE ,
    MUIA_Listview_SelectChange,MUI_TRUE,
    MUIA_Listview_Input , MUI_TRUE ,
    MUIA_Listview_List , self.lv_name ,
    End
    self.bt_loadcat := SimpleButton('Charger Catalogue' )
    gr_gad := GroupObject ,
    MUIA_HelpNode , 'GR_gad' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.bt_loadcat ,
    End
    self.bt_view := SimpleButton('Voir')
    self.bt_tools := SimpleButton('Utilitaires')
    gr_gad2 := GroupObject ,
    MUIA_HelpNode , 'GR_gad2' ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , self.bt_view ,
    Child, self.bt_tools ,
    End
    self.bt_copyram := SimpleButton(strg)
    self.bt_copydf0 := SimpleButton(strd)
    gr_copy := GroupObject ,
    MUIA_HelpNode , 'GR_copy' ,
    MUIA_Frame , MUIV_Frame_Group ,
    MUIA_Group_Horiz , MUI_TRUE ,
    Child , self.bt_copyram ,
    Child , self.bt_copydf0 ,
    End
    gr_listgad := GroupObject ,
    MUIA_HelpNode , 'GR_listgad' ,
    MUIA_Frame , MUIV_Frame_Group ,
    Child , self.lv_name ,
    Child , gr_gad ,
    Child , gr_gad2 ,
    Child , gr_copy ,
    End
    grOUP_ROOT_0 := GroupObject ,
    Child , gr_icontext ,
    Child , gr_listgad ,
    End
    self.wi_stamp := WindowObject ,
    MUIA_Window_Title , 'ImageCat' ,
    MUIA_Window_ID , "0WIN" ,
    MUIA_Window_PublicScreen,'ImageCatScreen',
    MUIA_Window_Backdrop,mycat.winbackdrop,
    WindowContents , grOUP_ROOT_0 ,
    End
    self.app := ApplicationObject ,
    ( IF icon THEN MUIA_Application_DiskObject ELSE TAG_IGNORE ) , icon ,
    /*
    ( IF arexx.commands THEN MUIA_Application_Commands ELSE TAG_IGNORE ) , arexx.commands ,
    ( IF arexx.error THEN MUIA_Application_RexxHook ELSE TAG_IGNORE ) , arexx.error ,
    */
    ( IF menu THEN MUIA_Application_Menu ELSE TAG_IGNORE ) , menu ,
    MUIA_Application_Author , 'NasGûl' ,
    MUIA_Application_Base , 'IMAGECAT' ,
    MUIA_Application_Title , 'ImageCat' ,
    MUIA_Application_HelpFile,'ImageCat:ImageCat.Guide',
    MUIA_Application_Version , '$VER: ImageCat 0.8 (22.11.95)' ,
    MUIA_Application_Copyright , '© 1995 Nasgûl' ,
    MUIA_Application_Description ,'Catalogueur d\aimages' ,
    SubWindow , self.wi_stamp ,
    End
ENDPROC self.app
-><->
->> dispose() OF app_obj
PROC dispose() OF app_obj IS Mui_DisposeObject( self.app )
-><
->> init_notifications( display : PTR TO app_display ) OF app_obj
PROC init_notifications( display : PTR TO app_display ) OF app_obj
    domethod( self.wi_stamp , [
    MUIM_Notify , MUIA_Window_CloseRequest , MUI_TRUE ,
    self.app ,
    2 ,
    MUIM_Application_ReturnID , MUIV_Application_ReturnID_Quit ] )
    domethod( self.lv_name , [ MUIM_Notify, MUIA_Listview_DoubleClick , MUI_TRUE, self.app,
                    2, MUIM_Application_ReturnID, BT_IMGDBL] )
    domethod( self.im_icon,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,
          MUIM_Application_ReturnID,BT_VIEWSTAMP])
    domethod( self.bt_loadcat,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,
          MUIM_Application_ReturnID,BT_LOADCAT])
    domethod( self.bt_view,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,
          MUIM_Application_ReturnID,BT_VIEW])
    domethod( self.bt_tools,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,
          MUIM_Application_ReturnID,BT_TOOLS])
    domethod( self.bt_copyram,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,
          MUIM_Application_ReturnID,BT_COPYRAM])
    domethod( self.bt_copydf0,[MUIM_Notify,MUIA_Pressed,FALSE,self.app,2,
          MUIM_Application_ReturnID,BT_COPYDF0])
    domethod( self.wi_stamp , [
    MUIM_Window_SetCycleChain , self.lv_texticon , self.lv_name, self.bt_loadcat ,
    self.bt_view,self.bt_tools,self.bt_copyram ,self.bt_copydf0,0 ] )
    set( self.wi_stamp , MUIA_Window_Open , MUI_TRUE )

ENDPROC
-><->
->> readCatalogue(fichier,pad)
PROC readCatalogue(fichier,pad)
    DEF fh,buf[1000]:ARRAY,s,buffer[256]:STRING
    IF pad=TRUE
    domethod(myapp.lv_name,[MUIM_List_Clear])
    cleanList(mycat.imagelist,FALSE,0,LIST_CLEAN)
    ENDIF
    set(myapp.lv_name,MUIA_List_Quiet,TRUE)
    IF FileLength(fichier)<>-1
    IF fh:=Open(fichier,1005)
        WHILE Fgets(fh,buf,1000)
        IF (s:=String(StrLen(buf)))=NIL THEN Raise("MEM")
        StrCopy(s,buf,StrLen(buf)-1)
->        IF FileLength(s)<>-1
            StringF(buffer,'\s\s',s,mycat.suffix)
->            IF FileLength(buffer)<>-1
                addNode(mycat.imagelist,s,0,0)
                domethod(myapp.lv_name,[MUIM_List_Insert,{s},1,MUIV_List_Insert_Bottom])
->            ENDIF
->        ENDIF
        ENDWHILE
        Close(fh)
    ENDIF
    ENDIF
    set(myapp.lv_name,MUIA_List_Quiet,FALSE)
ENDPROC
-><->
->> fileRequester(a)
PROC fileRequester(a)
/*===============================================================================
 = Para     : NONE
 = Return   : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the whatview arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste=0
    DEF ret=FALSE
    DEF the_reelname[256]:STRING
    DEF defaultdir[256]:STRING,firstfile=TRUE,numfile=0
    reqfile:=NIL
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
    buffer[0]:=0
    RtChangeReqAttrA(reqfile,[RTFI_MATCHPAT,mycat.patternreq,TAG_DONE])
    add_liste:=RtFileRequestA(reqfile,buffer,textfilereq[a],
                  [RT_PUBSCRNAME,'ImageCatScreen',RTFI_FLAGS,FREQF_MULTISELECT+FREQF_PATGAD,RTFI_OKTEXT,textfilereq[a],RTFI_HEIGHT,200,
                   RT_UNDERSCORE,"_",TAG_DONE])
    StrCopy(defaultdir,reqfile.dir,ALL)
    AddPart(defaultdir,'',256)
    IF reqfile THEN RtFreeRequest(reqfile)
    IF add_liste THEN ret:=TRUE
    ELSE
    ret:=FALSE
    ENDIF
    IF ret=TRUE
    liste:=add_liste
    IF add_liste
        WHILE liste
        StringF(the_reelname,'\s\s',defaultdir,liste.name)
        readCatalogue(the_reelname,firstfile)
        numfile:=numfile+1
        IF numfile<>0 THEN firstfile:=FALSE
        liste:=liste.next
        ENDWHILE
        IF add_liste THEN RtFreeFileList(add_liste)
    ENDIF
    ELSE
    ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC
-><->
->> request(bodytext,gadgettext,the_arg)
PROC request(bodytext,gadgettext,the_arg)
    DEF ret
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,[RT_PUBSCRNAME,'ImageCatScreen',TAG_DONE])
    RETURN ret
ENDPROC
-><->

