
'$INCLUDE BASU:_LoadPalette.bas
'$INCLUDE BASU:_BestCol.bas

SCREEN 1,320,256,8,1
WINDOW 1,"AlphaRGB Maker",,,1
CALL LoadPalette("EscapeLevels:BackGrounds/Various1.rgb32",1)

x=0
y=0

DIM TR%(255,16,16),TG%(255,16,16),TB%(255,16,16)	'color,alpha,r(gb)

' example: a white face with a yellow glass on. Must result a=0 yellow, a=7 white,a=15 white
'	   a black face with a yellow glass on. Must result a=0 black a=7 black a=15 yellow

'          a white face with a DARK RED glass on. Must result a=0 dark red a=7 white

' 0-7  AlphedRed = Min(LightRed * (a/8),ColorRed)	(lightcutting)
' 8-15 AlphedRed = ColorRed + (a-8)*(LightRed/7)	(ghostdrawing)

LOCATE 1,35:PRINT "RED"
FOR a=0 TO 15
 FOR r=0 TO 15
  x=0
  FOR c=0 TO 255 
   IF a<8 
    RC=(r*17)*a/8
    IF R%(c)<RC THEN RC=R%(c)
   ELSE
    RC=R%(c)+((a-8)*r*2.42)
    IF RC>255 THEN RC=255
   END IF      
   GC=G%(c)
   BC=B%(c)
   FC=BestCol(RC,GC,BC,6,2,1)
   PSET (x,y),FC
   TR%(c,a,r)=FC
   x=x+1
  NEXT c
 y=y+1
 NEXT r
NEXT a

LOCATE 1,35:PRINT "GREEN"
y=0
FOR a=0 TO 15
 FOR g=0 TO 15
  x=0
  FOR c=0 TO 255 
   IF a<8 
    GC=(g*17)*a/8
    IF G%(c)<GC THEN GC=G%(c)
   ELSE
    GC=G%(c)+((a-8)*g*2.42)
    IF GC>255 THEN GC=255
   END IF      
   RC=R%(c)
   BC=B%(c)
   FC=BestCol(RC,GC,BC,6,2,1)
   PSET (x,y),FC
   TG%(c,a,r)=FC
   x=x+1
  NEXT c
 y=y+1
 NEXT g
NEXT a

LOCATE 1,35:PRINT "BLUE"
y=0
FOR a=0 TO 15
 FOR b=0 TO 15
  x=0
  FOR c=0 TO 255 
   IF a<8 
    BC=(b*17)*a/8
    IF B%(c)<BC THEN BC=B%(c)
   ELSE
    BC=B%(c)+((a-8)*b*2.42)
    IF BC>255 THEN BC=255
   END IF      
   GC=G%(c)
   RC=R%(c)
   FC=BestCol(RC,GC,BC,6,2,1)
   PSET (x,y),FC
   TB%(c,a,r)=FC
   x=x+1
  NEXT c
 y=y+1
 NEXT b
NEXT a

OPEN "WildPJ:Trash/Various1.AlphaR" FOR OUTPUT AS 1
OPEN "WildPJ:Trash/Various1.AlphaG" FOR OUTPUT AS 2
OPEN "WildPJ:Trash/Various1.AlphaB" FOR OUTPUT AS 3
FOR a=0 TO 15
 FOR t=0 TO 15
  FOR c=0 TO 255
   PRINT #1,CHR$(TR%(c,a,t));
   PRINT #2,CHR$(TG%(c,a,t));
   PRINT #3,CHR$(TB%(c,a,t));
  NEXT c
 NEXT t
NEXT a
CLOSE 1
CLOSE 2
CLOSE 3

   
  
  
  