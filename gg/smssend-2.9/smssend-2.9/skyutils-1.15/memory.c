/****************************************************************/
/* Memory unit                                                  */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/
#include "skyutils.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SU_DEFAULT_MALLOC_CHECK 1

#ifdef _REENTRANT
#ifdef __unix__
#include <semaphore.h>
sem_t SU_alloc_trace_sem;  /* Semaphore to protect the use of SU_alloc_trace_list in MT environment */
#define SEM_UNIX
#else
#include <winbase.h>
HANDLE SU_alloc_trace_sem;  /* Semaphore to protect the use of SU_alloc_trace_list in MT environment */
#define SEM_WIN32
#endif
#endif
bool SU_sem_init=false;

SU_PList SU_alloc_trace_list = NULL; /* SU_PAlloc */

typedef struct
{
  void *ptr;
  long int size;
  long int time;
  char file[512];
  int line;
  bool freed;
} SU_TAlloc, *SU_PAlloc;

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

/* MEMORY ALIGNEMENT FUNCTIONS */
void *SU_malloc(long int size)
{
  unsigned char pad;
  void *memblock,*retblock;

  memblock = malloc(size+SU_MALLOC_ALIGN_SIZE);
  if(memblock == NULL)
    return NULL;
  pad = ((int)memblock)%SU_MALLOC_ALIGN_SIZE;
  if(pad == 0)
    pad = SU_MALLOC_ALIGN_SIZE;
  retblock = (unsigned char *)memblock+pad;
  *((unsigned char *)retblock-1) = pad;
  *((unsigned char *)retblock-2) = SU_MALLOC_KEY;
  return retblock;
}

void SU_free(void *memblock)
{
  unsigned char pad;
  if(*((unsigned char *)memblock-2) != SU_MALLOC_KEY)
  {
    printf("SU_free WARNING : bloc already freed\n");
    return;
  }
  *((unsigned char *)memblock-2) = 0;
  pad = *((unsigned char *)memblock-1);
  free((unsigned char *)memblock-pad);
}

/* TRACE DEBUG FUNCTIONS */
void SU_printf_trace_debug(char *func,char *Str,void *memblock,char *file,int line,char *file2,int line2)
{
  int v = SU_DEFAULT_MALLOC_CHECK;
#ifdef __unix__
  char *s;
  s = getenv("MALLOC_CHECK_");
  if(s != NULL)
    v = atoi(s);
#endif
  if(v > 0)
  {
    if(file2 == NULL)
      printf("%s Warning : bloc %p %s (%s:%d)\n",func,memblock,Str,file,line);
    else
      printf("%s Warning : bloc %p %s %s:%d (%s:%d)\n",func,memblock,Str,file,line,file2,line2);
  }
#ifdef __unix__
  if(v == 2)
    abort();
#endif
}

void *SU_malloc_trace(long int size,char *file,int line)
{
  SU_PAlloc Al;
  void *ptr;
  SU_PList Ptr;
  char *env1,*env2;

  ptr = malloc(size);
  if(ptr == NULL)
  {
    printf("SU_malloc_trace Warning : malloc returned NULL\n");
    return NULL;
  }
  if(!SU_sem_init)
  {
#ifdef SEM_UNIX
    sem_init(&SU_alloc_trace_sem,0,1);
#else
#ifdef SEM_WIN32
    SU_alloc_trace_sem = CreateSemaphore(NULL,1,1,"SU_alloc_trace_sem");
    if(SU_alloc_trace_sem == NULL)
      printf("SkyUtils Error : Couldn't allocate semaphore\n");
#endif
#endif
    SU_sem_init = true;
    env1 = getenv("MALLOC_CHECK_");
    env2 = getenv("SU_MALLOC_TRACE");
    printf("Skyutils Information : Using SU_MALLOC_TRACE hooks : MALLOC_CHECK_=%d SU_MALLOC_TRACE=%d\n",(env1==NULL)?SU_DEFAULT_MALLOC_CHECK:atoi(env1),(env2==NULL)?0:atoi(env2));
  }
#ifdef SEM_UNIX
  sem_wait(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
  WaitForSingleObject(SU_alloc_trace_sem,INFINITE);
#endif
#endif
  Ptr = SU_alloc_trace_list;
  while(Ptr != NULL)
  {
    Al = (SU_PAlloc)Ptr->Data;
    if(Al->ptr == ptr)
      break;
    Ptr = Ptr->Next;
  }
  if(Ptr == NULL)
  {
    Al = (SU_PAlloc) malloc(sizeof(SU_TAlloc));
    if(Al == NULL)
    {
      free(ptr);
      return NULL;
    }
    SU_alloc_trace_list = SU_AddElementHead(SU_alloc_trace_list,Al);
  }
  Al->ptr = ptr;
  Al->size = size;
  Al->time = time(NULL);
  SU_strcpy(Al->file,file,sizeof(Al->file));
  Al->line = line;
  Al->freed = false;
#ifdef SEM_UNIX
  sem_post(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
  ReleaseSemaphore(SU_alloc_trace_sem,1,NULL);
#endif
#endif
  return ptr;
}

void *SU_calloc_trace(long int nbelem,long int size,char *file,int line)
{
  void *ptr;

  ptr = SU_malloc_trace(nbelem*size,file,line);
  if(ptr == NULL)
    return NULL;
  memset(ptr,0,nbelem*size);
  return ptr;
}

void *SU_realloc_trace(void *memblock,long int size,char *file,int line)
{
  SU_PList Ptr;
  void *new_ptr;

#ifdef SEM_UNIX
  sem_wait(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
  WaitForSingleObject(SU_alloc_trace_sem,INFINITE);
#endif
#endif
  Ptr = SU_alloc_trace_list;
  while(Ptr != NULL)
  {
    if(((SU_PAlloc)Ptr->Data)->ptr == memblock)
      break;
    Ptr = Ptr->Next;
  }
#ifdef SEM_UNIX
  sem_post(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
  ReleaseSemaphore(SU_alloc_trace_sem,1,NULL);
#endif
#endif
  if(Ptr == NULL)
  {
    SU_printf_trace_debug("SU_realloc_trace","already freed, or never allocated",memblock,file,line,NULL,0);
    return NULL;
  }
  if(((SU_PAlloc)Ptr->Data)->freed)
  {
    SU_printf_trace_debug("SU_realloc_trace","was freed at",memblock,((SU_PAlloc)Ptr->Data)->file,((SU_PAlloc)Ptr->Data)->line,file,line);
    return NULL;
  }
  if(size == 0)
  {
    SU_free_trace(memblock,file,line);
    return NULL;
  }
  if(size > ((SU_PAlloc)Ptr->Data)->size)
  {
    new_ptr = SU_malloc_trace(size,file,line);
    if(new_ptr != NULL)
    {
      memcpy(new_ptr,memblock,((SU_PAlloc)Ptr->Data)->size);
      SU_free_trace(memblock,file,line);
    }
    return new_ptr;
  }
  else
  {
    SU_strcpy(((SU_PAlloc)Ptr->Data)->file,file,sizeof(((SU_PAlloc)Ptr->Data)->file));
    ((SU_PAlloc)Ptr->Data)->line = line;
    return memblock;
  }
}

char *SU_strdup_trace(const char *in,char *file,int line)
{
  char *s;
  long int len;

  len = strlen(in) + 1;
  s = (char *) SU_malloc_trace(len,file,line);
  if(s == NULL)
    return NULL;
  SU_strcpy(s,in,len);
  return s;
}

void SU_free_trace(void *memblock,char *file,int line)
{
  SU_PList Ptr,Ptr2;
  bool keep_it=false;
#ifdef __unix__
  char *s;

  s = getenv("SU_MALLOC_TRACE");
  if(s != NULL)
    keep_it = atoi(s);
#endif
  Ptr = SU_alloc_trace_list;
  Ptr2 = NULL;
  while(Ptr != NULL)
  {
    if(((SU_PAlloc)Ptr->Data)->ptr == memblock)
      break;
    Ptr2 = Ptr;
    Ptr = Ptr->Next;
  }
  if(Ptr == NULL)
  {
    if(keep_it)
      SU_printf_trace_debug("SU_free_trace","was never allocated",memblock,file,line,NULL,0);
    else
      SU_printf_trace_debug("SU_free_trace","already freed, or never allocated",memblock,file,line,NULL,0);
    return;
  }
  if(((SU_PAlloc)Ptr->Data)->freed)
  {
    SU_printf_trace_debug("SU_free_trace","was freed at",memblock,((SU_PAlloc)Ptr->Data)->file,((SU_PAlloc)Ptr->Data)->line,file,line);
    return;
  }
  free(memblock);
  if(keep_it)
  {
    ((SU_PAlloc)Ptr->Data)->freed = true;
    SU_strcpy(((SU_PAlloc)Ptr->Data)->file,file,sizeof(((SU_PAlloc)Ptr->Data)->file));
    ((SU_PAlloc)Ptr->Data)->line = line;
  }
  else
  {
    free(Ptr->Data);
#ifdef SEM_UNIX
    sem_wait(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
    WaitForSingleObject(SU_alloc_trace_sem,INFINITE);
#endif
#endif
    if(Ptr2 == NULL)
      SU_alloc_trace_list = SU_DelElementHead(SU_alloc_trace_list);
    else
      Ptr2->Next = SU_DelElementHead(Ptr);
#ifdef SEM_UNIX
    sem_post(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
    ReleaseSemaphore(SU_alloc_trace_sem,1,NULL);
#endif
#endif
  }
}

void SU_alloc_trace_print(bool detail)
{
  SU_PList Ptr;
  int count = 0;

#ifdef SEM_UNIX
  sem_wait(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
  WaitForSingleObject(SU_alloc_trace_sem,INFINITE);
#endif
#endif
  Ptr = SU_alloc_trace_list;
  while(Ptr != NULL)
  {
    if(!((SU_PAlloc)Ptr->Data)->freed)
    {
      count++;
      if(detail)
        printf("SU_alloc_trace_print : %ld %p %ld -> %s:%d\n",((SU_PAlloc)Ptr->Data)->time,((SU_PAlloc)Ptr->Data)->ptr,((SU_PAlloc)Ptr->Data)->size,((SU_PAlloc)Ptr->Data)->file,((SU_PAlloc)Ptr->Data)->line);
    }
    Ptr = Ptr->Next;
  }
  printf("SU_alloc_trace_print : %d blocks\n",count);
#ifdef SEM_UNIX
  sem_post(&SU_alloc_trace_sem);
#else
#ifdef SEM_WIN32
  ReleaseSemaphore(SU_alloc_trace_sem,1,NULL);
#endif
#endif
}
