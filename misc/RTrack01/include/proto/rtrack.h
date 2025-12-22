/*
 * RTrack (C) 1995 by PROXITY SOFTWORKS
 */

#ifndef PROTO_RTRACK_H
#define PROTO_RTRACK_H
#ifndef  EXEC_LIBRARIES_H
#include <exec/types.h>
#endif
#ifndef  DOS_DOS_H
#include <dos/dos.h>
#endif

/* Do not edit! AutoExit handling may change in the future! */
extern BOOL RTrackAutoExit;
#ifdef __SASC
static void __inline rkAutoExit(BOOL autoExit) {RTrackAutoExit = autoExit;}
#else
static void rkAutoExit(BOOL autoExit) {RTrackAutoExit = autoExit;}
#endif

#include <clib/RTrack_protos.h>
#endif
