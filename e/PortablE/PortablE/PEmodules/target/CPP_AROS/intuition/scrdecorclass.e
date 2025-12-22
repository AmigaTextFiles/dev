/* $Id: screendecorclass.h 12757 2001-12-08 22:23:57Z dariusb $ */
OPT NATIVE
MODULE 'target/utility/tagitem', 'target/intuition/imageclass', 'target/graphics/clip', 'target/intuition/intuition', 'target/intuition/screens'
MODULE 'target/exec/types'
{#include <intuition/scrdecorclass.h>}
NATIVE {INTUITION_SCRDECORCLASS_H} CONST

/* Attributes for SCRDECORCLASS */
NATIVE {SDA_Dummy}		    CONST SDA_DUMMY		    = (TAG_USER + $22100)
NATIVE {SDA_DrawInfo}	    	    CONST SDA_DRAWINFO	    	    = (SDA_DUMMY + 1) 	    /* I.G */
NATIVE {SDA_Screen}  	    	    CONST SDA_SCREEN  	    	    = (SDA_DUMMY + 2) 	    /* I.G */
NATIVE {SDA_TrueColorOnly}	    CONST SDA_TRUECOLORONLY	    = (SDA_DUMMY + 3) 	    /* ..G */
NATIVE {SDA_UserBuffer}              CONST SDA_USERBUFFER              = (SDA_DUMMY + 4)         /* I.G */

/* Methods for SCRDECORCLASS */
NATIVE {SDM_Dummy}   	    	    CONST SDM_DUMMY   	    	    = (SDA_DUMMY + 500)

NATIVE {SDM_SETUP}   	    	    CONST SDM_SETUP   	    	    = (SDM_DUMMY + 1)
NATIVE {SDM_CLEANUP} 	    	    CONST SDM_CLEANUP 	    	    = (SDM_DUMMY + 2)
NATIVE {SDM_GETDEFSIZE_SYSIMAGE}     CONST SDM_GETDEFSIZE_SYSIMAGE     = (SDM_DUMMY + 3)
NATIVE {SDM_DRAW_SYSIMAGE}   	    CONST SDM_DRAW_SYSIMAGE   	    = (SDM_DUMMY + 4)
NATIVE {SDM_DRAW_SCREENBAR}  	    CONST SDM_DRAW_SCREENBAR  	    = (SDM_DUMMY + 5)
NATIVE {SDM_LAYOUT_SCREENGADGETS}    CONST SDM_LAYOUT_SCREENGADGETS    = (SDM_DUMMY + 6)
NATIVE {SDM_INITSCREEN}              CONST SDM_INITSCREEN              = (SDM_DUMMY + 7)
NATIVE {SDM_EXITSCREEN}              CONST SDM_EXITSCREEN              = (SDM_DUMMY + 8)

NATIVE {sdpGetDefSizeSysImage} OBJECT sdpgetdefsizesysimage
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {sdp_TrueColor}	truecolor	:INT
    {sdp_Dri}	dri	:PTR TO drawinfo
    {sdp_ReferenceFont}	referencefont	:PTR TO textfont /* In: */
    {sdp_Which}	which	:/*STACKULONG*/ ULONG  	/* In: SDEPTHIMAGE */
    {sdp_SysiSize}	sysisize	:/*STACKULONG*/ ULONG	/* In: lowres/medres/highres */
    {sdp_Width}	width	:PTR TO /*STACKULONG*/ ULONG  	/* Out */
    {sdp_Height}	height	:PTR TO /*STACKULONG*/ ULONG 	/* Out */
    {sdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {sdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

/* This struct must match wdpDrawSysImage struct in windecorclass.h! */

NATIVE {sdpDrawSysImage} OBJECT sdpdrawsysimage
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {sdp_TrueColor}	truecolor	:INT
    {sdp_Dri}	dri	:PTR TO drawinfo
    {sdp_RPort}	rport	:PTR TO rastport
    {sdp_X}	x	:STACKLONG
    {sdp_Y}	y	:STACKLONG
    {sdp_Width}	width	:STACKLONG
    {sdp_Height}	height	:STACKLONG
    {sdp_Which}	which	:/*STACKULONG*/ ULONG
    {sdp_State}	state	:/*STACKULONG*/ ULONG
    {sdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {sdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {sdpDrawScreenBar} OBJECT sdpdrawscreenbar
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {sdp_TrueColor}	truecolor	:INT
    {sdp_Dri}	dri	:PTR TO drawinfo
    {sdp_Layer}	layer	:PTR TO layer
    {sdp_RPort}	rport	:PTR TO rastport
    {sdp_Screen}	screen	:PTR TO screen
    {sdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {sdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {sdpLayoutScreenGadgets} OBJECT sdplayoutscreengadgets
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {sdp_TrueColor}	truecolor	:INT
    {sdp_Dri}	dri	:PTR TO drawinfo
    {sdp_Layer}	layer	:PTR TO layer
    {sdp_Gadgets}	gadgets	:PTR TO gadget
    {sdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {sdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {sdpInitScreen} OBJECT sdpinitscreen
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {sdp_TrueColor}	truecolor	:INT
    {sdp_Dri}	dri	:PTR TO drawinfo
    {sdp_FontHeight}	fontheight	:/*STACKULONG*/ ULONG
    {sdp_TitleHack}	titlehack	:STACKLONG
    {sdp_BarHeight}	barheight	:/*STACKULONG*/ ULONG
    {sdp_BarVBorder}	barvborder	:/*STACKULONG*/ ULONG
    {sdp_BarHBorder}	barhborder	:/*STACKULONG*/ ULONG
    {sdp_MenuVBorder}	menuvborder	:/*STACKULONG*/ ULONG
    {spd_MenuHBorder}	menuhborder	:/*STACKULONG*/ ULONG
    {sdp_WBorTop}	wbortop	:STACKBYTE
    {sdp_WBorLeft}	wborleft	:STACKBYTE
    {sdp_WBorRight}	wborright	:STACKBYTE
    {sdp_WBorBottom}	wborbottom	:STACKBYTE
    {sdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {sdpExitScreen} OBJECT sdpexitscreen
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {sdp_TrueColor}	truecolor	:INT
    {sdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT
/* ScrDecor LayoutScreenGadgets Flags */
NATIVE {SDF_LSG_INITIAL}     	CONST SDF_LSG_INITIAL     	= 1   /* First time == During OpenScreen */
NATIVE {SDF_LSG_SYSTEMGADGET}	CONST SDF_LSG_SYSTEMGADGET	= 2   /* Is a system gadget (sdepth) */
NATIVE {SDF_LSG_INGADLIST}   	CONST SDF_LSG_INGADLIST   	= 4   /* Gadget is already in screen gadget list */
NATIVE {SDF_LSG_MULTIPLE}    	CONST SDF_LSG_MULTIPLE    	= 8   /* There may be multiple gadgets (linked
                                       together through NextGadget. Follow it) */
