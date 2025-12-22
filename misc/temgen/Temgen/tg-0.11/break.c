#include "alloc.h"
#include "generator.h"
#include "sysdefs.h"

static int *brk_stack = NULL;
static int  brk_size = 0;
static int  brk_n = 0;

#define      DELTA   64

static void brk_fatal( void )
{
    fatal( "stack memory allocation error" );
}

void   brk_push( int line )
{
    if ( !brk_stack ) {
        brk_stack = (int*)MALLOC( DELTA * sizeof(brk_stack[0]) );
        if ( !brk_stack ) brk_fatal();
        brk_size = DELTA;
        brk_n = 0;
    }
    
    if ( brk_n >= brk_size ) {
        brk_stack = (int*)REALLOC( brk_stack, 
                (brk_size + DELTA) * sizeof(brk_stack[0]) );
        if ( !brk_stack ) brk_fatal();
        brk_size += DELTA;
    }
   
    brk_stack[ brk_n++ ] = line;
}

int    brk_pop( void )
{
    if ( brk_n <= 0 ) return -1;
    return brk_stack[ --brk_n ];
}


