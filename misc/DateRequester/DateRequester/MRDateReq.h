/*  MRDateReq.h - definitions of the date requester package. */

#ifndef _MRDATEREQ_H
#define _MRDATEREQ_H
#include <libraries/dos.h>
#include "MRDates.h"

/*  The following structure defines a packet used to interface with the
 *  MRDateRequest function. It is highly recommended that objects of this
 *  type be dynamically allocated using AllocMem() (or equivalent) to 
 *  insure that the base address of the structure is longword-aligned.
 *  Also note that the pointer to a structure of this type is equivalent
 *  to a "struct DateTime *" since the first field in this structure is
 *  an embedded ARP DateTime structure.
 */
typedef struct {
    /* The following fields are filled in by the caller: */
    struct DateTime     ARPDatePacket;
    char                *prompt;
    struct Window       *window;

    /* The following fields are filled in by MRDateRequest: */
    struct Requester    *requester;     /* for local use only! */
    MRDate              newDate;        /* alternate format date */
    int                 status;         /* result code */
    int                 myStrings;      /* true => strings are mine */
    } MRDatePacket;

void            FreeMRDatePacket(/* MRDatePacket *thePacket */);
MRDatePacket *  CreateMRDatePacket(/* struct DateStamp *theDate, 
                                    int theFormat, int makeStrings */);
int             MRDateRequest(/* MRDatePacket *datePacket */);

#endif
