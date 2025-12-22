/*
 * Copyright (c) 1996 Tommaso Cucinotta, Alessandro Evangelista, Luigi Rizzo
 * All rights reserved.
 *
 *    Dip. di Ingegneria dell'Informazione, Universita of Pisa,
 *    via Diotisalvi 2 -- 56126 Pisa.
 *    email: simulpic@iet.unipi.it
 * 	
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by
 *	Tommaso Cucinotta, Alessandro Evangelista and Luigi Rizzo
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/***
 *** pictype.h
 ***
 *** contains specific parameters for the pic type
 ***
 ***	This is for the 16c84
 ***/

#ifndef _PICTYPE
#define _PICTYPE

#define	PROGMEM_SIZE	1024
#define	EEPROM_SIZE	64
#define	EEPROM_BASE	0x2100	/* in the hex file... */
#define	ALLMEM_SIZE	(EEPROM_BASE + EEPROM_SIZE)
#define	STACK_SIZE	8

#define NO_MEM_LOADED 0
#define MEM_LOADED 1

#define f_RTCC     0x01
#define f_PCL      0x02
#define f_STATUS   0x03
#define f_FSR      0x04
#define f_PORTA    0x05
#define f_PORTB    0x06
#define f_EEDATA   0x08
#define f_EEADR    0x09
#define f_PCLATH   0x0A
#define f_INTCON   0x0B
#define f_OPTION   0x81
#define f_TRISA    0x85
#define f_TRISB    0x86
#define f_EECON1   0x88
#define f_EECON2   0x89

#define STATUS_IRP 0x07
#define STATUS_RP1 0x06
#define STATUS_RP0 0x05
#define STATUS_TO  0x04
#define STATUS_PD  0x03
#define STATUS_Z   0x02
#define STATUS_DC  0x01
#define STATUS_C   0x00

#define INTCON_GIE 0x07
#define INTCON_EEIE 0x06
#define INTCON_RTIE 0x05
#define INTCON_INTE 0x04
#define INTCON_RBIE 0x03
#define INTCON_RTIF 0x02
#define INTCON_INTF 0x01
#define INTCON_RBIF 0x00

#define OPTION_RBPU   7
#define OPTION_INTEDG 6
#define OPTION_RTS    5
#define OPTION_RTE    4
#define OPTION_PSA    3

#define EECON1_EEIF  4
#define EECON1_WRERR 3
#define EECON1_WREN  2
#define EECON1_WR    1
#define EECON1_RD    0

#define S_MASK_IRP 0x80
#define S_MASK_RP1 0x40
#define S_MASK_RP0 0x20
#define S_MASK_TO  0x10
#define S_MASK_PD  0x08
#define S_MASK_Z   0x04
#define S_MASK_DC  0x02
#define S_MASK_C   0x01

#define I_MASK_GIE 0x80
#define I_MASK_EEIE 0x40
#define I_MASK_RTIE 0x20
#define I_MASK_INTE 0x10
#define I_MASK_RBIE 0x08
#define I_MASK_RTIF 0x04
#define I_MASK_INTF 0x02
#define I_MASK_RBIF 0x01

#define OPT_MASK_RBPU  0x80
#define OPT_MASK_INTEDG  0x40
#define OPT_MASK_RTS  0x20
#define OPT_MASK_RTE  0x10
#define OPT_MASK_PSA  0x08
#define OPT_MASK_PS2  0x04
#define OPT_MASK_PS1  0x02
#define OPT_MASK_PS0  0x01


typedef unsigned char TByte;
typedef unsigned int  TWord;

typedef unsigned char TRegister;        /*  8 bit */
typedef unsigned int  TAbs_Address;     /*  8 bit */
typedef unsigned char TData_Address;    /*  8 bit */
typedef unsigned int  TProgram_Address; /* 13 bit */
typedef unsigned char TEEPROM_Address;  /*  7 bit */
typedef unsigned int  TOp_Code;         /* 14 bit */
typedef unsigned char TBit_Address;     /*  3 bit */
typedef enum { _f , _W } TDestination;

typedef enum { IN_0, IN_1, OUT } TPin_State;

typedef struct {
          TPin_State MCLR, RA[5], RB[8];
        }  TInput_State;

typedef int TBool;   /*  ==0:False;  !=0:True  */
#define FALSE 0
#define TRUE 1

typedef char* TString;

#endif
