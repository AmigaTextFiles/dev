/****h* Z80Simulator/Z80DisAssembler.c [2.5] **************************
*
* NAME
*    Z80DisAssembler.c
*
* DESCRIPTION
*    The DisAssembler function for printing listings.
*
* FUNCTION
*    Decode the Opcodes in memory & generate the proper Instruction
*    string; then increment the address given.
*
* RETURNS
*    Z80 assembly instruction string.
*
* LAST CHANGED:  04/02/94 - Created file.
*
***********************************************************************
*
*/

#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include <exec/types.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include <MyFunctions.h>

#include "Z80FuncProtos.h"

IMPORT   UBYTE    *mem;

PRIVATE char  TEMP[ 25 ], *Mnemonic = &TEMP[0];

PRIVATE void  DecodeCB( int *addr )
{
   switch (mem[ *addr ])
      {
      case 0:  strcpy( Mnemonic, "\t\tRLC B" );               break;
      case 1:  strcpy( Mnemonic, "\t\tRLC C" );               break;
      case 2:  strcpy( Mnemonic, "\t\tRLC D" );               break;
      case 3:  strcpy( Mnemonic, "\t\tRLC E" );               break;
      case 4:  strcpy( Mnemonic, "\t\tRLC H" );               break;
      case 5:  strcpy( Mnemonic, "\t\tRLC L" );               break;
      case 6:  strcpy( Mnemonic, "\t\tRLC (HL)" );            break;
      case 7:  strcpy( Mnemonic, "\t\tRLC A" );               break;
      case 8:  strcpy( Mnemonic, "\t\tRRC B" );               break;
      case 9:  strcpy( Mnemonic, "\t\tRRC C" );               break;
      case 10: strcpy( Mnemonic, "\t\tRRC D" );               break;
      case 11: strcpy( Mnemonic, "\t\tRRC E" );               break;
      case 12: strcpy( Mnemonic, "\t\tRRC H" );               break;
      case 13: strcpy( Mnemonic, "\t\tRRC L" );               break;
      case 14: strcpy( Mnemonic, "\t\tRRC (HL)" );            break;
      case 15: strcpy( Mnemonic, "\t\tRRC A" );               break;
      case 16: strcpy( Mnemonic, "\t\tRL B" );                break;
      case 17: strcpy( Mnemonic, "\t\tRL C" );                break;
      case 18: strcpy( Mnemonic, "\t\tRL D" );                break;
      case 19: strcpy( Mnemonic, "\t\tRL E" );                break;
      case 20: strcpy( Mnemonic, "\t\tRL H" );                break;
      case 21: strcpy( Mnemonic, "\t\tRL L" );                break;
      case 22: strcpy( Mnemonic, "\t\tRL (HL)" );             break;
      case 23: strcpy( Mnemonic, "\t\tRL A" );                break;
      case 24: strcpy( Mnemonic, "\t\tRR B" );                break;
      case 25: strcpy( Mnemonic, "\t\tRR C" );                break;
      case 26: strcpy( Mnemonic, "\t\tRR D" );                break;
      case 27: strcpy( Mnemonic, "\t\tRR E" );                break;
      case 28: strcpy( Mnemonic, "\t\tRR H" );                break;
      case 29: strcpy( Mnemonic, "\t\tRR L" );                break;
      case 30: strcpy( Mnemonic, "\t\tRR (HL)" );             break;
      case 31: strcpy( Mnemonic, "\t\tRR A" );                break;
      case 32: strcpy( Mnemonic, "\t\tSLA B" );               break;
      case 33: strcpy( Mnemonic, "\t\tSLA C" );               break;
      case 34: strcpy( Mnemonic, "\t\tSLA D" );               break;
      case 35: strcpy( Mnemonic, "\t\tSLA E" );               break;
      case 36: strcpy( Mnemonic, "\t\tSLA H" );               break;
      case 37: strcpy( Mnemonic, "\t\tSLA L" );               break;
      case 38: strcpy( Mnemonic, "\t\tSLA (HL)" );            break;
      case 39: strcpy( Mnemonic, "\t\tSLA A" );               break;
      case 40: strcpy( Mnemonic, "\t\tSRA B" );               break;
      case 41: strcpy( Mnemonic, "\t\tSRA C" );               break;
      case 42: strcpy( Mnemonic, "\t\tSRA D" );               break;
      case 43: strcpy( Mnemonic, "\t\tSRA E" );               break;
      case 44: strcpy( Mnemonic, "\t\tSRA H" );               break;
      case 45: strcpy( Mnemonic, "\t\tSRA L" );               break;
      case 46: strcpy( Mnemonic, "\t\tSRA (HL)" );            break;
      case 47: strcpy( Mnemonic, "\t\tSRA A" );               break;

      case 48: case 49: case 50: case  51: case  52:
      case 53: case 54: case 55:
               strcpy( Mnemonic, "\t\t** INVALID CB ??" );       break;
               
      case 56: strcpy( Mnemonic, "\t\tSRL B" );               break;
      case 57: strcpy( Mnemonic, "\t\tSRL C" );               break;
      case 58: strcpy( Mnemonic, "\t\tSRL D" );               break;
      case 59: strcpy( Mnemonic, "\t\tSRL E" );               break;
      case 60: strcpy( Mnemonic, "\t\tSRL H" );               break;
      case 61: strcpy( Mnemonic, "\t\tSRL L" );               break;
      case 62: strcpy( Mnemonic, "\t\tSRL (HL)" );            break;
      case 63: strcpy( Mnemonic, "\t\tSRL A" );               break;
      case 64: strcpy( Mnemonic, "\t\tBIT 0,B" );             break;
      case 65: strcpy( Mnemonic, "\t\tBIT 0,C" );             break;
      case 66: strcpy( Mnemonic, "\t\tBIT 0,D" );             break;
      case 67: strcpy( Mnemonic, "\t\tBIT 0,E" );             break;
      case 68: strcpy( Mnemonic, "\t\tBIT 0,H" );             break;
      case 69: strcpy( Mnemonic, "\t\tBIT 0,L" );             break;
      case 70: strcpy( Mnemonic, "\t\tBIT 0,(HL)" );          break;
      case 71: strcpy( Mnemonic, "\t\tBIT 0,A" );             break;
      case 72: strcpy( Mnemonic, "\t\tBIT 1,B" );             break;
      case 73: strcpy( Mnemonic, "\t\tBIT 1,C" );             break;
      case 74: strcpy( Mnemonic, "\t\tBIT 1,D" );             break;
      case 75: strcpy( Mnemonic, "\t\tBIT 1,E" );             break;
      case 76: strcpy( Mnemonic, "\t\tBIT 1,H" );             break;
      case 77: strcpy( Mnemonic, "\t\tBIT 1,L" );             break;
      case 78: strcpy( Mnemonic, "\t\tBIT 1,(HL)" );          break;
      case 79: strcpy( Mnemonic, "\t\tBIT 1,A" );             break;
      case 80: strcpy( Mnemonic, "\t\tBIT 2,B" );             break;
      case 81: strcpy( Mnemonic, "\t\tBIT 2,C" );             break;
      case 82: strcpy( Mnemonic, "\t\tBIT 2,D" );             break;
      case 83: strcpy( Mnemonic, "\t\tBIT 2,E" );             break;
      case 84: strcpy( Mnemonic, "\t\tBIT 2,H" );             break;
      case 85: strcpy( Mnemonic, "\t\tBIT 2,L" );             break;
      case 86: strcpy( Mnemonic, "\t\tBIT 2,(HL)" );          break;
      case 87: strcpy( Mnemonic, "\t\tBIT 2,A" );             break;
      case 88: strcpy( Mnemonic, "\t\tBIT 3,B" );             break;
      case 89: strcpy( Mnemonic, "\t\tBIT 3,C" );             break;
      case 90: strcpy( Mnemonic, "\t\tBIT 3,D" );             break;
      case 91: strcpy( Mnemonic, "\t\tBIT 3,E" );             break;
      case 92: strcpy( Mnemonic, "\t\tBIT 3,H" );             break;
      case 93: strcpy( Mnemonic, "\t\tBIT 3,L" );             break;
      case 94: strcpy( Mnemonic, "\t\tBIT 3,(HL)" );          break;
      case 95: strcpy( Mnemonic, "\t\tBIT 3,A" );             break;
      case 96: strcpy( Mnemonic, "\t\tBIT 4,B" );             break;
      case 97: strcpy( Mnemonic, "\t\tBIT 4,C" );             break;
      case 98: strcpy( Mnemonic, "\t\tBIT 4,D" );             break;
      case 99: strcpy( Mnemonic, "\t\tBIT 4,E" );             break;

      case 100: strcpy( Mnemonic, "\t\tBIT 4,H" );             break;
      case 101: strcpy( Mnemonic, "\t\tBIT 4,L" );             break;
      case 102: strcpy( Mnemonic, "\t\tBIT 4,(HL)" );          break;
      case 103: strcpy( Mnemonic, "\t\tBIT 4,A" );             break;
      case 104: strcpy( Mnemonic, "\t\tBIT 5,B" );             break;
      case 105: strcpy( Mnemonic, "\t\tBIT 5,C" );             break;
      case 106: strcpy( Mnemonic, "\t\tBIT 5,D" );             break;
      case 107: strcpy( Mnemonic, "\t\tBIT 5,E" );             break;
      case 108: strcpy( Mnemonic, "\t\tBIT 5,H" );             break;
      case 109: strcpy( Mnemonic, "\t\tBIT 5,L" );             break;
      case 110: strcpy( Mnemonic, "\t\tBIT 5,(HL)" );          break;
      case 111: strcpy( Mnemonic, "\t\tBIT 5,A" );             break;
      case 112: strcpy( Mnemonic, "\t\tBIT 6,B" );             break;
      case 113: strcpy( Mnemonic, "\t\tBIT 6,C" );             break;
      case 114: strcpy( Mnemonic, "\t\tBIT 6,D" );             break;
      case 115: strcpy( Mnemonic, "\t\tBIT 6,E" );             break;
      case 116: strcpy( Mnemonic, "\t\tBIT 6,H" );             break;
      case 117: strcpy( Mnemonic, "\t\tBIT 6,L" );             break;
      case 118: strcpy( Mnemonic, "\t\tBIT 6,(HL)" );          break;
      case 119: strcpy( Mnemonic, "\t\tBIT 6,A" );             break;
      case 120: strcpy( Mnemonic, "\t\tBIT 7,B" );             break;
      case 121: strcpy( Mnemonic, "\t\tBIT 7,C" );             break;
      case 122: strcpy( Mnemonic, "\t\tBIT 7,D" );             break;
      case 123: strcpy( Mnemonic, "\t\tBIT 7,E" );             break;
      case 124: strcpy( Mnemonic, "\t\tBIT 7,H" );             break;
      case 125: strcpy( Mnemonic, "\t\tBIT 7,L" );             break;
      case 126: strcpy( Mnemonic, "\t\tBIT 7,(HL)" );          break;
      case 127: strcpy( Mnemonic, "\t\tBIT 7,A" );             break;
      case 128: strcpy( Mnemonic, "\t\tRES 0,B" );             break;
      case 129: strcpy( Mnemonic, "\t\tRES 0,C" );             break;
      case 130: strcpy( Mnemonic, "\t\tRES 0,D" );             break;
      case 131: strcpy( Mnemonic, "\t\tRES 0,E" );             break;
      case 132: strcpy( Mnemonic, "\t\tRES 0,H" );             break;
      case 133: strcpy( Mnemonic, "\t\tRES 0,L" );             break;
      case 134: strcpy( Mnemonic, "\t\tRES 0,(HL)" );          break;
      case 135: strcpy( Mnemonic, "\t\tRES 0,A" );             break;
      case 136: strcpy( Mnemonic, "\t\tRES 1,B" );             break;
      case 137: strcpy( Mnemonic, "\t\tRES 1,C" );             break;
      case 138: strcpy( Mnemonic, "\t\tRES 1,D" );             break;
      case 139: strcpy( Mnemonic, "\t\tRES 1,E" );             break;
      case 140: strcpy( Mnemonic, "\t\tRES 1,H" );             break;
      case 141: strcpy( Mnemonic, "\t\tRES 1,L" );             break;
      case 142: strcpy( Mnemonic, "\t\tRES 1,(HL)" );          break;
      case 143: strcpy( Mnemonic, "\t\tRES 1,A" );             break;
      case 144: strcpy( Mnemonic, "\t\tRES 2,B" );             break;
      case 145: strcpy( Mnemonic, "\t\tRES 2,C" );             break;
      case 146: strcpy( Mnemonic, "\t\tRES 2,D" );             break;
      case 147: strcpy( Mnemonic, "\t\tRES 2,E" );             break;
      case 148: strcpy( Mnemonic, "\t\tRES 2,H" );             break;
      case 149: strcpy( Mnemonic, "\t\tRES 2,L" );             break;
      case 150: strcpy( Mnemonic, "\t\tRES 2,(HL)" );          break;
      case 151: strcpy( Mnemonic, "\t\tRES 2,A" );             break;
      case 152: strcpy( Mnemonic, "\t\tRES 3,B" );             break;
      case 153: strcpy( Mnemonic, "\t\tRES 3,C" );             break;
      case 154: strcpy( Mnemonic, "\t\tRES 3,D" );             break;
      case 155: strcpy( Mnemonic, "\t\tRES 3,E" );             break;
      case 156: strcpy( Mnemonic, "\t\tRES 3,H" );             break;
      case 157: strcpy( Mnemonic, "\t\tRES 3,L" );             break;
      case 158: strcpy( Mnemonic, "\t\tRES 3,(HL)" );          break;
      case 159: strcpy( Mnemonic, "\t\tRES 3,A" );             break;
      case 160: strcpy( Mnemonic, "\t\tRES 4,B" );             break;
      case 161: strcpy( Mnemonic, "\t\tRES 4,C" );             break;
      case 162: strcpy( Mnemonic, "\t\tRES 4,D" );             break;
      case 163: strcpy( Mnemonic, "\t\tRES 4,E" );             break;
      case 164: strcpy( Mnemonic, "\t\tRES 4,H" );             break;
      case 165: strcpy( Mnemonic, "\t\tRES 4,L" );             break;
      case 166: strcpy( Mnemonic, "\t\tRES 4,(HL)" );          break;
      case 167: strcpy( Mnemonic, "\t\tRES 4,A" );             break;
      case 168: strcpy( Mnemonic, "\t\tRES 5,B" );             break;
      case 169: strcpy( Mnemonic, "\t\tRES 5,C" );             break;
      case 170: strcpy( Mnemonic, "\t\tRES 5,D" );             break;
      case 171: strcpy( Mnemonic, "\t\tRES 5,E" );             break;
      case 172: strcpy( Mnemonic, "\t\tRES 5,H" );             break;
      case 173: strcpy( Mnemonic, "\t\tRES 5,L" );             break;
      case 174: strcpy( Mnemonic, "\t\tRES 5,(HL)" );          break;
      case 175: strcpy( Mnemonic, "\t\tRES 5,A" );             break;
      case 176: strcpy( Mnemonic, "\t\tRES 6,B" );             break;
      case 177: strcpy( Mnemonic, "\t\tRES 6,C" );             break;
      case 178: strcpy( Mnemonic, "\t\tRES 6,D" );             break;
      case 179: strcpy( Mnemonic, "\t\tRES 6,E" );             break;
      case 180: strcpy( Mnemonic, "\t\tRES 6,H" );             break;
      case 181: strcpy( Mnemonic, "\t\tRES 6,L" );             break;
      case 182: strcpy( Mnemonic, "\t\tRES 6,(HL)" );          break;
      case 183: strcpy( Mnemonic, "\t\tRES 6,A" );             break;
      case 184: strcpy( Mnemonic, "\t\tRES 7,B" );             break;
      case 185: strcpy( Mnemonic, "\t\tRES 7,C" );             break;
      case 186: strcpy( Mnemonic, "\t\tRES 7,D" );             break;
      case 187: strcpy( Mnemonic, "\t\tRES 7,E" );             break;
      case 188: strcpy( Mnemonic, "\t\tRES 7,H" );             break;
      case 189: strcpy( Mnemonic, "\t\tRES 7,L" );             break;
      case 190: strcpy( Mnemonic, "\t\tRES 7,(HL)" );          break;
      case 191: strcpy( Mnemonic, "\t\tRES 7,A" );             break;
      case 192: strcpy( Mnemonic, "\t\tSET 0,B" );             break;
      case 193: strcpy( Mnemonic, "\t\tSET 0,C" );             break;
      case 194: strcpy( Mnemonic, "\t\tSET 0,D" );             break;
      case 195: strcpy( Mnemonic, "\t\tSET 0,E" );             break;
      case 196: strcpy( Mnemonic, "\t\tSET 0,H" );             break;
      case 197: strcpy( Mnemonic, "\t\tSET 0,L" );             break;
      case 198: strcpy( Mnemonic, "\t\tSET 0,(HL)" );          break;
      case 199: strcpy( Mnemonic, "\t\tSET 0,A" );             break;
      case 200: strcpy( Mnemonic, "\t\tSET 1,B" );             break;
      case 201: strcpy( Mnemonic, "\t\tSET 1,C" );             break;
      case 202: strcpy( Mnemonic, "\t\tSET 1,D" );             break;
      case 203: strcpy( Mnemonic, "\t\tSET 1,E" );             break;
      case 204: strcpy( Mnemonic, "\t\tSET 1,H" );             break;
      case 205: strcpy( Mnemonic, "\t\tSET 1,L" );             break;
      case 206: strcpy( Mnemonic, "\t\tSET 1,(HL)" );          break;
      case 207: strcpy( Mnemonic, "\t\tSET 1,A" );             break;
      case 208: strcpy( Mnemonic, "\t\tSET 2,B" );             break;
      case 209: strcpy( Mnemonic, "\t\tSET 2,C" );             break;
      case 210: strcpy( Mnemonic, "\t\tSET 2,D" );             break;
      case 211: strcpy( Mnemonic, "\t\tSET 2,E" );             break;
      case 212: strcpy( Mnemonic, "\t\tSET 2,H" );             break;
      case 213: strcpy( Mnemonic, "\t\tSET 2,L" );             break;
      case 214: strcpy( Mnemonic, "\t\tSET 2,(HL)" );          break;
      case 215: strcpy( Mnemonic, "\t\tSET 2,A" );             break;
      case 216: strcpy( Mnemonic, "\t\tSET 3,B" );             break;
      case 217: strcpy( Mnemonic, "\t\tSET 3,C" );             break;
      case 218: strcpy( Mnemonic, "\t\tSET 3,D" );             break;
      case 219: strcpy( Mnemonic, "\t\tSET 3,E" );             break;
      case 220: strcpy( Mnemonic, "\t\tSET 3,H" );             break;
      case 221: strcpy( Mnemonic, "\t\tSET 3,L" );             break;
      case 222: strcpy( Mnemonic, "\t\tSET 3,(HL)" );          break;
      case 223: strcpy( Mnemonic, "\t\tSET 3,A" );             break;
      case 224: strcpy( Mnemonic, "\t\tSET 4,B" );             break;
      case 225: strcpy( Mnemonic, "\t\tSET 4,C" );             break;
      case 226: strcpy( Mnemonic, "\t\tSET 4,D" );             break;
      case 227: strcpy( Mnemonic, "\t\tSET 4,E" );             break;
      case 228: strcpy( Mnemonic, "\t\tSET 4,H" );             break;
      case 229: strcpy( Mnemonic, "\t\tSET 4,L" );             break;
      case 230: strcpy( Mnemonic, "\t\tSET 4,(HL)" );          break;
      case 231: strcpy( Mnemonic, "\t\tSET 4,A" );             break;
      case 232: strcpy( Mnemonic, "\t\tSET 5,B" );             break;
      case 233: strcpy( Mnemonic, "\t\tSET 5,C" );             break;
      case 234: strcpy( Mnemonic, "\t\tSET 5,D" );             break;
      case 235: strcpy( Mnemonic, "\t\tSET 5,E" );             break;
      case 236: strcpy( Mnemonic, "\t\tSET 5,H" );             break;
      case 237: strcpy( Mnemonic, "\t\tSET 5,L" );             break;
      case 238: strcpy( Mnemonic, "\t\tSET 5,(HL)" );          break;
      case 239: strcpy( Mnemonic, "\t\tSET 5,A" );             break;
      case 240: strcpy( Mnemonic, "\t\tSET 6,B" );             break;
      case 241: strcpy( Mnemonic, "\t\tSET 6,C" );             break;
      case 242: strcpy( Mnemonic, "\t\tSET 6,D" );             break;
      case 243: strcpy( Mnemonic, "\t\tSET 6,E" );             break;
      case 244: strcpy( Mnemonic, "\t\tSET 6,H" );             break;
      case 245: strcpy( Mnemonic, "\t\tSET 6,L" );             break;
      case 246: strcpy( Mnemonic, "\t\tSET 6,(HL)" );          break;
      case 247: strcpy( Mnemonic, "\t\tSET 6,A" );             break;
      case 248: strcpy( Mnemonic, "\t\tSET 7,B" );             break;
      case 249: strcpy( Mnemonic, "\t\tSET 7,C" );             break;
      case 250: strcpy( Mnemonic, "\t\tSET 7,D" );             break;
      case 251: strcpy( Mnemonic, "\t\tSET 7,E" );             break;
      case 252: strcpy( Mnemonic, "\t\tSET 7,H" );             break;
      case 253: strcpy( Mnemonic, "\t\tSET 7,L" );             break;
      case 254: strcpy( Mnemonic, "\t\tSET 7,(HL)" );          break;
      case 255: strcpy( Mnemonic, "\t\tSET 7,A" );             break;
      }
   (*addr)++;
   return;
}

PRIVATE void DecodeIdx( int opcode, int disp, char *Idx )
{
   char  nil[ 3 ], *byte = &nil[0];
   
   switch (opcode)
      {
      case 0x06: strcpy( Mnemonic, "\t\tRLC (" );          break;
      case 0x0E: strcpy( Mnemonic, "\t\tRRC (" );          break;
      case 0x16: strcpy( Mnemonic, "\t\tRL (" );           break;
      case 0x1E: strcpy( Mnemonic, "\t\tRR (" );           break;
      case 0x26: strcpy( Mnemonic, "\t\tSLA (" );          break;
      case 0x2E: strcpy( Mnemonic, "\t\tSRA (" );          break;
      case 0x3E: strcpy( Mnemonic, "\t\tSRL (" );          break;
      case 0x46: strcpy( Mnemonic, "\t\tBIT 0,(" );        break;
      case 0x4E: strcpy( Mnemonic, "\t\tBIT 1,(" );        break;
      case 0x56: strcpy( Mnemonic, "\t\tBIT 2,(" );        break;
      case 0x5E: strcpy( Mnemonic, "\t\tBIT 3,(" );        break;
      case 0x66: strcpy( Mnemonic, "\t\tBIT 4,(" );        break;
      case 0x6E: strcpy( Mnemonic, "\t\tBIT 5,(" );        break;
      case 0x76: strcpy( Mnemonic, "\t\tBIT 6,(" );        break;
      case 0x7E: strcpy( Mnemonic, "\t\tBIT 7,(" );        break;
      case 0x86: strcpy( Mnemonic, "\t\tRES 0,(" );        break;
      case 0x8E: strcpy( Mnemonic, "\t\tRES 1,(" );        break;
      case 0x96: strcpy( Mnemonic, "\t\tRES 2,(" );        break;
      case 0x9E: strcpy( Mnemonic, "\t\tRES 3,(" );        break;
      case 0xA6: strcpy( Mnemonic, "\t\tRES 4,(" );        break;
      case 0xAE: strcpy( Mnemonic, "\t\tRES 5,(" );        break;
      case 0xB6: strcpy( Mnemonic, "\t\tRES 6,(" );        break;
      case 0xBE: strcpy( Mnemonic, "\t\tRES 7,(" );        break;
      case 0xC6: strcpy( Mnemonic, "\t\tSET 0,(" );        break;
      case 0xCE: strcpy( Mnemonic, "\t\tSET 1,(" );        break;
      case 0xD6: strcpy( Mnemonic, "\t\tSET 2,(" );        break;
      case 0xDE: strcpy( Mnemonic, "\t\tSET 3,(" );        break;
      case 0xE6: strcpy( Mnemonic, "\t\tSET 4,(" );        break;
      case 0xEE: strcpy( Mnemonic, "\t\tSET 5,(" );        break;
      case 0xF6: strcpy( Mnemonic, "\t\tSET 6,(" );        break;
      case 0xFE: strcpy( Mnemonic, "\t\tSET 7,(" );        break;

      default:    strcpy( Mnemonic, "\t\t** INVALID IDX CB ?? ??" );
                  return;
      }

   strcat( Mnemonic, Idx );
   strcat( Mnemonic, " + " );

   to_hexstr( disp, byte, 2 );

   strcat( Mnemonic, byte );
   strcat( Mnemonic, "H)" );

   return;
}

PRIVATE void  DecodeIndex( int *addr, char *Idx )
{
   char  nil[ 5 ], *word = &nil[0];
   
   switch ( mem[ *addr ] )
      {
      case 9:  strcpy( Mnemonic, "\t\tADD " );
               strcat( Mnemonic, Idx );
               strcat( Mnemonic, ",BC" );
               (*addr)++;
               break;
               
      case 0x19: strcpy( Mnemonic, "\t\tADD " );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, ",DE" );
                 (*addr)++;
                 break;

      case 0x21: strcpy( Mnemonic, "\t\tLD " );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, "," );
                 (*addr)++;
                 to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H" );
                 *addr += 2;
                 break;

      case 0x22: strcpy( Mnemonic, "\t\tLD (" );
                 (*addr)++;
                 to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)," );
                 strcat( Mnemonic, Idx );
                 *addr += 2;
                 break;

      case 0x23: strcpy( Mnemonic, "\t\tINC " );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;

      case 0x29: strcpy( Mnemonic, "\t\tADD " );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, "," );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;

      case 0x2A: strcpy( Mnemonic, "\t\tLD " );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, ",(" );
                 (*addr)++;
                 to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 *addr += 2;
                 break;

      case 0x2B: strcpy( Mnemonic, "\t\tDEC " );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;

      case 0x34: strcpy( Mnemonic, "\t\tINC (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x35: strcpy( Mnemonic, "\t\tDEC (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x36: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)," );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H" );
                 (*addr)++;
                 break;

      case 0x39: strcpy( Mnemonic, "\t\tADD " );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, ",SP" );
                 (*addr)++;
                 break;

      case 0x46: strcpy( Mnemonic, "\t\tLD B,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x4E: strcpy( Mnemonic, "\t\tLD C,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x56: strcpy( Mnemonic, "\t\tLD D,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x5E: strcpy( Mnemonic, "\t\tLD E,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;
      
      case 0x66: strcpy( Mnemonic, "\t\tLD H,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x6E: strcpy( Mnemonic, "\t\tLD L,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x70: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),B" );
                 (*addr)++;
                 break;

      case 0x71: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),C" );
                 (*addr)++;
                 break;

      case 0x72: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),D" );
                 (*addr)++;
                 break;

      case 0x73: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),E" );
                 (*addr)++;
                 break;

      case 0x74: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),H" );
                 (*addr)++;
                 break;

      case 0x75: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),L" );
                 (*addr)++;
                 break;

      case 0x77: strcpy( Mnemonic, "\t\tLD (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H),A" );
                 (*addr)++;
                 break;

      case 0x7E: strcpy( Mnemonic, "\t\tLD A,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x86: strcpy( Mnemonic, "\t\tADD A,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x8E: strcpy( Mnemonic, "\t\tADC A,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x96: strcpy( Mnemonic, "\t\tSUB (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0x9E: strcpy( Mnemonic, "\t\tSBC A,(" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0xA6: strcpy( Mnemonic, "\t\tAND (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0xAE: strcpy( Mnemonic, "\t\tXOR (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0xB6: strcpy( Mnemonic, "\t\tOR (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0xBE: strcpy( Mnemonic, "\t\tCP (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, " + " );
                 (*addr)++;
                 to_hexstr( mem[ *addr ], word, 2 );
                 strcat( Mnemonic, word );
                 strcat( Mnemonic, "H)" );
                 (*addr)++;
                 break;

      case 0xCB: DecodeIdx( mem[ *addr + 2 ], mem[ *addr + 1 ], Idx );
                 *addr += 3;
                 break;

      case 0xE1: strcpy( Mnemonic, "\t\tPOP " );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;
                 
      case 0xE3: strcpy( Mnemonic, "\t\tEX (SP)," );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;

      case 0xE5: strcpy( Mnemonic, "\t\tPUSH " );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;

      case 0xE9: strcpy( Mnemonic, "\t\tJP (" );
                 strcat( Mnemonic, Idx );
                 strcat( Mnemonic, ")" );
                 (*addr)++;
                 break;

      case 0xF9: strcpy( Mnemonic, "\t\tLD SP," );
                 strcat( Mnemonic, Idx );
                 (*addr)++;
                 break;

      default: strcpy( Mnemonic, "\t\t** INVALID IDX ??" );
               (*addr)++;
               break;
      }

   return;
}

PRIVATE void  DecodeED( int *addr )
{
   char  nil[ 5 ], *word = &nil[0];
    
   switch (mem[ *addr ])
      {
      case 0x40:  strcpy( Mnemonic, "\t\tIN B,(C)" ); 
                  (*addr)++;
                  break;
                  
      case 0x41:  strcpy( Mnemonic, "\t\tOUT (C),B" ); 
                  (*addr)++;
                  break;

      case 0x42:  strcpy( Mnemonic, "\t\tSBC HL,BC" ); 
                  (*addr)++;
                  break;

      case 0x43:  strcpy( Mnemonic, "\t\tLD (" ); 
                  (*addr)++;
                  to_hexstr( mem[*addr] + 256 * mem[*addr + 1], word, 4 );
                  strcat( Mnemonic, word );
                  strcat( Mnemonic, "H),BC" );
                  *addr += 2;
                  break;
         
      case 0x44:  strcpy( Mnemonic, "\t\tNEG" ); 
                  (*addr)++;
                  break;

      case 0x45:  strcpy( Mnemonic, "\t\tRETN" ); 
                  (*addr)++;
                  break;

      case 0x46:  strcpy( Mnemonic, "\t\tIM 0" ); 
                  (*addr)++;
                  break;

      case 0x47:  strcpy( Mnemonic, "\t\tLD I,A" ); 
                  (*addr)++;
                  break;

      case 0x48:  strcpy( Mnemonic, "\t\tIN C,(C)" ); 
                  (*addr)++;
                  break;

      case 0x49:  strcpy( Mnemonic, "\t\tOUT (C),C" ); 
                  (*addr)++;
                  break;

      case 0x4A:  strcpy( Mnemonic, "\t\tADC HL,BC" ); 
                  (*addr)++;
                  break;

      case 0x4B:  strcpy( Mnemonic, "\t\tLD BC,(" ); 
                  (*addr)++;
                  to_hexstr( mem[*addr] + 256 * mem[*addr + 1], word, 4 );
                  strcat( Mnemonic, word );
                  strcat( Mnemonic, "H)" );
                  *addr += 2;
                  break;
         
      case 0x4D:  strcpy( Mnemonic, "\t\tRETI" ); 
                  (*addr)++;
                  break;
         
      case 0x50:  strcpy( Mnemonic, "\t\tIN D,(C)" ); 
                  (*addr)++;
                  break;

      case 0x51:  strcpy( Mnemonic, "\t\tOUT (C),D" ); 
                  (*addr)++;
                  break;

      case 0x52:  strcpy( Mnemonic, "\t\tSBC HL,DE" ); 
                  (*addr)++;
                  break;

      case 0x53:  strcpy( Mnemonic, "\t\tLD (" ); 
                  (*addr)++;
                  to_hexstr( mem[*addr] + 256 * mem[*addr + 1], word, 4 );
                  strcat( Mnemonic, word );
                  strcat( Mnemonic, "H),DE" );
                  *addr += 2;
                  break;
         
      case 0x56:  strcpy( Mnemonic, "\t\tIM 1" ); 
                  (*addr)++;
                  break;
         
      case 0x57:  strcpy( Mnemonic, "\t\tLD A,I" ); 
                  (*addr)++;
                  break;
         
      case 0x58:  strcpy( Mnemonic, "\t\tIN E,(C)" ); 
                  (*addr)++;
                  break;
         
      case 0x59:  strcpy( Mnemonic, "\t\tOUT (C),E" ); 
                  (*addr)++;
                  break;
         
      case 0x5A:  strcpy( Mnemonic, "\t\tADC HL,DE" ); 
                  (*addr)++;
                  break;
         
      case 0x5B:  strcpy( Mnemonic, "\t\tLD DE,(" ); 
                  (*addr)++;
                  to_hexstr( mem[*addr] + 256 * mem[*addr + 1], word, 4 );
                  strcat( Mnemonic, word );
                  strcat( Mnemonic, "H)" );
                  *addr += 2;
                  break;
         
      case 0x5E:  strcpy( Mnemonic, "\t\tIM 2" ); 
                  (*addr)++;
                  break;

      case 0x60:  strcpy( Mnemonic, "\t\tIN H,(C)" ); 
                  (*addr)++;
                  break;

      case 0x61:  strcpy( Mnemonic, "\t\tOUT (C),H" ); 
                  (*addr)++;
                  break;

      case 0x62:  strcpy( Mnemonic, "\t\tSBC HL,HL" ); 
                  (*addr)++;
                  break;

      case 0x67:  strcpy( Mnemonic, "\t\tRRD" ); 
                  (*addr)++;
                  break;

      case 0x68:  strcpy( Mnemonic, "\t\tIN L,(C)" ); 
                  (*addr)++;
                  break;

      case 0x69:  strcpy( Mnemonic, "\t\tOUT (C),L" ); 
                  (*addr)++;
                  break;

      case 0x6A:  strcpy( Mnemonic, "\t\tADC HL,HL" ); 
                  (*addr)++;
                  break;

      case 0x6F:  strcpy( Mnemonic, "\t\tRLD" ); 
                  (*addr)++;
                  break;

      case 0x72:  strcpy( Mnemonic, "\t\tSBC HL,SP" ); 
                  (*addr)++;
                  break;

      case 0x73:  strcpy( Mnemonic, "\t\tLD (" ); 
                  (*addr)++;
                  to_hexstr( mem[*addr] + 256 * mem[*addr + 1], word, 4 );
                  strcat( Mnemonic, word );
                  strcat( Mnemonic, "H),SP" );
                  *addr += 2;
                  break;
         
      case 0x78:  strcpy( Mnemonic, "\t\tIN A,(C)" ); 
                  (*addr)++;
                  break;

      case 0x79:  strcpy( Mnemonic, "\t\tOUT (C),A" ); 
                  (*addr)++;
                  break;

      case 0x7A:  strcpy( Mnemonic, "\t\tADC HL,SP" ); 
                  (*addr)++;
                  break;

      case 0x7B:  strcpy( Mnemonic, "\t\tLD SP,(" ); 
                  (*addr)++;
                  to_hexstr( mem[*addr] + 256 * mem[*addr + 1], word, 4 );
                  strcat( Mnemonic, word );
                  strcat( Mnemonic, "H)" );
                  *addr += 2;
                  break;
         
      case 0xA0:  strcpy( Mnemonic, "\t\tLDI" ); 
                  (*addr)++;
                  break;

      case 0xA1:  strcpy( Mnemonic, "\t\tCPI" ); 
                  (*addr)++;
                  break;

      case 0xA2:  strcpy( Mnemonic, "\t\tINI" ); 
                  (*addr)++;
                  break;

      case 0xA3:  strcpy( Mnemonic, "\t\tOUTI" ); 
                  (*addr)++;
                  break;

      case 0xA8:  strcpy( Mnemonic, "\t\tLDD" ); 
                  (*addr)++;
                  break;

      case 0xA9:  strcpy( Mnemonic, "\t\tCPD" ); 
                  (*addr)++;
                  break;

      case 0xAA:  strcpy( Mnemonic, "\t\tIND" ); 
                  (*addr)++;
                  break;

      case 0xAB:  strcpy( Mnemonic, "\t\tOUTD" ); 
                  (*addr)++;
                  break;

      case 0xB0:  strcpy( Mnemonic, "\t\tLDIR" ); 
                  (*addr)++;
                  break;

      case 0xB1:  strcpy( Mnemonic, "\t\tCPIR" ); 
                  (*addr)++;
                  break;

      case 0xB2:  strcpy( Mnemonic, "\t\tINIR" ); 
                  (*addr)++;
                  break;

      case 0xB3:  strcpy( Mnemonic, "\t\tOTIR" ); 
                  (*addr)++;
                  break;

      case 0xB8:  strcpy( Mnemonic, "\t\tLDDR" ); 
                  (*addr)++;
                  break;

      case 0xB9:  strcpy( Mnemonic, "\t\tCPDR" ); 
                  (*addr)++;
                  break;

      case 0xBA:  strcpy( Mnemonic, "\t\tINDR" ); 
                  (*addr)++;
                  break;

      case 0xBB:  strcpy( Mnemonic, "\t\tOTDR" ); 
                  (*addr)++;
                  break;

      default:    strcpy( Mnemonic, "\t\t** INVALID ED ??" );
                  (*addr)++;
                  break;
      }

   return;
}


/****i* DisAssemble() ***************************************************
*
* NAME
*    DisAssemble()
*
* WARNINGS
*    DisAssemble() has the side effect of incrementing addr to point to
*    the next instruction to decode into an assembly instruction string.
*************************************************************************
*
*/

PUBLIC char *DisAssemble( UBYTE memcontents, int *addr )
{
   char  Nil[5], *word = &Nil[0], *byte = &Nil[2];
   
   switch (memcontents)
      {
      case 0:  strcpy( Mnemonic, "\t\tNOP" );
               (*addr)++;
               break;

      case 1:  strcpy( Mnemonic, "\t\tLD BC," );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H" );
               *addr += 2;
               break;

      case 2:  strcpy( Mnemonic, "\t\tLD (BC),A" );
               (*addr)++;
               break;
      
      case 3:  strcpy( Mnemonic, "\t\tINC BC" );
               (*addr)++;
               break;

      case 4:  strcpy( Mnemonic, "\t\tINC B" );
               (*addr)++;
               break;

      case 5:  strcpy( Mnemonic, "\t\tDEC B" );
               (*addr)++;
               break;

      case 6:  strcpy( Mnemonic, "\t\tLD B," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;
      
      case 7:  strcpy( Mnemonic, "\t\tRLCA" );
               (*addr)++;
               break;

      case 8:  strcpy( Mnemonic, "\t\tEX AF,AF\'" );
               (*addr)++;
               break;

      case 9:  strcpy( Mnemonic, "\t\tADD HL,BC" );
               (*addr)++;
               break;

      case 10: strcpy( Mnemonic, "\t\tLD A,(BC)" );
               (*addr)++;
               break;

      case 11: strcpy( Mnemonic, "\t\tDEC BC" );
               (*addr)++;
               break;

      case 12: strcpy( Mnemonic, "\t\tINC C" );
               (*addr)++;
               break;

      case 13: strcpy( Mnemonic, "\t\tDEC C" );
               (*addr)++;
               break;

      case 14: strcpy( Mnemonic, "\t\tLD C," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 15: strcpy( Mnemonic, "\t\tRRCA" );
               (*addr)++;
               break;

      case 16: strcpy( Mnemonic, "\t\tDJNZ " );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 17: strcpy( Mnemonic, "\t\tLD DE," );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H" );
               *addr += 2;
               break;
               
      case 18: strcpy( Mnemonic, "\t\tLD (DE),A" );
               (*addr)++;
               break;

      case 19: strcpy( Mnemonic, "\t\tINC DE" );
               (*addr)++;
               break;
   
      case 20: strcpy( Mnemonic, "\t\tINC D" );
               (*addr)++;
               break;

      case 21: strcpy( Mnemonic, "\t\tDEC D" );
               (*addr)++;
               break;

      case 22: strcpy( Mnemonic, "\t\tLD D," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 23: strcpy( Mnemonic, "\t\tRLA" );
               (*addr)++;
               break;
      
      case 24: strcpy( Mnemonic, "\t\tJR " );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 25: strcpy( Mnemonic, "\t\tADD HL,DE" );
               (*addr)++;
               break;
               
      case 26: strcpy( Mnemonic, "\t\tLD A,(DE)" );
               (*addr)++;
               break;
              
      case 27: strcpy( Mnemonic, "\t\tDEC DE" );
               (*addr)++;
               break;

      case 28: strcpy( Mnemonic, "\t\tINC E" );
               (*addr)++;
               break;

      case 29: strcpy( Mnemonic, "\t\tDEC E" );
               (*addr)++;
               break;

      case 30: strcpy( Mnemonic, "\t\tLD E," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;
 
      case 31: strcpy( Mnemonic, "\t\tRRA" );
               (*addr)++;
               break;

      case 32: strcpy( Mnemonic, "\t\tJR NZ," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 33: strcpy( Mnemonic, "\t\tLD HL," );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H" );
               *addr += 2;
               break;

      case 34: strcpy( Mnemonic, "\t\tLD (" );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H),HL" );
               *addr += 2;
               break;

      case 35: strcpy( Mnemonic, "\t\tINC HL" );
               (*addr)++;
               break;

      case 36: strcpy( Mnemonic, "\t\tINC H" );
               (*addr)++;
               break;

      case 37: strcpy( Mnemonic, "\t\tDEC H" );
               (*addr)++;
               break;

      case 38: strcpy( Mnemonic, "\t\tLD H," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;
               
      case 39: strcpy( Mnemonic, "\t\tDAA" );
               (*addr)++;
               break;

      case 40: strcpy( Mnemonic, "\t\tJR Z," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 41: strcpy( Mnemonic, "\t\tADD HL,HL" );
               (*addr)++;
               break;

      case 42: strcpy( Mnemonic, "\t\tLD HL,(" );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H)" );
               *addr += 2;
               break;

      case 43: strcpy( Mnemonic, "\t\tDEC HL" );
               (*addr)++;
               break;

      case 44: strcpy( Mnemonic, "\t\tINC L" );
               (*addr)++;
               break;

      case 45: strcpy( Mnemonic, "\t\tDEC L" );
               (*addr)++;
               break;

      case 46: strcpy( Mnemonic, "\t\tLD L," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 47: strcpy( Mnemonic, "\t\tCPL" );
               (*addr)++;
               break;

      case 48: strcpy( Mnemonic, "\t\tJR NC," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 49: strcpy( Mnemonic, "\t\tLD SP," );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H" );
               *addr += 2;
               break;

      case 50: strcpy( Mnemonic, "\t\tLD (" );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4);
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H),A" );
               *addr += 2;
               break;

      case 51: strcpy( Mnemonic, "\t\tINC SP" );
               (*addr)++;
               break;

      case 52: strcpy( Mnemonic, "\t\tINC (HL)" );
               (*addr)++;
               break;

      case 53: strcpy( Mnemonic, "\t\tDEC (HL)" );
               (*addr)++;
               break;

      case 54: strcpy( Mnemonic, "\t\tLD (HL)," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 55: strcpy( Mnemonic, "\t\tSCF" );
               (*addr)++;
               break;

      case 56: strcpy( Mnemonic, "\t\tJR C," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 57: strcpy( Mnemonic, "\t\tADD HL,SP" );
               (*addr)++;
               break;

      case 58: strcpy( Mnemonic, "\t\tLD A,(" );
               (*addr)++;
               to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
               strcat( Mnemonic, word );
               strcat( Mnemonic, "H)" );
               *addr += 2;
               break;

      case 59: strcpy( Mnemonic, "\t\tDEC SP" );
               (*addr)++;
               break;

      case 60: strcpy( Mnemonic, "\t\tINC A" );
               (*addr)++;
               break;

      case 61: strcpy( Mnemonic, "\t\tDEC A" );
               (*addr)++;
               break;

      case 62: strcpy( Mnemonic, "\t\tLD A," );
               (*addr)++;
               to_hexstr( mem[ *addr ], byte, 2 );
               strcat( Mnemonic, byte );
               strcat( Mnemonic, "H" );
               (*addr)++;
               break;

      case 63: strcpy( Mnemonic, "\t\tCCF" );
               (*addr)++;
               break;

      case 64: strcpy( Mnemonic, "\t\tLD B,B" );
               (*addr)++;
               break;

      case 65: strcpy( Mnemonic, "\t\tLD B,C" );
               (*addr)++;
               break;

      case 66: strcpy( Mnemonic, "\t\tLD B,D" );
               (*addr)++;
               break;

      case 67: strcpy( Mnemonic, "\t\tLD B,E" );
               (*addr)++;
               break;

      case 68: strcpy( Mnemonic, "\t\tLD B,H" );
               (*addr)++;
               break;

      case 69: strcpy( Mnemonic, "\t\tLD B,L" );
               (*addr)++;
               break;

      case 70: strcpy( Mnemonic, "\t\tLD B,(HL)" );
               (*addr)++;
               break;

      case 71: strcpy( Mnemonic, "\t\tLD B,A" );
               (*addr)++;
               break;

      case 72: strcpy( Mnemonic, "\t\tLD C,B" );
               (*addr)++;
               break;

      case 73: strcpy( Mnemonic, "\t\tLD C,C" );
               (*addr)++;
               break;

      case 74: strcpy( Mnemonic, "\t\tLD C,D" );
               (*addr)++;
               break;

      case 75: strcpy( Mnemonic, "\t\tLD C,E" );
               (*addr)++;
               break;

      case 76: strcpy( Mnemonic, "\t\tLD C,H" );
               (*addr)++;
               break;

      case 77: strcpy( Mnemonic, "\t\tLD C,L" );
               (*addr)++;
               break;

      case 78: strcpy( Mnemonic, "\t\tLD C,(HL)" );
               (*addr)++;
               break;

      case 79: strcpy( Mnemonic, "\t\tLD C,A" );
               (*addr)++;
               break;

      case 80: strcpy( Mnemonic, "\t\tLD D,B" );
               (*addr)++;
               break;

      case 81: strcpy( Mnemonic, "\t\tLD D,C" );
               (*addr)++;
               break;

      case 82: strcpy( Mnemonic, "\t\tLD D,D" );
               (*addr)++;
               break;

      case 83: strcpy( Mnemonic, "\t\tLD D,E" );
               (*addr)++;
               break;

      case 84: strcpy( Mnemonic, "\t\tLD D,H" );
               (*addr)++;
               break;

      case 85: strcpy( Mnemonic, "\t\tLD D,L" );
               (*addr)++;
               break;

      case 86: strcpy( Mnemonic, "\t\tLD D,(HL)" );
               (*addr)++;
               break;

      case 87: strcpy( Mnemonic, "\t\tLD D,A" );
               (*addr)++;
               break;

      case 88: strcpy( Mnemonic, "\t\tLD E,B" );
               (*addr)++;
               break;

      case 89: strcpy( Mnemonic, "\t\tLD E,C" );
               (*addr)++;
               break;

      case 90: strcpy( Mnemonic, "\t\tLD E,D" );
               (*addr)++;
               break;

      case 91: strcpy( Mnemonic, "\t\tLD E,E" );
               (*addr)++;
               break;

      case 92: strcpy( Mnemonic, "\t\tLD E,H" );
               (*addr)++;
               break;

      case 93: strcpy( Mnemonic, "\t\tLD E,L" );
               (*addr)++;
               break;

      case 94: strcpy( Mnemonic, "\t\tLD E,(HL)" );
               (*addr)++;
               break;

      case 95: strcpy( Mnemonic, "\t\tLD E,A" );
               (*addr)++;
               break;

      case 96: strcpy( Mnemonic, "\t\tLD H,B" );
               (*addr)++;
               break;

      case 97: strcpy( Mnemonic, "\t\tLD H,C" );
               (*addr)++;
               break;

      case 98: strcpy( Mnemonic, "\t\tLD H,D" );
               (*addr)++;
               break;

      case 99: strcpy( Mnemonic, "\t\tLD H,E" );
               (*addr)++;
               break;

      case 100: strcpy( Mnemonic, "\t\tLD H,H" );
                (*addr)++;
                break;

      case 101: strcpy( Mnemonic, "\t\tLD H,L" );
                (*addr)++;
                break;

      case 102: strcpy( Mnemonic, "\t\tLD H,(HL)" );
                (*addr)++;
                break;

      case 103: strcpy( Mnemonic, "\t\tLD H,A" );
                (*addr)++;
                break;

      case 104: strcpy( Mnemonic, "\t\tLD L,B" );
                (*addr)++;
                break;

      case 105: strcpy( Mnemonic, "\t\tLD L,C" );
                (*addr)++;
                break;

      case 106: strcpy( Mnemonic, "\t\tLD L,D" );
                (*addr)++;
                break;

      case 107: strcpy( Mnemonic, "\t\tLD L,E" );
                (*addr)++;
                break;

      case 108: strcpy( Mnemonic, "\t\tLD L,H" );
                (*addr)++;
                break;

      case 109: strcpy( Mnemonic, "\t\tLD L,L" );
                (*addr)++;
                break;

      case 110: strcpy( Mnemonic, "\t\tLD L,(HL)" );
                (*addr)++;
                break;

      case 111: strcpy( Mnemonic, "\t\tLD L,A" );
                (*addr)++;
                break;

      case 112: strcpy( Mnemonic, "\t\tLD (HL),B" );
                (*addr)++;
                break;

      case 113: strcpy( Mnemonic, "\t\tLD (HL),C" );
                (*addr)++;
                break;

      case 114: strcpy( Mnemonic, "\t\tLD (HL),D" );
                (*addr)++;
                break;

      case 115: strcpy( Mnemonic, "\t\tLD (HL),E" );
                (*addr)++;
                break;

      case 116: strcpy( Mnemonic, "\t\tLD (HL),H" );
                (*addr)++;
                break;

      case 117: strcpy( Mnemonic, "\t\tLD (HL),L" );
                (*addr)++;
                break;

      case 118: strcpy( Mnemonic, "\t\tHALT" );
                (*addr)++;
                break;

      case 119: strcpy( Mnemonic, "\t\tLD (HL),A" );
                (*addr)++;
                break;

      case 120: strcpy( Mnemonic, "\t\tLD A,B" );
                (*addr)++;
                break;

      case 121: strcpy( Mnemonic, "\t\tLD A,C" );
                (*addr)++;
                break;

      case 122: strcpy( Mnemonic, "\t\tLD A,D" );
                (*addr)++;
                break;

      case 123: strcpy( Mnemonic, "\t\tLD A,E" );
                (*addr)++;
                break;

      case 124: strcpy( Mnemonic, "\t\tLD A,H" );
                (*addr)++;
                break;

      case 125: strcpy( Mnemonic, "\t\tLD A,L" );
                (*addr)++;
                break;

      case 126: strcpy( Mnemonic, "\t\tLD A,(HL)" );
                (*addr)++;
                break;

      case 127: strcpy( Mnemonic, "\t\tLD A,A" );
                (*addr)++;
                break;

      case 128: strcpy( Mnemonic, "\t\tADD A,B" );
                (*addr)++;
                break;

      case 129: strcpy( Mnemonic, "\t\tADD A,C" );
                (*addr)++;
                break;

      case 130: strcpy( Mnemonic, "\t\tADD A,D" );
                (*addr)++;
                break;

      case 131: strcpy( Mnemonic, "\t\tADD A,E" );
                (*addr)++;
                break;

      case 132: strcpy( Mnemonic, "\t\tADD A,H" );
                (*addr)++;
                break;

      case 133: strcpy( Mnemonic, "\t\tADD A,L" );
                (*addr)++;
                break;

      case 134: strcpy( Mnemonic, "\t\tADD A,(HL)" );
                (*addr)++;
                break;

      case 135: strcpy( Mnemonic, "\t\tADD A,A" );
                (*addr)++;
                break;

      case 136: strcpy( Mnemonic, "\t\tADC A,B" );
                (*addr)++;
                break;

      case 137: strcpy( Mnemonic, "\t\tADC A,C" );
                (*addr)++;
                break;

      case 138: strcpy( Mnemonic, "\t\tADC A,D" );
                (*addr)++;
                break;

      case 139: strcpy( Mnemonic, "\t\tADC A,E" );
                (*addr)++;
                break;

      case 140: strcpy( Mnemonic, "\t\tADC A,H" );
                (*addr)++;
                break;

      case 141: strcpy( Mnemonic, "\t\tADC A,L" );
                (*addr)++;
                break;

      case 142: strcpy( Mnemonic, "\t\tADC A,(HL)" );
                (*addr)++;
                break;

      case 143: strcpy( Mnemonic, "\t\tADC A,A" );
                (*addr)++;
                break;

      case 144: strcpy( Mnemonic, "\t\tSUB B" );
                (*addr)++;
                break;

      case 145: strcpy( Mnemonic, "\t\tSUB C" );
                (*addr)++;
                break;

      case 146: strcpy( Mnemonic, "\t\tSUB D" );
                (*addr)++;
                break;

      case 147: strcpy( Mnemonic, "\t\tSUB E" );
                (*addr)++;
                break;

      case 148: strcpy( Mnemonic, "\t\tSUB H" );
                (*addr)++;
                break;

      case 149: strcpy( Mnemonic, "\t\tSUB L" );
                (*addr)++;
                break;

      case 150: strcpy( Mnemonic, "\t\tSUB (HL)" );
                (*addr)++;
                break;

      case 151: strcpy( Mnemonic, "\t\tSUB A" );
                (*addr)++;
                break;

      case 152: strcpy( Mnemonic, "\t\tSBC A,B" );
                (*addr)++;
                break;

      case 153: strcpy( Mnemonic, "\t\tSBC A,C" );
                (*addr)++;
                break;

      case 154: strcpy( Mnemonic, "\t\tSBC A,D" );
                (*addr)++;
                break;

      case 155: strcpy( Mnemonic, "\t\tSBC A,E" );
                (*addr)++;
                break;

      case 156: strcpy( Mnemonic, "\t\tSBC A,H" );
                (*addr)++;
                break;

      case 157: strcpy( Mnemonic, "\t\tSBC A,L" );
                (*addr)++;
                break;

      case 158: strcpy( Mnemonic, "\t\tSBC A,(HL)" );
                (*addr)++;
                break;

      case 159: strcpy( Mnemonic, "\t\tSBC A,A" );
                (*addr)++;
                break;

      case 160: strcpy( Mnemonic, "\t\tAND B" );
                (*addr)++;
                break;

      case 161: strcpy( Mnemonic, "\t\tAND C" );
                (*addr)++;
                break;

      case 162: strcpy( Mnemonic, "\t\tAND D" );
                (*addr)++;
                break;

      case 163: strcpy( Mnemonic, "\t\tAND E" );
                (*addr)++;
                break;

      case 164: strcpy( Mnemonic, "\t\tAND H" );
                (*addr)++;
                break;

      case 165: strcpy( Mnemonic, "\t\tAND L" );
                (*addr)++;
                break;

      case 166: strcpy( Mnemonic, "\t\tAND (HL)" );
                (*addr)++;
                break;

      case 167: strcpy( Mnemonic, "\t\tAND A" );
                (*addr)++;
                break;

      case 168: strcpy( Mnemonic, "\t\tXOR B" );
                (*addr)++;
                break;

      case 169: strcpy( Mnemonic, "\t\tXOR C" );
                (*addr)++;
                break;

      case 170: strcpy( Mnemonic, "\t\tXOR D" );
                (*addr)++;
                break;

      case 171: strcpy( Mnemonic, "\t\tXOR E" );
                (*addr)++;
                break;

      case 172: strcpy( Mnemonic, "\t\tXOR H" );
                (*addr)++;
                break;

      case 173: strcpy( Mnemonic, "\t\tXOR L" );
                (*addr)++;
                break;

      case 174: strcpy( Mnemonic, "\t\tXOR (HL)" );
                (*addr)++;
                break;

      case 175: strcpy( Mnemonic, "\t\tXOR A" );
                (*addr)++;
                break;

      case 176: strcpy( Mnemonic, "\t\tOR B" );
                (*addr)++;
                break;

      case 177: strcpy( Mnemonic, "\t\tOR C" );
                (*addr)++;
                break;

      case 178: strcpy( Mnemonic, "\t\tOR D" );
                (*addr)++;
                break;

      case 179: strcpy( Mnemonic, "\t\tOR E" );
                (*addr)++;
                break;

      case 180: strcpy( Mnemonic, "\t\tOR H" );
                (*addr)++;
                break;

      case 181: strcpy( Mnemonic, "\t\tOR L" );
                (*addr)++;
                break;

      case 182: strcpy( Mnemonic, "\t\tOR (HL)" );
                (*addr)++;
                break;

      case 183: strcpy( Mnemonic, "\t\tOR A" );
                (*addr)++;
                break;

      case 184: strcpy( Mnemonic, "\t\tCP B" );
                (*addr)++;
                break;

      case 185: strcpy( Mnemonic, "\t\tCP C" );
                (*addr)++;
                break;

      case 186: strcpy( Mnemonic, "\t\tCP D" );
                (*addr)++;
                break;

      case 187: strcpy( Mnemonic, "\t\tCP E" );
                (*addr)++;
                break;

      case 188: strcpy( Mnemonic, "\t\tCP H" );
                (*addr)++;
                break;

      case 189: strcpy( Mnemonic, "\t\tCP L" );
                (*addr)++;
                break;

      case 190: strcpy( Mnemonic, "\t\tCP (HL)" );
                (*addr)++;
                break;

      case 191: strcpy( Mnemonic, "\t\tCP A" );
                (*addr)++;
                break;

      case 192: strcpy( Mnemonic, "\t\tRET NZ" );
                (*addr)++;
                break;

      case 193: strcpy( Mnemonic, "\t\tPOP BC" );
                (*addr)++;
                break;

      case 194: strcpy( Mnemonic, "\t\tJP NZ," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 195: strcpy( Mnemonic, "\t\tJP " );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 196: strcpy( Mnemonic, "\t\tCALL NZ," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 197: strcpy( Mnemonic, "\t\tPUSH BC" );
                (*addr)++;
                break;

      case 198: strcpy( Mnemonic, "\t\tADD A," );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 199: strcpy( Mnemonic, "\t\tRST 0" );
                (*addr)++;
                break;

      case 200: strcpy( Mnemonic, "\t\tRET Z" );
                (*addr)++;
                break;

      case 201: strcpy( Mnemonic, "\t\tRET" );
                (*addr)++;
                break;

      case 202: strcpy( Mnemonic, "\t\tJP Z," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 203: (*addr)++;
                DecodeCB( addr );
                break;
                
      case 204: strcpy( Mnemonic, "\t\tCALL Z," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 205: strcpy( Mnemonic, "\t\tCALL " );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 206: strcpy( Mnemonic, "\t\tADC A," );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 207: strcpy( Mnemonic, "\t\tRST 8" );
                (*addr)++;
                break;

      case 208: strcpy( Mnemonic, "\t\tRET NC" );
                (*addr)++;
                break;

      case 209: strcpy( Mnemonic, "\t\tPOP DE" );
                (*addr)++;
                break;

      case 210: strcpy( Mnemonic, "\t\tJP NC," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 211: strcpy( Mnemonic, "\t\tOUT " );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H,A" );
                (*addr)++;
                break;

      case 212: strcpy( Mnemonic, "\t\tCALL NC," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 213: strcpy( Mnemonic, "\t\tPUSH DE" );
                (*addr)++;
                break;

      case 214: strcpy( Mnemonic, "\t\tSUB " );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 215: strcpy( Mnemonic, "\t\tRST 10H" );
                (*addr)++;
                break;

      case 216: strcpy( Mnemonic, "\t\tRET C" );
                (*addr)++;
                break;

      case 217: strcpy( Mnemonic, "\t\tEXX" );
                (*addr)++;
                break;

      case 218: strcpy( Mnemonic, "\t\tJP C," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 219: strcpy( Mnemonic, "\t\tIN A," );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 220: strcpy( Mnemonic, "\t\tCALL C," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 221: (*addr)++;
                DecodeIndex( addr, "IX" );
                break;
                  
      case 222: strcpy( Mnemonic, "\t\tSBC A," );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 223: strcpy( Mnemonic, "\t\tRST 18H" );
                (*addr)++;
                break;

      case 224: strcpy( Mnemonic, "\t\tRET PO" );
                (*addr)++;
                break;

      case 225: strcpy( Mnemonic, "\t\tPOP HL" );
                (*addr)++;
                break;

      case 226: strcpy( Mnemonic, "\t\tJP PO," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 227: strcpy( Mnemonic, "\t\tEX (SP),HL" );
                (*addr)++;
                break;

      case 228: strcpy( Mnemonic, "\t\tCALL PO," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 229: strcpy( Mnemonic, "\t\tPUSH HL" );
                (*addr)++;
                break;

      case 230: strcpy( Mnemonic, "\t\tAND " );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 231: strcpy( Mnemonic, "\t\tRST 20H" );
                (*addr)++;
                break;

      case 232: strcpy( Mnemonic, "\t\tRET PE" );
                (*addr)++;
                break;

      case 233: strcpy( Mnemonic, "\t\tJP (HL)" );
                (*addr)++;
                break;

      case 234: strcpy( Mnemonic, "\t\tJP PE," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 235: strcpy( Mnemonic, "\t\tEX DE,HL" );
                (*addr)++;
                break;

      case 236: strcpy( Mnemonic, "\t\tCALL PE," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 237: (*addr)++;
                DecodeED( addr );
                break;
                
      case 238: strcpy( Mnemonic, "\t\tXOR " );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 239: strcpy( Mnemonic, "\t\tRST 28H" );
                (*addr)++;
                break;

      case 240: strcpy( Mnemonic, "\t\tRET P" );
                (*addr)++;
                break;

      case 241: strcpy( Mnemonic, "\t\tPOP AF" );
                (*addr)++;
                break;

      case 242: strcpy( Mnemonic, "\t\tJP P," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 243: strcpy( Mnemonic, "\t\tDI" );
                (*addr)++;
                break;

      case 244: strcpy( Mnemonic, "\t\tCALL P," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 245: strcpy( Mnemonic, "\t\tPUSH AF" );
                (*addr)++;
                break;

      case 246: strcpy( Mnemonic, "\t\tOR " );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 247: strcpy( Mnemonic, "\t\tRST 30H" );
                (*addr)++;
                break;

      case 248: strcpy( Mnemonic, "\t\tRET M" );
                (*addr)++;
                break;

      case 249: strcpy( Mnemonic, "\t\tLD SP,HL" );
                (*addr)++;
                break;

      case 250: strcpy( Mnemonic, "\t\tJP M," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 251: strcpy( Mnemonic, "\t\tEI" );
                (*addr)++;
                break;

      case 252: strcpy( Mnemonic, "\t\tCALL M," );
                (*addr)++;
                to_hexstr( mem[ *addr ] + 256 * mem[ *addr + 1 ], word, 4 );
                strcat( Mnemonic, word );
                strcat( Mnemonic, "H" );
                *addr += 2;
                break;

      case 253: (*addr)++;
                DecodeIndex( addr, "IY" );
                break;
                
      case 254: strcpy( Mnemonic, "\t\tCP " );
                (*addr)++;
                to_hexstr( mem[ *addr ], byte, 2 );
                strcat( Mnemonic, byte );
                strcat( Mnemonic, "H" );
                (*addr)++;
                break;

      case 255: strcpy( Mnemonic, "\t\tRST 38H" );
                (*addr)++;
                break;

      }

   return( Mnemonic );
}

/* ---------------- END of Z80DisAssembler.c file! ------------------- */
