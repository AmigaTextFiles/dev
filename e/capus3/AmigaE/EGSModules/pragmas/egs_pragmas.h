/*-----------------------------------------------------------------*/
/* Filename : egs.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egs.def*/
/**/
/* (c) Copyright 1990/93 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. Juli 1992*/
/* Updated     : 25. Juli 1992*/
/*               17. Dezember 1992*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGSBase EE_OpenScreen 1E 801
#pragma libcall EGSBase EE_CloseScreen 24 801
#pragma libcall EGSBase EE_MouseOn 2A 801
#pragma libcall EGSBase EE_MouseOff 30 801
#pragma libcall EGSBase EE_ModifyMouse 36 9802
#pragma libcall EGSBase EE_ScreenToFront 3C 801
#pragma libcall EGSBase EE_ScreenToBack 42 801
#pragma libcall EGSBase EE_ActivateEGSScreen 48 0
#pragma libcall EGSBase EE_ActivateAmigaScreen 4E 0
#pragma libcall EGSBase EE_SetRGB8 54 3210805
#pragma libcall EGSBase EE_ModifyEDCMP 5A 0802
/*pragma libcall EGSBase EPrivate0 60 0*/
/*pragma libcall EGSBase EPrivate1 66 0*/
/*pragma libcall EGSBase EPrivate2 6C 0*/
/*pragma libcall EGSBase EPrivate3 72 0*/
/*pragma libcall EGSBase EPrivate4 78 0*/
#pragma libcall EGSBase EE_Private5 7E 0
#pragma libcall EGSBase EE_DisposeBitMap 84 801
#pragma libcall EGSBase EE_ClearBitMap 8A 801
#pragma libcall EGSBase EE_SetMouseExcept 90 9802
#pragma libcall EGSBase EE_ResetMouseExcept 96 0
#pragma libcall EGSBase EE_GetRGB8 9C 0802
/*pragma libcall EGSBase EGSPrivate6 A2 0*/
#pragma libcall EGSBase EE_FlipMap A8 9802
#pragma libcall EGSBase EE_SetRGB8CM AE 109804
#pragma libcall EGSBase EE_GetHardInfo B4 0
#pragma libcall EGSBase EE_GetRGB8CM BA 109804
#pragma libcall EGSBase EE_WaitTOF C0 0
#pragma libcall EGSBase EE_AllocBitMap C6 84321006
