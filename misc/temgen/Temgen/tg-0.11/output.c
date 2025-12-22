#include "alloc.h"
#include "atom.h"
#include "debug.h"
#include "generator.h"
#include "hash.h"
#include "sysdefs.h"

struct txtline {
    char  type;     /* t (text), e (embed) */
    union txt_val {
        char *text;
        int   emb;
    } val;
};

struct outfile {
    int                name;
    int                embed;           /* 1 if the outfile is embed handle */
    FILE              *f;
    struct txtline    *data; 
    int                count, size;
};

static struct outfile *curout = NULL;
static struct hash *otab = NULL;
static int cur_name = 0;
static int cur_embed = 0;

/* embed points stack */
struct eps_item {
    int embed, name;
};

static struct eps_item *eps_stack = NULL;
static int eps_size = 0; 
static int eps_count = 0;

static void out_error( void )
{
    char buf[ 256 ];
    snprintf( buf, sizeof(buf), "error generating output: %s", strerror(errno) );
    fatal( buf );
}

static unsigned ot_hfun( const void *p )
{
    return (unsigned)((const struct outfile*)p)->name;
}

static int ot_cmp( const void *p1, const void *p2 )
{
    int n1, n2;
    n1 = (((const struct outfile*)p1)->name << 1) 
        | (((const struct outfile*)p1)->embed ? 1: 0);
    n2 = (((const struct outfile*)p2)->name << 1)
        | (((const struct outfile*)p2)->embed ? 1: 0);
    return n1-n2;
}

static struct outfile *newof( int name, int isembed )
{
    struct outfile *of;
    
    of = (struct outfile*)CALLOC( 1, sizeof(*of) );
    if ( of ) {
        of->name = name;
        of->embed = (isembed ? 1: 0);
        if ( !otab ) otab = new_hash( 37, ot_hfun, ot_cmp );
        if ( h_add( otab, of ) ) {
            FREE( of );
            return NULL;
        }
    }
    
    return of;
}

static struct outfile *findof( int name, int embed )
{
    struct outfile f, *of;
    
    f.name = name;
    f.embed = (embed ? 1: 0);
    of = (struct outfile*)h_get( otab, &f );
    if ( !of ) of = newof( name, embed );
    return of;
}

void setout( int name, int embed )
{
    struct outfile *of;
    
    of = findof( name, embed );
    if ( of ) {
        curout = of;
        cur_name = name;
        cur_embed = embed;
    } else
        out_error();
}

void push_out( void )
{
    while ( eps_count >= eps_size ) {
        eps_size += 64;
        eps_stack = (struct eps_item*)REALLOC( eps_stack, 
                eps_size*sizeof( eps_stack[0] ) );
        if ( !eps_stack ) fatal( "memory allocation error" );
    }
    
    eps_stack[ eps_count ].name = cur_name;
    eps_stack[ eps_count ].embed = cur_embed;
    eps_count++;
}

void pop_out( void )
{
    if ( eps_count <= 0 ) return;
    cur_name = eps_stack[ --eps_count ].name;
    cur_embed = eps_stack[ eps_count ].embed;
    setout( cur_name, cur_embed );
}

static struct txtline *nextline( void )
{
#define  TABDELTA    1024        /* TODO tune */
    if ( !curout ) setout( atom("stdout"), 0 );
    if ( !curout ) out_error();
    if ( curout->size <= curout->count ) {
        struct txtline *old = curout->data;
        curout->size += TABDELTA;
        curout->data = (struct txtline*)REALLOC( old,
                curout->size * sizeof( curout->data[0] ));
        if ( !curout->data ) {
            curout->data = old;
            curout->size -= TABDELTA;
            return NULL;
        }
    }
    
    return curout->data + curout->count++;
}

void writeout( const char *s )
{
    struct txtline *tl;
    
    tl = nextline();
    if ( !tl ) out_error();
    
    tl->type = 't';
    tl->val.text = STRDUP( s );
    if ( debugger ) debout( "OUT:%s", s ); 
    if ( !tl->val.text ) out_error();
}

void embed( int id )
{
    struct txtline *tl;
    
    tl = nextline();
    if ( !tl ) out_error();
    
    tl->type = 'e';
    tl->val.emb = id;
}

void setemb( int id )
{
    setout( id, 1 );
}

static int do_fopen( struct outfile *of )
{
    if ( !of ) return -1;
    if ( of->embed ) return 0;
    if ( of->name == atom("stdout") )
        of->f = stdout;
    else if ( of->name == atom("stderr"))
        of->f = stderr;
    else
        of->f = fopen( atom_name(of->name), "w" );
    return of->f < 0;
}

static int writeln( struct outfile*, struct txtline* );

static int doembed( struct outfile *of, int id )
{
    int i;
    struct outfile *em;
    em = findof( id, 1 );

    for ( i=0; i<em->count; i++ ) 
        if ( writeln( of, em->data + i ) ) return -1;
    
    return 0; 
}

static int writeln( struct outfile *of, struct txtline *tl )
{
    switch( tl->type ) {
        case 'e':
            return doembed( of, tl->val.emb );
        case 't':
            if ( !of->f ) do_fopen( of );
            if ( !of->f ) {
                    char buf[ 512 ];
                    snprintf( buf, sizeof(buf), "error creating %s: %s",
                                    atom_name(of->name), strerror(errno) );
                    fatal( buf );
            }

            return fputs( tl->val.text, of->f ) < 0;
    }
    
    return -1;
}

static int do_fclose( struct outfile *of )
{
    int res;
    
    if ( of->name == atom("stdout") ) return 0;
    if ( of->name == atom("stderr") ) return 0;
    
    if ( of->f ) 
        res = fclose( of->f );
    else
        res = 0;
    
    return res;
}

static int closefile( void *p )
{
    int i;
    
    struct outfile *of = (struct outfile*)p;
    if ( !of ) return -1;
    if ( of->embed ) return 0; 

    for ( i=0; i<of->count; i++ ) 
        if ( writeln( of, of->data + i ) ) return -1;
    
    return do_fclose( of );
}

int closeout( void )
{
    return h_foreach( otab, closefile ); 
}
