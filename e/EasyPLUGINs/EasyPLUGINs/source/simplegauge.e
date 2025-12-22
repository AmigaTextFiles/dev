/*
**
** simplegauge PLUGIN
**
** Copyright: Ralph Wermke of Digital Innovations
** EMail    : wermke@gryps1.rz.uni-greifswald.de
** WWW      : http://www.user.fh-stralsund.de/~rwermke/di.html
**
** Version  : 1.1.2
** Date     : 05-Nov-1997
**
** ProgramID: 0002
**
** History:
**    03-Sep-1997:          V1.0 beta
**       first beta release
**    01-Nov-1997:          V1.1
**       some minor changes
**       new tags added
**          PLA_SimpleGauge_BackgroundPen [ISG]
**          PLA_SimpleGauge_BarPen        [ISG]
**    05-Nov-1997:          V1.1.1
**       enforcer hits removed
**    15-Nov-1997:          V1.1.2
**       object name changed to simplegauge_plugin
**
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
       'utility/tagitem','utility'


EXPORT OBJECT simplegauge_plugin OF plugin
PRIVATE
   current
   percent
   oldvalue
   max
   horizontal
   showtext
   disabled

   shinepen
   shadowpen
   fillpen
   backpen

   ta          : PTR TO textattr
ENDOBJECT

-> TAG_USER  | PROG_ID<<16 | TAG_VALUE
-> $80000000 |   $0002<<16 | 0...

EXPORT ENUM  PLA_SimpleGauge_Max=$80020001,
             PLA_SimpleGauge_Current,
             PLA_SimpleGauge_Horizontal,
             PLA_SimpleGauge_Percent,
             PLA_SimpleGauge_ShowText,
             PLA_SimpleGauge_Disabled,
             PLA_SimpleGauge_BackgroundPen,
             PLA_SimpleGauge_BarPen


->-- Constructor/ Destructor ---------------------------------

->>> simplegauge::simplegauge (Constructor)
PROC simplegauge(tags:PTR TO tagitem) OF simplegauge_plugin

   self.gh:=0     -> because it's not initialized
                  -> I need it to avoid drawing before gui is open

   IF utilitybase:=OpenLibrary('utility.library', 37)

      self.max       :=Max(1,GetTagData(PLA_SimpleGauge_Max, 100, tags))
      self.current   :=self.set(PLA_SimpleGauge_Current, GetTagData(PLA_SimpleGauge_Current, 0, tags))
      self.horizontal:=GetTagData(PLA_SimpleGauge_Horizontal, TRUE, tags)
      self.showtext  :=GetTagData(PLA_SimpleGauge_ShowText, FALSE, tags)
      self.disabled  :=GetTagData(PLA_SimpleGauge_Disabled, FALSE, tags)

      self.fillpen   :=GetTagData(PLA_SimpleGauge_BarPen, -1, tags)
      self.backpen   :=GetTagData(PLA_SimpleGauge_BackgroundPen, -1, tags)

      -> initial settings
      self.oldvalue  :=0
      self.shinepen  :=2
      self.shadowpen :=1

      CloseLibrary(utilitybase)
   ELSE
      Raise("UTIL")
   ENDIF

ENDPROC
-><<

->-- overridden methods --------------------------------------

->>> simplegauge::will_resize
PROC will_resize() OF simplegauge_plugin IS IF self.horizontal THEN RESIZEX ELSE RESIZEY
-><<

->>> simplegauge::min_size
PROC min_size(ta:PTR TO textattr, fh) OF simplegauge_plugin
DEF x
   x:=IF self.showtext THEN textlen('100%', ta)+4 ELSE fh+6
ENDPROC x,fh+6
-><<

->>> simplegauge::render
PROC render(ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF simplegauge_plugin
DEF oldwin, dri:PTR TO drawinfo

   self.ta :=ta

   IF dri:=GetScreenDrawInfo(win.wscreen)
      self.shinepen :=dri.pens[SHINEPEN]
      self.shadowpen:=dri.pens[SHADOWPEN]
      IF self.fillpen=-1 THEN self.fillpen:=dri.pens[FILLPEN]
      IF self.backpen=-1 THEN self.backpen:=dri.pens[BACKGROUNDPEN]
      FreeScreenDrawInfo(win.wscreen, dri)
   ENDIF

   oldwin:=self.gh.wnd  /* at this time wnd is 0 but it may change in a later version of easygui */
   self.gh.wnd:=win
   self.draw(TRUE)      /* full redraw */
   self.gh.wnd:=oldwin

ENDPROC
-><<

->>> simplegauge::draw
/* draws the full register */
PROC draw(redraw=FALSE) OF simplegauge_plugin
DEF rp:REG, left, top, right, bottom, width, height, lenght:REG, pixels,
    str[6]:STRING, itext:PTR TO intuitext, textx, texty

   IF self.gh=0 THEN RETURN      /* ignore draw before gui is open */
   IF self.gh.wnd=0 THEN RETURN  /* ignore draw when window is closed */

   rp    :=self.gh.wnd.rport
   left  :=self.x
   top   :=self.y
   width :=self.xs
   height:=self.ys
   right :=left+width-1
   bottom:=top+height-1

   IF redraw
      SetAPen(rp, self.shadowpen)
      RectFill(rp, left, top, left, bottom)
      RectFill(rp, left, top, right, top)

      SetAPen(rp, self.shinepen)
      RectFill(rp, right, top+1, right, bottom)
      RectFill(rp, left+1, bottom, right, bottom)
   ENDIF

   pixels:=IF self.horizontal THEN width-2 ELSE height-2
   self.percent:=Div(Mul(self.current, 100), self.max)
   lenght :=Div(Mul(self.current, pixels), self.max)

   IF ((self.oldvalue<>lenght) OR (lenght=0) OR (redraw))
      top++; left++
      right--; bottom--

      SetAPen(rp, self.backpen)

      IF self.horizontal
         RectFill(rp, left+lenght, top, right, bottom)
         SetAPen(rp, self.fillpen)
         RectFill(rp, left, top, left+lenght-1, bottom)
      ELSE
         RectFill(rp, left, top, right, bottom-lenght)
         SetAPen(rp, self.fillpen)
         RectFill(rp, left, bottom-lenght+1, right, bottom)
      ENDIF

      IF self.showtext
         StringF(str, '\d%', self.percent)
         itext:=[self.shinepen, 0, RP_JAM1, 0, 0, self.ta, str, NIL]:intuitext
         texty:=top+((height-self.ta.ysize)/2)-1
         textx:=left+((width-IntuiTextLength(itext))/2)-1

         itext.leftedge:=textx
         itext.topedge :=texty

         PrintIText(rp, itext, 0, 0)
      ENDIF

   ENDIF

   self.oldvalue:=lenght

   IF self.disabled THEN ghost(self.gh.wnd, left, top, width-1, height-1)

ENDPROC
-><<

->-- new methods ---------------------------------------------

->>> simplegauge::set
PROC set(attr, value) OF simplegauge_plugin

   SELECT attr
      CASE PLA_SimpleGauge_Current
         self.current:=Bounds(value, 0, self.max)
         self.draw()
      CASE PLA_SimpleGauge_Max
         IF value>0 THEN self.max:=value
         IF self.current>value THEN self.current:=value
         self.draw()
      CASE PLA_SimpleGauge_Disabled
         self.disabled:=value
         IF value=TRUE
            IF self.gh<>0           /* ignore draw before gui is open */
               IF self.gh.wnd<>0    /* ignore draw when window is closed */
                  ghost(self.gh.wnd, self.x, self.y, self.xs-1, self.ys-1)
               ENDIF
            ENDIF
         ELSE
            self.draw(TRUE)
         ENDIF
      CASE PLA_SimpleGauge_BackgroundPen
         IF (value>=0) AND (value<>self.backpen)
            self.backpen:=value
            self.draw(TRUE)
         ENDIF
      CASE PLA_SimpleGauge_BarPen
         IF (value>=0) AND (value<>self.fillpen)
            self.fillpen:=value
            self.draw(TRUE)
         ENDIF
   ENDSELECT

ENDPROC
-><<

->>> simplegauge::get
PROC get(attr) OF simplegauge_plugin

   SELECT attr
      CASE PLA_SimpleGauge_Max
         RETURN self.max, TRUE
      CASE PLA_SimpleGauge_Current
         RETURN self.current, TRUE
      CASE PLA_SimpleGauge_Percent
         RETURN self.percent, TRUE
      CASE PLA_SimpleGauge_Horizontal
         RETURN self.horizontal, TRUE
      CASE PLA_SimpleGauge_Disabled
         RETURN self.disabled, TRUE
      CASE PLA_SimpleGauge_BackgroundPen
         RETURN self.backpen, TRUE
      CASE PLA_SimpleGauge_BarPen
         RETURN self.fillpen, TRUE
   ENDSELECT

ENDPROC -1, FALSE
-><<

