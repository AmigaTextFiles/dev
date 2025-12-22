#ifndef DOS_FILEHANDLER_H
#define DOS_FILEHANDLER_H

#ifndef	  EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef	  DOS_DOS_H
MODULE  'dos/dos'
#endif

OBJECT DosEnvec
 
    TableSize:LONG	     
    SizeBlock:LONG	     
    SecOrg:LONG	     
    Surfaces:LONG	     
    SectorPerBlock:LONG 
    BlocksPerTrack:LONG 
    Reserved:LONG	     
    PreAlloc:LONG	     
    Interleave:LONG     
    LowCyl:LONG	     
    HighCyl:LONG	     
    NumBuffers:LONG     
    BufMemType:LONG     
    MaxTransfer:LONG    
    Mask:LONG	     
    BootPri:LONG	     
    DosType:LONG	     
    Baud:LONG	     
    Control:LONG	     
    BootBlocks:LONG     
ENDOBJECT



#define DE_TABLESIZE	0	
#define DE_SIZEBLOCK	1	
#define DE_SECORG	2	
#define DE_NUMHEADS	3	
#define DE_SECSPERBLK	4	
#define DE_BLKSPERTRACK 5	
#define DE_RESERVEDBLKS 6	
#define DE_PREFAC	7	
#define DE_INTERLEAVE	8	
#define DE_LOWCYL	9	
#define DE_UPPERCYL	10	
#define DE_NUMBUFFERS	11	
#define DE_MEMBUFTYPE	12	
#define DE_BUFMEMTYPE	12	
#define DE_MAXTRANSFER	13	
#define DE_MASK		14	
#define DE_BOOTPRI	15	
#define DE_DOSTYPE	16	
#define DE_BAUD		17	
#define DE_CONTROL	18	
#define DE_BOOTBLOCKS	19	

OBJECT FileSysStartupMsg
 
    Unit:LONG	
    Device:BSTR	
    Environ:LONG	
    Flags:LONG	
ENDOBJECT


OBJECT DeviceNode
 
    Next:LONG	
    Type:LONG	
      Task:PTR TO MsgPort	
    Lock:LONG	
    Handler:BSTR	
    StackSize:LONG	
    Priority:LONG	
    Startup:LONG	
    SegList:LONG	
    GlobalVec:LONG	
    Name:BSTR	
ENDOBJECT

#endif	
