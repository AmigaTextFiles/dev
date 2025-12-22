#include "alloc.h"
#include "atom.h"
#include "eval.h"
#include "func.h"
#include "generator.h"
#include "hash.h"
#include "output.h"
#include "omani.h"
#include "printf.h"
#include "strbuf.h" 
#include "sysdefs.h"
#include "util.h"

struct function {
    int name;
    int file; 
    int line;
};

static struct hash *funtab = 0;
static struct hash *systab = 0;

#define     FHSIZE    701       /* TODO tune */

static unsigned fhval( const void *data )
{
    return ((const struct function*)data)->name;
}

static int fhcmp( const void *f1, const void *f2 )
{
    int name1, name2;
    name1 = ((const struct function*)f1)->name;
    name2 = ((const struct function*)f2)->name;
    return name1-name2;
}

int regfun( const char *name, int file, int line )
{
    struct function *f;

    if ( !funtab ) funtab = new_hash( FHSIZE, fhval, fhcmp );
    if ( !funtab ) return -1;
    
    f = (struct function*)MALLOC( sizeof(*f) );
    f->name = atom(name);
    f->file = file;
    f->line = line;
    return h_add( funtab, f );
}

int findfun( int name, int *file, int *line )
{
    struct function f, *res;
    
    f.name = name;
    res = (struct function*)h_get( funtab, &f );
    if ( res ) {
        *file = res->file;
        *line = res->line;
        return 0;
    }

    return 1;
}

static unsigned sys_hash( const void *ptr )
{
    return ((const struct sysfun*)ptr)->name;
}

static int sys_cmp( const void *p1, const void *p2 )
{
    int n1, n2;
    n1 = ((const struct sysfun*)p1)->name;
    n2 = ((const struct sysfun*)p2)->name;
    return n1-n2;
}

/* "$output" removed - use "@output" ! */
#if 0
static int sys_output( void )
{
    int arg = refvar( atom( "a" ), 1 );
    if ( arg < 0 ) return -1;             /* TODO okreslic semantyke */
    setout( atom( ob_gets(arg) ), 0 ); 
    return 0;
}
#endif

static int sys_printf( void )
{
        char buf[ PRINTF_BUFFER_SIZE ];
        int arg = refvar( atom("a"), 1 );
        int i, p;
        char *fmt;
        int args[ MAX_NARGS ];
        char name[ 2 ] = "a";
        
        fmt = ob_gets( arg );
        for ( i=1; i<MAX_NARGS; i++ ) {
                name[ 0 ] = 'a' + i;
                p = refvar( atom(name), 1 );
                if ( p < 0 ) break;
                args[ i-1 ] = p;
        }

        snprintfo( buf, sizeof(buf), fmt, args, i );
        setrets( buf );
        return 0;
}

static int sys_number( void )
{
    const char *s;
    double x;
    int n;
    int typ;
    int arg = refvar( atom("a"), 1 );
    
    typ = ob_type( arg );
    switch( typ ) {
        case 'i':
            setreti( ob_geti(arg) );
            break;
        case 'f':
            setretf( ob_getf(arg) );
            break;
        case 's':
            s = ob_gets(arg);
            x = strtod( s, NULL );
            n = atoi( s );
            if ( n == x )
                setreti( n );
            else
                setretf( x );
            break;
        default:
            setreti( 0 );
    }
    
    return 0;
}

static int sys_size( void )
{
    int arg = refvar( atom( "a" ), 1 );
    if ( arg < 0 ) return 0;
    setreti( ob_count( arg ) ); 
    return 0;
}

static int sys_strlen( void )
{
    char *s;
    int arg = refvar( atom( "a" ), 1 );
    if ( arg < 0 ) return 1;
    s = ob_gets( arg );
    setreti( s ? strlen(s): 0 ); 
    return 0;
}

static int sys_substr( void )
{
    char *s, *res;
    int len;
    int a = refvar( atom( "a" ), 1 );
    int b = refvar( atom( "b" ), 1 );
    int c = refvar( atom( "c" ), 1 );
    s = ob_gets( a );
    if ( !s ) {
        setrets( "" );
        return 0;
    }
    len = strlen( s );
    b = ob_geti( b );
    c = (c>=0) ? ob_geti( c ): -1;
    if ( c >= 0 ) {
        if ( b + c > len )
            len = len - b;
        else
            len = c;
    } 
    res = (char*)ALLOCA( len + 1 );
    if ( !res ) return -1;
    memcpy( res, s+b, len );
    res[ len ] = '\0';
    setrets( res );
    return 0;
}

static int sys_system( void )
{
    char *s;
    int exitcode;
    
    int a = refvar( atom( "a" ), 1 );
    s = ob_gets( a );
    if ( s && s[0] ) {
        FILE *f;
        struct strbuf *out;
        char buf[ SYSTEM_BUFFER_SIZE ];
        out = new_strbuf( SYSTEM_BUFFER_SIZE, SYSTEM_BUFFER_SIZE );
        if ( !out ) return -1;
        
        f = popen( s, "r" );
        if ( !f ) {
            free_strbuf( out );
            return -1;
        }
        
        while( fgets( buf, sizeof(buf), f )) {
            if ( sb_cat( out, buf, strlen(buf) ) ) {
                pclose( f );
                free_strbuf( out );
                return -1;
            }
        }

        exitcode = pclose( f );
        setrets( sb_data( out ) );
        
        if ( WIFEXITED(exitcode) )    
            exitcode = WEXITSTATUS(exitcode);
        else
            exitcode = -1;
        
        ob_set( ob_field( system_obj(), atom("exitcode")), 'i', exitcode );
        free_strbuf( out );
    }
    return 0;
}

static int sys_tplfile( void )
{
    extern int cur_file;
    setrets( atom_name(cur_file) );
    return 0;
}

static int sys_tplline( void )
{
    extern int cur_cmd;
    setreti( cur_cmd+1 );
    return 0;
}

static struct sysfun *new_sysfun( const char *name, int (*f)(void), int npar )
{
    struct sysfun *fun;
    struct param *params = NULL;
    int i;
    
    params = (struct param*)CALLOC( npar, sizeof(params[0]));
    if ( npar>0 && !params ) {
            fatal( "memory allocation error" );
            return NULL;
    }
    
    fun = (struct sysfun*)MALLOC( sizeof(*fun) );
    if ( fun ) {
        
        for ( i=0; i<npar; i++ ) {
                char name[2] = "a";
                params[i].h = i ? params+i-1: 0;
                name[0] = 'a' + i; 
                params[i].t = atom( name );
        }    

        if ( npar > 0 ) 
                fun->par = params + npar-1;
        else
                fun->par = NULL;
        
        
        fun->name = atom( name );
        fun->fun = f;
    }
    
    return fun;
}

static void initsystab( void )
{
    systab = new_hash( 43, sys_hash, sys_cmp );   /* tuning ? */
    h_add( systab, new_sysfun( "number",  sys_number,  1 ));
    h_add( systab, new_sysfun( "printf",  sys_printf, MAX_NARGS ));
    h_add( systab, new_sysfun( "size",    sys_size,    1 ));
    h_add( systab, new_sysfun( "strlen",  sys_strlen,  1 ));
    h_add( systab, new_sysfun( "substr",  sys_substr,  3 ));
    h_add( systab, new_sysfun( "system",  sys_system,  1 ));
    h_add( systab, new_sysfun( "tplfile", sys_tplfile, 0 ));
    h_add( systab, new_sysfun( "tplline", sys_tplline, 0 ));
}

struct sysfun *findsys( int name )
{
    struct sysfun key;
    if ( !systab ) initsystab();
    if ( !systab ) {
            fatal( "memory allocation error" );
            return 0;  
    }
    key.name = name;
    return (struct sysfun*)h_get( systab, &key );
}
