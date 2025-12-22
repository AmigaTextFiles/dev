#include "frame.h"
#include "omani.h"

static int _next_free = 1;

int frame_alloc( int Frames )
{
    int res;
    
    /* FIXME ! - better memory allocation ! */
    res = ob_item( Frames, _next_free++ );
    return res;
}

void frame_free( int Frames, int obj )
{
    int last;
    
    /* FIXME ! - better deallocation */
    ob_set( obj, 'i', 0 );
    last = ob_item( Frames, _next_free-1 );
    if ( last == obj ) 
        _next_free--;
}
