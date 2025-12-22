/*
   Name:      newimagebutton.e
   About:     A subclass of the buttonbase Plugin for an imagebutton
   Version:   1.0 (5.6.98)
   Author:    Copyright © 1998 Victor Ducedre (victord@netrover.com)

   A brief note: This is an example of a subclass of buttonbase.  It supports
   normal and selected images, and will set its size in the constructor to the
   size of the normal image if no size parameters are specified.

*/
OPT MODULE
OPT PREPROCESS
OPT OSVERSION=37

MODULE 'tools/EasyGUI', 'tools/textlen', 'graphics/rastport',
       'intuition/intuition', 'intuition/gadgetclass',
       'gadgets/buttonclass', 'plugins/buttonbase',
       'tools/ctype', 'utility', 'utility/tagitem'

CONST NB_GADGET=$FF010001   -> kept private, and defined in each subclass

-> define NEWIMAGEBUTTON to make EasyGUI's gadget list more readable!
EXPORT CONST NEWIMAGEBUTTON=PLUGIN

EXPORT ENUM NIB_WIDTH=$FF010011,      -> [I.G]
  NIB_HEIGHT,                         -> [I.G]
  NIB_IMAGE,                          -> [IS.]
  NIB_SELECTRENDER                    -> [IS.]

EXPORT OBJECT newimagebutton OF buttonbase PRIVATE
  image:PTR TO image
  selectimage:PTR TO image
  width
  height
ENDOBJECT

PROC button(tags) OF newimagebutton
  SUPER self.button(tags)
  self.image:=      GetTagData(NIB_IMAGE, NIL, tags)
  IF self.image=NIL THEN Raise("nbut")
  self.selectimage:=GetTagData(NIB_SELECTRENDER, NIL, tags)
  self.width:=      Max(self.image.width,  GetTagData(NIB_WIDTH,  NIL, tags))
  self.height:=     Max(self.image.height, GetTagData(NIB_HEIGHT, NIL, tags))
ENDPROC

PROC min_size(ta,fh) OF newimagebutton
ENDPROC self.width+4, self.height+2

->will_resize() - uses superclass method

PROC render(ta,x,y,xs,ys,w:PTR TO window) OF newimagebutton
-> be sure to dynamically allocate your tag list with NEW;
-> see buttonbase/settags() for more info
  self.settags(NEW [GA_IMAGE,self.image,
                    IF self.selectimage THEN GA_SELECTRENDER ELSE TAG_IGNORE, self.selectimage,
                    GA_HIGHLIGHT, IF self.selectimage THEN GFLG_GADGHIMAGE ELSE GFLG_GADGHNONE,
                    BUT_FILLPEN, w.rport.bgpen,
                    NIL])
  SUPER self.render(ta,x,y,xs,ys,w)
ENDPROC

->clear_render() - uses superclass method

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF newimagebutton
IF Not(SUPER self.get(NB_DISABLED))
  IF imsg.class=IDCMP_GADGETUP THEN RETURN (imsg.iaddress=SUPER self.get(NB_GADGET))
ENDIF
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF newimagebutton
  SUPER self.set(NB_SELECTED, code)
-> Using SUPER here is only a time-saver; sending it to self.set() will work,
-> since self.set() will eventually make this same call to the superclass
ENDPROC TRUE

PROC set(attr, val) OF newimagebutton
DEF image:PTR TO image
  SELECT attr
    -> Note:  for both NIB_IMAGE and NIB_SELECTRENDER, the image is only
    -> accepted and changed if the width and height are <= those of the
    -> initial image.  The gadget will not adjust its size.
    CASE NIB_IMAGE
      image:=val
      IF (image.width<=self.width) AND (image.height<=self.height)
        self.image:=image
        SUPER self.set(NB_GADGET, [GA_IMAGE, image, NIL])
      ENDIF
    CASE NIB_SELECTRENDER
      image:=val
      IF (image.width<=self.width) AND (image.height<=self.height)
        self.selectimage:=image
        SUPER self.set(NB_GADGET, [GA_SELECTRENDER,image,NIL])
      ENDIF
    DEFAULT
      SUPER self.set(attr, val)
  ENDSELECT
ENDPROC

PROC get(attr) OF newimagebutton
  SELECT attr
    CASE NIB_WIDTH;     RETURN self.width, TRUE
    CASE NIB_HEIGHT;    RETURN self.height, TRUE
  ENDSELECT
ENDPROC SUPER self.get(attr)

