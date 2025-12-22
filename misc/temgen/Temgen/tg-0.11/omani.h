#ifndef __omani_h_
#define __omani_h_

int    ob_sethsize( unsigned, unsigned );
int    ob_root( void );
int    ob_set( int obj, char type, ... );     /* type = 'i', 'f', 's', 
                                                 'R' - reference */
/* array operations */
int    ob_item( int obj, int index );

/* record operations */
int    ob_defined( int obj, int fld );        /* returns boolean result */ 
int    ob_field( int obj, int fld );
int    ob_fieldname( int obj, int index );

/* get array size or field number */
int    ob_count( int obj );

/* get object value type */
char   ob_type( int obj );

/* get object value */
int    ob_geti( int obj );
float  ob_getf( int obj );
char  *ob_gets( int obj );

/* print object */
void   ob_print( char *buf, int size, int obj );

#endif
