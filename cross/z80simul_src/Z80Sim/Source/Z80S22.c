/****h* Z80Simulator/Z80S22.c [2.5] ************************************
*
* NAME
*    Z80S22.C
*
* NOTES
*    EXTERNAL CALLS:  Functions      in Z80Mach.c
*                     decode_mach3() in Z80ST3.c
*                     Output_Code()  in Z80Code.c
*
* DESCRIPTION
*    Decode the IY instructions
*
* SYNOPSIS
*    status = Y_Index( int state2 );
*
*    PARAMETERS:    state2 - The 2nd byte (mem[dreg[PC] + 1])
*                            of the machine code.
*
* RETURNS
*    Integer = processor status.
*
* HISTORY
*    21-Apr-2001 - Added code to highlight register value changes.
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include "Z80Sim.h"
#include "Z80Code.h"
#include "Z80FuncProtos.h"

#define   IYBYTE   0xFD

IMPORT UBYTE   *mem;
IMPORT UBYTE   reg[];
IMPORT UWORD   dreg[];

IMPORT BOOL sregchanged[], dregchanged[];

VISIBLE int Y_Index( int state2 )
{
   UWORD addry;
   int   status, temp, oper, b3, b4, B3, B4;

   b3     = mem[ dreg[PC] + 2 ];       
   B3     = b3;

   b4     = mem[ dreg[PC] + 3 ] << 8; 
   B4     = mem[ dreg[PC] + 3 ];

   addry  = add_displ( IY, b3 );
   status = RUNNING;

   sregchanged[F] = FALSE;   

   switch (state2)   
      {
      case 9: case 25: case 41:             /* ADD IY,dreg */
         oper = ((state2 - 9) / 16) + 4;

         if (state2 != 41)  
            {
            Output_Code( "ADD IY,", dreg[PC], INDY3, oper,
                         -1, IYBYTE, state2, -1, -1 
                       );

            add_indx( IY, oper );
            }
         else  
            {
            Output_Code( "ADD IY,IY", dreg[PC], IMPL, -1, -1,
                         IYBYTE, 41, -1, -1 
                       );

            add_indx( IY, IY );
            }
         break;

      case 33:               /* LD IY,aa */
         if (dreg[IY] != (b3 + b4))
            dregchanged[IY] = TRUE;
         else
            dregchanged[IY] = FALSE;
            
         dreg[IY] = b3 + b4;
         Output_Code( "LD IY,", dreg[PC], INDY4, -1,
                      -1, IYBYTE, 33, B3, B4 
                    );
         INCPC( 2 );
         break;
         
      case 34:                              /* LD (aa),IY */
         mem[ b3 + b4 ]     = get_low_word( IY );
         mem[ b3 + b4 + 1 ] = get_high_word( IY );
         Output_Code( "LD ", dreg[PC], INDY2, -1, -1, IYBYTE, 34, B3, B4 );
         INCPC( 2 );
         break;
         
      case 35:  
         Output_Code( "INC IY", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 35, -1, -1
                    );

         dreg[IY]++;
         dregchanged[IY] = TRUE;
         break;
    
      case 42:                              /* LD IY,(aa) */
         temp = mem[b3 + b4] + (mem[b3 + b4 + 1] << 8);

         if (dreg[IY] != temp)
            dregchanged[IY] = TRUE;
         else
            dregchanged[IY] = FALSE;
            
         dreg[IY] = temp;

         Output_Code( "LD IY,", dreg[PC], INDY2, -2, -1,
                       IYBYTE, 42, B3, B4 
                    );
         INCPC( 2 );
         break;
    
      case 43:  
         Output_Code( "DEC IY", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 43, -1, -1
                    );

         dreg[IY]--;
         dregchanged[IY] = TRUE;
         break;

      case 52:                              /* INC (IY + d) */
         inc_mem( addry );
         Output_Code( "INC ", dreg[PC], INDY5, -1, -1, IYBYTE, 52,B3, -1 );
         INCPC( 1 );
         break;

      case 53:                              /* DEC (IY + d) */
         dec_mem( addry );
         Output_Code( "DEC ", dreg[PC], INDY5, -1, -1, IYBYTE, 53,B3, -1 );
         INCPC( 1 );
         break;

      case 54:                             /* LD (IY + d),n */
         mem[ addry ] = mem[ dreg[PC] + 3];
         Output_Code( "LD ", dreg[PC], INDY1, 0, -2, IYBYTE, 54, B3, B4 );
         INCPC( 2 );
         break;

      case 57:
         Output_Code( "ADD IY,SP", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 57, -1, -1
                    );

         add_indx( IY, SP );
         break;

      case 70: case 78:  case 86:
      case 94: case 102: case 110:         /* LD r,(IY + d) */

         temp = ((state2 - 70) / 8) * 2 + 2;

         if (reg[temp] != mem[addry])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] = mem[ addry ];

         Output_Code( "LD ", dreg[PC], INDY2, temp, -1, 
                      IYBYTE, state2, B3, -1
                    );

         INCPC( 1 );
         break;

      case 112: case 113: case 114:
      case 115: case 116: case 117:        /* LD (IY + d),r */
         temp         = (state2 - 111) * 2;
         mem[ addry ] = reg[ temp ];

         Output_Code( "LD ", dreg[PC], INDY1, 0, temp, 
                      IYBYTE, state2, B3, -1
                    );

         INCPC( 1 );
         break;

      case 119:                            /* LD (IY + d),A */
         mem[ addry ] = reg[A];
         Output_Code( "LD ", dreg[PC], INDY1, A, 0, IYBYTE, 119, B3, -1 );
         INCPC( 1 );
         break;

      case 126:                            /* LD A,(IY + d) */
         if (reg[A] != mem[addry])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] = mem[ addry ];
         Output_Code( "LD ", dreg[PC], INDY2, 0, -1, IYBYTE, 126, B3, -1 );
         INCPC( 1 );
         break;

      case 134:
         Output_Code( "ADD ", dreg[PC], INDY2, A, -1, IYBYTE, 134, B3, -1 );
         add_regs( A, mem[ addry ], M );  /* ADD A,(IY + d) */
         break;

      case 142:
         Output_Code( "ADC ", dreg[PC], INDY2, A, -1, IYBYTE, 142, B3, -1 );
         adc_reg( A, mem[ addry ], M );   /* ADC A,(IY + d) */
         break;

      case 150:
         Output_Code( "SUB ", dreg[PC], INDY5, -1, -1, IYBYTE,150, B3, -1 );
         sub_regs( A, mem[ addry ], M );  /* SUB (IY + d) */
         break;

      case 158:
         Output_Code( "SBC ", dreg[PC], INDY2, A, -1, IYBYTE, 158,B3, -1 );
         sbc_reg( A, mem[ addry ], M );   /* SBC A,(IY + d) */
         break;

      case 166:
         Output_Code( "AND ", dreg[PC], INDY5, -1, -1, 
                      IYBYTE, 166, B3, -1
                    );

         log_reg( mem[ addry ], AND, M ); /* AND (IY + d) */
         break;

      case 174:
         Output_Code( "XOR ", dreg[PC], INDY5, -1, -1, 
                      IYBYTE, 174, B3, -1
                    );

         log_reg( mem[ addry ], XOR, M ); /* XOR (IY + d) */
         break;

      case 182:
         Output_Code( "OR ", dreg[PC], INDY5, -1, -1, IYBYTE, 182, B3, -1 );
         log_reg( mem[ addry ], OR, M );  /* OR  (IY + d) */
         break;

      case 190:
         Output_Code( "CP ", dreg[PC], INDY5, -1, -1, IYBYTE, 190, B3, -1 );
         log_reg( mem[ addry ], CP, M );  /* CP  (IY + d) */
         break;

      case 203: 
         status = decode_mach3( B4, IY );
         INCPC( 2 );
         break;
         
      case 225: 
         temp = mem[ dreg[SP] ] + (mem[ dreg[SP + 1] ] << 8);
         
         if (dreg[IY] != temp)
            dregchanged[IY] = TRUE;
         else
            dregchanged[IY] = FALSE;
            
         Output_Code( "POP IY", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 225, -1, -1
                    );

         dreg[IY]  = mem[ dreg[SP] ]; 
         dreg[SP]++;
         dreg[IY] += (mem[ dreg[SP] ] << 8);
         dreg[SP]++;

         dregchanged[SP] = TRUE;
         break;

      case 227:
         temp = mem[ dreg[SP] ] + (mem[ dreg[SP] + 1 ] << 8);
         
         if (dreg[IY] != temp)
            dregchanged[IY] = TRUE;
         else
            dregchanged[IY] = FALSE;
            
         Output_Code( "EX (SP),IY", dreg[PC], IMPL,-1,-1, 
                      IYBYTE, 227, -1, -1
                    );
         temp                = mem[ dreg[SP] ];
         mem[ dreg[SP] ]     = get_low_word( IY );
         dreg[IY]            = temp;

         temp                = mem[ dreg[SP] + 1 ];
         mem[ dreg[SP] + 1 ] = get_high_word( IY );
         dreg[IY]           += (temp << 8);
         break;

      case 229:
         Output_Code( "PUSH IY", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 229, -1, -1
                    );

         dreg[SP]--;
         mem[ dreg[SP] ] = get_high_word( IY );

         dreg[SP]--;
         mem[ dreg[SP] ] = get_low_word( IY );

         dregchanged[SP] = TRUE;
         break;

      case 233:
         Output_Code( "JP (IY)", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 233, -1, -1
                    );

         dreg[PC] = dreg[IY];
         status   = SKIP_INC;
         break;

      case 249:
         Output_Code( "LD SP,IY", dreg[PC], IMPL, -1, -1, 
                      IYBYTE, 249, -1, -1
                    );

         if (dreg[SP] != dreg[IY])
            dregchanged[SP] = TRUE;
         else
            dregchanged[SP] = FALSE;
            
         dreg[SP] = dreg[IY];  
         break;
         
      default:
         ILLEGAL();

      }  /* ------- END OF IY SWITCH TABLE!! ------- */

   dregchanged[PC] = TRUE;

   return( (int) status);
}

/* --------------------- End of Z80S22.c ------------------------ */
