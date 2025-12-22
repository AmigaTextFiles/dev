/*
 * access.c  V3.1
 *
 * ToolManager old preferences converter for Access Objects
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

#include "converter.h"

/* Conversion routine */
#define DEBUGFUNCTION ConvertAccessConfig
BOOL ConvertAccessConfig(void *chunk, struct IFFHandle *iffh, ULONG id)
{
 BOOL rc = TRUE;

 ACCESS_LOG(LOG3(Entry, "Chunk 0x%08lx IFF Handle 0x%08lx ID 0x%08lx",
                 chunk, iffh, id))

 ACCESS_LOG(LOG0(DISCARDED))

 ACCESS_LOG(LOG1(Result, "%ld", rc))

 return(rc);
}
