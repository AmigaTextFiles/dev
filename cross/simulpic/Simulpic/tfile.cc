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
 * tfile.cc
 */

#include "tfile.h"
#include <stdio.h>
#include <string.h>

TByte TFile::Ascii_To_Num(char c)
{

  if(c >= '0' && c <= '9') return ((TByte) c - '0');
  if(c >= 'A' && c <= 'F') return ((TByte) c - ('A' - 10));
  if(c >= 'a' && c <= 'f') return ((TByte) c - ('a' - 10));

  return(0xFF);
}


TByte TFile::Hex_Byte(char* s)
{
  return  (Ascii_To_Num(s[0]) << 4) | Ascii_To_Num(s[1]);
}

TWord TFile::Hex_Word(char* s)
{
  return (Hex_Byte(s) << 8) + Hex_Byte(s + 2);
}


/* Chiudere il file ... */

TError TFile::Load_File(TString filename, TWord* external_buffer, TBool& WDT_Fuse)
{
   FILE* file_pointer;
   char file_buffer[256];
   char* fb = NULL;
   TByte cnt, check;
   TWord pc;
   TByte Hi, Low;

   for (int i=0; i < ALLMEM_SIZE; i++) external_buffer[i]=0;
   if ((file_pointer = fopen(filename, "rb")) == NULL)
      return CANNOT_OPEN_FILE;

   do {
      do {

         if(fgets(file_buffer, sizeof(file_buffer)-1, file_pointer) == NULL) {
            fclose(file_pointer);
            return UNEXPECTED_EOF;
            }
         if(file_buffer[0] != ':')
            continue;

         if (strlen(file_buffer) < 10) {
            fclose(file_pointer);
            return UNEXPECTED_EOLN;
         }

         Low = Hex_Byte(&file_buffer[7]);

      } while( Low!=0 && Low!=1);

      if(Low==1) {
         fclose(file_pointer);
         return NO_ERROR; /* End of object file */
      }

      cnt = Hex_Byte(&file_buffer[1]);
      pc = Hex_Word(&file_buffer[3]);
      if((cnt & 1) != 0 || (pc & 1) != 0) {
         fclose(file_pointer);
         return ODD_LEN_ADDR;
      }

      check = cnt + (TByte) (pc >> 8) + (TByte) (pc & 0xFF);

      cnt >>=1;
      pc >>=1;

      fb = &file_buffer[9];

      do {
         Low = Hex_Byte(fb);
         check += Low;
         fb += 2;

         Hi = Hex_Byte(fb);
         check += Hi;
         fb += 2;

         if(--cnt == 0)
         {
            if(((0x100 - (check & 0xff)) & 0xff) != Hex_Byte(fb))
            {
               fclose(file_pointer);
               return CHECKSUM;
            }
            fb = NULL;
         }

         if (pc==0x2007)
            WDT_Fuse=((Low >> 2) & 0x01);
         else if (pc < ALLMEM_SIZE)
            external_buffer[pc] = Low | ((Hi & 0x3F) << 8);
	 else
	    printf("--- Warning: mem[0x%04x]= %04x\n", pc, Low | ((Hi & 0x3F) << 8) );
         pc++;

         } while(fb != NULL);

      } while(TRUE);
};
