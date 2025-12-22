#ifndef GADUTIL_20TO30COMP_H
#define GADUTIL_20TO30COMP_H
/*------------------------------------------------------------------------**
**
**	$VER: gadutil_20to30comp.h 37.10 (28.09.97)
**
**	Filename:	gadutil_20to30comp.h
**	Version:	37.10
**	Date:		28-Sep-97
**
**	Include file to make all examples compatible with OS 2.04 includes
**
**	© Copyright 1994-1997 by P-O Yliniemi and Staffan Hämälä.
**
**	All Rights Reserved.
**
**------------------------------------------------------------------------*/

/*---- GadTools additions ----*/

#ifndef GTMN_NewLookMenus			/* Check for v39 libraries/gadtools.i	*/
#define GTMN_NewLookMenus	GT_TagBase+67
#define GTCB_Scaled		GT_TagBase+68

#define MX_WIDTH		17
#define MX_HEIGHT		9
#define CHECKBOX_WIDTH		26
#define CHECKBOX_HEIGHT		11
#endif

/*---- Intuition additions ----*/

#ifndef WA_NewLookMenus				/* Check for v39 intuition/intuition.i	*/
#define WA_NewLookMenus		0x80000093
#define EasyStruct_SIZEOF	20
#endif

#endif /* GADUTIL_20TO30COMP_H */
