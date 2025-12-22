#ifndef	GRAPHICS_DISPLAYINFO_H
#define	GRAPHICS_DISPLAYINFO_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif 
#ifndef GRAPHICS_MONITOR_H
MODULE  'graphics/monitor'
#endif 
#ifndef GRAPHICS_MODEID_H
MODULE  'graphics/modeid'
#endif 
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif 

  
#define DisplayInfoHandle APTR


#define DTAG_DISP		$80000000
#define DTAG_DIMS		$80001000
#define DTAG_MNTR		$80002000
#define DTAG_NAME		$80003000
#define DTAG_VEC		$80004000	
OBJECT QueryHeader

	StructID:LONG	
	DisplayID:LONG	
	SkipID:LONG		
	Length:LONG		
ENDOBJECT

OBJECT DisplayInfo

		 Header:QueryHeader
	NotAvailable:UWORD	
	PropertyFlags:LONG	
	Resolution:Point	
	PixelSpeed:UWORD	
	NumStdSprites:UWORD	
	PaletteRange:UWORD	
	SpriteResolution:Point 
	pad[4]:UBYTE		
	RedBits:UBYTE	
	GreenBits:UBYTE	
	BlueBits:UBYTE	
	pad2[5]:UBYTE	
	reserved[2]:LONG	
ENDOBJECT


#define DI_AVAIL_NOCHIPS	$0001
#define DI_AVAIL_NOMONITOR	$0002
#define DI_AVAIL_NOTWITHGENLOCK	$0004

#define DIPF_IS_LACE		$00000001
#define DIPF_IS_DUALPF		$00000002
#define DIPF_IS_PF2PRI		$00000004
#define DIPF_IS_HAM		$00000008
#define DIPF_IS_ECS		$00000010	
#define DIPF_IS_AA		$00010000	
#define DIPF_IS_PAL		$00000020
#define DIPF_IS_SPRITES		$00000040
#define DIPF_IS_GENLOCK		$00000080
#define DIPF_IS_WB		$00000100
#define DIPF_IS_DRAGGABLE	$00000200
#define DIPF_IS_PANELLED	$00000400
#define DIPF_IS_BEAMSYNC	$00000800
#define DIPF_IS_EXTRAHALFBRITE	$00001000

#define DIPF_IS_SPRITES_ATT		$00002000	
#define DIPF_IS_SPRITES_CHNG_RES	$00004000	
#define DIPF_IS_SPRITES_BORDER		$00008000	
#define DIPF_IS_SCANDBL			$00020000	
#define DIPF_IS_SPRITES_CHNG_BASE	$00040000
											
#define DIPF_IS_SPRITES_CHNG_PRI	$00080000
											
#define DIPF_IS_DBUFFER		$00100000	
#define DIPF_IS_PROGBEAM	$00200000	
#define DIPF_IS_FOREIGN		$80000000	
OBJECT DimensionInfo

		 Header:QueryHeader
	MaxDepth:UWORD	      
	MinRasterWidth:UWORD       
	MinRasterHeight:UWORD      
	MaxRasterWidth:UWORD       
	MaxRasterHeight:UWORD      
		   Nominal:Rectangle  
		   MaxOScan:Rectangle 
		 VideoOScan:Rectangle 
		   TxtOScan:Rectangle 
		   StdOScan:Rectangle 
	pad[14]:UBYTE
	reserved[2]:LONG	      
ENDOBJECT

OBJECT MonitorInfo

		 Header:QueryHeader
		  Mspc:PTR TO MonitorSpec   
	ViewPosition:Point	      
	ViewResolution:Point       
		 ViewPositionRange:Rectangle  
	TotalRows:UWORD	      
	TotalColorClocks:UWORD     
	MinRow:UWORD	      
	Compatibility:WORD	      
	pad[32]:UBYTE
	MouseTicks:Point
	DefaultViewPosition:Point  
	PreferredModeID:LONG      
	reserved[2]:LONG	      
ENDOBJECT


#define MCOMPAT_MIXED	0	
#define MCOMPAT_SELF	1	
#define MCOMPAT_NOBODY -1	
#define DISPLAYNAMELEN 32
OBJECT NameInfo

		 Header:QueryHeader
	Name[DISPLAYNAMELEN]:UBYTE
	reserved[2]:LONG	      
ENDOBJECT



OBJECT VecInfo

		   Header:QueryHeader
	Vec:LONG
	Data:LONG
	Type:UWORD
	pad[3]:UWORD
	reserved[2]:LONG
ENDOBJECT

#endif	
