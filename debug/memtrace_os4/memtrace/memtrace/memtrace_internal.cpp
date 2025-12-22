#include "memtrace_internal.h"


MemTrace memtrace;      //global instance of the "MemTrace" class

//******************************************************************************
bool MemTrace::checkAllocation(void *p, size_t size)
{
 MemTraceStat *type[3] = {&this->o, &this->a, &this->m};  //different lists
 MemTraceEntry *ptr;

 //check all lists 
 for(int i = 0; i < 3; i++)
 {
   ptr = type[i]->head;
   while(ptr != NULL)
   {
     if((p >= ptr->adr) && (((char*)p + size) <= ((char*)ptr->adr + ptr->size)))
       return true;
     ptr = ptr->next;
   }
 }
 return false;
}
   
   
//******************************************************************************
bool MemTrace::setLastPosition(char *file, int line)
{
 del_file = file;
 del_line = line;
 return true;
}


//******************************************************************************
void *MemTrace::memNew(MEMTRACE_TYPE type, size_t size, char *file, int line)
{
 void *p = malloc(size);    // allocate     

 if(locked)
   return p;

#ifdef MEMTRACE_LOGALL
 switch(type) {
   case OBJECT:   MEMTRACE_PRINT_OUTLOG ("MemTrace: allocate object: "); break;
   case ARRAY:    MEMTRACE_PRINT_OUTLOG ("MemTrace: allocate array: ");  break;
   case C_MALLOC: MEMTRACE_PRINT_OUTLOG ("MemTrace: allocate block (\"malloc\"): "); break;
 } 
 MEMTRACE_PRINT_OUTLOG ( size << " bytes, " );

 if(file == NULL)
   MEMTRACE_PRINT_OUTLOG ( ", unknown location");
 else
   MEMTRACE_PRINT_OUTLOG ( "\"" << file << "\": " << line);
 
 MEMTRACE_PRINT_OUTLOG( " -> " << p << endl; );
#endif

 if(add(type, p, size, file, line) == false) {   //add entry to list
   #ifdef MEMTRACE_FORCE_ALLOCATION
     MEMTRACE_PRINT_ERRLOG ( " trying to allocate memory anyway" << endl );
   #else
     MEMTRACE_PRINT_ERRLOG ( " allocation refused" << endl );
     free(p);
     return NULL;
   #endif
 }
 
 return p;
}


//******************************************************************************
void MemTrace::memDelete(MEMTRACE_TYPE type, void *p)
{
 if(locked) {
   free(p);
   return;
 }

#ifdef MEMTRACE_HIDE_UNKNOWN_DELETE
 if(del_file == NULL)  //delete without logging, no list operations (identified by "del_file" beeing NULL)
 {
   free(p);
   return;
 }
#endif

#ifdef MEMTRACE_LOGALL
 switch(type) {
   case OBJECT:   MEMTRACE_PRINT_OUTLOG ("MemTrace: delete object: "); break;
   case ARRAY:    MEMTRACE_PRINT_OUTLOG ("MemTrace: delete array: ");  break;
   case C_MALLOC: MEMTRACE_PRINT_OUTLOG ("MemTrace: free block (\"malloc\"): "); break;
 } 
 MEMTRACE_PRINT_OUTLOG ( p );

 if(del_file == NULL)  //this should never happen, but you never know
   MEMTRACE_PRINT_OUTLOG ( ", unknown location" << endl );
 else
   MEMTRACE_PRINT_OUTLOG ( ", \"" << del_file << "\": " << del_line << endl );
#endif
 
 //reset file value, in case it's not set at the next call
 del_file = NULL;

 if(del(type, p) == false) {   //delete entry from list
   #ifdef MEMTRACE_FORCE_DELETION
     MEMTRACE_PRINT_ERRLOG ( " trying to free allocated memory anyway" << endl );
   #else
     MEMTRACE_PRINT_ERRLOG ( " deletion refused" << endl );
     return;
   #endif
 }

 free(p);
}

//******************************************************************************
//only for type  "C_MALLOC"
void *MemTrace::memRealloc(void *p, size_t size, char *file, int line)
{
 void *oldp = p;
 p = realloc(p, size);
     
 if(locked)
   return p;

#ifdef MEMTRACE_LOGALL
 MEMTRACE_PRINT_OUTLOG ("MemTrace: reallocate block (\"malloc\"): old pointer: " << oldp << ", new size: " << size << " bytes, " );
 if(file == NULL)
   MEMTRACE_PRINT_OUTLOG ( ", unknown location" );
 else
   MEMTRACE_PRINT_OUTLOG ( "\"" << file << "\": " << line );
   
 MEMTRACE_PRINT_OUTLOG( " -> " << p << endl; );
#endif
 
 //delete from list
 if(del(C_MALLOC, p) == false) {
   #ifdef MEMTRACE_FORCE_DELETION
     MEMTRACE_PRINT_ERRLOG ( " reallocate anyway" << endl );
   #else
     MEMTRACE_PRINT_ERRLOG ( " reallocation refused, memory block lost" << endl );
     free(p);
     return NULL;
   #endif
 }

 if(add(C_MALLOC, p, size, file, line) ==false) {  //add entry to list
   #ifdef MEMTRACE_FORCE_ALLOCATION
     MEMTRACE_PRINT_ERRLOG ( " reallocate memory anyway" << endl );
   #else
     MEMTRACE_PRINT_ERRLOG ( " allocation refused" << endl );
     free(p);
     return NULL;   
   #endif
 }

 return p;
}

//******************************************************************************
MemTrace::~MemTrace()
{
#ifdef MEMTRACE_DUMPATEXIT
 printList(OBJECT);
 printList(ARRAY);
 printList(C_MALLOC);
#endif
}



//******************************************************************************
void MemTrace::lock()
{
 locked = true;
}



//******************************************************************************
void MemTrace::unlock()
{
 locked = false;
}


//******************************************************************************
bool MemTrace::add(MEMTRACE_TYPE type, void *adr, size_t size, char* file, int line)
{
 MemTraceStat  *stat;
 MemTraceEntry *list;
 unsigned int max;

 if(adr == NULL) {
   MEMTRACE_PRINT_ERRLOG ( " MemTrace::del: Can't delete NULL pointer" << endl );
   return false;
 }

 switch(type)
 {
  case OBJECT:   stat = &o; list = olist; max = MEMTRACE_MAX_OBJETCS; break;
  case ARRAY:    stat = &a; list = alist; max = MEMTRACE_MAX_ARRAYS;  break;
  case C_MALLOC: stat = &m; list = mlist; max = MEMTRACE_MAX_ARRAYS;  break;
  default: return false; break;
 }


 //if list is empty
 if(stat->head == NULL){ 
   stat->head = list;
   stat->tail = list;
 }
 else
 {
   //if list is full
   if(stat->num >= max) {   
     stat->numoverflow == true;
     MEMTRACE_PRINT_ERRLOG ( " MemTrace::add: Warning, cannot add entry to list, list is full, capacity too small" << endl );
     return false;
   }
   

   //search for free entry space, there must be at least one
   for(int i = 0; i < max; i++)
     if(list[i].adr == NULL) {
       list = &(list[i]);
       break;
     }
  
   //add entry at the tail
   stat->tail->next = list; //set "next" pointer of prelast entry
   stat->tail = list;       //set new "tail"
 }
 
 //set entry attributes, update "stat"
 list->next = NULL;
 list->fname = file;
 list->line = line;
 list->adr = adr;
 list->size = size;
 list->n = stat->n; 
 stat->num++;
 stat->n++;
 
 return true;
}



//******************************************************************************
bool MemTrace::del(MEMTRACE_TYPE type, void *adr)
{
 MemTraceStat  *stat;
 MemTraceEntry *list;

 if(adr == NULL) {
   MEMTRACE_PRINT_ERRLOG ( " MemTrace::del: Warning, can't delete NULL pointer" << endl );
   return false;
 }

 switch(type)
 {
  case OBJECT:   stat = &o; break;
  case ARRAY:    stat = &a; break;
  case C_MALLOC: stat = &m; break;
  default: return false; break;
 }

 list = stat->head;

 if(list == NULL) {
  MEMTRACE_PRINT_ERRLOG ( " MemTrace::del: Error, address " << adr << " not found in the list, list is empty" << endl );
  return false; 
 }

 //if "head" is the entry
 if(list->adr == adr)
 {
   if(stat->tail == list)  //if head is tail (only single element in list)
     stat->tail = list->next;
   list->adr = NULL;
   stat->head = list->next;
   goto success;
 }
 
 //if head is not the entry
 while(list->next != NULL)
 {
  if(list->next->adr == adr) {   //if address found
    if(stat->tail == list->next) //if entry is tail
      stat->tail = list;
    list->next->adr = NULL;      //mark free slot with NULL
    list->next = list->next->next;
    goto success;
  }
  list = list->next;
 }
 
 //if not found
 MEMTRACE_PRINT_ERRLOG ( " MemTrace::del: Error, address " << adr << " not found in the list" << endl );
 return false; 


 //if success occures
 success:
   stat->num--;
   return true;
}




//******************************************************************************
bool MemTrace::delall(MEMTRACE_TYPE type)
{
 MemTraceStat  *stat;
 MemTraceEntry *list;
 unsigned int max;
 
 switch(type) {
  case OBJECT:   stat = &o; list = olist; max = MEMTRACE_MAX_OBJETCS; break;
  case ARRAY:    stat = &a; list = alist; max = MEMTRACE_MAX_ARRAYS;  break;
  case C_MALLOC: stat = &m; list = mlist; max = MEMTRACE_MAX_ARRAYS;  break;
  default:
    return false; break;
 }
    
 stat->n = 0; 
 stat->num = 0;
 stat->numoverflow = false;
 stat->head = NULL;
 stat->tail = NULL;

 //to mark all entries as free, set the address pointer to NULL
 for(int i = 0; i < max; i++)
   list[i].adr = NULL; 
}


//******************************************************************************
MemTrace::MemTrace()
{
 del_file = NULL;
 delall(OBJECT);
 delall(ARRAY);
 delall(C_MALLOC);
 
#ifdef MEMTRACE_STARTLOCKED
 lock();
#else
 unlock();
#endif
}


//******************************************************************************
void MemTrace::printList(MEMTRACE_TYPE type)
{
 MemTraceStat  *stat;
 MemTraceEntry *list;
 
 switch(type)
 {
  case OBJECT:
    stat = &o;
    MEMTRACE_PRINT_OUT << "--- object list ---" << endl;
    break;
  case ARRAY:
    stat = &a;
    MEMTRACE_PRINT_OUT << "--- array list ---" << endl;
    break;
  case C_MALLOC:
    stat = &m;
    MEMTRACE_PRINT_OUT << "--- malloc list ---" << endl;
    break;
 }

 //major info
 MEMTRACE_PRINT_OUT << " * total number of allocated blocks: " << stat->n << endl;;
 MEMTRACE_PRINT_OUT << " * remaining undeleted blocks: " << stat->num << endl;;
 MEMTRACE_PRINT_OUT << " * list overflow occured: ";
 if(stat->numoverflow)
   MEMTRACE_PRINT_OUT << "yes (capacity too small)";
 else
   MEMTRACE_PRINT_OUT << "no";
 MEMTRACE_PRINT_OUT << endl;

 if(stat->num != 0)
   MEMTRACE_PRINT_OUT << " Allocatio no. / Memory address / Size in bytes / File name: line" << endl;

 //entries in the list (not deleted blocks)
 list = stat->head;
 while(list != NULL)
 {
   MEMTRACE_PRINT_OUT << " > " << list->n << " / " << list->adr << " / " << list->size;
   if(list->fname == NULL)
     MEMTRACE_PRINT_OUT << " / " << "unknown" << endl;
   else
     MEMTRACE_PRINT_OUT << " / \"" << list->fname << "\": " << list->line << endl;

   list = list->next;
 }

 MEMTRACE_PRINT_OUT << endl;
}
