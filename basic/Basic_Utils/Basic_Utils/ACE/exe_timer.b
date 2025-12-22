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

{This program measures the execution time of a program in DateStamps (1/50
seconds). It takes the program name as the only argument.}
