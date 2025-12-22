#ifndef	EXT_ASCII_H
#define  EXT_ASCII_H 1
/****************************************************************************

$Source: MASTER:include/ext/ascii.h,v $
$Revision: 2.0 $
$Date: 1994/06/29 14:43:00 $

Macros defining non-printing ASCII character values.

****************************************************************************/

#define ASCII_NUL    0x00
#define ASCII_SOH    0x01
#define ASCII_STX    0x02
#define ASCII_ETX    0x03
#define ASCII_EOT    0x04
#define ASCII_ENQ    0x05
#define ASCII_ACK    0x06
#define ASCII_BEL    0x07
#define ASCII_BS     0x08
#define ASCII_HT     0x09
#define ASCII_LF     0x0A
#define ASCII_VT     0x0B
#define ASCII_FF     0x0C
#define ASCII_CR     0x0D
#define ASCII_SO     0x0E
#define ASCII_SI     0x0F
#define ASCII_DLE    0x10
#define ASCII_DC1    0x11
#define ASCII_DC2    0x12
#define ASCII_DC3    0x13
#define ASCII_DC4    0x14
#define ASCII_NAK    0x15
#define ASCII_SYN    0x16
#define ASCII_ETB    0x17
#define ASCII_CAN    0x18
#define ASCII_EM     0x19
#define ASCII_SUB    0x1A
#define ASCII_ESC    0x1B
#define ASCII_FS     0x1C
#define ASCII_GS     0x1D
#define ASCII_RS     0x1E
#define ASCII_US     0x1F


/* Obsolete. */

#define ENTER         0x0d
#define RETURN        ENTER
#define LF            0x0a
#define NEWLINE       LF
#define ESC           0x1b
#define UP            0x0c

#endif
