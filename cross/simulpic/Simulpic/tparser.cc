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
 * FileName: tparser.cc
 *
 *
 */

#include <stdio.h>
#include <string.h>

#include "tparser.h"

TParser::TParser()
{
   strcpy(Report.File_Name,"Report.txt");
   strcpy(Graphic.File_Name,"Graphic.txt");
   Graphic.Period = -1;
   Pic.last_t=0.0;
   strcpy(Inputs.File_Name,"Noname1.inp");
   Inputs.Next_Time=0;

   BP_Address = 0xFFFF;

   for (int i=0; i<=4; i++)
     Inputs.Next_Inputs.RA[i]=OUT;
   for (i=0; i<=7; i++)
     Inputs.Next_Inputs.RB[i]=OUT;
   Inputs.Next_Inputs.MCLR=IN_1;

   TIME=0.0;
}

void TParser::Report_In()
{
   int i;

   if (!Report.Opened()) return;
   fprintf(Report.File(),"<");
   for (i=4; i>=0; i--) {
         if (Pic.Regs.TRISA & (1 << i))
            switch(Pic.New_Input_State.RA[i]) {
               case IN_0:fprintf(Report.File(),"0");
                         break;
               case IN_1:fprintf(Report.File(),"1");
                         break;
               case OUT:fprintf(Report.File(),"-");
            }
         else
            fprintf(Report.File(),".");
   }
   fprintf(Report.File()," ");
   for (i=7; i>=0; i--) {
         if (Pic.Regs.TRISB & (1 << i))
            switch(Pic.New_Input_State.RB[i]) {
               case IN_0:fprintf(Report.File(),"0");
                         break;
               case IN_1:fprintf(Report.File(),"1");
                         break;
               case OUT:fprintf(Report.File(),"-");
            }
         else
            fprintf(Report.File(),".");
   }
   fprintf(Report.File(),"   %6.4lf\n",TIME);
}

void TParser::Report_Out()
{
   if (!Report.Opened()) return;
   fprintf(Report.File(),">");
   for (int i=4; i>=0; i--) {
         if (Pic.Regs.TRISA & (1 << i))
            fprintf(Report.File(),".");
         else
            fprintf(Report.File(),(Pic.Regs.PORTA & (1 << i)) ? "1" : "0" );
   }
   fprintf(Report.File()," ");
   for (i=7; i>=0; i--) {
         if (Pic.Regs.TRISB & (1 << i))
            fprintf(Report.File(),".");
         else
            fprintf(Report.File(),(Pic.Regs.PORTB & (1 << i)) ? "1" : "0" );
   }
   fprintf(Report.File(),"   %6.4lf\n",TIME);
}


void TParser::Graphic_Out()
{
   char buf[128];
   char *s, *p=buf;
   int i;

   if (!(Graphic.Opened())) return;
   for (i=4; i>=0; i--) {
         if (Pic.Regs.TRISA & (1 << i))
            s=" x  ";
         else
            s=(Pic.Regs.PORTA & (1 << i)) ? "  ] " : "[   " ;
         strcpy(p,s);
         p += 4;
      }
   strcpy(p,"  ");
   p += 2;
   for (i=7; i>=0; i--) {
         if (Pic.Regs.TRISB & (1 << i))
            s=" x  ";
         else
            s=(Pic.Regs.PORTB & (1 << i)) ? "  ] " : "[   ";
         strcpy(p,s);
         p += 4;
   }
   fprintf(Graphic.File(),"%s  %6.4lf %6.4lf\n",buf,TIME, TIME-Pic.last_t);
   fflush(Graphic.File());
   Pic.last_t=TIME;
}

void TParser::Report_Tris()
{
   int i;

   if (!Report.Opened()) return;
   fprintf(Report.File(),"T");
   for (i=4; i>=0; i--)
      fprintf(Report.File(),(Pic.Regs.TRISA & (1 << i)) ? "i" : "o" );
   fprintf(Report.File()," ");
   for (i=7; i>=0; i--)
      fprintf(Report.File(),(Pic.Regs.TRISB & (1 << i)) ? "i" : "o" );
   fprintf(Report.File(),"   %6.4lf\n",TIME);
}

void TParser::Dump_IO_Pins()
{
   char c;

   printf("\nRA:");
   for (int i=4; i>=0; i--) {
     switch(Pic.New_Input_State.RA[i])
     {
       case IN_0:putchar('0');
                 break;
       case IN_1:putchar('0');
                 break;
       case OUT:putchar('-');
     }
   }
   printf("   RB:");
   for (i=7; i>=0; i--)
     switch(Pic.New_Input_State.RB[i])
     {
       case IN_0:putchar('0');
                 break;
       case IN_1:putchar('1');
                 break;
       case OUT:putchar('-');
     }
   printf("   MCLR:%1d\n\n",(Pic.New_Input_State.MCLR==IN_0) ? (0) : (1));
}


void TParser::Dump_Register()
{
   printf("\nWDTE:%s    PC=%04X      ",
        (Pic.WDT_Fuse ? "On " : "Off"), Pic.Regs.PC);
   if (Pic.Reset)
      printf("RESET");
   else if (Pic.Sleep)
      printf("SLEEP");
   else {
      printf("Executing: ");
      if (Pic.IR_Valid)
          printf("%04X:%04X  %s", Pic.Regs.PC-1,
                 Pic.Program_Memory.Read(Pic.Regs.PC-1),
                 Pic.Get_Mnemonic(Pic.Regs.PC-1));
      else
         printf("<none>");
   }

   printf("\nSTATUS %02X   W   %02X   ", Pic.Regs.STATUS, Pic.W);
   printf("PCLATH %02X   INTCON %02X   ", Pic.Regs.PCLATH, Pic.Regs.INTCON);
   printf("EEADR  %02X   PORTA %02X   ", Pic.Regs.EEADR, Pic.Regs.PORTA);
   printf("PORTB %02X\n", Pic.Regs.PORTB);
   printf("OPTION %02X   FSR %02X   ", Pic.Regs.OPTION, Pic.Regs.FSR);
   printf("RTCC   %02X   EECON1 %02X   ", Pic.Regs.RTCC, Pic.Regs.EECON1);
   printf("EEDATA %02X   TRISA %02X   ", Pic.Regs.EEDATA, Pic.Regs.TRISA);
   printf("TRISB %02X\n\n", Pic.Regs.TRISB);
}

void TParser::Help()
{
   printf(
   "l  <filename>    read program memory from IHX8M-format file\n"
   "dr               view registers\n"
   "dg               view general registers\n"
   "dee              view EEPROM Data Memory\n"
   "dpm              view Program Memory\n"
   "dp               view IO pins state\n"
   "ds               view stack\n"
   "d  [<address>]   disassemble from <address> (or PC)\n"
   "s  [<number>]    execute <number> steps\n"
   "g  <time>        execute until <time>\n"
   "bp [<address>]   set/clear breakpoint\n"
   "pa ppppp         set RA io_port state (p = 0,1,-,u)\n"
   "pb pppppppp      set RB io_port state (p = 0,1,-,u)\n"
   "pm p             set MCLR state (p = 0,1)\n"
   "io [<filename>]  Open inputs file\n"
   "ic               Close inputs file\n"
   "ro [<filename>]  Open Report File\n"
   "rc               Close Report File\n"
   "eo [<filename>]  Open Graphic File\n"
   "ec               Close Graphic File\n"
   "st               Set sampling frequency (# instr.) for Graphic File\n"
   "f                Set clock frequency\n"
   "por              Power-On Reset\n"
   "q                quit\n\n"
   );
}

void TParser::LoadFile()
{
   char FileName[80];
   if (sscanf(input, "%s %s", token, FileName)==2) {
         TWord file_buffer[ALLMEM_SIZE];
         if (Source.Load_File(FileName,file_buffer,Pic.WDT_Fuse) == NO_ERROR) {
               Pic.Load_Program(file_buffer);
               printf("\nFile <%s> loaded\n\n", FileName);
               Pic.Reset_POR();
               TIME=0.0;
         }
         else
            printf("\nError opening <%s> \n\n", FileName);
   } else
      printf("\nsyntax: l <filename>\n\n");
}

void TParser::Dump_General()
{
   TData_Address addr=0x0C;
   printf("\n");
   for (int line=1; line<=4; line++) {
      for (int col=1; col<=9; col++) {
         printf("f%02X=%02X  ", addr, Pic.Regs.GENERAL(addr));
         addr++;
      }
      printf("\n");
   }
   printf("\n");
}

void TParser::Dump_EEPROM()
{
   TEEPROM_Address eeaddr=0x00;
   for (int eeline=1; eeline<=4; eeline++) {
      printf("\n%02X:", eeaddr);
      for (int eecol=0; eecol<16; eecol++) {
         printf( ((eecol & 0x03) == 0) ? "  " : "" );
         printf(" %02X", Pic.EEPROM.Mem[eeaddr++]);
      }
   }
   printf("\n\n");
}

void TParser::Dump_Program()
{
   int i=0;
   for (int eeline=1; eeline<PROGMEM_SIZE/8; eeline++) {
      int a=i;
      printf("\n%04X:", i);
      for (int eecol=0; eecol<8; eecol++) {
         printf("%s %04X",
             ((eecol & 0x03) == 0) ? "  " : "" ,
             Pic.Program_Memory.Read(i++));
      }
      i=a;
      for (eecol=0; eecol<8; eecol++) {
         int c=Pic.Program_Memory.Read(i++) & 0xff;
         if (c<' ' || c>0x7e ) c='.';
         printf("%s %c",
             ((eecol & 0x03) == 0) ? "  " : "" , c);
      }
   }
   printf("\n\n");
}

void TParser::Dump_Stack()
{
   if (Pic.Stack.Get_SP()==STACK_SIZE)
      printf("\nEmpty stack\n\n");
   else {
       unsigned char addr;
       printf("\n");
       for (addr=Pic.Stack.Get_SP(); addr<STACK_SIZE; addr++)
         printf("%1X : %04X\n",addr, Pic.Stack.Read(addr));
       printf("\n");
   }
}

void TParser::Disasm()
{
   putchar('\n');
   TProgram_Address start_addr;
   if (sscanf(input, "%s %x", token, &start_addr)==1)
      start_addr=Pic.Regs.PC & (PROGMEM_SIZE -1 );
   else
      if (start_addr>=PROGMEM_SIZE) {
         printf("Error: address out of range [0x0000...0x%04X]\n\n",
            PROGMEM_SIZE -1);
         return;
      }

   for (int dline=0; dline<=9; dline++) {
         if (start_addr==PROGMEM_SIZE) {
            start_addr=0;
            printf("\n");
         }
         printf("%04X:%04X  %s\n", start_addr,
                 Pic.Program_Memory.Read(start_addr),
                 Pic.Get_Mnemonic(start_addr));
         start_addr++;
      }
   putchar('\n');
}

void TParser::Inputs_Get()
{
   if (TIME>=Inputs.Next_Time) {
      if (!Pic.Set_Input_State(Inputs.Next_Inputs))
         printf("Error: attempt to force output pin level\n");
      else
         if (Report.Opened())
            Report_In();
      double New_Time;
      char New_A[6];
      char New_B[9];
      char New_MCLR;
      switch(fscanf(Inputs.File(),
         "%s %s %c%lf", &New_A, &New_B, &New_MCLR, &New_Time)) {
         case EOF:
            printf("\nReached end of input file\nInput file closed\n");
            Close_Inputs();
            break;
         case 4:
            Inputs.Next_Time=New_Time;
            int i;
            for (i=4; i>=0; i--)
               switch (New_A[4-i]) {
                  case '0': Inputs.Next_Inputs.RA[i]=IN_0;
                            break;
                  case '1': Inputs.Next_Inputs.RA[i]=IN_1;
                            break;
                  case '-': Inputs.Next_Inputs.RA[i]=OUT;
                            break;
                  case 'u': break;
               }
            for (i=7; i>=0; i--)
               switch (New_B[7-i]) {
                  case '0': Inputs.Next_Inputs.RB[i]=IN_0;
                            break;
                  case '1': Inputs.Next_Inputs.RB[i]=IN_1;
                            break;
                  case '-': Inputs.Next_Inputs.RB[i]=OUT;
                            break;
                  case 'u': break;
               }
            Inputs.Next_Inputs.MCLR = (New_MCLR=='0') ? (IN_0) : (IN_1);
            break;
         default:
            printf("Error in input file!\n\n");  /* Non dovrebbe capitare mai */
      }
   }
}

void TParser::Go_Time()
{
   long num_steps;
   double t;
   int param;

   if (( (param=sscanf(input, "%s %lf", token, &t))==2) && (t>=TIME)) {
      num_steps=(unsigned long int) ((t-TIME)*Pic.Clock_Frequency/4000.0);
      DoSteps(num_steps);
   } else {
      printf("\nSyntax: g <time> (have %d %f)\n\n", param, t);
   }
}

void TParser::DoSteps(long num_steps)
{
   double t;
   int param;
   TRegister OLD_PORTA, OLD_PORTB, OLD_TRISA, OLD_TRISB;

  for (; num_steps>0; num_steps--) {
     if (Inputs.Opened())
        Inputs_Get();
     OLD_PORTA=Pic.Regs.PORTA;
     OLD_PORTB=Pic.Regs.PORTB;
     OLD_TRISA=Pic.Regs.TRISA;
     OLD_TRISB=Pic.Regs.TRISB;
     Pic.Clock();

     if (  Graphic.Opened() && (
           ((Graphic.Count++) == Graphic.Period) ||
           (Graphic.Period < 0 && Pic.Port_Changed)
           )
        ) {
        Graphic.Count = 0;
        Pic.Port_Changed=0;
        Graphic_Out();
     }

     if ((OLD_TRISA!=Pic.Regs.TRISA) || (OLD_TRISB!=Pic.Regs.TRISB))
          Report_Tris();
     if ((OLD_PORTA!=Pic.Regs.PORTA) || (OLD_PORTB!=Pic.Regs.PORTB))
          Report_Out();

     TIME+=4000/Pic.Clock_Frequency;  /* in ms  */

     if ((Pic.Regs.PC-1 == BP_Address) && Pic.IR_Valid)
     {
        num_steps = 1;
        printf("Breakpoint reached!\n");
     }
  }
  Dump_Register();
}

void TParser::Step()
{
   long num_steps;
   if (sscanf(input, "%s %lu", token, &num_steps)==1)
      num_steps=1;
   DoSteps(num_steps);
}

void TParser::Open_Inputs()
{
   if (!Inputs.Opened())
   {
      char name[80];
      if (sscanf(input, "%s %s", token, name)==1)
         strcpy(name,Inputs.File_Name);
      if (Inputs.Open(name, "rt"))
      {
         printf("\nOk: reading pin state from <%s>\n\n", Inputs.File_Name);
         for (int i=0; i<=4; i++)
            Inputs.Next_Inputs.RA[i]=OUT;
         for (i=0; i<=7; i++)
            Inputs.Next_Inputs.RB[i]=OUT;
         Inputs.Next_Inputs.MCLR=IN_1;
         Inputs.Next_Time=-1;
         Inputs_Get();
         Inputs_Get();
      }
      else
         printf("\nError: File not open\n\n");
   }
   else printf("\nError: Close input file before opening a new one\n\n");
}

void TParser::Close_Inputs()
{
   if (Inputs.Opened())
      Inputs.Close();
   else printf("\nNo input file actually open\n\n");
}

void TParser::Open_Report()
{
   if (!Report.Opened())
   {
      char name[80];
      if (sscanf(input, "%s %s", token, name)==1)
         strcpy(name,Report.File_Name);
      if (Report.Open(name, "w"))
         printf("\nOk: writing all pin changes to <%s>\n\n", Report.File_Name);
      else
         printf("\nError: File not open\n");
   }
   else printf("\nError: Close input file before opening a new one\n");
}

void TParser::Close_Report()
{
   if (Report.Opened())
      Report.Close();
   else printf("\nError - No Report File actually open\n");
}

void TParser::Open_Graphic()
{
   if (!Graphic.Opened()) {
      char name[80];
      if (sscanf(input, "%s %s", token, name)==1)
         strcpy(name,Graphic.File_Name);
      if (Graphic.Open(name, "a")) {
         Graphic.Count = 0;
         printf("\nOk: sampling ports A & B to <%s>\n\n", Graphic.File_Name);
         fprintf(Graphic.File(),
                "RA4 RA3 RA2 RA1 RA0   "
                "RB7 RB6 RB5 RB4 RB3 RB2 RB1 RB0    Time Delta\n");
      }
      else
         printf("\nError: File not open\n");
   }
   else printf("\nError: Close Graphic File before opening a new one\n");
}

void TParser::Close_Graphic()
{
   if (Graphic.Opened())
      Graphic.Close();
   else printf("\nError - No Graphic File actually open\n");
}

void TParser::Time_Graphic()
{
   long num_steps;

   if (sscanf(input, "%s %ld", token, &num_steps)==2)
      Graphic.Period = num_steps;
   else
      printf("\nSyntax: st <cycles>, currently %d\n", Graphic.Period);
}

void TParser::Input_A()
{
   char A[10];
   if ((sscanf(input, "%s %s", token, A)==2) && (strlen(A)==5))
   {
      TInput_State inp=Pic.New_Input_State;
      for (int i=4; i>=0; i--)
         switch(A[4-i])
         {
            case '0':inp.RA[i]=IN_0;  break;
            case '1':inp.RA[i]=IN_1;  break;
            case '-':inp.RA[i]=OUT;  break;
            case 'u':;
         }
      if (!Pic.Set_Input_State(inp))
         printf("Error: Output pin level forced from extern\n");
      Pic.Port_Changed=1;
   }
   else
      printf("Syntax: pa ddddd\n");
}

void TParser::Input_B()
{
   char B[10];
   if ((sscanf(input, "%s %s", token, B)==2) && (strlen(B)==8))
   {
      TInput_State inp=Pic.New_Input_State;
      for (int i=7; i>=0; i--)
         switch(B[7-i])
         {
            case '0':inp.RB[i]=IN_0;  break;
            case '1':inp.RB[i]=IN_1;  break;
            case '-':inp.RB[i]=OUT;  break;
            case 'u':;
         }
      if (!Pic.Set_Input_State(inp))
         printf("Error: Output pin level forced from extern\n");
      Pic.Port_Changed=1;
   }
   else
      printf("Syntax: pb ddddd\n");
}

void TParser::Input_MCLR()
{
   char ch[10];
   if ((sscanf(input, "%s %s", token, ch)==2) && (strlen(ch)==1))
   {
      TInput_State inp=Pic.New_Input_State;
      switch (ch[0])
      {
            case '0':inp.MCLR=IN_0;  break;
            case '1':inp.MCLR=IN_1;  break;
      }
      Pic.Set_Input_State(inp);
   }
}

void TParser::Reset_POR()
{
   Pic.Reset_POR();
   TIME = 0;
   Dump_Register();
}

void TParser::Set_Breakpoint()
{
   TProgram_Address input_BP;
   if( sscanf(input, "%s %4x", token, &input_BP) == 2 ) {
     BP_Address = input_BP;
     printf("\nBreakpoint: %04X  - set\n\n", BP_Address);
     }
   else {
     if(BP_Address == 0xFFFF)
       printf("\nBreakpoint : <none>\n\n");
     else
       printf("\nBreakpoint: %04X  - removed\n\n", BP_Address);
     BP_Address = 0xFFFF;
     }
}

void TParser::Set_Frequency()
{
   double freq;
   if (sscanf(input, "%s %lf", token, &freq) == 2 )
   {
     Pic.Clock_Frequency = freq * 1.0E6;
   }
  printf("\nActual clock frequency = %4.6lf MHz\n\n", Pic.Clock_Frequency/1e6);
}

TBool TParser::Parse()
{
   printf("%.6lf ms> ",TIME);
   fgets(input, sizeof(input)-1, stdin);

   if (sscanf(input, "%s", token)==1) {
      if (strcmp(token,"h") == 0)
            Help();
      else if (strcmp(token,"q") == 0) {
          if (Graphic.Opened()==TRUE)
             fclose(Graphic.File());
          if (Report.Opened()==TRUE)
             fclose(Report.File());
          if (Inputs.Opened()==TRUE)
             fclose(Inputs.File());
          return FALSE;
      }
      else if (strcmp(token,"l") == 0)
            LoadFile();
      else if (strcmp(token,"dr") == 0)
            Dump_Register();
      else if (strcmp(token,"dg") == 0)
            Dump_General();
      else if (strcmp(token,"dee") == 0)
            Dump_EEPROM();
      else if (strcmp(token,"dpm") == 0)
            Dump_Program();
      else if (strcmp(token,"dp") == 0)
            Dump_IO_Pins();
      else if (strcmp(token,"ds") == 0)
            Dump_Stack();
      else if (strcmp(token,"d") == 0)
            Disasm();
      else if (strcmp(token,"s") == 0)
            Step();
      else if (strcmp(token,"g") == 0)
            Go_Time();
      else if (strcmp(token,"bp") == 0)
            Set_Breakpoint();
      else if (strcmp(token,"f") == 0)
            Set_Frequency();
      else if (strcmp(token,"pa") == 0)
            Input_A();
      else if (strcmp(token,"pb") == 0)
            Input_B();
      else if (strcmp(token,"pm") == 0)
            Input_MCLR();
      else if (strcmp(token,"ro") == 0)
            Open_Report();
      else if (strcmp(token,"rc") == 0)
            Close_Report();
       else if (strcmp(token,"eo") == 0)
            Open_Graphic();
      else if (strcmp(token,"ec") == 0)
            Close_Graphic();
      else if (strcmp(token,"st") == 0)
            Time_Graphic();
      else if (strcmp(token,"io") == 0)
            Open_Inputs();
      else if (strcmp(token,"ic") == 0)
            Close_Inputs();
      else if (strcmp(token,"por") == 0)
            Reset_POR();
      else printf("\nh for Help\n");
   }
   return TRUE;
}
