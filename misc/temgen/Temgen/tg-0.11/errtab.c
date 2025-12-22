#include "alloc.h"
#include "sysdefs.h"
#include "atom.h"
#include "lintab.h"

static struct lintab *errtab = NULL;

struct error {
        int file, line, msgn;
};

void save_error( const char *fname, int line, const char *msg )
{
        struct error *e;
        int maxndx; 
        
        if ( !errtab ) errtab = new_lintab( 128, 128 );
        if ( !errtab ) return;

        maxndx = lt_maxindex( errtab );
        if ( maxndx < 0 ) maxndx = -1;
        e = (struct error*)MALLOC( sizeof(*e) );
        if ( e ) {
                e->file = atom( fname );
                e->line = line;
                e->msgn = atom( msg );  
                lt_set( errtab, maxndx+1, e );
        }
}

const char *next_errmsg( void )
{
        static char buf[ 256 ];
        static int next = 0;
        struct error *e;
        if ( !errtab ) return NULL;
        if ( next > lt_maxindex( errtab )) return NULL;
        e = (struct error*)lt_get( errtab, next++ );
        if ( !e ) return NULL;
        snprintf( buf, sizeof(buf), "%s:%d %s", atom_name(e->file), 
                e->line, atom_name(e->msgn) );
        return buf;
}
