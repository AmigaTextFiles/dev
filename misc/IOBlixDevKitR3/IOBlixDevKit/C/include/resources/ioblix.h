/*
**      $VER: resources/ioblix.h 37.3 (7.4.99)
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef RESOURCES_IOBLIX_H
#define RESOURCES_IOBLIX_H 1

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef EXEC_INTERRUPTS_H
#include <exec/interrupts.h>
#endif

#ifndef PREFS_SERIAL_H
#include <prefs/serial.h>
#endif

#define IOBLIXRESNAME               "ioblix.resource"

/* manufacturer and product IDs for RBM products */
#define RBM_MANUF_ID                4711    /* manufacturer ID of RBM Digitaltechnik    */
#define IOBLIX_Z2_PROD_ID           1       /* board ID of ZorroII IOBlix board         */
#define IOBLIX_1200_SER_PROD_ID     2       /* board ID of IOBlix1200 ser module        */
#define IOBLIX_1200_PAR_PROD_ID     3       /* board ID of IOBlix1200 par module        */

/* how many boards can exist */
#define IOBLIX_MAX_Z2_BOARDS        5
#define IOBLIX_MAX_CP_BOARDS        1

/* how many units of which type can exist */
#define IOBLIX_Z2_NUM_SERUNITS      4       /* max. serial ports on Z2 board            */
#define IOBLIX_Z2_NUM_PARUNITS      2       /* max. parallel ports on Z2 board          */
#define IOBLIX_Z2_NUM_FIFOUNITS     1       /* max. ext. fifos on Z2 board              */
#define IOBLIX_Z2_NUM_ETHERUNITS    1       /* max. EtherNet modules on Z2 board        */
#define IOBLIX_Z2_NUM_AUDIOUNITS    1       /* max. Audio modules on Z2 board           */

#define IOBLIX_CP_NUM_SERUNITS      4       /* max. ser ports on clock port board       */
#define IOBLIX_CP_NUM_PARUNITS      4       /* max. par ports on clock port board       */
#define IOBLIX_CP_NUM_FIFOUNITS     0       /* max. fifos on clock port board           */
#define IOBLIX_CP_NUM_ETHERUNITS    0       /* max. EtherNets on clock port board       */
#define IOBLIX_CP_NUM_AUDIOUNITS    0       /* max. Audio modules on clock port board   */

/* the central resource */
struct IOBlixResource {
    struct Library ir_Library;
    struct ExecBase *ir_SysBase;
    /* private data follows, hands off! */
};

struct IOBlixBoardNode {
    struct Node ibn_Node;                   /* link                                     */
    struct ConfigDev *ibn_Board;            /* ConigDev structure as returned by        */
                                            /* expansion/FindConfigDev()                */
    UWORD ibn_Type;                         /* Z2, clock port, etc                      */
    UWORD ibn_Number;                       /* internal board number                    */
};

/* IOBlixBoardNode.ibn_Type */
#define IBT_ZORRO2                  1       /* ZorroII board                            */
#define IBT_CP_SERIAL               2       /* clock port serial module                 */
#define IBT_CP_PARALLEL             3       /* clock port parallel module               */

/* common structure for chip's register addresses */
struct ChipRegs {
    ULONG cr_RegCount;                      /* number of register addresses following   */
    APTR cr_Regs[1];                        /* dummy array of register addresses        */
                                            /* cr_RegCount pointers follow              */
};

struct IOBlixPnPInfo {
    UBYTE pnp_SerialIdentifier[32];         /* serial identifiert read during PnP       */
    UBYTE pnp_DeviceIdent[8];
    ULONG pnp_DeviceSerNo;
    APTR pnp_AddressAddr;                   /* address register address                 */
    APTR pnp_WriteAddr;                     /* write register address                   */
    APTR pnp_ReadAddr;                      /* read register address                    */
    ULONG pnp_CardSelectNumber;             /* PnP device number (CSN)                  */
    ULONG pnp_LogicalDeviceNumber;          /* logical device number of this chip       */
    APTR pnp_Reserved[4];
};

/* IOBlixChipNode, returned by FindChip() and ObtainChip */
/* all fields are READ-ONLY! */
struct IOBlixChipNode {
    struct Node icn_Node;                   /* link                                     */
    ULONG  icn_Flags;                       /* flags                                    */
    UWORD  icn_Type;                        /* chip type (ser, par, etc)                */
    UWORD  icn_Number;                      /* chip's internal number                   */
                                            /* equals unit number of devices            */
    struct ChipRegs *icn_ChipRegisters;     /* array of pointers to chips registers     */
                                            /* ie a pointer to (struct UARTRegisters *) */
                                            /* the old icn_Address entry is obsolete    */
    UBYTE  icn_Description[256];            /* name, information, etc                   */
    UBYTE *icn_Owner;                       /* current owner name, or NULL if none      */
    struct IOBlixBoardNode *icn_Board;      /* board to which the chip belongs to       */
    LONG   icn_ExpanderPort;                /* cp port, if used with cp expander        */
                                            /* -1 for Z2 boards                         */
                                            /* 0..3 for clockport modules               */
    struct SignalSemaphore icn_SharedAccessSema;
                                            /* semaphore for shared chip access         */
                                            /* you MUST obtain this if you want to      */
                                            /* access the chip in shared mode to avoid  */
                                            /* crashes                                  */
    struct List icn_SharedAccessorList;     /* list of shared accessors                 */
    ULONG  icn_SharedAccessorCount;         /* counter for shared accesses              */
    union {
        struct SerialChipProperties {
            ULONG scp_UARTType;             /* serial UART type                         */
            ULONG scp_FIFOSize;             /* UART's fifo size                         */
            ULONG scp_Flags;                /* flags                                    */
            ULONG scp_Frequency;            /* oscillator frequency                     */
            struct SerialPrefs scp_Prefs;   /* baud, handshake, etc                     */
        } icn_SerialProperties;
        struct ParallelChipProperties {
            ULONG pcp_Abilities;            /* parport ability mask                     */
            ULONG pcp_FIFOSize;             /* parallel fifo size                       */
            ULONG pcp_WriteThresh;          /* irq threshold on write                   */
            ULONG pcp_ReadThresh;           /* irq threshold on read                    */
        } icn_ParallelProperties;
        struct ExternalFIFOProperties {
            BOOL efp_Installed;
            BOOL efp_Operable;
            ULONG efp_WriteFIFOSize;
            ULONG efp_WriteHalfFullSize;
            ULONG efp_ReadFIFOSize;
            ULONG efp_ReadHalfFullSize;
        } icn_ExternalFIFOProperties;
        struct AudioChipProperties {
            struct IOBlixPnPInfo acp_PnPInfo;
        } icn_AudioChipProperties;
    } icn_Properties;
};

#define icns_UARTType               icn_Properties.icn_SerialProperties.scp_UARTType
#define icns_FIFOSize               icn_Properties.icn_SerialProperties.scp_FIFOSize
#define icns_Flags                  icn_Properties.icn_SerialProperties.scp_Flags
#define icns_Frequency              icn_Properties.icn_SerialProperties.scp_Frequency
#define icns_Prefs                  icn_Properties.icn_SerialProperties.scp_Prefs
#define icnp_Abilities              icn_Properties.icn_ParallelProperties.pcp_Abilities
#define icnp_FIFOSize               icn_Properties.icn_ParallelProperties.pcp_FIFOSize
#define icnp_WriteThresh            icn_Properties.icn_ParallelProperties.pcp_WriteThresh
#define icnp_ReadThresh             icn_Properties.icn_ParallelProperties.pcp_ReadThresh
#define icnf_StatusReg              icn_Properties.icn_ExternalFIFOProperties.efp_StatusReg
#define icnf_Installed              icn_Properties.icn_ExternalFIFOProperties.efp_Installed
#define icnf_Operable               icn_Properties.icn_ExternalFIFOProperties.efp_Operable
#define icnf_WriteFIFOSize          icn_Properties.icn_ExternalFIFOProperties.efp_WriteFIFOSize
#define icnf_WriteHalfFullSize      icn_Properties.icn_ExternalFIFOProperties.efp_WriteHalfFullSize
#define icnf_ReadFIFOSize           icn_Properties.icn_ExternalFIFOProperties.efp_ReadFIFOSize
#define icnf_ReadHalfFullSize       icn_Properties.icn_ExternalFIFOProperties.efp_ReadHalfFullSize
#define icna_PnPInfo                icn_Properties.icn_AudioChipProperties.acp_PnPInfo

/* icn_Flags */
#define ICFB_SHARED                 0       /* chip is obtained in shared mode          */
#define ICFF_SHARED                 (1 << ICFB_SHARED)

/* icn_Type */
#define ICT_NO_CHIP                 0       /* just a dummy                             */
#define ICT_Z2_SERIAL_CHIP          1       /* UART on a ZorroII board                  */
#define ICT_Z2_PARALLEL_CHIP        2       /* ParPort on a ZorroII board               */
#define ICT_Z2_EXTFIFO_CHIP         3       /* FIFO on a ZorroII board                  */
#define ICT_Z2_ETHERNET_CHIP        4       /* EtherNet chip on a ZorroII board         */
#define ICT_Z2_AUDIO_SBPRO_CHIP     5       /* SoundBlaster                             */
#define ICT_Z2_AUDIO_ADLIB_CHIP     6       /* AdLib                                    */
#define ICT_Z2_AUDIO_SSD_CHIP       7       /* SoundSystemDirect                        */
#define ICT_Z2_AUDIO_MIDI_CHIP      8       /* MIDI                                     */
#define ICT_Z2_AUDIO_GAMEPORT_CHIP  9       /* GamePort                                 */
#define ICT_CP_SERIAL_CHIP          101     /* UART on a clock port module              */
#define ICT_CP_PARALLEL_CHIP        102     /* ParPort on a clock port module           */

/* scp_UARTType */
#define SCPT_UNKNOWN                0       /* unknown UART                             */
#define SCPT_8250                   1       /* CIA 8250                                 */
#define SCPT_16450                  2       /* 16C450                                   */
#define SCPT_16550                  3       /* 16C550                                   */
#define SCPT_16550A                 4       /* 16C550A                                  */
#define SCPT_CIRRUS                 5       /* Cirrus                                   */
#define SCPT_16650                  6       /* 16C650                                   */
#define SCPT_16650V2                7       /* 16C650 V2                                */
#define SCPT_16654                  8       /* 16C654                                   */
#define SCPT_16750                  9       /* 16C750                                   */
#define SCPT_STARTECH               10      /* StarTech                                 */
#define SCPT_MAX                    10

/* scp_Flags */
#define SCPFB_USE_FIFO              0       /* enable FIFO                              */
#define SCPFF_USE_FIFO              (1 << SCPFB_USE_FIFO)
#define SCPFB_CLEAR_FIFO            1       /* clear FIFO on use                        */
#define SCPFF_CLEAR_FIFO            (1 << SCPFB_CLEAR_FIFO)
#define SCPFB_STARTECH              2       /* enable StarTech features                 */
#define SCPFF_STARTECH              (1 << SCPFB_STARTECH)
/* pcp_Abilities */
/* simple parallel port */
#define PCPAB_SPP                   0
#define PCPAF_SPP                   (1 << PCPAB_SPP)
/* parallel port with fifo */
#define PCPAB_PPF                   1
#define PCPAF_PPF                   (1 << PCPAB_PPF)
/* PS/2 mode supported */
#define PCPAB_PS2                   2
#define PCPAF_PS2                   (1 << PCPAB_PS2)
/* EPP mode supported */
#define PCPAB_EPP                   3
#define PCPAF_EPP                   (1 << PCPAB_EPP)
/* ECP mode supported */
#define PCPAB_ECP                   4
#define PCPAF_ECP                   (1 << PCPAB_ECP)
/* ECR register available */
#define PCPAB_ECR                   5
#define PCPAF_ECR                   (1 << PCPAB_ECR)
/* ECP/PS2 mode supported */
#define PCPAB_ECP_PS2               6
#define PCPAF_ECP_PS2               (1 << PCPAB_ECP_PS2)
/* ECP/EPP mode supported */
#define PCPAB_ECP_EPP               7
#define PCPAF_ECP_EPP               (1 << PCPAB_ECP_EPP)
/* IEEE1284 compatible */
#define PCPAB_IEEE1284              8
#define PCPAF_IEEE1284              (1 << PCPAB_IEEE1284)
/* port is completely dead */
#define PCPAB_NOT_WORKING           31
#define PCPAF_NOT_WORKING           (1 << PCPAB_NOT_WORKING)

/* Interrupt Hooks                                                                      */
/* To be able to recognize all interrupts, that can happen on an IOBlix board, it is    */
/* necessary to hook into IOBlix' own interrupt chain. Your node will be enqueued       */
/* and called dependant of its priority.                                                */
/* This structure must be filled with all necessary data to be called within an         */
/* interrupt.                                                                           */
/* Especially ihn_Node.ln_Pri should be initialized with a suitable value               */

struct IRQHookNode {
    struct Node ihn_Node;                   /*                                          */
    ULONG (*ihn_HookFunc)( APTR userData ); /* the function, that is to be called when  */
                                            /* an interrupt occurs                      */
    APTR ihn_HookUserData;                  /* any data you want to be passed to your   */
                                            /* function. Data is passed on the stack!   */
};

#endif /* RESOURCES_IOBLIX_H */

