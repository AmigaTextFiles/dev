/* GatewayBase.c (c) 1998,1999 by Michaela Prüß */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <exec/types.h>
#include <math.h>
#include <time.h>

#include "gateway_lib.h"
#include "gateway_protos.h"

struct	Library	*GatewayBase	=	NULL;

void Open_GatewayBase()
{
	GatewayBase = (APTR)OpenLibrary(GATELIBNAME, GATELIB_VERSION);

	if (!GatewayBase)
	{
		printf("\n%s V %d nicht gestartet!\n", GATELIBNAME, GATELIB_VERSION);
		exit(20);
	}

}

void Close_GatewayBase()
{
	if (GatewayBase)	CloseLibrary((APTR)GatewayBase);
}
