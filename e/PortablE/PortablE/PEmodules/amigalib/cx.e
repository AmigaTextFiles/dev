OPT MODULE

OPT PREPROCESS

MODULE 'commodities',
       'icon',
       'devices/inputevent',
       'libraries/commodities'
MODULE 'devices/keymap', 'exec/ports'

PROC userFilter(tt:ARRAY OF ARRAY OF CHAR, action_name:ARRAY OF CHAR, default_descr)
  DEF desc
  desc := NIL
  IF (iconbase=NIL) OR (cxbase=NIL) THEN RETURN NIL
  IF tt THEN desc:=FindToolType(tt, action_name)
ENDPROC CxFilter(IF desc THEN desc ELSE default_descr)

PROC hotKey(description:ARRAY OF CHAR, port:PTR TO mp, id)
  DEF filter:PTR TO CXOBJ
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

PROC freeIEvents(events:PTR TO inputevent)
  DEF next:PTR TO inputevent
  WHILE events
    next:=events.nextevent
    END events
    events:=next
  ENDWHILE
ENDPROC

ENUM ERR_NONE, ERR_ESC, ERR_ANGLE

PROC invertStringRev(str:ARRAY OF CHAR, km:PTR TO keymap)
  DEF events:PTR TO inputevent, c:CHAR, curr:PTR TO inputevent, ie:PTR TO inputevent
  DEF i
  i := 0
  IF cxbase=NIL THEN RETURN NIL
  IF str
    IF str[i]
      curr:=(events:=NEW ie)
      c:=str[i++]
      REPEAT
        IF c="<"
          str:=doangle(str, curr)
          i:=0
        ELSE
          IF c="\\" THEN c:=doesc(str[i++])
          InvertKeyMap(c, curr, km)
        ENDIF
        IF c:=str[i++]
          curr.nextevent:=NEW ie
          curr:=ie
        ENDIF
      UNTIL c=NIL
    ENDIF
  ENDIF
  RETURN events
FINALLY
  IF exception
    freeIEvents(events)
    events := NIL
  ENDIF
ENDPROC events

PROC invertString(str:ARRAY OF CHAR, km:PTR TO keymap)
  DEF events:PTR TO inputevent, c:CHAR, prev:PTR TO inputevent
  DEF i
  i := 0
  IF cxbase=NIL THEN RETURN NIL
  IF str
    IF str[i]
      WHILE c:=str[i++]
        prev:=events
        NEW events
        events.nextevent:=prev
        IF c="<"
          str:=doangle(str, events)
          i := 0
        ELSE
          IF c="\\" THEN c:=doesc(str[i++])
          InvertKeyMap(c, events, km)
        ENDIF
      ENDWHILE
    ENDIF
  ENDIF
  RETURN events
FINALLY
  IF exception
    freeIEvents(events)
    events := NIL
  ENDIF
ENDPROC events

PRIVATE
PROC doesc(c:CHAR)
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
ENDPROC c

PROC doangle(str:ARRAY OF CHAR, events:PTR TO inputevent)
  DEF s:ARRAY OF CHAR, c:CHAR, ix:inputxpression
  DEF i
  i := 0
  s:=str
  WHILE s[i] AND (s[i]<>">") DO i++
  IF c:=s[i] THEN s[i]:=0
  IF ParseIX(str, ix)<>0 THEN Raise(ERR_ANGLE)
  events.class:=ix.class
  events.code:=ix.code
  events.qualifier:=ix.qualifier
  s[i]:=c
  i++
ENDPROC s
PUBLIC
