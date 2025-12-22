OPT OSVERSION=37

MODULE 'gadtools','libraries/gadtools','intuition/intuition',
       'intuition/screens', 'intuition/gadgetclass', 'graphics/text',
        'dos/datetime','utility/date','dos/dos','Asl','libraries/Asl',
        'dos/dostags','workbench/startup','workbench/workbench','icon'

OBJECT makes
s             
ENDOBJECT

ENUM NONE,NOCONTEXT,NOGADGET,NOWB,NOVISUAL,OPENGT,NOWINDOW,NOMENUS,OPENASL,OPENIC

DEF	wnd:PTR TO window,scr:PTR TO screen,
	project0glist,starts[255]:STRING,
	zeiger[10]:ARRAY OF LONG,visual=NIL,
	bn[24]:ARRAY OF makes,ioi[255]:STRING,menu,mtime,
        y,type,infos,offx,offy,tattr,fh,mpx,altstd,mycon,auszahl


PROC setupscreen()
  IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN RETURN OPENIC
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
  IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN RETURN OPENASL 
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)+1


offx:=scr.wborleft
  tattr:=['topaz.font',8,0,0]:textattr
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
FOR y:=1 TO 13
    ReadStr(fh,ioi)
    StrCopy(bn[y].s,ioi,ALL)
  ENDFOR
Close(fh)
ELSEIF mpx=1
mpx:=2
lade()
ENDIF
ENDPROC 


PROC speicher()
auswahl()
fh:=Open(bn[22].s,1006)
 FOR y:=1 TO 13
  StringF(ioi,'\s\n',bn[y].s)
  Fputs(fh,ioi)
 ENDFOR
Close(fh)
ENDPROC 


PROC closedownscreen()
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN UnlockPubScreen(NIL,scr)
ENDPROC


PROC openproject0window()
  DEF g:PTR TO gadget
  IF (g:=CreateContext({project0glist}))=NIL THEN RETURN NOCONTEXT
  IF (menu:=CreateMenusA([1,0,'Project',0,0,0,0,
    2,0,'Infos','l',0,0,0,
    2,0,'Save','s',0,0,0,
    2,0,'Quit','q',0,0,0,
    1,0,'Work',0,0,0,0,
    2,0,'Editor','e',0,0,0,
    2,0,'EC','c',0,0,0,
    2,0,'Run','r',0,0,0,
    2,0,'HELP','p',0,0,0,
    2,0,'???--???','w',0,0,0,
    1,0,'REXX',0,0,0,0,
    2,0,'Rexx Command','x',0,0,0,
0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN RETURN NOMENUS
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN NOMENUS
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+33,offy+52,150,14,'Editor',tattr,1,4,visual,0]:newgadget,
    [GTST_STRING,bn[1].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[1]:=g
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+225,offy+52,170,14,'EC',tattr,2,4,visual,0]:newgadget,
    [GTST_STRING,bn[2].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[2]:=g 
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+441,offy+52,180,14,'Source',tattr,3,4,visual,0]:newgadget,
    [GTST_STRING,bn[3].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[3]:=g
 IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+33,offy+87,150,14,'Programm',tattr,4,4,visual,0]:newgadget,
    [GTST_STRING,bn[4].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[4]:=g 
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+225,offy+87,170,14,'E-Guide',tattr,5,4,visual,0]:newgadget,
    [GTST_STRING,bn[5].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[5]:=g
IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+441,offy+87,180,14,'Multiview',tattr,6,4,visual,0]:newgadget,
    [GTST_STRING,bn[6].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   zeiger[6]:=g
  IF (g:=CreateGadgetA(STRING_KIND,g,
    [offx+325,offy+14,195,14,'EC',tattr,18,1,visual,0]:newgadget,
    [GTST_STRING,bn[10].s,
     GTST_MAXCHARS,240,
     NIL]))=NIL THEN RETURN NOGADGET
   IF (g:=CreateGadgetA(MX_KIND,g,
    [offx+545,offy+6,20,10,NIL,tattr,20,2,visual,0]:newgadget,
    [GTMX_LABELS,['AUS','ENV:','ENVARC:',0],
    GTMX_SPACING,2,GTMX_ACTIVE,mpx,
    NIL]))=NIL THEN RETURN NOGADGET
 tattr:=['topaz.font',8,2,0]:textattr
 IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+8,offy+52,23,14,'»',tattr,7,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+200,offy+52,23,14,'»',tattr,8,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+416,offy+52,23,14,'»',tattr,9,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
 IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+8,offy+87,23,14,'»',tattr,10,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+200,offy+87,23,14,'»',tattr,11,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+416,offy+87,23,14,'»',tattr,12,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+80,offy+14,60,13,'E C',tattr,14,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+10,offy+14,60,13,'Editor',tattr,13,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+150,offy+14,60,13,'R U N',tattr,15,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
   IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+220,offy+14,60,13,'HELP',tattr,16,16,visual,0]:newgadget,
    [NIL]))=NIL THEN RETURN NOGADGET
mycon:=Open('CON:0/0/640/80/GUI_Output ',1006)
altstd:=stdout
stdout:=mycon
IF (wnd:=OpenW(0,55,639,offy+127,$40036F,$100E,
   'AmigaE-GUI ',NIL,1,project0glist))=NIL THEN RETURN NOWINDOW
IF SetMenuStrip(wnd,menu)=FALSE THEN RETURN NOMENUS 
 DrawBevelBoxA(wnd.rport,offx+539,offy+3,88,35,[GT_VISUALINFO,visual,NIL])
 DrawBevelBoxA(wnd.rport,offx+294,offy+3,238,28,[GT_VISUALINFO,visual,NIL])

 DrawBevelBoxA(wnd.rport,offx+8,offy+110,612,14,[GT_VISUALINFO,visual,GTBB_FRAMETYPE,
 BBFT_ICONDROPBOX,GTBB_RECESSED,NIL])

 Gt_RefreshWindow(wnd,NIL)
ENDPROC


PROC closeproject0window()
  IF project0glist THEN FreeGadgets(project0glist)
  IF aslbase THEN CloseLibrary(aslbase)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF iconbase THEN CloseLibrary(iconbase)
ENDPROC


PROC wait4message()
  DEF mes:PTR TO intuimessage,g:PTR TO gadget,helf:PTR TO stringinfo,
      menur,menup,menug
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
       type:=mes.class
      IF type=IDCMP_MENUPICK    /* Für  Menus */
        infos:=mes.code
         menur:=infos AND 31      
         menup:=(Shr(infos,5)) AND 63
          menug:=(menur*10)+menup+1
        IF menug
          auszahl:=menug+1002
         /* WriteF('  Zahl \d',auszahl) */
          auswerte()
        ENDIF
      ELSEIF (type=IDCMP_GADGETUP) OR (type=IDCMP_GADGETDOWN)
         g:=mes.iaddress
         infos:=g.gadgetid
        IF infos<7
         helf:=g.specialinfo
         StrCopy(bn[infos].s,helf.buffer,ALL)
          IF infos=3
            StrCopy(bn[12].s,bn[3].s,(StrLen(bn[3].s)-2))
          ELSEIF infos=6
             StrCopy(bn[13].s,bn[6].s,(StrLen(bn[6].s)-2))
          ENDIF
        ELSEIF infos<13
         aslfiler()
        ELSEIF infos=18
         helf:=g.specialinfo
         StrCopy(bn[10].s,helf.buffer,ALL)
        ELSEIF infos=19
         helf:=g.specialinfo
         StrCopy(bn[11].s,helf.buffer,ALL)
        ELSEIF infos=20
         mpx:=mes.code
        ELSEIF infos>12
         auszahl:=infos+1000
         auswerte()
        ENDIF
      ELSEIF type=IDCMP_REFRESHWINDOW
         Gt_BeginRefresh(wnd)
         Gt_EndRefresh(wnd,TRUE)
      ENDIF
       Gt_ReplyIMsg(mes)
    ELSE
      WaitPort(wnd.userport)
    ENDIF
  UNTIL type
ENDPROC


PROC auswerte()
 SELECT auszahl
   CASE 1013
        StringF(starts,'Run "\s" "\s"',bn[1].s,bn[3].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,stdout,NIL,NIL])
        WriteF('\n')
   CASE 1014
        StringF(starts,'Run "\s" \s \s',bn[2].s,bn[10].s,bn[12].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,stdout,NIL,NIL])
        WriteF('\n')       
   CASE 1015
        StringF(starts,'Run "\s"',bn[4].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,stdout,NIL,NIL])
        WriteF('\n')      
   CASE 1016
        StringF(starts,'Run "\s" "\s"',bn[6].s,bn[5].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,stdout,NIL,NIL])
   CASE 1023
        StringF(starts,'Run \s',bn[17].s)
        SystemTagList(starts,[SYS_INPUT,stdout,SYS_OUTPUT,stdout,NIL,NIL])
        
   CASE 1017
        WriteF('Hier könnte Euer Wunsch-Menue stehen. Nächste Version ??\n')
   CASE 1003
        WriteF('\e[33m\e[1mAmigaE-GUI V 1.3C © F.Bunk 1994  17.10.94\e[0m\n')
   CASE 1004
        IF mpx>0 THEN speicher()
   CASE 1005
    type:=IDCMP_CLOSEWINDOW
 ENDSELECT
ENDPROC


PROC makeclosewn()
DEF mes:PTR TO intuimessage        
Forbid()                           
 WHILE mes:=GetMsg(wnd.userport)
  IF mes.idcmpwindow=wnd
   Remove(mes)
   ReplyMsg(mes)
  ENDIF
 ENDWHILE
ModifyIDCMP(wnd,NIL)
Permit()
CloseWindow(wnd)
stdout:=altstd
Close(mycon)
ENDPROC


PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
    erlist:=['get context','create gadget','lock wb','get visual infos',
      'open "gadtools.library" v37+','open window','create menus',
      'open "Asl.library"','open "Icon.library"']
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
  ENDIF
ENDPROC er


PROC mydate()               

DEF dt:datetime,ds:PTR TO datestamp

DEF day[50]:ARRAY,date[50]:ARRAY,time[50]:ARRAY

IF mtime=TRUE
  ds:=DateStamp(dt.stamp)
  dt.format:=3
  dt.flags:=0
  dt.strday:=day
  dt.strdate:=date
  dt.strtime:=time
  IF DateToStr(dt)
  TextF(offx+375,offy+119,'\s  \s  \s',day,date,time)
  ENDIF
ENDIF
TextF(offx+20,offy+119,'Chip:\d[4] KByte Fast:\d[5] KByte',(AvailMem($2)/1024),(AvailMem($4)/1024))


ENDPROC


PROC aslfiler()   
 DEF req:PTR TO filerequester
 IF req:=AllocFileRequest()
  IF AslRequest(req,[ASL_HAIL,'Bitte Wählen',ASL_DIR,bn[15].s,ASL_HEIGHT,180,NIL])
   StrCopy(bn[15].s,req.drawer,ALL)
   StrCopy(bn[14].s,bn[infos-6].s,ALL)  
   StrCopy(bn[infos-6].s,req.drawer,ALL)
   AddPart(bn[infos-6].s,req.file,240)
    IF infos=9
    SetStr(bn[3].s,StrLen(bn[3].s))
    RightStr(bn[13].s,bn[3].s,2)
    IF StrCmp(bn[13].s,'.e',ALL)
      StrCopy(bn[4].s,bn[3].s,(StrLen(bn[3].s)-2))
      StrCopy(bn[12].s,bn[3].s,(StrLen(bn[3].s)-2))
      Gt_SetGadgetAttrsA(zeiger[4],wnd,0,[GTST_STRING,bn[4].s,NIL,NIL])
    ELSE
      StrCopy(bn[3].s,bn[14].s,ALL)
      WriteF('\e[33m\e[1mKein AmigaE-Source ! Cancel Operation. Neu Auswählen !\e[0m\n')
    ENDIF
   ENDIF
  ENDIF
  Gt_SetGadgetAttrsA(zeiger[infos-6],wnd,0,[GTST_STRING,bn[infos-6].s,NIL,NIL])  
  FreeFileRequest(req)
 ENDIF
ENDPROC


PROC tooltype()
DEF lock,y,wb:PTR TO wbstartup, args:PTR TO wbarg,
    x[15]:STRING,mydisk:PTR TO diskobject,wo
lock:=GetProgramDir()
IF lock
 y:=NameFromLock(lock,bn[19].s,240)
 StrCopy(bn[15].s,bn[19].s,ALL)
ENDIF
IF wbmessage	
  wb:=wbmessage
  args:=wb.arglist
  AddPart(bn[19].s,args[].name++,240) 
ENDIF   
mydisk:=GetDiskObject(bn[19].s)  
IF mydisk
x:='EMODULES'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
bn[21].s:=wo
ENDIF
x:='PMODULES'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
bn[22].s:=wo
ENDIF
x:='REXX'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
StrCopy(bn[17].s,wo,ALL)
ENDIF
x:='TIME'
wo:=FindToolType(mydisk.tooltypes,x)
IF wo
mtime:=TRUE
ENDIF
FreeDiskObject(mydisk)
ENDIF
 IF StrLen(bn[21].s)>1                           
  y:=AssignLate('EMODULES',bn[21].s)             
 ENDIF
 IF StrLen(bn[22].s)>1 
  y:=AssignLate('PMODULES',bn[22].s)    
 ENDIF
ENDPROC


PROC main()
FOR y:=0 TO 23
  bn[y].s:=String(240) 
ENDFOR  
VOID '$VER:AmigaE-GUI © F.Bunk  V1.3C (17.10.1994)' 
 bn[14].s:='.e'
 mpx:=1
  lade()
  mpx:=1
 IF reporterr(setupscreen())=0
   reporterr(openproject0window())
   SetTopaz(8)   
   Colour(1,0)
   TextF(offx+375,offy+119,'\s  \s  \s','TIME','=','OFF')
   TextF(376,offy+11,'OPTIONEN')
   tooltype()
 REPEAT
   mydate()
   wait4message()
 UNTIL type=IDCMP_CLOSEWINDOW
  IF mpx>0 THEN speicher()
   makeclosewn()
   closedownscreen()
   closeproject0window()
  ENDIF
ENDPROC
