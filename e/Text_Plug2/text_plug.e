OPT OSVERSION=37, MODULE

MODULE 'tools/EasyGUI',
       'graphics/rastport',
       'graphics/text',
       'intuition/screens',
       'intuition/intuition',
       '*fonts'

EXPORT DEF deffont:PTR TO textfont, deffixedfont:PTR TO textfont

EXPORT OBJECT text_plug OF plugin
  PRIVATE
  str,   slen, sfont:PTR TO textfont
  label, llen, lfont:PTR TO textfont
  min, hgt, base, spos
ENDOBJECT

EXPORT PROC create(str, label=NIL, min=0, sfont=NIL:PTR TO textfont,
                   lfont=NIL:PTR TO textfont) OF text_plug
  DEF textrp:PTR TO rastport, mb
  self.str:=IF str THEN str ELSE ''
  self.slen:=StrLen(self.str)
  IF (sfont=NIL) AND (deffixedfont=NIL) THEN Raise("DFNT")
  self.sfont:=IF sfont THEN sfont ELSE deffixedfont
  self.base:=self.sfont.baseline
  self.hgt:=self.sfont.ysize
  self.label:=label
  NEW textrp
  SetFont(textrp, self.sfont)
  self.min:=IF min THEN min*self.sfont.xsize ELSE TextLength(textrp,self.str,self.slen)
  IF label
    self.llen:=StrLen(label)
    IF (lfont=NIL) AND (deffont=NIL) THEN Raise("DFNT")
    self.lfont:=IF lfont THEN lfont ELSE deffont
    mb:=Max(self.base, self.lfont.baseline)
    self.hgt:=mb+Max(self.hgt-self.base,self.lfont.ysize-self.lfont.baseline)
    self.base:=mb
    SetFont(textrp, self.lfont)
    self.spos:=4+TextLength(textrp, self.label, self.llen)
    self.min:=self.min+self.spos
  ELSE
    self.spos:=0
  ENDIF
  END textrp
ENDPROC

EXPORT PROC will_resize() OF text_plug IS RESIZEX

EXPORT PROC min_size(fh) OF text_plug IS self.min, self.hgt

EXPORT PROC render(x,y,xs,ys,win) OF text_plug IS self.draw(win, self.label)

PROC draw(win:PTR TO window,label=NIL) OF text_plug
  DEF res:textextent, fit, old, f, r:PTR TO rastport
  r:=win.rport
  f:=r.font
  IF label
    SetFont(r, self.lfont)
    SetAPen(r, 1)
    Move(r, self.x, self.y+self.base)
    Text(r, self.label, self.llen)
  ELSE
    old:=SetStdRast(r)
    Box(self.x+self.spos, self.y, self.x+self.xs-1, self.y+self.ys-1, 0)
    SetStdRast(old)
  ENDIF
  SetFont(r, self.sfont)
  IF fit:=TextFit(r, self.str,self.slen, res,NIL,1, self.xs-self.spos,self.ys)
    SetAPen(r, 1)
    Move(r, self.x+self.spos, self.y+self.base)
    Text(r, self.str, fit)
  ENDIF
  SetFont(r, f)
ENDPROC

EXPORT PROC settext(gh:PTR TO guihandle, str) OF text_plug
  self.str:=IF str THEN str ELSE ''
  self.slen:=StrLen(self.str)
  self.draw(gh.wnd)
ENDPROC
