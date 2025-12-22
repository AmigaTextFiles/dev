
/*
** $Id: tip_misc.c,v 1.2 1999/11/12 20:47:01 carlos Exp $
*/


#include "tip_include.h"

/// _strncpy

char *_strncpy( char *dest, char *src, ULONG count )
{
int i = 0;

        while( TRUE )
           {
           dest[i] = src[i];

           if( (i >= count) || ( src[i] == 0 ) )
               break;

           i++;
           }

        return( dest );
}
//|
/// _strcpy

char *_strcpy( char *dest, char *src )
{
int i = 0;

        while( TRUE )
           {
           dest[i] = src[i];

           if( src[i] == 0 )
               break;

           i++;
           }

        return( dest );
}
//|
/// _strlen

int _strlen( char *str, char stop )
{
int i=0;

        while(str[i] != stop)
                i++;

        return( i );
}
//|
/// _strchr
char *_strchr( char *buf, char key )
{
char *found = NULL;
int  i;

    for( i = 0; ; i++ )
       {
       if( buf[i] == 0 )
           break;

       if( buf[i] == key )
           {
           found = &buf[i];
           break;
           }
       }

    return( found );
}
//|
/// _strnchrrev

/*
** length limited version of reverse strchr (checks starting from
** the end of the string!)
*/

char * _strnchrrev( char *str, char chr, int n )
{
ULONG len = _strlen( str, 0 );
ULONG max = n;
int   i;

    if( n == -1 )
       max = len;

    for( i=1; i <= len; i++ )
       {
       if( str[len - i] == chr)
           return( &str[ len - i] );

       max--;

       if( max < 0 )
           return( NULL );
       }

    return(NULL);
}
//|
/// _strcat

char *_strcat( char *str, char *str2 )
{
char *end = str + _strlen( str, 0 );

    _strcpy( end, str2 );

    return( end );
}
//|
/// _StrToLower

void _strtolower( char *dest_buffer, char * src )
{
    for(; *src;)
       {
       *dest_buffer = ToLower(*src);
       src++;
       dest_buffer++;
       }
    *dest_buffer=0;
}
//|

/// xget

ULONG xget( Object *obj, int attr)
{
ULONG val;

        get( obj, attr, &val);
        return( val );
}
//|

