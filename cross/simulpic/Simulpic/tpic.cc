/*
 * Copyright (c) 1996 Tommaso Cucinotta, Alessandro Evangelista, Luigi Rizzo
 * All rights reserved.
 *
 *    Dip. di Ingegneria dell'Informazione, Universita of Pisa,
 *    via Diotisalvi 2 -- 56126 Pisa.
 *    email: simulpic@iet.unipi.it
 *      
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by
 *      Tommaso Cucinotta, Alessandro Evangelista and Luigi Rizzo
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *
 * Project: SimulPIC
 * FileName: tpic.cc
 *
 *
 */

#include "tpic.h"
#include <string.h>

TPic::TPic()
{
  int i; for ( i=0; i<=4; i++)
    New_Input_State.RA[i]=OUT;
  for (i=0; i<=7; i++)
    New_Input_State.RB[i]=OUT;
  New_Input_State.MCLR=IN_1;

  Old_Input_State=New_Input_State;
  Port_Changed=1;

  Reset_POR();
  Clock_Frequency=10E6;
}


/*******************************  A L U  ********************************/
/*        N.B. I bit C,CD,Z sono modificati sempre dopo la scrittura    */
/*             dell'eventuale operando in memoria.                      */
/************************************************************************/

void TPic::ADDWF(TData_Address addr, TDestination dest)
{
   TRegister data=Read(addr);
   unsigned char NewDC = ((W & 0x0F)+(data & 0x0F) >= 0x10);
   unsigned char NewC = ((unsigned int) W + (unsigned int) data >= 0x0100);
   data+=W;
   if (dest==_W)
      W=data;
   else
      Write(addr,data);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_C, NewC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_DC, NewDC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, data==0);
}

void TPic::ANDWF(TData_Address addr, TDestination dest)
{
   TRegister ris=W & Read(addr);
   if (dest==_W)
     W=ris;
   else
     Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, ris==0);
}

void TPic::COMF(TData_Address addr, TDestination dest)
{
   TRegister ris=0xFF-Read(addr);
   if (dest==_W)
      W=ris;
   else
      Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS,STATUS_Z,ris==0);
}

void TPic::DECF(TData_Address addr, TDestination dest)
{
   TRegister ris=Read(addr)-1;
   if (dest==_W)
      W=ris;
   else
      Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS,STATUS_Z,ris==0);
}

void TPic::DECFSZ(TData_Address addr, TDestination dest)
{
   TRegister ris=Read(addr)-1;
   if (dest==_W)
      W=ris;
   else
      Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS,STATUS_Z,ris==0);
   if (ris==0) {
     IR_Valid=FALSE;
     Regs.PC++;
     }
}

void TPic::INCF(TData_Address addr, TDestination dest)
{
   TRegister ris=Read(addr)+1;
   if (dest==_W)
      W=ris;
   else
      Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, ris==0);
}

void TPic::INCFSZ(TData_Address addr, TDestination dest)
{
   TRegister ris=Read(addr)+1;
   if (dest==_W)
      W=ris;
   else
      Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, ris==0);
   if (ris==0) {
     IR_Valid=FALSE;
     Regs.PC++;
     }

}

void TPic::IORWF(TData_Address addr, TDestination dest)
{
   TRegister ris=(W | Read(addr));
   if (dest==_W)
     W=ris;
   else
     Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, ris==0);
}

void TPic::MOVF(TData_Address addr, TDestination dest)
{
   TRegister data=Read(addr);
   if (dest==_W)
      W=data;
   else
      Write(addr,data);    /*  Se addr Š una porta ! */
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, data==0);
}

void TPic::RLF(TData_Address addr, TDestination dest)
{
   unsigned int temp=(Read(addr) << 1);
   temp |= Bit_Read(Regs.STATUS, STATUS_C);
   if (dest==_W)
      W=(TRegister) temp & 0xFF;
   else
      Write(addr , (TRegister) temp & 0xFF);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_C, temp & 0x0100);
}

void TPic::RRF(TData_Address addr, TDestination dest)
{
   unsigned int temp=Read(addr);
   temp |= Bit_Read(Regs.STATUS,STATUS_C) << 8;
   if (dest==_W)
      W=(TRegister) (temp >> 1);
   else
      Write(addr , (TRegister) (temp >> 1));
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_C, temp & 0x0001);
}

void TPic::SUBWF(TData_Address addr, TDestination dest)
{
   TRegister data=Read(addr);
   unsigned char NewDC = ((data & 0x0F) | 0x10) - (W & 0x0F) >= 0x10;
   unsigned char NewC = (((unsigned int) data) | 0x0100) - ((unsigned int) W) >= 0x0100;
   data-=W;
   if (dest==_W)
      W=data;
   else
      Write(addr,data);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_C, NewC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_DC, NewDC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, data==0);
}

void TPic::SWAPF(TData_Address addr, TDestination dest)
{
   TRegister ris=Read(addr);
   ris=(ris >> 4) | (ris << 4);
   if (dest==_W)
     W=ris;
   else
     Write(addr,ris);
}

void TPic::XORWF(TData_Address addr, TDestination dest)
{
   TRegister ris=W ^ Read(addr);
   if (dest==_W)
     W=ris;
   else
     Write(addr,ris);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, ris==0);
}

void TPic::CLRF(TData_Address addr)
{
   Write(addr,0x00);
   Regs.STATUS=Bit_Set(Regs.STATUS,STATUS_Z);
}

void TPic::MOVWF(TData_Address addr)
{
   Write(addr,W);
}

void TPic::CLRW()
{
   W=0;
   Regs.STATUS=Bit_Set(Regs.STATUS, STATUS_Z);
}

void TPic::NOP()  {  }

                        /*  Bit-Oriented  */

void TPic::BCF(TData_Address addr, TBit_Address pos)
{
   Write(addr, Bit_Clear(Read(addr), pos));
}

void TPic::BSF(TData_Address addr, TBit_Address pos)
{
   Write(addr, Bit_Set(Read(addr), pos));
}

                         /**  Literal  **/

void TPic::ADDLW(TRegister literal)
{
   unsigned char NewDC = ((W & 0x0F)+(literal & 0x0F) >= 0x10);
   unsigned char NewC = (((unsigned int) W) + ((unsigned int) literal) >= 0x0100);
   W+=literal;
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_C, NewC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_DC, NewDC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, W==0);
}

void TPic::ANDLW(TRegister literal)
{
   W&=literal;
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, W==0);
}

void TPic::IORLW(TRegister literal)
{
   W|=literal;
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, W==0);
}

void TPic::MOVLW(TRegister literal)
{
   W=literal;
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, W==0);
}

void TPic::SUBLW(TRegister literal)
{
   unsigned char NewDC = (((literal & 0x0F) | 0x10) - (W & 0x0F) >= 0x10);
   unsigned char NewC = (((unsigned int) literal) | 0x0100) - ((unsigned int) W) >= 0x0100;
   W-=literal;
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_C, NewC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_DC, NewDC);
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, W==0);
}

void TPic::XORLW(TRegister literal)
{
   W^=literal;
   Regs.STATUS=Bit_Write(Regs.STATUS, STATUS_Z, W==0);
}

void TPic::CLRWDT()
{
   WDT_Timer=0;
   if (Bit_Read(Regs.OPTION, OPTION_PSA))
      Prescaler=0;
}

               /*        CONTROLLO DEL FLUSSO          */

void TPic::GOTO(TData_Address addr)
{
   Regs.PC=addr;
   IR_Valid=FALSE;
}

void TPic::CALL(TData_Address addr)
{
   Stack.Push(Regs.PC);
   GOTO(addr);
}

void TPic::RETURN()
{
   GOTO(Stack.Pop());
}

void TPic::RETLW(TRegister literal)
{
   W=literal;
   RETURN();
}

void TPic::RETFIE()
{
   Regs.INTCON=Bit_Set(Regs.INTCON,INTCON_GIE);
   RETURN();
}

void TPic::BTFSC(TData_Address addr, TBit_Address pos)
{
   if (Bit_Read(Read(addr), pos) == 0)
      {
         IR_Valid=FALSE;
         Regs.PC++;
      }
}

void TPic::BTFSS(TData_Address addr, TBit_Address pos)
{
   if (Bit_Read(Read(addr), pos) != 0)
      {
         IR_Valid=FALSE;
         Regs.PC++;
      }
}

void TPic::SLEEP()
{
   Sleep=TRUE;
   WDT_Timer=0;
   if (Bit_Read(Regs.OPTION, OPTION_PSA))
      Prescaler=0;
   Regs.STATUS = (Regs.STATUS & 0xE7) | 0x18;
}

          /*   Compatibilit… con altri modelli   */

void TPic::OPTION()
{
   Regs.OPTION=W;
   Prescaler=0;
}

void TPic::TRIS(TData_Address addr)
{
   if (addr==0x05)
     Regs.TRISA=W;
   else
     Regs.TRISB=W;
}

TRegister TPic::Bit_Set(TRegister reg, TBit_Address pos)
{
   return reg | (1 << pos);
}

TRegister TPic::Bit_Clear(TRegister reg, TBit_Address pos)
{
   return reg & (0xFF-(1 << pos));
}

TRegister TPic::Bit_Read(TRegister reg, TBit_Address pos)
{
   return ((reg & (1 << pos)) == 0) ? 0 : 1;
}

TRegister TPic::Bit_Write(TRegister reg, TBit_Address pos, TBool bit)
{
   return (bit==0) ? Bit_Clear(reg,pos) : Bit_Set(reg,pos);
}


   /*  Accesso del PIC al Register_File ed EEPROM data memory  */

TRegister TPic::Read(TData_Address addr)
{

#ifdef __DEBUG
   if ((addr & 0x80) != 0)
      printf("TPic::Read - Indirizzo Data_Address a 8bit completo !");
#endif

   TBool Page1 = Bit_Read(Regs.STATUS,STATUS_RP0);

   if (addr == 0x00)
     if( (addr = Regs.FSR) == 0x00 )
        return 0x00;
     else
     {
        Page1 = (addr & 0x80) != 0x00;
        addr &= 0x7F;
     }

   switch (addr)
   {

      case 0x01: return (Page1) ? (Regs.OPTION) : (Regs.RTCC);
      case f_PCL: return (TRegister) (Regs.PC & 0x00FF);
      case f_STATUS: return Regs.STATUS;
      case f_FSR: return Regs.FSR;
      case 0x05: if (Page1)
                    return Regs.TRISA;
                 else
                 {
                    TRegister reg=0x00;
                    for (int i=0; i<=4; i++)
                       reg=Bit_Write(reg,i,
                                     Bit_Read(Regs.TRISA,i) ?
                                     (New_Input_State.RA[i] != IN_0) :
                                     Bit_Read(Regs.PORTA,i)
                                    );
                    return reg;
                 }
      case 0x06: if (Page1)
                    return Regs.TRISB;
                 else
                 {
                    TRegister reg=0x00;
                    for (int i=0; i<=7; i++)
                       reg=Bit_Write(reg,i,
                                     Bit_Read(Regs.TRISB,i) ?
                                     (New_Input_State.RB[i] != IN_0) :
                                     Bit_Read(Regs.PORTB,i)
                                    );
                    return reg;
                 }
      case 0x07: return 0x00;
      case 0x08: return (Page1) ? (Regs.EECON1) : (Regs.EEDATA);
      case 0x09: return (Page1) ? 0x00 : (Regs.EEADR);
      case f_PCLATH: return Regs.PCLATH;
      case f_INTCON: return Regs.INTCON;

      default: return (addr<=0x2F) ? (Regs.GENERAL(addr)) : (0x00);

   }

}

void TPic::Write(TData_Address addr, TRegister data)
{

#ifdef __DEBUG
     if ((addr & 0x80) != 0)
        printf("TPic::Write - Indirizzo TData_Address a 8bit completo !");
#endif

   TBool Page1 = Bit_Read(Regs.STATUS,STATUS_RP0);

   if (addr == 0x00)
     if ( (addr = Regs.FSR) == 0x00 )
        return;
     else
     {
        Page1 = (addr & 0x80) != 0x00;
        addr &= 0x7F;
     }

   switch (addr) {
      case f_RTCC: if (Page1)
                 {
                    Old_Option=Regs.OPTION;
                    Regs.OPTION = data;
                    Prescaler=0;
                 }
                 else
                 {
                    if (Bit_Read(Regs.OPTION, OPTION_PSA) == 0)
                       Prescaler=0;
                    New_RTCC=data;
                    RTCC_State=4;
                 }
                 break;
      case f_PCL: Regs.PC = (Regs.PC & 0x1F00) | (TProgram_Address) data;
                  IR_Valid=FALSE;
                  break;
      case f_STATUS: Regs.STATUS=(data & 0xE7) | (Regs.STATUS & 0x18);
                     break;
      case f_FSR: Regs.FSR=data;
                  break;
      case f_PORTA:
                 if (Page1) {
                    if ( (data & 0x1F) != Regs.TRISA) Port_Changed=1;
                    Regs.TRISA=data & 0x1F;
                 } else {
                    if ( (data & 0x1F) != Regs.PORTA) Port_Changed=1;
                    Regs.PORTA=data & 0x1F;
                 }
                 break;
      case f_PORTB: if (Page1) {
                    if ( (data & 0x1F) != Regs.TRISA) Port_Changed=1;
                    Regs.TRISB=data;
                 } else {
                    if ( (data & 0x1F) != Regs.PORTB) Port_Changed=1;
                    Regs.PORTB=data;
                 }
                 break;
      case 0x07: break;
      case f_EEDATA: if (Page1)
                 {
                    if (Bit_Read(Regs.EECON1,EECON1_WREN) == 0)
                       data=Bit_Clear(data,EECON1_WR);
                    if (Bit_Read(data,EECON1_WR) && (EEPROM_Write_Status==-1))
                    {
                       EEPROM_Write_Data=Regs.EEDATA;
                       EEPROM_Write_Addr=Regs.EEADR;
                       EEPROM_Write_Status=(unsigned long int) (0.010*(Clock_Frequency/4.0)); /* 10ms */
                    }
                    if (Bit_Read(data,EECON1_RD))
                    {
                       Regs.EEDATA=EEPROM.Mem[Regs.EEADR & 0x7F];
                       data=Bit_Clear(data,EECON1_RD);
                    }
                    Regs.EECON1=data & 0x1F;
                 }
                 else
                    Regs.EEDATA=data;
                 break;
      case f_EEADR: if (Page1)
                   {
                     if ((data==0x55) && (EEPROM_Write_Status==0))
                        EEPROM_Write_Status=-5;
                     else if ((data==0xAA) && (EEPROM_Write_Status==-3))
                        EEPROM_Write_Status++;
                     else
                        EEPROM_Write_Status=0;
                   }
                 else
                   {
                     EEPROM_Write_Status=0;
                     Regs.EEADR=data;
                   }
                 break;
      case f_PCLATH: Regs.PCLATH=data;
                     break;
      case f_INTCON: Regs.INTCON=data;
                     break;

      default: if (addr<=0x2F)
                  Regs.GENERAL(addr)=data;
      }

}

TOp_Code TPic::Get_Op_Code(TProgram_Address addr)
{
  return Program_Memory.Read(addr);
}

                    /*    Gestione registri     */

/********************* Procedure di RESET ***********************/

void TPic::Reset_POR()
{

  Regs.TRISA=0x1F;
  Regs.TRISB=0xFF;
  Regs.OPTION=0xFF;
  Regs.STATUS=0x18;
  Regs.PC=0x00;
  Regs.PCLATH=0x00;
  Regs.INTCON=0x00;
  Regs.EECON1=0x00;

  Stack.Reset();

  EEPROM_Write_Status=0;
  IR_Valid=FALSE;
  Sleep=FALSE;
  Reset=FALSE;
  Int_State=0;
  RTCC_State=0;
  RTCC_Overflow=FALSE;
  Prescaler=0;
  WDT_Timer=0;
}

void TPic::Reset_WDT_Normal()
{

  Regs.TRISA=0x1F;
  Regs.TRISB=0xFF;
  Regs.OPTION=0xFF;
  Regs.EECON1=0x00;
  Regs.STATUS=(Regs.STATUS & 0x07) | 0x08;
  Regs.PC=0x00;
  Regs.PCLATH=0x00;
  Regs.INTCON=Regs.INTCON & 0x01;
  Regs.EECON1=0x00;

  Stack.Reset();

  if (EEPROM_Write_Status>0)
     Regs.EECON1=Bit_Set(Regs.EECON1, EECON1_WRERR);

  EEPROM_Write_Status=0;
  Int_State=0;
  RTCC_State=0;
  RTCC_Overflow=FALSE;
  Prescaler=0;
  IR_Valid = FALSE;
}

void TPic::Reset_WDT_Sleep()
{
   Regs.STATUS=Regs.STATUS & 0xE7;
   Sleep=FALSE;
}

void TPic::Reset_MCLR_Normal()
{
  Regs.TRISA=0x1F;
  Regs.TRISB=0xFF;
  Regs.OPTION=0xFF;
  Regs.EECON1=0x00;
  Regs.STATUS=Regs.STATUS & 0x1F;
  Regs.PC=0x00;
  Regs.PCLATH=0x00;
  Regs.INTCON=Regs.INTCON & 0x01;
  Regs.EECON1=0x00;

  Stack.Reset();

  if (EEPROM_Write_Status>0)
     Regs.EECON1=Bit_Set(Regs.EECON1, EECON1_WRERR);

  Reset = TRUE;
  Int_State=0;
  EEPROM_Write_Status=0;
  RTCC_State=0;
  RTCC_Overflow=FALSE;
  Prescaler=0;
  IR_Valid = FALSE;
  WDT_Timer = 0;
}

void TPic::Reset_MCLR_Sleep()
{

  Regs.TRISA=0x1F;
  Regs.TRISB=0xFF;
  Regs.OPTION=0xFF;
  Regs.EECON1=0x00;
  Regs.STATUS=(Regs.STATUS & 0x07) | 0x10;
  Regs.PC=0x00;
  Regs.PCLATH=0x00;
  Regs.INTCON=0x00;
  Regs.EECON1=0x00;

  if (EEPROM_Write_Status>0)
     Regs.EECON1=Bit_Set(Regs.EECON1, EECON1_WRERR);

  EEPROM_Write_Status=0;
  Stack.Reset();

  Reset = TRUE;
  Int_State=0;
  RTCC_State=0;
  RTCC_Overflow=FALSE;
  Prescaler=0;
  IR_Valid = FALSE;
  Sleep=FALSE;
  WDT_Timer = 0;
}

void TPic::Reset_Int_Wake_Up()
{
  Regs.STATUS= ((Regs.STATUS) & 0xE7) | 0x10;
  Sleep=FALSE;
}

                 /**  Supporto per la simulazione  **/

TBool TPic::Set_Input_State(TInput_State Inputs)
{
   TBit_Address pos;
   for (pos=0; pos<=4; pos++)
      if ((Bit_Read(Regs.TRISA, pos)==0) && (Inputs.RA[pos]!=OUT))
         return FALSE;
   for (pos=0; pos<=7; pos++)
      if ((Bit_Read(Regs.TRISB, pos)==0) && (Inputs.RB[pos]!=OUT))
         return FALSE;

#if 0   /* XXX chech this */
   if ( !(Old_Input_State == New_Input_State))
        Port_Changed=1;
#endif
   Old_Input_State=New_Input_State;
   New_Input_State=Inputs;

   return TRUE;
}

TBool TPic::RTCC_Event()
{
   if (RTCC_Overflow)
   {
      RTCC_Overflow=FALSE;
      return TRUE;
   }
   return FALSE;
}

TBool TPic::RB_Change_Event()
{
  int i;
  for (i=4; i<=7; i++)
    if ( ((New_Input_State.RB[i] != IN_0) && (Old_Input_State.RB[i] == IN_0))
      || ((New_Input_State.RB[i] == IN_0) && (Old_Input_State.RB[i] != IN_0)) )
      return TRUE;
  return FALSE;

}

#define RISING_INT ((Old_Input_State.RB[0] == IN_0) && (New_Input_State.RB[0] != IN_0))
#define FALLING_INT ((Old_Input_State.RB[0] != IN_0) && (New_Input_State.RB[0] == IN_0))

TBool TPic::INT_Event()
{
  if ( (RISING_INT && Bit_Read(Regs.OPTION, OPTION_INTEDG))
    || (FALLING_INT && !Bit_Read(Regs.OPTION, OPTION_INTEDG)) )
     return TRUE;
  else
     return FALSE;
}

#define PSA Bit_Read(Regs.OPTION, OPTION_PSA)

TBool TPic::Inc_Prescaler()   /*  TRUE=Overflow  */
{
   Prescaler++;
   unsigned int ps_value = Old_Option & (OPT_MASK_PS2 | OPT_MASK_PS1 | OPT_MASK_PS0);
   if ( (Prescaler >> (ps_value + ((PSA)?(0):(1)) ) ) & 0x01 )
   {
      Prescaler = 0;
      return TRUE;
   }
   return FALSE;
}

#define RT_CNT_MODE Bit_Read(Old_Option, OPTION_RTS)
#define RT_CLK_MODE !Bit_Read(Old_Option, OPTION_RTS)
#define OLD_RT (Old_Input_State.RA[4] != IN_0)
#define NEW_RT (New_Input_State.RA[4] != IN_0)
#define RISING_RT (!OLD_RT && NEW_RT)
#define FALLING_RT (OLD_RT && !NEW_RT)
#define RTE Bit_Read(Regs.OPTION, OPTION_RTE)

void TPic::Update_RTCC()
{
  /* l'incremento avviene se:

     + RTCC in modalita' clock (RTS=0)
     + RTCC in modalita' counter (RTS=1) con:
         + fronte di salita (RTE=0)
         + fronte di discesa (RTE=1)

  */

  if ( RT_CLK_MODE || (FALLING_RT && RTE) || (RISING_RT && (RTE == 0)) )
  {
     /* PSA: 0-RTCC, 1-WDT */
     if ( (Bit_Read(Old_Option, OPTION_PSA)==1) || (Inc_Prescaler()) )
     {
        Regs.RTCC++;
        if (Regs.RTCC == 0 )
            RTCC_Overflow = TRUE;
     }
  }

}

#define GIE Bit_Read(Regs.INTCON, INTCON_GIE)
#define RTIF Bit_Read(Regs.INTCON, INTCON_RTIF)
#define RTIE Bit_Read(Regs.INTCON, INTCON_RTIE)
#define RBIF Bit_Read(Regs.INTCON, INTCON_RBIF)
#define RBIE Bit_Read(Regs.INTCON, INTCON_RBIE)
#define INTF Bit_Read(Regs.INTCON, INTCON_INTF)
#define INTE Bit_Read(Regs.INTCON, INTCON_INTE)
#define EEIE Bit_Read(Regs.INTCON, INTCON_EEIE)
#define EEIF Bit_Read(Regs.EECON1, EECON1_EEIF)

void TPic::Check_Interrupt()
{
  if (GIE && ((RTIF && RTIE) || (INTF && INTE) || (RBIF && RBIE) || (EEIF && EEIE) ))
  {
    Int_State = 3;
    IR_Valid=FALSE;
  }
}

TBool TPic::Update_WDT()
{
   /* PSA: 0-RTCC, 1-WDT */
   if ((Bit_Read(Regs.OPTION, OPTION_PSA)==0) || Inc_Prescaler())
   {
      WDT_Timer++;
      if (WDT_Timer == (unsigned long int) (0.018*(Clock_Frequency/4)))
      {
         WDT_Timer=0;
         return TRUE;
      }
   }
   return FALSE;
}

void TPic::Clock()
{

   if (New_Input_State.MCLR == IN_0)
   {
     if (Sleep)
       Reset_MCLR_Sleep();
     else
       Reset_MCLR_Normal();
   }
   else
   {
      Reset=FALSE;

      if (WDT_Fuse && Update_WDT())
         if (Sleep)
            Reset_WDT_Sleep();
         else
            Reset_WDT_Normal();

      if (Sleep && (INT_Event() || RB_Change_Event() || (EEPROM_Write_Status==1)))
         Reset_Int_Wake_Up();

      if (!Sleep)    /*  Soltanto in questo caso il clock e' attivo!  */
      {
         switch(Int_State)
         {
            case 0:
               {
               Old_Option = Regs.OPTION;

               /* Old_Option conserva il valore di OPTION della frazione
                  Q1 di clock (fase di lettura) */

               TOp_Code New_IR = Program_Memory.Read(Regs.PC); /* Fetch */

               if (IR_Valid)
                  Execute();  /* Modifica: IR_Valid, Sleep, WDT_Timer, PC, ... */
               else
                  IR_Valid=TRUE;
               IR = New_IR;

               Check_Interrupt();

               if (IR_Valid)
                  Regs.PC++;
               }
               break;
            case 1:
               {
               IR = Program_Memory.Read(Regs.PC);   /* Fetch */
               Regs.PC++;
               IR_Valid=TRUE;
               Int_State--;
               }
               break;
            case 2:
               {
               Stack.Push(Regs.PC);
               Regs.PC=0x04;
               Int_State--;
               }
               break;
            case 3:
               {
               Regs.INTCON=Bit_Clear(Regs.INTCON, INTCON_GIE);
               Int_State--;
               }
               break;
         }

         switch(RTCC_State)
         {
            case 4:
               Update_RTCC();
               RTCC_State--;
               break;
            case 3:
               Regs.RTCC=New_RTCC;
               RTCC_State--;
               break;
            case 2:
            case 1:
               RTCC_State--;
               break;
            case 0:
               Update_RTCC();
               break;
         }

         if (RB_Change_Event())
            Regs.INTCON=Bit_Set(Regs.INTCON, INTCON_RBIF);
         if (INT_Event())
            Regs.INTCON=Bit_Set(Regs.INTCON, INTCON_INTF);
         if (RTCC_Event())
            Regs.INTCON=Bit_Set(Regs.INTCON, INTCON_RTIF);

      }

            /*  Ciclo di scrittura su EEPROM_Data_Memory  */
      if (EEPROM_Write_Status<0)
         EEPROM_Write_Status++;
      else if (EEPROM_Write_Status>0)
              if (--EEPROM_Write_Status==0)
              {
                   EEPROM.Mem[EEPROM_Write_Addr]=EEPROM_Write_Data;
                   Regs.EECON1=Bit_Set(Regs.EECON1, EECON1_EEIF);
              }

   } /*  if MCLR==0  */
   Old_Input_State=New_Input_State;
}

inline TRegister TPic::Get_Literal(TOp_Code opcode)
{
   return opcode & 0x00FF;
}

inline TData_Address TPic::Get_Data_Address(TOp_Code opcode)
{
   return opcode & 0x007F;
}

inline TProgram_Address TPic::Get_Program_Address(TOp_Code opcode)
{
   return opcode & 0x07FF;
}

inline TBit_Address TPic::Get_Bit_Address(TOp_Code opcode)
{
   return (opcode & 0x0380) >> 7;
}

inline TDestination TPic::Get_Destination(TOp_Code opcode)
{
   return (((opcode & 0x0080) >> 7) == 1) ?  (_f) : (_W);
}


TBool TPic::Execute()
{

   TData_Address data_address;
   TProgram_Address program_address;
   TDestination destination;
   TBit_Address bit_address;

   switch (IR >> 12)
   {
      case 0x00:
         if ((IR & 0x3F80) == 0)
            switch(IR)
            {
               case 0x00: case 0x20: case 0x40: case 0x60:
                  return TRUE;
               case 0x08:
                  RETURN();
                  return TRUE;
               case 0x09:
                  RETFIE();
                  return TRUE;
               case 0x62:
                  OPTION();
                  return TRUE;
               case 0x63:
                  SLEEP();
                  return TRUE;
               case 0x64:
                  CLRWDT();
                  return TRUE;
               case 0x65: case 0x66:
                  TRIS((TData_Address) (IR & 0x0007));
               default:
                  return FALSE;
            }
         if ((IR & 0x3F80) == 0x0100) {
            CLRW();
            return TRUE;
            }
         else
         {
            data_address = Get_Data_Address(IR);
            destination = Get_Destination(IR);
            switch ((IR >> 8) & 0x0F)
            {
               case 0x00:
                  MOVWF(data_address);
                  return TRUE;
               case 0x01:
                  CLRF(data_address);
                  return TRUE;
               case 0x02:
                  SUBWF(data_address,destination);
                  return TRUE;
               case 0x03:
                  DECF(data_address,destination);
                  return TRUE;
               case 0x04:
                  IORWF(data_address,destination);
                  return TRUE;
               case 0x05:
                  ANDWF(data_address,destination);
                  return TRUE;
               case 0x06:
                  XORWF(data_address,destination);
                  return TRUE;
               case 0x07:
                  ADDWF(data_address,destination);
                  return TRUE;
               case 0x08:
                  MOVF(data_address,destination);
                  return TRUE;
               case 0x09:
                  COMF(data_address,destination);
                  return TRUE;
               case 0x0A:
                  INCF(data_address,destination);
                  return TRUE;
               case 0x0B:
                  DECFSZ(data_address,destination);
                  return TRUE;
               case 0x0C:
                  RRF(data_address,destination);
                  return TRUE;
               case 0x0D:
                  RLF(data_address,destination);
                  return TRUE;
               case 0x0E:
                  SWAPF(data_address,destination);
                  return TRUE;
               case 0x0F:
                  INCFSZ(data_address,destination);
                  return TRUE;
            }  /* case */
         }  /* else */
      case 0x01:
         data_address = Get_Data_Address(IR);
         bit_address = Get_Bit_Address(IR);
         switch((IR >> 10) & 0x03)
         {
            case 0x00:
               BCF(data_address,bit_address);
               return TRUE;
            case 0x01:
               BSF(data_address,bit_address);
               return TRUE;
            case 0x02:
               BTFSC(data_address,bit_address);
               return TRUE;
            case 0x03:
               BTFSS(data_address,bit_address);
               return TRUE;
         }

      case 0x02:
         program_address = Get_Program_Address(IR);
         if ((IR & 0x800) == 0)
            CALL(program_address) ;
         else
            GOTO(program_address);
         return TRUE;

      case 0x03:
         TRegister data = Get_Literal(IR);
         switch((IR >> 8) & 0x0F)
         {
            case 0x00:
            case 0x01:
            case 0x02:
            case 0x03:
               MOVLW(data);
               return TRUE;
            case 0x04:
            case 0x05:
            case 0x06:
            case 0x07:
               RETLW(data);
               return TRUE;
            case 0x08:
               IORLW(data);
               return TRUE;
            case 0x09:
               ANDLW(data);
               return TRUE;
            case 0x0A:
               XORLW(data);
               return TRUE;
            case 0x0B:
               return FALSE;
            case 0x0C:
            case 0x0D:
               SUBLW(data);
               return TRUE;
            case 0x0E:
            case 0x0F:
               ADDLW(data);
               return TRUE;
         }
   }

   return FALSE;

}

void TPic::Load_Program(TOp_Code* pnt)
{
   int i;
   for ( i=0; i< PROGMEM_SIZE; i++)
       Program_Memory.Write(i,pnt[i]);
   for ( i=0; i< EEPROM_SIZE; i++)
       EEPROM.Mem[i]= pnt[i + EEPROM_BASE];
}


TString TPic::Get_Mnemonic(TProgram_Address addr)
{
   static char s[64]; /* the opcode */
   static TString Mn_00[] = {
      "movwf", "clrf",  "subwf", "decf",
      "iorwf", "andwf", "xorwf", "addwf",
      "movf",  "comf",  "incf",  "decfsz",
      "rrf",   "rlf",   "swapf", "incfsz"
      };

   static TString Mn_01[] = {
      "bcf", "bsf", "btfsc", "btfss"
   };

   static TString Mn_11[] = {
      "movlw", "movlw", "movlw", "movlw",
      "retlw", "retlw", "retlw", "retlw",
      "iorlw", "andlw", "xorlw", "???",
      "sublw", "sublw", "addlw", "addlw"
      };

static TString regname[] = {
    "INDIR", "TMR0/RTCC/OPTION", "PC/PCL", "STATUS",
    "FSR", "PORTA/TRISA", "PORTB/TRISB", "--",
    "EEDATA/EECON1", "EEADR/EECON2", "PCLATH", "INTCON" };

   TOp_Code opcode = Program_Memory.Read(addr);

   /* controllare MOVWF */

   switch(opcode >> 12) {
      case 0x00:
         if((opcode & 0x3F80) == 0)
            switch(opcode) {
               case 0x00: case 0x20: case 0x40: case 0x60:
                  return "nop";
               case 0x08:
                  return "return";
               case 0x09:
                  return "retfie";
               case 0x62:
                  return "option";
               case 0x63:
                  return "sleep";
               case 0x64:
                  return "clrwdt";
               case 0x65:
                  return "tris 5"; /* aggiungere porte */
               case 0x66:
                  return "tris 6";
               default:
                  return "???";
               }
         if((opcode & 0x3F80) == 0x100)
            return "clrw";
         else {
            sprintf(s,"%s 0x%02x",
                Mn_00[(opcode >> 8) & 0x0F],
                Get_Data_Address(opcode)
            );
            if ((opcode & 0x3E00) != 0)          /* ==0 per CLRF && MOVWF */
               strcat(s, (Get_Destination(opcode)== _f) ? ",f" : ",w");
            if (Get_Data_Address(opcode) <= f_INTCON)
                sprintf(s+strlen(s)," (%s)",
                    regname[Get_Data_Address(opcode) & 0xff]);
             else
                sprintf(s+strlen(s)," (= 0x%02x)",
                        Regs.GENERAL(Get_Data_Address(opcode)) );
            return s;
         }

      case 0x01:
         sprintf(s, "%s 0x%02x,%d",
                Mn_01[(opcode >> 10) & 0x03],
                Get_Data_Address(opcode) & 0xff,
                Get_Bit_Address(opcode));
         if (Get_Data_Address(opcode) <= f_INTCON)
                sprintf(s+strlen(s)," (%s)",
                    regname[Get_Data_Address(opcode) & 0xff]);
         else
                sprintf(s+strlen(s)," (= 0x%02x)",
                        Regs.GENERAL(Get_Data_Address(opcode)) );
         return s;
      case 0x02:
         if ((opcode & 0x800) == 0) {
            sprintf(s,"call 0x%03x", Get_Program_Address(opcode) & 0xfff);
            return s;
            }
         else {
            sprintf(s,"goto 0x%03x", Get_Program_Address(opcode) & 0xfff);
            return s;
            }
      case 0x03:
         sprintf(s, "%s 0x%02x",
                Mn_11[(opcode >> 8) & 0x0F],
         Get_Literal(opcode) & 0xff);
         return s;
      }

   return "???";
}
