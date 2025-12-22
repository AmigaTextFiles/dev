#ifndef __txttab_h_
#define __txttab_h_

struct txttab;

struct txttab *new_txttab( int size, int delta );
void free_txttab( struct txttab* );

/* push piece of text */
int tt_token( struct txttab*, const char* );

/* store line in table */
int tt_store( struct txttab*, int line );

/* find line */
const char *tt_find( struct txttab*, int line );

#endif
