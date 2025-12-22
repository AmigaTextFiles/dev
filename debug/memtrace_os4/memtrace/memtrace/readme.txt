Author:  Markus Wolf
Web:     http://www.murkymind.de
Version: 1.0 (20-nov-2006)

The "memtrace" include files provides overview over dynamic memory allocation and deallocation for C/C++ code.
A C++ compiler is required. It is intended for debugging and should be excluded (deactivated) for final project compilation.

Files:
"memtrace.h"            : The only file to include into a project (include file tree)
"memtrace_internal.h"   : "MemTrace" class definition, "MemTrace" configuration via preprocessor directives, method descriptions
"memtrace_internal.cpp" : "MemTrace" methods, must be compiled as separat object so a single global ("extern") instance can be used for a whole project



How to use:
-----------
- Edit the preprocessor configuration in "memtrace_internal.h" to your needs.
- Compile "memtrace_internal.cpp" as separate object. It includes the one and only instance "memtrace" of class "MemTrace".
- Include "memtrace.h" in the project where allocation should be watched in the following code. You don't have to change any code in your project.
  "memtrace.h" defines an external reference to the "memtrace" instance.
- Link the "memtrace_internal.cpp" compiled object to your project when compiling.


What it does:
----------------
- Watching your (de)allocations with file name and line of the appropriate statement in your code, finding memory leaks.
- The "memtrace" instance has tables. Each allocation in your project creates a table entry.
  Which table is used, depends on the way of allocation: "new", "new[]", "malloc"
- Each deallocation tries to delete the entry from the appropriate list, which may be successful or not.
- Actions and errors can be logged to a stream of choice.
- prints and logs the location of the (de)allocation action (file, line)
- If entries are left in the table at program end, these are potential memory leaks, which means one of the following:
   * memory block is not deallocated
   * illegal deallocations were used for the allocation type ("free"/"delete"/"delete[]" mixing)
   * "memtrace" was locked during (de)allocation and was unable to trace -> not a memory leak
- can check if a byte range (with address) is within allocated space registered in a list (via separate function call).


Note:
-----
- In order to start tracing memory (de)allocation, the "memtrace" instance must be "unlocked"!
- Read the *.h files.