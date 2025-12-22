------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                S Y S T E M . T A S K _ P R I M I T I V E S               --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.10 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2,  or (at  your  option)  any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with Interfaces.C;
--  Used for Size_t;

with Interfaces.C.Pthreads;
--  Used for, size_t,
--            pthread_mutex_t,
--            pthread_cond_t,
--            pthread_t

with Interfaces.C.POSIX_RTE;
--  Used for, Signal,
--            siginfo_ptr,

with System.Task_Clock;
--  Used for, Stimespec

with Unchecked_Conversion;

pragma Elaborate_All (Interfaces.C.Pthreads);

package System.Task_Primitives is

   --  Low level Task size and state definition

   type LL_Task_Procedure_Access is access procedure (Arg : System.Address);

   type Pre_Call_State is new System.Address;

   type Task_Storage_Size is new Interfaces.C.size_t;

   type Interrupt_ID is new Interfaces.C.POSIX_RTE.Signal;

   type Interrupt_Info is new Interfaces.C.POSIX_RTE.siginfo_ptr;

   type Machine_Exceptions is new Interfaces.C.POSIX_RTE.Signal;

   type Error_Information is new Interfaces.C.POSIX_RTE.siginfo_ptr;

   type Lock is new Interfaces.C.Pthreads.pthread_mutex_t;
   type Condition_Variable is new Interfaces.C.Pthreads.pthread_cond_t;

--  These definitions has to be private   ???
--   type Lock is private;
--   type Condition_Variable is private;

   --  The above types should both be limited.  They are not due to a hack in
   --  ATCB allocation which allocates a block of the correct size and then
   --  assigns an initalizized ATCB to it. This won't work with limited types.
   --  When allocation is done with new, these can become limited once again.
   --  ???

   type Task_Control_Block is record
      LL_Entry_Point : LL_Task_Procedure_Access;
      LL_Arg         : System.Address;
      Thread         : Interfaces.C.Pthreads.pthread_t;
      Stack_Size     : Task_Storage_Size;
      Stack_Limit    : System.Address;
   end record;

   type TCB_Ptr is access Task_Control_Block;

   --  Task ATCB related and variables.

   function Address_To_TCB_Ptr is new
     Unchecked_Conversion (System.Address, TCB_Ptr);

   procedure Initialize_LL_Tasks (T : TCB_Ptr);

   function Self return TCB_Ptr;

   procedure Initialize_Lock (Prio : System.Priority; L : in out Lock);

   procedure Finalize_Lock (L : in out Lock);

   procedure Write_Lock (L : in out Lock; Ceiling_Violation : out Boolean);

   procedure Read_Lock (L : in out Lock; Ceiling_Violation : out Boolean);

   procedure Unlock (L : in out Lock);

   procedure Initialize_Cond (Cond : in out Condition_Variable);

   procedure Finalize_Cond (Cond : in out Condition_Variable);

   procedure Cond_Wait (Cond : in out Condition_Variable; L : in out Lock);

   procedure Cond_Timed_Wait
     (Cond      : in out Condition_Variable;
      L         : in out Lock; Abs_Time : Task_Clock.Stimespec;
      Timed_Out : out Boolean);

   procedure Cond_Signal (Cond : in out Condition_Variable);

   procedure Cond_Broadcast (Cond : in out Condition_Variable);

   procedure Set_Priority (T : TCB_Ptr; Prio : System.Priority);

   procedure Set_Own_Priority (Prio : System.Priority);

   function Get_Priority (T : TCB_Ptr) return System.Priority;

   function Get_Own_Priority return System.Priority;

   procedure Create_LL_Task
     (Priority       : System.Priority;
      Stack_Size     :  Task_Storage_Size;
      LL_Entry_Point : LL_Task_Procedure_Access;
      Arg            : System.Address;
      T              : TCB_Ptr);

   procedure Exit_LL_Task;

   procedure Abort_Task (T : TCB_Ptr);

   procedure Test_Abort;

   type Abort_Handler_Pointer is access procedure (Context : Pre_Call_State);

   procedure Install_Abort_Handler (Handler : Abort_Handler_Pointer);

   procedure Install_Error_Handler (Handler : System.Address);

   procedure Signal_Task (T : TCB_Ptr; Int_Id : Interrupt_ID);

   procedure Wait_For_Signal (Int_Id : Interrupt_ID);

   function Reserved_Signal (Int_Id : Interrupt_ID) return Boolean;

   procedure LL_Assert (B : Boolean; M : String);

   Task_Wrapper_Frame : constant Integer := 72;
   --  This is the size of the frame for the Pthread_Wrapper procedure.

   type Proc is access procedure (Addr : System.Address);

   procedure Test_And_Set (Flag_Add : System.Address; Result : out Boolean);
   --  Flag_Add is the address of  a variable of type Boolean

--  private

--  type Lock is new Pthreads.pthread_mutex_t;                     ???
--  type Condition_Variable is new Pthreads.pthread_cond_t;        ???

end System.Task_Primitives;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Wed Jul 13 16:25:39 1994;  author: giering
--  Adding Elaborate_All (System.Pthreads)
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.9
--  date: Fri Jul 15 17:56:32 1994;  author: giering
--  Name Change: Init_State => LL_Task_Procedure_Access
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.10
--  date: Thu Aug 18 17:42:32 1994;  author: giering
--  Getting Size_t from Interfaces.C
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
