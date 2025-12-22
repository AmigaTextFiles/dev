/*  ----------------------------------------------------------------<Prolog>-
    Name:       sflprint.h
    Title:      Printing Functions
    Package:    Standard Function Library (SFL)

    Written:    1999/09/10  iMatix SFL project team <sfl@imatix.com>
    Revised:    1999/09/10

    Synopsis:   Provides printing functions which may be absent on some
                systems.   In particular ensures that the system has 
		snprintf()/vsnprintf() functions which can be called.  The
                functions supplied here are not as good as the vender 
		supplied ones, but are better than having none at all.

    Copyright:  Copyright (c) 1996-2000 iMatix Corporation
    License:    This is free software; you can redistribute it and/or modify
                it under the terms of the SFL License Agreement as provided
                in the file LICENSE.TXT.  This software is distributed in
                the hope that it will be useful, but without any warranty.
 ------------------------------------------------------------------</Prolog>-*/

#include "prelude.h"                    /*  Universal header file            */
#include "sflmem.h"                     /*  Memory allocation functions      */
#include "sflprint.h"                   /*  Prototypes for functions         */

#define SAFETY_FACTOR  2                /*  How much bigger to require temp  */
                                        /*  buffer to be than expected length*/
#define BUFFER_LEN     2048             /*  Length of temporary buffer       */

#if (! defined (DOES_SNPRINTF))
static char 
    shared_buffer[BUFFER_LEN];          /*  Static buffer for printing into  */
#endif

#if (! defined (DOES_SNPRINTF))
/*  ---------------------------------------------------------------------[<]-
    Function: snprintf

    Synopsis: Writes formatted output into supplied string, up to a maximum
    supplied length.  This function is provided for systems which do not have
    a snprintf() function in their C library.  It uses a temporary buffer
    to print into, and providing that temporary buffer wasn't overflowed it
    copies the data up to the supplied length into the supplied buffer.  If
    the temporary buffer was overflowed it exits immediately.  (This is a
    poor man's snprintf(), but allows other code to use snprintf() and get
    the advantages of the better library implementations where available.)
    snprintf() is implemented in terms of vsnprintf().
    Based on the GNU interface (the C9X interface is slightly different).

    Returns:  number of characters output if less than length supplied, 
              otherwise -1.

    Examples:

    char buffer [50];
    int  len;

    len = snprintf (buffer, sizeof(buffer), "Hello %s", "World");
    ---------------------------------------------------------------------[>]-*/

int snprintf  (char *str, size_t n, const char *format, ...)
{
    va_list ap;
    int     rc = 0;

    va_start (ap, format);
    rc = vsnprintf (str, n, format, ap);
    va_end   (ap);

    return rc;
}
#endif

