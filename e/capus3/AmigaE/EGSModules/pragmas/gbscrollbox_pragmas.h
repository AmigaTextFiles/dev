/*-----------------------------------------------------------------*/
/* Filename : gbscrollbox.fd*/
/* Release  : 1.0*/
/**/
/* fd file for gbscroll.def*/
/**/
/* (c) Copyright 1990/92 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. July 1992*/
/* Updated     : 14. July 1992*/
/* Updated     : 03. Aug  1992 US*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGBScrollBase EGB_CreateLateScrollBox 1E 543210807
#pragma libcall EGBScrollBase EGB_AddItemToScrollBox 24 A9803
#pragma libcall EGBScrollBase EGB_AddListToScrollBox 2A A9803
#pragma libcall EGBScrollBase EGB_RemItemFromScrollBox 30 A9803
#pragma libcall EGBScrollBase EGB_UpdateScrollBox 36 9802
#pragma libcall EGBScrollBase EGB_RemListFromScrollBox 3C A9803
#pragma libcall EGBScrollBase EGB_NextElem 42 9802
#pragma libcall EGBScrollBase EGB_PrevElem 48 9802
#pragma libcall EGBScrollBase EGB_ActivateElem 4E A9803
#pragma libcall EGBScrollBase EGB_SetTopElem 54 A9803
#pragma libcall EGBScrollBase EGB_LinkStringToScroll 5A 9802
