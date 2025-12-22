
/* OS include files */
#include<exec/types.h>
#include<exec/libraries.h>
#include<exec/memory.h>
#include<exec/execbase.h>
#include<dos/dos.h>
#include<graphics/gfx.h>
#include<libraries/mui.h>
#include<utility/utility.h>

/* OS function prototypes */
#include<clib/alib_protos.h>
#include<clib/exec_protos.h>
#include<clib/dos_protos.h>
#include<clib/muimaster_protos.h>
#include<clib/graphics_protos.h>
#include<clib/utility_protos.h>

/* pramga */
#include<pragma/exec_lib.h>
#include<pragma/dos_lib.h>
#include<pragma/muimaster_lib.h>
#include<pragma/graphics_lib.h>
#include<pragma/utility_lib.h>

/* Revision header        */
#include"TWFmultiLED.mcc_rev.h"

#define REG(x)                    register __## x
#define MAX(a,b)                  ((a)>(b)?(a):(b))
#define MIN(a,b)                  ((a)<(b)?(a):(b))
#define ABS(x)                    ((x<0)?(-(x)):(x))

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d)     ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#define MUIM_TWFmultiLED_SecTrigger         0xfebdF001

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

struct TWFmultiLED_RGB
{
    ULONG Red;
    ULONG Green;
    ULONG Blue;
};

struct ClassData
{
           LONG             BackPen  ;
           LONG             PenNum   ;

           LONG             Shape    ;

           LONG             Pens[11] ;

           LONG             LampPos  ;
           LONG             LampMax  ;
           BOOL             HandleOn ;

           BOOL             FreeSize ;
           BOOL             GotCustom;

           BOOL             UserType ;
           BOOL             UserTime ;

    struct MUI_RenderInfo  *RendInfo;
    struct TWFmultiLED_RGB  CustomRaw;
    struct MUI_PenSpec      CustomPen;
    struct MUI_InputHandlerNode ihnode;

};

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
