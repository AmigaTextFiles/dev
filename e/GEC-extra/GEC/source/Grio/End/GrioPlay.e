OPT PREPROCESS
OPT LARGE
OPT REG=5


#define GEC    -> GEC mode: better optimizations
->#define CREA   -> CreativE compatible
#define HIGH   -> OS 2.04 + CPU 020 required

#ifdef HIGH
OPT OSVERSION=37
OPT 020
#define GPVER 'Compiled for: 020+ , OS v2.04+'
#define PutFmt PrintF
#ifdef CREA
OPT RUNBG
#endif
#endif

#ifndef HIGH
#define GPVER 'Compiled for: 000+ , OS v1.3+'
#define PutFmt WriteF
#endif


#ifdef GEC
OPT STRMERGE
OPT RUNBG
#define REL(name) name
#endif


#ifndef GEC
#define REL(name) {name}
MODULE 'grio/str/stricmp'
#define StriCmp stricmp
#ifndef HIGH
MODULE 'grio/detatch'
#define DETATCH
#endif
#endif




#define DATE '(23.06.2002)'
#define VERS '1.64c9'
#define LSIDENT 'GrioPlLst:\n'
#define LSIDENTL 11
#define GRIOPLAY 'GrioPlay'
#define LOCKPUBSCR TRUE

#define NAMESIZE 258


#define OFFGADGETS






MODULE 'gadtools','libraries/gadtools',
       'exec/memory','exec/ports','exec/lists','exec/nodes',
       'graphics/modeid','graphics/rastport','graphics/text',
       'intuition/intuition','intuition/screens',
       'intuition/gadgetclass','intuition/iobsolete',
       'utility/tagitem',
       'dos/dos','exec/tasks',
       'dos/dosextens',
       'exec/semaphores'




MODULE 'reqtools','libraries/reqtools',
       'xpkmaster','xpk/xpk',
       'devices/audio','devices/inputevent',
       'devices/timer','exec/io',
       'powerpacker','libraries/ppbase',
       'workbench','workbench/startup',
       'workbench/workbench','icon'


MODULE 'grio/str/sprintf','grio/eval',
       'grio/ptreplay','grio/str/textf',
       'grio/threads','grio/libver','grio/char',
       'grio/str/clrstrcpy','grio/lha',
       'grio/timersoftint','grio/ports','grio/io',
       'grio/digiplayer','grio/playsid',
       'libraries/playsidbase','grio/scrnotify',
       'grio/getToolType','grio/rtfiler',
       'grio/clearwinport',
       'grio/cxer','libraries/commodities'


#ifdef HIGH
MODULE 'grio/ahxreplay020','grio/gadtools'
#define AllocVect AllocVec
#define FreeVect FreeVec
#define dAddPart AddPart
#define dFilePart FilePart
#endif
#ifndef HIGH
MODULE 'grio/ahxreplay','grio/gadtools33','grio/mem','grio/partutils'
#define AllocVect allocVec
#define FreeVect freeVec
#define dAddPart addpart
#define dFilePart filepart
#endif



DEF maingt:PTR TO gadtools,infogt:PTR TO gadtools,dispgt:PTR TO gadtools,
    confgt:PTR TO gadtools,modlgt:PTR TO gadtools,nsport:PTR TO mp,
    timegt:PTR TO gadtools,appwin:PTR TO window,wbtask=NIL


ENUM NO_VOLMETER,FAKE_VOLMETER,REAL_VOLMETER,FUNNY_VOLMETER,LAST_VOLMETER

ENUM TT_APPICON,TT_HIDE,TT_TABSIZE

ENUM RTF_LOAD=1,RTF_ADD,RTF_MODS,RTF_SAVELIST,RTF_SAVE
ENUM RTFT_LOAD,RTFT_ADD,RTFT_MODS,RTFT_SAVELIST,RTFT_SAVE,RTFT_NUM

ENUM TH_SLAVE=1,TH_READMOD,TH_ABOUT

DEF thread:PTR TO threads


OBJECT name
 file[108]:ARRAY
ENDOBJECT


DEF rtf:PTR TO rtfiler,rtfport:PTR TO mp,olposx,olposy,olsupx,olsupy,
    errmsg=TRUE,rtffile[RTFT_NUM]:ARRAY OF name,skiped,stacknode,
    breakfade,breaknorm,audiosem:ss,winsem:ss,tt[TT_TABSIZE]:ARRAY OF LONG,
    cx:PTR TO cxer,slavetask



ENUM AW_CONF,AW_LIST,AW_INFO,AW_DISP

ENUM UNKNOWNTYPE,PROTRACKER,DIGIBOOSTER,AHXABYSS,PSID

DEF modtype=UNKNOWNTYPE,ns:PTR TO scrnotify,nsid



ENUM ERROR_NONE,
     ERROR_CONTEXT,
     ERROR_GADGET,
     ERROR_SCRN,
     ERROR_VISUAL,
     ERROR_GT,
     ERROR_WINDOW,
     ERROR_PORT,
     ERROR_RT,
     ERROR_REQ,
     ERROR_AUDIO,
     ERROR_TIMER,
     ERROR_THREAD,
     ERROR_NOMEM


CONST KEY_UP=76,KEY_DOWN=77,KEY_ENTER=13,KEY_LEFT=79,KEY_RIGHT=78



OBJECT command
play,stop,pause,getvol,setvol
isenabled,next,prev,smpinfo
fwd,rev,numsongs,loop
songpos,pattpos,title,text
ENDOBJECT






OBJECT config
 head[10]:ARRAY OF CHAR
 loop:INT
 fade:INT
 volume:INT
 dirname[NAMESIZE]:ARRAY OF CHAR
 mainleft:INT,maintop:INT
 listleft:INT,listtop:INT
 confleft:INT,conftop:INT
 posleft:INT,postop:INT
 infoleft:INT,infotop:INT
 dispopen:LONG
 volmet:LONG
 error:LONG
 lhacmd[82]:ARRAY OF CHAR
 lhatemp[82]:ARRAY OF CHAR
 fontval:LONG
 fontflags:CHAR
 fontstyle:CHAR
 fontY:INT
 fontname[32]:ARRAY
 infoopen:LONG
 mlstopen:LONG
 backward:INT
 timetype:INT
 timedelay:INT
 menu:INT
ENDOBJECT


OBJECT mymsg
 mn:mn
 type:INT
 name[514]:ARRAY OF CHAR
 dir:PTR TO CHAR
ENDOBJECT


OBJECT mynode
 ln:ln
 path:LONG
 dtype:LONG
ENDOBJECT


OBJECT volmet
 pos[4]:ARRAY OF LONG
 last[4]:ARRAY OF LONG
 note[4]:ARRAY OF LONG
 ofx:LONG
 x4:LONG
 xfull:LONG
 chan[4]:ARRAY OF LONG
ENDOBJECT



DEF infos:PTR TO gadget,mainwnd:PTR TO window,
    type,id,code,qual,running=TRUE,maintask:PTR TO tc,
    volmet=FAKE_VOLMETER,vm:volmet,loadgad,addgad,
    mpathgad,savemlgad,nextgad:PTR TO gadget,prevgad:PTR TO gadget,
    savegad:PTR TO gadget,nextsg:PTR TO gadget,prevsg:PTR TO gadget


DEF module,memlen,aport
DEF ereq,ioa:PTR TO ioaudio,winport:PTR TO mp,opendev=FALSE,audio=FALSE
DEF fade=FALSE,volgad,scrname[80]:ARRAY
DEF mainleft=418,maintop=180,modlen,pause,playgad:PTR TO gadget
DEF infownd:PTR TO window,smpgad,iscroll
DEF infoleft=120,infotop=130,pausegad,playgadactiv=TRUE


DEF oldpos,songlen,ptport:PTR TO mp,oldpatt,mainappwin,
    volume=64,oldnumnode,subsong,numsubsongs,oldsubsong,
    fontreq:PTR TO rtfontrequester,fontval,fontgad,
    modtitle[38]:STRING,menu=TRUE,menugad:PTR TO gadget

#ifndef HIGH
DEF mainsize
#endif



ENUM LOOPLIST,LOOPMOD,ONCELIST,ONCEMOD
ENUM APPIDMAIN=1,APPIDLIST

CONST APPWINDOW=AMTYPE_APPWINDOW,APPICON=AMTYPE_APPICON,SHELLARG=15

ENUM TIMETYPE_NONE,TIMETYPE_NOTENDING,TIMETYPE_ALL


DEF modlistwnd:PTR TO window,samp[1120]:STRING,smpl[31]:LIST,
    listerleft=98,listertop=8,listappwin,modlst:lh,
    listgad:PTR TO gadget,listpos,numnodepos,tm:PTR TO timersoftint,
    tsec,tmin,quadr,confwnd:PTR TO window,
    confleft=386,conftop=16,loop=LOOPLIST,
    oldsec,oldmic,oldtsec,oldtmin,dispwnd:PTR TO window,
    posleft=424,postop=114,strcmd:PTR TO gadget,lhacmd[82]:ARRAY,
    lhatemp[82]:ARRAY,strtemp:PTR TO gadget,vmgad:PTR TO gadget,
    timewnd:PTR TO window,timetype=TIMETYPE_NOTENDING,
    timedelay=300


DEF modsdir[NAMESIZE]:ARRAY,savelsdir[NAMESIZE]:ARRAY,
    backward,dob:PTR TO diskobject,appicon,awins[4]:ARRAY OF LONG,
    screen:PTR TO screen,textattr:textattr


ENUM NOMOD,NOTPACKED,POWERPACKER,XPKMASTER,ARCHLHA

ENUM FONT_SCREEN,FONT_DISK


CONST MAXTIMEDELAY=600

DEF timegad:PTR TO gadget


PROC isGadChecked(gad:PTR TO gadget) IS
  IF gad.flags AND GFLG_SELECTED THEN TRUE ELSE FALSE


#ifdef OFFGADGETS
PROC gtOnGadget(gad,win)
ObtainSemaphore(winsem)
IF win THEN Gt_SetGadgetAttrsA(gad,win,NIL,[GA_DISABLED,FALSE,TAG_DONE])
ReleaseSemaphore(winsem)
ENDPROC D0

PROC gtOffGadget(gad,win)
ObtainSemaphore(winsem)
 IF win THEN Gt_SetGadgetAttrsA(gad,win,NIL,[GA_DISABLED,TRUE,TAG_DONE])
ReleaseSemaphore(winsem)
ENDPROC D0
#endif



PROC closewins()
IF mainwnd
   awins[AW_CONF]:=confwnd
   closeconfwindow()
   awins[AW_LIST]:=modlistwnd
   closemodlisterwin()
   awins[AW_INFO]:=infownd
   closeinfowindow()
   awins[AW_DISP]:=dispwnd
   closedispwindow()
   closemainwindow()
ENDIF
ENDPROC


PROC openwins()
IF mainwnd=NIL
   reporterr(openmainwindow())
   IF awins[AW_DISP] THEN disp_Clicked()
   IF awins[AW_INFO] THEN info_Clicked()
   IF awins[AW_LIST] THEN modlist_Clicked()
   IF awins[AW_CONF] THEN conf_Clicked()
ELSE
   ActivateWindow(mainwnd)
ENDIF
ENDPROC mainwnd





PROC openinfowindow() HANDLE
  #ifdef GEC
  DEF x:REG,tattr:REG
  #endif
  #ifndef GEC
  DEF x,tattr
  #endif
  IF infownd THEN RETURN NIL
  NEW infogt
  tattr:=IF fontval=FONT_DISK THEN fontreq.attr ELSE NIL
  IF x:=infogt.new(NIL,tattr,150)
     RETURN convertErr(x)
  ENDIF
  IF (smpgad:=infogt.gadget(SCROLLER_KIND,306,22,18,71,NIL,NIL,
     {smpscroll_Clicked},[GA_RELVERIFY,1,PGA_FREEDOM,
     LORIENT_VERT,GTSC_TOTAL,31,GTSC_TOP,iscroll,
     GTSC_VISIBLE,8,TAG_END]))=NIL THEN Raise(ERROR_GADGET)
  IF (infownd:=infogt.openWin(infoleft,infotop,332,96,
      IDCMP_CLOSEWINDOW OR SCROLLERIDCMP OR IDCMP_RAWKEY,
      WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
      WFLG_SMART_REFRESH OR WFLG_RMBTRAP,'GrioPlay Info',winport,
      NIL,LOCKPUBSCR,scrname)
      )=NIL THEN Raise(ERROR_WINDOW)
  infownd.userdata:=[REL(closeinfowindow),0,0,REL(info_RawKeys)]
  infogt.bevelBox(8,22,296,71)
  infogt.bevelBox(8,5,316,14,TRUE)
  SetDrMd(infownd.rport,RP_JAM2)
  SetAPen(infownd.rport,1)
  showModTitle()
  showSamples()
  reSetMenu(0)
EXCEPT
  END infogt
  RETURN exception
ENDPROC



PROC showModTitle()
DEF str[8]:STRING,len=ALL
DEF title
SELECT modtype
    CASE PROTRACKER
        title:=module
        len:=20
    CASE DIGIBOOSTER
        title:=module+610
    CASE AHXABYSS
        title:=module+Int(module+4)
    CASE PSID
        title:=module+22
    DEFAULT
        title:='GrioPlay   v'+VERS
ENDSELECT
StrCopy(modtitle,title,len)
IF infownd
   textf(infownd.rport,infogt.calcXX(13),infogt.calcYY(14),'\l\s[38]',{modtitle})
   IF modlen
      StringF(str,'\d',modlen)
      textf(infownd.rport,infogt.calcXX(320)-infogt.calcText(str),infogt.calcYY(14),'\s',{str})
   ENDIF
ENDIF
ENDPROC

PROC showSamples()
DEF x,y,z,i,text[30]:STRING,w,rast
IF infownd
   x:=infogt.calcXX(12)
   y:=infogt.calcYY(31)
   z:=infogt.font.ysize
   w:=infogt.calcXX(300)
   rast:=infownd.rport
   SetAPen(rast,0)
   RectFill(rast,infogt.calcXX(11),infogt.calcYY(23),infogt.calcXX(300),infogt.calcYY(89))
   SetAPen(rast,1)
   FOR i:=iscroll TO iscroll+7
      Move(rast,x,y)
      StrCopy(text,samp+(i*30))
      Text(rast,text,EstrLen(text))
      ->SetAPen(rast,0)
      ->RectFill(rast,infogt.calcTextX(text),y-z,infogt.calcXX(300),y)
      ->SetAPen(rast,1)
      IF ListLen(smpl)
         StringF(text,'\d',smpl[i])
         Move(rast,w-infogt.calcText(text),y)
         Text(rast,text,EstrLen(text))
      ENDIF
      y:=y+z
   ENDFOR
ENDIF
ENDPROC

PROC clearInfo()
DEF rast
ObtainSemaphore(winsem)
info2Samp()
IF infownd
   SetAPen(rast:=infownd.rport,0)
   RectFill(rast,infogt.calcXX(12),infogt.calcYY(6),
            infogt.calcXX(318),infogt.calcYY(16))
   RectFill(rast,infogt.calcXX(11),infogt.calcYY(23),
            infogt.calcXX(300),infogt.calcYY(89))
   SetAPen(rast,1)
ENDIF
ReleaseSemaphore(winsem)
ENDPROC


PROC smpscroll_Clicked()
IF code<>iscroll
   iscroll:=code
   showSamples()
ENDIF
ENDPROC


PROC info_RawKeys()
DEF raw
raw:=code
SELECT raw
    CASE KEY_UP
        IF iscroll>0
           DEC iscroll
           showSampleScroll()
        ENDIF
    CASE KEY_DOWN
        IF iscroll<23
           INC iscroll
           showSampleScroll()
        ENDIF
ENDSELECT
ENDPROC


PROC showSampleScroll()
  showSamples()
  IF infownd THEN
      Gt_SetGadgetAttrsA(smpgad,infownd,NIL,[GTSC_TOP,iscroll,TAG_DONE])
ENDPROC

PROC closeinfowindow()
  ObtainSemaphore(winsem)
  IF infownd 
     infoleft:=infownd.leftedge
     infotop:=infownd.topedge
  ENDIF
  END infogt
  infownd:=NIL
  reSetMenu(0)
  ReleaseSemaphore(winsem)
ENDPROC


PROC opendispwindow() HANDLE
  #ifdef GEC
  DEF hi:REG,win:REG PTR TO window,x:REG
  #endif
  #ifndef GEC
  DEF hi,win:PTR TO window,x
  #endif
  IF dispwnd THEN RETURN NIL
  NEW dispgt
  IF hi:=dispgt.new(NIL,IF fontval=FONT_DISK THEN fontreq.attr ELSE NIL)
     RETURN convertErr(hi)
  ENDIF
  hi:=IF volmet=NO_VOLMETER THEN 22 ELSE 52
  IF (win:=dispgt.openWin(posleft,postop,198,hi,IDCMP_CLOSEWINDOW OR
      IDCMP_VANILLAKEY,WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
      WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR WFLG_RMBTRAP,
      'GrioPlay Display',winport,NIL,LOCKPUBSCR,scrname))=NIL THEN Raise(ERROR_WINDOW)
  win.userdata:=[REL(closedispwindow),REL(disp_VanillaKey),0,0]
  dispgt.bevelBox(145,4,47,13,TRUE)
  dispgt.bevelBox(5,4,88,13,TRUE)
  dispgt.bevelBox(95,4,48,13,TRUE)
  IF volmet<>NO_VOLMETER
     dispgt.bevelBox(9,21,115,27)
     FOR hi:=0 TO 3 DO vm.last[hi]:=0
     dispgt.bevelBox(130,21,60,27)
     FOR x:=0 TO 3
       vm.chan[x]:=dispgt.calcY(6)*x+dispgt.calcYY(23)
     ENDFOR
     vm.ofx:=dispgt.calcXX(13)
     vm.x4:=dispgt.calcY(4)
     vm.xfull:=dispgt.calcX(64+42)     -> 42 = 64 * (2/3)
  ENDIF
  SetDrMd(win.rport,RP_JAM2)
  oldsubsong:=oldpatt:=oldtsec:=-1
  win.rport.areaptrn:=[$5555,$5555]:INT
  win.rport.areaptsz:=1
  dispwnd:=win
  IF audio=NIL THEN updateText()
  bingbong()
  reSetMenu(1)
EXCEPT
  END dispgt
  RETURN exception
ENDPROC



PROC disp_VanillaKey()
 DEF oldvm
 IF (code=KEY_ENTER)
    oldvm:=volmet
    INC volmet
    IF volmet=LAST_VOLMETER
       volmet:=NO_VOLMETER
    ENDIF
    IF (volmet=NO_VOLMETER) OR (oldvm=NO_VOLMETER)
       IF dispwnd
          closedispwindow()
          opendispwindow()
          IF dispwnd THEN ActivateWindow(dispwnd)
       ENDIF
    ENDIF
    IF (volmet=REAL_VOLMETER)
       FOR oldvm:=0 TO 3 DO vm.last[oldvm]:=0
    ENDIF
    IF confwnd
       Gt_SetGadgetAttrsA(vmgad,confwnd,NIL,[GTCY_ACTIVE,volmet,TAG_DONE])
    ENDIF
 ENDIF
ENDPROC




PROC bingbong()
 DEF rast,text
 ObtainSemaphore(winsem)
 IF dispwnd AND (volmet<>NO_VOLMETER)
    SetAPen(rast:=dispwnd.rport,0)
    RectFill(rast,dispgt.calcXX(132),dispgt.calcYY(23),
                  dispgt.calcXX(186),dispgt.calcYY(45))
    SELECT modtype
       CASE PROTRACKER
            text:='PTNT'
       CASE DIGIBOOSTER
            text:='DIGI'
       CASE AHXABYSS
            text:='AHX!'
       CASE PSID
            text:='PSID'
       DEFAULT
            text:='GRIO'
    ENDSELECT
    SetAPen(rast,1)
    olposx:=olposy:=0
    olsupx:=olsupy:=-1
    textf(rast,dispgt.calcXX(132),dispgt.calcYY(21)+
                                    dispgt.tattr.ysize,text)
 ENDIF
 ReleaseSemaphore(winsem)
ENDPROC


PROC closedispwindow()
 ObtainSemaphore(winsem)
 IF dispwnd
    posleft:=dispwnd.leftedge
    postop:=dispwnd.topedge
    dispwnd:=NIL
 ENDIF
 END dispgt
 reSetMenu(1)
 ReleaseSemaphore(winsem)
ENDPROC 





PROC main_CloseWindow()
IF easyReq('Do you want quit ?','_Yes|_No')
   quitProg()
ENDIF
ENDPROC running


PROC quitProg()
REPEAT
   Delay(2)
UNTIL (NIL=rtf.isopen()) AND (thread.islaunched(TH_ABOUT)=FALSE)
ejectMod()
clear_Clicked()
running:=FALSE
cleanLHA()
ENDPROC


PROC main_RawKeys()
DEF raw,back
raw:=code
SELECT raw
    CASE KEY_LEFT
        prevsong_Clicked()
    CASE KEY_RIGHT
        nextsong_Clicked()
    CASE KEY_UP
         IF listpos > 0
            DEC listpos
            back:=backward
            backward:=TRUE
            IF playCurrentNodeShow()=FALSE THEN INC listpos
            backward:=back
         ENDIF
    CASE KEY_DOWN
         IF (listpos+1)<numnodepos
            INC listpos
            IF playCurrentNodeShow()=FALSE THEN DEC listpos
         ENDIF
ENDSELECT
ENDPROC


PROC main_VanillaKey()
DEF key
 key:=lowerChar(code)
 SELECT key
    CASE "q"
       main_CloseWindow()
    CASE "l"
       load_Clicked()
    CASE "p"
       play_Clicked()
    CASE "s"
       stop_Clicked()
    CASE "e"
       eject_Clicked()
    CASE "i"
       info_Clicked()
    CASE "z"
       qual:=IEQUALIFIER_RBUTTON
       main_MouseButtons()
    CASE "f"
       fwd_Clicked()
    CASE "r"
       rew_Clicked()
    CASE "m"
       modlist_Clicked()
    CASE "d"
       disp_Clicked()
    CASE "n"
       next_Clicked()
    CASE "v"
       prev_Clicked()
    CASE "c"
       conf_Clicked()
    CASE "+"
       IF 64>volume
          INC volume
          fadeVol(volume)
       ENDIF
    CASE "-"
       IF 0<volume
          DEC volume
          fadeVol(volume)
       ENDIF
    CASE "h"
       hide_Clicked()
    CASE KEY_ENTER
       play_Clicked()
 ENDSELECT
ENDPROC


PROC main_MouseButtons()
 IF (IEQUALIFIER_RBUTTON AND qual)
    #ifdef HIGH
    ZipWindow(mainwnd)
    #endif
    #ifndef HIGH
    IF libver(intuitionbase,36)
       ZipWindow(mainwnd)
    ELSE
       SizeWindow(mainwnd,0,mainsize:=-mainsize)
    ENDIF
    #endif
 ENDIF
ENDPROC



PROC load_Clicked()
oldnumnode:=0
#ifdef OFFGADGETS
IF rtf.open(RTF_LOAD,'GrioPlay Load',getrtftags(RTFT_LOAD))
   gtOffGadget(loadgad,mainwnd)
ENDIF
#endif
#ifndef OFFGADGETS
rtf.open(RTF_LOAD,'GrioPlay Load',getrtftags(RTFT_LOAD))
#endif
ENDPROC



PROC play_Clicked()
 IF module
    IF audio
       SELECT modtype
           CASE PROTRACKER
               ptPause()
           CASE DIGIBOOSTER
               digiPause()
           CASE AHXABYSS
               ahxPause()
           CASE PSID
               psidPause()
       ENDSELECT
       pause:=Not(pause)
       swapGads()
    ELSE
       IF module
          audioStart()
       ELSE
          playCurrentNode()
       ENDIF
    ENDIF
 ELSE
    IF numnodepos>0 THEN playCurrentNodeShow() ELSE load_Clicked()
 ENDIF
ENDPROC


PROC stop_Clicked()
 IF module
    IF (thread.islaunched(TH_READMOD))=FALSE
       audioEnd()
    ENDIF
 ENDIF
ENDPROC


PROC eject_Clicked()
 IF (thread.islaunched(TH_READMOD))=FALSE
    ejectMod()
    showModTitle()
    showSamples()
 ENDIF
ENDPROC


PROC ejectMod(free=TRUE)
 IF module
    audioEnd()
    IF free
       tsec:=tmin:=songlen:=subsong:=numsubsongs:=0
       oldpatt:=-1
       updateText()
       FreeMem(module,memlen)
       module:=memlen:=modlen:=NIL
       clearInfo()
       stdTitle()
       modtype:=UNKNOWNTYPE
       bingbong()
       #ifdef OFFGADGETS
       gtOffGadget(savegad,mainwnd)
       #endif
    ENDIF
 ENDIF
ENDPROC



PROC rew_Clicked()
 DEF pos
 ObtainSemaphore(audiosem)
 IF module
    SELECT modtype
        CASE PROTRACKER
           ptSetSongPos(IF pos:=ptGetSongPos() THEN pos-1 ELSE songlen-1)
           ptSetPattPos(0)
        CASE DIGIBOOSTER
           digiSetSongPos(IF pos:=digiGetSongPos() THEN pos-1 ELSE songlen-1)
           digiSetPattPos(0)
        CASE AHXABYSS
           IF (pos:=ahxGetSongPos())
              ahxPrevPatt()
           ELSE
              ahxSetSongPos(songlen-1)
              ahxSetPattPos(0)
           ENDIF
        CASE PSID
           psidRewSong()
    ENDSELECT
    oldpos:=0
 ENDIF
 ReleaseSemaphore(audiosem)
ENDPROC


PROC fwd_Clicked()
 DEF pos
 ObtainSemaphore(audiosem)
 IF module
    SELECT modtype
        CASE PROTRACKER
            ptSetSongPos(IF (pos:=ptGetSongPos())=(songlen-1) THEN 0 ELSE pos+1)
            ptSetPattPos(0)
        CASE DIGIBOOSTER
            digiSetSongPos(IF (pos:=digiGetSongPos())=(songlen-1) THEN 0 ELSE pos+1)
            digiSetPattPos(0)
        CASE AHXABYSS
            ahxNextPatt()
        CASE PSID
            psidFwdSong()
    ENDSELECT
 ENDIF
 ReleaseSemaphore(audiosem)
ENDPROC

PROC info_Clicked()
IF infownd=NIL
   reporterr(openinfowindow())
ELSE
   closeinfowindow()
ENDIF
ENDPROC



PROC volume_Clicked()
 IF volume<>code
    volume:=code
    SELECT modtype
        CASE PROTRACKER
           IF ptIsEnabled() THEN ptSetVolume(volume)
        CASE DIGIBOOSTER
           IF digiIsEnabled() THEN digiSetVolume(volume)
        CASE AHXABYSS
           IF ahxIsEnabled() THEN ahxSetVolume(volume)
    ENDSELECT
 ENDIF
ENDPROC


PROC modlist_Clicked()
 IF modlistwnd=NIL
    reporterr(openmodlisterwin())
 ELSE
    closemodlisterwin()
 ENDIF
ENDPROC



PROC disp_Clicked()
 IF dispwnd=NIL
    reporterr(opendispwindow())
 ELSE
    closedispwindow()
 ENDIF
ENDPROC



PROC conf_Clicked()
 IF confwnd=NIL
    reporterr(openconfwindow())
 ELSE
    closeconfwindow()
 ENDIF
ENDPROC



PROC about() IS easyReq('Pro(Noise)Tracker,AHX,'+
                        'PSID,DIGIBooster\n'+
                        'module player.\n'+
                        GPVER+'\n'+
                        'Copyright © '+DATE+'\n'+
                        'ogrio.o2.pl','_Ok')




PROC hide_Clicked()
IF (wbtask<>NIL) AND (dob<>NIL)
   IF tt[TT_APPICON]=NIL THEN addAppIcon()
   IF appicon
      closewins()
   ELSE
      openAppWin()
   ENDIF
ELSE
   openAppWin()
ENDIF
ENDPROC



PROC getrtftags(num)
DEF flags:PTR TO LONG
flags:=[FREQF_MULTISELECT+FREQF_SELECTDIRS+FREQF_PATGAD,
        FREQF_MULTISELECT+FREQF_SELECTDIRS+FREQF_PATGAD,
        FREQF_NOFILES,
        FREQF_SAVE+FREQF_PATGAD,
        FREQF_SAVE+FREQF_PATGAD]
ENDPROC [RT_SCREEN,screen,RT_TEXTATTR,textattr,RTFI_FLAGS,flags[num],TAG_END]



PROC addAppIcon()
IF appicon=NIL
   appicon:=AddAppIconA(APPIDMAIN,NIL,GRIOPLAY,ptport,NIL,dob,NIL)
ENDIF
ENDPROC appicon


PROC openAppWin()
IF appwin=NIL
   IF (appwin:=OpenW(mainwnd.leftedge,mainwnd.topedge,maingt.calcX(160),
                    maingt.offy,NIL,WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR
                    WFLG_DRAGBAR OR WFLG_RMBTRAP,'GrioPlay',maingt.screen,15,NIL))
      appwin.userdata:=[REL(closeAppWin),0,0,0]
      appwin.userport:=winport
      ModifyIDCMP(appwin,IDCMP_CLOSEWINDOW)
      closewins()
   ENDIF
ENDIF
ENDPROC appwin



PROC closeAppWin()
 clearWinPort(appwin)
 CloseWindow(appwin)
 appwin:=0
ENDPROC openwins()



PROC next_Clicked()
 DEF oldlp,oldback
 ObtainSemaphore(audiosem)
 IF (1<numnodepos)
    oldlp:=listpos
    INC listpos
    IF listpos=numnodepos THEN listpos:=0
    oldback:=backward
    backward:=FALSE
    IF playCurrentNodeShow()=FALSE THEN listpos:=oldlp
    backward:=oldback
 ENDIF
 ReleaseSemaphore(audiosem)
ENDPROC



PROC nextsong_Clicked()
 IF numsubsongs>1
    SELECT modtype
         CASE PSID
              IF psidCurrentSong()<psidNumberSongs(module)
                 subsong:=psidSetSong(psidCurrentSong()+1)
                 tsec:=tmin:=0
                 #ifdef OFFGADGETS
                 setNextPrevSong()
                 #endif
              ENDIF
         CASE AHXABYSS
              IF ahxCurrentSong()<ahxNumberSongs()
                 tsec:=tmin:=0
                 subsong:=ahxSetSong(ahxCurrentSong()+1)
                 #ifdef OFFGADGETS
                 setNextPrevSong()
                 #endif
              ENDIF
         DEFAULT
              RETURN FALSE
    ENDSELECT
    RETURN TRUE
 ENDIF
ENDPROC FALSE




PROC prev_Clicked()
 DEF oldlp,oldback
 ObtainSemaphore(audiosem)
 IF (1<numnodepos)
    oldlp:=listpos
    DEC listpos
    IF listpos<0 THEN listpos:=numnodepos-1
    oldback:=backward
    backward:=TRUE
    IF playCurrentNodeShow()=FALSE THEN listpos:=oldlp
    backward:=oldback
 ENDIF
 ReleaseSemaphore(audiosem)
ENDPROC



PROC prevsong_Clicked()
 IF numsubsongs>1
    SELECT modtype
        CASE PSID
             IF psidCurrentSong()>1
                subsong:=psidSetSong(psidCurrentSong()-1)
                tsec:=tmin:=0
                #ifdef OFFGADGETS
                setNextPrevSong()
                #endif
             ENDIF
        CASE AHXABYSS
             IF ahxCurrentSong()>1
                subsong:=ahxSetSong(ahxCurrentSong()-1)
                tsec:=tmin:=0
                #ifdef OFFGADGETS
                setNextPrevSong()
                #endif
             ENDIF
        DEFAULT
             RETURN FALSE
    ENDSELECT
    RETURN TRUE
 ENDIF
ENDPROC FALSE


PROC save_Clicked()
IF module
   #ifndef OFFGADGETS
   rtf.open(RTF_SAVE,'GrioPlay SaveMod',getrtftags(RTFT_SAVE))
   #endif
   #ifdef OFFGADGETS
   IF rtf.open(RTF_SAVE,'GrioPlay SaveMod',getrtftags(RTFT_SAVE))
      gtOffGadget(savegad,mainwnd)
   ENDIF
   #endif
ENDIF
ENDPROC




PROC savemod(rtfmsg:PTR TO rtfilermsg)
DEF fh,name[NAMESIZE]:ARRAY
IF rtfmsg.result
   AstrCopy(name,rtfmsg.req.dir,NAMESIZE)
   dAddPart (name,rtfmsg.file,NAMESIZE-1)
   IF overWrite(name)
      IF (fh:=Open(name,NEWFILE))
         Write(fh,module,modlen)
         Close(fh)
      ENDIF
   ENDIF
ENDIF
#ifdef OFFGADGETS
gtOnGadget(savegad,mainwnd)
#endif
ENDPROC




PROC playCurrentNode()
 DEF node:PTR TO mynode
 IF numnodepos
    IF node:=currentNode()
       loadlist(node.path,{node})
       RETURN thread.launch(TH_READMOD,node.path)
    ENDIF
 ENDIF
ENDPROC FALSE


PROC playCurrentNodeShow()
 DEF ret
 IF ret:=playCurrentNode() THEN toplist()
ENDPROC ret



PROC modlister_RawKeys()
DEF raw
  raw:=code
  SELECT raw
      CASE KEY_UP
          IF listpos > 0
             DEC listpos
             toplist()
             #ifdef OFFGADGETS
             setNextPrev()
             #endif
          ENDIF
      CASE KEY_DOWN
          IF (listpos+1)<numnodepos
             INC listpos
             toplist()
             #ifdef OFFGADGETS
             setNextPrev()
             #endif
          ENDIF
  ENDSELECT
ENDPROC

PROC modlister_Keys()
 DEF key,node:PTR TO mynode
 key:=lowerChar(code)
 SELECT key
    CASE "a"
       add_Clicked()
    CASE "r"
       rem_Clicked()
    CASE "u"
       up_Clicked()
    CASE "d"
       down_Clicked()
    CASE "c"
       clear_Clicked()
    CASE "o"
       sort_Clicked()
    CASE "s"
       savelst_Clicked()
    CASE "n"
       next_Clicked()
    CASE "v"
       prev_Clicked()
    CASE KEY_ENTER
       IF (node:=currentNode())
          playCurrentNode()
       ENDIF
 ENDSELECT
ENDPROC



PROC lister_Clicked()
 DEF sec,mic
 CurrentTime({sec},{mic})
 IF listpos=code
    IF DoubleClick(oldsec,oldmic,sec,mic)
       playCurrentNode()
    ENDIF
 ELSE
    listpos:=code
    #ifdef OFFGADGETS
    setNextPrev()
    #endif
 ENDIF
 oldsec:=sec
 oldmic:=mic
ENDPROC

PROC add_Clicked()
 oldnumnode:=numnodepos
 #ifndef OFFGADGETS
 rtf.open(RTF_ADD,'GrioPlay Add',getrtftags(RTFT_ADD))
 #endif
 #ifdef OFFGADGETS
 IF rtf.open(RTF_ADD,'GrioPlay Add',getrtftags(RTFT_ADD))
    gtOffGadget(addgad,modlistwnd)
 ENDIF
 #endif
ENDPROC


PROC rem_Clicked()
 IF numnodepos>0
    updatelist(-1)
    freeNode(currentNode())
    updatelist(modlst)
    #ifdef OFFGADGETS
    setNextPrev()
    IF numnodepos=0 THEN gtOffGadget(savemlgad,modlistwnd)
    #endif
 ENDIF
ENDPROC


PROC up_Clicked()
 DEF node:PTR TO ln,pred
 IF numnodepos>0
    updatelist(-1)
    node:=currentNode()
    pred:=node.pred::ln.pred
    Remove(node)
    IF listpos > 0 THEN DEC listpos
    IF listpos
       Insert(modlst,node,pred)
    ELSE
       AddHead(modlst,node)
    ENDIF
    updatelist(modlst)
    toplist()
    #ifdef OFFGADGETS
    setNextPrev()
    #endif
 ENDIF
ENDPROC


PROC down_Clicked()
 DEF node:PTR TO ln,succ
 IF numnodepos>0
    IF numnodepos>(listpos+1)
       updatelist(-1)
       node:=currentNode()
       succ:=node.succ
       Remove(node)
       Insert(modlst,node,succ)
       INC listpos
       updatelist(modlst)
       toplist()
       #ifdef OFFGADGETS
       setNextPrev()
       #endif
    ENDIF
 ENDIF
ENDPROC



PROC clear_Clicked()
 DEF node:PTR TO ln,succ
 node:=modlst.head
 updatelist(-1)
 WHILE numnodepos>0
      succ:=node.succ
      freeNode(node,FALSE)
      node:=succ
 ENDWHILE
 updatelist(modlst)
 listpos:=0
 #ifdef OFFGADGETS
 setNextPrev()
 gtOffGadget(savemlgad,modlistwnd)
 #endif
ENDPROC

#ifdef GEC
MODULE 'grio/sortexeclist'
#endif
#ifndef GEC
MODULE 'grio/_sortexeclist'
#endif


PROC sort_Clicked()
 DEF snode,fnode:PTR TO mynode,x
 snode:=currentNode()
 updatelist(-1)
 sortExecList(modlst)
 fnode:=modlst.head
 FOR x:=0 TO numnodepos-1
     EXIT snode=fnode
     fnode:=fnode.ln.succ
 ENDFOR
 listpos:=x
 updatelist(modlst)
 toplist()
 #ifdef OFFGADGETS
 setNextPrev()
 #endif
ENDPROC


PROC overWrite(name)
DEF lock
IF (lock:=Lock(name,SHARED_LOCK))=NIL
   RETURN 1
ELSE
   UnLock(lock)
ENDIF
ENDPROC easyReq('Overwrite existing file\n"%s" ?','_Yes|_No',[dFilePart(name)])



PROC savelst_Clicked()
IF numnodepos
   #ifndef OFFGADGETS
   rtf.open(RTF_SAVELIST,'GrioPlay Save List',getrtftags(RTFT_SAVELIST))
   #endif
   #ifdef OFFGADGETS
   IF rtf.open(RTF_SAVELIST,'GrioPlay Save List',getrtftags(RTFT_SAVELIST))
      gtOffGadget(savemlgad,modlistwnd)
   ENDIF
   #endif
ENDIF
ENDPROC

PROC savemodlist(rtfmsg:PTR TO rtfilermsg)
DEF fh,lstname[NAMESIZE]:ARRAY,lst:PTR TO mynode
IF rtfmsg.result
   AstrCopy(lstname,rtfmsg.req.dir,ALL)
   dAddPart(lstname,rtfmsg.file,NAMESIZE-2)
   IF overWrite(lstname)
      IF (fh:=Open(lstname,NEWFILE))
         Write(fh,LSIDENT,LSIDENTL)
         Write(fh,lstname,sprintf(lstname,'\d\n',{listpos}))
         lst:=modlst.head
         WHILE lst.ln.succ
             Write(fh,lst.path,StrLen(lst.path))
             Out(fh,10)
             lst:=lst::ln.succ
         ENDWHILE
         Close(fh)
      ENDIF
      AstrCopy(savelsdir,rtfmsg.req.dir,NAMESIZE-1)
   ENDIF
ENDIF
#ifdef OFFGADGETS
gtOnGadget(savemlgad,modlistwnd)
#endif
ENDPROC


PROC loadlist(namelist,node_addr)
DEF fh,size,buf[20]:ARRAY,tmp,poslist=0,proc,str[112]:ARRAY,x
IF fh:=Open(namelist,OLDFILE)
   IF Read(fh,buf,LSIDENTL)=LSIDENTL
      proc:=`AstrCopy(str,tmp,x:=Abs(InStr(tmp,'\n'))+1)
      IF StrCmp(buf,LSIDENT,LSIDENTL)
         Read(fh,buf,20)
         poslist:=Val(buf)
         x:=LSIDENTL+InStr(buf,'\n')+1
      ELSE
         x:=8
         IF StrCmp(buf,'HIPPRO',6)
            proc:=`(x:=Int(tmp)) BUT (tmp:=tmp+2) BUT
                   AstrCopy(str,tmp,x+1)
         ELSE
            IF StrCmp(buf,'HiPPrg\n\n',8)=FALSE THEN proc:=NIL
         ENDIF
      ENDIF
      IF proc
         Seek(fh,0,OFFSET_END)
         size:=Seek(fh,x,OFFSET_BEGINING)-x
         freeNode(modlst.tailpred)
         IF numnodepos>0 THEN poslist:=listpos
         IF (buf:=AllocVect(size,MEMF_ANY))
            IF Read(fh,buf,size)=size
               tmp:=buf
               updatelist(-1)
               WHILE (buf+size)>tmp
                  gEval(proc)
                  tmp:=tmp+x
                  addNode(str,NIL,FALSE)
               ENDWHILE
               updatelist(modlst)
               toplist()
               listpos:=poslist
               ^node_addr:=currentNode()
            ENDIF
            FreeVect(buf)
         ENDIF
      ENDIF
   ENDIF
   Close(fh)
ENDIF
ENDPROC



PROC toplist()
IF modlistwnd
   Gt_SetGadgetAttrsA(listgad,modlistwnd,NIL,
     [GTLV_SELECTED,listpos,IF libver(gadtoolsbase,38) THEN
     GTLV_MAKEVISIBLE ELSE GTLV_TOP,listpos,TAG_DONE])
ENDIF
ENDPROC


PROC currentNode()
 DEF node=NIL:PTR TO ln,x
 IF numnodepos>0
    node:=modlst.head
    FOR x:=1 TO listpos DO node:=node.succ
 ENDIF
ENDPROC node




PROC makeNode(fpath)
DEF node=NIL:PTR TO mynode,nm
IF node:=AllocVect(SIZEOF mynode,MEMF_CLEAR)
   IF nm:=AllocVect(NAMESIZE,MEMF_ANY)
      AstrCopy(nm,fpath,ALL)
      node.path:=nm
      node::ln.name:=dFilePart(nm)
      IF backward=FALSE
         AddTail(modlst,node)
      ELSE
         AddHead(modlst,node)
      ENDIF
      INC numnodepos
   ELSE
      FreeVect(nm)
   ENDIF
ENDIF
ENDPROC node



PROC addNodeF(path,name,show=TRUE)
DEF buff[NAMESIZE]:REG ARRAY
AstrCopy(buff,path,ALL)
dAddPart(buff,name,NAMESIZE-2)
IF show THEN updatelist(-1)
makeNode(buff)
IF show THEN updatelist(modlst)
setupLoopPlay()
#ifdef OFFGADGETS
 IF numnodepos THEN gtOnGadget(savemlgad,modlistwnd)
#endif
ENDPROC




PROC addNode(path,name,show=TRUE)
DEF buff[NAMESIZE]:REG ARRAY
#ifdef GEC
stacknode:=FindTask(0)::tc.splower
#endif
#ifndef GEC
DEF tc:REG PTR TO tc
tc:=FindTask(0)
stacknode:=tc.splower
#endif
AstrCopy(buff,path,ALL)
IF name THEN dAddPart(buff,name,NAMESIZE-2)
getNodePath(buff,show)
setupLoopPlay()
#ifdef OFFGADGETS
 IF numnodepos THEN gtOnGadget(savemlgad,modlistwnd)
#endif
ENDPROC


PROC freestacknode()
     MOVE.L A7,D0
     SUB.L  stacknode,D0
ENDPROC D0


PROC getNodePath(name,show)
DEF buf[NAMESIZE]:ARRAY,lock,fib:fileinfoblock,len
IF freestacknode() > 1500
   len:=StrLen(name)
   AstrCopy(buf,name,NAMESIZE)
   IF (lock:=Lock(buf,SHARED_LOCK))
      IF show THEN updatelist(-1)
      Examine(lock,fib)
      IF fib.direntrytype>0
         WHILE ExNext(lock,fib)
               buf[len]:=0
               IF dAddPart(buf,fib.filename,NAMESIZE-2)
                  IF fib.direntrytype<0
                     makeNode(buf)
                  ELSEIF fib.direntrytype>0
                     getNodePath(buf,show)
                  ENDIF
               ENDIF
         ENDWHILE
      ELSEIF fib.direntrytype<0
         makeNode(buf)
      ENDIF
      IF show THEN updatelist(modlst)
      UnLock(lock)
      toplist()
   ENDIF
ENDIF
ENDPROC



PROC freeNode(node:PTR TO mynode,show=TRUE)
IF node
   IF show THEN updatelist(-1)
   DEC numnodepos
   Remove(node)
   FreeVect(node.path)
   FreeVect(node)
   IF show THEN updatelist(modlst)
   IF numnodepos>0
      IF (listpos+1)>numnodepos THEN listpos:=numnodepos-1
   ENDIF
   setupLoopPlay()
ENDIF
ENDPROC


PROC openmodlisterwin() HANDLE
  #ifdef GEC
  DEF table:REG PTR TO LONG,x:REG,y:REG,g:REG,tabgad[6]:REG ARRAY OF LONG
  #endif
  #ifndef GEC
  DEF table:PTR TO LONG,x,y,g,tabgad[6]:ARRAY OF LONG
  #endif
  ObtainSemaphore(winsem)
  IF modlistwnd=NIL
     NEW modlgt
     IF x:=modlgt.new(NIL,IF fontval=FONT_DISK THEN fontreq.attr ELSE NIL,50)
        RETURN convertErr(x)
     ENDIF
     table:=[8,33,'_Add',REL(add_Clicked),
             42,60,'_Remove',REL(rem_Clicked),
             103,31,'_Up',REL(up_Clicked),
             135,41,'_Down',REL(down_Clicked),
             177,48,'_Clear',REL(clear_Clicked),
             226,40,'S_ort',REL(sort_Clicked),
             267,40,'_Save',REL(savelst_Clicked)]
     y:=0
     FOR x:=0 TO 7-1
        IF (g:=modlgt.gadget(BUTTON_KIND,table[y++],89,table[y++],14,
           table[y++],PLACETEXT_IN,table[y++],{underTags}))=NIL
           Raise(ERROR_GADGET)
        ENDIF
        tabgad[x]:=g
     ENDFOR
     addgad:=tabgad[]
     savemlgad:=tabgad[6]
     IF (listgad:=modlgt.gadget(LISTVIEW_KIND,8,3,300,85,NIL,NIL,
         {lister_Clicked},[GTLV_LABELS,modlst,GTLV_SHOWSELECTED,NIL,
         GTLV_SELECTED,listpos,TAG_END]))=NIL
         Raise(ERROR_GADGET)
     ENDIF
     IF (modlistwnd:=modlgt.openWin(listerleft,listertop,316,106,
         IDCMP_REFRESHWINDOW OR IDCMP_CLOSEWINDOW OR IDCMP_VANILLAKEY OR
         BUTTONIDCMP OR LISTVIEWIDCMP OR SCROLLERIDCMP OR IDCMP_RAWKEY,
         WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
         WFLG_SMART_REFRESH OR WFLG_RMBTRAP,'GrioPlay ModsList',
         winport,NIL,LOCKPUBSCR,scrname))=NIL THEN Raise(ERROR_WINDOW)
     modlistwnd.userdata:=[REL(closemodlisterwin),REL(modlister_Keys),
                                          0,REL(modlister_RawKeys)]
     toplist()
     listappwin:=IF workbenchbase THEN
             AddAppWindowA(APPIDLIST,NIL,modlistwnd,ptport,NIL) ELSE NIL
     oldsec:=oldmic:=NIL
     #ifdef OFFGADGETS
     IF rtf.isopen(RTF_ADD)>0 THEN gtOffGadget(addgad,modlistwnd)
     IF (rtf.isopen(RTF_SAVELIST)>0) OR (numnodepos=0)
        gtOffGadget(savemlgad,modlistwnd)
     ENDIF
     #endif
  ENDIF
  ReleaseSemaphore(winsem)
  reSetMenu(2)
EXCEPT
  END modlgt
  ReleaseSemaphore(winsem)
  RETURN exception
ENDPROC NIL

PROC closemodlisterwin()
  ObtainSemaphore(winsem)
  IF modlistwnd
    IF listappwin THEN RemoveAppWindow(listappwin)
    listerleft:=modlistwnd.leftedge
    listertop:=modlistwnd.topedge
  ENDIF
  END modlgt
  modlistwnd:=listappwin:=NIL
  reSetMenu(2)
  ReleaseSemaphore(winsem)
ENDPROC


#ifdef OFFGADGETS
PROC isFirstNode()
IF listpos=0
   RETURN TRUE
ENDIF
ENDPROC FALSE

PROC isFirstSong()
IF module
   IF modtype=PSID
      IF psidNumberSongs(module)>1
         IF psidCurrentSong()>1 THEN RETURN FALSE
      ENDIF
   ELSEIF modtype=AHXABYSS
      IF ahxNumberSongs()>1
         IF ahxCurrentSong()>1 THEN RETURN FALSE
      ENDIF
   ENDIF
ENDIF
ENDPROC TRUE


PROC isLastNode()
IF numnodepos
   IF listpos=(numnodepos-1)
      RETURN TRUE
   ENDIF
ELSE
   RETURN TRUE
ENDIF
ENDPROC FALSE


PROC isLastSong()
DEF i
IF module
   IF modtype=PSID
      IF (i:=psidNumberSongs(module))>1
         IF psidCurrentSong()<i THEN RETURN FALSE
      ENDIF
   ELSEIF modtype=AHXABYSS
      IF (i:=ahxNumberSongs())>1
         IF ahxCurrentSong()<i THEN RETURN FALSE
      ENDIF
   ENDIF
ENDIF
ENDPROC TRUE


PROC setNextPrev()
IF isLastNode()
   IF (nextgad.flags AND GFLG_DISABLED)=NIL THEN gtOffGadget(nextgad,mainwnd)
ELSE
   IF (nextgad.flags AND GFLG_DISABLED) THEN gtOnGadget(nextgad,mainwnd)
ENDIF
IF isFirstNode()
   IF (prevgad.flags AND GFLG_DISABLED)=NIL THEN gtOffGadget(prevgad,mainwnd)
ELSE
   IF (prevgad.flags AND GFLG_DISABLED) THEN gtOnGadget(prevgad,mainwnd)
ENDIF
ENDPROC D0


PROC setNextPrevSong()
IF isLastSong()
   IF (nextsg.flags AND GFLG_DISABLED)=NIL THEN gtOffGadget(nextsg,mainwnd)
ELSE
   IF (nextsg.flags AND GFLG_DISABLED) THEN gtOnGadget(nextsg,mainwnd)
ENDIF
IF isFirstSong()
   IF (prevsg.flags AND GFLG_DISABLED)=NIL THEN gtOffGadget(prevsg,mainwnd)
ELSE
   IF (prevsg.flags AND GFLG_DISABLED) THEN gtOnGadget(prevsg,mainwnd)
ENDIF
ENDPROC D0


#endif



underTags:
  LONG GT_UNDERSCORE,"_",TAG_DONE

PROC convertErr(i)
IF i
   SELECT i
      CASE GTERR_GTLIB;   i:=ERROR_GT
      CASE GTERR_VISUAL;  i:=ERROR_VISUAL
      CASE GTERR_CONTEXT; i:=ERROR_CONTEXT
      CASE GTERR_SCR;     i:=ERROR_SCRN
   ENDSELECT
ENDIF
ENDPROC i


PROC openmainwindow() HANDLE
  #ifdef GEC
  DEF table:REG PTR TO LONG,x:REG,g:REG PTR TO gadget,y:REG,
      tabgad[17]:REG ARRAY OF LONG
  #endif
  #ifndef GEC
  DEF table:PTR TO LONG,x,g:PTR TO gadget,y,tabgad[17]:ARRAY OF LONG
  #endif
  IF mainwnd THEN RETURN NIL
  NEW maingt
  IF x:=maingt.new(NIL,IF fontval=FONT_DISK THEN fontreq.attr ELSE NIL)
     RETURN convertErr(x)
  ENDIF
  screen:=maingt.screen
  CopyMem(maingt.tattr,textattr,SIZEOF textattr)
  table:=[8,3,39,14,'_Load',REL(load_Clicked),
          94,3,39,14,'_Stop',REL(stop_Clicked),
          134,3,45,14,'_Eject',REL(eject_Clicked),
          180,3,15,14,'_H',REL(hide_Clicked),
          8,18,31,14,'_Rew',REL(rew_Clicked),
          40,18,31,14,'_Fwd',REL(fwd_Clicked),
          72,18,39,14,'_Info',REL(info_Clicked),
          112,18,25,14,'_ML',REL(modlist_Clicked),
          138,18,38,14,'_Disp',REL(disp_Clicked),
          177,18,34,14,'_Cfg',REL(conf_Clicked),
          126,33,31,14,'Pr_v',REL(prev_Clicked),
          158,33,31,14,'_Nxt',REL(next_Clicked),
          48,3,45,14,'_Play',REL(play_Clicked),
          48,3,45,14,'_Pause',REL(play_Clicked),
          196,3,15,14,'S',REL(save_Clicked),
          190,33,10,14,'<',REL(prevsong_Clicked),
          201,33,10,14,'>',REL(nextsong_Clicked)]
  y:=0
  FOR x:=0 TO 17-1
     IF (g:=maingt.gadget(BUTTON_KIND,table[y++],table[y++],table[y++],
        table[y++],table[y++],PLACETEXT_IN,table[y++],{underTags}))=NIL
        Raise(ERROR_GADGET)
     ENDIF
     tabgad[x]:=g
  ENDFOR
  loadgad:=tabgad[0]
  playgad:=tabgad[12]
  pausegad:=tabgad[13]
  nextgad:=tabgad[11]
  prevgad:=tabgad[10]
  savegad:=tabgad[14]
  prevsg:=tabgad[15]
  nextsg:=tabgad[16]
  IF (volgad:=maingt.gadget(SLIDER_KIND,66,34,58,12,'Vol:00',PLACETEXT_LEFT,
     {volume_Clicked},[GA_RELVERIFY,1,GTSL_MAX,64,GTSL_LEVEL,0,
     GTSL_LEVELFORMAT,'\r\z\d[2]',GTSL_MAXLEVELLEN,2,TAG_END]))=NIL THEN Raise(ERROR_GADGET)
  IF (mainwnd:=maingt.openWin(mainleft,maintop,219,49,IDCMP_VANILLAKEY OR
      IDCMP_CLOSEWINDOW OR IDCMP_REFRESHWINDOW OR BUTTONIDCMP OR SLIDERIDCMP OR
      IDCMP_RAWKEY OR (IF menu THEN IDCMP_MENUPICK ELSE IDCMP_MOUSEBUTTONS),
      WFLG_DRAGBAR OR (IF menu=0 THEN WFLG_RMBTRAP ELSE NIL) OR
      WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR
      WFLG_ACTIVATE,'GrioPlay Main',winport,
      [WA_ZOOM,[IF libver(intuitionbase,39) THEN -1 ELSE mainleft,
      IF libver(intuitionbase,39) THEN -1 ELSE maintop+maingt.offy,
      maingt.calcXX(219)+screen.wborright,maingt.offy]:INT,TAG_DONE],
      LOCKPUBSCR))=NIL THEN Raise(ERROR_WINDOW)
  #ifndef HIGH
  mainsize:=mainwnd.height-maingt.offy
  #endif
  RemoveGadget(mainwnd,g:=IF playgadactiv THEN pausegad ELSE playgad)
  mainwnd.userdata:=[REL(main_CloseWindow),REL(main_VanillaKey),
                     REL(main_MouseButtons),REL(main_RawKeys)]
  maingt.refreshGads(g,1)
  mainappwin:=IF workbenchbase THEN
         AddAppWindowA(APPIDMAIN,NIL,mainwnd,ptport,NIL) ELSE NIL
  stdTitle()
  mainMenu()
  #ifdef OFFGADGETS
  IF modtype=PSID THEN gtOffGadget(volgad,mainwnd)
  setNextPrev()  ;  setNextPrevSong()
  IF module=NIL THEN gtOffGadget(savegad,mainwnd)
  #endif
  fadeVol(volume)
EXCEPT
  END maingt
  RETURN exception
ENDPROC ERROR_NONE


PROC mainMenu() IS
maingt.setMenu(IF menu THEN [
                NM_TITLE,0,'Project',0,0,0,0,
                  NM_ITEM,0,'Load','l',0,0,REL(load_Clicked),
                  NM_ITEM,0,'Add','a',0,0,REL(add_Clicked),
                  NM_ITEM,0,'Save List',NIL,0,0,REL(savelst_Clicked),
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Play/Pause','p',0,0,REL(play_Clicked),
                  NM_ITEM,0,'Stop','s',0,0,REL(stop_Clicked),
                  NM_ITEM,0,'Save Module',NIL,0,0,REL(save_Clicked),
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'About',NIL,0,0,`thread.launch(TH_ABOUT),
                  NM_ITEM,0,'Hide','h',0,0,REL(hide_Clicked),
                  NM_ITEM,0,NM_BARLABEL,0,0,0,0,
                  NM_ITEM,0,'Quit','q',0,0,REL(main_CloseWindow),
                  NM_ITEM,0,'Quick Quit',NIL,0,0,REL(quitProg),
                NM_TITLE,0,'Windows',0,0,0,0,
                  NM_ITEM,0,'Info','i',menuWin(infownd),0,REL(info_Clicked),
                  NM_ITEM,0,'Display','d',menuWin(dispwnd),0,REL(disp_Clicked),
                  NM_ITEM,0,'List','m',menuWin(modlistwnd),0,REL(modlist_Clicked),
                  NM_ITEM,0,'Config','c',menuWin(confwnd),0,REL(conf_Clicked),
                NM_END,0,NIL,0,0,0,0]:newmenu ELSE NIL)

PROC menuWin(win) IS
 IF win THEN CHECKIT OR CHECKED ELSE CHECKIT

PROC reSetMenu(itemnum)
DEF item:PTR TO menuitem,wintab:PTR TO LONG
wintab:=[infownd,dispwnd,modlistwnd,confwnd]
IF mainwnd
   IF menu
      ClearMenuStrip(mainwnd)
      IF (item:=ItemAddress(maingt.menu,SHIFTMENU(1) OR SHIFTITEM(itemnum)))
         IF wintab[itemnum]
            item.flags:=item.flags OR CHECKED
         ELSE
            item.flags:=Eor(item.flags,(item.flags AND CHECKED))
         ENDIF
      ENDIF
      ResetMenuStrip(mainwnd,maingt.menu)
   ENDIF
ENDIF
ENDPROC


ptPlayWin:
  CHAR  'GrioPlay ',VERS,0


PROC stdTitle()
 IF module=NIL
    AstrCopy(scrname,{ptPlayScr},ALL)
 ENDIF
 IF mainwnd THEN SetWindowTitles(mainwnd,-1,scrname)
ENDPROC


PROC swapGads()
 DEF g
 IF mainwnd
    RemoveGadget(mainwnd,IF playgadactiv THEN playgad ELSE pausegad)
    AddGadget(mainwnd,g:=IF playgadactiv THEN pausegad ELSE playgad,-1)
    maingt.refreshGads(g,1)
 ENDIF
 playgadactiv:=Not(playgadactiv)
ENDPROC




PROC closemainwindow()
  IF mainwnd
    IF mainappwin THEN RemoveAppWindow(mainappwin)
    AddGadget(mainwnd,IF playgadactiv THEN pausegad ELSE playgad,-1)
    mainleft:=mainwnd.leftedge
    maintop:=mainwnd.topedge
    mainwnd:=NIL
  ENDIF
  END maingt
ENDPROC


PROC openconfwindow() HANDLE
  #ifdef GEC
  DEF x:REG,tb:REG PTR TO LONG,g:REG,tg[12]:ARRAY OF LONG
  #endif
  #ifndef GEC
  DEF x,tb:PTR TO LONG,g,tg[12]:ARRAY OF LONG
  #endif
  IF confwnd THEN RETURN NIL
  NEW confgt
  IF x:=confgt.new(NIL,IF fontval=FONT_DISK THEN fontreq.attr ELSE NIL,100)
     RETURN convertErr(x)
  ENDIF
  tb:=[
      CYCLE_KIND,8,3,124,NIL,PLACETEXT_RIGHT,REL(looping_Clicked),[GTCY_LABELS,
           ['Loop List','Loop Module','List Once','Module Once',NIL],
                                                    GTCY_ACTIVE,loop,TAG_END],
      CHECKBOX_KIND,140,18,26,'FadeVol',PLACETEXT_RIGHT,REL(fadeVol_Clicked),
           [GTCB_CHECKED,fade,IF libver(gadtoolsbase,39) THEN GTCB_SCALED ELSE NIL,
                                                 TRUE,TAG_END],
      BUTTON_KIND,140,3,98,'ModulesPath',PLACETEXT_IN,REL(modsPath_Clicked),TAG_END,
      BUTTON_KIND,198,80,42,'Save',PLACETEXT_IN,REL(savecfg_Clicked),TAG_END,
      BUTTON_KIND,8,80,62,'TimeOut',PLACETEXT_IN,REL(timeout_Clicked),TAG_END,
      CYCLE_KIND,8,48,72,'VMeter',PLACETEXT_RIGHT,REL(volMeter_Clicked),[GTCY_LABELS,
           ['None','Fake','Real','Funny',NIL],GTCY_ACTIVE,volmet,TAG_DONE],
      CHECKBOX_KIND,140,48,26,'BackList',PLACETEXT_RIGHT,REL(backplay_Clicked),
           [GTCB_CHECKED,backward,IF libver(gadtoolsbase,39) THEN GTCB_SCALED ELSE NIL,
                                                 TRUE,TAG_END],
      STRING_KIND,8,18,74,'LhA',PLACETEXT_RIGHT,REL(lhacmd_Clicked),
           [GTST_STRING,lhacmd,GTST_MAXCHARS,80,TAG_DONE],
      STRING_KIND,8,33,54,'TempPath',PLACETEXT_RIGHT,REL(lhatemp_Clicked),
           [GTST_STRING,lhatemp,GTST_MAXCHARS,80,TAG_DONE],
      CYCLE_KIND,8,64,80,'Font',PLACETEXT_RIGHT,REL(font_Clicked),[GTCY_LABELS,
           ['Screen','Disk',NIL],GTCY_ACTIVE,fontval,TAG_DONE],
      CHECKBOX_KIND,140,63,26,'Menu',PLACETEXT_RIGHT,REL(menu_Clicked),
           [GTCB_CHECKED,menu,IF libver(gadtoolsbase,39) THEN GTCB_SCALED ELSE NIL,
                                                 TRUE,TAG_END],
      CHECKBOX_KIND,140,33,26,'ErrMsg',PLACETEXT_RIGHT,REL(error_Clicked),
           [GTCB_CHECKED,errmsg,IF libver(gadtoolsbase,39) THEN GTCB_SCALED ELSE NIL,
                                                 TRUE,TAG_END]
      ]

  FOR x:=0 TO 12-1
    IF (g:=confgt.gadget(^tb++,^tb++,^tb++,^tb++,14,^tb++,^tb++,^tb++,^tb++))=NIL
        Raise(ERROR_GADGET)
    ENDIF
    tg[x]:=g
  ENDFOR
  mpathgad:=tg[2]   ;  vmgad:=tg[5]
  strcmd:=tg[7]     ;  strtemp:=tg[8]
  fontgad:=tg[9]    ;  menugad:=tg[10]

  IF (confwnd:=confgt.openWin(confleft,conftop,246,97,BUTTONIDCMP OR
     MXIDCMP OR IDCMP_CLOSEWINDOW,WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
     WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR WFLG_RMBTRAP,
     'GrioPlay Config',winport,NIL,LOCKPUBSCR,scrname))=NIL THEN Raise(ERROR_WINDOW)
  confwnd.userdata:=[REL(closeconfwindow),0,0,0]
  #ifdef OFFGADGETS
  IF rtf.isopen(RTF_MODS)>0
     gtOffGadget(mpathgad,confwnd)
  ENDIF
  #endif
  reSetMenu(3)
EXCEPT
  END confgt
  RETURN exception
ENDPROC NIL

PROC menu_Clicked()
menu:=isGadChecked(menugad)
ObtainSemaphore(winsem)
IF mainwnd
   closemainwindow()
   reporterr(openmainwindow())
ENDIF
ReleaseSemaphore(winsem)
ENDPROC


PROC backplay_Clicked()
    backward:=IF code THEN TRUE ELSE FALSE
ENDPROC


PROC looping_Clicked()
 loop:=code
 setupLoopPlay()
ENDPROC


PROC setupLoopPlay()
DEF x
 x:=(loop=LOOPMOD) OR ((loop=LOOPLIST) AND (1=numnodepos))
 breaknorm:=62
 breakfade:=32
 SELECT modtype
     CASE PROTRACKER
         ptLoopPlay(x)
     CASE DIGIBOOSTER
         digiLoopPlay(x)
     CASE AHXABYSS
         ahxLoopPlay(x)
         breaknorm:=ahxGetTrackLen()-2
         breakfade:=breaknorm-6
         IF breakfade<0 THEN breakfade:=0
 ENDSELECT
ENDPROC D0



PROC fadeVol_Clicked() IS
 fade:=IF fade THEN FALSE ELSE TRUE

PROC modsPath_Clicked()
#ifndef OFFGADGETS
rtf.open(RTF_MODS,'GrioPlay Mods Path',getrtftags(RTFT_MODS))
#endif
#ifdef OFFGADGETS
IF rtf.open(RTF_MODS,'GrioPlay Mods Path',getrtftags(RTFT_MODS))
   gtOffGadget(mpathgad,confwnd)
ENDIF
#endif
ENDPROC

PROC storemodsdir(rtfmsg:PTR TO rtfilermsg)
IF rtfmsg.result
  AstrCopy(modsdir,rtfmsg.req.dir,108)
ENDIF
#ifdef OFFGADGETS
gtOnGadget(mpathgad,confwnd)
#endif
ENDPROC

PROC volMeter_Clicked()
DEF oldvm
oldvm:=volmet
volmet:=code
IF (volmet=NO_VOLMETER) OR (oldvm=NO_VOLMETER)
   IF dispwnd
      closedispwindow()
      opendispwindow()
   ENDIF
ENDIF
IF (volmet=REAL_VOLMETER)
   FOR oldvm:=0 TO 3 DO vm.last[oldvm]:=0
ENDIF
ENDPROC

PROC lhacmd_Clicked()
 AstrCopy(lhacmd,strcmd.specialinfo::stringinfo.buffer,81)
 setupLHA(lhatemp,lhacmd)
ENDPROC


PROC lhatemp_Clicked()
 AstrCopy(lhatemp,strtemp.specialinfo::stringinfo.buffer,81)
 setupLHA(lhatemp,lhacmd)
ENDPROC


PROC setFontScreen()
IF confwnd
   fontval:=FONT_SCREEN
   Gt_SetGadgetAttrsA(fontgad,confwnd,NIL,
      [GTCY_ACTIVE,FONT_SCREEN,TAG_DONE])
ENDIF
ENDPROC


PROC font_Clicked()
IF (IDCMP_GADGETUP AND type)
   fontval:=code
   IF fontval=FONT_DISK
      IF RtFontRequestA(fontreq,'Select font',
               [RT_SCREEN,screen,
                RT_TEXTATTR,maingt.tattr,
                ->RTFO_FLAGS,FREQF_FIXEDWIDTH,
                TAG_DONE])
      ELSE
         RETURN setFontScreen()
      ENDIF
   ENDIF
   closemainwindow()
   IF reporterr(openmainwindow())<>ERROR_NONE
      setFontScreen()
      IF reporterr(openmainwindow())
         RETURN quitProg()
      ENDIF
   ENDIF
   IF dispwnd
      disp_Clicked()
      disp_Clicked()
   ENDIF
   IF modlistwnd
      closemodlisterwin()
      modlist_Clicked()
   ENDIF
   IF infownd
      closeinfowindow()
      info_Clicked()
   ENDIF
   conf_Clicked()
   conf_Clicked()
ENDIF
ENDPROC



PROC savecfg_Clicked()
DEF fh,conf:config
IF easyReq('Save config ?','_Yes|_No')
   IF (fh:=Open('S:GrioPlay.cfg',NEWFILE))
      clrstrcpy(conf,GRIOPLAY,10)
      conf.mainleft:=mainwnd.leftedge
      conf.maintop:=mainwnd.topedge
      clrstrcpy(conf.dirname,modsdir,NAMESIZE)
      conf.loop:=loop
      conf.fade:=fade
      conf.volume:=volume
      IF modlistwnd
         conf.listleft:=modlistwnd.leftedge
         conf.listtop:=modlistwnd.topedge
      ELSE
         conf.listleft:=listerleft
         conf.listtop:=listertop
      ENDIF
      conf.confleft:=confwnd.leftedge
      conf.conftop:=confwnd.topedge
      IF dispwnd
          conf.posleft:=dispwnd.leftedge
          conf.postop:=dispwnd.topedge
      ELSE
          conf.posleft:=posleft
          conf.postop:=postop
      ENDIF
      IF infownd
         conf.infoleft:=infownd.leftedge
         conf.infotop:=infownd.topedge
      ELSE
         conf.infoleft:=infoleft
         conf.infotop:=infotop
      ENDIF
      conf.dispopen:=dispwnd
      conf.volmet:=volmet
      conf.error:=errmsg
      clrstrcpy(conf.lhacmd,lhacmd,82)
      clrstrcpy(conf.lhatemp,lhatemp,82)
      conf.fontval:=fontval
      clrstrcpy(conf.fontname,fontreq.attr.name,32)
      conf.fontY:=fontreq.attr.ysize
      conf.fontflags:=fontreq.attr.flags
      conf.fontstyle:=fontreq.attr.style
      conf.infoopen:=infownd
      conf.mlstopen:=modlistwnd
      conf.backward:=backward
      conf.timetype:=timetype
      conf.timedelay:=timedelay
      conf.menu:=menu
      Write(fh,conf,SIZEOF config)
      Close(fh)
   ENDIF
ENDIF
ENDPROC


PROC errorMessage(text,gads,args=NIL) IS
     IF errmsg THEN easyReq(text,gads,args) ELSE NIL


PROC error_Clicked()
 errmsg:=IF errmsg THEN FALSE ELSE TRUE
ENDPROC


PROC timeout_Clicked() HANDLE
DEF x
IF timegt=NIL
   NEW timegt
   IF x:=timegt.new(NIL,IF fontval=FONT_DISK THEN fontreq.attr ELSE NIL,100)
      RETURN convertErr(x)
   ENDIF
   IF timegt.gadget(CYCLE_KIND,48,4,124,14,'Type',PLACETEXT_LEFT,
      {timetype_Clicked},[GTCY_LABELS,['None','NotEnding','All',NIL],
      GTCY_ACTIVE,timetype,TAG_END])=NIL THEN Raise(ERROR_GADGET)
   timegad:=timegt.gadget(SLIDER_KIND,42,34,130,10,'Delay in seconds',PLACETEXT_ABOVE,
      {delay_Clicked},[GA_RELVERIFY,1,GTSL_MAX,MAXTIMEDELAY,GTSL_LEVEL,timedelay,
     GTSL_LEVELFORMAT,'\r\z\d[3]',GTSL_MAXLEVELLEN,3,TAG_END])
   IF timegad=NIL THEN Raise(ERROR_GADGET)
   IF (timewnd:=timegt.openWin(confwnd.leftedge,confwnd.topedge+confwnd.height,
      180,46,BUTTONIDCMP OR IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY,WFLG_DRAGBAR OR
      WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR
      WFLG_ACTIVATE OR WFLG_RMBTRAP,'GrioPlay TimeOut',winport,NIL,LOCKPUBSCR,scrname)
      )=NIL THEN Raise(ERROR_WINDOW)
  timewnd.userdata:=[REL(closetimewin),0,0,REL(timeout_RawKeys)]
ELSE
   Raise()
ENDIF
EXCEPT
   closetimewin()
   RETURN exception
ENDPROC NIL

PROC closetimewin()
   IF timewnd
      timewnd:=0
   ENDIF
   END timegt
ENDPROC



PROC timetype_Clicked()
 timetype:=code
ENDPROC


PROC delay_Clicked()
 timedelay:=code
 IF modtype=PSID THEN songlen:=code
ENDPROC


PROC timeout_RawKeys()
DEF raw
raw:=code
SELECT raw
    CASE KEY_LEFT
        DEC timedelay
        IF timedelay<0
           timedelay:=0
        ELSE
           Gt_SetGadgetAttrsA(timegad,timewnd,NIL,[GTSL_LEVEL,timedelay,TAG_DONE])
        ENDIF
    CASE KEY_RIGHT
        INC timedelay
        IF timedelay>MAXTIMEDELAY
           timedelay:=MAXTIMEDELAY
        ELSE
           Gt_SetGadgetAttrsA(timegad,timewnd,NIL,[GTSL_LEVEL,timedelay,TAG_DONE])
        ENDIF
ENDSELECT
ENDPROC


PROC closeconfwindow()
  ObtainSemaphore(winsem)
  closetimewin()
  IF confwnd
    confleft:=confwnd.leftedge
    conftop:=confwnd.topedge
  ENDIF
  END confgt
  confwnd:=NIL
  reSetMenu(3)
  ReleaseSemaphore(winsem)
ENDPROC



PROC multiprocess()
DEF win:PTR TO window,func:PTR TO LONG,item:PTR TO menuitem
WHILE running
  win:=multiwait4message()
  IF (type=IDCMP_GADGETUP)
     gEval(infos.userdata)
  ELSE
     IF win
        IF (func:=win.userdata)
           SELECT type
               CASE IDCMP_CLOSEWINDOW
                   gEval(func[0])
               CASE IDCMP_VANILLAKEY
                   gEval(func[1])
               CASE IDCMP_MOUSEBUTTONS
                   gEval(func[2])
               CASE IDCMP_RAWKEY
                   gEval(func[3])
               CASE IDCMP_MENUPICK
                   infos:=code AND $FFFF
                   WHILE infos<>MENUNULL
                      item:=ItemAddress(win.menustrip,infos)
                      gEval(GTMENUITEM_USERDATA(item))
                   EXIT running=FALSE
                      infos:=item.nextselect AND $FFFF
                   ENDWHILE
           ENDSELECT
        ENDIF
     ENDIF
  ENDIF
ENDWHILE
ENDPROC

PROC multiwait4message()
DEF win:PTR TO window,mes=NIL:PTR TO intuimessage,winsig
win:=type:=NIL
winsig:=Shl(1,winport.sigbit)
REPEAT
  IF (mainwnd<>NIL) OR (appwin<>NIL) THEN mes:=Gt_GetIMsg(winport)
  IF mes
     win:=mes.idcmpwindow
     type:=mes.class
     qual:=mes.qualifier
     code:=mes.code
     IF (type AND (IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEMOVE))
        infos:=mes.iaddress
        type:=IF (id:=infos.gadgetid) THEN IDCMP_GADGETUP ELSE NIL
     ELSEIF (type = IDCMP_REFRESHWINDOW)
          Gt_BeginRefresh(win)
          Gt_EndRefresh(win,TRUE)
          type:=NIL
     ENDIF
     Gt_ReplyIMsg(mes)
  ELSE
     waitSig(winsig)
  ENDIF
UNTIL type
ENDPROC win


MODULE 'grio/namefromlock'


PROC waitSig(winsig)
DEF msg:PTR TO mymsg,sig,ptsig,mtype,appid,appstay,listback,id
DEF nssig,ignappicon=FALSE,rtfsig,rtfmsg:PTR TO rtfilermsg
ptsig:=Shl(1,ptport.sigbit)
nssig:=Shl(1,nsport.sigbit)
rtfsig:=Shl(1,rtfport.sigbit)
REPEAT
  sig:=Wait(SIGBREAKF_CTRL_C OR SIGBREAKF_CTRL_D OR winsig OR ptsig OR nssig OR rtfsig OR cx.signal)
  IF ptsig AND sig
     IF (msg:=GetMsg(ptport))
        listback:=listpos
        listpos:=numnodepos
        mtype:=msg.type
        SELECT mtype
             CASE APPWINDOW
                  appid:=getappmsg(msg)
             CASE APPICON
                  appid,appstay:=getappmsg(msg)
                  IF appstay=NIL
                     listpos:=listback
                     appid:=NIL
                     openHided()
                  ENDIF
             CASE SHELLARG
                  addFromArg(msg.name,msg.dir)
                  FreeVect(msg)
                  appid:=APPIDMAIN
        ENDSELECT
        IF (appid=APPIDMAIN)
           IF listpos<numnodepos THEN playCurrentNodeShow()
        ENDIF
     ENDIF
     sig:=NIL
  ELSEIF sig AND SIGBREAKF_CTRL_C
     main_CloseWindow()
     type:=SIGBREAKF_CTRL_C
  ELSEIF sig AND SIGBREAKF_CTRL_D
     openHided()
  ELSEIF sig AND nssig
     IF (msg:=GetMsg(nsport))
        mtype:=msg::scrnotifymsg.status
        ReplyMsg(msg)
        IF (mainwnd<>NIL) OR ignappicon
           SELECT mtype
                 CASE SCRNOTIFY_STATUS_WBCLOSE
                      hide_Clicked()
                      ignappicon:=TRUE
                 CASE SCRNOTIFY_STATUS_WBOPEN
                      Delay(100)
                      openHided()
                      ignappicon:=FALSE
                 CASE SCRNOTIFY_STATUS_CLOSED
                 DEFAULT
                      hide_Clicked()
                      Delay(350)
                      openHided()
           ENDSELECT
        ENDIF
     ENDIF
     sig:=NIL
  ELSEIF sig AND rtfsig
     IF (rtfmsg:=GetMsg(rtfport))
        gEval(rtfmsg.userdata,[rtfmsg])
        rtf.freemsg(rtfmsg)
     ENDIF
  ELSEIF sig AND cx.signal
     cx.handlemsg()
     id:=cx.msgid
     IF cx.msgtype=CXM_COMMAND
        SELECT id
            CASE CXCMD_DISABLE
                stop_Clicked()
            CASE CXCMD_ENABLE
                play_Clicked()
            CASE CXCMD_KILL
                main_CloseWindow()
                type:=SIGBREAKF_CTRL_C
            CASE CXCMD_APPEAR
                openwins()
            CASE CXCMD_DISAPPEAR
                closewins()
        ENDSELECT
     ENDIF
  ENDIF
UNTIL sig 
ENDPROC


PROC openHided()
IF appicon
   IF tt[TT_APPICON]=NIL
       RemoveAppIcon(appicon)
       appicon:=NIL
   ENDIF
   openwins()
ENDIF
ENDPROC

PROC getappmsg(msg:PTR TO appmessage)
 DEF numarg,wbarg:PTR TO wbarg,appid=APPIDMAIN,dirname[NAMESIZE]:ARRAY
 appid:=msg.id
 wbarg:=msg.arglist
 IF (numarg:=msg.numargs)  ->>1
    REPEAT
        nameFromLock(wbarg.lock,dirname,NAMESIZE)
        IF wbarg.name[]
           addNode(dirname,wbarg.name,TRUE)
        ELSE
           addNode(dirname,NIL,TRUE)
        ENDIF
        wbarg++
        DEC numarg
    UNTIL numarg=0
    numarg:=msg.numargs
 /*
 ELSE
    IF (numarg:=msg.numargs)=1
       IF (wbarg.name[]=0)
          nameFromLock(wbarg.lock,dirname,NAMESIZE)
          SELECT appid
               CASE APPIDMAIN
                    load_Clicked()
               CASE APPIDLIST
                    add_Clicked()
          ENDSELECT
       ENDIF
    ENDIF
 */
 ENDIF
 ReplyMsg(msg)
ENDPROC appid,numarg



PROC volMeters()
DEF value,channel,ppos,nt,realchan,subproc
ObtainSemaphore(winsem)
IF dispwnd
   IF (NO_VOLMETER<>volmet)
      SELECT modtype
          CASE PROTRACKER
               subproc:=`(value:=ptGetVolume(realchan)) BUT
                         (ppos:=ptGetPattPos()) BUT
                         (nt:=ptGetNote(realchan)) BUT
                         (IF (nt=0) AND (volmet=REAL_VOLMETER) THEN
                                 nt:=ptGetCmd(realchan) ELSE NIL)
          CASE DIGIBOOSTER
               subproc:=`(value:=digiGetVolume(realchan)) BUT
                         (ppos:=digiGetPattPos()) BUT
                         (nt:=digiGetNote(realchan)) BUT
                         (IF (nt=0) AND (volmet=REAL_VOLMETER) THEN
                                 nt:=digiGetCmd(realchan) ELSE NIL)
          CASE AHXABYSS
               subproc:=`(value:=ahxGetVolume(realchan)) BUT
                         (ppos:=ahxGetPattPos()) BUT
                         (nt:=ahxGetNote(realchan)) BUT
                         (IF (nt=0) AND (volmet=REAL_VOLMETER) THEN
                                 nt:=ahxGetCmd(realchan) ELSE NIL)
          CASE PSID
               subproc:=`(value:=psidGetVolume(realchan)) BUT
                         (ppos:=psidGetSecond())
          DEFAULT
               subproc:=`(value:=nt:=0)
      ENDSELECT
      FOR channel:=0 TO 3
          IF module
             realchan:=channel+1
             gEval(subproc)
          ELSE
             ppos:=value:=nt:=0
          ENDIF
          IF 64<value THEN value:=64
          IF ((vm.note[channel]<>ppos) AND nt ) OR (vm.last[channel]<>value)
             vm.pos[channel]:=0
             fillMeter(channel,value,FALSE)
             vm.note[channel]:=ppos
             vm.last[channel]:=value
          ELSE
             IF (volmet <> REAL_VOLMETER)  AND (vm.pos[channel] < 64)
                IF (vm.pos[channel]>=0)
                   vm.pos[channel]:=vm.pos[channel]+2
                   value:=value-vm.pos[channel]
                   IF value < 0 THEN value:=0
                   fillMeter(channel,value,TRUE)
                   IF value=0 THEN vm.pos[channel]:=-1
                ENDIF
            /*
             ELSE
                IF nt=0 THEN fillMeter(channel,0,FALSE)
             */
             ENDIF
          ENDIF
      ENDFOR
   ENDIF
ENDIF
ReleaseSemaphore(winsem)
ENDPROC


PROC fillMeter(xx,val,fake)
 DEF chan,xv,x1,x2,x3,x4
 chan:=vm.chan[xx]
 xv:=dispgt.calcX(val+(val*2/3))
 IF (volmet=FUNNY_VOLMETER) AND ((xx=1) OR (xx=2))
    x1:=vm.xfull-xv ; x2:=vm.xfull
    x3:=0 ;  x4:=x1
 ELSE
    x1:=0 ;  x2:=xv
    x3:=xv ; x4:=vm.xfull
 ENDIF
 IF val>0
    IF fake=FALSE
       RectFill(dispwnd.rport,vm.ofx+x1,chan,x2+vm.ofx,vm.x4+chan)
    ENDIF
 ENDIF
 SetAPen(dispwnd.rport,0)
 RectFill(dispwnd.rport,vm.ofx+x3,chan,x4+vm.ofx,vm.x4+chan)
 SetAPen(dispwnd.rport,1)
ENDPROC



PROC updateText()
DEF pos,patt
 IF audio
    SELECT modtype
        CASE PROTRACKER
           pos:=ptGetSongPos()
           patt:=ptGetPattPos()
        CASE DIGIBOOSTER
           pos:=digiGetSongPos()
           patt:=digiGetPattPos()
        CASE AHXABYSS
           pos:=ahxGetSongPos()
           patt:=ahxGetPattPos()
        CASE PSID
           pos:=psidGetMinute()
           patt:=psidGetSecond()
    ENDSELECT
 ELSE
    pos:=patt:=NIL
 ENDIF
 ObtainSemaphore(winsem)
 IF dispwnd
    IF (oldpos<>pos) OR (oldpatt<>patt)
       dispText(9,13,'\r\z\d[2]/\r\z\d[3]/\r\z\d[3]',[patt,pos,songlen])
    ENDIF
    IF (oldsubsong<>subsong)
       dispText(100,13,'\r\z\d[2]/\r\z\d[2]',[subsong,numsubsongs])
       oldsubsong:=subsong
    ENDIF
    IF (oldtmin<>tmin) OR (oldtsec<>tsec)
       dispText(149,13,'\z\d[2]:\z\d[2]',[tmin,tsec])
       oldtsec:=tsec
       oldtmin:=tmin
    ELSE
       IF quadr=12
          SetAPen(dispwnd.rport,0)
          RectFill(dispwnd.rport,dispgt.calcXX(165),dispgt.calcYY(7),
              dispgt.calcXX(169),dispgt.calcYY(14))
       ENDIF
    ENDIF
 ENDIF
 ReleaseSemaphore(winsem)
ENDPROC pos,patt


PROC dispText(x,y,fmt,argdata=NIL)
DEF s[200]:ARRAY,char[2]:ARRAY,l,i,a,b,xs,rast:PTR TO rastport
a:=dispgt.calcXX(x)
b:=dispgt.calcYY(y)
l:=sprintf(s,fmt,argdata)
rast:=dispwnd.rport
WaitTOF()
IF (dispgt.font.flags AND FPF_PROPORTIONAL)<>FPF_PROPORTIONAL
   SetAPen(rast,1)
   Move(rast,a,b)
   RETURN Text(rast,s,l)
ENDIF
char[1]:=0
xs:=dispgt.font.xsize
SetAPen(rast,0)
RectFill(rast,a,b-dispgt.font.ysize,a+(xs*l),b)
SetAPen(rast,1)
DEC l
FOR i:=0 TO l
  char[0]:=s[i]
  Move(rast,a+((xs-dispgt.calcText(char))/2),b)
  Text(rast,char,1)
  a:=a+xs
ENDFOR
ENDPROC D0



PROC slaveWork()
DEF pos,patt,action,x
Wait(SIGBREAKF_CTRL_E)
ObtainSemaphore(winsem)
IF dispwnd
   IF (NO_VOLMETER<>volmet)
      INC olposx
      INC olposy
      ScrollRaster(dispwnd.rport,olsupx,olsupy,
                   dispgt.calcXX(132),dispgt.calcYY(23),
                   dispgt.calcXX(186),dispgt.calcYY(45))
      IF dispgt.calcX(23)=olposx
         olsupx:=-olsupx
         olposx:=0
      ENDIF
      IF dispgt.calcY(16)=olposy
         olsupy:=-olsupy
         olposy:=0
      ENDIF
    ENDIF
ENDIF
ReleaseSemaphore(winsem)
action:=FALSE
IF audio OR skiped
   IF skiped
      action:=TRUE
   ELSE
      ->ObtainSemaphore(audiosem)
      pos,patt:=updateText()
      ->ReleaseSemaphore(audiosem)
      volMeters()
      SELECT modtype
          CASE PROTRACKER
              action:=ptIsEnabled()
          CASE DIGIBOOSTER
              action:=digiIsEnabled()
          CASE AHXABYSS
              action:=ahxIsEnabled()
          CASE PSID
              action:=psidIsEnabled()
          DEFAULT
              action:=FALSE
      ENDSELECT
      IF action
         SELECT modtype
             CASE PROTRACKER
                 action:=ptIsLooped()
             CASE DIGIBOOSTER
                 action:=digiIsLooped()
             CASE AHXABYSS
                 action:=ahxIsLooped()
             DEFAULT
                 action:=TRUE
         ENDSELECT
         ->ObtainSemaphore(audiosem)
         IF thread.islaunched(TH_READMOD) THEN action:=TRUE
         IF action=FALSE
            IF songlen=(pos+1)
               action:=IF fade THEN patt>breakfade ELSE patt>breaknorm
            ELSE
               action:=pos<oldpos
            ENDIF
         ELSE
            action:=FALSE
         ENDIF
         ->ReleaseSemaphore(audiosem)
         oldpos:=pos
         oldpatt:=patt
      ENDIF
   ENDIF
   IF action=FALSE
      IF timetype<>TIMETYPE_NONE    ->was IF timedelay
         IF loop<>LOOPMOD
            IF timedelay<=((tmin*60)+tsec)
               /* the same like in IF kewords */
               ->action:=((timetype=TIMETYPE_NOTENDING) AND
               ->      (modtype=PSID)) OR (timetype=TIMETYPE_ALL)
               IF timetype=TIMETYPE_NOTENDING
                  IF modtype=PSID THEN action:=TRUE
               ELSE
                  action:=TRUE
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF action
      IF (thread.islaunched(TH_READMOD))=FALSE
         IF audio OR skiped
            SELECT loop
                CASE ONCEMOD
                    action:=FALSE
                CASE LOOPMOD
                    action:=FALSE
                CASE ONCELIST
                    IF backward
                       IF listpos=0 THEN action:=FALSE
                    ELSE
                       IF listpos=(numnodepos-1) THEN action:=FALSE
                    ENDIF
                CASE LOOPLIST
                    IF backward
                       IF listpos=0
                          IF skiped THEN action:=FALSE
                       ENDIF
                    ELSE
                       IF listpos=(numnodepos-1)
                          IF skiped THEN action:=FALSE
                       ENDIF
                    ENDIF
            ENDSELECT
            ->ObtainSemaphore(audiosem)
            IF action AND ((thread.islaunched(TH_READMOD))=FALSE)
               IF backward
                  action:=IF (x:=prevsong_Clicked())=FALSE THEN prev_Clicked() ELSE x
               ELSE
                  action:=IF (x:=nextsong_Clicked())=FALSE THEN next_Clicked() ELSE x
               ENDIF
            ELSE
               action:=thread.launch(TH_READMOD,NIL)
            ENDIF
            ->ReleaseSemaphore(audiosem)
            ->IF (action=TRUE) AND (x=FALSE)
            ->   WHILE (thread.islaunched(TH_READMOD))=FALSE DO Delay(2)  -> Wait for start readthread
            ->                                                      -> IF is reached :-) ( x variable)
            ->ENDIF
         ENDIF
      ENDIF
   ENDIF
ENDIF
ENDPROC




PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
     IF er="MEM" THEN er:=ERROR_NOMEM
     erlist:=['get context',
             'create gadget',
             'lock/open screen',
             'get visual infos',
             'open "gadtools.library"',
             'open window',
             'create port',
             'open "reqtools.library"',
             'allocate requester',
             'start audio',
             'initialize "timer.device"',
             'start thread',
             'allocate memory']
     easyReq('Could not \s!','_Ok',[erlist[er-1]])
  ENDIF
ENDPROC er


PROC easyReq(text,gads,args=NIL)
 DEF r=NIL
 IF ereq
    r:=RtEZRequestA(text,gads,ereq,args,
                [RT_UNDERSCORE,"_",RT_SCREEN,screen,
                RT_TEXTATTR,textattr,
                RTEZ_REQTITLE,REL(ptPlayWin),
                RTEZ_FLAGS,EZREQF_NORETURNKEY OR
                EZREQF_CENTERTEXT,TAG_DONE])
 ELSE
    PutFmt(text,^args)
    PutFmt('\n')
 ENDIF
ENDPROC r



PROC addfromfreq(rtfmsg:PTR TO rtfilermsg)
 DEF filelist:PTR TO rtfilelist
 filelist:=rtfmsg.result
 IF filelist
    AstrCopy(rtfmsg.file,filelist.name,ALL)
    updatelist(-1)
    REPEAT
       IF filelist.strlen=-1
          addNode(rtfmsg.req.dir,filelist.name,FALSE)
       ELSE
          addNodeF(rtfmsg.req.dir,filelist.name,FALSE)
       ENDIF
       filelist:=filelist.next
    UNTIL (filelist=NIL)
    updatelist(modlst)
    IF oldnumnode=0 THEN toplist()
 ENDIF
 #ifdef OFFGADGETS
 gtOnGadget(addgad,modlistwnd)
 setNextPrev()
 #endif
ENDPROC rtfmsg.result



PROC loadfromfreq(rtfmsg:PTR TO rtfilermsg)
 DEF filelist:PTR TO rtfilelist
 filelist:=rtfmsg.result
 IF filelist
    AstrCopy(rtfmsg.file,filelist.name,ALL)
    clear_Clicked()
    updatelist(-1)
    REPEAT
       IF filelist.strlen=-1
          addNode(rtfmsg.req.dir,filelist.name,FALSE)
       ELSE
          addNodeF(rtfmsg.req.dir,filelist.name,FALSE)
       ENDIF
       filelist:=filelist.next
    UNTIL (filelist=NIL)
    updatelist(modlst)
    IF oldnumnode=0 THEN toplist()
    playCurrentNodeShow()
    IF rtf.isopen(RTF_ADD)=0
       newDir(RTF_ADD,rtfmsg.req.dir)
    ENDIF
 ENDIF
 #ifdef OFFGADGETS
 gtOnGadget(loadgad,mainwnd)
 setNextPrev()
 #endif
ENDPROC rtfmsg.result





PROC updatelist(pos)
 IF modlistwnd
    Gt_SetGadgetAttrsA(listgad,modlistwnd,NIL,
                   [GTLV_LABELS,pos,TAG_DONE])
 ENDIF
ENDPROC





PROC readNotPacked(filename,modaddr,sizeaddr)
DEF fh,size=0,buf=0

IF (fh:=Open(filename,OLDFILE))
   Seek(fh,0,OFFSET_END)
   size:=Seek(fh,0,OFFSET_BEGINING)
   IF (buf:=AllocMem(size,MEMF_ANY))
      IF Read(fh,buf,size)<>size
         FreeMem(buf,size)
         buf:=size:=0
      ENDIF
   ELSE
      size:=0
   ENDIF
   Close(fh)
ENDIF
^modaddr:=buf
^sizeaddr:=size
ENDPROC




PROC audioStart()
DEF x=FALSE,y,mem
audioEnd()
ObtainSemaphore(audiosem)
IF modtype=PSID THEN x:=TRUE
IF module
   IF x=FALSE
      IF (aport:=createPort(NIL,0))
         IF (ioa:=createExtIO(aport,SIZEOF ioaudio))
            ioa.data:=[1,2,4,8]:CHAR
            ioa.length:=4
            ioa.allockey:=0
            ioa::ln.pri:=127
            ioa::io.command:=ADCMD_ALLOCATE
            IF OpenDevice('audio.device',NIL,ioa,NIL)=NIL
               x:=opendev:=TRUE
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF x
      SELECT modtype
          CASE PROTRACKER
             IF TypeOfMem(module)<>MEMF_CHIP
                IF (mem:=AllocMem(memlen,MEMF_CHIP))
                    CopyMem(module,mem,memlen)
                    FreeMem(module,memlen)
                    module:=mem
                ENDIF
             ENDIF
             x:=ptPlay(module)
          CASE DIGIBOOSTER
             x:=digiPlay(module)
          CASE AHXABYSS
             x:=ahxPlay(module)
          CASE PSID
             x,y:=psidPlay(module,modlen)
             IF y=PSIDERR_NOLIB
                errorMessage('can\at open playsid.library','_Ok')
             ENDIF
          DEFAULT
             x:=NIL
      ENDSELECT
      IF x
         tsec:=tmin:=NIL
         audio:=TRUE
         numsubsongs:=subsong:=1
         SELECT modtype
             CASE PROTRACKER
                 songlen:=ptGetSongLen()
             CASE DIGIBOOSTER
                 songlen:=digiGetSongLen()
             CASE AHXABYSS
                 songlen:=ahxGetSongLen()
                 numsubsongs:=ahxNumberSongs()
             CASE PSID
                 songlen:=timedelay
                 subsong:=psidCurrentSong()
                 numsubsongs:=psidNumberSongs(module)
         ENDSELECT
         pause:=quadr:=NIL
         IF playgadactiv THEN swapGads()
         IF cx THEN cx.activate(TRUE)
         IF modtype<>PSID
            FOR x:=0 TO volume
                IF fade=FALSE THEN x:=volume
                fadeVol(x)
            ENDFOR
         ELSE
            fadeVol(64)
            #ifdef OFFGADGETS
            gtOffGadget(volgad,mainwnd)
            #endif
         ENDIF
      ENDIF
   ENDIF   
   IF audio=FALSE
      audioEnd()
      reporterr(ERROR_AUDIO)
   #ifdef OFFGADGETS
   ELSE
      gtOnGadget(savegad,mainwnd)
   #endif
   ENDIF
   #ifdef OFFGADGETS
   setNextPrev()
   setNextPrevSong()
   #endif
ENDIF
ReleaseSemaphore(audiosem)
ENDPROC audio


PROC audioEnd()
DEF x
IF audio
   SELECT modtype
       CASE PROTRACKER
           x:=ptIsEnabled()
       CASE DIGIBOOSTER
           x:=digiIsEnabled()
       CASE AHXABYSS
           x:=ahxIsEnabled()
       DEFAULT
           x:=FALSE
   ENDSELECT
   IF x
      FOR x:=volume TO 0 STEP -1
          IF fade=FALSE THEN x:=0
          fadeVol(x)
      ENDFOR
   ENDIF
   SELECT modtype
       CASE PROTRACKER
           ptStop()
       CASE DIGIBOOSTER
           digiStop()
       CASE AHXABYSS
           ahxStop()
       CASE PSID
           psidStop()
           #ifdef OFFGADGETS
           gtOnGadget(volgad,mainwnd)
           #endif
   ENDSELECT
   audio:=FALSE
   IF cx THEN cx.activate(FALSE)
   IF playgadactiv=FALSE THEN swapGads()
   volMeters()
   updateText()
   oldpos:=oldpatt:=0
ENDIF
IF opendev
   CloseDevice(ioa)
   opendev:=NIL
ENDIF
IF ioa
   deleteExtIO(ioa)
   ioa:=NIL
ENDIF
IF aport
   deletePort(aport)
   aport:=NIL
ENDIF
ENDPROC


PROC readModule(modname)
DEF modfile[NAMESIZE]:STRING
ejectMod(modname)
IF modname=NIL THEN RETURN
StrCopy(modfile,modname,ALL)
skiped:=checkselect(modfile)=NIL
IF module
   ObtainSemaphore(winsem)
   showModTitle()
   showSamples()
   ReleaseSemaphore(winsem)
   IF modtitle[]
      StrCopy(modfile,ListItem(['mod.','digi.','Ahx.','PSID.'],modtype-1))
      StrAdd(modfile,modtitle)
   ELSE
      StrCopy(modfile,dFilePart(modname))
   ENDIF
   AstrCopy(rtffile[RTFT_SAVE].file,modfile,108)
ENDIF
ENDPROC




PROC checkselect(modfile)
DEF check,func,x,line[40]:ARRAY,smp[40]:ARRAY,smp2
check:=recognize(modfile)
SELECT check
   CASE POWERPACKER
      IF ppbase
         func:=`PpLoadData(modfile,DECR_NONE,MEMF_ANY,
             {module},{memlen},-1) BUT (modlen:=memlen) BUT TRUE
      ELSE
         func:=`errorMessage('I need powerpacker.library\n'+
               'for powerpacked module .','_Ok') BUT FALSE
      ENDIF
   CASE XPKMASTER
      IF xpkbase
         func:=`XpkUnpack([XPK_INNAME,modfile,
                           XPK_GETOUTBUF,{module},
                           XPK_GETOUTBUFLEN,{memlen},
                           XPK_GETOUTLEN,{modlen},
                           XPK_OUTMEMTYPE,MEMF_ANY,
                           TAG_DONE]) BUT TRUE
      ELSE
         func:=`errorMessage('I need xpkmaster.library\n'+
               'for xpkpacked module .','_Ok') BUT FALSE
      ENDIF
   CASE ARCHLHA
        func:=`lhafunc(modfile)
  CASE NOTPACKED
        func:=`readNotPacked(modfile,{module},{memlen}) BUT
             (modlen:=memlen) BUT TRUE
   DEFAULT
      func:=`FALSE
ENDSELECT
IF check<>NOMOD
   check:=gEval(func)
   IF (NOMOD<>check) AND (ARCHLHA<>check)
      IF module
         IF checkPT(dFilePart(modfile))=FALSE
            ejectMod()
            showSamples()
            showModTitle()
            check:=NIL
         ELSE
            sprintf(scrname,'\s: \s',[REL(ptPlayWin),dFilePart(modfile)])        -> was file
            IF mainwnd THEN SetWindowTitles(mainwnd,-1,scrname)
            SetStr(samp,0)
            SetList(smpl,0)
            FOR x:=1 TO 31
                SELECT modtype
                    CASE PROTRACKER
                        smp2:=ptGetSampleInfo(module,smp,x)
                    CASE DIGIBOOSTER
                        smp2:=digiGetSampleInfo(module,smp,x)
                    CASE AHXABYSS
                        smp2:=-1
                        ahxGetSampleInfo(module,smp,x)
                    CASE PSID
                        smp2:=-1
                        psidGetModInfo(module,smp,x)
                ENDSELECT
                sprintf(line,'\l\s[30]',{smp})
                StrAdd(samp,line,ALL)
                IF smp2>=0 THEN ListAdd(smpl,[smp2])
            ENDFOR
            IF modtype<>UNKNOWNTYPE THEN bingbong()
            audioStart()
            setupLoopPlay()
         ENDIF
      ELSE
         check:=NIL
         errorMessage('Module loading problem!','_Ok')
      ENDIF
   ENDIF
ENDIF
ENDPROC check


PROC lhafunc(modfile)
DEF x,y,check
IF unArchLHA(modfile)
   FOR x:=0 TO 100
       IF (y:=getNameLHA(modfile,x))<0
          check:=recognize(modfile)
          IF (check<>NOMOD) AND (check<>ARCHLHA)
             checkselect(modfile)
             IF module THEN x:=100
          ENDIF
       ELSE
          IF y=0 THEN x:=100
       ENDIF
  ENDFOR
  clearTempLHA()
ENDIF
ENDPROC (check:=ARCHLHA)


PROC recognize(modname)
DEF check[8]:ARRAY,fh,return=NOTPACKED
IF (fh:=Open(modname,OLDFILE))
   Read(fh,check,8)
   IF ^check="PP20"
      return:=POWERPACKER
   ELSE
      IF ^check="XPKF"
         return:=XPKMASTER
      ELSE
         IF (Long(check+2) AND $ffffff00)="-lh\0"
            return:=ARCHLHA
         ENDIF
      ENDIF
   ENDIF
   Close(fh)
ELSE
   errorMessage('Can\at open module "\s"!','_Ok',{modname})
   return:=NOMOD
ENDIF
ENDPROC return


PROC checkPT(namemod)
DEF valpt,ret=TRUE,valx
modtype:=PROTRACKER
valx:=Long(module)
IF Shr(valx,8)<>"THX"
   IF valx="PSID"
      modtype:=PSID
   ELSE
      IF modlen>1100
         valpt:=Long(module+1080)
         IF valpt<>"M.K."
            IF valpt<>"M!K!"
               IF valpt<>"FLT4"
                  IF valx<>"DIGI"
                     ret:=(errorMessage('Can\at recognize "\s"\n'+
                         'Play it with protracker routine ?',
                         '_Yes|_No',{namemod})<>0)
                     IF ret=FALSE THEN modtype:=UNKNOWNTYPE
                  ELSE
                     modtype:=DIGIBOOSTER
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ELSE
         modtype:=UNKNOWNTYPE
         ret:=FALSE
      ENDIF
   ENDIF
ELSE
   modtype:=AHXABYSS
ENDIF
ENDPROC ret


PROC fadeVol(v)
 SELECT modtype
     CASE PROTRACKER
        ptSetVolume(v)
     CASE DIGIBOOSTER
        digiSetVolume(v)
     CASE AHXABYSS
        ahxSetVolume(v)
 ENDSELECT
 IF mainwnd THEN
    Gt_SetGadgetAttrsA(volgad,mainwnd,NIL,[GTSL_LEVEL,v,TAG_DONE])
 Delay(1)
ENDPROC



PROC activateconfig()
DEF fh,conf:config,size
AstrCopy(lhacmd,'C:LhA e',ALL)
AstrCopy(lhatemp,'RAM:',ALL)
IF (fh:=Open('S:GrioPlay.cfg',OLDFILE))
   size:=Read(fh,conf,SIZEOF config)
   Close(fh)
   IF StrCmp(conf,GRIOPLAY,ALL)=FALSE
      easyReq('Bad config file','_Ok')
   ELSE
      AstrCopy(modsdir,conf.dirname,ALL)
      newDir(RTF_LOAD,modsdir)
      newDir(RTF_ADD,modsdir)
      newDir(RTF_MODS,modsdir)
      newDir(RTF_SAVE,modsdir)
      newDir(RTF_SAVELIST,'RAM:')
      loop:=Min(loop,conf.loop)
      fade:=conf.fade
      mainleft:=conf.mainleft
      maintop:=conf.maintop
      volume:=Min(volume,conf.volume)
      listerleft:=conf.listleft
      listertop:=conf.listtop
      confleft:=conf.confleft
      conftop:=conf.conftop
      posleft:=conf.posleft
      postop:=conf.postop
      infoleft:=conf.infoleft
      infotop:=conf.infotop
      awins[AW_DISP]:=conf.dispopen
      volmet:=conf.volmet
      errmsg:=conf.error
      fontval:=conf.fontval
      awins[AW_INFO]:=conf.infoopen
      awins[AW_LIST]:=conf.mlstopen
      backward:=conf.backward
      RtChangeReqAttrA(fontreq,[RTFO_FONTNAME,conf.fontname,
                                RTFO_FONTFLAGS,conf.fontflags,
                                RTFO_FONTHEIGHT,conf.fontY,
                                RTFO_FONTSTYLE,conf.fontstyle,
                                TAG_DONE])
      AstrCopy(lhacmd,conf.lhacmd,81)
      AstrCopy(lhatemp,conf.lhatemp,81)
      timetype:=conf.timetype
      timedelay:=conf.timedelay
      menu:=conf.menu
   ENDIF
ENDIF
setupLHA(lhatemp,lhacmd)
ENDPROC



PROC newDir(reqnum,name)
DEF freq:PTR TO rtfilerequester
IF (freq:=rtf.getreq(reqnum))
   IF StrCmp(freq.dir,name,ALL)=FALSE
      rtf.change(reqnum,[RTFI_DIR,name,TAG_DONE])
   ENDIF
ENDIF
ENDPROC



PROC info2Samp()
DEF buf[30]:ARRAY,x
SetStr(samp,0)
SetList(smpl,0)
FOR x:=0 TO 31-1
    sprintf(buf,'\l\s[30]',[IF x=<5 THEN
                            ListItem(['Pro(Noise)Tracker,AHX,PSID,',
                                      'DIGIBooster module player.',
                                      GPVER,
                                      'Copyright ',
                                      'ogrio@o2.pl'],x) ELSE ''])
    StrAdd(samp,buf)
ENDFOR
ENDPROC


PROC setuplibs()
  DEF cmn,x,rtftitle:PTR TO LONG,user:PTR TO LONG,wbs:PTR TO wbstartup
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))=NIL THEN
                                                  RETURN ERROR_RT
  ereq:=RtAllocRequestA(RT_REQINFO,NIL)
  fontreq:=RtAllocRequestA(RT_FONTREQ,NIL)
  NEW rtf.new(rtfport)
  rtftitle:=['Load module(s)','Add Module(s)','Modules path','Save modules list','Save module']
  user:=[REL(loadfromfreq),REL(addfromfreq),REL(storemodsdir),REL(savemodlist),REL(savemod)]
  FOR x:=0 TO RTFT_NUM-1
     EXIT rtf.add(ListItem(rtftitle,x),rtffile[x].file,user[x])=FALSE
     rtffile[x].file[]:=0
  ENDFOR
  IF (ereq=NIL) OR (fontreq=NIL) OR (x<RTFT_NUM) THEN RETURN ERROR_REQ
  ppbase:=OpenLibrary('powerpacker.library',34)
  xpkbase:=OpenLibrary('xpkmaster.library',2)
  IF (workbenchbase:=OpenLibrary('workbench.library',36))
     IF (iconbase:=OpenLibrary('icon.library',36))
        cmn:=Long({cmdname})
        IF cmn=0
           IF (wbs:=wbmessage)
              x:=IF wbs.arglist.lock THEN CurrentDir(wbs.arglist.lock) ELSE NIL
              dob:=GetDiskObjectNew(wbs.arglist.name)
              IF x THEN CurrentDir(x)
           ENDIF
        ELSE
           dob:=GetDiskObjectNew(cmn)
        ENDIF
       IF dob=NIL THEN dob:=GetDefDiskObject(WBTOOL)
     ENDIF
  ENDIF
  InitSemaphore(audiosem)
  InitSemaphore(winsem)
  NEW ns
  IF ns.new()
     nsid:=ns.notify(nsport,10)
  ELSE
     nsid:=NIL
  ENDIF
  wbtask:=FindTask('Workbench')
  FOR x:=0 TO TT_TABSIZE-1 DO tt[x]:=NIL
  IF dob
     dob.currentx:=NO_ICON_POSITION
     dob.currenty:=NO_ICON_POSITION
     FOR x:=0 TO TT_TABSIZE-1
        tt[x]:=getToolType(dob,
               ListItem(['APPICON','HIDE'],x))
     ENDFOR
  ENDIF
  IF tt[TT_APPICON] THEN addAppIcon()
  info2Samp()
  NEW cx
  IF cx.new()=CXERROR_NONE
     IF cx.install('GrioPlay',GRIOPLAY+' '+VERS,'Multitask module player',TRUE)
        END cx
     ENDIF
  ENDIF
ENDPROC


PROC closedownlibs()
  END cx
  IF nsid THEN ns.remnotify()
  END ns
  IF xpkbase THEN CloseLibrary(xpkbase)
  IF ppbase THEN CloseLibrary(ppbase)
  IF ereq THEN RtFreeRequest(ereq)
  IF fontreq THEN RtFreeRequest(fontreq)
  END rtf
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
  IF workbenchbase
     CloseLibrary(workbenchbase)
     IF iconbase
        IF dob
           IF appicon THEN RemoveAppIcon(appicon)
           FreeDiskObject(dob)
        ENDIF
        CloseLibrary(iconbase)
     ENDIF
  ENDIF
ENDPROC




MODULE 'grio/skiparg'


PROC addFromArg(arg1,argdir)
 DEF arg2
 WHILE (arg2:=skiparg(arg1))>0
    IF (dFilePart(arg1)=arg1) AND (argdir<>NIL)
       addNode(argdir,arg1)
    ELSE
       addNode(arg1,NIL)
    ENDIF
    arg1:=arg2
 ENDWHILE
 FreeVect(argdir)
ENDPROC




PROC intCode()
 DEF r:REG
 Signal(slavetask,SIGBREAKF_CTRL_E)
 SELECT modtype
    CASE PROTRACKER
       r:=ptIsEnabled()
    CASE DIGIBOOSTER
       r:=digiIsEnabled()
    CASE AHXABYSS
       r:=ahxIsEnabled()
    CASE PSID
       r:=psidIsEnabled()
    DEFAULT
       r:=FALSE
 ENDSELECT
 IF r
    INC quadr
    IF (quadr = 25)
       quadr:=0
       INC tsec
       IF (tsec = 60)
          tsec:=0
          INC tmin
          IF (tmin = 100) THEN tmin:=0
       ENDIF
    ENDIF
 ENDIF
ENDPROC




PROC starter()
 DEF port,msg:PTR TO mymsg,cdir,cmdn=0
 stdout:=NIL
 IF ("?"=arg[])
     PutFmt('USAGE: <module ...>\n')
     port:=1
 ELSE
     Forbid()
     IF port:=FindPort(GRIOPLAY)
        IF arg[]
           IF msg:=AllocVect(SIZEOF mymsg,MEMF_CLEAR OR MEMF_PUBLIC)
              msg::ln.type:=NT_MESSAGE
              msg.type:=SHELLARG
              msg.dir:=getdirname()
              AstrCopy(msg.name,arg,ALL)
              PutMsg(port,msg)
           ENDIF
        ENDIF
     ENDIF
     Permit()
 ENDIF
 IF port
    CleanUp()
 ELSE
    IF wbmessage=NIL
       cdir:=getdirname()
       IF cmdn:=AllocVect(NAMESIZE,MEMF_ANY)
          AstrCopy(cmdn,maintask::ln.name,NAMESIZE-1)
          IF StriCmp(cmdn,GRIOPLAY)=FALSE
             AstrCopy(cmdn,cdir,NAMESIZE)
             dAddPart(cmdn,GRIOPLAY,NAMESIZE-2)
          ENDIF
       ENDIF
       IF  arg[] THEN PutLong({currentDirStore},cdir)
       PutLong({cmdname},cmdn)
       #ifdef DETATCH
       detatch(GRIOPLAY)
       #endif
    ENDIF
 ENDIF
ENDPROC


currentDirStore:
  LONG 0

cmdname:
  LONG  0


PROC getdirname()
DEF dirname,cd
IF dirname:=AllocVect(NAMESIZE,MEMF_PUBLIC)
   cd:=CurrentDir(NIL)
   nameFromLock(cd,dirname,NAMESIZE-2)
   CurrentDir(cd)
ENDIF
ENDPROC dirname


#ifndef GEC
MODULE 'grio/fakestack'
#endif

MODULE 'amigalib/lists'


PROC makePort(name,pri)
 IF createPort(name,pri)=NIL
    Raise(ERROR_PORT)
 ENDIF
ENDPROC D0



PROC main() HANDLE
  #ifndef GEC
  DEF err,stc
  maintask:=FindTask(NIL)
  #endif
  #ifdef GEC
  DEF err:REG
  maintask:=thistask
  #endif
  starter()
  #ifndef GEC
  stc:=fakestack()
  #endif
  winport:=makePort(NIL,0)
  ptport:=makePort(GRIOPLAY,0)
  nsport:=makePort(NIL,20)
  rtfport:=makePort(NIL,5)
  IF (err:=setuplibs())<>ERROR_NONE THEN Raise(err)
  activateconfig()
  newList(modlst)
  IF tt[TT_HIDE]=NIL
     IF openwins()=NIL THEN Raise()
  ENDIF
  NEW thread
  IF (thread.init({slaveWork},'GrioPlay Slave',0,8192))=NIL
     Raise(ERROR_THREAD)
  ENDIF
  IF (thread.init({readModule},'GrioPlay Reader',0,8192))=NIL
     Raise(ERROR_THREAD)
  ENDIF
  IF (thread.init({about},'GrioPlay About',0,4096))=NIL
     Raise(ERROR_THREAD)
  ENDIF
  NEW tm
  IF tm.init({intCode},UNIT_MICROHZ,16)=NIL THEN Raise(ERROR_TIMER)
  tm.setinterval(40000,0)
  IF (thread.launch(TH_SLAVE,NIL,TRUE))=FALSE THEN Raise(ERROR_THREAD)
  slavetask:=thread.task(TH_SLAVE)
  tm.start()
  IF arg[]
     addFromArg(arg,Long({currentDirStore}))
     playCurrentNodeShow()
  ENDIF
  multiprocess()
EXCEPT DO
  END thread,tm
  reporterr(exception)
  closewins()
  closedownlibs()
  deletePort(winport)
  deletePort(ptport)
  deletePort(nsport)
  deletePort(rtfport)
  #ifndef GEC
  fakestack(stc)
  #endif
  FreeVect(Long({cmdname}))
ENDPROC

 CHAR '$VER: '
ptPlayScr:
 CHAR 'GrioPlay v',VERS,' ',DATE,' Grio!',0



