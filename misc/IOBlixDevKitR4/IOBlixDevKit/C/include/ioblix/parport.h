/*
**      $VER: ioblix/parport.h 37.3 (7.4.99)
**
**      include file for access to IOBlix parallel ports
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_PARPORT_H
#define IOBLIX_PARPORT_H 1

#define PARPORT_DATA        0
#define PARPORT_ECP_AFIFO   0
#define PARPORT_STATUS      1
#define PARPORT_CONTROL     2
#define PARPORT_EPP_APORT   3
#define PARPORT_EPP_DPORT1  4
#define PARPORT_EPP_DPORT2  5
#define PARPORT_EPP_DPORT3  6
#define PARPORT_EPP_DPORT4  7
#define PARPORT_CONFIG_A    8
#define PARPORT_CFIFO       8
#define PARPORT_TFIFO       8
#define PARPORT_ECP_DFIFO   8
#define PARPORT_CONFIG_B    9
#define PARPORT_ECONTROL    10
#define PARPORT_REG_COUNT   11

/*
    The old static structures are now obsolete now and have been completely erased.
    These new definitions allow a much more hardware independent way to access different,
    but very similar chips (ie serial UARTs 16C650 and 16C654, which have the same registers,
    but at different addresses.
*/

struct ParPortRegisters {
    ULONG pr_RegCount;
    volatile UBYTE *pr_Regs[PARPORT_REG_COUNT];
};

#define pr_data         pr_Regs[PARPORT_DATA]
#define pr_ecp_afifo    pr_Regs[PARPORT_ECP_AFIFO]
#define pr_status       pr_Regs[PARPORT_STATUS]
#define pr_control      pr_Regs[PARPORT_CONTROL]
#define pr_epp_aport    pr_Regs[PARPORT_EPP_APORT]
#define pr_epp_dport1   pr_Regs[PARPORT_EPP_DPORT1]
#define pr_epp_dport2   pr_Regs[PARPORT_EPP_DPORT2]
#define pr_epp_dport3   pr_Regs[PARPORT_EPP_DPORT3]
#define pr_epp_dport4   pr_Regs[PARPORT_EPP_DPORT4]
#define pr_config_a     pr_Regs[PARPORT_CONFIG_A]
#define pr_cfifo        pr_Regs[PARPORT_CFIFO]
#define pr_tfifo        pr_Regs[PARPORT_TFIFO]
#define pr_ecp_dfifo    pr_Regs[PARPORT_ECP_DFIFO]
#define pr_config_b     pr_Regs[PARPORT_CONFIG_B]
#define pr_econtrol     pr_Regs[PARPORT_ECONTROL]

/* ParPort.control */
#define PARPORT_CONTROL_STROBE      0x01
#define PARPORT_CONTROL_AUTOFD      0x02
#define PARPORT_CONTROL_INIT        0x04
#define PARPORT_CONTROL_SELECT      0x08
#define PARPORT_CONTROL_ACKINT      0x10
#define PARPORT_CONTROL_DIRECTION   0x20

/* ParPort.status */
#define PARPORT_STATUS_EPP_TIMEOUT  0x01
#define PARPORT_STATUS_ERROR        0x08
#define PARPORT_STATUS_SELECT       0x10
#define PARPORT_STATUS_PAPEROUT     0x20
#define PARPORT_STATUS_ACK          0x40
#define PARPORT_STATUS_BUSY         0x80

/* ParPort.econtrol */
#define PARPORT_ECONTROL_FAULT      0x10
#define PARPORT_ECONTROL_DMA        0x08
#define PARPORT_ECONTROL_INT        0x04
#define PARPORT_ECONTROL_FIFO_F     0x02
#define PARPORT_ECONTROL_FIFO_E     0x01
#define PARPORT_ECONTROL_SPP        0x00
#define PARPORT_ECONTROL_PS2        0x20
#define PARPORT_ECONTROL_PPF        0x40
#define PARPORT_ECONTROL_ECP        0x60
#define PARPORT_ECONTROL_EPP        0x80
#define PARPORT_ECONTROL_TST        0xc0
#define PARPORT_ECONTROL_CFG        0xe0
#define PARPORT_ECONTROL_MODE_MASK  0xe0


/* structure returned by AllocECPInfo() */
/* all fields are READ-ONLY             */

struct ECPProbeInformation {
    BOOL epi_IsIEEE1284Compatible;      /* device is IEEE1284 compatible?   */
    UBYTE epi_Pad0;
    UBYTE *epi_FullInformation;         /* complete information string      */
    UBYTE *epi_Manufacturer;            /* device manufacturer              */
    UBYTE *epi_Model;                   /* device model                     */
    UBYTE *epi_Class;                   /* device class                     */
    UBYTE *epi_CommandSet;              /* supported command sets           */
    UBYTE *epi_Description;             /* device description               */
};

#endif /* IOBLIX_PARPORT_H */

