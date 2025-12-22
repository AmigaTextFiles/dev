/* Object/Executable Information Utility V0.90 05/22/1989
 * Hunk type codes Lattice 5.02 Compiler
 * The information for these definitions came from The AmigaDos
 * Technical Reference Manual and the Lattice Technical Support
 * People, My thanks to them!
 */
#include <exec/types.h>
#include <stdlib.h>
#include <string.h>
#include <proto/dos.h>
#include <ctype.h>
#include <stdio.h>
#define Hunk_Unit     0x3E7  /*Start of program unit */
#define Hunk_Name     0x3E8  /*Name of a hunk */
#define Hunk_Code     0x3E9  /*Code segment */
#define Hunk_Data     0x3EA  /*Initialized Data segment */
#define Hunk_Bss      0x3EB  /*Unitialized Data segment */
#define Hunk_Reloc32  0x3EC  /*32-bit relocation list */
#define Hunk_Reloc16  0x3ED  /*16-bit PC-relative relocation info */
#define Hunk_Reloc8   0x3EE  /* 8-bit PC-relative relocation info */
#define Hunk_Ext      0x3EF  /*External symbol */
#define Hunk_Symbol   0x3F0  /*Symbol table */
#define Hunk_Debug    0x3F1  /*Debug data */
#define Hunk_End      0x3F2  /*End of this hunk */
#define Hunk_Header   0x3F3  /*hunk summary for loader */
#define Hunk_Overlay  0x3F5  /*overlay table */
#define Hunk_Break    0x3F6  /*end of overlay node */
#define Hunk_Dreloc32 0x3F7  /*32-bit relocation list */
#define Hunk_Dreloc16 0x3F8  /*16-bit PC-relative relocation info */
#define Hunk_Dreloc8  0x3F9  /* 8-bit PC-relative relocation info */
#define Hunk_Library  0x3FA  /*Lattice library format */
#define Hunk_Index    0x3FB  /*Lattice library index */
/*
 * External symbol info
 * Each Hunk_Ext record is a null-terminated list of symbol data units.
 * each symbol data unit consists of a type byte, symbol length
 * in longwords, symbol name (null-padded if necessary).  The data following
 * will vary with the symbol type.
 * Ext_symbol   has null-terminated list of symbol data units.
 * Ext_def/abS/res have 1 longword of data.
 * Ext_ref32/16/8  have a longword count and that many longwords of data.
 * Ext_dref32/16/8 have a longword count and that many longwords of data.
 * Ext_common has a longword size of common block, data count and the count
 *            number of words of data.
 */

#define Ext_symbol       0      /* symbol table */
#define Ext_def          1      /* relocatable definition */
#define Ext_abs          2      /* absolute definition */
#define Ext_res          3      /* resident library definition */
#define Ext_ref32      0x81     /* 32-bit reference to symbol */
#define Ext_common     0x82     /* 32-bit reference to COMMON */
#define Ext_ref16      0x83     /* 16-bit reference to symbol */
#define Ext_ref8       0x84     /*  8-bit reference to symbol */
#define Ext_dref32     0x85     /* 32-bit base relative reference */
#define Ext_dref16     0x86     /* 16-bit base relative reference */
#define Ext_dref8      0x87     /*  8-bit base relative reference  */

/* decode.c */
void startline ( void );
void padd ( void );
void opchar ( char c );
void opstring ( char *s );
short opcode ( char *s );
void opint ( unsigned int v );
void ophex ( unsigned int v , short n );
void opbyte ( unsigned int v );
void lefthex ( unsigned short , short );
void invalid ( void );
void sourcekind ( short k );
unsigned char grabchar ( short n );
short grabword ( short n );
void outadd ( char *address );
void operand ( unsigned mode , unsigned reg );
void shiftinstruction ( void );
void conditioncode ( unsigned short cc );
void handlezero ( void );
void breakfurther ( char *base );
void moveinstruction ( unsigned short kind );
void startrange ( short bit );
void endrange ( short first , short bit );
void registerlist ( short kkkk , short mask );
void specialbits ( void );
void handlefour ( void );
void op_5 ( void );
void op_14 ( void );
void decode ( void );
char *dumpcode ( int offset , char *loc , int n );

/* do_sym.c */
unsigned char OneChar ( BPTR file );
int GrabThree ( BPTR file );
int GrabLong ( BPTR file );
void DoSymbolData ( BPTR file );

/* do_arguments.c */
void Do_Arguments ( int , char **, long *);

/* ninfo.c */
void main ( int argc , char *argv []);
void Dump_Text ( char *tptr , int count );
int Dump_Raw ( BPTR file , int Type , int Words );
int Do_Name ( BPTR file , int Words );
int Dump_Code ( BPTR file , int Words );
int Dump_Virus ( BPTR file );
