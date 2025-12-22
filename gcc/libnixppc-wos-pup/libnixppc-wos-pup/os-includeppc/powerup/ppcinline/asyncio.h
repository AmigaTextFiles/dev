/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_ASYNCIO_H
#define _PPCINLINE_ASYNCIO_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef ASYNCIO_BASE_NAME
#define ASYNCIO_BASE_NAME AsyncIOBase
#endif /* !ASYNCIO_BASE_NAME */

#define CloseAsync(file) \
	LP1(0x2a, LONG, CloseAsync, AsyncFile *, file, a0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FGetsAsync(file, buf, bytes) \
	LP3(0x5a, APTR, FGetsAsync, AsyncFile *, file, a0, APTR, buf, a1, LONG, bytes, d0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FGetsLenAsync(file, buf, bytes, length) \
	LP4(0x60, APTR, FGetsLenAsync, AsyncFile *, file, a0, APTR, buf, a1, LONG, bytes, d0, LONG *, length, a2, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenAsync(fileName, mode, bufferSize) \
	LP3(0x1e, struct AsyncFile *, OpenAsync, const STRPTR, fileName, a0, OpenModes, mode, d0, LONG, bufferSize, d1, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OpenAsyncFromFH(handle, mode, bufferSize) \
	LP3(0x24, struct AsyncFile *, OpenAsyncFromFH, BPTR, handle, a0, OpenModes, mode, d0, LONG, bufferSize, d1, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define PeekAsync(file, buffer, bytes) \
	LP3(0x66, LONG, PeekAsync, AsyncFile *, file, a0, APTR, buffer, a1, LONG, bytes, d0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadAsync(file, buffer, bytes) \
	LP3(0x36, LONG, ReadAsync, AsyncFile *, file, a0, APTR, buffer, a1, LONG, bytes, d0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadCharAsync(file) \
	LP1(0x42, LONG, ReadCharAsync, AsyncFile *, file, a0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadLineAsync(file, buf, bytes) \
	LP3(0x4e, LONG, ReadLineAsync, AsyncFile *, file, a0, APTR, buf, a1, LONG, bytes, d0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define SeekAsync(file, position, mode) \
	LP3(0x30, LONG, SeekAsync, AsyncFile *, file, a0, LONG, position, d0, SeekModes, mode, d1, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteAsync(file, buffer, bytes) \
	LP3(0x3c, LONG, WriteAsync, AsyncFile *, file, a0, APTR, buffer, a1, LONG, bytes, d0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteCharAsync(file, ch) \
	LP2(0x48, LONG, WriteCharAsync, AsyncFile *, file, a0, UBYTE, ch, d0, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteLineAsync(file, buf) \
	LP2(0x54, LONG, WriteLineAsync, AsyncFile *, file, a0, STRPTR, buf, a1, \
	, ASYNCIO_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_ASYNCIO_H */
