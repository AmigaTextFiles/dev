/****h* Z80Simulator/Z80ST1.c [2.5] ************************************
*
* NAME
*    Z80ST1.c
*
* NOTES
*    EXTERNAL CALLS: decode_mach2() in Z80ST2.c
*                    Output_Code()  in Z80Code.c
*
* DESCRIPTION
*    The state machine code for the Z80 processor simulator program.
*
* HISTORY
*    21-Apr-2001 - Added code for highlighting register value changes.
*    12-Apr-1994 - Corrected CALL cc,nn coding.
*    04-Mar-1994 - changed ADD_REL() to perform arithmetic correctly.
*                  Also re-formatted Decode_Mach().
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include "Z80Sim.h"
#include "Z80Code.h"
#include "Z80FuncProtos.h"

IMPORT UWORD dreg[], temp_PC;
IMPORT BOOL  sregchanged[], dregchanged[];

void  ADD_REL( UBYTE disp )
{
   int test = disp;
    
   INCPC( 2 );

   if (test <= 0x7F)
      {
      dreg[PC] += disp;
      }
   else   
      {
      test      = -1 * ((~disp & 0xFF) + 1);
      dreg[PC] += test;
      }

   dregchanged[PC] = TRUE;
   
   return;
}

void  Push( int b1, int b2 ) /* store two bytes on the Z80 stack! */
{
   extern UBYTE   *mem;

   dreg[ SP ]--;   mem[ dreg[SP] ] = b1;
   dreg[ SP ]--;   mem[ dreg[SP] ] = b2;
   
   dregchanged[SP] = TRUE;

   return;
}

void  Pop( int b2, int b1, int type ) /* get 2 bytes from the Z80 stack! */
{
   extern UBYTE   reg[], *mem;

   if (type == M)  
      {
      b2 = mem[ dreg[SP] ];   dreg[ SP ]++;
      b1 = mem[ dreg[SP] ];   dreg[ SP ]++; 
      }
   else if (type == RG) 
      {
      reg[b2] = mem[ dreg[SP] ];   dreg[ SP ]++;
      reg[b1] = mem[ dreg[SP] ];   dreg[ SP ]++; 
      }
   else  
      {                        /* b1 == b2!! */
      dreg[b2] = mem[ dreg[SP] ];                    dreg[ SP ]++;
      dreg[b1] = dreg[b2] + 256 * mem[ dreg[SP] ];   dreg[ SP ]++; 
      }

   dregchanged[SP] = TRUE;
   return;
}

int   decode_mach( int state )
{
   extern UBYTE *mem;
   extern UBYTE n1, n2, altAF, altregs, IFF1_2, PORTS[], status, reg[];

   UBYTE        temp, oper, byte2, byte3;
   UWORD        adr_lo, adr_hi, w1, w2, HL_addr, mem_addr;

   /* Decode the 1st byte in 'state', if necessary, set state to
    * mem[dreg[PC] + 1] and call decode_mach2() for more decoding
    * Inside any particular state:
    *    1. Determine how much to increment the PC by (INCPC).
    *    2. Manipulate the registers affected, and the condition
    *       codes, if affected.
    *
    * Set up any system level flags that main() needs to know about.
    */

   adr_lo   = dreg[PC] + 1;
   byte2    = mem[ adr_lo ];
   adr_hi   = dreg[PC] + 2;
   byte3    = mem[ adr_hi ];
   HL_addr  = 256 * reg[H] + reg[L];
   mem_addr = byte2 + 256 * byte3;  /* jump addr = byte2 + 256 * byte3 */

   switch( state )   
      {
      case 0:  
         Output_Code( "NOP", dreg[PC], IMPL, -1, -1, 0, -1, -1, -1 );
         INCPC( 1 );    
         break;
         
      case 1:  case 17:  case 33:                  /* LD dreg,nn */
         temp = ((state - 1) / 16) * 4 + 2;

         if (reg[temp] != byte3)
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;

         if (reg[temp + 2] != byte2)
            sregchanged[temp + 2] = TRUE;
         else
            sregchanged[temp + 2] = FALSE;

         reg[temp]     = byte3; 
         reg[temp + 2] = byte2;

         oper          = ((state - 1) / 16) + 4;

         Output_Code( "LD ", dreg[PC], EXTA4, oper, -1, state, 
                      byte2, byte3, -1 
                    );

         INCPC( 3 );
         break;
      
      case 2:  case 18:                           /* LD (dreg),A */
         temp = ((state - 2) / 16) * 4 + 2;
         oper = ((state - 2) / 16) + 4;

         Output_Code( "LD ", dreg[PC], REGI1, oper, A, 
                      state, -1, -1, -1
                    );

         INCPC( 1 );             

         mem[ 256 * reg[temp] + reg[temp + 2] ] = reg[A];
         break;
         
      case 3:  case 19: case 35:                  /* INC dreg */
         temp = ((state - 3) / 16) * 4 + 2;      
         oper = ((state - 3) / 16) + 4;

         Output_Code( "INC ", dreg[PC], REGD2, -1, oper, 
                      state, -1, -1, -1
                    );

         inc_dreg( temp, temp + 2 );
         break;

      case 4:  case 12:  case 20:                 /* INC reg */
      case 28: case 36:  case 44:
         temp = ((state - 4) / 8) * 2 + 2;    

         Output_Code( "INC ", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1
                    );

         inc_reg( temp );
         break;
         
      case 5:  case 13:  case 21:                 /* DEC reg */
      case 29: case 37:  case 45:
         temp = ((state - 5) / 8) * 2 + 2;

         Output_Code( "DEC ", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1
                    );

         dec_reg( temp );                     
         break;
         
      case 6:  case 14: case 22:                  /* LD reg,n */
      case 30: case 38: case 46:
         temp = ((state - 6) / 8) * 2 + 2;
         
         if (reg[temp] != byte2)
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] = byte2;

         Output_Code( "LD ", dreg[PC], IMMD2, temp, -1, 
                      state, byte2, -1, -1
                    );

         INCPC( 2 );
         break;
         
      case 7:  
         Output_Code( "RLCA ", dreg[PC], IMPL, -1, -1, 7, -1, -1, -1 );
         INCPC( 1 );

         RESETNEG();    
         RESETHALF();

         if ((reg[A] & CARRY) == CARRY)  
            {
            SETCARRY(); 
            reg[A] <<= 1;
            reg[A]++;  
            }
         else  
            { 
            RESETCARRY(); 
            reg[A] <<= 1; 
            }
         
         sregchanged[A] = TRUE;
         sregchanged[F] = TRUE;
         break;

      case 8:  
         Output_Code( "EX AF,AF\'",dreg[PC], IMPL, -1, -1, 8, -1, -1, -1 );

         INCPC( 1 );

         if (altAF == 0) 
            F_SET( altAF );
         else            
            F_RESET( altAF );

         temp = reg[A]; reg[A] = reg[A+1]; reg[A+1] = temp;
         temp = reg[F]; reg[F] = reg[F+1]; reg[F+1] = temp;
         
         if (reg[A] != reg[A+1])
            {
            sregchanged[A]   = TRUE;
            sregchanged[A+1] = TRUE;
            }
         else
            {
            sregchanged[A]   = FALSE;
            sregchanged[A+1] = FALSE;
            }

         if (reg[F] != reg[F+1])
            {
            sregchanged[F]   = TRUE;
            sregchanged[F+1] = TRUE;
            }
         else
            {
            sregchanged[F]   = FALSE;
            sregchanged[F+1] = FALSE;
            }
         break;

      case 9:  case 25: case 41:                  /* ADD HL,dreg */
         oper = ((state - 9) / 16) + 4;
         Output_Code( "ADD HL,",dreg[PC], REGD2, -1, oper, 
                      state, -1, -1, -1
                    );

         add_dbl( oper );
         INCPC( 1 );
         break;
         
      case 10: case 26:                           /* LD A,(dreg) */
         temp = ((state - 10) / 16) * 4 + 2;
         oper = ((state - 10) / 16) + 4;

         Output_Code( "LD A,", dreg[PC], REGI2, -1, oper, 
                      state, -1, -1, -1 
                    );

         INCPC( 1 );                      
         
         if (reg[A] != mem[ 256 * reg[temp] + reg[temp + 2] ])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] = mem[ 256 * reg[temp] + reg[temp + 2] ];
         break;

      case 11: case 27: case 43:                   /* DEC dreg */
         temp = ((state - 11) / 16) * 4 + 2;
         oper = ((state - 11) / 16) + 4;

         Output_Code( "DEC ", dreg[PC], REGD2, -1, oper, 
                      state, -1, -1, -1 
                    );

         dec_dreg( temp, temp + 2 );
         break;
         
      case 15: 
         Output_Code( "RRCA ", dreg[PC], IMPL, -1, -1, 15, -1,-1,-1);
         INCPC( 1 );
         RESETNEG();    
         RESETHALF();

         if ((reg[A] & CARRY) != CARRY)  
            {
            RESETCARRY(); 
            reg[A] >>= 1;
            }
         else  
            { 
            SETCARRY(); 
            reg[A] >>= 1; 
            reg[A]++; 
            }

         sregchanged[A] = TRUE;  
         sregchanged[F] = TRUE;  
         break;
         
      case 16:                 /* DJNZ e */
         reg[B]--;   
         reg[B] &= 0xFF;

         Output_Code( "DJNZ ", dreg[PC], RELA1, -1, -1, 16, byte2, -1, -1 );

         sregchanged[B] = TRUE;

         if (reg[B] == 0)  
            { 
            INCPC( 2 );  
            break;  
            }
         else 
            ADD_REL( byte2 );  /* do jump */

         break;

      case 23: 
         Output_Code( "RLA ", dreg[PC], IMPL, -1, -1, 23, -1, -1, -1 );
         INCPC( 1 );
         RESETNEG();    
         RESETHALF();

         if ((reg[A] & 0x80) != 0)
            {
            if ((reg[F] & CARRY) == CARRY)  
               {
               SETCARRY(); 
               reg[A] <<= 1;
               reg[A]++;   
               break;
               }
            else  
               {
               SETCARRY(); 
               reg[A] <<= 1;
               break;  
               }
            }
         else  
            { 
            RESETCARRY(); 
            reg[A] <<= 1; 
            }

         sregchanged[A] = TRUE;  
         sregchanged[F] = TRUE;  
         break;
 
      case 24:                                       /* JR e */
         Output_Code( "JR ", dreg[PC], RELA1, -1, -1, 24, byte2, -1, -1 );
         ADD_REL( byte2 );
         break;

      case 31: 
         Output_Code( "RRA", dreg[PC], IMPL, -1, -1, 31, -1, -1, -1 );
         INCPC( 1 );
         RESETNEG();    
         RESETHALF();

         if ((reg[F] & CARRY) == CARRY)
            reg[A] += 0x80;

         if ((reg[A] & 0x01) == 1)   
            {
            SETCARRY(); 
            reg[A] >>= 1;
            }
         else  
            { 
            RESETCARRY(); 
            reg[A] >>= 1; 
            }

         sregchanged[A] = TRUE;  
         sregchanged[F] = TRUE;  
         break;

      case 32:                                 /* JR NZ,e */
         Output_Code( "JR NZ,", dreg[PC], RELA2, -1, -1, 
                      32, byte2, -1, -1 
                    );

         if ((reg[F] & ZERO) != ZERO)     
            ADD_REL( byte2 );
         else     
            INCPC( 2 );

         break;
         
      case 34:                                 /* LD (nn),HL */
         Output_Code( "LD ", dreg[PC], EXTI1, -1, HL, 
                      34, byte2, byte3, -1 
                    );

         INCPC( 3 );                      
         mem[ mem_addr ]     = reg[L];
         mem[ mem_addr + 1 ] = reg[H];
         break;

      case 39: 
         Output_Code( "DAA", dreg[PC], IMPL, -1, -1, 39, -1, -1, -1 );
         INCPC( 1 );
         n2 = (reg[F] & (CARRY | HALF)); /* separate C & H flags */

         if ((reg[F] & NEG) == 0)  
            {                       /* bcd addition! */
            if (n2 == 0)         
               break;
            else if (n2 == 4)  
               { 
               reg[A] += 0x06; 
               sregchanged[A] = TRUE;
               break; 
               }
            else if (n2 == 80) 
               { 
               reg[A] += 0x60; 
               sregchanged[A] = TRUE;
               break; 
               }
            else
               { 
               reg[A] += 0x66; 
               sregchanged[A] = TRUE;
               break; 
               }
            }
         else  
            {                       /* bcd subtraction! */
            if (n2 == 0)        
               break;
            else if (n2 == 4)  
               { 
               reg[A] -= 0x06; 
               sregchanged[A] = TRUE;
               break; 
               }
            else if (n2 == 80) 
               { 
               reg[A] -= 0x60; 
               sregchanged[A] = TRUE;
               break; 
               }
            else 
               { 
               reg[A] -= 0x66; 
               sregchanged[A] = TRUE;
               }
            }

         break;

      case 40:                                /* JR Z,e */
         Output_Code( "JR Z,", dreg[PC], RELA2, -1, -1, 40, byte2, -1, -1 );

         if ((reg[F] & ZERO) == ZERO)
            ADD_REL( byte2 );
         else     
            INCPC( 2 );

         break;
 
      case 42:                                     /* LD HL,(nn) */
         if (reg[L] != mem[ mem_addr ])
            sregchanged[L] = TRUE;
         else
            sregchanged[L] = FALSE;
            
         if (reg[H] != mem[ mem_addr + 1])
            sregchanged[H] = TRUE;
         else
            sregchanged[H] = FALSE;
            
         reg[L] = mem[ mem_addr ];
         reg[H] = mem[ mem_addr + 1 ];

         Output_Code( "LD HL,", dreg[PC], EXTI2, -1, -1, 
                      42, byte2, byte3, -1
                    );

         INCPC( 3 );
         break;

      case 47: 
         Output_Code( "CPL", dreg[PC], IMPL, -1, -1, 47, -1, -1, -1 );
         INCPC( 1 );
         SETNEG();   
         SETHALF();
         
         if (reg[A] != (~reg[A]))
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] = (~reg[A]);
         
         sregchanged[F] = TRUE;
         break;
    
      case 48:                                    /* JR NC,e */
         Output_Code( "JR NC,",dreg[PC], RELA2, -1, -1, 48, byte2, -1, -1 );

         if ((reg[F] & CARRY) != CARRY)     
            ADD_REL( byte2 );
         else     
            INCPC( 2 );

         break;

      case 49:                            /* LD SP,nn */
         if (dreg[SP] != mem_addr)
            dregchanged[SP] = TRUE;
         else
            dregchanged[SP] = FALSE;
               
         dreg[SP] = mem_addr;
         Output_Code( "LD SP,", dreg[PC], EXTI2, -1, -1, 
                      49, byte2, byte3, -1
                    );

         INCPC( 3 );
         break;

      case 50:                            /* LD (nn),A */
         mem[ mem_addr ] = reg[A];
         Output_Code( "LD ", dreg[PC], REGI3, -1, A, 50, byte2, byte3, -1 );
         INCPC( 3 );
         break;
 
      case 51: 
         Output_Code( "INC SP", dreg[PC], IMPL, -1, -1, 51, -1, -1, -1 );
         INCPC( 1 );
         dreg[SP] = dreg[SP] + 1;

         dregchanged[SP] = TRUE;
         break;

      case 52: 
         Output_Code( "INC (HL)", dreg[PC], IMPL, -1, -1, 52, -1, -1, -1 );
         inc_reg( mem[ HL_addr ] );    /* INCPC() in inc_reg()!! */
         break;

      case 53: 
         Output_Code( "DEC (HL)", dreg[PC], IMPL, -1, -1, 53, -1, -1, -1 );
         dec_reg( mem[ HL_addr ] ); /* INCPC() in inc_reg()!! */
         break;
 
      case 54:                            /* LD (HL),n */
         mem[ HL_addr ] = byte2;
         Output_Code( "LD ", dreg[PC], REGI1, HL, -1, 54, byte2, -1, -1 );
         INCPC( 2 );
         break;

      case 55: 
         Output_Code( "SCF", dreg[PC], IMPL, -1, -1, 55, -1, -1, -1 );
         INCPC( 1 );
         RESETNEG();   
         RESETHALF();
         reg[F] |= CARRY;   

         sregchanged[F] = TRUE;
         break;
         
      case 56:                              /* JR C,e */
         Output_Code( "JR C,", dreg[PC], RELA2, -1, -1, 56, byte2, -1, -1 );

         if ((reg[F] & CARRY) == CARRY)
            ADD_REL( byte2 );
         else     
            INCPC( 2 );

         break;

      case 57: 
         Output_Code( "ADD HL,SP", dreg[PC], IMPL, -1, -1, 57, -1, -1, -1 );
         add_dbl( SP );
         INCPC( 1 );
         break;
 
      case 58:                               /* LD A,(nn) */
         if (reg[A] != mem[mem_addr])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] = mem[ mem_addr ];

         Output_Code( "LD A,", dreg[PC], EXTA2, -1, -1, 
                      58, byte2, byte3, -1
                    );

         INCPC( 3 );
         break;

      case 59: 
         Output_Code( "DEC SP", dreg[PC], IMPL, -1, -1, 59, -1, -1, -1 );
         INCPC( 1 );
         dreg[SP] = dreg[SP] - 1;

         dregchanged[SP] = TRUE;
         break;

      case 60: 
         Output_Code( "INC A", dreg[PC], IMPL, -1, -1, 60, -1, -1, -1 );
         inc_reg( A );

         sregchanged[A] = TRUE;
         break;
 
      case 61: 
         Output_Code( "DEC A", dreg[PC], IMPL, -1, -1, 61, -1, -1, -1 );
         dec_reg( A );
         
         sregchanged[A] = TRUE;
         break;

      case 62:                           /* LD A,n */
         Output_Code( "LD A,", dreg[PC], IMMD, -1, -1, 62, byte2, -1, -1 );
         if (reg[A] != byte2)
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] = byte2;  
         INCPC( 2 );   
         break;
         
      case 63: 
         Output_Code( "CCF", dreg[PC], IMPL, -1, -1,63,-1, -1, -1);
         INCPC( 1 );
         RESETNEG();

         if (reg[F] & CARRY == 0)    
            reg[F] |= CARRY;
         else
            reg[F] &= NCARRY;

         sregchanged[F] = TRUE;
         break;
         
      case 64: case 65: case 66: case 67: case 68: case 69:  /* LD r,r' */
      case 72: case 73: case 74: case 75: case 76: case 77:
      case 80: case 81: case 82: case 83: case 84: case 85:
      case 88: case 89: case 90: case 91: case 92: case 93:
      case 96: case 97: case 98: case 99: case 100: case 101:
      case 104: case 105: case 106: case 107: case 108: case 109:

         n1 = ((state - 64) / 8) * 2 + 2; 
         n2 = (state % 8) * 2 + 2;

         Output_Code( "LD ", dreg[PC], REGA4, n1, n2, state, -1, -1, -1 );
         INCPC( 1 );
         
         if (reg[n1] != reg[n2])
            sregchanged[n1] = TRUE;
         else
            sregchanged[n1] = FALSE;
            
         LD_IMM( reg[n1], reg[n2] );
         break;

      case 70: case 78:  case 86:            /* LD r,(HL) */
      case 94: case 102: case 110:
         temp = ((state - 70) / 8) * 2 + 2;  
         Output_Code( "LD ", dreg[PC], REGI2, temp, HL, state, -1, -1, -1 );
         INCPC( 1 );
         
         if (reg[temp] != mem[ HL_addr ])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         LD_IMM( reg[temp], mem[ HL_addr ] );
         break;

      case 71: case 79:  case 87:            /* LD r,A */
      case 95: case 103: case 111:
         temp = ((state - 71) / 8) * 2 + 2;  
         Output_Code( "LD ", dreg[PC], REGA4, temp, A, state, -1, -1, -1 );
         INCPC( 1 );
         
         if (reg[temp] != reg[A])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         LD_IMM( reg[temp], reg[A] );
         break;
 
      case 112: case 113: case 114:          /* LD (HL),r */
      case 115: case 116: case 117:
         temp = (state - 112) * 2 + 2; 
         Output_Code( "LD ", dreg[PC], REGI1, HL, temp, state, -1, -1, -1 );
         INCPC( 1 );
         LD_IMM( mem[ HL_addr ], reg[temp] );
         break;

      case 118: 
         Output_Code( "HALT", dreg[PC], IMPL, -1, -1, 118, -1, -1, -1 );
         INCPC( 1 );
         status = HALT;   
         break;
         
      case 119: 
         Output_Code( "LD (HL),A", dreg[PC], IMPL, -1, -1, 119, -1, -1, -1 );
         INCPC( 1 );
         LD_IMM( mem[ HL_addr ], reg[A] );
         break;

      case 120: case 121: case 122:           /* LD A,r */
      case 123: case 124: case 125:
         temp = (state - 120) * 2 + 2;  
         Output_Code( "LD A,", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1 
                    );

         INCPC( 1 );
        
         if (reg[A] != reg[temp])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         LD_IMM( reg[A], reg[temp] );  
         break;

      case 126:
         if (reg[A] != mem[ HL_addr ])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         LD_IMM( reg[A], mem[ HL_addr ] );

         Output_Code( "LD A,(HL)", dreg[PC], IMPL, -1, -1, 126, -1, -1, -1 );
         INCPC( 1 );
         break;

      case 127: 
         Output_Code( "LD A,A", dreg[PC], IMPL, -1, -1, 127, -1, -1, -1 );
         INCPC( 1 );
         break;

      case 128: case 129: case 130:                 /* ADD A,r */
      case 131: case 132: case 133:
         temp = (state - 128) * 2 + 2;
         Output_Code( "ADD A,", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1
                    );

         add_regs( A, temp, RG );
         break;
 
      case 134: 
         Output_Code( "ADD A,(HL)", dreg[PC], IMPL, -1, -1, 
                      134, -1, -1, -1 
                    );

         add_regs( A, mem[ HL_addr ], M );
         break;
 
      case 135: 
         Output_Code( "ADD A,A", dreg[PC], IMPL, -1, -1, 135, -1, -1, -1 );
         add_regs( A, A, RG );
         break;

      case 136: case 137: case 138:           /* ADC A,r */
      case 139: case 140: case 141:
         temp = (state - 136) * 2 + 2;
         Output_Code( "ADC A,", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1 
                    );

         adc_reg( A, temp, RG );
         break;

      case 142:
         Output_Code( "ADC A,(HL)", dreg[PC], IMPL, -1, -1, 
                      142, -1, -1, -1 
                    );

         adc_reg( A, mem[HL_addr], M );
         break;

      case 143: 
         Output_Code( "ADC A,A", dreg[PC], IMPL, -1, -1, 143, -1, -1, -1 );
         adc_reg( A, A, RG );
         break;

      case 144: case 145: case 146:           /* SUB r */
      case 147: case 148: case 149:
         temp = (state - 144) * 2 + 2;
         Output_Code( "SUB ", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1 
                    );

         sub_regs( A, temp, RG );
         break;
 
      case 150: 
         Output_Code( "SUB (HL)", dreg[PC], IMPL, -1, -1, 150, -1, -1, -1 );
         sub_regs( A, mem[ HL_addr ], M );
         break;

      case 151: 
         Output_Code( "SUB A", dreg[PC], IMPL, -1, -1, 151, -1, -1, -1 );
         sub_regs( A, A, RG );
         break;

      case 152: case 153: case 154:           /* SBC A,r */
      case 155: case 156: case 157:
         temp = (state - 152) * 2 + 2;
         Output_Code( "SBC A,", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1
                    );

         sbc_reg( A, temp, RG );
         break;

      case 158:
         Output_Code( "SBC A,(HL)", dreg[PC], IMPL, -1, -1, 
                      158, -1, -1, -1
                    );

         sbc_reg( A, mem[HL_addr], M );
         break;

      case 159: 
         Output_Code( "SBC A,A", dreg[PC], IMPL, -1, -1, 159, -1, -1, -1 );
         sbc_reg( A, A, RG );
         break;
 
      case 160: case 161: case 162:           /* AND r */
      case 163: case 164: case 165:
         temp = (state - 160) * 2 + 2;
         Output_Code( "AND ", dreg[PC], REGA2, -1, temp, 
                      state, -1, -1, -1 
                    );

         log_reg( temp, AND, RG );
         break;

      case 166: 
         Output_Code( "AND (HL)", dreg[PC], IMPL, -1, -1, 166, -1, -1, -1 );
         log_reg( mem[ HL_addr ], AND, M );
         break;

      case 167: 
         Output_Code( "AND A", dreg[PC], IMPL, -1, -1, 167, -1, -1, -1 );
         log_reg( A, AND, RG );
         break;

      case 168: case 169: case 170:           /* XOR r */
      case 171: case 172: case 173:
         temp = (state - 168) * 2 + 2;
         Output_Code( "XOR ", dreg[PC], REGA2, -1, temp, state, -1, -1, -1 );
         log_reg( temp, XOR, RG );
         break;

      case 174: 
         Output_Code( "XOR (HL)", dreg[PC], IMPL, -1, -1, 174, -1, -1, -1 );
         log_reg( mem[ HL_addr ], XOR, M );
         break;

      case 175: 
         Output_Code( "XOR A", dreg[PC], IMPL, -1, -1, 175, -1, -1, -1 );
         log_reg( A, XOR, RG );
         break;

      case 176: case 177: case 178:           /* OR r */
      case 179: case 180: case 181:
         temp = (state - 176) * 2 + 2;
         Output_Code( "OR ", dreg[PC], REGA2, -1, temp, state, -1, -1, -1 );
         log_reg( temp, OR, RG );
         break;

      case 182: 
         Output_Code( "OR (HL)", dreg[PC], IMPL, -1, -1, 182, -1, -1, -1 );
         log_reg( mem[ HL_addr ], OR, M );
         break;

      case 183: 
         Output_Code( "OR A", dreg[PC], IMPL, -1, -1, 183, -1, -1, -1 );
         log_reg( A, OR, RG );
         break;

      case 184: case 185: case 186:           /* CP r */
      case 187: case 188: case 189:
         temp = (state - 184) * 2 + 2;
         Output_Code( "CP ", dreg[PC], REGA2, -1, temp, state, -1, -1, -1 );
         log_reg( temp, CP, RG );
         break;

      case 190: 
         Output_Code( "CP (HL)", dreg[PC], IMPL, -1, -1, 190, -1, -1, -1 );
         log_reg( mem[ HL_addr ], CP, M );
         break;

      case 191: 
         Output_Code( "CP A", dreg[PC], IMPL, -1, -1, 191, -1, -1, -1 );
         log_reg( A, CP, RG );
         break;

      case 192: case 200: case 208: case 216:      /* RET cc */
      case 224: case 232: case 240: case 248:
         INCPC( 3 );
         temp_PC = dreg[PC];
         temp    = ((state - 192) / 8) + 1; /* 1 -> 8 */
         oper    = temp - 1;                /* 0 -> 7 */

         Output_Code( "RET ", dreg[PC] - 3, EXTA1, -1, oper,
                      state, -1, -1, -1
                    );

         switch (oper)
            {
            case 0:
            case 1:
               n1 = ZERO;
               break;
            case 2:
            case 3:
               n1 = CARRY;
               break;
            case 4:
            case 5:
               n1 = PV;
               break;
            case 6:
            case 7:
               n1 = SGN;
               break;
            }

         if ((temp % 2) == 0)   
            {
            /* RET Z, RET C, RET PE, RET M: */
            if ((reg[F] & n1) == n1)  /* Flag is set: */
               {
               Pop( PC, PC, PC );
               status = RETURN_FOUND;
               }
            else 
               INCPC( 1 );
            }
         else  
            {
            /* RET NZ, RET NC, RET PO, RET P: */
            if ((reg[F] & n1) != n1)  /* Flag is clear: */
               {
               Pop( PC, PC, PC );
               status = RETURN_FOUND;
               }
            else 
               INCPC( 1 );
            }
         break;
         
      case 193: case 209:                  /* POP dreg */
      case 225: case 241:
         INCPC( 1 );        

         if (state == 241)   
            {
            Output_Code( "POP AF", dreg[PC] - 1, IMPL, 
                         -1, -1, 241, -1, -1, -1
                       );

            Pop( F, A, RG );
            break;
            }
         else    
            {
            temp = ((state - 193) / 16) * 4 + 2;
            oper = ((state - 193) / 16) + 4;
            Output_Code( "POP ", dreg[PC] - 1, REGD2, -1, 
                          oper, state, -1, -1, -1 
                       );

            Pop( temp + 2, temp, RG );
            break;
            }
 
      case 194: case 202: case 210: case 218:           /* JP cc,aa */
      case 226: case 234: case 242: case 250:
                                     
         temp = ((state - 194) / 8) + 1;

         Output_Code( "JP ", dreg[PC], EXTA3, temp - 1, -1, 
                      state, byte2, byte3, -1 
                    );

         switch (temp)
            {
            case 1:
            case 2:
               n1 = ZERO;
               break;
            case 3:
            case 4:
               n1 = CARRY;
               break;
            case 5:
            case 6:
               n1 = PV;
               break;
            case 7:
            case 8: 
               n1 = SGN;
               break;
            } 

         if ((temp % 2) == 0)   
            {
            if ((reg[F] & n1) == n1)
               dreg[PC] = mem_addr;
            else
               INCPC( 3 );
            }
         else  
            {
            if ((reg[F] & n1) != n1)
               dreg[PC] = mem_addr;
            else
               INCPC( 3 );
            }
         break;

      case 195:                                /* JP aa */
         Output_Code( "JP ", dreg[PC], EXTA1, -1, -1, 
                      195, byte2, byte3, -1 
                    );

         dreg[PC] = mem_addr;
         break;

      case 0xC4: case 0xCC: case 0xD4: case 0xDC:  /* NZ, Z, NC, C */  
      case 0xE4: case 0xEC: case 0xF4: case 0xFC:  /* PO, PE, P, M */
                                                   /* CALL cc,aa   */
         INCPC( 3 );
         temp = ((state - 0xC4) / 8) + 1;

         switch (temp)
            {
            case 1:  
            case 2:  n1 = ZERO;  break; /* Zero   flag */
            case 3:
            case 4:  n1 = CARRY; break; /* Carry  flag */
            case 5:
            case 6:  n1 = PV;    break; /* Parity flag */
            case 7:
            case 8:  n1 = SGN;   break; /* Sign   flag */
            }

         w1 = get_high_word( PC );
         w2 = get_low_word( PC );

         Output_Code( "CALL ", dreg[PC] - 3, EXTA3, temp - 1, -1,
                      state, byte2, byte3, -1 
                    );

         if ((temp % 2) == 0) /* condition bit asserted calls: */
            {
            if ((reg[F] & n1) == n1)  
               {
               Push( w1, w2 );
               dreg[PC]  = mem_addr;
               }
            }
         else                 /* condition bit NOT asserted calls: */
            {
            if ((reg[F] & n1) != n1)  
               {
               Push( w1, w2 );
               dreg[PC]  = mem_addr;
               }
            }
         break;
 
      case 197: case 213:        /* PUSH dreg */
      case 229: case 245:

         if (state == 245)   
            {
            Output_Code( "PUSH AF", dreg[PC] - 1, IMPL, -1, -1,
                          245, -1, -1, -1 );
            Push( reg[A], reg[F] );
            }
         else 
            {
            temp = ((state - 197) / 16) * 4 + 2;
            oper = ((state - 197) / 16) + 4;
            Output_Code( "PUSH ", dreg[PC] - 1, REGD2, -1, oper,
                          state, -1, -1, -1 );
            Push( reg[temp], reg[temp + 2] );
            }

         INCPC( 1 );
         break;
 
      case 198:                               /* ADD A,n */
         Output_Code( "ADD A,", dreg[PC], IMMD, -1, -1, 
                      198, byte2, -1, -1 
                    );

         RESETNEG();
         add_regs( A, byte2, N );
         INCPC( 1 );
         break;

      case 199: case 207: case 215: case 223:     /* RST xxH */
      case 231: case 239: case 247: case 255:

         Output_Code( "RST ", dreg[PC] - 1, MPZA, 
                      -1, temp, state, -1, -1, -1
                    );
         INCPC( 1 );

         temp = state - 199;
         w1   = get_high_word( PC );
         w2   = get_low_word( PC );

         Push( w1, w2 );
         dreg[PC] = temp;  
         status   = RESET;
         break;

      case 201: 
         Output_Code( "RET", dreg[PC], IMPL, -1, -1, 201, -1, -1, -1 );
         INCPC( 1 );
         temp_PC = dreg[PC];
         Pop( PC, PC, PC );
         status  = RETURN_FOUND;
         break;

      case 203:                               /* BIT, SET, RES? (T1) */
         status = decode_mach2( byte2, T1 );  /* CB table            */
         INCPC( 2 );                          /* for CB & byte2      */
         break;

      case 205: 
         Output_Code( "CALL ", dreg[PC], EXTA1, -1, -1, 
                      205, byte2, byte3, -1
                    );

         INCPC( 3 );
         w1 = get_high_word( PC );
         w2 = get_low_word( PC );

         Push( w1, w2 );
         dreg[PC]  = mem_addr;
         break;

      case 206:                                 /* ADC A,n */
         Output_Code( "ADC A,", dreg[PC], IMMD, -1, -1, 
                      206, byte2, -1, -1 
                    );

         RESETNEG();
         adc_reg( A, byte2, N );
         INCPC( 2 );
         break;

      case 211:                               /* OUT (n),A */
         Output_Code( "OUT ", dreg[PC], IMPL2, -1, A, 211, byte2, -1, -1 );
         (void) HandleOutPort( byte2, reg[A] );
         INCPC( 2 );   
         break;
         
      case 214:                               /* SUB n */
         Output_Code( "SUB ", dreg[PC], IMMD, -1, -1, 214, byte2, -1, -1 );
         sub_regs( A, byte2, N );
         INCPC( 1 );
         break;

      case 217: 
         Output_Code( "EXX", dreg[PC], IMPL,-1, -1, 217, -1, -1, -1 );
         INCPC( 1 );

         if (altAF == 0)  
            F_SET( altregs );
         else             
            F_RESET( altregs );

         if (reg[B] != reg[B + 1])
            {
            sregchanged[B    ] = TRUE;
            sregchanged[B + 1] = TRUE;
            }
         else
            {
            sregchanged[B    ] = FALSE;
            sregchanged[B + 1] = FALSE;
            }            

         if (reg[C] != reg[C + 1])
            {
            sregchanged[C    ] = TRUE;
            sregchanged[C + 1] = TRUE;
            }
         else
            {
            sregchanged[C    ] = FALSE;
            sregchanged[C + 1] = FALSE;
            }            

         temp = reg[B]; reg[B] = reg[B+1]; reg[B+1] = temp;
         temp = reg[C]; reg[C] = reg[C+1]; reg[C+1] = temp;

         if (reg[D] != reg[D + 1])
            {
            sregchanged[D    ] = TRUE;
            sregchanged[D + 1] = TRUE;
            }
         else
            {
            sregchanged[D    ] = FALSE;
            sregchanged[D + 1] = FALSE;
            }            

         if (reg[E] != reg[E + 1])
            {
            sregchanged[E    ] = TRUE;
            sregchanged[E + 1] = TRUE;
            }
         else
            {
            sregchanged[E    ] = FALSE;
            sregchanged[E + 1] = FALSE;
            }            

         temp = reg[D]; reg[D] = reg[D+1]; reg[D+1] = temp;
         temp = reg[E]; reg[E] = reg[E+1]; reg[E+1] = temp;

         if (reg[H] != reg[H + 1])
            {
            sregchanged[H    ] = TRUE;
            sregchanged[H + 1] = TRUE;
            }
         else
            {
            sregchanged[H    ] = FALSE;
            sregchanged[H + 1] = FALSE;
            }            

         if (reg[L] != reg[L + 1])
            {
            sregchanged[L    ] = TRUE;
            sregchanged[L + 1] = TRUE;
            }
         else
            {
            sregchanged[L    ] = FALSE;
            sregchanged[L + 1] = FALSE;
            }            

         temp = reg[H]; reg[H] = reg[H+1]; reg[H+1] = temp;
         temp = reg[L]; reg[L] = reg[L+1]; reg[L+1] = temp;
         break;

      case 219:                           /* IN A,(n) */
         {
         int rval = 0;
         
         Output_Code( "IN A,", dreg[PC], IMPL2, A, -1, 219, byte2, -1, -1 );
         rval = HandleInPort();

         if (reg[A] != rval)
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         if (rval < 0)
            Handle_Problem( "Couldn't open IN() Requester!", 
                            "Z80 IN() Port Problem!", &rval 
                          );

         else if (rval < 256)
            reg[A] = rval & 0x000000FF;
         else 
            reg[A] = 0;

         INCPC( 2 );
         }
         break;
         
      case 221:                               /* indexed inst. DD (IX) */
         status = decode_mach2( byte2, IX );
         if (status != SKIP_INC)
            INCPC( 2 );
         break;

      case 222:                               /* SBC A,n */
         Output_Code( "SBC A,", dreg[PC], REGA2, -1, -1, 
                      222, byte2, -1, -1 
                    );

         sbc_reg( A, byte2, N );
         INCPC( 1 );
         break;

      case 227: 
         Output_Code( "EX (SP),HL", dreg[PC], IMPL, -1, -1, 
                      227, -1, -1, -1 
                    );

         INCPC( 1 );

         if (reg[L] != mem[SP])
            {
            sregchanged[L] = TRUE;
            }
         else
            {
            sregchanged[L] = FALSE;
            }            

         temp = reg[L]; reg[L] = mem[SP];   mem[SP] = temp;

         if (reg[H] != mem[SP + 1])
            {
            sregchanged[H] = TRUE;
            }
         else
            {
            sregchanged[H] = FALSE;
            }            

         temp = reg[H]; reg[H] = mem[SP+1]; mem[SP] = temp;
         break;
 
      case 230:                               /* AND n */
         Output_Code( "AND ", dreg[PC], IMMD, -1, -1, 
                      230, byte2, -1, -1 
                    );

         log_reg( byte2, AND, M );
         INCPC( 1 );
         break;

      case 233: 
         Output_Code( "JP (HL)", dreg[PC], IMPL, -1, -1, 233, -1 , -1, -1 );
         INCPC( 1 );
         dreg[PC] = HL_addr;
         break;

      case 235: 
         Output_Code( "EX DE,HL", dreg[PC], IMPL, -1, -1, 235, -1, -1, -1 );
         INCPC( 2 );

         if (reg[D] != reg[H])
            {
            sregchanged[D] = TRUE;
            sregchanged[H] = TRUE;
            }
         else
            {
            sregchanged[D] = FALSE;
            sregchanged[H] = FALSE;
            }            

         temp = reg[H]; reg[H] = reg[D]; reg[D] = temp;

         if (reg[L] != reg[E])
            {
            sregchanged[E] = TRUE;
            sregchanged[L] = TRUE;
            }
         else
            {
            sregchanged[E] = FALSE;
            sregchanged[L] = FALSE;
            }            

         temp = reg[L]; reg[L] = reg[E]; reg[E] = temp;
         break;

      case 237:                               /* indexed inst. ED (T2) */
         status = decode_mach2( byte2, T2 );
         if (status != RETURN_FOUND)
            INCPC( 2 );
         break;

      case 238:                               /* XOR n */
         Output_Code( "XOR ", dreg[PC], IMMD, -1, -1, 238, byte2, -1, -1 );
         log_reg( byte2, XOR, N );
         INCPC( 1 );
         break;

      case 243: 
         Output_Code( "DI", dreg[PC], IMPL, -1, -1, 243, -1, -1, -1);
         INCPC( 1 );
         IFF1_2 = 0;  
         break;
         
      case 246:                               /* OR n */
         Output_Code( "OR ", dreg[PC], IMMD, -1, -1, 246, byte2, -1, -1 );
         log_reg( byte2, OR, N );
         INCPC( 1 );
         break;

      case 249: 
         Output_Code( "LD SP,HL", dreg[PC], IMPL, -1, -1, 249, -1, -1, -1 );
         INCPC( 1 );

         if (dreg[SP] != HL_addr)
            dregchanged[SP] = TRUE;
         else
            dregchanged[SP] = FALSE;

         dreg[SP] = HL_addr;
         break;

      case 251: 
         Output_Code( "EI", dreg[PC], IMPL, -1, -1, 251, -1, -1, -1 );
         INCPC( 1 );
         IFF1_2 = IFF1 | IFF2;  
         break;
         
      case 253:                             /* indexed inst. FD (IY) */
         status = decode_mach2( byte2, IY );
         if (status != SKIP_INC)
            INCPC( 2 );                        /* for FD & byte2! */
         break;

      case 254:                             /* CP n */
         Output_Code( "CP ", dreg[PC], IMMD, -1, -1, 254, byte2, -1, -1 );
         log_reg( byte2, CP, N );  /* PC gets incremented here also! */
         INCPC( 1 );
         break;

      default:  
         ILLEGAL();
      }

   dregchanged[PC] = TRUE;

   return( (int) status );
}

/* -------------------- End of Z80ST1.c ---------------------- */
