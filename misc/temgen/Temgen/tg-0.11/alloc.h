#ifndef __alloc_h_
#define __alloc_h_

/* macros for memory allocation debugging */

/* #define  MALLOC_DEBUG 1 */

#ifndef  MALLOC_DEBUG

#define      MALLOC         malloc
#define     REALLOC        realloc  
#define      CALLOC         calloc
#define        FREE           free
#define      STRDUP         strdup
#define      ALLOCA         alloca

#else

void *malloc_wrapper( unsigned );
void *alloca_wrapper( unsigned );
void *realloc_wrapper( void*, unsigned );
void *calloc_wrapper( unsigned, unsigned );
void  free_wrapper( void* );
char *strdup_wrapper( const char* );

#define      MALLOC         malloc_wrapper
#define     REALLOC        realloc_wrapper  
#define      CALLOC         calloc_wrapper
#define        FREE           free_wrapper
#define      STRDUP         strdup_wrapper
#define      ALLOCA         alloca_wrapper

#endif
#endif
