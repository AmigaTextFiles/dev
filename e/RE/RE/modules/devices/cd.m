
#ifndef DEVICES_CD_H
#define DEVICES_CD_H

MODULE  'exec/types'
MODULE  'exec/nodes'

#define CD_RESET	     1
#define CD_READ	     2
#define CD_WRITE	     3
#define CD_UPDATE	     4
#define CD_CLEAR	     5
#define CD_STOP	     6
#define CD_START	     7
#define CD_FLUSH	     8
#define CD_MOTOR	     9
#define CD_SEEK	    10
#define CD_FORMAT	    11
#define CD_REMOVE	    12
#define CD_CHANGENUM	    13
#define CD_CHANGESTATE	    14
#define CD_PROTSTATUS	    15
#define CD_GETDRIVETYPE     18
#define CD_GETNUMTRACKS     19
#define CD_ADDCHANGEINT     20
#define CD_REMCHANGEINT     21
#define CD_GETGEOMETRY	    22
#define CD_EJECT	    23
#define CD_INFO	    32
#define CD_CONFIG	    33
#define CD_TOCMSF	    34
#define CD_TOCLSN	    35
#define CD_READXL	    36
#define CD_PLAYTRACK	    37
#define CD_PLAYMSF	    38
#define CD_PLAYLSN	    39
#define CD_PAUSE	    40
#define CD_SEARCH	    41
#define CD_QCODEMSF	    42
#define CD_QCODELSN	    43
#define CD_ATTENUATE	    44
#define CD_ADDFRAMEINT	    45
#define CD_REMFRAMEINT	    46

#define CDERR_OPENFAIL	     (-1) 
#define CDERR_ABORTED	     (-2) 
#define CDERR_NOCMD	     (-3) 
#define CDERR_BADLENGTH      (-4) 
#define CDERR_BADADDRESS     (-5) 
#define CDERR_UNITBUSY	     (-6) 
#define CDERR_SELFTEST	     (-7) 
#define CDERR_NotSpecified   20   
#define CDERR_NoSecHdr	     21   
#define CDERR_BadSecPreamble 22   
#define CDERR_BadSecID	     23   
#define CDERR_BadHdrSum      24   
#define CDERR_BadSecSum      25   
#define CDERR_TooFewSecs     26   
#define CDERR_BadSecHdr      27   
#define CDERR_WriteProt      28   
#define CDERR_NoDisk	     29   
#define CDERR_SeekError      30   
#define CDERR_NoMem	     31   
#define CDERR_BadUnitNum     32   
#define CDERR_BadDriveType   33   
#define CDERR_DriveInUse     34   
#define CDERR_PostReset      35   
#define CDERR_BadDataType    36   
#define CDERR_InvalidState   37   
#define CDERR_Phase	     42   
#define CDERR_NoBoard	     50   

#define TAGCD_PLAYSPEED	$0001
#define TAGCD_READSPEED	$0002
#define TAGCD_READXLSPEED	$0003
#define TAGCD_SECTORSIZE	$0004
#define TAGCD_XLECC		$0005
#define TAGCD_EJECTRESET	$0006

OBJECT CDInfo
 
			    
    PlaySpeed:UWORD	    
    ReadSpeed:UWORD	    
    ReadXLSpeed:UWORD    
    SectorSize:UWORD     
    XLECC:UWORD	    
    EjectReset:UWORD     
    Reserved1[4]:UWORD   
    MaxSpeed:UWORD	    
    AudioPrecision:UWORD 
			    
    Status:UWORD	    
    Reserved2[4]:UWORD   
    ENDOBJECT


#define CDSTSB_CLOSED	 0 
#define CDSTSB_DISK	 1 
#define CDSTSB_SPIN	 2 
#define CDSTSB_TOC	 3 
#define CDSTSB_CDROM	 4 
#define CDSTSB_PLAYING	 5 
#define CDSTSB_PAUSED	 6 
#define CDSTSB_SEARCH	 7 
#define CDSTSB_DIRECTION 8 
#define CDSTSF_CLOSED	 $0001
#define CDSTSF_DISK	 $0002
#define CDSTSF_SPIN	 $0004
#define CDSTSF_TOC	 $0008
#define CDSTSF_CDROM	 $0010
#define CDSTSF_PLAYING	 $0020
#define CDSTSF_PAUSED	 $0040
#define CDSTSF_SEARCH	 $0080
#define CDSTSF_DIRECTION $0100

#define CDMODE_NORMAL	0	  
#define CDMODE_FFWD	1	  
#define CDMODE_FREV	2	  

OBJECT RMSF
 
    Reserved:UBYTE	    
    Minute:UBYTE	    
    Second:UBYTE	    
    Frame:UBYTE	    
    ENDOBJECT

UNION LSNMSF
 
       MSF:RMSF	    
    LSN:LONG	    
    ENDUNION


OBJECT CDXL
 
         Node:MinNode	       
    Buffer:LONG	       
    Length:LONG	       
    Actual:LONG	       
    IntData:LONG	       
    IntCode:LONG    
    ENDOBJECT


OBJECT TOCSummary
 
    FirstTrack:UBYTE 
    LastTrack:UBYTE  
      LeadOut:LSNMSF    
    ENDOBJECT

OBJECT TOCEntry
 
    CtlAdr:UBYTE     
    Track:UBYTE      
      Position:LSNMSF   
    ENDOBJECT

UNION CDTOC
 
      Summary:TOCSummary	
        Entry:TOCEntry	
    ENDUNION


OBJECT QCode
 
    CtlAdr:UBYTE	
    Track:UBYTE	
    Index:UBYTE	
    Zero:UBYTE		
      TrackPosition:LSNMSF 
      DiskPosition:LSNMSF	
    ENDOBJECT

#define CTLADR_CTLMASK $F0   
#define CTL_CTLMASK    $D0   
#define CTL_2AUD       $00   
#define CTL_2AUDEMPH   $10   
#define CTL_4AUD       $80   
#define CTL_4AUDEMPH   $90   
#define CTL_DATA       $40   
#define CTL_COPYMASK   $20   
#define CTL_COPY       $20   
#define CTLADR_ADRMASK $0F   
#define ADR_POSITION   $01   
#define ADR_UPC        $02   
#define ADR_ISRC       $03   
#define ADR_HYBRID     $05   
#endif
