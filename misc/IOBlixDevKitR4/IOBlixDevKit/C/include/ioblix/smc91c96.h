/*
**      $VER: ioblix/smc91c96.h 37.3 (03.04.2000)
**
**      include file for access to EtherNet chip
**
**      (C) Copyright 1998-2000 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_SMC91C96_H
#define IOBLIX_SMC91C96_H 1

#define ETHER_REG0      0
#define ETHER_REG1      1
#define ETHER_REG2      2
#define ETHER_REG3      3
#define ETHER_REG4      4
#define ETHER_REG5      5
#define ETHER_REG6      6
#define ETHER_REG7      7
#define ETHER_REG_COUNT 8

/*
    The old static structures are now obsolete now and have been completely erased.
    These new definitions allow a much more hardware independent way to access different,
    but very similar chips (ie serial UARTs 16C650 and 16C654, which have the same registers,
    but at different addresses.
*/

struct EthernetRegisters {
    ULONG er_RegCount;
    volatile UWORD *er_Regs[ETHER_REG_COUNT];
};

#define bank_select         er_Regs[ETHER_REG7]

/* Bank 0 Register */
#define b0_tcr              er_Regs[ETHER_REG0]             /* transmit control register                    */
#define b0_eph_status       er_Regs[ETHER_REG1]
#define b0_rcr              er_Regs[ETHER_REG2]
#define b0_counter          er_Regs[ETHER_REG3]
#define b0_mir              er_Regs[ETHER_REG4]
#define b0_mcr              er_Regs[ETHER_REG5]

#define TCR_CLEAR           0x0000                          /* do NOTHING                                   */
#define TCR_TXENABLE        0x0100                          /* if this is 1, we can transmit                */
#define TCR_LOOP            0x0200                          /* local loopback                               */
#define TCR_FORCOL          0x0400                          /* Force Collision on next TX */
#define TCR_PAD_ENABLE      0x8000                          /* pads short packets to 64 bytes               */
#define TCR_NOCRC           0x0001                          /* don't append CRC to transmitted packets      */
#define TCR_MON_CNS         0x0004                          /* monitors the carrier status                  */
#define TCR_FDUPLX          0x0008                          /* receive packets sent out                     */
#define TCR_STP_SQET        0x0010                          /* stop transmitting if Signal quality error    */
#define TCR_EPH_LOOP        0x0020                          /* internal loopback at EPH block               */
#define TCR_FDSE            0x0080                          /* full duplex switch EtherNet                  */
#define TCR_NORMAL          (TCR_TXENABLE | TCR_PAD_ENABLE)

#define ES_TX_SUC           0x0100                          /* transmit successfull                         */
#define ES_SNGLCOL          0x0200                          /* single collision detected                    */
#define ES_MULCOL           0x0400                          /* multiple collisions detected                 */
#define ES_LTX_MULT         0x0800                          /* last frame was multicast                     */
#define ES_16COL            0x1000                          /* 16 collisions reached                        */
#define ES_SQET             0x2000                          /* single quality error test                    */
#define ES_LTX_BRD          0x4000                          /* last frame was broadcast                     */
#define ES_TX_DEFR          0x8000                          /* transmit deferred                            */
#define ES_WAKEUP           0x0001                          /* received packet had Magic Packet sig         */
#define ES_LATCOL           0x0002                          /* late collision detected                      */
#define ES_LOST_CARR        0x0004                          /* lost carrier sense                           */
#define ES_EXC_DEF          0x0008                          /* excessive deferral                           */
#define ES_CTR_ROL          0x0010                          /* counter roll over                            */
#define ES_RX_OVRN          0x0020                          /* receive FIFO overrun                         */
#define ES_LINK_OK          0x0040                          /* is the link integrity ok ?                   */
#define ES_TX_UNRN          0x0080                          /* transmit underrun                            */

#define RCR_CLEAR           0x0000                          /* set it to a base state                       */
#define RCR_RX_ABORT        0x0100                          /* receive frame aborted                        */
#define RCR_PROMISC         0x0200                          /* enable promiscuous mode                      */
#define RCR_ALMUL           0x0400                          /* receive all multicast packets                */
#define RCR_RXENABLE        0x0001                          /* IFF this is set, we can receive packets      */
#define RCR_STRIP_CRC       0x0002                          /* strips CRC                                   */
#define RCR_FILT_CARR       0x0040                          /* filter carrier                               */
#define RCR_SOFTRESET       0x0080                          /* resets the chip                              */
// #define RCR_NORMAL          (RCR_STRIP_CRC | RCR_RXENABLE)  /* the normal settings for the RCR register :   */
#define RCR_NORMAL          (RCR_RXENABLE)                  /* the normal settings for the RCR register :   */

#define CTR_EXCDEF_TX_MASK  0x00f0                          /* exc. deferred tx counter mask                */
#define CTR_DEF_TX_MASK     0x000f                          /* deferred tx counter mask                     */
#define CTR_MULTCOLL_MASK   0xf000                          /* multiple collision counter mask              */
#define CTR_SINGCOLL_MASK   0x0f00                          /* single collision counter mask                */

/* Bank 1 Register */
#define b1_config           er_Regs[ETHER_REG0]
#define b1_base             er_Regs[ETHER_REG1]
#define b1_addr0            er_Regs[ETHER_REG2]
#define b1_addr1            er_Regs[ETHER_REG3]
#define b1_addr2            er_Regs[ETHER_REG4]
#define b1_general          er_Regs[ETHER_REG5]
#define b1_control          er_Regs[ETHER_REG6]

#define CFG_INT_0           0x0000
#define CFG_INT_1           0x0200
#define CFG_INT_2           0x0400
#define CFG_INT_3           0x0600
#define CFG_DIS_LINK        0x4000                          /* Disable 10BaseT Link Test */
#define CFG_EN16            0x8000
#define CFG_AUI_SELECT      0x0001                          /* Use external (AUI) Transceiver */
#define CFG_SET_SQLSH       0x0002
#define CFG_FULLSTEP        0x0004                          /* AUI signalling mode */
#define CFG_NOWAIT          0x0010
#define CFG_MII_SELECT      0x0080

#define CTL_STORE           0x0100                          /* store registers in EEPROM                    */
#define CTL_RELOAD          0x0200                          /* load registers from EEPROM                   */
#define CTL_EEPROM_SEL      0x0400
#define CTL_TE_ENABLE       0x2000                          /* transmit error enable                        */
#define CTL_CR_ENABLE       0x4000                          /* counter roll over enable                     */
#define CTL_LE_ENABLE       0x8000                          /* link error enable                            */
#define CTL_AUTO_RELEASE    0x0008                          /* automatically release successful pages       */
#define CTL_WAKEUP_EN       0x0010                          /* enable auto wakeup in powerdown mode         */
#define CTL_POWERDOWN       0x0020                          /* put chip in powerdown mode                   */
#define CTL_RCV_BAD         0x0040                          /* receive bad CRC packets                      */
#define CTL_EPROM_ACCESS    0x0300                          /* high if Eprom is being read                  */

/* Bank 2 Register */
#define b2_mmu_cmd          er_Regs[ETHER_REG0]
#define b2_pnr_arr          er_Regs[ETHER_REG1]
#define b2_fifo_ports       er_Regs[ETHER_REG2]
#define b2_pointer          er_Regs[ETHER_REG3]
#define b2_data1            er_Regs[ETHER_REG4]
#define b2_data2            er_Regs[ETHER_REG5]
#define b2_interrupt        er_Regs[ETHER_REG6]
#define b2_int_mask         er_Regs[ETHER_REG6]

#define MC_NOP              0x0000
#define MC_BUSY             0x0100                          /* only readable bit in the register            */
#define MC_ALLOC            0x2000                          /* or with number of 256 byte packets           */
#define MC_RESET            0x4000                          /* reset MMU                                    */
#define MC_REMOVE           0x6000                          /* remove the current rx packet                 */
#define MC_RELEASE          0x8000                          /* remove and release the current rx packet     */
#define MC_FREEPKT          0xA000                          /* Release packet in PNR register               */
#define MC_ENQUEUE          0xC000                          /* Enqueue the packet for transmit              */
#define MC_RESET_TX         0xE000                          /* reset tx FIFOs                               */

#define PA_FAILED           0x0080
#define PA_ALLOC_MASK       0x007f                          /* mask for packet number at tx area            */
#define PA_PNUM_MASK        0x7f00                          /* mask for allocated packet number             */

#define FP_RXEMPTY          0x0080                          /* rx FIFO empty                                */
#define FP_TXEMPTY          0x8000                          /* tx FIFO empty                                */
#define FP_RXFIFO_MASK      0x001f                          /* mask for rx FIFO packet number               */
#define FP_TXDONE_MASK      0x1f00                          /* mask for tx done packet number               */

#define PTR_EARLY_EN        0x0010                          /* enable early transmit                        */
#define PTR_READ            0x0020
#define PTR_AUTOINC         0x0040
#define PTR_RCV             0x0080

#define IM_RCV_INT          0x01
#define IM_TX_INT           0x02
#define IM_TX_EMPTY_INT     0x04
#define IM_ALLOC_INT        0x08
#define IM_RX_OVRN_INT      0x10
#define IM_EPH_INT          0x20
#define IM_ERCV_INT         0x40                           /* not on SMC9192 */
#define IM_TX_IDLE_INT      0x80
#define IM_INTERRUPT_MASK   (IM_EPH_INT | IM_RX_OVRN_INT | IM_RCV_INT)

#define AllocPages(ec, num) *(ec)->b2_mmu_cmd = (MC_ALLOC | ((num) << 8))

/* Bank 3 Register */
#define b3_multicast1       er_Regs[ETHER_REG0]
#define b3_multicast2       er_Regs[ETHER_REG1]
#define b3_multicast3       er_Regs[ETHER_REG2]
#define b3_multicast4       er_Regs[ETHER_REG3]
#define b3_mgmt             er_Regs[ETHER_REG4]
#define b3_revision         er_Regs[ETHER_REG5]
#define b3_ercv             er_Regs[ETHER_REG6]

#define SelectBank(ec, bank) *(ec)->bank_select = (bank << 8)
#define GetBank(ec)         ((*(ec)->bank_select >> 8) & 0x000f)

#define EtherDelay(ec)      { UWORD scratch; scratch = *(ec)->b0_rcr; scratch = *(ec)->b0_rcr; scratch = *(ec)->b0_rcr; }

#define AckIRQ(ec, x)       *(ec)->b2_int_mask = (*(ec)->b2_int_mask & 0x00ff) | ((x) << 8)
#define GetIRQ(ec)          ((*(ec)->b2_int_mask & 0xff00) >> 8)

#define SetIRQMask(ec, x)   *(ec)->b2_int_mask = (x)
#define GetIRQMask(ec)      (*(ec)->b2_int_mask & 0x00ff)

#define EnableIRQ(ec, x)    *(ec)->b2_int_mask |= (x)
#define DisableIRQ(ec, x)   *(ec)->b2_int_mask &= ~(x)

/* Transmit status bits */
#define TS_SUCCESS          0x0001
#define TS_16COL            0x0010
#define TS_SQET             0x0020
#define TS_LATCOL           0x0200
#define TS_LOSTCAR          0x0400

/* Receive status bits */
#define RS_MULTICAST        0x0100
#define RS_HASH_MASK        0x7e00
#define RS_TOOSHORT         0x0004
#define RS_TOOLONG          0x0008
#define RS_ODDFRAME         0x0010
#define RS_BADCRC           0x0020
#define RS_BROADCAST        0x0040
#define RS_ALGNERR          0x0080
#define RS_ERRORS           (RS_ALGNERR | RS_BADCRC | RS_TOOLONG | RS_TOOSHORT)

/* The control byte has the following significant bits.
 * For transmit, the CTLB_ODD bit specifies whether an extra byte
 * is present in the frame.  Bit 0 of the byte count field is
 * ignored.  I just pad every frame to even length and forget about
 * it.
 */
#define CTLB_CRC            0x10 /* Add CRC for this packet (TX only) */
#define CTLB_ODD            0x20 /* The packet length is ODD */

#define INVALID_MAC_ADDRESS "\x00\x00\x00\x00\x00\x00"

#endif /* IOBLIX_SMC91C96_H */

