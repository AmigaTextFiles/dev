/*
**
** register PLUGIN
**
** Copyright: Ralph Wermke of Digital Innovations
** EMail    : wermke@gryps1.rz.uni-greifswald.de
** WWW      : http://www.user.fh-stralsund.de/~rwermke/di.html
**
** Version  : 1.1.2
** Date     : 15-Nov-1997
**
** ProgramID: 0001
**
** History:
**    03-Sep-1997:          V1.0 beta
**       - first beta release
**    02-Nov-1997:          V1.1
**       - some minor changes
**       - special values for ActivePage (FIRST,LAST,NEXT,PREV)
**         now also usable on init
**    05-Nov-1997:          V1.1.1
**       - enforcer hits removed
**    15-Nov-1997:          V1.1.2
**       - object name changed to register_plugin
**
*/

OPT OSVERSION=37
OPT PREPROCESS
OPT MODULE

->#define lite_version

#ifdef lite_version
   MODULE 'tools/EasyGUI_lite'
#endif

#ifndef lite_version
   MODULE 'tools/EasyGUI'
#endif

MODULE 'tools/textlen','tools/ghost',
       'graphics/text','graphics/rastport',
       'intuition/intuition','intuition/screens',
       'utility/tagitem','utility','utility/hooks',
       'amigalib/boopsi'


EXPORT OBJECT register_plugin OF plugin
PRIVATE
   titles      : PTR TO LONG
   current
->   oldvalue
   hook        : PTR TO hook
   disabled
   max
   mousex
   mousey

   shinepen
   shadowpen

   ta          : PTR TO textattr
ENDOBJECT

EXPORT CONST PLV_Register_ActivePage_First =  0,
             PLV_Register_ActivePage_Last  = -1,
             PLV_Register_ActivePage_Next  = -2,
             PLV_Register_ActivePage_Prev  = -3

-> TAG_USER  | PROG_ID<<16 | TAG_VALUE
-> $80000000 |   $0001<<16 | 0...

EXPORT ENUM  PLA_Register_Disabled=$80010001,
             PLA_Register_ActivePage,
             PLA_Register_Titles,
             PLA_Register_ActionHook



->>> register::register (Constructor)
PROC register(tags:PTR TO tagitem) OF register_plugin

   self.gh:=0     -> because it's not initialized
                  -> I need it to avoid drawing before gui is open
   self.hook:=NIL

   IF utilitybase:=OpenLibrary('utility.library', 37)

      self.disabled  :=GetTagData(PLA_Register_Disabled, FALSE, tags)
      self.titles    :=GetTagData(PLA_Register_Titles, NIL, tags)

      IF self.titles<>NIL
         IF ListLen(self.titles)>0
            self.max:=ListLen(self.titles)-1
         ELSE
            Raise("TITL")
         ENDIF
      ELSE
         Raise("TITL")
      ENDIF

      self.current:=0
      self.set(PLA_Register_ActivePage, GetTagData(PLA_Register_ActivePage, 0,tags))
      self.hook:=GetTagData(PLA_Register_ActionHook, NIL, tags)

      self.shinepen  :=2
      self.shadowpen :=1

      CloseLibrary(utilitybase)
   ELSE
      Raise("UTIL")
   ENDIF

ENDPROC
-><<

PROC will_resize() OF register_plugin IS RESIZEX

->>> register::min_size
PROC min_size(ta:PTR TO textattr, fh) OF register_plugin
DEF x=0, i

   FOR i:=0 TO self.max DO x:=Max(x, textlen(ListItem(self.titles, i), ta))
   /* 10 is minimum width without text */
   x:=(x+10)*(self.max+1)

ENDPROC x,fh+6
-><<

->>> register::render
PROC render(ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF register_plugin
DEF oldwin, dri:PTR TO drawinfo

   self.ta :=ta

   IF dri:=GetScreenDrawInfo(win.wscreen)
      self.shinepen :=dri.pens[SHINEPEN]
      self.shadowpen:=dri.pens[SHADOWPEN]
      FreeScreenDrawInfo(win.wscreen, dri)
   ENDIF

   oldwin:=self.gh.wnd
   self.gh.wnd:=win
   self.draw(TRUE)            /* full redraw */
   self.gh.wnd:=oldwin

ENDPROC
-><<

->>> register::draw
/* draws the full register */
PROC draw(redraw=FALSE) OF register_plugin
DEF i, labelnum, x, y, xs, ys, rp

   IF self.gh=0 THEN RETURN      /* ignore draw before gui is open */
   IF self.gh.wnd=0 THEN RETURN  /* ignore draw when window is closed */

   rp:=self.gh.wnd.rport
   x :=self.x
   y :=self.y
   xs:=self.xs
   ys:=self.ys

   labelnum:=self.max+1

   IF Not(redraw)
      /* clear full area */
      SetAPen(rp, 0)
      RectFill(rp, x, y, x+xs, y+ys)
   ENDIF

   FOR i:=0 TO labelnum-1
      self.drawRegister(x+(xs/labelnum*i), y, (xs/labelnum), ys, ListItem(self.titles, i), IF i<>self.current THEN FALSE ELSE TRUE)
   ENDFOR

   IF self.disabled THEN ghost(self.gh.wnd, x, y, xs, ys)

ENDPROC
-><<

->>> register::drawRegister
/* draws a single label */
PROC drawRegister(x, y, xs, ys, text, active=TRUE) OF register_plugin
DEF rp:REG, xxs:REG, yys:REG, itext, itext2, textx, texty, ta:REG PTR TO textattr

   rp:=self.gh.wnd.rport
   ta:=self.ta

   IF active=FALSE
      y:=y+2; ys:=ys-2
   ENDIF

   xxs:=x+xs; yys:=y+ys

   SetAPen(rp, self.shinepen)
   RectFill(rp, x+1, y+3, x+1, yys-1)
   RectFill(rp, x+4, y, xxs-4, y)
   WritePixel(rp, x+2, y+2)
   WritePixel(rp, x+3, y+1)
   SetAPen(rp, self.shadowpen)
   RectFill(rp, xxs-1, y+3, xxs-1, yys-1)
   WritePixel(rp, xxs-2, y+2)
   WritePixel(rp, xxs-3, y+1)

   IF active=FALSE
      SetAPen(rp, self.shinepen)
      RectFill(rp, x, yys, xxs, yys)
   ENDIF

   IF text
      textx :=x+((xs-textlen(text, ta))/2)+1
      texty :=y+((ys-ta.ysize)/2)+1
      itext :=[self.shadowpen, 0, RP_JAM1, textx, texty, ta, text, NIL]:intuitext
      itext2:=[self.shinepen, 0, RP_JAM1, textx+1, texty+1, ta, text, itext]:intuitext
      PrintIText(rp, IF active THEN itext2 ELSE itext, 0, 0)
   ENDIF

ENDPROC
-><<

->>> register::message_test
PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF register_plugin

   IF self.disabled THEN RETURN FALSE

   IF (imsg.class=IDCMP_MOUSEBUTTONS) AND (imsg.code=SELECTUP)
      /* store hit point */
      self.mousex:=win.mousex
      self.mousey:=win.mousey
      /* check boundaries */
      IF (self.mousex>=self.x) AND (self.mousex<=(self.x+self.xs)) AND (self.mousey>=(self.y+2)) AND (self.mousey<=(self.y+self.ys))
         RETURN TRUE
      ENDIF
   ENDIF

ENDPROC FALSE
-><<

->>> register::message_action
PROC message_action(class, qual, code, win:PTR TO window) OF register_plugin
DEF i, labelnum:REG, left, right, break=FALSE

   labelnum:=self.max+1

   FOR i:=0 TO labelnum-1
      IF i<>self.current                     /* ignore current label */
         left  :=self.x+(self.xs/labelnum*i)
         right :=left+(self.xs/labelnum)
         IF (self.mousex>left) AND (self.mousex<right) THEN break:=TRUE
      ENDIF
      EXIT break
   ENDFOR

   IF break
      self.current:=i
      self.draw()                            /* update */
      IF self.hook<>NIL THEN callHookA(self.hook, self, self.current)
      RETURN TRUE
   ENDIF

ENDPROC FALSE
-><<

->>> register::set
PROC set(attr, value) OF register_plugin

   SELECT attr
      CASE PLA_Register_Disabled
         IF value
            self.disabled:=TRUE
            IF self.gh<>0           /* ignore draw before gui is open */
               IF self.gh.wnd<>0    /* ignore draw when window is closed */
                  IF self.gh.wnd THEN ghost(self.gh.wnd, self.x, self.y, self.xs, self.ys)
               ENDIF
            ENDIF
         ELSE
            self.disabled:=FALSE
            self.draw()             /* update */
         ENDIF
      CASE PLA_Register_ActivePage
         IF (value>=0) AND (value<=self.max)
            self.current:=value
         ELSE
            SELECT value
               CASE PLV_Register_ActivePage_First
                  self.current:=0
               CASE PLV_Register_ActivePage_Last
                  self.current:=self.max
               CASE PLV_Register_ActivePage_Next
                  self.current:=self.current+1
                  IF self.current>self.max THEN self.current:=0
               CASE PLV_Register_ActivePage_Prev
                  self.current:=self.current-1
                  IF self.current<0 THEN self.current:=self.max
               DEFAULT
                  self.current:=0
            ENDSELECT
         ENDIF
         self.draw()       /* update */
         -> call hook only if the gui is initialized
         IF (self.hook<>NIL) AND (self.gh) THEN callHookA(self.hook, self, self.current)
   ENDSELECT

ENDPROC
-><<

->>> register::get
PROC get(attr) OF register_plugin

   SELECT attr
      CASE PLA_Register_Disabled
         RETURN self.disabled, TRUE
      CASE PLA_Register_ActivePage
         RETURN self.current, TRUE
   ENDSELECT

ENDPROC -1, FALSE
-><<

