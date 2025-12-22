/*****************************************************************************
* 6502D Version 0.1                                                          *
* Bart Trzynadlowski, 1999                                                   *
*                                                                            *
* Feel free to do whatever you wish with this source code provided that you  *
* understand it is provided "as is" and that the author will not be held     *
* responsible for anything that happens because of this software.            *
*                                                                            *
* disasm.c: Contains function to disassemble and print mnemonics.            *
*****************************************************************************/

#include <stdio.h>
#include "opcode.h"

/*****************************************************************************
* disasm: Prints the opcode passed to it and updates the main program        *
* counter passed to it via a pointer.                                        *
*****************************************************************************/
int disasm(unsigned char opcode, int *p, FILE *infile)
{
        unsigned char opcode2;
        unsigned char opcode3;

        /* (address+origin)+tab+op_byte1 */
        printf("%08X:\t%02X", *p, opcode);

        /* print ... keep in mind that 6502 is little-endian */
        switch (opcode)
        {
                default:
                        printf("\t.DB $%02X", opcode);                       
                        break;
                case ADC_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tADC #$%02X", opcode2, opcode2);
                        break;
                case ADC_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tADC $%02X", opcode2, opcode2);
                        break;
                case ADC_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tADC $%02X,X", opcode2, opcode2);
                        break;
                case ADC_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tADC $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ADC_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tADC $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ADC_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tADC $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case ADC_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tADC ($%02X,X)", opcode2, opcode2);
                        break;
                case ADC_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tADC ($%02X),Y", opcode2, opcode2);
                        break;
                case AND_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tAND #$%02X", opcode2, opcode2);
                        break;
                case AND_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tAND $%02X", opcode2, opcode2);
                        break;
                case AND_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tAND $%02X,X", opcode2, opcode2);
                        break;
                case AND_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tAND $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case AND_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tAND $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case AND_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tAND $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case AND_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tAND ($%02X,X)", opcode2, opcode2);
                        break;
                case AND_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tAND ($%02X),Y", opcode2, opcode2);
                        break;
                case ASL_A:
                        printf("\tASL A");
                        break;
                case ASL_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tASL $%02X", opcode2, opcode2);
                        break;
                case ASL_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tASL $%02X,X", opcode2, opcode2);
                        break;
                case ASL_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tASL $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ASL_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tASL $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case BCC:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBCC $%02X", opcode2, opcode2);
                        break;
                case BCS:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBCS $%02X", opcode2, opcode2);
                        break;
                case BEQ:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBEQ $%02X", opcode2, opcode2);
                        break;
                case BIT_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBIT $%02X", opcode2, opcode2);
                        break;
                case BIT_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tBIT $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case BMI:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBMI $%02X", opcode2, opcode2);
                        break;
                case BNE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBNE $%02X", opcode2, opcode2);
                        break;
                case BPL:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBPL $%02X", opcode2, opcode2);
                        break;
                case BRK:
                        printf("\tBRK");
                        break;
                case BVC:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBVC $%02X", opcode2, opcode2);
                        break;
                case BVS:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tBVS $%02X", opcode2, opcode2);
                        break;
                case CLC:
                        printf("\tCLC");
                        break;
                case CLD:
                        printf("\tCLD");
                        break;
                case CLI:
                        printf("\tCLI");
                        break;
                case CLV:
                        printf("\tCLV");
                        break;
                case CMP_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCMP #$%02X", opcode2, opcode2);
                        break;
                case CMP_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCMP $%02X", opcode2, opcode2);
                        break;
                case CMP_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCMP $%02X,X", opcode2, opcode2);
                        break;
                case CMP_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tCMP $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case CMP_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tCMP $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case CMP_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tCMP $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case CMP_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCMP ($%02X,X)", opcode2, opcode2);
                        break;
                case CMP_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCMP ($%02X),Y", opcode2, opcode2);
                        break;
                case CPX_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCPX #$%02X", opcode2, opcode2);
                        break;
                case CPX_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCPX $%02X", opcode2, opcode2);
                        break;
                case CPX_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tCPX $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case CPY_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCPY #$%02X", opcode2, opcode2);
                        break;
                case CPY_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tCPY $%02X", opcode2, opcode2);
                        break;
                case CPY_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tCPY $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case DEC_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tDEC $%02X", opcode2, opcode2);
                        break;
                case DEC_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tDEC $%02X,X", opcode2, opcode2);
                        break;
                case DEC_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tDEC $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case DEC_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tDEC $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case DEX:
                        printf("\tDEX");
                        break;
                case DEY:
                        printf("\tDEY");
                        break;
                case EOR_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tEOR #$%02X", opcode2, opcode2);
                        break;
                case EOR_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tEOR $%02X", opcode2, opcode2);
                        break;
                case EOR_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tEOR $%02X,X", opcode2, opcode2);
                        break;
                case EOR_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tEOR $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case EOR_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tEOR $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case EOR_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tEOR $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case EOR_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tEOR ($%02X,X)", opcode2, opcode2);
                        break;
                case EOR_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tEOR ($%02X),Y", opcode2, opcode2);
                        break;                       
                case INC_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tINC $%02X", opcode2, opcode2);
                        break;
                case INC_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tINC $%02X,X", opcode2, opcode2);
                        break;
                case INC_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tINC $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case INC_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tINC $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case INX:
                        printf("\tINX");
                        break;
                case INY:
                        printf("\tINY");
                        break;
                case JMP_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tJMP $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case JMP_INDIRECT:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tJMP ($%02X%02X)", opcode2, opcode3, opcode3, opcode2);
                        break;
                case JSR:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tJSR $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LDA_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDA #$%02X", opcode2, opcode2);
                        break;
                case LDA_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDA $%02X", opcode2, opcode2);
                        break;
                case LDA_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDA $%02X,X", opcode2, opcode2);
                        break;
                case LDA_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDA $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LDA_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDA $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LDA_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDA $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case LDA_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDA ($%02X,X)", opcode2, opcode2);
                        break;
                case LDA_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDA ($%02X),Y", opcode2, opcode2);
                        break;                       
                case LDX_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDX #$%02X", opcode2, opcode2);
                        break;
                case LDX_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDX $%02X", opcode2, opcode2);
                        break;
                case LDX_ZEROPAGE_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDX $%02X,Y", opcode2, opcode2);
                        break;
                case LDX_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDX $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LDX_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDX $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LDY_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDY #$%02X", opcode2, opcode2);
                        break;
                case LDY_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDY $%02X", opcode2, opcode2);
                        break;
                case LDY_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLDY $%02X,X", opcode2, opcode2);
                        break;
                case LDY_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDY $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LDY_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLDY $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LSR_A:
                        printf("\tLSR A");
                        break;
                case LSR_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLSR $%02X", opcode2, opcode2);
                        break;
                case LSR_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tLSR $%02X,X", opcode2, opcode2);
                        break;
                case LSR_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLSR $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case LSR_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tLSR $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case NOP:
                        printf("\tNOP");
                        break;
                case ORA_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tORA #$%02X", opcode2, opcode2);
                        break;
                case ORA_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tORA $%02X", opcode2, opcode2);
                        break;
                case ORA_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tORA $%02X,X", opcode2, opcode2);
                        break;
                case ORA_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tORA $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ORA_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tORA $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ORA_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tORA $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case ORA_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tORA ($%02X,X)", opcode2, opcode2);
                        break;
                case ORA_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tORA ($%02X),Y", opcode2, opcode2);
                        break;
                case PHA:
                        printf("\tPHA");
                        break;
                case PHP:
                        printf("\tPHP");
                        break;
                case PLA:
                        printf("\tPLA");
                        break;
                case PLP:
                        printf("\tPLP");
                        break;
                case ROL_A:
                        printf("\tROL A");
                        break;
                case ROL_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tROL $%02X", opcode2, opcode2);
                        break;
                case ROL_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tROL $%02X,X", opcode2, opcode2);
                        break;
                case ROL_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tROL $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ROL_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tROL $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ROR_A:
                        printf("\tROR A");
                        break;
                case ROR_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tROR $%02X", opcode2, opcode2);
                        break;
                case ROR_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tROR $%02X,X", opcode2, opcode2);
                        break;
                case ROR_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tROR $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case ROR_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tROR $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case RTI:
                        printf("\tRTI");
                        break;
                case RTS:
                        printf("\tRTS");
                        break;
                case SBC_IMMED:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSBC #$%02X", opcode2, opcode2);
                        break;
                case SBC_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSBC $%02X", opcode2, opcode2);
                        break;
                case SBC_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSBC $%02X,X", opcode2, opcode2);
                        break;
                case SBC_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSBC $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case SBC_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSBC $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case SBC_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSBC $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case SBC_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSBC ($%02X,X)", opcode2, opcode2);
                        break;
                case SBC_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSBC ($%02X),Y", opcode2, opcode2);
                        break;
                case SEC:
                        printf("\tSEC");
                        break;
                case SED:
                        printf("\tSED");
                        break;
                case SEI:
                        printf("\tSEI");
                        break;
                case STA_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTA $%02X", opcode2, opcode2);
                        break;
                case STA_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTA $%02X,X", opcode2, opcode2);
                        break;
                case STA_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSTA $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case STA_ABSOLUTE_X:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSTA $%02X%02X,X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case STA_ABSOLUTE_Y:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSTA $%02X%02X,Y", opcode2, opcode3, opcode3, opcode2);
                        break;                       
                case STA_INDIRECT_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTA ($%02X,X)", opcode2, opcode2);
                        break;
                case STA_INDIRECT_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTA ($%02X),Y", opcode2, opcode2);
                        break;
                case STX_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTX $%02X", opcode2, opcode2);
                        break;
                case STX_ZEROPAGE_Y:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTX $%02X,Y", opcode2, opcode2);
                        break;
                case STX_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSTX $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case STY_ZEROPAGE:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTY $%02X", opcode2, opcode2);
                        break;
                case STY_ZEROPAGE_X:
                        opcode2=fgetc(infile);
                        (*p)++;
                        printf("%02X\tSTY $%02X,X", opcode2, opcode2);
                        break;
                case STY_ABSOLUTE:
                        opcode2=fgetc(infile);
                        opcode3=fgetc(infile);
                        *p=*p+2;
                        printf("%02X%02X\tSTY $%02X%02X", opcode2, opcode3, opcode3, opcode2);
                        break;
                case TAX:
                        printf("\tTAX");
                        break;
                case TAY:
                        printf("\tTAY");
                        break;
                case TSX:
                        printf("\tTSX");
                        break;
                case TXA:
                        printf("\tTXA");
                        break;
                case TXS:
                        printf("\tTXS");
                        break;
                case TYA:
                        printf("\tTYA");
                        break;                                                                             
        }

        printf("\n");
        return 0;
}

