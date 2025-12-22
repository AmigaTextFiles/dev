#ifndef INTUITION_PREFERENCES_H
#define INTUITION_PREFERENCES_H TRUE

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef DEVICES_TIMER_H
MODULE  'devices/timer'
#endif




#define	FILENAME_SIZE	30	
#define DEVNAME_SIZE	16	
#define	POINTERSIZE 36  ->(1 + 16 + 1) * 2	

#define TOPAZ_EIGHTY 8
#define TOPAZ_SIXTY 9

OBJECT Preferences

    
    FontHeight:BYTE			
    
    PrinterPort:UBYTE			
    
    BaudRate:UWORD			
    
      KeyRptSpeed:timeval		
      KeyRptDelay:timeval		
      DoubleClick:timeval		
    
    PointerMatrix[POINTERSIZE]:UWORD	
    XOffset:BYTE			
    YOffset:BYTE			
    color17:UWORD			
    color18:UWORD			
    color19:UWORD			
    PointerTicks:UWORD			
    
    color0:UWORD			
    color1:UWORD			
    color2:UWORD			
    color3:UWORD			
    
    ViewXOffset:BYTE			
    ViewYOffset:BYTE			
    ViewInitX:WORD
 ViewInitY:WORD		
    EnableCLI:BOOL			
    
    PrinterType:UWORD			
    PrinterFilename[FILENAME_SIZE]:UBYTE
    
    PrintPitch:UWORD			
    PrintQuality:UWORD			
    PrintSpacing:UWORD			
    PrintLeftMargin:UWORD		
    PrintRightMargin:UWORD		
    PrintImage:UWORD			
    PrintAspect:UWORD			
    PrintShade:UWORD			
    PrintThreshold:WORD		
    
    PaperSize:UWORD			
    PaperLength:UWORD			
    PaperType:UWORD			
    
    
    SerRWBits:UBYTE	 
			 
    SerStopBuf:UBYTE  
			 
    SerParShk:UBYTE	 
			 
    LaceWB:UBYTE	 
    Pad[ 12 ]:UBYTE
    PrtDevName[DEVNAME_SIZE]:UBYTE	
    DefaultPrtUnit:UBYTE	
    DefaultSerUnit:UBYTE	
    RowSizeChange:BYTE	
    ColumnSizeChange:BYTE
    PrintFlags:UWORD	
    PrintMaxWidth:UWORD	
    PrintMaxHeight:UWORD	
    PrintDensity:UBYTE	
    PrintXOffset:UBYTE	
    Width:UWORD		
    Height:UWORD		
    Depth:UBYTE		
    size:UBYTE		
			    
ENDOBJECT


#define LACEWB			(1<< 0)
#define LW_RESERVED	1		

#define SCREEN_DRAG	(1<<14)
#define MOUSE_ACCEL	(1<<15)

#define PARALLEL_PRINTER $00
#define SERIAL_PRINTER	$01

#define BAUD_110	$00
#define BAUD_300	$01
#define BAUD_1200	$02
#define BAUD_2400	$03
#define BAUD_4800	$04
#define BAUD_9600	$05
#define BAUD_19200	$06
#define BAUD_MIDI	$07

#define FANFOLD	$00
#define SINGLE		$80

#define PICA		$000
#define ELITE		$400
#define FINE		$800

#define DRAFT		$000
#define LETTER		$100

#define SIX_LPI		$000
#define EIGHT_LPI	$200

#define IMAGE_POSITIVE	$00
#define IMAGE_NEGATIVE	$01

#define ASPECT_HORIZ	$00
#define ASPECT_VERT	$01

#define SHADE_BW	$00
#define SHADE_GREYSCALE	$01
#define SHADE_COLOR	$02

#define US_LETTER	$00
#define US_LEGAL	$10
#define N_TRACTOR	$20
#define W_TRACTOR	$30
#define CUSTOM		$40

#define EURO_A0	$50		
#define EURO_A1	$60		
#define EURO_A2	$70		
#define EURO_A3	$80		
#define EURO_A4	$90		
#define EURO_A5	$A0		
#define EURO_A6	$B0		
#define EURO_A7	$C0		
#define EURO_A8	$D0		

#define CUSTOM_NAME		$00
#define	ALPHA_P_101		$01
#define BROTHER_15XL		$02
#define CBM_MPS1000		$03
#define DIAB_630		$04
#define DIAB_ADV_D25		$05
#define DIAB_C_150		$06
#define EPSON			$07
#define EPSON_JX_80		$08
#define OKIMATE_20		$09
#define QUME_LP_20		$0A

#define HP_LASERJET		$0B
#define HP_LASERJET_PLUS	$0C

#define SBUF_512	$00
#define SBUF_1024	$01
#define SBUF_2048	$02
#define SBUF_4096	$03
#define SBUF_8000	$04
#define SBUF_16000	$05

#define	SREAD_BITS	$F0 
#define	SWRITE_BITS	$0F
#define	SSTOP_BITS	$F0 
#define	SBUFSIZE_BITS	$0F
#define	SPARITY_BITS	$F0 
#define SHSHAKE_BITS	$0F

#define SPARITY_NONE	 0
#define SPARITY_EVEN	 1
#define SPARITY_ODD	 2

#define SPARITY_MARK	 3
#define SPARITY_SPACE	 4

#define SHSHAKE_XON	 0
#define SHSHAKE_RTS	 1
#define SHSHAKE_NONE	 2

#define CORRECT_RED	    $0001  
#define CORRECT_GREEN	    $0002  
#define CORRECT_BLUE	    $0004  
#define CENTER_IMAGE	    $0008  
#define IGNORE_DIMENSIONS   $0000 
#define BOUNDED_DIMENSIONS  $0010  
#define ABSOLUTE_DIMENSIONS $0020  
#define PIXEL_DIMENSIONS    $0040  
#define MULTIPLY_DIMENSIONS $0080 
#define INTEGER_SCALING     $0100  
#define ORDERED_DITHERING   $0000 
#define HALFTONE_DITHERING  $0200  
#define FLOYD_DITHERING     $0400 
#define ANTI_ALIAS	    $0800 
#define GREY_SCALE2	    $1000 

#define CORRECT_RGB_MASK    (CORRECT_RED OR CORRECT_GREEN OR CORRECT_BLUE)
#define DIMENSIONS_MASK     (BOUNDED_DIMENSIONS OR ABSOLUTE_DIMENSIONS OR PIXEL_DIMENSIONS OR MULTIPLY_DIMENSIONS)
#define DITHERING_MASK	    (HALFTONE_DITHERING OR FLOYD_DITHERING)
#endif
