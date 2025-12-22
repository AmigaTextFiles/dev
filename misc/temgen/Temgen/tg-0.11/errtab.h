#ifndef __errtab_h_
#define __errtab_h_

void save_error( const char *fname, int line, const char *msg );
const char *next_errmsg( void );

#endif
