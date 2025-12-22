OPT MODULE
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12'
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui'
#endif

MODULE 'intuition/intuition', 'intuition/gadgetclass',
       'libraries/gadtools',
       'tools/textlen',
       'gadtools','utility/tagitem'

EXPORT OBJECT windowify OF plugin
  disabled
PRIVATE
  gadget:PTR TO gadget
  label, winlabel, winxsize
  resize
ENDOBJECT

OBJECT sizeplug OF plugin
  xsize
ENDOBJECT
PROC sizeplug(xsize) OF sizeplug
  self.xsize:=xsize
ENDPROC
PROC min_size(ta,fh) OF sizeplug IS self.xsize,0


PROC windowify(label,winlabel=NIL,
             resizex=FALSE,resizey=FALSE,disabled=FALSE) OF windowify
  self.label:=IF label THEN label ELSE ''
  self.winlabel:=IF winlabel THEN winlabel ELSE self.label
  self.disabled:=disabled
  self.resize:=(IF resizex THEN RESIZEX ELSE 0) OR
               (IF resizey THEN RESIZEY ELSE 0)
ENDPROC

PROC end() OF windowify IS EMPTY

PROC min_size(ta,fh) OF windowify
  self.winxsize:=textlen(self.winlabel,ta)+48
ENDPROC textlen(self.label,ta)+16,fh+6

PROC will_resize() OF windowify IS self.resize

-> Don't need to define this:
->PROC render(ta,x,y,xs,ys,w) OF windowify IS EMPTY

PROC gtrender(gl,vis,ta,x,y,xs,ys,w) OF windowify
  -> Or, a gadget in the title bar would have also been nice...
  self.gadget:=CreateGadgetA(BUTTON_KIND,gl,
                 [x,y,xs,ys,self.label,ta,0,
                  PLACETEXT_IN,vis,NIL]:newgadget,
                 [GA_DISABLED,self.disabled,TAG_DONE])
  IF self.gadget=NIL THEN Raise("tlfy")
ENDPROC self.gadget

-> Don't need to define this:
-> PROC clear_render(win:PTR TO window) OF windowify IS EMPTY

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF windowify
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.gadget
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF windowify HANDLE
  DEF sp=NIL:PTR TO sizeplug
  NEW sp.sizeplug(self.winxsize)
  closewin(self.gh)
  easyguiA(self.winlabel,[ROWS, [PLUGIN,0,sp,TRUE] ], [EG_WTYPE, WTYPE_NOSIZE, EG_TOP, 0, EG_LEFT,  0, TAG_DONE])
EXCEPT DO
  openwin(self.gh)
  END sp
ENDPROC FALSE

PROC setdisabled(disabled=TRUE) OF windowify
  Gt_SetGadgetAttrsA(self.gadget,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.disabled:=disabled
ENDPROC
