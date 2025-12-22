
' A test program for the "string.o" functions.
' (C) 2014  Lorence Lombardo.


#include <SUBmods/string.h>


a$="    ABCDEFGHIJKLMONP"

print a$

print StripLead$(a$,32)


a$="AAAAAAAAAAAAAAAABBBBBBBBBB"

print a$

print StripTrail$(a$,asc("B"))

a$="title fork title fork title fork title fork title fork title fork"

print a$

print Replace$(a$, "title", "count")

print Replace$(a$, "fork", "")

print Replace$(a$, "fork", "X")

a$="123456"

b$=LSet$(a$, 10)+"x"
print b$
print Len(b$)

print LSet$(a$, 4)

print RSet$(a$, 4)
print RSet$(a$, 10)

print Center$(a$, 4)
print Center$(a$, 10)+"x"
print Center$(a$, 6)+"x"

print Lrem$(a$, 4)
print Rrem$(a$, 4)

print str$(9)
print nstr$(9)

a$="title fork title fork title fork title fork title fork title fork"

print   instr(a$,"FoRk")
print instrNC(a$,"FoRk",1)

print Replace$(a$, "FoRk", "XxXx")
print  srepNC$(a$, "FoRk", "XxXx")

print flip$(a$)


' See "#include <ace/strings.h>" for an LCASE$()

