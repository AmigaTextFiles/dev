OPT PREPROCESS

/* carddisk.device crashes! */

-> Fatal bug in drawsel() (replaced with drawtree() for now!)

-> Doesn't deallocate mem after close

MODULE 'intuition/intuition', 'exec/memory', 'dos/dosextens',
       'dos/filehandler', 'dos/dos', 'devices/trackdisk',
       'exec/io', 'graphics/rastport', 'graphics/text',
       'datatypes', 'datatypes/pictureclass',
       'datatypes/datatypesclass', 'datatypes/datatypes',
       'graphics/view', 'devices/scsidisk',
       'intuition/screens', 'intuition/imageclass',
       'intuition/gadgetclass', 'utility',
       'intuition/icclass','utility/tagitem',
       'libraries/gadtools', 'gadtools',
       'layers', 'graphics/clip','graphics/gfx',
       'exec/ports', 'exec/nodes', 'exec/tasks',
       'wb'

ENUM ERR_WIN=1, ERR_LIB, ERR_SCRL, ERR_SCR, ERR_GAD, ERR_PORT, ERR_MENU

RAISE ERR_WIN IF OpenWindowTagList()=NIL
RAISE ERR_LIB IF OpenLibrary()=NIL
RAISE ERR_SCRL IF GetScreenDrawInfo()=NIL
RAISE ERR_SCRL IF NewObjectA()=NIL
RAISE ERR_SCR IF LockPubScreen()=NIL
RAISE ERR_GAD IF GetVisualInfoA()=NIL
RAISE ERR_GAD IF CreateGadgetA()=NIL
RAISE ERR_GAD IF CreateContext()=NIL
RAISE ERR_PORT IF CreateMsgPort()=NIL
RAISE ERR_MENU IF LayoutMenusA()=NIL
RAISE ERR_MENU IF CreateMenusA()=NIL

ENUM WORKBENCH, DEVICES, DEVICE, FOLDER, FILE, DIREMPTY, GROUP
ENUM DRIVE, CDROM, FLOPPY, NETWORK, RAMDISK, HARDDISK, BACKDROP, PROJECTFILE
ENUM NONE, EXPAND, HIDE

ENUM TREE_ID=1, OPEN_ID

CONST ICONTOP=32

CONST TW_MAGIC=$F3C32AF1

OBJECT node
  next:PTR TO node
  child:PTR TO node
  lastchild:PTR TO node
  type:CHAR
  subtype:CHAR
  lastnode:CHAR
  name:PTR TO CHAR
  icon:PTR TO image
  exp:CHAR
  parent:PTR TO node
ENDOBJECT

OBJECT wbnode
  next:PTR TO node
  child:PTR TO node
  lastchild:PTR TO node
  type:CHAR
  subtype:CHAR
  lastnode:CHAR
  name:PTR TO CHAR
  icon:PTR TO image
  exp:CHAR
  parent:PTR TO node
  backdrop:PTR TO CHAR
ENDOBJECT

OBJECT icon
  bmp
  dto
ENDOBJECT

OBJECT tw
  magic:LONG
  win:PTR TO window
  tree:PTR TO node
  devices:PTR TO node
  offy
  oldchk
  op
  vtotchange, openvtotchange
  lines[64]:ARRAY OF LONG
  openlines[64]:ARRAY OF LONG
  vvisible
  vtotal
  glist
  vertgadget
  openvtotal
  openvertgadget
  open:PTR TO node
  openoffy
  openoldchk
  sel:PTR TO node
  oldsel
  secs
  menus
ENDOBJECT

DEF more:PTR TO image, less:PTR TO image, branch:PTR TO image,
    lastbranch:PTR TO image, port=NIL:PTR TO mp, opencnt=0

DEF icons[12]:ARRAY OF icon

DEF dri=NIL:PTR TO drawinfo, scr=NIL:PTR TO screen,
    visinfo=NIL, sizeimage=NIL:PTR TO image

DEF pathbuf[256]:STRING, nd=0, first:PTR TO window

PROC inittw(tw:PTR TO tw)
  DEF i
  tw.win:=NIL
  tw.offy:=0
  tw.oldchk:=-1
  tw.vtotchange:=FALSE
  tw.openvtotchange:=FALSE
  tw.vvisible:=2
  tw.vtotal:=1
  tw.glist:=NIL
  tw.vertgadget:=NIL
  tw.openvtotal:=NIL
  tw.openvertgadget:=NIL
  tw.open:=NIL
  tw.openoffy:=0
  tw.openoldchk:=-1
  tw.sel:=NIL
  tw.oldsel:=NIL
  tw.secs:=0
  tw.menus:=NIL
  FOR i:=0 TO 63
    tw.lines[i]:=NIL
    tw.openlines[i]:=NIL
  ENDFOR
ENDPROC

PROC newimageobject(which) IS
  NewObjectA(NIL,'sysiclass',
    [SYSIA_DRAWINFO,dri,SYSIA_WHICH,which,SYSIA_SIZE,SYSISIZE_MEDRES,NIL])

PROC updateprop(tw:PTR TO tw, gad:PTR TO gadget, tags)
  Gt_SetGadgetAttrsA(gad, tw.win, NIL, tags)
  ->RefreshGList(tw.glist, tw.win, NIL, -1)
ENDPROC

PROC makescrollers(tw:PTR TO tw)
  DEF gad:PTR TO gadget, glist, menu
  gad:=CreateContext({glist})
  tw.glist:=glist
  IF tw.vvisible>tw.vtotal THEN tw.vtotal:=tw.vvisible
  IF tw.vvisible>tw.openvtotal THEN tw.openvtotal:=tw.vvisible
  tw.vertgadget:=CreateGadgetA(SCROLLER_KIND, gad, [tw.op-sizeimage.width, ICONTOP,
                                                 sizeimage.width, tw.win.height-tw.win.borderbottom-tw.win.bordertop-ICONTOP,
                                                 NIL, NIL, TREE_ID,
                                                 NIL, visinfo, NIL]:newgadget, [PGA_FREEDOM, LORIENT_VERT,
                                                 GTSC_ARROWS, sizeimage.height, GTSC_TOTAL, tw.vtotal, GTSC_VISIBLE, tw.vvisible,
                                                 GTSC_TOP, 0, NIL])
  tw.openvertgadget:=CreateGadgetA(SCROLLER_KIND, tw.vertgadget, [tw.win.width-tw.win.borderright-tw.win.borderleft-sizeimage.width, ICONTOP,
                                                            sizeimage.width, tw.win.height-tw.win.borderbottom-tw.win.bordertop-ICONTOP,
                                                            NIL, NIL, OPEN_ID,
                                                            NIL, visinfo, NIL]:newgadget, [PGA_FREEDOM, LORIENT_VERT,
                                                            GTSC_ARROWS, sizeimage.height, GTSC_TOTAL, tw.openvtotal, GTSC_VISIBLE, tw.vvisible,
                                                            GTSC_TOP, 0, NIL])
  AddGList(tw.win, tw.glist, -1, -1, NIL)
  RefreshGList(tw.glist, tw.win, NIL, -1)
  menu:=[NM_TITLE, 0, 'Project', NIL, NIL, NIL, NIL,
         NM_ITEM,  0, 'New Window', 'N', NIL, NIL, NIL,
         NM_ITEM,  0, 'About', '?', NIL, NIL, NIL,
         NM_ITEM,  0, 'Close', 'Q', NIL, NIL, NIL,
         NM_TITLE, 0, 'File', NIL, NIL, NIL, NIL,
         NM_ITEM,  0, 'New Group...', 'G', NIL, NIL, NIL,
         NM_ITEM,  0, 'Open', 'O', NIL, NIL, NIL,
         NM_ITEM,  0, 'Information...', 'I', NIL, NIL, NIL,
         NM_ITEM,  0, 'Rename...', 'R', NIL, NIL, NIL,
         NM_ITEM,  0, 'Delete', 'D', NIL, NIL, NIL,
         NM_END,   0, NIL, NIL, NIL, NIL, NIL]:newmenu
  tw.menus:=CreateMenusA(menu, [GTMN_NEWLOOKMENUS, TRUE, NIL])
  LayoutMenusA(tw.menus, visinfo, [GTMN_NEWLOOKMENUS, TRUE, NIL])
  SetMenuStrip(tw.win, tw.menus)
ENDPROC

PROC getpath(node:PTR TO wbnode, lp=FALSE)
  DEF tmp[256]:STRING, colon
  pathbuf[0]:=0
  SetStr(pathbuf, 0)
  IF node.subtype<>BACKDROP
    IF node.parent.type<>DEVICES
      IF lp<>TRUE THEN StrCopy(pathbuf, node.name)
      node:=node.parent
      WHILE ((node.parent.type<>DEVICES) AND (node.subtype<>BACKDROP))
        StringF(tmp, '\s/\s', node.name, pathbuf)
        StrCopy(pathbuf, tmp)
        node:=node.parent
      ENDWHILE
      IF node.subtype<>BACKDROP
        StrCopy(tmp, pathbuf)
        colon:=InStr(node.name, ':')
        StrCopy(pathbuf, node.name, colon+1)
        StrAdd(pathbuf, tmp)
      ELSE
        StringF(tmp, '\s\s/\s', node.backdrop, node.name, pathbuf)
        StrCopy(pathbuf, tmp)
      ENDIF
    ELSE
      colon:=InStr(node.name, ':')
      StrCopy(tmp, node.name, colon+1)
      StrCopy(pathbuf, tmp)
    ENDIF
  ELSE
    StrCopy(pathbuf, node.backdrop)
    StrAdd(pathbuf, node.name)
  ENDIF
ENDPROC pathbuf

PROC expand(tw:PTR TO tw, node:PTR TO node)
  DEF lock, path, fib:PTR TO fileinfoblock, err, cnt=0
  tw.open:=node
  tw.openoldchk:=-1
  tw.vtotchange:=TRUE
  tw.oldchk:=-1
  path:=getpath(node)
  IF lock:=Lock(path, ACCESS_READ)
    IF fib:=AllocDosObject(DOS_FIB, NIL)
      err:=Examine(lock, fib)
      WHILE (err)
        err:=ExNext(lock, fib)
        IF err
          IF fib.direntrytype>0
            addchild(node, FOLDER, IF (node.subtype=BACKDROP) OR (node.subtype=PROJECTFILE) THEN PROJECTFILE ELSE NIL, StrCopy(String(StrLen(fib.filename)), fib.filename), 1)
            cnt++
            WriteF('\s\n', fib.filename)
          ELSE
            addchild(node, FILE, IF (node.subtype=BACKDROP) OR (node.subtype=PROJECTFILE) THEN PROJECTFILE ELSE NIL, StrCopy(String(StrLen(fib.filename)), fib.filename), 0)
            cnt++
            WriteF('\s\n', fib.filename)
          ENDIF
        ENDIF
      ENDWHILE
      ->drawtree(tw)
      FreeDosObject(DOS_FIB, fib)
    ENDIF
    UnLock(lock)
  ENDIF
  IF cnt=0 THEN addchild(node, DIREMPTY, NIL, StrCopy(String(20),'Directory is empty'), NIL)
ENDPROC

PROC freenode(cur:PTR TO node)
  DisposeLink(cur.name)
  END cur
ENDPROC

PROC collapse(tw:PTR TO tw, parent:PTR TO node)
  DEF node[32]:ARRAY OF LONG, curdepth=0, cur:PTR TO node, i,
      next, p:PTR TO node
  FOR i:=0 TO 31
    node[i]:=NIL
  ENDFOR
  node[0]:=parent.child
  WHILE (curdepth>=0)
    cur:=node[curdepth]
    IF cur.child<>NIL
      curdepth++
      node[curdepth]:=cur.child
    ELSE
      IF cur.lastnode=1
        p:=cur.parent
        freenode(cur)
        IF cur=tw.sel THEN tw.sel:=NIL
        p.child:=NIL
        p.lastchild:=NIL
        curdepth--
      ENDIF
      IF curdepth>=0
        REPEAT
          cur:=node[curdepth]
          IF cur.lastnode=0
            next:=cur.next
            freenode(cur)
            IF cur=tw.sel THEN tw.sel:=NIL
            node[curdepth]:=next
          ELSE
            p:=cur.parent
            freenode(cur)
            p.child:=NIL
            p.lastchild:=NIL
            IF cur=tw.sel THEN tw.sel:=NIL
            curdepth--
          ENDIF
        UNTIL (curdepth<0) OR (cur.lastnode=0)
      ENDIF
    ENDIF
  ENDWHILE
  tw.oldchk:=-1
  tw.openoldchk:=-1
  tw.vtotchange:=TRUE
  ->drawtree(tw)
ENDPROC

PROC addbackdrop(tw:PTR TO tw)
  DEF tmp[128]:STRING, backdrop:PTR TO CHAR, fh, pp, lock,
      fib:fileinfoblock, name:PTR TO CHAR
    IF fh:=Open('Projects.list', MODE_OLDFILE)
      WHILE Fgets(fh, tmp, 120)
        SetStr(tmp, StrLen(tmp)-1)
        IF StrLen(tmp)>1
          pp:=PathPart(tmp)
          backdrop:=String(pp-tmp+2)
          pp:=FilePart(tmp)
          name:=String(StrLen(tmp)-(pp-tmp)+2)
          StrCopy(name, pp)
          StrCopy(backdrop, tmp, pp-tmp)
          ->StringF(tmp, '\s\s', backdrop, name)
          IF lock:=Lock(tmp, ACCESS_READ)
            Examine(lock, fib)
            UnLock(lock)
            IF fib.direntrytype>0
              addchild(tw.tree, GROUP, BACKDROP, name, 1, backdrop)
            ELSE
              addchild(tw.tree, FILE, BACKDROP, name, 0, backdrop)
            ENDIF
          ENDIF
        ENDIF
      ENDWHILE
      Close(fh)
ENDIF
ENDPROC

PROC insertchild(node:PTR TO node, type, subtype, name, exp, backdrop=NIL)
  DEF child:PTR TO node, icon=NIL, wbchild:PTR TO wbnode
  IF backdrop
    NEW wbchild
    wbchild.backdrop:=backdrop
    child:=wbchild
  ELSE
    NEW child
  ENDIF
  child.type:=type
  child.subtype:=subtype
  child.name:=name
  child.next:=NIL
  child.exp:=exp
  child.child:=NIL
  child.lastchild:=NIL
  child.lastnode:=0
  child.parent:=node
  child.icon:=NIL
  IF node.child=NIL THEN child.lastnode:=1
  child.next:=node.child
  node.child:=child
  SELECT type
    CASE WORKBENCH
      icon:=icons[7].bmp
    CASE DEVICES
      icon:=icons[1].bmp
    CASE FOLDER
      icon:=icons[4].bmp
    CASE FILE
      icon:=icons[9].bmp
    CASE DIREMPTY
      icon:=1
    CASE GROUP
      icon:=icons[10].bmp
      child.type:=FOLDER
    CASE DEVICE
      SELECT subtype
        CASE DRIVE
          icon:=icons[2].bmp
        CASE CDROM
          icon:=icons[0].bmp
        CASE FLOPPY
          icon:=icons[3].bmp
        CASE NETWORK
          icon:=icons[5].bmp
        CASE RAMDISK
          icon:=icons[6].bmp
        CASE HARDDISK
          icon:=icons[8].bmp
      ENDSELECT
  ENDSELECT
  child.icon:=icon
ENDPROC child

PROC addchild(node:PTR TO node, type, subtype, name, exp, backdrop=NIL)
  DEF child:PTR TO node, icon=NIL, wbchild:PTR TO wbnode
  IF backdrop
    NEW wbchild
    wbchild.backdrop:=backdrop
    child:=wbchild
  ELSE
    NEW child
  ENDIF
  child.type:=type
  child.subtype:=subtype
  child.name:=name
  child.next:=NIL
  child.exp:=exp
  child.child:=NIL
  child.lastchild:=NIL
  child.lastnode:=1
  child.parent:=node
  child.icon:=NIL
  IF node.child=NIL THEN node.child:=child
  IF node.lastchild
    node.lastchild.next:=child
    node.lastchild.lastnode:=0
  ENDIF
  node.lastchild:=child
  SELECT type
    CASE WORKBENCH
      icon:=icons[7].bmp
    CASE DEVICES
      icon:=icons[1].bmp
    CASE FOLDER
      icon:=icons[4].bmp
    CASE FILE
      icon:=icons[9].bmp
    CASE DIREMPTY
      icon:=1
    CASE GROUP
      icon:=icons[10].bmp
      child.type:=FOLDER
    CASE DEVICE
      SELECT subtype
        CASE DRIVE
          icon:=icons[2].bmp
        CASE CDROM
          icon:=icons[0].bmp
        CASE FLOPPY
          icon:=icons[3].bmp
        CASE NETWORK
          icon:=icons[5].bmp
        CASE RAMDISK
          icon:=icons[6].bmp
        CASE HARDDISK
          icon:=icons[8].bmp
      ENDSELECT
  ENDSELECT
  child.icon:=icon
ENDPROC child

PROC main() HANDLE
  DEF proc:PTR TO process, imsg:PTR TO intuimessage, class, code, mousex, mousey,
      i, node:PTR TO node, tw:PTR TO tw, line, menunum, itemnum, path, lock,
      cmd[256]:STRING
  proc:=FindTask(NIL)
  proc.windowptr:=-1
  proc.task.ln.name:='Project Manager'
  FOR i:=0 TO 10
    icons[i].bmp:=NIL
    icons[i].dto:=NIL
  ENDFOR
  datatypesbase:=OpenLibrary('datatypes.library', 39)
  utilitybase:=OpenLibrary('utility.library', 37)
  gadtoolsbase:=OpenLibrary('gadtools.library', 39)
  layersbase:=OpenLibrary('layers.library', NIL)
  workbenchbase:=OpenLibrary('workbench.library', 39)
  port:=CreateMsgPort()
  scr:=LockPubScreen(NIL)
  dri:=GetScreenDrawInfo(scr)
  sizeimage:=newimageobject(SIZEIMAGE)
  more:=[0, 0, 16, 11, 1, copyImageToChip({moredata}), 1, 0, NIL]:image
  less:=[0, 0, 16, 11, 1, copyImageToChip({lessdata}), 1, 0, NIL]:image
  branch:=[0, 0, 16, 11, 1, copyImageToChip({branchdata}), 1, 0, NIL]:image
  lastbranch:=[0, 0, 16, 11, 1, copyImageToChip({lastbranchdata}), 1, 0, NIL]:image
  visinfo:=GetVisualInfoA(scr, NIL)
  loadicons()
  opentw()
  WHILE (opencnt>0)
    WaitPort(port)
    WHILE (imsg:=Gt_GetIMsg(port))
      class:=imsg.class
      code:=imsg.code
      mousex:=imsg.mousex-imsg.idcmpwindow.borderleft
      mousey:=imsg.mousey-imsg.idcmpwindow.bordertop
      tw:=imsg.idcmpwindow.userdata
      Gt_ReplyIMsg(imsg)
      IF tw
      IF tw.magic=TW_MAGIC
      IF class AND (ARROWIDCMP OR SCROLLERIDCMP)
        drawtree(tw)
      ENDIF
      SELECT class
        CASE IDCMP_DISKINSERTED
          updatedevices(tw)
        CASE IDCMP_DISKREMOVED
          updatedevices(tw)
        CASE IDCMP_CLOSEWINDOW
          closetw(tw)
        CASE IDCMP_MENUPICK
          menunum:=MENUNUM(code)
          itemnum:=ITEMNUM(code)
          SELECT menunum
            CASE 0
              SELECT itemnum
                CASE 0
                  opentw()
                CASE 1
                  error('Project Manager\n© Christopher January 1998\nPart of the Portrait package')
                CASE 2
                  closetw(tw)
              ENDSELECT
            CASE 1
              SELECT itemnum
                CASE 0
                  IF lock:=CreateDir('Projects/Unnamed')
                    UnLock(lock)
                    tw.sel:=insertchild(tw.tree, GROUP, BACKDROP, StrCopy(String(8), 'Unnamed'), 1, StrCopy(String(10),'Projects/'))
                    expand(tw,tw.sel)
                    tw.oldchk:=-1
                    tw.openoldchk:=-1
                    tw.openvtotchange:=TRUE
                    tw.vtotchange:=TRUE
                    tw.offy:=0
                    tw.openoffy:=0
                    drawtree(tw)
                    rename(tw)
                  ENDIF
                CASE 1
                  IF tw.sel
                    path:=getpath(tw.sel)
                    IF (tw.sel.type=FILE)
                      StringF(cmd, 'Run >NIL: <NIL: Multiview \s', path)
                      SystemTagList(cmd, NIL)
                    ENDIF
                  ENDIF
                CASE 2
                  IF tw.sel
                    path:=getpath(tw.sel, TRUE)
                      IF (tw.sel.type=FOLDER) OR (tw.sel.type=FILE)
                        IF lock:=Lock(path, ACCESS_READ)
                          WbInfo(lock, tw.sel.name, scr)
                          UnLock(lock)
                        ENDIF
                      ELSEIF (tw.sel.type=DEVICE)
                        IF lock:=Lock(path, ACCESS_READ)
                          WbInfo(NIL, '', scr)
                          UnLock(lock)
                        ENDIF
                      ENDIF
                    ENDIF
                CASE 3
                  IF tw.sel
                  IF (tw.sel.subtype=BACKDROP) OR (tw.sel.subtype=PROJECTFILE)
                    rename(tw)
                  ELSE
                    error('You can only rename a project file')
                  ENDIF
                  ENDIF
              ENDSELECT
          ENDSELECT
        CASE IDCMP_NEWSIZE
          tw.op:=tw.win.width/3
          tw.vvisible:=(tw.win.height-tw.win.bordertop-tw.win.borderbottom-ICONTOP)/16
          RemoveGList(tw.win, tw.glist, -1)
          FreeGadgets(tw.glist)
          makescrollers(tw)
         tw.oldchk:=-1
          tw.openoldchk:=-1
          drawtree(tw)
        CASE IDCMP_MOUSEBUTTONS
          IF code=SELECTDOWN
            IF (mousey>=ICONTOP) AND (mousey<=(tw.win.height-tw.win.bordertop-tw.win.borderbottom))
              line:=(mousey/16)
              IF (mousex<(tw.op-sizeimage.width)) AND (mousex>=0)
                node:=tw.lines[line]
                IF node.type<>DIREMPTY
                IF (node=tw.sel)
                  IF (node<>tw.tree) AND (node<>tw.devices)
                    IF node.child<>NIL
                      collapse(tw, node)
                    ELSEIF (node.exp=EXPAND)
                      expand(tw, node)
                    ENDIF
                  ENDIF
                ELSE
                  tw.oldsel:=tw.sel
                  tw.sel:=node
                  tw.open:=node
                  tw.openoldchk:=-1
                  tw.oldchk:=-1
                  tw.openvtotchange:=TRUE
                  ->drawsel(tw)
                ENDIF
                ENDIF
              ELSEIF (mousex>=(tw.op+8)) AND (mousex<(tw.win.width-tw.win.borderleft-tw.win.borderright-sizeimage.width))
                node:=tw.openlines[line]
                IF node.type<>DIREMPTY
                IF (node=tw.sel)
                  IF (node<>tw.tree) AND (node<>tw.devices)
                    IF node.child<>NIL
                      collapse(tw, node)
                    ELSEIF (node.exp=EXPAND)
                      expand(tw, node)
                    ENDIF
                  ENDIF
                ELSE
                  tw.oldsel:=tw.sel
                  tw.sel:=node
                  /*tw.open:=node
                  tw.openvtotchange:=TRUE*/
                  tw.openoldchk:=-1
                  tw.oldchk:=-1
                  ->drawsel(tw)
                ENDIF
                ENDIF
              ENDIF
            ENDIF
          ENDIF
      ENDSELECT
      ENDIF
      ENDIF
    ENDWHILE
  ENDWHILE
EXCEPT DO
  SELECT exception
    CASE ERR_WIN
      error('Cannot open window')
    CASE ERR_LIB
      error('Cannot open datatypes.library V39+')
    CASE ERR_SCRL
      error('Cannot create scrollers')
    CASE ERR_SCR
      error('Cannot find a public screen')
    CASE ERR_GAD
      error('Cannot create gadgets')
    CASE ERR_PORT
      error('Cannot create message port')
  ENDSELECT
  IF datatypesbase
    freeicons()
    CloseLibrary(datatypesbase)
  ENDIF
  IF sizeimage THEN DisposeObject(sizeimage)
  IF visinfo THEN FreeVisualInfo(visinfo)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF utilitybase THEN CloseLibrary(utilitybase)
  IF layersbase THEN CloseLibrary(layersbase)
  IF workbenchbase THEN CloseLibrary(workbenchbase)
  IF dri THEN FreeScreenDrawInfo(scr, dri)
  IF scr THEN UnlockPubScreen(NIL, scr)
  IF port THEN DeleteMsgPort(port)
ENDPROC

PROC writelist(tw:PTR TO tw)
  DEF node:PTR TO wbnode, str[256]:STRING, f=TRUE, fh
  IF fh:=Open('Projects.list', MODE_NEWFILE)
  node:=tw.tree.child
  REPEAT
    IF f<>TRUE THEN node:=node.next
    IF node.subtype=BACKDROP
      StringF(str, '\s\s\n', node.backdrop, node.name)
      Fputs(fh, str)
    ENDIF
    f:=FALSE
  UNTIL node.lastnode=1
  Close(fh)
  ENDIF
ENDPROC

PROC rename(tw:PTR TO tw) HANDLE
  DEF renwin:PTR TO window, ys, imsg:PTR TO intuimessage, quit=FALSE,
      class,glist=NIL,gad=NIL:PTR TO gadget
  ys:=tw.win.rport.font.ysize
  renwin:=OpenWindowTagList(NIL, [WA_WIDTH, 160, WA_INNERHEIGHT, ys+6,
                                  WA_TITLE, 'Rename...',
                                  WA_DRAGBAR, TRUE,
                                  WA_DEPTHGADGET, TRUE,
                                  WA_ACTIVATE, TRUE,
                                  WA_CLOSEGADGET, TRUE,
                                  WA_SMARTREFRESH, TRUE,
                                  WA_AUTOADJUST, TRUE,
                                  WA_NEWLOOKMENUS, TRUE,
                                  WA_PUBSCREEN, scr,
                                  WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP,
                                  NIL])
  gad:=CreateContext({glist})
  gad:=CreateGadgetA(STRING_KIND, gad, [renwin.borderleft, renwin.bordertop,
  renwin.width-renwin.borderleft-renwin.borderright,
  renwin.height-renwin.bordertop-renwin.borderbottom,
  NIL,NIL, NIL, NIL, visinfo, NIL]:newgadget, [GTST_STRING, tw.sel.name,
  GTST_MAXCHARS, 64, NIL])
  AddGList(renwin, glist, -1, -1, NIL)
  RefreshGList(glist, renwin, NIL, -1)
  WHILE (quit=FALSE)
    WaitPort(renwin.userport)
  WHILE (imsg:=Gt_GetIMsg(renwin.userport))
    class:=imsg.class
    Gt_ReplyIMsg(renwin.userport)
    SELECT class
      CASE IDCMP_CLOSEWINDOW
        quit:=TRUE
      CASE IDCMP_GADGETUP
        quit:=TRUE
    ENDSELECT
  ENDWHILE
  ENDWHILE
  DisposeLink(tw.sel.name)
  tw.sel.name:=StrCopy(String(StrLen(gad.specialinfo::stringinfo.buffer)),gad.specialinfo::stringinfo.buffer)
  FreeGadgets(glist)
  CloseWindow(renwin)
  writelist(tw)
EXCEPT
  IF glist THEN FreeGadgets(glist)
  IF renwin THEN CloseWindow(renwin)
ENDPROC

PROC opentw() HANDLE
  DEF tw:PTR TO tw
  NEW tw
  inittw(tw)
  tw.magic:=TW_MAGIC
  tw.win:=OpenWindowTagList(NIL,[WA_WIDTH, 640, WA_HEIGHT, Min(200, scr.height/2),
                          WA_TITLE, 'Project tree window',
                          WA_MINWIDTH, 160, WA_MINHEIGHT, 128,
                          WA_MAXWIDTH, -1, WA_MAXHEIGHT, -1,
                          IF nd=1 THEN WA_TOP ELSE TAG_IGNORE, IF nd=1 THEN first.topedge+first.height ELSE 0,
                          WA_SIZEGADGET, TRUE,
                          WA_DRAGBAR, TRUE,
                          WA_DEPTHGADGET, TRUE,
                          WA_CLOSEGADGET, TRUE,
                          WA_ACTIVATE, TRUE,
                          WA_SMARTREFRESH, TRUE,
                          WA_AUTOADJUST, TRUE,
                          WA_GIMMEZEROZERO, TRUE,
                          WA_NEWLOOKMENUS, TRUE,
                          WA_SIZEBBOTTOM, TRUE,
                          WA_PUBSCREEN, scr,
                          NIL])
  tw.win.userport:=port
  ModifyIDCMP(tw.win,IDCMP_MOUSEBUTTONS OR IDCMP_CLOSEWINDOW OR
                                    IDCMP_NEWSIZE OR ARROWIDCMP OR
                                    IDCMP_DISKINSERTED OR IDCMP_DISKREMOVED OR
                                    SCROLLERIDCMP OR IDCMP_MENUPICK)
  tw.win.userdata:=tw
  tw.op:=tw.win.width/3
  tw.vvisible:=(tw.win.height-tw.win.bordertop-tw.win.borderbottom)/16
  makescrollers(tw)
  tw.tree:=NEW [NIL, NIL, NIL, WORKBENCH, NIL, 1, StrCopy(String(10),'Portrait'), icons[7].bmp, 0, NIL]:node
  addbackdrop(tw)
  tw.devices:=NEW [NIL, NIL, NIL, DEVICES, NIL, 1, StrCopy(String(12), 'Devices'), icons[1].bmp, 0, NIL]:node
  IF tw.tree.child=NIL THEN tw.tree.child:=tw.devices
  IF tw.tree.lastchild<>NIL
    tw.tree.lastchild.next:=tw.devices
    tw.tree.lastchild.lastnode:=0
  ENDIF
  tw.tree.lastchild:=tw.devices
  adddevices(tw)
  tw.open:=tw.devices
  tw.vtotchange:=TRUE
  updatedevices(tw)
  drawtree(tw)
  opencnt++
  first:=tw.win
  nd++
EXCEPT
  IF tw
    IF tw.menus
      SetMenuStrip(tw.win, NIL)
      FreeMenus(tw.menus)
    ENDIF
    IF tw.win THEN CloseWindow(tw.win)
    IF tw.glist THEN FreeGadgets(tw.glist)
    END tw
    tw:=NIL
  ENDIF
ENDPROC tw

PROC closetw(tw:PTR TO tw)
  tw.win.userport:=NIL
  ModifyIDCMP(tw, 0)
  tw.win.userdata:=NIL
  SetMenuStrip(tw.win, NIL)
  FreeMenus(tw.menus)
  CloseWindow(tw.win)
  FreeGadgets(tw.glist)
  END tw
  opencnt--
ENDPROC

PROC error(body)
ENDPROC EasyRequestArgs(NIL,[20,0,0,body,'Ok'],0,NIL)

PROC copyImageToChip(data)
  DEF mem
  mem:=NewM(11*2, MEMF_CHIP)
  CopyMem(data, mem, 11*2)
ENDPROC mem

PROC adddevices(tw:PTR TO tw)
  DEF dlist:PTR TO doslist, name, startup:PTR TO filesysstartupmsg,
      device, unit, flags, tdport, tdio:PTR TO iostd, type,
      err, p, sc:scsicmd, data:PTR TO CHAR, cmd[6]:ARRAY OF CHAR,
      node:PTR TO node
  data:=NewM(252, MEMF_CHIP)
  IF tdport:=CreateMsgPort()
    IF tdio:=CreateIORequest(tdport, SIZEOF iostd)
      dlist:=LockDosList(LDF_READ OR LDF_DEVICES)
      IF dlist
        dlist:=NextDosEntry(dlist, LDF_READ OR LDF_DEVICES)
        WHILE (dlist)
          IF dlist.type=DLT_DEVICE
            name:=StrCopy(String(128),BADDR(dlist.name)+1,Char(BADDR(dlist.name)))
            StrAdd(name, ':')
            IF StrCmp(name, 'PRT:')=FALSE
            IF IsFileSystem(name)
              startup:=BADDR(dlist.startup)
              IF startup
                device:=StrCopy(String(Char(BADDR(startup.device))),BADDR(startup.device)+1,Char(BADDR(startup.device)))
                unit:=startup.unit
                flags:=startup.flags
                IF StrCmp(device, 'ramdrive.device')
                  type:=RAMDISK
                ELSEIF StrCmp(device, 'carddisk.device')
                  type:=DRIVE
                ELSEIF (OpenDevice(device, unit, tdio, flags)=NIL)
                  tdio.command:=HD_SCSICMD
                  tdio.length:=SIZEOF scsicmd
                  tdio.data:=sc
                  sc.data:=data
                  sc.length:=252
                  sc.command:=cmd
                  sc.cmdlength:=6
                  sc.flags:=SCSIF_READ
                  cmd[0]:=$12
                  cmd[1]:=0
                  cmd[2]:=0
                  cmd[3]:=0
                  cmd[4]:=252
                  cmd[5]:=0
                  err:=DoIO(tdio)
                  IF err=0
                    IF data[0]=DG_CDROM
                      type:=CDROM
                    ELSE
                      type:=HARDDISK
                    ENDIF
                  ELSE
                    tdio.command:=TD_GETNUMTRACKS
                    err:=DoIO(tdio)
                    p:=tdio.actual
                    IF (err=-1)
                      type:=DRIVE
                    ELSE
                      type:=FLOPPY
                    ENDIF
                  ENDIF
                  CloseDevice(tdio)
                ELSE
                  type:=DRIVE
                ENDIF
                DisposeLink(device)
              ELSE
                type:=DRIVE
                IF StrCmp(name, 'RAM:') THEN type:=RAMDISK
                IF StrCmp(name, 'NET:') THEN type:=NETWORK
              ENDIF
              node:=addchild(tw.devices, DEVICE, type, name, 1)
            ELSE
              DisposeLink(name)
            ENDIF
            ELSE
            DisposeLink(name)
            ENDIF
          ENDIF
          dlist:=NextDosEntry(dlist, LDF_READ OR LDF_DEVICES)
        ENDWHILE
        UnLockDosList(LDF_READ OR LDF_DEVICES)
      ENDIF
      DeleteIORequest(tdio)
    ENDIF
    DeleteMsgPort(tdport)
  ENDIF
ENDPROC

PROC unclipWindow(win:PTR TO window)
  DEF old_region
  IF old_region:=InstallClipRegion(win.wlayer, NIL)
    DisposeRegion(old_region)
  ENDIF
ENDPROC

PROC clipWindow(win:PTR TO window, minX, minY, maxX, maxY)
  DEF new_region, my_rectangle
  my_rectangle:=[minX, minY, maxX, maxY]:rectangle
  IF new_region:=NewRegion()
    IF OrRectRegion(new_region, my_rectangle)=FALSE
      DisposeRegion(new_region)
      new_region:=NIL
    ENDIF
  ENDIF
ENDPROC InstallClipRegion(win.wlayer, new_region)

PROC drawtree(tw:PTR TO tw)
  DEF curdepth=0, i, y, node[32]:ARRAY OF LONG, cur:PTR TO node, v, chk, offy
  Gt_GetGadgetAttrsA(tw.vertgadget, tw.win, NIL, [GTSC_TOP, {offy}, NIL])
  tw.offy:=offy
  Gt_GetGadgetAttrsA(tw.openvertgadget, tw.win, NIL, [GTSC_TOP, {offy}, NIL])
  tw.openoffy:=offy
  chk:=tw.offy*tw.vtotal*tw.vvisible
  IF (tw.vvisible+tw.offy)>tw.vtotal
    tw.offy:=Max(tw.vtotal-tw.vvisible, 0)
    updateprop(tw, tw.vertgadget, [GTSC_TOP, tw.offy, NIL])
  ENDIF
  SetDrMd(tw.win.rport, RP_JAM2)
  IF chk<>tw.oldchk
  clipWindow(tw.win, 0, ICONTOP, tw.op-sizeimage.width-1, tw.win.height-tw.win.borderbottom-tw.win.bordertop)
  tw.oldchk:=chk
  y:=-(tw.offy)+(ICONTOP/16)
  FOR i:=0 TO 31
    node[i]:=NIL
  ENDFOR
  node[0]:=tw.tree
  WHILE (curdepth>=0)
    cur:=node[curdepth]
    v:=y*16
    IF (v<ICONTOP) OR (v>(tw.win.height-tw.win.bordertop-tw.win.borderbottom))
      v:=-1
    ELSE
      v:=y
    ENDIF
    IF (cur.exp<>HIDE) AND (((cur.type<>FILE) AND (cur.type<>DIREMPTY)) OR (cur.parent=tw.tree))
    IF v>=0
    IF (tw.lines[v]<>cur) OR (cur=tw.sel) OR (cur=tw.oldsel)
    tw.lines[v]:=cur
    SetAPen(tw.win.rport, dri.pens[BACKGROUNDPEN])
    RectFill(tw.win.rport, 0, y*16, tw.op-sizeimage.width-1, y*16+15)
    SetAPen(tw.win.rport, dri.pens[TEXTPEN])
    IF (curdepth>0)
      Move(tw.win.rport, curdepth*16-11, y*16)
      Draw(tw.win.rport, curdepth*16-11, y*16+2)
      IF cur.lastnode=0
        Move(tw.win.rport, curdepth*16-11, y*16+14)
        Draw(tw.win.rport, curdepth*16-11, y*16+15)
      ENDIF
      IF (cur.exp=EXPAND) AND (cur.child=NIL)
        DrawImage(tw.win.rport, more, curdepth*16-16, y*16+3)
      ELSEIF (cur.exp=EXPAND)
        DrawImage(tw.win.rport, less, curdepth*16-16, y*16+3)
      ELSEIF (cur.lastnode=1)
        DrawImage(tw.win.rport, lastbranch, curdepth*16-16, y*16+3)
      ELSE
        DrawImage(tw.win.rport, branch, curdepth*16-16, y*16+3)
      ENDIF
    ENDIF
    IF (curdepth>1)
      FOR i:=0 TO curdepth-2
        cur:=node[i+1]
        IF cur.lastnode=0
          Move(tw.win.rport, i*16+5, y*16)
          Draw(tw.win.rport, i*16+5, y*16+15)
        ENDIF
      ENDFOR
      cur:=node[curdepth]
    ENDIF
    drawicontext(tw, cur, curdepth, y)
    ENDIF
    ENDIF
    y++
    ENDIF
    IF cur.child<>NIL
      curdepth++
      node[curdepth]:=cur.child
    ELSE
      IF cur.lastnode=1 THEN curdepth--
      IF curdepth>=0
        REPEAT
          cur:=node[curdepth]
          IF cur.lastnode=0
            node[curdepth]:=cur.next
          ELSE
            curdepth--
          ENDIF
        UNTIL (curdepth<0) OR (cur.lastnode=0)
      ENDIF
    ENDIF
  ENDWHILE
  IF (y*16)<=(tw.win.height-tw.win.bordertop-tw.win.borderbottom)
    SetAPen(tw.win.rport, dri.pens[BACKGROUNDPEN])
    RectFill(tw.win.rport, 0, y*16, tw.op-sizeimage.width-1, tw.win.height-tw.win.bordertop-tw.win.borderbottom)
  ENDIF
  unclipWindow(tw.win)
  IF tw.vtotchange
    tw.vtotal:=y+tw.offy
    updateprop(tw, tw.vertgadget, [GTSC_TOTAL,tw.vtotal, NIL])
  ENDIF
  IF y<=63
    FOR i:=y TO 63
      tw.lines[i]:=NIL
    ENDFOR
  ENDIF
  ENDIF
  SetAPen(tw.win.rport, dri.pens[SHINEPEN])
  Move(tw.win.rport, tw.op, ICONTOP)
  Draw(tw.win.rport, tw.op, tw.win.height-tw.win.borderbottom-tw.win.bordertop)
  SetAPen(tw.win.rport, dri.pens[SHADOWPEN])
  Move(tw.win.rport, tw.op+1, ICONTOP)
  Draw(tw.win.rport, tw.op+1, tw.win.height-tw.win.borderbottom-tw.win.bordertop)
  chk:=tw.openoffy*tw.openvtotal*tw.vvisible
  IF (tw.vvisible+tw.openoffy)>tw.openvtotal
    tw.openoffy:=Max(0, tw.openvtotal-tw.vvisible)
    updateprop(tw, tw.openvertgadget, [GTSC_TOP, tw.openoffy, NIL])
  ENDIF
  IF chk<>tw.openoldchk
    clipWindow(tw.win, tw.op+2, ICONTOP, tw.win.width-tw.win.borderleft-tw.win.borderright-sizeimage.width-1, tw.win.height-tw.win.borderbottom-tw.win.bordertop)
    tw.openoldchk:=chk
    cur:=tw.open.child
    curdepth:=1
    y:=-(tw.openoffy)+(ICONTOP/16)
    IF cur
      REPEAT
        IF curdepth=0 THEN cur:=cur.next
        v:=y*16
        IF (v<ICONTOP) OR (v>(tw.win.height-tw.win.bordertop-tw.win.borderbottom))
          v:=-1
        ELSE
          v:=y
        ENDIF
        IF cur.exp<>HIDE
          IF v>=0
            IF (tw.openlines[v]<>cur) OR (cur=tw.sel) OR (cur=tw.oldsel)
            tw.openlines[v]:=cur
            SetAPen(tw.win.rport, dri.pens[BACKGROUNDPEN])
            RectFill(tw.win.rport, tw.op+24, y*16, tw.win.width-tw.win.borderleft-tw.win.borderright-sizeimage.width-1, y*16+15)
            drawicontext(tw, cur, 0, y, 1)
            ENDIF
          ENDIF
          y++
        ENDIF
        curdepth:=0
      UNTIL cur.lastnode=1
    ENDIF
    IF (y*16)<=(tw.win.height-tw.win.bordertop-tw.win.borderbottom)
      SetAPen(tw.win.rport, dri.pens[BACKGROUNDPEN])
      RectFill(tw.win.rport, tw.op+2, y*16, tw.win.width-tw.win.borderleft-tw.win.borderright-sizeimage.width-1, tw.win.height-tw.win.bordertop-tw.win.borderbottom)
    ENDIF
    unclipWindow(tw.win)
     IF (tw.vtotchange=TRUE) OR (tw.openvtotchange=TRUE)
       tw.openvtotal:=y+tw.openoffy
       updateprop(tw, tw.openvertgadget, [GTSC_TOTAL,tw.openvtotal, NIL])
     ENDIF
  IF y<=63
    FOR i:=y TO 63
      tw.openlines[i]:=NIL
    ENDFOR
  ENDIF
  ENDIF
  tw.vtotchange:=FALSE
  tw.openvtotchange:=FALSE
ENDPROC

PROC updatedevices(tw:PTR TO tw)
  DEF node:PTR TO node, lock, devname[64]:STRING, colon=-2,
      tmp[64]:ARRAY OF CHAR
  node:=tw.devices.child
  REPEAT
    IF colon<>-2 THEN node:=node.next
    colon:=InStr(node.name, ':')
    StrCopy(devname, node.name, colon+1)
    IF lock:=Lock(devname, ACCESS_READ)
      NameFromLock(lock, tmp, 64)
      StringF(node.name, '\s [\s]', devname, tmp)
      UnLock(lock)
      IF node.exp<>EXPAND
        node.exp:=EXPAND
        tw.oldchk:=-1
        IF tw.open=tw.devices THEN tw.openoldchk:=-1
      ENDIF
    ELSE
      IF node.exp<>HIDE
        node.exp:=HIDE
        tw.oldchk:=-1
        IF tw.open=tw.devices THEN tw.openoldchk:=-1
      ENDIF
    ENDIF
  UNTIL node.lastnode=1
  drawtree(tw)
ENDPROC

PROC drawsel(tw:PTR TO tw)
  DEF curdepth=0, i, y, node[32]:ARRAY OF LONG, cur:PTR TO node, v
  SetDrMd(tw.win.rport, RP_JAM2)
  clipWindow(tw.win, 0, ICONTOP, tw.op-sizeimage.width-1, tw.win.height-tw.win.borderbottom-tw.win.bordertop)
  y:=-(tw.offy)+(ICONTOP/16)
  FOR i:=0 TO 31
    node[i]:=NIL
  ENDFOR
  node[0]:=tw.tree
  WHILE (curdepth>=0)
    cur:=node[curdepth]
    v:=y*16
    IF (v<ICONTOP) OR (v>(tw.win.height-tw.win.bordertop-tw.win.borderbottom))
      v:=-1
    ELSE
      v:=y
    ENDIF
    IF (cur.exp<>HIDE) AND ((cur.type<>FILE) OR (cur.parent=tw.tree))
    IF v>=0
      IF tw.sel=cur THEN drawicontext(tw, cur, curdepth, y)
      IF tw.oldsel=cur THEN drawicontext(tw, cur, curdepth, y)
    ENDIF
    y++
    ENDIF
    IF cur.child<>NIL
      curdepth++
      node[curdepth]:=cur.child
    ELSE
      IF cur.lastnode=1 THEN curdepth--
      IF curdepth>=0
        REPEAT
          cur:=node[curdepth]
          IF cur.lastnode=0
            node[curdepth]:=cur.next
          ELSE
            curdepth--
          ENDIF
        UNTIL (curdepth<0) OR (cur.lastnode=0)
      ENDIF
    ENDIF
  ENDWHILE
  unclipWindow(tw.win)
    clipWindow(tw.win, tw.op+2, ICONTOP, tw.win.width-tw.win.borderleft-tw.win.borderright-sizeimage.width-1, tw.win.height-tw.win.borderbottom-tw.win.bordertop)
    cur:=tw.open.child
    curdepth:=1
    y:=-(tw.openoffy)+(ICONTOP/16)
    IF cur
      REPEAT
        IF curdepth=0 THEN cur:=cur.next
        v:=y*16
        IF (v<ICONTOP) OR (v>(tw.win.height-tw.win.bordertop-tw.win.borderbottom))
          v:=-1
        ELSE
          v:=y
        ENDIF
        IF cur.exp<>HIDE
          IF v>=0
            IF tw.sel=cur THEN drawicontext(cur, 0, y, 1)
            IF tw.oldsel=cur THEN drawicontext(cur, 0, y, 1)
          ENDIF
          y++
        ENDIF
        curdepth:=0
      UNTIL cur.lastnode=1
    ENDIF
    unclipWindow(tw.win)
ENDPROC

PROC drawicontext(tw:PTR TO tw, node:PTR TO node, depth, y, o=0)
  DEF ty
  IF node.icon<>1
    IF node.icon THEN BltBitMapRastPort(node.icon, 0, 0, tw.win.rport, depth*16+(o*(tw.op+8)), y*16, 16, 16, $c0)
    IF (node.icon<>NIL) OR (o=1) THEN depth++
    IF node=tw.sel
      SetBPen(tw.win.rport, dri.pens[TEXTPEN])
      SetAPen(tw.win.rport, IF dri.pens[HIGHLIGHTTEXTPEN]<>dri.pens[DETAILPEN] THEN dri.pens[HIGHLIGHTTEXTPEN] ELSE dri.pens[TEXTPEN]+1)
    ELSE
      SetAPen(tw.win.rport, dri.pens[TEXTPEN])
    ENDIF
  ELSE
    SetAPen(tw.win.rport, dri.pens[HIGHLIGHTTEXTPEN])
  ENDIF
  ty:=8-(tw.win.rport.font.ysize/2)+tw.win.rport.font.baseline+(y*16)
  Move(tw.win.rport, (depth*16)+(o*(tw.op+8)), ty)
  Text(tw.win.rport, node.name, StrLen(node.name))
  IF node=tw.sel
    SetBPen(tw.win.rport, dri.pens[BACKGROUNDPEN])
    ->SetAPen(tw.win.rport, dri.pens[TEXTPEN])
  ENDIF
ENDPROC

PROC loadicons()
  DEF name[64]:STRING, bmp, list:PTR TO LONG, i
  list:=['CDROM', 'Devices', 'Drive', 'Floppy', 'Folder', 'Network', 'RAMDisk', 'Portrait', 'HardDisk', 'File', 'Group']
  FOR i:=0 TO 10
    StringF(name, 'Icons/ProjectManager/\s.bsh', list[i])
    icons[i].dto:=NewDTObjectA(name, [DTA_GROUPID, GID_PICTURE,
                                      PDTA_SCREEN, scr,
                                      PDTA_REMAP, TRUE,
                                      OBP_PRECISION, PRECISION_ICON,
                                      NIL])
    IF icons[i].dto<>NIL
      IF DoDTMethodA(icons[i].dto,NIL,NIL,[DTM_PROCLAYOUT,NIL,1])=NIL
        DisposeDTObject(icons[i].dto)
        icons[i].dto:=NIL
      ELSE
        GetDTAttrsA(icons[i].dto, [PDTA_BITMAP, {bmp}, NIL])
        icons[i].bmp:=bmp
      ENDIF
    ENDIF
  ENDFOR
ENDPROC

PROC freeicons()
  DEF i
  FOR i:=0 TO 9
    IF icons[i].dto<>NIL
      DisposeDTObject(icons[i].dto)
    ENDIF
  ENDFOR
ENDPROC

#define RGB32(r,g,b) Shl(r,24)+Shl(r,16)+Shl(r,8)+r,\
                     Shl(g,24)+Shl(g,16)+Shl(g,8)+g,\
                     Shl(b,24)+Shl(b,16)+Shl(b,8)+b

PROC getpen(r,g,b)
  DEF pen
  pen:=ObtainBestPenA(scr.viewport.colormap,RGB32(r,g,b),
                                            [OBP_PRECISION, PRECISION_IMAGE,
                                             NIL])
ENDPROC pen

moredata:
INT %1111111111100000
INT %1000000000100000
INT %1000010000100000
INT %1000010000100000
INT %1000010000100000
INT %1011111110111100
INT %1000010000100000
INT %1000010000100000
INT %1000010000100000
INT %1000000000100000
INT %1111111111100000

lessdata:
INT %1111111111100000
INT %1000000000100000
INT %1000000000100000
INT %1000000000100000
INT %1000000000100000
INT %1011111110111100
INT %1000000000100000
INT %1000000000100000
INT %1000000000100000
INT %1000000000100000
INT %1111111111100000

branchdata:
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000011111111100
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000

lastbranchdata:
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000010000000000
INT %0000011111111100
INT %0000000000000000
INT %0000000000000000
INT %0000000000000000
INT %0000000000000000
INT %0000000000000000

/* Project		File
	New Window
	About			Open
	Quit			Information
					Rename
					Delete */
