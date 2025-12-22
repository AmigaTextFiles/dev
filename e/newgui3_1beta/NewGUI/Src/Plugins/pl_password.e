OPT     OSVERSION = 37
OPT     MODULE

MODULE  'newgui/newgui'
MODULE  'intuition/intuition'
MODULE  'intuition/sghooks'
MODULE  'intuition/gadgetclass'
MODULE  'gadtools'
MODULE  'libraries/gadtools'
MODULE  'tools/textlen'
MODULE  'tools/inithook'
MODULE  'utility/hooks'

RAISE "MEM" IF String()=NIL

EXPORT  CONST   PASSWORD = PLUGIN

CONST NUM_EOS=EO_SPECIAL+1

-> Share gadtoolsbase with EasyGUI

EXPORT OBJECT password OF plugin
  estr
PRIVATE
  password:PTR TO gadget
  label
  over
  relx
  mid
  hook:hook
ENDOBJECT

PROC password(estr,label=NIL,over=FALSE,relx=0,disabled=FALSE) OF password
  self.estr:=estr
  self.label:=IF label THEN label ELSE ''
  self.over:=over
  self.relx:=IF relx THEN relx ELSE 5
  self.dis:=disabled
  inithook(self.hook,{passHookCode},estr)
ENDPROC

PROC end() OF password IS EMPTY

PROC min_size(ta,fh) OF password
  self.mid:=textlen(self.label,ta)+8
ENDPROC self.relx*fh+self.mid, fh+6

PROC will_resize() OF password IS RESIZEX

-> Don't need to define this:
->PROC render(ta,x,y,xs,ys,w) OF password IS EMPTY

PROC gtrender(gl,vis,ta,x,y,xs,ys,w) OF password HANDLE
  DEF len, pass=NIL
  pass:=makePass(self.estr)
  len:=textlen(self.label,ta)
  self.password:=CreateGadgetA(STRING_KIND,gl,
                 [x+self.mid,y,xs-self.mid,ys,self.label,ta,0,
                  PLACETEXT_LEFT,vis,NIL]:newgadget,
                 [GTST_STRING,pass, GTST_EDITHOOK,self.hook,
                  GTST_MAXCHARS,StrMax(self.estr), GA_DISABLED,self.dis,
                  STRINGA_REPLACEMODE,self.over, NIL])
  IF self.password=NIL THEN Raise("pass")
EXCEPT DO
  DisposeLink(pass)
  ReThrow()
ENDPROC self.password

-> Don't need to define this:
-> PROC clear_render(win:PTR TO window) OF password IS EMPTY

PROC message_test(imsg:PTR TO intuimessage,win:PTR TO window) OF password
  IF imsg.class=IDCMP_GADGETUP THEN RETURN imsg.iaddress=self.password
ENDPROC FALSE

PROC message_action(class,qual,code,win:PTR TO window) OF password
ENDPROC TRUE

PROC isgtgadget()       OF password IS TRUE

PROC setpass(str) OF password HANDLE
  DEF pass=NIL
  pass:=makePass(str)
  Gt_SetGadgetAttrsA(self.password,self.gh.wnd,NIL,[GTST_STRING,pass,NIL])
  StrCopy(self.estr,str)
EXCEPT DO
  DisposeLink(pass)
ENDPROC

PROC disable(disabled=TRUE) OF password
  Gt_SetGadgetAttrsA(self.password,self.gh.wnd,NIL,[GA_DISABLED,disabled,NIL])
  self.dis:=disabled
ENDPROC

PROC makePass(s)
  DEF len, p=NIL
  IF s
    IF len:=StrLen(s)
      SetStr(p:=String(len),len)
      WHILE len DO p[len--]:="*"
    ENDIF
  ENDIF
ENDPROC p

PROC passHookCode(hook:PTR TO hook, sgw:PTR TO sgwork, msg:PTR TO LONG)
  DEF realBuff:PTR TO CHAR, bp
  IF msg[]=SGH_KEY
    realBuff:=hook.data
    bp:=sgw.bufferpos
    SELECT NUM_EOS OF sgw.editop
    CASE EO_DELBACKWARD
      IF bp<>sgw.numchars
        sgw.actions:=(sgw.actions OR SGA_BEEP) AND Not(SGA_USE)
      ELSE
        SetStr(realBuff, bp)
      ENDIF
    CASE EO_REPLACECHAR
      realBuff[bp--]:=sgw.code
      sgw.workbuffer[bp]:="*"
    CASE EO_INSERTCHAR
      IF bp<>sgw.numchars
        sgw.actions:=(sgw.actions OR SGA_BEEP) AND Not(SGA_USE)
      ELSE
        SetStr(realBuff, bp)
        realBuff[bp--]:=sgw.code
        sgw.workbuffer[bp]:="*"
      ENDIF
    CASE EO_NOOP, EO_MOVECURSOR, EO_ENTER, EO_BADFORMAT
      -> Safely ignore
    DEFAULT
      -> EO_DELFORWARD, EO_BIGCHANGE, EO_RESET, EO_UNDO, EO_CLEAR, EO_SPECIAL
      -> Disallow
      sgw.actions:=(sgw.actions OR SGA_BEEP) AND Not(SGA_USE)
    ENDSELECT
    RETURN -1
  ENDIF
  -> UNKNOWN COMMAND
  -> Hook should return zero if the command is not supported
ENDPROC 0
