OBJECT RigidDiskBlock
	ID:ULONG,
	SummedLongs:ULONG,
	ChkSum:LONG,
	HostID:ULONG,
	BlockBytes:ULONG,
	Flags:ULONG,
	BadBlockList:ULONG,
	PartitionList:ULONG,
	FileSysHeaderList:ULONG,
	DriveInit:ULONG,
	Reserved1[6]:ULONG,
	Cylinders:ULONG,
	Sectors:ULONG,
	Heads:ULONG,
	Interleave:ULONG,
	Park:ULONG,
	Reserved2[3]:ULONG,
	WritePreComp:ULONG,
	ReducedWrite:ULONG,
	StepRate:ULONG,
	Reserved3[5]:ULONG,
	RDBBlocksLo:ULONG,
	RDBBlocksHi:ULONG,
	LoCylinder:ULONG,
	HiCylinder:ULONG,
	CylBlocks:ULONG,
	AutoParkSeconds:ULONG,
	HighRDSKBlock:ULONG,
	Reserved4:ULONG,
	DiskVendor[8]:CHAR,
	DiskProduct[16]:CHAR,
	DiskRevision[4]:CHAR,
	ControllerVendor[8]:CHAR,
	ControllerProduct[16]:CHAR,
	ControllerRevision[4]:CHAR,
	DriveInitName[40]:CHAR

CONST	IDNAME_RIGIDDISK=$5244534B,
		RDB_LOCATION_LIMIT=16,
		RDBFB_LAST=0,
		RDBFF_LAST=1,
		RDBFB_LASTLUN=1,
		RDBFF_LASTLUN=2,
		RDBFB_LASTTID=2,
		RDBFF_LASTTID=4,
		RDBFB_NORESELECT=3,
		RDBFF_NORESELECT=8,
		RDBFB_DISKID=4,
		RDBFF_DISKID=16,
		RDBFB_CTRLRID=5,
		RDBFF_CTRLRID=$20,
		RDBFB_SYNCH=6,
		RDBFF_SYNCH=$40

OBJECT BadBlockEntry
	BadBlock:ULONG,
	GoodBlock:ULONG

OBJECT BadBlockBlock
	ID:ULONG,
	SummedLongs:ULONG,
	ChkSum:LONG,
	HostID:ULONG,
	Next:ULONG,
	Reserved:ULONG,
	BlockPairs[61]:BadBlockEntry

CONST	IDNAME_BADBLOCK=$42414442

OBJECT PartitionBlock
	ID:ULONG,
	SummedLongs:ULONG,
	ChkSum:LONG,
	HostID:ULONG,
	Next:ULONG,
	Flags:ULONG,
	Reserved1[2]:ULONG,
	DevFlags:ULONG,
	DriveName[32]:UBYTE,
	Reserved2[15]:ULONG,
	Environment[20]:ULONG,
	EReserved[12]:ULONG

CONST	IDNAME_PARTITION=$50415254,
		PBFB_BOOTABLE=0,
		PBFF_BOOTABLE=1,
		PBFB_NOMOUNT=1,
		PBFF_NOMOUNT=2

OBJECT FileSysHeaderBlock
	ID:ULONG,
	SummedLongs:ULONG,
	ChkSum:LONG,
	HostID:ULONG,
	Next:ULONG,
	Flags:ULONG,
	Reserved1[2]:ULONG,
	DosType:ULONG,
	Version:ULONG,
	PatchFlags:ULONG,
	Type:ULONG,
	Task:ULONG,
	Lock:ULONG,
	Handler:ULONG,
	StackSize:ULONG,
	Priority:LONG,
	Startup:LONG,
	SegListBlocks:LONG,
	GlobalVec:LONG,
	Reserved2[23]:ULONG,
	FileSysName[84]:CHAR

CONST	IDNAME_FILESYSHEADER=$46534844

OBJECT LoadSegBlock
	ID:ULONG,
	SummedLongs:ULONG,
	ChkSum:LONG,
	HostID:ULONG,
	Next:ULONG,
	LoadData[123]:ULONG

CONST	IDNAME_LOADSEG=$4C534547
