/*********************************************************
**
**    Z80Sim.h       Defines for Z80S.c
**
**    PATHNAME:      DH0:CPGM/Z80Sim.h
**
**    FUNCTION:      Header for the Z80 Simulator program.
**
**    LAST CHANGED:  02/08/95 - Added List, Translate, 
**                              Assemble & Edit Code menu items.
**                   03/07/94 - Added Set PC menu item
**                   07/09/89
**
***********************************************************/

#define  MAXADDR          65536L
#define  MAXDATA          255
#define  MAXBUFFER        4096
#define  MAXCODE          9        /* 4 bytes + NIL */
#define  MAXLINE          81       /* 80 char.s + NIL */

#define  MAXBKPT          128
#define  BREAKLINE_LENGTH 32

#define  SCMAXITEM        100 /* Source Code ListView Constants. */
#define  SCITEMLENGTH     40

#define  _NIL        '\0'
#define  DELIM       '@'      /* Used in File_Loader() in Z80Loader.c */
#define  ENDLINE     '\n'
#define  ESC         0x1B

#define  A           0            /* Main registers: */
#define  B           2
#define  C           4
#define  D           6
#define  E           8
#define  H           10
#define  L           12
#define  F           14
#define  I           16
#define  R           17

#define  PC          0
#define  SP          1
#define  IX          2
#define  IY          3

#define  BC          4 // NOT used in dreg[] as indices.
#define  DE          5
#define  HL          6
#define  AF          7

#define  BCP         7             /* Used by breakpoint functions! */
#define  DEP         8
#define  HLP         9

#define  SCRATCH     4             /* for Z80MH.c display functions */
#define  T1          0
#define  T2          1

#define  CARRY       0x01          /* Z80 Status flags */
#define  ZERO        0x40          /* 'SZ-H -PNC'      */
#define  PV          0x04
#define  SGN         0x80
#define  NEG         0x02
#define  HALF        0x10

#define  NCARRY      0xFE          /* Z80 Status flag masks. */
#define  NZERO       0xBF
#define  NPV         0xFB
#define  NSGN        0x7F
#define  NNEG        0xFD
#define  NHALF       0xEF

#define  HALT           2          /* Processor status values. */
#define  RESET          3
#define  RUNNING        1
#define  INT            4
#define  NMI            5
#define  ILLGL          6
#define  SKIP_INC       7
#define  RETURN_FOUND   8

#define  IFF1        0x80
#define  IFF2        0x40
#define  BIN         1
#define  HEX         0
#define  AND         1
#define  OR          2
#define  XOR         3
#define  CP          4

#define  RG          1      /* for the Pop() function: */
#define  M           2
#define  X           3
#define  Y           3
#define  N           0
#define  DRG         4

#define  MAXPNT   25

/* ----------------------- struct definitions: ------------------------- */

struct   _Point    { int    x, y; };

struct   Console  {

         struct   MsgPort     *WritePort;
         struct   IOStdReq    *WriteMsg;
         struct   MsgPort     *ReadPort;
         struct   IOStdReq    *ReadMsg;
         char                 readbuffer[80];
         };

/* ---------------------- Console defines: ------------------------------ */
#define  CON_WPORT   0X01
#define  CON_WMSG    0X02
#define  CON_RPORT   0X04
#define  CON_RMSG    0X08
#define  CON_DEVICE  0X10

/* ---------------------- System Macros: -------------------------- */
#define  F_SET(x)    ((x) = 1)
#define  F_RESET(x)  ((x) = 0)
#define  F_TOGGLE(x) ((x) == 1 ? 0 : 1)

                /* State Machine Macros: */
                /* ADD_REL() moved to Z80States.c */

#define  LD_IMM( reg, val )   ((reg) = (val))
#define  INCPC( val )         (dreg[PC] += (val))
#define  ILLEGAL()            { status = ILLGL; break; }

#define  SETCARRY()     (reg[F] |= CARRY)
#define  RESETCARRY()   (reg[F] &= NCARRY)
#define  SETZERO()      (reg[F] |= ZERO)
#define  RESETZERO()    (reg[F] &= NZERO)
#define  SETPV()        (reg[F] |= PV)
#define  RESETPV()      (reg[F] &= NPV)
#define  SETSIGN()      (reg[F] |= SGN)
#define  RESETSIGN()    (reg[F] &= NSGN)
#define  SETNEG()       (reg[F] |= NEG)
#define  RESETNEG()     (reg[F] &= NNEG)
#define  SETHALF()      (reg[F] |= HALF)
#define  RESETHALF()    (reg[F] &= NHALF)

#define  SETIFF1()      (IFF1_2 |= IFF1)
#define  RESETIFF1()    (IFF1_2 &= 0x7F)

#define  SETIFF2()      (IFF1_2 |= IFF2)
#define  RESETIFF2()    (IFF1_2 &= 0xF7)

