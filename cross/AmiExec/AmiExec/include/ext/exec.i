   IFND  EXT_EXEC_I
EXT_EXEC_I SET    1
***************************************************************************** 
*
* $Source: MASTER:include/ext/exec.i,v $
* $Revision: 3.1 $
* $Date: 1994/10/28 09:26:56 $
*
* This file contains some low-level extensions of the standard CBM exec 
* includes.
*
*****************************************************************************

      IFND     EXEC_MEMORY_I
      INCLUDE  "exec/memory.i"
      ENDC


*--- Extensions to "exec/memory.i". ---*

* A couple of handy memory types.

MEMF_STD       EQU   MEMF_ANY!MEMF_CLEAR
MEMF_BAT       EQU   MEMF_CHIP


*--- Extensions to "exec/resident.i".  ---*

* Structures for AUTOINIT of resident modules.

   STRUCTURE RtInitLib,0
      ULONG rtl_space
      APTR  rtl_funcTable    
      APTR  rtl_dataTable
      APTR  rtl_initRoutine  
      LABEL RTL_SIZE

   STRUCTURE RtInitTask,0
      BYTE  rtt_priority
      BYTE  rtt_pad
      APTR  rtt_entrypt
      ULONG rtt_stacksz
      LABEL RTT_SIZE

   STRUCT RtInitMem,0
      ULONG rtm_size
      ULONG rtm_attributes
      LONG  rtm_pri
      APTR  rtm_base
      APTR  rtm_name
      APTR  rtm_dest
      LABEL RTM_SIZE


*--- Extensions to "exec/interrupts.i". ---*

* Structs and such for manipulating the context of an interrupt.

   STRUCTURE Registers,0
      ULONG rg_D0
      ULONG rg_D1
      ULONG rg_D2
      ULONG rg_D3
      ULONG rg_D4
      ULONG rg_D5
      ULONG rg_D6
      ULONG rg_D7
      ULONG rg_A0
      ULONG rg_A1
      ULONG rg_A2
      ULONG rg_A3
      ULONG rg_A4
      ULONG rg_A5
      ULONG rg_A6
      ULONG rg_A7
      LABEL rg_SIZE

   STRUCTURE Context,rg_SIZE
      UWORD  cn_SR                        ; status registers
      ULONG  cn_PC                        ; program counter
      LABEL  cn_SIZE


* A Vector structure defines how an exception vector is to be initialized.

   STRUCTURE Vector,0
      LONG   v_Vectnum
      APTR   v_Isr
      LABEL  v_SIZE


*--- Extensions to "exec/libraries.h". ---*

* The LibEntry structure describes the format of an entry in a library's
* vector table.

   STRUCTURE LibEntry,0
      UWORD le_opcode                     ;always LE_JMPLONG as defined below.
      APTR  le_func                       ;ptr to a library procedure
      LABEL le_SIZE

LE_JMPLONG  EQU   $4EF9                   ;jmp instruction opcode


      ENDC
