#include "alloc.h"
#include "generator.h"
#include "omani.h"
#include "sysdefs.h"

struct fmtchunk {
        char *fmt;
        char  type;
};

static struct fmtchunk *new_fmtchunk( int len )
{
        struct fmtchunk *res;

        res = (struct fmtchunk*)MALLOC( sizeof(*res) );
        if ( !res ) return NULL;

        res->fmt = (char*)MALLOC( len );
        res->type = '\0';
        if ( !res->fmt ) {
                FREE( res );
                return NULL;
        }

        return res;
}

static void printf_sfree( struct fmtchunk **ptr )
{
        struct fmtchunk **c;

        if ( ptr ) {
                for ( c = ptr; *c; c++ ) {
                        if ( (*c)->fmt ) FREE( (*c)->fmt );
                        FREE( *c );
                }
                
                FREE( ptr );
        }
}

static struct fmtchunk **printf_split( const char *fmt )
{
        int n, i, state, begin, len;
        const char *c;
        struct fmtchunk **res;
        struct fmtchunk **d;
        
        const char *convspec = "diouxXeEfFgGaAcspn%";
        
        if ( !fmt ) return NULL;
        for ( n=0, c=fmt; *c; c++ ) 
                if ( *c == '%' ) n++;

        res = (struct fmtchunk **)CALLOC( n+2, sizeof( res[0] ));
        if ( !res ) {
                fatal( "memory allocation error" );
                return NULL;
        } 

        d = res;
        state = begin = 0;
        
        for ( i=0, c=fmt; *c; c++, i++ ) {
                if ( state ) {
                        if ( strchr( convspec, *c ) ) {
                                len = i-begin+1;
                                *d = new_fmtchunk( len + 1 );
                                
                                if ( !*d ) {
                                        printf_sfree( res );
                                        return NULL;
                                }

                                memcpy( (*d)->fmt, fmt+begin, len );
                                (*d)->fmt[ len ] = '\0';
                                (*d)->type = *c;
                                d++;
                                begin = i+1;
                                state = 0;
                        }
                }
                else {
                        if ( *c == '%' ) state = 1;
                }
        }

        if ( begin != i ) {
                len = i-begin+1;
                *d = new_fmtchunk( len + 1 );
                if ( !*d ) {
                        printf_sfree( res );
                        return NULL;
                }

                memcpy( (*d)->fmt, fmt+begin, len );
                (*d)->fmt[ len ] = '\0';
        }

        return res;
}

int prn_get_int( int n )
{
        int type;

        type = ob_type( n );
        switch( type ) {
                case 'f':
                        return ob_getf( n );
                case 's':
                        return atoi( ob_gets( n ) );
                default: 
                        return ob_geti( n );
        }
}

unsigned prn_get_unsigned( int n )
{
        return (unsigned)prn_get_int( n ); 
}

double prn_get_double( int n )
{
        int type;

        type = ob_type( n );
        switch( type ) {
                case 'i':
                        return ob_geti( n );
                case 's':
                        return atof( ob_gets( n ) );
                default: 
                        return ob_getf( n );
        }
}

const char *prn_get_string( int n )
{
        static char buf[ 128 ] = "";
        
        int type;

        type = ob_type( n );
        switch( type ) {
                case 'i':
                        snprintf( buf, sizeof(buf), "%d", ob_geti( n ));
                        break;
                case 'f':
                        snprintf( buf, sizeof(buf), "%f", ob_getf( n ));
                        break;
                case 's':
                        return ob_gets( n );
        }
        
        return buf;
}

int snprintfo( char *buf, int size, const char *fmt, int *data, int ndata )
{
        char *d;
        int n, ndx, len;
        struct fmtchunk **split;
        struct fmtchunk **s;
        
        if ( buf ) buf[ 0 ] = '\0';
        if (!( buf && fmt )) return 0;
        split = printf_split( fmt );
        if ( !split ) return 0;

        d = buf;
        n = ndx = 0;

        for ( s=split; *s; s++ ) {
                switch( (*s)->type ) {
                        case 'd':
                        case 'i':
                                snprintf( d, size-n, (*s)->fmt,
                                                (ndata>0) ? 
                                                prn_get_int( data[ndx++] ): 0 );
                                break;
                        case 'o':
                        case 'u':
                        case 'x':
                        case 'X':
                                snprintf( d, size-n, (*s)->fmt,
                                                (ndata>0) ? 
                                                prn_get_unsigned( data[ndx++] ): 0 );
                                break;
                        case 'e':
                        case 'E':
                        case 'f':
                        case 'F':
                        case 'g':
                        case 'G':
                        case 'a':
                        case 'A':
                                snprintf( d, size-n, (*s)->fmt,
                                                (ndata>0) ? 
                                                prn_get_double( data[ndx++] ): 0 );
                                break;
                        case 's':
                                snprintf( d, size-n, (*s)->fmt,
                                                (ndata>0) ? 
                                                prn_get_string( data[ndx++] ): 0 );
                                break;
                        case 'c':
                                snprintf( d, size-n, (*s)->fmt,
                                                (ndata>0) ? 
                                                prn_get_string( data[ndx++] )[0]: 0 );
                                break;
                        case '%':
                                snprintf( d, size-n, "%%" );
                                break;
                        default:
                                snprintf( d, size-n, "%s", (*s)->fmt );
                                break;
                                

                }

                ndata--;

                len = strlen( d );
                d += len;
                n += len;
                if ( n >= size ) break;
        }
       
        printf_sfree( split );
        return n;
}

