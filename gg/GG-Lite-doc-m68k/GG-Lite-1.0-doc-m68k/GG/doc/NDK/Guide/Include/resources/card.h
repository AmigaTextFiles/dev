@DATABASE "gg:doc/NDK/Guide/Include/resources/card.h"
@MASTER   "gg:os-include/resources/card.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:22
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "resources/card.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"resources/card.h" LINK File}


@{b}Structures@{ub}

@{"CardHandle" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 30}  @{"CardMemoryMap" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 45}  @{"DeviceTData" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 38}  @{"TP_AmigaXIP" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 164}


@{b}#defines@{ub}

@{"CARD_DISABLEB_WP" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 114}       @{"CARD_DISABLEF_WP" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 115}      @{"CARD_ENABLEB_DIGAUDIO" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 111}
@{"CARD_ENABLEF_DIGAUDIO" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 112}  @{"CARD_INTB_BSY" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 143}         @{"CARD_INTB_BVD1" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 131}
@{"CARD_INTB_BVD2" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 137}         @{"CARD_INTB_DA" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 140}          @{"CARD_INTB_IRQ" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 146}
@{"CARD_INTB_SC" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 134}           @{"CARD_INTB_SETCLR" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 128}      @{"CARD_INTERFACE_AMIGA_0" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 152}
@{"CARD_INTF_BSY" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 144}          @{"CARD_INTF_BVD1" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 132}        @{"CARD_INTF_BVD2" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 138}
@{"CARD_INTF_DA" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 141}           @{"CARD_INTF_IRQ" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 147}         @{"CARD_INTF_SC" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 135}
@{"CARD_INTF_SETCLR" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 129}       @{"CARD_STATUSB_BSY" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 97}      @{"CARD_STATUSB_BVD1" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 82}
@{"CARD_STATUSB_BVD2" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 88}      @{"CARD_STATUSB_CCDET" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 79}    @{"CARD_STATUSB_DA" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 91}
@{"CARD_STATUSB_IRQ" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 100}       @{"CARD_STATUSB_SC" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 85}       @{"CARD_STATUSB_WR" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 94}
@{"CARD_STATUSF_BSY" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 98}       @{"CARD_STATUSF_BVD1" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 83}     @{"CARD_STATUSF_BVD2" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 89}
@{"CARD_STATUSF_CCDET" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 80}     @{"CARD_STATUSF_DA" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 92}       @{"CARD_STATUSF_IRQ" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 101}
@{"CARD_STATUSF_SC" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 86}        @{"CARD_STATUSF_WR" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 95}       @{"CARD_VOLTAGE_0V" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 105}
@{"CARD_VOLTAGE_12V" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 107}       @{"CARD_VOLTAGE_5V" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 106}       @{"CARDB_DELAYOWNERSHIP" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 66}
@{"CARDB_IFAVAILABLE" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 63}      @{"CARDB_POSTSTATUS" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 69}      @{"CARDB_REMOVEHANDLE" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 74}
@{"CARDB_RESETREMOVE" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 60}      @{"CARDF_DELAYOWNERSHIP" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 67}  @{"CARDF_IFAVAILABLE" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 64}
@{"CARDF_POSTSTATUS" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 70}       @{"CARDF_REMOVEHANDLE" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 75}    @{"CARDF_RESETREMOVE" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 61}
@{"CARDRESNAME" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 26}            @{"CISTPL_AMIGAXIP" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 162}       @{"XIPFLAGSB_AUTORUN" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 184}
@{"XIPFLAGSF_AUTORUN" LINK "gg:doc/NDK/Guide/Include/resources/card.h/File" 185}      

@ENDNODE
@NODE File "resources/card.h"
#ifndef RESOURCES_CARD_H
#define RESOURCES_CARD_H 1

/*
**      $VER: card.h 1.11 (14.12.1992)
**      Includes Release 45.1
**
**      @{"card.resource" LINK "gg:doc/NDK/Guide/cardres/MAIN"} include file
**
**      (C) Copyright 1991-2001 Amiga, Inc.
**          All Rights Reserved
**
*/
#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

#ifndef EXEC_INTERRUPTS_H
#include <@{"exec/interrupts.h" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File"}>
#endif

#define CARDRESNAME     "card.resource"

/* Structures used by the @{"card.resource" LINK "gg:doc/NDK/Guide/cardres/MAIN"}                         */

struct  CardHandle {
        @{"struct Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22} cah_CardNode;
        @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *cah_CardRemoved;
        @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *cah_CardInserted;
        @{"struct Interrupt" LINK "gg:doc/NDK/Guide/Include/exec/interrupts.h/File" 22} *cah_CardStatus;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   cah_CardFlags;
};

struct  DeviceTData {
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dtd_DTsize;     /* Size in bytes                */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   dtd_DTspeed;    /* Speed in nanoseconds         */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   dtd_DTtype;     /* Type of card                 */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   dtd_DTflags;    /* Other flags                  */
};

struct  CardMemoryMap {
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *cmm_CommonMemory;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *cmm_AttributeMemory;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *cmm_IOMemory;

/* Extended for V39 - These are the size of the memory spaces above */

        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cmm_CommonMemSize;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cmm_AttributeMemSize;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}   cmm_IOMemSize;

};

/* CardHandle.cah_CardFlags for @{"OwnCard()" LINK "gg:doc/NDK/Guide/cardres/OwnCard"} function              */

#define CARDB_RESETREMOVE       0
#define CARDF_RESETREMOVE       (1<<@{"CARDB_RESETREMOVE" LINK File 60})

#define CARDB_IFAVAILABLE       1
#define CARDF_IFAVAILABLE       (1<<@{"CARDB_IFAVAILABLE" LINK File 63})

#define CARDB_DELAYOWNERSHIP    2
#define CARDF_DELAYOWNERSHIP    (1<<@{"CARDB_DELAYOWNERSHIP" LINK File 66})

#define CARDB_POSTSTATUS        3
#define CARDF_POSTSTATUS        (1<<@{"CARDB_POSTSTATUS" LINK File 69})

/* ReleaseCreditCard() function flags                           */

#define CARDB_REMOVEHANDLE      0
#define CARDF_REMOVEHANDLE      (1<<@{"CARDB_REMOVEHANDLE" LINK File 74})

/* ReadStatus() return flags                                    */

#define CARD_STATUSB_CCDET              6
#define CARD_STATUSF_CCDET              (1<<@{"CARD_STATUSB_CCDET" LINK File 79})

#define CARD_STATUSB_BVD1               5
#define CARD_STATUSF_BVD1               (1<<@{"CARD_STATUSB_BVD1" LINK File 82})

#define CARD_STATUSB_SC                 5
#define CARD_STATUSF_SC                 (1<<@{"CARD_STATUSB_SC" LINK File 85})

#define CARD_STATUSB_BVD2               4
#define CARD_STATUSF_BVD2               (1<<@{"CARD_STATUSB_BVD2" LINK File 88})

#define CARD_STATUSB_DA                 4
#define CARD_STATUSF_DA                 (1<<@{"CARD_STATUSB_DA" LINK File 91})

#define CARD_STATUSB_WR                 3
#define CARD_STATUSF_WR                 (1<<@{"CARD_STATUSB_WR" LINK File 94})

#define CARD_STATUSB_BSY                2
#define CARD_STATUSF_BSY                (1<<@{"CARD_STATUSB_BSY" LINK File 97})

#define CARD_STATUSB_IRQ                2
#define CARD_STATUSF_IRQ                (1<<@{"CARD_STATUSB_IRQ" LINK File 100})

/* @{"CardProgramVoltage()" LINK "gg:doc/NDK/Guide/cardres/CardProgramVoltage"} defines */

#define CARD_VOLTAGE_0V         0       /* Set to default; may be the same as 5V */
#define CARD_VOLTAGE_5V         1
#define CARD_VOLTAGE_12V        2

/* @{"CardMiscControl()" LINK "gg:doc/NDK/Guide/cardres/CardMiscControl"} defines */

#define CARD_ENABLEB_DIGAUDIO   1
#define CARD_ENABLEF_DIGAUDIO   (1<<@{"CARD_ENABLEB_DIGAUDIO" LINK File 111})

#define CARD_DISABLEB_WP        3
#define CARD_DISABLEF_WP        (1<<@{"CARD_DISABLEB_WP" LINK File 114})

/*
 * New @{"CardMiscControl()" LINK "gg:doc/NDK/Guide/cardres/CardMiscControl"} bits for V39 @{"card.resource" LINK "gg:doc/NDK/Guide/cardres/MAIN"}.  Use these bits to set,
 * or clear status change interrupts for BVD1/SC, BVD2/DA, and BSY/IRQ.
 * Write-enable/protect change interrupts are always enabled.  The defaults
 * are unchanged (BVD1/SC is enabled, BVD2/DA is disabled, and BSY/IRQ is enabled).
 *
 * IMPORTANT -- Only set these bits for V39 @{"card.resource" LINK "gg:doc/NDK/Guide/cardres/MAIN"} or greater (check
 * resource base VERSION)
 *
 */

#define CARD_INTB_SETCLR        7
#define CARD_INTF_SETCLR        (1<<@{"CARD_INTB_SETCLR" LINK File 128})

#define CARD_INTB_BVD1          5
#define CARD_INTF_BVD1          (1<<@{"CARD_INTB_BVD1" LINK File 131})

#define CARD_INTB_SC            5
#define CARD_INTF_SC            (1<<@{"CARD_INTB_SC" LINK File 134})

#define CARD_INTB_BVD2          4
#define CARD_INTF_BVD2          (1<<@{"CARD_INTB_BVD2" LINK File 137})

#define CARD_INTB_DA            4
#define CARD_INTF_DA            (1<<@{"CARD_INTB_DA" LINK File 140})

#define CARD_INTB_BSY           2
#define CARD_INTF_BSY           (1<<@{"CARD_INTB_BSY" LINK File 143})

#define CARD_INTB_IRQ           2
#define CARD_INTF_IRQ           (1<<@{"CARD_INTB_IRQ" LINK File 146})


/* @{"CardInterface()" LINK "gg:doc/NDK/Guide/cardres/CardInterface"} defines */

#define CARD_INTERFACE_AMIGA_0  0

/*
 * Tuple for Amiga execute-in-place software (e.g., games, or other
 * such software which wants to use execute-in-place software stored
 * on a credit-card, such as a ROM card).
 *
 * See documentatin for @{"IfAmigaXIP()" LINK "gg:doc/NDK/Guide/cardres/IfAmigaXIP"}.
 */

#define CISTPL_AMIGAXIP 0x91

struct  TP_AmigaXIP {
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TPL_CODE;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TPL_LINK;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TP_XIPLOC[4];
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TP_XIPFLAGS;
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   TP_XIPRESRV;
        };
/*

        ; The XIPFLAGB_AUTORUN bit means that you want the machine
        ; to perform a reset if the execute-in-place card is inserted
        ; after DOS has been started.  The machine will then reset,
        ; and execute your execute-in-place code the next time around.
        ;
        ; NOTE -- this flag may be ignored on some machines, in which
        ; case the user will have to manually reset the machine in the
        ; usual way.

*/

#define XIPFLAGSB_AUTORUN       0
#define XIPFLAGSF_AUTORUN       (1<<@{"XIPFLAGSB_AUTORUN" LINK File 184})

#endif  /* RESOURCES_CARD_H */
@ENDNODE
