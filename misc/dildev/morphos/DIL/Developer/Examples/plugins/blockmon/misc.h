/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef MISC_H
#define MISC_H 1

//-----------------------------------------------------------------------------

void vsprintf(UBYTE *to, UBYTE *fmt, va_list args);
void sprintf(UBYTE *to, UBYTE *fmt, ...);

void vsnprintf(UBYTE *to, LONG maxlen, UBYTE *fmt, va_list args);
void snprintf(UBYTE *to, LONG maxlen, UBYTE *fmt, ...);

LONG vscountf(UBYTE *fmt, va_list args);
LONG scountf(UBYTE *fmt, ...);

//-----------------------------------------------------------------------------

APTR AllocVP(Control *control, ULONG size);
void FreeVP(Control *control, APTR data);

UBYTE *AllocStrcln(Control *control, UBYTE *str);
void FreeStrcln(Control *control, UBYTE *str);

UBYTE *AllocSPrintf(Control *control, UBYTE *fmt, ...);
void FreeSPrintf(Control *control, UBYTE *str);

//-----------------------------------------------------------------------------

UBYTE *strcpy(UBYTE *to, const UBYTE *from);
ULONG strlen(const UBYTE *str);

ULONG strtoul(const UBYTE *nptr, UBYTE **endptr, int base);

APTR memset(APTR dest, UBYTE val, ULONG len);

//-----------------------------------------------------------------------------

UBYTE *Size2String(UQUAD bytes);

//-----------------------------------------------------------------------------

ULONG CST2LBA(struct DosEnvec *de, ULONG cylinder, ULONG surface, ULONG track);
void LBA2CST(struct DosEnvec *de, ULONG lba, ULONG *cylinder, ULONG *surface, ULONG *track);

ULONG GetNumBlocks(struct DosEnvec *de);
ULONG GetNumCyls(struct DosEnvec *de);

ULONG GetLowBlock(struct DosEnvec *de);
ULONG GetHighBlock(struct DosEnvec *de);

ULONG GetCyl(struct DosEnvec *de, ULONG lba);
ULONG GetSurface(struct DosEnvec *de, ULONG lba);
ULONG GetTrack(struct DosEnvec *de, ULONG lba);

ULONG GetRootBlock_AROS(struct DosEnvec *de);

//-----------------------------------------------------------------------------

BOOL CheckCreateDir(UBYTE *dn);

BOOL LoadDecimal(UBYTE *fn, ULONG *value);
BOOL SaveDecimal(UBYTE *fn, ULONG value);

//-----------------------------------------------------------------------------

BOOL LoadCache(DILParams *params);
BOOL SaveCache(DILParams *params);

//-----------------------------------------------------------------------------

#endif /* MISC_H */

