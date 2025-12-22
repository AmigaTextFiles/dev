/*******************************************************************
** Z80FuncProtos.h   Function prototypes for all of the functions
**                   used in the Z80Simulator & supporting
**                   programs.
**
*******************************************************************/

#ifndef  UBYTE
#include <exec/types.h>
#endif

/* ------- From Z80SimGTGUI.c: ---------------------------------- */

VISIBLE void  CloseDownScreen( void );
VISIBLE int   Z80SimCloseWindow( void );
VISIBLE int   main( int argc, char **argv );

/* ------- From AddressRange.c: --------------------------------- */

PUBLIC int HandleAddrRange( void );

/* ------- From ClearBrkPt.c: ----------------------------------- */

PUBLIC int HandleClearBreakPt( void );

/* ------- From DumpMem.c: -------------------------------------- */

PUBLIC int HandleDumpReq( void );

/* ------- From DumpStack.c: ------------------------------------ */

PUBLIC int HandleStackReq( void );

/* ------- From FillMem.c: -------------------------------------- */

PUBLIC int HandleFillMemReq( void );

/* ------- From IM0Req.c: --------------------------------------- */

PUBLIC int HandleIM0Req( void );

/* ------- From IM2Req.c: --------------------------------------- */

PUBLIC int HandleIM2Req( int IRegister );

/* ------- From PrintListing.c: --------------------------------- */

PUBLIC int HandlePrintListing( void );

/* ------- From SetBrkPt.c: ------------------------------------- */

PUBLIC int HandleSetBreakPt( void );

/* ------- From SetRegister.c: ---------------------------------- */

PUBLIC int HandleSetRegister( void );

/* ------- From ShowBrkPt.c: ------------------------------------ */

PUBLIC int HandleShowBreakPt( void );

/* ------- From Z80Code.c: -------------------------------------- */

PUBLIC void  Output_Code( char *mnem, UWORD addr, int mode, int op1, 
                          int op2, int b1, int b2, int b3, int b4 );

/* ------- From Z80Console.c: ----------------------------------- */

#ifdef   Z80CONSOLE_C

PUBLIC struct Console  *AttachConsole( struct Window *window, char *name );
PUBLIC void            ConDumps( struct Console *console, char *string );
PUBLIC void            ConDumpc( struct Console *console, char ch );
PUBLIC int             ConGetc( struct Console *console );
PUBLIC void            DetachConsole( struct Console *console );

#endif

/* ------- From Z80Loader.c: ----------------------------------- */

PUBLIC int   File_Loader( char *filename, struct Window *status );

/* ------- From Z80Mach.c: ------------------------------------- */

PUBLIC UBYTE    get_high_word( int drg );
PUBLIC UBYTE    get_low_word( int drg );
PUBLIC UWORD    add_displ( unsigned int indx, unsigned int displ );
PUBLIC int      Set_High_Low( int drg_index, UBYTE *high, UBYTE *low );
PUBLIC int      Reset_SRegs( int drg_index, UBYTE high, UBYTE low );
PUBLIC void     add_indx( int x, int val );
PUBLIC void     negate( void );
PUBLIC void     add_dbl( int drg );
PUBLIC void     adc_dreg( int dr, int val );
PUBLIC void     sbc_dreg( int dr, int val );
PUBLIC void     inc_mem( UWORD addr );
PUBLIC void     dec_mem( UWORD addr );
PUBLIC void     compare_reg( int val );     /* called by decode_mach2() */
PUBLIC void     inc_reg( int r );
PUBLIC void     dec_reg( int r );
PUBLIC void     inc_dreg( int rh, int rl );
PUBLIC void     dec_dreg( int rh, int rl );
PUBLIC void     setup_flags( int num );
PUBLIC void     sla_reg( int var, int type );
PUBLIC void     sra_reg( int var, int type );
PUBLIC void     srl_reg( int var, int type );
PUBLIC void     rlc_reg( int var, int type );
PUBLIC void     rl_reg( int var, int type );
PUBLIC void     rrc_reg( int var, int type );
PUBLIC void     rr_reg( int var, int type );
PUBLIC void     add_regs( int r1, int r2, int type );
PUBLIC void     adc_reg( int r1, int r2, int type );
PUBLIC void     sub_regs( int r1, int r2, int type );
PUBLIC void     sbc_reg( int r1, int r2, int type );
PUBLIC void     log_reg( int r, int op, int type );

/* ------- From Z80S21.c: ------------------------------------ */

VISIBLE int   X_Index( int state2 );

/* ------- From Z80S22.c: ------------------------------------ */

VISIBLE int   Y_Index( int state2 );

/* ------- From Z80S23.c: ------------------------------------ */

VISIBLE int   Misc_Inst( int state2 );

/* ------- From Z80S24.c: ------------------------------------ */

VISIBLE int   Logical_Bits( int state2 );

/* ------- From Z80ST1.c: ------------------------------------ */

PUBLIC void  ADD_REL( UBYTE disp );
PUBLIC void  Push( int b1, int b2 ); /* store 2 bytes on the Z80 stack! */
PUBLIC void  Pop( int b2, int b1, int type );  
/* get 2 bytes from the Z80 stack! */

VISIBLE int   decode_mach( int state );

/* ------- From Z80ST2.c: ------------------------------------ */

VISIBLE int   decode_mach2( int state2, int table );

/* ------- From Z80ST3.c: ------------------------------------ */

PUBLIC UBYTE Convert_2_Number( int bitnum );
PUBLIC int   decode_mach3( int state4, int indx );
