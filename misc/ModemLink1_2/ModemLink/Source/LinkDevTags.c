/*
** NAME: LinkDevTags.c
** DESC: Contains the ML_EstabslishTags() routine which in turn makes a call
**       to ML_EstablishTagList() in modemlink.device.  This is part of the
**       ModemLinkDev.lib.  Do not link with this if you're planning on
**       unsing the modemlink.LIB.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  11 Mar 1997 Created
*/


#include <devices/serial.h>
#include <utility/tagitem.h>

#include "Link.h"
#include "LinkDevTags.h"
#include "ModemLinkDev_pragmas.h"

extern struct Library *ModemLinkBase;

ULONG ML_EstablishTags(struct IOExtLink *LinkIO, struct IOExtSer *SerIO, ULONG data, ...)
{
  struct TagItem *tags = (struct TagItem *)&data;

  return(ML_EstablishTagList(LinkIO, SerIO, tags));
}
