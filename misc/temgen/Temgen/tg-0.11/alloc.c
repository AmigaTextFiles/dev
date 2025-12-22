#include "sysdefs.h"

void *malloc_wrapper( size_t size )
{
    return malloc( size );
}

void *alloca_wrapper( size_t size )
{
    return alloca( size );
}

void *realloc_wrapper( void *p, size_t size )
{
    return realloc( p, size );
}

void *calloc_wrapper( size_t n, size_t size )
{
    return calloc( n, size );
}

void free_wrapper( void *p )
{
    free( p );
}

char *strdup_wrapper( const char *s )
{
    return strdup( s );
}

