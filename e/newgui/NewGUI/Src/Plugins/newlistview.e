OPT MODULE

MODULE  'gadtools'
MODULE  'libraries/gadtools'
MODULE  'devices/inputevent'
MODULE  'intuition/gadgetclass'
MODULE  'intuition/intuition'
MODULE  'utility/tagitem'
MODULE  'tools/textlen'
MODULE  'tools/ctype'
MODULE  'exec/nodes'
MODULE  'exec/lists'
MODULE  'newgui/newgui'

EXPORT  CONST   NEWLISTV = PLUGIN

EXPORT OBJECT newlistv OF plugin
  disabled
  current
  clicked
PRIVATE
  listview:PTR TO gadget
  label
  labelhi
  relx, rely
  execlist
  maxnode
  key
  second1, micros1
  second2, micros2
  vers
ENDOBJECT

PROC newlistv(label=NIL,relx=0,rely=0,execlist=NIL,current=0,key=NIL,disabled=FALSE) OF newlistv
  self.label:=IF label THEN label ELSE NIL
  self.relx:=IF relx>=5 THEN relx ELSE 5
  self.rely:=IF rely>=2 THEN rely ELSE 5
  self.execlist:=execlist
  self.maxnode:=max_node(execlist)
  self.current:=IF current>=0 THEN current ELSE -1
  self.disabled:=disabled
  key:= tolower(key)
  self.key:=IF isalpha(key) THEN key ELSE NIL
  self.second1:=NIL
  self.second2:=NIL
  self.micros1:=NIL
  self.micros2:=NIL
  self.vers:=KickVersion(39)
ENDPROC

PROC end() OF newlistv IS EMPTY

PROC min_size(ta,fh) OF newlistv
  self.labelhi:=IF self.label THEN fh+5 ELSE 0
ENDPROC Max(textlen_key(self.label,ta,self.key),self.relx*fh), self.rely*fh+self.labelhi+5

PROC will_resize() OF newlistv IS (RESIZEX OR RESIZEY)

PROC gtrender(gl,vis,ta,x,y,xs,ys,w) OF newlistv HANDLE
  self.listview:=CreateGadgetA(LISTVIEW_KIND,gl,
                 [x,y+self.labelhi,xs,ys-self.labelhi,self.label,
                     ta,0,0,vis,NIL]:newgadget,
                 [GTLV_LABELS, self.execlist,
                  GA_DISABLED, self.disabled,
                  IF self.key THEN GT_UNDERSCORE ELSE TAG_IGNORE, "_",
                  GTLV_SHOWSELECTED, NIL,
                  GTLV_SELECTED, self.current,
                  GTLV_TOP, Max(self.current,0),
                  TAG_DONE])
  IF self.listview=NIL THEN Raise("dclv") 
EXCEPT DO
  ReThrow()
ENDPROC self.listview

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF newlistv
DEF islist=FALSE
IF ((imsg.class=IDCMP_VANILLAKEY) AND Not(self.disabled)) THEN RETURN (self.key=tolower(imsg.code))
IF (imsg.class=IDCMP_GADGETUP)
  IF islist:= (imsg.iaddress=self.listview)
    self.second2:=imsg.seconds
    self.micros2:=imsg.micros
  ENDIF              
ENDIF
ENDPROC islist

PROC message_action(class,qual,code,win:PTR TO window) OF newlistv
DEF newcurrent
SELECT class
  CASE IDCMP_VANILLAKEY
    self.clicked:=FALSE
    IF (qual AND (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT))
      newcurrent:=Max(self.current-1, 0)
    ELSE
      newcurrent:=Min(self.current+1, self.maxnode)
    ENDIF
    IF newcurrent=self.current THEN RETURN FALSE ELSE self.current:=newcurrent
    Gt_SetGadgetAttrsA(self.listview,self.gh.wnd,NIL,[GTLV_SELECTED,self.current,
                                                      IF self.vers THEN GTLV_MAKEVISIBLE ELSE GTLV_TOP, self.current,
                                                      TAG_DONE])
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

PROC isgtgadget()       OF newlistv IS TRUE

PROC setdisabled(disabled=TRUE) OF newlistv
  IF self.vers
    Gt_SetGadgetAttrsA(self.listview,self.gh.wnd,NIL,[GA_DISABLED,disabled,TAG_DONE])
    self.disabled:=disabled
    self.clicked:=FALSE
  ENDIF
ENDPROC

PROC setdclist(list) OF newlistv
  self.maxnode:=max_node(list)
  Gt_SetGadgetAttrsA(self.listview, self.gh.wnd, NIL, [GTLV_LABELS, list, TAG_DONE])
  self.execlist:=list
  self.clicked:=FALSE
ENDPROC

PROC getdclist() OF newlistv IS self.execlist

PROC setdctop(top) OF newlistv IS Gt_SetGadgetAttrsA(self.listview, self.gh.wnd, NIL,
                                                       [GTLV_TOP, top, TAG_DONE])

PROC setdccurrent(current) OF newlistv
  self.current:= Bounds(current,-1,self.maxnode)
  Gt_SetGadgetAttrsA(self.listview, self.gh.wnd, NIL, [GTLV_SELECTED, self.current,
                                                       IF self.vers THEN GTLV_MAKEVISIBLE ELSE GTLV_TOP, Max(current,0),
                                                       TAG_DONE])
  self.clicked:=FALSE
ENDPROC self.current

PROC max_node(list:PTR TO lh)
DEF node:PTR TO ln, i=NIL
  IF list>0
    node:=list.head
    WHILE node.succ
      node:=node.succ
      INC i
    ENDWHILE
  DEC i
  ENDIF
ENDPROC i

