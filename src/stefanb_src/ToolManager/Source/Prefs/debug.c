/*
 * debug.c  V3.1
 *
 * Preferences editor debugging code
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
static char TagBuffer[11];

#ifdef DEBUGPRINTTAGLIST
static const char PrintHex(ULONG data)
{
 int i;

 /* Print Hex introducer */
 TagBuffer[0] = '0';
 TagBuffer[1] = 'x';

 /* Print digits (backwards) */
 for (i = 9; i > 1; i--) {
  ULONG digit = data & 0xF;

  /* Translate to Hex digit */
  TagBuffer[i] = (digit < 10) ? digit + '0' : digit - 10 + 'A';

  /* Next digit */
  data >>= 4;
 }

 /* Add string terminator */
 TagBuffer[10] = '\0';
}

/* Get tag name */
const char *GetTagName(ULONG tag)
{
 const char *rc;

 switch(tag) {
  default: PrintHex(tag); rc = TagBuffer; break;
 }

 return(rc);
}

/* Get tag data format */
static const char *GetTagFormat(ULONG tag)
{
 const char *rc;

 switch (tag) {
  default: rc = "0x%08lx"; break;
 }

 return(rc);
}
#endif

/* Include global debugging code */
#include "/global_debug.c"
