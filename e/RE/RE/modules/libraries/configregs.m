#ifndef LIBRARIES_CONFIGREGS_H
#define LIBRARIES_CONFIGREGS_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif	

OBJECT ExpansionRom
 		
    Type:UBYTE	
    Product:UBYTE	
    Flags:UBYTE	
    Reserved03:UBYTE	
    Manufacturer:UWORD 
    SerialNumber:LONG 
    InitDiagVec:UWORD 
    Reserved0c:UBYTE
    Reserved0d:UBYTE
    Reserved0e:UBYTE
    Reserved0f:UBYTE
ENDOBJECT


OBJECT ExpansionControl
 	
    Interrupt:UBYTE	
    Z3_HighBase:UBYTE 
    BaseAddress:UBYTE 
    Shutup:UBYTE	
    Reserved14:UBYTE
    Reserved15:UBYTE
    Reserved16:UBYTE
    Reserved17:UBYTE
    Reserved18:UBYTE
    Reserved19:UBYTE
    Reserved1a:UBYTE
    Reserved1b:UBYTE
    Reserved1c:UBYTE
    Reserved1d:UBYTE
    Reserved1e:UBYTE
    Reserved1f:UBYTE
ENDOBJECT



#define E_SLOTSIZE		$10000
#define E_SLOTMASK		$ffff
#define E_SLOTSHIFT		16

#define E_EXPANSIONBASE	$00e80000	
#define EZ3_EXPANSIONBASE	$ff000000	
#define E_EXPANSIONSIZE	$00080000	
#define E_EXPANSIONSLOTS	8
#define E_MEMORYBASE		$00200000	
#define E_MEMORYSIZE		$00800000
#define E_MEMORYSLOTS		128
#define EZ3_CONFIGAREA		$40000000	
#define EZ3_CONFIGAREAEND	$7FFFFFFF	
#define EZ3_SIZEGRANULARITY	$00080000	


#define ERT_TYPEMASK		$c0	
#define ERT_TYPEBIT		6
#define ERT_TYPESIZE		2
#define ERT_NEWBOARD		$c0
#define ERT_ZORROII		ERT_NEWBOARD
#define ERT_ZORROIII		$80

#define ERTB_MEMLIST		5   
#define ERTB_DIAGVALID		4   
#define ERTB_CHAINEDCONFIG	3   
#define ERTF_MEMLIST		(1<<5)
#define ERTF_DIAGVALID		(1<<4)
#define ERTF_CHAINEDCONFIG	(1<<3)

#define ERT_MEMMASK		$07	
#define ERT_MEMBIT		0
#define ERT_MEMSIZE		3


#define ERFF_MEMSPACE		(1<<7)	
#define ERFB_MEMSPACE		7	
#define ERFF_NOSHUTUP		(1<<6)	
#define ERFB_NOSHUTUP		6
#define ERFF_EXTENDED		(1<<5)	
#define ERFB_EXTENDED		5	
					
#define ERFF_ZORRO_III		(1<<4)	
#define ERFB_ZORRO_III		4	
#define ERT_Z3_SSMASK		$0F	
#define ERT_Z3_SSBIT		0	
#define ERT_Z3_SSSIZE		4	
					

#define ECIB_INTENA		1
#define ECIB_RESET		3
#define ECIB_INT2PEND		4
#define ECIB_INT6PEND		5
#define ECIB_INT7PEND		6
#define ECIB_INTERRUPTING	7
#define ECIF_INTENA		(1<<1)
#define ECIF_RESET		(1<<3)
#define ECIF_INT2PEND		(1<<4)
#define ECIF_INT6PEND		(1<<5)
#define ECIF_INT7PEND		(1<<6)
#define ECIF_INTERRUPTING	(1<<7)

#define ERT_MEMNEEDED(t)	\
	(((t)&ERT_MEMMASK)? $10000 << (((t)&ERT_MEMMASK) -1) : $800000 )

#define ERT_SLOTSNEEDED(t)	\
	(((t)&ERT_MEMMASK)? 1 << (((t)&ERT_MEMMASK)-1) : $80 )

#define EC_MEMADDR(slot)		((slot) << (E_SLOTSHIFT) )

#define EROFFSET(er)	(&(  0).er)
#define ECOFFSET(ec)	\
 ( SIZEOF ExpansionRom+(&(  0).ec))

OBJECT DiagArea
 
    Config:UBYTE	
    Flags:UBYTE	
    Size:UWORD	
    DiagPoint:UWORD	
    BootPoint:UWORD	
    Name:UWORD	
				
				
    Reserved01:UWORD	
    Reserved02:UWORD
ENDOBJECT



#define DAC_BUSWIDTH	$C0 
#define DAC_NIBBLEWIDE	$00
#define DAC_BYTEWIDE	$40 
#define DAC_WORDWIDE	$80
#define DAC_BOOTTIME	$30	
#define DAC_NEVER	$00	
#define DAC_CONFIGTIME	$10	
				
#define DAC_BINDTIME	$20	

#endif 
