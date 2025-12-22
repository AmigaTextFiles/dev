/****h* Z80Simulator/Z80ST2.c [2.5] ******************************
*
* NAME
*    Z80ST2.c
*
* NOTES
*    EXTERNAL CALLS: X_Index()      in Z80S21.c
*                    Y_Index()      in Z80S22.c
*                    Misc_Inst()    in Z80S23.c
*                    Logical_Bits() in Z80S24.c
*
* DESCRIPTION
*    More State Machine decoding for the tabulated instructions.
*
* SYNOPSIS
*    int status = decode_mach2( int state2, int table )
*
*    PARAMETERS:    state2 - The 2nd byte (mem[dreg[PC] + 1])
*                            of the machine code.
*                   table  - A value furnished by decode_
*                            mach(), T1, T2, IX, or IY.
*
* RETURNS
*    Integer equal to processor status.
******************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include "Z80Sim.h"
#include "Z80FuncProtos.h"

VISIBLE int decode_mach2( int state2, int table )
{
   int   status = RUNNING;

   switch( table )   
      {
      case IX:   
         status = X_Index( state2 );       
         break;
      
      case IY:   
         status = Y_Index( state2 );
         break;
      
      case T2:
         status = Misc_Inst( state2 );
         break;
      
      case T1:   
         status = Logical_Bits( state2 );  
         break;
      
      default:   
         status = ILLGL;
         break;
      }

   return( status );
}

/* -------------------- End of Z80ST2.c ---------------------- */
