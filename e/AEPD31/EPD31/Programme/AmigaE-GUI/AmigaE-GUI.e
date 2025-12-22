/*************************************************************************

:Programm.      AmigaE-GUI.e
:Beschreibung.  Benutzeroberfläche für AmigaE

:Autor.         Friedhelm Bunk
:EC-Version.     EC3.1    
:OS.            > 2.0 
:PRG-Version.   2.0b

Benötigt Gattolsbox.library >= Version 33
#


*************************************************************************/


OPT OSVERSION=37

MODULE 'gadtools','libraries/gadtools','intuition/intuition','amigaguide',
       'libraries/amigaguide','intuition/screens', 'intuition/gadgetclass',
       'graphics/text','dos/datetime','utility/date','dos/dos','Asl',
       'libraries/Asl','dos/dostags','workbench/startup','gtx','icon',
       'workbench/workbench','intuition/icclass','intuition/imageclass',
       'other/testcpu'


OBJECT makes
s             
ENDOBJECT

ENUM NONE,NOCONTEXT,NOGADGET,NOWB,NOVISUAL,OPENGT,NOWINDOW,NOMENUS,OPENASL,
     OPENIC,OPENGUIDE,OPENGTX,NOFILEI,NOBUFFER
DEF	wnd:PTR TO window,wnd1:PTR TO window,scr:PTR TO screen,mymess,
	project0glist,project1glist,starts[255]:STRING,mysys[120]:STRING,
	zeiger[10]:ARRAY OF LONG,visual=NIL,getfilei,zu,myrast,mysave,
	bn[24]:ARRAY OF makes,ioi[255]:STRING,menu,mytime,myrexx,
        y,type,infos,offx,offy,tattr,fh,mpx,altstd,mycon,auszahl


PROC main()
FOR y:=0 TO 25
  bn[y].s:=String(250) 
ENDFOR  
VOID '$VER:AmigaE-GUI © F.Bunk  V2.0b  (28.05.1995)' 
  mpx:=1
  lade()
  mpx:=1
zu:=TRUE
systeminfo()
StringF(mysys,'\s         \s\nKickstart \d.\d    Workbench \d.\d',mycpu,myfpu,myver,myrev,mywbv,mywbr)
StringF(bn[23].s,'AmigaE-GUI V 2.0b BETA 0  (28.05.1995 )\n © F.Bunk 1995\n Uses GadtoolBox.library\n\s',mysys)
IF reporterr(setupscreen())=0
   reporterr(openproject0window())
   SetTopaz(8)   
   Colour(1,0)
   mytime:=1
   mydate()
   mytime:=Val(bn[10].s,NIL)   
   TextF(378,offy+11,'OPTIONEN')
   tooltype() 
 mymess:=wnd 
TextF(offx+367,offy+45,'System Information:')
TextF(offx+333,offy+55,'\s         \s',mycpu,myfpu)
TextF(offx+307,offy+65,'Kickstart \d.\d    Workbench \d.\d',myver,myrev,mywbv,mywbr)
 REPEAT
   mydate()
   wait4message(mymess)
   UNTIL type=IDCMP_CLOSEWINDOW
    IF mysave=1 THEN speicher()
    makeclosewn(wnd)
    stdout:=altstd
    Close(mycon)  
    closeproject0window()
   ENDIF
ENDPROC


PROC setupscreen()
  IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN RETURN OPENIC
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
  IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN RETURN OPENASL 
  IF (amigaguidebase:=OpenLibrary('amigaguide.library',33))=NIL THEN RETURN OPENGUIDE 
  IF (gtxbase:=OpenLibrary('gadtoolsbox.library',37))=NIL THEN RETURN OPENGTX
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
  IF (getfilei:=NewObjectA(GtX_InitGetFileClass(),NIL,[GT_VISUALINFO,visual,IA_HEIGHT,14,0]))=NIL THEN NOFILEI
  offy:=scr.wbortop+Int(scr.rastport+58)+1
  offx:=scr.wborleft
  tattr:=['topaz.font',8,0,0]:textattr
ENDPROC


PROC openproject0window()
  DEF g:PTR TO gadget
  IF (g:=CreateContext({project0glist}))=NIL THEN RETURN NOCONTEXT
  IF (menu:=CreateMenusA([1,0,'Project',0,0,0,0,
    2,0,'Save','l',$0,0,0,
    2,0,'About..','s',$0,0,0,
    2,0,'Quit','q',$0,0,0,
    1,0,'Work',0,$0,0,0,
    2,0,'Editor','e',$0,0,0,
    2,0,'EC','c',$0,0,0,
    2,0,'Run','r',$0,0,0,
    2,0,'DeBug','d',$0,0,0,
    2,0,'AProf','p',$0,0,0,
    2,0,'FlushC','f',$0,0,0,
    2,0,'HELP','h',$0,0,0,
    1,0,'REXX',0,$0,0,0,
    2,0,'Rexx Command','x',$0,0,0,
         0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN RETURN NOMENUS
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN NOMENUS
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+31,offy+87,214,14,'Source',tattr,3,4,visual,0]:newgadget,
    [GTST_STRING,bn[3].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[3]:=g
 IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+278,offy+87,232,14,'Programm',tattr,4,4,visual,0]:newgadget,
    [GTST_STRING,bn[4].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[4]:=g
 IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+325,offy+14,195,14,'EC',tattr,21,1,visual,0]:newgadget,
    [GTST_STRING,bn[15].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
 IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+8,offy+87,23,14,NIL,NIL,9,16,visual,NIL]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=getfilei
 g.selectrender:=getfilei
  IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+255,offy+87,23,14,NIL,NIL,10,16,visual,NIL]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 g.flags:=6
 g.activation:=1
 g.gadgetrender:=getfilei
 g.selectrender:=getfilei
 tattr:=['topaz.font',8,2,0]:textattr
IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+530,offy+87,96,14,'Open Prefs',tattr,30,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+20,offy+28,60,13,'E C',tattr,14,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+20,offy+10,60,13,'Editor',tattr,13,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+100,offy+10,60,13,'R U N',tattr,15,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+100,offy+28,60,13,'BeBug',tattr,16,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+20,offy+46,60,13,'AProf',tattr,17,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+100,offy+46,60,13,'FlushC',tattr,18,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+195,offy+10,60,13,'HELP',tattr,19,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+195,offy+28,60,13,'About',tattr,22,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
mycon:=Open('CON:0/0/640/80/GUI_Output ',1006)
altstd:=stdout
stdout:=mycon
 tattr:=['topaz.font',8,0,0]:textattr
IF (wnd:=OpenW(0,75,639,offy+127,$40036F,$100E,
   'AmigaE-GUI    (  EDP Disk ExclusiveVersion )',NIL,1,project0glist))=NIL THEN RETURN NOWINDOW
IF SetMenuStrip(wnd,menu)=FALSE THEN RETURN NOMENUS 
 DrawBevelBoxA(wnd.rport,offx+294,offy+3,238,28,[GT_VISUALINFO,visual,NIL])
 DrawBevelBoxA(wnd.rport,offx+8,offy+110,612,14,[GT_VISUALINFO,visual,GTBB_FRAMETYPE,
 BBFT_RIDGE,GTBB_RECESSED,NIL])
 DrawBevelBoxA(wnd.rport,offx+8,offy+3,167,63,[GT_VISUALINFO,visual,NIL])
 DrawBevelBoxA(wnd.rport,offx+185,offy+3,80,44,[GT_VISUALINFO,visual,GTBB_RECESSED,NIL])
 DrawBevelBoxA(wnd.rport,offx+294,offy+35,300,34,[GT_VISUALINFO,visual,NIL])
 Gt_RefreshWindow(wnd,NIL)
myrast:=stdrast
ENDPROC


PROC openproject1window()
  DEF g:PTR TO gadget
project1glist:=0
 tattr:=['topaz.font',8,2,0]:textattr
  IF (g:=CreateContext({project1glist}))=NIL THEN RETURN NOCONTEXT
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+525,offy+76,104,14,'Close Prefs',tattr,31,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 tattr:=['topaz.font',8,0,0]:textattr
 IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+33,offy+17,180,14,'Editor',tattr,1,4,visual,0]:newgadget,
    [GTST_STRING,bn[1].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[1]:=g
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+33,offy+49,180,14,'EC',tattr,2,4,visual,0]:newgadget,
    [GTST_STRING,bn[2].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[2]:=g
 IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+270,offy+17,180,14,'E-Guide',tattr,5,4,visual,0]:newgadget,
    [GTST_STRING,bn[5].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[5]:=g
 IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+270,offy+49,180,14,'Rexx Script',tattr,34,4,visual,0]:newgadget,
    [GTST_STRING,bn[13].s,
     GTST_MAXCHARS,250,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[9]:=g
 IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+10,offy+49,23,14,NIL,NIL,8,16,visual,NIL]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  g.flags:=6
  g.activation:=1
  g.gadgetrender:=getfilei
  g.selectrender:=getfilei
 IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+247,offy+17,23,14,NIL,NIL,11,16,visual,NIL]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  g.flags:=6
  g.activation:=1
  g.gadgetrender:=getfilei
  g.selectrender:=getfilei
 IF (g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+10,offy+17,23,14,NIL,NIL,7,0,visual,NIL]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  g.flags:=6
  g.activation:=1
  g.gadgetrender:=getfilei
  g.selectrender:=getfilei
 IF (g:=CreateGadgetA(CYCLE_KIND,g,
    [offx+524,offy+20,96,14,'SAVE TO',tattr,20,4,visual,0]:newgadget,
    [GTCY_LABELS,['ENVARC:','ENV:','ENVARC:',0],GTCY_ACTIVE,mpx,
     NIL]))=NIL THEN RETURN NOGADGET
 IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+594,offy+40,26,14,'Zeit :',tattr,32,1,visual,0]:newgadget,[GTCB_CHECKED,mytime,
    NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+594,offy+60,26,14,'Auto Save :',tattr,33,1,visual,0]:newgadget,[GTCB_CHECKED,mysave,
    NIL]))=NIL THEN RETURN NOGADGET
IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+380,offy+73,26,14,'Rexx + EC',tattr,35,1,visual,0]:newgadget,[GTCB_CHECKED,myrexx,
    NIL]))=NIL THEN RETURN NOGADGET
IF (wnd1:=OpenW(0,91,639,offy+93,$36F,$1004,
   ' GUI_Prefs ',NIL,1,project1glist))=NIL THEN RETURN NOWINDOW
Gt_RefreshWindow(wnd1,NIL)
ENDPROC


PROC tooltype()
DEF lock,y,wb:PTR TO wbstartup, args:PTR TO wbarg,
    x[15]:STRING,mydisk:PTR TO diskobject,wo
lock:=GetProgramDir()
IF lock
 y:=NameFromLock(lock,bn[19].s,250)
 StrCopy(bn[25].s,bn[19].s,ALL)
ENDIF
IF wbmessage	
  wb:=wbmessage
  args:=wb.arglist
  AddPart(bn[19].s,args[].name++,250) 
ENDIF
mydisk:=GetDiskObject(bn[19].s)
IF mydisk
x:='EMODULES'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
StrCopy(bn[21].s,wo,ALL)
ENDIF
x:='HELPGUIDE'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
StrCopy(bn[5].s,wo,ALL)
Gt_SetGadgetAttrsA(zeiger[5],wnd,0,[GTST_STRING,bn[5].s,NIL,NIL])
ENDIF
x:='REXX'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
StrCopy(bn[13].s,wo,ALL)
Gt_SetGadgetAttrsA(zeiger[9],wnd,0,[GTST_STRING,bn[13].s,NIL,NIL])
ENDIF
FreeDiskObject(mydisk)
ENDIF
 IF StrLen(bn[21].s)>1
  y:=AssignLate('EMODULES',bn[21].s)
 ENDIF
ENDPROC


PROC wait4message(win:PTR TO window)
  DEF mes:PTR TO intuimessage,g:PTR TO gadget,helf:PTR TO stringinfo,
      menur,menup,menug,zpoint,ypoint[254]:STRING
  zu:=FALSE 
REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(win.userport)
       type:=mes.class
      IF type=IDCMP_MENUPICK    /* Für  Menus */
        infos:=mes.code
         menur:=infos AND 31      
         menup:=(Shr(infos,5)) AND 63
          menug:=(menur*10)+menup+1
        IF menug
          auszahl:=menug+1002
          auswerte()
        ENDIF
      ELSEIF (type=IDCMP_GADGETUP) OR (type=IDCMP_GADGETDOWN)
         g:=mes.iaddress
         infos:=g.gadgetid
       IF infos<6
         helf:=g.specialinfo
         StrCopy(bn[infos].s,helf.buffer,ALL)
          IF infos=3
            StrCopy(bn[12].s,bn[3].s,(StrLen(bn[3].s)-2))
          ENDIF
          IF infos=2
             zpoint:=FilePart(bn[2].s)
             StrCopy(ypoint,bn[2].s,(EstrLen(bn[2].s)-StrLen(zpoint)))
             StrCopy(bn[6].s,ypoint,ALL)
             IF (AddPart(bn[6].s,'AProf',250))=NIL THEN RETURN NOBUFFER
             StrCopy(bn[7].s,ypoint,ALL)
             IF (AddPart(bn[7].s,'FlushCache',250))=NIL THEN RETURN NOBUFFER
             StrCopy(bn[8].s,ypoint,ALL)
             IF (AddPart(bn[8].s,'EDBG',250))=NIL THEN RETURN NOBUFFER
          ENDIF
        ELSEIF infos<12
         aslfiler()
        ELSEIF infos=32
         mytime:=mes.code
         StringF(bn[10].s,'\d',mytime)
        ELSEIF infos=33
         mysave:=mes.code
         StringF(bn[11].s,'\d',mysave)
        ELSEIF infos=35
         myrexx:=mes.code
       ELSEIF infos=34
         helf:=g.specialinfo
         StrCopy(bn[13].s,helf.buffer,ALL)
       ELSEIF infos=21
         helf:=g.specialinfo
         StrCopy(bn[15].s,helf.buffer,ALL)
       ELSEIF infos=20
         mpx:=mes.code
       ELSEIF infos>12
         auszahl:=infos+1000
         IF infos=22 
          auszahl:=1004
         ENDIF
         auswerte()
         win:=mymess 
     ENDIF
      ELSEIF type=IDCMP_REFRESHWINDOW
         Gt_BeginRefresh(win)
         Gt_EndRefresh(win,TRUE)
      ENDIF
       Gt_ReplyIMsg(mes)
       IF zu=TRUE
        closeproject1window()
        zu:=FALSE
       ENDIF
    ELSE
  WaitPort(win.userport)
     ENDIF
  UNTIL type
ENDPROC


PROC mydate()
DEF dt:datetime,ds:PTR TO datestamp
DEF day[50]:ARRAY,date[50]:ARRAY,time[50]:ARRAY
y:=SetStdRast(myrast)
IF mytime=1
  ds:=DateStamp(dt.stamp)
  dt.format:=3
  dt.flags:=0
  dt.strday:=day
  dt.strdate:=date
  dt.strtime:=time
  IF DateToStr(dt)
  TextF(offx+370,offy+120,'\s  \s  \s',day,date,time)
  ENDIF
ENDIF
TextF(offx+20,offy+120,' Chip:\d[4] KByte   Fast:\d[5] KByte',(AvailMem($2)/1024),(AvailMem($4)/1024))
ENDPROC


PROC auswerte()
DEF zpoint,ypoint[254]:STRING,mylock,oldlock
 SELECT auszahl
   CASE 1031
         mymess:=wnd
         zu:=TRUE
   CASE 1030
         reporterr(openproject1window())
         mymess:=wnd1
         zu:=FALSE
   CASE 1013
        StringF(starts,'Run "\s" "\s"',bn[1].s,bn[3].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])  
        WriteF('\n')
   CASE 1014
        IF myrexx=1
         StringF(starts,'Run RX \s "\s"',bn[13].s,bn[3].s)
         SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])   
        ENDIF
        StringF(starts,'Run "\s" \s "\s"',bn[2].s,bn[15].s,bn[12].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])  
        WriteF('\n')
   CASE 1015
        StringF(starts,'Run "\s"',bn[4].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])  
        WriteF('\n')
   CASE 1016
/*  Kompensation eines Fehlers?   in EDBG   */
             zpoint:=FilePart(bn[12].s)
             StrCopy(bn[20].s,bn[12].s,(EstrLen(bn[12].s)-StrLen(zpoint)))
             mylock:=Lock(bn[20].s,ACCESS_READ)
             oldlock:=CurrentDir(mylock)
             RightStr(ypoint,bn[12].s,(EstrLen(bn[12].s)-EstrLen(bn[20].s)))
       StringF(starts,'Run "\s" "\s"',bn[8].s,bn[12].s)
       SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL])  
            zpoint:=CurrentDir(oldlock)
            UnLock(mylock)
      WriteF('\n')
   CASE 1017
        StringF(starts,'Run "\s" "\s"',bn[6].s,bn[4].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL]) 
        WriteF('\n')
   CASE 1018
        StringF(starts,'Run "\s"',bn[7].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL]) 
   CASE 1019
        WriteF('Bitte Warten! Start der Help-Datei  !\n')
        guidm()
        WriteF('Help-Datei beendet !\n')  /*Starten einer AmigaguideDatei*/
   CASE 1023
        StringF(starts,'Run RX \s "\s"',bn[13].s,bn[3].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,0,NIL,NIL]) 
   CASE 1004
        EasyRequestArgs(0,[20,0,'Infos','\s','Weiter'],0,[bn[23].s])
   CASE 1003
        IF mpx>0 THEN speicher()
   CASE 1005
    type:=IDCMP_CLOSEWINDOW
 ENDSELECT
ENDPROC


PROC aslfiler()   
 DEF req:PTR TO filerequester
 IF req:=AllocFileRequest()
  IF AslRequest(req,[ASL_HAIL,'Bitte Wählen',ASL_DIR,bn[9].s,ASL_HEIGHT,180,NIL])
    StrCopy(bn[9].s,req.drawer,ALL)
    StrCopy(bn[25].s,bn[infos-6].s,ALL)
    StrCopy(bn[infos-6].s,req.drawer,ALL)
    IF (AddPart(bn[infos-6].s,req.file,250))=NIL THEN RETURN NOBUFFER
    SetStr(bn[infos-6].s,StrLen(bn[infos-6].s))
   IF infos=8
    StrCopy(bn[6].s,req.drawer,ALL)
    IF (AddPart(bn[6].s,'AProf',250))=NIL THEN RETURN NOBUFFER
    StrCopy(bn[7].s,req.drawer,ALL)
    IF (AddPart(bn[7].s,'FlushCache',250))=NIL THEN RETURN NOBUFFER
    StrCopy(bn[8].s,req.drawer,ALL)
    IF (AddPart(bn[8].s,'EDBG',250))=NIL THEN RETURN NOBUFFER
   ENDIF
   IF infos=9
    RightStr(bn[24].s,bn[3].s,2)
    IF StrCmp(bn[24].s,'.e',ALL)
      StrCopy(bn[4].s,bn[3].s,(StrLen(bn[3].s)-2))
      StrCopy(bn[12].s,bn[3].s,(StrLen(bn[3].s)-2))
      Gt_SetGadgetAttrsA(zeiger[4],wnd,0,[GTST_STRING,bn[4].s,NIL,NIL])
    ELSE
      StrCopy(bn[3].s,bn[25].s,ALL)
      WriteF('\e[33m\e[1mKein AmigaE-Source ! Cancel Operation. Neu Auswählen !\e[0m\n')
    ENDIF
   ENDIF
  ENDIF
  IF infos<12 
   Gt_SetGadgetAttrsA(zeiger[infos-6],mymess,0,[GTST_STRING,bn[infos-6].s,NIL,NIL])
  ENDIF
  FreeFileRequest(req)
 ENDIF
ENDPROC


PROC guidm()   /* Start einer Amigaguidedatei*/
DEF ja, myg:newamigaguide
myg.lock:=0
myg.screen:=0
myg.pubscreen:=0
myg.hostport:=0
myg.clientport:=0
myg.basename:=0
myg.flags:=2
myg.context:=0
myg.extens:=0
myg.client:=0
myg.name:=bn[5].s
myg.node:=0
myg.line:=0
ja:=OpenAmigaGuideA(myg,NIL)
CloseAmigaGuide(ja)
ENDPROC


PROC auswahl() 
 IF mpx=1
   StrCopy(bn[22].s,'ENV:Setup_GUI',ALL)
  ELSE 
   StrCopy(bn[22].s,'ENVARC:Setup_GUI',ALL)
 ENDIF
StringF(bn[17].s,'\d',mpx)
ENDPROC


PROC lade()
auswahl()
IF FileLength(bn[22].s)>0
fh:=Open(bn[22].s,MODE_OLDFILE)
FOR y:=1 TO 15
    ReadStr(fh,ioi)
    StrCopy(bn[y].s,ioi,ALL)
  ENDFOR
ReadStr(fh,ioi)
myrexx:=Val(ioi,NIL)
Close(fh)
ELSEIF mpx=1
mpx:=2
lade()
ENDIF
mysave:=Val(bn[11].s,NIL)
ENDPROC


PROC speicher()
auswahl()
fh:=Open(bn[22].s,1006)
 FOR y:=1 TO 15
  StringF(ioi,'\s\n',bn[y].s)
  Fputs(fh,ioi)
 ENDFOR
StringF(ioi,'\d\n',myrexx)
Fputs(fh,ioi)
Close(fh)
ENDPROC


PROC closeproject1window()
  IF wnd1 THEN makeclosewn(wnd1)
  IF project1glist THEN FreeGadgets(project1glist)
  wnd1:=0
ENDPROC


PROC closeproject0window()
  IF wnd1 THEN closeproject1window()
  IF wnd THEN ClearMenuStrip(wnd)
  IF menu THEN FreeMenus(menu) 
  IF visual THEN FreeVisualInfo(visual)
  IF project0glist THEN FreeGadgets(project0glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF getfilei THEN DisposeObject(getfilei)
  IF aslbase THEN CloseLibrary(aslbase)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF iconbase THEN CloseLibrary(iconbase)
  IF amigaguidebase THEN CloseLibrary(amigaguidebase)
  IF gtxbase THEN CloseLibrary(gtxbase)
ENDPROC


PROC makeclosewn(win:PTR TO window)
DEF mes:PTR TO intuimessage
Forbid()                           
 WHILE mes:=GetMsg(win.userport)
  IF mes.idcmpwindow=win
   Remove(mes)
   ReplyMsg(mes)
  ENDIF
 ENDWHILE
ModifyIDCMP(win,NIL)
Permit()
CloseW(win)
ENDPROC


PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
    erlist:=['get context','create gadget','lock wb','get visual infos',
      'open "gadtools.library" v37+','open window','create menus',
      'open "Asl.library"','open "Icon.library"','open "AmigaGuide.library"',
      'open "GadToolsBox.library"','get Getfile Image',
      ' Help ! Puffer für FileName zu klein']
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
  ENDIF
ENDPROC er





/* Only Interne Infos zum Programmerstellen !!!
1=Editor 2=EC 3=Source 4=Programm 5=Guide  6=Aprof 7=Flushcache 8=EDBG
9=Intern,DRAWER 10=time  11=save  12=Debugfile  13=REXX   14= 
15=Optionen     16=    17=Setup_gui  18=
19=Programmname/Pfad bei Start  20=belegtT 21=belegt 22=belegtT 23=belegt   
24=Intern |.e|   25=Intern |Zwischenspeicher|   */

/*StringF(bn[16].s,'Chip:\d[4] KByte     Fast:\d[5] KByte        \s',(AvailMem($2)/1024),(AvailMem($4)/1024),bn[18].s)
SetWindowTitles(wnd,bn[16].s,NIL)*/

/*StringF(bn[18].s,'\s  \s  \s',day,date,time)*/

/* Mit Tags Window Open 
  IF (wnd1:=OpenWindowTagList(NIL,
     [WA_LEFT,0,
     WA_TOP,75,
     WA_WIDTH,offx+639,
     WA_HEIGHT,offy+127,
     WA_IDCMP,$24C077E,
     WA_FLAGS,$100E,
     WA_TITLE,'AmigaE-GUI Prefs',
     WA_CUSTOMSCREEN,scr,
     WA_MINWIDTH,67,
     WA_MINHEIGHT,21,
     WA_MAXWIDTH,$2C0,
     WA_MAXHEIGHT,448,
     WA_AUTOADJUST,1,
     WA_AUTOADJUST,1,
     WA_GADGETS,project1glist,
     NIL]))=NIL THEN RETURN NOWINDOW      */

/*IF (g:=CreateGadgetA(CYCLE_KIND,g,
    [offx+400,offy+52,96,14,'Uhr',tattr,32,4,visual,0]:newgadget,
    [GTCY_LABELS,['AUS !','An !',0],GTCY_ACTIVE,mytime,
     NIL]))=NIL THEN RETURN NOGADGET*/
