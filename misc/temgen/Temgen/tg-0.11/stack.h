#ifndef __stack_h_
#define __stack_h_

/* temporary objects stack manipulation */

void stinit( int stack );
int stalloc( void );
void stfree( int obj );

#endif
