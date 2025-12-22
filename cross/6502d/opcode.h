/*****************************************************************************
* 6502D Version 0.1                                                          *
* Bart Trzynadlowski, 1999                                                   *
*                                                                            *
* Feel free to do whatever you wish with this source code provided that you  *
* understand it is provided "as is" and that the author will not be held     *
* responsible for anything that happens because of this software.            *
*                                                                            *
* opcode.h: List of 6502 opcodes.                                            *
*****************************************************************************/

#define ADC_IMMED 0x69
#define ADC_ZEROPAGE 0x65
#define ADC_ZEROPAGE_X 0x75
#define ADC_ABSOLUTE 0x6d
#define ADC_ABSOLUTE_X 0x7d
#define ADC_ABSOLUTE_Y 0x79
#define ADC_INDIRECT_X 0x61
#define ADC_INDIRECT_Y 0x71


#define AND_IMMED 0x29
#define AND_ZEROPAGE 0x25
#define AND_ZEROPAGE_X 0x35
#define AND_ABSOLUTE 0x2d
#define AND_ABSOLUTE_X 0x3d
#define AND_ABSOLUTE_Y 0x39
#define AND_INDIRECT_X 0x21
#define AND_INDIRECT_Y 0x31

#define ASL_A 0x0a
#define ASL_ZEROPAGE 0x06
#define ASL_ZEROPAGE_X 0x16
#define ASL_ABSOLUTE 0x0e
#define ASL_ABSOLUTE_X 0x1e

#define BCC 0x90

#define BCS 0xb0

#define BEQ 0xf0

#define BIT_ZEROPAGE 0x24
#define BIT_ABSOLUTE 0x2c

#define BMI 0x30

#define BNE 0xd0

#define BPL 0x10

#define BRK 0x00

#define BVC 0x50

#define BVS 0x70

#define CLC 0x18

#define CLD 0xd8

#define CLI 0x58

#define CLV 0xb8


#define CMP_IMMED 0xc9
#define CMP_ZEROPAGE 0xc5
#define CMP_ZEROPAGE_X 0xd5
#define CMP_ABSOLUTE 0xcd
#define CMP_ABSOLUTE_X 0xdd
#define CMP_ABSOLUTE_Y 0xd9
#define CMP_INDIRECT_X 0xc1
#define CMP_INDIRECT_Y 0xd1

#define CPX_IMMED 0xe0
#define CPX_ZEROPAGE 0xe4
#define CPX_ABSOLUTE 0xec

#define CPY_IMMED 0xc0
#define CPY_ZEROPAGE 0xc4
#define CPY_ABSOLUTE 0xcc

#define DEC_ZEROPAGE 0xc6
#define DEC_ZEROPAGE_X 0xd6
#define DEC_ABSOLUTE 0xce
#define DEC_ABSOLUTE_X 0xde

#define DEX 0xca

#define DEY 0x88

#define EOR_IMMED 0x49
#define EOR_ZEROPAGE 0x45
#define EOR_ZEROPAGE_X 0x55
#define EOR_ABSOLUTE 0x4d
#define EOR_ABSOLUTE_X 0x5d
#define EOR_ABSOLUTE_Y 0x59
#define EOR_INDIRECT_X 0x41
#define EOR_INDIRECT_Y 0x51

#define INC_ZEROPAGE 0xe6
#define INC_ZEROPAGE_X 0xf6
#define INC_ABSOLUTE 0xee
#define INC_ABSOLUTE_X 0xfe

#define INX 0xe8

#define INY 0xc8

#define JMP_ABSOLUTE 0x4c
#define JMP_INDIRECT 0x6c

#define JSR 0x20

#define LDA_IMMED 0xa9
#define LDA_ZEROPAGE 0xa5
#define LDA_ZEROPAGE_X 0xb5
#define LDA_ABSOLUTE 0xad
#define LDA_ABSOLUTE_X 0xbd
#define LDA_ABSOLUTE_Y 0xb9
#define LDA_INDIRECT_X 0xa1
#define LDA_INDIRECT_Y 0xb1

#define LDX_IMMED 0xa2
#define LDX_ZEROPAGE 0xa6
#define LDX_ZEROPAGE_Y 0xb6
#define LDX_ABSOLUTE 0xae
#define LDX_ABSOLUTE_Y 0xbe

#define LDY_IMMED 0xa0
#define LDY_ZEROPAGE 0xa4
#define LDY_ZEROPAGE_X 0xb4
#define LDY_ABSOLUTE 0xac
#define LDY_ABSOLUTE_X 0xbc

#define LSR_A 0x4a
#define LSR_ZEROPAGE 0x46
#define LSR_ZEROPAGE_X 0x56
#define LSR_ABSOLUTE 0x4e
#define LSR_ABSOLUTE_X 0x5e

#define NOP 0xea

#define ORA_IMMED 0x09
#define ORA_ZEROPAGE 0x05
#define ORA_ZEROPAGE_X 0x15
#define ORA_ABSOLUTE 0x0d
#define ORA_ABSOLUTE_X 0x1d
#define ORA_ABSOLUTE_Y 0x19
#define ORA_INDIRECT_X 0x01
#define ORA_INDIRECT_Y 0x11

#define PHA 0x48

#define PHP 0x08

#define PLA 0x68

#define PLP 0x28

#define ROL_A 0x2a
#define ROL_ZEROPAGE 0x26
#define ROL_ZEROPAGE_X 0x36
#define ROL_ABSOLUTE 0x2e
#define ROL_ABSOLUTE_X 0x3e

#define ROR_A 0x6a
#define ROR_ZEROPAGE 0x66
#define ROR_ZEROPAGE_X 0x76
#define ROR_ABSOLUTE 0x6e
#define ROR_ABSOLUTE_X 0x7e

#define RTI 0x40

#define RTS 0x60

#define SBC_IMMED 0xe9
#define SBC_ZEROPAGE 0xe5
#define SBC_ZEROPAGE_X 0xf5
#define SBC_ABSOLUTE 0xed
#define SBC_ABSOLUTE_X 0xfd
#define SBC_ABSOLUTE_Y 0xf9
#define SBC_INDIRECT_X 0xe1
#define SBC_INDIRECT_Y 0xf1

#define SEC 0x38

#define SED 0xf8

#define SEI 0x78

#define STA_ZEROPAGE 0x85
#define STA_ZEROPAGE_X 0x95
#define STA_ABSOLUTE 0x8d
#define STA_ABSOLUTE_X 0x9d
#define STA_ABSOLUTE_Y 0x99
#define STA_INDIRECT_X 0x81
#define STA_INDIRECT_Y 0x91

#define STX_ZEROPAGE 0x86
#define STX_ZEROPAGE_Y 0x96
#define STX_ABSOLUTE 0x8e

#define STY_ZEROPAGE 0x84
#define STY_ZEROPAGE_X 0x94
#define STY_ABSOLUTE 0x8c

#define TAX 0xaa

#define TAY 0xa8

#define TSX 0xba

#define TXA 0x8a

#define TXS 0x9a

#define TYA 0x98
