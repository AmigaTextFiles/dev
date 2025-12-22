OPT MODULE, PREPROCESS, REG = 5

MODULE '*mods/myscreens'

MODULE 'graphics/rastport',
       'graphics/gfxmacros',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'utility/tagitem'

RAISE "WIN" IF OpenWindowTagList() = NIL

EXPORT OBJECT progresswin PRIVATE
  win:PTR TO window
  scr:PTR TO screen
  dri:PTR TO drawinfo

  windowdim[4]:ARRAY OF INT
  progressgaddim[4]:ARRAY OF INT

  currpercent:INT

  black:INT
  white:INT
  grey:INT
  text:INT
  fill:INT
ENDOBJECT

PROC lockprogressscreen(screenname) OF progresswin HANDLE
  self.scr := LockPubScreen(screenname)
  IF self.scr = NIL THEN Throw("PUBS", screenname)

  self.dri := GetScreenDrawInfo(self.scr)
EXCEPT
  self.unlockprogressscreen()
  ReThrow()
ENDPROC

PROC unlockprogressscreen() OF progresswin
  IF self.dri
    FreeScreenDrawInfo(self.scr, self.dri)
    self.dri:=NIL
  ENDIF

  IF self.scr
    UnlockPubScreen(NIL, self.scr)
    self.scr:=NIL
  ENDIF
ENDPROC

PROC progresswinopen() OF progresswin
  IF self.win THEN RETURN TRUE ELSE FALSE
ENDPROC

PROC openprogresswin(scrname, win2ptr:PTR TO window, progressstr) OF progresswin HANDLE
  DEF rp:PTR TO rastport, tf:PTR TO textfont

  IF findpubscreen(scrname)
    self.lockprogressscreen(scrname)
  ELSE
    self.lockprogressscreen(NIL)
  ENDIF

  -> Get font
  tf := self.dri.font

  self.windowdim[2] := 250
  self.windowdim[3] := tf.ysize * 6
  IF win2ptr
    self.windowdim[0] := win2ptr.leftedge + (win2ptr.width  / 2) - (self.windowdim[2] / 2)
    self.windowdim[1] := win2ptr.topedge  + (win2ptr.height / 2) - (self.windowdim[3] / 2)
  ELSE
    self.windowdim[0] := (self.scr.width  / 2) - (self.windowdim[2] / 2)
    self.windowdim[1] := (self.scr.height / 2) - (self.windowdim[3] / 2)
  ENDIF

  self.win := OpenWindowTagList(NIL,
      [WA_LEFT,       self.windowdim[0],
       WA_TOP,        self.windowdim[1],
       WA_WIDTH,      self.windowdim[2],
       WA_HEIGHT,     self.windowdim[3],
       WA_BORDERLESS, TRUE,
       WA_AUTOADJUST, TRUE,
       WA_PUBSCREEN,  self.scr,
       TAG_END])

  -> Get pens
  self.black := self.dri.pens[SHADOWPEN]
  self.white := self.dri.pens[SHINEPEN]
  self.grey  := self.dri.pens[BACKGROUNDPEN]
  self.text  := self.dri.pens[TEXTPEN]
  self.fill  := self.dri.pens[FILLPEN]

  rp := self.win.rport
  SetFont(rp, tf)
  SetBPen(rp, self.grey)
  SetDrMd(rp, RP_JAM1)

  self.drawprogresswin()
  self.drawprogresstext(progressstr)
EXCEPT
  self.closeprogresswin()
  ReThrow()
ENDPROC

PROC closeprogresswin() OF progresswin
  IF self.win
    CloseWindow(self.win)
    self.win := NIL
  ENDIF

  self.unlockprogressscreen()
ENDPROC

PROC drawprogresswin() OF progresswin
  DEF rp:PTR TO rastport, tf:PTR TO textfont

  IF (self.win = NIL) THEN RETURN

  rp := self.win.rport
  tf := self.dri.font

  -> Draw dither fill
  SetAPen(rp, self.white)
  SetAfPt(rp, [%1010101010101010, %0101010101010101]:INT, 1)
  RectFill(rp, 0, 0, self.windowdim[2], self.windowdim[3])
  SetAfPt(rp, NIL, 0)

  -> Draw bevel
  self.drawbevel(rp, 0, 0, self.windowdim[2] - 1,  self.windowdim[3] - 1,  FALSE)
  self.drawbevel(rp, 5, 5, self.windowdim[2] - 11, self.windowdim[3] - 11, TRUE)
    
  -> Fill middle
  SetAPen(rp, self.grey)
  RectFill(rp, 6, 6, self.windowdim[2] - 7, self.windowdim[3] - 7)

  -> Gadget

  self.progressgaddim[0] := 20
  self.progressgaddim[1] := self.windowdim[3] / 2
  self.progressgaddim[2] := self.windowdim[2] - 40
  self.progressgaddim[3] := tf.ysize + 6

  self.drawbevel(rp, self.progressgaddim[0],
                     self.progressgaddim[1],
                     self.progressgaddim[2] - 1,
                     self.progressgaddim[3] - 1, TRUE)
ENDPROC

PROC drawprogresstext(string) OF progresswin
  DEF textext:textextent, fit, strlen, rp:PTR TO rastport, tf:PTR TO textfont

  IF (self.win = NIL) THEN RETURN

  rp := self.win.rport
  tf := self.dri.font

  -> Text

  strlen := StrLen(string)

  SetAPen(rp, self.grey)
  RectFill(rp, 10,                     (self.windowdim[3] / 3) - tf.baseline,
               self.windowdim[2] - 11, (self.windowdim[3] / 3) - tf.baseline + tf.ysize)

  SetAPen(rp, self.text)
  Move(rp, Max(10, (self.windowdim[2] / 2) - (TextLength(rp, string, strlen) / 2)), (self.windowdim[3] / 3) )
  IF (fit := TextFit(rp,
                     string, strlen,
                     textext,
                     NIL,
                     1,
                     self.windowdim[2] - 11 - rp.cp_x,
                     self.scr.font.ysize)) > 0 THEN Text(rp, string, fit)

ENDPROC

PROC drawprogressgad(percentage) OF progresswin
  DEF fillpos, percentstr[100]:STRING, percentlen
  DEF rp:PTR TO rastport, tf:PTR TO textfont

  -> If the percent is the same as before, don't draw anything
  IF (self.win = NIL) OR (percentage = self.currpercent) THEN RETURN
  self.currpercent := percentage

  rp := self.win.rport
  tf := self.dri.font

  fillpos := ((self.progressgaddim[2] - 4) * percentage) / 100
                                        
  -> Draw filled part
  SetAPen(rp, self.fill)
  RectFill(rp, self.progressgaddim[0] + 2,
               self.progressgaddim[1] + 2,
               self.progressgaddim[0] + 2 + fillpos - 1,
               self.progressgaddim[1] - 3 + self.progressgaddim[3])

  -> Draw fill bevel edge
  self.drawbevel(rp,
                 self.progressgaddim[0] + 2,
                 self.progressgaddim[1] + 2,
                 fillpos - 1,
                 self.progressgaddim[3] - 5, FALSE)
  
  -> Clear empty part
  SetAPen(rp, self.grey)
  RectFill(rp, self.progressgaddim[0] + 2 + fillpos,
               self.progressgaddim[1] + 2,
               self.progressgaddim[0] - 3 + self.progressgaddim[2],
               self.progressgaddim[1] - 3 + self.progressgaddim[3])

  -> Draw percent on the middle of the gadget
  StringF(percentstr, '\d%', percentage)
  percentlen := EstrLen(percentstr)

  Move(rp, (self.windowdim[2] / 2) - (TextLength(rp, percentstr, percentlen) / 2),
            self.progressgaddim[1] + (self.progressgaddim[3] / 2) - (tf.ysize / 2) + tf.baseline)
  SetAPen(rp, self.text)
  Text(rp, percentstr, percentlen)
ENDPROC

PROC drawbevel(rp:PTR TO rastport, x, y, xs, ys, recess = FALSE) OF progresswin
  IF (xs < 2) OR (ys < 2) THEN RETURN
  SetAPen(rp, IF recess THEN self.black ELSE self.white)
  Move(rp, x,      y + ys)
  Draw(rp, x,      y)
  Draw(rp, x + xs, y)
  SetAPen(rp, IF recess THEN self.white ELSE self.black)
  Move(rp, x,      y + ys)
  Draw(rp, x + xs, y + ys)
  Draw(rp, x + xs, y)
ENDPROC
