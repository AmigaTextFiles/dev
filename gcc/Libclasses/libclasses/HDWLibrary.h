
#ifndef _HDWLIBRARY_H
#define _HDWLIBRARY_H

//#include <libraries/hdwrench.h>

class HDWLibrary
{
public:
	HDWLibrary();
	~HDWLibrary();

	static class HDWLibrary Default;

	BOOL HDWOpenDevice(STRPTR devName, ULONG unit);
	VOID HDWCloseDevice();
	UWORD RawRead(BootBlock * bbk, ULONG size);
	UWORD RawWrite(BootBlock * bb);
	UWORD WriteBlock(BootBlock * bb);
	UWORD ReadRDBs();
	UWORD WriteRDBs();
	BOOL QueryReady(LONG * errorcode);
	BOOL QueryInquiry(BYTE * inqbuf, LONG * errorcode);
	BOOL QueryModeSense(LONG page, LONG msbsize, BYTE * msbuf, LONG * errorcode);
	VOID QueryFindValid(ValidIDstruct * validIDs, STRPTR devicename, LONG board, ULONG types, LONG wide_scsi, int callBack);
	BOOL QueryCapacity(ULONG * totalblocks, ULONG * blocksize);
	ULONG ReadMountfile(ULONG unit, STRPTR filename, STRPTR controller);
	ULONG ReadRDBStructs(STRPTR filename, ULONG unit);
	ULONG WriteMountfile(STRPTR filename, STRPTR ldir, ULONG unit);
	ULONG WriteRDBStructs(STRPTR filename);
	ULONG InMemMountfile(ULONG unit, STRPTR mfdata, STRPTR controller);
	ULONG InMemRDBStructs(STRPTR rdbp, ULONG sizerdb, ULONG unit);
	ULONG OutMemMountfile(STRPTR mfp, ULONG * sizew, ULONG sizeb, ULONG unit);
	ULONG OutMemRDBStructs(STRPTR rdbp, ULONG * sizew, ULONG sizeb);
	BOOL FindDiskName(STRPTR diskname);
	BOOL FindControllerID(STRPTR devname, ULONG * selfid);
	ULONG FindLastSector();
	ULONG FindDefaults(ULONG optimize, struct DefaultsArray * result);
	ULONG LowlevelFormat(int callBack);
	ULONG VerifyDrive(int callBack);

private:
	struct Library *Base;
};

HDWLibrary HDWLibrary::Default;

#endif

