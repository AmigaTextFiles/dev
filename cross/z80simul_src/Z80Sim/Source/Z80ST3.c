/****h* Z80Simulator/Z80ST3.c [2.5] ************************************
*
* NAME
*    Z80ST3.c
*
* NOTES
*    EXTERNAL CALLS:  Output_Code()  in CPGM/Z80Code.c
*
* DESCRIPTION
*    The state machine code for the Z80 processor simulator program.
*
* HISTORY
*    21-Apr-2001 - Added code to highlight register value changes.
*
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include "Z80Sim.h"
#include "Z80Code.h"
#include "Z80FuncProtos.h"

#define   IYBYTE   0xFD
#define   IXBYTE   0xDD

IMPORT UBYTE *mem, status, reg[];
IMPORT UWORD dreg[];
IMPORT BOOL  sregchanged[];

UBYTE  Convert_2_Number( int bitnum )
{
   UBYTE rval;

   if (bitnum == 0)  
      return 1;
   
   rval = (1 << bitnum);
   
   return( rval );
}

VISIBLE int decode_mach3( int state4, int indx )
{
   UWORD eff_addr = 0, addrx, addry;
   int   bitnum, number, b3, b4, B3, B4;

   status = RUNNING;

   b3     = mem[ dreg[PC] + 2 ];
   b4     = 256 * mem[ dreg[PC] + 3 ];

   B3     = b3;
   B4     = mem[ dreg[PC] + 3 ];

   addrx  = add_displ( IX, b3 );
   addry  = add_displ( IY, b3 );

   switch( indx )  
      {
      case IX:
         switch( state4 )  
            {
            case 6:  
               Output_Code( "RLC ", dreg[PC], INDX5, -1, -1, IXBYTE, 
                            203, B3, 6
                          );

               rlc_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;

            case 14: 
               Output_Code( "RRC ", dreg[PC], INDX5, -1, -1, IXBYTE,
                            203, B3, 14
                          );

               rrc_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;

            case 22: 
               Output_Code( "RL ", dreg[PC], INDX5, -1, -1, IXBYTE,
                            203, B3, 22
                          );

               rl_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;
 
            case 30: 
               Output_Code( "RR ", dreg[PC], INDX5, -1, -1, IXBYTE,
                            203, B3, 30 
                          );

               rr_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;

            case 38: 
               Output_Code( "SLA ", dreg[PC], INDX5, -1, -1, IXBYTE,
                            203, B3, 38
                          );

               sla_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;

            case 46: 
               Output_Code( "SRA ", dreg[PC], INDX5, -1, -1, IXBYTE,
                            203, B3, 46
                          );

               sra_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;

            case 62: 
               Output_Code( "SRL ", dreg[PC], INDX5, -1, -1, IXBYTE,
                            203, B3, 62
                          );

               srl_reg( mem[ addrx ], M );
               INCPC( 2 );
               break;

            case 70:  case 78:  case 86:  case 94:    /* BIT n,(IX+d) */
            case 102: case 110: case 118: case 126:
               bitnum = (state4 - 70) / 8;

               Output_Code( "BIT ", dreg[PC], BITA, bitnum, -2, IXBYTE,
                             203, B3, B4 
                          );

               SETHALF();  RESETNEG();

               eff_addr = add_displ( IX, b3 );
               number   = Convert_2_Number( bitnum );

               if ((mem[ eff_addr ] & number) == 0)
                  SETZERO();
               else
                  RESETZERO();
               
               sregchanged[F] = TRUE;
               break;

            case 134: case 142: case 150: case 158:   /* RES n,(IX+d) */
            case 166: case 174: case 182: case 190:
               bitnum = (state4 - 134) / 8;

               Output_Code( "RES ", dreg[PC], BITA, bitnum,
                             -2, IXBYTE, 203, B3, B4 
                          );

               eff_addr         = add_displ( IX, b3 );
               number           = Convert_2_Number( bitnum );
               mem[ eff_addr ] &= (~number);
               break;

            case 198: case 206: case 214: case 222:   /* SET n,(IX+d) */
            case 230: case 238: case 246: case 254:
               bitnum = (state4 - 198) / 8;

               Output_Code( "SET ", dreg[PC], BITA, bitnum,
                             -2, IXBYTE, 203, B3, B4 
                          );

               eff_addr         = add_displ( IX, b3 );
               number           = Convert_2_Number( bitnum );
               mem[ eff_addr ] |= number;
               break;

            default: 
               ILLEGAL();
            }                  /* end of IX table!! */
         break;

      case IY:
         switch( state4 )  
            {
            case 6:  
               Output_Code( "RLC ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 6 
                          );

               rlc_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
            case 14: 
               Output_Code( "RRC ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 14 
                          );

               rrc_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
            case 22: 
               Output_Code( "RL ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 22 
                          );

               rl_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
            case 30: 
               Output_Code( "RR ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 30 
                          );
 
               rr_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
            case 38: 
               Output_Code( "SLA ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 38
                          );

               sla_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
            case 46: 
               Output_Code( "SRA ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 46 
                          );

               sra_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
            case 62: 
               Output_Code( "SRL ", dreg[PC], INDY5, -1, -1, IYBYTE,
                             203, B3, 62 
                          );

               srl_reg( mem[ addry ], M );
               INCPC( 2 );
               break;
               
            case 70:  case 78:  case 86:  case 94:    /* BIT n,(IY+d) */
            case 102: case 110: case 118: case 126:
               bitnum = (state4 - 70) / 8;

               Output_Code( "BIT ", dreg[PC], BITA, bitnum,
                             -3, IYBYTE, 203, B3, B4 
                          );

               SETHALF();  RESETNEG();

               eff_addr = add_displ( IY, b3 );
               number   = Convert_2_Number( bitnum );

               if ((mem[ eff_addr ] & number) == 0)
                  SETZERO();
               else
                  RESETZERO();

               sregchanged[F] = TRUE;
               break;
               
            case 134: case 142: case 150: case 158:   /* RES n,(IY+d) */
            case 166: case 174: case 182: case 190:
               bitnum = (state4 - 134) / 8;

               Output_Code( "RES ", dreg[PC], BITA, bitnum,
                             -3, IYBYTE, 203, B3, B4 
                          );

               eff_addr         = add_displ( IY, b3 );
               number           = Convert_2_Number( bitnum );
               mem[ eff_addr ] &= (~number);
               break;
               
            case 198: case 206: case 214: case 222:   /* SET n,(IY+d) */
            case 230: case 238: case 246: case 254:
               bitnum = (state4 - 198) / 8;

               Output_Code( "SET ", dreg[PC], BITA, bitnum,
                             -3, IYBYTE, 203, B3, B4
                          );

               eff_addr         = add_displ( IY, b3 );
               number           = Convert_2_Number( bitnum );
               mem[ eff_addr ] |= number;
               break;
               
            default: 
               ILLEGAL();
            }                  /* end of IY table!! */
         break;
      }

   return( (int) status );
}

/* ----------------------- End of Z80ST3.c ------------------------ */
