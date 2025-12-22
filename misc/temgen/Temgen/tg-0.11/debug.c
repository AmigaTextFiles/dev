#include "atom.h"
#include "debug.h"
#include "sysdefs.h"

/* debugger modes */
#define      DM_NEXT        0
#define      DM_STEP        1
#define      DM_RUN         2

static int deb_mode = DM_NEXT;

char *debugp( const char *fmt, ... )
{
    static char cmd[ 512 ];
    char newcmd[ 512 ];
    va_list ap;
   
    if ( !debugger ) return NULL; 
    va_start( ap, fmt );
    vprintf( fmt, ap );
    va_end( ap );
    fgets( newcmd, sizeof(newcmd), stdin );
    if ( newcmd[0] != '\n' ) 
        strncpy( cmd, newcmd, sizeof(cmd) );
    
    cmd[ sizeof(cmd)-1 ] = '\0';
    return cmd;
}

static const char *prn_fname( struct sourcefile *sf )
{
        return atom_name( sf->fname );
}

static const char *prn_command( int index, struct command *c, 
        struct sourcefile *sf )
{
    static char buf[ 512 ];
    
    snprintf( buf, sizeof(buf), "%s:%d: %s", 
                    prn_fname(sf), index, tt_find( sf->tt, index ) );
    return buf;
}

void  deb_cmd( int index, struct command *c, struct sourcefile *sf )
{
    char *cmd;
    
    switch( deb_mode ) {
        case DM_RUN: 
            return;
        default:
            cmd = debugp( "%s(tg) ", prn_command( index, c, sf ) );
    }
}

void  debout( const char *fmt, ... )
{
    va_list ap;
   
    if ( !debugger ) return; 
    va_start( ap, fmt );
    vprintf( fmt, ap );
    va_end( ap );
}
