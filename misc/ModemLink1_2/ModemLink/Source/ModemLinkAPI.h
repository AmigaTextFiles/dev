#ifndef ML_API_H
#define ML_API_H

#include <exec/ports.h>
#include "ModemLinkDevAPI.h"

BYTE ML_DoIO(struct IORequest *IOReq);
void ML_SendIO(struct IORequest *IOReq);

#endif
