OPT MODULE,OSVERSION=37
OPT PREPROCESS,REG=5


MODULE 'tools/EasyGUI', 'tools/textlen',
       'intuition/intuition', 'intuition/gadgetclass',
       'gadgets/button','intuition/screens','intuition/imageclass',
       'intuition/classes','intuition/classusr','utility/tagitem','intuition/icclass',
       'graphics/text','icon','wb','workbench/workbench'
MODULE 'class/iconifyb'


/*
 * File:         iconify.e
 * Description:  window iconify button plugin
 *
 * 1998, Piotr Gapiïski
 *
 */


RAISE "icfy" IF AddAppIconA()=NIL,
      "icfy" IF OpenLibrary()=NIL,
      "icfy" IF CreateMsgPort()=NIL

DEF iconbase  -> Redefine for privateness
#define DEFICON 'env:sys/def_tool'


EXPORT OBJECT iconify OF plugin
PRIVATE
  class    :PTR TO iclass
  gadget   :PTR TO gadget
  icon,label      :LONG
ENDOBJECT


PROC create(label=NIL,icon=NIL) OF iconify
  iconbase:=OpenLibrary('icon.library',37)
  self.class:=initIconifyButtonClass()
  IF (self.class=NIL) THEN Raise("icls")
  self.label:=IF label THEN label ELSE ''
  self.icon:=IF icon THEN icon ELSE DEFICON
ENDPROC


PROC end() OF iconify
  IF (self.gadget) THEN DisposeObject(self.gadget)
  IF (self.class) THEN FreeClass(self.class)
  IF (iconbase) THEN CloseLibrary(iconbase)
ENDPROC


PROC will_resize() OF iconify IS 0,0
PROC min_size(ta:PTR TO textattr, fontheight) OF iconify IS 0,0
PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF iconify
  IF (imsg.class=IDCMP_GADGETUP) THEN RETURN imsg.iaddress=self.gadget
ENDPROC FALSE
PROC message_action(class,qual,code,win:PTR TO window) OF iconify HANDLE
  DEF dobj=NIL:PTR TO diskobject, myport=NIL, appicon=NIL,
      appmsg:PTR TO appmessage

  closewin(self.gh)
  ->- Fallback to using a default icon if not found...
  ->-
  IF NIL=(dobj:=GetDiskObjectNew(self.icon)) THEN dobj:=GetDiskObjectNew(DEFICON)
  dobj.type:=NIL
  myport:=CreateMsgPort()
  appicon:=AddAppIconA(0,0,self.label,myport,NIL,dobj,NIL)
  WaitPort(myport)
EXCEPT DO
  IF (appicon) THEN RemoveAppIcon(appicon)
  IF (myport)
    ->- Clear away any messages that arrived at the last moment
    ->-
    WHILE appmsg:=GetMsg(myport) DO ReplyMsg(appmsg)
    DeleteMsgPort(myport)
  ENDIF
  IF dobj THEN FreeDiskObject(dobj)
  openwin(self.gh)
  AddGadget(self.gh.wnd,self.gadget,0)
  RefreshGList(self.gadget,self.gh.wnd,NIL,1)
ENDPROC FALSE

PROC clear_render(w:PTR TO window) OF iconify IS FALSE
PROC render(ta,x,y,xs,ys,w:PTR TO window) OF iconify
  DEF relpos=0
  DEF resolution,depthImage:PTR TO image,zoomImage:PTR TO image
  DEF screen:PTR TO screen,dinfo

  IF (self.gadget)=NIL
    screen:=w.wscreen
    dinfo:=GetScreenDrawInfo(screen)
    resolution:=IF (screen.flags AND SCREENHIRES) THEN SYSISIZE_MEDRES ELSE SYSISIZE_LOWRES
    depthImage:=NewObjectA(NIL,SYSICLASS,
      [
        SYSIA_DRAWINFO,  dinfo,
        SYSIA_WHICH,     DEPTHIMAGE,
        SYSIA_SIZE,      resolution,
        TAG_DONE
      ])
    zoomImage:=NewObjectA(NIL,SYSICLASS,
      [
        SYSIA_DRAWINFO,  dinfo,
        SYSIA_WHICH,     ZOOMIMAGE,
        SYSIA_SIZE,      resolution,
        TAG_DONE
      ])
    IF (zoomImage)AND(depthImage)
      relpos:=(4)-(depthImage.width+1)-(2*zoomImage.width)
      self.gadget:=NewObjectA(self.class,NIL,
        [
           GA_TOPBORDER, TRUE,
           GA_RELRIGHT,  relpos,
           GA_WIDTH,     zoomImage.width,
           GA_HEIGHT,    screen.barheight,
           GA_RELVERIFY, TRUE,
           TAG_DONE
        ])
    ENDIF
    IF (zoomImage) THEN DisposeObject(zoomImage)
    IF (depthImage) THEN DisposeObject(depthImage)
    FreeScreenDrawInfo(screen,dinfo)
    IF (self.gadget)=NIL THEN Raise("igad")
    AddGadget(w,self.gadget,0)
    RefreshGList(self.gadget,w,NIL,1)
  ELSE
    RefreshGList(self.gadget,w,NIL,1)
  ENDIF
ENDPROC
