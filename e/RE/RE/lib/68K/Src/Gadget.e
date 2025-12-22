/*
*/
OPT NOHEAD,NOEXE
MODULE 'intuition/intuition','graphics/rastport','graphics/text'

OBJECT eGadget
  gad:Gadget
  brd:Border
  coo[10]:INT
  txt:IntuiText
ENDOBJECT

CONST FIXHEIGHT=12
->CONST GADGETSIZE=SIZEOF eGadget

PROC Gadget(buf:PTR TO eGadget,glist,id,flags,x,y,width,string)
  DEF tlen,topaz=['topaz.font',8,0,0]:TextAttr
  ->tlen:=TextLength(stdrast,string,StrLen(string))->stdrast non e' settato
  tlen:=StrLen(string)*8 ->fixed font width
  width:=Max(width,tlen+4)
  IF glist THEN buf[-1].gad.NextGadget    :=  buf ->glist acts only as a flag

  buf.gad.NextGadget    :=  0
  buf.gad.LeftEdge      :=  x
  buf.gad.TopEdge       :=  y
  buf.gad.Width         :=  width
  buf.gad.Height        :=  FIXHEIGHT
  buf.gad.Flags         :=  GFLG_GADGHCOMP
  buf.gad.Activation    :=  GACT_RELVERIFY OR GACT_IMMEDIATE
  buf.gad.GadgetType    :=  0
  IF flags>0
    buf.gad.Activation    |=  GACT_TOGGLESELECT
    buf.gad.GadgetType    :=  GTYP_BOOLGADGET
    IF flags=3 THEN buf.gad.Flags |=  GFLG_SELECTED
  ENDIF
  buf.gad.GadgetRender  :=  &buf.brd
  buf.gad.SelectRender  :=  0
  buf.gad.GadgetText    :=  &buf.txt
  buf.gad.MutualExclude :=  0
  buf.gad.SpecialInfo   :=  0
  buf.gad.GadgetID      :=  0
  buf.gad.UserData      :=  id
  buf.brd.LeftEdge      :=  0
  buf.brd.TopEdge       :=  0
  buf.brd.FrontPen      :=  1
  buf.brd.BackPen       :=  0
  buf.brd.DrawMode      :=  JAM1
  buf.brd.Count         :=  5
  buf.brd.XY            :=  &buf.coo
  buf.brd.NextBorder    :=  0
  buf.coo[0]            :=  0
  buf.coo[1]            :=  0

  buf.coo[2]            :=  width
  buf.coo[3]            :=  0

  buf.coo[4]            :=  width
  buf.coo[5]            :=  FIXHEIGHT

  buf.coo[6]            :=  0
  buf.coo[7]            :=  FIXHEIGHT

  buf.coo[8]            :=  0
  buf.coo[9]            :=  0
  buf.txt.FrontPen      :=  1
  buf.txt.BackPen       :=  0
  buf.txt.DrawMode      :=  JAM1
  buf.txt.LeftEdge      :=  (width-tlen)/2
  buf.txt.TopEdge       :=  2
  buf.txt.ITextFont     :=  topaz
  buf.txt.IText         :=  string
  buf.txt.NextText      :=  0
ENDPROC buf+SIZEOF eGadget
