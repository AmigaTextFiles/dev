/****h* Z80Simulator/Z80S1.c [2.5] **************************************
*
* NAME
*    Z80S21.C
*
* NOTES
*    EXTERNAL CALLS: Functions      in Z80Mach.c
*                    decode_mach3() in Z80ST3.c
*                    Output_Code()  in Z80Code.c
*
* DESCRIPTION
*    More State Machine decoding for the tabulated instructions.
*
* SYNOPSIS
*    rval = X_Index( int state2 )
*
*    PARAMETERS:    state2 - The 2nd byte (mem[dreg[PC] + 1])
*                            of the machine code.
*
* RETURNS
*    Integer = processor status.
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

#define   IXBYTE   0xDD

IMPORT UBYTE   *mem;
IMPORT UBYTE   reg[];
IMPORT UWORD   dreg[];

IMPORT BOOL sregchanged[], dregchanged[];

int   X_Index( int state2 )
{
   UWORD addrx;
   int   status, temp, oper, b3, b4, B3, B4, RGH;

   b3     = mem[ dreg[PC] + 2 ];       
   B3     = b3;

   b4     = mem[ dreg[PC] + 3 ] << 8; 
   B4     = mem[ dreg[PC] + 3 ];

   RGH    = reg[H] << 8;             
   addrx  = add_displ( IX, b3 );
   status = RUNNING;

   sregchanged[F] = FALSE;

   switch (state2)   
      {
      case 9: case 25: case 41:             /* ADD IX,dreg */
         oper = ((state2 - 9) / 16) + 4;

         if (state2 != 41)  
            {
            Output_Code( "ADD IX,", dreg[PC], INDX3, oper,
                          -1, IXBYTE, state2, -1, -1 
                       );

            add_indx( IX, oper );
            }
         else  
            {
            Output_Code( "ADD IX,IX", dreg[PC], IMPL, -1,
                         -1, IXBYTE, 41, -1, -1 
                       );

            add_indx( IX, IX );
            }
         break;

      case 33:  
         if (dreg[IX] != (b3 + b4))
            dregchanged[IX] = TRUE;
         else
            dregchanged[IX] = FALSE;
            
         dreg[IX] = b3 + b4;                  /* LD IX,aa */
         Output_Code( "LD IX,", dreg[PC], INDX4, -1,
                      -1, IXBYTE, 33, B3, B4 
                    );

         INCPC( 2 );
         break;

      case 34:                                       /* LD (aa),IX */
         mem[ b3 + b4 ]     = get_low_word( IX );
         mem[ b3 + b4 + 1 ] = get_high_word( IX );

         Output_Code( "LD ", dreg[PC], INDX2, -1, -1, 
                      IXBYTE, 34, B3, B4 
                    );

         INCPC( 2 );
         break;
         
      case 35:  
         Output_Code( "INC IX", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 35, -1, -1 
                    );

         dreg[IX]++;
         dregchanged[IX] = TRUE;

         break;
         
      case 42:  /* LD IX,(aa) */
         if (dreg[IX] != (mem[ b3 + b4 ] + (mem[ b3 + b4 + 1 ] << 8)))
            dregchanged[IX] = TRUE;
         else
            dregchanged[IX] = FALSE;

         dreg[IX] = mem[ b3 + b4 ] + (mem[ b3 + b4 + 1 ] << 8);

         Output_Code( "LD IX,", dreg[PC], INDX2, -2, -1, 
                      IXBYTE, 42, B3, B4 
                    );

         INCPC( 2 );
         break;
 
      case 43:  
         Output_Code( "DEC IX", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 43, -1, -1 
                    );

         dreg[IX]--;
         dregchanged[IX] = TRUE;

         break;

      case 52:                              /* INC (IX + d) */
         inc_mem( addrx );
         Output_Code( "INC ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 52, B3, -1 
                    );

         INCPC( 1 );
         break;

      case 53:                              /* DEC (IX + d) */
         dec_mem( addrx );
         Output_Code( "DEC ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 53, B3, -1 
                    );

         INCPC( 1 );
         break;

      case 54:                             /* LD (IX + d),n */
         mem[ addrx ] = mem[ dreg[PC] + 3];
         Output_Code( "LD ", dreg[PC], INDX1, 0, -2, IXBYTE, 54, B3, B4 );
         INCPC( 2 );
         break;

      case 57:
         Output_Code( "ADD IX,SP", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 57, -1, -1
                    );

         add_indx( IX, SP );
         break;

      case 70: case 78:  case 86:
      case 94: case 102: case 110:         /* LD r,(IX + d) */
         temp        = ((state2 - 70) / 8) * 2 + 2;
         
         if (reg[temp] != mem[addrx])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] = mem[ addrx ];

         Output_Code( "LD ", dreg[PC], INDX2, temp, -1, 
                      IXBYTE, state2, B3, -1
                    );

         INCPC( 1 );
         break;

      case 112: case 113: case 114:
      case 115: case 116: case 117:        /* LD (IX + d),r */
         temp         = (state2 - 111) * 2;
         mem[ addrx ] = reg[ temp ];

         Output_Code( "LD ", dreg[PC], INDX1, 0, temp, 
                      IXBYTE, state2, B3, -1
                    );

         INCPC( 1 );
         break;

      case 119:                            /* LD (IX + d),A */
         mem[ addrx ] = reg[A];
         Output_Code( "LD ", dreg[PC], INDX1, A, 0, IXBYTE, 119, B3, -1 );
         INCPC( 1 );
         break;

      case 126:                            /* LD A,(IX + d) */
         if (reg[A] != mem[addrx])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
             
         reg[A] = mem[ addrx ];
         Output_Code( "LD ", dreg[PC], INDX2, 0, -1, IXBYTE, 126, B3, -1 );
         INCPC( 1 );
         break;

      case 134:
         Output_Code( "ADD ", dreg[PC], INDX2, A, -1, 
                      IXBYTE, 134, B3, -1 
                    );

         add_regs( A, mem[ addrx ], M );           /* ADD A,(IX + d) */
         break;

      case 142:
         Output_Code( "ADC ", dreg[PC], INDX2, A, -1, 
                      IXBYTE, 142, B3, -1 
                    );

         adc_reg( A, mem[ addrx ], M );            /* ADC A,(IX + d) */
         break;

      case 150:
         Output_Code( "SUB ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 150, B3, -1 
                    );

         sub_regs( A, mem[ addrx ], M );           /* SUB (IX + d) */
         break;

      case 158:
         Output_Code( "SBC ", dreg[PC], INDX2, A, -1, 
                      IXBYTE, 158, B3, -1 
                    );
         sbc_reg( A, mem[ addrx ], M );            /* SBC A,(IX + d) */
         break;

      case 166:
         Output_Code( "AND ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 166, B3, -1 
                    );

         log_reg( mem[ addrx ], AND, M );          /* AND (IX + d) */
         break;
         
      case 174:
         Output_Code( "XOR ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 174, B3, -1 
                    );

         log_reg( mem[ addrx ], XOR, M );          /* XOR (IX + d) */
         break;

      case 182:
         Output_Code( "OR ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 182, B3, -1 
                    );

         log_reg( mem[ addrx ], OR, M );           /* OR  (IX + d) */
         break;

      case 190:
         Output_Code( "CP ", dreg[PC], INDX5, -1, -1, 
                      IXBYTE, 190, B3, -1 
                    );

         log_reg( mem[ addrx ], CP, M );           /* CP  (IX + d) */
         break;

      case 203: 
         status = decode_mach3( B4, IX );
         INCPC( 2 );
         break;
         
      case 225: 
         temp = mem[dreg[SP]] + (mem[dreg[SP + 1]] << 8);
         
         Output_Code( "POP IX", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 225, -1, -1 
                    );

         if (dreg[IX] != temp)
            dregchanged[IX] = TRUE;
         else
            dregchanged[IX] = FALSE;
                     
         dreg[IX]  = mem[ dreg[SP] ];        /* LSB of IX */
         dreg[SP]++;
         
         dreg[IX] += (mem[ dreg[SP] ] << 8); /* MSB of IX */
         dreg[SP]++;

         dregchanged[SP] = TRUE;

         break;

      case 227:
         temp = mem[dreg[SP]] + (mem[dreg[SP + 1]] << 8);

         if (dreg[IX] != temp)
            dregchanged[IX] = TRUE;
         else
            dregchanged[IX] = FALSE;
            
         Output_Code( "EX (SP),IX", dreg[PC], IMPL,-1,-1, 
                      IXBYTE, 227,-1,-1 
                    );

         temp                = mem[ dreg[SP] ];
         mem[ dreg[SP] ]     = get_low_word( IX );
         dreg[IX]            = temp;

         temp                = mem[ dreg[SP] + 1 ];
         mem[ dreg[SP] + 1 ] = get_high_word( IX );
         dreg[IX]           += (temp << 8);
         break;

      case 229:
         Output_Code( "PUSH IX", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 229, -1, -1
                    );

         dreg[SP]--;
         mem[ dreg[SP] ] = get_high_word( IX );

         dreg[SP]--;
         mem[ dreg[SP] ] = get_low_word( IX );

         dregchanged[SP] = TRUE;

         break;

      case 233:
         Output_Code( "JP (IX)", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 233, -1, -1
                    );

         dreg[PC] = dreg[IX];
         status   = SKIP_INC;
         break;

      case 249:
         Output_Code( "LD SP,IX", dreg[PC], IMPL, -1, -1, 
                      IXBYTE, 249, -1, -1
                    );

         if (dreg[IX] != dreg[SP])
            dregchanged[SP] = TRUE;
         else
            dregchanged[SP] = FALSE;
            
         dreg[SP] = dreg[IX];  
         break;
         
      default:
         ILLEGAL();

      }  /* END OF X_Index() SWITCH TABLE!! */

   dregchanged[PC] = TRUE;
   
   return( (int) status);
}

/* ---------------------- End of Z80S21.c ----------------------- */
