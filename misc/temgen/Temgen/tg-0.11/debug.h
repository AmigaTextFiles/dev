#ifndef __debug_h_
#define __debug_h_

#include "structs.h"

extern int debugger;

char *debugp( const char *fmt, ... );
void  debout( const char *fmt, ... );
void  deb_cmd( int index, struct command*, struct sourcefile* );

#endif
