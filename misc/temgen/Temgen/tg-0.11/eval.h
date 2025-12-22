#ifndef __eval_h_
#define __eval_h_

#include "structs.h"

int system_obj( void );
const char *evalstr( struct expression* );
int eval( int reg, struct expression* );
int istrue( int obj );
void setret( struct expression* ); 
void setrets( const char* );
void setreti( int );
void setretf( double );
int select_obj( struct expression* );

/* refvar flags:  0 - all variables, 1 - defined local arguments only */
int refvar( int name, unsigned flags );

int nextreg( void );
int find_case( int, struct caselist* );

/* create local variable */
void create_local( int name );

/* temporary objects allocation */
int tmp_alloc( void );
void tmp_free( int obj );

#endif
