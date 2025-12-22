-> Guigfx pictures
-> loading/saving
-> Separate task
-> clipwindow() wrapround

OPT REG=5
OPT LARGE
OPT PREPROCESS

MODULE '*easygui/easygui'

MODULE 'libraries/gadtools', 'gadtools'

MODULE 'datatypes', 'datatypes/pictureclass',
		 'datatypes/datatypesclass', 'datatypes/datatypes'

MODULE 'wb', 'workbench/workbench'

MODULE 'layers', 'graphics/clip'

MODULE 'utility', 'utility/tagitem'

MODULE 'intuition', 'intuition/intuition', 'intuition/screens'

MODULE 'locale', 'libraries/locale'

MODULE 'graphics/text', 'graphics/gfx', 'graphics/rastport'

MODULE 'exec/lists', 'exec/nodes'

MODULE 'exec/io', 'devices/trackdisk', 'dos/dosextens', 'dos/filehandler',
		 'devices/scsidisk', 'exec/memory', 'dos/dos'

ENUM ERR_OPENLIB=1, ERR_LOCKPUBSCREEN,
	  ERR_CREATEMENUS, ERR_LAYOUTMENUS,
	  ERR_GETSCREENDRAWINFO

OBJECT info
	gh:PTR TO guihandle
	tree:PTR TO tree
	files:PTR TO files
ENDOBJECT

OBJECT tree OF plugin
	vertgadget:PTR TO gadget
	horizgadget:PTR TO gadget
   drives:PTR TO treenode
	top:PTR TO treenode
	tree:PTR TO treenode
   totalvis
   sel:PTR TO treenode
   mousex, mousey
   fh
   width, height
   maxviewpos
ENDOBJECT

OBJECT treenode OF ln
	type:CHAR
	subtype:CHAR
	parent:PTR TO treenode
	children:PTR TO lh
	flags:INT
	depth:INT
	x:INT
	y:INT
   volume:PTR TO CHAR
   picture
   bitmap:PTR TO bitmap
ENDOBJECT

OBJECT files OF plugin
	parent:PTR TO treenode
	sel:PTR TO treenode
	mousex, mousey
	width, height
	vertgadget:PTR TO gadget
	horizgadget:PTR TO gadget
	offx,offy
ENDOBJECT

SET TNF_PRESERVE, TNF_EXPANDED, TNF_ROOT, TNF_CONTAINERS, TNF_FILES, TNF_LAST

OBJECT locale
  catalog:PTR TO catalog
ENDOBJECT

ENUM MENU_PROJECT=1, MENU_ABOUT, MENU_ABOUT_SHORTCUT, MENU_QUIT,
	  MENU_QUIT_SHORTCUT, STR_APPNAME, STR_ABOUT, STR_ABOUTSTRING,
	  MENU_NEW, MENU_NEW_SHORTCUT, STR_OK, STR_EXIT, STR_ERROR,
	  STR_LIBOPEN

DEF locale=NIL:PTR TO locale

DEF mh=NIL:PTR TO multihandle

DEF scr=NIL:PTR TO screen, dri=NIL:PTR TO drawinfo

ENUM ROOT, DRIVES, CONTAINER, FILE
ENUM DRAWER, VOLUME, CDROM, FLOPPY, NETWORK, RAMDISK, HARDDISK
ENUM DATA, IMAGE

DEF thumbwidth=64, thumbheight=48

CONST THUMBHSPACING=12
CONST THUMBVSPACING=4

PROC init() OF locale
  self.catalog:=OpenCatalogA(NIL, 'portrait.catalog', [OC_BUILTINLANGUAGE, 'english',
                                                       TAG_DONE]:tagitem)
  ->IF self.catalog=NIL THEN Raise(ERR_OPENCATALOG)
ENDPROC

PROC end() OF locale
  IF self.catalog
    CloseCatalog(self.catalog)
    self.catalog:=NIL
  ENDIF
ENDPROC

PROC string(num) OF locale
  DEF defstrs:PTR TO LONG
  defstrs:=[NIL,'Project', 'About', '?', 'Quit', 'Q', 'Project Manager', 'About', 'Project Manager\n© Christopher January 1998-1999\nPart of the Portrait package\nFreely distributable\nAll other rights reserved\nBy use of this software you\nagreee to the disclaimer', 'New window', 'N', 'Ok', 'Exit', 'Error', 'Cannot open %s']:LONG
  IF self.catalog
    RETURN GetCatalogStr(self.catalog, num, defstrs[num])
  ELSE
    RETURN defstrs[num]
  ENDIF
ENDPROC

PROC main() HANDLE
	DEF libname
	IF (localebase:=OpenLibrary(libname:='locale.library', 38))=NIL THEN Throw(ERR_OPENLIB, libname)
   NEW locale.init()
	IF (datatypesbase:=OpenLibrary(libname:='datatypes.library', 39))=NIL THEN Throw(ERR_OPENLIB, libname)
	IF (gadtoolsbase:=OpenLibrary(libname:='gadtools.library', 39))=NIL THEN Throw(ERR_OPENLIB, libname)
	IF (workbenchbase:=OpenLibrary(libname:='workbench.library', 39))=NIL THEN Throw(ERR_OPENLIB, libname)
	IF (layersbase:=OpenLibrary(libname:='layers.library', NIL))=NIL THEN Throw(ERR_OPENLIB, libname)
	IF (utilitybase:=OpenLibrary(libname:='utility.library', 37))=NIL THEN Throw(ERR_OPENLIB, libname)
	IF (scr:=LockPubScreen(NIL))=NIL THEN Raise(ERR_LOCKPUBSCREEN)
	IF (dri:=GetScreenDrawInfo(scr))=NIL THEN Raise(ERR_GETSCREENDRAWINFO)
	mh:=multiinit()
	opentree()
	multiloop(mh)
EXCEPT DO
	IF locale
		SELECT exception
			CASE ERR_OPENLIB
				error(locale.string(STR_LIBOPEN), locale.string(STR_EXIT), [exceptioninfo])
		ENDSELECT
	ELSE
		error('Cannot open locale.library', 'Exit', NIL)
	ENDIF
	IF mh THEN cleanmulti(mh)
	IF dri THEN FreeScreenDrawInfo(scr, dri)
	IF scr THEN UnlockPubScreen(NIL, scr)
	IF utilitybase THEN CloseLibrary(utilitybase)
	IF layersbase THEN CloseLibrary(layersbase)
	IF workbenchbase THEN CloseLibrary(workbenchbase)
	IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
	IF locale THEN END locale
	IF localebase THEN CloseLibrary(localebase)
ENDPROC

PROC request(title,body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,title,body,gadgets],0,args)

PROC error(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,'Error',body,gadgets],0,args)

PROC tree_action(info:PTR TO info, tree:PTR TO tree)
	info.files.setdrawer(tree.sel)
ENDPROC

PROC tree_appmessage(tree:PTR TO tree, info:PTR TO info, amsg:PTR TO appmessage)
ENDPROC

PROC files_action(info:PTR TO info, files:PTR TO files)
ENDPROC

PROC files_appmessage(files:PTR TO files, info:PTR TO info, amsg:PTR TO appmessage)
ENDPROC

PROC init() OF tree
	DEF tn:PTR TO treenode
	NEW tn
	tn.name:='Portrait'
	tn.type:=ROOT
   tn.parent:=NIL
   tn.flags:=TNF_PRESERVE OR TNF_EXPANDED OR TNF_CONTAINERS
   tn.depth:=0
   tn.succ:=[NIL,NIL,0,0,NIL]:ln
   self.totalvis:=1
   self.top:=tn
   self.tree:=tn
   tn:=self.addchild(tn, 'Devices', DRIVES, NIL, TNF_PRESERVE OR TNF_EXPANDED OR TNF_ROOT OR TNF_CONTAINERS)
	self.adddevices(tn)
	self.sel:=NIL
	self.drives:=tn
ENDPROC

PROC init() OF files
	self.parent:=NIL
	self.sel:=NIL
	self.offx:=0
	self.offy:=0
ENDPROC

PROC adddevices(parent:PTR TO treenode) OF tree
  DEF dlist:PTR TO doslist, startup:PTR TO filesysstartupmsg,
      device, unit, flags, tdport, tdio:PTR TO iostd, type,
      err, p, sc:scsicmd, data:PTR TO CHAR, cmd[6]:ARRAY OF CHAR,
      tn:PTR TO treenode,name[128]:STRING
  data:=NewM(252, MEMF_CHIP)
  IF tdport:=CreateMsgPort()
    IF tdio:=CreateIORequest(tdport, SIZEOF iostd)
      dlist:=LockDosList(LDF_READ OR LDF_DEVICES)
      IF dlist
        dlist:=NextDosEntry(dlist, LDF_READ OR LDF_DEVICES)
        WHILE (dlist)
          IF dlist.type=DLT_DEVICE
            StrCopy(name,BADDR(dlist.name)+1,Char(BADDR(dlist.name)))
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
                  type:=VOLUME
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
                      type:=VOLUME
                    ELSE
                      type:=FLOPPY
                    ENDIF
                  ENDIF
                  CloseDevice(tdio)
                ELSE
                  type:=VOLUME
                ENDIF
                DisposeLink(device)
              ELSE
                type:=VOLUME
                IF StrCmp(name, 'RAM:') THEN type:=RAMDISK
                IF StrCmp(name, 'NET:') THEN type:=NETWORK
              ENDIF
              tn:=self.addchild(parent, StrCopy(String(StrLen(name)+1),name), CONTAINER, type, TNF_PRESERVE)
              self.adddrawer(tn, NIL)
            ENDIF
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
  Dispose(data)
ENDPROC

PROC getpath(tn:PTR TO treenode) OF tree
	DEF tmp[256]:STRING, str
	str:=String(256)
	IF (tn.type=CONTAINER) AND (tn.subtype>DRAWER)
		IF tn.volume
			StringF(str, '\s:', tn.volume)
		ELSE
			StrCopy(str,tn.name)
		ENDIF
		RETURN str
	ENDIF
	StrCopy(str, tn.name)
	tn:=tn.parent
   WHILE (tn.volume=NIL) AND (tn.type<VOLUME)
      StringF(tmp, '\s/\s', tn.name, str)
      StrCopy(str, tmp)
      tn:=tn.parent
   ENDWHILE
   StringF(tmp, '\s:\s', IF tn.volume THEN tn.volume ELSE tn.name, str)
   StrCopy(str, tmp)
ENDPROC str

PROC addchild(parent:PTR TO treenode, name:PTR TO CHAR, type, subtype, flags=NIL) OF tree
	DEF tn:PTR TO treenode
	NEW tn
	tn.type:=type
	tn.bitmap:=NIL
   tn.parent:=parent
   tn.flags:=flags OR TNF_LAST
   tn.depth:=parent.depth+1
   tn.children:=NIL
   tn.subtype:=subtype
   IF parent.children=NIL
   	parent.children:=newlist()
   ELSE
   	parent.children.tailpred::treenode.flags:=parent.children.tailpred::treenode.flags AND Not(TNF_LAST)
   ENDIF
   newnode(tn, name)
   AddTail(parent.children, tn)
   IF parent.flags AND TNF_EXPANDED THEN self.totalvis:=self.totalvis+1
ENDPROC tn

PROC adddrawer(parent:PTR TO treenode, flags) OF tree
   DEF proc:PTR TO process,oldptr, lock, fib:PTR TO fileinfoblock, cont, type, path,
   	 tn:PTR TO treenode
   proc:=FindTask(NIL)
   oldptr:=proc.windowptr
   proc.windowptr:=-1
  	path:=self.getpath(parent)
   lock:=Lock(path, ACCESS_READ)
   DisposeLink(path)
   proc.windowptr:=oldptr
	IF lock
		IF fib:=AllocDosObject(DOS_FIB, NIL)
			IF flags AND TNF_EXPANDED
            cont:=Examine(lock, fib)
				IF (parent.type=CONTAINER) AND (parent.volume=NIL) AND (parent.subtype>DRAWER) THEN parent.volume:=StrCopy(String(StrLen(fib.filename)+1), fib.filename)
         	WHILE (cont)
         		cont:=ExNext(lock, fib)
         		IF cont
               	IF fib.direntrytype>0
               		type:=CONTAINER
               	ELSE
               		type:=FILE
               	ENDIF
               	tn:=self.addchild(parent, StrCopy(String(StrLen(fib.filename)+1), fib.filename), type, 0)
						IF (type=CONTAINER) THEN self.adddrawer(tn, NIL)
					ENDIF
         	ENDWHILE
         ELSE
         	cont:=Examine(lock, fib)
         	WHILE (cont)
         		cont:=ExNext(lock,fib)
         		IF cont
        				IF fib.direntrytype>0
         				parent.flags:=parent.flags OR TNF_CONTAINERS
         				JUMP _endskip
         			ENDIF
         		ENDIF
         	ENDWHILE
            _endskip:
            parent.flags:=parent.flags OR TNF_FILES
         ENDIF
			FreeDosObject(DOS_FIB, fib)
		ENDIF
		UnLock(lock)
	ENDIF
ENDPROC IF lock THEN TRUE ELSE FALSE

PROC will_resize() OF tree RETURN COND_RESIZEX OR RESIZEY

PROC will_resize() OF files RETURN RESIZEX OR RESIZEY

PROC min_size(ta:PTR TO textattr, fh) OF tree RETURN fh*6,fh*12
PROC min_size(ta:PTR TO textattr, fh) OF files RETURN fh*10,fh*12

PROC gtrender(gl, vis, ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF tree
	self.fh:=Max(ta.ysize,11)
	self.width:=xs
	self.height:=ys
	IF self.vertgadget THEN self.width:=self.width-self.vertgadget.width
	IF self.horizgadget THEN self.height:=self.height-self.horizgadget.height
	self.top.y:=0
	self.drawtree(win, self.top)
ENDPROC

PROC gtrender(gl, vis, ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF files
	self.width:=xs
	self.height:=ys
	IF self.vertgadget THEN self.width:=self.width-self.vertgadget.width
	IF self.horizgadget THEN self.height:=self.height-self.horizgadget.height
	self.drawfiles(win)
ENDPROC

PROC setdrawer(parent:PTR TO treenode) OF files
	->Semaphores
	   self.parent:=parent
	->ELSE
      ->Wait()
   ->ENDIF
	self.dofiles()
ENDPROC

PROC dofiles() OF files
	DEF oldparent:PTR TO treenode
	oldparent:=self.parent
   IF oldparent<>self.parent
   	closewin(self.gh)
   ->Grab semaphore
	self.layoutfiles()
	self.drawfiles(self.gh.wnd)
	->Release semaphore
ENDPROC

PROC layoutfiles() OF files
   DEF x,y,tn:PTR TO treenode
   x:=INTERWIDTH
   y:=INTERHEIGHT
   IF self.parent
   	IF self.parent.children
   		tn:=self.parent.children.head
   	   WHILE (tn.succ)
   	   	IF (tn.type=FILE) AND (tn.subtype=IMAGE)
   				tn.x:=x
   				tn.y:=y
   		   	x:=x+thumbwidth+THUMBHSPACING
	   			IF x>self.width
	   				x:=INTERWIDTH
	   				y:=y+thumbheight+THUMBVSPACING+(self.gh.wnd.rport.font.ysize*2)+2
					ENDIF
				ENDIF
				tn:=tn.succ
	   	ENDWHILE
	   ENDIF
   ENDIF
ENDPROC

PROC drawfiles(win:PTR TO window) OF files
	DEF tn:PTR TO treenode
	SetAPen(win.rport, dri.pens[BACKGROUNDPEN])
   RectFill(win.rport, self.x, self.y, self.x+self.width-1, self.y+self.height-1)
   clipWindow(win, self.x,self.y, self.x+self.width-1, self.y+self.height-1)
   IF self.parent
   	IF self.parent.children
   	   tn:=self.parent.children.head
   		WHILE (tn.succ)
   			IF (tn.type=FILE) AND (tn.subtype=IMAGE) THEN self.drawfile(win,tn)
				tn:=tn.succ
   		ENDWHILE
   	ENDIF
   ENDIF
   unclipWindow(win)
ENDPROC

PROC drawfile(win:PTR TO window, tn:PTR TO treenode) OF files
	DEF x,y,tw,fl,sl,strl,sfl,ssl
	x:=tn.x-self.offx+self.x
	y:=tn.y-self.offy+self.y
	SetAPen(win.rport, dri.pens[BLOCKPEN])
	RectFill(win.rport, x, y, x+thumbwidth-1, y+thumbheight-1)
	tw:=(thumbwidth/win.rport.font.ysize)+1
	fl:=String(tw+1)
	sl:=String(tw+1)
	strl:=StrLen(tn.name)
	IF self.sel<>tn
		SetAPen(win.rport, dri.pens[TEXTPEN])
		SetBPen(win.rport, dri.pens[BACKGROUNDPEN])
	ELSE
		SetAPen(win.rport, dri.pens[FILLTEXTPEN])
		SetBPen(win.rport, dri.pens[FILLPEN])
	ENDIF
   StrCopy(fl, tn.name, Min(strl, tw))
   Move(win.rport, x-(win.rport.font.ysize/2)+((tw-(sfl:=StrLen(fl)))/2*win.rport.font.ysize),y+thumbheight+2+win.rport.font.baseline)
   Text(win.rport, fl, sfl)
	IF strl>tw
		StrCopy(sl, tn.name+tw, Min(strl,tw))
		Move(win.rport, x-(win.rport.font.ysize/2)+((tw-(ssl:=StrLen(sl)))/2*win.rport.font.ysize), y+thumbheight+2+win.rport.font.baseline+win.rport.font.ysize)
		Text(win.rport, sl, ssl)
	ENDIF
ENDPROC

PROC drawtree(win:PTR TO window, tn:PTR TO treenode) OF tree
	DEF depth=0
	DEF xp,yp,viewpos,fh,height,width, i
	DEF pad,x,y
	x:=self.x
	y:=self.y
	SetDrMd(win.rport, RP_JAM2)
	width:=self.width
	height:=self.height
	fh:=self.fh
	viewpos:=tn.y
	LOOP
		IF (tn.type<>FILE)
			tn.y:=viewpos
      	yp:=(viewpos*fh)+y
      	viewpos++
      	self.drawnode(tn, fh, yp, width, win)
      	IF yp>height THEN JUMP _end
     	ENDIF
      ->IF (tn.children<>NIL) AND ((tn.flags AND TNF_EXPANDED)<>NIL)
      IF (tn.flags AND TNF_EXPANDED)
      	tn:=tn.children.head
      	->drawline
      ELSE
			WHILE (tn.succ.succ=NIL)
				tn:=tn.parent
				IF tn=NIL THEN JUMP _end
			ENDWHILE
			tn:=tn.succ
		ENDIF
	ENDLOOP
	_end:
	IF (yp+fh)<(y+height)
		SetAPen(win.rport, dri.pens[BACKGROUNDPEN])
		RectFill(win.rport, x, yp+fh, x+width-1, y+height-1)
	ENDIF
	self.maxviewpos:=viewpos
ENDPROC

ENUM LINE=1, BRANCH, PLUS, MINUS
CONST CONTINUES=16, TYPEMASK=15

PROC drawnode(tn:PTR TO treenode, fh, y, xs, win:PTR TO window) OF tree
   DEF fgpen, bgpen, vec=BRANCH, bl, text[256]:STRING, curdepth, xp,x
   x:=self.x
	clipWindow(win, x, y, Min(x+self.width-1, self.x+self.xs-1), Min(y+fh-1, self.y+self.ys-1))
   IF tn<>self.sel
		bgpen:=dri.pens[BACKGROUNDPEN]
		fgpen:=dri.pens[TEXTPEN]
	ELSE
		bgpen:=dri.pens[FILLPEN]
		fgpen:=dri.pens[FILLTEXTPEN]
	ENDIF
	SetAPen(win.rport, dri.pens[BACKGROUNDPEN])
	RectFill(win.rport, x, y, x+xs-1, y+fh-1)
   SetAPen(win.rport, fgpen)
   SetBPen(win.rport, bgpen)
   bl:=win.rport.font.baseline
   IF tn.volume=NIL
   	StrCopy(text, tn.name)
   ELSE
   	StringF(text, '\s [\s]', tn.name, tn.volume)
   ENDIF
	Move(win.rport, x+fh+(tn.depth*fh), y+bl+((fh-bl)/2))
	Text(win.rport, text, StrLen(text))
	IF tn.flags AND TNF_CONTAINERS
		IF tn.flags AND TNF_EXPANDED
			vec:=MINUS
		ELSE
			vec:=PLUS
		ENDIF
	ENDIF
	->IF (tn.succ.succ<>NIL) THEN vec:=vec OR CONTINUES
	IF (tn.flags AND TNF_LAST)=NIL THEN vec:=vec OR CONTINUES
	drawvector(win.rport, fh, x+(tn.depth*fh), y, vec)
	curdepth:=tn.depth
	xp:=x+(tn.depth*fh)-fh
   WHILE (curdepth>0)
   	tn:=tn.parent
   	IF (tn.succ.succ<>NIL) THEN drawvector(win.rport, fh, xp, y, LINE OR CONTINUES)
   	curdepth--
   	xp:=xp-fh
   ENDWHILE
	unclipWindow(win)
ENDPROC

PROC drawvector(rport:PTR TO rastport, fh, x, y, vec)
	DEF mfh, bdr, vt
	vt:=vec AND TYPEMASK
	SetAPen(rport, dri.pens[BLOCKPEN])
	mfh:=fh/2
	bdr:=fh/8
	IF vt=BRANCH
		Move(rport, x+mfh, y)
		Draw(rport, x+mfh, y+mfh)
      Draw(rport, x+fh-1, y+mfh)
		IF (vec AND CONTINUES)
			Move(rport, x+mfh, y+mfh)
			Draw(rport, x+mfh, y+fh-1)
		ENDIF
	ELSEIF (vt=MINUS) OR (vt=PLUS)
		Move(rport, x+bdr, y+bdr)
		Draw(rport, x+fh-1-bdr, y+bdr)
		Draw(rport, x+fh-1-bdr, y+fh-1-bdr)
		Draw(rport, x+bdr, y+fh-1-bdr)
		Draw(rport, x+bdr, y+bdr)
		Move(rport, x+mfh, y)
		Draw(rport, x+mfh, y+bdr)
      Move(rport, x+(bdr*2)+1, y+mfh)
      Draw(rport, x+fh-2-(bdr*2), y+mfh)
      IF (vt=PLUS)
      	Move(rport, x+mfh, y+(bdr*2)+1)
      	Draw(rport, x+mfh, y+fh-2-(bdr*2))
      ENDIF
		IF (vec AND CONTINUES)
			Move(rport, x+mfh, y+fh-1-bdr)
			Draw(rport, x+mfh, y+fh-1)
		ENDIF
	ELSEIF (vt=LINE)
		Move(rport, x+mfh, y)
		Draw(rport, x+mfh, y+fh-1)
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

PROC clear_render(win:PTR TO window) OF tree
ENDPROC

PROC clear_render(win:PTR TO window) OF files
ENDPROC

PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF tree
	self.mousex:=imsg.mousex
	self.mousey:=imsg.mousey
	IF ((imsg.class AND (IDCMP_MOUSEMOVE OR IDCMP_DISKINSERTED OR IDCMP_DISKREMOVED))<>NIL) THEN RETURN TRUE
   IF ((imsg.class AND (IDCMP_GADGETUP OR IDCMP_GADGETDOWN))<>NIL) THEN IF (imsg.iaddress=self.vertgadget) OR (imsg.iaddress=self.horizgadget) THEN RETURN TRUE
   IF (imsg.class AND IDCMP_MOUSEBUTTONS) THEN IF (imsg.mousex>=self.x) AND (imsg.mousey>=self.y) AND (imsg.mousex<(self.x+self.xs)) AND (imsg.mousey<(self.y+self.ys)) THEN RETURN TRUE
ENDPROC FALSE

PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF files
	self.mousex:=imsg.mousex
	self.mousey:=imsg.mousey
ENDPROC FALSE

PROC appmessage(amsg:PTR TO appmessage, win:PTR TO window) OF tree
	IF (amsg.mousex>=self.x) AND (amsg.mousey>=self.y) AND (amsg.mousex<(self.x+self.xs)) AND (amsg.mousey<(self.y+self.ys)) THEN RETURN TRUE
ENDPROC

PROC appmessage(amsg:PTR TO appmessage, win:PTR TO window) OF files
	IF (amsg.mousex>=self.x) AND (amsg.mousey>=self.y) AND (amsg.mousex<(self.x+self.xs)) AND (amsg.mousey<(self.y+self.ys)) THEN RETURN TRUE
ENDPROC

PROC message_action(class, qual, code, win:PTR TO window) OF tree
	DEF tn:PTR TO treenode, viewpos, xp, yp, oldsel=NIL:PTR TO treenode
	IF class=IDCMP_MOUSEBUTTONS
		IF code=SELECTDOWN
			viewpos:=(self.mousey-self.y)/self.fh
			IF viewpos<=self.maxviewpos
      		tn:=self.top
      		WHILE (tn.y<>viewpos) OR (tn.type=FILE)
      			->IF (tn.children<>NIL) AND ((tn.flags AND TNF_EXPANDED)<>NIL)
      			IF tn.flags AND TNF_EXPANDED
      				tn:=tn.children.head
      			ELSE
						WHILE (tn.succ.succ=NIL)
							tn:=tn.parent
							IF tn=NIL THEN JUMP _end
						ENDWHILE
						tn:=tn.succ
					ENDIF
				ENDWHILE
				IF tn<>NIL
      			IF (tn=self.sel)
      				IF tn.flags AND TNF_CONTAINERS
         				self.collapseexpand(tn)
         				self.drawtree(win, tn)
         			ENDIF
      			ELSE
      				IF self.sel THEN oldsel:=self.sel
      				self.sel:=tn
      				IF oldsel
							->xp:=(oldsel.depth*self.fh)+self.x
      					yp:=(oldsel.y*self.fh)+self.y
      					self.drawnode(oldsel, self.fh, yp, self.width, win)
      				ENDIF
						xp:=(tn.depth*self.fh)+self.x
						yp:=(viewpos*self.fh)+self.y
      				IF (tn.type=CONTAINER) AND (tn.children=NIL)
      					blockwin(self.gh)
      					self.adddrawer(tn, TNF_EXPANDED)
      					unblockwin(self.gh)
      				ENDIF
						IF (self.mousex>=xp) AND (self.mousex<(xp+self.fh))
							IF tn.flags AND TNF_CONTAINERS
								self.collapseexpand(tn)
								self.drawtree(win, tn)
								JUMP _skip3
							ENDIF
						ENDIF
						self.drawnode(tn, self.fh, yp, self.width-(tn.depth*self.fh), win)
						_skip3:
      				RETURN TRUE
      			ENDIF
      		ENDIF
				_end:
			ENDIF
		ENDIF
	ENDIF
ENDPROC FALSE

PROC message_action(class, qual, code, win:PTR TO window) OF files
ENDPROC FALSE

PROC collapseexpand(parent:PTR TO treenode) OF tree
   DEF tn:PTR TO treenode
	IF parent.flags AND TNF_EXPANDED
		parent.flags:=parent.flags-TNF_EXPANDED
		IF parent.children
			tn:=parent.children.head
			WHILE (tn.succ)
				IF (tn.type=CONTAINER) AND ((tn.flags AND TNF_EXPANDED)<>NIL) THEN self.collapse(tn)
				tn:=tn.succ
			ENDWHILE
		ENDIF
      ->self.collapse(parent)
	ELSE
		parent.flags:=parent.flags OR TNF_EXPANDED
	ENDIF
ENDPROC

PROC collapse(parent:PTR TO treenode) OF tree
   DEF tn:PTR TO treenode, lh:PTR TO lh, next:PTR TO ln
	IF parent.children
   	tn:=parent.children.head
   	WHILE (tn.succ)
   		next:=tn.succ
   		IF (tn.flags AND TNF_PRESERVE)=NIL
   			IF tn.children THEN self.collapse(tn)
   			IF tn.children=NIL
   				DisposeLink(tn.name)
   				Remove(tn)
					END tn
				ELSE
					tn.flags:=tn.flags AND Not(TNF_EXPANDED)
				ENDIF
			ELSEIF (tn.flags AND TNF_EXPANDED)
				tn.flags:=tn.flags AND Not(TNF_EXPANDED)
			ENDIF
         tn:=next
   	ENDWHILE
		lh:=parent.children
		IF lh.head.succ=NIL
   		END lh
   		parent.children:=NIL
   	ENDIF
   ENDIF
   IF (parent.type=CONTAINER) AND (parent.subtype>DRAWER)
   	IF parent.volume
   		DisposeLink(parent.volume)
   		parent.volume:=NIL
   	ENDIF
   ENDIF
   IF parent.flags AND TNF_EXPANDED THEN parent.flags:=parent.flags-TNF_EXPANDED
ENDPROC

PROC opentree() HANDLE
	DEF newmenu:PTR TO newmenu, tree:PTR TO tree, files:PTR TO files
	DEF info:PTR TO info, gh
	newmenu:=[NM_TITLE, NIL, locale.string(MENU_PROJECT), NIL, NIL, NIL, NIL,
				 NM_ITEM, NIL, locale.string(MENU_NEW), locale.string(MENU_NEW_SHORTCUT), NIL, NIL, {opentree},
  				 NM_ITEM, NIL, locale.string(MENU_ABOUT), locale.string(MENU_ABOUT_SHORTCUT), NIL, NIL, {menu_about},
             NM_ITEM, NIL, locale.string(MENU_QUIT), locale.string(MENU_QUIT_SHORTCUT), NIL, NIL, {menu_quit},
             NM_END, NIL, NIL, NIL, NIL, NIL, NIL]:newmenu
	NEW tree.init()
	NEW files.init()
   addmultiA(mh, locale.string(STR_APPNAME),
            [COLS,
            	[PLUGIN,{tree_action},tree,TRUE,{tree_appmessage}],
            	[BAR],
            	[PLUGIN,{files_action},files,TRUE,{files_appmessage}]
            ],
            [EG_SCRN, scr,
             EG_CLEAN, {tree_clean},
             EG_CLOSE, {tree_close},
             EG_INFO, info:=[gh, tree, files]:info,
             EG_GHVAR, {gh},
             EG_NEWMENU, newmenu,
             TAG_DONE])
	info.gh:=gh
EXCEPT
	IF gh=NIL
		IF files THEN END files
		IF tree THEN END tree
	ENDIF
	ReThrow()
ENDPROC

PROC menu_quit()
	quitgui()
ENDPROC

PROC menu_about()
	request(locale.string(STR_ABOUT), locale.string(STR_ABOUTSTRING), locale.string(STR_OK), NIL)
ENDPROC

PROC tree_close(info:PTR TO info)
	closewin(info.gh)
ENDPROC

PROC tree_clean(info:PTR TO info)
   DEF tree:PTR TO tree,files:PTR TO files
   tree:=info.tree
   END tree
   files:=info.files
   END files
ENDPROC

PROC newlist(lh=NIL:PTR TO lh,type=0)
  IF lh=NIL THEN lh:=NEW lh
  lh.head:=lh+4
  lh.tailpred:=lh
  lh.tail:=0
  lh.type:=0
  lh.pad:=0
ENDPROC lh

PROC newnode(ln=NIL:PTR TO ln,name=NIL,type=0,pri=0)
  IF ln=NIL THEN ln:=NEW ln
  ->ln.name:=StrCopy(String(StrLen(name)),name)
  ln.name:=name
  ln.pri:=pri
  ln.type:=type
ENDPROC ln
