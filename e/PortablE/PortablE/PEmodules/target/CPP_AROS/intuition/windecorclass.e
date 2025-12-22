/* $Id: windecorclass.h 12757 2001-12-08 22:23:57Z dariusb $ */
OPT NATIVE
MODULE 'target/utility/tagitem', 'target/intuition/imageclass', 'target/intuition/intuition', 'target/intuition/screens'
MODULE 'target/graphics/text', 'target/graphics/gfx', 'target/exec/types'
{#include <intuition/windecorclass.h>}
NATIVE {INTUITION_WINDECORCLASS_H} CONST

/* Attributes for WINDECORCLASS */
NATIVE {WDA_Dummy}		    CONST WDA_DUMMY		    = (TAG_USER + $22000)
NATIVE {WDA_DrawInfo}	    	    CONST WDA_DRAWINFO	    	    = (WDA_DUMMY + 1) 	    /* I.G */
NATIVE {WDA_Screen}  	    	    CONST WDA_SCREEN  	    	    = (WDA_DUMMY + 2) 	    /* I.G */
NATIVE {WDA_TrueColorOnly}	    CONST WDA_TRUECOLORONLY	    = (WDA_DUMMY + 3) 	    /* ..G */
NATIVE {WDA_UserBuffer}              CONST WDA_USERBUFFER              = (WDA_DUMMY + 4)         /* I.G */


/* Methods for WINDECORCLASS */
NATIVE {WDM_Dummy}   	    	    CONST WDM_DUMMY   	    	    = (WDA_DUMMY + 500)

NATIVE {WDM_SETUP}   	    	    CONST WDM_SETUP   	    	    = (WDM_DUMMY + 1)
NATIVE {WDM_CLEANUP} 	    	    CONST WDM_CLEANUP 	    	    = (WDM_DUMMY + 2)
NATIVE {WDM_GETDEFSIZE_SYSIMAGE}     CONST WDM_GETDEFSIZE_SYSIMAGE     = (WDM_DUMMY + 3)
NATIVE {WDM_DRAW_SYSIMAGE}   	    CONST WDM_DRAW_SYSIMAGE   	    = (WDM_DUMMY + 4)
NATIVE {WDM_DRAW_WINBORDER}  	    CONST WDM_DRAW_WINBORDER  	    = (WDM_DUMMY + 5)
NATIVE {WDM_LAYOUT_BORDERGADGETS}    CONST WDM_LAYOUT_BORDERGADGETS    = (WDM_DUMMY + 6)
NATIVE {WDM_DRAW_BORDERPROPBACK}     CONST WDM_DRAW_BORDERPROPBACK     = (WDM_DUMMY + 7)
NATIVE {WDM_DRAW_BORDERPROPKNOB}     CONST WDM_DRAW_BORDERPROPKNOB     = (WDM_DUMMY + 8)
NATIVE {WDM_INITWINDOW}              CONST WDM_INITWINDOW              = (WDM_DUMMY + 9)
NATIVE {WDM_EXITWINDOW}              CONST WDM_EXITWINDOW              = (WDM_DUMMY + 10)
NATIVE {WDM_WINDOWSHAPE}             CONST WDM_WINDOWSHAPE             = (WDM_DUMMY + 11)


NATIVE {wdpGetDefSizeSysImage} OBJECT wdpgetdefsizesysimage
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Dri}	dri	:PTR TO drawinfo
    {wdp_ReferenceFont}	referencefont	:PTR TO textfont /* In: */
    {wdp_Which}	which	:/*STACKULONG*/ ULONG  	/* In: One of CLOSEIMAGE, SIZEIMAGE, ... */
    {wdp_SysiSize}	sysisize	:/*STACKULONG*/ ULONG	/* In: lowres/medres/highres */
    {wdp_Width}	width	:PTR TO /*STACKULONG*/ ULONG  	/* Out */
    {wdp_Height}	height	:PTR TO /*STACKULONG*/ ULONG 	/* Out */
    {wdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
    
ENDOBJECT

/* The sdpDrawSysImage struct in scrdecorclass.h must match this one!!! */

NATIVE {wdpDrawSysImage} OBJECT wdpdrawsysimage
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Dri}	dri	:PTR TO drawinfo
    {wdp_RPort}	rport	:PTR TO rastport
    {wdp_X}	x	:STACKLONG
    {wdp_Y}	y	:STACKLONG
    {wdp_Width}	width	:STACKLONG
    {wdp_Height}	height	:STACKLONG
    {wdp_Which}	which	:/*STACKULONG*/ ULONG
    {wdp_State}	state	:/*STACKULONG*/ ULONG
    {wdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpDrawWinBorder} OBJECT wdpdrawwinborder
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Dri}	dri	:PTR TO drawinfo
    {wdp_Window}	window	:PTR TO window
    {wdp_RPort}	rport	:PTR TO rastport
    {wdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpLayoutBorderGadgets} OBJECT wdplayoutbordergadgets
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Dri}	dri	:PTR TO drawinfo
    {wdp_Window}	window	:PTR TO window
    {wdp_Gadgets}	gadgets	:PTR TO gadget
    {wdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpDrawBorderPropBack} OBJECT wdpdrawborderpropback
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Dri}	dri	:PTR TO drawinfo
    {wdp_Window}	window	:PTR TO window
    {wdp_RPort}	rport	:PTR TO rastport
    {wdp_Gadget}	gadget	:PTR TO gadget
    {wdp_RenderRect}	renderrect	:PTR TO rectangle
    {wdp_PropRect}	proprect	:PTR TO rectangle
    {wdp_KnobRect}	knobrect	:PTR TO rectangle
    {wdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpDrawBorderPropKnob} OBJECT wdpdrawborderpropknob
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Dri}	dri	:PTR TO drawinfo
    {wdp_Window}	window	:PTR TO window
    {wdp_RPort}	rport	:PTR TO rastport
    {wdp_Gadget}	gadget	:PTR TO gadget
    {wdp_RenderRect}	renderrect	:PTR TO rectangle
    {wdp_PropRect}	proprect	:PTR TO rectangle
    {wdp_Flags}	flags	:/*STACKULONG*/ ULONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpInitWindow} OBJECT wdpinitwindow
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpExitWindow} OBJECT wdpexitwindow
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

NATIVE {wdpWindowShape} OBJECT wdpwindowshape
    {MethodID}	methodid	:/*STACKULONG*/ ULONG
    {wdp_TrueColor}	truecolor	:INT
    {wdp_Width}	width	:STACKLONG
    {wdp_Height}	height	:STACKLONG
    {wdp_UserBuffer}	userbuffer	:STACKIPTR
ENDOBJECT

/* WinDecor DrawWindowBorder Flags */ 
NATIVE {WDF_DWB_TOP_ONLY}   	CONST WDF_DWB_TOP_ONLY   	= 1   /* Draw top border only */

/* WinDecor DrawWinTitle Title Align */
NATIVE {WD_DWTA_LEFT} 	    	CONST WD_DWTA_LEFT 	    	= 0
NATIVE {WD_DWTA_RIGHT} 	    	CONST WD_DWTA_RIGHT 	    	= 1
NATIVE {WD_DWTA_CENTER}      	CONST WD_DWTA_CENTER      	= 2

/* WinDecor LayourBorderGadgets Flags */
NATIVE {WDF_LBG_INITIAL}     	CONST WDF_LBG_INITIAL     	= 1   /* First time == During OpenWindow */
NATIVE {WDF_LBG_SYSTEMGADGET}	CONST WDF_LBG_SYSTEMGADGET	= 2   /* Is a system gadget (close/depth/zoom) */
NATIVE {WDF_LBG_INGADLIST}   	CONST WDF_LBG_INGADLIST   	= 4   /* Gadget is already in window gadget list */
NATIVE {WDF_LBG_MULTIPLE}    	CONST WDF_LBG_MULTIPLE    	= 8   /* There may be multiple gadgets (linked
                                       together through NextGadget. Follow it) */
/* WinDecor DrawBorderPropKnob Flags */
NATIVE {WDF_DBPK_HIT}	    	CONST WDF_DBPK_HIT	    	= 1   /* Knob is hit / in use by user*/
