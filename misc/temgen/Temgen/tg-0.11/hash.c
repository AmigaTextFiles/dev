#include "alloc.h"
#include "hash.h"
#include "list.h"
#include "sysdefs.h"

struct hash {
    unsigned size;
    hash_fun *hf;
    hash_compare *hc;
    struct list_head *tab;
};

struct hash_item {
    struct list_head list;
    void *data;
};

struct hash *new_hash( unsigned size, hash_fun *hf, hash_compare *hc )
{
    int i;
    struct hash *h = (struct hash*)CALLOC( 1, sizeof(*h) );
    if ( h ) {
        h->size = size;
        h->hf = hf;
        h->hc = hc;
        h->tab = (struct list_head*)CALLOC( size, sizeof(h->tab[0]));
        if ( !h->tab ) {
            FREE( h );
            return NULL;
        }
        
        for ( i=0; i<size; i++ )
            INIT_LIST_HEAD( h->tab + i );
    }
    
    return h;
}

void free_hash( struct hash *h )
{
    if ( h ) {
        if ( h->tab ) {
            unsigned i;
            for ( i=0; i<h->size; i++ ) 
                while( h->tab[ i ].next != h->tab+i ) {
                    struct hash_item *it;
                    it = list_entry( h->tab[ i ].next, struct hash_item, list );
                    list_del( h->tab[ i ].next );
                    FREE( it );
                }
        }
        free( h );
    }
}

int h_add( struct hash *h, void *data )
{
    unsigned hv;
    struct list_head *p;
    struct hash_item *it;
    
    if ( !( h && data ) ) return -1;
 
    hv = h->hf( data ) % h->size;
    for ( p=h->tab[ hv ].next; p != h->tab+hv; p = p->next ) {
        it = list_entry( p, struct hash_item, list );
        if ( h->hc( it->data, data ) == 0 ) return 2;
    }
   
    it = (struct hash_item*)MALLOC( sizeof(*it) );
    if ( it ) {
        it->data = data;
        list_add( &it->list, h->tab + hv );
        return 0;
    }
    else return 1;
}

int h_del( struct hash *h, const void *data )
{
    unsigned hv;
    struct list_head *p;
    struct hash_item *it;
    
    if ( !( h && data ) ) return -1;
 
    hv = h->hf( data ) % h->size;
    for ( p=h->tab[ hv ].next; p != h->tab+hv; p = p->next ) {
        it = list_entry( p, struct hash_item, list );
        if ( h->hc( it->data, data ) == 0 ) {
            list_del( &it->list );
            FREE( it );
            return 0;
        }
    }
    
    return 1;
}

void *h_get( struct hash *h, const void *data )
{
    unsigned hv;
    struct list_head *p;
    struct hash_item *it;
    
    if ( !( h && data ) ) return NULL;
 
    hv = h->hf( data ) % h->size;
    for ( p=h->tab[ hv ].next; p != h->tab+hv; p = p->next ) {
        it = list_entry( p, struct hash_item, list );
        if ( h->hc( it->data, data ) == 0 ) {
            struct hash_item *it;
            it = list_entry( p, struct hash_item, list );
            return it->data;
        }
    }
    
    return NULL;
    
}

int h_foreach( struct hash *h, int (*fun)(void*) )
{
    int res;
    unsigned i;
    struct list_head *p;
    struct hash_item *it;
    
    if ( h && !fun ) return -1;
    if ( !h ) return 0;
    
    for ( i=0; i<h->size; i++ ) {
        for ( p=h->tab[ i ].next; p != h->tab+i; p = p->next ) {
            it = list_entry( p, struct hash_item, list );
            if ( (res = fun( it->data )) != 0 ) return res;
        }
    }
    
    return 0;
}
