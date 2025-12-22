#include "alloc.h"
#include "istack.h"
#include "sysdefs.h"

#define     IS_CHUNK     256

extern void fatal( const char *msg );

struct istack {
    int size, count;
    int *data;
};

struct istack *is_init( void )
{
    struct istack *s;
    
    s = (struct istack*)MALLOC( sizeof( *s ));
    if ( s ) {
        s->size = s->count = 0;
        s->data = (int*)MALLOC( IS_CHUNK * sizeof(int) );
        if ( !s->data ) {
            FREE( s );
            return 0;
        }
        
        s->size = IS_CHUNK;
    }
    
    return s;
}

void is_push( struct istack *s, int n )
{
    if ( s ) {
        if ( s->count >= s->size ) {
            s->size += IS_CHUNK;
            s->data = (int*)REALLOC( s->data, s->size * sizeof(int) );
            if ( !s->data ) fatal( "stack overflow" );
        }
        
        s->data[ s->count++ ] = n;
    }
}

int  is_top( struct istack *s )
{
    return (s->count > 0) ? s->data[ s->count-1 ] : 0;
}

int  is_pop( struct istack *s )
{
    if ( s->count > 0 ) 
        return s->data[ --s->count ];
    
    return 0;
}

