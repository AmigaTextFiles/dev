
/*
 * XMISC.H
 */

#ifndef MYLIB_XMISC_H
#define MYLIB_XMISC_H

#define ACTION_DOSCAPABILITIES	3000
#define ACTION_SETRBLOCKMODE	3001	/*  turn on/off blocking on read    */
#define ACTION_SETWBLOCKMODE	3002	/*  turn atomic/on/off blocking on write   */
#define ACTION_SETRSIGNAL	3003	/*  set signal/-1 read data ready   */
#define ACTION_SETWSIGNAL	3004	/*  set signal/-1 buffr. space avail*/
#define ACTION_GETRDATAREADY	3005	/*  get read data ready 	    */
#define ACTION_GETWSPACEAVAIL	3006	/*  get write space available	    */
#define ACTION_GETRBUFSIZE	3007
#define ACTION_GETWBUFSIZE	3008
#define ACTION_SETRBUFSIZE	3009
#define ACTION_SETWBUFSIZE	3010
#define ACTION_SHUTDOWN 	3011

#define GRAPHICS_LIB	    0x0001L
#define INTUITION_LIB	    0x0002L
#define EXPANSION_LIB	    0x0004L
#define DISKFONT_LIB	    0x0008L
#define TRANSLATOR_LIB	    0x0010L
#define ICON_LIB	    0x0020L
#define MATH_LIB	    0x0040L
#define MATHTRANS_LIB	    0x0080L
#define MATHIEEEDOUBBAS_LIB 0x0100L
#define MATHIEEESINGBAS_LIB 0x0200L
#define LAYERS_LIB	    0x0400L
#define CLIST_LIB	    0x0800L
#define POTGO_LIB	    0x1000L
#define TIMER_LIB	    0x2000L
#define DRES_LIB	    0x4000L

#define ADRLOCK struct _ADRLOCK
#define XLIST struct _XLIST

ADRLOCK {
    long    ad_Wait;
    unsigned char  ad_Bits;
};

XLIST {
    XLIST *next;
    XLIST **prev;
};

#endif


