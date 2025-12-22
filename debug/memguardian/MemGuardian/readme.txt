MemGuardian 0.1 - a simple debug-time memory tracker for C/C++ programs
-----------------------------------------------------------------------

MemGuardian's purpose is to help tracking memory allocation and deallocation. It tries to catch
possible memory leaks, deallocations that happen more than once, attempts to free non-allocated
memory and attempts to use wrong deallocation method with allocated memory.

The concept can be easily extended to "any" resource, it's only a matter of writing more wrapper functions.

Currently it supports memory tracking via functions:

 - MG_malloc (malloc), MG_free (free), MG_AllocVec (IExec->AllocVec), MG_FreeVec (IExec->FreeVec)

And via overloaded C++ operators:

 - new, new [], delete, delete []

MemGuardian is Public Domain.


Usage:
-----

Include "MemGuardian.h" where needed, add MemGuardian.c to your project and add -DDEBUG=1 to
compiling flags. When DEBUG isn't defined, wrapper functions are not activated and C++
operators are not overloaded.

To start the tracking, call MG_Init(). To finish the tracking, call MG_Exit();

Currently tracking output is only dumped to shell. After calling MG_Exit(), possible memory
leaks are reported and cleaned up.


Example of running "test":
--------------------------

2.Code:MemGuardian> avail flush
Type      Available     In-Use    Maximum    Largest
chip(*)    35875696   29791344   65667040   34588744
fast       35875696   29791344   65667040   34588744
virtual   130678784   65011712  195690496  130678784
total     166554480   94803056  261357536  130678784
(*) Chip RAM is emulated
2.Code:MemGuardian> test
[Mem Guardian] Init
Malloc() called in file test.c (line 12)
free() called in file test.c (line 15)
Warning: possible attempt to free() already free()'d object in file test.c (line 18). Memory was earlier free()'d in file test.c (line 15)
Warning: couldn't find memory allocation to free() (0x13317448) in file test.c (line 18)
Warning: couldn't find memory allocation to free() (0x0) in file test.c (line 21)
Operator new called in file test.c (line 28)
Warning: possible attempt to delete already deleted object in file test.c (line 31). Memory was earlier deleted in file test.c (line 15)
Operator delete called in file test.c (line 31)
Operator new [] called in file test.c (line 34)
Warning: possible attempt to delete [] already deleted object in file test.c (line 37). Memory was earlier deleted [] in file test.c (line 15)
Warning: possible attempt to delete [] already deleted object in file test.c (line 37). Memory was earlier deleted [] in file test.c (line 31)
Operator delete [] called in file test.c (line 37)
Warning: couldn't find memory allocation to delete (0x666) in file test.c (line 40)
AllocVec() called in file test.c (line 45)
FreeVec() called in file test.c (line 47)
Malloc() called in file test.c (line 50)
[Mem Guardian] Exit
Warning: non-free'd allocation exists: allocated in test.c (50)
2.Code:MemGuardian> avail flush
Type      Available     In-Use    Maximum    Largest
chip(*)    35875696   29791344   65667040   34588744
fast       35875696   29791344   65667040   34588744
virtual   130678784   65011712  195690496  130678784
total     166554480   94803056  261357536  130678784


Some comments...It's easy to get those "Warning: possible attempt to..." because sometimes when freeing memory,
and making a new allocation, system might reserve you the same memory address. At the moment, information about
old allocations is available even after they are free'd so that may confuse MemGuardian, unfortunately.

Just before "Exit" line, malloc() is called and it "leaks", but is cleaned up and the leakage is reported to happen.


Feedback & bug reports may be sent to address: jniemima@mail.student.oulu.fi

