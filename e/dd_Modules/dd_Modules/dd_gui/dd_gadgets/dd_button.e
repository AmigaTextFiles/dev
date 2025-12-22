OPT MODULE

MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'intuition/intuition'
MODULE 'gadtools'
MODULE 'libraries/gadtools'
MODULE 'intuition/icclass'
MODULE 'intuition/imageclass'
MODULE 'intuition/gadgetclass'
MODULE 'intuition/screens'

MODULE 'dd_gui/dd_screen'

MODULE '*dd_maxtextlen'

EXPORT OBJECT button
  gadget:PTR TO gadget
ENDOBJECT

EXPORT ENUM
  DD_GADGET_DUMMY=TAG_USER,
  DD_GADGET_PREVIOUS,
  DD_GADGET_IMMEDIATE,
  DD_GADGET_LEFT,
  DD_GADGET_TOP,
  DD_GADGET_WIDTH,
  DD_GADGET_HEIGHT,
  DD_GADGET_TEXT,
  DD_DRAWINFO,
  DD_STRINGS

EXPORT PROC new(taglist=NIL:PTR TO tagitem) OF button
  DEF previous
  DEF visual
  previous:=GetTagData(DD_GADGET_PREVIOUS,0,taglist)
  visual:=GetTagData(DD_SCREEN_VISUALINFO,0,taglist)
  IF (previous<>0) AND (visual<>0)
    self.gadget:=CreateGadgetA(BUTTON_KIND,previous,
    [GetTagData(DD_GADGET_LEFT,0,taglist),
     GetTagData(DD_GADGET_TOP,0,taglist),
     GetTagData(DD_GADGET_WIDTH,0,taglist),
     GetTagData(DD_GADGET_HEIGHT,0,taglist),
     GetTagData(DD_GADGET_TEXT,0,taglist),
     0,"NR",PLACETEXT_IN,visual,0]:newgadget,[
      GT_UNDERSCORE,"_",
      TAG_DONE
     ])
  ENDIF
ENDPROC

EXPORT PROC end() OF button IS EMPTY

EXPORT PROC maxButtonLen(taglist)
  DEF stringlist:PTR TO LONG
  DEF drawinfo:PTR TO drawinfo
  stringlist:=GetTagData(DD_STRINGS,0,taglist)
  drawinfo:=GetTagData(DD_DRAWINFO,0,taglist)
  IF (stringlist<>0) AND (drawinfo<>0)
    RETURN maxTextLen(stringlist,drawinfo.font)
  ENDIF
ENDPROC 0

EXPORT PROC lastgadget(taglist=NIL) OF button IS self.gadget
