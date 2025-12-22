/**************************/
/*			  */
/* StackMon v1.31	  */
/* © 1993-96 David Kinder */
/*			  */
/* Written with AmigaE	  */
/*			  */
/**************************/

OPT OSVERSION = 37

MODULE 'dos/dosextens',
       'exec/execbase','exec/libraries','exec/lists',
       'exec/nodes','exec/tasks',
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
    strinfo : PTR TO stringinfo,
    str : PTR TO gadget,
    name[128] : STRING,
    offset,visual,glist,gadg,stk,max,size,mypri,
    version

PROC main() HANDLE
  version := '$VER: StackMon 1.31 (21.1.96)'
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
  DEF font : PTR TO textattr,
      execlib : PTR TO lib,
      high,wbor

  exec := execbase
  execlib := exec
  high := 80
  IF execlib.version = 39 THEN high := high+6

  StrCopy(name,'',ALL)
  IF (gadtoolsbase := OpenLibrary('gadtools.library',37)) = NIL THEN
    Raise(ER_GAD)
  IF (scr := LockPubScreen(NIL)) = NIL THEN Raise(ER_SCR)
  font := scr.font
  offset := font.ysize
  wbor := scr.wborbottom
  IF (visual := GetVisualInfoA(scr,NIL)) = NIL THEN Raise(ER_VISUAL)
  IF (gadg := CreateContext({glist})) = NIL THEN Raise(ER_CONTEXT)

  listv := [0,0,0,0,0]:lh
  listv.head := listv+4; listv.tailpred := listv

  gettasks()
  font := ['topaz.font',8,0,0]:textattr

  IF (gadg := CreateGadgetA(BUTTON_KIND,gadg,
   [12,offset+141,64,14,'About',font,2,PLACETEXT_IN,visual,0]:newgadget,
    NIL)) = NIL THEN Raise(ER_GADGET)
  IF (gadg := CreateGadgetA(BUTTON_KIND,gadg,
   [206,offset+141,64,14,'Stop',font,3,PLACETEXT_IN,visual,0]:newgadget,
    NIL)) = NIL THEN Raise(ER_GADGET)
  IF (gadg := CreateGadgetA(BUTTON_KIND,gadg,
   [87,offset+141,108,14,'Update list',font,4,PLACETEXT_IN,visual,
    0]:newgadget,NIL)) = NIL THEN Raise(ER_GADGET)
  IF (gadg := CreateGadgetA(STRING_KIND,gadg,
   [12,offset+123,258,14,NIL,font,5,0,visual,0]:newgadget,
    NIL)) = NIL THEN Raise(ER_GADGET)
  str := gadg
  strinfo := str.specialinfo
  IF (gadg := CreateGadgetA(LISTVIEW_KIND,gadg,
   [12,offset+55,258,high,NIL,font,1,0,visual,0]:newgadget,
   [GTLV_SCROLLWIDTH,17,GTLV_LABELS,listv,GTLV_SHOWSELECTED,str,
    TAG_DONE])) = NIL THEN Raise(ER_GADGET)

  IF (wnd := OpenWindowTagList(NIL,
   [WA_LEFT,100,
    WA_TOP,25,
    WA_WIDTH,282,
    WA_HEIGHT,offset+159+wbor,
    WA_GADGETS,glist,
    WA_IDCMP,IDCMP_CLOSEWINDOW+IDCMP_CHANGEWINDOW+LISTVIEWIDCMP,
    WA_FLAGS,WFLG_DRAGBAR+WFLG_DEPTHGADGET+WFLG_CLOSEGADGET+WFLG_ACTIVATE+
      WFLG_RMBTRAP,
    WA_PUBSCREEN,scr,
    WA_SCREENTITLE,'StackMon v1.31',
    WA_TITLE,'StackMon v1.31',
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
    ActivateGadget(str,wnd,NIL)
    WHILE (msg := Gt_GetIMsg(wnd.userport)) <> NIL
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
	  CASE 5
	    cancel()
	    StrCopy(name,strinfo.buffer,128)
	    Colour(2,0)
	    TextF(100,offset+13,'\s(0,21)',name)
	ENDSELECT
      ENDIF

    ENDWHILE
  ENDWHILE
ENDPROC

PROC about()
  request('StackMon v1.31\n© 1993-96 David Kinder\n\n"Rise and reverberate"',
    'Continue')
ENDPROC

PROC request(body,gadgets)
  EasyRequestArgs(wnd,[SIZEOF easystruct,0,'StackMon',body,gadgets],0,NIL)
ENDPROC

PROC gettasks()
  DEF list : PTR TO lh,
      sort : PTR TO lh,
      node : PTR TO mynode,
      mem : PTR TO mynode

  Disable()
  list := exec.taskwait
  scanlist(list.head)
  list := exec.taskready
  scanlist(list.head)
  Enable()

  node := listv.head
  sort := [0,0,0,0,0]:lh
  sort.head := sort+4; sort.tail := 0; sort.tailpred := sort

  WHILE node.succ <> NIL
    IF (mem := New(SIZEOF mynode)) <> NIL
      mem.name := String(StrLen(node.name))
      IF mem.name <> NIL THEN StrCopy(mem.name,node.name,ALL)
      mem.ptr := node.ptr
      mem.pri := node.pri+sortpos(node)
      Enqueue(sort,mem)
    ENDIF
    node := node.succ
  ENDWHILE
  freelist()
  listv.head := sort.head; listv.tailpred := sort.tailpred
ENDPROC

PROC sortpos(node : PTR TO mynode)
  DEF lnode : PTR TO mynode,i

  i := 0
  lnode := listv.head
  WHILE lnode.succ <> NIL
    IF compare(node.name,lnode.name) > 0 THEN i++
    lnode := lnode.succ
  ENDWHILE
ENDPROC i

PROC compare(str1 : PTR TO CHAR,str2 : PTR TO CHAR)
  DEF ustr1[128] : STRING,
      ustr2[128] : STRING,
      i,diff

  StrCopy(ustr1,str1,ALL)
  StrCopy(ustr2,str2,ALL)
  UpperStr(ustr1)
  UpperStr(ustr2)
  i := 0
  LOOP
    IF ustr1[i] = 0 THEN RETURN 1
    IF ustr2[i] = 0 THEN RETURN -1
    diff := ustr1[i]-ustr2[i]
    IF diff < 0 THEN RETURN 1
    IF diff > 0 THEN RETURN -1
    i++
  ENDLOOP
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
	  IF len = 0
	    addtolist(node.name,pr,TRUE)
	  ELSE
	    StrCopy(name,Mul(cli.commandname,4)+1,len)
	    addtolist(name,pr,TRUE)
	  ENDIF
	ENDIF
      ENDIF
    ELSE
      addtolist(node.name,pr,FALSE)
    ENDIF
    pr := node.succ
    node := pr
  ENDWHILE
ENDPROC

PROC addtolist(name,task,process)
  DEF mem : PTR TO mynode

  IF (mem := New(SIZEOF mynode)) <> NIL
    mem.name := String(StrLen(name))
    IF mem.name <> NIL THEN StrCopy(mem.name,name,ALL)
    mem.ptr := task
    IF process = FALSE THEN mem.pri := -127
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

  StrCopy(name,'',ALL)
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
      TextF(141,offset+50,'Task not found')
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
    show(189,40,size)
    show(76,50,max)
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
  StrCopy(name,'',ALL)
ENDPROC

PROC getinfo()
  DEF list : PTR TO lh,
      newstk,newsize,gauge

  IF currtask <> NIL
    Forbid()
    list := exec.taskwait
    IF searchlist(list.head,currtask) = FALSE
      list := exec.taskready
      IF searchlist(list.head,currtask) = FALSE
	currtask := NIL
	Colour(2,0)
	TextF(76,offset+40,'        ')
	TextF(141,offset+50,'Task not found')
      ENDIF
    ENDIF
    Permit()
  ELSE
    IF StrCmp(name,'',ALL) = FALSE
      Forbid()
      list := exec.taskwait
      currtask := searchlistname(list.head)
      list := exec.taskready
      IF currtask = NIL THEN currtask := searchlistname(list.head)
      Permit()
      IF currtask <> NIL
	StrCopy(name,'',ALL)
	stk := 0
	TextF(189,offset+40,'        ')
	TextF(76,offset+40,'        ')
	TextF(76,offset+50,'        ')
	TextF(141,offset+50,'               ')
	Forbid()
	size := currtask.spupper-currtask.splower
	max := currtask.spupper-currtask.spreg
	Permit()
	Colour(2,0)
	TextF(100,offset+13,'\s(0,21)',name)
	show(189,40,size)
	show(76,50,max)
      ELSE
	Colour(2,0)
	TextF(141,offset+50,'Task not found')
      ENDIF
    ENDIF
  ENDIF

  IF currtask <> NIL
    Forbid()
    newstk := currtask.spupper-currtask.spreg
    newsize := currtask.spupper-currtask.splower
    Permit()

    IF newsize <> size
      size := newsize
      Colour(2,0)
      TextF(189,offset+40,'        ')
      show(189,40,size)
    ENDIF

    IF stk <> newstk
      stk := newstk
      Colour(2,0)
      TextF(76,offset+40,'        ')
      show(76,40,stk)
      IF stk > max
	max := stk
        Colour(2,0)
	TextF(76,offset+50,'        ')
	show(76,50,max)
      ENDIF
      IF stk > size
	Colour(2,0)
	TextF(141,offset+50,'Stack Overflow')
      ENDIF
      gauge := Div(Mul(stk,254),size)
      IF (stk < 0) OR (stk > 999999) THEN gauge := -1
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

  Disable()
  rval := FALSE
  WHILE pr.succ <> NIL
    IF pr = lookfor THEN rval := TRUE
    pr := pr.succ
  ENDWHILE
  Enable()
ENDPROC rval

PROC searchlistname(pr : PTR TO ln)
  DEF proc : PTR TO process,
      cli : PTR TO commandlineinterface,
      rval,len

  rval := NIL
  Disable()
  WHILE pr.succ <> NIL
    IF pr.type = NT_PROCESS
      proc := pr
      IF (cli := Mul(proc.cli,4)) = 0
	IF StrCmp(pr.name,name,ALL) THEN rval := pr
      ELSE
	IF cli.module = 0
	  IF StrCmp(pr.name,name,ALL) THEN rval := pr
	ELSE
	  len := Char(Mul(cli.commandname,4))
	  IF len = 0
	    IF StrCmp(pr.name,name,ALL) THEN rval := pr
	  ELSE
	    IF StrCmp(Mul(cli.commandname,4)+1,name,len) THEN rval := pr
	  ENDIF
	ENDIF
      ENDIF
    ELSE
      IF StrCmp(pr.name,name,ALL) THEN rval := pr
    ENDIF
    pr := pr.succ
  ENDWHILE
  Enable()
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

PROC show(x,y,var)
  IF (var >= 0) AND (var <= 999999)
    TextF(x,offset+y,'\d',var)
  ELSE
    TextF(x,offset+y,'???')
  ENDIF
ENDPROC
