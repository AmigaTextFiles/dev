
#ifndef _HDWLIBRARY_CPP
#define _HDWLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/HDWLibrary.h>

HDWLibrary::HDWLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("hdw.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open hdw.library") );
	}
}

HDWLibrary::~HDWLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

BOOL HDWLibrary::HDWOpenDevice(STRPTR devName, ULONG unit)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = devName;
	register unsigned int d0 __asm("d0") = unit;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (BOOL) _res;
}

VOID HDWLibrary::HDWCloseDevice()
{
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6)
	: "d0");
}

UWORD HDWLibrary::RawRead(BootBlock * bbk, ULONG size)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bbk;
	register unsigned int d0 __asm("d0") = size;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (UWORD) _res;
}

UWORD HDWLibrary::RawWrite(BootBlock * bb)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bb;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (UWORD) _res;
}

UWORD HDWLibrary::WriteBlock(BootBlock * bb)
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = bb;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (UWORD) _res;
}

UWORD HDWLibrary::ReadRDBs()
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (UWORD) _res;
}

UWORD HDWLibrary::WriteRDBs()
{
	register UWORD _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (UWORD) _res;
}

BOOL HDWLibrary::QueryReady(LONG * errorcode)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = errorcode;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

BOOL HDWLibrary::QueryInquiry(BYTE * inqbuf, LONG * errorcode)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = inqbuf;
	register void * a1 __asm("a1") = errorcode;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

BOOL HDWLibrary::QueryModeSense(LONG page, LONG msbsize, BYTE * msbuf, LONG * errorcode)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int d0 __asm("d0") = page;
	register int d1 __asm("d1") = msbsize;
	register void * a0 __asm("a0") = msbuf;
	register void * a1 __asm("a1") = errorcode;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (d1), "r" (a0), "r" (a1)
	: "d0", "d1", "a0", "a1");
	return (BOOL) _res;
}

VOID HDWLibrary::QueryFindValid(ValidIDstruct * validIDs, STRPTR devicename, LONG board, ULONG types, LONG wide_scsi, int callBack)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = validIDs;
	register char * a1 __asm("a1") = devicename;
	register int d0 __asm("d0") = board;
	register unsigned int d1 __asm("d1") = types;
	register int d2 __asm("d2") = wide_scsi;
	register int a2 __asm("a2") = callBack;

	__asm volatile ("jsr a6@(-90)"
	: 
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (a2)
	: "a0", "a1", "d0", "d1", "d2", "a2");
}

BOOL HDWLibrary::QueryCapacity(ULONG * totalblocks, ULONG * blocksize)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = totalblocks;
	register void * a1 __asm("a1") = blocksize;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

ULONG HDWLibrary::ReadMountfile(ULONG unit, STRPTR filename, STRPTR controller)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = unit;
	register char * a0 __asm("a0") = filename;
	register char * a1 __asm("a1") = controller;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (ULONG) _res;
}

ULONG HDWLibrary::ReadRDBStructs(STRPTR filename, ULONG unit)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = filename;
	register unsigned int d0 __asm("d0") = unit;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

ULONG HDWLibrary::WriteMountfile(STRPTR filename, STRPTR ldir, ULONG unit)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = filename;
	register char * a1 __asm("a1") = ldir;
	register unsigned int d0 __asm("d0") = unit;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (ULONG) _res;
}

ULONG HDWLibrary::WriteRDBStructs(STRPTR filename)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = filename;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG HDWLibrary::InMemMountfile(ULONG unit, STRPTR mfdata, STRPTR controller)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = unit;
	register char * a0 __asm("a0") = mfdata;
	register char * a1 __asm("a1") = controller;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0), "r" (a1)
	: "d0", "a0", "a1");
	return (ULONG) _res;
}

ULONG HDWLibrary::InMemRDBStructs(STRPTR rdbp, ULONG sizerdb, ULONG unit)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = rdbp;
	register unsigned int d0 __asm("d0") = sizerdb;
	register unsigned int d1 __asm("d1") = unit;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (ULONG) _res;
}

ULONG HDWLibrary::OutMemMountfile(STRPTR mfp, ULONG * sizew, ULONG sizeb, ULONG unit)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = mfp;
	register void * a1 __asm("a1") = sizew;
	register unsigned int d0 __asm("d0") = sizeb;
	register unsigned int d1 __asm("d1") = unit;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (ULONG) _res;
}

ULONG HDWLibrary::OutMemRDBStructs(STRPTR rdbp, ULONG * sizew, ULONG sizeb)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = rdbp;
	register void * a1 __asm("a1") = sizew;
	register unsigned int d0 __asm("d0") = sizeb;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (ULONG) _res;
}

BOOL HDWLibrary::FindDiskName(STRPTR diskname)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = diskname;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

BOOL HDWLibrary::FindControllerID(STRPTR devname, ULONG * selfid)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register char * a0 __asm("a0") = devname;
	register void * a1 __asm("a1") = selfid;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

ULONG HDWLibrary::FindLastSector()
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;

	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6)
	: "d0");
	return (ULONG) _res;
}

ULONG HDWLibrary::FindDefaults(ULONG optimize, struct DefaultsArray * result)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = optimize;
	register void * a0 __asm("a0") = result;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (d0), "r" (a0)
	: "d0", "a0");
	return (ULONG) _res;
}

ULONG HDWLibrary::LowlevelFormat(int callBack)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = callBack;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG HDWLibrary::VerifyDrive(int callBack)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register int a0 __asm("a0") = callBack;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}


#endif

