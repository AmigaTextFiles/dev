
{ Some special functions, included in the PCQ.lib since 2.0 }


{ MemXXX returns the value found at address a }

Function MemInt( a : Address ): Integer;
    External;

Function MemWordInt( a : Address ): Word;
    External;

Function MemByte( a : Address ): Byte;
    External;



{ XJsr causes the CPU to continue at address a }
{ ****   USE  WITH  EXTREMLY  CAUTION  !! **** }

Function XJsr( a : Address ): Integer;
    External;


{ GetD0 returns the last value used in D0;  useful e.g. for }
{ getting the value returned by CloseScreen since kickstart }
{ V36.							    }

Function GetD0 : Integer;
    External;

