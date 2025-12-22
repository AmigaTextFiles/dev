-> This is a small browser which shows how to use the module 'multiGUI'.
->
-> Note: multiGUI is an module which enable you to use several easyGUIs
->       at the same time (user could use every window at any time).
->       Shows how to use dynamic-created GUIs.

OPT OSVERSION=37
OPT PREPROCESS

MODULE 'exec/lists','exec/nodes',
       'dos/dos','dos/dosasl',
       'libraries/gadtools',
       'asl','libraries/asl',
       'utility/tagitem'
MODULE 'tools/EasyGUI',
       'tools/constructors',
       'tools/multiGUI'

RAISE "MEM"  IF String()=NIL

CONST MAXPATH=255,                -> Maximum path length
      TYPE_FILE=0,                -> Entry is an file
      TYPE_DIR=1                  -> entry is an directory
CONST PATHLENGTH=MAXPATH-1


OBJECT dir_node OF ln
  direntrytype
ENDOBJECT

OBJECT lister_data           -> every gui gets such an structure as info-value
  path                       -> path of this lister
  dirlist:PTR TO lh          -> contents fo this directory (list of dir_node)
  actentry:PTR TO dir_node   -> selected listentry
  gui_lv                     -> listview (easygui gadget); shows contents
  gui_txtname                -> textgadget; shows name of selected entry
  gui_txttype                -> textgadget; shows type of selected entry
  gl                         -> guientry of this gui
  ghandle:PTR TO guihandle   -> guihandle of this gui
ENDOBJECT

DEF mg=NIL:PTR TO multiGUI,
    filereq=NIL:PTR TO filerequester


->========================== Main START ======================================

PROC main() HANDLE
RAISE "SCR"  IF LockPubScreen()=NIL,
      "LIB"  IF OpenLibrary()=NIL,
      "aslr" IF AllocFileRequest()=NIL

DEF pubscreen=NIL

  NEW mg.multiGUI()
  mg.setStdScreen(pubscreen:=LockPubScreen(NIL))
  ScreenToFront(pubscreen)

  -> Open asl.library and alloc a filerequest.
  aslbase:=OpenLibrary(ASLNAME,37)
  filereq:=AllocAslRequest(ASL_FILEREQUEST,
                           [ASLFR_SCREEN, pubscreen,
                            ASLFR_TITLETEXT, 'Select a directory...',
                            ASLFR_DRAWERSONLY, TRUE,
                            TAG_DONE,0])

  -> create our first lister
  newLister()

  -> Wait for user-action. Stop when all gui's are closed.
  WHILE mg.getCounter()>0 DO mg.wait()

EXCEPT DO

  -> CleanUp
  IF filereq THEN FreeFileRequest(filereq)
  CloseLibrary(aslbase)

  END mg
  IF pubscreen THEN UnlockPubScreen(NIL,pubscreen)

  IF exception AND (exception<>"quit")
    /* Print error description */
    PrintF('Error: ')
    SELECT exception
      CASE "MEM"  ; PrintF('Not enough memory.\n')
      CASE "addp" ; PrintF('Path too long !?\n')
      CASE "LIB"  ; PrintF('Could not open library.\n')
      DEFAULT     ; PrintF('\s (\s)\n',[exception,0]:LONG,exceptioninfo)
    ENDSELECT
  ENDIF

ENDPROC

->========================== Main STOP =======================================

CHAR '$VER: multiGUI_Browser 0.05 (25.06.96)',0

->========================== Lister START ====================================

-> creates and initialize a new lister
PROC newLister(path=NIL) HANDLE
DEF gui=NIL,
    lister=NIL:PTR TO lister_data,
    listview,txtname,txttype,
    dummypath[MAXPATH]:STRING

  -> If no path was specified pop up an aslrqeuester.
  IF path=NIL
    IF AslRequest(filereq,NIL)=FALSE THEN RETURN
    path:=connectParts(dummypath,filereq.drawer,filereq.file)
  ENDIF

  -> our lister-structure
  NEW lister
  -> remember the path
  lister.path:=getFullName(path)
  -> create list of this directory
  lister.dirlist:=createDirList(path)

  -> create our gui (dynamical)
  gui:=NEW [ROWS,
         listview:=NEW [LISTV,{proc_listv},NIL,30,10,lister.dirlist,FALSE,0,0],
         txtname:=NEW [TEXT,'','Name',TRUE,3],
         txttype:=NEW [TEXT,'','Type',TRUE,3],
         NEW [EQCOLS,
           NEW [SBUTTON, {proc_browse},'Browse'],
           NEW [SBUTTON, {proc_parent},'Parent']
         ]
       ]

  -> remember the gui-elements
  lister.gui_lv:=listview
  lister.gui_txtname:=txtname
  lister.gui_txttype:=txttype

  -> open gui; Pass lister-structure as info-value
  lister.gl:=mg.addGUI(lister.path,gui,lister,NIL,NIL,
                       [NM_TITLE,0,'Filer',     NIL,0,0,NIL,
                        NM_ITEM, 0,'New lister','n',0,0,{proc_newlister},
                        NM_ITEM, 0,'Close this','c',0,0,NIL,
                        NM_ITEM, 0,NM_BARLABEL, NIL,0,0,NIL,
                        NM_ITEM, 0,'Close all', 'a',0,0,{proc_closeall},
                        NM_END]:newmenu)
  -> store guihandle
  lister.ghandle:=mg.getGUIHandle(lister.gl)

  -> Set action-funcs of this gui. 'std_disposegui' dispose our
  -> dynamical guilist and the lister-structure
  -> (therefore we store the lister-structure as userdata before)
  mg.setGUIUserData(lister.gl,lister)
  mg.setGUIProcs(lister.gl,NIL,{std_disposegui})

EXCEPT

  -> there went something wrong.
  -> dispose data-structures
  disposeLister(lister)
  IF gui THEN disposegui(gui)

  -> and inform the user
  userRequest('Could not create GUI','Ok')

ENDPROC

-> Disposes a lister-structure
PROC disposeLister(lister:PTR TO lister_data)

  IF lister
    -> dispose directorylist
    disposeDirList(lister.dirlist)
    -> dispose path-string
    IF lister.path THEN DisposeLink(lister.path)
    -> dispose listerstructure
    END lister
  ENDIF

ENDPROC

->======================== Lister STOP =======================================


->=================== action-procs of gui START ==============================

-> This is the action function of the listview.
PROC proc_listv(info:PTR TO lister_data,num_selected)

  -> set active listviewentry. (easygui does nothing (v3.2). bug??)
  setlistvselected(info.ghandle,info.gui_lv,num_selected)
  -> get actual entry (:PTR TO dir_node)
  info.actentry:=getListEntry(info.dirlist,num_selected)
  -> put filename and type of current entry into textgadget
  settext(info.ghandle,info.gui_txtname,info.actentry.name)
  settext(info.ghandle,info.gui_txttype,
          IF info.actentry.direntrytype=TYPE_FILE THEN 'File' ELSE 'Directory')

ENDPROC

-> Action function of 'browse'-button
PROC proc_browse(info:PTR TO lister_data)
DEF stri[MAXPATH]:STRING

  IF info.actentry
    IF info.actentry.direntrytype=TYPE_DIR
      -> If it the active entry is an directory, open a new lister
      -> with that path
      newLister(connectParts(stri,info.path,info.actentry.name))
    ELSE
      -> If not, inform the user.
      userRequest('Could not browse into a file','Ok')
    ENDIF
  ENDIF

ENDPROC

-> Action function of 'parent'-button
PROC proc_parent(info:PTR TO lister_data)

  -> get parent.
  SetStr(info.path,PathPart(info.path)-info.path)
  -> update window title
  SetWindowTitles(info.ghandle.wnd,info.path,-1)

  -> initialize new listview contents
  setlistvlabels(info.ghandle,info.gui_lv,-1)
  disposeDirList(info.dirlist)
  info.dirlist:=createDirList(info.path)
  info.actentry:=NIL
  setlistvlabels(info.ghandle,info.gui_lv,info.dirlist)

  -> reset textgadgets
  settext(info.ghandle,info.gui_txtname,'')
  settext(info.ghandle,info.gui_txttype,'')

ENDPROC

-> Is called by menu 'Filer/Close all'. Closes all guis.
PROC proc_closeall(info:PTR TO lister_data) IS Raise("quit")

-> Is called by menu 'Filer/New lister'. Opens a new lister.
PROC proc_newlister(info:PTR TO lister_data) IS newLister()

-> Disposes a dynamical created gui. This is the action function of an gui.
PROC std_disposegui(mg:PTR TO multiGUI,gl,res)

  -> Dispose the guilist
  disposegui(mg.getGUIDescription(gl))
  -> dispose the lister-structure (stored in the userdata-field)
  disposeLister(mg.getGUIUserData(gl))

ENDPROC

->=================== action procs of gui STOP================================


->======================= DirList START ======================================

-> creates a new dir_node. 'name' is *not* stored but copied.
-> Returns the new node.
PROC createDirNode(name=NIL,type=0,pri=0,user=0) HANDLE
DEF ln=NIL:PTR TO dir_node

  NEW ln
  -> create new string, copy 'name' into it, add '/' to directories.
  ln.name:=StringF(String(StrLen(name)+1),'\s\s',name,IF user=TYPE_DIR THEN '/' ELSE NIL)
  ln.pri:=pri
  ln.type:=type
  ln.direntrytype:=user

EXCEPT
  -> something went wrong, free structures.
  disposeDirNode(ln)
  ReThrow()

ENDPROC ln

-> Disposes a dir_node allocated with createDirNode().
PROC disposeDirNode(ln:PTR TO dir_node)

  IF ln
    IF ln.name THEN DisposeLink(ln.name)
    END ln
  ENDIF

ENDPROC

-> creates a list (:PTR TO lh) of the directory 'path'
PROC createDirList(path) HANDLE
DEF info:PTR TO fileinfoblock,
    anchor=NIL:PTR TO anchorpath,
    mypath[MAXPATH]:STRING,
    error,
    fullpath,
    lh=NIL

  -> add wildcard
  connectParts(mypath,path,'#?')
  -> create new listheader
  lh:=newlist()

  /* Create and initialize anchor structure needed for
  ** scanning through directory.
  ** This structure has no fixed size.
  */
  anchor:=NewR(SIZEOF anchorpath+MAXPATH)
  anchor.strlen:=PATHLENGTH

  -> Get start of string
  fullpath:=anchor+SIZEOF anchorpath

  error:=MatchFirst(mypath,anchor)
  WHILE error=DOSFALSE

    info:=anchor.info                           -> get fileinfoblock
    IF info.direntrytype>0                      -> is it a directory ?

      AddTail(lh,createDirNode(info.filename,NT_USER,0,TYPE_DIR))

    ELSE

      AddTail(lh,createDirNode(info.filename,NT_USER,0,TYPE_FILE))

    ENDIF

    error:=MatchNext(anchor)                    -> Next entry
  ENDWHILE

EXCEPT DO

  IF anchor
    MatchEnd(anchor)                            -> Clean up
    Dispose(anchor)
  ENDIF
  IF exception THEN disposeDirList(lh)          -> only dispose on error

  ReThrow()

ENDPROC lh

-> disposes a dirlist created with createDirList()
PROC disposeDirList(lh:PTR TO lh)
DEF ln:PTR TO dir_node

  IF lh
    WHILE ln:=RemTail(lh) DO disposeDirNode(ln)
    END lh
  ENDIF

ENDPROC

->========================= DirList STOP =====================================


->======================== Support Procs START ===============================

-> Returns the 'nr'th entry in the list 'lh'.
-> 'nr' have to be a valid number.
PROC getListEntry(lh:PTR TO lh,nr)
DEF i,ln:PTR TO dir_node

  ln:=lh.head
  FOR i:=1 TO nr DO ln:=ln.succ

ENDPROC ln

-> Adds the path- or filename 'addi' to the path 'path'.
-> The result is stored in 'dest'. Returns 'dest'
PROC connectParts(dest,path,addi)
RAISE "addp" IF AddPart()=DOSFALSE

  StrCopy(dest,path,ALL)
  AddPart(dest,addi,StrMax(dest))
  SetStr(dest,StrLen(dest))

ENDPROC dest

-> creates a new string, gets full name of 'path' into the new string.
-> returns the new string.
PROC getFullName(path)
DEF lock

  IF lock:=Lock(path,SHARED_LOCK)
    path:=String(MAXPATH)
    NameFromLock(lock,path,StrMax(path))
    SetStr(path,StrLen(path))
    UnLock(lock)
  ENDIF

ENDPROC path


-> Pops up an Requester with 'text' as infotext, 'butt' as buttons and
-> 'args' as arguments to 'text'.
PROC userRequest(text,butt,args=NIL) IS
  EasyRequestArgs(NIL,[20,0,0,text,butt],0,args)

->======================== Support Procs STOP ================================

