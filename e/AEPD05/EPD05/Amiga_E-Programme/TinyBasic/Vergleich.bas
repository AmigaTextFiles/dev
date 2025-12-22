print "*** TinyBasic vergleicht ......***"
print "-> STOP <- mit -1!!!"

label1:

input "Erste zahl: ",a:input "Zweite Zahl",b
IF A<= B THEN PRINT "a<=b"
IF A<  B THEN PRINT "a<b "
IF A=  B THEN PRINT "a=b"
IF A>B THEN PRINT "a>b"
IF A>=B THEN PRINT "a>=b"
IF A<>B THEN PRINT "a<>b"
if a=-1 then stop

goto label1
