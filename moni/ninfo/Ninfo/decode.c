/* 68000 disassembler Version 1.2 */
/* Amiga Version: A. F. Preston   */
#include <stdio.h>
#include "hunk.h"
int      codedisp;         /* offset of code */
int      codesize;         /* LENGTH OF CODE */
char     *codeaddress;     /* ADDRESS OF CODE */
short srckind;             /* source kind flag */
char codes[] = "RASRHILSCCCSNEEQVCVSPLMIGELTGTLE";
char *interpret[16] =
  {
  /*0*/ "\0\0\0\0\0\0\0\0",
  /*1*/ "",
  /*2*/ "",
  /*3*/ "",
  /*4*/ "\0\0\0\0\0\0\0\0",
  /*5*/ "\170\170\170\104\173\173\173\104ADDQ\0S\0\0\0\0DB\0\0\0SUBQ\0\321\321\342",
  /*6*/ "\360\360\360\360\360\360\360\360B",
  /*7*/ "\200\200\200\200\200\200\200\200MOVEQ",
  /*8*/ "\30\30\30\21\104\105\105\22OR\0\0\0DIVU\0DIVS\0SBCD\0\70\23\143\0\0\70\0\0",
  /*9*/ "\30\30\30\50\102\102\102\50SUB\0\0SUBX\0\70\31\151",
  /*a*/ "\0\0\0\0\0\0\0\0",
  /*b*/ "\30\30\30\50\103\103\103\50CMP\0\0EOR\0\0CMPM\0\71\71\132",
  /*c*/ "\30\30\30\21\105\106\107\22AND\0\0MULU\0MULS\0ABCD\0EXG\0\0\70\23\143\0\0\70\64\224\0\0\70\0\64",
  /*d*/ "\30\30\30\50\102\102\102\50ADD\0\0ADDX\0\70\31\151",
  /*e*/ "",
  /*f*/ "\0\0\0\0\0\0\0\0"
  };
  struct op5_Q
    {
    unsigned opcode:4;
    unsigned data  :3;
    unsigned otype :1;
    unsigned omode :2;
    unsigned eamod :3;
    unsigned eareg :3;
    };
  struct op5_cc
    {
    unsigned opcode:4;
    unsigned ccode :4;
    unsigned omode :2;
    unsigned eamod :3;
    unsigned eareg :3;
    };
  struct indexword
    {
    unsigned dora:1;
    unsigned ireg:3;
    unsigned size:1;
    unsigned junk:3;
    unsigned disp:8;
    };

struct instruction
  {
  unsigned  opcode:4;
  unsigned  destreg:3;
  unsigned  extend:3;
  unsigned  srcmode:3;
  unsigned  srcreg:3;
  };
struct shiftbits
  {
  unsigned  opcode:4;
  unsigned  count:3;
  unsigned  direct:1;
  unsigned  optype:2;
  unsigned  opmode:1;
  unsigned  shift:2;
  unsigned  dest:3;
  };
struct testbits
  {
  unsigned  opcode:4;
  unsigned  ccode:4;
  unsigned  offset:8;
  };
struct mview 
  {
  unsigned  zero:1;
  unsigned    di:3;
  unsigned  type:1;
  unsigned  size:1;
  unsigned zeros:6;
  unsigned    dh:4;
  };

union
  {
  struct op5_Q       qview;
  struct op5_cc      cview;
  struct mview        bits;
  struct instruction iview;
  struct shiftbits       s;
  struct testbits    tview;
  short              sview;
  } cheat;
char opline[80];
char  *hex;          /* output byte pointer */
char  *opp;          /* output line pointer */

/* */
void startline()    /* initialize the output line */
  {
  short i;
  for(i=0; i < 80; i++)opline[i] = ' ';
  opp = opline;
  hex = &opline[17];   /* op code bytes start here */
  }

void padd()     /* pad line to col 40 */
  {
  opp = &opline[45];   /* instruction codes start here */
  }

void opchar(c)  /* put characters in output buffer */   
char c;
  {
  *opp++=c;
  }

void opstring(s) /* put string in output buffer */
char *s;
  {
  while (*s!='\0') opchar(*s++);
  }

short opcode(s)   /* output string with max of 5 characters */
char *s;
  {
  short n=5;
  while ( (*s!='\0') & (n-- >0) ) opchar(*s++);
  return(n);   /* return the unused positions */
  }

void opint(v)    /* output an integer recursively */
unsigned int v;
  {
  unsigned int  t;
  if ((t=v/10)>0) opint(t);
  opchar( (char)(v%10+'0') );
  }

void ophex(v,n)   /* output a value v, n digits long */
unsigned int v;
short n;
  {
  short sc;
  char c;
  while (n-- > 0)
    {
    sc = ( v >> ( n << 2 ) ) & 0xF;
    c =  ( sc <= 9 ) ?  sc+'0'  :  sc-10+'A' ;
    opchar( c );
    };
  }

void opbyte(v)   /* output a hex value v, 2 digits long */
unsigned int v;
  {
  short sc;
  short n=2;
  while (n-- > 0)
    {
    sc = ( v >> ( n << 2 ) ) & 0xF;
    *hex++ =  ( sc <= 9 ) ?  sc+'0'  :  sc-10+'A' ;
    };
  }

void lefthex(v,b)  /* output a value v(4 digits long), after b blanks */
unsigned short  v;
short b;
  {
  while (b-->0)opchar(' ');
  ophex(v,4);
  }

void invalid()    /* invalid opcode handler */
  {
  padd();
  opstring(".WORD ");
  ophex((unsigned int)cheat.sview,4);
  }

void sourcekind(k)  /* output size indicator and set flag */
short k;
  {
  opchar('.');
  switch (k)
    {
    case 0: 
    case 4:         
      opchar('B'); 
      srckind=0; 
      break;
    case 1: 
    case 5: 
    case 3: 
      opchar('W'); 
      srckind=1; 
      break;
    case 2:
    case 6:
    case 7:
      opchar('L');
      srckind=2;
      break;
    }
  }


unsigned char grabchar(n)
short n;  /* leading blanks before output */
  {
  unsigned char c;
  codesize--;
  c = *codeaddress++;
  while( n--> 0)*hex++ = ' ';  /* leading blanks */
  opbyte(c);
  return(c );  
  }

short grabword(n)
short n;           /* leading blanks for word */
  {
  short  *word;
  unsigned char   byte[2];
  word = (short *)byte;
  byte[0] =  grabchar(n);
  byte[1] =  grabchar(0);
  return ( *word );
  }

void outadd(address)
char *address;
  {
  unsigned short *part;
  int value;
  if( codedisp != 0 )
    { 
    part  = (unsigned short *)&value;
    part++; 
    opchar('(');
    value =  ((int)address - codedisp) & 0xFFFF;
    lefthex(*part,0);
    opchar(')');
    };
  part  = (unsigned short *)&value;
  value =(int)address;
  lefthex( *part++, 0);    /* output address */
  lefthex( *part  , 0);
  }  

void operand(mode,reg)     /* operand decoding */
unsigned mode;
unsigned reg;
  {
  union
    {
    short sh;
    struct indexword ind;
    }
  mycheat;
  short sloc;    /* byte or word offset */
  long  cloc;    /* current address for branches */
  opchar(' ');
  switch (mode)
    {
    case 0: 
      opchar('D');
      opint(reg);
      break;
    case 1:
      opchar('A');
      opint(reg);
      break;
    case 2:
      opstring("(A");
      opint(reg);
      opchar(')');
      break;
    case 3: 
      opstring("(A");
      opint(reg);
      opstring(")+");
      break;
    case 4: 
      opstring("-(A");
     opint(reg);
      opchar(')');
      break;
    case 5: 
      opchar(' ');
      ophex(grabword(1),4);
      opstring("(A");
      opint((unsigned int)reg);
      opchar(')');
      break;
    case 6:
      mycheat.sh = grabword(1);
      ophex(mycheat.ind.disp,2);
      opstring("(A");
      opint(reg);
      opchar(',');
      opchar( (char)(mycheat.ind.dora==0 ? 'D' : 'A') );
      opint(mycheat.ind.ireg);
      opchar('.');
      opchar( (char)(mycheat.ind.size==0 ? 'W' : 'L') );
      opchar(')');
      break;
    case 7:
     opchar(' ');
      switch (reg)
        {
        case 0: 
          cloc = grabword(1);
          outadd( (char *)cloc );
          break;
        case 1:
          cloc = grabword(1);
          cloc = cloc<<16 | ( 0xFFFF & grabword(1));
          outadd( (char *)cloc );
          break;
        case 2:    /* 16 bit offset value */
          sloc = grabword(1);
          opstring("   ");
          cloc = (long)sloc + (long)codeaddress -2;
          outadd( (char *)cloc );
          break;
        case 3:
          mycheat.sh=grabword(1);
          opstring(" + ");
          ophex(mycheat.ind.disp,2);
          opchar('(');
          opchar( (char)(mycheat.ind.dora==0 ? 'D' : 'A') );
          opint(mycheat.ind.ireg);
          opchar('.');
          opchar( (char)(mycheat.ind.size==0 ? 'W' : 'L') );
          opchar(')');
          break;
      case 4: 
        opstring("# ");
        switch (srckind)
          {
          case 0:
            ophex((unsigned int)grabword(1),2);
            break;
          case 1: 
            ophex((unsigned int)grabword(1),4);
            break;
          case 2:
            ophex((unsigned int)grabword(1),4);
            ophex((unsigned int)grabword(0),4);
            break;
          };
        break;
      case 5:  /* 32 bit offset */
        cloc = (long)grabword(1);
        cloc = cloc<<16 | ( 0xFFFF & (long) grabword(1));
        opstring("   ");
        cloc = cloc + (long)codeaddress -4;
        outadd( (char *)cloc );
        break;
      case 6:  /* 8 bit offset */ 
        sloc = (short)(cheat.tview.offset) ;
        opstring("   ");
        cloc = (long)sloc + (long)codeaddress;
        outadd( (char *)cloc );
        break;

      }
    }
  }

void shiftinstruction()   /* handle shift instructions */
  {
  short n,t;
  static char *mnemonics[8] =
    {
    "ASR",  "ASL",  "LSR", "LSL",
    "ROXR", "ROXL", "ROR", "ROL"
    } ;
  padd();
  if (cheat.s.optype==3)
    {
    n = opcode(mnemonics[(cheat.s.count<<1)+cheat.s.direct]);
    while( n-- > 0)opchar(' ');
    operand(cheat.iview.srcmode,cheat.iview.srcreg);
    }
  else
    {
    n = opcode(mnemonics[(cheat.s.shift<<1)+cheat.s.direct]);
    sourcekind((short)cheat.s.optype);
    while( n-- > 0)opchar(' ');
    if (cheat.s.opmode==0)
      {
      opstring(" #");
      opint((short) (t=cheat.s.count)==0 ? 8 : t );
      }
    else
    operand(0,cheat.s.count);
    opchar(',');
    operand(0,cheat.s.dest);
    }
  }

void conditioncode(cc)
unsigned short cc;
  {
  if (cc>1 || cheat.iview.opcode==6)
    {
    opchar(codes[cc<<1]);
    opchar(codes[(cc<<1)+1]);
    }
  else if (cc==0) opchar('T');
  else opchar('F');
  }

void handlezero()
  {
  short ext =  cheat.iview.extend;
  short dreg = cheat.iview.destreg;
  short smod = cheat.iview.srcmode;
  short sreg = cheat.iview.srcreg;
  static char *opzero[] =
    {
    "ORI","ANDI","SUBI","ADDI","ERR","EORI","CMPI",""
    }
  ;
  static char *opone[] =
    {
    "BTST","BCHG","BCLR","BSET"
    }
  ;
  padd();
  if ( (ext <= 2) & ( dreg != 4) )
    {
    opstring(opzero[dreg]);
    sourcekind(ext);
    operand(7,4);
    opchar(',');
    if ( (smod == 7) && (sreg == 4) )
      {
      if (srckind==0) 
         {
         opstring(" CCR ");
         }
      else opstring(" SR ");
      }
    else operand(smod,sreg);
    }
  else if ( (ext <= 3) & (dreg == 4) )
    {
    opstring(opone[ext]);
    srckind = 0;
    operand(7,4);
    opchar(',');
    operand(smod,sreg);
    }
  else if (ext>=4)
    {
    if (smod!=1)
      {
      opstring(opone[ext-4]);
      operand(0,dreg);
      opchar(',');
      operand(smod,sreg);
      }
    else
      {
      opstring("MOVEP");
      sourcekind(1+(ext&1));
      if (ext<=5)
        {
        operand(5,sreg);
        opchar(',');
        operand(0,dreg);
        }
      else
        {
        operand(0,dreg);
        opchar(',');
        operand(5,sreg);
        }
      }
    }
  else if ( (ext <= 3) & (dreg == 7) )
    {
    opstring("MOVES");
    sourcekind(ext);
    operand(smod,sreg);
    opchar(',');
    operand(7,0);
    }
  else invalid();
  }

void    breakfurther(base)
char *base;
  {
  short ext =  cheat.iview.extend;
  short dreg = cheat.iview.destreg;
  short smod = cheat.iview.srcmode;
  short sreg = cheat.iview.srcreg;
  short comm,t, n;
  padd();
  
  if ( ( (comm = *(base+ext) ) & 0xF0 ) == 0x40 )
  comm = *(base + ( 8 + (t=comm&0xF) + (t<<2) 
         + ( smod==0 ? 1 : (smod==1 ? 2 : 0) ) ) );
  if (comm==0)invalid();
  else
    {
    n = opcode( base + ( 8 + ( t = comm & 7 ) + (t<<2) ) );
    if (comm & 8) sourcekind(ext);
    if ( ( t = (comm>>4) & 0xF ) >= 13 )
       {
       conditioncode(cheat.tview.ccode);
       n = 2;
       };
    while( n-- > 0) opchar(' ');
    switch (t)
      {
      case 0:
        invalid();
        break;
      case 1: 
        operand(smod,sreg);
        opchar(',');
        operand(0,dreg);
        break;
      case 2:
        operand(smod,sreg);
        opchar(',');
        operand(1,dreg);
        break;
      case 3:
        operand(0,dreg);
        opchar(',');
        operand(smod,sreg);
        break;
      case 4:
        opstring(" Internal check fail");
        break;
      case 5:
        operand(3,sreg);
        opchar(',');
        operand(3,dreg);
        break;
      case 6:
        operand(4,sreg);
        opchar(',');
        operand(4,dreg);
        break;
      case 7:
        opstring(" #");
        opint(dreg);
        opchar(',');
        operand(smod,sreg);
        break;
      case 8: 
        opstring(" #");
        ophex(cheat.tview.offset,2);
        opchar(',');
        operand(0,dreg);
        break;
      case 9:  
        operand(1,dreg);
        opchar(',');
        operand(smod,sreg);
        break;
      case 13:
        operand(smod,sreg);
        break;
      case 14:
        operand(0,sreg);
        opchar(',');
        operand(7,2);
        break;
      case 15:
        if     ( cheat.tview.offset == 0x00 ) operand(7,2);
        else if( cheat.tview.offset == 0xFF ) operand(7,5); 
        else                                  operand(7,6);
        break;
      }
    }
  }

void  moveinstruction(kind)
unsigned short kind;
  {
  padd();
  opstring("MOVE");
  sourcekind(kind==1 ? 0 : (kind==2 ? 2 : 1));
  operand(cheat.iview.srcmode,cheat.iview.srcreg);
  opchar(',');
  operand(cheat.iview.extend,cheat.iview.destreg);
  }

void  startrange(bit)
short bit;
  {
  operand(bit<=7 ? 0 : 1, bit%8);
  }

void endrange(first,bit)
short first,bit;
  {
  if (first<=7 && bit>7)
    {
    endrange(first,7);
    opchar('/');
    startrange(8);
    first=8;
    }
  ;
  if (bit>first)
    {
    opchar('-');
    startrange(bit);
    }
  }

void  registerlist(kkkk,mask)
short kkkk,mask;
  {
  short bit = 0;
  short inrange = -1;
  short some = 0;
  while (bit <= 15)
    {
    if ( ( kkkk ? (mask>>(15-bit)) : (mask>>bit) ) & 1 )
      {
      if (inrange<0)
        {
        if (some) opchar('/');
        startrange(bit);
        some = 1; inrange = bit;
        }
      }
    else
      {
      if (inrange>=0)
        {
        endrange(inrange,bit-1);
        inrange = -1;
        }
      }
    ;
    bit++;
    };
  if (inrange>=0) endrange(inrange,15);
  }
void  specialbits()
  {
  short smod = cheat.iview.srcmode;
  short sreg = cheat.iview.srcreg;
  padd();
  switch (smod)
    {
    case 0: 
    case 1:
      opstring("TRAP  #");
      opint( ( (smod%1)<<3 ) + sreg );
      break;
    case 2:
      opstring("LINK   ");
      operand(1,sreg);
      opchar(',');
      srckind=1;
      operand(7,4);
      break;
    case 3:
      opstring("UNLK   ");
      operand(1,sreg);
      break;
    case 4:
      opstring("MOVE   ");
      operand(1,sreg);
      opstring(",USP");
      break;
    case 5:
      opstring("MOVE    USP");
      operand(1,sreg);
      break;
    case 6: 
      switch (sreg)
        {
        case 0: 
          opstring("RESET");
          break;
        case 1:
          opstring("NOP");
          break;
        case 2:
          opstring("STOP");
          srckind=1;
          operand(7,4);
          break;
        case 3:
          opstring("RTE");
          break;
        case 4:
          opstring("RTD");
          srckind = 1;
          operand(7,4);
          break;
        case 5:
          opstring("RTS");
          break;
        case 6:
          opstring("TRAPV");
          break;
        case 7:
          opstring("RTR");
          break;
        } ;
      break;
    case 7: 
      opstring("MOVEC   ");
      srckind = 1;
      operand(7,4);
      break;
    }
  }

void  handlefour()
  {
  short ext =  cheat.iview.extend;
  short dreg = cheat.iview.destreg;
  short smod = cheat.iview.srcmode;
  short sreg = cheat.iview.srcreg;
  short reglist;
  static char *unaryA[] =
    {
    "NEGX","CLR","NEG","NOT","ERR","TST"
    };
  static char *cross4[] =
    {
    "NBCD","PEA   ", "MOVEM.W","MOVEM.L",
    "NBCD","SWAP  ","EXT.W  ","EXT.L   "
    };
  static char *jumps[] =
    {
    "JSR   ","JMP   "
    };
  static char * opty[] = { "MUL", "DIV"};
  
  padd();
  if( dreg == 6 && ext <= 1)
    {
    opstring( opty[ext] );
    cheat.sview = grabword(1);
    opchar( (char)(cheat.bits.type == 0 ? 'U' : 'S') );
    opstring(".L ");
    operand(smod, sreg);
    opchar(',');
    if( cheat.bits.size == 0)
      {
      operand(0,cheat.bits.dh);
      opchar(':');
      operand(0,cheat.bits.di);
      }
    else   operand(0,cheat.bits.di);
    }
  else if (ext<=2 && (dreg<=3 || dreg==5))
    {
    opstring(unaryA[dreg]);
    sourcekind(ext);
    opchar(' ');
    operand(smod,sreg);
    }
  else if (dreg==4 && ext<=3)
    {
    opstring(cross4[smod==0 ? ext+4 : ext]);
    opchar(' ');
    if (ext>=2 && smod!=0)
      {
      registerlist((short)(smod==4),grabword(1));
      opchar(',');
      };
    operand(smod,sreg);
    }
  else if(ext==2 || ext==3)
    {
    if (dreg==6)
      {
      opstring(cross4[ext]);
      opchar(' ');
      reglist = grabword(1);
      operand(smod==4 ? 3: smod ,sreg);
      opchar(',');
      registerlist(0,reglist);
      }
    else if (dreg==7)
      {
      opstring(jumps[ext-2]);
      operand(smod,sreg);
      }
    else if (ext==3)
      {
      switch (dreg)
        {
        case 0:
          opstring("MOVE  SR,  ");
          operand(smod,sreg);
          break;
        case 1: 
          opstring("MOVE  CCR, ");
          operand(smod,sreg);
          break;
        case 2: 
          opstring("MOVE  ");
          srckind=0;
          operand(smod,sreg);
          opstring(", CCR");
          break;
        case 3: 
          opstring("MOVE  ");
          srckind=1;
          operand(smod,sreg);
          opstring(", SR");
          break;
        case 5: 
          if( smod == 7  && sreg == 4 )
            {
            opstring("ILLEGAL");
            }
          else 
            {
            opstring("TAS  ");
            operand(smod,sreg);
            break;
            };
        }
      }
    }
  else if (ext==7)
    {
    opstring("LEA    ");
    operand(smod,sreg);
    opchar(',');
    operand(1,dreg);
    }
  else if (ext==6)
    {
    opstring("CHK    ");
    srckind=1;
    operand(smod,sreg);
    opchar(',');
    operand(0,dreg);
    }
  else if (ext==1 && dreg==7) specialbits();
  else invalid();;
  }

void op_5()
  {
  short ccod = cheat.cview.ccode;
  short omop = cheat.qview.omode;
  short qmod = cheat.qview.eamod;
  short qreg = cheat.qview.eareg;
  short qval = cheat.qview.data;
/* op-code 5 is:                */
/* TRAPcc, DBcc, and Scc if omop is 3 */
/* ADDq and SUBq                      */
  padd();
  if( omop == 3 )
    {
    switch (qmod)
      {
      case 1: /* DBcc */
        opstring("DB");
        conditioncode(ccod);
        opstring(".W ");
        operand(0,qreg);
        opchar(',');
        operand(7,2);
        break;
      case 7: /* TRAPcc */
        opstring("TRAP");
        conditioncode(ccod);
        if( qreg == 2 || qreg == 3 )
          {
          sourcekind(qreg-1);       /* size indicator */
          operand(7,4);           /* immediate value*/
          };
        break;
      default:
        opstring("S");
        conditioncode(ccod);
        operand(qmod,qreg);
      };
    }
  else
    {
    opstring( ( cheat.qview.otype == 0 ? "ADDQ" : "SUBQ") );
    sourcekind(omop);
    if( qval == 0 ) qval = 8;
    opstring(" #");
    opint(qval);
    opchar(',');
    operand(qmod, qreg);
    };
  }
void 
op_14()
  {
  short ext =  cheat.iview.extend;
  short dreg = cheat.iview.destreg;
  short smod = cheat.iview.srcmode;
  short sreg = cheat.iview.srcreg;
/* op-code 14 is:          */
/* CMP  <ea>,Dn        if ext = 0, 1, or 2 */  
/* CMPA <ea>,An        if ext = 3 or 7    */
/* CMPM (Ax)+, (Ay)+   if ext = 4, 5, or 6 and smod = 1 */
/* EOR  Dn, <ea>       if ext = 4, 5, or 6 and smod != 1 */
  padd();
  switch ( ext )
    {
    case 0:
    case 1:       /* Compare */
    case 2:
      opstring("CMP");
      sourcekind(ext);
      opchar(' ');
      operand(smod,sreg);
      opstring(", ");
      operand(0,dreg);
      break;
    case 3:      /* Compare address */
    case 7: 
      opstring("CMPA");
      sourcekind(ext);
      operand(smod,sreg);
      opstring(", ");
      operand(1,dreg);
      break;
    case 4:
    case 5:      /* Compare Memory or Exclusive OR */
    case 6:
      if( smod == 1 ) 
        {
        opstring("CMPM");
        sourcekind(ext);
        operand(3,sreg);
        opstring(", ");
        operand(3,dreg);
        }
      else
        {
        opstring("EOR");
        sourcekind(ext);
        opchar(' ');
        operand(0,dreg);
        opstring(", ");
        operand(smod,sreg);
        };
      break;
    };
  }
void decode()         /* decode instructions at address */
  {
  startline();                /* initialize the line  */
  outadd(codeaddress);      /* display address with offset */
  cheat.sview=grabword(1);  /* get the opcode */
  switch (cheat.iview.opcode)
    {
    case 1:
    case 2:
    case 3:
      moveinstruction(cheat.iview.opcode);
      break;
    case 0:
      handlezero();
      break;
    case 4:
      handlefour();
      break;
    case 5:
      op_5();
      break;
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
      breakfurther(interpret[cheat.iview.opcode]);
      break;
    case 11:
      op_14();
      break;
    case 12:
    case 13:
    case 15: 
      breakfurther(interpret[cheat.iview.opcode]);
      break;
    case 14:
      shiftinstruction();
      break;
    } ;
  }

char * dumpcode(offset,loc,n)
int  offset;   /* relative offset for listings */
char *loc;     /* address of code */
int n;         /* length of code in bytes*/
  {
  codedisp = offset;
  codesize = n;
  codeaddress = loc;
  while (codesize>0)
    {
    decode();        /* disassemble */
    opchar(0x00);    /* null */
    puts(opline);
    };
  return(codeaddress);
  }
