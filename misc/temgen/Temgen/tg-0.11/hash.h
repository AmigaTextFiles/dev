#ifndef __hash_h_
#define __hash_h_

struct hash;

typedef unsigned hash_fun( const void *data );
typedef int      hash_compare( const void *data1, const void *data2 );

struct hash *new_hash( unsigned size, hash_fun*, hash_compare* );
void free_hash( struct hash* );

int h_add( struct hash*, void *data );
int h_del( struct hash*, const void *data );
void *h_get( struct hash*, const void *data );
int h_foreach( struct hash*, int (*fun)(void*) );

#endif
