
WINDOW 1,"H2G"
HTMLIN$="hd1:h.html"

'$include basu:_findchar.bas
GUIDEOUT$="ram:a.guide"

OPEN HTMLIN$ FOR INPUT AS 1

REPEAT reading
 IF EOF(1) THEN EXIT reading
 LINE INPUT #1,a$
 CM=FindChar(a$,"<")
 IF CM
  IF UCASE$(MID$(a$,CM,4))="<BR>"
   SimpleText(MID$(a$,CM,4));
  END IF 
 END IF
END REPEAT reading
CLOSE 1