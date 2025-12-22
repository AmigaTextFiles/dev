OPT MODULE

MODULE '*borderslider'

MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'intuition/intuition'
MODULE 'gadtools'
MODULE 'intuition/icclass'
MODULE 'intuition/imageclass'
MODULE 'intuition/gadgetclass'
MODULE 'intuition/screens'

EXPORT OBJECT bottomslider OF borderslider
  context:PTR TO gadget
  gadgetlist:PTR TO gadget
  leftimage:PTR TO image
  rightimage:PTR TO image
  leftgadget:PTR TO gadget
  rightgadget:PTR TO gadget
  slider:PTR TO gadget
  total:LONG
  visible:LONG
ENDOBJECT

EXPORT ENUM SLIDER,LEFT,RIGHT

RAISE BSLIDX_CREATE IF NewObjectA()=0
RAISE BSLIDX_CREATE IF CreateContext()=0

EXPORT PROC new(taglist=NIL) OF bottomslider HANDLE
  DEF gadgetlist:PTR TO gadget
  DEF drawinfo,sysisize
  PrintF('taglist=\h\n',taglist)
  SUPER self.new(taglist)
  drawinfo:=GetTagData(BSLIDA_DRAWINFO,0,taglist)
  sysisize:=GetTagData(BSLIDA_SIZE,SYSISIZE_MEDRES,taglist)
  self.leftimage:=NewObjectA(
    0,
    'sysiclass',
    [
      SYSIA_DRAWINFO,drawinfo,
      SYSIA_WHICH,LEFTIMAGE,
      SYSIA_SIZE,sysisize,
      TAG_END
    ])
  self.rightimage:=NewObjectA(
    0,
    'sysiclass',
    [
      SYSIA_DRAWINFO,drawinfo,
      SYSIA_WHICH,RIGHTIMAGE,
      SYSIA_SIZE,sysisize,
      TAG_END
    ])
  self.context:=CreateContext({gadgetlist})
  self.gadgetlist:=gadgetlist
  self.rightgadget:=NewObjectA(
    0,
    'buttongclass',
    [
      GA_ID,RIGHT,
      GA_IMMEDIATE,TRUE,
      GA_IMAGE,self.rightimage,
      GA_WIDTH,self.rightimage.width,
      GA_HEIGHT,self.rightimage.height,
      GA_PREVIOUS,self.context,
      GA_RELVERIFY,TRUE,
      GA_BOTTOMBORDER,TRUE,
      GA_RELRIGHT,(1-self.sizeimage.width-self.rightimage.width),
      GA_RELBOTTOM,(1-self.rightimage.height),
      ICA_TARGET,ICTARGET_IDCMP,
      TAG_END
    ])
  self.leftgadget:=NewObjectA(
    0,
    'buttongclass',
    [
      GA_ID,LEFT,
      GA_IMMEDIATE,TRUE,
      GA_IMAGE,self.leftimage,
      GA_WIDTH,self.leftimage.width,
      GA_HEIGHT,self.leftimage.height,
      GA_PREVIOUS,self.rightgadget,
      GA_RELVERIFY,TRUE,
      GA_BOTTOMBORDER,TRUE,
      GA_RELRIGHT,(1-self.sizeimage.width-self.rightimage.width-self.leftimage.width),
      GA_RELBOTTOM,(1-self.leftimage.height),
      ICA_TARGET,ICTARGET_IDCMP,
      TAG_END
    ])
  self.slider:=NewObjectA(
    0,
    'propgclass',
    [
      ICA_TARGET,ICTARGET_IDCMP,
      GA_PREVIOUS,self.rightgadget,
      GA_LEFT,3,
      GA_RELBOTTOM,(3-self.sizeimage.height),
      GA_RELWIDTH,(-5-self.sizeimage.width-self.rightimage.width-self.leftimage.width),
      GA_HEIGHT,self.sizeimage.height-4,
      GA_BOTTOMBORDER,TRUE,
      GA_ID,SLIDER,
      PGA_FREEDOM,FREEHORIZ,
      PGA_NEWLOOK,TRUE,
      PGA_BORDERLESS,TRUE,
      PGA_TOTAL,self.total,
      PGA_VISIBLE,self.visible,
      TAG_DONE
    ])
EXCEPT
  self.end()
  ReThrow()
ENDPROC
PROC end() OF bottomslider
  IF self.gadgetlist
    FreeGadgets(self.gadgetlist)
    self.gadgetlist:=0
    self.context:=0
    self.leftgadget:=0
    self.rightgadget:=0
  ENDIF
  IF self.rightimage
    DisposeObject(self.rightimage)
    self.rightimage:=0
  ENDIF
  IF self.leftimage
    DisposeObject(self.leftimage)
    self.leftimage:=0
  ENDIF
  SUPER self.end()
ENDPROC

PROC gadgetlist() OF bottomslider IS self.gadgetlist

PROC lastgadget() OF bottomslider IS self.leftgadget
