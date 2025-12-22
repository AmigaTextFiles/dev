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
 *	Tommaso Cucinotta, Alessandro Evangelista and Luigi Rizzo
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

#ifndef _TPIC
#define _TPIC

#include "pictype.h"
#include "tstack.h"
#include "tprogmem.h"
#include "tregfile.h"

class TPic {
  private:

    int EEPROM_Write_Status;
        /*  <0:Verifica se il ciclo di scrittura inizia correttamente.
            >0:Ciclo di scrittura su EEPROM_Data  */
    TRegister EEPROM_Write_Data;
    TEEPROM_Address EEPROM_Write_Addr;

    TOp_Code IR;        /*   Instruction Register   */

    unsigned char Int_State;

    unsigned char RTCC_State;
    TRegister New_RTCC;
    TBool RTCC_Overflow;
    TRegister Old_Option;
    unsigned int Prescaler;
    unsigned long int WDT_Timer;

    TInput_State Old_Input_State;

    TRegister Get_Literal(TOp_Code);
    TData_Address Get_Data_Address(TOp_Code);
    TProgram_Address Get_Program_Address(TOp_Code);
    TBit_Address Get_Bit_Address(TOp_Code);
    TDestination Get_Destination(TOp_Code);

    void Reset_WDT_Normal(void);  // WDT time-out reset during normal operation
    void Reset_WDT_Sleep(void);   // WDT time-out reset during sleep
    void Reset_MCLR_Normal(void); // MCLR reset during normal operation
    void Reset_MCLR_Sleep(void);  // MCLR reset during sleep
    void Reset_Int_Wake_Up(void); // Wake-up through Interrupt

    TBool Execute();
    void Fetch();
    void Check_Interrupt();
    TBool Inc_Prescaler();

    TRegister Read(TData_Address);
    void Write(TData_Address, TRegister);

    TRegister Bit_Set(TRegister reg, TBit_Address pos);
    TRegister Bit_Clear(TRegister reg, TBit_Address pos);
    TRegister Bit_Read(TRegister reg, TBit_Address pos);
    TRegister Bit_Write(TRegister reg, TBit_Address pos, TBool bit);

    TBool TPic::RB_Change_Event();
    TBool TPic::INT_Event();
    TBool TPic::RTCC_Event();
    void TPic::Update_RTCC();
    TBool TPic::Update_WDT();

          /****   PIC16C84 - Instruction Set  ****/

    void ADDWF(TData_Address, TDestination);
    void ANDWF(TData_Address, TDestination);
    void COMF(TData_Address, TDestination);
    void DECF(TData_Address, TDestination);
    void DECFSZ(TData_Address, TDestination);
    void INCF(TData_Address, TDestination);
    void INCFSZ(TData_Address, TDestination);
    void IORWF(TData_Address, TDestination);
    void MOVF(TData_Address, TDestination);
    void RLF(TData_Address, TDestination);
    void RRF(TData_Address, TDestination);
    void SUBWF(TData_Address, TDestination);
    void SWAPF(TData_Address, TDestination);
    void XORWF(TData_Address, TDestination);
    void CLRF(TData_Address);
    void MOVWF(TData_Address);
    void CLRW(void);
    void NOP(void);

                      /* Bit-Oriented */

    void BCF(TData_Address, TBit_Address);
    void BSF(TData_Address, TBit_Address);

                        /* Literal */

    void ADDLW(TRegister);
    void ANDLW(TRegister);
    void IORLW(TRegister);
    void MOVLW(TRegister);
    void SUBLW(TRegister);
    void XORLW(TRegister);
    void CLRWDT(void);

    void OPTION(void);
    void TRIS(TData_Address);

    void SLEEP(void);
    void GOTO(TRegister);
    void CALL(TRegister);
    void RETURN(void);
    void RETLW(TRegister);
    void RETFIE(void);
    void BTFSC(TData_Address, TBit_Address);
    void BTFSS(TData_Address, TBit_Address);


  public:

    TPic();

    void Load_Program(TOp_Code*);
    void Clock();
    TBool Set_Input_State(TInput_State);

    void Reset_POR(void);         // Power-On Reset

    TString Get_Mnemonic(TProgram_Address);
    TOp_Code Get_Op_Code(TProgram_Address);

    int Port_Changed;	/* set if IO ports have changed */
    double last_t;	/* last time printed statistics */

    TStack Stack;
    TBool WDT_Fuse;

    TRegister_File Regs;
    TProgram_Memory Program_Memory;
    TEEPROM_Data EEPROM; /* aggiungere funzioni di R/W */
    TRegister W;
    TBool IR_Valid;
    TBool Sleep;
    TBool Reset;
    TInput_State New_Input_State;
    double Clock_Frequency;

  };

#endif
