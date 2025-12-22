OPEN "ram:sinuslist.s" FOR OUTPUT AS 1
CLS
PRINT "SINUS GENERATOR   by   COOL-G"
PRINT
PRINT "CREATES A SOURCE CONTAINING DC.B LINES (SEKA) WITH SINUS VALUES"
PRINT
min=1000:max=999
PRINT  "ENTER BYTE VALUES: (between 0 and 255)"
WHILE min>max
  LOCATE 7
  WHILE min>255 OR min<0
    INPUT "minimum value for sinus :";min
  WEND
  WHILE max >255 OR max <0
    INPUT "maximum value for sinus :";max
  WEND
WEND

a=(max-min)/2
b=(max-min)/2+min
CLS

PRINT#1,"sinuslist:         ; generated with sinusgen by Cool-G"

FOR t=0 TO (2*3.141592654#)+.1 STEP .01
  LOCATE 1
  v=INT((SIN(t)*a)+b)
  PRINT USING" ### ";v
  p=p+1
  IF p=1 THEN 
    a$="dc.b "+RIGHT$("  "+STR$(v),3)+","
  ELSE
    IF p=10 THEN 
      p=0:a$=RIGHT$("   "+STR$(v),3)
    ELSE
      a$=RIGHT$("  "+STR$(v),3)+","
    END IF
  END IF
  n$=n$+a$
 IF p=0 THEN PRINT #1,n$:n$=""  
NEXT
PRINT #1,"endsinuslist:"
CLOSE 1
CLS
PRINT "THE SOURCE IS SAVED !!"
PRINT "RAM:SINUSLIST.S"
PRINT :PRINT "THANK YOU FOR USING THIS TOOL"

