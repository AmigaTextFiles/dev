/*
** NAME: LinkTags.c
** DESC: Contains the ML_EstabslishTags() routine which in turn makes a call
**       to ML_EstablishTagList() in modemlink.lib.  This is part of the
**       ModemLink.lib.  Do not link with this if you're using the
**       modemlink.DEVICE.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  13 Mar 1997 Created
*/


#include <devices/serial.h>
#include <utility/tagitem.h>

#include "Link.h"
#include "LinkTags.h"

ULONG ML_EstablishTags(struct IOExtLink *LinkIO, struct IOExtSer *SerIO, ULONG data, ...)
{
  struct TagItem *tags = (struct TagItem *)&data;

  return(ML_EstablishTagList(LinkIO, SerIO, tags));
}
