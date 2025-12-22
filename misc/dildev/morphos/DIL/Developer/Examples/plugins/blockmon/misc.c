/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#include "include.h"

//------------------------------------------------------------------------------

#ifndef __MORPHOS__

const UWORD CountChrs[] =
{
	0x5293,	/* addq.l #1,(a3) */
	0x4E75,	/* rts */
};

const UWORD CpyChr[] =
{
	0x16C0,	/* move.b d0,(a3)+ */
	0x4E75,	/* rts */
};

#endif

void vsprintf(UBYTE *to, UBYTE *fmt, va_list args)
{
#ifdef __MORPHOS__
	VNewRawDoFmt(fmt, (APTR)RAWFMTFUNC_STRING, to, args);
#else
	RawDoFmt(fmt, &fmt + 1, (void (*)(void))CpyChr, to);
#endif
}

void sprintf(UBYTE *to, UBYTE *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	vsprintf(to, fmt, args);
	va_end(args);
}

void vsnprintf(UBYTE *to, LONG maxlen, UBYTE *fmt, va_list args)
{
#ifdef __MORPHOS__
	VNewRawDoFmt(fmt, (APTR)RAWFMTFUNC_STRING, to, args);
#else
	RawDoFmt(fmt, &fmt + 1, (void (*)(void))CpyChr, to);
#endif
	to[maxlen] = '\0';
}

void snprintf(UBYTE *to, LONG maxlen, UBYTE *fmt, ...)
{
	va_list args;

	va_start(args, fmt);
	vsnprintf(to, maxlen, fmt, args);
	va_end(args);
}

LONG vscountf(UBYTE *fmt, va_list args)
{
	LONG size = 0l;

#ifdef __MORPHOS__
	VNewRawDoFmt(fmt, (APTR)RAWFMTFUNC_COUNT, (STRPTR)&size, args);
#else
	RawDoFmt(fmt, &fmt + 1, (void (*)(void))CountChrs, &size);
#endif
	return size;
}

LONG scountf(UBYTE *fmt, ...)
{
	va_list args;
	LONG size = 0l;

	va_start(args, fmt);
	size = vscountf(fmt, args);
	va_end(args);

	return size;
}

//------------------------------------------------------------------------------

APTR AllocVP(Control *control, ULONG size)
{
	APTR data;

	if ((data = AllocVecPooled(control->c_Pool, size))) {
		control->c_PoolUsage += size;
		return data;
   }
	return NULL;
}

void FreeVP(Control *control, APTR data)
{
	if (data) {
		ULONG size = *((ULONG *)data - 1) - sizeof(ULONG);

		FreeVecPooled(control->c_Pool, data);
		control->c_PoolUsage -= size;
	}
}

//------------------------------------------------------------------------------

UBYTE *AllocStrcln(Control *control, UBYTE *str)
{
	UBYTE *ptr;

	if (str && (ptr = AllocVP(control, strlen(str) + 1))) {
		strcpy(ptr, str); return ptr;
	}
	return NULL;
}

void FreeStrcln(Control *control, UBYTE *str)
{
	if (str) FreeVP(control, str);
}

UBYTE *AllocSPrintf(Control *control, UBYTE *fmt, ...)
{
	va_list args;
	ULONG size = 0ul;

	va_start(args, fmt);
	size = (ULONG)vscountf(fmt, args);
	va_end(args);

	if (size > 0) {
		UBYTE *ptr;

		if ((ptr = AllocVP(control, size + 1))) {
			va_start(args, fmt);
			vsprintf(ptr, fmt, args);
			va_end(args);
         return ptr;
		}
	}
	return NULL;
}

void FreeSPrintf(Control *control, UBYTE *str)
{
	if (str) FreeVP(control, str);
}

//------------------------------------------------------------------------------

/*static UBYTE tolower(UBYTE c)
{
	return ((c >= 'A' && c <= 'Z') ? c + 32 : c);
}

static UBYTE toupper(UBYTE c)
{
	return ((c >= 'a' && c <= 'z') ? c - 32 : c);
}*/

static BOOL islower(UBYTE c)
{
	return ((c >= 'a' && c <= 'z') ? 1 : 0);
}

static BOOL isupper(UBYTE c)
{
	return ((c >= 'A' && c <= 'Z') ? 1 : 0);
}

static BOOL isdigit(UBYTE c)
{
	return ((c >= '0' && c <= '9') ? 1 : 0);
}

static BOOL isalpha(UBYTE c)
{
	return (isupper(c) || islower(c));
}

static BOOL isspace(UBYTE c)
{
	return ((c == ' ' || c == '\t' || c == '\n') ? 1 : 0);
}

UBYTE *strcpy(UBYTE *to, const UBYTE *from)
{
	UBYTE *save = to;

	for (; (*to = *from); ++from, ++to);
	return save;
}

ULONG strlen(const UBYTE *str)
{
	const UBYTE *s;

	for (s = str; *s; ++s);
	return ((ULONG)(s - str));
}

ULONG strtoul(const UBYTE *nptr, UBYTE **endptr, int base)
{
	static const ULONG max = 0xfffffffful;
	const UBYTE *s;
	ULONG acc, cutoff;
	int c;
	int neg, any, cutlim;

	s = nptr;
	do
		c = *s++;
	while (isspace(c));

	if (c == '-') {
		neg = 1;
		c = *s++;
	} else {
		neg = 0;
		if (c == '+')
			c = *s++;
	}

	if ((base == 0 || base == 16) && c == '0' && (*s == 'x' || *s == 'X')) {
		c = s[1];
		s += 2;
		base = 16;
	}
	if (base == 0)
		base = c == '0' ? 8 : 10;

	cutoff = max / (ULONG)base;
	cutlim = max % (ULONG)base;

	for (acc = 0ul, any = 0;; c = *s++) {
		if (isdigit(c))
			c -= '0';
      else if (isalpha(c))
			c -= isupper(c) ? 'A' - 10 : 'a' - 10;
      else
			break;

      if (c >= base)
			break;
      if (any < 0)
			continue;

		if (acc > cutoff || (acc == cutoff && c > cutlim)) {
			any = -1;
			acc = max;
		} else {
			any = 1;
			acc *= (ULONG)base;
			acc += c;
		}
   }
   if (neg && any > 0)
		acc = -acc;
   if (endptr != 0)
		*endptr = (UBYTE *) (any ? s - 1 : nptr);

	return acc;
}

//------------------------------------------------------------------------------

APTR memset(APTR dest, UBYTE val, ULONG len)
{
	register UBYTE *ptr = (UBYTE *)dest;

   while (len-- > 0)
		*ptr++ = val;
   return dest;
}

//------------------------------------------------------------------------------

UBYTE *Size2String(UQUAD bytes)
{
	static UBYTE buf[32];

	if (bytes < 1024ull * 1024ull)
		sprintf(buf, "%lu.%02lu kb", (ULONG)(bytes / 1000), (ULONG)((((bytes * 1000) % 1000000) + 5000) / 10000));
	else if (bytes < 2ull * 1024ull * 1024ull * 1024ull)
		sprintf(buf, "%lu.%02lu mb", (ULONG)(bytes / 1000 / 1000), (ULONG)(((bytes % 1000000) + 5000) / 10000));
   else
		sprintf(buf, "%lu.%02lu gb", (ULONG)(bytes / 1000ll / 1000ll / 1000ll), (ULONG)((((bytes / 1000) % 1000000) + 5000) / 10000));

   return buf;
}

//------------------------------------------------------------------------------

ULONG CST2LBA(struct DosEnvec *de, ULONG cylinder, ULONG surface, ULONG track)
{
	return (((cylinder * de->de_Surfaces + surface) * de->de_BlocksPerTrack) + track - 1);
}

void LBA2CST(struct DosEnvec *de, ULONG lba, ULONG *cylinder, ULONG *surface, ULONG *track)
{
	ULONG tmp = lba % (de->de_Surfaces * de->de_BlocksPerTrack);

	*cylinder = lba / (de->de_Surfaces * de->de_BlocksPerTrack);
	*surface = tmp / de->de_BlocksPerTrack;
	*track = tmp % de->de_BlocksPerTrack + 1;
}

//------------------------------------------------------------------------------

ULONG GetNumBlocks(struct DosEnvec *de)
{
	return ((de->de_HighCyl - de->de_LowCyl + 1) * de->de_Surfaces * de->de_BlocksPerTrack);
}

ULONG GetNumCyls(struct DosEnvec *de)
{
	return (de->de_HighCyl - de->de_LowCyl + 1);
}

//------------------------------------------------------------------------------

ULONG GetLowBlock(struct DosEnvec *de)
{
	return (de->de_LowCyl * de->de_Surfaces * de->de_BlocksPerTrack);
}

ULONG GetHighBlock(struct DosEnvec *de)
{
	return (((de->de_HighCyl+1) * de->de_Surfaces * de->de_BlocksPerTrack)-1);
}

//------------------------------------------------------------------------------

ULONG GetCyl(struct DosEnvec *de, ULONG lba)
{
	return (lba / (de->de_Surfaces * de->de_BlocksPerTrack));
}

ULONG GetSurface(struct DosEnvec *de, ULONG lba)
{
	ULONG tmp = lba % (de->de_Surfaces * de->de_BlocksPerTrack);

	return (tmp / de->de_BlocksPerTrack);
}

ULONG GetTrack(struct DosEnvec *de, ULONG lba)
{
	ULONG tmp = lba % (de->de_Surfaces * de->de_BlocksPerTrack);

	return (tmp % de->de_BlocksPerTrack + 1);
}

//------------------------------------------------------------------------------

ULONG GetRootBlock_AROS(struct DosEnvec *de)
{
	return ((GetNumBlocks(de) - 1 + de->de_Reserved) / 2);
}

//------------------------------------------------------------------------------

BOOL CheckCreateDir(UBYTE *dn)
{
	BPTR lock;

	if ((lock = Lock(dn, ACCESS_READ))) {
		UnLock(lock); return TRUE;
	} else if ((lock = CreateDir(dn))) {
		UnLock(lock); return TRUE;
	}
	return FALSE;
}

//------------------------------------------------------------------------------

BOOL LoadDecimal(UBYTE *fn, ULONG *value)
{
	BPTR fh;
	BOOL result = FALSE;

	if ((fh = Open(fn, MODE_OLDFILE))) {
		UBYTE buffer[128];
		
      if (FGets(fh, buffer, sizeof(buffer))) {
			*value = strtoul(buffer, NULL, 10);
			result = TRUE;
		}
      Close(fh);
	}
	return result;
}

BOOL SaveDecimal(UBYTE *fn, ULONG value)
{
	BPTR fh;
	BOOL result = FALSE;

	if ((fh = Open(fn, MODE_NEWFILE))) {
		UBYTE buffer[128];
		LONG len;

		memclr(buffer, sizeof(buffer));
		sprintf(buffer, "%lu", value);
		
		len = (LONG)strlen(buffer);
		if (Write(fh, buffer, len) == len)
			result = TRUE;

		Close(fh);
	}
	return result;
}

//------------------------------------------------------------------------------

BOOL LoadCache(DILParams *params)
{
   Control *control = params->p_User;
	Settings *settings = &control->c_Settings;
	UBYTE fmt[1024], *fn;

	strcpy(fmt, settings->s_PathCache);
	AddPart(fmt, FMT_CACHE_UNIT, sizeof(fmt));

	if ((fn = AllocSPrintf(control, fmt, params->p_DILUnit)))
	{
		BPTR fh;

		if ((fh = Open(fn, MODE_OLDFILE)))
		{
			LONG offset = sizeof(struct MinNode);
			LONG length = sizeof(Entry) - sizeof(struct MinNode);
			BOOL more = TRUE;

			while (more) {
				Entry *entry;

				if ((entry = AllocVP(control, sizeof(Entry))))
				{
					APTR data = &((UBYTE *)entry)[offset];

					if ((Read(fh, data, length) == length)) {
						_AddTail(&control->c_List, &entry->e_Node);
						control->c_ListEntries++;
						control->c_AccessCountMax = max(control->c_AccessCountMax, max(entry->e_RAC, entry->e_WAC));
					} else {
						FreeVP(control, entry);
						more = FALSE;
					}
				}
			}
			Close(fh);
		}
		FreeSPrintf(control, fn);
		return TRUE;
	}
	return FALSE;
}

//------------------------------------------------------------------------------

BOOL SaveCache(DILParams *params)
{
   Control *control = params->p_User;
	Settings *settings = &control->c_Settings;
	UBYTE fmt[1024], *fn;
	BOOL result = TRUE;

	if (IsListEmpty(&control->c_List))
		return result;
	else if (isclrf(control->c_Flags, CF_NEEDSAVE))
		return result;

	strcpy(fmt, settings->s_PathCache);
	AddPart(fmt, FMT_CACHE_UNIT, sizeof(fmt));

	if ((fn = AllocSPrintf(control, fmt, params->p_DILUnit)))
	{
		BPTR fh;

		if ((fh = Open(fn, MODE_NEWFILE)))
		{
			Entry *entry;
			LONG offset = sizeof(struct MinNode);
			LONG length = sizeof(Entry) - sizeof(struct MinNode);

			ForeachNode(&control->c_List, entry) {
				APTR data = &((UBYTE *)entry)[offset];

				if ((Write(fh, data, length) != length)) {
					result = FALSE; break;
				}
			}
			Close(fh);
		}
		FreeSPrintf(control, fn);
	}
	return result;
}

//------------------------------------------------------------------------------

































