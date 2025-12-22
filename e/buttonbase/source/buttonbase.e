/*
   Name:        buttonbase.e
   About:       A base Plugin for use with my custom BOOPSI button gadget
   Version:     1.0 (5.6.98)
   Author:      Copyright © 1998 Victor Ducedre (victord@netrover.com)

   A brief note:  This plugin is not meant to be used directly within your
   EasyGUI-based program.  It is only a base class for subclasses, which only
   handles the elements common to all sub classes.  Please see newbutton.e and
   newimagebutton.e for examples of subclasses.

*/
OPT MODULE
OPT PREPROCESS
OPT OSVERSION=37

MODULE 'tools/EasyGUI', 'tools/textlen', 'graphics/rastport',
       'intuition/intuition', 'intuition/gadgetclass', 'intuition/imageclass',
       'gadgets/buttonclass', 'tools/ctype', 'utility', 'utility/tagitem'

CONST NB_GADGET=$FF010001   -> kept private, and defined in each subclass

EXPORT ENUM NB_SELECTED=$FF010002,       -> [ISG]
  NB_RESIZEX,                            -> [I..]
  NB_RESIZEY,                            -> [I..]
  NB_TOGGLE,                             -> [I..]
  NB_PUSH,                               -> [I..]
  NB_DISABLED,                           -> [ISG]
  NB_FRAMETYPE                           -> [I..]

EXPORT OBJECT buttonbase OF plugin PRIVATE
  selected
  disabled
  gadget:PTR TO gadget
  class
  resize
  toggle
  push
  frame
  tags
ENDOBJECT

PROC button(tags=NIL) OF buttonbase
  IF utilitybase
    self.class:=     initButtonGadgetClass()
    IF self.class=NIL THEN Raise("nbut")
    self.resize:=(IF GetTagData(NB_RESIZEX,   FALSE, tags) THEN RESIZEX ELSE 0) OR
                 (IF GetTagData(NB_RESIZEY,   FALSE, tags) THEN RESIZEY ELSE 0)
    self.toggle:=    GetTagData(NB_TOGGLE,    FALSE, tags)
    self.push:=   IF self.toggle THEN FALSE ELSE GetTagData(NB_PUSH, FALSE, tags)
    IF (self.toggle) OR (self.push) THEN
      self.selected:=GetTagData(NB_SELECTED,  FALSE, tags)
    self.disabled:=  GetTagData(NB_DISABLED,  FALSE, tags)
    self.frame:=     GetTagData(NB_FRAMETYPE, BATT_BUTTONFRAME, tags)
    self.tags:=      NIL
  ELSE
    Raise("util")
  ENDIF
ENDPROC

PROC end() OF buttonbase
DEF tags
  IF tags:=self.tags THEN END tags
  IF self.class THEN freeButtonGadgetClass(self.class)
ENDPROC

PROC will_resize() OF buttonbase IS self.resize

->min_size() -subclasses only

PROC render(ta,x,y,xs,ys,w) OF buttonbase
  self.gadget:=NewObjectA(self.class,NIL,
                         [GA_TOP,y, GA_LEFT,x, GA_WIDTH,xs, GA_HEIGHT,ys,
                          GA_TOGGLESELECT, self.toggle, BUT_PUSH, self.push,
                          GA_DISABLED,self.disabled, GA_SELECTED,self.selected,
                          BUT_FRAMETYPE, self.frame,
                          GA_RELVERIFY,TRUE, TAG_MORE, self.tags, NIL])
  IF self.gadget=NIL THEN Raise("nbut")
  AddGList(w,self.gadget,-1,1,NIL)
  RefreshGList(self.gadget,w,NIL,1)
ENDPROC

PROC clear_render(win:PTR TO window) OF buttonbase
DEF tags
  IF tags:=self.tags THEN END tags
  IF self.gadget
    RemoveGList(win,self.gadget,1)
    DisposeObject(self.gadget)
  ENDIF
ENDPROC

->message_test()   -subclasses only
->message_action() -subclasses only

PROC set(attr, val) OF buttonbase
  SELECT attr
    CASE NB_GADGET  -> this attribute should only be sent by subclasses, not
                    -> by the user of the plugin; NB_GADGET is kept private for
                    -> this reason. 'val' should be a tag list to be sent
                    -> directly to the gadget, and no checking is done on it.
                    -> It's perhaps a bit of a kludge but does allows a cleaner,
                    -> more consistent way for subclasses to alter their own
                    -> gadget attributes.
      IF visible(self) THEN SetGadgetAttrsA(self.gadget,self.gh.wnd,NIL,val)
    CASE NB_DISABLED
      IF self.disabled<>val
        self.disabled:=val
        IF visible(self) THEN
          SetGadgetAttrsA(self.gadget,self.gh.wnd,NIL,[GA_DISABLED,val,NIL])
      ENDIF
    CASE NB_SELECTED
      self.selected:=val
      IF ((self.toggle) OR (self.push)) AND visible(self) THEN
        SetGadgetAttrsA(self.gadget,self.gh.wnd,NIL,[GA_SELECTED,val,NIL])
  ENDSELECT
ENDPROC

PROC get(attr) OF buttonbase
  SELECT attr
    CASE NB_GADGET      -> this will return the pointer to the actual gadget
                        -> for subclasses, but as far as any outside programs
                        -> are concerned, as the second return value is FALSE,
                        -> this attribute is not "get-able"
                        RETURN self.gadget,   FALSE
    CASE NB_SELECTED;   RETURN self.selected, TRUE
    CASE NB_DISABLED;   RETURN self.disabled, TRUE
  ENDSELECT
ENDPROC -1, FALSE

PROC settags(tags) OF buttonbase
-> This method exists only to maintain the privacy if the elements of the base
-> object.  It allows subclasses to pass a tag list to self.tags, which is
-> appended to the tag list sent to NewObjectA() in the render() method.
->    The tag list passed should be a dynamically created one (with NEW), the
-> list is properly deallocated in clear_render() and in end()
  self.tags:= IF tags THEN tags ELSE NEW [NIL]
ENDPROC

PROC visible(self:PTR TO buttonbase) IS (self.gadget AND self.gh.wnd)
