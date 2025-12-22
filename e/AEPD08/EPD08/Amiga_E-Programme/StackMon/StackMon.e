/*************************/
/*			 */
/*  StackMon v1.0	 */
/*  © 1993 David Kinder  */
/*			 */
/*  Written with AmigaE  */
/*			 */
/*************************/

OPT OSVERSION = 37

MODULE 'dos/dosextens',
       'exec/execbase','exec/lists','exec/nodes','exec/tasks',
       'gadtools','libraries/gadtools',
       'graphics/text',
       'intuition/intuition','intuition/screens',
       'utility/tagitem'

OBJECT mynode
  succ : LONG
  pred : LONG
  type : CHAR
  pri : CHAR
  name : LONG
  ptr : LONG
ENDOBJECT

ENUM NONE,ER_GAD,ER_SCR,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW

DEF scr : PTR TO screen,
    wnd : PTR TO window,
    listv : PTR TO lh,
    currtask : PTR TO tc,
    exec : PTR TO execbase,
    offset,visual,glist,gadg,stk,max,size,mypri,
    version

PROC main() HANDLE
  version := '$VER: StackMon 1.0 (6.9.93)'
  changepri()
  openwin()
  handlemsg()
  Raise(NONE)
EXCEPT
  closewin()
  IF exception > 0 THEN error(ListItem(['','open gadtools.library',
    'find screen','get visual info','create context','create gadget',
    'open window'],exception))
ENDPROC

PROC openwin()
  DEF font : PTR TO textattr

  exec := execbase
  IF (gadtoolsbase := OpenLibrary('gadtools.library',37)) = NIL THEN
    Raise(ER_GAD)
  IF (scr := LockPubScreen(NIL)) = NIL THEN Raise(ER_SCR)
  font := scr.font
  offset := font.ysize
  IF (visual := GetVisualInfoA(scr,NIL)) = NIL THEN Raise(ER_VISUAL)
  IF (gadg := CreateContext({glist})) = NIL THEN Raise(ER_CONTEXT)

  listv := [0,0,0,0,0]:lh
  listv.head := listv+4; listv.tail := 0; listv.tailpred := listv

  gettasks()
  font := ['topaz.font',8,0,0]:textattr

  IF (gadg := CreateGadgetA(BUTTON_KIND,gadg,
    [12,offset+127,64,14,'_About',font,2,PLACETEXT_IN,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",TAG_DONE])) = NIL THEN Raise(ER_GADGET)
  IF (gadg := CreateGadgetA(BUTTON_KIND,gadg,
    [206,offset+127,64,14,'_Cancel',font,3,PLACETEXT_IN,visual,
     0]:newgadget,[GT_UNDERSCORE,"_",TAG_DONE])) = NIL THEN Raise(ER_GADGET)
  IF (gadg := CreateGadgetA(BUTTON_KIND,gadg,
    [87,offset+127,108,14,'_Update list',font,4,PLACETEXT_IN,visual,
     0]:newgadget,[GT_UNDERSCORE,"_",TAG_DONE])) = NIL THEN Raise(ER_GADGET)
  IF (gadg := CreateGadgetA(LISTVIEW_KIND,gadg,
    [12,offset+55,258,72,NIL,font,1,0,visual,0]:newgadget,[GTLV_SCROLLWIDTH,
     18,GTLV_LABELS,listv,TAG_DONE])) = NIL THEN Raise(ER_GADGET)

  IF (wnd := OpenWindowTagList(NIL,
   [WA_LEFT,100,
    WA_TOP,30,
    WA_WIDTH,282,
    WA_HEIGHT,offset+147,
    WA_GADGETS,glist,
    WA_IDCMP,IDCMP_CLOSEWINDOW+IDCMP_VANILLAKEY+IDCMP_CHANGEWINDOW+
      LISTVIEWIDCMP,
    WA_FLAGS,WFLG_DRAGBAR+WFLG_DEPTHGADGET+WFLG_CLOSEGADGET+WFLG_ACTIVATE+
      WFLG_RMBTRAP,
    WA_PUBSCREEN,scr,
    WA_SCREENTITLE,'StackMon v1.0',
    WA_TITLE,'StackMon v1.0',
    WA_ZOOM,[0,offset+55+Mul(282,65536)],
    TAG_DONE])) = NIL THEN Raise(ER_WINDOW)

  SetStdRast(wnd.rport)
  SetTopaz(8)
  Gt_RefreshWindow(wnd,NIL)
  DrawBevelBoxA(wnd.rport,12,offset+18,258,12,
    [GT_VISUALINFO,visual,GTBB_RECESSED,TRUE,TAG_DONE])
  Colour(1,0)
  TextF(12,offset+13,'Monitoring:')
  TextF(12,offset+40,'Current:')
  TextF(141,offset+40,'Stack:')
  TextF(12,offset+50, 'Largest:')
ENDPROC

PROC closewin()
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF glist THEN FreeGadgets(glist)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  SetTaskPri(FindTask(NIL),mypri)
ENDPROC

PROC handlemsg()
  DEF msg : PTR TO intuimessage,
      addr : PTR TO gadget,
      class,code,id

  WHILE TRUE
    getinfo()
    Delay(10)
    REPEAT
      msg := Gt_GetIMsg(wnd.userport)
      class := msg.class
      code := msg.code
      addr := msg.iaddress
      Gt_ReplyIMsg(msg)

      IF class = IDCMP_CLOSEWINDOW THEN Raise(NONE)
      IF class = IDCMP_CHANGEWINDOW
        Gt_BeginRefresh(wnd)
	Gt_RefreshWindow(wnd,NIL)
        Gt_EndRefresh(wnd,TRUE)
      ENDIF
      IF class = IDCMP_GADGETUP
	id := addr.gadgetid
	SELECT id
	  CASE 1
	    startmon(code)
	  CASE 2
	    about()
	  CASE 3
	    cancel()
	  CASE 4
	    update()
	ENDSELECT
      ENDIF
      IF class = IDCMP_VANILLAKEY
	SELECT code
	  CASE "a"
	    about()
	  CASE "c"
	    cancel()
	  CASE "u"
	    update()
	ENDSELECT
      ENDIF

    UNTIL msg = NIL
  ENDWHILE
ENDPROC

PROC about()
  request('StackMon v1.0\n© 1993 David Kinder\n\n"Rise and reverberate"',
    'Continue')
ENDPROC

PROC request(body,gadgets)
  EasyRequestArgs(0,[SIZEOF easystruct,0,'StackMon',body,gadgets],0,NIL)
ENDPROC

PROC gettasks()
  DEF list : PTR TO lh

  Forbid()
  Disable()
  list := exec.taskwait
  scanlist(list.head)
  list := exec.taskready
  scanlist(list.head)
  Enable()
  Permit()
ENDPROC

PROC scanlist(pr : PTR TO process)
  DEF node : PTR TO ln,
      cli : PTR TO commandlineinterface,
      name[128] : STRING,
      len 

  node := pr
  WHILE node.succ <> NIL
    IF node.type = NT_PROCESS
      IF (cli := Mul(pr.cli,4)) = 0 
        addtolist(node.name,pr,TRUE)
      ELSE
	IF cli.module = 0
	  addtolist(node.name,pr,TRUE)
	ELSE
          len := Char(Mul(cli.commandname,4))
          StrCopy(name,Mul(cli.commandname,4)+1,len)
          addtolist(name,pr,TRUE)
	ENDIF
      ENDIF
    ENDIF
    IF node.type = NT_TASK THEN addtolist(node.name,pr,FALSE)
    pr := node.succ
    node := pr
  ENDWHILE
ENDPROC

PROC addtolist(name,task,process)
  DEF mem : PTR TO mynode

  mem := New(SIZEOF mynode)
  IF mem <> NIL
    mem.name := String(StrLen(name))
    IF mem.name <> NIL THEN StrCopy(mem.name,name,ALL)
    mem.ptr := task
    IF process = TRUE THEN mem.pri := 1
    Enqueue(listv,mem)
  ENDIF
ENDPROC

PROC freelist()
  DEF mem : PTR TO mynode

  WHILE (mem := RemHead(listv)) <> NIL
    IF mem.name <> NIL THEN DisposeLink(mem.name)
    Dispose(mem)
  ENDWHILE
ENDPROC

PROC update()
  freelist()
  gettasks()
  Gt_SetGadgetAttrsA(gadg,wnd,NIL,[GTLV_LABELS,listv,TAG_DONE])
  Gt_RefreshWindow(wnd,NIL)
ENDPROC

PROC startmon(id)
  DEF pos : PTR TO mynode,
      list : PTR TO lh,
      status

  pos := listv.head
  WHILE id > 0
    pos := pos.succ
    id--
  ENDWHILE

  currtask := pos.ptr
  stk := 0
  TextF(100,offset+13,'                     ')
  TextF(189,offset+40,'        ')
  TextF(76,offset+40,'        ')
  TextF(76,offset+50,'        ')
  TextF(141,offset+50,'               ')

  status := FALSE
  list := exec.taskwait
  IF searchlist(list.head,currtask) = FALSE
    list := exec.taskready
    IF searchlist(list.head,currtask) = FALSE
      currtask := NIL
      Colour(2,0)
      TextF(141,offset+50,'Task Terminated')
      Colour(0,0)
      RectFill(wnd.rport,14,offset+19,267,offset+28)
    ELSE
      status := TRUE
    ENDIF
  ELSE
    status := TRUE
  ENDIF

  IF status = TRUE
    Forbid()
    size := currtask.spupper-currtask.splower
    max := currtask.spupper-currtask.spreg
    Permit()
    Colour(2,0)
    TextF(100,offset+13,'\s(0,21)',pos.name)
    TextF(189,offset+40,'\d',size)
    TextF(76,offset+50,'\d',max)
  ENDIF
ENDPROC

PROC cancel()
  currtask := NIL
  TextF(100,offset+13,'                     ')
  TextF(189,offset+40,'        ')
  TextF(76,offset+40,'        ')
  TextF(76,offset+50,'        ')
  TextF(141,offset+50,'               ')
  Colour(0,0)
  RectFill(wnd.rport,14,offset+19,267,offset+28)
ENDPROC

PROC getinfo()
  DEF list : PTR TO lh,
      newstk,gauge

  IF currtask <> NIL
    list := exec.taskwait
    IF searchlist(list.head,currtask) = FALSE
      list := exec.taskready
      IF searchlist(list.head,currtask) = FALSE
	currtask := NIL
	Colour(2,0)
	TextF(76,offset+40,'        ')
	TextF(141,offset+50,'Task Terminated')
      ENDIF
    ENDIF
  ENDIF

  IF currtask <> NIL
    Forbid()
    newstk := currtask.spupper-currtask.spreg
    Permit()

    IF stk <> newstk
      stk := newstk
      Colour(2,0)
      TextF(76,offset+40,'        ')
      TextF(76,offset+40,'\d',stk)
      IF stk > max
	max := stk
        Colour(2,0)
	TextF(76,offset+50,'        ')
	TextF(76,offset+50,'\d',max)
      ENDIF
      IF stk > size
	Colour(2,0)
	TextF(141,offset+50,'Stack Overflow')
      ENDIF
      gauge := Div(Mul(stk,254),size)
      IF gauge > 253 THEN gauge := 253
      IF gauge > 0
	Colour(3,0)
	RectFill(wnd.rport,14,offset+19,gauge+14,offset+28)
      ENDIF
      IF gauge < 253
	Colour(0,0)
	RectFill(wnd.rport,gauge+15,offset+19,267,offset+28)
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC searchlist(pr : PTR TO ln,lookfor)
  DEF rval

  Forbid()
  Disable()
  rval := FALSE
  WHILE pr.succ <> NIL
    IF pr = lookfor THEN rval := TRUE
    pr := pr.succ
  ENDWHILE
  Enable()
  Permit()
ENDPROC rval

PROC changepri()
  DEF mypr : PTR TO ln

  mypr := FindTask(NIL)
  mypri := mypr.pri
  IF mypri < 1 THEN SetTaskPri(mypr,1)
ENDPROC

PROC error(errstring)
  DEF str[60] : STRING

  IF stdout = NIL
    StrCopy(str,'Could not ',ALL)
    StrAdd(str,errstring,ALL)
    request(str,'Abort')
  ELSE
    WriteF('Could not \s\n',errstring)
  ENDIF
ENDPROC
