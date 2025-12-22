//     ___       ___
//   _/  /_______\  \_     ___ ___ __ _                       _ __ ___ ___
//__//  / _______ \  \\___/                                               \___
//_/ | '  \__ __/  ` | \_/        © Copyright 1999, Christopher Page       \__
// \ | |    | |__  | | / \   Released as Free Software under the GNU GPL   /
//  >| .    |  _/  . |<   >--- --- -- -                       - -- --- ---<
// / \  \   | |   /  / \ /   This file is part of the TWFmultiLED source   \
// \  \  \_/   \_/  /  / \  and it is released under the GNU GPL. Please   /
//  \  \           /  /   \   read the "COPYING" file which should have   /
// //\  \_________/  /\\ //\    been included in the distribution arc.   /
//- --\   _______   /-- - --\      for full details of the license      /-----
//-----\_/       \_/---------\   ___________________________________   /------
//                            \_/                                   \_/
//

// OS include files
#include<exec/types.h>
#include<exec/libraries.h>
#include<exec/memory.h>
#include<exec/resident.h>
#include<exec/semaphores.h>
#include<dos/dos.h>
#include<libraries/mui.h>

// OS function prototypes
#include<clib/alib_protos.h>
#include<clib/exec_protos.h>
#include<clib/dos_protos.h>
#include<clib/muimaster_protos.h>

// pramga
#include<pragma/exec_lib.h>
#include<pragma/dos_lib.h>
#include<pragma/muimaster_lib.h>

/* Revision header        */
#include"TWFmultiLED.mcp_rev.h"

#define REG(x)                    register __## x
#define MAX(a,b)                  ((a)>(b)?(a):(b))
#define MIN(a,b)                  ((a)<(b)?(a):(b))
#define ABS(x)                    ((x<0)?(-(x)):(x))

#define MUIC_TWFmultiLED    "TWFmultiLED.mcc"
#define TWFmultiLEDObject   MUI_NewObject(MUIC_TWFmultiLED

struct PrefsData
{
    Object *GP_Prefs  ;

    Object *PP_Off    ; // Row: 1
    Object *PP_On     ; // Row: 2
    Object *PP_Ok     ; // Row: 3
    Object *PP_Wait   ; // Row: 4
    Object *PP_Work   ; // Row: 5

    Object *PP_Load   ; // Row: 1
    Object *PP_Cancel ; // Row: 2
    Object *PP_Stop   ; // Row: 3
    Object *PP_Error  ; // Row: 4
    Object *PP_Panic  ; // Row: 5

    Object *SL_Timeout;

    Object *CY_Type   ;

    // These are used on the demo page.
    Object *BT_Off    ;
    Object *BT_On     ;
    Object *BT_Ok     ;
    Object *BT_Work   ;
    Object *BT_Wait   ;
    Object *BT_Load   ;
    Object *BT_Can    ;
    Object *BT_Stop   ;
    Object *BT_Error  ;
    Object *BT_Panic  ;
    Object *BT_TypeC5 ;
    Object *BT_TypeC11;
    Object *BT_TypeS5 ;
    Object *BT_TypeS11;
    Object *BT_TypeR11;
    Object *BT_TypeR15;

    Object *ML_LED    ;

};

#define Prefs_Image_Width       22
#define Prefs_Image_Height      13
#define Prefs_Image_Depth       3
#define Prefs_Image_Masking     2
#define Prefs_Image_Transparent 0
#define Prefs_Image_Compression 0

extern ULONG Prefs_Image_Colors[];
extern UBYTE Prefs_Image_Data  [];

#define MSG_ABOUT_TEXT "\n\33c\33b\0333TWFmultiLED\nIndicator class for MUI\0330\33n\n\33bCopyright 1998-1999 Chris Page\33n\n  \33iContact: Chris <chris@worldfoundry.demon.co.uk>  \33n\nPlease contact me for developer information\n\n\n"

#define MUIA_TWFmultiLED_Colour             0xfebd0001
#define MUIA_TWFmultiLED_Custom             0xfebd0002
#define MUIA_TWFmultiLED_Type               0xfebd0003
#define MUIA_TWFmultiLED_Free               0xfebd0004
#define MUIA_TWFmultiLED_TimeDelay          0xfebd0005

// For MUIA_TWFmultiLED_Colour
#define MUIV_TWFmultiLED_Colour_Off         0
#define MUIV_TWFmultiLED_Colour_On          1
#define MUIV_TWFmultiLED_Colour_Ok          2
#define MUIV_TWFmultiLED_Colour_Load        3
#define MUIV_TWFmultiLED_Colour_Error       4
#define MUIV_TWFmultiLED_Colour_Panic       5
#define MUIV_TWFmultiLED_Colour_Custom      6
#define MUIV_TWFmultiLED_Colour_Working     7   // Added in v 12.4
#define MUIV_TWFmultiLED_Colour_Waiting     8   // Added in v 12.4
#define MUIV_TWFmultiLED_Colour_Cancelled   9   // Added in v 12.4
#define MUIV_TWFmultiLED_Colour_Stopped     10  // Added in v 12.4

// For MUIA_TWFmultiLED_Type
#define MUIV_TWFmultiLED_Type_Round5        0
#define MUIV_TWFmultiLED_Type_Round11       1
#define MUIV_TWFmultiLED_Type_Square5       2
#define MUIV_TWFmultiLED_Type_Square11      3
#define MUIV_TWFmultiLED_Type_Rect11        4
#define MUIV_TWFmultiLED_Type_Rect15        5
#define MUIV_TWFmultiLED_Type_User          6

// For MUIA_TWFmultiLED_TimeDelay
#define MUIV_TWFmultiLED_TimeDelay_User     -1  // Added in v 12.4
#define MUIV_TWFmultiLED_TimeDelay_Off      0   // Added in v 12.4

#define MUICFG_TWFmultiLED_Off       0xfebd1001
#define MUICFG_TWFmultiLED_On        0xfebd1002
#define MUICFG_TWFmultiLED_Ok        0xfebd1003
#define MUICFG_TWFmultiLED_Load      0xfebd1004
#define MUICFG_TWFmultiLED_Error     0xfebd1005
#define MUICFG_TWFmultiLED_Panic     0xfebd1006
#define MUICFG_TWFmultiLED_Type      0xfebd1007

// Added in v 12.4
#define MUICFG_TWFmultiLED_TimeOut   0xfebd1008
#define MUICFG_TWFmultiLED_Working   0xfebd1009
#define MUICFG_TWFmultiLED_Waiting   0xfebd100A
#define MUICFG_TWFmultiLED_Cancelled 0xfebd100B
#define MUICFG_TWFmultiLED_Stopped   0xfebd100C


// Missing from mui.h
#define MUIC_Crawling  "Crawling.mcc"
#define CrawlingObject MUI_NewObject(MUIC_Crawling

#define MUIM_GetConfigItem                  0x80423edb /* V11 */

#define MUIM_Settingsgroup_ConfigToGadgets  0x80427043 /* V11 */
#define MUIM_Settingsgroup_GadgetsToConfig  0x80425242 /* V11 */

#define MUIM_Dataspace_Find                 0x8042832c /* V11 */


#ifndef NDEBUG
    void kprintf(UBYTE *fmt,...);
    #define DEBUGLOG(x) x
#else
    #define DEBUGLOG(x)
#endif
