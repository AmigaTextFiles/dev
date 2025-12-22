#include "alloc.h"
#include "sysdefs.h"
#include "omani.h"
#include "list.h"

#define  DEF_HSIZE     2063   
#define  DEF_FHSIZE    2063   
#define  CHECK( err )  { if (!otab) inittable(); if (!otab) return err; }

/* array (list) of objects */
struct array {
    struct list_head list;         /* linked with *.parent fields       */
    struct list_head *cur;         /* current item, indexed with curndx */
    int curndx;                    /* index of *cur item */
    int count;                     /* total items number */  
};

/* main object data structure */
struct object {
    struct list_head list;         /* 'otab' hash table link, cannot be 0 */
    struct list_head parent;       /* link to list of siblings, can be 0  */
    int id;                        /* unique id  */       
    char type;                     /* '\0', 'i', 'f', 's', 'a', 'r',
                                      'R' - reference */
    union value {
        struct array *a;       /* for 'a' and 'r' objects           */
        int   i;
        float f;
        char *s;
    } val;
};

/* field of 'l'-typed object */
struct ofield {
    struct list_head list;         /* 'ftab' hash table link           */
    struct list_head parent;       /* link to object.val.a->list       */
    int obj, fld;
    struct object *data;
};

/* object hash table */
static unsigned hsize = DEF_HSIZE;
static struct list_head *otab = NULL;
static int last_obj = 0;
static int root_obj = 0;
/* field hash table */
static unsigned fhsize = DEF_FHSIZE;
static struct list_head *ftab = NULL;

static unsigned hval( int id )
{
    return ((unsigned)id) % hsize;
}

static unsigned fhval( int obj, int fld )
{
    return ((obj << 18) | fld) % fhsize;
}

int ob_sethsize( unsigned h, unsigned fh )
{
    if (otab || ftab) return -1;
    if ( h ) hsize = h;
    if ( fh ) fhsize = fh;
    return 0;
}

static void inittable( void )
{
    int i;
    otab = (struct list_head*)CALLOC( hsize, sizeof(otab[0]));
    if ( otab ) 
        for ( i=0; i<hsize; i++ )
            INIT_LIST_HEAD( otab+i );
    last_obj = 0;
    root_obj = 0;

    ftab = (struct list_head*)CALLOC( fhsize, sizeof(ftab[0]));
    if ( ftab ) 
        for ( i=0; i<fhsize; i++ )
            INIT_LIST_HEAD( ftab+i );
}

static struct object *create_object( void )
{
    struct object *ob;
    unsigned hv;

    CHECK( NULL );
    ob = (struct object*)MALLOC( sizeof(*ob) );
    if ( !ob ) return 0;
    memset( ob, 0, sizeof(*ob) );
    ob->id = ++last_obj;
    hv = hval( ob->id );
    list_add( &ob->list, otab+hv );
    return ob;
}

int ob_root( void )
{
    struct object *ob;
    if ( root_obj <= 0 ) {
        ob = create_object();
        root_obj = ob ? ob->id: 0;
    }
    return root_obj;
}

static struct object *find_object( int id )
{
    unsigned hv;
    struct list_head *p;
    struct object *ob;

    if ( !otab ) return NULL;
    hv = hval( id );
    for ( p=otab[ hv ].next; p != otab + hv; p = p->next ) {
        ob = list_entry( p, struct object, list );
        if ( ob->id == id ) return ob;
    }

    return NULL;
}


static void free_value( struct object* );

static void free_object( struct object *ob )
{
    if ( !ob ) return;
    if ( ob->list.next ) list_del( &ob->list );
    if ( ob->parent.next ) list_del( &ob->parent );
    free_value( ob );
    FREE( ob );
}

static void free_ofield( struct ofield *f )
{
    if ( f ) {
        if ( f->list.next ) list_del( &f->list );
        if ( f->parent.next ) list_del( &f->parent );
        if ( f->data ) free_object( f->data );
        FREE( f );
    }
}

static void free_array( int owner, struct array *a )
{
    if ( !a ) return;

    if ( owner ) {   /* 'r' type */
        if ( a->list.next ) {
            while( a->list.next != &a->list ) {
                struct ofield *f;
                f = list_entry( a->list.next, struct ofield, parent );
                free_ofield( f );
            }
        }
    }
    else {       /* 'a' array type */
        if ( a->list.next ) {
            while( a->list.next != &a->list ) {
                struct object *ob;
                ob = list_entry( a->list.next, struct object, parent );
                free_object( ob );
            }
        }
    }

    FREE( a );
}

static void free_value( struct object *ob )
{
    if ( ob ) {
        switch( ob->type ) {
            case 'a':
                if ( ob->val.a ) free_array( 0, ob->val.a );
                break;
            case 'r':
                if ( ob->val.a ) free_array( ob->id, ob->val.a );
                break;
            case 's':
                if ( ob->val.s ) FREE( ob->val.s );
                break;
        }

        ob->type = 0;
    }
}

int ob_set( int obj, char type, ... )
{
    va_list ap;
    struct object *ob;
    int i;
    float f;
    char *s;
    ob = find_object( obj );
    if ( !ob ) return -1;
    free_value( ob );
    va_start( ap, type );
    ob->type = type;
    switch( type ) {
        case 'R':
        case 'i':
            i = va_arg( ap, int );
            ob->val.i = i;
            break;
        case 'f':
            f = va_arg( ap, double );
            ob->val.f = f;
            break;
        case 's':
            s = va_arg( ap, char* );
            ob->val.s = STRDUP( s );
            if ( !ob->val.s ) { 
                ob->type = 0;
                va_end( ap );
                return -1;
            }
            break;
        default:
            ob->type = 0;
            va_end( ap );
            return -1;
    }

    va_end( ap );
    return 0;
}

static int arr_item( struct array *a, int index )
{
    struct object *ob;

    if ( !a ) return 0;
    if ( index < 0 || index >= a->count ) return 0;

    /* TODO - array item access optim. */
    a->cur = 0;
    if ( !a->cur ) {
        a->cur = a->list.next;
        a->curndx = 0;
    }

    if ( index > a->curndx ) {
        while( index > a->curndx ) {
            a->cur = a->cur->next;
            a->curndx++;
        }
    }
    else if ( index < a->curndx ) {
        while( index < a->curndx ) {
            a->cur = a->cur->prev;
            a->curndx--;
        }
    }

    if ( index == a->curndx ) {
        ob = list_entry( a->cur, struct object, parent );
        return ob->id;
    }

    return 0;
}

static int rec_item( struct array *a, int index )
{
    struct ofield *f;

    if ( !a ) return 0;
    if ( index < 0 || index >= a->count ) return 0;

    if ( !a->cur ) {
        a->cur = a->list.next;
        a->curndx = 0;
    }

    if ( index > a->curndx ) {
        while( index > a->curndx ) {
            a->cur = a->cur->next;
            a->curndx++;
        }
    }
    else if ( index < a->curndx ) {
        while( index < a->curndx ) {
            a->cur = a->cur->prev;
            a->curndx--;
        }
    }

    if ( index == a->curndx ) {
        f = list_entry( a->cur, struct ofield, parent );
        return f->fld;
    }

    return 0;
}

static int arr_append( struct array *a )
{
    struct object *ob;

    if ( !a ) return -1;
    ob = create_object();
    if ( !ob ) return -1;
    list_add( &ob->parent, a->list.prev );
    a->cur = a->list.prev;
    a->curndx = a->count++;
    /* TODO  */
    a->cur = 0;
    a->curndx = 0;
    return 0;
}

int ob_item( int obj, int index )
{
    struct object *ob;

    ob = find_object( obj );
    if ( !ob ) return 0; 

    if ( ob->type != 'a' ) {
        free_value( ob );
        ob->type = 'a';
        ob->val.a = (struct array*)MALLOC( sizeof(*ob->val.a) );
        if ( !ob->val.a ) {
            ob->type = 0;
            return 0;
        } 
        memset( ob->val.a, 0, sizeof( *ob->val.a ));
        INIT_LIST_HEAD( &ob->val.a->list );
    }

    if ( index < 0 ) return 0;
    while( index >= ob->val.a->count ) 
        if ( arr_append( ob->val.a )) return 0;

    return arr_item( ob->val.a, index );
}

char *ob_gets( int obj )
{
    struct object *ob;

    ob = find_object( obj );
    if ( !ob ) return NULL;

    return (ob->type == 's') ? ob->val.s: NULL;
}

int ob_geti( int obj )
{
    struct object *ob;

    ob = find_object( obj );
    if ( !ob ) return 0;

    return ob->val.i;
}

float ob_getf( int obj )
{
    struct object *ob;

    ob = find_object( obj );
    if ( !ob ) return 0;

    return ob->val.f;
}

char ob_type( int obj )
{
    struct object *ob;

    ob = find_object( obj );
    if ( !ob ) return 0;

    return ob->type;
}

int ob_count( int obj )
{
    struct object *ob;

    ob = find_object( obj );
    if ( !ob ) return 0;

    return (ob->type=='a' || ob->type=='r') ? ob->val.a->count: 0;
}

static struct ofield *create_field( int obj, int fld, unsigned hv )
{
    struct object *ob;
    struct ofield *f;
    
    ob = find_object( obj );
    if ( !ob ) return NULL;
    
    if ( ob->type != 'r' ) {
        free_value( ob );
        ob->type = 'r';
        ob->val.a = (struct array*)MALLOC( sizeof(*ob->val.a) );
        if ( !ob->val.a ) {
            ob->type = 0;
            return NULL;
        } 
        memset( ob->val.a, 0, sizeof( *ob->val.a ));
        INIT_LIST_HEAD( &ob->val.a->list );
    }
    
    f = (struct ofield*)MALLOC( sizeof(*f) );
    if ( !f ) return NULL;
    
    memset( f, 0, sizeof(*f) );
    f->obj = obj;
    f->fld = fld;
    f->data = create_object();
    if ( !f->data ) {
        FREE( f );
        return NULL;
    }
    
    list_add( &f->list, ftab+hv );
    list_add( &f->parent, &ob->val.a->list );
   /***** TODO  ***/
    ob->val.a->cur = ob->val.a->list.prev;
    ob->val.a->curndx = ob->val.a->count++; 
 /* ob->val.a->cur = 0;
    ob->val.a->curndx = 0;        */
    return f;
}

int ob_field( int obj, int fld )
{
    unsigned hv;
    struct list_head *p;
    struct ofield *f = NULL;
    
    if ( !( otab && ftab ) ) return 0;
    
    hv = fhval( obj, fld );
    for ( p=ftab[ hv ].next; p != ftab+hv; p = p->next ) {
        f = list_entry( p, struct ofield, list );
        if ( f->obj==obj && f->fld==fld ) break;
        f = NULL;
    }
    
    if ( !f ) f = create_field( obj, fld, hv );
    
    return f ? f->data->id: 0;
}

int ob_defined( int obj, int fld )
{
    unsigned hv;
    struct list_head *p;
    struct ofield *f;
    
    if ( !( otab && ftab ) ) return 0;
    
    hv = fhval( obj, fld );
    for ( p=ftab[ hv ].next; p != ftab+hv; p = p->next ) {
        f = list_entry( p, struct ofield, list );
        if ( f->obj==obj && f->fld==fld ) return 1;
    }
    
    return 0;
}

int ob_fieldname( int obj, int index )
{
    struct object *ob;
    
    ob = find_object( obj );
    if ( !ob ) return 0;

    if ( ob->type != 'r' ) return 0; 
    return rec_item( ob->val.a, index );
}

