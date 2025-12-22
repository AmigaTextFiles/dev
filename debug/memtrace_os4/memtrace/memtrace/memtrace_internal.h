/*
The MemTrace class is only for debugging purposes.

- slows down memory allocation and deletion, should be excluded/deactivated for final compilation
- uses a linked list within a static buffer, number of logable objects is limited
- a static buffer prevents the methods from using "new"/"delete" itself
- logs all actions with the standart "new"/"delete" operators

The class instance must be unlocked first in order to work.
*/


#ifndef _MEMTRACE_INTERNAL_H_
#define _MEMTRACE_INTERNAL_H_

#include <cstdlib>
#include <iostream>

using namespace std;


/*** Configuration ************************************************************/

#define MEMTRACE_PRINT_OUT  cout  //print text to stream for log information
#define MEMTRACE_PRINT_ERR  cout  //print text to stream for error messages


#define MEMTRACE_LOGALL           //uncomment and no normal actions will be logged, excluding errors

#ifdef MEMTRACE_LOGALL
 #define MEMTRACE_PRINT_OUTLOG(x)   MEMTRACE_PRINT_OUT << x   //print non error log messages
#else 
 #define MEMTRACE_PRINT_OUTLOG(x)   ;                         //replace makro with nothing
#endif

#define MEMTRACE_PRINT_ERRLOG(x)   {MEMTRACE_PRINT_ERR << x; MEMTRACE_PRINT_ERR.flush();}  //print error messages


#define MEMTRACE_STARTLOCKED          //The instance must be unlocked first before it logs any actions, unlocked from the beginning if undefined 

#define MEMTRACE_DUMPATEXIT           //prints contents of lists on program exit if defined

//#define MEMTRACE_FORCE_DELETION     //delete memory where the pointer points to, although list error occured
#define MEMTRACE_FORCE_ALLOCATION     //allocate although list error occures (full list)

#define MEMTRACE_HIDE_UNKNOWN_DELETE  //"delete" invoked from unknown locations (compiled objects) are done without log, are logged if undefined

#define MEMTRACE_EXIT  {MEMTRACE_PRINT_OUT.flush(); MEMTRACE_PRINT_ERR.flush(); exit(1)}  //programm exit with flushed stream buffers


#define MEMTRACE_MAX_OBJETCS  10000   //max list capacity for objects (max. number of entries)
#define MEMTRACE_MAX_ARRAYS   10000   //max list capacity for arrays

//*** Config end





//different list types
enum MEMTRACE_TYPE {
 OBJECT,     //C++ instance
 ARRAY,      //C++ array of instances
 C_MALLOC    //C memory block
};






struct MemTraceEntry
{
 MemTraceEntry *next;  //points to next entry in the list
 unsigned int n;       //chronological number
 void  *adr;           //address of first byte of memory block
 size_t size;          //memory block size in bytes
 char  *fname;         //file name where this was allocated
 int    line;          //line of allocation
};

struct MemTraceStat    //holds all attributes of an allocation type
{
 unsigned int n;       //chronological number of the next block, starting with 0
 unsigned int num;     //number of active block allocated with "new" (number of list entries), 0 if list is empty
 bool numoverflow;     //set if list is too small to hold all entries
 MemTraceEntry *head;  //list start 
 MemTraceEntry *tail;  //last list entry (to add easily at the end)
};




class MemTrace
{
 public:
   bool locked;      //lock state

 protected:
   char *del_file;   //file name where "delete" is invoked
   int   del_line;   //line where "delete" is called from

   MemTraceStat o;   //object list attributes
   MemTraceStat a;   //array list attributes
   MemTraceStat m;   //"malloc" list attributes

   MemTraceEntry olist[MEMTRACE_MAX_OBJETCS];  //objects list
   MemTraceEntry alist[MEMTRACE_MAX_ARRAYS];   //array list
   MemTraceEntry mlist[MEMTRACE_MAX_ARRAYS];   //"C malloc" list

 //not for the user, called via inline funtions and macros
 public:
    MemTrace();
   ~MemTrace();
   
   bool setLastPosition(char *file, int line);           //used by a makro, returns always true, sets member variables for the next (de)allocation
   bool add(MEMTRACE_TYPE type, void *adr, size_t size, char* file, int line); //add entry to specific list
   bool del(MEMTRACE_TYPE type, void *adr);              //delete entry from list
   bool delall(MEMTRACE_TYPE type);                      //clears content of a complete list (all attributes are resetted) 

   void *memNew(MEMTRACE_TYPE type, size_t size, char *file, int line);   //allocate mem for object
   void  memDelete(MEMTRACE_TYPE type, void *adr);                 //deallocate object
   void *memRealloc(void *p, size_t size, char *file, int line);   //invokes "realloc", implies allocation type C_MALLOC only

 //only the following methods should be used by the user
 public:
   void printList(MEMTRACE_TYPE type);         //prints list using "MEMTRACE_PRINT_LOG" (there are serveral lists)
   bool checkOverflow(MEMTRACE_TYPE type);     //returns overflow flag state
   bool checkAllocation(void *p, size_t size); //returns "true" if the byte range is within an allocated block registered in a list, else "false" -> useful to check for illegal memory access
   void clear(MEMTRACE_TYPE type);             //clear errors (overflow flag)
   void lock();                                //locks list operations, (de)allocations are still operational
   void unlock();                              //unlocks list operations, enables logging
   
};


#endif
