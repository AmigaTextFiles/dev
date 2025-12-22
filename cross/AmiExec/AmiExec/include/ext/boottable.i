   IFND  EXT_BOOTTABLE_I
EXT_BOOTTABLE_I SET    1
***************************************************************************** 
*
* $Source: MASTER:include/ext/boottable.i,v $
* $Revision: 3.3 $
* $Date: 1997/02/01 08:16:06 $
*
* This file contains the definition of the BootTable structure and related
* values.
*
* Copyright © 1993-1996 by W. John Malone.  All rights reserved.
*
*****************************************************************************

   IFND EXEC_EXECBASE_I
      INCLUDE "exec/execbase.i"
   ENDC
   INCLUDE "exec/funcdef.i"


* Where the BootTable is located, relative to exec.library.

BOOTTABLE      EQU   -$400


* A BootTable

   STRUCTURE BootTable,0
      APTR   AbsSysBase             ; pointer to pointer to base of exec lib
      APTR   SysStackLower          ; lower limit of supervisor stack
      APTR   SysStackUpper          ; upper limit of supervisor stack
      APTR   ScanStart              ; start for ROMTag scan
      ULONG  ScanSkip               ; memory quantum to advance scan on bus error
      APTR   DumpArea               ; where to dump if debug.library not present 
      UWORD  AttnFlags              ; processors and co-processors
      UWORD  SoftIntTrap            ; trap used for software interrupts
      APTR   VectorBase;            ; location of vector table - i.e. VBR
      APTR   MonitorVectors         ; exception vectors when monitor present
      APTR   ExecISRs               ; ptr to library style jump table of ExecISRs
      ULONG  Baud                   ; default baud rate for console
      BOOL   TagStep                ; pause at each ROMTag during boot
      UWORD  BreakpointTrap;        ; trap used to insert breakpoints
      APTR   BootEvent;             ; low level boot debugging callback

      LABEL  BT_SIZE


      ENDC
