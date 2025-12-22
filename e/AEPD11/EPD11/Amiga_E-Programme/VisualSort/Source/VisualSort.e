/**********************************************************
 *                                                        *
 *       --- VisualSort v1.15 by Nico Max ---             *
 *                                                        *
 * Das Teil ist PD, somit darf es jeder kopieren, wie     *
 * sie/er Lust dazu hat. Wer im Source herumwurschteln    *
 * mag, kann dies meinetwegen gern tun (und dabei irgend- *
 * welche Fehler findet, oder Verbesserungen - mir bitte  *
 * mitteilen!)                                            *
 *                                                        *
 **********************************************************/

MODULE 'intuition/screens','intuition/intuition','intuition/gadgetclass',
       'graphics/displayinfo','graphics/modeid','graphics/text','graphics/rastport',
       'gadtools','libraries/gadtools',
       'reqtools','libraries/reqtools',
       'exec/nodes','exec/ports','exec/memory',
       'rexxsyslib','rexx/errors','rexx/storage',
       'devices/inputevent','keymap','dos/dos',
       'libraries/locale','locale'

OPT OSVERSION=37

CONST COLSET=2,COLCLEAR=0,DRAWMX=$f882,DIRECTIONMX=$f8e2,IMMMX=$f9c2

OBJECT rexxobj
  keyword,len:CHAR
ENDOBJECT
OBJECT statisticrec
  moves,comps,elems
ENDOBJECT


ENUM SCHLEIF
ENUM ARG_AS,ARG_DES,ARG_DEGREE,ARG_LINES,NUMARGS
ENUM ABOUT,QUIT,BUBBLE,SHAKE,INSERT,SEL,SHELL,MERGE,QUICK,HEAP,SCREEN,BREAK,STOPS,
     POINTS,LINES,RANDOMIZE,ASCENDING,DESCENDING,DEGREE,STATISTICS,IMMEDIATE,
     SAVESTATISTICS,FREEHAND,COMPLETE,FREEINITVALUE,POPUP,POPBACK
ENUM PROG_L,SAVE_L,ABOUT_L,QUIT_L,ALG_L,BUBBLE_L,SHAKE_L,INSERT_L,SELECT_L,
     SHELL_L,MERGE_L,QUICK_L,HEAP_L,STATISTIK_L,SETUP_L,SCR_L,DEGREE_L,
     FREEINIT_L,POINTS_L,LINES_L,RAND_L,ASC_L,DES_L,FREEHAND_L,COMPLETE_L,
     IMM_L,WELCOME_L,ARRAYCREATE_L,ARRAYCOMPLETE_L,BREAK_L,STOP_L,BUBBLEW_L,
     SHAKEW_L,JOKE_L,DRAW_L,WHICHVALUE_L,BREAKBUTTON_L,STOPBUTTON_L,
     SAVEREQTITLE_L,SCRMODE_L,DEGREETITLE_L,FREEINITVALUE_L,SCREENTITLE_L,
     ABOUTREQ1_L,ABOUTREQ2_L,ABOUTBUTTONS_L,OKBUTTON_L,ALGSTATISTIK_L,
     ERRCOULDNT_L,
     ERRPUBSCR_L,ERROPENSCR_L,ERROPENWIN_L,ERRMODEID_L,ERRVISUAL_L,
     ERRCONTXT_L,ERRGADGET_L,ERRMENUS_L,ERROPEN_L,ERRWRITE_L,BOTHASCDES_L,
     ERRDEGREE_L,CHOOSEASCDES_L,WHICHDEGREE_L,LOWMEM_L,REXXDEGREE_L,
     REXXNUMERICNEED_L,REXXNEEDKEYWORD_L,REXXFILENAMENEED_L,
     REXXWRONGFREEHAND_L,REXXONOFFONLY_L,REXXUNKNOWNCOMMAND_L,
     SETFREETOZERO_L,NEEDGADTOOLS_L,NEEDREQTOOLS_L,ERRSCRMODESTRUCT_L,
     ERRFILEREQSTRUCT_L,KEYMAP_L,SECONDCOPY_L,ERRMSGPORT_L,CLOSESCR

RAISE ERRPUBSCR_L  IF LockPubScreen()=0,
      ERRMODEID_L  IF GetVPModeID()=INVALID_ID,
      ERROPENSCR_L IF OpenScreenTagList()=0,
      ERROPENWIN_L IF OpenWindowTagList()=0,
      ERRVISUAL_L  IF GetVisualInfoA()=0,
      ERRCONTXT_L  IF CreateContext()=0,
      ERRGADGET_L  IF CreateGadgetA()=0,
      ERRMENUS_L   IF CreateMenusA()=0,
      ERRMENUS_L   IF LayoutMenusA()=0,
      ERROPEN_L    IF Open()=0,
      ERRWRITE_L   IF VfPrintf()= TRUE

DEF scr=0:PTR TO screen,pscr:PTR TO screen,win=0:PTR TO window,
    visual=0,menus, glist=0:PTR TO gadget,msgmenucode=MENUNULL,
    rexxport=0:PTR TO mp,lptr:PTR TO ln,
    catalog=0:PTR TO catalog,builtinlanguage:PTR TO LONG,
    rexxkeywords:PTR TO rexxobj,rexxmsg:PTR TO rexxmsg,rexxwait= FALSE,
    scroller:PTR TO gadget, bstop:PTR TO gadget,bexit:PTR TO gadget,
    infoy,infox,inforecty,
    screenmodereq=0:PTR TO rtscreenmoderequester,filereq=0:PTR TO rtfilerequester,
    adr=0:PTR TO INT,maxlen,
    rectop,recleft,recheight, font=0,textheight,
    args[NUMARGS]:LIST,
    lines=0,ascending= TRUE,random= TRUE, degree=75,immediate= TRUE,
    statistics[7]:ARRAY OF statisticrec,break,freehand=0,
    complete= TRUE,funcs:PTR TO LONG,freeinitvalue=0

PROC main() HANDLE
DEF x:PTR TO LONG,templ,rdargs
  initdatas(); openlibs()
  FOR x:=0 TO NUMARGS-1 DO args[x]:=0
  templ:='A=ASCENDING/S,D=DESCENDING/S,DEGREE/N,LINES/S'; rdargs:=ReadArgs(templ,args,NIL)
  IF (args[ARG_AS]<>0) AND (args[ARG_DES]<>0)
    WriteF(getstr(BOTHASCDES_L)); Raise(SCHLEIF); ENDIF
  IF ((x:=Long(args[ARG_DEGREE]))<0) OR (x>100)
    WriteF(getstr(ERRDEGREE_L)); Raise(SCHLEIF); ENDIF
  IF ((args[ARG_AS]=0) AND (args[ARG_DES]=0)) AND args[ARG_DEGREE]
    WriteF(getstr(CHOOSEASCDES_L)); Raise(SCHLEIF); ENDIF
  IF ((args[ARG_AS] OR args[ARG_DES]) AND (args[ARG_DEGREE]=0))
    WriteF(getstr(WHICHDEGREE_L)); Raise(SCHLEIF); ENDIF
  IF args[ARG_LINES] THEN lines:= 1
  IF args[ARG_DEGREE]
    degree:= Long(args[ARG_DEGREE]); random:= FALSE
    IF args[ARG_DES] THEN ascending:= FALSE
  ENDIF
  opengui(0,getstr(WELCOME_L))
  wait4message(); closegui(); closelibs(); IF rdargs THEN FreeArgs(rdargs)
EXCEPT
  IF exception <> SCHLEIF THEN printerrmsg(getstr(ERRCOULDNT_L),[getstr(exception)])
  closegui(); closelibs(); IF rdargs THEN FreeArgs(rdargs)
ENDPROC

PROC wait4message()
DEF what,reqtags,filename[111]:ARRAY
  LOOP
    what:= checkports()
    SELECT what
      CASE SAVESTATISTICS;
        IF filereq
          IF RtFileRequestA(filereq,filename,getstr(SAVEREQTITLE_L),
            [RT_WINDOW,win,RT_LOCKWINDOW,TRUE,RT_REQPOS,REQPOS_CENTERWIN,
             RT_UNDERSCORE,"_",RTFI_FLAGS,FREQF_SAVE,0])
            save_statistics(filereq.dir,filename)
          ENDIF
        ENDIF
      CASE ABOUT
        IF reqtoolsbase
           reqtags:= [RT_WINDOW,win,RT_LOCKWINDOW,TRUE,RT_REQPOS,REQPOS_CENTERWIN,
                      RT_UNDERSCORE,"_",RTEZ_FLAGS,EZREQF_CENTERTEXT,0]
          IF RtEZRequestA(getstr(ABOUTREQ1_L),getstr(ABOUTBUTTONS_L),0,0,reqtags)
             RtEZRequestA(getstr(ABOUTREQ2_L),getstr(OKBUTTON_L),0,
                          [AvailMem(MEMF_CHIP),AvailMem(MEMF_FAST)],reqtags)
          ENDIF
        ENDIF
      CASE QUIT; RETURN
      CASE SCREEN
        IF screenmodereq
          IF RtScreenModeRequestA(screenmodereq,getstr(SCRMODE_L),
              [RT_WINDOW,win,RT_LOCKWINDOW,TRUE,
               RT_REQPOS,REQPOS_CENTERWIN,0])
             closegui(); opengui(screenmodereq.displayid,getstr(JOKE_L))
          ENDIF; ENDIF
      CASE POPUP;   ScreenToFront(scr); ActivateWindow(win)
      CASE POPBACK; ScreenToBack(scr)
      CASE DEGREE
        IF reqtoolsbase
          RtGetLongA({degree},getstr(DEGREETITLE_L),0,
          [RT_WINDOW,win,RT_REQPOS,REQPOS_CENTERWIN,RT_LOCKWINDOW,TRUE,
           RTGL_MIN,0,RTGL_MAX,100,
           RTGL_SHOWDEFAULT,TRUE,0]); ENDIF
      CASE FREEINITVALUE
        IF reqtoolsbase
          RtGetLongA({freeinitvalue},getstr(FREEINITVALUE_L),0,
          [RT_WINDOW,win,RT_REQPOS,REQPOS_CENTERWIN,RT_LOCKWINDOW,TRUE,
           RTGL_MIN,0,RTGL_MAX,recheight,
           RTGL_SHOWDEFAULT,TRUE,0]); ENDIF
      CASE POINTS;     lines:= 0; checkmxmenus(DRAWMX,2,1)
      CASE LINES;      lines:= 1; checkmxmenus(DRAWMX,2,2)
      CASE RANDOMIZE;  random:=    TRUE;  freehand:= FALSE; checkmxmenus(DIRECTIONMX,4,1)
      CASE ASCENDING;  ascending:= TRUE;  freehand:= random:= FALSE; checkmxmenus(DIRECTIONMX,4,2)
      CASE DESCENDING; ascending:= FALSE; freehand:= random:= FALSE; checkmxmenus(DIRECTIONMX,4,3)
      CASE FREEHAND;   freehand:=  TRUE;  checkmxmenus(DIRECTIONMX,4,4)
      CASE STATISTICS; show_statistics()
      DEFAULT
        IF (what >= BUBBLE) AND (what <= HEAP)
          createarray()
          IF adr; start_algorithmus(what)
          ELSE
            printerrmsg(getstr(LOWMEM_L),0)
          ENDIF
        ENDIF
    ENDSELECT
  ENDLOOP
ENDPROC

PROC checkports()
DEF mes:PTR TO intuimessage,what,port:PTR TO mp,class,code,alg,
    nochmal=TRUE,arg[100]:STRING,restarg,x,len,rmb,mx,my,x2=-1,
    item:PTR TO menuitem
  IF rexxwait; ReplyMsg(rexxmsg); rexxwait:= FALSE; ENDIF
  LOOP
    REPEAT
      IF msgmenucode<>MENUNULL
        item:= ItemAddress(menus,msgmenucode)
        IF (what:= getwhat(0,IDCMP_MENUPICK,item.nextselect,0))<>-1 THEN RETURN what
      ENDIF
      IF mes:= GetMsg(port:= win.userport)
        nochmal:= TRUE
        IF mes:= Gt_FilterIMsg(mes)
          what:= getwhat(mes.iaddress,mes.class,mes.code,mes.qualifier)
        ELSE; what:= -1; ENDIF
        Gt_ReplyIMsg(mes)
        IF what<>-1
          IF (what>=BUBBLE) AND (what<=HEAP) AND freehand
            alg:= what; what:= -1
            SetAPen(win.rport,0); RectFill(win.rport,recleft-2,rectop-1,maxlen+3,recheight+rectop+1)
            win.flags:= win.flags OR WFLG_RMBTRAP
            IF adr THEN Dispose(adr)
            adr:= New(Shl(maxlen+1,1))
            IF adr
              FOR x:= 0 TO maxlen; adr[x]:= freeinitvalue; setpoint(x,freeinitvalue,1); ENDFOR
              clearinfo(); SetAPen(win.rport,1)
              TextF(infox,infoy,getstr(DRAW_L))
              rmb:= mx:= my:= 0; x:= 1;
              REPEAT
                IF mes:= GetMsg(port)
                  class:= mes.class; code:= mes.code; ReplyMsg(mes)
                  IF class=IDCMP_MOUSEBUTTONS
                    SELECT code
                        CASE IECODE_RBUTTON+IECODE_UP_PREFIX; rmb:= TRUE
                        CASE IECODE_LBUTTON
                          clearinfo()
                          WHILE Mouse()=1
                            IF (mx:= MouseX(win))<recleft; mx:= recleft
                            ELSE
                              IF mx>(recleft+maxlen) THEN mx:= recleft+maxlen
                            ENDIF
                            IF (my:= MouseY(win))<rectop; my:= rectop
                            ELSE
                              IF my>(rectop+recheight) THEN my:= rectop+recheight
                            ENDIF
                            mx:= mx-recleft
                            IF lines
                              IF (my >= rectop) AND (my <= (Shr(recheight,1)+rectop))
                                my:= Shl(Shr(recheight,1)+rectop-my,1)
                              ELSE; my:= Shl(my-Shr(recheight,1)-rectop,1)
                              ENDIF
                            ELSE; my:= rectop+recheight-my; ENDIF
                            IF (mx<>x2) AND (adr[mx]=freeinitvalue)
                              x2:= mx; displayinfo(getstr(WHICHVALUE_L),[x++])
                            ENDIF
                            IF adr[mx]<>my
                              setpoint(mx,adr[mx],0); adr[mx]:= my
                              setpoint(mx,adr[mx],1); ENDIF
                          ENDWHILE
                    ENDSELECT
                  ENDIF
                ELSE; Wait(Shl(1,port.sigbit)); ENDIF
              UNTIL rmb
              win.flags:= win.flags AND Not(WFLG_RMBTRAP)
              IF complete THEN complete_array()
              start_algorithmus(alg)
            ELSE; printerrmsg(getstr(LOWMEM_L),0); ENDIF
          ENDIF; IF what <> -1 THEN RETURN what
        ENDIF
      ELSE; nochmal:= FALSE; ENDIF
      IF rexxmsg:= GetMsg(rexxport)
        nochmal:= TRUE
        StrCopy(arg,TrimStr(Long(rexxmsg.args)),100); UpperStr(arg)
        rexxmsg.result1:= RC_WARN; rexxmsg.result2:= 0
        what:=0 ; nochmal:= TRUE
        REPEAT
        UNTIL StrCmp(x:=rexxkeywords[what].keyword,arg,
                     len:= rexxkeywords[what++].len) OR (len=0)
        IF len
          IF Char(restarg:= TrimStr(arg+len))=0 THEN rexxmsg.result1:= RC_OK
          IF what--=DEGREE
            degree:= Val(restarg,{x}); what:= -1
            IF x
              IF (degree < 0) OR (degree > 100)
                printerrmsg(getstr(REXXDEGREE_L),0)
                degree:= -1
              ELSE
                rexxmsg.result1:= RC_OK; random:= FALSE
                checkmxmenus(DIRECTIONMX,3,IF ascending THEN 2 ELSE 3)
              ENDIF
            ELSE
              printerrmsg(getstr(REXXNUMERICNEED_L),rexxmsg.args)
              degree:= -1; ENDIF
          ELSE
            IF (what >= BUBBLE) AND (what <= HEAP)
              IF restarg[]
                IF StrCmp(restarg,'WAIT',ALL)
                  rexxwait:= TRUE; rexxmsg.result1:= RC_OK; ENDIF
              ELSE; rexxmsg.result1:= RC_OK; ENDIF
            ELSE
              IF ((x:=what)=IMMEDIATE) OR (what=COMPLETE)
                what:= -1
                IF restarg[]
                  rexxmsg.result1:= RC_OK
                  IF StrCmp(restarg,'ON',ALL)
                    IF x=IMMEDIATE THEN immediate:= TRUE ELSE complete:= TRUE
                    checkmxmenus(IF x=IMMEDIATE THEN IMMMX ELSE IMMMX-$40,1,1)
                  ELSE
                    IF StrCmp(restarg,'OFF',ALL)
                      IF x=IMMEDIATE THEN immediate:= FALSE ELSE complete:= FALSE
                      checkmxmenus(IF x=IMMEDIATE THEN IMMMX ELSE IMMMX-$40,1,0)
                    ELSE
                      printerrmsg(getstr(REXXONOFFONLY_L),rexxmsg.args)
                      rexxmsg.result1:= RC_WARN; ENDIF; ENDIF
                ELSE; printerrmsg(getstr(REXXNEEDKEYWORD_L),rexxmsg.args); ENDIF
              ELSE
                IF what=SAVESTATISTICS
                  what:= -1
                  IF restarg[]
                    save_statistics('',TrimStr(Long(rexxmsg.args)+len))
                    rexxmsg.result1:= RC_OK
                  ELSE; printerrmsg(getstr(REXXFILENAMENEED_L),rexxmsg.args); ENDIF
                ELSE
                  IF what=FREEINITVALUE
                    freeinitvalue:= Val(restarg,{x}); what:= -1
                    IF x
                      IF (freeinitvalue < 0) OR (freeinitvalue > recheight)
                        printerrmsg(getstr(REXXWRONGFREEHAND_L),{recheight})
                        freeinitvalue:= 0
                      ELSE; rexxmsg.result1:= RC_OK; ENDIF
                    ELSE
                      printerrmsg(getstr(REXXNUMERICNEED_L),rexxmsg.args)
                      freeinitvalue:= 0; ENDIF
                  ENDIF
                ENDIF
              ENDIF
            ENDIF
          ENDIF              /* ok, ich geb's zu; nächstes Mal nehme ich */
                             /* ReadArgs()                               */
          IF (what<>-1) AND restarg[]
            printerrmsg(getstr(REXXUNKNOWNCOMMAND_L),rexxmsg.args); what:= -1; ENDIF
        ELSE; printerrmsg(getstr(REXXUNKNOWNCOMMAND_L),rexxmsg.args); what:= -1; ENDIF
        IF (rexxmsg.action AND RXFF_RESULT) AND (what<>-1)
          rexxsysbase:= rexxmsg.libbase
          rexxmsg.result2:= CreateArgstring(arg,StrLen(arg))
        ENDIF
        IF rexxwait= FALSE THEN ReplyMsg(rexxmsg)
        IF what   <> -1    THEN RETURN what
      ENDIF
    UNTIL nochmal=FALSE
    Wait(Shl(1,port.sigbit) OR Shl(1,rexxport.sigbit))
  ENDLOOP
ENDPROC

PROC checkbreak()
DEF mes:PTR TO intuimessage,iadr,class,code,qual,weiter=FALSE,what
  IF mes:=Gt_GetIMsg(win.userport)
    iadr :=mes.iaddress; class:= mes.class; code:= mes.code; qual:= mes.qualifier
    Gt_ReplyIMsg(mes); what:= getwhat(iadr,class,code,qual)
    SELECT what
      CASE STOPS
        clearinfo();  displayinfo(getstr(STOP_L),0)
        REPEAT
          IF mes:=Gt_GetIMsg(win.userport)
            iadr :=mes.iaddress; class:= mes.class; code:= mes.code; qual:= mes.qualifier
            Gt_ReplyIMsg(mes); what:= getwhat(iadr,class,code,qual)
            IF what=STOPS THEN weiter:= TRUE
            IF what=BREAK
              what:= RemoveGadget(win,bstop)
              bstop.flags:= bstop.flags AND Not(GFLG_SELECTED)
              AddGadget(win,bstop,what); RefreshGList(bstop,win,0,1)
              clearinfo(); displayinfo(getstr(BREAK_L),0); Raise(BREAK); ENDIF
          ELSE; WaitPort(win.userport); ENDIF
        UNTIL weiter; clearinfo()
      CASE BREAK
        clearinfo(); displayinfo(getstr(BREAK_L),0); Raise(BREAK)
    ENDSELECT
  ENDIF
ENDPROC

PROC getwhat(iadr,class,code,qual)
DEF inputrec:inputevent,buffer[10]:STRING,x,titel,item,sb,ss
    inputrec.class:= IECLASS_RAWKEY; inputrec.code:= code; inputrec.qualifier:= qual
    IF class=IDCMP_RAWKEY
      IF inputrec.qualifier /*AND IEQUALIFIER_RCOMMAND*/
        MapRawKey(inputrec,buffer,10,0); UpperStr(buffer)
        sb:= IF (x:= InStr(item:= getstr(BREAKBUTTON_L),'_',0))<>-1 THEN item[x+1] AND 223 ELSE -1
        ss:= IF (x:= InStr(item:= getstr(STOPBUTTON_L),'_',0))<>-1  THEN item[x+1] AND 223 ELSE -1
        x:= buffer[]
        SELECT x
          CASE ss; code:= $40; CASE sb; code:= $45
        ENDSELECT
      ENDIF
      SELECT code
        CASE $45
          IF bexit.flags AND GFLG_DISABLED THEN RETURN -1
          x:= RemoveGadget(win,bexit); bexit.flags:= bexit.flags+GFLG_SELECTED
          AddGadget(win,bexit,x); RefreshGList(bexit,win,0,1)
          Delay(4); x:= RemoveGadget(win,bexit)
          bexit.flags:= bexit.flags-GFLG_SELECTED; AddGadget(win,bexit,x)
          RefreshGList(bexit,win,0,1); RETURN BREAK
        CASE $40
          IF bexit.flags AND GFLG_DISABLED THEN RETURN -1
          x:= RemoveGadget(win,bstop); bstop.flags:= Eor(bstop.flags,GFLG_SELECTED);
          AddGadget(win,bstop,x); RefreshGList(bstop,win,0,1); RETURN STOPS
      ENDSELECT
    ELSE; IF iadr=bstop THEN RETURN STOPS; IF iadr=bexit THEN RETURN BREAK; ENDIF
    IF (class=IDCMP_MENUPICK) AND (code<>MENUNULL)
      msgmenucode:= code
      titel:=code AND %11111; item:= Shr(code,5) AND %111111
      SELECT titel
        CASE 0
          SELECT item
            CASE 0; RETURN SAVESTATISTICS
            CASE 2; RETURN ABOUT
            CASE 4; RETURN QUIT
          ENDSELECT
        CASE 1; IF item=9 THEN RETURN STATISTICS ELSE RETURN item+BUBBLE
        CASE 2
          SELECT item
            CASE 0;  RETURN SCREEN
            CASE 1;  RETURN DEGREE
            CASE 2;  RETURN FREEINITVALUE
            CASE 4;  lines    := 0
            CASE 5;  lines    := 1
            CASE 7;  random   := TRUE;  freehand:=             FALSE
            CASE 8;  ascending:= TRUE;  freehand:= random   := FALSE
            CASE 9;  ascending:=        freehand:= random   := FALSE
            CASE 10; freehand := TRUE;  random  := ascending:= FALSE
            CASE 12; complete := Not(complete)
            CASE 14; immediate:= Not(immediate)
          ENDSELECT
      ENDSELECT
    ENDIF
ENDPROC -1

PROC start_algorithmus(what)
  clearinfo(); ClearMenuStrip(win); break:= FALSE
  OnGadget(bexit,win,0); OnGadget(bstop,win,0)
  statistics[what-BUBBLE].comps:= 0; statistics[what-BUBBLE].moves:= 0
  statistics[what-BUBBLE].elems:= IF what=HEAP THEN maxlen ELSE maxlen+1
  IF what=HEAP THEN setpoint(0,adr[0],COLCLEAR)
  Eval(funcs[what-BUBBLE]); ResetMenuStrip(win,menus); DisplayBeep(0)
  IF break
    statistics[what-BUBBLE].comps:= 0; statistics[what-BUBBLE].moves:= 0
    statistics[what-BUBBLE].elems:= 0; ENDIF
  OffGadget(bexit,win,0); OffGadget(bstop,win,0)
  IF immediate THEN show_statistics()
ENDPROC

PROC complete_array()
DEF x,y,x1,x2,a
  clearinfo(); displayinfo(getstr(ARRAYCOMPLETE_L),0)
  FOR x:= 0 TO maxlen-1
    IF adr[x1:= x]<>freeinitvalue
      FOR y:=x+1 TO maxlen DO IF adr[x2:=y]<>freeinitvalue THEN y:= maxlen+1
      IF adr[x2]=freeinitvalue THEN RETURN
      a:= SpDiv(SpFlt(x2-x1),SpFlt(adr[x2]-adr[x1]))
      FOR y:=x1 TO x2
        setpoint(y,adr[y],0); adr[y]:= adr[x1]+SpFix(SpMul(SpFlt(y-x1),a))
        setpoint(y,adr[y],1)
      ENDFOR
      x:= x2-1
    ENDIF
  ENDFOR
ENDPROC
/*-----------------------------------------------------------------------------*/
PROC bubble(von,bis,adr:PTR TO INT) HANDLE
DEF fertig, pos,loop=1,x
  x:= getstr(BUBBLEW_L)
  REPEAT
    fertig:= TRUE; displayinfo(x,[loop++])
    FOR pos:= von TO bis-1
      checkbreak()
      statistics[BUBBLE-BUBBLE].comps:= statistics[BUBBLE-BUBBLE].comps+1
      IF adr[pos] > adr[pos+1]
        swapentries (adr,pos,pos+1); fertig:=FALSE
        statistics[BUBBLE-BUBBLE].moves:= statistics[BUBBLE-BUBBLE].moves+2
      ENDIF
    ENDFOR
  UNTIL fertig
EXCEPT; break:= TRUE; ENDPROC
/*-----------------------------------------------------------------------------*/
PROC shake (von,bis,adr:PTR TO INT) HANDLE
DEF links, rechts, i, position,loop=1,x
  position:= links:= von; rechts:= bis - 1; /*x:= getstr(SHAKEW_L)*/
  WHILE links <= rechts
    /*displayinfo(x,[links,rechts,loop++])*/
    FOR i := links TO rechts
      checkbreak()
      statistics[SHAKE-BUBBLE].comps:= statistics[SHAKE-BUBBLE].comps+1
      IF adr[i] > adr[i+1]
        swapentries (adr,i,position:=i+1)
        statistics[SHAKE-BUBBLE].moves:= statistics[SHAKE-BUBBLE].moves+2
      ENDIF
    ENDFOR
    rechts := position - 1
    FOR i:= rechts TO links STEP -1
      checkbreak()
      statistics[SHAKE-BUBBLE].comps:= statistics[SHAKE-BUBBLE].comps+1
      IF adr[i] > adr[i+1]
        swapentries (adr,position:=i,i+1)
        statistics[SHAKE-BUBBLE].moves:= statistics[SHAKE-BUBBLE].moves+2
      ENDIF
    ENDFOR
    links := position + 1
  ENDWHILE
EXCEPT; break:= TRUE; ENDPROC
/*-----------------------------------------------------------------------------*/
PROC insert(von,bis,adr:PTR TO INT) HANDLE
DEF j,i
  FOR i:= von+1 TO bis
    FOR j:= i TO von+1 STEP -1
      checkbreak()
      statistics[INSERT-BUBBLE].comps:= statistics[INSERT-BUBBLE].comps+1
      IF adr[j-1] > adr [j]
        swapentries (adr,j-1,j)
        statistics[INSERT-BUBBLE].moves:= statistics[INSERT-BUBBLE].moves+2
      ELSE; j:= von
      ENDIF
    ENDFOR
  ENDFOR
EXCEPT; break:= TRUE; ENDPROC
/*-----------------------------------------------------------------------------*/
PROC selsort(von,bis,adr:PTR TO INT) HANDLE
DEF min,x,y
  min:= von
  FOR x:= von+1 TO bis DO IF adr[x]<adr[min] THEN min:= x
  swapentries(adr,min,von)
  FOR y:= von+1 TO bis-1
    min:=y; checkbreak()
    FOR x:=y+1 TO bis
      IF adr[x] <= adr[min]
        min:= x; statistics[SEL-BUBBLE].comps:= statistics[SEL-BUBBLE].comps+2
        IF adr[min]=adr[y-1] THEN x:= bis
      ENDIF
    ENDFOR
    statistics[SEL-BUBBLE].moves:= statistics[SEL-BUBBLE].moves+2
    swapentries (adr,y,min)
  ENDFOR
EXCEPT; break:= TRUE; ENDPROC
/*-----------------------------------------------------------------------------*/
PROC shell(von,bis,adr:PTR TO INT) HANDLE
DEF i,j,incr,weiter,term= TRUE
  incr:= (bis-von)/3   /* Knut's recommendation */
  WHILE incr
    FOR i:= incr+1 TO bis
      j:= i-incr; weiter:= TRUE
      WHILE (j>=von) AND weiter
        checkbreak()
        statistics[SHELL-BUBBLE].comps:= statistics[SHELL-BUBBLE].comps+1
        IF adr[j] > adr[j+incr]
          statistics[SHELL-BUBBLE].moves:= statistics[SHELL-BUBBLE].moves+2
          swapentries (adr,j,j+incr); j:= j-incr
        ELSE; weiter:= FALSE; ENDIF
      ENDWHILE
    ENDFOR
    IF (incr:= (incr-1)/3)=0  /* ensure that incr becomes at least */
      IF term; term:= FALSE; incr:= 1; ENDIF /* one time 1 */
    ELSE; IF incr=1 THEN term:= FALSE; ENDIF
  ENDWHILE
EXCEPT; break:= TRUE; ENDPROC
/*-----------------------------------------------------------------------------*/
PROC merge (von,bis,adr:PTR TO INT) HANDLE
DEF hilf:PTR TO INT
  hilf:= New(Shl(bis-von+2,1))
  IF hilf; sort1 (adr, von, bis, hilf); Dispose(hilf)
  ELSE;    printerrmsg(getstr(LOWMEM_L),0); ENDIF
EXCEPT; Dispose(hilf); break:= TRUE; ENDPROC

PROC mergesort1 (inp:PTR TO INT,von1, bis1,von2,bis2,out:PTR TO INT)
DEF i1, i2, j
  j:= i1 := von1; i2 := von2; checkbreak()
  WHILE (i1 <= bis1) AND (i2 <= bis2)
    checkbreak()
    statistics[MERGE-BUBBLE].comps:= statistics[MERGE-BUBBLE].comps+1
    IF inp[i1] <= inp[i2]
      setpoint(i1,inp[i1],COLCLEAR); setpoint(j,inp[i1],COLSET)
      out[j++] := inp[i1++]
      statistics[MERGE-BUBBLE].moves:= statistics[MERGE-BUBBLE].moves+1
    ELSE
      setpoint(i2,inp[i2],COLCLEAR); setpoint(j,inp[i2],COLSET)
      out[j++] := inp[i2++]
      statistics[MERGE-BUBBLE].moves:= statistics[MERGE-BUBBLE].moves+1
    ENDIF
  ENDWHILE
  WHILE i1 <= bis1
    checkbreak()
    setpoint(i1,inp[i1],COLCLEAR); setpoint(j,inp[i1],COLSET)
    out[j++] := inp[i1++]
    statistics[MERGE-BUBBLE].moves:= statistics[MERGE-BUBBLE].moves+1
  ENDWHILE
  WHILE i2 <= bis2
    checkbreak()
    setpoint(i2,inp[i2],COLCLEAR); setpoint(j,inp[i2],COLSET)
    out[j++] := inp[i2++]
    statistics[MERGE-BUBBLE].moves:= statistics[MERGE-BUBBLE].moves+1
  ENDWHILE
ENDPROC

PROC sort1 (unsort_vekt:PTR TO INT,von,bis,hilf:PTR TO INT)
DEF split, x1, x2,i
  IF (bis-von) > 0
    split := Shr((bis-von),1); x1 := von + split; x2 := x1 + 1
    sort2 (unsort_vekt, von, x1, hilf)
    sort2 (unsort_vekt, x2, bis, hilf)
    mergesort1 (unsort_vekt, von, x1, x2, bis, hilf)
    FOR i:= von TO bis
      checkbreak(); unsort_vekt[i]:= hilf[i]
    ENDFOR
    statistics[MERGE-BUBBLE].moves:= statistics[MERGE-BUBBLE].moves+bis-von+1
  ELSE
    hilf[von] := unsort_vekt[von]
    statistics[MERGE-BUBBLE].moves:= statistics[MERGE-BUBBLE].moves+1
  ENDIF
ENDPROC

PROC sort2 (unsort_vekt:PTR TO INT,von, bis,hilf:PTR TO INT)
DEF split, x1, x2
  IF (bis-von) > 0
    split := Shr((bis-von),1); x1 := von + split; x2 := x1 + 1
    sort1 (unsort_vekt, von, x1, hilf)
    sort1 (unsort_vekt, x2, bis, hilf)
    mergesort1 (hilf, von, x1, x2, bis, unsort_vekt)
  ENDIF
ENDPROC
/*-----------------------------------------------------------------------------*/
PROC quick(von,bis,adr:PTR TO INT) HANDLE
  qsort(von,bis,adr)
EXCEPT; break:= TRUE; ENDPROC

PROC qsort(l, r, a:PTR TO INT)
DEF i, j, x
  i := l; j := r; x := a[Shr((l+r),1)]
  REPEAT
    checkbreak()
    WHILE a[i++] < x DO statistics[QUICK-BUBBLE].comps:= statistics[QUICK-BUBBLE].comps+1
    WHILE x < a[j]
      DEC j; statistics[QUICK-BUBBLE].comps:= statistics[QUICK-BUBBLE].comps+1
    ENDWHILE
    IF i-- <= j
      statistics[QUICK-BUBBLE].moves:= statistics[QUICK-BUBBLE].moves+1
      swapentries(a,i++,j); DEC j
    ENDIF
  UNTIL i > j
  IF l < j THEN qsort(l, j,a)
  IF i < r THEN qsort(i, r,a)
ENDPROC
/*-----------------------------------------------------------------------------*/
PROC heap(von,bis,adr:PTR TO INT) HANDLE
DEF i,x
  x:= Shr(bis,1)
  FOR i:= x TO von STEP -1
    checkbreak(); reheap (i,bis,adr)
  ENDFOR
  FOR i:= bis TO von+1 STEP -1
    checkbreak(); statistics[HEAP-BUBBLE].moves:= statistics[HEAP-BUBBLE].moves+2
    swapentries (adr,von,i); reheap (von,i-1,adr)
  ENDFOR
EXCEPT; break:= TRUE; ENDPROC

PROC reheap (i,k,adr:PTR TO INT)
DEF j,son,x
  j:= i
  LOOP
    checkbreak()
    IF (x:=Shl(j,1))  > k THEN RETURN
    IF (x+1)         <= k
      statistics[HEAP-BUBBLE].comps:= statistics[HEAP-BUBBLE].comps+1
      IF adr[x] >= adr[x+1] THEN son:= x ELSE son:= x+1
    ELSE; son:= x; ENDIF
    statistics[HEAP-BUBBLE].comps:= statistics[HEAP-BUBBLE].comps+1
    IF adr[j] <= adr[son]
      swapentries (adr,j,son); j:= son
      statistics[HEAP-BUBBLE].moves:= statistics[HEAP-BUBBLE].moves+2
    ELSE; RETURN; ENDIF
  ENDLOOP
ENDPROC
/*-----------------------------------------------------------------------------*/

PROC swapentries(adr:PTR TO INT,i,j)
DEF x
  setpoint(i,adr[i],COLCLEAR); setpoint(j,adr[j],COLCLEAR)
  setpoint(i,adr[j],COLSET);   setpoint(j,adr[i],COLSET)
  x:= adr[i]; adr[i]:= adr[j]; adr[j]:=x
ENDPROC

PROC createarray()
DEF x,anstieg,rndadr:PTR TO INT,y,a,b,rndptr,temp
  IF adr THEN Dispose(adr); adr:= New(Shl(maxlen+1,1))
  IF adr
    clearinfo(); displayinfo(getstr(ARRAYCREATE_L),0)
    SetAPen(win.rport,0); RectFill(win.rport,recleft-2,rectop-1,maxlen+3,recheight+rectop+1)
    IF random= FALSE
      anstieg:= SpDiv(SpFlt(maxlen),SpFlt(recheight))
      IF ascending
        FOR x:= 0 TO maxlen
          adr[x]:= SpFix(SpMul(SpFlt(x),anstieg)); setpoint(x,adr[x],1)
        ENDFOR
      ELSE
        FOR x:= 0 TO maxlen
          adr[x]:= SpFix(SpMul(SpFlt(maxlen+1-x),anstieg)); setpoint(x,adr[x],1)
        ENDFOR
      ENDIF
      rndadr:= New(Shl(maxlen+1,1))
      IF rndadr
        y:= SpFix(SpMul(SpDiv(100.0,SpFlt(-maxlen)),SpFlt(degree)))+maxlen
        FOR x:=0 TO maxlen DO rndadr[x]:= 65535
        IF y<>1
          FOR x:=0 TO y
            rndptr:= a:= Rnd(maxlen)+1; b:= Rnd(maxlen)+1
            WHILE (rndadr[rndptr] <> 65535) AND (rndadr[rndptr] = a)
              INC rndptr; IF rndptr > maxlen THEN rndptr:= 0
            ENDWHILE
            rndadr[rndptr]:= a; a:= rndptr; rndptr:= b;
            WHILE (rndadr[rndptr] <> 65535) AND (rndadr[rndptr] = b)
              INC rndptr; IF rndptr > maxlen THEN rndptr:= 0;
            ENDWHILE
            rndadr[rndptr]:= b; b:= rndptr
            setpoint(a,adr[a],COLCLEAR); setpoint(b,adr[b],COLCLEAR)
            temp:= adr[a]; adr[a]:= adr[b]; adr[b]:= temp
            setpoint(a,adr[a],1); setpoint(b,adr[b],1)
          ENDFOR
        ENDIF
        Dispose(rndadr)
      ELSE
        printerrmsg(getstr(LOWMEM_L),0)
        SetAPen(win.rport,0); RectFill(win.rport,recleft,rectop,maxlen,recheight+rectop)
        FOR x:=0 TO maxlen
          adr[x]:= Rnd(recheight+1); setpoint(x,adr[x],1)
        ENDFOR
      ENDIF
    ELSE
      FOR x:=0 TO maxlen
        adr[x]:= Rnd(recheight+1); setpoint(x,adr[x],1)
      ENDFOR
    ENDIF
  ENDIF
ENDPROC

PROC clearinfo()
  SetAPen(win.rport,0)
  RectFill(win.rport,2,inforecty,scr.width-3,inforecty+textheight+1)
ENDPROC

PROC displayinfo(body,text)
DEF ziel[40]:ARRAY
  SetAPen(win.rport,1)
  RawDoFmt(body,text,{putproc},ziel); TextF(infox,infoy,ziel)
ENDPROC
putproc: MOVE.B D0,(A3)+; RTS

PROC setpoint(x,y,c)
  IF lines
    Line(recleft+x,Shr(recheight,1)+rectop+Shr(y,1),
         recleft+x,Shr(recheight,1)+rectop-Shr(y,1),c)
  ELSE; Plot(recleft+x,rectop+recheight-y,c); ENDIF
ENDPROC

PROC checkmxmenus(itemnumber,number,which)
DEF x,menu:PTR TO menuitem
  FOR x:= 0 TO number-1
    menu:= ItemAddress(menus,$20*x+itemnumber)
    IF (x+1)=which
      menu.flags:= menu.flags OR CHECKED
    ELSE; menu.flags:= menu.flags AND Not(CHECKED); ENDIF
  ENDFOR
ENDPROC

PROC show_statistics()
  IF reqtoolsbase
    RtEZRequestA(getstr(ALGSTATISTIK_L),getstr(OKBUTTON_L),0,statistics,
      [RT_WINDOW,win,RT_LOCKWINDOW,TRUE,RT_REQPOS,REQPOS_CENTERWIN,
       RT_UNDERSCORE,"_",RT_TEXTATTR,['topaz.font',8,0,0]:textattr,0])
  ENDIF
ENDPROC

PROC save_statistics(dir,filename) HANDLE
DEF tempdir[300]:ARRAY,filehandle=0,windowlock
  IF reqtoolsbase THEN windowlock:= RtLockWindow(win)
  StrCopy(tempdir,dir,ALL); AddPart(tempdir,filename,300)
  filehandle:=Open(tempdir,MODE_NEWFILE)
  VfPrintf(filehandle,getstr(ALGSTATISTIK_L),statistics)
  Flush(filehandle); Close(filehandle)
  IF reqtoolsbase THEN RtUnlockWindow(win,windowlock)
EXCEPT
  printerrmsg('DOS error: \d',IoErr())
  IF filehandle THEN Close(filehandle)
  IF reqtoolsbase THEN RtUnlockWindow(win,windowlock)
ENDPROC

PROC getstr(num)
ENDPROC IF catalog THEN GetCatalogStr(catalog,num,0) ELSE builtinlanguage[num]

PROC opengui(modeid,welcome)
DEF x,offy,delta,
    twidth, icht:PTR TO textfont,ichr:PTR TO rastport
    IF modeid=0
      modeid:= IF pscr:= LockPubScreen(0) THEN GetVPModeID(pscr.viewport) ELSE 0
    ENDIF
  scr:=OpenScreenTagList(0,
        [SA_TITLE,      getstr(SCREENTITLE_L),
         SA_PUBNAME,    'VisualSort Screen',
         SA_PENS,       [$ffff]:INT,
         SA_FONT,       IF modeid THEN font:= pscr.font ELSE font:= ['topaz.font',8,0,0]:textattr,
         SA_FULLPALETTE,TRUE,
         SA_DEPTH,      2,
         SA_DISPLAYID,  modeid,
         SA_TYPE,       CUSTOMSCREEN,0])
  PubScreenStatus(scr,0); visual:=GetVisualInfoA(scr,NIL)
  LayoutMenusA(menus:=CreateMenusA([1,0,getstr(PROG_L),0,0,0,0,
                        2,0,(x:= getstr(SAVE_L))+2,IF x[] THEN x ELSE 0,IF filereq THEN 0 ELSE 16,0,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(ABOUT_L))+2,IF x[] THEN x ELSE 0,IF reqtoolsbase THEN 0 ELSE 16,0,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(QUIT_L))+2,IF x[] THEN x ELSE 0,0,0,0,
                        1,0,getstr(ALG_L),0,0,0,0,
                        2,0,(x:=getstr(BUBBLE_L))+2,IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(SHAKE_L))+2, IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(INSERT_L))+2,IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(SELECT_L))+2,IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(SHELL_L))+2, IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(MERGE_L))+2, IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(QUICK_L))+2, IF x[] THEN x ELSE 0,0,0,0,
                        2,0,(x:=getstr(HEAP_L))+2,  IF x[] THEN x ELSE 0,0,0,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(STATISTIK_L))+2,IF x[] THEN x ELSE 0,IF reqtoolsbase THEN 0 ELSE 16,0,0,
                        1,0,getstr(SETUP_L),0,0,0,0,
                        2,0,(x:=getstr(SCR_L))+2,IF x[] THEN x ELSE 0,IF screenmodereq THEN 0 ELSE 16,0,0,
                        2,0,(x:=getstr(DEGREE_L))+2,IF x[] THEN x ELSE 0,IF reqtoolsbase  THEN 0 ELSE 16,0,0,
                        2,0,(x:=getstr(FREEINIT_L))+2,IF x[] THEN x ELSE 0,IF reqtoolsbase THEN 0 ELSE 16,0,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(POINTS_L))+2,IF x[] THEN x ELSE 0,IF lines THEN 1    ELSE $101,32,0,
                        2,0,(x:=getstr(LINES_L))+2, IF x[] THEN x ELSE 0,IF lines THEN $101 ELSE 1   ,16,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(RAND_L))+2,IF x[] THEN x ELSE 0, IF random THEN $101 ELSE 1,256+512+1024,0,
                        2,0,(x:=getstr(ASC_L))+2, IF x[] THEN x ELSE 0, IF random=FALSE   AND ascending THEN $101 ELSE 1,128+1024+512, 0,
                        2,0,(x:=getstr(DES_L))+2, IF x[] THEN x ELSE 0, IF (random=FALSE) AND (ascending=FALSE) AND (freehand=FALSE) THEN $101 ELSE 1,128+256+1024,0,
                        2,0,(x:=getstr(FREEHAND_L))+2,IF x[] THEN x ELSE 0,IF freehand THEN $109 ELSE 9,512+128+256,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(COMPLETE_L))+2,IF x[] THEN x ELSE 0,IF complete THEN $109 ELSE 9,0,0,
                        2,0,-1,0,0,0,0,
                        2,0,(x:=getstr(IMM_L))+2,IF x[] THEN x ELSE 0,IF immediate THEN $109 ELSE 9,0,0,
                        0]:newmenu,NIL),visual,[GTMN_NEWLOOKMENUS,1,0])

  twidth:= TextLength(ichr:= scr.rastport,x:=getstr(STOPBUTTON_L),StrLen(x))
  IF (delta:= TextLength(ichr,x:=getstr(BREAKBUTTON_L),StrLen(x)))>twidth THEN twidth:= delta

  icht:= ichr.font; textheight:= icht.ysize
  offy:= scr.height-(textheight+6)
  
  bstop:= CreateGadgetA(BUTTON_KIND,CreateContext({glist}),
    [scr.width-twidth,offy,twidth,textheight+6,
     getstr(STOPBUTTON_L),font,0,16,visual,0]:newgadget,
    [GA_DISABLED,TRUE,GT_UNDERSCORE,"_",0])
  bstop.activation:= bstop.activation OR GACT_TOGGLESELECT; delta:= twidth+twidth
  
  bexit:=CreateGadgetA(BUTTON_KIND,bstop,
    [scr.width-delta,offy,twidth,textheight+6,
     getstr(BREAKBUTTON_L),font,1,16,visual,0]:newgadget,
    [GA_DISABLED,TRUE,GT_UNDERSCORE,"_",0])

  scroller:=CreateGadgetA(SCROLLER_KIND,bexit,
    [0,offy,scr.width-delta,textheight+6,
     font,NIL,2,0,visual,0]:newgadget,
    [GA_RELVERIFY,1,
     GTSC_TOTAL,128,
     GTSC_VISIBLE,1,
     GA_DISABLED,1,NIL])

  win:=OpenWindowTagList(0,
        [WA_FLAGS,       WFLG_ACTIVATE+WFLG_SMART_REFRESH+WFLG_BACKDROP+
                         WFLG_BORDERLESS+WFLG_NEWLOOKMENUS,
         WA_IDCMP,       IDCMP_RAWKEY+IDCMP_GADGETUP+IDCMP_MENUPICK+
                         IDCMP_MOUSEBUTTONS,
         WA_CUSTOMSCREEN,scr,
         WA_GADGETS,     glist,0])

  DrawBevelBoxA(stdrast:=win.rport,
    0,inforecty:= offy:=offy-(textheight+6),scr.width,textheight+6,
    [GT_VISUALINFO,visual,NIL]); INC inforecty

    infox:= 5
    infoy:= offy+icht.baseline+3
    offy:= offy-scr.barheight-1

  DrawBevelBoxA(win.rport,0,x:=scr.barheight+1,scr.width,offy,
    [GT_VISUALINFO,visual,NIL])

  displayinfo(welcome,0)
  rectop:= x+2; recleft:=3; recheight:= offy-5; maxlen:= scr.width-8
  IF freeinitvalue>recheight
    freeinitvalue:= 0; printerrmsg(getstr(SETFREETOZERO_L),0); ENDIF

  SetMenuStrip(win,menus); Gt_RefreshWindow(win,NIL)
ENDPROC

PROC openlibs()
  IF localebase:= OpenLibrary('locale.library',0)
    catalog:= OpenCatalogA(0,'VisualSort.catalog',0)
  ENDIF
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=0
    printerrmsg(getstr(NEEDGADTOOLS_L),0); Raise(SCHLEIF)
  ENDIF
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=0
    printerrmsg(getstr(NEEDREQTOOLS_L),0)
  ELSE
    IF (screenmodereq:=RtAllocRequestA(RT_SCREENMODEREQ,0))=0
      printerrmsg(getstr(ERRSCRMODESTRUCT_L),0)
    ENDIF
    IF (filereq:= RtAllocRequestA(RT_FILEREQ,0))=0
      printerrmsg(getstr(ERRFILEREQSTRUCT_L),0)
    ENDIF; ENDIF
  IF (keymapbase:= OpenLibrary('keymap.library',0))=0
    printerrmsg(getstr(KEYMAP_L),0); Raise(SCHLEIF); ENDIF
  IF FindPort('VISUALSORT'); printerrmsg(getstr(SECONDCOPY_L),0); Raise(SCHLEIF); ENDIF
  IF rexxport:=CreateMsgPort()
    lptr:=rexxport.ln; lptr.name:='VISUALSORT'; lptr.pri:= 0
    AddPort(rexxport)
  ELSE; printerrmsg(getstr(ERRMSGPORT_L),0); ENDIF
ENDPROC

PROC initdatas()
DEF x
  FOR x:= 0 TO HEAP-BUBBLE
    statistics[x].moves:= 0; statistics[x].comps:= 0; statistics[x].elems:= 0
  ENDFOR
  rexxkeywords:=[x:= 'dummy',     STRLEN,'QUIT',      STRLEN,'BUBBLESORT',STRLEN,'SHAKESORT', STRLEN,
    'INSERTSORT',STRLEN,'SELECTSORT',STRLEN,'SHELLSORT' ,STRLEN,'MERGESORT', STRLEN,
    'QUICKSORT', STRLEN,'HEAPSORT',  STRLEN,'SCREENMODE',STRLEN, x,5,x,5,
    'POINTS',    STRLEN,'LINES',     STRLEN,'RANDOMIZE', STRLEN,'ASCENDING', STRLEN,
    'DESCENDING',STRLEN,'DEGREE ',   STRLEN,'STATISTICS',STRLEN,'IMMEDIATE ',STRLEN,
    'SAVESTATISTICS ',STRLEN,'FREEHAND',STRLEN,'COMPLETE ',STRLEN,
    'FREEINITVALUE ', STRLEN,'POPUP',     STRLEN,'POPBACK',  STRLEN,
    '',0]:rexxobj
  funcs:= [`bubble(0,maxlen,adr),`shake  (0,maxlen,adr),
           `insert(0,maxlen,adr),`selsort(0,maxlen,adr),
           `shell (0,maxlen,adr),`merge  (0,maxlen,adr),
           `quick (0,maxlen,adr),`heap   (1,maxlen,adr)]
  builtinlanguage:=  ['Project',
                        'W\0Save Statistics...','?\0About...','Q\0Quit',
                      'Algorithms',
                        'B\0BubbleSort','A\0ShakeSort','I\0InsertSort',
                        'C\0SelectSort','L\0ShellSort','M\0MergeSort',
                        'K\0QuickSort','H\0HeapSort','S\0Statistics...',
                      'Setup',
                        '\0\0Screenmode...','O\0Degree...',
                        '*\0Freehand init value...','P\0Points',
                        'N\0Lines','R\0random',
                        '+\0ascending','-\0descending','F\0freehand',
                        'U\0Complete empty parts','Y\0Statistics immediately',
      'Welcome to VisualSort v1.15',
      'creating array...','completing array...',' Brekkies',' *** stopped',
      ' \d[5]th loop  ',' \d[5] left, \d[5] right, \d[5]th loop  ',
      'nice screenmode :-)',
      'draw with left, leave with right mousebutton',
      '\d[5]th element',
      '  Br_eak  ','  St_op  ',
      'choose Filename...','choose Screenmode...',
      'Enter degree...','Enter init value...',
      'VisualSort v1.15 ©1994 by Nico Max',
      '--- VisualSort v1.15 ---\n'+
        '(C) Copyright 1994 by Nico Max\n\n'+
        'Written using..\n\n'+
        'Wouter van Oortmerssen\as Amiga_E v2.1b\n\n'+
        'GUI created using GadToolsBox v2.0b (C) Jaba Development\n'+
        'reqtools.library (C) Copyright by Nico François',
        'This program is Public Domain!. This means that you can\n'+
        'copy it for free but all Copyrights remain to the author!\n\n'+
        'for remarks or if you find bugs (or for sending donatins :-)\n'+
        'please write to:\n\nNico Max\nGerüstbauerring 15\n18109 Rostock\n'+
        'Germany\n\nor email: max@informatik.uni-rostock.de\n\n'+
        'free chip:\d[9], free fast:\d[9]','_More|_Continue',' _Ok ',
   'Algorithm         Moves    Compares Elems\n'+
   '-----------------------------------------\n'+
   'BubbleSort   \d[10]  \d[10] \d[5]\n'+
   'ShakeSort    \d[10]  \d[10] \d[5]\n'+
   'InsertSort   \d[10]  \d[10] \d[5]\n'+
   'SelectSort   \d[10]  \d[10] \d[5]\n'+
   'ShellSort    \d[10]  \d[10] \d[5]\n'+
   'MergeSort    \d[10]  \d[10] \d[5]\n'+
   'QuickSort    \d[10]  \d[10] \d[5]\n'+
   'HeapSort     \d[10]  \d[10] \d[5]\n',
   'Couldn\at \s!',
     'lock publicscreen','open screen','open window',
     'get ModeID','get visualinfo','get context','create gadget',
     'create menus','open file','write',
   'Decide, what you want!\n','0 <= degree <= 100\n',
   'choose: ascending or descending\n','which degree?\n',
   'Out of memory!\nChoose a lower resolution!',
   'DEGREE: must be >= 0 and <= 100','\s: numeric value expected!',
   '\s: Need keyword (ON/OFF)!','\s: Filename needed!',
   'FREEHANDVALUE: must be >= 0 and <= \d!','\s: only ON/OFF!',
   '\s: Unknown command!','Freeinitvalue set to zero!',
   'Need gadtools.library >=v37!','No reqtools.library >=v38 found!\nSeveral menuitems may be unreachable!',
   'Couldn\at allocate Screenmoderequesterstructure','Couldn\at allocate Filerequesterstructure',
   'Need keymap.library!','There\as still another copy of VisualSort active!',
   'Couldn\at allocate Messageport!','Please close all windows!']
ENDPROC

PROC closelibs()
  IF catalog       THEN CloseCatalog(catalog)
  IF localebase    THEN CloseLibrary(localebase)
  IF screenmodereq THEN RtFreeRequest(screenmodereq)
  IF filereq;           RtFreeReqBuffer(filereq); RtFreeRequest(filereq); ENDIF
  IF keymapbase    THEN CloseLibrary(keymapbase)
  IF reqtoolsbase  THEN CloseLibrary(reqtoolsbase)
  IF gadtoolsbase  THEN CloseLibrary(gadtoolsbase)
  IF rexxport;          RemPort(rexxport); DeleteMsgPort(rexxport); ENDIF
ENDPROC

PROC closegui()
  IF visual; FreeVisualInfo(visual);                visual:= 0; ENDIF
  IF menus;  ClearMenuStrip(win); FreeMenus(menus); menus := 0; ENDIF
  IF win;    CloseWindow(win);                      win   := 0; ENDIF
  IF glist;  FreeGadgets(glist);                    glist := 0; ENDIF
  IF scr;    WHILE CloseScreen(scr)=0 DO printerrmsg(getstr(CLOSESCR),0); scr:= 0; ENDIF
  IF pscr;   UnlockPubScreen(0,pscr);                           ENDIF
  IF adr;    Dispose(adr);                          adr   := 0; ENDIF
  msgmenucode:= MENUNULL
ENDPROC

PROC printerrmsg(string,bodyfmt)
  EasyRequestArgs(win,[20,0,0,string,' Ok ']:easystruct,0,bodyfmt)
ENDPROC

CHAR '$VER: VisualSort 1.15 (3.30.94)'