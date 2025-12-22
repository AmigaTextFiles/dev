/*
**
** Name         : TextField PLUGIN
**              : Part of the EasyPLUGINs package
**
** Copyright    : Ralph Wermke of Digital Innovations
** EMail        : wermke@uni-greifswald.de
** WWW          : http://www.user.fh-stralsund.de/~rwermke/di.html
**
** ProgID       : $08
** ProgrammerID : $00
**
** Version      : 0.9
** Date         : 11-Dec-97
**
*/

OPT PREPROCESS
OPT MODULE
OPT EXPORT

MODULE 'tools/easygui',
       'graphics/text',
       'utility/tagitem','utility',
       'intuition/intuition','intuition/gadgetclass','intuition/classes',
       'workbench/workbench',
       'gadgets/textfield','textfield'


OBJECT textfield_plugin OF plugin PRIVATE
   gad      : PTR TO gadget
   tfclass  : PTR TO iclass
   text     : PTR TO CHAR
   pos
   win      : PTR TO window
   disabled
ENDOBJECT


CONST TAG_BASE = $80080000

->- Special Tags ------------------------------------------

ENUM PLA_TextField_Disabled=TAG_BASE,
     PLA_TextField_Text,
     PLA_TextField_TextLen

->- Special Values ----------------------------------------


->- Constructor/ Destructor -------------------------------

PROC textfield(tags=NIL:PTR TO tagitem) OF textfield_plugin

   IF (textfieldbase:=OpenLibrary('gadgets/textfield.gadget',0))=NIL THEN Raise("TXTF")

   self.tfclass:=TeXTFIELD_GetClass()

   IF utilitybase:=OpenLibrary('utility.library', 37)

      self.text    :=GetTagData(PLA_TextField_Text, NIL, tags)
      self.disabled:=GetTagData(PLA_TextField_Disabled, FALSE, tags)
      self.pos     :=0
      self.gad     :=0
      self.win     :=0

      CloseLibrary(utilitybase)
   ELSE
      Raise("UTIL")
   ENDIF

ENDPROC

PROC end() OF textfield_plugin
   IF self.text THEN Dispose(self.text)
   self.tfclass:=NIL
   IF textfieldbase THEN CloseLibrary(textfieldbase)
ENDPROC


->- Overridden Methods ------------------------------------

PROC will_resize() OF textfield_plugin IS (RESIZEX OR RESIZEY)

PROC min_size(ta:PTR TO textattr, fh) OF textfield_plugin IS (10*fh),(5*fh)

PROC render(ta:PTR TO textattr,x,y,xs,ys,win:PTR TO window) OF textfield_plugin

   self.gad:=NewObjectA(self.tfclass, NIL, [GA_LEFT, x,
                                            GA_TOP, y,
                                            GA_WIDTH, xs,
                                            GA_HEIGHT, ys,
                                            GA_ID, 1,
                                            TEXTFIELD_BORDER, TEXTFIELD_BORDER_DOUBLEBEVEL,
                                            TEXTFIELD_BLOCKCURSOR, TRUE,
                                            TEXTFIELD_TABSPACES, 4,
                                            TEXTFIELD_TEXT, self.text,
                                            TEXTFIELD_CURSORPOS, self.pos,
                                            GA_DISABLED, self.disabled,
                                            TAG_DONE])
   IF self.gad=NIL THEN Raise("GAD")
   self.win:=win
   AddGList(win,self.gad,-1,1,NIL)
   RefreshGList(self.gad,win,NIL,1)

ENDPROC

PROC clear_render(win:PTR TO window) OF textfield_plugin
DEF len, buffer, pos

   IF self.gad

      SetGadgetAttrsA(self.gad, win, NIL, [TEXTFIELD_READONLY, TRUE, TAG_DONE])

      GetAttr(TEXTFIELD_SIZE, self.gad, {len})
      GetAttr(TEXTFIELD_TEXT, self.gad, {buffer})
      GetAttr(TEXTFIELD_CURSORPOS, self.gad, {pos})
      self.pos:=pos

      IF buffer
         Dispose(self.text)
         self.text:=New(len+1)
         AstrCopy(self.text,buffer,len+1)
      ENDIF

      SetGadgetAttrsA(self.gad, win, NIL, [TEXTFIELD_READONLY, FALSE, TAG_DONE])

      RemoveGList(win,self.gad,1)
      DisposeObject(self.gad)
   ENDIF

ENDPROC


->- New Methods -------------------------------------------

PROC set(attr, value) OF textfield_plugin
DEF len

   SELECT attr

      CASE PLA_TextField_Disabled
         IF self.gad
            SetGadgetAttrsA(self.gad,self.gh.wnd,NIL,[GA_DISABLED,self.disabled,TAG_DONE])
         ENDIF
      CASE PLA_TextField_Text
         IF value
            IF self.gad
               Dispose(self.text)
               len:=StrLen(value)+1
               self.text:=New(len)
               AstrCopy(self.text,value,len)
               SetGadgetAttrsA(self.gad,self.gh.wnd,NIL,[TEXTFIELD_TEXT,self.text,TAG_DONE])
            ENDIF
         ENDIF

   ENDSELECT

ENDPROC


PROC get(attr) OF textfield_plugin
DEF x

   SELECT attr

      CASE PLA_TextField_Disabled
         RETURN self.disabled, TRUE
      CASE PLA_TextField_Text
         IF self.win AND self.gad
            SetGadgetAttrsA(self.gad, self.win, NIL, [TEXTFIELD_READONLY, TRUE, TAG_DONE])
            GetAttr(TEXTFIELD_TEXT, self.gad, {x})
            SetGadgetAttrsA(self.gad, self.win, NIL, [TEXTFIELD_READONLY, FALSE, TAG_DONE])
            RETURN x, TRUE
         ENDIF
      CASE PLA_TextField_TextLen
         IF self.gad
            GetAttr(TEXTFIELD_SIZE, self.gad, {x})
            RETURN x, TRUE
         ENDIF
   ENDSELECT

ENDPROC -1,FALSE

