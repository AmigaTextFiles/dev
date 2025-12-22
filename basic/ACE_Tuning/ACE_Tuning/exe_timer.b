{EXE_timer.b
 ===========

 Version:  1.00
 Revision: 16 Sep 1996
 Author:   Frank Reibold

This utility calculates the execution time of a program using "ticks".

*** Declare used library functions and variables ***
}
DECLARE FUNCTION DateStamp LIBRARY "dos.library"

DIM v&(2)

{*** Get current time ***}

DateStamp(VARPTR(v&))
t1& = PEEKL(VARPTR(v&)+8)

{*** Execute program ***}

SYSTEM ARG$(1)

{*** Get current time ***}

DateStamp(VARPTR(v&))
t2& = PEEKL(VARPTR(v&)+8)

{*** Calculate and display elapsed time ***}

t3& = t2& - t1&

PRINT t3&;" Ticks."

{*** Cleanup ***}

LIBRARY CLOSE
END
