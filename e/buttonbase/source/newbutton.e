/*
   Name:      newbutton.e
   About:     A subclass of the buttonbase Plugin for a text button
   Version:   1.0 (23.5.98)
   Author:    Copyright © 1998 Victor Ducedre (victord@netrover.com)

   A brief note:  This is an example of a subclass of buttonbase.  There are
   some features that aren't fully implemented (such as setting pen colours
   in the constructor, or using get() to get NB_TEXT).
      It will, though, keep track of and implement key-press activation :-)

*/
OPT MODULE
OPT PREPROCESS
OPT OSVERSION=37

MODULE 'tools/EasyGUI', 'tools/textlen', 'graphics/rastport',
       'intuition/intuition', 'intuition/gadgetclass',
       'gadgets/buttonclass', 'plugins/buttonbase',
       'tools/ctype', 'utility', 'utility/tagitem'

CONST NB_GADGET=$FF010001   -> kept private, and defined in each subclass

-> define NEWBUTTON to make EasyGUI's gadget list more readable!
EXPORT CONST NEWBUTTON=PLUGIN

EXPORT ENUM NB_TEXT=$FF010010        -> [IS.]

EXPORT OBJECT newbutton OF buttonbase PRIVATE
  label
  key
  pen1:INT
  pen2:INT
  pen3:INT
  pen4:INT
ENDOBJECT

PROC button(tags) OF newbutton
DEF key, label
  SUPER self.button(tags)  -> superclass checks for utility.library
  self.label:=GetTagData(NB_TEXT, NIL, tags) OR GetTagData(GA_TEXT, NIL, tags)
  IF label:=self.label
    self.key:= IF (key:=InStr(label, '_'))<>-1 THEN tolower(label[key+1]) ELSE NIL
    self.key:= IF isalpha(self.key) THEN self.key ELSE NIL
  ENDIF
  self.pen1:=-1
  self.pen2:=-1
  self.pen3:=-1
  self.pen4:=-1
ENDPROC

-> will resize() - uses superclass method

PROC min_size(ta,fh) OF newbutton
ENDPROC textlen_key(self.label,ta,self.key)+16,fh+6

PROC render(ta,x,y,xs,ys,w) OF newbutton
-> be sure to dynamically allocate your tag list with NEW;
-> see buttonbase/settags() for more info
  self.settags(NEW [GA_TEXT,        self.label,
                    BUT_TEXTPEN,     self.pen1, BUT_FILLPEN,       self.pen2,
                    BUT_FILLTEXTPEN, self.pen3, BUT_BACKGROUNDPEN, self.pen4,
                    NIL])
  SUPER self.render(ta,x,y,xs,ys,w)
ENDPROC

-> clear_render() - uses superclass method

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF newbutton
IF Not(SUPER self.get(NB_DISABLED))
  IF imsg.class=IDCMP_VANILLAKEY THEN RETURN (self.key=tolower(imsg.code))
  IF imsg.class=IDCMP_GADGETUP THEN RETURN (imsg.iaddress=SUPER self.get(NB_GADGET))
ENDIF
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF newbutton
IF class=IDCMP_VANILLAKEY
-> Gadget activated by a key press.  ActivateGadget() does the GM_GOACTIVE method
-> of the gadget which will either: a) for toggle/push buttons, come back right away
-> with a IDCMP_GADGETUP message, or 2) for normal buttons, go active, until the
-> gadget reads a RAWKEY_UP message (when you let go of the key)
  ActivateGadget(self.get(NB_GADGET), win, NIL)
  RETURN FALSE
ELSE
  SUPER self.set(NB_SELECTED, code)
-> Use of SUPER here is only a time-saver; sending it to self.set() will work,
-> since self.set() will eventually make this same call to the superclass
ENDIF
ENDPROC TRUE

PROC set(attr, val) OF newbutton
DEF key
  SELECT attr
    CASE NB_TEXT  -> changes the text label, and the key equivalent when needed
                        ->                *****CAUTION*****
                        -> No adjustment is made to the size of the gadget
                        -> (since I don't know how to signal EasyGUI to
                        -> resize itself).  Supplying a new label that's
                        -> larger than the one set in the constructor HAS
                        -> NOT BEEN TESTED!
      self.label:=val
      self.key:= IF key:=InStr(val, '_')<>-1 THEN tolower(val[key+1]) ELSE NIL
      self.key:= IF isalpha(self.key) THEN self.key ELSE NIL
      SUPER self.set(NB_GADGET, [GA_TEXT,val,NIL])
    DEFAULT
      SUPER self.set(attr, val)
  ENDSELECT
ENDPROC

-> get() - uses superclass method
-> since there's nothing really to get

PROC setcolour(colour, value) OF newbutton
-> I don't know why I didn't put this in the set() method... (?!)
-> BUT_ attribute values are defined in buttonclass.m
DEF proceed=TRUE
SELECT colour
  CASE BUT_TEXTPEN;      self.pen1:=value
  CASE BUT_FILLPEN;      self.pen2:=value
  CASE BUT_FILLTEXTPEN;  self.pen3:=value
  CASE BUT_BACKGROUNDPEN;self.pen4:=value
  DEFAULT;               proceed:=FALSE
ENDSELECT
IF proceed THEN self.set(NB_GADGET, [colour, value, NIL])
ENDPROC
