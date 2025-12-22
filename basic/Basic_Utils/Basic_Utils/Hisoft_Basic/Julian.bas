DECLARE FUNCTION julday(caldate$)
DECLARE FUNCTION calday$(dj!) 

REM *** Test functions ***
ax = julday(DATE$)
PRINT ax
PRINT calday$(ax + 10)
END  

REM **********************
  
FUNCTION julday(caldate$) 
'Date = "DD.MM.YYYY"
'This function calculates the Julian date (a serial number)
	 DEFSNG m1,y1,a,b,c,d,dj
	 dy=VAL(MID$(caldate$,1,2))
	 mn=VAL(MID$(caldate$,4,2))
	 yr=VAL(RIGHT$(caldate$,4))
	 IF yr = 0 THEN 
	   dj=-1  '*** ERROR ***
	 ELSE 
	   m1=mn : y1=yr : b=0 
	   IF y1 < 1 THEN INCR y1 
	   IF mn < 3 THEN m1=mn+12 : DECR y1 
	   IF y1 > 1582 OR mn > 10 OR dy >= 15 THEN  
	     a=INT(y1/100) : b=2-a+INT(a/4) 
	     c=INT(365.25*y1)-694025 
	     IF y1 < 0 THEN c=FIX((365.25*y1)-0.75)-694025 
	     d=INT(30.6001*(m1+1))
	     dj=b+c+d+dy-0.5 
	   ELSE 
	     IF (y1<1582 OR (y1=1582 AND mn<10) OR (y1=1582 AND mn=10 AND dy<5)) THEN
	       c=INT(365.25*y1)-694025 
	       IF y1 < 0 THEN c=FIX((365.25*y1)-0.75)-694025 
	       d=INT(30.6001*(m1+1)): dj=b+c+d+dy-0.5 
	     ELSE 
	       dj=-1  '*** ERROR ***
	     END IF
	   END IF 
	 END IF
	 julday = dj  '*** ERROR *** := -1
END FUNCTION
 
FUNCTION calday$(dj!) 
'Converts a Julian date to "DD.MM.YYYY"
	 DEFSNG a,b,c,d,g,i,fd
	 d=dj!+0.5 : i=INT(d) : fd=d-i 
	 IF fd = 1 THEN fd=0 : INCR i
	 IF i > -115860 THEN 
	   a=INT((i/36524.25)+9.9835726e-1)+14 
	   i=i+1+a-INT(a/4) 
	 END IF 
	 b=INT((i/365.25)+8.02601e-1) 
	 c=i-INT((365.25*b)+7.50001e-1)+416 
	 g=INT(c/30.6001) : mn=g-1 
	 dy=c-INT(30.6001*g)+fd : yr=b+1899 
	 IF g > 13.5 THEN mn=g-13 
	 IF mn < 2.5 THEN yr=b+1900 
	 IF yr < 1 THEN DECR yr 
	 dy$=STR$(INT(dy)) : IF dy < 10 THEN dy$="0"+RIGHT$(dy$,1)
	 dy$=RIGHT$(dy$,2)
	 mn$=STR$(INT(mn)) : IF mn < 10 THEN mn$="0"+RIGHT$(mn$,1)
	 mn$=RIGHT$(mn$,2)
	 yr$=STR$(INT(yr))
	 yr$=RIGHT$(yr$,4)
	 calday$ = dy$+"."+mn$+"."+yr$
END FUNCTION 

