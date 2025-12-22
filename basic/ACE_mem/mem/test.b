

' A test of the mem.o extended memory functions.
' (C) 2014  Lorence Lombardo.


#include <SUBmods/mem.h>

a$=chr$(255)

print peek(@a$)
print speek(@a$)

a$=a$+a$

print peekw(@a$)
print upeekw(@a$)

a$="ABCD"
b$="1234"

bla& = fpeekl(@a$)
CopyMemB(@bla&, @b$, 4)
print b$


bla% = fpeekw(@a$)

CopyMemB(@bla%, @b$, 2)

print b$

print chr$(peek(@bla%)) + chr$(peek(@bla%+1))


c$="123456789012"

memset(@c$, asc("I"), Len(c$) )

PRINT c$

b$="123"
bla& = fpeek24(@a$)
CopyMemB(@bla&+1, @b$, 3)
print b$


bla$=Chr$(255)
bla$=bla$+bla$+bla$

print peek24(@bla$)
print upeek24(@bla$)

print upeek24(@c$)
poke24 (@c$, 16777215)
print upeek24(@c$)

Print c$
Print Chr$(255)
Print bla$

bla% = 40000         ' <- too much for signed bla%
Print bla%
bla%=fpeekw(@bla%)   ' <- here make it intel
Print ufpeekw(@bla%) ' <- here we retrieve it as a motorola unsigned word

bla&=9388607            ' <- that would be too much for a signed 24 bit
Print peek24(@bla&+1)   ' <- +1 coz we r in a 32 bit long
bla&=fpeek24(@bla&+1)   ' <- here make it intel
Print ufpeek24(@bla&+1) ' <- here we retrieve it as a motorola unsigned 24 bit

