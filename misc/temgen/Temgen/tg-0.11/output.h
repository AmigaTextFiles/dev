#ifndef __output_h_
#define __output_h_

void setout( int name, int embed );   /* change output destination to given file or embed point */
void writeout( const char* );    /* output string                           */
void embed( int );               /* declare embed point in current output   */
void setemb( int );              /* change output to given embed            */ 
int  closeout( void );           /* flush and close all output              */

void push_out( void );
void pop_out( void );

#endif
