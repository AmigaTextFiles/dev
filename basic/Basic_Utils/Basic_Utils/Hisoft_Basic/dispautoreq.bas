LIBRARY  "intuition.library"
DECLARE FUNCTION AutoRequest&(win&,body&,posi&,nega&,posflags&,negflags&,x00&,y00&) LIBRARY
LIBRARY OPEN "intuition.library"

DECLARE FUNCTION makeitext$(fpen&,bpen&,drawm&,kf0&,left&,top&,font&,textptr&,next&)
DECLARE FUNCTION autoreq!(t01$,t02$,t03$,p00$,n00$,posflags&,negflags&,y1&,y2&,y3&,x00&,y00&)
DECLARE FUNCTION dispautoreq!(txt1$,txt2$,txt3$,ja$,nein$)

REM *** Test *********************************************************

PRINT dispautoreq!("This is","a sample,","requester.","Okay","Cancel")

REM *******************************************************************

FUNCTION makeitext$(fpen&,bpen&,drawm&,kf0&,left&,top&,font&,textptr&,next&)
  tvc$=""
  tvc$=CHR$(fpen&)+CHR$(bpen&)+CHR$(drawm&)+CHR$(kf0&)
  tvc$=tvc$+MKI$(left&)+MKI$(top&)+MKL$(font&)+MKL$(textptr&)
  tvc$=tvc$+MKL$(next&)
  makeitext$=tvc$
  tvc$=""
END FUNCTION

FUNCTION autoreq!(t01$,t02$,t03$,p00$,n00$,posflags&,negflags&,y1&,y2&,y3&,x00&,y00&)
'Parameters: 3 Text lines, OKAY text, CANCEL text, IDCMP flags, y positions
'and window size (if OKAY = CANCEL, only one button will be rendered)

'Use the following y values:
'o  Three text lines: 0,10,20
'o  Two text lines: 0,10,10
'o  One text line: 0,0,0

'The Requester returns -1 (True) or 0 (False).
  body_$=t01$+CHR$(0)
  b02_$=t02$+CHR$(0)
  b03_$=t03$+CHR$(0)
  pos_$=p00$+CHR$(0)
  neg_$=n00$+CHR$(0)
  neg$=makeitext$(0,1,2,0,0,0,0,SADD(neg_$),0)
  nega&=SADD(neg$)
  IF ((p00$<>n00$) AND (p00$<>""))
    pos$=makeitext$(0,1,2,0,0,0,0,SADD(pos_$),0)
    posi&=SADD(pos$)
  ELSE
    posi&=0 'Render one gadget only
  END IF
  b03$=makeitext$(0,1,2,0,0,y3&,0,SADD(b03_$),0)
  b03&=SADD(b03$)
  b02$=makeitext$(0,1,2,0,0,y2&,0,SADD(b02_$),b03&)
  b02&=SADD(b02$)
  body$=makeitext$(0,1,2,0,0,y1&,0,SADD(body_$),b02&)
  body&=SADD(body$)
  response&=AutoRequest&(WINDOW(7),body&,posi&,nega&,posflags&,negflags&,x00&,y00&)
  autoreq=-response&
END FUNCTION

FUNCTION dispautoreq!(txt1$,txt2$,txt3$,ja$,nein$)
'Parameters: 3 Text lines, OKAY text, CANCEL text
'The Requester returns -1 (True) or 0 (False).
  dispautoreq=autoreq!(txt1$,txt2$,txt3$,ja$,nein$,0,0,0,10,20,200,50)
END FUNCTION
