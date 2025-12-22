OPT AMIGAOS4, MODULE

-> amigalib/cx.e

OPT PREPROCESS

MODULE 'commodities',
       'icon',
       'devices/inputevent',
       'libraries/commodities'

EXPORT PROC userFilter(tt, action_name, default_descr)
  DEF desc=NIL
  IF (iconbase=NIL) OR (cxbase=NIL) THEN RETURN NIL
  IF tt THEN desc:=FindToolType(tt, action_name)
ENDPROC CxFilter(IF desc THEN desc ELSE default_descr)

EXPORT PROC hotKey(description, port, id)
  DEF filter
  IF cxbase=NIL THEN RETURN NIL
  IF filter:=CxFilter(description)
    AttachCxObj(filter, CxSender(port, id))
    AttachCxObj(filter, CxTranslate(NIL))
    IF CxObjError(filter)
      DeleteCxObjAll(filter)
      filter:=NIL
    ENDIF
  ENDIF
ENDPROC filter

EXPORT PROC freeIEvents(events:PTR TO inputevent)
  DEF next
  WHILE events
    next:=events.nextevent
    END events
    events:=next
  ENDWHILE
ENDPROC

ENUM ERR_NONE, ERR_ESC, ERR_ANGLE

EXPORT PROC invertStringRev(str, km) HANDLE
  DEF events=NIL, c, curr:PTR TO inputevent, ie:PTR TO inputevent
  IF cxbase=NIL THEN RETURN NIL
  IF str
    IF str[]
      curr:=(events:=NEW ie)
      c:=str[]++
      REPEAT
        IF c="<"
          str:=doangle(str, curr)
        ELSE
          IF c="\\" THEN c:=doesc(str[]++)
          InvertKeyMap(c, curr, km)
        ENDIF
        IF c:=str[]++
          curr.nextevent:=NEW ie
          curr:=ie
        ENDIF
      UNTIL c=NIL
    ENDIF
  ENDIF
  RETURN events
EXCEPT
  freeIEvents(events)
  RETURN NIL
ENDPROC

EXPORT PROC invertString(str, km) HANDLE
  DEF events=NIL:PTR TO inputevent, c, prev:PTR TO inputevent
  IF cxbase=NIL THEN RETURN NIL
  IF str
    IF str[]
      WHILE c:=str[]++
        prev:=events
        NEW events
        events.nextevent:=prev
        IF c="<"
          str:=doangle(str, events)
        ELSE
          IF c="\\" THEN c:=doesc(str[]++)
          InvertKeyMap(c, events, km)
        ENDIF
      ENDWHILE
    ENDIF
  ENDIF
  RETURN events
EXCEPT
  freeIEvents(events)
  RETURN NIL
ENDPROC

PROC doesc(c)
  SELECT "u" OF c
  CASE "\q", "'", "<", "\\"
    RETURN c
  CASE "0"
    RETURN 0
  CASE "n", "r"
    RETURN "\b"
  CASE "t"
    RETURN "\t"
  DEFAULT
    Raise(ERR_ESC)
  ENDSELECT
ENDPROC

PROC doangle(str, events:PTR TO inputevent)
  DEF s, c, ix:inputxpression
  s:=str
  WHILE s[] AND (s[]<>">") DO s++
  IF c:=s[] THEN s[]:=NIL
  IF ParseIX(str, ix)<>0 THEN Raise(ERR_ANGLE)
  events.class:=ix.class
  events.code:=ix.code
  events.qualifier:=ix.qualifier
  s[]++:=c
ENDPROC s



