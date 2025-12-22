/* 
 *  TextField-Plugin 1.0
 * -====================-
 * 
 * Changes:
 * --------
 *
 * 0.9: = First BETA-Version
 *      - Wrote the whole code
 * 
 * 1.0: = BugFixes + new Features
 *      - Open the Class by itselfs, the "User" hasn`t longer to do that!
 *      - You could write the Tags for the TextField-Gadget by yourself!
 *      - changed the destructors-name to end!
 * 
 */

OPT     MODULE
OPT     OSVERSION = 37

MODULE  'gadgets/textfield'
MODULE  'graphics/rastport'
MODULE  'intuition/gadgetclass'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'
MODULE  'textfield'
MODULE  'utility/tagitem'

EXPORT  CONST   TEXTFIELD = PLUGIN

EXPORT  OBJECT  textfield OF plugin
PRIVATE
 win            :PTR TO window
 textfieldbase
 textfieldclass
 tf_obj
ENDOBJECT

DEF     textfieldbase

PROC textfield(xs,ys,tags)                         OF textfield
 IF (textfieldbase:=OpenLibrary('gadgets/textfield.gadget',TEXTFIELD_VER))
  self.textfieldbase:=textfieldbase
   self.textfieldclass:=Textfield_GetClass()
    self.xs:=xs
     self.ys:=ys
       self.tf_obj:=NewObjectA(self.textfieldclass,0,
               [GA_ID,          self.tf_obj,
                GA_TOP,         1,
                GA_LEFT,        1,
                TAG_MORE,       tags,
                NIL,NIL])
 ELSE
  RETURN FALSE
 ENDIF
ENDPROC self.textfieldbase

PROC end()                                      OF textfield
  IF (self.tf_obj<>NIL) THEN DisposeObject(self.tf_obj)
 IF (textfieldbase<>NIL) THEN CloseLibrary(self.textfieldbase)
ENDPROC

PROC will_resize()                              OF textfield IS RESIZEXANDY

PROC min_size(x,y)                              OF textfield IS self.xs,self.ys

PROC render(a,x,y,xs,ys,win:PTR TO window)      OF textfield
 DEF    gad:PTR TO gadget
  gad:=self.tf_obj
   gad.leftedge:=x
   gad.topedge:=y
   gad.width:=xs
   gad.height:=ys
    IF self.win=NIL
      AddGList(win,gad,-1,-1,0)
     self.win:=win
    ENDIF
   RefreshGadgets(gad,win,0)
ENDPROC

PROC message_test(msg:PTR TO intuimessage,win)  OF textfield IS FALSE

PROC message_action(a,b,c,win)                  OF textfield IS TRUE

PROC getgadget()                                OF textfield IS self.tf_obj,self.win
