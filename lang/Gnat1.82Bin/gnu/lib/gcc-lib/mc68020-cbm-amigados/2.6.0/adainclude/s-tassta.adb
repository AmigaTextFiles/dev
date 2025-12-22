------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                 S Y S T E M . T A S K I N G . S T A G E S                --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.25 $                             --
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

with System.Compiler_Exceptions;
--  Used for,  Compiler_Exceptions.Notify_Exception
--             Null_Exception

with System.Compiler_Options;
--  Used for, Main_Priority

--  The following two packages are not part of the GNARL proper.  They
--  provide access to a compiler-specific per-task data area.

with System.Task_Soft_Links;
--  Used for, Abort_Defer, Abort_Undefer, Get_TSD_Address
--  These are procedure pointers to non-tasking routines that use
--  task specific data.  In the absense of tasking, these routines
--  refer to global data.  In the presense of tasking, they must be
--  replaced with pointers to task-specific versions.

with System.Tasking_Specific_Data;
--  Used for, Create_TSD, Destroy_TSD
--  This package provides initialization routines for task specific data.
--  The GNARL must call these to be sure that all non-tasking
--  Ada constructs will work.

with System.Error_Reporting;
--  Used for, Error_Reporting.Assert

with System.Tasking.Abortion;
--  Used for, Abortion.Defer_Abortion,
--            Abortion.Undefer_Abortion,
--            Abortion.Change_Base_Priority

with System.Tasking.Utilities;
--  Used for, Utilities.ATCB_Ptr,
--            Utilities.ATCB_To_ID,
--            Utilities.ID_To_ATCB,
--            Utilities.ATCB_To_Address
--            Utilities."<",
--            Utilities.">=",
--            Utilities."=",
--            Utilities."/=",
--            Utilities.Task_Stage
--            Utilities.Accepting_State
--            Utilities.All_Tasks_List
--            Utilities.Ada_Task_Control_Block
--            Utilities.Task_Error
--            Utilities.ATCB_Init
--            Utilities.Await_Dependents
--            Utilities.Vulnerable_Complete_Activation
--            Utilities.Abort_To_Level
--            Utilities.Abort_Dependents
--            Utilities.Complete
--            Utilities.Check_Exceptions
--            Utilities.Remove_From_All_Tasks_List

with System.Task_Memory;
--  Used for, Task_Memory.Low_Level_New,
--            Task_Memory.Unsafe_Low_Level_New,
--            Task_Memory.Low_Level_Free

with System.Task_Primitives; use System.Task_Primitives;

with Unchecked_Conversion;

pragma Elaborate_All (System.Tasking.Utilities);
pragma Elaborate_All (System.Task_Primitives);
pragma Elaborate_All (System.Tasking.Abortion);
pragma Elaborate_All (System.Error_Reporting);
pragma Elaborate_All (System.Compiler_Exceptions);
pragma Elaborate_All (System.Task_Memory);

pragma Elaborate_All (System.Task_Soft_Links);
--  This must be elaborated first, to prevent its initialization of
--  the global procedure pointers from overwriting the pointers installed
--  by Stages.

package body System.Tasking.Stages is

   function ID_To_ATCB (ID : Task_ID) return Utilities.ATCB_Ptr
     renames Tasking.Utilities.ID_To_ATCB;

   function ATCB_To_ID (Ptr : Utilities.ATCB_Ptr) return Task_ID
     renames Utilities.ATCB_To_ID;

   --  Could use "use type" for the following declarations ???

   function "=" (L, R : Utilities.ATCB_Ptr) return Boolean
     renames Utilities."=";

   function "=" (L, R : Utilities.Task_Stage) return Boolean
     renames Utilities."=";

   function ">=" (L, R : Utilities.Task_Stage) return Boolean
     renames Utilities.">=";

   function "<" (L, R : Utilities.Task_Stage) return Boolean
     renames Utilities."<";

   function "=" (L, R : Utilities.Accepting_State) return Boolean
     renames Utilities."=";

   procedure Defer_Abortion renames Abortion.Defer_Abortion;

   procedure Undefer_Abortion renames Abortion.Undefer_Abortion;

   function Activation_to_ATCB is new
     Unchecked_Conversion (Activation_Chain, Utilities.ATCB_Ptr);

   function ATCB_to_Activation is new
     Unchecked_Conversion (Utilities.ATCB_Ptr, Activation_Chain);

   -----------------------------
   -- ATCB related operations --
   -----------------------------

   --  The TCB contains a variable size array whose dope vector must be
   --  initialized. This is too complex (and changes too much with changes
   --  in the TCB record) to do explicitely, so a record of the correct size
   --  is declared here and copied into the newly allocated storage.

   --  Discriminant checking is disabled to prevent the discriminant in the
   --  newly created record from being checked before a legal value is
   --  assigned to it.

   --  How is discriminant checking disabled, I see no pragma Suppress ???

   procedure Initialize_ATCB
     (T    : Utilities.ATCB_Ptr;
      Init : Utilities.ATCB_Init);
   --  Initialize fields of a TCB and link into global TCB structures

   function New_ATCB
     (Init : Utilities.ATCB_Init)
      return Utilities.ATCB_Ptr;
   --  New_ATCB creates a new ATCB using the low level allocation routines
   --  (essentially a protected version of malloc()).  This is done because
   --  the new operator can be changed by the user, and may involve
   --  allocation from pools (which would limit the number of tasks), might
   --  block on insufficiant memory, or might fragment the user's heap
   --  behind his back.

   function Unsafe_New_ATCB
     (Init : Utilities.ATCB_Init)
      return Utilities.ATCB_Ptr;
   --  This creates a new ATCB using unprotected low level allocation routines
   --  (essentially malloc()).  This is done for allocating the ATCB for the
   --  initial task, since this must be done before initializing the low
   --  level tasking, and locks (and hence protected Low_Level_New) cannot
   --  be used until it is.

   procedure Free_ATCB (T : in out Utilities.ATCB_Ptr);
   --  Release storage of a previously allocated ATCB

   -----------------------------
   -- Other Local Subprograms --
   -----------------------------

   procedure Task_Wrapper (Arg : System.Address);
   --  This is the procedure that is called by the GNULL from the
   --  new context when a task is created.  It waits for activation
   --  and then calls the task body procedure.  When the task body
   --  procedure completes, it terminates the task.

   procedure Terminate_Dependents (ML : Master_ID := Master_ID'First);
   --  Terminate all dependent tasks of given master level

   procedure Vulnerable_Complete_Task;
   --  Complete the calling task.  This procedure must be called with
   --  abortion deferred.

   ---------------------
   -- Initialize_ATCB --
   ---------------------

   procedure Initialize_ATCB
     (T     : Utilities.ATCB_Ptr;
      Init  : Utilities.ATCB_Init)
   is
      Error : Boolean;
   begin
      --  Initialize all fields of the TCB

      Initialize_Lock (System.Priority'Last, T.L);
      Initialize_Cond (T.Cond);
      Initialize_Cond (T.Rend_Cond);
      T.Activation_Count := 0;
      T.Awake_Count := 1;                       --  Counting this task.
      T.Awaited_Dependent_Count := 0;
      T.Terminating_Dependent_Count := 0;
      T.Pending_Action := False;
      T.Pending_ATC_Level := ATC_Level_Infinity;
      T.ATC_Nesting_Level := 1;                 --  1 deep; 0 = abnormal.
      T.Deferral_Level := 1;                    --  Start out deferred.
      T.Stage := Utilities.Created;
      T.Exception_To_Raise := Compiler_Exceptions.Null_Exception;
      T.Accepting := Utilities.Not_Accepting;
      T.Aborting := False;
      T.Suspended_Abortably := False;
      T.Call := null;
      T.Elaborated := Init.Elaborated;
      T.Parent := Init.Parent;
      T.Task_Entry_Point := Init.Task_Entry_Point;
      T.Task_Arg := Init.Task_Arg;
      T.Stack_Size := Init.Stack_Size;
      T.Current_Priority := Init.Priority;
      T.Base_Priority := Init.Priority;
      T.Pending_Priority_Change := False;
      T.Activator := Init.Activator;
      T.Master_of_Task := Init.Master_of_Task;
      T.Master_Within := Increment_Master (Init.Master_of_Task);

      for J in 1 .. T.Entry_Num loop
         T.Entry_Queues (J).Head := null;
         T.Entry_Queues (J).Tail := null;
      end loop;

      for L in T.Entry_Calls'range loop
         T.Entry_Calls (L).Next := null;
         T.Entry_Calls (L).Self := ATCB_To_ID (T);
         T.Entry_Calls (L).Level := L;
      end loop;

      --  Link the task into the list of all tasks.

      if T.Parent /= null then
         Defer_Abortion;
         Write_Lock (Utilities.All_Tasks_L, Error);
      end if;

      T.All_Tasks_Link := Utilities.All_Tasks_List;
      Utilities.All_Tasks_List := T;

      if T.Parent /= null then
         Unlock (Utilities.All_Tasks_L);
         Undefer_Abortion;
      end if;
   end Initialize_ATCB;

   --------------
   -- New_ATCB --
   --------------

   function New_ATCB
     (Init : Utilities.ATCB_Init)
      return Utilities.ATCB_Ptr
   is
      subtype Constrained_ATCB is
        Utilities.Ada_Task_Control_Block (Init.Entry_Num);

      Initialized_ATCB : Constrained_ATCB;
      T                : Utilities.ATCB_Ptr;
      A                : System.Address;

      function Address_to_Pointer is new
        Unchecked_Conversion (System.Address, Utilities.ATCB_Ptr);

   begin
      A :=
        Task_Memory.Low_Level_New
          (Constrained_ATCB'Size / System.Storage_Unit);
      T := Address_to_Pointer (A);
      T.all := Initialized_ATCB;
      Initialize_ATCB (T, Init);
      return T;
   end New_ATCB;

   ---------------------
   -- Unsafe_New_ATCB --
   ---------------------

   function Unsafe_New_ATCB
     (Init : Utilities.ATCB_Init)
      return Utilities.ATCB_Ptr
   is
      subtype Constrained_ATCB is
        Utilities.Ada_Task_Control_Block (Init.Entry_Num);

      Initialized_ATCB : Constrained_ATCB;
      T                : Utilities.ATCB_Ptr;
      A                : System.Address;

      function Address_to_Pointer is new
        Unchecked_Conversion (System.Address, Utilities.ATCB_Ptr);

   begin
      A :=
        Task_Memory.Unsafe_Low_Level_New
          (Constrained_ATCB'Size / System.Storage_Unit);
      T := Address_to_Pointer (A);
      T.all := Initialized_ATCB;
      return T;
   end Unsafe_New_ATCB;

   ---------------
   -- Free_ATCB --
   ---------------

   procedure Free_ATCB (T : in out Utilities.ATCB_Ptr) is
      function Pointer_to_Address is new
        Unchecked_Conversion (Utilities.ATCB_Ptr, System.Address);

   begin
      Finalize_Lock (T.L);
      Finalize_Cond (T.Cond);
      Finalize_Cond (T.Rend_Cond);
      Task_Memory.Low_Level_Free (Pointer_to_Address (T));
   end Free_ATCB;

   ---------------------
   -- Get_TSD_Address --
   ---------------------

   --  This procedure returns the task-specific data pointer installed at
   --  task creation time by the GNARL on behalf of the compiler.  A pointer
   --  to this routine replaces the default pointer installed for the
   --  non-tasking case.
   --  The dummy parameter avoids a bug in GNAT.

   function Get_TSD_Address (Dummy : Boolean) return Address is
      T : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
   begin
      return T.Compiler_Data;
   end Get_TSD_Address;

   --------------
   -- Init_RTS --
   --------------

   procedure Init_RTS (Main_Task_Priority : System.Priority) is
      T    : Utilities.ATCB_Ptr;
      Init : Utilities.ATCB_Init;

   begin

      Utilities.All_Tasks_List := null;
      Init.Entry_Num := 0;
      Init.Parent := null;

      Init.Task_Entry_Point := null;

      Init.Stack_Size := 0;
      Init.Activator := null;
      Stages.Init_Master (Init.Master_of_Task);
      Init.Elaborated := null;
      if Main_Task_Priority = Unspecified_Priority then
         Init.Priority := Default_Priority;
      else
         Init.Priority := Main_Task_Priority;
      end if;

      T := Unsafe_New_ATCB (Init);

      T.Compiler_Data := Task_Specific_Data.Create_TSD;
      --  This needs to be done as early as possible in the creation
      --  of a task, since the opration of Ada code within the task may
      --  depend on task specific data.

      Initialize_LL_Tasks (T.LL_TCB'access);
      Initialize_ATCB (T, Init);

      --  The allocation of the initial task ATCB is different from
      --  that of subsequent ATCBs, which are allocated with ATCB.New_ATCB.
      --  New_ATCB performs all of the functions of Unsafe_New_ATCB
      --  and Initialize_ATCB.  However, it uses GNULLI operations, which
      --  should not be called until after Initialize_LL_Tasks.  Since
      --  Initialize_LL_Tasks needs the initial ATCB, New_ATCB was broken
      --  down into two parts, the first of which alloctes the ATCB without
      --  calling any GNULLI operations.

      Set_Own_Priority (T.Current_Priority);

      Initialize_Lock (Priority'Last, Utilities.All_Tasks_L);
      --  Initialize the lock used to synchronize chain of all ATCBs.

      --  This is not according the the GNULLI, which specifes
      --  access procedure (Context: Pre_Call_State) for the handler.
      --  This may be a mistake in the interface. ???

      Install_Abort_Handler (Utilities.Abort_Handler'access);

      --  Install handlers for asynchronous error signals.

      --  This is not according the the GNULLI, which specifes
      --  access procedure(...) for the handler.
      --  This may be a mistake in the interface. ???

      Install_Error_Handler (Compiler_Exceptions.Notify_Exception'Address);

      --  Set up the soft links to tasking services used in the absense of
      --  tasking.  These replace tasking-free defaults.

      Tasking_Soft_Links.Abort_Defer := Abortion.Defer_Abortion'Access;
      Tasking_Soft_Links.Abort_Undefer := Abortion.Undefer_Abortion'Access;
      Tasking_Soft_Links.Get_TSD_Address := Get_TSD_Address'Access;

      --  Abortion is deferred in a new ATCB, so we need to undefer abortion
      --  at this stage to make the environment task abortable.

      Abortion.Undefer_Abortion;

   end Init_RTS;

   -----------------
   -- Init_Master --
   -----------------

   procedure Init_Master (M : out Master_ID) is
   begin
      M := 0;
   end Init_Master;

   ----------------------
   -- Increment_Master --
   ----------------------

   function Increment_Master (M : Master_ID) return Master_ID is
   begin
      return M + 1;
   end Increment_Master;

   ----------------------
   -- Decrement_Master --
   ----------------------

   function Decrement_Master (M : Master_ID) return Master_ID is
   begin
      return M - 1;
   end Decrement_Master;

   -------------------------
   -- Wait_For_Activation --
   -------------------------

   procedure Wait_For_Activation (Target : Task_ID) is
      T     : Utilities.ATCB_Ptr := ID_To_ATCB (Target);
      Error : Boolean;
   begin

      --  Abortion is deferred at this point as a result
      --  of ATCB initialization.

      Read_Lock (T.L, Error);
      T.Suspended_Abortably := True;
      while Utilities."/=" (T.Stage, Utilities.Can_Activate) loop
         if T.Pending_Action then
            if T.Pending_Priority_Change then
               Abortion.Change_Base_Priority (T);
            end if;

            exit when
               T.Pending_ATC_Level < T.ATC_Nesting_Level;
            T.Pending_Action := False;
         end if;
         Cond_Wait (T.Cond, T.L);
      end loop;
      T.Suspended_Abortably := False;
      Unlock (T.L);

      Undefer_Abortion;
   end Wait_For_Activation;
   pragma Inline (Wait_For_Activation);

   ------------------
   -- Task_Wrapper --
   ------------------

   procedure Task_Wrapper (Arg : System.Address) is
      function Address_To_Pointer is new
        Unchecked_Conversion (System.Address, Access_Boolean);

      function Address_To_Task_ID is new
        Unchecked_Conversion (System.Address, Utilities.ATCB_Ptr);

      T : Utilities.ATCB_Ptr := Address_To_Task_ID (Arg);

   begin

      --  ??? This is a patch.  If a task is aborted while waiting for
      --  activation, it must be completed.  Ideally, abortion would
      --  be deferred until the task body procedure started execution,
      --  in the call to T.Task_Entry_Point below.  Task body procedures
      --  are protected by "at end" handlers which do the Complete_Task.
      --  Until this is done, handle the signal here.

      begin
         Wait_For_Activation (ATCB_To_ID (T));
      exception
      when Standard'Abort_Signal =>
         Complete_Task;
         raise;
      end;

      --  Call the task body procedure.

      T.Task_Entry_Point (T.Task_Arg);
      --  Return here after task finalization

      Defer_Abortion;

      --  This call won't return. Therefor no need for Undefer_Abortion

      Stages.Leave_Task;

   exception

   --  Only the call to user code (T.Task_Entry_Point) should raise an
   --  exception.  An "at end" handler in the generated code should have
   --  completed the the task, and the exception should not be propagated
   --  further.  Terminate the task as though it had returned.

   when Standard'Abort_Signal =>
      Defer_Abortion;
      Stages.Leave_Task;
   when others =>
      Defer_Abortion;
      Stages.Leave_Task;
   end Task_Wrapper;

   -----------------
   -- Create_Task --
   -----------------

   procedure Create_Task
     (Size          : Size_Type;
      Priority      : Integer;
      Num_Entries   : Task_Entry_Index;
      Master        : Master_ID;
      State         : Task_Procedure_Access;
      Discriminants : System.Address;
      Elaborated    : Access_Boolean;
      Chain         : in out Activation_Chain;
      Created_Task  : out Task_ID)
   is

      T, P, S            : Utilities.ATCB_Ptr;
      Init               : Utilities.ATCB_Init;
      Default_Stack_Size : constant Size_Type := 10000;
      Error              : Boolean;

   begin
      S := ID_To_ATCB (Self);

      if Priority = Unspecified_Priority then
         Init.Priority := Default_Priority;
      else
         Init.Priority := Priority;
      end if;

      --  Find parent of new task, P, via master level number.

      P := S;
      if P /= null then
         while P.Master_of_Task >= Master loop
            P := P.Parent;
            exit when P = null;
         end loop;
      end if;

      Defer_Abortion;

      if P /= null then
         Write_Lock (P.L, Error);

         if P /= S
           and then P.Awaited_Dependent_Count /= 0
           and then Master = P.Master_Within
         then
            P.Awaited_Dependent_Count := P.Awaited_Dependent_Count + 1;
         end if;

         P.Awake_Count := P.Awake_Count + 1;
         Unlock (P.L);
      end if;

      Undefer_Abortion;

      Init.Entry_Num := Num_Entries;
      Init.Task_Arg := Discriminants;
      Init.Parent := P;
      Init.Task_Entry_Point := State;

      if Size = Unspecified_Size then
         Init.Stack_Size := Default_Stack_Size;
      else
         Init.Stack_Size := Size;
      end if;

      Init.Activator := S;
      Init.Master_of_Task := Master;
      Init.Elaborated := Elaborated;
      T := New_ATCB (Init);

      T.Compiler_Data := Task_Specific_Data.Create_TSD;
      --  This needs to be done as early as possible in the creation
      --  of a task, since the opration of Ada code within the task may
      --  depend on task specific data.

      T.Activation_Link := Activation_to_ATCB (Chain);
      Chain := ATCB_to_Activation (T);

      T.Aborter_Link := null;

      Created_Task := ATCB_To_ID (T);
   end Create_Task;

   --------------------
   -- Activate_Tasks --
   --------------------

   procedure Activate_Tasks (Chain_Access : Activation_Chain_Access) is
      This_Task      : Utilities.ATCB_Ptr;
      C              : Utilities.ATCB_Ptr;
      All_Elaborated : Boolean := True;
      LL_Entry_Point : Task_Primitives.LL_Task_Procedure_Access;
      Error          : Boolean;

   begin
      This_Task := ID_To_ATCB (Self);

      C := Activation_to_ATCB (Chain_Access.all);
      while (C /= null) and All_Elaborated loop
         if C.Elaborated /= null and then not C.Elaborated.all then
            All_Elaborated := False;
         end if;

         C := C.Activation_Link;
      end loop;

      --  Check that all task bodies have been elaborated.

      if not All_Elaborated then
         raise Program_Error;
      end if;

      Defer_Abortion;

      Write_Lock (This_Task.L, Error);
      This_Task.Activation_Count := 0;

      --  Wake up all the tasks so that they can activate themselves.

      LL_Entry_Point := Task_Wrapper'access;

      C := Activation_to_ATCB (Chain_Access.all);
      while C /= null loop

         Write_Lock (C.L, Error);

         --  Note that the locks of the activator and created task are locked
         --  here.  This is necessary because C.Stage and
         --  This_Task.Activation_Count have to be synchronized.  This is also
         --  done in Complete_Activation and Init_Abortion.  So long as the
         --  activator lock is always locked first, this cannot lead to
         --  deadlock.

         if C.Stage = Utilities.Created then

            --  Create the task
            --  Actual creation of LL_Task is defered until the activation
            --  time

            --  Ask for 4 extra bytes of stack space so that the ATCB
            --  pointer can be stored below the stack limit, plus extra
            --  space for the frame of Task_Wrapper.  This is so the use
            --  gets the amount of stack requested exclusive of the needs
            --  of the runtime.

            Create_LL_Task (
              System.Priority (C.Current_Priority),
              Task_Primitives.Task_Storage_Size (
              Integer (C.Stack_Size) +
              Integer (Task_Primitives.Task_Wrapper_Frame) + 4),
              LL_Entry_Point,
              Utilities.ATCB_To_Address (C),
              C.LL_TCB'access);

            C.Stage := Utilities.Can_Activate;
            Cond_Signal (C.Cond);
            This_Task.Activation_Count := This_Task.Activation_Count + 1;

         end if;

         Unlock (C.L);

         C := C.Activation_Link;
      end loop;

      This_Task.Suspended_Abortably := True;
      while This_Task.Activation_Count > 0 loop
         if This_Task.Pending_Action then
            if This_Task.Pending_Priority_Change then
               Abortion.Change_Base_Priority (This_Task);
            end if;

            exit when
               This_Task.Pending_ATC_Level < This_Task.ATC_Nesting_Level;
            This_Task.Pending_Action := False;
         end if;
         Cond_Wait (This_Task.Cond, This_Task.L);
      end loop;
      This_Task.Suspended_Abortably := False;

      Unlock (This_Task.L);

      Chain_Access.all := null;
      --  After the activation, tasks should be removed from the Chain

      Undefer_Abortion;
      Utilities.Check_Exception;
   end Activate_Tasks;

   -------------------------------
   -- Expunge_Unactivated_Tasks --
   -------------------------------

   procedure Expunge_Unactivated_Tasks (Chain : in out Activation_Chain) is
      This_Task      : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      C              : Utilities.ATCB_Ptr;
      Temp           : Utilities.ATCB_Ptr;
      Result         : Boolean;
   begin

      Defer_Abortion;

      C := Activation_to_ATCB (Chain);

      while C /= null loop

         Error_Reporting.Assert (
           C.Stage <= Utilities.Created,
           "Trying to expunge task which went beyond CREATED stage");

         Temp := C;
         C := C.Activation_Link;

         Utilities.Complete (ATCB_To_ID (Temp));
         --  This will take care of decrementing parent's Await_Count and
         --  Awaited_Dependent_Count.

         Utilities.Remove_From_All_Tasks_List (Temp, Result);
         Error_Reporting.Assert (
           Result,
           "Mismatch between All_Tasks_List and Chain to be expunged");

         Free_ATCB (Temp);
         --  Task is out of Chain and All_Tasks_List. It is now safe to
         --  free the storage for ATCB.

      end loop;

      Chain := null;

      Undefer_Abortion;

   end Expunge_Unactivated_Tasks;

   --------------------
   -- Current_Master --
   --------------------

   function Current_Master return Master_ID is
   begin
      return ID_To_ATCB (Self).Master_Within;
   end Current_Master;

   ------------------------------
   -- Vulnerable_Complete_Task --
   ------------------------------

   --  WARNING : Only call this procedure with abortion deferred.
   --  That's why the name has "Vulnerable" in it.

   --  This procedure needs to have abortion deferred while it has the current
   --  task's lock locked.

   --  This procedure should be called to complete the current task.  This
   --  should be done for:
   --    normal termination via completion;
   --    termination via unhandled exception;
   --    terminate alternative;
   --    abortion.

   procedure Vulnerable_Complete_Task is
      P, T            : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      C               : Utilities.ATCB_Ptr;
      Never_Activated : Boolean;
      Error           : Boolean;

   begin
      --  T.Stage can be safely checked for Can_Activate here without
      --  protection, since T does not get to run until Stage is Can_Activate,
      --  and Vulnerable_Complete_Activation will check to see if it has moved
      --  beyond Complete_Activation under the protection of the mutex
      --  before decrementing the activator's Activation_Count.

      if T.Stage = Utilities.Can_Activate then
         Utilities.Vulnerable_Complete_Activation (T, Completed => True);
      end if;

      --  Note that abortion is deferred (see WARNING above)

      Utilities.Complete (ATCB_To_ID (T));
      if T.Stage = Utilities.Created then
         T.Stage := Utilities.Terminated;
      end if;

      Write_Lock (T.L, Error);

      --  If the task has been awakened due to abortion, this should
      --  cause the dependents to abort themselves and cause the awake
      --  count to go to zero.

      if T.Pending_ATC_Level < T.ATC_Nesting_Level
        and then T.Awake_Count /= 0
      then
         Unlock (T.L);
         Utilities.Abort_Dependents (ATCB_To_ID (T));
         Write_Lock (T.L, Error);
      end if;

      --  At this point we want to complete tasks created by T and not yet
      --  activated, and also mark those tasks as terminated.

      Write_Lock (Utilities.All_Tasks_L, Error);
      Unlock (T.L);

      C := Utilities.All_Tasks_List;

      while C /= null loop

         if C.Parent = T and then C.Stage = Utilities.Created then
            Utilities.Complete (ATCB_To_ID (C));
            C.Stage := Utilities.Terminated;
         end if;

         C := C.All_Tasks_Link;
      end loop;

      Write_Lock (T.L, Error);
      Unlock (Utilities.All_Tasks_L);

      while T.Awake_Count /= 0 loop
         Cond_Wait (T.Cond, T.L);

         if T.Pending_ATC_Level < T.ATC_Nesting_Level
           and then T.Awake_Count /= 0
         then
            --  The task may have been awakened to perform abortion.

            Unlock (T.L);
            Utilities.Abort_Dependents (ATCB_To_ID (T));
            Write_Lock (T.L, Error);
         end if;
      end loop;

      Unlock (T.L);
      Terminate_Dependents;

   end Vulnerable_Complete_Task;

   ----------------
   -- Leave_Task --
   ----------------

   procedure Leave_Task is
      P, T                    : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Saved_Pending_ATC_Level : ATC_Level_Base;
      Error                   : Boolean;

   begin
      Saved_Pending_ATC_Level := T.Pending_ATC_Level;

      --  We are about to lose our ATCB. Save special fields for final cleanup.

      P := T.Parent;

      if P /= null then
         Write_Lock (P.L, Error);
         Write_Lock (T.L, Error);

         --  If T has a parent, then setting T.Stage to Terminted and
         --  incrementing/decrementing P.Terminating_Dependent_Count
         --  have to be synchronized here and in Terminate_Dependents.
         --  This is done by locking the parent and dependent locks.  So
         --  long as the parent lock is always locked first, this should not
         --  cause deadlock.

         T.Stage := Utilities.Terminated;

         if P.Terminating_Dependent_Count > 0
           and then T.Master_of_Task = P.Master_Within
         then
            P.Terminating_Dependent_Count := P.Terminating_Dependent_Count - 1;

            if P.Terminating_Dependent_Count = 0 then
               Cond_Signal (P.Cond);
            end if;
         end if;

         Task_Specific_Data.Destroy_TSD (T.Compiler_Data);
         --  This should be the last thing done to a TCB, since the correct
         --  operation of compiled code may depend on it.

         Unlock (T.L);
         Unlock (P.L);

         --  WARNING - Once this lock is unlocked, it should be assumed that
         --  the ATCB has been deallocated. It should not be accessed again.

      else
         Write_Lock (T.L, Error);
         T.Stage := Utilities.Terminated;

         Task_Specific_Data.Destroy_TSD (T.Compiler_Data);
         --  This should be the last thing done to a TCB, since the correct
         --  operation of compiled code may depend on it.

         Unlock (T.L);
      end if;

      Exit_LL_Task;

   end Leave_Task;

   -------------------
   -- Complete_Task --
   -------------------

   procedure Complete_Task is
   begin
      Defer_Abortion;
      Vulnerable_Complete_Task;
      Undefer_Abortion;
   end Complete_Task;

   -------------------------
   -- Complete_Activation --
   -------------------------

   procedure Complete_Activation is
      Dummy : Boolean;
   begin
      Defer_Abortion;

      Utilities.Vulnerable_Complete_Activation
        (ID_To_ATCB (Self),
         Completed => False);

      Undefer_Abortion;
   end Complete_Activation;

   --------------------------
   -- Terminate_Dependents --
   --------------------------

   --  WARNING : Only call this procedure with abortion deferred.
   --  This procedure needs to have abortion deferred while it has
   --  the current task's lock locked.  This is indicated by the commented
   --  abortion control calls.  Since it is called from two procedures which
   --  also need abortion deferred, it is left controlled on entry to
   --  this procedure.
   --
   --  This relies that all dependents are passive.
   --  That is, they may be :

   --  1) held in COMPLETE_TASK;
   --  2) aborted, with forced-call to COMPLETE_TASK pending;
   --  3) held in terminate-alternative of SELECT.

   procedure Terminate_Dependents (ML : Master_ID := Master_ID'First) is
      Failed   : Boolean;
      Taken    : Boolean;
      T        : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      C        : Utilities.ATCB_Ptr;
      Previous : Utilities.ATCB_Ptr;
      Temp     : Utilities.ATCB_Ptr;
      Error    : Boolean;

   begin
      Write_Lock (Utilities.All_Tasks_L, Error);

      --  Abortion is deferred already (see WARNING above)

      Write_Lock (T.L, Error);

      --  Count the number of active dependents that must terminate before
      --  proceeding.  If Terminating_Dependent_Count is not zero, then the
      --  dependents have already been counted.  This can occur when a thread
      --  executing this routine is canceled and the cancellation takes effect
      --  when Cond_Wait is called to wait for Terminating_Dependent_Count to
      --  go to zero.  In this case we just skip the count and continue waiting
      --  for the count to go to zero.

      if T.Terminating_Dependent_Count = 0 then
         C := Utilities.All_Tasks_List;

         while C /= null loop

            --  The check for C.Stage=ATCB.Terminated and the increment of
            --  T.Terminating_Dependent_Count must be synchronized here and in
            --  Complete_Task using T.L and C.L.  So long as the parent T
            --  is locked before the dependent C, this should not lead to
            --  deadlock.

            if C /= T then
               Write_Lock (C.L, Error);

               if C.Parent = T
                 and then C.Master_of_Task >= ML
                 and then C.Stage /= Utilities.Terminated
               then
                  T.Terminating_Dependent_Count :=
                    T.Terminating_Dependent_Count + 1;
               end if;

               Unlock (C.L);
            end if;

            C := C.All_Tasks_Link;
         end loop;
      end if;

      Unlock (T.L);

      C := Utilities.All_Tasks_List;

      while C /= null loop
         if C.Parent = T and then C.Master_of_Task >= ML then
            Utilities.Complete (ATCB_To_ID (C));
            Cond_Signal (C.Cond);
         end if;

         C := C.All_Tasks_Link;
      end loop;

      Unlock (Utilities.All_Tasks_L);

      Write_Lock (T.L, Error);

      while T.Terminating_Dependent_Count /= 0 loop
         Cond_Wait (T.Cond, T.L);
      end loop;

      Unlock (T.L);

      --  We don't wake up for abortion here, since we are already
      --  terminating just as fast as we can so there is no point.

      Write_Lock (Utilities.All_Tasks_L, Error);
      C := Utilities.All_Tasks_List;
      Previous := null;

      while C /= null loop
         if C.Parent = T
           and then C.Master_of_Task >= ML
         then
            if Previous /= null then
               Previous.All_Tasks_Link := C.All_Tasks_Link;
            else
               Utilities.All_Tasks_List := C.All_Tasks_Link;
            end if;

            Temp := C;
            C := C.All_Tasks_Link;
            Free_ATCB (Temp);

            --  It is OK to free the ATCB provided that the dependent task
            --  does not access its ATCB in Complete_Task after signalling its
            --  parent's (this task) condition variable and unlocking its lock.

         else
            Previous := C;
            C := C.All_Tasks_Link;
         end if;
      end loop;

      Unlock (Utilities.All_Tasks_L);
   end Terminate_Dependents;

   ------------------
   -- Enter_Master --
   ------------------

   procedure Enter_Master is
      T : Utilities.ATCB_Ptr := ID_To_ATCB (Self);

   begin
      T.Master_Within := Increment_Master (T.Master_Within);
   end Enter_Master;

   ---------------------
   -- Complete_Master --
   ---------------------

   procedure Complete_Master is
      T          : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      C          : Utilities.ATCB_Ptr;
      CM         : Master_ID := T.Master_Within;
      Taken      : Boolean;
      Asleep     : Boolean;
      TAS_Result : Boolean;
      Error      : Boolean;

   begin
      Defer_Abortion;

      Write_Lock (Utilities.All_Tasks_L, Error);

      --  Cancel threads of dependent tasks that have not yet started
      --  activation.

      C := Utilities.All_Tasks_List;

      while C /= null loop
         if C.Parent = T and then C.Master_of_Task = CM then
            Write_Lock (C.L, Error);

            --  The only way that a dependent should not have been activated
            --  at this point is if the master was aborted before it could
            --  call Activate_Tasks.  Abort such dependents.

            if C.Stage = Utilities.Created then
               Unlock (C.L);
               Utilities.Complete (ATCB_To_ID (C));
               C.Stage := Utilities.Terminated;
               --  Task is not yet activated. So, just complete and
               --  Mark it as Terminated.
            else
               Unlock (C.L);
            end if;

         end if;

         C := C.All_Tasks_Link;
      end loop;

      --  Note that Awaited_Dependent_Count must be zero at this point.  It is
      --  initialized to zero, this is the only code that can increment it
      --  when it is zero, and it will be zero again on exit from this routine.

      Write_Lock (T.L, Error);
      C := Utilities.All_Tasks_List;

      while C /= null loop
         if C.Parent = T and then C.Master_of_Task = CM then
            Write_Lock (C.L, Error);

            if C.Awake_Count /= 0 then
               T.Awaited_Dependent_Count := T.Awaited_Dependent_Count + 1;
            end if;

            Unlock (C.L);
         end if;

         C := C.All_Tasks_Link;
      end loop;

      Unlock (Utilities.All_Tasks_L);

      --  If the task has been awakened due to abortion, this should
      --  cause the dependents to abort themselves and cause
      --  Awaited_Dependent_Count count to go to zero.

      if T.Pending_ATC_Level < T.ATC_Nesting_Level
        and then T.Awaited_Dependent_Count /= 0
      then
         Unlock (T.L);
         Utilities.Abort_Dependents (ATCB_To_ID (T));
         Write_Lock (T.L, Error);
      end if;

      T.Stage := Utilities.Await_Dependents;

      while T.Awaited_Dependent_Count /= 0 loop
         Cond_Wait (T.Cond, T.L);

         if T.Pending_ATC_Level < T.ATC_Nesting_Level
           and then T.Awaited_Dependent_Count /= 0
         then
            --  The task may have been awakened to perform abortion.

            Unlock (T.L);
            Utilities.Abort_Dependents (ATCB_To_ID (T));
            Write_Lock (T.L, Error);
         end if;

      end loop;

      Unlock (T.L);

      if T.Pending_ATC_Level < T.ATC_Nesting_Level then
         Undefer_Abortion;
         Error_Reporting.Assert (False, "Continuing after being aborted!");
      end if;

      Terminate_Dependents (CM);

      T.Stage := Utilities.Active;

      --  Make next master level up active.  This needs to be done before
      --  decrementing the master level number, so that tasks finding
      --  themselves dependent on the current master level do not think that
      --  this master has been terminated (i.e. Stage=Await_Dependents and
      --  Awaited_Dependent_Count=0).  This should be safe; the only thing that
      --  can affect the stage of a task after it has become active is either
      --  the task itself or abortion, which is deferred here.

      T.Master_Within := Decrement_Master (CM);

      --  Should not need protection; can only change if T executes an
      --  Enter_Master or a Complete_Master.  T is only one task, and cannot
      --  execute these while executing this.

      Undefer_Abortion;

   end Complete_Master;

   ----------------
   -- Terminated --
   ----------------

   function Terminated (T : Task_ID) return Boolean is
   begin
      --  Does not need protection; access is assumed to be atomic.
      --  Why is this assumption made, is pragma Atomic applied proprly???

      return ID_To_ATCB (T).Stage = Utilities.Terminated;
   end Terminated;

   -----------------------------------
   -- Tasking System Initialization --
   -----------------------------------

begin
   Init_RTS (Compiler_Options.Main_Priority);
end System.Tasking.Stages;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.23
--  date: Wed Aug  3 14:57:24 1994;  author: giering
--  Activate_Task takes Activation_Chain_Access as a parameter to allow
--   direct modification of the accessed Activation_Chain variable
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.24
--  date: Thu Aug 18 17:57:26 1994;  author: giering
--  Remove_From_All_Tasks_List moved to Utilities and became shared.
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.25
--  date: Mon Aug 22 18:11:29 1994;  author: giering
--  Complete_Task completes the tasks created by the activator which are
--   not yet activated. Also mark them as terminated.
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
