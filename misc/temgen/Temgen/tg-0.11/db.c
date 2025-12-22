#include "db.h"

#if DEBUG

#include "sysdefs.h"

void dbpr( const char *fmt, ... )
{
    va_list ap;
    va_start( ap, fmt );
    vfprintf( stderr, fmt, ap );
    va_end( ap );
}

#else

void dbpr( const char *fmt, ... )
{
}

#endif
