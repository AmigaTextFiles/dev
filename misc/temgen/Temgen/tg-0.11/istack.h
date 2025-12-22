#ifndef __istack_h_
#define __istack_h_

/* int stack */

struct istack *is_init( void );
void is_push( struct istack*, int );
int  is_top( struct istack* );
int  is_pop( struct istack* );

#endif
