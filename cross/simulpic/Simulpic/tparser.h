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

#ifndef _TPARSER
#define _TPARSER

#include "pictype.h"
#include "tpic.h"
#include "tfile.h"
#include "tiofile.h"

#include <stdio.h>

class TInputs_File:public TIO_File
  {
     public:
     double Next_Time;
     TInput_State Next_Inputs;
  };

class TGraphic_File:public TIO_File
  {
     public:
     long Period, Count;
  };

class TParser {
   private:
      TPic Pic;
      TFile Source;

      TInputs_File Inputs;   /* Pin-Input-File */
      TIO_File Report;
      TGraphic_File Graphic;

      TProgram_Address BP_Address;

      char input[256];
      char token[80];

      void Graphic_Out();
      void Report_In();
      void Report_Out();
      void Report_Tris();
      void Inputs_Get();

      void Help();
      void LoadFile();
      void Dump_Register();
      void Dump_General();
      void Dump_EEPROM();
      void Dump_Program();
      void Dump_IO_Pins();
      void Disasm();
      void Step();
      void DoSteps(long);
      void Go_Time();
      void Input_A();
      void Input_B();
      void Input_MCLR();
      void Open_Report();
      void Close_Report();
      void Open_Graphic();
      void Close_Graphic();
      void Time_Graphic();
      void Open_Inputs();
      void Close_Inputs();
      void Reset_POR();
      void Set_Breakpoint();
      void Dump_Stack();
      void Set_Frequency();

      double TIME;

   public:
      TParser();
      TBool Parse();
   };

#endif
