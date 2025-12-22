/*-----------------------------------------------------------------*/
/* Filename : egslayers.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egslayers.def*/
/**/
/* (c) Copyright 1990/93 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. July 1992*/
/* Updated     : 14. July 1992*/
/*             : 24. July 1992 us*/
/*               17. Dec  1992 mvk*/
/*               09. Jan  1993 us*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGSLayersBase EL_FreeRect 1E 801
#pragma libcall EGSLayersBase EL_FreeRegion 24 801
#pragma libcall EGSLayersBase EL_NewRect 2A 0
#pragma libcall EGSLayersBase EL_DupRegion 30 801
#pragma libcall EGSLayersBase EL_DupMoveRegion 36 21803
#pragma libcall EGSLayersBase EL_MoveRegion 3C 21803
#pragma libcall EGSLayersBase EL_OrRectRegion 42 9802
#pragma libcall EGSLayersBase EL_OrRegionRegion 48 9802
#pragma libcall EGSLayersBase EL_DelRectRegion 4E 9802
#pragma libcall EGSLayersBase EL_DelRegionRegion 54 9802
#pragma libcall EGSLayersBase EL_AndRectRegion 5A 9802
#pragma libcall EGSLayersBase EL_AndRegionRegion 60 9802
#pragma libcall EGSLayersBase EL_CreateLayerInfo 66 A2109806
#pragma libcall EGSLayersBase EL_FreeLayerInfo 6C 801
#pragma libcall EGSLayersBase EL_LockLayer 72 801
#pragma libcall EGSLayersBase EL_UnlockLayer 78 801
#pragma libcall EGSLayersBase EL_LockLayerInfo 7E 801
#pragma libcall EGSLayersBase EL_UnlockLayerInfo 84 801
#pragma libcall EGSLayersBase EL_LockLayers 8A 801
#pragma libcall EGSLayersBase EL_UnlockLayers 90 801
#pragma libcall EGSLayersBase EL_CreateUpfrontLayer 96 76543210809
#pragma libcall EGSLayersBase EL_CreateBehindLayer 9C 76543210809
#pragma libcall EGSLayersBase EL_DeleteLayer A2 801
#pragma libcall EGSLayersBase EL_LayerToFront A8 801
#pragma libcall EGSLayersBase EL_LayerToBack AE 801
#pragma libcall EGSLayersBase EL_MoveLayerBehind B4 9802
#pragma libcall EGSLayersBase EL_MoveLayerInFront BA 9802
#pragma libcall EGSLayersBase EL_MoveLayer C0 10803
#pragma libcall EGSLayersBase EL_SizeLayer C6 10803
#pragma libcall EGSLayersBase EL_ScrollLayer CC 10803
#pragma libcall EGSLayersBase EL_WhichLayer D2 10803
#pragma libcall EGSLayersBase EL_BeginUpdate D8 0802
#pragma libcall EGSLayersBase EL_EndUpdate DE 0802
#pragma libcall EGSLayersBase EL_UpdateBackMap E4 801
#pragma libcall EGSLayersBase EL_UpdateFrontMap EA 801
#pragma libcall EGSLayersBase EL_AndSmartClip F0 9802
#pragma libcall EGSLayersBase EL_FreeSmartList F6 801
#pragma libcall EGSLayersBase EL_Invalidate FC 09803
#pragma libcall EGSLayersBase EL_InstallLHook 102 9802
#pragma libcall EGSLayersBase EL_InstallLIHook 108 9802
#pragma libcall EGSLayersBase EL_RemoveRefreshRegion 10E 9802
