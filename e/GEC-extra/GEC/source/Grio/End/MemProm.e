OPT PREPROCESS
OPT REG=5
OPT STRMERGE
OPT OSVERSION=37

#define HEADER   'MEMPROM'
#define CONFIG   'ENV:MemProm.prefs'
#define CONFIGS  'ENVARC:MemProm.prefs'
#define INCLUDE  'IncludeMode'
#define EXCLUDE  'ExcludeMode'
#define FAST     'Fast'
#define CHIP     'Chip'
#define DATE     '12.04.2004'
#define VERS     'MemProm 1.0d'
#define DESCR    'Memory promotion commodity'
#define ONLYNAME  'ogrio@o2.pl'
#define MYNAME    'ogrio@o2.pl'
->#define DEBUG


MODULE 'exec/lists','exec/nodes','exec/memory','exec/ports'
MODULE 'exec/execbase','dos/dosextens','dos/dos'

MODULE 'libraries/gadtools','intuition/intuition'
MODULE 'utility/tagitem','gadtools','icon'
MODULE 'grio/gadtools','amigalib/argarray'
MODULE 'amigalib/lists','grio/cxer','libraries/commodities'
MODULE 'asl','libraries/asl'
MODULE 'devices/inputevent','graphics/text'
MODULE 'intuition/screens'



#define UWORD(a) a AND $FFFF


CONST KEY_UP=76,KEY_DOWN=77,KEY_ENTER=13


ENUM MODE_INCLUDE,MODE_EXCLUDE,MODE_BAD
CONST TYPE_ANY=0,TYPE_FAST=MEMF_FAST,TYPE_CHIP=MEMF_CHIP

ENUM GAD_MLIST,GAD_ADD,GAD_REMOVE,GAD_CLEAR,GAD_SORT,GAD_USE,GAD_SAVE,
     GAD_MEMTYPE,GAD_MODE,GAD_ENABLE

ENUM ID_CLOSEWIN,ID_VANILLA,ID_RAWKEY


CONST PROGDIE=-1

DEF list:lh,mode=MODE_INCLUDE,oldvec=NIL,tasklh:lh,inuse=0,deffont=TRUE

OBJECT mynode
  ln:ln
  mtype:LONG
ENDOBJECT


DEF infos:PTR TO gadget,
    mwnd=NIL:PTR TO window,
    code,type,id,key,
    qual,item:PTR TO menuitem,
    running

DEF mlistpos=0,enable=TRUE,oldsec,oldmic,tlistpos,oldmtype=TYPE_FAST
DEF mleft=100,mtop=150,tleft=120,ttop=40,correct,numtask,tattr:textattr
DEF fontname[80]:ARRAY OF CHAR


CONST ERROR_NONE=GTERR_NO,
      ERROR_GT=GTERR_GTLIB,
      ERROR_SCRN=GTERR_SCR,
      ERROR_VISUAL=GTERR_VISUAL,
      ERROR_CONTEXT=GTERR_CONTEXT,
      ERROR_GADGET=5,
      ERROR_WINDOW=6,
      ERROR_MENUS=7,
      ERROR_PORT=8,
      ERROR_MEM=9,
      ERROR_CXLIB=10,
      ERROR_CXBROKER=11,
      ERROR_CXOBJ=12,
      ERROR_ICONLIB=13,
      ERROR_ARGS=14,
      ERROR_ASLLIB=15


DEF gtm:PTR TO gadtools,tgm:PTR TO LONG
DEF gtt:PTR TO gadtools,wport=NIL:PTR TO mp
DEF stri[122]:ARRAY,strgad:PTR TO gadget
DEF twnd:PTR TO window,tlhgad
DEF cx:PTR TO cxer,testwin




PROC main() HANDLE
DEF err,ttypes=NIL
IF arg[]="?"
   WriteF('USAGE: [CX_PRIORITY=<value>] [CX_POPUP=<YES|NO>] [CX_HOTKEY=<hotkey>]\n')
   CleanUp()
ENDIF
IF (wport:=CreateMsgPort())=NIL THEN Raise(ERROR_PORT)
IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(ERROR_ICONLIB)
IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ERROR_ASLLIB)
NEW cx
newList(list)
tattr.name:=NIL
IF loadCfg(CONFIG)=FALSE
   loadCfg(CONFIGS)
ENDIF
IF (ttypes:=argArrayInit())=FALSE THEN Raise(ERROR_ARGS)
IF (err:=cx.new())=CXERROR_NONE
   IF (err:=cx.install('MemProm',VERS+'  © '+DATE,DESCR+' !',TRUE,
                      argString(ttypes,'CX_POPKEY','Ctrl Alt m'),
                      argInt(ttypes,'CX_PRIORITY',0)))=CXERROR_NONE
      IF tattr.name=NIL THEN setTextAttr()
      IF StriCmp(argString(ttypes,'CX_POPUP','YES'),'NO')=FALSE THEN openMainWin()
      cx.activate(enable)
      setPatch()
      REPEAT
         multiprocess()
      UNTIL remPatch(TRUE)
   ENDIF
ENDIF
IF err
   SELECT err
      CASE CXERROR_PORT      ;Raise(ERROR_PORT)
      CASE CXERROR_LIB       ;Raise(ERROR_CXLIB)
      CASE CXERROR_MEMNB     ;Raise(ERROR_MEM)
      CASE CXERROR_BROKER    ;Raise(ERROR_CXBROKER)
      CASE CXERROR_CXOBJ     ;Raise(ERROR_CXOBJ)
      CASE CXERROR_DUPLICATE ;Raise(ERROR_NONE)
   ENDSELECT
ENDIF
EXCEPT DO
setEnable(FALSE)
REPEAT
UNTIL remPatch()
mwin_CloseWindow()
END cx
IF wport THEN DeleteMsgPort(wport)
IF aslbase THEN CloseLibrary(aslbase)
IF iconbase THEN CloseLibrary(iconbase)
IF ttypes THEN argArrayDone()
reporterr(exception)
ENDPROC


MODULE 'grio/easyreq'


PROC setPatch()
#ifndef DEBUG
Forbid()
oldvec:=SetFunction(execbase,-198,{patch})
CacheClearU()
Permit()
#endif
ENDPROC D0

PROC remPatch(ask=FALSE)
DEF res=TRUE,enab
#ifndef DEBUG
IF oldvec
   enab:=enable
   res:=enable:=FALSE
   Delay(25)
   IF inuse=0
      Forbid()
      res:=SetFunction(execbase,-198,oldvec)
      IF res<>{patch}
         SetFunction(execbase,-198,res)
         res:=FALSE
      ELSE
         CacheClearU()
         res:=TRUE
      ENDIF
      Permit()
      IF res=FALSE
         IF ask
            ask:=easyreq('MemProm patch is patched','Disable and try later|Forget it','MemProm')=0
         ENDIF
         IF ask=FALSE
            setEnable(FALSE)
         ELSE
            enable:=enab
         ENDIF
      ENDIF
   ELSE
      IF ask
         ask:=easyreq('MemProm is in use','Disable and try later|Forget it','MemProm')=0
      ENDIF
      IF ask=FALSE
         setEnable(FALSE)
      ELSE
         enable:=enab
      ENDIF
   ENDIF
   IF res=TRUE THEN oldvec:=NIL
ENDIF
#endif
ENDPROC res


CHAR '$VER: ',VERS,' (',DATE,') by ',ONLYNAME,0




PROC setTextAttr(ta=NIL:PTR TO textattr)
DEF scr:PTR TO screen,res=TRUE
tattr.name:=fontname
IF ta=NIL
   IF (scr:=LockPubScreen(NIL))
      AstrCopy(fontname,scr.font.name)
      tattr.ysize:=scr.font.ysize
      tattr.style:=NIL
      tattr.flags:=NIL
      UnlockPubScreen(NIL,scr)
      deffont:=TRUE
   ELSE
      res:=FALSE
   ENDIF
ELSE
   AstrCopy(fontname,ta.name)
   tattr.ysize:=ta.ysize
   deffont:=FALSE
ENDIF
ENDPROC res




PROC openMainWin()
DEF err,l,x ,tab:PTR TO LONG
IF mwnd=NIL
   NEW gtm
   tab,l:=genMainTable()
   tgm:=NewR(l*4)
   IF (err:=gtm.new(NIL,tattr)) THEN Raise(err)
   FOR x:=0 TO l-1
       IF (tgm[x]:=gtm.gadget(^tab++,^tab++,^tab++,^tab++,^tab++,^tab++,^tab++,^tab++,^tab++))=NIL
          Raise(ERROR_GADGET)
       ENDIF
   ENDFOR
   IF (mwnd:=gtm.openWin(mleft,mtop,480,228,IDCMP_MOUSEMOVE OR IDCMP_GADGETUP OR
               IDCMP_GADGETDOWN OR IDCMP_CLOSEWINDOW OR IDCMP_MENUPICK OR IDCMP_REFRESHWINDOW OR
               IDCMP_VANILLAKEY OR IDCMP_RAWKEY,WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
               WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR WFLG_ACTIVATE,'MemProm',wport,
               NIL,TRUE,VERS))=NIL
      Raise(ERROR_WINDOW)
   ENDIF
   mwnd.userdata:=[mwin_CloseWindow,mwin_VanillaKey,mwin_RawKey]
   IF gtm.setMenu([NM_TITLE,0,'Project',0,0,0,0,
                   NM_ITEM,0,'Open','o',0,0,open_Clicked,
                   NM_ITEM,0,'Save As','s',0,0,saveas_Clicked,
                   NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                   NM_ITEM,0,'Hide','h',0,0,hide_Clicked,
                   NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                   NM_ITEM,0,'About','a',0,0,about,
                   NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                   NM_ITEM,0,'Quit','q',0,0,kill,
                   NM_TITLE,0,'Edit',0,0,0,0,
                   NM_ITEM,0,'Restore',NIL,0,0,restore_Clicked,
                   NM_ITEM,0,'Last Saved',NIL,0,0,lastSaved_Clicked,
                   NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                   NM_ITEM,0,'Set font',NIL,0,0,font_Clicked,
                   NM_ITEM,0,'Def font',NIL,0,0,dfont_Clicked,
                   NM_END,0,NIL,0,0,0,0]:newmenu)=NIL
      Raise(ERROR_MENUS)
   ENDIF
ENDIF
infos:=MENUNULL
correct:=NIL
ENDPROC D0


PROC dfont_Clicked()       -> use only from menu
 mwin_CloseWindow()
 setTextAttr()
 openMainWin()
 testwin:=mwnd
ENDPROC


PROC font_Clicked()        -> use only from menu
DEF fr:PTR TO fontrequester,res=FALSE
IF (fr:=AllocAslRequest(ASL_FONTREQUEST,
                       [ASL_HAIL,'Select font',
                        ASL_WIDTH,320,
                        ASL_HEIGHT,240,
                        ASL_LEFTEDGE,mleft,
                        ASL_TOPEDGE,mtop,
                        ASL_FONTHEIGHT,gtm.tattr.ysize,
                        ASL_FONTNAME,gtm.tattr.name,
                        ASL_FUNCFLAGS,FONF_FIXEDWIDTH,
                        ASL_OKTEXT,'Select',
                        TAG_END]))
   IF (res:=AslRequest(fr,NIL))
      mwin_CloseWindow()
      setTextAttr(fr.tattr)
      openMainWin()
   ENDIF
   FreeAslRequest(fr)
ENDIF
testwin:=mwnd
ENDPROC



PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er="MEM" THEN er:=ERROR_MEM
  IF er
    erlist:=['open "gadtools.library"',
             'lock screen',
             'get visual infos',
             'get context',
             'create gadget',
             'open window',
             'create menus',
             'create port',
             'alloc mem',
             'open "commodities.library"',
             'create cx broker',
             'create cx object',
             'open "icon.library"',
             'init args array',
             'open "asl.library"']
   easyreq('Could not \s!','OK','MemProm',[erlist[er-1]])
  ENDIF
ENDPROC er



PROC genMainTable()
  DEF tab:REG
  tab:=
     [
     LISTVIEW_KIND,14,5,369,208,NIL,0,list_Clicked,
     [GTLV_LABELS,list,GTLV_SHOWSELECTED,NIL,
     TAG_END],
     BUTTON_KIND,16,210,56,14,'_Add',PLACETEXT_IN,add_Clicked,
     [GT_UNDERSCORE,"_",TAG_END],
     BUTTON_KIND,76,210,60,14,'_Remove',PLACETEXT_IN,rem_Clicked,
     [GT_UNDERSCORE,"_",TAG_END],
     BUTTON_KIND,140,210,56,14,'_Clear',PLACETEXT_IN,clear_Clicked,
     [GT_UNDERSCORE,"_",TAG_END],
     BUTTON_KIND,200,210,56,14,'S_ort',PLACETEXT_IN,sort_Clicked,
     [GT_UNDERSCORE,"_",TAG_END],
     BUTTON_KIND,260,210,56,14,'_Use',PLACETEXT_IN,use_Clicked,
     [GT_UNDERSCORE,"_",TAG_END],
     BUTTON_KIND,320,210,56,14,'_Save',PLACETEXT_IN,save_Clicked,
     [GT_UNDERSCORE,"_",TAG_END],
     CYCLE_KIND,390,20,80,14,'Mem Type',PLACETEXT_ABOVE,mtype_Clicked,
     [GTCY_LABELS,['Any','Chip','Fast',NIL],GTCY_ACTIVE,2,
     TAG_END],
     MX_KIND,390,160,16,10,'Mode',PLACETEXT_RIGHT,mode_Clicked,
     [GTMX_LABELS,['Include','Exclude',NIL],GTMX_ACTIVE,mode,
     GTMX_SCALED,TRUE,GTMX_SPACING,5,GTMX_TITLEPLACE,PLACETEXT_ABOVE,
     TAG_END],
     CHECKBOX_KIND,390,100,16,10,'Enable',PLACETEXT_RIGHT,enable_Clicked,
     [GTCB_SCALED,TRUE,GTCB_CHECKED,enable,TAG_END]
     ]
ENDPROC tab,ListLen(tab)/9



PROC multiprocess()
  DEF win:PTR TO window
  DEF func=NIL:PTR TO LONG
  running:=TRUE
  WHILE running
    win:=multiwait4message()
    SELECT type
       CASE IDCMP_CLOSEWINDOW
         func:=win.userdata
         IF func THEN func:=func[ID_CLOSEWIN]
       CASE IDCMP_GADGETUP
         func:=infos.userdata
       CASE IDCMP_MENUPICK
         testwin:=win
         WHILE infos<>MENUNULL
            item:=ItemAddress(win.menustrip,infos)
            func:=GTMENUITEM_USERDATA(item)
            IF func THEN Eval(func)
            EXIT running=FALSE
            EXIT win<>testwin              -> If we get close and open gui from menu (change font)
            infos:=UWORD(item.nextselect)
         ENDWHILE
         func:=NIL
       CASE IDCMP_VANILLAKEY
         func:=win.userdata
         IF func THEN func:=func[ID_VANILLA]
       CASE IDCMP_GADGETDOWN
         IF id=9
            func:=infos.userdata
         ENDIF
       CASE IDCMP_RAWKEY
         func:=win.userdata
         IF func THEN func:=func[ID_RAWKEY]
       CASE PROGDIE
         ->IF easyreq('Quit CX "MemProm"','Leave|Quit','MemProm')=0
            running:=FALSE
         ->ENDIF
         func:=NIL
    ENDSELECT
    IF func THEN Eval(func)
  ENDWHILE
ENDPROC



PROC multiwait4message()
  DEF win=NIL:PTR TO window,mes:PTR TO intuimessage
  REPEAT
    type:=0
    mes:=IF mwnd THEN Gt_GetIMsg(wport) ELSE NIL
    IF mes
       win:=mes.idcmpwindow
       type:=mes.class
       code:=mes.code
       qual:=UWORD(mes.qualifier)
       SELECT type
          CASE IDCMP_MENUPICK
             infos:=UWORD(code)
          CASE IDCMP_GADGETUP
             infos:=mes.iaddress
             id:=infos.gadgetid
          CASE IDCMP_GADGETDOWN
             infos:=mes.iaddress
              id:=infos.gadgetid
          CASE IDCMP_VANILLAKEY
             key:=code
          CASE IDCMP_REFRESHWINDOW
             Gt_BeginRefresh(win)
             Gt_EndRefresh(win,TRUE)
             type:=0
       ENDSELECT
       Gt_ReplyIMsg(mes)
    ELSE
      wait4sig()
    ENDIF
  UNTIL type
ENDPROC win

PROC wait4sig()
DEF sig,id
sig:=Wait(Shl(1,wport.sigbit) OR cx.signal OR SIGBREAKF_CTRL_C)
IF sig=cx.signal
   cx.handlemsg()
   id:=cx.msgid
   IF cx.msgtype=CXM_COMMAND
      SELECT id
         CASE CXCMD_DISABLE
             setEnable(FALSE)
         CASE CXCMD_ENABLE
             setEnable(TRUE)
         CASE CXCMD_KILL
             type:=PROGDIE
         CASE CXCMD_APPEAR
             openMainWin()
         CASE CXCMD_DISAPPEAR
             mwin_CloseWindow()
         CASE CXCMD_UNIQUE
             openMainWin()
      ENDSELECT
   ELSEIF cx.msgtype=CXM_IEVENT
      IF id=EVT_HOTKEY
         openMainWin()
      ENDIF
   ENDIF
ELSEIF sig=SIGBREAKF_CTRL_C
   type:=PROGDIE
ENDIF
ENDPROC

PROC setEnable(mode)
IF enable<>mode
   enable:=mode
   IF mwnd
      Gt_SetGadgetAttrsA(tgm[GAD_ENABLE],mwnd,NIL,[GTCB_CHECKED,enable,TAG_END])
   ENDIF
ENDIF
ENDPROC

PROC kill()
mwin_CloseWindow()
running:=FALSE
ENDPROC D0


PROC about() IS
   easyreq(VERS+'\n'+DESCR+'\nCopyright © '+DATE+'\nWritten by:\n'+MYNAME,'OK','MemProm')


PROC open_Clicked()
DEF name[1024]:ARRAY
IF filereq(name,'Load')
   clear_Clicked()
   setList(-1)
   loadCfgGad(name)
   setList(list)
ENDIF
ENDPROC

PROC saveas_Clicked()
DEF name[1024]:ARRAY
IF filereq(name,'Save')
   saveCfg(name)
ENDIF
ENDPROC


PROC filereq(buf,ok)
DEF fr:PTR TO filerequester,res=FALSE
IF (aslbase:=OpenLibrary('asl.library',37))
   IF (fr:=AllocAslRequest(ASL_FILEREQUEST,
                         [ASL_HAIL,'Select MemProm prefs',
                          ASL_WIDTH,320,
                          ASL_HEIGHT,240,
                          ASL_LEFTEDGE,mleft,
                          ASL_TOPEDGE,mtop,
                          ASL_DIR,'SYS:Prefs/Presets',
                          ASL_FILE,'MemProm.prefs',
                          ASL_OKTEXT,ok,
                         TAG_END]))
      IF (res:=AslRequest(fr,NIL))
         AstrCopy(buf,fr.drawer,1022)
         AddPart(buf,fr.file,1022)
      ENDIF
      FreeAslRequest(fr)
   ENDIF
   CloseLibrary(aslbase)
ENDIF
ENDPROC res



PROC hide_Clicked() IS mwin_CloseWindow()


PROC mwin_CloseWindow()
twin_CloseWindow()
IF mwnd
   mleft:=mwnd.leftedge
   mtop:=mwnd.topedge
   END gtm
   Dispose(tgm)
   gtm:=mwnd:=tgm:=type:=NIL
ENDIF
ENDPROC


PROC mwin_RawKey()
DEF nd:PTR TO mynode,do=FALSE,nd2:PTR TO ln,oldtype
SELECT code
    CASE KEY_UP
        IF (nd:=mainNode())
           oldtype:=nd.mtype
           IF nd2:=nd.ln.pred
               IF nd2.pred
                  DEC mlistpos
                  do:=TRUE
                  IF qual AND IEQUALIFIER_LSHIFT
                     Remove(nd)
                     Insert(list,nd,nd2.pred)
                  ENDIF
               ENDIF
           ENDIF
        ENDIF
    CASE KEY_DOWN
        IF (nd:=mainNode())
            oldtype:=nd.mtype
            IF nd2:=nd.ln.succ
               IF nd2.succ
                  INC mlistpos
                  do:=TRUE
                  IF qual AND IEQUALIFIER_LSHIFT
                     Remove(nd)
                     Insert(list,nd,nd2)
                  ENDIF
               ENDIF
            ENDIF
        ENDIF
ENDSELECT
IF do
   Gt_SetGadgetAttrsA(tgm[GAD_MLIST],mwnd,NIL,[GTLV_SELECTED,mlistpos,GTLV_TOP,mlistpos,TAG_END])
   IF (nd:=mainNode())
      IF oldtype<>nd.mtype THEN
         Gt_SetGadgetAttrsA(tgm[GAD_MEMTYPE],mwnd,NIL,[GTCY_ACTIVE,Shr(nd.mtype,1),TAG_END])
   ENDIF
ENDIF
ENDPROC


PROC mwin_VanillaKey()
SELECT key
    CASE "a"
        add_Clicked()
    CASE "r"
        rem_Clicked()
    CASE "o"
        sort_Clicked()
    CASE "s"
        save_Clicked()
    CASE "u"
        use_Clicked()
    CASE "c"
        clear_Clicked()
    CASE KEY_ENTER
        invokeAdd(mainNode())
ENDSELECT
ENDPROC



PROC list_Clicked()
DEF nd:PTR TO mynode,sec,mic,double
CurrentTime({sec},{mic})
double:=IF mlistpos=code  THEN DoubleClick(oldsec,oldmic,sec,mic) ELSE NIL
oldsec:=sec
oldmic:=mic
mlistpos:=code
IF (nd:=mainNode())
   Gt_SetGadgetAttrsA(tgm[GAD_MEMTYPE],mwnd,NIL,[GTCY_ACTIVE,Shr(nd.mtype,1),TAG_END])
   IF double
      invokeAdd(nd)
   ENDIF
ENDIF
ENDPROC


PROC invokeAdd(nd:PTR TO mynode)
IF nd
   IF twnd=NIL THEN add_Clicked()
   IF twnd
      setStriGad(correct:=nd.ln.name)
      Gt_SetGadgetAttrsA(tlhgad,twnd,NIL,[GTLV_SELECTED,-1,TAG_END])
      ActivateWindow(twnd)
      ActivateGadget(strgad,twnd,NIL)
   ENDIF
ENDIF
ENDPROC


PROC taskNode()
DEF node:PTR TO ln,x
node:=tasklh.head
FOR x:=1 TO tlistpos
   EXIT node=NIL
   node:=node.succ
ENDFOR
ENDPROC node


PROC taskList_Clicked()
DEF sec,mic,node:PTR TO ln,double
correct:=NIL
CurrentTime({sec},{mic})
double:=IF tlistpos=code  THEN DoubleClick(oldsec,oldmic,sec,mic) ELSE NIL
oldsec:=sec
oldmic:=mic
tlistpos:=code
IF (node:=taskNode())
   IF double
      addStuff(node.name)
   ELSE
      setStriGad(node.name)
      ActivateGadget(strgad,twnd,NIL)
   ENDIF
ENDIF
ENDPROC

PROC setStriGad(text)
AstrCopy(stri,text,121)
Gt_SetGadgetAttrsA(strgad,twnd,NIL,[GTST_STRING,stri,TAG_END])
ENDPROC

PROC stri_Clicked()
DEF name,nd:PTR TO mynode,m
name:=strgad.specialinfo::stringinfo.buffer
IF correct
   IF (nd:=find(correct))
      IF (m:=New(StrLen(name)+2))
         setList(-1)
         nd.ln.name:=m
         Dispose(correct)
         AstrCopy(m,name)
         setList(list)
      ENDIF
   ENDIF
   correct:=NIL
ELSE
   addStuff(name,FALSE)
ENDIF
twin_CloseWindow()
ENDPROC


PROC addStuff(name,close=TRUE)
IF isPresent(name)=FALSE
   setList()
   addNode(name,oldmtype)
   setList(list)
ENDIF
IF close THEN twin_CloseWindow()
ENDPROC


PROC isPresent(name)
DEF res=FALSE
IF find(name)
   res:=easyreq('Task: "\s"\nallready exists in list','Cancel|Add','MemProm',{name})=1
ENDIF
ENDPROC res


PROC twin_CloseWindow()
IF twnd
   tleft:=twnd.leftedge
   ttop:=twnd.topedge
   END gtt
   gtt:=twnd:=NIL
   freeList(tasklh)
ENDIF
ENDPROC




PROC twin_VanillaKey()
DEF nd:PTR TO ln
IF key=KEY_ENTER
   IF (nd:=taskNode())
      addStuff(nd.name)
   ENDIF
ENDIF
ENDPROC

PROC twin_RawKey()
DEF do=FALSE:PTR TO mynode
SELECT code
    CASE KEY_UP
        IF tlistpos>0
           DEC tlistpos
           do:=TRUE
        ENDIF
    CASE KEY_DOWN
        IF tlistpos<(numtask-1)
           INC tlistpos
           do:=TRUE
        ENDIF
ENDSELECT
IF do
   Gt_SetGadgetAttrsA(tlhgad,twnd,NIL,[GTLV_SELECTED,tlistpos,GTLV_TOP,tlistpos,TAG_END])
   IF (do:=taskNode())
      setStriGad(do.ln.name)
   ENDIF
ENDIF
ENDPROC


PROC add_Clicked() HANDLE
DEF err
IF twnd=NIL
   NEW gtt
   IF (err:=gtt.new(NIL,tattr,51)) THEN Raise(err)
   newList(tasklh)
   makeList()
   IF (tlhgad:=gtt.gadget(LISTVIEW_KIND,14,5,369,180,NIL,0,{taskList_Clicked},
                   [GTLV_LABELS,tasklh,GTLV_SHOWSELECTED,NIL,GTLV_SELECTED,tlistpos:=0,
                   TAG_END]))=NIL
      Raise(ERROR_GADGET)
   ENDIF
   stri[]:=0
   IF (strgad:=gtt.gadget(STRING_KIND,14,186,369,14,NIL,0,{stri_Clicked},
                 [GTST_STRING,stri,GTST_MAXCHARS,120,TAG_END]))=NIL
      Raise(ERROR_GADGET)
   ENDIF
   IF (twnd:=gtt.openWin(tleft,ttop,394,204,IDCMP_MOUSEMOVE OR IDCMP_GADGETUP OR
                 IDCMP_GADGETDOWN OR IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY OR IDCMP_REFRESHWINDOW OR
                 IDCMP_VANILLAKEY,WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
                 WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR WFLG_RMBTRAP,'Add Task',wport,NIL,TRUE,VERS))=NIL
      Raise(ERROR_WINDOW)
   ENDIF
   twnd.userdata:=[twin_CloseWindow,twin_VanillaKey,twin_RawKey]
   oldsec:=oldmic:=NIL
ELSE
   Raise()
ENDIF
EXCEPT
twin_CloseWindow()
twnd:=gtt:=NIL
reporterr(exception)
ENDPROC twnd


MODULE 'grio/sortExecList'


PROC makeList()
DEF ok=FALSE
Forbid()
numtask:=0
ok:=copyList(execbase::execbase.taskwait)
Permit()
IF ok
   sortExecList(tasklh)
ELSE
   freeList(tasklh)
   Raise(ERROR_MEM)
ENDIF
ENDPROC

MODULE 'grio/taskname'

PROC copyList(slh:PTR TO lh)
DEF ln=TRUE:PTR TO ln,name=TRUE,eln:PTR TO ln,tn
eln:=slh.head
WHILE eln.succ
    EXIT (tn:=taskName(eln))=NIL
    EXIT (ln:=New(SIZEOF ln))=NIL
    EXIT (name:=New(StrLen(tn)+2))=NIL
    ln.name:=name
    AstrCopy(name,tn)
    AddTail(tasklh,ln)
    eln:=eln.succ
    INC numtask
ENDWHILE
ENDPROC (ln<>NIL) AND (name<>NIL)

PROC rem_Clicked()
DEF nd:PTR TO mynode
setList()
IF (nd:=mainNode())
   IF mlistpos
      IF nd.ln.succ=NIL
         DEC mlistpos
         nd:=mainNode()
      ENDIF
    ENDIF
   remNode(nd)
ENDIF
setList(list)
ENDPROC

PROC clear_Clicked()
setList()
freeList(list)
setList(list)
ENDPROC

PROC sort_Clicked()
DEF benable
setList()
benable:=enable
enable:=FALSE
sortExecList(list)
enable:=benable
setList(list)
ENDPROC

PROC use_Clicked()
IF twnd
   tleft:=twnd.leftedge
   ttop:=twnd.topedge
ENDIF
mleft:=mwnd.leftedge
mtop:=mwnd.topedge
saveCfg(CONFIG)
mwin_CloseWindow()
ENDPROC

PROC save_Clicked()
use_Clicked()
saveCfg(CONFIGS)
ENDPROC

PROC lastSaved_Clicked()
setList()
freeList(list)
loadCfgGad(CONFIGS)
setList(list)
ENDPROC

PROC restore_Clicked()
setList()
freeList(list)
loadCfgGad(CONFIG)
setList(list)
ENDPROC


PROC enable_Clicked()
DEF gad:PTR TO gadget
gad:=tgm[GAD_ENABLE]
enable:=IF gad.flags AND GFLG_SELECTED THEN TRUE ELSE FALSE
cx.activate(enable)
ENDPROC

PROC mode_Clicked()
mode:=code
ENDPROC

PROC mtype_Clicked()
DEF nd:PTR TO mynode
oldmtype:=code+code
IF (nd:=mainNode())
    nd.mtype:=oldmtype
ENDIF
ENDPROC

PROC setList(lh=-1)
IF mwnd
   Gt_SetGadgetAttrsA(tgm[GAD_MLIST],mwnd,NIL,[GTLV_LABELS,lh,GTLV_SELECTED,mlistpos,
                                                  GTLV_TOP,mlistpos,TAG_END])
ENDIF
ENDPROC

PROC mainNode()
DEF node:PTR TO ln,x
node:=list.head
FOR x:=1 TO mlistpos
  EXIT node=NIL
  node:=node.succ
ENDFOR
ENDPROC node





PROC saveCfg(name)
DEF fh,out,node:PTR TO mynode
IF (fh:=Open(name,NEWFILE))
   out:=SetStdOut(fh)
   writeLine(HEADER)
   WriteF('\d,\d;\d,\d\n',mleft,mtop,tleft,ttop)
   IF deffont=FALSE THEN WriteF('FONT:\s,\d\n',tattr.name,tattr.ysize)
   writeLine(IF mode=MODE_EXCLUDE THEN EXCLUDE ELSE INCLUDE)
   node:=list.head
   WHILE node
       IF node.ln.succ
          WriteF('"\s" ',node.ln.name)
          IF node.mtype<>TYPE_ANY
             writeLine(IF node.mtype=TYPE_CHIP THEN CHIP ELSE FAST)
          ELSE
             writeLine('')
          ENDIF
       ENDIF
       node:=node.ln.succ
   ENDWHILE
   SetStdOut(out)
   Close(fh)
ENDIF
ENDPROC

PROC writeLine(text) IS WriteF('\s\n',text)

PROC loadCfgGad(name)
DEF res
res:=loadCfg(name)
Gt_SetGadgetAttrsA(tgm[GAD_MODE],mwnd,NIL,[GTMX_ACTIVE,mode,TAG_END])
ENDPROC res

PROC loadCfg(name)
DEF fh,line[120]:STRING,res=FALSE,mtype,x
IF (fh:=Open(name,OLDFILE))
    IF ReadStr(fh,line)>0
       IF StrCmp(line,HEADER)
          IF ReadStr(fh,line)>0
             mleft,x:=Val(line)          /*  get mleft main Window leftedge    */
             IF x
                mtype:=line+x+1
                mtop,x:=Val(mtype)       /*  get mtop main Window topedge      */
             ENDIF
             IF x
                mtype:=mtype+x+1
                tleft,x:=Val(mtype)      /*  get tleft task Window leftedge    */
             ENDIF
             IF x
                ttop,x:=Val(mtype+x+1)   /*  get ttop task Window topedge      */
             ENDIF
             IF x
                IF ReadStr(fh,line)>0
                   IF StrCmp('FONT:',line,STRLEN)
                      mtype:=line+STRLEN
                      FOR x:=0 TO 80-1
                          fontname[x]:=mtype[x]
                          EXIT mtype[x]=","
                      ENDFOR
                      fontname[x]:=0
                      tattr.name:=fontname
                      tattr.ysize:=Val(mtype+x+1)
                      tattr.style:=NIL
                      tattr.flags:=NIL
                   ELSE
                      Seek(fh,-(EstrLen(line)+1),OFFSET_CURRENT)
                      Flush(fh)
                   ENDIF
                ENDIF
                IF ReadStr(fh,line)>0
                   mode:=MODE_BAD
                   IF StriCmp(line,INCLUDE)
                      mode:=MODE_INCLUDE
                   ELSEIF StriCmp(line,EXCLUDE)
                      mode:=MODE_EXCLUDE
                   ENDIF
                   IF mode<>MODE_BAD
                      res:=TRUE
                      WHILE ReadStr(fh,line)>0
                          mtype:=-1
                          IF line[]=34         -> "
                             mtype:=line+1
                             WHILE mtype[]<>34
                                 INC mtype
                                 EXIT EstrLen(line)<=(mtype-line)
                             ENDWHILE
                             IF mtype[]=34
                                mtype[]++:=0
                                IF mtype[]++=" "
                                   IF StriCmp(FAST,mtype)
                                      mtype:=TYPE_FAST
                                   ELSEIF StriCmp(CHIP,mtype)
                                      mtype:=TYPE_CHIP
                                   ELSEIF mtype[]=0
                                      mtype:=TYPE_ANY
                                   ENDIF
                                ENDIF
                             ENDIF
                          ENDIF
                          IF mtype<>TYPE_FAST
                             IF mtype<>TYPE_CHIP
                                IF mtype<>TYPE_ANY
                                   freeList(list)
                                   res:=FALSE
                                ENDIF
                             ENDIF
                          ENDIF
                          EXIT res=FALSE
                          EXIT addNode(line+1,mtype)=NIL
                      ENDWHILE
                   ENDIF
                ENDIF
             ELSE
                mleft:=100 ; mtop:=150
                tleft:=110 ; ttop:=40
             ENDIF
          ENDIF
       ENDIF
    ENDIF
    Close(fh)
ENDIF
ENDPROC res


PROC addNode(name,mtype=TYPE_ANY)
DEF bname,node=NIL:PTR TO mynode
IF name
   IF name[]
      IF (bname:=New(StrLen(name)+2))
         IF (node:=New(SIZEOF mynode))
             AstrCopy(bname,name)
             node.ln.name:=bname
             node.mtype:=mtype
             AddTail(list,node)
         ELSE
             Dispose(bname)
         ENDIF
      ENDIF
   ENDIF
ENDIF
ENDPROC node


PROC freeList(lh:PTR TO lh)
DEF node:PTR TO ln,next
node:=lh.head
WHILE node
    next:=node.succ
    IF next
       remNode(node)
    ENDIF
    node:=next
ENDWHILE
ENDPROC


PROC remNode(node:PTR TO ln)
IF node
   IF node.succ
      Remove(node)
      Dispose(node.name)
      Dispose(node)
      RETURN TRUE
   ENDIF
ENDIF
ENDPROC FALSE

/*
PROC find(name)
DEF node:PTR TO mynode,res,next
IF name
   node:=list.head
   IF node
      res:=FALSE
      REPEAT
         EXIT (next:=node.ln.succ)=NIL
         EXIT (res:=StriCmp(name,node.ln.name))
         node:=next
      UNTIL node=NIL
      IF res THEN RETURN node
   ENDIF
ENDIF
ENDPROC NIL
*/


PROC find(name)
DEF node:REG PTR TO mynode,res:REG,next:REG
MOVE.L   name,D0
BEQ.S    findquit
   MOVEA.L   list,A0
   MOVE.L    (A0),node        ->  list.head
   BEQ.S     findquit
   MOVEQ     #FALSE,res
   loopfind:
      MOVEA.L  node,A0
      MOVE.L   (A0),next      ->  node.ln.succ
      BEQ.S    endloopfind
      StriCmp  (name,node.ln.name,ALL)
      MOVE.L   D0,res
      BNE.S    endloopfind
      MOVE.L   next,node
      BNE.S    loopfind
   endloopfind:
   MOVE.L   res,D0
   BEQ.S    findquit
   MOVE.L   node,D0
findquit:
ENDPROC D0




PROC SAFE patch()
DEF d0s:REG,d1s:REG
GetA4    ()
ADDQ.L   #1,inuse
TST.L    enable
BEQ.S    quitpatch
  MOVE.L   D0,d0s
  MOVE.L   D1,d1s
  SUBA.L   A1,A1
  JSR      FindTask(A6)
  MOVE.L   D0,-(A7)
  BSR.W    taskName
  MOVE.L   D0,(A7)
  BSR.S    find
  ADDQ.L   #4,A7
  MOVEQ    #MODE_EXCLUDE,D1
  CMP.L    mode,D1
  BNE.S    isinclude
    TST.L    D0
    BNE.S    contpatch
      BCLR     #1,d1s
      BSET     #2,d1s
      BRA.S    contpatch
  isinclude:
  TST.L    D0
  BEQ.S    contpatch
    BCLR     #1,d1s
    BCLR     #2,d1s
    MOVEA.L  D0,A0
    OR.L     14(A0),d1s     -> mynode.mtype
contpatch:
MOVE.L   d0s,D0
MOVE.L   d1s,D1
MOVEA.L  execbase,A6
quitpatch:
MOVEA.L  oldvec,A0
JSR      (A0)
SUBQ.L   #1,inuse
TST.L    D0
ENDPROC  D0







