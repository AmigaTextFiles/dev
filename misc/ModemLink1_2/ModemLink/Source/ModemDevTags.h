/*
** NAME: ModemTags.h
*/

#ifndef MODEM_DEV_TAGS_H
#define MODEM_DEV_TAGS_H

#include <exec/types.h>
#include <devices/serial.h>
#include <utility/tagitem.h>

ULONG ML_SendModemCMDTags(struct IOExtSer *SerIO, char *CMD, ULONG data, ...);
ULONG ML_DialTags(struct IOExtSer *SerIO, char *PhoneNum, ULONG data, ...);
ULONG ML_AnswerTags(struct IOExtSer *SerIO, ULONG data, ...);

#endif
