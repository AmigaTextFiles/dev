#include "alloc.h"
#include "sysdefs.h"
#include "txttab.h"

struct txttab {
    char **data;
    int  size, delta;
    char *buf;
    int  bufsize, buflen;
};

struct txttab *new_txttab( int size, int delta )
{
    struct txttab *t;
    
    if ( size < 0 || delta < 0 ) return NULL;
    
    t = (struct txttab*)MALLOC( sizeof(*t) );
    if ( t ) {
        t->size = size;
        t->delta = delta;
        t->buf = NULL;
        t->bufsize = t->buflen = 0;
        if ( size ) {
            t->data = (char**)CALLOC( size, sizeof(char*) );
            if ( !t->data ) {
                FREE( t );
                return NULL;
            }
        }
    }
    
    return t;
}

void free_txttab( struct txttab *t )
{
    int i;
    
    if ( t ) {
        if ( t->data ) {
            for ( i=0; i<t->size; i++ ) 
                if ( t->data[ i ] ) FREE( t->data[ i ] );
            FREE( t->data );
        }
        
        FREE( t );
    }
}

int tt_token( struct txttab *t, const char *s )
{
    int len;
    if ( !(t && s) ) return -1;
    
    len = strlen( s );
    if ( len + t->buflen >= t->bufsize ) {
        int newsize = len + t->buflen + 256;
        char *old = t->buf;
        t->buf = (char*)REALLOC( old, newsize );
        if ( !t->buf ) {
            t->buf = old;
            return -1;
        }
        t->bufsize = newsize;
    }
    
    strcpy( t->buf + t->buflen, s );
    t->buflen += len;
    return 0;
}

int tt_store( struct txttab *t, int line )
{
    if ( !t ) return -1;
    
    if ( t->size <= line ) {
        char **old;
        int s1, s2;
        s1 = t->size + t->delta;
        s2 = line+1;
        s1 = (s1>s2) ? s1: s2;
        old = t->data;
        t->data = (char**)REALLOC( old, s1 * sizeof(char*) );
        if ( !t->data ) {
            t->data = old;
            return -1;
        }
        memset( t->data+t->size, 0, (s1-t->size) * sizeof(t->data[0]) );
        t->size = s1;
    }
    
    if ( t->data[ line ] ) FREE( t->data[ line ] );
    t->data[ line ] = STRDUP( t->buf ? t->buf: "" );
    if ( t->bufsize > 512 ) {
        char *old;
        old = t->buf;
        t->buf = (char*)REALLOC( t->buf, 512 );
        if ( !t->buf ) 
            t->buf = old;
        else {
            t->bufsize = 512;
        }
    }
    
    if ( t->buf ) t->buf[ 0 ] = '\0';
    t->buflen = 0;
    
    return 0;
}

const char *tt_find( struct txttab *t, int line )
{
    if ( !t ) return NULL;
    if ( line < 0 || line >= t->size ) return NULL;
    return t->data[ line ];
}


