#ifndef DEVICES_TRACKDISK_H
#define DEVICES_TRACKDISK_H

#ifndef EXEC_IO_H
MODULE  'exec/io'
#endif
#ifndef EXEC_DEVICES_H
MODULE  'exec/devices'
#endif


		
	


#define	NUMSECS	11
#define NUMUNITS 4


#define	TD_SECTOR 512
#define	TD_SECSHIFT 9		


#define	TD_NAME	'trackdisk.device'
#define	TDF_EXTCOM (1<<15)		
#define	TD_MOTOR	(CMD_NONSTD+0)	
#define	TD_SEEK		(CMD_NONSTD+1)	
#define	TD_FORMAT	(CMD_NONSTD+2)	
#define	TD_REMOVE	(CMD_NONSTD+3)	
#define	TD_CHANGENUM	(CMD_NONSTD+4)	
#define	TD_CHANGESTATE	(CMD_NONSTD+5)	
#define	TD_PROTSTATUS	(CMD_NONSTD+6)	
#define	TD_RAWREAD	(CMD_NONSTD+7)	
#define	TD_RAWWRITE	(CMD_NONSTD+8)	
#define	TD_GETDRIVETYPE	(CMD_NONSTD+9)	
#define	TD_GETNUMTRACKS	(CMD_NONSTD+10)	
#define	TD_ADDCHANGEINT	(CMD_NONSTD+11)	
#define	TD_REMCHANGEINT	(CMD_NONSTD+12)	
#define TD_GETGEOMETRY	(CMD_NONSTD+13) 
#define TD_EJECT	(CMD_NONSTD+14) 
#define	TD_LASTCOMM	(CMD_NONSTD+15)

#define	ETD_WRITE	(CMD_WRITEORTDF_EXTCOM)
#define	ETD_READ	(CMD_READORTDF_EXTCOM)
#define	ETD_MOTOR	(TD_MOTORORTDF_EXTCOM)
#define	ETD_SEEK	(TD_SEEKORTDF_EXTCOM)
#define	ETD_FORMAT	(TD_FORMATORTDF_EXTCOM)
#define	ETD_UPDATE	(CMD_UPDATEORTDF_EXTCOM)
#define	ETD_CLEAR	(CMD_CLEARORTDF_EXTCOM)
#define	ETD_RAWREAD	(TD_RAWREADORTDF_EXTCOM)
#define	ETD_RAWWRITE	(TD_RAWWRITEORTDF_EXTCOM)

OBJECT IOExtTD
 
		 Req:IOStdReq
	Count:LONG
	SecLabel:LONG
ENDOBJECT


OBJECT DriveGeometry
 
	SectorSize:LONG		
	TotalSectors:LONG	
	Cylinders:LONG		
	CylSectors:LONG		
	Heads:LONG		
	TrackSectors:LONG	
	BufMemType:LONG		
					
	DeviceType:UBYTE		
	Flags:UBYTE		
	Reserved:UWORD
ENDOBJECT


#define DG_DIRECT_ACCESS	0
#define DG_SEQUENTIAL_ACCESS	1
#define DG_PRINTER		2
#define DG_PROCESSOR		3
#define DG_WORM			4
#define DG_CDROM		5
#define DG_SCANNER		6
#define DG_OPTICAL_DISK		7
#define DG_MEDIUM_CHANGER	8
#define DG_COMMUNICATION	9
#define DG_UNKNOWN		31

#define DGB_REMOVABLE		0
#define DGF_REMOVABLE		1

#define IOTDB_INDEXSYNC	4
#define IOTDF_INDEXSYNC (1<<4)

#define IOTDB_WORDSYNC	5
#define IOTDF_WORDSYNC (1<<5)

#define	TD_LABELSIZE 16

#define TDB_ALLOW_NON_3_5	0
#define TDF_ALLOW_NON_3_5	(1<<0)

#define	DRIVE3_5	1
#define	DRIVE5_25	2
#define	DRIVE3_5_150RPM	3

#define	TDERR_NotSpecified	20	
#define	TDERR_NoSecHdr		21	
#define	TDERR_BadSecPreamble	22	
#define	TDERR_BadSecID		23	
#define	TDERR_BadHdrSum		24	
#define	TDERR_BadSecSum		25	
#define	TDERR_TooFewSecs	26	
#define	TDERR_BadSecHdr		27	
#define	TDERR_WriteProt		28	
#define	TDERR_DiskChanged	29	
#define	TDERR_SeekError		30	
#define	TDERR_NoMem		31	
#define	TDERR_BadUnitNum	32	
#define	TDERR_BadDriveType	33	
#define	TDERR_DriveInUse	34	
#define	TDERR_PostReset		35	

OBJECT PublicUnit
 
		 Unit:Unit		
	Comp01Track:UWORD	
	Comp10Track:UWORD	
	Comp11Track:UWORD	
	StepDelay:LONG		
	SettleDelay:LONG	
	RetryCnt:UBYTE		
	PubFlags:UBYTE		
	CurrTrk:UWORD		
					
	CalibrateDelay:LONG	
					
	Counter:LONG		
					
ENDOBJECT


#define TDPB_NOCLICK	0
#define TDPF_NOCLICK	(1 << 0)
#endif	
