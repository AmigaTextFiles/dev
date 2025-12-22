#include "sysdefs.h"

#include "alloc.h"
#include "crc.h"
#include "list.h"
#include "atom.h"

#define   HSIZE     419

struct atomstr {
    struct list_head name_list;
    struct list_head id_list;
    int id;
    char *name;
};

static int first_free = 0;
static struct list_head name_hash[ HSIZE ];
static struct list_head id_hash[ HSIZE ];
    
static void init_atoms()
{
    int i;
    
    first_free = 1;
    
    for ( i=0; i<HSIZE; i++ ) {
        INIT_LIST_HEAD( name_hash + i );
        INIT_LIST_HEAD( id_hash + i );
    }
}

int atom( const char *name )
{
    unsigned hv;
    struct list_head *it;
    struct atomstr *a;
    
    if ( !first_free ) init_atoms();
    hv = crc32_0( name ) % HSIZE;
    
    for ( it = name_hash[ hv ].next; it != name_hash+hv; it = it->next ) {
        a = list_entry( it, struct atomstr, name_list );
        if ( !strcmp( a->name, name ) ) return a->id;
    }
    
    a = (struct atomstr*)MALLOC( sizeof(*a) );
    if ( !a ) return 0;
    
    a->id = first_free++;
    a->name = STRDUP( name );
    if ( !a->name ) {
        FREE( a );
        first_free--;
        return 0;
    }
    
    list_add( &( a->name_list ), name_hash + hv );
    list_add( &( a->id_list ), id_hash + (a->id % HSIZE) );
    return a->id;
}

const char *atom_name( int id )
{
    unsigned hv;
    struct list_head *it;
    struct atomstr *a;
    
    if ( id <= 0 ) return NULL;
    
    if ( !first_free ) init_atoms();
    hv = id % HSIZE;
    
    for ( it = id_hash[ hv ].next; it != id_hash+hv; it = it->next ) {
        a = list_entry( it, struct atomstr, id_list );
        if ( a->id == id ) return a->name;
    }
    
    return NULL;
}
