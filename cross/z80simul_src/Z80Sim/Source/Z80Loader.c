/****h* Z80Simulator/Z80Loader.c [2.5] ******************************
*
* NAME
*    Z80Loader.c
*
* DESCRIPTION
*    The Configuration file loader for the Z80 Simulator program.
*
*     FLeX -L -s -e -t Z80LexLoader.flex >Z80LexLoader.c
*     SC data=far nostkchk Z80LexLoader.c
*
*     FSMGen <Z80Loader.defn Z80Loader.c
*     SC data=far nostkchk Z80Loader.c
*
*  LAST CHANGED:  03/03/94
*
*********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Z80Sim.h"
#include "Z80BKPT.h"

/* ----------------------------------- Located in Z80SimGTGUI.c file */
IMPORT void FreeupData( void );
IMPORT void CloseDownScreen( void );
IMPORT int  Z80SimCloseWindow( void );
/* ----------------------------------- */


   /* action functions used by this machine! */

PRIVATE void skip(      void );
PRIVATE void report(    void );
PRIVATE void Add_Byt(   void );
PRIVATE void BrkRegNum( void );
PRIVATE void BrkByte1(  void );
PRIVATE void BrkByte2(  void );
PRIVATE void addr1(     void );
PRIVATE void addr2(     void );
PRIVATE void membyt(    void );

IMPORT char  *loadfile_buff;

#define   MAXREGBYTES    53
#define   LASTREGBYTE    MAXREGBYTES - 1

int    reg_defn_count = 0;
int    bkpt_reg       = 0;      // number of breakpoint register.   
int    loadaddr       = 0;

char   regbytes[ MAXREGBYTES ]; // storage for register initial values.
char   break_pt[7];             // breakpoint-related values.

IMPORT FILE *yyin;


#define   EMPTY    -1
#define   STOP     -1

/* Start of Transition table */

struct Transitions {

   int  nextstate;
   void	(*act)( void );
};

		/* Defines for Symbol names: */

#define	EMPTY   -1
#define	empty    0
#define	white    1   // [ \t]+
#define	reg      2   // 'REG'
#define	alpha    3   // 'A-FHLIR | [A-FHLS] P | IX | IY | PC
#define	colon    4   // ':'
#define	byte     5   // 00 -> FF
#define	break    6   // 'BREAK'
#define	load     7   // 'LOAD'
#define	end      8   // 'END'
#define	eol      9   // [\n]+
#define	marker   10  // '@'

		/* Defines for State names: */

#define	start    0
#define	reg_def  1
#define	reg_nam  2
#define	reg_trm  3
#define	regnum   4
#define	bkpt     5
#define	bknum    6
#define	bknum2   7
#define	bknum3   8
#define	loadmem  9
#define	addrhi   10
#define	addrlo   11
#define	bytes    12
#define	endstmt  13
#define	wrong    14

PRIVATE struct Transitions fsm_table[][11] = {

/*
   empty             white             reg               alpha            
   colon             byte              break             load             
   end               eol               marker           
*/

/*  start STATE: */

start  ,skip   , start  ,skip   , reg_def,skip   , wrong  ,report , 
wrong  ,report , wrong  ,report , bkpt   ,skip   , loadmem,skip   , 
endstmt,skip   , start  ,skip   , wrong  ,report , 

/*  reg_def STATE: */

reg_def,skip   , reg_def,skip   , wrong  ,report , reg_nam,skip   , 
wrong  ,report , wrong  ,report , wrong  ,report , wrong  ,report , 
wrong  ,report , wrong  ,report , wrong  ,report , 

/*  reg_nam STATE: */

reg_nam,skip   , reg_nam,skip   , wrong  ,report , reg_nam,skip   , 
reg_trm,skip   , wrong  ,report , wrong  ,report , wrong  ,report , 
wrong  ,report , reg_nam,skip   , wrong  ,report , 

/*  reg_trm STATE: */

reg_trm,skip   , reg_trm,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , regnum ,Add_Byt, wrong  ,report , wrong  ,report , 
wrong  ,report , wrong  ,report , wrong  ,report , 

/*  regnum STATE: */

regnum ,skip   , regnum ,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , regnum ,Add_Byt, wrong  ,report , wrong  ,report , 
wrong  ,report , start  ,skip   , wrong  ,report , 

/*  bkpt STATE: */

bkpt   ,skip   , bkpt   ,skip     , wrong  ,report , wrong  ,report , 
wrong  ,report , bknum  ,BrkRegNum, wrong  ,report , wrong  ,report , 
wrong  ,report , bkpt   ,skip     , wrong  ,report , 

/*  bknum STATE: */

bknum  ,skip   , bknum  ,skip    , wrong  ,report , wrong  ,report , 
wrong  ,report , bknum2 ,BrkByte1, wrong  ,report , wrong  ,report , 
wrong  ,report , bknum  ,skip    , wrong  ,report , 

/*  bknum2 STATE: */

bknum2 ,skip   , bknum2 ,skip    , wrong  ,report , wrong  ,report , 
wrong  ,report , bknum3 ,BrkByte2, wrong  ,report , wrong  ,report , 
wrong  ,report , bknum2 ,skip    , start  ,skip   , 

/*  bknum3 STATE: */

bknum3 ,skip   , bknum3 ,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , wrong  ,report , wrong  ,report , wrong  ,report , 
wrong  ,report , bknum3 ,skip   , start  ,skip   ,

/*  loadmem STATE: */

loadmem,skip   , loadmem,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , addrhi ,addr1  , wrong  ,report , wrong  ,report , 
wrong  ,report , loadmem,skip   , wrong  ,report , 

/*  addrhi STATE: */

addrhi ,skip   , addrhi ,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , addrlo ,addr2  , wrong  ,report , wrong  ,report , 
wrong  ,report , addrhi ,skip   , wrong  ,report , 

/*  addrlo STATE: */

addrlo ,skip   , addrlo ,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , bytes  ,membyt , wrong  ,report , wrong  ,report , 
wrong  ,report , addrlo ,skip   , wrong  ,report , 

/*  bytes STATE: */

bytes  ,skip   , bytes  ,skip   , wrong  ,report , wrong  ,report , 
wrong  ,report , bytes  ,membyt , wrong  ,report , wrong  ,report , 
wrong  ,report , bytes  ,skip   , start  ,skip   , 

/*  endstmt STATE: */

STOP   ,skip   , STOP   ,skip   , STOP   ,skip   , STOP   ,skip   , 
STOP   ,skip   , STOP   ,skip   , STOP   ,skip   , STOP   ,skip   , 
STOP   ,skip   , STOP   ,skip   , STOP   ,skip   , 

/*  wrong STATE: */

start  ,skip   , start  ,skip   , reg_def,skip   , STOP   ,skip   , 
STOP   ,skip   , STOP   ,skip   , bkpt   ,skip   , loadmem,skip   , 
endstmt,skip   , start  ,skip   , STOP   ,skip    
	
};


PRIVATE struct Window *status = NULL;

PRIVATE void cleanup( void )
{
   if (status != NULL)
      CloseWindow( status );

   Z80SimCloseWindow();
   CloseDownScreen();
   CloseLibs();
   FreeupData();

   return;
}

PRIVATE void  error( char *str )
{
   SetReqButtons( "YES|NO" );

   if (Handle_Problem( str, "Wanna quit?", NULL ) == 0)
      {
      cleanup();
      exit( 35 );
      }

   SetReqButtons( "CONTINUE|ABORT" );

   return;
}

/* Code for FSM Start_Function(): */

PRIVATE int	mstate, token;

/****h* Z80Simulator/File_Loader() **********************************
*
* NAME
*    File_Loader()
*********************************************************************
*
*/

VISIBLE int File_Loader( char *filename, struct Window *statuswindow )
{
   IMPORT int yy_init;
    
   mstate  = start;
   token   = EMPTY;
   yy_init = ~0;        // Make sure that yylex() initializes everything.
   
   status = statuswindow;
   
   if ((yyin = fopen( filename, "r" )) == NULL)
      {
      fprintf( stderr, "Couldn't open %s for loading!\n", filename );
      error( "Couldn't open the configuration file!" );

      return( -1 );
      }

   do {
      token  = yylex();

      (*fsm_table[ mstate ][ token ].act)();

      mstate = fsm_table[ mstate ][ token ].nextstate;
   
   }  while (mstate != STOP);

   return( 0 );
}

PRIVATE void  report( void )
{
   SetReqButtons( "QUIT!|NO" );

   if (Handle_Problem( "Illegal input in config file!!",
                       "Wanna quit?", NULL ) == 0)
      {
      cleanup();
      exit( 121 );
      }

   SetReqButtons( "CONTINUE|ABORT" );

   return;
}

PRIVATE void skip( void )   { return; } /* ignore input token */

PRIVATE void Add_Byt( void )            /* Add byte of a register def'n */
{                                       /* to the regbytes array        */
   if (reg_defn_count >= LASTREGBYTE)
      return;
   else   
      {
      regbytes[ reg_defn_count++ ] = loadfile_buff[0];
      regbytes[ reg_defn_count++ ] = loadfile_buff[1];
      }

   return;
}

/* Convert the two supplied characters to a byte value: */

PRIVATE int chs_to_byte( char ch1, char ch2 )
{
   int   rval = 0;

   ch1 = toupper( ch1 );
   ch2 = toupper( ch2 );

   if (ch1 >= '0' && ch1 <= '9')
      rval = ch1 - '0';
   else if (ch1 >= 'A' && ch1 <= 'F')
      rval = ch1 - 'A' + 10;

   rval <<= 4;
 
   if (ch2 >= '0' && ch2 <= '9')
      rval += ch2 - '0';
   else if (ch2 >= 'A' && ch2 <= 'F')
      rval += ch2 - 'A' + 10;

   return( rval );
}

/* BrkRegNum() - change the next two characters into a byte that
** corresponds to the Z80 registers as follows:
**
**  A  - 0   E  - 8   I   - 16  IX - 24
**  AP - 1   EP - 9   R   - 17  IY - 25
**  B  - 2   H  - 10  BC  - 18  SP - 26
**  BP - 3   HP - 11  BCP - 19  PC - 27
**  C  - 4   L  - 12  DE  - 20
**  CP - 5   LP - 13  DEP - 21
**  D  - 6   F  - 14  HL  - 22
**  DP - 7   FP - 15  HLP - 23
*/

PRIVATE void BrkRegNum( void )
{
   bkpt_reg    = chs_to_byte( loadfile_buff[0], loadfile_buff[1] );

   break_pt[0] = loadfile_buff[0];
   break_pt[1] = loadfile_buff[1];

   return;
}

/* 8-bit register value to break on: */

PRIVATE void BrkByte1( void )
{
   IMPORT void MakeBreakString( int whichreg, int value );
    
   int brkvalue = 0, errnum = 200;
    
   break_pt[2] = loadfile_buff[0];
   break_pt[3] = loadfile_buff[1];
   break_pt[4] = '\0';

   (void) stch_i( &break_pt[2], &brkvalue );

   if (bkpt_reg < REGBC && bkpt_reg >= A)
      MakeBreakString( bkpt_reg,  brkvalue );

   return;
}

/* Must be a 16-bit register to set up a breakpoint for: */

/* NOTE:  the only 16-bit registers that are recognized by
**        the rest of the breakpoint code are:
**        IX, IY, SP & PC.
*/

PRIVATE void BrkByte2( void )
{
   IMPORT void MakeBreakString( int whichreg, int value );
    
   int brkvalue = 0, errnum = 200;
    
   if (bkpt_reg >= REGBC && bkpt_reg <= REGPC) // Double register pair:
      {
      break_pt[4] = loadfile_buff[0];
      break_pt[5] = loadfile_buff[1];
      break_pt[6] = '\0';

      (void) stch_i( &break_pt[2], &brkvalue );
      
      MakeBreakString( bkpt_reg,  brkvalue );
      }

   return;
}
       
PRIVATE void addr1( void )  /* high byte of load address */
{
   loadaddr = (chs_to_byte( loadfile_buff[0], loadfile_buff[1] ) << 8);
   return;
}

PRIVATE void addr2( void )  /* low byte of load address */
{  
   int   temp = 0;

   temp      = chs_to_byte( loadfile_buff[0], loadfile_buff[1] );
   loadaddr += temp;
   return;
}

PRIVATE void membyt( void ) /* byte to store in mem[ loadaddr ] */
{
   IMPORT UBYTE *mem;

   mem[ loadaddr++ ] = chs_to_byte( loadfile_buff[0], loadfile_buff[1] );
   return;
}

/* ---------------- End of Z80Loader.c Code Section! ---------------- */
