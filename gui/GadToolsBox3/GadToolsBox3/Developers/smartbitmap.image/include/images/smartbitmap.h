#ifndef IMAGES_SMARTBITMAP_H
#define IMAGES_SMARTBITMAP_H
/*
**	$VER: smartbitmap.h 37.0 (13.2.96)
**
**	Definitions for the image BOOPSI class
**
**	(C) Copyright 1998 Tomasz Muszynski.
**	All Rights Reserved
*/

/*****************************************************************************/


#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif


/*****************************************************************************/

#define SMARTBITMAPNAME "images/smartbitmap.image"
#define SMARTBITMAPVERSION 39

struct SmartBitMapIRGB
{
	ULONG I,R,G,B;
};

#define SMBM_Dummy		(TAG_USER+0x00001000)
#define SMBM_Border		(SMBM_Dummy+1)			// draw gadget alike border around image
#define SMBM_SelBorder		(SMBM_Dummy+2)	// draw gadget alike border around image if selected
#define SMBM_Screen		(SMBM_Dummy+3)			// screen to display on
#define SMBM_BitMap		(IA_Data)						// bitmap data
#define SMBM_Palette	(SMBM_Dummy+4)			// smartbitmapirgbs
#define SMBM_Pens			(IA_Pens)						// UWORDs for pens conversion
#define SMBM_AllocPens (SMBM_Dummy+5)			// always allocate pens


/*****************************************************************************/


#endif /* IMAGES_SMARTBITMAP_H */
