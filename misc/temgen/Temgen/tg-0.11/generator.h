#ifndef __generator_h_
#define __generator_h_

/*** generator structures manipulation ***/

#include "structs.h"

struct object;
struct object_part;
struct expression;
struct explist;
struct paramlist;
struct caselist;
struct command;
struct forctl; 
struct fldlist;

/* objects */

struct object *new_object( struct object*, struct object_part* ); 

struct object_part *new_part( const char *name );
struct object_part *new_fun( struct object_part*, struct explist* );
struct object_part *new_tab( struct object_part*, struct expression* );
struct object_part *new_exppart( struct expression* );

/* expressions */

struct explist *new_explist( struct explist*, struct expression* );
struct fldlist *new_fldlist( struct fldlist*, const char*, struct expression* );

struct expression *new_num( int );
struct expression *new_inc( struct expression*, int, int );
struct expression *new_float( float );
struct expression *new_string( const char* );
struct expression *new_objexp( struct object* );
struct expression *new_exp( struct expression*, char op, struct expression* ); 
struct expression *new_array( struct explist* );
struct expression *new_record( struct fldlist* );

/* commands */
struct command *new_if( struct expression*, int else_line, int end_line );
struct command *new_goto( int line );
struct command *new_embed( struct expression* ); 
struct command *new_emit( struct expression* ); 
struct command *new_exit( struct expression* ); 
struct command *new_output( struct expression* ); 
struct command *new_local( const char *name ); 
struct command *new_use( const char *name ); 
struct command *new_function( const char *name, struct paramlist*, int end_line );
struct paramlist *new_parlist( struct paramlist*, const char *param );

struct command *new_switch( struct expression*, struct caselist*, 
        int start_line, int end_line );
struct caselist *new_caselist( struct caselist*, struct expression*, int line );
struct command *new_for( struct forctl*, int start_line, int end_line );
struct forctl *new_forctl( struct expression*, 
        struct expression*, struct expression* );
struct forctl *new_lforctl( struct expression*, struct expression* );
struct command *new_return( struct expression* );
struct command *new_break( int );
struct command *new_push( void );
struct command *new_pop( void );
struct command *new_cmdexp( struct expression* );
struct command *build_lcmd_c( struct command*, int start, int end );
struct command *build_lcmd_e( struct command*, struct expression*, 
                int start, int end );

void add_cmd( struct lintab*, int line, struct command *c );
void close_line( int line, int end );


/* interpreter */
int run_cmd( int index, struct command*, struct sourcefile* );

/* debugging and testing functions */
void dump_expression( char *buf, int size, struct expression* );
void dump_cmd( int line, struct command* );

void warning( const char *msg );
void fatal( const char *msg );

#endif
