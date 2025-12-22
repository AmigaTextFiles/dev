OPT     OSVERSION = 37

OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'tools/ghost'
MODULE  'tools/textlen'
MODULE  'intuition/intuition'
MODULE  'intuition/gadgetclass'
MODULE  'gadgets/tabs'

EXPORT  CONST   TABS = PLUGIN

EXPORT OBJECT tabs OF plugin
  current
  disabled
PRIVATE
  tabs:PTR TO gadget
  tabsbase
  tabslist
  max
ENDOBJECT

PROC tabs(tabslist,current=0,max=TRUE,disabled=FALSE) OF tabs
  self.tabsbase:=OpenLibrary('gadgets/tabs.gadget',37)
  IF self.tabsbase=NIL THEN Raise("tabs")
  self.tabslist:=tabslist
  self.current:=current
  self.max:=max
  self.disabled:=disabled
ENDPROC

PROC end() OF tabs
  IF self.tabsbase THEN CloseLibrary(self.tabsbase)
ENDPROC

PROC min_size(ta,fh) OF tabs
  DEF p:PTR TO tablabel, w=0, n=0
  p:=self.tabslist
  IF self.max
    WHILE p.label
      w:=Max(w,textlen(p.label,ta))
      n++
      p++
    ENDWHILE
    w:=w*n
  ELSE
    WHILE p.label
      w:=w+textlen(p.label,ta)
      n++
      p++
    ENDWHILE
  ENDIF
ENDPROC n*20+w+7,fh+5

PROC will_resize() OF tabs IS COND_RESIZEX

PROC render(ta,x,y,xs,ys,w) OF tabs
  self.tabs:=NewObjectA(NIL,'tabs.gadget',
                       [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs-1, GA_HEIGHT,ys,
                        GA_TEXTATTR,ta, GA_RELVERIFY,TRUE,
                        TABS_CURRENT,self.current, TABS_LABELS,self.tabslist,
                        LAYOUTA_CHILDMAXWIDTH,self.max,
                        GA_DISABLED,self.disabled, NIL])
  IF self.tabs=NIL THEN Raise("tabs")
  AddGList(w,self.tabs,-1,1,NIL)
  RefreshGList(self.tabs,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF tabs
  IF self.tabs
    RemoveGList(win,self.tabs,1)
    DisposeObject(self.tabs)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF tabs
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.tabs
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF tabs
  self.current:=code
ENDPROC TRUE

PROC setcurrent(x) OF tabs
  self.current:=x
  SetGadgetAttrsA(self.tabs,self.gh.wnd,NIL,[TABS_CURRENT,x,NIL])
ENDPROC

PROC setdisabled(disabled=TRUE) OF tabs
  SetGadgetAttrsA(self.tabs,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.disabled:=disabled
  IF disabled=FALSE
    unghost_clear(self.tabs,self.gh.wnd,self.x,self.y,self.xs,self.ys)
  ENDIF
ENDPROC
