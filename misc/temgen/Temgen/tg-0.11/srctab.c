#include "srctab.h"
#include "hash.h"

#define SRCHSIZE       59

static unsigned src_hash_fun( const void *data )
{
    return (unsigned)(((const struct sourcefile*)data)->fname);
}

static int src_hash_compare( const void *data1, const void *data2 )
{
    int name1, name2;
    name1 = ((const struct sourcefile*)data1)->fname;
    name2 = ((const struct sourcefile*)data2)->fname;
    return name1-name2;
}

static struct hash *srctab = 0;

int regsrc( struct sourcefile *sf )
{
    if ( !srctab ) 
        srctab = new_hash( SRCHSIZE, src_hash_fun, src_hash_compare );
    if ( !srctab ) return -100;
    return h_add( srctab, sf );
}

struct sourcefile *findsrc( int fname ) 
{
    struct sourcefile sf;
    sf.fname = fname;
    return (struct sourcefile*)h_get( srctab, &sf );
}

