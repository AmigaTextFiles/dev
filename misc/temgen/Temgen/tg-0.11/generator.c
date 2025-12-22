#include "alloc.h"
#include "atom.h"
#include "break.h"
#include "debug.h"
#include "eval.h"
#include "generator.h"
#include "omani.h"  
#include "output.h"
#include "sysdefs.h"
#include "strbuf.h"
#include "use.h"
#include "util.h"  

extern struct txttab *text_table;
extern struct lintab *line_table;

/* runtime variables */
int  cur_cmd = 0;
int  cur_file = 0;



struct object *new_object( struct object *h, struct object_part *t ) 
{
    struct object *ob;

    ob = (struct object*)MALLOC( sizeof(*ob) );
    if ( ob ) {
        ob->h = h;
        ob->t = t;
    }

    return ob;
}

struct object_part *new_part( const char *name )
{
    struct object_part *p;

    p = (struct object_part*)MALLOC( sizeof(*p) );
    if ( p ) {
        p->type = 'n';
        p->val.name = atom( name );
    }

    return p;
}

struct object_part *new_fun( struct object_part *f, struct explist *l )
{
    struct object_part *p;

    p = (struct object_part*)MALLOC( sizeof(*p) );
    if ( p ) {
        p->type = 'f';
        p->val.f.h = f;
        p->val.f.l = l;
    }

    return p;
}

struct object_part *new_tab( struct object_part *t, struct expression *e )
{
    struct object_part *p;

    p = (struct object_part*)MALLOC( sizeof(*p) );
    if ( p ) {
        p->type = 't';
        p->val.t.h = t;
        p->val.t.e = e;
    }

    return p;
}

struct object_part *new_exppart( struct expression *e )
{
    struct object_part *p;

    p = (struct object_part*)MALLOC( sizeof(*p) );
    if ( p ) {
        p->type = 'e';
        p->val.e.e = e;
    }

    return p;
}

struct explist *new_explist( struct explist *h, struct expression *t )
{
    struct explist *l;

    l = (struct explist*)MALLOC( sizeof( *l ) );
    if ( l ) {
        l->h = h;
        l->t = t;
    }

    return l;
}

struct fldlist *new_fldlist( struct fldlist *h, const char *name,
        struct expression *e )
{
    struct fldlist *l;

    l = (struct fldlist*)MALLOC( sizeof( *l ) );
    if ( l ) {
        l->h = h;
        l->name = atom( name );
        l->e = e;
    }

    return l;
}

struct expression *new_inc( struct expression *e, int inc, int post )
{
    return new_exp( e, (inc== +1)?(post ? 'i': 'I'):(post ? 'd': 'D'), 0 );
}

struct expression *new_num( int n )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = 'i';
        e->val.i = n;
    }

    return e;
}

struct expression *new_float( float x )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = 'f';
        e->val.f = x;
    }

    return e;
}

struct expression *new_string( const char *s )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = 's';
        e->val.s = STRDUP( unquote(s) );
    }

    return e;
}

struct expression *new_objexp( struct object *o )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = 'o';
        e->val.o = o;
    }

    return e;
}

struct expression *new_array( struct explist *l )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = 'a';
        e->val.a.reg = nextreg();
        e->val.a.l = l;
    }

    return e;
}

struct expression *new_record( struct fldlist *l )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = 'r';
        e->val.r.reg = nextreg();
        e->val.r.l = l;
    }

    return e;
}

struct expression *new_exp( struct expression *a, char op, 
        struct expression *b )
{
    struct expression *e;

    e = (struct expression*)MALLOC( sizeof(*e) );
    if ( e ) {
        e->type = '+';
        e->val.oper.a = a;
        e->val.oper.b = b;
        e->val.oper.op = op;
    }

    return e;
}

struct command *new_if( struct expression *cond, int else_line, int end_line )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_IF;
        cmd->cmd.cmd_if.cond = cond;
        cmd->cmd.cmd_if.else_line = else_line;
        cmd->cmd.cmd_if.end_line = end_line;
    }

    return cmd;
}

struct command *new_goto( int line )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_GOTO;
        cmd->cmd.cmd_goto.line = line;
    }

    return cmd;
}

struct param *make_param( struct paramlist *pl )
{
    struct param *p;
    if ( !pl ) return NULL;

    p = (struct param*)MALLOC( sizeof(*p) );
    if ( p ) {
        p->t = atom( pl->t );
        if ( pl->t ) FREE( pl->t );
        p->h = make_param( pl->h );
    }

    FREE( pl );
    return p;
}

struct command *new_function( const char *name, struct paramlist *pl, int end_line )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_FUNCTION;
        cmd->cmd.cmd_function.name = atom( name );
        cmd->cmd.cmd_function.par = make_param( pl );
        cmd->cmd.cmd_function.end_line = end_line;
    }

    return cmd;
}

struct paramlist *new_parlist( struct paramlist *pl, const char *param )
{
    struct paramlist *res;

    res = (struct paramlist*)MALLOC( sizeof(*res) );
    if ( res ) {
        res->h = pl;
        res->t = STRDUP( param );
    }

    return res;
}

struct command *new_switch( struct expression *cond, struct caselist *cl,
       int start_line, int end_line )
{
    struct command *cmd;
    int brk;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_SWITCH;
        cmd->cmd.cmd_switch.cond = cond;
        cmd->cmd.cmd_switch.cl = cl;
        cmd->cmd.cmd_switch.end_line = end_line;
    }

    while( 1 ) {
        brk = brk_pop();
        if ( brk <= start_line || brk >= end_line ) {
            if ( brk >= 0 ) brk_push( brk );
            break;
        }
        
        add_cmd( line_table, brk, new_goto( end_line ));
    }

    return cmd;
}

struct caselist *new_caselist( struct caselist *cl, 
        struct expression *e, int line )
{
    struct caselist *res;

    res = (struct caselist*)MALLOC( sizeof(*res) );
    if ( res ) {
        res->h = cl;
        res->e = e;
        res->line = line;
    }

    return res;
}

struct command *new_for( struct forctl *ctl, int start_line, int end_line )
{
    struct command *cmd;
    int brk;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_FOR;
        if ( ctl ) {
            cmd->cmd.cmd_for.ctl = *ctl;
            FREE( ctl );
        }
        cmd->cmd.cmd_for.end_line = end_line;
    }
    
    while( 1 ) {
        brk = brk_pop();
        if ( brk <= start_line || brk >= end_line ) {
            if ( brk >= 0 ) brk_push( brk );
            break;
        }
        
        add_cmd( line_table, brk, new_goto( end_line+1 ));
    }

    return cmd;
}

struct forctl *new_forctl( struct expression *e1,
        struct expression *e2, struct expression *e3 )
{
    static struct expression true;
    struct forctl *ctl;

    if ( !e2 ) {
        true.type = 'i';
        true.val.i = 1;
        e2 = &true;
    }
    
    ctl = (struct forctl*)MALLOC( sizeof(*ctl) );
    if ( ctl ) {
        ctl->type = 'c';
        ctl->val.c.e1 = e1;
        ctl->val.c.e2 = e2;
        ctl->val.c.e3 = e3;
    }

    return ctl;
}

struct forctl *new_lforctl( struct expression *i, struct expression *obj )
{
    struct forctl *ctl;

    ctl = (struct forctl*)MALLOC( sizeof(*ctl) );
    if ( ctl ) {
        ctl->type = 'l';
        ctl->val.l.i = i;
        ctl->val.l.obj = obj;
    }

    return ctl;
}

struct command *new_return( struct expression *e )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_RETURN;
        cmd->cmd.cmd_exp.e = e;
    }

    return cmd;
}

struct command *new_embed( struct expression *e )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_EMBED;
        cmd->cmd.cmd_exp.e = e;
    }

    return cmd;
}

struct command *new_emit( struct expression *e )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_EMIT;
        cmd->cmd.cmd_exp.e = e;
    }

    return cmd;
}

struct command *new_exit( struct expression *e )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_EXIT;
        cmd->cmd.cmd_exp.e = e;
    }

    return cmd;
}

struct command *new_output( struct expression *e )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_OUTPUT;
        cmd->cmd.cmd_exp.e = e;
    }

    return cmd;
}

struct command *new_local( const char *name )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_LOCAL;
        cmd->cmd.cmd_local.name = atom( name );
    }

    return cmd;
}

struct command *new_use( const char *name )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_USE;
        do_use( cmd->cmd.cmd_use.name = atom( name ) );
    }

    return cmd;
}

struct command *new_break( int line )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_BREAK;
    }
    
    brk_push( line );
    
    return cmd;
}

struct command *new_push( void )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_PUSH;
    }
    
    return cmd;
}

struct command *new_pop( void )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_POP; 
    }
    
    return cmd;
}

struct command *new_cmdexp( struct expression *e )
{
    struct command *cmd;

    cmd = (struct command*)MALLOC( sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_EXP;
        cmd->cmd.cmd_exp.e = e;
    }

    return cmd;
}

int lcmd_add_c( struct command *cmd, int start, int end )
{
    int n;

    n = cmd->cmd.cmd_data.count;

    if ( cmd->cmd.cmd_data.size <= n ) {
        struct dataitem *old;
        old = cmd->cmd.cmd_data.tab; 
        cmd->cmd.cmd_data.size += 4;           /* TODO tune it ! */
        cmd->cmd.cmd_data.tab = (struct dataitem*)REALLOC( old, 
                cmd->cmd.cmd_data.size * sizeof(cmd->cmd.cmd_data.tab[0]));
        if ( !cmd->cmd.cmd_data.tab ) {
            cmd->cmd.cmd_data.tab = old;
            cmd->cmd.cmd_data.size -= 4;
            return -1;
        }
    }

    cmd->cmd.cmd_data.count++;
    cmd->cmd.cmd_data.tab[ n ].start = start;
    cmd->cmd.cmd_data.tab[ n ].end = end;
    cmd->cmd.cmd_data.tab[ n ].exp = NULL;
    return 0;
}

struct command *build_lcmd_c( struct command *cmd, int start, int end )
{
    int n;

    if ( !cmd ) cmd = (struct command*)CALLOC( 1, sizeof(*cmd) );
    if ( cmd ) {
        cmd->type = CMD_DATA;
        n = cmd->cmd.cmd_data.count; 

        if ( n == 0 && start!=0 ) {
            /* add empty slot starting from begin of line */
            if ( lcmd_add_c( cmd, 0, 1 ) ) return NULL;
            n = cmd->cmd.cmd_data.count;
        }

        if ( n ) {  
            if ( cmd->cmd.cmd_data.tab[ n-1 ].exp == 0 )
                cmd->cmd.cmd_data.tab[ n-1 ].end = end;
            else {
                if ( start > cmd->cmd.cmd_data.tab[ n-1 ].end )
                    start = cmd->cmd.cmd_data.tab[ n-1 ].end;   
                lcmd_add_c( cmd, start, end );
            }
        } else 
            lcmd_add_c( cmd, start, end );
    }

    return cmd;
}

int lcmd_add_e( struct command *cmd, struct expression *e,
        int start, int end )
{
    int n;

    n = cmd->cmd.cmd_data.count;
    if ( cmd->cmd.cmd_data.size <= n ) {
        struct dataitem *old;
        old = cmd->cmd.cmd_data.tab; 
        cmd->cmd.cmd_data.size += 4;           /* TODO tune it ! */
        cmd->cmd.cmd_data.tab = (struct dataitem*)REALLOC( old, 
                cmd->cmd.cmd_data.size * sizeof(cmd->cmd.cmd_data.tab[0]));
        if ( !cmd->cmd.cmd_data.tab ) {
            cmd->cmd.cmd_data.tab = old;
            cmd->cmd.cmd_data.size -= 4;
            return -1;
        }
    }

    cmd->cmd.cmd_data.count++;
    cmd->cmd.cmd_data.tab[ n ].start = start;
    cmd->cmd.cmd_data.tab[ n ].end = end;
    cmd->cmd.cmd_data.tab[ n ].exp = e;
    return 0;
}

struct command *build_lcmd_e( struct command *cmd, struct expression *e,
        int start, int end )
{
    if ( !cmd ) cmd = (struct command*)CALLOC( 1, sizeof(*cmd) );
    if ( cmd ) {
        int n = cmd->cmd.cmd_data.count;

        if ( n == 0 ) { 
            if ( start!=0 ) {
                /* add empty slot starting from begin of line */
                if ( lcmd_add_c( cmd, 0, start )) return NULL;
            }
        }
        else {
            if ( cmd->cmd.cmd_data.tab[ n-1 ].exp ) {
                /* add cmd_c between the two expressions */
                if ( cmd->cmd.cmd_data.tab[ n-1 ].end != start )
                    if ( lcmd_add_c( cmd, cmd->cmd.cmd_data.tab[ n-1 ].end,
                                start )) return NULL;
            }
            else {
                /* enlarge previous cmd_c if needed */
                cmd->cmd.cmd_data.tab[ n-1 ].end = start;
            }
        }

        cmd->type = CMD_DATA;
        lcmd_add_e( cmd, e, start, end );
    }

    return cmd;
}

void close_line( int line, int end )
{
    int n;
    struct command *cmd;

    cmd = (struct command*)lt_get( line_table, line );
    if ( cmd && cmd->type == CMD_DATA ) {
        struct dataitem *it;

        if ( (n = cmd->cmd.cmd_data.count) > 0 ) {
            it = cmd->cmd.cmd_data.tab + n-1;   
            if ( it->exp && it->end != end ) 
                lcmd_add_c( cmd, it->end, end );
            else 
                it->end = end;
        }
    }
}

int  run_data_cmd( struct command *c, const char *line )
{
    int i;
    static struct strbuf *buf = NULL;
    static int buflock = 0;
   
    if ( !( c && line ) ) return 0;
    
    if ( !buflock ) {
        if ( buf )
            sb_clear( buf );
        else
            buf = new_strbuf( 512, 512 );
    }

    if ( !buf ) return -1;
    buflock++;

    for ( i=0; i<c->cmd.cmd_data.count; i++ )  {
        struct dataitem *it;

        it = c->cmd.cmd_data.tab + i;
        if ( it->exp == 0 ) {
            sb_cat( (buflock!=1) ? NULL: buf, 
                    unescape(line + it->start, it->end - it->start),
                    it->end - it->start);
        } else  
            sb_cat( (buflock!=1) ? NULL: buf, 
                    evalstr(it->exp), 0x7ffffff0 );
    }

    buflock--;
    if ( !buflock ) writeout( sb_data(buf) );
    return 0;
}

int run_if( struct command *c, int start_line, struct sourcefile *sf )
{
    int A, obj;
    
    A = tmp_alloc();
    obj = eval( A, c->cmd.cmd_if.cond );
    obj = istrue( obj );
    tmp_free( A );
    if ( obj ) 
        return start_line + 1;
    else 
        return c->cmd.cmd_if.else_line + 1;
}

int run_switch( struct command *c, struct sourcefile *sf )
{
    int obj, A;
    int line;
   
    A = tmp_alloc();
    obj = eval( A, c->cmd.cmd_switch.cond );
    line = find_case( obj, c->cmd.cmd_switch.cl );
    tmp_free( A );
    return (line >= 0) ? line: c->cmd.cmd_switch.end_line;
}

int run_for( struct command *c, int start_line, struct sourcefile *sf )
{
    int sel, i, obj, index, n;
    
    switch( c->cmd.cmd_for.ctl.type ) {
        case 'c':
            /* this is the classic C 'for' command instance */
            for( eval( 0, c->cmd.cmd_for.ctl.val.c.e1 ); 
                    istrue( eval( 0, c->cmd.cmd_for.ctl.val.c.e2 ) );
                    eval( 0, c->cmd.cmd_for.ctl.val.c.e3 )) {

                index = start_line+1;

                while( 1 ) {
                    struct command *cmd;
                    cmd = lt_get( sf->lt, index );
                    index = run_cmd( index, cmd, sf );

                    if ( index < start_line ||
                            index >= c->cmd.cmd_for.end_line ) 
                        break;
                }
                    
                if ( index > c->cmd.cmd_for.end_line ) /* @break */
                    break;
            }
            break;
        case 'l':
            obj = select_obj( c->cmd.cmd_for.ctl.val.l.obj );
            sel = select_obj( c->cmd.cmd_for.ctl.val.l.i ); 
            n = ob_count( obj );
            
            for ( i=0; i<n; i++ ) {
                int name = ob_fieldname( obj, i );
                if ( name <= 0 ) break;
                ob_set( sel, 's', atom_name(name) );
                
                index = start_line+1;

                while( 1 ) {
                    struct command *cmd;
                    cmd = lt_get( sf->lt, index );
                    index = run_cmd( index, cmd, sf );

                    if ( index < start_line ||
                            index >= c->cmd.cmd_for.end_line ) 
                        break;
                }
                
                if ( index > c->cmd.cmd_for.end_line ) /* @break */
                    break;
            }
            break;
    }
    
    return 0;
}

static void do_exit( struct expression *e )
{
    int a, typ;
    const char *s;
    int n;
    double x;
    
    if ( !e ) exit( 0 );
    a = tmp_alloc();
    eval( a, e );
    typ = ob_type( a );
    switch( typ ) {
        case 'i':
            exit( ob_geti(a) );
        case 'f':
            exit( ob_getf(a) );
            break;
        case 's':
            s = ob_gets(a);
            x = strtod( s, NULL );
            n = atoi( s );
            if ( n == x )
                exit( n );
            else
                exit( x );
            break;
        default:
            exit( 0 );
    }
}

int run_cmd( int index, struct command *c, struct sourcefile *sf )
{
    const char *line;
    if ( !c ) return index+1;
    
    cur_cmd = index;
    cur_file = sf ? sf->fname: 0;
    
    if ( debugger ) deb_cmd( index, c, sf );

    switch( c->type ) {
        case CMD_EMBED:
            line = evalstr( c->cmd.cmd_exp.e );
            embed( atom(line) );
            return index + 1;
        case CMD_EMIT:
            line = evalstr( c->cmd.cmd_exp.e );
            setemb( atom(line) );
            return index + 1;
        case CMD_OUTPUT:
            line = evalstr( c->cmd.cmd_exp.e );
            setout( atom(line), 0 );
            return index + 1;
        case CMD_EXP:
            eval( 0, c->cmd.cmd_exp.e );
            return index + 1;
        case CMD_FUNCTION:
            return c->cmd.cmd_function.end_line + 1;
        case CMD_IF:
            return run_if( c, index, sf );
        case CMD_SWITCH:
            return run_switch( c, sf );
        case CMD_FOR:
            if ( run_for( c, index, sf ) ) fatal( "fatal error in loop" );
            return c->cmd.cmd_for.end_line + 1;
        case CMD_DATA:
            line = tt_find( sf->tt, index );
            if ( run_data_cmd( c, line ) ) fatal( "fatal error generating data" );
            return index + 1;
        case CMD_GOTO:
            return c->cmd.cmd_goto.line;
        case CMD_PUSH:
            push_out();
            return index + 1;
        case CMD_POP: 
            pop_out();
            return index + 1;
        case CMD_RETURN:
            setret( c->cmd.cmd_exp.e );
            return -1;
        case CMD_LOCAL:
            create_local( c->cmd.cmd_local.name );
            return index + 1;
        case CMD_EXIT:
            do_exit( c->cmd.cmd_exp.e );
        default:
            return index + 1;
    }
}

void add_cmd( struct lintab *lt, int line, struct command *c )
{
    struct command *next;
    lt_set( lt, line, c );
    if ( c ) switch( c->type ) {
        case CMD_IF:
            next = new_goto( c->cmd.cmd_if.end_line + 1 );
            add_cmd( lt, c->cmd.cmd_if.else_line, next );
            break;
        case CMD_FUNCTION:
            next = new_return( NULL );
            add_cmd( lt, c->cmd.cmd_function.end_line, next );
            break;
    } 
}


#include <stdio.h>

void dump_explist( char *buf, int size, struct explist* );

void dump_part( char *buf, int size, struct object_part *p )
{
    int len;
    
    if ( !p ) {
        snprintf( buf, size, "[NULL]" );
        return;
    }

    switch( p->type ) {
        case 'n':
            snprintf( buf, size, atom_name( p->val.name ) );
            break;
        case 'f':
            dump_part( buf, size, p->val.f.h );
            len = strlen( buf );
            if ( len > size-6 ) break;
            strcat( buf, "( " );
            dump_explist( buf+len+2, size-len-2, p->val.f.l );
            len = strlen( buf );
            if ( len > size-3 ) break;
            strcat( buf, " )" );
            break;
        case 't':
            dump_part( buf, size, p->val.t.h );
            len = strlen( buf );
            if ( len > size-6 ) break;
            strcat( buf, "[ " );
            dump_expression( buf+len+2, size-len-2, p->val.t.e );
            len = strlen( buf );
            if ( len > size-3 ) break;
            strcat( buf, " ]" );
            break;
        default:
            snprintf( buf, size, "[%c:?]", p->type );
    }
}

void dump_obj( char *buf, int size, struct object *o )
{
    int len;
    
    if ( !o ) {
        snprintf( buf, size, "<NULL>" );
        return;
    }

    if ( o->h ) {
        dump_obj( buf, size, o->h );
        len = strlen( buf );
        if ( len > size-3 ) return;
        strcat( buf, "." );
    }
    else len = -1;

    dump_part( buf+len+1, size-len-1, o->t );
}

void dump_expression( char *buf, int size, struct expression *e )
{
    int len;
    
    if ( !e ) {
        snprintf( buf, size, "(NULL expression)" );
        return;
    }

    switch( e->type ) {
        case 'i':
            snprintf( buf, size, "%d", e->val.i );
            break;
        case 'f':
            snprintf( buf, size, "%f", e->val.f );
            break;
        case 's':
            snprintf( buf, size, "%s", e->val.s );
            break;
        case 'o':
            dump_obj( buf, size, e->val.o );
            break;
        case '+':
            snprintf( buf, size, "(" );
            dump_expression( buf+1, size-1, e->val.oper.a );
            len = strlen( buf );
            if ( len < size-8 ) {
                snprintf( buf+len, size-len, " %c ", e->val.oper.op );
                dump_expression( buf+len+3, size-len-3, e->val.oper.b );
                len = strlen( buf );
                if ( len < size-2 )
                    snprintf( buf + len, size-len, ")" );
            }
    }
}

void dump_explist( char *buf, int size, struct explist *l )
{
    int len;
    
    if ( !l ) {
        snprintf( buf, size, "(NULL)" );
        return;
    }

    if ( l->h ) {
        dump_explist( buf, size, l->h );
        len = strlen( buf );
        if ( len > size-4 ) return;
        strcat( buf, ", " );
    }
    else len = -2;

    dump_expression( buf+len+2, size-len-2, l->t );
}

void dump_param( struct param *p )
{
    if ( p ) {
        dump_param( p->h );
        if ( p->h ) printf( ", " );
        printf( "%s", atom_name( p->t ));
    }
}


#if 0 

void dump_caselist( struct caselist *cl )
{
    if ( !cl ) return;
    dump_caselist( cl->h );
    printf( "%d:@  case ", cl->line );
    dump_expression( cl->e );
    printf( " :\n" );
}

void dump_cmd( int line, struct command *c )
{
    if ( !c ) {
        printf( "(Null)\n" );
        return;
    }

    switch( c->type ) {
        case      CMD_IF:         
            printf( "@if " );
            dump_expression( c->cmd.cmd_if.cond );
            printf( "\nelse: line %d\ngoto: line %d\n", c->cmd.cmd_if.else_line,
                    c->cmd.cmd_if.end_line  );
            printf( "%d:@endif", c->cmd.cmd_if.end_line );
            printf( "\n" );
            break;
        case      CMD_FUNCTION:  
            printf( "@function %s(", atom_name(c->cmd.cmd_function.name) );
            dump_param( c->cmd.cmd_function.par );
            printf( ")\n" );
            printf( "%d:@endfunction\n", c->cmd.cmd_function.end_line );
            break;
        case      CMD_SWITCH:   
            printf( "@switch " );
            dump_expression( c->cmd.cmd_switch.cond );
            printf( "\n" );
            dump_caselist( c->cmd.cmd_switch.cl );
            printf( "%d:@endswitch", c->cmd.cmd_switch.end_line );
            printf( "\n" );
            break;
        case      CMD_FOR:     
            printf( "@for ( " );
            dump_expression( c->cmd.cmd_for.e1 ); printf( "; " );
            dump_expression( c->cmd.cmd_for.e2 ); printf( "; " );
            dump_expression( c->cmd.cmd_for.e3 ); 
            printf( " )\n" );
            printf( "%d:@endfor", c->cmd.cmd_for.end_line );
            printf( "\n" );
            break;
        case      CMD_RETURN: 
            printf( "@return " );
            dump_expression( c->cmd.cmd_return.e );
            printf( "\n" );
            break;
        case      CMD_BREAK: 
            printf( "@break" );
            printf( "\n" );
            break;
        case      CMD_EXP:  
            printf( "@exp:" );
            dump_expression( c->cmd.cmd_exp.e );
            printf( "\n" );
            break;
        case      CMD_DATA:
            printf( "%s", tt_find( text_table, line ));
            break;
    }
}
#endif

void warning( const char *msg )
{
        const char *fname;
        fname = atom_name( cur_file );
        if ( fname && fname[0] )
                fprintf( stderr, "%s:%d: %s\n", fname, cur_cmd, msg );
        else
                fprintf( stderr, "tg: %s\n", msg );
}

void fatal( const char *msg )
{
        warning( msg );
        exit( 1 );
}

