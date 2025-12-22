/*
	avr.inc

	version 0.2.1
			
	AVR Declarations of the I/O Registers
	Reference: AVR Enhanced RISC Micro-controller Databook 1997-1999
	
	Uros Platise (c) 1997-1999

	-------	
	This file was entirely rearranged and updated on 24. January 1999.
	Last update: 14.2.1999
*/

#ifndef __AVR_INC
#define __AVR_INC

/* 
  Common Macros
  -------------
*/

/* Calculate Flash Address from the label */
#define FADDR(x) 	(x>>1)

/* Define Constant from label */
#define DC_ADDR(x)	dc.w FADDR(x)

/* Calculate bit value from bit number! */
#define BV(x)	(1<<x)

/* Calculate Address of the Memory Mapped I/O Registers */
#if __ERAM_SIZE > 0
#define mmio(x)	((x)+0x20)
#endif

/* Exclude lower/higher eight bits */
#define low(x)  ((x)&0xff)
#define high(x) (((x)>>8)&0xff)

/* Exclude lower/higher eight bits from the FLASH address */
#define flow(x)  (FADDR(x)&0xff)
#define fhigh(x) ((FADDR(x)>>8)&0xff)



/*
  Device Peripheral Selection
  ---------------------------
  The following statements declares peripheral sections to be
  included according to the specifed device.
*/

#ifdef AT90S1200
#include "avr/1200def.inc"
#endif

#ifdef AT90S2313
#include "avr/2313def.inc"
#endif

#ifdef AT90S2323
#include "avr/2323def.inc"
#endif

#ifdef AT90S2333
#include "avr/2333def.inc"
#endif

#ifdef AT90S2343
#include "avr/2343def.inc"
#endif

#ifdef AT90S4414
#include "avr/4414def.inc"
#endif

#ifdef AT90S4433
#include "avr/4433def.inc"
#endif

#ifdef AT90S4434
#include "avr/4414def.inc"
#endif

#ifdef AT90S8515
#include "avr/8515def.inc"
#endif

#ifdef AT90S8535
#include "avr/8535def.inc"
#endif

#ifdef ATmega103
#include "avr/M103def.inc"
#endif

#ifdef ATmega603
#include "avr/M603def.inc"
#endif


/*
  Peripheral Additional Macros
  ----------------------------
*/

/* SM Abbreviations */
#define SM_POWERDOWN	SM
#define SM_IDLE		0
#define SM_SAVE		(BV(SM0)+BV(SM1))

/* Watchdog Prescaler Shortcuts WDPx; x [miliseconds] */
#define WDP16	0
#define WDP32	BV(WDP0)
#define WDP64	BV(WDP1)
#define WDP128	(BV(WDP1)+BV(WDP0))
#define WDP256	BV(WDP2)
#define WDP512	(BV(WDP2)+BV(WDP0))
#define WDP1024	(BV(WDP2)+BV(WDP1))
#define WDP2048	(BV(WDP2)+BV(WDP1)+BV(WDP0))

/* 8 bit Counter/Timer Prescaler Values */
#define TMC8_STOP	0
#define TMC8_CK		BV(CS00)
#define TMC8_CK8	BV(CS01)
#define TMC8_CK64	(BV(CS00)+BV(CS01))
#define TMC8_CK256	BV(CS02)
#define TMC8_CK1024	(BV(CS02)+BV(CS00))
#define TMC8_EXTFAL	(BV(CS02)+BV(CS01))
#define TMC8_EXTRIS	(BV(CS02)+BV(CS01)+BV(CS00))

/* 16 bit Timer Counter Prescaler Values */
#define TMC16_STOP	0
#define TMC16_CK	BV(CS10)
#define TMC16_CK8	BV(CS11)
#define TMC16_CK64	(BV(CS10)+BV(CS11))
#define TMC16_CK256	BV(CS12)
#define TMC16_CK1024	(BV(CS12)+BV(CS10))
#define TMC16_EXTFAL	(BV(CS12)+BV(CS11))
#define TMC16_EXTRIS	(BV(CS12)+BV(CS11)+BV(CS10))

/* SPI Prescaler Values at SYS_CLK = 8.000 MHz */
#define SPI_CK4		0			/*    2 Mbit */
#define SPI_CK16	BV(SPR0)		/*  500 kbit */
#define SPI_CK64	BV(SPR1)		/*  125 kbit */
#define SPI_CK128	(BV(SPR1)+BV(SPR0))	/* 62.5 kbit */

/* UART Baudrate Expression
   fclk - system clock
   baudrate - as 1200, 2400, 9600, ... 
*/
#define UART_UBBR(fclk,baudrate)	((fclk/(16*baudrate))-1)

#endif
/* eof: avr.inc */

