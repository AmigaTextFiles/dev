#include "generator.h"
#include "lintab.h"
#include "use.h"

static struct lintab *used_files = 0;
static int used_iter = 0;

void do_use( int fname )
{
    int i, n;

    if ( !used_files ) 
        used_files = new_lintab( 32, 32 );
    
    if ( !used_files ) fatal( "Memory allocation error in 'use'" );
    
    n = lt_maxindex( used_files );
     
    for ( i=0; i<=n; i++ ) {
        int name;
        
        name = (int)lt_get( used_files, i );
        if ( name == fname ) return;
    }
    
    lt_set( used_files, n+1, (void*)fname );
}

void reset_use( void )
{
    used_iter = 0;
}

int  next_use( void )
{
    return (int)lt_get( used_files, used_iter++ );
}
