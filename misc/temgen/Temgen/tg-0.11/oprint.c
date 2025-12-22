#include "atom.h"
#include "omani.h"
#include "sysdefs.h"

static int getlinelen( const char *buf )
{
    const char *nl;
    int sl;
    
    if ( !( buf && buf[0] ) ) return 0;
    
    nl = strrchr( buf, '\n' );
    sl = strlen( buf );
    return nl ? sl-(nl-buf): sl;
}

void  ob_print( char *buf, int size, int obj )
{
    int typ, n, i, len1, len2, name;  
    
    typ = ob_type( obj );
    switch( typ ) {
        case 'i':
            snprintf( buf, size, "%d", ob_geti( obj ));
            break;
        case 'f':
            snprintf( buf, size, "%f", ob_getf( obj ));
            break;
        case 's':
            snprintf( buf, size, "\"%s\"", ob_gets( obj ));
            break;
        case 'R':
            ob_print( buf, size, ob_geti( obj ));
            break;
        case 'r':
            if ( size < 6 ) return;
            buf[ 0 ] = '{';
            buf[ 1 ] = ' ';
            buf[ 2 ] = '\0';
            n = ob_count( obj );
            for ( i=0; i<n; i++ ) {
                len1 = strlen( buf );
                if ( len1 > size-6 ) return;
                name = ob_fieldname( obj, i );
                snprintf( buf+len1, size-len1, "%s: ", atom_name(name) );
                len1 = strlen( buf );
                if ( len1 > size-6 ) return;
                ob_print( buf+len1, size-len1, ob_field( obj, name ));
                len2 = strlen( buf );
                if ( len2 > size-6 ) return;
                len1 = getlinelen( buf );
                if ( len1 > 70 )
                    strcat( buf, (i==n-1) ? " }": ",\n" );
                else
                    strcat( buf, (i==n-1) ? " }": ", " );
            }
            break;
        case 'a':
            if ( size < 6 ) return;
            buf[ 0 ] = '[';
            buf[ 1 ] = ' ';
            buf[ 2 ] = '\0';
            n = ob_count( obj );
            for ( i=0; i<n; i++ ) {
                len1 = strlen( buf );
                if ( len1 > size-6 ) return;
                ob_print( buf+len1, size-len1, ob_item( obj, i ));
                len2 = strlen( buf );
                if ( len2 > size-6 ) return;
                len1 = getlinelen( buf );
                if ( len1 > 70 )
                    strcat( buf, (i==n-1) ? " ]": ",\n" );
                else
                    strcat( buf, (i==n-1) ? " ]": ", " );
            }
            break;
            break;
        default :
            snprintf( buf, size, "( type:0x%02x )", typ );
    }
}
