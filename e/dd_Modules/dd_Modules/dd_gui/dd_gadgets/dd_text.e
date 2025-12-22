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

EXPORT OBJECT text
  gadget:PTR TO gadget
ENDOBJECT

EXPORT ENUM
  DD_GADGET_DUMMY=TAG_USER,
  DD_GADGET_PREVIOUS,
  DD_GADGET_VISUAL,
  DD_GADGET_IMMEDIATE,
  DD_GADGET_LEFT,
  DD_GADGET_TOP,
  DD_GADGET_WIDTH,
  DD_GADGET_HEIGHT,
  DD_GADGET_TEXT,
  DD_DRAWINFO,
  DD_STRINGS,
  DD_WINDOW

EXPORT PROC new(taglist=NIL:PTR TO tagitem) OF text
  DEF previous
  DEF visual
  previous:=GetTagData(DD_GADGET_PREVIOUS,0,taglist)
  visual:=GetTagData(DD_GADGET_VISUAL,0,taglist)
  IF (previous<>0) AND (visual<>0)
    self.gadget:=CreateGadgetA(TEXT_KIND,previous,
    [GetTagData(DD_GADGET_LEFT,0,taglist),
     GetTagData(DD_GADGET_TOP,0,taglist),
     GetTagData(DD_GADGET_WIDTH,0,taglist),
     GetTagData(DD_GADGET_HEIGHT,0,taglist),
     GetTagData(DD_GADGET_TEXT,0,taglist),
     0,"NR",PLACETEXT_IN,visual,0]:newgadget,[
      GTTX_BORDER,TRUE,
      GTTX_CLIPPED,TRUE,
      GTTX_TEXT,'hello',
      TAG_DONE
     ])
  ENDIF
ENDPROC

EXPORT PROC end() OF text IS EMPTY

EXPORT PROC lastgadget(taglist=NIL) OF text IS self.gadget
EXPORT PROC change(taglist=NIL) OF text
  PrintF('$\h\n',GetTagData(DD_WINDOW,0,taglist))
  Gt_SetGadgetAttrsA(self.gadget,GetTagData(DD_WINDOW,0,taglist),0,[GTTX_TEXT,'bla',GTTX_BORDER,TRUE,GTTX_CLIPPED,TRUE,TAG_DONE])
ENDPROC


