/* $Id: menudecorclass.h 12757 2001-12-08 22:23:57Z dariusb $ */
OPT NATIVE
MODULE 'target/utility/tagitem', 'target/intuition/imageclass', 'target/intuition/intuition', 'target/intuition/screens'
MODULE 'target/intuition/windecorclass', 'target/graphics/text', 'target/exec/types'
{#include <intuition/menudecorclass.h>}
NATIVE {INTUITION_MENUDECORCLASS_H} CONST

/* Attributes for MENUDECORCLASS */
NATIVE {MDA_Dummy}		    CONST MDA_DUMMY		    = (TAG_USER + $22000)
NATIVE {MDA_DrawInfo}	    	    CONST MDA_DRAWINFO	    	    = (WDA_DUMMY + 1) 	    /* I.G */
NATIVE {MDA_Screen}  	    	    CONST MDA_SCREEN  	    	    = (WDA_DUMMY + 2) 	    /* I.G */
NATIVE {MDA_TrueColorOnly}	    CONST MDA_TRUECOLORONLY	    = (WDA_DUMMY + 3) 	    /* ..G */
NATIVE {MDA_UserBuffer}              CONST MDA_USERBUFFER              = (WDA_DUMMY + 4)         /* I.G */


/* Methods for MENUDECORCLASS */
NATIVE {MDM_Dummy}   	    	    CONST MDM_DUMMY   	    	    = (MDA_DUMMY + 500)

NATIVE {MDM_GETDEFSIZE_SYSIMAGE}     CONST MDM_GETDEFSIZE_SYSIMAGE     = (MDM_DUMMY + 1)
NATIVE {MDM_DRAW_SYSIMAGE}   	    CONST MDM_DRAW_SYSIMAGE   	    = (MDM_DUMMY + 2)
NATIVE {MDM_GETMENUSPACES}           CONST MDM_GETMENUSPACES           = (MDM_DUMMY + 3)
NATIVE {MDM_DRAWBACKGROUND}          CONST MDM_DRAWBACKGROUND          = (MDM_DUMMY + 4)
NATIVE {MDM_INITMENU}                CONST MDM_INITMENU                = (MDM_DUMMY + 5)
NATIVE {MDM_EXITMENU}                CONST MDM_EXITMENU                = (MDM_DUMMY + 6)

NATIVE {mdpGetDefSizeSysImage} OBJECT mdpgetdefsizesysimage
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {mdp_TrueColor}	truecolor	:INT
    {mdp_Dri}	dri	:PTR TO drawinfo
    {mdp_ReferenceFont}	referencefont	:PTR TO textfont /* In: */
    {mdp_Which}	which	:/*STACKULONG*/ ULONG  	/* In: One of CLOSEIMAGE, SIZEIMAGE, ... */
    {mdp_SysiSize}	sysisize	:/*STACKULONG*/ ULONG	/* In: lowres/medres/highres */
    {mdp_Width}	width	:PTR TO /*STACKULONG*/ ULONG  	/* Out */
    {mdp_Height}	height	:PTR TO /*STACKULONG*/ ULONG 	/* Out */
    {mdp_Flags}	flags	:/*STACKULONG*/ ULONG
ENDOBJECT

NATIVE {mdpDrawSysImage} OBJECT mdpdrawsysimage
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {mdp_TrueColor}	truecolor	:INT
    {mdp_Dri}	dri	:PTR TO drawinfo
    {mdp_RPort}	rport	:PTR TO rastport
    {mdp_X}	x	:STACKLONG
    {mdp_Y}	y	:STACKLONG
    {mdp_Width}	width	:STACKLONG
    {mdp_Height}	height	:STACKLONG
    {mdp_Which}	which	:/*STACKULONG*/ ULONG
    {mdp_State}	state	:/*STACKULONG*/ ULONG
    {mdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {mdp_UserBuffer}	userbuffer	:IPTR
ENDOBJECT

NATIVE {mdpGetMenuSpaces} OBJECT mdpgetmenuspaces
    {MethodID}	methodid	:STACKLONG
    {mdp_TrueColor}	truecolor	:INT
    {mdp_InnerLeft}	innerleft	:STACKLONG  	/* Out */
    {mdp_InnerTop}	innertop	:STACKLONG 	/* Out */
    {mdp_InnerRight}	innerright	:STACKLONG
    {mdp_InnerBottom}	innerbottom	:STACKLONG
    {mdp_ItemInnerLeft}	iteminnerleft	:STACKLONG
    {mdp_ItemInnerTop}	iteminnertop	:STACKLONG
    {mdp_ItemInnerRight}	iteminnerright	:STACKLONG
    {mdp_ItemInnerBottom}	iteminnerbottom	:STACKLONG
    {mdp_MinWidth}	minwidth	:STACKLONG
    {mdp_MinHeight}	minheight	:STACKLONG
ENDOBJECT

/* The sdpDrawSysImage struct in scrdecorclass.h must match this one!!! */

NATIVE {mdpDrawBackground} OBJECT mdpdrawbackground
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {mdp_TrueColor}	truecolor	:INT
    {mdp_RPort}	rport	:PTR TO rastport
    {mdp_X}	x	:STACKLONG
    {mdp_Y}	y	:STACKLONG
    {mdp_Width}	width	:STACKLONG
    {mdp_Height}	height	:STACKLONG
    {mdp_ItemLeft}	itemleft	:STACKLONG
    {mdp_ItemTop}	itemtop	:STACKLONG
    {mdp_ItemWidth}	itemwidth	:STACKLONG
    {mdp_ItemHeight}	itemheight	:STACKLONG
    {mdp_Flags}	flags	:/*STACKUWORD*/ LONG
    {mdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {mdpInitMenu} OBJECT mdpinitmenu
    {MethodID}	methodid	:STACKLONG
    {mdp_TrueColor}	truecolor	:INT
    {mdp_RPort}	rport	:PTR TO rastport
    {mdp_Left}	left	:/*STACKULONG*/ ULONG
    {mdp_Top}	top	:/*STACKULONG*/ ULONG
    {mdp_Width}	width	:/*STACKULONG*/ ULONG
    {mdp_Height}	height	:STACKLONG
    {mdp_UserBuffer}	userbuffer	:STACKIPTR
    
ENDOBJECT

NATIVE {mdpExitMenu} OBJECT mdpexitmenu
    {MethodID}	methodid	:STACKLONG
    {mdp_TrueColor}	truecolor	:INT
    {mdp_UserBuffer}	userbuffer	:STACKIPTR
    
ENDOBJECT


NATIVE {MDP_STATE_NORMAL}	CONST MDP_STATE_NORMAL	= 0
NATIVE {MDP_STATE_SELECTED}    CONST MDP_STATE_SELECTED    = 1
NATIVE {MDP_STATE_DISABLED}    CONST MDP_STATE_DISABLED    = 2
