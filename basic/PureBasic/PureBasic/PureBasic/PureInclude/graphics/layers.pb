;
; ** $VER: layers.h 39.4 (14.4.92)
; ** Includes Release 40.15
; **
; ** (C) Copyright 1985-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"

XIncludeFile "exec/lists.pb"
XIncludeFile "exec/semaphores.pb"

#LAYERSIMPLE  = 1
#LAYERSMART  = 2
#LAYERSUPER  = 4
#LAYERUPDATING  = $10
#LAYERBACKDROP  = $40
#LAYERREFRESH  = $80
#LAYERIREFRESH  = $200
#LAYERIREFRESH2  = $400
#LAYER_CLIPRECTS_LOST = $100 ;  during BeginUpdate
     ;  or during layerop
     ;  this happens if out of memory

Structure Layer_Info

 *top_layer.Layer
 *check_lp.Layer  ;  !! Private !!
 *obs.ClipRect
 *FreeClipRects.ClipRect  ;  !! Private !!
  PrivateReserve1.l ;  !! Private !!
  PrivateReserve2.l ;  !! Private !!
  Lock.SignalSemaphore   ;  !! Private !!
  gs_Head.MinList  ;  !! Private !!
  PrivateReserve3.w ;  !! Private !!
 *PrivateReserve4.l ;  !! Private !!
  Flags.w
  fatten_count.b  ;  !! Private !!
  LockLayersCount.b ;  !! Private !!
  PrivateReserve5.w ;  !! Private !!
 *BlankHook.l  ;  !! Private !!
 *LayerInfo_extra.l ;  !! Private !!
EndStructure

#NEWLAYERINFO_CALLED = 1

;
;  * LAYERS_NOBACKFILL is the value needed to get no backfill hook
;  * LAYERS_BACKFILL is the value needed to get the default backfill hook
;
;#LAYERS_NOBACKFILL = ((*)1).Hook
;#LAYERS_BACKFILL  = ((*)0).Hook

