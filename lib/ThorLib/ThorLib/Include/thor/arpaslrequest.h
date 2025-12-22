/*************************************************************************
 ** THOR.lib                                                            **
 ** Version 1.01  10th December 1995     © 1995 THOR-Software inc       **
 **                                                                     **
 **---------------------------------------------------------------------**
 **                                                                     **
 ** Filerequester, using ASL or ARP under 1.3                           **
 **                                                                     **
 ** © 1991,1993,1995 THOR - Software                                    **
 *************************************************************************/

#ifndef ARPASLREQUEST_H
#define ARPASLREQUEST_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

struct ARPASLFileRequester {
        char            *fr_Hail;               /* Hailing Text */
        char            *fr_File;               /* Filename Array */
        char            *fr_Dir;                /* Directory Array */
        struct Window   *fr_Window;             /* Window requesting or NULL */
        UBYTE           fr_obsolete[2];         /* set to 0 */
        ULONG           fr_obsolete2[2];        /* ditto */
};


ULONG __asm ArpRequest(register __a0 struct ARPASLFileRequester *);

/* Don't count on the return value: Only one thing...
        NON-NULL:       O.K.
        0:              User canceled or failed
*/

#endif

