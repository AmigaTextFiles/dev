------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                S Y S T E M . T A S K _ P R I M I T I V E S               --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.16 $                             --
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

with System.Task_Clock;
--  Used for, Stimespec,
--            Stimespec_Seconds,
--            Stimespec_NSeconds

with Interfaces.C.POSIX_timers;
--  Used for, timespec,
--            Nanoseconds

with Interfaces.C.POSIX_Error;
--  Used for, Return_Code,
--            Failure,
--            Get_Error_Code,
--            Interrupted_Operation,
--            Resource_Temporarily_Unavailable,
--            Priority_Ceiling_Violation

with Interfaces.C.POSIX_RTE;
--  Used for, Signal,
--            Signal_Set,
--            Add_Signal,
--            Delete_Signal,
--            Delete_All_Signals,
--            sigprocmask,
--            siginfo_ptr,
--            struct_sigaction,
--            sigaction,
--            Is_Member,
--            and various CONSTANTS

with Interfaces.C.Pthreads; use Interfaces.C.Pthreads;

with Unchecked_Deallocation;

with Unchecked_Conversion;

package body System.Task_Primitives is

   package RTE renames POSIX_RTE;

   Failure : Interfaces.C.POSIX_Error.Return_Code
      renames Interfaces.C.POSIX_Error.Failure;

   Test_And_Set_Mutex : Lock;
   --  Use a mutex to simulate test-and-set.  This is ridiculously inefficient;
   --  it is just here so that I can fix the syntax errors without having to
   --  worry about how to get machine code into the system in the absense
   --  of machine code inserts.

   Abort_Signal : constant RTE.Signal := RTE.SIGUSR1;

   function "=" (L, R : System.Address) return Boolean
     renames System."=";

   ATCB_Key : pthread_key_t;

   Abort_Handler : Abort_Handler_Pointer;

   LL_Signals       : RTE.Signal_Set;
   Task_Signal_Mask : RTE.Signal_Set;

   Reserved_Signals : RTE.Signal_Set;

   Assertions_Checked : constant Boolean := True;

   procedure Put_Character (C : Integer);
   pragma Import (C, Put_Character, "putchar");

   procedure Prog_Exit (Status : Integer);
   pragma Import (C, Prog_Exit, "exit");

   function Pointer_to_Address is new
     Unchecked_Conversion (TCB_Ptr, System.Address);

   function Address_to_Pointer is new
     Unchecked_Conversion (System.Address, TCB_Ptr);

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Get_Stack_Limit return System.Address;
   pragma Inline (Get_Stack_Limit);
   --  Obtains stack limit from TCB

   procedure Assert (B : Boolean; M : String);
   pragma Inline (Assert);
   --  Output string M if B is True and Assertions_Checked

   procedure Write_Character (C : Character);
   procedure Write_EOL;
   procedure Write_String (S : String);
   --  Debugging procedures used for assertion output

   ---------------------
   -- Write_Character --
   ---------------------

   procedure Write_Character (C : Character) is
   begin
      Put_Character (Character'Pos (C));
   end Write_Character;

   ---------------
   -- Write_Eol --
   ---------------

   procedure Write_EOL is
   begin
      Write_Character (Ascii.LF);
   end Write_EOL;

   ------------------
   -- Write_String --
   ------------------

   procedure Write_String (S : String) is
   begin
      for J in S'range loop
         Write_Character (S (J));
      end loop;
   end Write_String;

   ---------------
   -- LL_Assert --
   ---------------

   procedure LL_Assert (B : Boolean; M : String) is
   begin
      if not B then
         Write_String ("Failed assertion: ");
         Write_String (M);
         Write_String (".");
         Write_EOL;
         Prog_Exit (1);
      end if;
   end LL_Assert;

   ------------
   -- Assert --
   ------------

   procedure Assert (B : Boolean; M : String) is
   begin
      if Assertions_Checked then
         LL_Assert (B, M);
      end if;
   end Assert;

   -------------------------
   -- Initialize_LL_Tasks --
   -------------------------

   procedure Initialize_LL_Tasks (T : TCB_Ptr) is
      Old_Set : RTE.Signal_Set;
      Mask    : RTE.Signal_Set;
      Result  : Interfaces.C.POSIX_Error.Return_Code;

   begin
   --  WARNING : SIGALRM should not be in the following mask.  SIGALRM should
   --          be a normal user signal under 1, and should be enabled
   --          by the client.  However, the current RTS built on 1
   --          uses nanosleep () and pthread_cond_wait (), which fail if all
   --          threads have SIGALRM masked. ???

      RTE.Delete_All_Signals (LL_Signals);
      RTE.Add_Signal (LL_Signals, Abort_Signal);
      RTE.Add_Signal (LL_Signals, RTE.SIGALRM);
      RTE.Add_Signal (LL_Signals, RTE.SIGILL);
      RTE.Add_Signal (LL_Signals, RTE.SIGABRT);
      RTE.Add_Signal (LL_Signals, RTE.SIGFPE);
      RTE.Add_Signal (LL_Signals, RTE.SIGSEGV);
      RTE.Add_Signal (LL_Signals, RTE.SIGPIPE);
      RTE.Add_All_Signals (Task_Signal_Mask);
      RTE.Delete_Signal (Task_Signal_Mask, Abort_Signal);
      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGALRM);
      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGILL);
      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGABRT);
      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGFPE);
      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGSEGV);
      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGPIPE);

      RTE.Delete_Signal (Task_Signal_Mask, RTE.SIGTRAP);
      --  Not POSIX; this is left unmasked to keep SGI dbx happy.

      RTE.Delete_All_Signals (Reserved_Signals);
      RTE.Add_Signal (Reserved_Signals, RTE.SIGILL);
      RTE.Add_Signal (Reserved_Signals, RTE.SIGABRT);
      RTE.Add_Signal (Reserved_Signals, RTE.SIGFPE);
      RTE.Add_Signal (Reserved_Signals, RTE.SIGSEGV);
      RTE.Add_Signal (Reserved_Signals, RTE.SIGPIPE);
      RTE.Add_Signal (Reserved_Signals, Abort_Signal);

      pthread_key_create (ATCB_Key, System.Null_Address, Result);

      if Result = Failure then
         raise Storage_Error;               --  Insufficiant resources.
      end if;

      RTE.sigprocmask (RTE.SIG_SETMASK, Task_Signal_Mask, Old_Set, Result);
      Assert (Result /= Failure, "GNULLI failure---sigprocmask");

      T.LL_Entry_Point := null;

      T.Thread := pthread_self;
      pthread_setspecific (ATCB_Key, Pointer_to_Address (T), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_setspecific");

   end Initialize_LL_Tasks;

   ----------
   -- Self --
   ----------

   function Self return TCB_Ptr is
      Temp   : System.Address;
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_getspecific (ATCB_Key, Temp, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_getspecific");
      return Address_to_Pointer (Temp);
   end Self;

   ---------------------
   -- Initialize_Lock --
   ---------------------

   procedure Initialize_Lock
     (Prio : System.Priority;
      L    : in out Lock)
   is
      Attributes : pthread_mutexattr_t;
      Result     : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_mutexattr_init (Attributes, Result);
      if Result = Failure then
         raise STORAGE_ERROR;  --  should be ENOMEM
      end if;

      pthread_mutexattr_setprotocol (Attributes, PRIO_PROTECT, Result);

      Assert (Result /= Failure,
        "GNULLI failure---pthread_mutexattr_setprotocol");

      pthread_mutexattr_setprio_ceiling
         (Attributes, Interfaces.C.int (Prio), Result);

      Assert (Result /= Failure,
        "GNULLI failure---pthread_mutexattr_setprio_ceiling");

      pthread_mutex_init (pthread_mutex_t (L), Attributes, Result);

      if Result = Failure then
         raise STORAGE_ERROR;  --  should be ENOMEM ???
      end if;
   end Initialize_Lock;

   -------------------
   -- Finalize_Lock --
   -------------------

   procedure Finalize_Lock (L : in out Lock) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_mutex_destroy (pthread_mutex_t (L), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_mutex_destroy");
   end Finalize_Lock;

   ----------------
   -- Write_Lock --
   ----------------

   --  The error code EINVAL indicates either an uninitialized mutex or
   --  a priority ceiling violation. We assume that the former cannot
   --  occur in our system.
   procedure Write_Lock (L : in out Lock; Ceiling_Violation : out Boolean) is
      Result : Interfaces.C.POSIX_Error.Return_Code;
      Ceiling_Error : Boolean;
   begin
      pthread_mutex_lock (pthread_mutex_t (L), Result);
      Ceiling_Error := Result = Failure and then
        Interfaces.C.POSIX_Error.Get_Error_Code =
           Interfaces.C.POSIX_Error.Priority_Ceiling_Violation;
      Assert (Result /= Failure or else Ceiling_Error,
        "GNULLI failure---pthread_mutex_lock");
      Ceiling_Violation := Ceiling_Error;
   end Write_Lock;

   ---------------
   -- Read_Lock --
   ---------------

   procedure Read_Lock (L : in out Lock; Ceiling_Violation : out Boolean) is
   begin
      Write_Lock (L, Ceiling_Violation);
   end Read_Lock;

   ------------
   -- Unlock --
   ------------

   procedure Unlock (L : in out Lock) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_mutex_unlock (pthread_mutex_t (L), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_mutex_unlock");
   end Unlock;

   ---------------------
   -- Initialize_Cond --
   ---------------------

   procedure Initialize_Cond (Cond : in out Condition_Variable) is
      Attributes : pthread_condattr_t;
      Result     : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_condattr_init (Attributes, Result);

      if Result = Failure then
         raise STORAGE_ERROR;  --  should be ENOMEM ???
      end if;

      pthread_cond_init (pthread_cond_t (Cond), Attributes, Result);

      if Result = Failure then
         raise STORAGE_ERROR;  --  should be ENOMEM  ???
      end if;

      pthread_condattr_destroy (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_condattr_destroy");
   end Initialize_Cond;

   -------------------
   -- Finalize_Cond --
   -------------------

   procedure Finalize_Cond (Cond : in out Condition_Variable) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_cond_destroy (pthread_cond_t (Cond), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_cond_destroy");
   end Finalize_Cond;

   ---------------
   -- Cond_Wait --
   ---------------

   procedure Cond_Wait
     (Cond : in out Condition_Variable;
      L    : in out Lock)
   is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_cond_wait (pthread_cond_t (Cond), pthread_mutex_t (L), Result);

      --  EINTR is not considered a failure.  We have been assured that
      --  Pthreads will soon guarantee that a thread will wake up from
      --  a condition variable wait after it handles a signal.  EINTR will
      --  probably go away at that point. ???

      Assert (Result /= Failure or else
        Interfaces.C.POSIX_Error.Get_Error_Code =
           Interfaces.C.POSIX_Error.Interrupted_Operation,
        "GNULLI failure---pthread_cond_wait");

   end Cond_Wait;

   ---------------------
   -- Cond_Timed_Wait --
   ---------------------

   procedure Cond_Timed_Wait
     (Cond      : in out Condition_Variable;
      L         : in out Lock; Abs_Time : Task_Clock.Stimespec;
      Timed_Out : out Boolean)
   is
      Result   : Interfaces.C.POSIX_Error.Return_Code;
      I_Result : Integer;

      function Stimespec_to_timespec (S : Task_Clock.Stimespec)
        return Interfaces.C.POSIX_timers.timespec is
      begin
         return Interfaces.C.POSIX_timers.timespec'
           (tv_sec =>
               Interfaces.C.POSIX_timers.time_t
                  (Task_Clock.Stimespec_Seconds (S)),
            tv_nsec =>
              Interfaces.C.POSIX_timers.Nanoseconds
                 (Task_Clock.Stimespec_NSeconds (S)));
      end Stimespec_to_timespec;

   begin
      pthread_cond_timedwait (
        pthread_cond_t (Cond),
        pthread_mutex_t (L),
        Stimespec_to_timespec (Abs_Time),
        Result);

      Timed_Out := Result = Failure and then
        Interfaces.C.POSIX_Error.Get_Error_Code =
          Interfaces.C.POSIX_Error.Resource_Temporarily_Unavailable;
      Assert (Result /= Failure or else
            Interfaces.C.POSIX_Error.Get_Error_Code =
              Interfaces.C.POSIX_Error.Resource_Temporarily_Unavailable,
            "GNULLI failure---pthread_cond_timedwait");
   end Cond_Timed_Wait;

   -----------------
   -- Cond_Signal --
   -----------------

   procedure Cond_Signal (Cond : in out Condition_Variable) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_cond_signal (pthread_cond_t (Cond), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_cond_signal");
   end Cond_Signal;

   --------------------
   -- Cond_Broadcast --
   --------------------

   procedure Cond_Broadcast (Cond : in out Condition_Variable) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_cond_broadcast (pthread_cond_t (Cond), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_cond_signal");
   end Cond_Broadcast;

   ------------------
   -- Set_Priority --
   ------------------

   procedure Set_Priority (T : TCB_Ptr; Prio : System.Priority) is
      Attributes : pthread_attr_t;
      Result     : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_attr_init (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_init");

      pthread_getschedattr (T.Thread, Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_getschedattr");

      pthread_attr_setprio (Attributes, Priority_Type (Prio), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_setprio");

      pthread_setschedattr (T.Thread, Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_setschedattr");

      pthread_attr_destroy (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_destroy");
   end Set_Priority;

   ----------------------
   -- Set_Own_Priority --
   ----------------------

   procedure Set_Own_Priority (Prio : System.Priority) is
      Attributes : pthread_attr_t;
      Result     : Interfaces.C.POSIX_Error.Return_Code;
   begin
      Set_Priority (Self, Prio);
   end Set_Own_Priority;

   ------------------
   -- Get_Priority --
   ------------------

   function Get_Priority (T : TCB_Ptr) return System.Priority is
      Attributes : pthread_attr_t;
      Prio       : Priority_Type;
      Result     : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_attr_init (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_init");

      pthread_getschedattr (T.Thread, Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_getschedattr");

      pthread_attr_getprio (Attributes, Prio, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_getprio");

      pthread_attr_destroy (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_destroy");

      return System.Priority (Prio);
   end Get_Priority;

   -----------------------
   --  Get_Own_Priority --
   -----------------------

   --  Note: this is specialized (rather than being done using a default
   --  parameter for Get_Priority) in case there is a specially efficient
   --  way of getting your own priority, which might well be the case in
   --  general (although is not the case in Pthreads).

   function Get_Own_Priority return System.Priority is
   begin
      return Get_Priority (Self);
   end Get_Own_Priority;

   ----------------
   -- LL_Wrapper --
   ----------------

   procedure LL_Wrapper (T : TCB_Ptr) is
      Result : Interfaces.C.POSIX_Error.Return_Code;
      Old_Set    : RTE.Signal_Set;

   begin
      pthread_setspecific (ATCB_Key, Pointer_to_Address (T), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_setspecific");

      RTE.sigprocmask (RTE.SIG_UNBLOCK, LL_Signals, Old_Set, Result);
      Assert (Result /= Failure, "GNULLI failure---sigprocmask");

      --  Note that the following call may not return!

      T.LL_Entry_Point (T.LL_Arg);
   end LL_Wrapper;

   --------------------
   -- Create_LL_Task --
   --------------------

   procedure Create_LL_Task
     (Priority       : System.Priority;
      Stack_Size     :  Task_Storage_Size;
      LL_Entry_Point : LL_Task_Procedure_Access;
      Arg            : System.Address;
      T              : TCB_Ptr)
   is
      Attributes : pthread_attr_t;
      Result     : Interfaces.C.POSIX_Error.Return_Code;
      Old_Set    : RTE.Signal_Set;

   begin
      T.LL_Entry_Point := LL_Entry_Point;
      T.LL_Arg := Arg;
      T.Stack_Size := Stack_Size;

      pthread_attr_init (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_init");

      Pthreads.pthread_attr_setdetachstate (Attributes, 1, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_setdetachstate");

      pthread_attr_setstacksize
         (Attributes, Interfaces.C.size_t (Stack_Size), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_setstacksize");

      pthread_attr_setprio (Attributes, Priority_Type (Priority), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_setprio");

      --  It is not safe for the task to be created to accept signals until it
      --  has bound its TCB pointer to the thread with pthread_setspecific ().
      --  The handler wrappers use the TCB pointers to restore the stack limit.

      RTE.sigprocmask (RTE.SIG_BLOCK, LL_Signals, Old_Set, Result);
      Assert (Result /= Failure, "GNULLI failure---sigprocmask");

      pthread_create (
        T.Thread,
        Attributes,
        LL_Wrapper'Address,
        Pointer_to_Address (T),
        Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_create");

      pthread_attr_destroy (Attributes, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_attr_destroy");

      RTE.sigprocmask (RTE.SIG_UNBLOCK, LL_Signals, Old_Set, Result);
      Assert (Result /= Failure, "GNULLI failure---sigprocmask");

   end Create_LL_Task;

   ------------------
   -- Exit_LL_Task --
   ------------------

   procedure Exit_LL_Task is
   begin
      pthread_exit (System.Null_Address);
   end Exit_LL_Task;

   --------------------
   -- Deallocate_TCB --
   --------------------

   procedure Deallocate_TCB (T : in out TCB_Ptr) is
      procedure Old_TCB is new
        Unchecked_Deallocation (Task_Control_Block, TCB_Ptr);

   begin
      Old_TCB (T);
   end Deallocate_TCB;

   ----------------
   -- Abort_Task --
   ----------------

   procedure Abort_Task (T : TCB_Ptr) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_kill (T.Thread, Abort_Signal, Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_kill");
   end Abort_Task;

   ----------------
   -- Test_Abort --
   ----------------

   --  This procedure does nothing.  It is intended for systems without
   --  asynchronous abortion, where the runtime system would have to
   --  synchronously poll for pending abortions.  This should be done
   --  at least at every synchronization point.

   procedure Test_Abort is
   begin
      null;
   end Test_Abort;

   ---------------------
   -- Get_Stack_Limit --
   ---------------------

   function Get_Stack_Limit return System.Address is
   begin
      return Self.Stack_Limit;
   end Get_Stack_Limit;

   -------------------
   -- Abort_Wrapper --
   -------------------

   --  Note that this currently takes System.Address.  The 1 specifies
   --  access procedure (Context : Pre_Call_State) for the handler type.
   --  This may be a mistake of the interface in commiting to this 9X type.
   --  The right way to do it may be to make this a type in Machine_Specifics,
   --  which can then be created with a constructor funciton in one place.
   --  However, Ada 83 compilers are always going to have to take the address
   --  of the procedure, if only to pass it to a constructor function. ???

   --  Isn't above comment obsolete. Certainly the reference to package
   --  Machine_Specifics is obsolete ???

   procedure Abort_Wrapper
     (signo   : Integer;
      info    : RTE.siginfo_ptr;
      context : System.Address)
   is
      function Address_To_Call_State is new
        Unchecked_Conversion (System.Address, Pre_Call_State);

   begin
      Abort_Handler (Address_To_Call_State (context));
   end Abort_Wrapper;

   ---------------------------
   -- Install_Abort_Handler --
   ---------------------------

   procedure Install_Abort_Handler (Handler : Abort_Handler_Pointer) is
      act     : RTE.struct_sigaction;
      old_act : RTE.struct_sigaction;
      Result  : Interfaces.C.POSIX_Error.Return_Code;

   begin
      Abort_Handler := Handler;
      act.sa_handler := Abort_Wrapper'Address;
      RTE.Delete_All_Signals (act.sa_mask);
      act.sa_flags := 0;

      RTE.sigaction (Abort_Signal, act, old_act, Result);
      Assert (Result /= Failure, "GNULLI failure---sigaction");
   end Install_Abort_Handler;

   ---------------------------
   -- Install_Error_Handler --
   ---------------------------

   procedure Install_Error_Handler (Handler : System.Address) is
      act     : RTE.struct_sigaction;
      old_act : RTE.struct_sigaction;
      Result  : Interfaces.C.POSIX_Error.Return_Code;

   begin
      act.sa_handler := Handler;

      RTE.Delete_All_Signals (act.sa_mask);
      RTE.Add_Signal (act.sa_mask, RTE.SIGILL);
      RTE.Add_Signal (act.sa_mask, RTE.SIGABRT);
      RTE.Add_Signal (act.sa_mask, RTE.SIGFPE);
      RTE.Add_Signal (act.sa_mask, RTE.SIGSEGV);
      RTE.Add_Signal (act.sa_mask, RTE.SIGPIPE);
      act.sa_flags := 0;

      RTE.sigaction (RTE.SIGILL, act, old_act, Result);
      Assert (Result /= Failure, "GNULLI failure---sigaction");

      RTE.sigaction (RTE.SIGABRT, act, old_act, Result);
      Assert (Result /= Failure, "GNULLI failure---sigaction");

      RTE.sigaction (RTE.SIGFPE, act, old_act, Result);
      Assert (Result /= Failure, "GNULLI failure---sigaction");

      RTE.sigaction (RTE.SIGSEGV, act, old_act, Result);
      Assert (Result /= Failure, "GNULLI failure---sigaction");

      RTE.sigaction (RTE.SIGPIPE, act, old_act, Result);
      Assert (Result /= Failure, "GNULLI failure---sigaction");
   end Install_Error_Handler;

   -----------------
   -- Signal_Task --
   -----------------

   procedure Signal_Task (T : TCB_Ptr; Int_Id : Interrupt_ID) is
      Result : Interfaces.C.POSIX_Error.Return_Code;

   begin
      pthread_kill (T.Thread, RTE.Signal (Int_Id), Result);
      Assert (Result /= Failure, "GNULLI failure---pthread_kill");
   end Signal_Task;

   ---------------------
   -- Wait_For_Signal --
   ---------------------

   procedure Wait_For_Signal (Int_Id : Interrupt_ID) is
      Temp_Signal : RTE.Signal;
      Result      : Interfaces.C.POSIX_Error.Return_Code;
      Mask        : RTE.Signal_Set;

   begin
      RTE.Delete_All_Signals (Mask);
      RTE.Add_Signal (Mask, RTE.Signal (Int_Id));
      sigwait (Mask, Temp_Signal, Result);
      Assert (Result /= Failure, "GNULLI failure---sigwait");
   end Wait_For_Signal;

   ---------------------
   -- Reserved_Signal --
   ---------------------

   function Reserved_Signal (Int_Id : Interrupt_ID) return Boolean is
   begin
      return RTE.Is_Member (Reserved_Signals, RTE.Signal (Int_Id));
   end Reserved_Signal;

   ------------------
   -- Test_And_Set --
   ------------------

   procedure Test_And_Set (Flag_Add : System.Address; Result : out Boolean) is
      type Access_Boolean is access Boolean;
      Error : Boolean;

      function Address_To_Pointer is new
        Unchecked_Conversion (System.Address, Access_Boolean);

   begin
      Write_Lock (Test_And_Set_Mutex, Error);

      if not Address_To_Pointer (Flag_Add).all then
         Address_To_Pointer (Flag_Add).all := True;
         Unlock (Test_And_Set_Mutex);
         Result :=  True;
      else
         Unlock (Test_And_Set_Mutex);
         Result := False;
      end if;
   end Test_And_Set;

begin
   Initialize_Lock (System.Priority'Last, Test_And_Set_Mutex);
end System.Task_Primitives;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.14
--  date: Fri Aug  5 16:45:59 1994;  author: giering
--  (Write_Lock): Corrected assertion to ignore ceiling errors (this error
--   is passed to the client).
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.15
--  date: Thu Aug 18 17:43:55 1994;  author: giering
--  Accomodating Interfaces.C.POSIX files
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.16
--  date: Wed Aug 31 12:13:32 1994;  author: giering
--  (Set_Priority, Get_Priority, Create_LL_Task): Called
--   pthread_attr_destroy on attribute objects before deallocating them.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
