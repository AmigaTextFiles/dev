/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED            "EDG"
 EC            "EC"
 PREPRO        "EPP"
 SOURCE        "Vtext.e"
 EPPDEST       "VText_EPP.e"
 EXEC          "Vtext"
 ISOURCE       " "
 HSOURCE       " "
 ERROREC       " "
 ERROREPP      " "
 VERSION       "0"
 REVISION      "1"
 NAMEPRG       "Vtext"
 NAMEAUTHOR    "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/
ENUM ER_NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS,
     ER_MEM,ER_BA,ER_SCREEN,ER_SIG
ENUM ARG_FICHIER,NUMARGS
MODULE 'intuition/intuition', 'gadtools', 'libraries/gadtools',
       'intuition/gadgetclass', 'exec/nodes', 'intuition/screens',
       'exec/lists','graphics/displayinfo' ,'graphics/text'
MODULE 'utility','utility/tagitem','wb','workbench/startup','dos/dosextens'
MODULE 'asl','libraries/asl'
RAISE ER_MEM IF New()=NIL
RAISE ER_MEM IF String()=NIL
DEF new_screen=NIL:PTR TO screen,
    visual=NIL,
    wnd=NIL:PTR TO window,
    glist=NIL,g,g1,type
DEF new_liste:PTR TO lh,fichier[256]:STRING,base_lock,task,sig=-1
DEF tattr
PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Main Porc.
 *******************************************************************************/
  DEF test
  task:=FindTask(0)
  tattr:=['topaz.font',8,0,0]:textattr
  SetTopaz(8)
  VOID {prg_banner}
  IF wbmessage<>NIL
      IF (test:=start_from_wb())<>ER_NONE THEN Raise(test)
  ELSE
      IF (test:=start_from_cli())<>ER_NONE THEN Raise(test)
  ENDIF
  new_liste:=New(SIZEOF lh)
  new_liste.tail:=0
  new_liste.head:=new_liste.tail
  new_liste.tailpred:=new_liste.head
  new_liste.type:=0
  new_liste.pad:=0
  IF (test:=readfile())<>ER_NONE THEN Raise(test)
  checkerror(openinterface())
  REPEAT
    wait4message()
  UNTIL type=IDCMP_CLOSEWINDOW
  Raise(ER_NONE)
EXCEPT
    CurrentDir(base_lock)
    IF new_liste THEN Dispose(new_liste)
    IF wnd
        closeinterface()
        IF new_screen.firstwindow<>0
            Wait(Shl(1,sig))            /* wait until all windows closed */
        ENDIF
        IF sig THEN FreeSignal(sig)
        IF new_screen THEN CloseScreen(new_screen)
    ENDIF
    SetDefaultPubScreen('Workbench')    /* workbench is default again */
    SELECT exception
        CASE ER_NONE;   NOP
        CASE ER_MEM;     WriteF('Mémoire insuffisante.\n')
        CASE ER_BA;      WriteF('Bad Args !.\n')
        CASE ER_SCREEN;  WriteF('Ouverture de l\aécran impossible.\n')
        DEFAULT;     NOP
    ENDSELECT
ENDPROC
PROC start_from_cli() /*"start_from_cli()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Start from Cli (lock current dir).
 *******************************************************************************/
    DEF pro:PTR TO process
    DEF myargs:PTR TO LONG,rdargs
    DEF ret=ER_NONE
    myargs:=[0]
    pro:=task
    base_lock:=CurrentDir(pro.currentdir)
    IF rdargs:=ReadArgs('SOURCE',myargs,NIL)
        IF myargs[0] THEN StrCopy(fichier,myargs[0],ALL) ELSE ret:=ER_BA
        FreeArgs(rdargs)
    ELSE
        ret:=ER_BA
    ENDIF
    RETURN ret
ENDPROC
PROC start_from_wb() /*"start_from_wb()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Start from wb (Lock the dir of the first arg).
 *******************************************************************************/
    DEF wb:PTR TO wbstartup /*wb_args:PTR TO wbarg */
    DEF args:PTR TO wbarg
    wb:=wbmessage
    args:=wb.arglist
    StrCopy(fichier,args[1].name,ALL)
    base_lock:=CurrentDir(args[1].lock)
    RETURN ER_NONE
ENDPROC
PROC openinterface() HANDLE /*"openinterface()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Open lib,Call getdisplayid().
 *                open screen and window.
 *******************************************************************************/
  DEF name,wb_scr,id_wb=HIRES_KEY
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN RETURN ER_OPENLIB
  name:=fichier
  IF wb_scr:=LockPubScreen('Workbench')
      IF (id_wb:=getdisplayid(wb_scr))=FALSE THEN id_wb:=HIRES_KEY
      UnlockPubScreen(wb_scr,NIL)
      id_wb:=PAL_MONITOR_ID+id_wb
  ENDIF
  IF (new_screen:=OpenScreenTagList(NIL,          /* get ourselves a public screen */
         [SA_TOP,0,
          SA_DEPTH,2,
          SA_FONT,tattr,
          SA_DISPLAYID,id_wb,
          SA_PUBNAME,name,
          SA_TITLE,name,
          SA_PUBSIG,IF (sig:=AllocSignal(-1))=NIL THEN Raise(ER_SIG) ELSE sig,
          SA_PUBTASK,task,
          SA_AUTOSCROLL,TRUE,
          SA_OVERSCAN,OSCAN_TEXT,
          SA_PENS,[0,0,1,2,1,3,1,0,1,1,2]:INT,
          0,0]))=NIL THEN Raise(ER_SCREEN)
  PubScreenStatus(new_screen,0)                 /* make it available */
  SetDefaultPubScreen(fichier)
  SetPubScreenModes(SHANGHAI)
  IF (visual:=GetVisualInfoA(new_screen,NIL))=NIL THEN RETURN ER_VISUAL
  IF (g:=CreateContext({glist}))=NIL THEN RETURN ER_CONTEXT
  IF (g1:=CreateGadgetA(LISTVIEW_KIND,g,[new_screen.wborleft,
                                         new_screen.topedge+new_screen.barheight,
                                         new_screen.width-new_screen.wborright,
                                         new_screen.height-new_screen.barheight,'',tattr,2,16,visual,0]:newgadget,[GTLV_READONLY,TRUE,GTLV_SCROLLWIDTH,15,GTLV_LABELS,new_liste,0]))=NIL THEN RETURN ER_GADGET
  IF (wnd:=OpenW(0,0,new_screen.width,new_screen.height,$700 OR LISTVIEWIDCMP,$190E,'Viewtext v0.0 (c) 1993 NasGûl',new_screen,15,glist))=NIL THEN RETURN ER_WINDOW
  wnd.screentitle:=arg
  Gt_RefreshWindow(wnd,NIL)
  Gt_SetGadgetAttrsA(g1,wnd,NIL,[GTLV_TOP,0,GTLV_LABELS,new_liste,0])
EXCEPT
    RETURN exception
ENDPROC
PROC closeinterface() /*"closeinterface()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Free All and Close lib.
 *******************************************************************************/
  IF glist THEN FreeGadgets(glist)
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF aslbase THEN CloseLibrary(aslbase)
ENDPROC
PROC checkerror(er) /*"checkerror(er)"*/
/********************************************************************************
 * Para         : the error.
 * Return       : NONE
 * Description  : Check error.
 *******************************************************************************/
  DEF errors:PTR TO LONG
  IF er>0
    closeinterface()
    errors:=['','open "gadtools.library" v37','lock workbench','get visual infos','create context','create gadget','open window','allocate menus','allocate signal']
    WriteF('Could not \s !\n',errors[er])
    CleanUp(10)
  ENDIF
ENDPROC
PROC wait4message() /*"wait4message()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Wait Message.
 *******************************************************************************/
  DEF mes:PTR TO intuimessage
  DEF ret
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
      type:=mes.class
      IF type:=IDCMP_RAWKEY
          ret:=mes.code
          SELECT ret
              CASE $45; type:=IDCMP_CLOSEWINDOW
              CASE $4D  /* Down */
              CASE $4C  /* Up   */
              DEFAULT; NOP
          ENDSELECT
      ELSEIF type=IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(wnd)
        Gt_EndRefresh(wnd,TRUE)
        type:=0
      ELSEIF type<>IDCMP_CLOSEWINDOW
        type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      Wait(-1)
    ENDIF
  UNTIL type
ENDPROC
PROC readfile() /*"readfile()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : read file and build a list (For ListView).
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE
  DEF my_string[256]:STRING,p=0,num_node=0
  DEF node:PTR TO ln
  IF (flen:=FileLength(fichier))=-1 THEN RETURN ER_BA
  IF (buf:=New(flen+1))=NIL THEN RETURN ER_BA
  IF (handle:=Open(fichier,1005))=NIL THEN RETURN ER_BA
  len:=Read(handle,buf,flen)
  Close(handle)
  IF len<1 THEN RETURN ER_BA
  adr:=buf
  FOR a:=0 TO len-1
    IF buf[a]=10
        IF a-p<>0
            StrCopy(my_string,adr,a-p)
        ELSE
            StrCopy(my_string,'',ALL)
        ENDIF
        node:=New(SIZEOF ln)
        node.succ:=0
        node.name:=String(EstrLen(my_string))
        StrCopy(node.name,my_string,ALL)
        AddTail(new_liste,node)
        IF num_node=0
            new_liste.head:=node
            node.pred:=0
        ENDIF
        new_liste.tailpred:=node
        p:=a+1
        adr:=buf+a+1
        num_node:=num_node+1
    ENDIF
  ENDFOR
  Dispose(buf)
  RETURN ER_NONE
ENDPROC
PROC getdisplayid(wb_scr) /*"getdisplayid(wb_scr)"*/
/********************************************************************************
 * Para         : Address of screen.
 * Return       : DisplayId.
 * Description  : Retrun the DisplayId of a screen.
 *******************************************************************************/
    DEF s:PTR TO screen,w=NIL,h=NIL
    s:=wb_scr
    w:=s.width
    h:=s.height
    IF (w=320) AND (h=256)
        RETURN LORES_KEY
    ELSEIF (w=320) AND (h=512)
        RETURN LORESLACE_KEY
    ELSEIF (w=640) AND (h=256)
        RETURN HIRES_KEY
    ELSEIF (w=640) AND (h=512)
        RETURN HIRESLACE_KEY
    ELSEIF (w=1280) AND (h=256)
        RETURN SUPER_KEY
    ELSEIF (w=1280) AND (h=512)
        RETURN SUPERLACE_KEY
    ENDIF
    RETURN FALSE
ENDPROC
prg_banner:
INCBIN 'Vtext.header'


