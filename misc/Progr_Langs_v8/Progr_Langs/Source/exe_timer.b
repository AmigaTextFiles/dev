REM *** ACE version - obsolete ***
DECLARE FUNCTION DateStamp LIBRARY "dos.library"
DIM v&(2)
DateStamp(varptr(v&))
t1&=peekl(varptr(v&)+8)
SYSTEM arg$(1)
DateStamp(varptr(v&))
t2&=peekl(varptr(v&)+8)
t3&=t2&-t1&
print t3&;" Datestamps."
LIBRARY CLOSE

