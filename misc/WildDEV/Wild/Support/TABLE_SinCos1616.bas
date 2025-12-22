
WINDOW 1,"SinCos1616.table maker..."
PRINT "1024 angles stored in this table. Offsets: 0=sin 16.16 4=con 16.16"

OPEN "Ram:SinCos1616.table" FOR OUTPUT AS 1
FOR i=0 TO 1023
 a=3.1415926*i/512
 PRINT #1,MKL$(SIN(a)*65536);MKL$(COS(a)*65536);
NEXT i
CLOSE 1