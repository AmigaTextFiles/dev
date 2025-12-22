#ifndef	GRAPHICS_LAYERS_H
#define	GRAPHICS_LAYERS_H

#ifndef EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif
#define LAYERSIMPLE		1
#define LAYERSMART		2
#define LAYERSUPER		4
#define LAYERUPDATING		$10
#define LAYERBACKDROP		$40
#define LAYERREFRESH		$80
#define	LAYERIREFRESH		$200
#define	LAYERIREFRESH2		$400
#define LAYER_CLIPRECTS_LOST	$100	
					
					
OBJECT Layer_Info

			layer:PTR TO Layer
			lp:PTR TO Layer		
		obs:PTR TO ClipRect
		FreeClipRects:PTR TO ClipRect		
	PrivateReserve1:LONG	
	PrivateReserve2:LONG	
		Lock:SignalSemaphore			
			Head:MinList		
	PrivateReserve3:WORD	
	PrivateReserve4:PTR TO LONG	
	Flags:UWORD
	count:BYTE		
	LockLayersCount:BYTE	
	PrivateReserve5:WORD	
	BlankHook:PTR TO LONG		
	extra:PTR TO LONG	
ENDOBJECT

#define NEWLAYERINFO_CALLED 1

#define	LAYERS_NOBACKFILL	(  1)
#define	LAYERS_BACKFILL		(  0)
#endif	
