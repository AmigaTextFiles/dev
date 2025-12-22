#ifndef __func_h_
#define __func_h_

#include "structs.h"

int regfun( const char *name, int file, int line );
int findfun( int name, int *file, int *line );
struct sysfun *findsys( int name );

#endif
