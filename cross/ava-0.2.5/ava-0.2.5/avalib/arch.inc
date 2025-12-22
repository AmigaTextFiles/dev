/*
	arch.inc

	AVA Micro-controller (MCU) Declarations

	This file is automatically included to every assembler source
        immediately after first non system definition as: 
	  #arch MCU_NAME

	Uros Platise (c) 1998-1999
	Last update: 7. February 1999

  AVR FAMILY MICRO-CONTROLLERS
  Supported models:
    - AT90S1200
    - AT90S2313
    - AT90S2323
    - AT90S2333
    - AT90S2343
    - AT90S4414
    - AT90S4433
    - AT90S4434
    - AT90S8515
    - AT90S8535
    - ATmega603
    - ATmega103
*/

/*
  Current Version
  Produce error if arch versions do not much cross object files.
*/
#define public __AVA_ARCH_VER	5

#if AT90S1200
device AVR 1
#define __ERAM_SIZE 0				/* no memory no option */
seg abstract abs=0 size=__ERAM_SIZE eram
seg abs=0 size=64 eeprom
seg abs=0 size=1024 align=2 flash		/* the last is default segment! */
#endif

#if AT90S2313 | AT90S2323 | AT90S2333 | AT90S2343
device AVR 2
#ifndef __ERAM_SIZE
#define __ERAM_SIZE 224		/* 128 of sram + 96 of i/o mapped */
#endif
#define __AVR_IOMAP
seg abstract abs=0 size=__ERAM_SIZE eram
seg abs=0 size=128 eeprom
seg abs=0 size=2048 align=2 flash
#endif

#if AT90S4414 | AT90S4434
#ifndef __ERAM_SIZE
#define __ERAM_SIZE 0x160	/* defaults to internal memory size */
#endif
#define __AVR_IOMAP
device AVR 2
seg abstract abs=0  size=__ERAM_SIZE eram
seg abs=0 size=256 eeprom
seg abs=0 size=4096 align=2 flash
#endif

#if AT90S4433
#ifndef __ERAM_SIZE
#define __ERAM_SIZE 224
#endif
#define __AVR_IOMAP
device AVR 2
seg abstract abs=0  size=__ERAM_SIZE eram
seg abs=0 size=256 eeprom
seg abs=0 size=4096 align=2 flash
#endif

#if AT90S8515 | AT90S8535
#define public  __AVR_WRAP_AROUND
#ifndef __ERAM_SIZE
#define __ERAM_SIZE 0x260
#endif
#define __AVR_IOMAP
device AVR 2
seg abstract abs=0 size=__ERAM_SIZE eram
seg abs=0 size=512 eeprom
seg abs=0 size=8192 align=2 flash
#endif

/* AVR MEGA FAMILY 64kb and 128kb FLASH */

#if ATmega603
#ifndef __ERAM_SIZE
#define __ERAM_SIZE 0x1060
#endif
#define __AVR_IOMAP
device AVR 3
seg abstract abs=0  size=__ERAM_SIZE eram
seg abs=0 size=2048 eeprom
seg abs=0 size=0x10000 align=2 flash
#endif

#if ATmega103
#ifndef __ERAM_SIZE
#define __ERAM_SIZE 0x1060
#endif
#define __AVR_IOMAP
device AVR 3
seg abstract abs=0 size=__ERAM_SIZE eram
seg abs=0 size=4096 eeprom
seg abs=0 size=0x20000 align=2 flash
#endif

/* 
	AVR Standard Memory Mapped Registers
*/
#ifdef __AVR_IOMAP
seg abs=0  size=32 eram.registers
seg abs=32 size=64 eram.io_space
seg flash		/* set default segment */
#endif

#ifdef __ERAM_SIZE
#ifndef __ERAM_END	/* if end of ram is not explicitly defined */
#define __ERAM_END	(__ERAM_SIZE - 1)
#endif
#endif

/* end of arch.inc */
