/*==============================================================================
 *
 *          	 S O F T W A R E   S O U R C E   F I L E
 *
 *             (c) Agfa-Gevaert N.V.  Edegem Belgium  1988
 *
 *******************************************************************************
 *
 *    Name of File  : M O N D I S . C
 *    State/Version : V 1.0
 *
 *******************************************************************************
 *
 *    Project				:	ANTRAX
 *    Author				:	Andre Pelckmans
 *    Creation Date	:		21-NOV-1989 
 *    Description		:	Disassembler for the 680x0 serie
 *
================================================================================
 *  Version  |     Date     |    Author    |  Description
 *______________________________________________________________________________
 *   0.00    | 21-NOV-1989  | A. Pelckmans |  Creation of file
 *   0.00    | 23-AUG-1990  | A. Pelckmans |  Added 68040 CPUSH instructions
 *   1.00    | 19-AUG-1992  | J. Tyberghein|  Several additions for PowerVisor
 *           |              |              |  Optimization of cmd_size (macro)
 *           | 30-AUG-1992  |              |  Bug fixed in FMOVE.x #imm,FPx
==============================================================================*/

/* Part of PowerVisor   Copyright © 1992   Andre Pelckmans, Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH
 */


#ifdef __GNUC__
#	define SDS
#	define REG
#endif

#ifdef LATTICE
#	define SDS __saveds
#	define REG __regargs
#endif

#define then
#define TRUE	 1
#define FALSE	 0
#define UBYTE	 unsigned char
#define UWORD	 unsigned short
#define ULONG	 unsigned int

/*===========================================================================*
digits in name of table :
  if not in following table then print it
    a : append "AL"
    b : append ".B"
    c : condition code for branch, bit 11..8 of op1 (CC,GE,...)
    d : bit 8 of opcode2: 0="FD" 1=""
    f : FPU mnemonics
    g : bit 10..9 : 0="AS"   1="LS"   2="ROX"  3="RO"
    h : bit  4..3 : 0="AS"   1="LS"   2="ROX"  3="RO"
    l : append ".L"
    m : sigen or unsigned for MUL & DIV
    o : append "ORE"
    p : append "cp"
    q : FPU size .B .W .L .S .D .X .P
    r : bit  8    : 0="R"    1="L 
    s : bit  7..6 : 0=".B"   1=".W"   2=".L"   3=".?"
    t : bit  6    : 0=".W"   1=".L"
    u : bit  8    : 0=".W"   1=".L"
    v : condition code for FPU branch: bit 5..0 of opcode 1 or 2
    w : append ".W"
    x : append ".X"
    y : bit 9 of opcode2: 0="W"  1="R"
    z : op2_bit11 : 0="CMP2" 1="CHK2"
   null : stop
 *===========================================================================*/
/*==========================*
   enum's for operand types  
 *==========================*/

enum codes			/*							|												|	 argument	word2				*/
  {/*---------------------------------------------------------------------------------------------*/
    nop = 1,
    D12,				/* Dq						*												*  .qqq.... ........							*/
    D9,					/* Dx						*												*  ....xxx. ........							*/
    D4,					/* Dy						*												*  ........ .yyy....							*/
    D0,					/* Dy						*												*  ........ .....yyy							*/
    A9,					/* Ax						*												*  ....xxx. ........							*/
    A0,					/* Ay						*												*  ........ .....yyy							*/
    R0,					/* D0						*												*  ........ ....0nnn							*/
								/* A0						*												*  ........ ....1nnn							*/
    R12,				/* Dn						*												*  0nnn.... ........							*/
								/* A12					*												*  1nnn.... ........							*/
    D0D9,				/* Dy,Dx				*												*  ....xxx. .....yyy							*/
    ixA0,				/* (Ay)					*												*  ........ .....yyy							*/
    ixmA9,			/* -(Ax)				*												*  ....xxx. ........							*/
    ixmA0,			/* -(Ay)				*												*  ........ .....yyy							*/
    ixpA12,			/* (Ax)+				*												*  .xxx.... ........							*/
    ixpA9,			/* (Ax)+				*												*  ....xxx. ........							*/
    ixpA0,			/* (Ay)+				*												*  ........ .....yyy							*/
    ixwA0,			/* (w,Ay)				*												*  ........ .....yyy + word				*/
    ixmA0A9,		/* -(Ay),-(Ax)	*												*  ....xxx. .....yyy							*/
    fp0,				/* FPn					*												*  ........ ........ + ........ .....nnn	*/
    fp7,				/* FPn					*												*  ........ ........ + ......nn n.......	*/
    fp10,				/* FPn					*												*  ........ ........ + ...nnn.. ........	*/
    fp0fp7,			/* FPn					*												*  ........ ........ + ......nn n....nnn	*/
    eaow,				/* ea{o:w}			*												*  ........ ..mmmrrr + 0000dooo oodwwwww	*/
    eafk,				/* ea{#k}				*												*  									 + ........ .kkkkkkk	*/
    eafd,				/* ea{dn}				*												*  									 + ........ .rrr0000	*/
    datass,			/* #data				* ss 										*  ........ ss......							*/
								/*									00 : byte						*  ........ ........ + ........ dddddddd	*/
								/*									01 : word						*  ........ ........ + word				*/
								/*									10 : long						*  ........ ........ + long				*/
    data9_3,		/* #data				*												*  ....ddd. ........							*/
    data0_3, 		/* #data				*												*  ........ .....ddd							*/
    data0_4,		/* #data				*												*  ........ ....dddd							*/
    data0_8,		/* #data				*												*  ........ dddddddd							*/
    dataw,			/* #data				*												*  ........ ........ + word				*/
    datal,	 		/* #data				*												*  ........ ........ + long				*/
    usp,				/* USP					*												*																	*/
    ccr,				/* CCR					*												*																	*/
    sr,					/* SR						*												*																	*/
    ccrsr,			/* CCR					*												*  ........ .0......							*/
								/* SR						*												*  ........ .1......							*/
    div,				/* divide				*												*																	*/
    mul,mul1,mul2,/* multiply		*												*																	*/
    reglist,		/* register list*												*																	*/
    FPlist,			/* register list FPU data 							*																	*/
    FClist,			/* register list FPU control						*																	*/
    disp,				/* label=pc+disp* 			1  bit 7..0			*																	*/
								/*											$00 : next word	*  ........ 00000000 + dddddddd ddddddd		*/
								/*											$FF : next long	*  ........ 11111111 + dddddddd ddddddd +	*/
								/*											else : byte			*  ........ dddddddd											*/
    datarom,		/* #ROMdata			*												*  ........ ........											*/
    dispw,			/* label=pc+word*												*  ........ ........ + wwwwwwww wwwwwww		*/
    displ,			/* label=pc+long*												*  ........ ........ + wwwwwwww wwwwwww		*/
    offwid,			/* {off:wid}		* 											*  ........ ........ + ........ ..tnnnnn	*/
    moves,
    cas1,
    cas2,
    op2_Rc,			/* 							*	    11..0							*  ........ ........ + ....c000 00000ccc	*/
								/* SFC					*	    $000							*																	*/
								/* DFC					*	    $001							*																	*/
								/* CACR					*	    $002							*																	*/
								/* TC						*	    $003							*																	*/
								/* ITT0					*	    $004							*																	*/
								/* ITT1					*	    $005							*																	*/
								/* DTT0					*	    $006							*																	*/
								/* DTT1					*	    $007							*																	*/
								/* USP					*	    $800							*																	*/
								/* VBR					*	    $801							*																	*/
								/* CAAR					*	    $802							*																	*/
								/* MSP					*	    $803							*																	*/
								/* ISP					*	    $804							*																	*/
								/* MMUSR				*	    $805							*																	*/
								/* URP					*	    $806							*																	*/
								/* SRP					*	    $807							*																	*/
    ea11_6,			/* ea						* ea =	1   11..6				*  ....rrrm mm......							*/
    ea,					/* ea						* ea =	1    5..0				*  ........ ..mmmrrr							*/
    arith,			/* arithmetic   *												*  ........ ........ + 0m0sssdd dfffffff	*/
    indA0,			/* ea ind(An)		mode = 110 nnn	= ea+7	*																	*/
    ixword,			/* ea (word)		mode = 111 000	= ea+8	*																	*/
    ixlong,			/* ea (long)		mode = 111 001	= ea+9	*																	*/
    ixwPC,			/* ea (w,PC)		mode = 111 010	= ea+10	*																	*/
    indPC,			/* ea ind(PC)		mode = 111 011	= ea+11	*																	*/
    inv,				/*							mode = 111 101	= ea+13	*																	*/
    fc,fcea,fcmask,mmulist,level,
    lab_a,lab_b,lab_c,lab_d,lab_f,lab_g,lab_h,lab_l,lab_m,lab_o,
    lab_p,lab_q,lab_r,lab_s,lab_t,lab_u,lab_v,lab_w,lab_x,lab_y,lab_z,
    doind,pword	/* labels			*/
  };
/*======================================================*
 | Table with opcodes, names and operand types					|
 *======================================================*/

struct OPCODES
	{
		UWORD opcode;			/* opcode					*/
		UWORD mask;				/* mask						*/
		char  name[6];		/* mnemonic name	*/
		UBYTE code1;			/* code 1					*/
		UBYTE code2;			/* code 2					*/
	};

#define C1 (enum codes)
#define C2 0x80 + (UBYTE)(enum codes)

struct OPCODES *pt,tabdis[] =
{
	{ 0x003C,0xFFBF, "ORI",   C1 dataw,		C1 ccrsr	},/* 00000000 0c111100 + W	   	: #data,CcrSr		*/
	{ 0x0000,0xFF00, "ORIs",  C1 datass,	C1 ea			},/* 00000000 sseeeeee + W	   	: #data,ea			*/
	{ 0x023C,0xFFBF, "ANDI",  C1 dataw,		C1 ccrsr	},/* 00000010 0c111100 + W	   	: #word,CcrSr		*/
	{ 0x0200,0xFF00, "ANDIs", C1 datass,	C1 ea			},/* 00000010 sseeeeee + data  	: #data,ea			*/
	{ 0x0400,0xFF00, "SUBIs", C1 datass,	C1 ea			},/* 00000100 sseeeeee + data  	: #data,ea			*/
	{ 0x06C0,0xFFF0, "RTM",   C1 R0,			C1 nop		},/* 00000110 1100dyyy	   			: Ry						*/
	{ 0x06C0,0xFFC0, "CALLM", C1 dataw,		C1 ea			},/* 00000110 11eeeeee + W	   	: #data,ea			*/
	{ 0x0600,0xFF00, "ADDIs", C1 datass,	C1 ea			},/* 00000110 sseeeeee + data   : #data,ea			*/
	{ 0x0800,0xFFC0, "BTST",  C1 dataw,		C1 ea			},/* 00001000 00eeeeee + W	   	: #data,ea			*/
	{ 0x0840,0xFFC0, "BCHG",  C1 dataw,		C1 ea			},/* 00001000 01eeeeee + W	   	: #data,ea			*/
	{ 0x0880,0xFFC0, "BCLR",  C1 dataw,		C1 ea			},/* 00001000 10eeeeee + W	   	: #data,ea			*/
	{ 0x08C0,0xFFC0, "BSET",  C1 dataw,		C1 ea			},/* 00001000 11eeeeee + W	   	: #data,ea			*/
	{ 0x00C0,0xF9C0, "z2",    C1 ea,			C2 R12		},/* 00000ss0 11eeeeee + op     : ea,Rn					*/
	{ 0x08FC,0xF9FF, "CAS2",  C2 cas2,		C1 nop		},/* 00001ss0 11111100 + op + op: Dc1:Dc2,Dc2..	*/
	{ 0x08C0,0xF9C0, "CAS",   C2 cas1,		C1 ea			},/* 00001ss0 11eeeeee + op	   	: Dc,Du,ea			*/
	{ 0x0A3C,0xFFBF, "EORI",  C1 dataw,		C1 ccrsr	},/* 00001010 0c111100 + W	   	: #word,CcrSR		*/
	{ 0x0A00,0xFF00, "EORIs", C1 datass,	C1 ea			},/* 00001010 sseeeeee + data   : #data,ea			*/
	{ 0x0C00,0xFF00, "CMPIs", C1 datass,	C1 ea			},/* 00001100 sseeeeee + data   : #data,ea			*/
	{ 0x0E00,0xFF00, "MOVESs",C2 moves,		C1 nop		},/* 00001110 sseeeeee + op	   	: Rn,ea					*/
	{ 0x0108,0xF1B8, "MOVEPt",C1 ixwA0,		C1 D9			},/* 0000xxx1 0t001yyy + W	   	: (word,Ay),Dx	*/
	{ 0x0188,0xF1B8, "MOVEPt",C1 D9,			C1 ixwA0	},/* 0000xxx1 1t001yyy   				: Dx,(word,Ay)	*/
	{ 0x0100,0xF1C0, "BTST",  C1 D9,			C1 ea			},/* 0000xxx1 00eeeeee 	   			: Dx,ea					*/
	{ 0x0140,0xF1C0, "BCHG",  C1 D9,			C1 ea			},/* 0000xxx1 01eeeeee	   			: Dx,ea					*/
	{ 0x0180,0xF1C0, "BCLR",  C1 D9,			C1 ea			},/* 0000xxx1 10eeeeee 	   			: Dx,ea					*/
	{ 0x01C0,0xF1C0, "BSET",  C1 D9,			C1 ea			},/* 0000xxx1 11eeeeee 	   			: Dx,ea					*/

	{ 0x1000,0xF000, "MOVEb", C1 ea, 			C1 ea11_6	},/* 0001eeee eeeeeeee	   			: ea,ea					*/
	{ 0x2040,0xF1C0, "MOVEAl",C1 ea, 			C1 A9			},/* 0010xxx0 01eeeeee	   			: ea,Ax					*/
	{ 0x2000,0xF000, "MOVEl", C1 ea, 			C1 ea11_6	},/* 0010eeee eeeeeeee	   			: ea,ea					*/
	{ 0x3040,0xF1C0, "MOVEAw",C1 ea, 			C1 A9			},/* 0011xxx0 01eeeeee	   			: ea,Ax					*/
	{ 0x3000,0xF000, "MOVEw", C1 ea, 			C1 ea11_6	},/* 0011eeee eeeeeeee	   			: ea,ea					*/

	{ 0x40C0,0xFFC0, "MOVEw", C1 sr, 			C1 ea			},/* 01000000 11eeeeee	   			: SR,ea					*/
	{ 0x4000,0xFF00, "NEGXs", C1 ea,  		C1 nop		},/* 01000000 sseeeeee	   			: ea						*/
	{ 0x42C0,0xFFC0, "MOVEw", C1 ccr, 		C1 ea			},/* 01000010 11eeeeee	   			: CCR,ea				*/
	{ 0x4200,0xFF00, "CLRs",  C1 ea,  		C1 nop	  },/* 01000010 sseeeeee	   			: ea						*/
	{ 0x44C0,0xFFC0, "MOVEw", C1 ea,			C1 ccr	  },/* 01000100 11eeeeee	   			: ea,CCR				*/
	{ 0x4400,0xFF00, "NEGs",  C1 ea,  		C1 nop	  },/* 01000100 sseeeeee	   			: ea						*/
	{ 0x46C0,0xFFC0, "MOVEw", C1 ea, 			C1 sr			},/* 01000110 11eeeeee	   			: ea,SR					*/
	{ 0x4600,0xFF00, "NOTs",  C1 ea,  		C1 nop	  },/* 01000110 sseeeeee	   			: ea						*/
	{ 0x4808,0xFFF8, "LINKl", C1 A0,   		C1 datal  },/* 01001000 00001yyy + L	   	: Ay,#disp			*/
	{ 0x4840,0xFFF8, "SWAP.W",C1 D0,  		C1 nop	  },/* 01001000 01000yyy	   			: Dy						*/
	{ 0x4848,0xFFF8, "BKPT",  C1 data0_3,	C1 nop	  },/* 01001000 01001yyy	   			: #data					*/
	{ 0x4800,0xFFC0, "NBCD.B",C1 ea, 			C1 nop	  },/* 01001000 00eeeeee	   			: ea						*/
	{ 0x4840,0xFFC0, "PEA",   C1 ea,  		C1 nop	  },/* 01001000 01eeeeee	   			: ea						*/
	{ 0x4880,0xFFB8, "EXTt",  C1 D0,  		C1 nop	  },/* 01001000 1t000yyy	   			: Dy						*/
	{ 0x4880,0xFF80, "MOVEMt",C2 reglist,	C1 ea			},/* 01001000 1teeeeee + op	   	: reglist,ea		*/
	{ 0x4AFC,0xFFFF, "ILLEGa",C1 nop,			C1 nop	  },/* 01001010 11111100	   			: /							*/
	{ 0x4AC0,0xFFC0, "TAS.B", C1 ea,  		C1 nop	  },/* 01001010 11eeeeee	   			: ea						*/
	{ 0x4A00,0xFF00, "TSTs",  C1 ea,  		C1 nop	  },/* 01001010 sseeeeee	   			: ea						*/
	{ 0x4C00,0xFFC0, "MULml", C1 ea, 			C2 mul	  },/* 01001100 00eeeeee + op	   	: ea,Dl					*/
	{ 0x4C40,0xFFC0, "DIVml", C1 ea, 			C2 div	  },/* 01001100 01eeeeee + op	   	: ea,Dq					*/
	{ 0x4C80,0xFF80, "MOVEMt",C1 ea, 			C2 reglist},/* 01001100 1teeeeee + op	   	: ea,reglist		*/
/* { 0x4E4F,0xFFFF, "SYSCaL",C1 dataw,	C1 nop	  },   01001110 01001111 + W	   	: #data					*/
	{ 0x4E40,0xFFF0, "TRAP",  C1 data0_4,	C1 nop	  },/* 01001110 0100dddd	   			: #data					*/
	{ 0x4E50,0xFFF8, "LINK.W",C1 A0, 			C1 dataw  },/* 01001110 01010yyy + W	   	: Ay,#disp			*/
	{ 0x4E58,0xFFF8, "UNLK",  C1 A0,  		C1 nop	  },/* 01001110 01011yyy	   			: Ay						*/
	{ 0x4E60,0xFFF8, "MOVE.L",C1 A0, 			C1 usp	  },/* 01001110 01100yyy	   			: Ay,USP				*/
	{ 0x4E68,0xFFF8, "MOVE.L",C1 usp,			C1 A0			},/* 01001110 01101yyy	   			: USP,Ay				*/
	{ 0x4E70,0xFFFF, "RESET", C1 nop,			C1 nop	  },/* 01001110 01110000	   			: /							*/
	{ 0x4E71,0xFFFF, "NOP",   C1 nop,			C1 nop	  },/* 01001110 01110001	   			: /							*/
	{ 0x4E72,0xFFFF, "STOP",  C1 dataw,		C1 nop	  },/* 01001110 01110010 + W	   	: #data					*/
	{ 0x4E73,0xFFFF, "RTE",   C1 nop,			C1 nop 	  },/* 01001110 01110011	  			: /							*/
	{ 0x4E74,0xFFFF, "RTD",   C1 dataw,		C1 nop	  },/* 01001110 01110100 + W	   	: #word					*/
	{ 0x4E75,0xFFFF, "RTS",   C1 nop,			C1 nop	  },/* 01001110 01110101	   			: /							*/
	{ 0x4E76,0xFFFF, "TRAPV", C1 nop,			C1 nop	  },/* 01001110 01110110	   			: /							*/
	{ 0x4E77,0xFFFF, "RTR",   C1 nop,			C1 nop	  },/* 01001110 01110111	   			: /							*/
	{ 0x4E7A,0xFFFF, "MOVEC", C2 op2_Rc,	C2 R12    },/* 01001110 01111010 + op	  	: Rc,Rn					*/
	{ 0x4E7B,0xFFFF, "MOVEC", C2 R12, 		C2 op2_Rc },/* 01001110 01111011 + op	  	: Rn,Rc					*/
	{ 0x4E80,0xFFC0, "JSR",   C1 ea,			C1 nop	  },/* 01001110 10eeeeee	   			: ea						*/
	{ 0x4EC0,0xFFC0, "JMP",   C1 ea,			C1 nop	  },/* 01001110 11eeeeee	   			: ea						*/
	{ 0x49C0,0xFFF8, "EXTBl", C1 D0,			C1 nop	  },/* 01001001 11000yyy	   			: Dy						*/
	{ 0x4100,0xF1C0, "CHKl",  C1 ea, 			C1 D9			},/* 0100xxx1 00eeeeee	   			: ea,Dx					*/
	{ 0x4180,0xF1C0, "CHKw",  C1 ea, 			C1 D9			},/* 0100xxx1 10eeeeee	   			: ea,Dx					*/
	{ 0x41C0,0xF1C0, "LEA",   C1 ea, 			C1 A9			},/* 0100xxx1 11eeeeee	   			: ea,Ax					*/

	{ 0x50FC,0xF0FF, "TRAPc", C1 nop,			C1 nop	  },/* 0101cccc 11111100 	   			: /							*/
	{ 0x50FA,0xF0FF, "TRAPcw",C1 dataw,		C1 nop	  },/* 0101cccc 11111010 + W	   	: #data					*/
	{ 0x50FB,0xF0FF, "TRAPcl",C1 datal,		C1 nop	  },/* 0101cccc 11111011 + L	   	: #data					*/
	{ 0x50C8,0xF0F8, "DBc",   C1 D0,			C1 dispw  },/* 0101cccc 11001yyy + W	   	: DBcc Dy,label	*/
	{ 0x50C0,0xF0C0, "Sc.B",  C1 ea,			C1 nop	  },/* 0101cccc 11eeeeee	   			: ea						*/
	{ 0x5000,0xF100, "ADDQs", C1 data9_3,	C1 ea	  	},/* 0101xxx0 sseeeeee	   			: #data,ea			*/
	{ 0x5100,0xF100, "SUBQs", C1 data9_3,	C1 ea	  	},/* 0101xxx1 sseeeeee	   			: #data,ea			*/

	{ 0x6000,0xFF00, "BRA",   C1 disp,		C1 nop	  },/* 01100000 dddddddd + disp   : disp					*/
	{ 0x6100,0xFF00, "BSR",   C1 disp,		C1 nop	  },/* 01100001 dddddddd + disp   : disp					*/
	{ 0x6000,0xF000, "Bc",    C1 disp,		C1 nop	  },/* 0110cccc dddddddd + disp   : cc disp				*/

	{ 0x7000,0xF100, "MOVEQl",C1 data0_8,	C1 D9	  	},/* 0111xxx0 dddddddd	   			: #data,Dx			*/

	{ 0x80C0,0xF1C0, "DIVUw", C1 ea, 			C1 D9	  	},/* 1000xxx0 11eeeeee	   			: ea,Dx					*/
	{ 0x8000,0xF100, "ORs",   C1 ea, 			C1 D9	  	},/* 1000xxx0 sseeeeee	   			: ea,Dx					*/
	{ 0x8100,0xF1F8, "SBCD.B",C1 D0, 			C1 D9	  	},/* 1000xxx1 00000yyy	   			: Dy,Dx					*/
	{ 0x8108,0xF1F8, "SBCD.B",C1 ixmA0,		C1 ixmA9  },/* 1000xxx1 00001yyy	   			:-(Ay),-(Ax)		*/
	{ 0x8140,0xF1F8, "PACK",  C1 D0D9,		C1 dataw  },/* 1000xxx1 01000yyy + W	   	: Dy,Dx,#adj		*/
	{ 0x8148,0xF1F8, "PACK",  C1 ixmA0A9,	C1 dataw  },/* 1000xxx1 01001yyy + W	   	:-(Ay),-(ax),#a	*/
	{ 0x8180,0xF1F8, "UNPK",  C1 D0D9,		C1 dataw  },/* 1000xxx1 10000yyy + W	   	: Dy,Dx,#adj		*/
	{ 0x8188,0xF1F8, "UNPK",  C1 ixmA0A9,	C1 dataw  },/* 1000xxx1 10001yyy + W	   	:-(Ay),-(Ax),#a	*/
	{ 0x81C0,0xF1C0, "DIVSw", C1 ea, 			C1 D9	  	},/* 1000xxx1 11eeeeee	   			: ea,Dx					*/
	{ 0x8100,0xF100, "ORs",   C1 D9, 			C1 ea	  	},/* 1000xxx1 sseeeeee	   			: ea,Dx					*/

	{ 0x90C0,0xF0C0, "SUBAu", C1 ea, 			C1 A9	  	},/* 1001xxxu 11eeeeee	   			: ea,Ax					*/
	{ 0x9100,0xF138, "SUBXs", C1 D0, 			C1 D9	  	},/* 1001xxx1 ss000yyy	   			: Dy,Dx					*/
	{ 0x9108,0xF138, "SUBXs", C1 ixmA0,		C1 ixmA9  },/* 1001xxx1 ss001yyy	   			: -(Ay),-(Ax)		*/
	{ 0x9000,0xF100, "SUBs",  C1 ea, 			C1 D9	  	},/* 1001xxx0 sseeeeee	   			: ea,Dx					*/
	{ 0x9100,0xF100, "SUBs",  C1 D9, 			C1 ea	  	},/* 1001xxx1 sseeeeee	   			: Dx,ea					*/

	{ 0xB0C0,0xF0C0, "CMPAu", C1 ea, 			C1 A9	  	},/* 1011xxxu 11eeeeee	   			: ea,Ax					*/
	{ 0xB000,0xF100, "CMPs",  C1 ea, 			C1 D9	  	},/* 1011xxx0 sseeeeee	   			: ea,Dx					*/
	{ 0xB108,0xF138, "CMPMs", C1 ixpA0,		C1 ixpA9  },/* 1011xxx1 ss001yyy	   			: (Ay)+,(Ax)+		*/
	{ 0xB100,0xF100, "EORs",  C1 D9, 			C1 ea	  	},/* 1011xxx1 sseeeeee	   			: Dx,ea					*/

	{ 0xC0C0,0xF1C0, "MULUw", C1 ea, 			C1 D9	  	},/* 1100xxx0 11eeeeee	   			: ea,Dx					*/
	{ 0xC000,0xF100, "ANDs",  C1 ea, 			C1 D9	  	},/* 1100xxx0 sseeeeee	   			: ea,Dx					*/
	{ 0xC100,0xF1F8, "ABCD.B",C1 D0, 			C1 D9	  	},/* 1100xxx1 00000yyy	   			: Dy,Dx					*/
	{ 0xC108,0xF1F8, "ABCD.B",C1 ixmA0,		C1 ixmA9  },/* 1100xxx1 00001yyy	   			: -(Ay),-(Ax)		*/
	{ 0xC140,0xF1F8, "EXG",   C1 D9, 			C1 D0	  	},/* 1100xxx1 01000yyy	   			: Dx,Dy					*/
	{ 0xC148,0xF1F8, "EXG",   C1 A9, 			C1 A0	  	},/* 1100xxx1 01001yyy	   			: Ax,Ay					*/
	{ 0xC188,0xF1F8, "EXG",   C1 D9,   		C1 A0	  	},/* 1100xxx1 10001yyy	   			: Dx,Ay					*/
	{ 0xC1C0,0xF1C0, "MULSw", C1 ea, 			C1 D9	  	},/* 1100xxx1 11eeeeee	   			: ea,Dx					*/
	{ 0xC100,0xF100, "ANDs",  C1 D9, 			C1 ea	  	},/* 1100xxx1 sseeeeee	   			: Dx,ea					*/

	{ 0xD0C0,0xF0C0, "ADDAu", C1 ea, 			C1 A9	  	},/* 1101xxxu 11eeeeee	   			: ea,Ax					*/
	{ 0xD000,0xF100, "ADDs",  C1 ea, 			C1 D9	  	},/* 1101xxx0 sseeeeee	   			: ea,Dx					*/
	{ 0xD100,0xF138, "ADDXs", C1 D0, 			C1 D9	  	},/* 1101xxx1 ss000yyy	   			: Dy,Dx					*/
	{ 0xD108,0xF138, "ADDXs", C1 ixmA0,		C1 ixmA9  },/* 1101xxx1 ss001yyy	   			: -(Ay),-(Ax)		*/
	{ 0xD100,0xF100, "ADDs",  C1 D9, 			C1 ea	  	},/* 1101xxx1 sseeeeee	   			: Dx,ea					*/

	{ 0xE8C0,0xFFC0, "BFTST", C2 eaow,		C1 nop	  },/* 11101000 11eeeeee + op	   	:ea{ofs:wid}		*/
	{ 0xE9C0,0xFFC0, "BFEXTU",C2 eaow,		C2 D12    },/* 11101001 11eeeeee + op	   	:ea{ofs:wid},Dn	*/
	{ 0xEAC0,0xFFC0, "BFCHG", C2 eaow,		C1 nop	  },/* 11101010 11eeeeee + op	   	:ea{ofs:wid}		*/
	{ 0xEBC0,0xFFC0, "BFEXTS",C2 eaow,		C2 D12    },/* 11101011 11eeeeee + op	   	:ea{ofs:wid},Dn	*/
	{ 0xECC0,0xFFC0, "BFCLR", C2 eaow,		C1 nop	  },/* 11101100 11eeeeee + op	   	:ea{ofs:wid}		*/
	{ 0xEDC0,0xFFC0, "BFFFO", C2 eaow,		C2 D12    },/* 11101101 11eeeeee + op	   	:ea{ofs:wid},Dn	*/
	{ 0xEEC0,0xFFC0, "BFSET", C2 eaow,		C1 nop	  },/* 11101110 11eeeeee + op	   	:ea{ofs:wid}		*/
	{ 0xEFC0,0xFFC0, "BFINS", C2 D12, 		C1 eaow	  },/* 11101111 11eeeeee + op	   	:Dn,ea{ofs:wid}	*/
	{ 0xE0C0,0xF8C0, "grw",   C1 ea, 			C1 nop	  },/* 11100hhr 11eeeeee	   			: ea						*/
	{ 0xE000,0xF020, "hrs",   C1 data9_3,	C1 D0	  	},/* 1110xxxr ss0hhyyy	   			: #data,Dy			*/
	{ 0xE020,0xF020, "hrs",   C1 D9, 			C1 D0	  	},/* 1110xxxr ss1hhyyy	   			: Dx,Dy					*/

	{ 0xF248,0xFFF8, "FDBv",  C1 D0,			C2 dispw  },/* 11110010 01001yyy + op + W : Dy,label			*/
	{ 0xF27A,0xFFFF, "FTRAPv",C1 dataw,		C2 nop	  },/* 11110010 01111010 + op + W : #data					*/
	{ 0xF27B,0xFFFF, "FTRAPv",C1 datal,		C2 nop	  },/* 11110010 01111011 + op + L : #data					*/
	{ 0xF27C,0xFFFF, "FTRAPv",C1 nop,			C2 nop	  },/* 11110010 01111100 + op     :								*/
	{ 0xF240,0xFFC0, "FSv.B", C1 ea,			C2 nop	  },/* 11110010 01eeeeee + W	   	: ea						*/
	{ 0xF280,0xFFFF, "FNOP",  C2 nop,			C2 nop 	  },/* 11110010 10000000													*/
	{ 0xF280,0xFFC0, "FBv.W", C1 dispw,		C1 nop 	  },/* 11110010 1scccccc + W	   	: label					*/
	{ 0xF2C0,0xFFC0, "FBv.L", C1 displ,		C1 nop 	  },/* 11110010 1scccccc + L	   	: label					*/
	{ 0xF340,0xFFC0, "FRESTo",C1 ea, 			C1 nop	  },/* 11110011 01eeeeee	   			: ea						*/
	{ 0xF300,0xFFC0, "FSAVE", C1 ea,			C1 nop	  },/* 11110011 00eeeeee	   			: ea						*/
	{ 0xF620,0xFFF8, "MOV16", C1 ixpA0,   C2 ixpA12 },/* 11110110 00100rrr + op     : (Ax)+,(Ay)+		*/
	{ 0xF600,0xFFF8, "MOV16", C1 ixpA0,   C1 ixlong },/* 11110110 00000rrr + L      : (Ax)+,long		*/
	{ 0xF608,0xFFF8, "MOV16", C1 ixlong,  C1 ixpA0  },/* 11110110 00001rrr + L      : long,(Ax)+		*/
	{ 0xF610,0xFFF8, "MOV16", C1 ixA0,    C1 ixlong },/* 11110110 00010rrr + L      : (Ax),long			*/
	{ 0xF618,0xFFF8, "MOV16", C1 ixlong,  C1 ixA0   },/* 11110110 00011rrr + L      : long,(Ax)			*/
	{ 0xF408,0xFF38, "CINVL", C1 nop,     C1 ixA0   },/* 11110100 cc001rrr	   			: cache,(An)		*/
	{ 0xF410,0xFF38, "CINVP", C1 nop,     C1 ixA0   },/* 11110100 cc010rrr	   			: cache,(An)		*/
	{ 0xF418,0xFF38, "CINVA", C1 nop,     C1 nop    },/* 11110100 cc011rrr	   			: cache					*/
	{ 0xF428,0xFF38, "CPUSHL",C1 nop,     C1 ixA0   },/* 11110100 cc101rrr	   			: cache,(An)		*/
	{ 0xF430,0xFF38, "CPUSHP",C1 nop,     C1 ixA0   },/* 11110100 cc110rrr	   			: cache,(An)		*/
	{ 0xF438,0xFF38, "CPUSHA",C1 nop,     C1 nop    },/* 11110100 cc111rrr	   			: cache					*/
	{ 0xF000,0xF1C0, "pGEN",  C1 nop,			C1 nop	  },/* 1111iii0 00eeeeee + W	   	: <params>			*/
	{ 0xF048,0xF1F8, "pDB",   C1 nop,			C1 nop	  },/* 1111iii0 01001yyy + L	   	: Dy,label			*/
	{ 0xF078,0xF1F8, "pTRAPc",C1 nop,			C1 nop	  },/* 1111iii0 01111mmm + op + W : #data					*/
	{ 0xF040,0xF1C0, "pSc",   C1 nop,			C1 nop	  },/* 1111iii0 01eeeeee + W	   	: ea						*/
	{ 0xF080,0xF180, "pB",	  C1 nop,			C1 nop	  },/* 1111iii0 1scccccc + W	   	: label					*/
	{ 0xF140,0xF1C0, "pRESTo",C1 nop, 		C1 nop	  },/* 1111iii1 01eeeeee	   			: ea						*/
	{ 0xF100,0xF1C0, "pSAVE", C1 nop,			C1 nop	  },/* 1111iii1 00eeeeee	   			: ea						*/
	{ 0x0000,0x0000, "INV_OP",C1 nop,			C1 nop	  },/* dddddddd dddddddd          : dummy					*/
};

struct OPCODES tabdisF[] =
{
	{ 0x0030,0xE078, "SINCOS",C2 fp10,		C2 fp0fp7 },/* 000sssdd d0110eee					: FPs,FPd:FPe		*/
	{ 0x4030,0xE078, "SINCOS",C1 ea,			C2 fp0fp7 },/* 000sssdd d0110eee 					: ea,FPd:FPe		*/
	{ 0x0000,0xE000, "f.X",	  C2 fp10,		C2 fp7 	  },/* 000sssdd dfffffff 					: FPs,FPd				*/
	{ 0x5C00,0xFC00, "MOVECR",C2 datarom,	C2 fp7    },/* 010111dd dccccccc					: #rom,FPd			*/
	{ 0x4000,0xE000, "fq",    C1 ea,			C2 fp7 	  },/* 010qqqdd dfffffff 					: ea,FPd				*/
	{ 0x6C00,0xFC00, "MOVE.P",C2 fp7,			C1 eafk	  },/* 011011ss skkkkkkk					: FPs,ea{#k}		*/
	{ 0x7C00,0xFC00, "MOVE.P",C2 fp7,			C1 eafd	  },/* 011111ss srrr0000 					: FPs,ea{Dr}		*/
	{ 0x6000,0xE000, "MOVEq", C2 fp7,			C1 ea	  	},/* 011qqqss srrr0000 					: FPs,ea				*/
	{ 0x8000,0xE000, "MOVEM", C1 ea,			C2 FClist },/* 100rrr00 00000000 					: ea,ctrlist		*/
	{ 0xA000,0xE000, "MOVEM", C2 FClist,	C1 ea	  	},/* 101rrr00 00000000 					: ctrlist,ea		*/
	{ 0xC000,0xEF00, "MOVEMx",C1 ea,			C2 FPlist },/* 110.0000 <list>						: ea,<list>			*/
	{ 0xE000,0xEF00, "MOVEMx",C2 FPlist,	C1 ea	  	},/* 111.0000 <list>						: <list>,ea			*/
	{ 0xC800,0xEF00, "MOVEMx",C1 ea,			C2 D4	  	},/* 110.1000 <list>						: ea,<D4>				*/
	{ 0xE800,0xEF00, "MOVEMx",C2 D4,			C1 ea	  	},/* 111.1000 <list>						: ea,<D4>				*/
};

struct OPCODES tabdisP[] =
{
	{ 0x2400,0xff00, "FLUSHA",C2 nop,			C2 nop	  },/* 00100100 000fffff					:								*/
	{ 0x3000,0xff00, "FLUSH", C2 fcmask,	C2 nop	  },/* 00110000 mmmfffff					: fc,#match			*/
	{ 0x3800,0xff00, "FLUSH", C2 fcmask,	C1 ea	  	},/* 00111000 mmmfffff					: fc,#match,ea	*/
	{ 0x2000,0xfde0, "LOADy", C2 fc,			C1 ea	  	},/* 001000y0 000fffff					: fc,ea					*/
	{ 0x0200,0x92ff, "MOVEd", C2 mmulist,	C1 ea	  	},/* 0nn0nn1d 00000000					: mmureg,ea			*/
	{ 0x0000,0x92ff, "MOVEd", C1 ea,			C2 mmulist},/* 0nn0nn0d 00000000					: ea,mmureg			*/
	{ 0x8000,0xe000, "TESTy", C2 fcea,		C2 level  },/* 100lllyx nnnffff						: fc,ea,#lev,An	*/
};

/*x=
   Table with effective addresses
   - entry in table is mode   (if mode<>7)
    						    or reg+7  (if mode==7)
   - the table contains labels for the cmdtable
*/

UBYTE table_ea[15] =
	{
    D0,				/* ea Dn				mode = 000 nnn	*/
    A0,				/* ea An				mode = 001 nnn	*/
    ixA0,			/* ea (An)			mode = 010 nnn	*/
    ixpA0,		/* ea (An)+			mode = 011 nnn	*/
    ixmA0,		/* ea -(An)			mode = 100 nnn	*/
    ixwA0,		/* ea (w,An)		mode = 101 nnn	*/
    indA0,		/* ea ind(An)		mode = 110 nnn	*/
    ixword,		/* ea (word)		mode = 111 000	*/
    ixlong,		/* ea (long)		mode = 111 001	*/
    ixwPC,		/* ea (w,PC)		mode = 111 010	*/
    indPC, 		/* ea ind(PC)		mode = 111 011	*/
    datass,		/* ea #data			mode = 111 100	*/
    inv,			/*							mode = 111 101	*/
    inv,			/*							mode = 111 110	*/
    inv				/*							mode = 111 111	*/
	};


/*x=
   Table with lower case chars (used in tabdis
   - entry in table is char-'a'
   - the table contains labels for the cmdtable
*/

UBYTE table_lower[26] =
	{
    lab_a, lab_b, lab_c, lab_d, inv,   lab_f, lab_g, lab_h, inv,
    inv,   inv,   lab_l, lab_m, inv,   lab_o, lab_p, lab_q, lab_r,
    lab_s, lab_t, lab_u, lab_v, lab_w, lab_x, lab_y, lab_z
	};


/*
   Table with message strings used in put_msg
   - Use the offsets from the define statements
*/

char table_msg[][4] =
	{
		"",    "*2",  "*4",  "*8",	/* 0  : msg_scale			*/
		".B",  ".W",  ".L",  ".?",	/* 4  : msg_size			*/
		"AS",  "LS",  "ROX", "RO",	/* 8  : msg_shift			*/
		"T" ,  "F" ,  "HI",  "LS",	/* 12 : msg_cond			*/
		"CC",  "CS",  "NE",  "EQ",
		"VC",  "VS",  "PL",  "MI",
		"GE",  "LT",  "GT",  "LE",
		"SFC", "DFC", "CACR","TC",	/* 28 : msg_reg				*/
		"ITT0","ITT1","DTT0","DTT1",
		"USP", "VBR", "CAAR","MSP",
		"ISP", "MUSR","URP", "SRP",
		"R",   "L",									/* 44 : msg_dir				*/
		"CMP", "CHK",								/* 46 : msg_chkcmp		*/
		"U",   "S",									/* 48 : msg_US				*/
		".L",  ".S",  ".X",  ".P",	/* 50 : msg_sizeF			*/
		".W",  ".D",  ".B",  ".P",
		"F",   "EQ",  "OGT", "OGE",	/* 58 : msg_condF			*/
		"OLT", "OLE", "OGL", "OR",
		"UN",  "UEQ", "UGT", "UGE",
		"ULT", "ULE", "NE",  "T",
		"SF",  "SEQ", "GT",  "GE",
		"LT",  "LE",  "GL",  "GLE",
		"NGLE","NGL", "NLE", "NLT",
		"NGE", "NGT", "SNE", "ST",
		"TC",  "???", "SRP", "CRP",	/* 90 : msg_mmu				*/
	};

#define msg_scale   0
#define msg_size    4
#define msg_shift   8
#define msg_cond   12
#define msg_reg    28
#define msg_dir    44
#define msg_chkcmp 46
#define msg_US	   48
#define msg_sizeF  50
#define msg_condF  58
#define msg_mmu	   90


/*
  Tabel with mnemonics for the FPU
*/
char table_msgF[0x3b][6] =
	{
		"MOVE",		/* 00 = 0000000	*/
		"INT",		/* 01 = 0000001	*/
		"SINH",		/* 02 = 0000010	*/
		"INTRZ",	/* 03 = 0000011	*/
		"SQRT",		/* 04 = 0000100	*/
		"inv05",
		"LOGNP1",	/* 06 = 0000110	*/
		"inv07",
		"ETOXM1",	/* 08 = 0001000	*/
		"inv09",
		"ATAN",		/* 0A = 0001010	*/
		"inv0B",
		"ASIN",		/* 0C = 0001100	*/
		"ATANH",	/* 0D = 0001101	*/
		"SIN",		/* 0E = 0001110	*/
		"TAN",		/* 0F = 0001111	*/
		"ETOX",		/* 10 = 0010000	*/
		"TWOTOX",	/* 11 = 0010001	*/
		"TENTOX",	/* 12 = 0010010	*/
		"inv13",
		"LOGN",		/* 14 = 0010100	*/
		"LOG10",	/* 15 = 0010101	*/
		"LOG2",		/* 16 = 0010110	*/
		"inv17",
		"ABS",		/* 18 = 0011000	*/
		"COSH",		/* 19 = 0011001	*/
		"NEG",		/* 1A = 0011010	*/
		"inv1B",
		"ACOS",		/* 1C = 0011100	*/
		"COS",		/* 1D = 0011101	*/
		"GETEXP",	/* 1E = 0011110	*/
		"GETMAN",	/* 1F = 0011111	*/
		"DIV",		/* 20 = 0100000	*/
		"MOD",		/* 21 = 0100001	*/
		"ADD",		/* 22 = 0100010	*/
		"MUL",		/* 23 = 0100011	*/
		"SGLDIV",	/* 24 = 0100100	*/
		"REM",		/* 25 = 0100101	*/
		"SCALE",	/* 26 = 0100110	*/
		"SGLMUL",	/* 27 = 0100111	*/
		"SUB",		/* 28 = 0101000	*/
		"inv29",
		"inv2A",
		"inv2B",
		"inv2C",
		"inv2D",
		"inv2E",
		"inv2F",
		"SINCOS",	/* 30 = 0110ddd	*/
		"SINCOS",	/* 31 = 0110ddd	*/
		"SINCOS",	/* 32 = 0110ddd	*/
		"SINCOS",	/* 33 = 0110ddd	*/
		"SINCOS",	/* 34 = 0110ddd	*/
		"SINCOS",	/* 35 = 0110ddd	*/
		"SINCOS",	/* 36 = 0110ddd	*/
		"SINCOS",	/* 37 = 0110ddd	*/
		"CMP",		/* 38 = 0111000	*/
		"inv39",
		"TST"			/* 3A = 0111010	*/
	};



/*
   Table with indexed addressing modes		 
   - entry in table is IS,I/ISmode + 1		 
   - the table contains a bitmap for the fields
     that are to be outputted
*/

UBYTE table_ind1[17] =
	{
					/*   ?[]x]wl	bit pattern			IS I/IS	*/
    0x08,	/*  00001000	a,x    (8 bit)	 - ---	*/
    0x08,	/*  00001000	a,x							 0 000	*/
    0x2C,	/*  00101100	[a,x]						 0 001	*/
    0x2E,	/*  00101110	[a,x],word			 0 010	*/
    0x2D,	/*  00101101	[a,x],long			 0 011	*/
    0x70,	/*  01110000	[a],?						 0 100	*/
    0x38,	/*  00111000	[a],x						 0 101	*/
    0x3A,	/*  00111010	[a],x,word			 0 110	*/
    0x39,	/*  00111001	[a],x,long			 0 111	*/
    0x00,	/*  00000000	a								 1 000	*/
    0x30,	/*  00110000	[a]							 1 001	*/
    0x32,	/*  00110010	[a],word				 1 010	*/
    0x31,	/*  00110001	[a],long				 1 011	*/
    0x70,	/*  01110000	[a],?						 1 100	*/
    0X70,	/*  01110000	[a],?						 1 101	*/
    0x70,	/*  01110000	[a],?						 1 110	*/
    0x70	/*  01110000	[a],?						 1 111	*/
	};


/*x=
   Table with indexed addressing modes (base)
   - entry in table is BS,BDsize
   - the table contains a bitmap for the fields
     that are to be outputted
*/

UBYTE table_ind2[9] =
	{
					/*  ?0bwl,ap									BS BDsiz	*/
    0x23,	/*  00100011	byte,An	(8 bit)	 - --			*/
    0x80,	/*  10000000	?								 0 00			*/
    0x03,	/*  00000011	An							 0 01			*/
    0x17,	/*  00010111	word,An					 0 10			*/
    0x0F,	/*  00001111	long,An					 0 11			*/
    0x80,	/*  10000000	?								 1 00			*/
    0x40,	/*  01000000	0								 1 01			*/
    0x10,	/*  00010000	word						 1 10			*/
    0x08	/*  00001000	long						 1 11			*/
	};

/*
   enumarates for interpreter commands
*/

/*	The commands consist of one byte and zero or more						*/
/*	parameters.  Bit 7..6 defines the number of parameters.			*/
/*	If cmd = $A0..$FF then put the ascii character (cmd & $7F)	*/
/*	If bit 7..6 = 00 then cmd with 0 parameters									*/
/*	If bit 7..6 = 01 then cmd with 1 parameter									*/
/*	if bit 7..6 = 10 then cmd with 2 parameters									*/

enum cmds
	{
		cmd_nop = 1,
		cmd_label,				/* define label here						*/
		cmd_goto,					/* goto label										*/
		cmd_call,					/* call label										*/

		cmd_take_op1,			/* arg <-- opcode1							*/
		cmd_take_op2,			/* arg <-- opcode2							*/
		cmd_take_op3,			/* arg <-- opcode3							*/
		cmd_take_reg,			/* arg <-- reg									*/
		cmd_take_pc,			/* arg <-- pca									*/
		cmd_take_word,		/* arg <-- next_word						*/
		cmd_take_long,		/* arg <-- next_long						*/
		cmd_take_disp,		/* arg <-- displacement					*/
		cmd_take_extword,	/* arg <-- extword							*/

		cmd_set_arg,			/* arg <-- par									*/
		cmd_put_reglist,	/* *str++ <-- register list			*/
		cmd_put_FClist,		/* *str++ <-- FPU ctr reg list	*/
		cmd_put_ea,				/* *str++ <-- effective address	*/
		cmd_put_ea6,			/* *str++ <-- ea bits 11..6			*/
		cmd_put_arg,			/* *str++ <-- char(arg)					*/
		cmd_put_num,			/* *str++ <-- append(number)		*/
		cmd_put_numAx,		/* *str++ <-- append(number)		*/
											/* With structure check (Jorrit)*/
		cmd_put_sym,			/* *str++ <-- append(symbol)		*/
		cmd_put_msg,			/* *str++ <-- table_msg[par+arg]*/
		cmd_put_msgF,			/* *str++ <-- table_msgF[arg]		*/
		cmd_put_datass,		/* *str++ <-- data (b,w,l,x,l,d	*/

		cmd_put_tmp,			/* tmp <-- arg (Jorrit)					*/
		cmd_get_tmp,			/* arg <-- tmp (Jorrit)					*/

		cmd_extendB,			/* arg <-- sign extend arg			*/
		cmd_extendW,			/* arg <-- sign extend arg			*/
		cmd_addpc,				/* arg <-- arg + pca						*/
		cmd_add,					/* arg <-- arg + parameter			*/
		cmd_and,					/* arg <-- arg & parameter			*/
		cmd_shift,				/* arg <-- arg >> parameter			*/
		cmd_setsize,			/* size = arg										*/

		cmd_if_EQ,				/* if (arg==0) then ... endif		*/
		cmd_if_NE,				/* if (arg!=0) then ... endif		*/
		cmd_if_bit,				/* if (arg   & par) ... endif		*/
		cmd_if_code1,			/* if (code1 & par) ... endif		*/
		cmd_if_code2,			/* if (code2 & par) ... endif		*/

		cmd_endif,				/* end if for if_code cmd				*/
		cmd_indirect,			/* set code1 & code2						*/
		cmd_checkreg,			/* opcode2 R12 - R0							*/
		cmd_stop,					/* stop			*/
		cmd_invalid,			/* invalid label								*/
		cmd_einde 				/* end table										*/
	};


#define label(a)				0x40+(char) cmd_label,(a),
#define call(a)					0x40+(char) cmd_call,(a),
#define goto(a)					0x40+(char) cmd_goto,(a),
#define take_op1				     (char) cmd_take_op1,
#define take_op2				     (char) cmd_take_op2,
#define take_op3				     (char) cmd_take_op3,
#define take_pc					     (char) cmd_take_pc,
#define take_reg				     (char) cmd_take_reg,
#define take_word				     (char) cmd_take_word,
#define take_long				     (char) cmd_take_long,
#define take_disp				     (char) cmd_take_disp,
#define take_extword		     (char) cmd_take_extword,
#define set_arg(a)			0x40+(char) cmd_set_arg,(a),
#define put_FClist			     (char) cmd_put_FClist,
#define put_reglist(a)	0x40+(char) cmd_put_reglist,(a),
#define put_msg(a)			0x40+(char) cmd_put_msg,(a),
#define put_msgF				     (char) cmd_put_msgF,
#define put_ea					     (char) cmd_put_ea,
#define put_ea6					     (char) cmd_put_ea6,
#define put_arg					     (char) cmd_put_arg,
#define put_num					     (char) cmd_put_num,
#define put_numAx				     (char) cmd_put_numAx,
#define put_sym					     (char) cmd_put_sym,
#define put_datass			     (char) cmd_put_datass,
#define put(a)					0x80+(a),
#define put_tmp					     (char) cmd_put_tmp,		/* Jorrit */
#define get_tmp					     (char) cmd_get_tmp,		/* Jorrit */
#define extendB					     (char) cmd_extendB,
#define extendW					     (char) cmd_extendW,
#define addpc						     (char) cmd_addpc,
#define add(a)					0x40+(char) cmd_add,(a),
#define anda(a)					0x40+(char) cmd_and,(a),
#define shift(a)				0x40+(char) cmd_shift,(a),
#define setsize					     (char) cmd_setsize,
#define if_EQ						     (char) cmd_if_EQ,
#define if_NE						     (char) cmd_if_NE,
#define if_bit(a)				0x40+(char) cmd_if_bit,(a),
#define if_code1(a)			0x40+(char) cmd_if_code1,(a),
#define if_code2(a)			0x40+(char) cmd_if_code2,(a),
#define endif						     (char) cmd_endif,
#define indirect(a)			0x40+(char) cmd_indirect,(a),
#define checkreg				     (char) cmd_checkreg,
#define stop						     (char) cmd_stop,
#define einde						     (char) cmd_einde,
#define invalid					     (char) cmd_invalid,

/*__off */
UBYTE table_cmd[] = {
 label(nop)	stop

 label(D12)	shift(3)
 label(D9)	shift(5)
 label(D4)	shift(4)
 label(D0)	put('D')  anda(7)   add('0')   put_arg  stop

 label(A9)	shift(9)
 label(A0)	put('A')  anda(7)  add('0')  put_arg  stop

 label(R12)	shift(12)
 label(R0)	if_bit(3)  goto(A0)  endif
		goto(D0)

 label(ixA0)	put('(')  call(A0)  put(')')  stop

 label(ixpA12)  shift(3)
 label(ixpA9)	shift(9)
 label(ixpA0)	call(ixA0)  put('+')  stop

 label(ixmA9)	shift(9)
 label(ixmA0)	put('-')  goto(ixA0)

 label(D0D9)	call(D0)  put(',')  goto(D9)

 label(ixmA0A9) call(ixmA0)  put(',')  goto(ixmA9)

/* label(ixwA0)	put('(')  call(pword) put(',') call(A0)  put(')')  stop */
/* (Jorrit) Change to enable names of structure items to be printed instead
	 of numbers */
 label(ixwA0)	put('(')
 								anda(7) put_tmp
								take_word put_numAx
								put(',')
								put('A') get_tmp add('0') put_arg
							put(')')  stop

 label(ixwPC)	put('(')  call(dispw)  put(',')  put('P') put('C') put(')')  stop

 label(cas1)	take_op2  call(D0)  put(',')  shift(6)  goto(D0)

 label(cas2)	take_op2  call(D0)  put(':') 
		take_op3  call(D0)  put(',') 
		take_op2  shift(6)  call(D0)   put(':') 
		take_op3  shift(6)  call(D0)   put(',') 
		put('(')  take_op2  shift(12)  call(A0)  put(')')  put(':')
		put('(')  take_op3  shift(12)  call(A0)  put(')')
		stop

 label(moves)	if_bit(11) then
		  take_op2  call(R12) put(',')  take_op1  goto(ea)
		endif
		  take_op1  call(ea)  put(',')  take_op2  goto(R12)

 label(ixword)	put('(')  take_word  put_num  put(')')  stop

 label(ixlong)	put('(')  take_long  put_num  put_sym  put(')')  stop

 label(ea11_6)	put_ea6  stop
 label(ea)	put_ea   stop

 label(usp)	put('U')  put('S')  put('P')  stop

 label(ccrsr)	if_bit(6) then 
 label(sr)	  put('S')  put('R') stop
		endif
 label(ccr)	  put('C')  put('C')  put('R')  stop
		
 label(FClist)	put_FClist  stop

 label(FPlist)  anda(0xff) put_reglist(2)  stop

 label(reglist) put_reglist(1)  stop

 label(displ)	set_arg(0xff) goto(disp)
 label(dispw)	set_arg(0)
 label(disp)	anda(0xFF) take_disp  put_num  put_sym stop

 
 label(data9_3) shift(9) anda(7) if_EQ then add(8) endif 
		put('#') put_num  stop

 label(data0_3)	anda(0x07)
 label(data0_4)	anda(0x0F)
 label(data0_8)	anda(0xFF)  put('#')  put_num  stop

 label(datarom)	put('#')  put('r')  put('o')  put('m')  anda(0x3f)  put_num  stop

 label(dataw)	put('#')
 label(pword)	take_word  put_num  stop

 label(datal)	put('#')  take_long  put_num  stop

 label(datass)	put('#')  put_datass  stop

 label(indA0)	indirect(0)  goto(doind)
 label(indPC)	indirect(1)
 label(doind)	put('(')
		if_code1(0x20) then put('[')   endif
		if_code2(0x80) then put('?')   endif
		if_code2(0x40) then put('0')   endif
		if_code2(0x20) then take_extword  extendB  addpc  put_num  put_sym put(',') endif
		if_code2(0x10) then take_word  extendW addpc  put_num  put_sym endif
		if_code2(0x08) then take_long  addpc  put_num  put_sym endif
		if_code2(0x04) then put(',')   endif
		if_code2(0x02) then take_reg   call(A0) endif
		if_code2(0x01) then put('P')  put('C')  endif
		if_code1(0x10) then put(']')  endif
		if_code1(0x40) then put(',')  put('?')   endif
		if_code1(0x08) then put(',')  take_extword  call(R12)
				    shift(11)  anda(1)  add(1)  put_msg(msg_size)
				    take_extword  shift(9) anda(3) put_msg(msg_scale)
				    endif
		if_code1(0x04) then put(']')  endif
		if_code1(0x02) then put(',')  take_word  put_num  endif
		if_code1(0x01) then put(',')  take_long  put_num  endif
		put(')')
		stop
		 
 label(offwid)	if_bit(5) then goto(D0) endif
		anda(0x1F)  put_num  stop

 label(eaow)	take_op1  call(ea)  put('{')
		take_op2  shift(6)  call(offwid)  put(':')
		take_op2  call(offwid)  put('}')  stop

 label(eafk)	call(ea)  take_op2  put('{')  put('#')  anda(0x7f)  put_num  put('}')  stop

 label(eafd)	call(ea)  take_op2  put('{')  shift(4)  anda(7)  
		call(D0)  put('}')  stop

 label(op2_Rc)	if_bit(11) then add(8) endif
		anda(15)  put_msg(msg_reg)  stop

 label(div)	checkreg  if_EQ then goto(mul2) endif
		goto(mul1)

 label(mul)	if_bit(10) then 
 label(mul1)	  take_op2  call(D0)  put(':')
		endif
 label(mul2)	  take_op2  goto(D12)

 label(fp0fp7)	call(fp0)  put(':')  goto(fp7)
 label(fp10)	shift(3)
 label(fp7)	shift(7)
 label(fp0)	put('F')  put('P')  anda(7)  add('0')  put_arg  stop

 label(fc)	if_bit(4) then put('#') anda(7) put_num stop endif
		if_bit(3) then goto(D0) endif
		if_bit(0) then put('D') put('F') put('C') stop endif
		put('S') put('F') put('C') stop

 label(fcea)	call(fc)  put(',')  take_op1  goto(ea)

 label(fcmask) call(fc)  put(',')  put('#')  take_op2  shift(5)  anda(7)  put_num  stop

 label(mmulist) if_bit(13) put('M') put('M') put('U') put('S') put('R') stop endif
		if_bit(14) shift(10) anda(3)  put_msg(msg_mmu) stop endif
		put('T') put('T') shift(10) anda(1) put_num stop

 label(level)	put('#')  shift(10) anda(7) put_num
		take_op2  if_bit(8) put(',') shift(5) goto(A0) endif 
		stop

 label(lab_a)	put('A')  put('L')  	     stop
 label(lab_o)   put('O')  put('R')  put('E') stop
 label(lab_p)	put('c')  put('p')           stop

 label(lab_c)	shift(8)  anda(15)  put_msg(msg_cond)   stop
 label(lab_r)	shift(8)  anda(1)   put_msg(msg_dir)    stop
 label(lab_g)   shift(6)
 label(lab_h)	shift(3)  anda(3)   put_msg(msg_shift)  stop
 label(lab_z)	shift(8)  anda(1)   put_msg(msg_chkcmp) stop

 label(lab_b)	set_arg(0)  setsize  put('.')  put('B')  stop
 label(lab_w)	set_arg(1)  setsize  put('.')  put('W')  stop
 label(lab_l)	set_arg(2)  setsize  put('.')  put('L')  stop

 label(lab_u)	shift(2)
 label(lab_t)	anda(0x40)  add(0x40)
 label(lab_s)	shift(6)  anda(3)
 		setsize  put_msg(msg_size)  stop

 label(lab_m)	take_op2  shift(11) anda(1) put_msg(msg_US)
		checkreg  if_EQ then stop endif
		take_op2  if_bit(10) then stop endif
		put('L')  stop

 label(lab_f)	put_msgF  stop

 label(lab_q)	take_op2 shift(10) anda(7) put_msg(msg_sizeF) 
		add(8) setsize stop

 label(lab_x)	put('.')  put('X')  stop

 label(lab_d)	take_op2 if_bit(8) then put('F') put('D') endif stop

 label(lab_y)	take_op2 if_bit(9) then put('R') stop endif put('W') stop

 label(lab_v)	if_bit(7) anda(0x3f)  put_msg(msg_condF)  stop  endif
		take_op2  anda(0x3f)  put_msg(msg_condF)  stop

 label(inv)	put('?')  stop

		einde invalid
};
/*__on */


/*
		(Jorrit)
		This structure is given from the calling program (PowerVisor). It
		contains all registers for a given program. With these registers we
		can disassemble a bit smarter. For example, we can disassemble
		offsets in structures to the equivalent name if the structure is loaded
		and if the tag type is set to that structure for a given address
*/

struct StackFrame
	{
		ULONG pc;
		UWORD sr;
		ULONG Dx[8];
		ULONG Ax[7];
	};
struct StackFrame *sf;


/*
		Variables
*/

static char *str;
static int opcode1,opcode2,opcode3,op3val;
static int address,memofs;
static int size;
static int extword,pca,reg,code1,code2;

char *CheckForSymbol (ULONG number);							/* Jorrit */
char *CheckStruct (ULONG address, UWORD offset);	/* Jorrit */

/* #define DEBUG 1 */

#ifdef DEBUG

	void Print (char *s);
	void PrintNum (int num);
#	define PR(s) Print(s);
#	define PRN(n) PrintNum(n);

#else

#	define PR(s)
#	define PRN(n)

#endif

/*x=
   append - appends a string to str
*/

void REG appendstr (char *s, int len)
{
	int n;

	for (n=0 ; n<len ; n++)
		{
			if (*s == 0) break;
			*str++ = *s++;
		}
}


/*x=
	 appendnum - appends a number to str
	 (Jorrit)
	 if regnum != -1 we see if we can print a structure element name instead
									 of a number. In that case regnum is equal to the used
									 register (example: (5,a5) -> regnum == 5)
*/

void REG appendnum (ULONG number, int regnum)
{
	int digit,n,flag;
	char *p;

	/* (Jorrit) */
	if (regnum != -1 && sf)
		{
			if (p = CheckStruct (sf->Ax[regnum],number))
				{
					appendstr (p,20);
					return;
				}
		}
	if (p = CheckForSymbol (number))
		{
			appendstr (p,20);
			return;
		}

	if (number >= (ULONG)10)  *str++ = '$';
		flag = FALSE;
	for (n=7 ; n>=0 ; n--)
		{
			digit = (number >> (n*4)) & 0x0F;
			if (digit > 9)  digit += 'A' - 10;
			else digit += '0';
			if ((digit != '0') || (n == 0)) flag=TRUE;
			if (flag) *str++ = digit;
		}
}

/*x=
    append symbol string
*/

void REG appendsym (ULONG addr)
{
	char sym[64], *s;

	sym[0] = 0;
	s = sym;
	if (*s == 0) return;
	*str++ = ':';
	while (*s) *str++ = *s++;
}

/*x=
   get next word from memory
*/

ULONG next_word (void)
{
	int w;

	w = *(UWORD *)address;
	address += 2;
	return ((ULONG)w);
}


/*x=
   get next long word from memory
*/

ULONG next_long (void)
{
	int w;

	w = *(ULONG *)address;
	address += 4;
	return ((ULONG)w);
}

/*x=
  get size in bytes of command
*/

#define cmd_size(cmd) (((cmd) >= 0xA0) ? 1 : ((((cmd)>>6) & 3)+1))



/*x=
  put register list
  bit 0..7 = D0..D7
  bit 8..15 = A0..A7
  bit 16..23 = FP0..FP7
*/

void REG putlist (ULONG list, int par)
{
	int draw,first,last,flag,n;
	ULONG bit;
	int left;	/* shift left */
	int fpu;	/* for FPU */

	first = last = draw = -1;
	flag = FALSE;
	left = par & 1;
	fpu = par & 2;
	if (left)  bit = 1; else bit = 0x800000;
	if (left && fpu) list = list << 16;
	if (! left && ! fpu) list = list << 8;
	for (n=0 ; n<=23 ; n++)
		{
			if (list & bit)
				{
					if (first == -1) { first = n; draw = n; }
					last = n;
				}
			if (((list & bit) == 0) || ((n % 8) == 7))
				{
					if (last != first) { *str++ = '-'; draw = last; }
					first = last = -1;
				}

		if (draw >= 0)
			{
				if (flag && (str[-1] != '-'))  *str++ = '/';
				/* */if (n >= 16) { *str++ = 'F'; *str++ = 'P'; }
				else if (n >= 8)  *str++ = 'A';
				else *str++ = 'D';
				*str++ = (draw & 7) + '0';
				draw = -1; flag = TRUE;
			}
		if (left)  bit = bit<<1; else bit = bit>>1;
	}
}

/*==============================================================*
   docode
 *==============================================================*/


void REG docode (enum codes code, int arg)
{
	UBYTE *p;
	int cmd,par,stops,skip;
	int mode,temp;
	int tmp;		/* Jorrit */

PR(" { ");

	if ((UBYTE)code & 0x80) arg = opcode2;
	code = (enum codes) ((UBYTE)code & 0x7F);

	for (p=table_cmd ; *p != (UBYTE)(enum cmds)cmd_einde ; p += cmd_size(*p))
		if (*p == 0x40+(UBYTE)(enum cmds)cmd_label)
			if (*(p+1) == (UBYTE)(enum codes)code) break;

	do
		{
			p += cmd_size(*p);
			skip = FALSE;   stops = FALSE;
			cmd = *(p+0);   par = *(p+1);
			if (cmd >= 0xA0)  { *str++ = cmd & 0x7f; continue; };
			cmd = cmd & 0x3F;
			switch((enum cmds)cmd)
				{
					case cmd_take_op1		: PR("a"); arg = opcode1; 		break;
					case cmd_take_op2		: PR("b"); arg = opcode2;		break;
					case cmd_take_op3		: PR("c"); if (! op3val)  opcode3 = next_word ();
																op3val = TRUE;
																arg = opcode3;
																break;
					case cmd_take_pc		: PR("d"); arg = pca; break;
					case cmd_take_reg		: PR("e"); arg = reg; break;
					case cmd_take_word	: PR("f"); arg = next_word ();	break;
					case cmd_take_long	: PR("g"); arg = next_long ();	break;
					case cmd_take_extword:PR("h"); arg = extword;		break;
					case cmd_set_arg		: PR("i"); arg = par;		break;
					case cmd_put_arg		: PR("j"); *str++ = arg;		break;
					case cmd_put_num		: PR("k"); appendnum(arg,-1); break;
					case cmd_put_numAx	: PR("k"); appendnum(arg,tmp); break;	/* Jorrit */
					case cmd_put_sym		: PR("l"); appendsym(arg);		break;
					case cmd_put_msg		: PR("m"); appendstr (table_msg[par+arg],4); break;
					case cmd_put_msgF		: PR("n"); appendstr (table_msgF[opcode2 & 0x7f],6); break;
					case cmd_extendB		: PR("o"); arg &= 0x00ff; if (arg > 0x007f) arg += 0xffffff00; break;
					case cmd_extendW		: PR("p"); arg &= 0xffff; if (arg > 0x7fff) arg += 0xffff0000; break;
					case cmd_addpc			: PR("q"); arg = arg + pca;	break;
					case cmd_add				: PR("r"); arg = arg + par;	break;
					case cmd_and				: PR("s"); arg = arg & par;	break;
					case cmd_shift			: PR("t"); arg = arg >> par;	break;
					case cmd_setsize		: PR("u"); size = arg;		break;
					case cmd_indirect		: PR("v"); reg = arg;
																if (par) pca = address - memofs; else pca = 0;
																extword = next_word ();
																code1 = ( ((extword>>0) & 7) | ((extword>>3) & 8) ) + 1;  /*  I/IS + IS + 1   */
																code2 = ( ((extword>>4) & 3) | ((extword>>5) & 4) ) + 1;  /*  BDSIZE + BS + 1 */
																if ((extword & 0x0100) == 0)  code1 = code2 = 0;
																code1 = table_ind1[code1];
																code2 = table_ind2[code2];
																if (par) code2 &= 0xFD; else code2 &= 0xFE;
																break;

					case cmd_put_ea6		: PR("w"); arg = ((arg >> 3) & 070) | ((arg >> 9) & 007);
					case cmd_put_ea			: PR("x"); mode = (arg>>3) & 7;
																if (mode == 7) mode += arg & 7;
																docode ((enum codes)table_ea[mode],arg);
																break;

					case cmd_put_FClist	: PR("y"); if (opcode2 & 0x1000) appendstr ("FPCR/",5);
																if (opcode2 & 0x0800) appendstr ("FPSR/",5);
																if (opcode2 & 0x0400) appendstr ("FPIAR/",6);
																str--;
																break;

					case cmd_put_reglist: PR("z"); if ((opcode1 & 0x0038) == 0x0020) par ^= 1;
																putlist (arg, par);
																break;

					case cmd_put_datass	: PR("0"); switch (size)
																	{
																		case 14: ;
																		case 0: arg = next_word () & 0xFF;	break;
																		case 12: ;
																		case 1: arg = next_word ();		break;
																		case 8: case 9: case 10: case 11: case 13: ;
																		case 2: arg = next_long ();		break;
																	};
																appendnum(arg,-1);
																switch (size)
																	{
																		case 10: case 11: next_long ();
																		case 13: next_long ();
																	}
																break;

					case cmd_take_disp	: PR("1"); temp = address - memofs;
																if (arg == 0x00)  arg = temp + (short)next_word ();
																else if (arg == 0xFF)  arg = temp + (int)next_long ();
																else arg = temp + (char)arg;
																break;

					case cmd_checkreg		: PR("2"); arg = (opcode2 & 7) - ((opcode2>>12) & 7); break;
					case cmd_if_EQ			: PR("3"); if (arg != 0) 							skip=TRUE; break;
					case cmd_if_NE			: PR("4"); if (arg == 0) 							skip=TRUE; break;
					case cmd_if_bit			: PR("5"); if (((arg>>par) & 1) == 0)	skip=TRUE; break;
					case cmd_if_code1		: PR("6"); if ((code1 & par) == 0) 		skip=TRUE; break;
					case cmd_if_code2		: PR("7"); if ((code2 & par) == 0) 		skip=TRUE; break;

					case cmd_call				: PR("8"); docode (par,arg); break;
					case cmd_goto				: PR("9"); docode (par,arg);
					case cmd_stop				: PR("A"); stops = TRUE;
					case cmd_label			: PR("B"); break;
					case cmd_endif			: PR("C"); break;

					case cmd_invalid		: PR("D"); appendstr ("?inv?",9);
																stops = TRUE;
																break;

					case cmd_put_tmp		: PR("E"); tmp = arg; break;		/* Jorrit */
					case cmd_get_tmp		: PR("F"); arg = tmp; break;		/* Jorrit */

					default 						: PR("G"); appendstr ("?cmd_",9); appendnum (cmd,-1); *str++ = '?';
																stops = TRUE;
																break;
				}
			if (skip)
				while (*p != (UBYTE)(enum cmds)cmd_endif) p += cmd_size (*p);
		}
	while (!stops);

PR(" } ");
}

/*=====================================================*
	 disasm will disassemble one instruction at address
	 returns : number of bytes of instruction
 *=====================================================*/

int SDS disasm (char *result_string,			/* string to put disassembled result */
								int address_first_opcode,	/* address of first opcode */
								struct StackFrame *stf)		/* stackframe for task so we can */
																					/* disassemble with structure names */
																					/* instead of numbers, if appropriate */
																					/* (can be NULL) (Jorrit) */
{
	char c;
	int n;

	sf = stf;		/* Jorrit */
	memofs = 0;
	str = result_string;
	address = address_first_opcode;
	opcode1 = next_word ();
	op3val = FALSE;

	/* MMU 68030 opcodes */
	if ((opcode1 & 0xFFC0) == 0xF000)
		{
			*str++ = 'P';
			pt = tabdisP;
			opcode2 = next_word ();
			while ((opcode2 & pt->mask) != pt->opcode) pt++;
		}
	/* FPU for 680x0 */
	else if ((opcode1 & 0xFFC0) == 0xF200)
		{
			*str++ = 'F';
			pt = tabdisF;
			opcode2 = next_word ();
			while ((opcode2 & pt->mask) != pt->opcode) pt++;
		}
	else
		{
			pt = tabdis;
			while ((opcode1 & pt->mask) != pt->opcode) pt++;
			if ((pt->code1 | pt->code2) & 0x80) opcode2 = next_word ();
    }

	for (n=0 ; n<6 ; n++)
		{
			if ((c = pt->name[n]) == 0) break;
			if ((c >= 'a') && (c <= 'z'))
				docode ((enum codes)table_lower[c - 'a'], opcode1);
			else *str++ = c;
		}

	if (pt->code1 != ((UBYTE)nop & 0x7f))
		{
			*str++ = ' ';
			for (n=(int)str - (int)result_string ; n<=8 ; n++) *str++ = ' ';
			docode ((enum codes)pt->code1,opcode1);
		}

	if (pt->code2 != ((UBYTE)nop & 0x7f))
		{
			*str++ = ',';
			docode ((enum codes)pt->code2,opcode1);
		}

PR("\n");
	*str = 0;
	return (address - address_first_opcode);
}

char * SDS getstr (void)
{
	return str;
}


/* end */
