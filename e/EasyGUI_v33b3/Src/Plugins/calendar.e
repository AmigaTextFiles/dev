OPT MODULE

MODULE 'tools/EasyGUI', 'tools/textlen',
       'intuition/intuition', 'intuition/gadgetclass',
       'gadgets/calendar', 'graphics/text',
       'utility/date'

EXPORT OBJECT calendar OF plugin
  date:PTR TO clockdata
  disabled
PRIVATE
  calendar:PTR TO gadget
  calendarbase
  resize
ENDOBJECT

PROC calendar(date,resizex=FALSE,resizey=FALSE,disabled=FALSE) OF calendar
  self.calendarbase:=OpenLibrary('gadgets/calendar.gadget',37)
  IF self.calendarbase=NIL THEN Raise("cal")
  self.date:=date
  self.resize:=(IF resizex THEN RESIZEX ELSE 0) OR
               (IF resizey THEN RESIZEY ELSE 0)
  self.disabled:=disabled
ENDPROC

PROC end() OF calendar
  IF self.calendarbase THEN CloseLibrary(self.calendarbase)
ENDPROC

PROC min_size(ta,fh) OF calendar IS textlen('Wed',ta)+2*7,fh*7+13

PROC will_resize() OF calendar IS self.resize

PROC render(ta,x,y,xs,ys,w) OF calendar
  self.calendar:=NewObjectA(NIL,'calendar.gadget',
                           [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                            GA_TEXTATTR,ta, GA_RELVERIFY,TRUE,
                            GA_DISABLED,self.disabled,
                            CALENDAR_CLOCKDATA,self.date, NIL])
  IF self.calendar=NIL THEN Raise("cal")
  AddGList(w,self.calendar,-1,1,NIL)
  RefreshGList(self.calendar,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF calendar
  IF self.calendar
    RemoveGList(win,self.calendar,1)
    DisposeObject(self.calendar)
  ENDIF
ENDPROC

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF calendar
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.calendar
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF calendar
  self.date.mday:=code
ENDPROC TRUE

PROC setdate(date=NIL) OF calendar
  IF date THEN self.date:=date
  SetGadgetAttrsA(self.calendar,self.gh.wnd,NIL,[CALENDAR_CLOCKDATA,self.date,NIL])
ENDPROC

PROC setdisabled(disabled=TRUE) OF calendar
  SetGadgetAttrsA(self.calendar,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.disabled:=disabled
ENDPROC
