OPT     OSVERSION = 37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'libraries/gadtools'
MODULE  'intuition/gadgetclass'
MODULE  'intuition/intuition'
MODULE  'gadgets/select'
MODULE  'selectgadget'
MODULE  'tools/textlen'

EXPORT  CONST   POPUP = PLUGIN

EXPORT OBJECT popup OF plugin
  item
 PRIVATE
  gad:PTR TO gadget
  labels
ENDOBJECT

DEF     selectgadgetbase

PROC popup(labels,item) OF popup
  IF (selectgadgetbase:=OpenLibrary('gadgets/select.gadget',40))=NIL THEN Raise("popg")
 self.labels:=labels
 self.item:=item
ENDPROC

PROC will_resize() OF popup IS RESIZEX

PROC min_size(ta,fh) OF popup
ENDPROC textlen(self.labels[0],ta),fh+4

PROC message_action(class,qual,code,win) OF popup 
 self.item:=code
ENDPROC TRUE

PROC render(ta,x,y,xs,ys,w) OF popup
 self.gad:=NewObjectA(NIL,'selectgclass',
       [GA_LEFT,        x,
        GA_TOP,         y,
        GA_RELVERIFY,   TRUE,
        GA_WIDTH,       xs,
        GA_HEIGHT,      ys,
        GA_DISABLED,    self.dis,
        SGA_LABELS,     self.labels,
        SGA_ACTIVE,     self.item,
        SGA_SEPARATOR,  TRUE,
        SGA_ITEMSPACING,2,
        SGA_FOLLOWMODE, SGFM_FULL,
        SGA_DROPSHADOW, TRUE,
        NIL,NIL])
  IF self.gad=NIL THEN Raise("popg")
  AddGList(w,self.gad,-1,1,NIL)
  RefreshGList(self.gad,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF popup
 IF self.gad
  RemoveGList(win,self.gad,1)
  DisposeObject(self.gad)
 ENDIF
 IF (selectgadgetbase<>NIL) THEN CloseLibrary(selectgadgetbase)
ENDPROC

PROC end()      OF popup
 IF self.gad
  IF (self.gh.wnd<>NIL) THEN RemoveGList(self.gh.wnd,self.gad,1)
  DisposeObject(self.gad)
 ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF popup
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.gad
  IF imsg.class=IDCMP_GADGETDOWN THEN RETURN imsg.iaddress=self.gad
ENDPROC FALSE

PROC disable(disabled=TRUE) OF popup
  SetGadgetAttrsA(self.gad,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.dis:=disabled
ENDPROC
