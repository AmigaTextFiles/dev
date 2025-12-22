#include "alloc.h"
#include "generator.h"
#include "list.h"
#include "stack.h"
#include "sysdefs.h"
#include "omani.h"

static int Stack = -1;
static int last_alloc = 0;
static struct list_head notused;      /* not used slots */

struct sitem {
    struct list_head list;
    int id;
};

void stinit( int stack )
{
    Stack = stack;
    INIT_LIST_HEAD( &notused );
}

int stalloc( void )
{
    int res;
    struct sitem *it;
    
    if ( Stack <= 0 ) return -1;
    
    /* look for recyclable entry */
    if ( notused.next != &notused ) {
        it = list_entry( notused.next, struct sitem, list );
        res = it->id;
        list_del( &it->list );
        FREE( it );
        return res;
    }
    
    res = ++last_alloc;
    return ob_item( Stack, res );
}

void stfree( int obj )
{
    struct sitem *it;
    
    if ( Stack <= 0 ) return;
    
    ob_set( obj, 'i', 0 );
    it = (struct sitem*)MALLOC( sizeof(*it) );
    if ( !it ) fatal( "Memory allocation error in 'stfree'" );
    it->id = obj;
    list_add( &it->list, &notused );
}
