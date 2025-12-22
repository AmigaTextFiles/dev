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

/*
 *
 * Project: SimulPIC
 * FileName: tprogmem.cc
 *
 */



#include "tprogmem.h"

unsigned int TProgram_Memory::Index(TProgram_Address Address)
{
  return(Address & (PROGMEM_SIZE -1) ); // Address & 0000.0011.1111.1111
};

TOp_Code TProgram_Memory::Read(TProgram_Address addr)
{
   return Memory[Index(addr)];
}

void TProgram_Memory::Write(TProgram_Address addr, TOp_Code opc)
{
   Memory[Index(addr)]=opc;
}

TDestination TProgram_Memory::Get_Destination(TProgram_Address addr)
{
   return ((Read(addr) & 0x0080)==0x0080) ? (_f) : (_W);
}

TData_Address TProgram_Memory::Get_Data_Address(TProgram_Address addr)
{
   return Read(addr) & 0x007F;
}

TBit_Address TProgram_Memory::Get_Bit_Address(TProgram_Address addr)
{
   return (Read(addr) >> 7) & 0x0003;
}

TRegister TProgram_Memory::Get_Literal(TProgram_Address addr)
{
   return Read(addr) & 0x00FF;
}

TProgram_Address TProgram_Memory::Get_Literal_Address(TProgram_Address addr)
{
   return Read(addr) & 0x07FF;
}
