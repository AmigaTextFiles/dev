/****h* Z80Simulator/Z80S23.c [2.5] ************************************
*
* NAME
*    Z80S23.C
*
* NOTES
*    EXTERNAL CALLS:  Functions     in Z80Mach.c
*                     setup_flags() in Z80Mach.c
*                     Output_Code() in Z80Code.c
*                     ShowPort(),   input_mem() & input_reg()
*                                   in Z80Port.c
*                     Update_Regs() in Z80S.c
*
* DESCRIPTION
*    Decode the misc' ED instructions.
*
* SYNOPSIS
*    int status = Misc_Inst( int state2 );
*
*    PARAMETERS:    state2 - The 2nd byte (mem[dreg[PC] + 1])
*                            of the machine code.
*
* RETURNS
*    Integer status of processor.
*
* HISTORY
*    21-Apr-2001 - Added code to highlight register value changes.
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include "Z80Sim.h"
#include "Z80Code.h"
#include "Z80FuncProtos.h"

IMPORT UBYTE   *mem;
IMPORT UBYTE   imode, reg[];
IMPORT UBYTE   IFF1_2;
IMPORT UWORD   dreg[], temp_PC;

IMPORT BOOL    sregchanged[], dregchanged[];

/* decode state2 first, then perform the opcode.  If byte3 &/or byte4 are
** used, then increment dreg[PC] accordingly.  dreg[PC] is incremented for
** ED & state2 upon return to decode_mach() function in Z80ST1.c
*/

VISIBLE int Misc_Inst( int state2 )
{
   int  status, temp, oper, b3, b4, B3, B4, HL_addr, DE_addr;

   b3 = mem[ dreg[PC] + 2 ];
   B3 = b3;

   b4 = 256 * mem[ dreg[PC] + 3 ];
   B4 = mem[ dreg[PC] + 3 ];

   HL_addr = 256 * reg[H] + reg[L];
   DE_addr = 256 * reg[D] + reg[E];

   status         = RUNNING;
   sregchanged[F] = FALSE;   

   switch( state2 )   
      {
      case 64: case 72: case 80:              /* IN r,(C) */
      case 88: case 96: case 104:
         {
         int rval = 0;
         
         temp = ((state2 - 64) / 8) * 2 + 2;
         Output_Code( "IN ", dreg[PC], REGA3, temp, -1,237,state2,-1,-1);
         rval = HandleInPort();
         if (rval < 0)
            Handle_Problem( "Couldn't open IN() Requester!", 
                            "Z80 IN r,(C) Port Problem!", &rval 
                          );
         else if (rval < 256)
            temp = rval & 0x000000FF;
         else 
            temp = 0;
         }
         break;

      case 65: case 73: case 81:              /* OUT (C),r */
      case 89: case 97: case 105:
         temp = ((state2 - 65) / 8) * 2 + 2;
         Output_Code( "OUT (C),", dreg[PC], REGA3,-1, temp, 237, state2,-1,-1);
         (void) HandleOutPort( reg[C], reg[ temp ] );
         break;

      case 66: case 82: case 98:          /* SBC HL,dreg */
         temp = ((state2 - 66) / 16) + 4;
         Output_Code( "SBC HL,", dreg[PC], REGD2, -1, temp, 237, state2,-1,-1);
         sbc_dreg( HL, temp );
         break;

      case 67: case 83:                   /* LD (aa),dreg */
         temp = ((state2 - 67) / 16) + 4;
         mem[ b3 + b4 ]    = reg[ temp + 2 ];
         mem[ b3 + b4 + 1] = reg[ temp ];
         Output_Code( "LD ", dreg[PC], EXTI1, -1, temp, 237, state2, B3, B4 );
         INCPC( 2 );
         break;

      case 68:
         Output_Code( "NEG", dreg[PC], IMPL, -1, -1, 237, 68, -1, -1 );
         negate();
         break;

      case 69:
         Output_Code( "RETN", dreg[PC], IMPL, -1, -1, 237, 69, -1, -1 );

         if ((IFF1_2 & IFF2) == IFF2)
            {
            SETIFF1();        // Enable interrupts again!
            RESETIFF2();
            }
         else
            RESETIFF1();

         INCPC( 2 );

         temp_PC = dreg[PC];

         Pop( PC, PC, DRG );

         status = RETURN_FOUND;
         break;

      case 70:
         Output_Code( "IM 0", dreg[PC], IMPL, -1, -1, 237, 70, -1, -1 );
         imode = 0;
         break;

      case 71: case 79:                   /* LD r',A */
         temp = ((state2 - 71) / 8) + I;
         Output_Code( "LD ", dreg[PC], REGA4, temp, A, 237, state2, -1, -1 );
         
         if (reg[temp] != reg[A])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] = reg[A];  
         break;
         
      case 74: case 90: case 106:         /* ADC HL,dreg */
         temp = ((state2 - 74) / 16) + 4;
         Output_Code( "ADC HL,", dreg[PC], REGD2, -1, temp, 237, state2,-1,-1);
         adc_dreg( HL, temp );
         break;

      case 75: case 91:                   /* LD dreg,(aa) */
         temp = ((state2 - 75) / 16) + 4;
         
         if (reg[temp + 2] != mem[ b3 + b4])
            sregchanged[temp + 2] = TRUE;
         else
            sregchanged[temp + 2] = FALSE;
            
         reg[ temp + 2 ] = mem[ b3 + b4 ];

         if (reg[temp] != mem[ b3 + b4 + 1])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ]     = mem[ b3 + b4 + 1 ];

         Output_Code( "LD ", dreg[PC], EXTI2, temp, 0, 237, state2, B3, B4 );
         INCPC( 2 );
         break;

      case 77:
         Output_Code( "RETI", dreg[PC], IMPL, -1, -1, 237, 77, -1, -1 );
         INCPC( 2 );
         temp_PC = dreg[PC];

         Pop( PC, PC, DRG );

         status = RETURN_FOUND;
         break;

      case 86:
         Output_Code( "IM 1", dreg[PC], IMPL, -1, -1, 237, 86, -1, -1 );
         imode = 1;
         break;

      case 87: case 95:                   /* LD A,r' */
         temp = ((state2 - 87) / 8) + I;
         Output_Code( "LD A,", dreg[PC], REGA2, A, temp, 237, state2,-1, -1 );

         if (reg[A] != reg[temp])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] = reg[ temp ];
         break;

      case 94:
         Output_Code( "IM 2", dreg[PC], IMPL, -1, -1, 237, 94, -1, -1 );
         imode = 2;
         break;

      case 103:                           /* RRD */
         RESETHALF(); 
         RESETNEG();
         sregchanged[F] = TRUE;
         
         Output_Code( "RRD", dreg[PC], IMPL, -1, -1, 237, 103, -1, -1 );

         temp             = reg[A];  
         oper             = mem[ HL_addr ];

         if (oper != 0)
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
             
         reg[A]           =  reg[A] & 0xF0;
         reg[A]          += (oper & 0x0F);

         mem[ HL_addr ] >>= 4;
         mem[ HL_addr ]  +=  ((temp & 0x0F) << 4);

         setup_flags( reg[A] );
         break;

      case 111:                           /* RLD */
         RESETHALF(); RESETNEG();
         Output_Code( "RLD", dreg[PC], IMPL, -1, -1, 237, 111, -1, -1 );

         temp             = reg[A];  
         oper             = mem[ HL_addr ];

         mem[ HL_addr ] <<= 4;

         if (oper != 0)
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
             
         reg[A]          &= 0xF0;
         reg[A]          += ((oper & 0x0F) >> 4);

         mem[ HL_addr ]  +=  (temp & 0x0F);
         setup_flags( reg[A] );
         break;
         
      case 114:
         Output_Code( "SBC HL,SP", dreg[PC], IMPL, -1, -1, 237, 114, -1, -1 );
         sbc_dreg( HL, SP );
         break;

      case 115:                         /* LD (aa),SP */
         Output_Code( "LD ", dreg[PC], EXTI1, -1, SP, 237, 115, B3, B4 );
         mem[ b3 + b4 ]    = get_low_word( SP );
         mem[ b3 + b4 + 1] = get_high_word( SP );
         INCPC( 2 );
         break;

      case 120:
         {
         int rval = 0;

         Output_Code( "IN A,(C)", dreg[PC], IMPL, -1, -1, 237, 120, -1, -1 );
         rval = HandleInPort();

         if (rval < 0)
            Handle_Problem( "Couldn't open IN() Requester!", 
                            "Z80 IN A,(C) Port Problem!", &rval 
                          );
         else if (rval < 256)
            {
            if (reg[A] != (rval & 0xFF))
               sregchanged[A] = TRUE;
            else
               sregchanged[A] = FALSE;
               
            reg[A] = rval & 0x000000FF;
            }
         else 
            {
            if (reg[A] != 0)
               sregchanged[A] = TRUE;
            else
               sregchanged[A] = FALSE;
               
            reg[A] = 0;
            }
         }
         
         break;

      case 121:                           /* OUT (C),A */
         Output_Code( "OUT (C),A", dreg[PC], IMPL, -1, -1,237,121,-1,-1);
         (void) HandleOutPort( reg[C], reg[A] );
         break;

      case 122:                           /* ADC HL,SP */
         Output_Code( "ADC HL,SP", dreg[PC], IMPL, -1, -1, 237, 122, -1, -1 );
         adc_dreg( HL, SP );
         break;

      case 123:                           /* LD SP,(aa) */
         temp = 256 * mem[b3 + b4] + mem[b3 + b4 + 1];
         
         if (dreg[SP] != temp)
            dregchanged[SP] = TRUE;
         else
            dregchanged[SP] = FALSE;
            
         Output_Code( "LD ", dreg[PC], EXTI2, SP, 0, 237, 123, B3, B4 );
         dreg[SP] = temp;
         INCPC( 2 );
         break;

      case 160:                           /* LDI */
         RESETHALF(); 
         RESETNEG();

         Output_Code( "LDI", dreg[PC], IMPL, -1, -1, 237, 160, -1, -1 );

         mem[ DE_addr ] = mem[ HL_addr ];

         inc_dreg( H, L );
         inc_dreg( D, E );
         dec_dreg( B, C );
         dreg[PC] -= 3;

         if (dreg[BC] != 0)    
            SETPV();
         else
            RESETPV();
         
         sregchanged[F] = TRUE;
         break;

      case 161:                           /* CPI */
         RESETHALF(); 
         RESETNEG();
         
         Output_Code( "CPI", dreg[PC], IMPL, -1, -1, 237, 161, -1, -1 );
         compare_reg( mem[ HL_addr ] );
         
         inc_dreg( H, L );
         dec_dreg( B, C );
         dreg[PC] -= 2;
         
         if (dreg[BC] != 0)
            SETPV();
         else
            RESETPV();
         
         sregchanged[F] = TRUE;
         break;

      case 162:                           /* INI */
         {
         int rval = 0;
         
         Output_Code( "INI", dreg[PC], IMPL, -1, -1, 237, 162, -1, -1 );
         
         rval = HandleInPort();
         if (rval < 0)
            {
            if (Handle_Problem( "Press OKAY to ignore", 
                                "IN() Requester problem:", NULL ) != 0)
               {
               /* Do some sort of error recovery here! */
               }
            }
         else if (rval < 256)
            mem[ HL_addr ] = rval;
         else
            mem[ HL_addr ] = 0;

         inc_dreg( H, L );
         dec_reg( B );
         SETNEG();
         dreg[PC] -= 2;

         if (reg[B] == 0)    
            SETZERO();
         else
            RESETZERO();
         }

         sregchanged[F] = TRUE;
         break;

      case 163:                           /* OUTI */
         Output_Code( "OUTI", dreg[PC], IMPL, -1, -1, 237, 163, -1, -1 );
         (void) HandleOutPort( reg[C], mem[ HL_addr ] ); /* (C) <- (HL) */

         inc_dreg( H, L );
         dec_reg( B );

         SETNEG();
         dreg[PC] -= 2;

         if (reg[B] == 0)   
            SETZERO();
         else
            RESETZERO();
         
         sregchanged[F] = TRUE;
         break;

      case 168:                           /* LDD */
         RESETHALF(); 
         RESETNEG();
         
         Output_Code( "LDD", dreg[PC], IMPL, -1, -1, 237, 168, -1, -1 );
         mem[ DE_addr ] = mem[ HL_addr ];
         
         dec_dreg( D, E );
         dec_dreg( H, L );
         dec_dreg( B, C );
         
         dreg[PC] -= 3;
         
         if (dreg[BC] == 0)
            RESETPV();
         else
            SETPV();

         sregchanged[F] = TRUE;
         break;

      case 169:                           /* CPD */
         SETNEG();
         Output_Code( "CPD", dreg[PC], IMPL, -1, -1, 237, 169, -1, -1 );
         compare_reg( mem[ HL_addr ] );

         dec_dreg( H, L );
         dec_dreg( B, C );
         dreg[PC] -= 2;

         if (dreg[BC] != 0)
            SETPV();
         else
            RESETPV();

         sregchanged[F] = TRUE;
         break;

      case 170:                           /* IND */
         {
         int rval = 0;

         Output_Code( "IND", dreg[PC], IMPL, -1, -1, 237, 170, -1, -1 );

         rval = HandleInPort();
         if (rval < 0)
            {
            if (Handle_Problem( "Press OKAY to ignore", 
                                "IN() Requester problem:", NULL ) != 0)
               {
               /* Do some sort of error recovery here! */
               }
            }
         else if (rval < 256)
            mem[ HL_addr ] = rval;
         else
            mem[ HL_addr ] = 0;

         dec_dreg( H, L );
         dec_reg( B );
         SETNEG();
         dreg[PC] -= 2;

         if (reg[B] == 0)
            SETZERO();
         else
            RESETZERO();
         }

         sregchanged[F] = TRUE;
         break;

      case 171:                           /* OUTD */
         Output_Code( "OUTD", dreg[PC], IMPL, -1, -1, 237, 171, -1, -1 );

         (void) HandleOutPort( reg[C], mem[ HL_addr ] ); /* (C) <- (HL) */

         dec_dreg( H, L );
         dec_reg( B );
         SETNEG();
         dreg[PC] -= 2;

         if (reg[B] == 0)
            SETZERO();
         else
            RESETZERO();

         sregchanged[F] = TRUE;
         break;

      case 176:                           /* LDIR */
         RESETHALF(); 
         RESETNEG(); 
         RESETPV();
         sregchanged[F] = TRUE;

         Output_Code( "LDIR", dreg[PC], IMPL, -1, -1, 237, 176, -1, -1 );

         do {
            mem[ DE_addr ] = mem[ HL_addr ];
            inc_dreg( D, E );
            inc_dreg( H, L );
            dec_dreg( B, C );
            dreg[PC] -= 3;

            (void) CheckBkpt();  /* check the breakpoints! */
            Update_Regs( dreg[PC] );

            DE_addr = 256 * reg[D] + reg[E];
            HL_addr = 256 * reg[H] + reg[L];

            } while ((reg[B] != 0) || (reg[C] != 0));

         break;

      case 177:                           /* CPIR */
         SETNEG();
         sregchanged[F] = TRUE;

         Output_Code( "CPIR", dreg[PC], IMPL, -1, -1, 237, 177, -1, -1 );
         
         do {
            compare_reg( mem[ HL_addr ] );
            inc_dreg( H, L );
            dec_dreg( B, C );
            dreg[PC] -= 2;

            Update_Regs( dreg[PC] );
            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];

            } while (((reg[B] != 0) || (reg[C] != 0))
                    && (reg[F] & ZERO) != ZERO);
         break;

      case 178:                           /* INIR */
         {
         int rval = 0;

         sregchanged[F] = TRUE;

         Output_Code( "INIR", dreg[PC], IMPL, -1, -1, 237, 178, -1, -1 );

         do {
            rval = HandleInPort();   /* (HL) <- (C) */

            if (rval < 0)
               {
               if (Handle_Problem( "Press OKAY to ignore", 
                                   "IN() Requester problem:", NULL ) != 0)
                  {
                  /* Do some sort of error recovery here! */
                  }
               }
            else if (rval < 256)
               mem[ HL_addr ] = rval;
            else
               mem[ HL_addr ] = 0;


            inc_dreg( H, L );
            dec_reg( B );
            SETNEG();  
            SETZERO();

            dreg[PC] -= 2;
            Update_Regs( dreg[PC] );

            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];
            HL_addr = 256 * reg[H] + reg[L];

            } while (reg[B] != 0);
         }
         break;

      case 179:                           /* OTIR */
         sregchanged[F] = TRUE;
         Output_Code( "OTIR", dreg[PC], IMPL, -1, -1, 237, 179, -1, -1 );

         do {
            (void) HandleOutPort( reg[C], mem[ HL_addr ] ); 
            /* (C) <- (HL) */

            inc_dreg( H, L );
            dec_reg( B );
            SETNEG();  
            SETZERO();

            dreg[PC] -= 2;

            Update_Regs( dreg[PC] );
            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];
            HL_addr = 256 * reg[H] + reg[L];

            } while (reg[B] != 0);

         break;

      case 184:                           /* LDDR */
         RESETHALF(); 
         RESETNEG(); 
         RESETPV();
         sregchanged[F] = TRUE;

         Output_Code( "LDDR", dreg[PC], IMPL, -1, -1, 237, 184, -1, -1 );

         do {
            mem[ DE_addr ] = mem[ HL_addr ];
            dec_dreg( D, E );
            dec_dreg( H, L );
            dec_dreg( B, C );
            dreg[PC] -= 3;

            Update_Regs( dreg[PC] );
            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];
            DE_addr = 256 * reg[D] + reg[E];
            HL_addr = 256 * reg[H] + reg[L];

            } while ((reg[B] != 0) || (reg[C] != 0));
         break;

      case 185:                           /* CPDR */
         SETNEG();
         sregchanged[F] = TRUE;
         Output_Code( "CPDR", dreg[PC], IMPL, -1, -1, 237, 185, -1, -1 );

         do {
            compare_reg( mem[ HL_addr ] );
            dec_dreg( H, L );
            dec_dreg( B, C );
            dreg[PC] -= 2;

            Update_Regs( dreg[PC] );
            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];
            HL_addr = 256 * reg[H] + reg[L];

            } while ((reg[B] != 0) || (reg[C] != 0)
                    && (reg[F] & ZERO) != ZERO);
         break;

      case 186:                           /* INDR */
         {
         int rval = 0;
         
         Output_Code( "INDR", dreg[PC], IMPL, -1, -1, 237, 186, -1, -1 );

         sregchanged[F] = TRUE;

         do {
            rval = HandleInPort();
            if (rval < 0)
               Handle_Problem( "Couldn't open IN() Requester!", 
                               "Z80 INDR Port Problem!", &rval 
                             );
            else if (rval < 256)
               mem[ HL_addr ] = rval & 0x000000FF;
            else 
               mem[ HL_addr ] = 0;

            dec_dreg( H, L );
            dec_reg( B );

            SETNEG();  
            SETZERO();
            
            dreg[PC] -= 2;
            Update_Regs( dreg[PC] );
            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];
            HL_addr = 256 * reg[H] + reg[L];

            } while (reg[B] != 0);
         }
         break;

      case 187:                           /* OTDR */
         Output_Code( "OTDR", dreg[PC], IMPL, -1, -1, 237, 187, -1, -1 );
         sregchanged[F] = TRUE;

         do {
            (void) HandleOutPort( reg[C], mem[ HL_addr ] );/* (C) <- (HL) */
            dec_dreg( H, L );
            dec_reg( B );
            SETNEG();  
            SETZERO();

            dreg[PC] -= 2;
            Update_Regs( dreg[PC] );
            (void) CheckBkpt();              /* check the breakpoints! */

            HL_addr = 256 * reg[H] + reg[L];
            HL_addr = 256 * reg[H] + reg[L];

            } while (reg[B] != 0);

         break;

      default:
         ILLEGAL();
      }  /* ------------   END OF T2 SWITCH TABLE!!   ------------ */

   dregchanged[PC] = TRUE;

   return( (int) status);
}

/* --------------------- END of Z80S23.c!! ----------------------- */
