/*
**      $VER: ioblix/uart.h 37.3 (7.4.99)
**
**      include file for access to IOBlix UARTs
**
**      (C) Copyright 1998,1999 Thore Böckelmann
**      All Rights Reserved.
*/

#ifndef IOBLIX_UART_H
#define IOBLIX_UART_H 1

#define UART_RX             0
#define UART_TX             0
#define UART_DLL            0
#define UART_IER            1
#define UART_DLM            1
#define UART_IIR            2
#define UART_FCR            2
#define UART_EFR            2
#define UART_LCR            3
#define UART_MCR            4
#define UART_XON1           4
#define UART_LSR            5
#define UART_XON2           5
#define UART_MSR            6
#define UART_XOFF1          6
#define UART_SCR            7
#define UART_XOFF2          7
#define UART_REG_COUNT      8

/*
    The old static structures are now obsolete now and have been completely erased.
    These new definitions allow a much more hardware independent way to access different,
    but very similar chips (ie serial UARTs 16C650 and 16C654, which have the same registers,
    but at different addresses.
*/

struct UARTRegisters {
    ULONG ur_RegCount;
    volatile UBYTE *ur_Regs[UART_REG_COUNT];
};

#define ur_rx           ur_Regs[UART_RX]
#define ur_tx           ur_Regs[UART_TX]
#define ur_dll          ur_Regs[UART_DLL]
#define ur_ier          ur_Regs[UART_IER]
#define ur_dlm          ur_Regs[UART_DLM]
#define ur_iir          ur_Regs[UART_IIR]
#define ur_fcr          ur_Regs[UART_FCR]
#define ur_efr          ur_Regs[UART_EFR]
#define ur_lcr          ur_Regs[UART_LCR]
#define ur_mcr          ur_Regs[UART_MCR]
#define ur_xon1         ur_Regs[UART_XON1]
#define ur_lsr          ur_Regs[UART_LSR]
#define ur_xon2         ur_Regs[UART_XON2]
#define ur_msr          ur_Regs[UART_MSR]
#define ur_xoff1        ur_Regs[UART_XOFF1]
#define ur_scr          ur_Regs[UART_SCR]
#define ur_xoff2        ur_Regs[UART_XOFF2]

/*
 * These are the definitions for the FIFO Control Register
 * (16650 only)
 */
#define UART_FCR_ENABLE_FIFO    0x01 /* Enable the FIFO */
#define UART_FCR_CLEAR_RCVR     0x02 /* Clear the RCVR FIFO */
#define UART_FCR_CLEAR_XMIT     0x04 /* Clear the XMIT FIFO */
#define UART_FCR_DMA_SELECT     0x08 /* For DMA applications */
#define UART_FCR_TRIGGER_MASK   0xC0 /* Mask for the FIFO trigger range */
#define UART_FCR_TRIGGER_1      0x00 /* Mask for trigger set at 1 */
#define UART_FCR_TRIGGER_4      0x40 /* Mask for trigger set at 4 */
#define UART_FCR_TRIGGER_8      0x80 /* Mask for trigger set at 8 */
#define UART_FCR_TRIGGER_14     0xC0 /* Mask for trigger set at 14 */
/* 16650A redefinitions */
#define UART_FCR0_R_TRIGGER_8   0x00 /* Mask for receive trigger set at 8 */
#define UART_FCR0_R_TRIGGER_16  0x40 /* Mask for receive trigger set at 16 */
#define UART_FCR0_R_TRIGGER_24  0x80 /* Mask for receive trigger set at 24 */
#define UART_FCR0_R_TRIGGER_28  0xC0 /* Mask for receive trigger set at 28 */
#define UART_FCR0_T_TRIGGER_8   0x10 /* Mask for transmit trigger set at 8 */
#define UART_FCR0_T_TRIGGER_16  0x00 /* Mask for transmit trigger set at 16 */
#define UART_FCR0_T_TRIGGER_24  0x20 /* Mask for transmit trigger set at 24 */
#define UART_FCR0_T_TRIGGER_30  0x30 /* Mask for transmit trigger set at 30 */
/* 16654 redefinitions */
#define UART_FCR4_R_TRIGGER_8   0x00 /* Mask for receive trigger set at 8 */
#define UART_FCR4_R_TRIGGER_16  0x40 /* Mask for receive trigger set at 16 */
#define UART_FCR4_R_TRIGGER_56  0x80 /* Mask for receive trigger set at 56 */
#define UART_FCR4_R_TRIGGER_60  0xC0 /* Mask for receive trigger set at 60 */
#define UART_FCR4_T_TRIGGER_8   0x00 /* Mask for transmit trigger set at 8 */
#define UART_FCR4_T_TRIGGER_16  0x10 /* Mask for transmit trigger set at 16 */
#define UART_FCR4_T_TRIGGER_32  0x20 /* Mask for transmit trigger set at 32 */
#define UART_FCR4_T_TRIGGER_56  0x30 /* Mask for transmit trigger set at 56 */
/* TI 16750 definitions */
#define UART_FCR7_64BYTE        0x20 /* Go into 64 byte mode */

/*
 * These are the definitions for the Line Control Register
 *
 * Note: if the word length is 5 bits (UART_LCR_WLEN5), then setting
 * UART_LCR_STOP will select 1.5 stop bits, not 2 stop bits.
 */
#define UART_LCR_DLAB   0x80    /* Divisor latch access bit */
#define UART_LCR_SBC    0x40    /* Set break control */
#define UART_LCR_SPAR   0x20    /* Mark/Space parity select */
#define UART_LCR_EPAR   0x10    /* Odd/Even parity select */
#define UART_LCR_PARITY 0x08    /* Parity Enable */
#define UART_LCR_STOP   0x04    /* Stop bits: 0=1 stop bit, 1= 2 stop bits */
#define UART_LCR_WLEN5  0x00    /* Wordlength: 5 bits */
#define UART_LCR_WLEN6  0x01    /* Wordlength: 6 bits */
#define UART_LCR_WLEN7  0x02    /* Wordlength: 7 bits */
#define UART_LCR_WLEN8  0x03    /* Wordlength: 8 bits */

/*
 * These are the definitions for the Line Status Register
 */
#define UART_LSR_ERROR  0x80    /* Any error happend */
#define UART_LSR_TEMT   0x40    /* Transmitter empty */
#define UART_LSR_THRE   0x20    /* Transmit-hold-register empty */
#define UART_LSR_BI     0x10    /* Break interrupt indicator */
#define UART_LSR_FE     0x08    /* Frame error indicator */
#define UART_LSR_PE     0x04    /* Parity error indicator */
#define UART_LSR_OE     0x02    /* Overrun error indicator */
#define UART_LSR_DR     0x01    /* Receiver data ready */

/*
 * These are the definitions for the Interrupt Identification Register
 */
#define UART_IIR_NO_INT 0x01    /* No interrupts pending */
#define UART_IIR_ID     0x06    /* Mask for the interrupt ID */

#define UART_IIR_MSI    0x00    /* Modem status interrupt */
#define UART_IIR_THRI   0x02    /* Transmitter holding register empty */
#define UART_IIR_RDI    0x04    /* Receiver data interrupt */
#define UART_IIR_RLSI   0x06    /* Receiver line status interrupt */
#define UART_IIR_XOFF   0x10    /* Xoff interrupt */

/*
 * These are the definitions for the Interrupt Enable Register
 */
#define UART_IER_CTS    0x80    /* Enable Modem CTS interrupt */
#define UART_IER_RTS    0x40    /* Enable Modem RTS interrupt */
#define UART_IER_XOFF   0x20    /* Enable Modem Xoff interrupt */
#define UART_IER_MSI    0x08    /* Enable Modem status interrupt */
#define UART_IER_RLSI   0x04    /* Enable receiver line status interrupt */
#define UART_IER_THRI   0x02    /* Enable Transmitter holding register int. */
#define UART_IER_RDI    0x01    /* Enable receiver data interrupt */
/*
 * Sleep mode for ST16650 and TI16750.
 * Note that for 16650, EFR-bit 4 must be selected as well.
 */
#define UART_IERX_SLEEP  0x10   /* Enable sleep mode */

/*
 * These are the definitions for the Modem Control Register
 */
#define UART_MCR_CLOCK4 0x80    /* Clock division by 4 */
#define UART_MCR_IRDA   0x40    /* IR enable */
#define UART_MCR_IRQ    0x20    /* IRQ select, 16c650 only */
#define UART_MCR_LOOP   0x10    /* Enable loopback test mode */
#define UART_MCR_OUT2   0x08    /* Out2 complement */
#define UART_MCR_OUT1   0x04    /* Out1 complement */
#define UART_MCR_RTS    0x02    /* RTS complement */
#define UART_MCR_DTR    0x01    /* DTR complement */

/*
 * These are the definitions for the Modem Status Register
 */
#define UART_MSR_DCD    0x80    /* Data Carrier Detect */
#define UART_MSR_RI     0x40    /* Ring Indicator */
#define UART_MSR_DSR    0x20    /* Data Set Ready */
#define UART_MSR_CTS    0x10    /* Clear to Send */
#define UART_MSR_DDCD   0x08    /* Delta DCD */
#define UART_MSR_TERI   0x04    /* Trailing edge ring indicator */
#define UART_MSR_DDSR   0x02    /* Delta DSR */
#define UART_MSR_DCTS   0x01    /* Delta CTS */
#define UART_MSR_ANY_DELTA 0x0F /* Any of the delta bits! */

/*
 * These are the definitions for the Extended Features Register
 * (StarTech 16C660 only, when DLAB=1)
 */
#define UART_EFR_CTS    0x80    /* CTS flow control */
#define UART_EFR_RTS    0x40    /* RTS flow control */
#define UART_EFR_SCD    0x20    /* Special character detect */
#define UART_EFR_ECB    0x10    /* Enhanced control bit */
/*
 * the low four bits control software flow control
 */

#endif /* IOBLIX_UART_H */

