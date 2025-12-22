/****h* Z80Simulator/Z80S24.c [2.5] ************************************
*
* NAME
*    Z80S24.C
*
* NOTES
*    EXTERNAL CALLS:  Functions      in Z80Mach.c
*                     Output_Code()  in Z80Code.c
*
* DESCRIPTION
*    Decode the shifts and bit instructions.
*
* SYNOPSIS
*    int status = Logical_Bits( int state2 );
*
*    PARAMETERS:    state2 - The 2nd byte (mem[dreg[PC] + 1])
*                            of the machine code.
*
* RETURNS
*    Integer = status of processor.
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

#define   CBTAB    0xCB

IMPORT UBYTE *mem, reg[];
IMPORT UWORD  dreg[];
IMPORT BOOL   sregchanged[], dregchanged[];

PRIVATE void Check_For_Zero( int val, int bit )
{
   if ((val & bit) == 0)
      SETZERO();
   else
      RESETZERO();

   sregchanged[F] = TRUE;   
   return;
}

PUBLIC int Logical_Bits( int state2 )
{
   int  status, temp, b3, b4, B3, B4, HL_addr;

   b3 = mem[ dreg[PC] + 2 ];
   B3 = b3;

   b4 = 256 * mem[ dreg[PC] + 3 ];
   B4 = mem[ dreg[PC] + 3 ];

   HL_addr = 256 * reg[H] + reg[L];

   status         = RUNNING;
   sregchanged[F] = FALSE;   

   switch( state2 )  
      {
      case 0: case 1: case 2:                /* RLC r */
      case 3: case 4: case 5:
         temp = 2 * state2 + 2;
         Output_Code( "RLC ", dreg[PC], REGA2, -1, temp, CBTAB, state2,-1,-1);
         rlc_reg( temp, RG ); 
         break;

      case 6:
         Output_Code( "RLC (HL)", dreg[PC], IMPL, -1, -1,CBTAB, 6, -1, -1 );
         rlc_reg( mem[ HL_addr ], M );
         break;

      case 7:
         Output_Code( "RLC A", dreg[PC], IMPL, -1, -1, CBTAB, 7, -1, -1 );
         rlc_reg( A, RG );  
         break;

      case 8:  case 9:  case 10:          /* RRC r */
      case 11: case 12: case 13:
         Output_Code( "RRC ", dreg[PC], REGA2, -1, (state2 - 7) * 2,
                       CBTAB, state2, -1, -1 );
         rrc_reg( (state2 - 7) * 2, RG ); 
         break;
         
      case 14:
         Output_Code( "RRC (HL)", dreg[PC], IMPL, -1, -1, CBTAB, 14,-1,-1);
         rrc_reg( mem[ HL_addr ], M );
         break;

      case 15:
         Output_Code( "RRC A", dreg[PC], IMPL, -1, -1, CBTAB, 15, -1, -1 );
         rrc_reg( A, RG );  
         break;

      case 16: case 17: case 18:       /* RL r */
      case 19: case 20: case 21:
         Output_Code( "RL ", dreg[PC], REGA2, -1, (state2 - 15) * 2,
                       CBTAB, state2, -1, -1 );

         rl_reg( (state2 - 15) * 2, RG ); 
         break;

      case 22:
         Output_Code( "RL (HL)", dreg[PC], IMPL, -1,-1,CBTAB, 22, -1, -1 );
         rl_reg( mem[ HL_addr ], M );
         break;

      case 23:
         Output_Code( "RL A", dreg[PC], IMPL, -1, -1, CBTAB, 23, -1, -1 );
         rl_reg( A, RG ); 
         break;

      case 24: case 25: case 26:        /* RR r */
      case 27: case 28: case 29:
         Output_Code( "RR ", dreg[PC], REGA2, -1, (state2 - 23) * 2,
                       CBTAB, state2, -1, -1 );

         rr_reg( (state2 - 23) * 2, RG ); 
         break;

      case 30:
         Output_Code( "RR (HL)", dreg[PC], IMPL, -1, -1,CBTAB, 30, -1, -1);
         rr_reg( mem[ HL_addr ], M );
         break;

      case 31:
         Output_Code( "RR A", dreg[PC], IMPL, -1, -1, CBTAB, 31, -1, -1 );
         rr_reg( A, RG ); 
         break;

      case 32: case 33: case 34:       /* SLA r */
      case 35: case 36: case 37:
         Output_Code( "SLA ", dreg[PC], REGA2, -1, (state2 - 31) * 2,
                       CBTAB, state2, -1, -1 );

         sla_reg( (state2 - 31) * 2, RG ); 
         break;

      case 38:
         Output_Code( "SLA (HL)", dreg[PC], IMPL, -1, -1,CBTAB,38, -1,-1);
         sla_reg( mem[ HL_addr ], M );
         break;

      case 39:
         Output_Code( "SLA A", dreg[PC], IMPL, -1, -1, CBTAB, 39, -1, -1 );
         sla_reg( A, RG ); 
         break;

      case 40: case 41: case 42:        /* SRA r */
      case 43: case 44: case 45:
         Output_Code( "SRA ", dreg[PC], REGA2, -1, (state2 - 39) * 2,
                       CBTAB, state2, -1, -1 );

         sra_reg( (state2 - 39) * 2, RG ); 
         break;

      case 46:
         Output_Code( "SRA (HL)", dreg[PC], IMPL, -1,-1,CBTAB,46, -1, -1 );
         sra_reg( mem[ HL_addr ], M );
         break;

      case 47:
         Output_Code( "SRA A", dreg[PC], IMPL, -1, -1, CBTAB, 47, -1, -1 );
         sra_reg( A, RG ); 
         break;

      case 48: case 49: case 50:
      case 51: case 52: case 53:
      case 54: case 55:
         ILLEGAL();

      case 56: case 57: case 58:        /* SRL r */
      case 59: case 60: case 61:
         Output_Code( "SRL ", dreg[PC], REGA2, -1, (state2 - 55) * 2,
                       CBTAB, state2, -1, -1 );

         srl_reg( (state2 - 55) * 2, RG ); 
         break;

      case 62:               /* SRL (HL) */
         Output_Code( "SRL (HL)", dreg[PC], IMPL, -1, -1,CBTAB,62,-1, -1 );
         srl_reg( mem[ HL_addr ], M );
         break; 

      case 63:
         Output_Code( "SRL A", dreg[PC], IMPL, -1, -1, CBTAB, 63, -1, -1 );
         srl_reg( A, RG );
         break;

      case 64: case 65: case 66:
      case 67: case 68: case 69:               /* BIT 0,r */
         temp = (state2 - 63) * 2;
         Output_Code( "BIT ", dreg[PC], BITA, 0, temp,
                       CBTAB, state2, -1, -1 );

         Check_For_Zero( reg[ temp ], 1 );
         break;

      case 70:
         Output_Code( "BIT 00,(HL)", dreg[PC], IMPL, -1,-1,CBTAB,70,-1,-1);
         Check_For_Zero( mem[ HL_addr ], 1 );
         break;

      case 71:
         Output_Code( "BIT 00,A", dreg[PC], IMPL, -1, -1,CBTAB,71, -1,-1 );
         Check_For_Zero( reg[A], 1 );
         break;

      case 72: case 73: case 74:
      case 75: case 76: case 77:              /* BIT 1,r */
         temp = (state2 - 71) * 2;
         Output_Code( "BIT ", dreg[PC], BITA, 1, temp,
                       CBTAB, state2, -1, -1 );

         Check_For_Zero( reg[ temp ], 2 );
         break;

      case 78:
         Output_Code( "BIT 01,(HL)", dreg[PC], IMPL, -1,-1,CBTAB,78,-1,-1);
         Check_For_Zero( mem[ HL_addr ], 2 );
         break;

      case 79:
         Output_Code( "BIT 01,A", dreg[PC], IMPL, -1, -1,CBTAB,79,-1,-1 );
         Check_For_Zero( reg[A], 2 );
         break;

      case 80: case 81: case 82:
      case 83: case 84: case 85:              /* BIT 2,r */
         temp = (state2 - 79) * 2;
         Output_Code( "BIT ", dreg[PC], BITA, 2, temp,
                       CBTAB, state2, -1, -1 );

         Check_For_Zero( reg[ temp ], 4 );
         break;

      case 86:
         Output_Code( "BIT 02,(HL)", dreg[PC], IMPL, -1, -1, CBTAB, 86,-1,-1);
         Check_For_Zero( mem[ HL_addr ], 4 );
         break;

      case 87:
         Output_Code( "BIT 02,A", dreg[PC], IMPL, -1, -1, CBTAB, 87, -1, -1 );
         Check_For_Zero( reg[A], 4 );
         break;

      case 88: case 89: case 90:
      case 91: case 92: case 93:              /* BIT 3,r */
         temp = (state2 - 87) * 2;

         Output_Code( "BIT ", dreg[PC], BITA, 3, temp,
                       CBTAB, state2, -1, -1 );
         Check_For_Zero( reg[ temp ], 8 );
         break;

      case 94:
         Output_Code( "BIT 03,(HL)", dreg[PC], IMPL, -1, -1, CBTAB, 94,-1,-1);
         Check_For_Zero( mem[ HL_addr ], 8 );
         break;

      case 95:
         Output_Code( "BIT 03,A", dreg[PC], IMPL, -1, -1, CBTAB, 95, -1, -1 );
         Check_For_Zero( reg[A], 8 );
         break;

      case 96: case 97:  case 98:
      case 99: case 100: case 101:              /* BIT 4,r */
         temp = (state2 - 95) * 2;

         Output_Code( "BIT ", dreg[PC], BITA, 4, temp,
                       CBTAB, state2, -1, -1 );
         Check_For_Zero( reg[ temp ], 16 );
         break;

      case 102:
         Output_Code( "BIT 04,(HL)", dreg[PC], IMPL, -1, -1, CBTAB, 102,-1,-1);
         Check_For_Zero( mem[ HL_addr ], 16 );
         break;

      case 103:
         Output_Code( "BIT 04,A", dreg[PC], IMPL, -1, -1, CBTAB, 103, -1, -1);
         Check_For_Zero( reg[A], 16 );
         break;

      case 104: case 105: case 106:
      case 107: case 108: case 109:              /* BIT 5,r */
         temp = (state2 - 103) * 2;

         Output_Code( "BIT ", dreg[PC], BITA, 5, temp,
                       CBTAB, state2, -1, -1 );
         Check_For_Zero( reg[ temp ], 32 );
         break;

      case 110:
         Output_Code( "BIT 05,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 110, -1,-1);
         Check_For_Zero( mem[ HL_addr ], 32 );
         break;

      case 111:
         Output_Code( "BIT 05,A", dreg[PC], IMPL, -1, -1, CBTAB, 111, -1, -1);
         Check_For_Zero( reg[A], 32 );
         break;

      case 112: case 113: case 114:
      case 115: case 116: case 117:          /* BIT 6,r */
         temp = (state2 - 111) * 2;

         Output_Code( "BIT ", dreg[PC], BITA, 6, temp,
                       CBTAB, state2, -1, -1 );

         Check_For_Zero( reg[ temp ], 64 );
         break;

      case 118:
         Output_Code( "BIT 06,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 118, -1,-1);
         Check_For_Zero( mem[ HL_addr ], 64 );
         break;

      case 119:
         Output_Code( "BIT 06,A", dreg[PC], IMPL, -1, -1, CBTAB, 119, -1, -1);
         Check_For_Zero( reg[A], 64 );
         break;

      case 120: case 121: case 122:
      case 123: case 124: case 125:              /* BIT 7,r */
         temp = (state2 - 119) * 2;

         Output_Code( "BIT ", dreg[PC], BITA, 7, temp,
                       CBTAB, state2, -1, -1 );

         Check_For_Zero( reg[ temp ], 128 );
         break;

      case 126:
         Output_Code( "BIT 07,(HL)", dreg[PC], IMPL, -1, -1, CBTAB, 126,-1,-1);
         Check_For_Zero( mem[ HL_addr ], 128 );
         break;

      case 127:
         Output_Code( "BIT 07,A", dreg[PC], IMPL, -1, -1, CBTAB, 127, -1, -1);
         Check_For_Zero( reg[A], 128 );
         break;

      case 128: case 129: case 130:
      case 131: case 132: case 133:             /* RES 0,r */
         temp = (state2 - 127) * 2;

         Output_Code( "RES ", dreg[PC], BITA, 0, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xFE) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xFE;  
         break;

      case 134:
         Output_Code( "RES 00,(HL)", dreg[PC], IMPL, -1, -1, CBTAB, 134,-1,-1);
         mem[ HL_addr ] &= 0xFE;
         break;

      case 135:
         Output_Code( "RES 00,A", dreg[PC], IMPL, -1, -1, CBTAB, 135, -1, -1);

         if ((reg[A] & 0xFE) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xFE;  
         break;

      case 136: case 137: case 138:
      case 139: case 140: case 141:         /* RES 1,r */
         temp = (state2 - 135) * 2;

         Output_Code( "RES ", dreg[PC], BITA, 1, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xFD) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xFD;  
         break;

      case 142:
         Output_Code( "RES 01,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 142, -1,-1);
         mem[ HL_addr ] &= 0xFD;
         break;

      case 143:
         Output_Code( "RES 01,A", dreg[PC], IMPL, -1, -1, CBTAB, 143, -1, -1);

         if ((reg[A] & 0xFD) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xFD;  
         break;

      case 144: case 145: case 146:
      case 147: case 148: case 149:         /* RES 2,r */
         temp = (state2 - 143) * 2;
         Output_Code( "RES ", dreg[PC], BITA, 2, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xFB) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xFB;  
         break;

      case 150:
         Output_Code( "RES 02,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 150, -1,-1);
         mem[ HL_addr ] &= 0xFB;
         break;

      case 151:
         Output_Code( "RES 02,A", dreg[PC], IMPL, -1, -1, CBTAB, 151, -1, -1);

         if ((reg[A] & 0xFB) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xFB;  
         break;

      case 152: case 153: case 154:
      case 155: case 156: case 157:         /* RES 3,r */
         temp = (state2 - 151) * 2;
         Output_Code( "RES ", dreg[PC], BITA, 3, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xF7) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xF7;  
         break;

      case 158:
         Output_Code( "RES 03,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 158, -1,-1);
         mem[ HL_addr ] &= 0xF7;
         break;

      case 159:
         Output_Code( "RES 03,A", dreg[PC], IMPL, -1, -1, CBTAB, 159, -1, -1);

         if ((reg[A] & 0xF7) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xF7;  
         break;

      case 160: case 161: case 162:
      case 163: case 164: case 165:         /* RES 4,r */
         temp = (state2 - 159) * 2;
         Output_Code( "RES ", dreg[PC], BITA, 4, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xEF) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xEF;  
         break;

      case 166:
         Output_Code( "RES 04,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 166, -1,-1);
         mem[ HL_addr ] &= 0xEF;
         break;

      case 167:
         Output_Code( "RES 04,A", dreg[PC], IMPL, -1, -1, CBTAB, 167, -1, -1);

         if ((reg[A] & 0xEF) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xEF;  
         break;

      case 168: case 169: case 170:
      case 171: case 172: case 173:         /* RES 5,r */
         temp = (state2 - 167) * 2;
         Output_Code( "RES ", dreg[PC], BITA, 5, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xDF) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xDF;  
         break;

      case 174:
         Output_Code( "RES 05,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 174, -1,-1);
         mem[ HL_addr ] &= 0xDF;
         break;

      case 175:
         Output_Code( "RES 05,A", dreg[PC], IMPL, -1, -1, CBTAB, 175, -1, -1);

         if ((reg[A] & 0xDF) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xDF;  
         break;

      case 176: case 177: case 178:
      case 179: case 180: case 181:         /* RES 6,r */
         temp = (state2 - 175) * 2;
         Output_Code( "RES ", dreg[PC], BITA, 6, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0xBF) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0xBF;  
         break;

      case 182:
         Output_Code( "RES 06,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 182, -1,-1);
         mem[ HL_addr ] &= 0xBF;
         break;

      case 183:
         Output_Code( "RES 06,A", dreg[PC], IMPL, -1, -1, CBTAB, 183, -1, -1);

         if ((reg[A] & 0xBF) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0xBF;  
         break;

      case 184: case 185: case 186:
      case 187: case 188: case 189:         /* RES 7,r */
         temp = (state2 - 183) * 2;
         Output_Code( "RES ", dreg[PC], BITA, 7, temp,
                       CBTAB, state2, -1, -1 );

         if ((reg[temp] & 0x7F) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] &= 0x7F;  
         break;

      case 190:
         Output_Code( "RES 07,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 190, -1,-1);
         mem[ HL_addr ] &= 0x7F;
         break;

      case 191:
         Output_Code( "RES 07,A", dreg[PC], IMPL, -1, -1, CBTAB, 191, -1, -1);

         if ((reg[A] & 0x7F) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] &= 0x7F;  
         break;

      case 192: case 193: case 194:
      case 195: case 196: case 197:         /* SET 0,r */
         temp = (state2 - 191) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 0, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 1) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 1;     
         break;

      case 198:
         Output_Code( "SET 00,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 198, -1,-1);
         mem[ HL_addr ] |= 1;
         break;

      case 199:
         Output_Code( "SET 00,A", dreg[PC], IMPL, -1, -1, CBTAB, 199, -1, -1);

         if ((reg[A] | 1) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 1;     
         break;

      case 200: case 201: case 202:
      case 203: case 204: case 205:         /* SET 1,r */
         temp = (state2 - 199) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 1, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 2) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 2;     
         break;

      case 206:
         Output_Code( "SET 01,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 206, -1,-1);
         mem[ HL_addr ] |= 2;
         break;

      case 207:
         Output_Code( "SET 01,A", dreg[PC], IMPL, -1, -1, CBTAB, 207, -1, -1);

         if ((reg[A] | 2) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 2;   
         break;

      case 208: case 209: case 210:
      case 211: case 212: case 213:         /* SET 2,r */
         temp = (state2 - 207) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 2, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 4) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 4;     
         break;

      case 214:
         Output_Code( "SET 02,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 214, -1,-1);
         mem[ HL_addr ] |= 4;
         break;

      case 215:
         Output_Code( "SET 02,A", dreg[PC], IMPL, -1, -1, CBTAB, 215, -1, -1);

         if ((reg[A] | 4) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 4;  
         break;

      case 216: case 217: case 218:
      case 219: case 220: case 221:         /* SET 3,r */
         temp = (state2 - 215) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 3, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 8) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 8;     
         break;

      case 222:
         Output_Code( "SET 03,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 222, -1,-1);
         mem[ HL_addr ] |= 8;
         break;

      case 223:
         Output_Code( "SET 03,A", dreg[PC], IMPL, -1, -1, CBTAB, 223, -1, -1);

         if ((reg[A] | 8) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 8;  
         break;

      case 224: case 225: case 226:
      case 227: case 228: case 229:         /* SET 4,r */
         temp = (state2 - 223) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 4, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 16) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 16;    
         break;

      case 230:
         Output_Code( "SET 04,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 230, -1,-1);
         mem[ HL_addr ] |= 16;
         break;

      case 231:
         Output_Code( "SET 04,A", dreg[PC], IMPL, -1, -1, CBTAB, 231, -1, -1);

         if ((reg[A] | 16) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 16;  
         break;

      case 232: case 233: case 234:
      case 235: case 236: case 237:         /* SET 5,r */
         temp = (state2 - 231) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 5, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 32) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 32;    
         break;

      case 238:
         Output_Code( "SET 05,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 238, -1,-1);
         mem[ HL_addr ] |= 32;
         break;

      case 239:
         Output_Code( "SET 05,A", dreg[PC], IMPL, -1, -1, CBTAB, 239, -1, -1);

         if ((reg[A] | 32) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 32;  
         break;

      case 240: case 241: case 242:
      case 243: case 244: case 245:         /* SET 6,r */
         temp = (state2 - 239) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 6, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 64) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 64;    
         break;

      case 246:
         Output_Code( "SET 06,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 246, -1,-1);
         mem[ HL_addr ] |= 64;
         break;

      case 247:
         Output_Code( "SET 06,A", dreg[PC], IMPL, -1, -1, CBTAB, 247, -1, -1);

         if ((reg[A] | 64) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 64;   
         break;

      case 248: case 249: case 250:
      case 251: case 252: case 253:         /* SET 7,r */
         temp = (state2 - 247) * 2;
         Output_Code( "SET ", dreg[PC], BITA, 7, temp, CBTAB, state2, -1, -1);

         if ((reg[temp] | 128) != reg[temp])
            sregchanged[temp] = TRUE;
         else
            sregchanged[temp] = FALSE;
            
         reg[ temp ] |= 128;   
         break;

      case 254:
         Output_Code( "SET 07,(HL)", dreg[PC], IMPL, -1,-1, CBTAB, 254, -1,-1);
         mem[ HL_addr ] |= 128;
         break;

      case 255:
         Output_Code( "SET 07,A", dreg[PC], IMPL, -1, -1, CBTAB, 255, -1, -1);

         if ((reg[A] | 128) != reg[A])
            sregchanged[A] = TRUE;
         else
            sregchanged[A] = FALSE;
            
         reg[A] |= 128;  
         break;

      default:
         ILLEGAL();
      }              // ------- END OF T1 SWITCH TABLE!! --------

   dregchanged[PC] = TRUE;
   
   return( (int) status);
}

/* -------------------- End of Z80S24.c --------------------- */
