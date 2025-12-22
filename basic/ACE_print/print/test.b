
' A test program for the print.h include functions.
' (C) 2014  Lorence Lombardo.


#include <ace/print.h>

LIBRARY "exec.library"

putsn("")

a$="is this gona work ?"

Dim sargs&(4)

sargs&(0)=20
sargs&(1)=-1
sargs&(2)=@a$
sargs&(3)=10

bla$=sprintf$( "test %ld %lx %s %lc", @sargs&(0) )

puts(bla$)

If SYSTEM>36 then
   sargs&(0)=-1
   sargs&(1)=10
   sargs&(2)=10
   bla$=sprintf$( "%lu %lc %lc", @sargs&(0))
   puts(bla$)
End If


putsn("test this text")

putsn(" h="+HStr$(11)+" d="+DStr$(16)+" c="+Byt$(65))

If SYSTEM>36 then
   putsn(" u="+UStr$(-1))
end if

putsn("")

LIBRARY CLOSE "exec.library"

