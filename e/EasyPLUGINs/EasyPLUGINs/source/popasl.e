/*
**
** popasl PLUGIN
**
** Copyright: Ralph Wermke of Digital Innovations
** EMail    : wermke@gryps1.rz.uni-greifswald.de
** WWW      : http://di.home.pages.de
**
** Version  : 1.2
** Date     : 10-Feb-1998
**
** ProgramID: 0007
**
** History:
**    10-Nov-1997:      [1.0]
**       - initial release
**    15-Nov-1997:      [1.0.1]
**       - object name changed to popasl_plugin
**    15-Dec-1997:      [1.1]
**       - two new tags added
**         PLA_PopAsl_ButtonOnRight    [I..]
**         PLA_PopAsl_NoFontExtension  [I..]
**    10-Feb-1998:      [1.2]
**       - two new tags added
**         PLA_PopAsl_UserData         [ISG]
**         PLA_PopAsl_Title            [IS.]
**
*/

OPT OSVERSION=38
OPT PREPROCESS
OPT MODULE

MODULE 'tools/easygui','tools/textlen',
       'graphics/text',
       'intuition/intuition','intuition/gadgetclass',
       'utility/tagitem','utility',
       'gadtools',
       'libraries/gadtools','libraries/asl',
       'asl'

EXPORT OBJECT popasl_plugin OF plugin PRIVATE
   string      : PTR TO LONG
   type
   disabled

   gad_str     : PTR TO gadget
   gad_bt      : PTR TO gadget
   id_str
   id_bt
   bt_width
   bt_text     : PTR TO CHAR
   buttonright
   noext
   imsg        : PTR TO intuimessage

   ta          : PTR TO textattr

   title       :PTR TO CHAR
   userdata

ENDOBJECT

-> TAG_USER  | PROG_ID<<16 | TAG_VALUE
-> $80000000 |   $0007<<16 | 0...

EXPORT ENUM PLA_PopAsl_Disabled=$80070001,
            PLA_PopAsl_Contents,
            PLA_PopAsl_GadgetID,
            PLA_PopAsl_ButtonText,
            PLA_PopAsl_Type,
            PLA_PopAsl_ButtonOnRight,
            PLA_PopAsl_NoFontExtension,
            PLA_PopAsl_Title,
            PLA_PopAsl_UserData

EXPORT ENUM PLV_PopAsl_Type_Drawer=0,
            PLV_PopAsl_Type_File,
            PLV_PopAsl_Type_Font
->     ,PLV_PopAsl_Type_Screen


->-- Constructor/ Destructor ---------------------------------

->>> popasl::popasl (Constructor)
PROC popasl(tags=NIL:PTR TO tagitem) OF popasl_plugin
DEF x, s:PTR TO CHAR, title:PTR TO CHAR, type

   IF utilitybase:=OpenLibrary('utility.library', 37)
      self.disabled     :=GetTagData(PLA_PopAsl_Disabled, FALSE, tags)

      s                 :=GetTagData(PLA_PopAsl_Contents, '', tags)
      self.string       :=String(StrLen(s)+1); StrCopy(self.string, s)

      self.id_bt        :=GetTagData(PLA_PopAsl_GadgetID, And(Shr(self,4),$FFFF), tags)
      self.type         :=GetTagData(PLA_PopAsl_Type, PLV_PopAsl_Type_Drawer, tags)
      self.bt_text      :=GetTagData(PLA_PopAsl_ButtonText, NIL, tags)
      self.buttonright  :=GetTagData(PLA_PopAsl_ButtonOnRight, FALSE, tags)
      self.noext        :=GetTagData(PLA_PopAsl_NoFontExtension, FALSE, tags)

      type:=self.type

      SELECT type

        CASE PLV_PopAsl_Type_Drawer;    title:='Select Drawer'
        CASE PLV_PopAsl_Type_File;      title:='Select File'
        CASE PLV_PopAsl_Type_Font;      title:='Select Font'

      ENDSELECT

      self.title        :=GetTagData(PLA_PopAsl_Title, title, tags)
      self.userdata     :=GetTagData(PLA_PopAsl_UserData, NIL, tags)

      IF (self.bt_text=NIL)
         x:=self.type
         SELECT x
            CASE PLV_PopAsl_Type_Drawer
               self.bt_text:='Path...'
            CASE PLV_PopAsl_Type_File
               self.bt_text:='File...'
            CASE PLV_PopAsl_Type_Font
               self.bt_text:='Font...'
->            CASE PLV_PopAsl_Type_Screen
->               self.bt_text:='Screen...'
            DEFAULT
               Raise("TYPE")
         ENDSELECT
      ENDIF

      self.id_str:=self.id_bt+1

      CloseLibrary(utilitybase)
   ELSE
      Raise("util")
   ENDIF

ENDPROC
-><<

->>> popasl::end (Destructor)
PROC end() OF popasl_plugin
   IF self.string THEN DisposeLink(self.string)
ENDPROC
-><<

->-- overridden methods --------------------------------------

->>> popasl::will_resize
PROC will_resize() OF popasl_plugin IS RESIZEX
-><<

->>> popasl::min_size
PROC min_size(ta:PTR TO textattr, fh) OF popasl_plugin
   self.bt_width:=textlen(self.bt_text,ta)+8
ENDPROC (self.bt_width+(fh*8)),(fh+6)
-><<

->>> popasl::gtrender
PROC gtrender(gl, vis, ta:PTR TO textattr, x, y, xs, ys, win:PTR TO window) OF popasl_plugin
DEF ng_bt, ng_str

   IF self.buttonright
      ng_bt :=[x+xs-self.bt_width+1, y, self.bt_width, ys, self.bt_text, ta, self.id_bt, 0, vis, 0]:newgadget
      ng_str:=[x, y, xs-self.bt_width, ys, NIL, ta, self.id_str, 0, vis, 0]:newgadget
   ELSE
      ng_bt :=[x, y, self.bt_width, ys, self.bt_text, ta, self.id_bt, 0, vis, 0]:newgadget
      ng_str:=[x+self.bt_width+1, y, xs-self.bt_width, ys, NIL, ta, self.id_str, 0, vis, 0]:newgadget
   ENDIF

   self.gad_bt:=CreateGadgetA(BUTTON_KIND, gl,
                              ng_bt,
                              [GA_DISABLED, self.disabled, TAG_DONE])

   self.gad_str:=CreateGadgetA(STRING_KIND, self.gad_bt,
                               ng_str,
                               [GA_DISABLED, self.disabled,
                                GTST_MAXCHARS, 350,
                                GTST_STRING, self.string,
                                TAG_DONE])
ENDPROC self.gad_str
-><<

->>> popasl::clear_render
PROC clear_render(win:PTR TO window) OF popasl_plugin

    DEF buffer:REG

    buffer:=self.gad_str.specialinfo::stringinfo.buffer

    IF self.string THEN DisposeLink(self.string)

    self.string:=String(StrLen(buffer)+1)

    StrCopy(self.string, buffer)

ENDPROC
-><<

->>> popasl::message_test
PROC message_test(imsg:PTR TO intuimessage, win:PTR TO window) OF popasl_plugin

   self.imsg:=0
   IF imsg.class=IDCMP_GADGETUP
      IF (imsg.iaddress=self.gad_bt) OR (imsg.iaddress=self.gad_str)
         self.imsg:=imsg
         RETURN TRUE
      ENDIF
   ENDIF

ENDPROC FALSE
-><<

->>> popasl::message_action
PROC message_action(class, qual, code, win:PTR TO window) OF popasl_plugin
DEF filereq:PTR TO filerequester, fontreq:PTR TO fontrequester,
    res, len, buffer:REG, tags, x, s1=NIL:PTR TO CHAR, reqtype,
    s=NIL:PTR TO CHAR

   IF self.imsg
      buffer:=self.gad_str.specialinfo::stringinfo.buffer
      IF self.imsg.iaddress=self.gad_bt
         IF (aslbase:=OpenLibrary('asl.library', 38))
            self.set(PLA_PopAsl_Disabled, TRUE)
            x:=self.type
            SELECT x
               CASE PLV_PopAsl_Type_Drawer
                  reqtype:=ASL_FILEREQUEST
                  tags:=[ASLFR_WINDOW, win,
                         ASLFR_SLEEPWINDOW, TRUE,
                         ASLFR_TITLETEXT, self.title,
                         ASLFR_INITIALDRAWER, buffer,
                         ASLFR_DRAWERSONLY, TRUE,
                         TAG_DONE]
               CASE PLV_PopAsl_Type_File
                  reqtype:=ASL_FILEREQUEST
                  s1:=PathPart(buffer)-1
                  s1:=String(len:=(s1-buffer)+2)
                  StrCopy(s1, buffer, len-1)
                  tags:=[ASLFR_WINDOW, win,
                         ASLFR_SLEEPWINDOW, TRUE,
                         ASLFR_TITLETEXT, self.title,
                         ASLFR_INITIALFILE, FilePart(buffer),
                         ASLFR_INITIALDRAWER, s1,
                         TAG_DONE]
               CASE PLV_PopAsl_Type_Font
                  reqtype:=ASL_FONTREQUEST
                  s1:=PathPart(buffer)
                  len:=s1-buffer
                  IF len  -> name/size
                     s1:=String(len)
                     StrCopy(s1, buffer,len)
                  ELSE    -> name
                     s1:=String(StrLen(buffer)+2)
                     StrCopy(s1, buffer)
                  ENDIF
                  x:=Val(FilePart(buffer), {len})
                  tags:=[ASLFO_WINDOW, win,
                         ASLFO_SLEEPWINDOW, TRUE,
                         ASLFO_TITLETEXT, self.title,
                         ASLFO_INITIALNAME, s1,
                         ASLFO_INITIALSIZE, IF len>0 THEN x ELSE 8,
                         TAG_DONE]
            ENDSELECT
            IF (filereq:=AllocAslRequest(reqtype, NIL))
               res:=AslRequest(filereq, tags)

               IF res
                  IF self.string THEN DisposeLink(self.string)

                  x:=self.type
                  SELECT x
                     CASE PLV_PopAsl_Type_Drawer
                        self.string:=String(StrLen(filereq.drawer)+1)
                        StrCopy(self.string, filereq.drawer)
                     CASE PLV_PopAsl_Type_File
                        self.string:=String(len:=(StrLen(filereq.drawer)+StrLen(filereq.file)+2))
                        StrCopy(self.string, filereq.drawer)
                        AddPart(self.string, filereq.file, len)
                        SetStr(self.string, StrLen(self.string))
                     CASE PLV_PopAsl_Type_Font
                        fontreq:=filereq
                        s:=fontreq.attr::textattr.name
                        self.string:=String(StrLen(s)+1+6)
                        IF self.noext
                           len:=InStr(s,'.font')
                           IF len<>-1 THEN s[len]:=0
                        ENDIF
                        StringF(self.string, '\s/\d', s,fontreq.attr::textattr.ysize)
                        IF self.noext THEN s[len]:="."
                  ENDSELECT

                  Gt_SetGadgetAttrsA(self.gad_str,self.gh.wnd,NIL,[GTST_STRING,self.string,TAG_DONE])
               ENDIF
               FreeAslRequest(filereq)
            ELSE
               Raise("AREQ")
            ENDIF
            self.set(PLA_PopAsl_Disabled, FALSE)
            CloseLibrary(aslbase)
         ELSE
            Raise("ASL")
         ENDIF
         IF s1 THEN DisposeLink(s1)
         -> don't call action function on cancel
         IF res=0 THEN RETURN FALSE
      ELSE
         IF self.imsg.iaddress=self.gad_str
->            IF code=9
->            ELSE
               IF self.string THEN DisposeLink(self.string)
               self.string:=String(StrLen(buffer)+1)
               StrCopy(self.string, buffer)
->            ENDIF
         ENDIF
      ENDIF
   ENDIF

ENDPROC TRUE
-><<

->-- new methods ---------------------------------------------

->>> popasl::set
PROC set(attr, value) OF popasl_plugin
DEF x

   SELECT attr
      CASE PLA_PopAsl_Disabled
         self.disabled:=value
         Gt_SetGadgetAttrsA(self.gad_bt,self.gh.wnd,NIL,[GA_DISABLED,self.disabled,TAG_DONE])
         Gt_SetGadgetAttrsA(self.gad_str,self.gh.wnd,NIL,[GA_DISABLED,self.disabled,TAG_DONE])
      CASE PLA_PopAsl_Contents
         IF value
            IF self.string THEN DisposeLink(self.string)
            self.string:=String(StrLen(value)+1)
            StrCopy(self.string, value)
            Gt_SetGadgetAttrsA(self.gad_str,self.gh.wnd,NIL,[GTST_STRING,self.string,TAG_DONE])
         ENDIF
      CASE PLA_PopAsl_Title
        IF value THEN self.title:=value ELSE self.title:=''
      CASE PLA_PopAsl_UserData
         self.userdata:=value
   ENDSELECT

ENDPROC
-><<

->>> popasl::get
PROC get(attr) OF popasl_plugin

   SELECT attr
      CASE PLA_PopAsl_UserData
         RETURN self.userdata, TRUE
      CASE PLA_PopAsl_Contents
         self.clear_render(NIL)      -> copy input buffer to self.string
         RETURN self.string, TRUE
      CASE PLA_PopAsl_Disabled
         RETURN self.disabled, TRUE
   ENDSELECT

ENDPROC -1, FALSE
-><<





