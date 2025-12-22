/*
 * FILE:
 *   mem.h
 *
 * DESCRIPTION:
 *     This file contains the macros needed to access the safe_ memory
 *   functions in mem.c. See mem.c for more details.
 *
 */

#define AllocMem(s,t) safe_AllocMem((s),(t), __FILE__, __LINE__)
#define FreeMem(a,s)  safe_FreeMem((a),(s), __FILE__, __LINE__)
#define ShowMemList() safe_ShowMemList(__FILE__, __LINE__)
#define ClearMemList() safe_ClearMemList(__FILE__, __LINE__)

void *safe_AllocMem(),
      safe_FreeMem();

ULONG safe_ShowMemList(),
      safe_ClearMemList();
