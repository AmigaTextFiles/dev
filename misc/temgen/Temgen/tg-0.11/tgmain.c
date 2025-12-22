#include "alloc.h"
#include "atom.h"
#include "db.h"
#include "y.tab.h"
#include "sysdefs.h"
#include "generator.h"
#include "errtab.h"
#include "srctab.h"
#include "output.h"
#include "use.h"
#include "version.h"

extern int  yylex();
extern int  yyparse();

extern FILE     *yyin;
extern int       lineno;

const char      *curfile = NULL;
int              curfilen = 0;
struct txttab   *text_table = NULL;
struct lintab   *line_table = NULL;
int              errraised = 0;
extern char     *errmsg;
static       int status = 0;
int              debugger = 0;

int yywrap()
{
    return 1;
}

int yyerror( const char *s )
{
    errraised = lineno;
    /* save_error( curfile, lineno, errmsg ); 
       --- save_error is called in tg.y ! */
    return 0;
}

#if 0
void dumpdata( void )
{
    int i;

    for ( i=0; i<=lt_maxindex( line_table ); i++ ) {
        struct command *c;

        c = (struct command*)lt_get( line_table, i );
        if ( c ) {
            printf( "%d:", i );
            dump_cmd( i, c );
        }
    }
}
#endif

void start_file( const char *fname ) 
{
    if ( text_table ) free_txttab( text_table );
    if ( line_table ) free_lintab( line_table );
    text_table = new_txttab( 4096, 4096 );
    line_table = new_lintab( 4096, 4096 );
    curfilen = atom( fname );
    yyin = fopen( fname, "r" );
    if ( !yyin ) {
        fprintf( stderr, "Error opening %s\n", fname );
        exit( 1 );
    }

    curfile = fname;
    errraised = 0;
    lineno = 1;
}

struct sourcefile *parsefile( const char *fname )
{
    struct sourcefile *f;

    f = (struct sourcefile*)MALLOC( sizeof(*f) );
    if ( f ) {
        start_file( fname );
        yyparse();
        
        if ( errraised ) {
            FREE( f );
            f = NULL;
            status++;
        } else {
            f->fname = curfilen;
            f->tt = text_table;
            f->lt = line_table;
            text_table = NULL;
            line_table = NULL;
        }
    }

    return f;
}

/* table of sourcefile*'s */
struct lintab *source = NULL;

static int run_file( struct sourcefile *sf )
{
    int cur = 0;
    int maxndx;
    
    if ( !sf ) return -1;
    maxndx = sf->lt ? lt_maxindex( sf->lt ): -1;
    
    while( cur>=0 && cur<=maxndx ) {
        struct command *c;
        c = lt_get( sf->lt, cur );
        cur = run_cmd( cur, c, sf );
    }
    
    return 0;
}

static void longopt( const char *str )
{
        if ( !strcmp( str, "version" )) {
                printf( version_message, VERSION );
                exit( 0 );
        }
        if ( !strcmp( str, "help" )) {
                printf( help_message, VERSION );
                exit( 0 );
        }
}

static void load( const char *fname )
{
    struct sourcefile *sf; 
    
    sf = parsefile( fname );
    if ( sf ) {
        int res;

        if ( !source ) source = new_lintab( 16, 16 );
        if ( !source ) {
            fprintf( stderr, "Memory allocation error\n" );
            exit( 1 );
        }

        lt_set( source, lt_maxindex(source)+1, sf );
        res = regsrc( sf );
        if ( res && res == -100 ) {
            fprintf( stderr, "Memory allocation error\n" );
            exit( 1 );
        }
    }
}

static int source_find( int fname )
{
    int i;
    struct sourcefile *sf;
    
    for ( i=0; i<=lt_maxindex(source); i++ ) { 
        sf = (struct sourcefile*)lt_get( source, i );
        if ( sf->fname == fname ) return 1;
    }
    
    return 0;
}

int main( int argc, char *argv[] )
{
    extern int yydebug;
    int i;

    for ( i=1; i<argc; i++ ) {
        if ( argv[i][0] == '-' ) {
            switch( argv[i][1] ) {
                case 'd':
                    debugger = 1;
                    break;
                case 'h':
                    printf( help_message, VERSION );
                    exit( 0 );
                case 'y':
                    yydebug = 1;
                    break;
                case '-':
                    longopt( argv[i]+2 );
                    break;
                default:
                    fprintf( stderr, "Unrecognized command, use tg --help\n" );
            }

            continue;
        }

        load( argv[i] );
    }

    reset_use();
    while( 1 ) {
        int f;
        f = next_use();
        if ( f <= 0 ) break;
        if ( !source_find(f) )
            load( atom_name(f) );
    }
    
    if ( status ) {
        while( 1 ) {
            const char *msg = next_errmsg();
            if ( !msg ) break;
            fprintf( stderr, "%s\n", msg );
        }
    }
    else {
        for ( i=0; i<=lt_maxindex(source); i++ ) 
            if ( run_file( (struct sourcefile*)lt_get( source, i )) ) break;
        
        status = closeout();
        if ( status ) {
                char buf[ 256 ];
                snprintf( buf, sizeof(buf), "write error: %s", strerror(errno) );
                fatal( buf );
        }
    }
    
    return status;
}
