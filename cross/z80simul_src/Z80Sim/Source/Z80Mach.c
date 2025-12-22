/****h* Z80Simulator/Z80Mach.c [2.5] **********************************
*
* NAME
*    Z80Mach.c
*
* DESCRIPTION
*    The state machine support routines for
*    Z80ST1.c, Z80S21.c, Z80S22.c, Z80S23.c, Z80S24.c & Z80ST3.c
*
* HISTORY
*    21-Apr-2001 - Added code for highlighting register value changes.
*    04-Mar-1994 - Added Z80FuncProtos.h
***********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <intuition/intuitionbase.h>

#include "Z80Sim.h"
#include "Z80FuncProtos.h"

#define  BYTE_MASK_   0xFF
#define  WORD_MASK_   0xFFFF

IMPORT UBYTE  n1, n2, byte1, byte2, byte3, byte4, altAF, altregs,
             *mem, IFF1_2, status, reg[];

IMPORT UWORD  addr, dreg[];

IMPORT BOOL   sregchanged[], dregchanged[];

// return the most-significant byte of a double register:

UBYTE get_high_word( int drg )
{
   ULONG    MASK = 0x0000FF00;
   ULONG    rval = 0;

   rval   = (dreg[drg] & MASK);
   rval >>= 8;

   return( (UBYTE) rval );
}

// return the least-significant byte of a double register:

UBYTE get_low_word( int drg )
{
   ULONG    MASK = 0x000000FF;
   UBYTE    rval = 0;

   rval = (UBYTE) (dreg[drg] & MASK);

   return( rval );
}

UWORD add_displ( unsigned int indx, unsigned int displ )
{
   int   s_displ = 0;
   UWORD rval    = 0;

   if (displ > 0x7F)
      s_displ = - (0xFF - displ + 1);
   else
      s_displ =  displ;

   rval = dreg[indx] + s_displ;

   if (s_displ != 0)
      dregchanged[ indx ] = TRUE;
   else
      dregchanged[ indx ] = FALSE;
      
   return( rval );
}

/* get the high & low bytes from a double register   */

int Set_High_Low( int drg_index, UBYTE *high, UBYTE *low )
{
   switch (drg_index)   
      {
      case   BC:   *high = reg[B];    
                   *low  = reg[C];   
                   break;

      case   DE:   *high = reg[D];    
                   *low  = reg[E];
                   break;

      case   HL:   *high = reg[H];    
                   *low  = reg[L];
                   break;

      case   SP:   *high = dreg[SP] & 0xFF00; // >> 8 ??
                   *low  = dreg[SP] & 0x00FF;
                   break;

      case   IX:   *high = dreg[IX] & 0xFF00;
                   *low  = dreg[IX] & 0x00FF;
                   break;

      case   IY:   *high = dreg[IY] & 0xFF00;
                   *low  = dreg[IY] & 0x00FF;
                   break;

      case   PC:   *high = dreg[PC] & 0xFF00;
                   *low  = dreg[PC] & 0x00FF;
                   break;
      }

   return 0;
}

/* set the single registers to what the double register contains. */

int Reset_SRegs( int drg_index, UBYTE high, UBYTE low )
{

   switch (drg_index)   
      {
      case   BC:
         if (reg[B] != high)
            sregchanged[B] = TRUE;
         else
            sregchanged[B] = FALSE;
            
         if (reg[C] != low)
            sregchanged[C] = TRUE;
         else
            sregchanged[C] = FALSE;
            
         reg[B] = high;    
         reg[C] = low;   
         break;
      
      case   DE:   
         if (reg[D] != high)
            sregchanged[D] = TRUE;
         else
            sregchanged[D] = FALSE;
            
         if (reg[E] != low)
            sregchanged[E] = TRUE;
         else
            sregchanged[E] = FALSE;
            
         reg[D] = high;    
         reg[E] = low;   
         break;
      
      case   HL:   
         if (reg[H] != high)
            sregchanged[H] = TRUE;
         else
            sregchanged[H] = FALSE;
            
         if (reg[L] != low)
            sregchanged[L] = TRUE;
         else
            sregchanged[L] = FALSE;
            
         reg[H] = high;    
         reg[L] = low;   
         break;
      
      case   SP:   
         if (dreg[SP] != (high << 8) + low)
            dregchanged[SP] = TRUE;
         else
            dregchanged[SP] = FALSE;
            
         dreg[SP] = (high << 8) + low;     
         break;
      
      case   IX:   
         if (dreg[IX] != (high << 8) + low)
            dregchanged[IX] = TRUE;
         else
            dregchanged[IX] = FALSE;
            
         dreg[IX] = (high << 8) + low;     
         break;
      
      case   IY:   
         if (dreg[IY] != (high << 8) + low)
            dregchanged[IY] = TRUE;
         else
            dregchanged[IY] = FALSE;
            
         dreg[IY] = (high << 8) + low;     
         break;
      
      case   PC:   
         if (dreg[PC] != (high << 8) + low)
            dregchanged[PC] = TRUE;
         else
            dregchanged[PC] = FALSE;
            
         dreg[PC] = (high << 8) + low;     
         break;
      }

   return 0;
}

void add_indx( int x, int val )
{
   UBYTE  hi = 0, lo = 0;
   
   if (val > IY) // BC, DE HL or AF register sets:
      {
      (void) Set_High_Low( val, &hi, &lo );
      dreg[val] = (hi << 8) + lo;
      }

   RESETNEG();

   if ((dreg[x] + dreg[val]) >= 4096)
      SETHALF();
   else     
      RESETHALF();

   if ((dreg[x] + dreg[val]) >= MAXADDR)
      SETCARRY();
   else
      RESETCARRY();

   if (dreg[val] != 0)
      dregchanged[x] = TRUE;
   else
      dregchanged[x] = FALSE;
      
   dreg[x] += dreg[val];

   sregchanged[F] = TRUE;
   return;
}

void negate( void )
{
   UBYTE result, n1;

   SETNEG();
   
   if (reg[A] != 0)
      sregchanged[A] = TRUE;
   else
      sregchanged[A] = FALSE;
      
   result = (UBYTE) (0 - reg[A]);
   n1     = reg[A] & 0x0F;

   if (result > 0x7F)   
      SETSIGN();  
   else  
      RESETSIGN();
   
   if (result == 0  )   
      SETZERO();  
   else  
      RESETZERO();
   
   if (result == 0x80)  
      SETPV();    
   else  
      RESETPV();
   
   if (reg[A] != 0)
      SETCARRY(); 
   else  
      RESETCARRY();
   
   if (n1 > 0)
      SETHALF();  
   else  
      RESETHALF();

   reg[A] = result;

   sregchanged[F] = TRUE;
   return;
}

void add_dbl( int drg )
{
   UBYTE    h1 = 0, h2 = 0, l1 = 0, l2 = 0;
   ULONG    total = 0;
   int      b1, b2;

   (void) Set_High_Low( drg, &h1, &l1 );
   (void) Set_High_Low( HL,  &h2, &l2 );

   RESETNEG();

   dreg[HL]  = (h2 << 8) + l2;
   dreg[drg] = (h1 << 8) + l1;
   b1        = dreg[HL]  & 0x0FFF;
   b2        = dreg[drg] & 0x0FFF;
   total     = dreg[HL]  + dreg[drg];

   if ((b1 + b2) > 0x0FFF)         
      SETHALF();
   else
      RESETHALF();

   if ((total & WORD_MASK_) == 0)  
      SETZERO();
   else
      RESETZERO();

   if ((total & WORD_MASK_) > 0x7FFF)
      SETSIGN();
   else
      RESETSIGN();

   if (total > 0xFFFF)
      {  
      SETPV();    
      SETCARRY();   
      }
   else
      {  
      RESETPV();  
      RESETCARRY(); 
      }

   dreg[HL] += dreg[drg];

   (void) Reset_SRegs( HL, (dreg[HL] >> 8), (dreg[HL] & 0x00FF) );
 
   sregchanged[F] = TRUE;

   return;
}

void adc_dreg( int dr, int val )
{
   UBYTE      h1 = 0, h2 = 0, l1 = 0, l2 = 0;
   short int  tempcarry;
   int        b1, b2, total;

   (void) Set_High_Low( val, &h1, &l1 );
   (void) Set_High_Low( dr,  &h2, &l2 );

   RESETNEG();

   tempcarry = reg[F] & CARRY;
   dreg[dr]  = (h2 << 8) + l2;    /* set dreg[] = to hi & lo bytes */
   dreg[val] = (h1 << 8) + l1;
   total     = dreg[dr] + dreg[val] + tempcarry;
   b1        = dreg[dr]  & 0x0FFF;
   b2        = dreg[val] & 0x0FFF;

   if ((b1 + b2 + tempcarry) > 0x0FFF)  
      SETHALF();
   else
      RESETHALF();

   if (total == 0)
      SETZERO();
   else
      RESETZERO();

   if (total > 0x7FFF)
      SETSIGN();
   else
      RESETSIGN();

   if (total > 0xFFFF)  
      {
      SETPV();    
      SETCARRY();   
      }
   else
      {
      RESETPV();  
      RESETCARRY(); 
      }

   dreg[dr] += (dreg[val] + tempcarry);
 
   (void) Reset_SRegs( dr, (dreg[dr] >> 8), (dreg[dr] & 0x00FF) );

   sregchanged[F] = TRUE; 

   return;
}

void sbc_dreg( int dr, int val )
{
   UBYTE      h1 = 0, h2 = 0, l1 = 0, l2 = 0;
   short int  tempcarry;
   int        b1, b2;
   UWORD      total;

   (void) Set_High_Low( dr,  &h2, &l2 );
   (void) Set_High_Low( val, &h1, &l1 );    

   SETNEG();

   tempcarry = reg[F] & CARRY;
   dreg[dr]  = (h2 << 8) + l2;
   dreg[val] = (h1 << 8) + l1;
   total     = dreg[dr] - dreg[val] - tempcarry;
   b1        = dreg[dr]  & 0x0FFF;
   b2        = dreg[val] & 0x0FFF;

   if ((b1 - b2 - tempcarry) < 0)     
      SETHALF();
   else
      RESETHALF();

   if (total == 0)
      SETZERO();
   else
      RESETZERO();

   if (total > 0x7FFF)
      SETSIGN();
   else
      RESETSIGN();

   if (total > 0xFFFF)  
      {
      SETPV();    
      SETCARRY();   
      }
   else 
      {
      RESETPV();  
      RESETCARRY(); 
      }

   dreg[dr] = dreg[dr] - dreg[val] - tempcarry;

   (void) Reset_SRegs( dr, (dreg[dr] >> 8), (dreg[dr] & 0x00FF) );

   sregchanged[F] = TRUE;
   
   return;
}

void inc_mem( UWORD addr )
{
   short int n1;

   RESETNEG();

   if ((n1 = ((mem[addr] + 1) & 0x0F)) > 0x0F)     
      SETHALF();
   else
      RESETHALF();

   if (mem[addr] == 0x7F)                 
      SETPV();
   else
      RESETPV();

   mem[addr]++;
   
   if (mem[addr] == 0)
      SETZERO();
   else
      RESETZERO();

   if (mem[addr] > 0x7F)   
      SETSIGN();
   else
      RESETSIGN();

   sregchanged[F] = TRUE;
     
   return;
}

void dec_mem( UWORD addr )
{
   short int n1;

   SETNEG();

   if ((n1 = (mem[addr] & 0x0F) - 1) < 0)     
      SETHALF();
   else
      RESETHALF();

   if (mem[addr] == 0x80)
      SETPV();
   else
      RESETPV();

   mem[addr]--;
   
   if (mem[addr] == 0)     
      SETZERO();
   else
      RESETZERO();

   if (mem[addr] > 0x7F)
      SETSIGN();
   else
      RESETSIGN();
   
   sregchanged[F] = TRUE;

   return;
}

void compare_reg( int val )     /* called by decode_mach2() */
{
   short int   n1, n2;

   SETNEG();

   n1 = reg[A] & 0x0F;  
   n2 = val & 0x0F;

   if ((n1 - n2) < 0)
      SETHALF();
   else
      RESETHALF();

   if ((reg[A] - val) == 0)   
      SETZERO();
   else
      RESETZERO();

   if ((reg[A] - val) > 0x7F) 
      SETSIGN();
   else
      RESETSIGN();

   if ((reg[A] - val) < 0)  
      {
      SETPV(); 
      SETCARRY();
      }
   else  
      {
      RESETPV(); 
      RESETCARRY();
      }

   sregchanged[F] = TRUE;
   
   return;
}

void inc_reg( int r )
{
   INCPC( 1 );               /* INC 8-Bit Register */
   RESETNEG();
   RESETPV();
   RESETZERO();
   RESETSIGN();

   sregchanged[F] = TRUE;
   sregchanged[r] = TRUE;

   n1 = reg[r] & 0x0F;

   if (n1 > 0x0E)      // There will be a carry from bit 3!
      SETHALF();
   else              
      RESETHALF();
 
   if (reg[r] == 0xFF)
      {
      reg[r] = 0;
      SETZERO();
      return;
      }
   else if (reg[r] == 0x7F)  
      {
      reg[r]++;
      SETPV();
      SETSIGN();
      return;
      }
   else if (reg[r] > 0x7F) 
      {
      reg[r]++;
      SETSIGN();
      return;
      }

   reg[r]++;

   return;
}

void dec_reg( int r )
{

   INCPC( 1 );            /* Decrement 8-bit register */
   RESETZERO();
   RESETPV();
   RESETSIGN();
   SETNEG();

   sregchanged[F] = TRUE;
   sregchanged[r] = TRUE;

   if ((n1 = reg[r] & 0x0F) == 0) 
      SETHALF();
   else
      RESETHALF();

   if (reg[r] == 0x80)  
      {
      reg[r]--;
      SETPV();
      return;
      }
   else if (reg[r] == 1)   
      {
      reg[r]--;
      SETZERO();
      return;
      }
   else if (reg[r] == 0)   
      {
      reg[r]--;
      SETSIGN();
      return;
      }
   else if (reg[r] > 0x80) 
      {
      SETSIGN();
      reg[r]--;
      return;
      }

   reg[r]--;

   return;
}

void inc_dreg( int rh, int rl )
{
   INCPC( 1 );            /* Inc Register Pair */

   if (reg[rl] > 0xFE)   
      {
      reg[rl] = 0;
      reg[rh]++;
      sregchanged[rh] = TRUE;
      }
   else
      reg[rl]++;

   sregchanged[rl] = TRUE;

   return;
}

void dec_dreg( int rh, int rl )
{
   INCPC( 1 );            /* Decrement Register Pair */

   if (reg[rl] == 0)     
      {
      sregchanged[rh] = TRUE;
      
      if (reg[rh] > 0)   
         {
         reg[rh]--;
         reg[rl] = 0xFF;
         }
      else  
         {
         reg[rh] = 0xFF;
         reg[rl] = 0xFF;
         }
      }
   else
      reg[rl]--;

   sregchanged[rl] = TRUE;
   
   return;
}

void setup_flags( int num )
{
   if (num == 0)
      SETZERO();
   else
      RESETZERO();

   if (num > 0x7F)
      SETSIGN();
   else
      RESETSIGN();

   if ((num % 2) == 0)
      SETPV();
   else
      RESETPV();
      
   sregchanged[F] = TRUE;
   return;
}

void sla_reg( int var, int type )
{
   int   temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); RESETHALF();

   if ((temp & 0x80) == 0x80)
      SETCARRY();
   else
      RESETCARRY();

   temp = (temp << 1);

   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var]  = temp;
      }
   else if (type == M)
      var       = temp;

   setup_flags( temp );

   return;
}

void sra_reg( int var, int type )
{
   int   temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); RESETHALF();
   
   if ((temp & 1) == 1)
      SETCARRY();
   else
      RESETCARRY();
   
   if ((temp & 0x80) == 0x80)   
      {
      SETSIGN(); 
      temp  = (temp >> 1); 
      temp += 0x80;  
      }
   else  
      {
      RESETSIGN(); temp = (temp >> 1);  
      }

   if (temp == 0)
      SETZERO();
   else
      RESETZERO();
   
   if ((temp % 2) == 0)
      SETPV();
   else
      RESETPV();
   
   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var]  = temp;
      }
   else if (type == M)
      var       = temp;

   sregchanged[F] = TRUE;
   return;
}

void srl_reg( int var, int type )
{
   int   temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); RESETHALF();
   
   if ((temp & 1) == 1)
      SETCARRY();
   else
      RESETCARRY();
   
   temp = (temp >> 1);
   setup_flags( temp );
   
   RESETSIGN();
   
   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var]  = temp;
      }
   else if (type == M)
      var       = temp;
   
   return;
}

void rlc_reg( int var, int type )
{
   int   temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); 
   RESETHALF();
   
   if ((temp & 0x80) == 0x80)   
      {
      SETCARRY(); 
      temp = (temp << 1); 
      temp++;   
      }
   else  
      { 
      RESETCARRY(); 
      temp = (temp << 1); 
      }
   
   setup_flags( temp );
   
   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var] = temp;
      }
   else if (type == M)
      var = temp;
   
   return;
}

void rl_reg( int var, int type )
{
   int   carry = 0, temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); 
   RESETHALF();
   
   if ((reg[F] & CARRY) == CARRY)      
      carry = 1;
   
   if (temp > 0x7F)   
      SETCARRY();
   else
      RESETCARRY();
   
   temp = (temp << 1) + carry;

   setup_flags( temp );
   
   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var]  = temp;
      }
   else if (type == M)
      var       = temp;
   
   return;
}

void rrc_reg( int var, int type )
{
   int   temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); 
   RESETHALF();
   
   if ((temp & 1) == 1)   
      {
      SETCARRY(); 
      temp = (temp >> 1) + 0x80;  
      }
   else  
      { 
      RESETCARRY(); 
      temp = (temp >> 1); 
      }

   setup_flags( temp );
 
   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var]  = temp;
      }
   else if (type == M)
      var = temp;

   return;
}

void rr_reg( int var, int type )
{
   int   carry = 0, temp = 0;

   if (type == RG)
      temp = reg[var];  /* register */
   else if (type == M)
      temp = var;       /* memory   */

   RESETNEG(); 
   RESETHALF();
   
   if ((reg[F] & CARRY) == CARRY)      
      carry = 0x80;
   
   if ((temp & 1) == 1)   
      {
      SETCARRY(); 
      temp = (temp >> 1) + carry;  
      }
   else  
      {
      RESETCARRY(); 
      temp = (temp >> 1) + carry; 
      }

   setup_flags( temp );

   if (type == RG)
      {
      if (reg[var] != temp)
         sregchanged[var] = TRUE;
      else
         sregchanged[var] = FALSE;
         
      reg[var] = temp;
      }
   else if (type == M)
      var = temp;
   
   return;
}

void add_regs( int r1, int r2, int type )
{
   int  temp = 0, tsum = 0;

   INCPC( 1 );
   RESETNEG();

   if (type == RG)
      temp = reg[r2]; /* register */
   else if (type == M || type == N)  
      temp = r2;      /* memory or ADD r,n */

   n1 = reg[r1] & 0x0F; n2 = temp & 0x0F;

   if ((n1 + n2) > 0x0F)
      SETHALF();
   else
      RESETHALF();

   tsum = reg[r1] + temp;

   if ((tsum & BYTE_MASK_) > 0x7F)   
      SETSIGN();
   else
      RESETSIGN();

   if (tsum > 0xFF)   
      { 
      SETPV();     
      SETCARRY();   
      }
   else
      { 
      RESETPV();   
      RESETCARRY(); 
      }

   if ((tsum & BYTE_MASK_) == 0) 
      {
      SETZERO();
      RESETCARRY();
      RESETPV();
      }
   else
      RESETZERO();

   if (reg[r1] != tsum)
      sregchanged[r1] = TRUE;
   else
      sregchanged[r1] = FALSE;
      
   reg[r1] = tsum;

   sregchanged[F] = TRUE;

   return;
}

void adc_reg( int r1, int r2, int type )
{
    UBYTE     carry = 0;
    int       temp  = 0, tsum = 0;

    INCPC( 1 );

    if (type == RG)
       temp = reg[r2]; /* register */
    else if (type == M || type == N) 
       temp = r2;      /* memory or ADC r,n */

    if ((reg[F] & CARRY) == CARRY)         
       carry = 1;
    
    RESETNEG();
    
    n1 = reg[r1] & 0x0F;
    n2 = temp    & 0x0F;
    
    if ((n1 + n2 + carry) > 0x0F)        
       SETHALF();
    else
       RESETHALF();
    
    tsum = reg[r1] + temp + carry;
    
    if ((tsum & BYTE_MASK_) > 0x7F)
       SETSIGN();
    else
       RESETSIGN();
    
    if (tsum > 0xFF)                
       {    
       SETPV();   
       SETCARRY();   
       }
    else 
       {
       RESETPV(); 
       RESETCARRY(); 
       }

    if ((tsum & BYTE_MASK_) == 0)
       SETZERO();
    else
       RESETZERO();
    
    if (reg[r1] != tsum)
       sregchanged[r1] = TRUE;
    else
       sregchanged[r1] = FALSE;
       
    reg[r1] = tsum;
    
    sregchanged[F] = TRUE;

    return;
}

void sub_regs( int r1, int r2, int type )
{
   int  temp = 0, tsum = 0;

   INCPC( 1 );
   SETNEG();

   if (type == RG)
      temp = reg[r2];                 /* register */
   else if (type == M || type == N)
      temp = r2;                      /* memory or SUB r,n */

   n1 = reg[r1] & 0x0F;
   n2 = temp & 0x0F;

   if ((n1 - n2) < 0)            
      SETHALF();
   else
      RESETHALF();

   tsum = reg[r1] - temp;

   if ((tsum & BYTE_MASK_) == 0) 
      SETZERO();
   else
      RESETZERO();

   if (tsum < 0)             
      {
      SETPV();
      SETCARRY();
      RESETZERO(); 
      }
   else if ((tsum & BYTE_MASK_) > 0x7F)    
      {
      SETSIGN();     
      RESETPV();
      RESETZERO();   
      RESETCARRY();
      }

   if (reg[r1] != tsum)
      sregchanged[r1] = TRUE;
   else
      sregchanged[r1] = FALSE;
      
   reg[r1] = tsum;

   sregchanged[F] = TRUE;

   return;
}

void sbc_reg( int r1, int r2, int type )
{

   UBYTE     carry = 0;
   int       temp  = 0, tsum = 0;

   INCPC( 1 );
   SETNEG();

   if (type == RG)
      temp = reg[r2];                /* register */
   else if (type == M || type == N)
      temp = r2;                     /* memory or SBC r,n */

   n1 = reg[r1] & 0x0F;     
   n2 = temp & 0x0F;

   if ((reg[F] & CARRY) != 0)
      carry = 1;

   if ((n1 - n2 - carry) < 0)      
      SETHALF();
   else
      RESETHALF();

   tsum = reg[r1] - temp - carry;

   if ((tsum & BYTE_MASK_) == 0)    
      SETZERO();
   else
      RESETZERO();

   if (tsum < 0)
      {
      SETPV();    
      SETCARRY();  
      RESETZERO();
      }

   if ((tsum & BYTE_MASK_) > 0x7F)
      {
      SETSIGN();     
      RESETPV();
      RESETZERO();   
      RESETCARRY();
      }

   if (reg[r1] != tsum)
      sregchanged[r1] = TRUE;
   else
      sregchanged[r1] = FALSE;
      
   reg[r1] = tsum;

   sregchanged[F] = TRUE;

   return;
}

void log_reg( int r, int op, int type )
{
   int  temp = 0, result = 0;

   INCPC( 1 );

   if (type == RG)
      temp = reg[r];                 /* register */
   else if (type == M || type == N)
      temp = r;                      /* memory or OP r,n */

   if (op == AND) 
      {
      RESETCARRY();  
      RESETNEG();    
      SETHALF();
      result = reg[A] & temp;

      if (result == 0)              
         SETZERO();
      else
         RESETZERO();

      if ((result % 2) == 0)        
         SETPV();
      else
         RESETPV();

      if (result > 0x7F)
         SETSIGN();
      else
         RESETSIGN();

      if (reg[A] != result)
         sregchanged[A] = TRUE;
      else
         sregchanged[A] = FALSE;
      
      sregchanged[F] = TRUE;

      reg[A] = result;
      return;
      }
   else if (op == OR)   
      {
      RESETCARRY();  
      RESETNEG();    
      RESETHALF();
      
      result = reg[A] | temp;

      if (result == 0)
         SETZERO();
      else
         RESETZERO();

      if ((result % 2) == 0)
         SETPV();
      else
         RESETPV();

      if (result > 0x7F)
         SETSIGN();
      else
         RESETSIGN();

      if (reg[A] != result)
         sregchanged[A] = TRUE;
      else
         sregchanged[A] = FALSE;
      
      sregchanged[F] = TRUE;

      reg[A] = result;
      return;
      }
   else if (op == XOR)  
      {
      RESETCARRY();  
      RESETNEG();    
      RESETHALF();
      
      result = reg[A] ^ temp;

      if (result == 0)              
         SETZERO();
      else
         RESETZERO();

      if ((result % 2) == 0)
         SETPV();
      else
         RESETPV();

      if (result > 0x7F)
         SETSIGN();
      else
         RESETSIGN();

      if (reg[A] != result)
         sregchanged[A] = TRUE;
      else
         sregchanged[A] = FALSE;
      
      sregchanged[F] = TRUE;

      reg[A] = result;

      return;
      }
   else if (op == CP)   
      {
      SETNEG();
      n1 = reg[A] & 0x0F;  
      n2 = temp   & 0x0F;

      if ((n1 - n2) < 0)
         SETHALF();
      else
         RESETHALF();

      result = reg[A] - temp;

      if (result == 0)
         SETZERO();
      else
         RESETZERO();

      if ((result & BYTE_MASK_) > 0x7F)
         SETSIGN();
      else
         RESETSIGN();

      if ((result & BYTE_MASK_) < 0)        
         {
         SETPV();    
         SETCARRY();    
         }
      else  
         {
         RESETPV();  
         RESETCARRY();  
         }
      }

   sregchanged[F] = TRUE;

   return;
}

/* ---------------------- End of Z80Mach.c ----------------------- */
