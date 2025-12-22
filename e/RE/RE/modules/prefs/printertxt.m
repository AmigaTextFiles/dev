#ifndef PREFS_PRINTERTXT_H
#define PREFS_PRINTERTXT_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define ID_PTXT MAKE_ID("P","T","X","T")
#define ID_PUNT MAKE_ID("P","U","N","T")
#define	DRIVERNAMESIZE 30		
#define DEVICENAMESIZE 32		
OBJECT PrinterTxtPrefs

    Reserved[4]:LONG		
    Driver[DRIVERNAMESIZE]:UBYTE	
    Port:UBYTE			
    PaperType:UWORD
    PaperSize:UWORD
    PaperLength:UWORD		
    Pitch:UWORD
    Spacing:UWORD
    LeftMargin:UWORD		
    RightMargin:UWORD		
    Quality:UWORD
ENDOBJECT


#define PP_PARALLEL 0
#define PP_SERIAL   1

#define PT_FANFOLD  0
#define PT_SINGLE   1

#define PS_US_LETTER	0
#define PS_US_LEGAL	1
#define PS_N_TRACTOR	2
#define PS_W_TRACTOR	3
#define PS_CUSTOM	4
#define PS_EURO_A0	5		
#define PS_EURO_A1	6		
#define PS_EURO_A2	7		
#define PS_EURO_A3	8		
#define PS_EURO_A4	9		
#define PS_EURO_A5	10		
#define PS_EURO_A6	11		
#define PS_EURO_A7	12		
#define PS_EURO_A8	13		

#define PP_PICA	 0
#define PP_ELITE 1
#define PP_FINE	 2

#define PS_SIX_LPI   0
#define PS_EIGHT_LPI 1

#define PQ_DRAFT  0
#define PQ_LETTER 1
OBJECT PrinterUnitPrefs

    Reserved[4]:LONG		  
    UnitNum:LONG			  
    OpenDeviceFlags:LONG		  
    DeviceName[DEVICENAMESIZE]:UBYTE  
ENDOBJECT


#endif 
