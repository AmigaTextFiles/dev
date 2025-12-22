
/*************************************************************************

:Program       Info_mixer.e
:Description   Tool for Prelude Soundcard

:Autor.         Friedhelm Bunk
:EC-Version     EC3.3a    
:OS.            > 2.0 
:PRG-Version    1.0

*************************************************************************/



OPT OSVERSION=37

MODULE 'gadtools',
       'libraries/gadtools',
       'intuition/intuition',
       'intuition/screens',
       'intuition/gadgetclass',
       'intuition/iobsolete',
       'utility/tagitem',
       'devices/inputevent',
       'graphics/text','dos/dos',
       'prelude','libraries/prelude'

OBJECT makes
wert
posx
posy
ids
mdevi
setfreq
setinput
test
ENDOBJECT


ENUM ERROR_NONE,
     ERROR_CONTEXT,
     ERROR_GADGET,
     ERROR_WB,
     ERROR_VISUAL,
     ERROR_GT,
     ERROR_WINDOW,
     ERROR_MENUS,
     NOBUFFER,
     ERROR_PRE


DEF infos:PTR TO gadget,menu=NIL,fh,mpx,lok,flag,attn,
    project0wnd:PTR TO window,ioi[255]:STRING,
    project0glist,start:PTR TO prlctrl,rueck,beginn,
    scr:PTR TO screen,bn[26]:ARRAY OF makes,status,
    visual=NIL,x,offx,offy,type,faktor,multi,umre,
    tattr:PTR TO textattr,zy,mystart:PTR TO preludebase



PROC wait4message(win:PTR TO window)
  DEF mes:PTR TO intuimessage,g:PTR TO gadget,
      menur,menup,menug
REPEAT
    type:=0
    faktor:=36.0  
 IF mes:=Gt_GetIMsg(win.userport)
      type:=mes.class
      infos:=mes.code
      g:=mes.iaddress
      infos:=g.gadgetid
IF (type=IDCMP_MENUPICK)
         x:=mes.code
         menur:=x AND 31
         menup:=(Shr(x,5)) AND 63
         menug:=(menur*10)+menup+1
     IF menug=6
        type:=IDCMP_CLOSEWINDOW
     ELSEIF menug=2
       mpx:=2
       speicher()
     ELSEIF menug=1
       attn:=TRUE
       check()
      IF flag=0
        mpx:=1
       lok:=TRUE
       auswahl()
       lade()
      rechne2()
      ENDIF
     ELSEIF menug=4
        EasyRequestArgs(0,[20,0,'Infos','\s','OK'],0,[bn[23].wert])
     ELSEIF menug=11
       attn:=TRUE
       check()
       IF flag=0
        start:=PreludeInit([bn[1].mdevi,$08,bn[2].mdevi,$08,bn[3].mdevi,$9F,bn[4].mdevi,$9F,
        bn[5].mdevi,$09,bn[6].mdevi,$09,bn[7].mdevi,$09,bn[8].mdevi,$09,bn[10].mdevi,$80,                        
        bn[9].mdevi,$0,bn[11].mdevi,$0,bn[12].mdevi,$0,PRL_INPUT_RIGHT,$0,PRL_INPUT_LEFT,$0,
        PRL_FREQUENCY,bn[1].setfreq,NIL])
        lese()
        setze()
        EasyRequestArgs(0,[20,0,'Card Reset','\s','OK'],0,[bn[24].wert])
       ENDIF
      ELSEIF menug=12
       status:=mystart.mopencnt
       check()
       EasyRequestArgs(0,[20,0,'Info','\s\s','OK'],0,[bn[11].setinput,bn[x].setinput])
      ELSEIF menug=13
       lese()
       setze()
     ELSEIF menug=14
      attn:=TRUE
      check()
      IF flag=0
       lok:=TRUE
       mpx:=2
       auswahl()
       lade()
       rechne2()
      ENDIF
     ENDIF
ELSEIF  (type=IDCMP_GADGETUP) OR (type=IDCMP_GADGETDOWN)
 IF infos=13   
     Gt_SetGadgetAttrsA(bn[2].test,project0wnd,0,[GTSL_LEVEL,bn[1].ids,NIL])
  anzeige(2,bn[1].ids)
  rueck:=SetPrlCtrl([PRL_VOL_LINE_LEFT,bn[1].wert,NIL])
 ELSEIF infos=14   
     Gt_SetGadgetAttrsA(bn[4].test,project0wnd,0,[GTSL_LEVEL,bn[3].ids,NIL])
  anzeige(4,bn[3].ids)
  rueck:=SetPrlCtrl([PRL_VOL_A1_LEFT,bn[3].wert,NIL])
 ELSEIF infos=15   
     Gt_SetGadgetAttrsA(bn[6].test,project0wnd,0,[GTSL_LEVEL,bn[5].ids,NIL])
  anzeige(6,bn[5].ids)
  rueck:=SetPrlCtrl([PRL_VOL_A2_LEFT,bn[5].wert,NIL])
 ELSEIF infos=16   
     Gt_SetGadgetAttrsA(bn[8].test,project0wnd,0,[GTSL_LEVEL,bn[7].ids,NIL])
  anzeige(8,bn[7].ids)
  rueck:=SetPrlCtrl([PRL_VOL_DAC_LEFT,bn[7].wert,NIL])
 ELSEIF infos=17   
     Gt_SetGadgetAttrsA(bn[12].test,project0wnd,0,[GTSL_LEVEL,bn[11].ids,NIL])
  anzeige(12,bn[11].ids)
  rueck:=SetPrlCtrl([PRL_ING_LEFT,bn[11].wert,NIL])
 ENDIF
 IF infos=18
  rueck:=SetPrlCtrl([PRL_FREQUENCY,bn[mes.code].setfreq,NIL])
   bn[13].wert:=mes.code
 ENDIF
 IF infos=22
  rueck:=SetPrlCtrl([PRL_INPUT_RIGHT,bn[mes.code].setinput,NIL])
  rueck:=SetPrlCtrl([PRL_INPUT_LEFT,bn[mes.code].setinput,NIL])
   bn[17].wert:=mes.code
 ENDIF
 IF infos=19
  IF bn[14].wert=$20
  rueck:=SetPrlCtrl([PRL_MING_LEFT,0,NIL])
  bn[14].wert:=0
  ELSE
  rueck:=SetPrlCtrl([PRL_MING_LEFT,$20,NIL])
  bn[14].wert:=$20
  ENDIF
 ENDIF
IF infos=20
  IF bn[15].wert=$20
    rueck:=SetPrlCtrl([PRL_MING_RIGHT,0,NIL])
    bn[15].wert:=0
   ELSE
    rueck:=SetPrlCtrl([PRL_MING_RIGHT,$20,NIL])
    bn[15].wert:=$20
   ENDIF
  ENDIF
IF infos=21
    IF bn[16].wert=5
     rueck:=SetPrlCtrl([PRL_HPF,0,NIL])
     bn[16].wert:=0
   ELSE
    rueck:=SetPrlCtrl([PRL_HPF,5,NIL])
     bn[16].wert:=5
  ENDIF
 ENDIF
ELSEIF (type=IDCMP_MOUSEMOVE) 
 IF infos<10
  umre:=32
 ELSE
  umre:=16
 ENDIF
       bn[infos].ids:=mes.code
       bn[infos].wert:=Abs(umre-mes.code)
 IF infos>10
  bn[infos].wert:=mes.code
 ENDIF
 IF bn[infos].wert=umre
  IF infos>10
   bn[infos].wert:=0
  ELSEIF infos>8
    bn[infos].wert:=$80
  ELSEIF infos>6
    bn[infos].wert:=$BF
  ELSE
   bn[infos].wert:=$9F
  ENDIF 
 ENDIF
       anzeige(infos,mes.code)
       rueck:=SetPrlCtrl([bn[infos].mdevi,bn[infos].wert,NIL])
    ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(win)
        Gt_EndRefresh(win,TRUE)
     ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      WaitPort(win.userport)
    ENDIF
  UNTIL type
ENDPROC 


PROC check()
status:=mystart.mopencnt
IF status>1
bn[11].setinput:='\nAt least one other Program has open Prelude.library\n\n'
ELSE
bn[11].setinput:='\n'
ENDIF
flag:=0
x:=start.runningmode
x:=x+7
IF (x>7) AND (x<10) AND (attn=TRUE)
 flag:=EasyRequestArgs(0,[20,0,'Sorry Attention :','\s\s','CANCEL|DO IT'],0,[bn[11].setinput,bn[x].setinput])
ELSEIF ((start.prl_status AND $FFFF)=$9000) AND (attn=TRUE)
 flag:=EasyRequestArgs(0,[20,0,'Sorry Attention :','\s\s','CANCEL|DO IT'],0,[bn[11].setinput,bn[10].setinput])
ELSEIF beginn=TRUE
 flag:=EasyRequestArgs(0,[20,0,'Start with Reset ?','\s\s','CANCEL|DO IT'],0,[bn[11].setinput,bn[x].setinput])
ENDIF
attn:=FALSE
ENDPROC



PROC rechne(xy,ab,plika,xx,yy,minfos)
DEF x,s[7]:STRING
x:=xy!*plika-ab
StringF(zy,'\s(5)db',RealF(s,x,1))
IF xy>32 THEN xy:=0
IF xy = 0
 StringF(zy,' MUTE  ')
 IF (minfos=11) OR (minfos=12)
   StringF(zy,'NO GAIN')
 ENDIF
ENDIF
TextF(offx+xx,offy+yy,'\s',zy)
ENDPROC


PROC anzeige(auswert,code)
     faktor:=36.0
     multi:=1.5
     IF (auswert>6) AND (auswert<10)
     faktor:=48.0
     ELSEIF auswert=10
      faktor:=48.0
      multi:=3.0
    ELSEIF (auswert>10) AND (auswert<13)
      faktor:=0.0
      multi:=1.5
     ENDIF
 rechne(code,faktor,multi,bn[auswert].posx,bn[auswert].posy,auswert)
ENDPROC


PROC lese()
FOR x:=14 TO 16
bn[x].wert:=0
bn[x].ids:=0
ENDFOR
umre:=32
bn[2].ids:=Abs(umre-start.volumeleftline)
bn[2].wert:=start.volumeleftline
bn[1].ids:=Abs(umre-start.volumerightline)
bn[1].wert:=start.volumerightline
bn[4].ids:=Abs(umre-start.volumeleftaux1)
bn[4].wert:=start.volumeleftaux1
bn[3].ids:=Abs(umre-start.volumerightaux1)
bn[3].wert:=start.volumerightaux1
bn[6].ids:=Abs(umre-start.volumeleftaux2)
bn[6].wert:=start.volumeleftaux2
bn[5].wert:=start.volumerightaux2
bn[5].ids:=Abs(umre-start.volumerightaux2)
bn[9].ids:=Abs(umre-start.volumeloopback)
bn[9].wert:=start.volumeloopback
bn[10].wert:=start.volumemonoin
bn[8].ids:=Abs(umre-start.volumeleftdac)
bn[8].wert:=start.volumeleftdac
bn[7].ids:=Abs(umre-start.volumerightdac)
bn[7].wert:=start.volumerightdac
umre:=16
bn[10].ids:=Abs(umre-start.volumemonoin)
bn[12].ids:=start.inputgainleft
bn[12].wert:=start.inputgainleft
bn[11].ids:=start.inputgainright
bn[11].wert:=start.inputgainright
FOR x:=1 TO 12
 IF bn[x].ids>31 THEN bn[x].ids:=0
 IF bn[x].wert>31 
  IF x>10
   bn[x].wert:=0
  ELSEIF x>8
    bn[x].wert:=$80
  ELSEIF x>6
    bn[x].wert:=$BF
  ELSE
  bn[x].wert:=$9F
  ENDIF
 ENDIF
ENDFOR
FOR x:=0 TO 13
 IF bn[x].setfreq=(start.frequency AND $0000FFFF)
  bn[13].wert:=x
  bn[13].ids:=bn[13].wert
 ENDIF
ENDFOR
FOR x:=0 TO 3
 IF bn[x].setinput=start.rightinput
  bn[17].wert:=x
  bn[17].ids:=bn[17].wert
 ENDIF
ENDFOR
IF bn[19].setinput=start.lmicgainenabled
 bn[14].wert:=$20
 bn[14].ids:=1
ENDIF
IF bn[20].setinput=start.rmicgainenabled
 bn[15].wert:=$20
 bn[15].ids:=1
ENDIF
IF start.filterenabled >0
 bn[16].wert:=5
 bn[16].ids:=1
ENDIF
ENDPROC


PROC rechne2()
IF lok=TRUE
FOR x:=14 TO 16
bn[x].ids:=0
ENDFOR
umre:=32
bn[2].ids:=Abs(umre-bn[2].wert)
bn[1].ids:=Abs(umre-bn[1].wert)
bn[4].ids:=Abs(umre-bn[4].wert)
bn[3].ids:=Abs(umre-bn[3].wert)
bn[6].ids:=Abs(umre-bn[6].wert)
bn[5].ids:=Abs(umre-bn[5].wert)
bn[9].ids:=Abs(umre-bn[9].wert)
bn[8].ids:=Abs(umre-bn[8].wert)
bn[7].ids:=Abs(umre-bn[7].wert)
umre:=16
bn[10].ids:=Abs(umre-bn[10].wert)
bn[12].ids:=bn[12].wert
bn[11].ids:=bn[11].wert
bn[13].ids:=bn[13].wert
bn[17].ids:=bn[17].wert
IF bn[19].setinput=bn[14].wert
 bn[14].ids:=1
ENDIF
IF bn[20].setinput=bn[15].wert
 bn[15].ids:=1
ENDIF
IF bn[16].wert >0
 bn[16].ids:=1
ENDIF
setze()
presetze()
ENDIF
lok:=FALSE
ENDPROC


PROC setze()
FOR x:=1 TO 12
 IF bn[x].ids>31 THEN bn[x].ids:=0
 Gt_SetGadgetAttrsA(bn[x].test,project0wnd,0,[GTSL_LEVEL,bn[x].ids,NIL])
 anzeige(x,bn[x].ids)
ENDFOR
 Gt_SetGadgetAttrsA(bn[17].test,project0wnd,0,[GTCY_ACTIVE,bn[17].ids,NIL])
 Gt_SetGadgetAttrsA(bn[13].test,project0wnd,0,[GTCY_ACTIVE,bn[13].ids,NIL])
 Gt_SetGadgetAttrsA(bn[14].test,project0wnd,0,[GTCB_CHECKED,bn[14].ids,NIL])
 Gt_SetGadgetAttrsA(bn[15].test,project0wnd,0,[GTCB_CHECKED,bn[15].ids,NIL])
 Gt_SetGadgetAttrsA(bn[16].test,project0wnd,0,[GTCB_CHECKED,bn[16].ids,NIL])
ENDPROC


PROC presetze()
FOR x:=1 TO 12
 rueck:=SetPrlCtrl([bn[x].mdevi,bn[x].wert,NIL])
ENDFOR
x:=bn[17].wert
 rueck:=SetPrlCtrl([PRL_INPUT_RIGHT,bn[x].setinput,NIL])
 rueck:=SetPrlCtrl([PRL_INPUT_LEFT,bn[x].setinput,NIL])
x:=bn[13].wert
 rueck:=SetPrlCtrl([PRL_FREQUENCY,bn[x].setfreq,NIL])
 rueck:=SetPrlCtrl([PRL_MING_LEFT,bn[14].wert,NIL])
 rueck:=SetPrlCtrl([PRL_MING_RIGHT,bn[15].wert,NIL])
 rueck:=SetPrlCtrl([PRL_HPF,bn[16].wert,NIL])
ENDPROC


PROC lade()
IF FileLength(bn[22].wert)>0
fh:=Open(bn[22].wert,MODE_OLDFILE)
FOR x:=1 TO 17
ReadStr(fh,ioi)
bn[x].wert:=Val(ioi,NIL)
ENDFOR
lok:=TRUE
Close(fh)
ELSEIF mpx=1
mpx:=2
auswahl()
lade()
ENDIF
ENDPROC


PROC speicher()
auswahl()
fh:=Open(bn[22].wert,1006)
 FOR x:=1 TO 17
  StringF(ioi,'\d\n',bn[x].wert)
  Fputs(fh,ioi)
 ENDFOR
Close(fh)
ENDPROC


PROC auswahl() 
 IF mpx=1
   StrCopy(bn[22].wert,'ENV:Prelude/Balusmixer.pref',ALL)
  ELSE 
   StrCopy(bn[22].wert,'ENVARC:Prelude/balusmixer.pref',ALL)
 ENDIF
ENDPROC


PROC main() HANDLE
  DEF err=ERROR_NONE
IF (err:=setupscreen())<>ERROR_NONE THEN Raise(err)
VOID '$VER:Balus_Mixer © F.Bunk  V1.0  (09.12.1997)' 
bn[22].wert:=String(250)
bn[23].wert:=String(250)
bn[24].wert:=String(250)
bn[7].setinput:=String(250)
bn[8].setinput:=String(250)
bn[9].setinput:=String(250)
bn[10].setinput:=String(250)
bn[11].setinput:=String(250)
bn[23].wert:='\nBalus_Mixer © F.Bunk  \nV1.0  (09.12.1997)\n' 
bn[24].wert:='\n Card Reset done. \n'
bn[8].setinput:='PLAY Mode is running !\n'
bn[9].setinput:='REC Mode is running !\n'
bn[7].setinput:='Nothing is running .\n'
bn[10].setinput:='It is possible a AHI-Program uses Prelude\n'
lok:=FALSE
anlege()
preludeinit()
lese()
reporterr(openproject0window())
SetTopaz(8)   
  Colour(3,0)
zy:=String(7)
multi:=1.5
faktor:=36.0
FOR x:=1 TO 6
rechne(bn[x].ids,faktor,multi,bn[x].posx,bn[x].posy,x)
ENDFOR
faktor:=48.0
FOR x:=7 TO 9
rechne(bn[x].ids,faktor,multi,bn[x].posx,bn[x].posy,x)
ENDFOR
x:=10
faktor:=48.0
multi:=3.0
rechne(bn[x].ids,faktor,multi,bn[x].posx,bn[x].posy,x)
x:=11
faktor:=0.0
multi:=1.5
rechne(bn[x].ids,faktor,multi,bn[x].posx,bn[x].posy,x)
x:=12
rechne(bn[x].ids,faktor,multi,bn[x].posx,bn[x].posy,x)
 REPEAT
   wait4message(project0wnd)  
 UNTIL type=IDCMP_CLOSEWINDOW
   closeproject0window()
  IF CtrlC() THEN Raise(ERROR_NONE)
  Raise(ERROR_NONE)
EXCEPT
  closedownscreen()
  reporterr(err)
ENDPROC


PROC anlege()
bn[1].posx:=155
bn[1].posy:=22
bn[2].posx:=155
bn[2].posy:=34
bn[3].posx:=372
bn[3].posy:=22
bn[4].posx:=372
bn[4].posy:=34
bn[5].posx:=155
bn[5].posy:=76
bn[6].posx:=155
bn[6].posy:=87
bn[7].posx:=372
bn[7].posy:=76
bn[8].posx:=372
bn[8].posy:=87
bn[9].posx:=155
bn[9].posy:=134
bn[10].posx:=155
bn[10].posy:=152
bn[11].posx:=372
bn[11].posy:=130
bn[12].posx:=372
bn[12].posy:=141
bn[1].mdevi:=PRL_VOL_LINE_RIGHT
bn[2].mdevi:=PRL_VOL_LINE_LEFT
bn[3].mdevi:=PRL_VOL_A1_RIGHT
bn[4].mdevi:=PRL_VOL_A1_LEFT
bn[5].mdevi:=PRL_VOL_A2_RIGHT
bn[6].mdevi:=PRL_VOL_A2_LEFT
bn[7].mdevi:=PRL_VOL_DAC_RIGHT
bn[8].mdevi:=PRL_VOL_DAC_LEFT
bn[9].mdevi:=PRL_VOL_LOOPB
bn[10].mdevi:=PRL_VOL_MONO
bn[11].mdevi:=PRL_ING_RIGHT
bn[12].mdevi:=PRL_ING_LEFT
bn[0].setfreq:=48000
bn[1].setfreq:=44100
bn[2].setfreq:=37800
bn[3].setfreq:=33075
bn[4].setfreq:=32000
bn[5].setfreq:=27420
bn[6].setfreq:=22050
bn[7].setfreq:=18900
bn[8].setfreq:=16000
bn[9].setfreq:=11025
bn[10].setfreq:=9600
bn[11].setfreq:=8000
bn[12].setfreq:=6620
bn[13].setfreq:=5510
bn[0].setinput:=$0
bn[1].setinput:=$40
bn[2].setinput:=$80
bn[3].setinput:=$C0
bn[19].setinput:=$20
bn[20].setinput:=$20
ENDPROC


PROC reporterr(er)
  DEF erlist:PTR TO LONG
  IF er
    erlist:=['get context',
             'create gadget',
             'lock wb',
             'get visual infos',
             'open "gadtools.library" v37+',
             'open window',
             'create menus',
             'open Prelude_library, No Prelude ?']
    EasyRequestArgs(0,[20,0,0,'Could not \s!','OK'],0,[erlist[er-1]])
  ENDIF
ENDPROC er


PROC setupscreen()
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ERROR_GT
  IF (preludebase:=OpenLibrary('prelude.library',2))=NIL THEN RETURN ERROR_PRE
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN ERROR_WB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN ERROR_VISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)-10
  tattr:=['topaz.font',8,0,0]:textattr
ENDPROC


PROC closedownscreen()
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF preludebase 
  PreludeQuit()
  CloseLibrary(preludebase)
  mpx:=1
  speicher()
  ENDIF
ENDPROC


PROC openproject0window()
   DEF g:PTR TO gadget
  IF (g:=CreateContext({project0glist}))=NIL THEN RETURN ERROR_CONTEXT
IF (menu:=CreateMenusA([1,0,'Project',0,0,0,0,
    2,0,'Load','l',$0,0,0,
    2,0,'Save ENVARC:','s',$0,0,0,
    2,0,NM_BARLABEL,NIL,$0,0,0,
    2,0,'About','a',$0,0,0,
    2,0,NM_BARLABEL,NIL,$0,0,0,
    2,0,'Quit ','q',$0,0,0,
    1,0,'PRELUDE',0,$0,0,0,
    2,0,'RESET_CARD ','r',$0,0,0,
    2,0,'CARD_INFO','i',$0,0,0,
    2,0,'UPDATE_Data','u',$0,0,0,
    2,0,'SET_DEFAULT','d',$0,0,0,
    0,0,0,0,0,0,0]:newmenu,NIL))=NIL THEN RETURN ERROR_MENUS
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN ERROR_MENUS
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
  [offx+28,offy+15,124,10,'R',tattr,1,$0,visual,0]:newgadget,
  [GA_RELVERIFY,1,
   GTSL_MAX,32,GTSL_LEVEL,bn[1].ids,
   TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[1].test:=g
   IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+28,offy+26,124,10,'L',tattr,2,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[2].ids,    
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[2].test:=g
   IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+245,offy+15,124,10,'R',tattr,3,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[3].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[3].test:=g
   IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+245,offy+26,124,10,'L',tattr,4,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[4].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[4].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+28,offy+69,124,10,'R',tattr,5,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[5].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[5].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+28,offy+80,124,10,'L',tattr,6,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[6].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[6].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+245,offy+69,124,10,'R',tattr,7,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[7].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[7].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+245,offy+80,124,10,'L',tattr,8,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[8].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[8].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+46,offy+127,106,10,'L_B',tattr,9,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,32,GTSL_LEVEL,bn[9].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[9].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+46,offy+144,106,10,'MONO',tattr,10,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,16,GTSL_LEVEL,bn[10].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[10].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+245,offy+122,124,10,'R',tattr,11,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSL_MAX,15,GTSL_LEVEL,bn[11].ids,
     TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[11].test:=g
  IF (g:=CreateGadgetA(SLIDER_KIND,g,
    [offx+245,offy+133,124,10,'L',tattr,12,$0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
    GTSL_MAX,15,GTSL_LEVEL,bn[12].ids,
    TAG_END]))=NIL THEN RETURN ERROR_GADGET
bn[12].test:=g
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+56,offy+40,63,16,'LINE',tattr,13,PLACETEXT_IN,visual,0]:newgadget,
    [TAG_END]))=NIL THEN RETURN ERROR_GADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+277,offy+40,63,16,'AUX 1',tattr,14,PLACETEXT_IN,visual,0]:newgadget,
    [TAG_END]))=NIL THEN RETURN ERROR_GADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+56,offy+94,63,16,'AUX 2',tattr,15,PLACETEXT_IN,visual,0]:newgadget,
    [TAG_END]))=NIL THEN RETURN ERROR_GADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+278,offy+94,63,16,'DAC',tattr,16,PLACETEXT_IN,visual,0]:newgadget,
    [TAG_END]))=NIL THEN RETURN ERROR_GADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+277,offy+147,63,16,'GAIN',tattr,17,PLACETEXT_IN,visual,0]:newgadget,
    [TAG_END]))=NIL THEN RETURN ERROR_GADGET
 IF (g:=CreateGadgetA(CYCLE_KIND,g,
    [offx+450,offy+34,96,14,'Frequenz Hz',tattr,18,4,visual,0]:newgadget,
    [GTCY_LABELS,['48000','44100','37800','33075','32000','27420','22050',
     '18900','16000','11025',' 9600',' 8000',' 6620',' 5510',0],GTCY_ACTIVE,bn[13].wert,
     NIL]))=NIL THEN RETURN ERROR_GADGET
bn[13].test:=g
IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+454,offy+100,26,14,'L MIC',tattr,19,4,visual,0]:newgadget,[GTCB_CHECKED,bn[14].wert,
    NIL]))=NIL THEN RETURN ERROR_GADGET
bn[14].test:=g
IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+518,offy+100,26,14,'R MIC',tattr,20,4,visual,0]:newgadget,[GTCB_CHECKED,bn[15].wert,
    NIL]))=NIL THEN RETURN ERROR_GADGET
bn[15].test:=g
IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+528,offy+68,26,14,'ADC Filter',tattr,21,1,visual,0]:newgadget,[GTCB_CHECKED,bn[16].wert,
    NIL]))=NIL THEN RETURN ERROR_GADGET
bn[16].test:=g
 IF (g:=CreateGadgetA(CYCLE_KIND,g,
    [offx+450,offy+140,93,14,'Sample from:',tattr,22,4,visual,0]:newgadget,
    [GTCY_LABELS,[' Line ',' Aux 1 ','  MIC  ',' LoopB ',0],GTCY_ACTIVE,bn[17].wert,
     NIL]))=NIL THEN RETURN ERROR_GADGET
bn[17].test:=g
IF (project0wnd:=OpenW(0,15,560,offy+167,$37f,$100E,
   'INFO_MIXER',NIL,1,project0glist))=NIL THEN RETURN ERROR_WINDOW
IF SetMenuStrip(project0wnd,menu)=FALSE THEN RETURN ERROR_MENUS 
 DrawBevelBoxA(project0wnd.rport,218+offx,11+offy,5,50,
    [GT_VISUALINFO,visual,TAG_END]) 
 DrawBevelBoxA(project0wnd.rport,5+offx,61+offy,550,4,
    [GT_VISUALINFO,visual,TAG_END])
 DrawBevelBoxA(project0wnd.rport,432+offx,11+offy,5,50,
    [GT_VISUALINFO,visual,TAG_END])
 DrawBevelBoxA(project0wnd.rport,218+offx,65+offy,5,50,
    [GT_VISUALINFO,visual,TAG_END])
 DrawBevelBoxA(project0wnd.rport,5+offx,115+offy,550,4,
    [GT_VISUALINFO,visual,TAG_END])
 DrawBevelBoxA(project0wnd.rport,432+offx,65+offy,5,50,
    [GT_VISUALINFO,visual,TAG_END])
 DrawBevelBoxA(project0wnd.rport,218+offx,119+offy,5,45,
    [GT_VISUALINFO,visual,TAG_END])
 DrawBevelBoxA(project0wnd.rport,432+offx,119+offy,5,45,
    [GT_VISUALINFO,visual,TAG_END])
  Gt_RefreshWindow(project0wnd,NIL)
ENDPROC


PROC closeproject0window()
  IF project0wnd THEN CloseWindow(project0wnd)
  IF project0glist THEN FreeGadgets(project0glist)
  IF project0wnd THEN ClearMenuStrip(project0wnd)
  IF menu THEN FreeMenus(menu) 
ENDPROC


PROC preludeinit()
beginn:=TRUE
mystart:=preludebase
start:=mystart.mpr_prlctrl
attn:=TRUE
check()
IF flag=0
start:=PreludeInit([bn[1].mdevi,$08,bn[2].mdevi,$08,bn[3].mdevi,$9F,bn[4].mdevi,$9F,
       bn[5].mdevi,$09,bn[6].mdevi,$09,bn[7].mdevi,$09,bn[8].mdevi,$09,bn[10].mdevi,$80,                        
       bn[9].mdevi,$0,bn[11].mdevi,$0,bn[12].mdevi,$0,PRL_INPUT_RIGHT,$0,PRL_INPUT_LEFT,$0,
       PRL_FREQUENCY,bn[1].setfreq,NIL])
ENDIF
beginn:=FALSE
ENDPROC

