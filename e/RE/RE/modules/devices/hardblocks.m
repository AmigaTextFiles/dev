#ifndef	DEVICES_HARDBLOCKS_H
#define	DEVICES_HARDBLOCKS_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 


OBJECT RigidDiskBlock
 
    ID:LONG		
    SummedLongs:LONG	
    ChkSum:LONG		
    HostID:LONG		
    BlockBytes:LONG	
    Flags:LONG		
    
    BadBlockList:LONG	
    PartitionList:LONG	
    FileSysHeaderList:LONG 
    DriveInit:LONG	
				
    Reserved1[6]:LONG	
    
    Cylinders:LONG	
    Sectors:LONG	
    Heads:LONG		
    Interleave:LONG	
    Park:LONG		
    Reserved2[3]:LONG
    WritePreComp:LONG	
    ReducedWrite:LONG	
    StepRate:LONG	
    Reserved3[5]:LONG
    
    RDBBlocksLo:LONG	
    RDBBlocksHi:LONG	
    LoCylinder:LONG	
    HiCylinder:LONG	
    CylBlocks:LONG	
    AutoParkSeconds:LONG 
    HighRDSKBlock:LONG	
				
    Reserved4:LONG
    
    DiskVendor[8]:LONG
    DiskProduct[16]:LONG
    DiskRevision[4]:LONG
    ControllerVendor[8]:LONG
    ControllerProduct[16]:LONG
    ControllerRevision[4]:LONG
    Reserved5[10]:LONG
ENDOBJECT

#define	IDNAME_RIGIDDISK	$5244534B	
#define	RDB_LOCATION_LIMIT	16
#define	RDBFB_LAST	0	
#define	RDBFF_LAST	$01	
#define	RDBFB_LASTLUN	1	
#define	RDBFF_LASTLUN	$02	
#define	RDBFB_LASTTID	2	
#define	RDBFF_LASTTID	$04	
#define	RDBFB_NORESELECT 3	
#define	RDBFF_NORESELECT $08	
#define	RDBFB_DISKID	4	
#define	RDBFF_DISKID	$10
#define	RDBFB_CTRLRID	5	
#define	RDBFF_CTRLRID	$20
				
#define RDBFB_SYNCH	6	
#define RDBFF_SYNCH	$40	

OBJECT BadBlockEntry
 
    BadBlock:LONG	
    GoodBlock:LONG	
ENDOBJECT

OBJECT BadBlockBlock
 
    ID:LONG		
    SummedLongs:LONG	
    ChkSum:LONG		
    HostID:LONG		
    Next:LONG		
    Reserved:LONG
      BlockPairs[61]:BadBlockEntry 
    
ENDOBJECT

#define	IDNAME_BADBLOCK		$42414442	

OBJECT PartitionBlock
 
    ID:LONG		
    SummedLongs:LONG	
    ChkSum:LONG		
    HostID:LONG		
    Next:LONG		
    Flags:LONG		
    Reserved1[2]:LONG
    DevFlags:LONG	
    DriveName[32]:UBYTE	
				
    Reserved2[15]:LONG	
    Environment[17]:LONG	
    EReserved[15]:LONG	
ENDOBJECT

#define	IDNAME_PARTITION	$50415254	
#define	PBFB_BOOTABLE	0	
#define	PBFF_BOOTABLE	1	
#define	PBFB_NOMOUNT	1	
#define	PBFF_NOMOUNT	2	

OBJECT FileSysHeaderBlock
 
    ID:LONG		
    SummedLongs:LONG	
    ChkSum:LONG		
    HostID:LONG		
    Next:LONG		
    Flags:LONG		
    Reserved1[2]:LONG
    DosType:LONG	
				
    Version:LONG	
    PatchFlags:LONG	
				
				
				
    Type:LONG		
    Task:LONG		
    Lock:LONG		
    Handler:LONG	
    StackSize:LONG	
    Priority:LONG	
    Startup:LONG	
    SegListBlocks:LONG	
				
				
    GlobalVec:LONG	
    Reserved2[23]:LONG	
    Reserved3[21]:LONG
ENDOBJECT

#define	IDNAME_FILESYSHEADER	$46534844	

OBJECT LoadSegBlock
 
    ID:LONG		
    SummedLongs:LONG	
    ChkSum:LONG		
    HostID:LONG		
    Next:LONG		
    LoadData[123]:LONG	
    
ENDOBJECT

#define	IDNAME_LOADSEG		$4C534547	
#endif	
