'$include basu:_command.bas
'$include basu:_cut.bas
'$include basu:_filereq.bas
'$include basu:_loadpalette.bas

' That makes a table of palettes, from the darkest to the brightest.
' There are 64 shades from 0 to 255 intensity, wich are calced looking
' for the color with the luminosity. So, the last palette is the real
' palette, NOT a brighter palette.
' Then, for specialfx, I add 64 more shades, and those colors are
' calced with the normal color added at $iiiiii. The max $ii is 255.
' That's good to draw transparent objects (not coloured, with this...)

'''pal$=FileReq$("WildPJ:Libs/Wild/Draw","Select a RGB32 palette","#?.rgb32")
pal$="EscapeLevels:BackGrounds/Various1.rgb32"

FUNCTION BestCol(RF%,GF%,BF%,ER%,EG%,EB%)
 SHARED R%(),G%(),B%()
 LOCAL p%,BER&,CER&,CEG&,CEB&,BC%,CE&
 BER&=2^20
 FOR p%=0 TO 255
  CER&=ABS(R%(p%)-RF%)*ER%
  CEG&=ABS(G%(p%)-GF%)*EG%
  CEB&=ABS(B%(p%)-BF%)*EB%
  CE&=CER&+CEG&+CEB&
  IF CE&<BER& THEN BER&=CE&:BC%=p%
 NEXT p%
 BestCol=BC%
END FUNCTION

DIM Table(127,255)	'pal,col
IF pal$<>""
 SCREEN 1,640,256,8,5
 WINDOW 1,"Palette Shades Creator",,,1
 CALL LoadPalette(pal$,1)
 CLS
 sx=WINDOW(2)/15
 sy=WINDOW(3)/15

 FOR i=63 TO 0 STEP -1
  FOR c=0 TO 255 
   RTF=R%(c)+(i+1)*4
   GTF=G%(c)+(i+1)*4
   BTF=B%(c)+(i+1)*4
   IF RTF>255 THEN RTF=255
   IF GTF>255 THEN GTF=255
   IF BTF>255 THEN BTF=255
   
   BC%=BestCol(RTF,GTF,BTF,1,1,1)
   
   PSET (c,i+64),BC%
   Table(i+64,c)=BC%
  NEXT c
 NEXT i

 FOR i=63 TO 0 STEP -1
  FOR c=0 TO 255
   RTF=R%(c)*(i+1)/64
   GTF=G%(c)*(i+1)/64
   BTF=B%(c)*(i+1)/64
   
   BC%=BestCol(RTF,GTF,BTF,1,1,1)
   
   PSET (c,i),BC%
   Table(i,c)=BC%
  NEXT c
 NEXT i
 
 OPEN "RAM:Palette.preka" FOR OUTPUT AS 1
  FOR i=0 TO 127
   FOR c=0 TO 255
    PRINT #1,CHR$(Table(i,c));
   NEXT c
  NEXT i
 CLOSE 1
END IF



