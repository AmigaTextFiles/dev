/*-----------------------------------------------------------------*/
/* Filename : egsblit.fd*/
/* Release  : 1.0*/
/**/
/* fd file for egsblit.def*/
/**/
/* (c) Copyright 1990/93 VIONA Development*/
/*     All Rights Reserved*/
/**/
/* Author      : Markus van Kempen*/
/* Created     : 14. July 1992*/
/* Updated     : 14. July 1992*/
/*             : 24. July 1992 us*/
/*               17. December 1992 mvk*/
/*               31. Januar 1993*/
/**/
/*-----------------------------------------------------------------*/
#pragma libcall EGSBlitBase EB_ReadPixel 1E 10803
#pragma libcall EGSBlitBase EB_WritePixel 24 3210805
#pragma libcall EGSBlitBase EB_InvertPixel 2A 10803
#pragma libcall EGSBlitBase EB_Draw 30 543210807
#pragma libcall EGSBlitBase EB_DrawClipped 36 5432109808
#pragma libcall EGSBlitBase EB_InvertRectangle 3C 3210805
#pragma libcall EGSBlitBase EB_RectangleFill 42 543210807
#pragma libcall EGSBlitBase EB_RectangleClipped 48 5432109808
#pragma libcall EGSBlitBase EB_Write 4E 32B10A807
#pragma libcall EGSBlitBase EB_WriteClipped 54 32B10A9808
#pragma libcall EGSBlitBase EB_CopyBitMap 5A 65432109809
#pragma libcall EGSBlitBase EB_CopyBitMapClipped 60 6543210A980A
#pragma libcall EGSBlitBase EB_FillMask 66 210A9806
#pragma libcall EGSBlitBase EB_FillMaskClipped 6C 210BA9807
#pragma libcall EGSBlitBase EB_UnpackImage 72 A0903
#pragma libcall EGSBlitBase EB_BitAreaCircle 78 0802
#pragma libcall EGSBlitBase EB_BitAreaPolygon 7E 2109805
#pragma libcall EGSBlitBase EB_FloodFill 84 32109806
#pragma libcall EGSBlitBase EB_ExtractColor 8A 65432109809
#pragma libcall EGSBlitBase EB_FloodOneBit 90 10A9805
#pragma libcall EGSBlitBase EB_FloodZeroBit 96 10A9805
