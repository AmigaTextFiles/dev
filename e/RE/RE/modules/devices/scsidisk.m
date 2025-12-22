#ifndef	DEVICES_SCSIDISK_H
#define	DEVICES_SCSIDISK_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 

#define	HD_SCSICMD	28	
				
				
				
OBJECT SCSICmd
 
    Data:PTR TO UWORD		
				
				
    Length:LONG	
				
				
    Actual:LONG	
    Command:PTR TO UBYTE	
    CmdLength:UWORD	
    CmdActual:UWORD	
    Flags:UBYTE		
    Status:UBYTE	
    SenseData:PTR TO UBYTE	
				
				
    SenseLength:UWORD	
				
    SenseActual:UWORD	
ENDOBJECT


#define	SCSIF_WRITE		0	
#define	SCSIF_READ		1	
#define	SCSIB_READ_WRITE	0	
#define	SCSIF_NOSENSE		0	
#define	SCSIF_AUTOSENSE		2	
					
#define	SCSIF_OLDAUTOSENSE	6	
					
#define	SCSIB_AUTOSENSE		1	
#define	SCSIB_OLDAUTOSENSE	2	

#define	HFERR_SelfUnit		40	
#define	HFERR_DMA		41	
#define	HFERR_Phase		42	
#define	HFERR_Parity		43	
#define	HFERR_SelTimeout	44	
#define	HFERR_BadStatus		45	

#define	HFERR_NoBoard		50	
#endif	
