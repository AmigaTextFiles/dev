/*
** NAME LinkTags.h
*/

#ifndef LINK_TAGS_H
#define LINK_TAGS_H

#include <devices/serial.h>
#include "Link.h"

ULONG ML_EstablishTags(struct IOExtLink *LinkIO, struct IOExtSer *SerIO, ULONG data, ...);

#endif
