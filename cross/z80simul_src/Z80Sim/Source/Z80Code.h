/************************************************************************
*
*   Z80CODE.H      This header is mainly for the output_code() function.
*
*   LAST CHANGED:  4/22/88
*
*   WARNINGS:      None.
*
*************************************************************************
*
*/

#define  IMPL     0         /* Implied, no operands needed      */
#define  IMPL2    1         /* IN & OUT opcodes                 */
#define  IMMD     2         /* One operand to decode            */
#define  IMMD2    3         /* Two operands to decode           */
#define  EXTI1    4         /* Operand one is ()'d              */
#define  EXTI2    5         /* Operand two is ()'d              */
#define  REGA2    6         /* One register operand to decode   */
#define  REGA3    7         /* IN & OUT (C)                     */
#define  REGA4    8         /* Two register operands            */
#define  REGA5    9         /* for BIT, SET, & RES              */
#define  REGD2    10        /* One double register op to decode */
#define  REGD3    11        /* Not needed                       */
#define  REGI1    12        /* Operand one is (dreg)'d          */
#define  REGI2    13        /* Operand two is (dreg)'d          */
#define  REGI3    14        /* Not needed                       */
#define  EXTA1    15        /* Operand is 16 bits in b2, b3     */
#define  EXTA2    16        /* LD A,(nn)                        */
#define  EXTA3    17        /* Op1 is cc, op2 is 16 bits        */
#define  EXTA4    18        /* LD dreg,nn                       */
#define  MPZA     19        /* RST xxH                          */
#define  RELA1    20        /* b2 is the offset operand         */
#define  RELA2    21        /* Op1 is cc, b2 is the offset      */
#define  INDX1    22        /* Op1 is indexed by IX.            */
#define  INDX2    23        /* Op2 is indexed by IX.            */
#define  INDX3    24        /* Op2 is a double register.        */
#define  INDX4    25        /* OP IX,nn (no displacement!)      */
#define  INDX5    26        /* OP (IX+d)  no op2!               */
#define  INDY1    27        /* Op1 is indexed by IY.            */
#define  INDY2    28        /* Op2 is indexed by IY.            */
#define  INDY3    29        /* Op2 is a double register.        */
#define  INDY4    30        /* OP IY,nn (no displacement!)      */
#define  INDY5    31        /* OP (IY+d)  no op2!               */
#define  BITA     32        /* Op1 is the bit no.               */

#define  NZ_      0         /* Condition code defines           */
#define  Z_       1
#define  NC_      2
#define  C_       3
#define  PO_      4
#define  PE_      5
#define  P_       6
#define  M_       7

/* --------------------- END of Z80Code.h ---------------------------- */
