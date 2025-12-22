/*
 * network.c  V3.1
 *
 * ToolManager network handling routines
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

#include "toolmanager.h"

/* Local data */
static LONG EntitySignal;

/* Start networking */
#define DEBUGFUNCTION StartNetwork
LONG StartNetwork(void)
{
 NETWORK_LOG(LOG0(Entry))

 /* Allocate signal bit */
 EntitySignal = AllocSignal(-1);

 NETWORK_LOG(LOG1(Result, "%ld", EntitySignal))

 return(EntitySignal);
}

/* Stop networking */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION StopNetwork
void StopNetwork(void)
{
 APPMSGS_LOG(LOG1(Signal, "%ld", EntitySignal))

 /* Disable network first */
 DisableNetwork();

 /* Free signal bit */
 FreeSignal(EntitySignal);
}

/* Enable networking */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION EnableNetwork
void EnableNetwork(void)
{
}

/* Disable networking */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION DisableNetwork
void DisableNetwork(void)
{
}

/* Handle network event */
#undef  DEBUGFUNCTION
#define DEBUGFUNCTION HandleNetwork
void HandleNetwork(void)
{
 NETWORK_LOG(LOG0(NOT IMPLEMENTED))
}
