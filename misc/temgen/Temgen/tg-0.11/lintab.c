#include "lintab.h"
#include "alloc.h"
#include "sysdefs.h"

struct lintab {
    void **data;
    int size, delta, maxndx;
};

struct lintab *new_lintab( int size, int delta )
{
    struct lintab *t;
    
    if ( size < 0 || delta < 0 ) return 0;
    
    t = (struct lintab*)MALLOC( sizeof(*t) );
    if ( t ) {
        t->size = size;
        t->delta = delta;
        t->maxndx = -1;
        if ( t->size ) {
            t->data = (void**)CALLOC( t->size, sizeof(void*) );
            if ( !t->data ) t->size = 0; 
        }
    }
    
    return t;
}

void free_lintab( struct lintab *t )
{
    if ( t ) {
        if ( t->data ) FREE( t->data );
        FREE( t );
    }
}

int lt_set( struct lintab *t, int n, void *p )
{
    if ( !t ) return -1;
    if ( n < 0 ) return -1;
   
    if ( !p ) {
            if ( n < 0 || n > t->maxndx ) return 0;
            t->data[ n ] = NULL;
            return 0;
    }
    
    if ( n >= t->size ) {
        int s1, s2;
        void **old = t->data;
        s1 = t->size + t->delta;
        s2 = n+1;
        s1 = (s1>s2) ? s1: s2;
        t->data = (void**)REALLOC( old, s1*sizeof(t->data[0]) );
        if ( !t->data ) {
            t->data = old;
            return -1;
        }
        
        memset( t->data+t->size, 0, (s1-t->size) * sizeof(t->data[0]) );
        t->size = s1;
    }
    
    t->data[ n ] = p;
    if ( n > t->maxndx ) t->maxndx = n;
    return 0;
}

void *lt_get( struct lintab *t, int n )
{
    if ( !t ) return NULL;
    if ( n < 0 || n > t->maxndx ) return NULL;
    return t->data[ n ];
}

int lt_maxindex( struct lintab *t )
{
    return t ? t->maxndx: -1;
}

