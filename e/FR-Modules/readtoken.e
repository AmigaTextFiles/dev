/* $VER: readtoken 1.1 (16.11.97) © Frédéric Rodrigues
   Read tokens from a string
   Carefull ! char 0 cannot be a separator

   1.0 (30.9.97)  - first
   1.1 (16.11.97) - tokens are separated by one only, or more separators
*/

OPT MODULE

OBJECT objreadtoken
  token
  pos
  separators
  nb
  oneonly
ENDOBJECT

EXPORT PROC readtokenfrom(string,separators=NIL,oneonly=FALSE)
  DEF objreadtoken:PTR TO objreadtoken
  NEW objreadtoken
  objreadtoken.pos:=string
  objreadtoken.separators:=IF separators THEN separators ELSE ' ,;:.!?()-''"«»\t'
  objreadtoken.nb:=0
  objreadtoken.oneonly:=oneonly
ENDPROC objreadtoken

EXPORT PROC readtoken(o)
  DEF s,obj:PTR TO objreadtoken
  obj:=o
  s:=obj.pos
  IF s[]=0
    obj.token:=''
    RETURN FALSE
  ELSE
    IF obj.oneonly=FALSE THEN WHILE charinstr(obj.separators,s[]) DO INC s
    IF s[]=0 THEN RETURN FALSE
    obj.token:=s
    WHILE charinstr(obj.separators,s[])=FALSE
      IF s[]=0
        obj.pos:=s
        RETURN TRUE
      ENDIF
      INC s
    ENDWHILE
    s[]++:=0
    obj.pos:=s
  ENDIF
ENDPROC TRUE

EXPORT PROC nbtoken(o)
-> I can call several times this without losting speed
  DEF s,obj:PTR TO objreadtoken,c=0
  obj:=o
  IF obj.nb=0
    s:=obj.pos
    LOOP
      IF obj.oneonly=FALSE THEN WHILE charinstr(obj.separators,s[]) DO INC s
      IF s[]=0
        obj.nb:=c
        RETURN obj.nb
      ENDIF
      WHILE charinstr(obj.separators,s[])=FALSE
        IF s[]++=0
          obj.nb:=c+1
          RETURN obj.nb
        ENDIF
      ENDWHILE
      INC c
    ENDLOOP
  ENDIF
ENDPROC obj.nb

EXPORT PROC endreadtoken(o:PTR TO objreadtoken)
  END o
ENDPROC

PROC charinstr(string,char)
  DEF str
  str:=string
  WHILE str[]
    IF str[]++=char THEN RETURN TRUE
  ENDWHILE
ENDPROC FALSE
