/* gatexpr.h */

#ifndef GATEXPR
#define GATEXPR

struct Library *GateXprBase;

enum	{	ERR_ILLEGAL=1,ERR_NOMEM,ERR_NOPORT,ERR_OPENDEVICE,
		ERR_PARAMS,ERR_TIMER,ERR_OPENLIBRARY,ERR_SETUP,ERR_MODE };

enum	{	PAR_NONE,PAR_EVEN,PAR_ODD,PAR_MARK,PAR_SPACE };

struct TransferNote
{
	LONG			 tn_Continue;
	LONG			 tn_CarrierDetect;
	LONG			 tn_Seconds;
	LONG			 tn_Bytes;
	APTR			 tn_UserData;
	UBYTE			*tn_CurrentFile;
	LONG			 tn_FilesToGo;
	UBYTE			*tn_ProtocolName;
	LONG			 tn_Extension;
	LONG			 tn_WatchCarrier;
	LONG			 tn_Aborted;
	LONG			 tn_Error;
	LONG			 tn_ErrorCode;
};

LONG	TransferSetup(UBYTE *Device,LONG Unit,UBYTE *Library,LONG Baud,LONG DataBits,LONG StopBits,LONG Parity,LONG Handshaking);

LONG	ReceiveFile(UBYTE *Name,LONG Window,struct Screen *Screen);
LONG	SendFile(UBYTE *Name,LONG Window,struct Screen *Screen);

LONG	GetOptions(UBYTE *Buffer);
LONG	SetOptions(UBYTE *Buffer);

LONG	TransferSetupShared(struct IOExtSer *ReadRequest,struct IOExtSer *WriteRequest,UBYTE *Library);
LONG	InstallTransferNote(struct TransferNote *Note);
LONG	SendMultipleFile(UBYTE *Namen,LONG Window,struct Screen *Screen);

#pragma amicall(GateXprBase, 0x1e, TransferSetup(a0,d0,a1,d1,d2,d3,d4,d5))
#pragma amicall(GateXprBase, 0x24, ReceiveFile(a0,d0,a1))
#pragma amicall(GateXprBase, 0x2a, SendFile(a0,d0,a1))
#pragma amicall(GateXprBase, 0x30, GetOptions(a0))
#pragma amicall(GateXprBase, 0x36, SetOptions(a0))
#pragma amicall(GateXprBase, 0x3c, TransferSetupShared(a0,a1,a2))
#pragma amicall(GateXprBase, 0x42, InstallTransferNote(a0))
#pragma amicall(GateXprBase, 0x48, SendMultipleFiles(a0,d0,a1))

#endif
