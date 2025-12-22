#ifndef __lintab_h_
#define __lintab_h_

struct lintab;

struct lintab *new_lintab( int size, int delta );
void free_lintab( struct lintab* );

int lt_set( struct lintab*, int, void* );
void *lt_get( struct lintab*, int );
int lt_maxindex( struct lintab* );

#endif
