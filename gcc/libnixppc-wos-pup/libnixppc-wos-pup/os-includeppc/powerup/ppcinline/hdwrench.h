/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_HDWRENCH_H
#define _PPCINLINE_HDWRENCH_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef HDWRENCH_BASE_NAME
#define HDWRENCH_BASE_NAME HDWBase
#endif /* !HDWRENCH_BASE_NAME */

#define FindControllerID(devname, selfid) \
	LP2(0x9c, BOOL, FindControllerID, STRPTR, devname, a0, ULONG *, selfid, a1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindDefaults(optimize, result) \
	LP2(0xa8, ULONG, FindDefaults, ULONG, optimize, d0, struct DefaultsArray *, result, a0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindDiskName(diskname) \
	LP1(0x96, BOOL, FindDiskName, STRPTR, diskname, a0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define FindLastSector() \
	LP0(0xa2, ULONG, FindLastSector, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define HDWCloseDevice() \
	LP0NR(0x24, HDWCloseDevice, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define HDWOpenDevice(devName, unit) \
	LP2(0x1e, BOOL, HDWOpenDevice, STRPTR, devName, a0, ULONG, unit, d0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InMemMountfile(unit, mfdata, controller) \
	LP3(0x7e, ULONG, InMemMountfile, ULONG, unit, d0, STRPTR, mfdata, a0, STRPTR, controller, a1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define InMemRDBStructs(rdbp, sizerdb, unit) \
	LP3(0x84, ULONG, InMemRDBStructs, STRPTR, rdbp, a0, ULONG, sizerdb, d0, ULONG, unit, d1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define LowlevelFormat(callBack) \
	LP1FP(0xae, ULONG, LowlevelFormat, __fpt, callBack, a0, \
	, HDWRENCH_BASE_NAME, LONG (*__fpt)(), IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OutMemMountfile(mfp, sizew, sizeb, unit) \
	LP4(0x8a, ULONG, OutMemMountfile, STRPTR, mfp, a0, ULONG *, sizew, a1, ULONG, sizeb, d0, ULONG, unit, d1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define OutMemRDBStructs(rdbp, sizew, sizeb) \
	LP3(0x90, ULONG, OutMemRDBStructs, STRPTR, rdbp, a0, ULONG *, sizew, a1, ULONG, sizeb, d0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define QueryCapacity(totalblocks, blocksize) \
	LP2(0x60, BOOL, QueryCapacity, ULONG *, totalblocks, a0, ULONG *, blocksize, a1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define QueryFindValid(validIDs, devicename, board, types, wide_scsi, callBack) \
	LP6NRFP(0x5a, QueryFindValid, ValidIDstruct *, validIDs, a0, STRPTR, devicename, a1, LONG, board, d0, ULONG, types, d1, LONG, wide_scsi, d2, __fpt, callBack, a2, \
	, HDWRENCH_BASE_NAME, LONG (*__fpt)(), IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define QueryInquiry(inqbuf, errorcode) \
	LP2(0x4e, BOOL, QueryInquiry, BYTE *, inqbuf, a0, LONG *, errorcode, a1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define QueryModeSense(page, msbsize, msbuf, errorcode) \
	LP4(0x54, BOOL, QueryModeSense, LONG, page, d0, LONG, msbsize, d1, BYTE *, msbuf, a0, LONG *, errorcode, a1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define QueryReady(errorcode) \
	LP1(0x48, BOOL, QueryReady, LONG *, errorcode, a0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RawRead(bbk, size) \
	LP2(0x2a, UWORD, RawRead, BootBlock *, bbk, a0, ULONG, size, d0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define RawWrite(bb) \
	LP1(0x30, UWORD, RawWrite, BootBlock *, bb, a0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadMountfile(unit, filename, controller) \
	LP3(0x66, ULONG, ReadMountfile, ULONG, unit, d0, STRPTR, filename, a0, STRPTR, controller, a1, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadRDBStructs(filename, unit) \
	LP2(0x6c, ULONG, ReadRDBStructs, STRPTR, filename, a0, ULONG, unit, d0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define ReadRDBs() \
	LP0(0x3c, UWORD, ReadRDBs, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define VerifyDrive(callBack) \
	LP1FP(0xb4, ULONG, VerifyDrive, __fpt, callBack, a0, \
	, HDWRENCH_BASE_NAME, LONG (*__fpt)(), IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteBlock(bb) \
	LP1(0x36, UWORD, WriteBlock, BootBlock *, bb, a0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteMountfile(filename, ldir, unit) \
	LP3(0x72, ULONG, WriteMountfile, STRPTR, filename, a0, STRPTR, ldir, a1, ULONG, unit, d0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteRDBStructs(filename) \
	LP1(0x78, ULONG, WriteRDBStructs, STRPTR, filename, a0, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define WriteRDBs() \
	LP0(0x42, UWORD, WriteRDBs, \
	, HDWRENCH_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_HDWRENCH_H */
