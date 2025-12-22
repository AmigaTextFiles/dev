OPT MODULE
OPT PREPROCESS

-> RST: Added conditional EASY_OS12 support
#define EASY_OS12

#ifdef EASY_OS12
  MODULE 'tools/easygui_os12','hybrid/tagdata'
  #define GetTagData getTagData
#endif
#ifndef EASY_OS12
  OPT OSVERSION=37
  MODULE 'tools/easygui','utility'
#endif

MODULE 'gadtools', 'libraries/gadtools', 'devices/inputevent',
       'intuition/gadgetclass', 'intuition/intuition', 'utility/tagitem',
       'tools/textlen', 'tools/ctype', 'exec/nodes',
       'exec/lists'

->define DCLIST to make EasyGUI's gadget list more readable!
EXPORT CONST DCLIST=PLUGIN

EXPORT ENUM DCLV_LABEL=$FF000001,            -> [I..]
  DCLV_RELX,                                 -> [I..]
  DCLV_RELY,                                 -> [I..]
  DCLV_LIST,                                 -> [ISG]
  DCLV_CURRENT,                              -> [ISG]
  DCLV_CLICK,                                -> [..G]
  DCLV_TOP,                                  -> [ISG]
  DCLV_DISABLED                              -> [ISG]

EXPORT OBJECT dclistview OF plugin PRIVATE
  disabled
  current
  top
  clicked
  listview:PTR TO gadget
  label
  labelhi
  relx, rely
  execlist
  maxnode
  key
  second1, micros1
  second2, micros2
ENDOBJECT

PROC dclistview(tags:PTR TO tagitem) OF dclistview
DEF key,label
#ifndef EASY_OS12
  IF utilitybase
#endif
    self.label:=      GetTagData(DCLV_LABEL,     NIL, tags)
    self.relx :=  Max(GetTagData(DCLV_RELX,        5, tags), 5)
    self.rely :=  Max(GetTagData(DCLV_RELY,        5, tags), 2)
    self.execlist:=   GetTagData(DCLV_LIST,      NIL, tags)
    self.maxnode:=    max_node(self.execlist)
    self.current:=Max(GetTagData(DCLV_CURRENT,   NIL, tags), -1)
    self.top:=    Max(GetTagData(DCLV_TOP,       NIL, tags),0)
    self.disabled:=   GetTagData(DCLV_DISABLED,FALSE, tags)
    IF label:=self.label
      self.key:= IF (key:=InStr(label, '_'))<>-1 THEN tolower(label[key+1]) ELSE NIL
      self.key:= IF isalpha(self.key) THEN self.key ELSE NIL
    ENDIF
    self.second1:=NIL
    self.second2:=NIL
    self.micros1:=NIL
    self.micros2:=NIL
#ifndef EASY_OS12
  ELSE
    Raise("util")
  ENDIF
#endif
ENDPROC

PROC end() OF dclistview IS EMPTY

PROC min_size(ta,fh) OF dclistview
  self.labelhi:=IF self.label THEN fh+5 ELSE 0
ENDPROC Max(textlen_key(self.label,ta,self.key),self.relx*fh), self.rely*fh+self.labelhi+5

PROC will_resize() OF dclistview IS (RESIZEX OR RESIZEY)

PROC gtrender(gl,vis,ta,x,y,xs,ys,w) OF dclistview HANDLE
  self.listview:=CreateGadgetA(LISTVIEW_KIND,gl,
                 [x,y+self.labelhi,xs,ys-self.labelhi,self.label,
                     ta,0,0,vis,NIL]:newgadget,
                 [GTLV_LABELS, self.execlist,
                  GA_DISABLED, self.disabled,
                  IF self.key THEN GT_UNDERSCORE ELSE TAG_IGNORE, "_",
                  GTLV_SHOWSELECTED, NIL,
                  GTLV_SELECTED, self.current,
                  GTLV_TOP, self.top,
                  TAG_DONE])
  IF self.listview=NIL THEN Raise("dclv")
EXCEPT DO
  ReThrow()
ENDPROC self.listview

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF dclistview
DEF islist=FALSE
IF ((imsg.class=IDCMP_VANILLAKEY) AND Not(self.disabled)) THEN RETURN (self.key=tolower(imsg.code))
IF (imsg.class=IDCMP_GADGETUP)
  IF islist:= (imsg.iaddress=self.listview)
    self.second2:=imsg.seconds
    self.micros2:=imsg.micros
  ENDIF
ENDIF
ENDPROC islist

PROC message_action(class,qual,code,win:PTR TO window) OF dclistview
DEF newcurrent
SELECT class
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
    ENDIF
ENDSELECT
  self.second1:=self.second2
  self.micros1:=self.micros2
  self.second2:=NIL
  self.micros2:=NIL
ENDPROC TRUE

PROC set(attr, val) OF dclistview
  SELECT attr
    CASE DCLV_DISABLED
      IF KickVersion(39)
        IF self.disabled<>val
          self.disabled:=val
          IF visible(self) THEN
            Gt_SetGadgetAttrsA(self.listview,self.gh.wnd,NIL,[GA_DISABLED,self.disabled,TAG_DONE])
          self.clicked:=FALSE
        ENDIF
      ENDIF
    CASE DCLV_LIST
      self.maxnode:=max_node(val)
      IF visible(self) THEN
        Gt_SetGadgetAttrsA(self.listview, self.gh.wnd, NIL, [GTLV_LABELS, val, TAG_DONE])
      self.execlist:=val
      self.clicked:=FALSE
    CASE DCLV_TOP
      self.top:=Bounds(val,0,self.maxnode)
      IF visible(self) THEN
        Gt_SetGadgetAttrsA(self.listview, self.gh.wnd, NIL, [GTLV_TOP, self.top, TAG_DONE])
    CASE DCLV_CURRENT
      self.current:= Bounds(val,-1,self.maxnode)
      IF visible(self) THEN
        Gt_SetGadgetAttrsA(self.listview, self.gh.wnd, NIL, [GTLV_SELECTED, self.current,
                                                             IF KickVersion(39) THEN GTLV_MAKEVISIBLE ELSE GTLV_TOP, Max(val,0),
                                                             TAG_DONE])
      self.clicked:=FALSE
      RETURN self.current
  ENDSELECT
ENDPROC

PROC get(attr) OF dclistview
  SELECT attr
    CASE DCLV_LIST;     RETURN self.execlist, TRUE
    CASE DCLV_CURRENT;  RETURN self.current, TRUE
    CASE DCLV_TOP;      RETURN self.top, TRUE
    CASE DCLV_CLICK;    RETURN self.clicked, TRUE
    CASE DCLV_DISABLED; RETURN self.disabled, TRUE
  ENDSELECT
ENDPROC -1, FALSE

PROC visible(self:PTR TO dclistview) IS (self.listview AND self.gh.wnd)

PROC max_node(list:PTR TO lh)
DEF node:PTR TO ln, i=NIL
  IF list>0
    node:=list.head
    WHILE node:=node.succ DO INC i
  ENDIF
ENDPROC i

