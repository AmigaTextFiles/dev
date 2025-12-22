#ifndef GRAPHICS_VIEW_H
#define GRAPHICS_VIEW_H

#define ECS_SPECIFIC
#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif
#ifndef GRAPHICS_COPPER_H
MODULE  'graphics/copper'
#endif
#ifndef GRAPHICS_GFXNODES_H
MODULE  'graphics/gfxnodes'
#endif
#ifndef GRAPHICS_MONITOR_H
MODULE  'graphics/monitor'
#endif
#ifndef GRAPHICS_DISPLAYINFO_H
MODULE  'graphics/displayinfo'
#endif
#ifndef HARDWARE_CUSTOM_H
MODULE  'hardware/custom'
#endif
OBJECT ViewPort

		 Next:PTR TO ViewPort
		 ColorMap:PTR TO ColorMap	
					
		  DspIns:PTR TO CopList	
		  SprIns:PTR TO CopList	
		  ClrIns:PTR TO CopList	
		 UCopIns:PTR TO UCopList	
	DWidth:WORD
DHeight:WORD
	DxOffset:WORD
DyOffset:WORD
	Modes:UWORD
	SpritePriorities:UBYTE
	ExtendedModes:UBYTE
		 RasInfo:PTR TO RasInfo
ENDOBJECT

OBJECT View

		 ViewPort:PTR TO ViewPort
		 LOFCprList:PTR TO cprlist   
		 SHFCprList:PTR TO cprlist   
	DyOffset:WORD
DxOffset:WORD   
				   
	Modes:UWORD		   
ENDOBJECT



OBJECT ViewExtra

	  n:ExtendedNode
	  View:PTR TO View		
	  Monitor:PTR TO MonitorSpec	
	TopLine:UWORD
ENDOBJECT



OBJECT ViewPortExtra

	  n:ExtendedNode
	  ViewPort:PTR TO ViewPort	
	  DisplayClip:Rectangle	
	
	VecTable:LONG		
	DriverData[2]:LONG
	Flags:UWORD
	Origin[2]:Point		
	cop1ptr:LONG			
	cop2ptr:LONG			
ENDOBJECT


#define VPXB_FREE_ME		0
#define VPXF_FREE_ME		(1 << VPXB_FREE_ME)
#define VPXB_LAST		1
#define VPXF_LAST		(1 << VPXB_LAST)
#define VPXB_STRADDLES_256	4
#define VPXF_STRADDLES_256	(1 << VPXB_STRADDLES_256)
#define VPXB_STRADDLES_512	5
#define VPXF_STRADDLES_512	(1 << VPXB_STRADDLES_512)
#define EXTEND_VSTRUCT	$1000	
#define VPF_A2024	      $40	
#define VPF_TENHZ	      $20
#define VPB_A2024	      6
#define VPB_TENHZ	      4

#define GENLOCK_VIDEO	$0002
#define LACE		$0004
#define DOUBLESCAN	$0008
#define SUPERHIRES	$0020
#define PFBA		$0040
#define EXTRA_HALFBRITE $0080
#define GENLOCK_AUDIO	$0100
#define DUALPF		$0400
#define HAM		$0800
#define EXTENDED_MODE	$1000
#define VP_HIDE	$2000
#define SPRITES	$4000
#define HIRES		$8000
OBJECT RasInfo
	
       Next:PTR TO RasInfo	    
       BitMap:PTR TO BitMap
   RxOffset:WORD
RyOffset:WORD	   
ENDOBJECT

OBJECT ColorMap

	Flags:UBYTE
	Type:UBYTE
	Count:UWORD
	ColorTable:LONG
		 vpe:PTR TO ViewPortExtra
	LowColorBits:LONG
	TransparencyPlane:UBYTE
	SpriteResolution:UBYTE
	SpriteResDefault:UBYTE	
	AuxFlags:UBYTE
		 vp:PTR TO ViewPort
	NormalDisplayInfo:LONG
	CoerceDisplayInfo:LONG
		 batch_items:PTR TO TagItem
	VPModeID:LONG
		 PalExtra:PTR TO PaletteExtra
	Even:UWORD
	Odd:UWORD
  Bp_0_base:UWORD
	Bp_1_base:UWORD
ENDOBJECT




#define COLORMAP_TYPE_V1_2	$00
#define COLORMAP_TYPE_V1_4	$01
#define COLORMAP_TYPE_V36 COLORMAP_TYPE_V1_4	
#define COLORMAP_TYPE_V39	$02

#define COLORMAP_TRANSPARENCY	$01
#define COLORPLANE_TRANSPARENCY	$02
#define BORDER_BLANKING		$04
#define BORDER_NOTRANSPARENCY	$08
#define VIDEOCONTROL_BATCH	$10
#define USER_COPPER_CLIP	$20
#define BORDERSPRITES	$40
#define CMF_CMTRANS	0
#define CMF_CPTRANS	1
#define CMF_BRDRBLNK	2
#define CMF_BRDNTRAN	3
#define CMF_BRDRSPRT	6
#define SPRITERESN_ECS		0

#define SPRITERESN_140NS	1
#define SPRITERESN_70NS		2
#define SPRITERESN_35NS		3
#define SPRITERESN_DEFAULT	-1

#define CMAB_FULLPALETTE 0
#define CMAF_FULLPALETTE (1<<CMAB_FULLPALETTE)
#define CMAB_NO_INTERMED_UPDATE 1
#define CMAF_NO_INTERMED_UPDATE (1<<CMAB_NO_INTERMED_UPDATE)
#define CMAB_NO_COLOR_LOAD 2
#define CMAF_NO_COLOR_LOAD (1 << CMAB_NO_COLOR_LOAD)
#define CMAB_DUALPF_DISABLE 3
#define CMAF_DUALPF_DISABLE (1 << CMAB_DUALPF_DISABLE)
OBJECT PaletteExtra
				
	  Semaphore:SignalSemaphore		
	FirstFree:UWORD				
	NFree:UWORD				
	FirstShared:UWORD				
	NShared:UWORD				
	RefCnt:PTR TO UBYTE				
	AllocList:PTR TO UBYTE				
	  ViewPort:PTR TO ViewPort			
	SharableColors:UWORD			
ENDOBJECT


#define PENB_EXCLUSIVE 0
#define PENB_NO_SETCOLOR 1
#define PENF_EXCLUSIVE (1l<<PENB_EXCLUSIVE)
#define PENF_NO_SETCOLOR (1l<<PENB_NO_SETCOLOR)

#define PEN_EXCLUSIVE PENF_EXCLUSIVE
#define PEN_NO_SETCOLOR PENF_NO_SETCOLOR

#define PRECISION_EXACT	-1
#define PRECISION_IMAGE	0
#define PRECISION_ICON	16
#define PRECISION_GUI	32

#define OBP_Precision $84000000
#define OBP_FailIfBad $84000001

#define MVP_OK		0	
#define MVP_NO_MEM	1	
#define MVP_NO_VPE	2	
#define MVP_NO_DSPINS	3	
#define MVP_NO_DISPLAY	4	
#define MVP_OFF_BOTTOM	5	

#define MCOP_OK		0	
#define MCOP_NO_MEM	1	
#define MCOP_NOP	2	
OBJECT DBufInfo
 
	Link1:LONG
	Count1:LONG
	  SafeMessage:Message		
	UserData1:LONG			
	Link2:LONG
	Count2:LONG
	  DispMessage:Message	
	UserData2:LONG			
	MatchLong:LONG
	CopPtr1:LONG
	CopPtr2:LONG
	CopPtr3:LONG
	BeamPos1:UWORD
	BeamPos2:UWORD
ENDOBJECT

#endif	
