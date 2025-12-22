/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     memorytrack
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Jun 28, 1997: Created.
***/

#ifndef MEMORYTRACK
#define MEMORYTRACK

#include "lists.h"

#if (MEMORYTRACKING!=0)
extern ListNode_t *pMemoryList;
#endif /* MEMORYTRACKING */

#endif /* MEMORYTRACK */
