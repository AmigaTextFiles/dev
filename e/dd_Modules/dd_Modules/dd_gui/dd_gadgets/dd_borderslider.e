OPT MODULE

MODULE 'utility'
MODULE 'utility/tagitem'
MODULE 'intuition/intuition'
MODULE 'intuition/imageclass'
MODULE 'intuition/screens'

EXPORT OBJECT borderslider
  sizeimage:PTR TO image
ENDOBJECT

EXPORT ENUM BSLIDA_DUMMY=TAG_USER,BSLIDA_SIZE,BSLIDA_DRAWINFO
EXPORT ENUM BSLIDX_CREATE

RAISE BSLIDX_CREATE IF NewObjectA()=0

EXPORT PROC new(taglist=NIL) OF borderslider HANDLE
  PrintF('drawinfo=\h\n',GetTagData(BSLIDA_DRAWINFO,0,taglist))
  self.sizeimage:=NewObjectA(
    0,
    'sysiclass',
    [
      SYSIA_DRAWINFO,GetTagData(BSLIDA_DRAWINFO,0,taglist),
      SYSIA_WHICH,SIZEIMAGE,
      SYSIA_SIZE,GetTagData(BSLIDA_SIZE,SYSISIZE_MEDRES,taglist),
      TAG_END
    ])
EXCEPT
  self.end()
  ReThrow()
ENDPROC
EXPORT PROC end() OF borderslider
  IF self.sizeimage
    DisposeObject(self.sizeimage)
    self.sizeimage:=0
  ENDIF
ENDPROC
EXPORT PROC height(taglist=NIL) OF borderslider IS self.sizeimage.height
EXPORT PROC width(taglist=NIL) OF borderslider IS self.sizeimage.width

