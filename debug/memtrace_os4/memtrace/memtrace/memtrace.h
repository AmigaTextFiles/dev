/*
 Include this file to a file, which memory (de)allocation should be traced.

- uses inline functions and macros for replacing "new", "new[]", "delete", "delete[]"
   -> makes them local, already compiled objects (libs) aren't affected (you may think, but's not the case, so a trick is used to hide non local (de)allocations)
- same with malloc(), calloc(), realloc(), free() for C code

note: "delete" is handled in another way
 - it can be overloaded, but the overloaded function can't be invoked like "new (...) <type>"
  -> no argument list is supported
 - "delete[]" cannot easily be replaced by preprocessor, because "[]" it is not handled as needed
  -> standart operator functions are replaced
*/


#define MEMTRACE_DEBUG   //comment out to deactivate memory tracing




#ifdef MEMTRACE_DEBUG

#ifndef _MEMTRACE_H_
#define _MEMTRACE_H_

#include "memtrace_internal.h"

#define MEMTRACE_VERSION "1.00a"

extern MemTrace memtrace;


//C++ allocation, deallcation
inline void *operator new (size_t size, char *file, int line)
{ return memtrace.memNew(OBJECT, size, file, line); }

inline void *operator new[] (size_t size, char *file, int line)
{ return memtrace.memNew(ARRAY, size, file, line); }

inline void operator delete (void *p)
{ memtrace.memDelete(OBJECT, p); }

inline void operator delete[] (void *p) 
{ memtrace.memDelete(ARRAY, p); }

//operator replacement
#define new  new(__FILE__, __LINE__)

//using a true "if()" expression we can call any functions of choice with
// keeping the right "{}" block structure for the following "delete" expression
#define delete if(memtrace.setLastPosition(__FILE__, __LINE__)) delete  



//C allocation, deallcation
inline void *malloc (size_t size, char *file, int line)
{ return memtrace.memNew(C_MALLOC, size, file, line); }


inline void *calloc (size_t num, size_t size, char *file, int line)
{
 void *p = memtrace.memNew(C_MALLOC, num * size, file, line);
 memset(p, 0, num * size);
 return p;
}


inline void *realloc (void *p, size_t size, char *file, int line)
{ return memtrace.memRealloc( p, size, file, line); }


inline void free (void *p, char *file, int line)
{
 memtrace.setLastPosition(file, line);
 memtrace.memDelete(C_MALLOC, p);
}


#define malloc(x)    malloc(x, __FILE__, __LINE__)
#define calloc(x,y)  calloc(x, y, __FILE__, __LINE__)
#define realloc(x,y) realloc(x, y, __FILE__, __LINE__)
#define free(x)      free(x, __FILE__, __LINE__)



#endif




#endif
