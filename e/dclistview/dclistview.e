/*
   Name:      dclistview.e
   About:     A listview Plugin that understands double-clicks
   Version:   $VER: dclistview.e 1.6 (19.1.99)
   Author:    Copyright © 1997, 1998, 1999 Victor Ducedre.  All Rights Reserved.

   A brief note:  This version has been updated with the use of etaglist.m
   from dev/e/SvensModules.lha.  eGetTagData() is the same as GetTagData()
   from utility.library, but does not require the library.

*/
OPT MODULE
OPT PREPROCESS

MODULE 'gadtools', 'libraries/gadtools', 'devices/inputevent',
       'intuition/gadgetclass', 'intuition/intuition', 'utility/tagitem',
       'tools/EasyGUI', 'tools/textlen', 'tools/ctype', 'exec/nodes',
       'exec/lists', 'sven/support/etaglist', 'graphics/text'

->define DCLIST to make EasyGUI's gadget list more readable!
EXPORT CONST DCLIST=PLUGIN

EXPORT ENUM DCLV_LABEL=$FF000001,           -> [I..]
            DCLV_RELX,                      -> [I..]
            DCLV_RELY,                      -> [I..]
            DCLV_LIST,                      -> [ISG]
            DCLV_CURRENT,                   -> [ISG]
            DCLV_CLICK,                     -> [..G]
            DCLV_TOP,                       -> [ISG]
            DCLV_DISABLED,                  -> [ISG]
            DCLV_TEXTATTR,                  -> [I..]
            DCLV_USEARROWS                  -> [I..]

EXPORT OBJECT dclistview OF plugin PRIVATE
  disabled
  current
  top
  clicked
  gadget:PTR TO gadget
  label
  labelhi
  relx, rely
  execlist
  maxnode
  key
  second1, micros1
  second2, micros2
  textattr:PTR TO textattr
  cursor
ENDOBJECT

PROC dclistview(tags:PTR TO tagitem) OF dclistview
DEF key,label
-> eGetTagData() is from sven/support/etaglist.  See docs.
  self.label:=      eGetTagData(DCLV_LABEL,     NIL, tags)
  self.relx :=  Max(eGetTagData(DCLV_RELX,        5, tags), 5)
  self.rely :=  Max(eGetTagData(DCLV_RELY,        5, tags), 2)
  self.execlist:=   eGetTagData(DCLV_LIST,      NIL, tags)
  self.maxnode:=    max_node(self.execlist)
  self.current:=Max(eGetTagData(DCLV_CURRENT,   NIL, tags), -1)
  self.top:=    Max(eGetTagData(DCLV_TOP,       NIL, tags),0)
  self.disabled:=   eGetTagData(DCLV_DISABLED,FALSE, tags)
  self.cursor:=     eGetTagData(DCLV_USEARROWS,FALSE, tags)
  IF self.cursor
    self.key:=NIL
  ELSEIF label:=self.label
    self.key:= IF (key:=InStr(label, '_'))<>-1 THEN tolower(label[key+1]) ELSE NIL
    self.key:= IF isalpha(self.key) THEN self.key ELSE NIL
  ENDIF
  self.textattr:=   eGetTagData(DCLV_TEXTATTR,  NIL, tags)
  self.second1:=NIL;  self.second2:=NIL
  self.micros1:=NIL;  self.micros2:=NIL
ENDPROC

PROC end() OF dclistview IS EMPTY

PROC min_size(ta,fh) OF dclistview
  IF self.textattr THEN fh:=self.textattr.ysize
  self.labelhi:=IF self.label THEN fh+5 ELSE 0
ENDPROC Max(textlen_key(self.label,ta,self.key),self.relx*fh), self.rely*fh+self.labelhi+5

PROC will_resize() OF dclistview IS (RESIZEX OR RESIZEY)

PROC gtrender(gl,vis,ta,x,y,xs,ys,w) OF dclistview HANDLE

  self.gadget:=CreateGadgetA(LISTVIEW_KIND,gl,
                 [x,y+self.labelhi,xs,ys-self.labelhi,self.label,
                  IF self.textattr THEN self.textattr ELSE ta,0,0,vis,NIL]:newgadget,
                 [GTLV_LABELS, self.execlist,
                  GA_DISABLED, self.disabled,
                  IF self.key THEN GT_UNDERSCORE ELSE TAG_IGNORE, "_",
                  GTLV_SHOWSELECTED, NIL,
                  GTLV_SELECTED, self.current,
                  GTLV_TOP, self.top,
                  TAG_DONE])
  IF self.gadget=NIL THEN Raise("dclv")
EXCEPT DO
  ReThrow()
ENDPROC self.gadget

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF dclistview
DEF islist=FALSE
IF Not(self.disabled)
  IF (imsg.class=IDCMP_VANILLAKEY) THEN RETURN (self.key=tolower(imsg.code))
  IF (imsg.class=IDCMP_RAWKEY) AND (self.cursor) THEN RETURN ((imsg.code=CURSORUP) OR (imsg.code=CURSORDOWN))
ENDIF
IF (imsg.class=IDCMP_GADGETUP)
  IF islist:= (imsg.iaddress=self.gadget)
    self.second2:=imsg.seconds
    self.micros2:=imsg.micros
  ENDIF
ENDIF
ENDPROC islist

PROC message_action(class,qual,code,win:PTR TO window) OF dclistview
DEF newcurrent, altused
SELECT class
  CASE IDCMP_RAWKEY
    SELECT code
      altused:=(qual AND (IEQUALIFIER_LALT OR IEQUALIFIER_RALT))
      CASE CURSORUP
        newcurrent:=IF altused THEN 0 ELSE Max(self.current-1, 0)
      CASE CURSORDOWN
        newcurrent:=IF altused THEN self.maxnode ELSE Min(self.current+1, self.maxnode)
    ENDSELECT
    IF newcurrent=self.current THEN RETURN FALSE ELSE self.current:=newcurrent
    self.set(DCLV_CURRENT, self.current)
  CASE IDCMP_VANILLAKEY
    IF (qual AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT))
      newcurrent:=Max(self.current-1, 0)
    ELSE
      newcurrent:=Min(self.current+1, self.maxnode)
    ENDIF
    IF newcurrent=self.current THEN RETURN FALSE ELSE self.current:=newcurrent
    self.set(DCLV_CURRENT, self.current)
  CASE IDCMP_GADGETUP
    IF code=self.current
      self.clicked:=(IF self.clicked THEN FALSE ELSE DoubleClick(self.second1,self.micros1,self.second2,self.micros2))
    ELSE
      self.current:=code
      self.clicked:=FALSE
    ENDIF
ENDSELECT
  self.second1:=self.second2;  self.second2:=NIL
  self.micros1:=self.micros2;  self.micros2:=NIL
ENDPROC TRUE

PROC set(attr, val) OF dclistview IS self.setA([attr, val, TAG_DONE])

PROC setA(tags:PTR TO LONG) OF dclistview
DEF newattr=NIL, attr, val, vers, newtop

  vers:=KickVersion(39)
  WHILE (attr:=Long(tags++))
    val:=Long(tags++)
    SELECT attr
      CASE DCLV_DISABLED
        IF vers
          IF self.disabled<>val
            self.disabled:=val
            newattr:=NEW [GA_DISABLED, self.disabled, TAG_DONE]
            self.clicked:=FALSE
          ENDIF
        ENDIF
      CASE DCLV_LIST
        self.maxnode:=max_node(val)
        newattr:=NEW [GTLV_LABELS, val, TAG_DONE]
        self.execlist:=val
        self.clicked:=FALSE
      CASE DCLV_TOP
        self.top:=Bounds(val,0,self.maxnode)
        newattr:=NEW [GTLV_TOP, self.top, TAG_DONE]
      CASE DCLV_CURRENT
        self.current:= Bounds(val,-1,self.maxnode)
        newattr:=NEW [GTLV_SELECTED, self.current,
                      IF vers THEN GTLV_MAKEVISIBLE ELSE GTLV_TOP, Max(self.current,0),
                      TAG_DONE]
        IF vers
          Gt_GetGadgetAttrsA(self.gadget, self.gh.wnd,NIL, [GTLV_TOP, {newtop}, TAG_DONE])
        ELSE
          newtop:=Max(self.current,0)
        ENDIF
        self.top:=newtop
        self.clicked:=FALSE
    ENDSELECT
    IF newattr
      IF visible(self) THEN Gt_SetGadgetAttrsA(self.gadget, self.gh.wnd, NIL, newattr)
      FastDisposeList(newattr)
    ENDIF
  ENDWHILE
ENDPROC

PROC get(attr) OF dclistview
  SELECT attr
    CASE DCLV_LIST;     RETURN self.execlist, TRUE
    CASE DCLV_CURRENT;  RETURN self.current,  TRUE
    CASE DCLV_TOP;      RETURN self.top,      TRUE
    CASE DCLV_CLICK;    RETURN self.clicked,  TRUE
    CASE DCLV_DISABLED; RETURN self.disabled, TRUE
  ENDSELECT
ENDPROC -1, FALSE

PROC visible(self:PTR TO dclistview) IS (self.gadget)AND(self.gh.wnd)

PROC max_node(list:PTR TO lh)
DEF node=NIL:PTR TO ln, i=-1
  IF list>0
    node:=list.head
    WHILE node:=node.succ DO INC i
  ENDIF
ENDPROC i

