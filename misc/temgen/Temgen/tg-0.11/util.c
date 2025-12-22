#include <string.h>

#include "strbuf.h"

const char *unquote( const char *s )
{
    static struct strbuf *buf = 0;
    int len;
    
    if ( !s ) return 0;
    if ( !s[0] ) return "";
    if ( s[0] != '"' && s[0] != '\'' ) return s;
    len = strlen( s );
    
    if ( buf ) 
        sb_clear( buf );
    else
        buf = new_strbuf( len-1, 256 );

    sb_cat( buf, s+1, len-2 );
    return sb_data( buf );
}

const char *unescape( const char *s, int len )
{
    const char *c;
    static struct strbuf *buf = 0;
    
    if ( !s ) return 0;
    if ( !s[0] ) return "";

    if ( buf ) 
        sb_clear( buf );
    else
        buf = new_strbuf( 256, 256 );

    for ( c=s; len>0 && *c; c++, len-- ) {
        if ( *c=='\\' && len>1 ) {
            c++;
            len--;
        }
        sb_cat( buf, c, 1 );
    }

    return sb_data( buf );
}

