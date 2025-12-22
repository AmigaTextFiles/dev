#include "atom.h"
#include "db.h"
#include "debug.h"
#include "eval.h"
#include "frame.h"
#include "func.h"
#include "generator.h"
#include "istack.h"
#include "omani.h"
#include "strbuf.h"
#include "srctab.h"
#include "sysdefs.h"
#include "stack.h"
#include "util.h"
#include "version.h"

static int eval_initialized = 0;

/* registers */
static int A_reg = -1;
static int Globals = -1;

static struct istack *Stack = 0;   /* function parameter stack   */

static int VarStack = -1;          /* temporary objects stack    */ 
static int Const = -1;             /* constructed objects        */
static int NextFreeConst = 0;
static int Frames = -1;            /* frames pool                */

static int System = -1;            /* artificial "system" object */

static void init_system( void ) 
{
    int fld;
    System = ob_field( Globals, atom("system") );
    fld = ob_field( System, atom("version"));
    ob_set( fld, 's', VERSION );
}

int system_obj( void )
{
    if ( System <= 0 ) init_system();
    return System;
}

static void init_eval( void )
{
    int root;
    if ( !eval_initialized ) {
        root = ob_root();
        A_reg = ob_item( root, 0 );
        Globals = ob_item( root, 1 );
        Stack = is_init();
        if ( !Stack ) fatal( "memory allocation error" );
        VarStack = ob_item( root, 3 );
        stinit( VarStack );
        Const = ob_item( root, 4 );
        Frames = ob_item( root, 5 );
        NextFreeConst = 0;
        init_system();
        eval_initialized = 1;  
    }
}

int tmp_alloc( void )
{
    init_eval();
    return stalloc();
}

void tmp_free( int obj )
{
    init_eval();
    stfree( obj );
}

int nextreg( void )
{
    return NextFreeConst++;
}

static int refer( int obj ) 
{
#define       MAXREFLOOP        512 
     int i;
     
     for ( i=0; i<MAXREFLOOP; i++ ) {
         if ( ob_type(obj) != 'R' ) break;
         obj = ob_geti( obj );
     }
     
     return obj;
}

const char *print_obj( int obj )
{
    static char cbuf[ 64 ];
   
    obj = refer( obj );
    
    switch( ob_type(obj) ) {
        case 'i':
            sprintf( cbuf, "%d", ob_geti( obj ));
            return cbuf;
        case 'f':
            sprintf( cbuf, "%f", ob_getf( obj ));
            return cbuf;
        case 's':
            return ob_gets( obj );
    } 

    return "";
}

static const char *glue( int a, int b )
{
    static struct strbuf *buf = NULL;
    
    if ( !buf ) 
        buf = new_strbuf( 1024, 1024 );
    else
        sb_clear( buf );

    sb_cat( buf, print_obj( a ), 0x7ffffff0 );
    sb_cat( buf, print_obj( b ), 0x7ffffff0 );
    
    return sb_data( buf );
}

static void eval_arith( int reg, int a, char op, int b )
{
    char atype, btype;
    int i1, i2;
    float f1, f2;

    a = refer( a );
    b = refer( b );
    
    atype = ob_type( a );
    if ( atype == '\0' ) {
        ob_set( a, 'i', 0 );
        atype = ob_type( a );
    }
    btype = ob_type( b );
   
    if ( (atype=='s' || btype=='s') && op=='+' ) {
        ob_set( reg, 's', glue( a, b ) );
        return;
    }
    
    switch( atype ) {
        case 'i':
            i1 = ob_geti( a );
            switch( btype ) {
                case 'i':
                    i2 = ob_geti( b );
                    switch( op ) {
                        case '+':
                            ob_set( reg, 'i', i1 + i2 );
                            break;
                        case '-':
                            ob_set( reg, 'i', i1 - i2 );
                            break;
                        case '*':
                            ob_set( reg, 'i', i1 * i2 );
                            break;
                        case '/':
                            ob_set( reg, 'f', 
                                    (double)(i2 ? ((double)i1 / (double)i2): 0) );
                            break;
                    }
                    break;
                case 'f':
                    f2 = ob_getf( b );
                    switch( op ) {
                        case '+':
                            ob_set( reg, 'f', i1 + f2 );
                            break;
                        case '-':
                            ob_set( reg, 'f', i1 - f2 );
                            break;
                        case '*':
                            ob_set( reg, 'f', i1 * f2 );
                            break;
                        case '/':
                            ob_set( reg, 'f', f2 ? (i1 / f2): 0 );
                            break;
                    }
                    break;
                default:
                    ob_set( reg, 's', "" );
            }
            break;
        case 'f':
            f1 = ob_getf( a );
            switch( btype ) {
                case 'i':
                    i2 = ob_geti( b );
                    switch( op ) {
                        case '+':
                            ob_set( reg, 'f', f1 + i2 );
                            break;
                        case '-':
                            ob_set( reg, 'f', f1 - i2 );
                            break;
                        case '*':
                            ob_set( reg, 'f', f1 * i2 );
                            break;
                        case '/':
                            ob_set( reg, 'f', i2 ? (f1 / i2): 0 );
                            break;
                    }
                    break;
                case 'f':
                    f2 = ob_getf( b );
                    switch( op ) {
                        case '+':
                            ob_set( reg, 'f', f1 + f2 );
                            break;
                        case '-':
                            ob_set( reg, 'f', f1 - f2 );
                            break;
                        case '*':
                            ob_set( reg, 'f', f1 * f2 );
                            break;
                        case '/':
                            ob_set( reg, 'f', f2 ? (f1 / f2): 0 );
                            break;
                    }
                    break;
                default:
                    ob_set( reg, 's', "" );
            }
            break;
            
        default:
            ob_set( reg, 's', "" );
    }
}

int objtoint( int obj )
{
    obj = refer( obj );

    switch( ob_type( obj ) ) {
        case 'i':
            return ob_geti( obj );
        case 'f':
            return (int)ob_getf( obj );
        default:
            return -1;
    }
}

static int plist_len( struct param *p )
{
        if ( !p ) return 0;
        return 1 + plist_len( p->h );
}

static int elist_len( struct explist *el )
{
        if ( !el ) return 0;
        return 1 + elist_len( el->h );
}

static void do_args( int frame, struct param *p, struct explist *el )
{
    int plen, ellen;

    
    if ( !( p && el ) ) return; 

    plen = plist_len( p );
    ellen = elist_len( el );
   
    if ( plen > ellen ) {
            while( plen > ellen ) {
                    p = p->h;
                    plen--;
            }
    }
    else if ( plen < ellen ) {
            while( plen < ellen ) {
                    el = el->h;
                    plen++;
            }
    }
    
    do_args( frame, p->h, el ? el->h: NULL );
    if ( el && el->t ) {
        eval( ob_field( frame, p->t ), el->t );
#if  0      
        dump_expression( dbuf, sizeof(dbuf), el->t );
        ob_print( dbuf2, sizeof(dbuf2), ob_field( frame, p->t ));
        dbpr( "do_args, SP: %d, %s=%s : %s\n", StackPtr, atom_name(p->t), 
                dbuf, dbuf2 );
#endif        
    } else
        ob_set( ob_field( frame, p->t ), 's', "" );
}

static int makeargs( struct param *p, struct explist *el )
{
    int frame;
    
    frame = frame_alloc( Frames );
    ob_set( frame, 'i', 0 );
    do_args( frame, p, el );
    return frame;
}

static void push_args( int frame )
{
    is_push( Stack, frame );
}

static void pop_args( int frame )
{
    is_pop( Stack );
    frame_free( Frames, frame );
}

static int call( struct funpart f )
{
    int sys=0, frame, maxndx, cur, file, line, res;
    struct sourcefile *sf;
    struct command *fun;
    struct sysfun *sfun;
    
    if ( !f.h ) return -1;
    if ( f.h->type != 'n' ) return -2;
    if ( findfun( f.h->val.name, &file, &line )) {
        if ( (sfun = findsys( f.h->val.name )) == NULL ) 
            return -3;
        else
            sys = 1;
    }

    if ( sys ) {
        frame = makeargs( sfun->par, f.l );
        push_args( frame );
        if ( (res = sfun->fun()) != 0 ) {
                char buf[ 256 ];
                snprintf( buf, sizeof(buf), 
                                "fatal error %d in %s", res, atom_name( sfun->name ));
                fatal( buf );
        }
    }
    else {
        sf = findsrc( file );
        if ( !sf ) return -4;

        cur = line + 1;
        maxndx = sf->lt ? lt_maxindex( sf->lt ): -1;
        fun = lt_get( sf->lt, line );

        if ( !(fun && fun->type == CMD_FUNCTION) ) {
            fatal( "internal function call error" );
            return A_reg;
        }

        frame = makeargs( fun->cmd.cmd_function.par, f.l );
        push_args( frame );
        
        while( cur>=0 && cur<=maxndx ) {
            struct command *c;
            c = lt_get( sf->lt, cur );
            cur = run_cmd( cur, c, sf );
        }
    }
    
    pop_args( frame );

    return A_reg;     
}

/* refvar flags:  0 - all variables, 1 - defined local arguments only */
int refvar( int name, unsigned flags ) 
{
    int  top;
    
    top = is_top( Stack );
    if ( top )
        if ( ob_defined( top, name ))
            return refer( ob_field( top, name ));
    
    return (flags & 1) ? -1 : refer( ob_field( Globals, name ) );
}

static int find_objhead( struct object_part *p )
{
    int base, selector, a, b;
    
    if ( !p ) return -1;
    
    switch( p->type ) {
        case 'n':
            return refvar( p->val.name, 0 );
        case 'f':
            return call( p->val.f );
        case 't':
            base = find_objhead( p->val.t.h );
            a = tmp_alloc();
            selector = eval( a, p->val.t.e );
            selector = objtoint( selector );
            b = refer( ob_item( base, selector ) );
            tmp_free( a );
            return b;
    }
    
    return -1;
}

int deref( struct object *o ) 
{
    int base, selector, a;
    int res = -1;
    const char *name;
    struct object_part *p;
    
    if ( !o ) return -1;
    if ( o->h ) 
        base = deref( o->h );
    else {
        res = find_objhead( o->t );
        return res;
    }
    
    if ( !o->t ) {
        res = -1;
        return res;
    }
    
    base = refer( base );

    switch( o->t->type ) {
        case 'e':
            name = evalstr( o->t->val.e.e );
            res = ob_field( base, atom(name) );
            break;
        case 'n':
            res = ob_field( base, o->t->val.name );
            break;
        case 'f':
            return -1; 
        case 't':
            p = o->t;
            base = find_objhead( p->val.t.h );
            a = tmp_alloc();
            selector = eval( a, p->val.t.e );
            selector = objtoint( selector );
            res = ob_item( base, selector );
            tmp_free( a );
            break;
    }
    
    return refer( res );
}

int makearray( int reg, struct explist *l )
{
    int count = l->h ? makearray( reg, l->h ): 0;
    eval( ob_item( reg, count ), l->t );
    return count+1;        
}

void makerecord( int reg, struct fldlist *l )
{
    if ( !l ) return;
    eval( ob_field( reg, l->name ), l->e );
    makerecord( reg, l->h );
}

int select_obj( struct expression *e )
{
    int res;
    if ( !e ) return -1;
   
    switch ( e->type ) {
        case 'a':
            res = ob_item(Const, e->val.a.reg);
            ob_set( res, 'i', 0 );
            makearray( res, e->val.a.l );
            break;
        case 'r':
            res = ob_item(Const, e->val.a.reg);
            ob_set( res, 'i', 0 );
            makerecord( res, e->val.r.l );
            break;
        case 'o':
            res = deref( e->val.o );
            break;
        default:
            res = -1;
    }
   
    return res;
}

void set_objval( int reg, int a, int b )
{
    int i;
    double f;
    char *s;
   
    a = refer( a );
    b = refer( b );

    if ( b && b==a ) a = 0;
    else if ( reg && reg==b ) reg = 0;
    else 
        switch( ob_type( b ) ) {
            case 'i':
                i = ob_geti( b );
                if ( a > 0 ) ob_set( a, 'i', i );
                if ( reg > 0 ) ob_set( reg, 'i', i );
                break;
            case 'f':
                f = ob_getf( b );
                if ( a > 0 ) ob_set( a, 'f', f );
                if ( reg > 0 ) ob_set( reg, 'f', f );
                break;
            case 's':
                s = ob_gets( b );
                if ( a > 0 ) ob_set( a, 's', s );
                if ( reg > 0 ) ob_set( reg, 's', s );
                break;
            default:
                if ( a > 0 )     ob_set( a, 'R', b );
                if ( reg > 0 )   ob_set( reg, 'R', b );
        }
}

static void objcmp( int reg, int a, char op, int b )
{
    int atype, btype;
    int floatmode;
    
    int cmp, x, y;
    float fx, fy;
    
    a = refer( a );
    b = refer( b );
    
    atype = ob_type( a );
    btype = ob_type( b );
    
    if ( atype=='s' && btype =='s' ) {
        struct strbuf *sa, *sb;
        sa = new_strbuf( 256, 256 );
        sb = new_strbuf( 256, 256 );
        sb_cat( sa, ob_gets(a), 0x7ffffff0 );
        sb_cat( sb, ob_gets(b), 0x7ffffff0 );
        cmp = strcmp( sb_data(sa), sb_data(sb) );
        free_strbuf(sa);
        free_strbuf(sb);
    }
    else {
        floatmode = (atype=='f' || btype=='f');

        if ( floatmode ) {
            switch( atype ) {
                case 'i':
                    fx = ob_geti( a );
                    break;
                case 'f':
                    fx = ob_getf( a );
                    break;
                case 's':
                    fx = atof( ob_gets( a ) );
                    break;
                case 'a':
                case 'r':
                    fx = ob_count( a );
                    break;
            }
            switch( btype ) {
                case 'i':
                    fy = ob_geti( b );
                    break;
                case 'f':
                    fy = ob_getf( b );
                    break;
                case 's':
                    fy = atof( ob_gets( b ) );
                    break;
                case 'a':
                case 'r':
                    fy = ob_count( b );
                    break;
            }
            cmp = (fx>fy) ? 1: ( (fx<fy) ? -1: 0 );
        }
        else {
            switch( atype ) {
                case 'i':
                    x = ob_geti( a );
                    break;
                case 's':
                    x = atoi( ob_gets( a ) );
                    break;
                case 'a':
                case 'r':
                    x = ob_count( a );
                    break;
            }
            switch( btype ) {
                case 'i':
                    y = ob_geti( b );
                    break;
                case 's':
                    y = atoi( ob_gets( b ) );
                    break;
                case 'a':
                case 'r':
                    y = ob_count( b );
                    break;
            }
            cmp = (x>y) ? 1: ( (x<y) ? -1: 0 );

        }
    }
    
    switch( op ) {
        case 'e':
            ob_set( reg, 'i', (cmp==0) );
            break;
        case '<':
            ob_set( reg, 'i', (cmp<0) );
            break;
        case '>':
            ob_set( reg, 'i', (cmp>0) );
            break;
        case '!':
            ob_set( reg, 'i', (cmp!=0) );
            break;
        case 'l':
            ob_set( reg, 'i', (cmp<=0) );
            break;
        case 'g':
            ob_set( reg, 'i', (cmp>=0) );
            break;
    }
}

void objinc( int obj, int inc )
{
    switch( ob_type( obj ) ) {
        case 'i':
            ob_set( obj, 'i', ob_geti(obj)+inc );
            break;
        case 'f':
            ob_set( obj, 'f', ob_getf(obj)+inc );
            break;
    }
}

void eval_exp( int reg, struct expression *a, char op, struct expression *b )
{
    int A, B, obj;
    
    switch( op ) {
        case '+':
        case '-':
        case '*':
        case '/':
            A = tmp_alloc();
            B = tmp_alloc();
            eval( A, a );
            eval( B, b );
            eval_arith( reg, A, op, B );
            tmp_free( A );
            tmp_free( B );
            break; 
        case '=':
            obj = select_obj( a );
            B = tmp_alloc();
            B = eval( B, b );
            set_objval( reg, obj, B );
            tmp_free( B );
            break;
        case '1':
        case '2':
        case '3':
        case '4':
            A = tmp_alloc();
            B = tmp_alloc();
            obj = select_obj( a );
            A = eval( A, a );
            B = eval( B, b );
            eval_arith( reg, A, "*/+-"[op-'1'], B );
            set_objval( 0, obj, reg );
            tmp_free( A );
            tmp_free( B );
            break;
        case 'e':
        case '<':
        case '>':
        case '!':
        case 'l':
        case 'g':
            A = tmp_alloc();
            B = tmp_alloc();
            eval( A, a );
            eval( B, b );
            objcmp( reg, A, op, B );
            tmp_free( A );
            tmp_free( B );
            break;
        case '|':
        case '&':
            A = tmp_alloc();
            B = tmp_alloc();
            eval( A, a );
            eval( B, b );
            ob_set( reg, 'i', 
                   (op=='|') ? (istrue(A)||istrue(B)) :
                               (istrue(A)&&istrue(B))); 
            tmp_free( A );
            tmp_free( B );
            break;
        case 'i':
            A = select_obj( a );
            set_objval( reg, 0, A );
            objinc( A, +1 );
            break;
        case 'd':
            A = select_obj( a );
            set_objval( reg, 0, A );
            objinc( A, -1 );
            break;
        case 'I':
            A = select_obj( a );
            objinc( A, +1 );
            set_objval( reg, 0, A );
            break;
        case 'D':
            A = select_obj( a );
            objinc( A, -1 );
            set_objval( reg, 0, A );
            break;
        case 'n':
            B = tmp_alloc();
            eval( B, b );
            A = istrue( B );
            ob_set( B, 'i', !A );
            set_objval( reg, 0, B );
            tmp_free( B );
            break;
            
    }
}

int eval( int reg, struct expression *e )
{
#if  DEBUG
    char dbuf[ 2048 ];
#endif    
    int obj;
    
    if ( !eval_initialized ) init_eval();
    if ( !e ) return -1;
    
    if ( reg <= 0 ) reg = A_reg;

#if  DEBUG
    dump_expression( dbuf, sizeof(dbuf), e );
    dbpr( "eval( %d, %s )\n", reg, dbuf );
#endif    
    
    switch( e->type ) {
        case 'a':
        case 'r':
            obj = select_obj( e );
            set_objval( reg, 0, obj );
            return reg;
        case 'i':
            ob_set( reg, 'i', e->val.i );
            return reg;
        case 'f':
            ob_set( reg, 'f', e->val.f );
            return reg;
        case 's':
            ob_set( reg, 's', e->val.s );
            return reg;
        case 'o':
            obj = select_obj( e );
            if ( obj<0 ) 
                warning( "warning: uninitialized object" );

            set_objval( reg, 0, obj );
            dbpr( "eval result: %d=%s\n", reg, print_obj(reg) );
            return reg;
            break;
        case '+':
            eval_exp( reg, e->val.oper.a, e->val.oper.op, 
                    e->val.oper.b );
            return reg;
    }

    return -1;
}

const char *evalstr( struct expression *e )
{
    int res;

    res = eval( 0, e ); 
    return print_obj( res );
}

int istrue( int obj )
{
    int type;
   
    obj = refer( obj );
    type = ob_type( obj );
    switch( type ) {
        case 'i':
            return ob_geti( obj ) != 0;
        case 'f':
            return ob_getf( obj ) != 0.0;
        default:
            return 0;
    }
}

void setret( struct expression *e )
{
    eval( A_reg, e );
}

void setrets( const char *s )
{
    ob_set( A_reg, 's', s );
}

void setreti( int i )
{
    ob_set( A_reg, 'i', i );
}

void setretf( double x )
{
    ob_set( A_reg, 'f', x );
}

void setreti( int );

static int makearglis( int frame, struct explist *l )
{
    int n;
    if ( !l ) return 0;
    
    if ( l->h ) {
        int res;
        res = makearglis( frame, l->h );
        if ( res ) return res;
    }

    if ( !l->t ) return -1;      /* explist malformed */
    n = ob_count( frame );
    set_objval( 0, ob_item( frame, n ), eval( 0, l->t ));
    return 0;
}

int find_case( int obj, struct caselist *cl )
{
#if DEBUG    
    char dbuf[ 128 ];
#endif    
    int A, B, eq;
    
    if ( !( cl && cl->e ) ) return -1;
    A = tmp_alloc();
    B = tmp_alloc();
#if DEBUG    
    dump_expression( dbuf, sizeof(dbuf), cl->e );
    dbpr( "find_case, exp: %s\n", dbuf );
#endif    
    eval( A, cl->e );
    dbpr( "find_case, compare: %d==%d %s==%s\n", obj, A, print_obj(obj), print_obj(A));
    objcmp( B, A, 'e', obj );
    eq = istrue( B );
    tmp_free( A );
    tmp_free( B );
    if ( eq ) return cl->line;
    return find_case( obj, cl->h );
}

void create_local( int name )
{
    int top;
    
    top = is_top( Stack );
    if ( top ) ob_field( top, name );
}
