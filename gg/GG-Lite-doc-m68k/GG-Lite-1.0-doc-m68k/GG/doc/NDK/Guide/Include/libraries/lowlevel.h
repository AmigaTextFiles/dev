@DATABASE "gg:doc/NDK/Guide/Include/libraries/lowlevel.h"
@MASTER   "gg:os-include/libraries/lowlevel.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:53
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/lowlevel.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/lowlevel.h" LINK File}


@{b}Structures@{ub}

@{"KeyQuery" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 30}


@{b}#defines@{ub}

@{"CDReboot_Default" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 163}             @{"CDReboot_Off" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 162}
@{"CDReboot_On" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 161}                  @{"JP_BUTTON_MASK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 103}
@{"JP_DIRECTION_MASK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 114}            @{"JP_MHORZ_MASK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 117}
@{"JP_MOUSE_MASK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 119}                @{"JP_MVERT_MASK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 118}
@{"JP_TYPE_GAMECTLR" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 82}             @{"JP_TYPE_JOYSTK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 84}
@{"JP_TYPE_MASK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 86}                 @{"JP_TYPE_MOUSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 83}
@{"JP_TYPE_NOTAVAIL" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 81}             @{"JP_TYPE_UNKNOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 85}
@{"JPB_BTN1" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 124}                     @{"JPB_BTN2" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 126}
@{"JPB_BTN3" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 128}                     @{"JPB_BTN4" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 130}
@{"JPB_BTN5" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 132}                     @{"JPB_BTN6" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 134}
@{"JPB_BTN7" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 136}                     @{"JPB_BUTTON_BLUE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 89}
@{"JPB_BUTTON_FORWARD" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 93}           @{"JPB_BUTTON_GREEN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 92}
@{"JPB_BUTTON_PLAY" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 95}              @{"JPB_BUTTON_RED" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 90}
@{"JPB_BUTTON_REVERSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 94}           @{"JPB_BUTTON_YELLOW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 91}
@{"JPB_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 140}                     @{"JPB_JOY_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 107}
@{"JPB_JOY_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 108}                 @{"JPB_JOY_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 109}
@{"JPB_JOY_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 106}                   @{"JPB_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 142}
@{"JPB_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 144}                    @{"JPB_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 138}
@{"JPF_BTN1" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 125}                     @{"JPF_BTN2" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 127}
@{"JPF_BTN3" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 129}                     @{"JPF_BTN4" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 131}
@{"JPF_BTN5" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 133}                     @{"JPF_BTN6" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 135}
@{"JPF_BTN7" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 137}                     @{"JPF_BUTTON_BLUE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 96}
@{"JPF_BUTTON_FORWARD" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 100}           @{"JPF_BUTTON_GREEN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 99}
@{"JPF_BUTTON_PLAY" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 102}              @{"JPF_BUTTON_RED" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 97}
@{"JPF_BUTTON_REVERSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 101}           @{"JPF_BUTTON_YELLOW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 98}
@{"JPF_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 141}                     @{"JPF_JOY_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 111}
@{"JPF_JOY_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 112}                 @{"JPF_JOY_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 113}
@{"JPF_JOY_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 110}                   @{"JPF_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 143}
@{"JPF_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 145}                    @{"JPF_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 139}
@{"LANG_AMERICAN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 225}                @{"LANG_ARABIC" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 239}
@{"LANG_CHINESE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 238}                 @{"LANG_DANISH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 232}
@{"LANG_DUTCH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 233}                   @{"LANG_ENGLISH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 226}
@{"LANG_FINNISH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 235}                 @{"LANG_FRENCH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 228}
@{"LANG_GERMAN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 227}                  @{"LANG_GREEK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 240}
@{"LANG_HEBREW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 241}                  @{"LANG_ITALIAN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 230}
@{"LANG_JAPANESE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 237}                @{"LANG_KOREAN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 242}
@{"LANG_NORWEGIAN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 234}               @{"LANG_PORTUGUESE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 231}
@{"LANG_SPANISH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 229}                 @{"LANG_SWEDISH" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 236}
@{"LANG_UNKNOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 224}                 @{"LLKB_CAPSLOCK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 43}
@{"LLKB_CONTROL" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 44}                 @{"LLKB_LALT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 45}
@{"LLKB_LAMIGA" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 47}                  @{"LLKB_LSHIFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 41}
@{"LLKB_RALT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 46}                    @{"LLKB_RAMIGA" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 48}
@{"LLKB_RSHIFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 42}                  @{"LLKF_CAPSLOCK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 52}
@{"LLKF_CONTROL" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 53}                 @{"LLKF_LALT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 54}
@{"LLKF_LAMIGA" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 56}                  @{"LLKF_LSHIFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 50}
@{"LLKF_RALT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 55}                    @{"LLKF_RAMIGA" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 57}
@{"LLKF_RSHIFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 51}                  @{"RAWKEY_PORT0_BUTTON_BLUE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 171}
@{"RAWKEY_PORT0_BUTTON_FORWARD" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 175}  @{"RAWKEY_PORT0_BUTTON_GREEN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 174}
@{"RAWKEY_PORT0_BUTTON_PLAY" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 177}     @{"RAWKEY_PORT0_BUTTON_RED" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 172}
@{"RAWKEY_PORT0_BUTTON_REVERSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 176}  @{"RAWKEY_PORT0_BUTTON_YELLOW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 173}
@{"RAWKEY_PORT0_JOY_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 179}        @{"RAWKEY_PORT0_JOY_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 180}
@{"RAWKEY_PORT0_JOY_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 181}       @{"RAWKEY_PORT0_JOY_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 178}
@{"RAWKEY_PORT1_BUTTON_BLUE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 183}     @{"RAWKEY_PORT1_BUTTON_FORWARD" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 187}
@{"RAWKEY_PORT1_BUTTON_GREEN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 186}    @{"RAWKEY_PORT1_BUTTON_PLAY" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 189}
@{"RAWKEY_PORT1_BUTTON_RED" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 184}      @{"RAWKEY_PORT1_BUTTON_REVERSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 188}
@{"RAWKEY_PORT1_BUTTON_YELLOW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 185}   @{"RAWKEY_PORT1_JOY_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 191}
@{"RAWKEY_PORT1_JOY_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 192}        @{"RAWKEY_PORT1_JOY_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 193}
@{"RAWKEY_PORT1_JOY_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 190}          @{"RAWKEY_PORT2_BUTTON_BLUE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 195}
@{"RAWKEY_PORT2_BUTTON_FORWARD" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 199}  @{"RAWKEY_PORT2_BUTTON_GREEN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 198}
@{"RAWKEY_PORT2_BUTTON_PLAY" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 201}     @{"RAWKEY_PORT2_BUTTON_RED" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 196}
@{"RAWKEY_PORT2_BUTTON_REVERSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 200}  @{"RAWKEY_PORT2_BUTTON_YELLOW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 197}
@{"RAWKEY_PORT2_JOY_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 203}        @{"RAWKEY_PORT2_JOY_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 204}
@{"RAWKEY_PORT2_JOY_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 205}       @{"RAWKEY_PORT2_JOY_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 202}
@{"RAWKEY_PORT3_BUTTON_BLUE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 207}     @{"RAWKEY_PORT3_BUTTON_FORWARD" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 211}
@{"RAWKEY_PORT3_BUTTON_GREEN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 210}    @{"RAWKEY_PORT3_BUTTON_PLAY" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 213}
@{"RAWKEY_PORT3_BUTTON_RED" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 208}      @{"RAWKEY_PORT3_BUTTON_REVERSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 212}
@{"RAWKEY_PORT3_BUTTON_YELLOW" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 209}   @{"RAWKEY_PORT3_JOY_DOWN" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 215}
@{"RAWKEY_PORT3_JOY_LEFT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 216}        @{"RAWKEY_PORT3_JOY_RIGHT" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 217}
@{"RAWKEY_PORT3_JOY_UP" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 214}          @{"SCON_AddCreateKeys" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 157}
@{"SCON_CDReboot" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 155}                @{"SCON_Dummy" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 152}
@{"SCON_KillReq" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 154}                 @{"SCON_RemCreateKeys" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 158}
@{"SCON_StopInput" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 156}               @{"SCON_TakeOverSys" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 153}
@{"SJA_Dummy" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 64}                    @{"SJA_Reinitialize" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 66}
@{"SJA_Type" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 65}                     @{"SJA_TYPE_AUTOSENSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 69}
@{"SJA_TYPE_GAMECTLR" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 70}            @{"SJA_TYPE_JOYSTK" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 72}
@{"SJA_TYPE_MOUSE" LINK "gg:doc/NDK/Guide/Include/libraries/lowlevel.h/File" 71}               

@ENDNODE
@NODE File "libraries/lowlevel.h"
#ifndef LIBRARIES_LOWLEVEL_H
#define LIBRARIES_LOWLEVEL_H

/*
**      $VER: lowlevel.h 40.6 (30.7.1993)
**      Includes Release 45.1
**
**      @{"lowlevel.library" LINK "gg:doc/NDK/Guide/lowlevel/MAIN"} interface structures and definitions.
**
**      (C) Copyright-2001 Amiga, Inc.
**      All Rights Reserved
*/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif


/*****************************************************************************/


/* structure for use with @{"QueryKeys()" LINK "gg:doc/NDK/Guide/lowlevel/QueryKeys"} */
struct KeyQuery
{
    @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} kq_KeyCode;
    @{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}  kq_Pressed;
};


/*****************************************************************************/


/* bits in the return value of @{"GetKey()" LINK "gg:doc/NDK/Guide/lowlevel/GetKey"} */
#define LLKB_LSHIFT     16
#define LLKB_RSHIFT     17
#define LLKB_CAPSLOCK   18
#define LLKB_CONTROL    19
#define LLKB_LALT       20
#define LLKB_RALT       21
#define LLKB_LAMIGA     22
#define LLKB_RAMIGA     23

#define LLKF_LSHIFT     (1<<@{"LLKB_LSHIFT" LINK File 41})
#define LLKF_RSHIFT     (1<<@{"LLKB_RSHIFT" LINK File 42})
#define LLKF_CAPSLOCK   (1<<@{"LLKB_CAPSLOCK" LINK File 43})
#define LLKF_CONTROL    (1<<@{"LLKB_CONTROL" LINK File 44})
#define LLKF_LALT       (1<<@{"LLKB_LALT" LINK File 45})
#define LLKF_RALT       (1<<@{"LLKB_RALT" LINK File 46})
#define LLKF_LAMIGA     (1<<@{"LLKB_LAMIGA" LINK File 47})
#define LLKF_RAMIGA     (1<<@{"LLKB_RAMIGA" LINK File 48})


/*****************************************************************************/


/* Tags for @{"SetJoyPortAttrs()" LINK "gg:doc/NDK/Guide/lowlevel/SetJoyPortAttrsA"} */
#define SJA_Dummy        (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0xc00100)
#define SJA_Type         (@{"SJA_Dummy" LINK File 64}+1) /* force type to mouse, joy, game cntrlr */
#define SJA_Reinitialize (@{"SJA_Dummy" LINK File 64}+2) /* free potgo bits, reset to autosense   */

/* Controller types for @{"SJA_Type" LINK File 65} tag */
#define SJA_TYPE_AUTOSENSE 0
#define SJA_TYPE_GAMECTLR  1
#define SJA_TYPE_MOUSE     2
#define SJA_TYPE_JOYSTK    3


/*****************************************************************************/


/* @{"ReadJoyPort()" LINK "gg:doc/NDK/Guide/lowlevel/ReadJoyPort"} return value definitions */

/* Port types */
#define JP_TYPE_NOTAVAIL  (00<<28)        /* port data unavailable    */
#define JP_TYPE_GAMECTLR  (01<<28)        /* port has game controller */
#define JP_TYPE_MOUSE     (02<<28)        /* port has mouse           */
#define JP_TYPE_JOYSTK    (03<<28)        /* port has joystick        */
#define JP_TYPE_UNKNOWN   (04<<28)        /* port has unknown device  */
#define JP_TYPE_MASK      (15<<28)        /* controller type          */

/* Button types, valid for all types except @{"JP_TYPE_NOTAVAIL" LINK File 81} */
#define JPB_BUTTON_BLUE    23     /* Blue - Stop; Right Mouse                */
#define JPB_BUTTON_RED     22     /* Red - Select; Left Mouse; Joystick Fire */
#define JPB_BUTTON_YELLOW  21     /* Yellow - Repeat                         */
#define JPB_BUTTON_GREEN   20     /* Green - Shuffle                         */
#define JPB_BUTTON_FORWARD 19     /* Charcoal - Forward              */
#define JPB_BUTTON_REVERSE 18     /* Charcoal - Reverse              */
#define JPB_BUTTON_PLAY    17     /* Grey - Play/Pause; Middle Mouse         */
#define JPF_BUTTON_BLUE    (1<<@{"JPB_BUTTON_BLUE" LINK File 89})
#define JPF_BUTTON_RED     (1<<@{"JPB_BUTTON_RED" LINK File 90})
#define JPF_BUTTON_YELLOW  (1<<@{"JPB_BUTTON_YELLOW" LINK File 91})
#define JPF_BUTTON_GREEN   (1<<@{"JPB_BUTTON_GREEN" LINK File 92})
#define JPF_BUTTON_FORWARD (1<<@{"JPB_BUTTON_FORWARD" LINK File 93})
#define JPF_BUTTON_REVERSE (1<<@{"JPB_BUTTON_REVERSE" LINK File 94})
#define JPF_BUTTON_PLAY    (1<<@{"JPB_BUTTON_PLAY" LINK File 95})
#define JP_BUTTON_MASK     (@{"JPF_BUTTON_BLUE" LINK File 96}|@{"JPF_BUTTON_RED" LINK File 97}|@{"JPF_BUTTON_YELLOW" LINK File 98}|@{"JPF_BUTTON_GREEN" LINK File 99}|@{"JPF_BUTTON_FORWARD" LINK File 100}|@{"JPF_BUTTON_REVERSE" LINK File 101}|@{"JPF_BUTTON_PLAY" LINK File 102})

/* Direction types, valid for @{"JP_TYPE_GAMECTLR" LINK File 82} and @{"JP_TYPE_JOYSTK" LINK File 84} */
#define JPB_JOY_UP        3
#define JPB_JOY_DOWN      2
#define JPB_JOY_LEFT      1
#define JPB_JOY_RIGHT     0
#define JPF_JOY_UP        (1<<@{"JPB_JOY_UP" LINK File 106})
#define JPF_JOY_DOWN      (1<<@{"JPB_JOY_DOWN" LINK File 107})
#define JPF_JOY_LEFT      (1<<@{"JPB_JOY_LEFT" LINK File 108})
#define JPF_JOY_RIGHT     (1<<@{"JPB_JOY_RIGHT" LINK File 109})
#define JP_DIRECTION_MASK (@{"JPF_JOY_UP" LINK File 110}|@{"JPF_JOY_DOWN" LINK File 111}|@{"JPF_JOY_LEFT" LINK File 112}|@{"JPF_JOY_RIGHT" LINK File 113})

/* Mouse position reports, valid for @{"JP_TYPE_MOUSE" LINK File 83} */
#define JP_MHORZ_MASK   (255<<0)        /* horzizontal position */
#define JP_MVERT_MASK   (255<<8)        /* vertical position    */
#define JP_MOUSE_MASK   (@{"JP_MHORZ_MASK" LINK File 117}|@{"JP_MVERT_MASK" LINK File 118})

/* Obsolete @{"ReadJoyPort()" LINK "gg:doc/NDK/Guide/lowlevel/ReadJoyPort"} definitions, here for source code compatibility only.
 * Please do @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} use in new code.
 */
#define JPB_BTN1  @{"JPB_BUTTON_BLUE" LINK File 89}
#define JPF_BTN1  @{"JPF_BUTTON_BLUE" LINK File 96}
#define JPB_BTN2  @{"JPB_BUTTON_RED" LINK File 90}
#define JPF_BTN2  @{"JPF_BUTTON_RED" LINK File 97}
#define JPB_BTN3  @{"JPB_BUTTON_YELLOW" LINK File 91}
#define JPF_BTN3  @{"JPF_BUTTON_YELLOW" LINK File 98}
#define JPB_BTN4  @{"JPB_BUTTON_GREEN" LINK File 92}
#define JPF_BTN4  @{"JPF_BUTTON_GREEN" LINK File 99}
#define JPB_BTN5  @{"JPB_BUTTON_FORWARD" LINK File 93}
#define JPF_BTN5  @{"JPF_BUTTON_FORWARD" LINK File 100}
#define JPB_BTN6  @{"JPB_BUTTON_REVERSE" LINK File 94}
#define JPF_BTN6  @{"JPF_BUTTON_REVERSE" LINK File 101}
#define JPB_BTN7  @{"JPB_BUTTON_PLAY" LINK File 95}
#define JPF_BTN7  @{"JPF_BUTTON_PLAY" LINK File 102}
#define JPB_UP    @{"JPB_JOY_UP" LINK File 106}
#define JPF_UP    @{"JPF_JOY_UP" LINK File 110}
#define JPB_DOWN  @{"JPB_JOY_DOWN" LINK File 107}
#define JPF_DOWN  @{"JPF_JOY_DOWN" LINK File 111}
#define JPB_LEFT  @{"JPB_JOY_LEFT" LINK File 108}
#define JPF_LEFT  @{"JPF_JOY_LEFT" LINK File 112}
#define JPB_RIGHT @{"JPB_JOY_RIGHT" LINK File 109}
#define JPF_RIGHT @{"JPF_JOY_RIGHT" LINK File 113}


/*****************************************************************************/


/* Tags for @{"SystemControl()" LINK "gg:doc/NDK/Guide/lowlevel/SystemControlA"} */
#define SCON_Dummy         (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x00C00000)
#define SCON_TakeOverSys   (@{"SCON_Dummy" LINK File 152}+0)
#define SCON_KillReq       (@{"SCON_Dummy" LINK File 152}+1)
#define SCON_CDReboot      (@{"SCON_Dummy" LINK File 152}+2)
#define SCON_StopInput     (@{"SCON_Dummy" LINK File 152}+3)
#define SCON_AddCreateKeys (@{"SCON_Dummy" LINK File 152}+4)
#define SCON_RemCreateKeys (@{"SCON_Dummy" LINK File 152}+5)

/* Reboot control values for use with @{"SCON_CDReboot" LINK File 155} tag */
#define CDReboot_On             1
#define CDReboot_Off            0
#define CDReboot_Default        2


/*****************************************************************************/


/* Rawkey codes returned when using @{"SCON_AddCreateKeys" LINK File 157} with @{"SystemControl()" LINK "gg:doc/NDK/Guide/lowlevel/SystemControlA"} */

#define RAWKEY_PORT0_BUTTON_BLUE        0x72
#define RAWKEY_PORT0_BUTTON_RED 0x78
#define RAWKEY_PORT0_BUTTON_YELLOW      0x77
#define RAWKEY_PORT0_BUTTON_GREEN       0x76
#define RAWKEY_PORT0_BUTTON_FORWARD     0x75
#define RAWKEY_PORT0_BUTTON_REVERSE     0x74
#define RAWKEY_PORT0_BUTTON_PLAY        0x73
#define RAWKEY_PORT0_JOY_UP             0x79
#define RAWKEY_PORT0_JOY_DOWN           0x7A
#define RAWKEY_PORT0_JOY_LEFT           0x7C
#define RAWKEY_PORT0_JOY_RIGHT          0x7B

#define RAWKEY_PORT1_BUTTON_BLUE        0x172
#define RAWKEY_PORT1_BUTTON_RED 0x178
#define RAWKEY_PORT1_BUTTON_YELLOW      0x177
#define RAWKEY_PORT1_BUTTON_GREEN       0x176
#define RAWKEY_PORT1_BUTTON_FORWARD     0x175
#define RAWKEY_PORT1_BUTTON_REVERSE     0x174
#define RAWKEY_PORT1_BUTTON_PLAY        0x173
#define RAWKEY_PORT1_JOY_UP             0x179
#define RAWKEY_PORT1_JOY_DOWN           0x17A
#define RAWKEY_PORT1_JOY_LEFT           0x17C
#define RAWKEY_PORT1_JOY_RIGHT          0x17B

#define RAWKEY_PORT2_BUTTON_BLUE        0x272
#define RAWKEY_PORT2_BUTTON_RED 0x278
#define RAWKEY_PORT2_BUTTON_YELLOW      0x277
#define RAWKEY_PORT2_BUTTON_GREEN       0x276
#define RAWKEY_PORT2_BUTTON_FORWARD     0x275
#define RAWKEY_PORT2_BUTTON_REVERSE     0x274
#define RAWKEY_PORT2_BUTTON_PLAY        0x273
#define RAWKEY_PORT2_JOY_UP             0x279
#define RAWKEY_PORT2_JOY_DOWN           0x27A
#define RAWKEY_PORT2_JOY_LEFT           0x27C
#define RAWKEY_PORT2_JOY_RIGHT          0x27B

#define RAWKEY_PORT3_BUTTON_BLUE        0x372
#define RAWKEY_PORT3_BUTTON_RED 0x378
#define RAWKEY_PORT3_BUTTON_YELLOW      0x377
#define RAWKEY_PORT3_BUTTON_GREEN       0x376
#define RAWKEY_PORT3_BUTTON_FORWARD     0x375
#define RAWKEY_PORT3_BUTTON_REVERSE     0x374
#define RAWKEY_PORT3_BUTTON_PLAY        0x373
#define RAWKEY_PORT3_JOY_UP             0x379
#define RAWKEY_PORT3_JOY_DOWN           0x37A
#define RAWKEY_PORT3_JOY_LEFT           0x37C
#define RAWKEY_PORT3_JOY_RIGHT          0x37B


/*****************************************************************************/


/* Return values for @{"GetLanguageSelection()" LINK "gg:doc/NDK/Guide/lowlevel/GetLanguageSelection"} */
#define LANG_UNKNOWN    0
#define LANG_AMERICAN   1       /* American English */
#define LANG_ENGLISH    2       /* British English  */
#define LANG_GERMAN     3
#define LANG_FRENCH     4
#define LANG_SPANISH    5
#define LANG_ITALIAN    6
#define LANG_PORTUGUESE 7
#define LANG_DANISH     8
#define LANG_DUTCH      9
#define LANG_NORWEGIAN  10
#define LANG_FINNISH    11
#define LANG_SWEDISH    12
#define LANG_JAPANESE   13
#define LANG_CHINESE    14
#define LANG_ARABIC     15
#define LANG_GREEK      16
#define LANG_HEBREW     17
#define LANG_KOREAN     18


/*****************************************************************************/


#endif /* LIBRARIES_LOWLEVEL_H */
@ENDNODE
