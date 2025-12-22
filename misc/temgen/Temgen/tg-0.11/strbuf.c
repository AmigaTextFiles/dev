#include "alloc.h"
#include "sysdefs.h"

struct strbuf {
        char    *data;
        unsigned size, len, delta;
};

struct strbuf *new_strbuf( unsigned size, unsigned delta )
{
        struct strbuf *b;

        b = (struct strbuf*)MALLOC( sizeof(*b) );
        if ( b ) {
                b->data = size ? (char*)MALLOC( size ): NULL;
                if ( size && !b->data ) {
                        FREE( b );
                        return NULL;
                }

                b->size = size;
                b->data[ 0 ] = '\0';
                b->len = 0;
                b->delta = delta;
        }

        return b;
}

void free_strbuf( struct strbuf *b )
{
        if ( b ) {
                if ( b->data ) FREE( b->data );
                FREE( b );
        }
}

const char *sb_data( struct strbuf *b )
{
        return b ? b->data: NULL;
}

int sb_cat( struct strbuf *b, const char *s, unsigned n )
{
        unsigned len;
        if ( !b ) return -1;

        len = s ? strlen(s): 0;
        if ( n < len ) len = n;
        
        while( b->size < b->len + len + 1 ) {
                char *old;
                if ( b->delta <= 0 ) return -1;
                b->size += b->delta;
                old = b->data;
                b->data = (char*)REALLOC( b->data, b->size );
                if ( !b->data ) {
                        b->data = old;
                        b->size -= b->delta;
                        return -1;
                }
                else memset( b->data+b->size-b->delta, 0, b->delta );
        }

        strncat( b->data, s, len );
        b->len += len;
        return 0;
}

void sb_clear( struct strbuf *sb )
{
        if ( sb && sb->data ) {
                sb->data[ 0 ] = '\0';
                sb->len = 0;

                if ( sb->delta && sb->size > 8*sb->delta ) {
                        FREE( sb->data );
                        sb->size = sb->len = 0;
                        sb->data = NULL;
                }
        }
}
