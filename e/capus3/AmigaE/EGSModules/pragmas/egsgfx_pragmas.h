/*-----------------------------------------------------------------*/
/* Filename : egsgfx.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egsgfx.def*/
/**/
/* (c) Copyright 1990/92 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. Juli 1992*/
/* Updated     : 14. Juli 1992*/
/*             : 26. Juli 1992  us*/
/*               17. Dezember 1992 mvk*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGSGfxBase EG_SetAPen 1E 0802
#pragma libcall EGSGfxBase EG_SetBPen 24 0802
#pragma libcall EGSGfxBase EG_SetDrMd 2A 0802
#pragma libcall EGSGfxBase EG_Move 30 10803
#pragma libcall EGSGfxBase EG_WritePixel 36 10803
#pragma libcall EGSGfxBase EG_ReadPixel 3C 10803
#pragma libcall EGSGfxBase EG_Draw 42 10803
#pragma libcall EGSGfxBase EG_Curve 48 543210807
#pragma libcall EGSGfxBase EG_Text 4E 09803
#pragma libcall EGSGfxBase EG_RectFill 54 3210805
#pragma libcall EGSGfxBase EG_CopyBitMapRastPort 5A 5432109808
#pragma libcall EGSGfxBase EG_ScrollRaster 60 543210807
#pragma libcall EGSGfxBase EG_FillMask 66 109804
#pragma libcall EGSGfxBase EG_AreaCircle 6C 210804
#pragma libcall EGSGfxBase EG_AreaMove 72 10803
#pragma libcall EGSGfxBase EG_AreaDraw 78 10803
#pragma libcall EGSGfxBase EG_AreaEnd 7E 801
#pragma libcall EGSGfxBase EG_AreaCurve 84 543210807
#pragma libcall EGSGfxBase EG_InitArea 8A 09803
#pragma libcall EGSGfxBase EG_OpenFont 90 801
#pragma libcall EGSGfxBase EG_CloseFont 96 801
#pragma libcall EGSGfxBase EG_StdFont 9C 0
#pragma libcall EGSGfxBase EG_InstallClipRegion A2 9802
#pragma libcall EGSGfxBase EG_RemoveClipRegion A8 801
#pragma libcall EGSGfxBase EG_CreateRastPort AE A9803
#pragma libcall EGSGfxBase EG_DeleteRastPort B4 801
#pragma libcall EGSGfxBase EG_SetFont BA 9802
#pragma libcall EGSGfxBase EG_SetSoftStyle C0 10803
#pragma libcall EGSGfxBase EG_Ellipse C6 3210805
#pragma libcall EGSGfxBase EG_SetMask CC 0802
#pragma libcall EGSGfxBase EG_TextLength D2 09803
#pragma libcall EGSGfxBase EG_Flood D8 210804
#pragma libcall EGSGfxBase EG_CopyRectangle DE 5432109808
#pragma libcall EGSGfxBase EG_FillMaskSeg E4 5432109808
#pragma libcall EGSGfxBase EG_CurveL EA 543210807
#pragma libcall EGSGfxBase EG_AreaCurveL F0 543210807
#pragma libcall EGSGfxBase EG_CheckRectangle F6 9802
