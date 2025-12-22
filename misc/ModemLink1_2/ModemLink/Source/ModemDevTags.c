/*
** NAME: ModemDevTags.c
** DESC: Contains the ...Tags() version of the Modem related commands.  All
**       these do is call the corresponding routines in modemlink.DEVICE.
**       Make sure to not link with this if using the modemlink.lib.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  11 Mar 1997 Created
*/


#include <devices/serial.h>
#include <utility/tagitem.h>

#include "ModemDevTags.h"
#include "Modem.h"
#include "ModemLinkDev_pragmas.h"

extern struct Library *ModemLinkBase;

ULONG ML_SendModemCMDTags(struct IOExtSer *SerIO, char *CMD, ULONG data, ...)
{
  struct TagItem *tags = (struct TagItem *)&data;

  return (ML_SendModemCMDTagList(SerIO, CMD, tags));
}

ULONG ML_DialTags(struct IOExtSer *SerIO, char *PhoneNum, ULONG data, ...)
{
  struct TagItem *tags = (struct TagItem *)&data;

  return (ML_DialTagList(SerIO, PhoneNum, tags));
}

ULONG ML_AnswerTags(struct IOExtSer *SerIO, ULONG data, ...)
{
  struct TagItem *tags = (struct TagItem *)&data;

  return (ML_AnswerTagList(SerIO, tags));
}
