#ifndef DEVICES_PRTGFX_H
#define DEVICES_PRTGFX_H

#ifndef  EXEC_TYPES_H
MODULE  'exec/types'
#endif
#define	PCMYELLOW	0		
#define	PCMMAGENTA	1		
#define	PCMCYAN		2		
#define	PCMBLACK	3		
#define PCMBLUE		PCMYELLOW	
#define PCMGREEN	PCMMAGENTA	
#define PCMRED		PCMCYAN		
#define PCMWHITE	PCMBLACK	
UNION colorEntry
 
	colorLong:LONG	
	colorByte[4]:UBYTE	
	colorSByte[4]:BYTE	
ENDUNION

OBJECT PrtInfo
  
	render:LONG		
	  rp:PTR TO RastPort		
	  temprp:PTR TO RastPort	
	RowBuf:PTR TO UWORD		
	HamBuf:PTR TO UWORD		
	  ColorMap:PTR TO colorEntry	
	  ColorInt:PTR TO colorEntry	
	  HamInt:PTR TO colorEntry	
	  Dest1Int:PTR TO colorEntry	
	  Dest2Int:PTR TO colorEntry	
	ScaleX:PTR TO UWORD		
	ScaleXAlt:PTR TO UWORD		
	dmatrix:PTR TO UBYTE		
	TopBuf:PTR TO UWORD		
	BotBuf:PTR TO UWORD		
	RowBufSize:UWORD		
	HamBufSize:UWORD		
	ColorMapSize:UWORD		
	ColorIntSize:UWORD		
	HamIntSize:UWORD		
	Dest1IntSize:UWORD		
	Dest2IntSize:UWORD		
	ScaleXSize:UWORD		
	ScaleXAltSize:UWORD		
	PrefsFlags:UWORD		
	special:LONG		
	xstart:UWORD		
	ystart:UWORD		
	width:UWORD			
	height:UWORD		
	pc:LONG			
	pr:LONG			
	ymult:UWORD			
	ymod:UWORD			
	ety:WORD			
	xpos:UWORD			
	threshold:UWORD		
	tempwidth:UWORD		
	flags:UWORD			
ENDOBJECT

#endif	
