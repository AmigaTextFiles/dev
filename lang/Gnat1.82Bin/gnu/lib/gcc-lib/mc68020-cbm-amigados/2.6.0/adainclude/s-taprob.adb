------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--      S Y S T E M . T A S K I N G . P R O T E C T E D _ O B J E C T S     --
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

with System.Compiler_Exceptions;
--  Used for, "="
--            Raise_Exceptions
--            Exception_ID
--            Compiler_Exceptions.Null_Exception
--            Program_Error_ID

with System.Error_Reporting;
--  Used for, System.Error_Reporting.Assert

with System.Tasking.Abortion;
--  Used for, Abortion.Defer_Abortion,
--            Abortion.Undefer_Abortion,
--            Abortion.Change_Base_Priority

with System.Task_Primitives; use System.Task_Primitives;

with System.Tasking.Queuing; use System.Tasking.Queuing;
--  Used for, Queuing.Enqueue,
--            Queuing.Dequeue,
--            Queuing.Head,
--            Queuing.Dequeue_Head,
--            Queuing.Count_Waiting,
--            Queuing.Select_Protected_Entry_Call

with System.Tasking.Utilities;
--  Used for, Utilities.ATCB_Ptr,
--            Utilities.ATCB_To_ID,
--            Utilities.ID_To_ATCB,
--            Utilities.Abort_To_Level

with System.Tasking.Stages;
pragma Elaborate_All (System.Tasking.Stages);
--  Just for elaboration.

with Unchecked_Conversion;

package body System.Tasking.Protected_Objects is

   procedure Assert (B : Boolean; M : String)
     renames Error_Reporting.Assert;

   function ID_To_ATCB (ID : Task_ID) return Utilities.ATCB_Ptr
     renames Tasking.Utilities.ID_To_ATCB;

   function ATCB_To_ID (Ptr : Utilities.ATCB_Ptr) return Task_ID
     renames Utilities.ATCB_To_ID;

   procedure Defer_Abortion
     renames Abortion.Defer_Abortion;

   procedure Undefer_Abortion
     renames Abortion.Undefer_Abortion;

   function "=" (L, R : Utilities.ATCB_Ptr) return Boolean
     renames Utilities."=";

   function "=" (L, R : Compiler_Exceptions.Exception_ID) return Boolean
     renames Compiler_Exceptions."=";

   function Address_To_Protection_Access is new
     Unchecked_Conversion (System.Address, Protection_Access);

   function Protection_Access_To_Address is new
     Unchecked_Conversion (Protection_Access, System.Address);

   -----------------------------
   -- Raise_Pending_Exception --
   -----------------------------

   procedure Raise_Pending_Exception (Block : Communication_Block) is
      T  : Utilities.ATCB_Ptr := ID_To_ATCB (Block.Self);
      Ex : Compiler_Exceptions.Exception_ID := T.Exception_To_Raise;
   begin

      T.Exception_To_Raise := Compiler_Exceptions.Null_Exception;
      Compiler_Exceptions.Raise_Exception (Ex);
   end Raise_Pending_Exception;

   ---------------------------
   -- Initialize_Protection --
   ---------------------------

   procedure Initialize_Protection
     (Object           : Protection_Access;
      Ceiling_Priority : Integer)
   is
      Init_Priority : Integer := Ceiling_Priority;

   begin
      if Init_Priority = Unspecified_Priority then
         Init_Priority := System.Default_Priority;
      end if;

      Initialize_Lock (Init_Priority, Object.L);
      Object.Ceiling := System.Priority (Init_Priority);
      Object.Pending_Action := False;
      Object.Pending_Call := null;
      Object.Call_In_Progress := null;

      for E in Object.Entry_Queues'range loop
         Object.Entry_Queues (E).Head := null;
         Object.Entry_Queues (E).Tail := null;
      end loop;
   end Initialize_Protection;

   -------------------------
   -- Finalize_Protection --
   -------------------------

   procedure Finalize_Protection (Object : Protection_Access) is
   begin
      --  Need to purge entry queues and pending entry call here. ???

      Finalize_Lock (Object.L);
   end Finalize_Protection;

   -------------------
   -- Internal_Lock --
   -------------------

   procedure Internal_Lock
     (Object : Protection_Access;
      Ceiling_Violation : out Boolean) is
   begin
      Write_Lock (Object.L, Ceiling_Violation);
   end Internal_Lock;

   -----------------------------
   -- Internal_Lock_Read_Only --
   -----------------------------

   procedure Internal_Lock_Read_Only
     (Object : Protection_Access;
      Ceiling_Violation : out Boolean) is
   begin
      Read_Lock (Object.L, Ceiling_Violation);
   end Internal_Lock_Read_Only;

   ----------
   -- Lock --
   ----------

   procedure Lock (Object : Protection_Access) is
      Ceiling_Violation : Boolean;
   begin
      Internal_Lock (Object, Ceiling_Violation);
      if Ceiling_Violation then
         raise Program_Error;
      end if;
   end Lock;

   --------------------
   -- Lock_Read_Only --
   --------------------

   procedure Lock_Read_Only (Object : Protection_Access) is
      Ceiling_Violation : Boolean;
   begin
      Internal_Lock_Read_Only (Object, Ceiling_Violation);
      if Ceiling_Violation then
         raise Program_Error;
      end if;
   end Lock_Read_Only;

   ------------
   -- Unlock --
   ------------

   procedure Unlock (Object : Protection_Access) is
      Caller : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Error  : Boolean;
   begin
      if Object.Pending_Action then
         Object.Pending_Action := False;
         Write_Lock (Caller.L, Error);
         Caller.New_Base_Priority := Object.Old_Base_Priority;
         Abortion.Change_Base_Priority (Caller);
         Unlock (Caller.L);
      end if;
      Unlock (Object.L);
   end Unlock;

   --------------------------
   -- Protected_Entry_Call --
   --------------------------

   procedure Protected_Entry_Call
     (Object    : Protection_Access;
      E         : Protected_Entry_Index;
      Uninterpreted_Data : System.Address;
      Mode      : Call_Modes;
      Block     : out Communication_Block)
   is
      Level : ATC_Level;
      Caller : Utilities.ATCB_Ptr := ID_To_ATCB (Self);

   begin
      Block.Self := ATCB_To_ID (Caller);
      Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level + 1;
      Level := Caller.ATC_Nesting_Level;

      Object.Pending_Call := Caller.Entry_Calls (Level)'access;

      --  The caller's lock is not needed here.  The call record does not
      --  need protection, since other tasks only access these records
      --  when they are queued, which this one is not.  The Pending_Call
      --  field is protected, and will be until the call is removed by
      --  Next_Entry_Call.

      Object.Pending_Call.Next := null;
      Object.Pending_Call.Call_Claimed := False;
      Object.Pending_Call.Mode := Mode;
      Object.Pending_Call.Abortable := True;
      Object.Pending_Call.Done := False;
      Object.Pending_Call.E := Entry_Index (E);
      Object.Pending_Call.Prio := Caller.Current_Priority;
      Object.Pending_Call.Uninterpreted_Data := Uninterpreted_Data;
      Object.Pending_Call.Called_PO := Protection_Access_To_Address (Object);

      Object.Pending_Call.Called_Task := Null_Task;
      Object.Pending_Call.Exception_To_Raise :=
        Compiler_Exceptions.Null_Exception;

   end Protected_Entry_Call;

   --------------------------------------------
   -- Vulnerable_Cancel_Protected_Entry_Call --
   --------------------------------------------

   procedure Vulnerable_Cancel_Protected_Entry_Call
     (Caller         : Utilities.ATCB_Ptr;
      Call           : Entry_Call_Link;
      PO             : Protection_Access;
      Call_Cancelled : out Boolean)
   is
      TAS_Result : Boolean;
      Ceiling_Violation : Boolean;
      Old_Base_Priority : System.Priority;

   begin
      Test_And_Set (Call.Call_Claimed'Address, TAS_Result);

      if TAS_Result then

         Internal_Lock (PO, Ceiling_Violation);
         if Ceiling_Violation then
            Write_Lock (Caller.L, Ceiling_Violation);
            Old_Base_Priority := Caller.Base_Priority;
            Caller.New_Base_Priority := PO.Ceiling;
            Abortion.Change_Base_Priority (Caller);
            Unlock (Caller.L);
            Lock (PO);
            PO.Old_Base_Priority := Old_Base_Priority;
            PO.Pending_Action := True;
         end if;

         if Onqueue (Call) then
            Dequeue (PO.Entry_Queues (Protected_Entry_Index (Call.E)), Call);
         end if;

      else
         Write_Lock (Caller.L, Ceiling_Violation);

         while not Call.Done loop
            Cond_Wait (Caller.Rend_Cond, Caller.L);
         end loop;

         Unlock (Caller.L);
      end if;

      Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level - 1;

      Write_Lock (Caller.L, Ceiling_Violation);

      if Caller.Pending_ATC_Level = Caller.ATC_Nesting_Level then
         Caller.Pending_ATC_Level := ATC_Level_Infinity;
         Caller.Aborting := False;
      end if;

      Unlock (Caller.L);

      --   If we have reached the desired ATC nesting level, reset the
      --   requested level to effective infinity, to allow further calls.

      Caller.Exception_To_Raise := Call.Exception_To_Raise;
      Call_Cancelled := TAS_Result;

   end Vulnerable_Cancel_Protected_Entry_Call;

   -------------------------
   -- Wait_For_Completion --
   -------------------------

   --  Control flow procedure.
   --  Abortion must be deferred before calling this procedure.

   procedure Wait_For_Completion
     (Call_Cancelled : out Boolean;
      Block          : in out Communication_Block)
   is
      Caller     : Utilities.ATCB_Ptr := ID_To_ATCB (Block.Self);
      Call       : Entry_Call_Link;
      PO         : Protection_Access;
      Error : Boolean;

   begin

      Assert (Caller.ATC_Nesting_Level > ATC_Level_Base'First,
        "Attempt to wait on a nonexistant protected entry call.");

      Call := Caller.Entry_Calls (Caller.ATC_Nesting_Level)'access;

      Assert (Call.Mode = Simple_Call,
        "Attempt to wait on a on a conditional or asynchronous call");

      PO := Address_To_Protection_Access (Call.Called_PO);

      Write_Lock (Caller.L, Error);

      if Call.Abortable then
         Caller.Suspended_Abortably := True;

         while not Call.Done loop
            if Caller.Pending_Action then
               if Caller.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Caller);
                  --  requeue call at new priority
                  Unlock (Caller.L);
                  Lock (PO);
                  if Onqueue (Call) then  --  Dequeued by proxy?
                     Dequeue (PO.Entry_Queues (
                       Protected_Entry_Index (Call.E)), Call);
                     Enqueue (PO.Entry_Queues (
                       Protected_Entry_Index (Call.E)), Call);
                  end if;
                  Unlock (PO);
                  Write_Lock (Caller.L, Error);
               end if;

               exit when
                  Caller.Pending_ATC_Level < Caller.ATC_Nesting_Level;
               Caller.Pending_Action := False;
            end if;
            Cond_Wait (Caller.Cond, Caller.L);
         end loop;

         Caller.Suspended_Abortably := False;

      else
         while not Call.Done loop
            Cond_Wait (Caller.Cond, Caller.L);
         end loop;
      end if;

      Unlock (Caller.L);

      Vulnerable_Cancel_Protected_Entry_Call
        (Caller, Call, PO, Call_Cancelled);

   end Wait_For_Completion;

   ---------------------------------
   -- Cancel_Protected_Entry_Call --
   ---------------------------------

   procedure Cancel_Protected_Entry_Call
     (Call_Cancelled : out Boolean;
      Block          : in out Communication_Block)
   is
      Caller     : Utilities.ATCB_Ptr := ID_To_ATCB (Block.Self);
      Call       : Entry_Call_Link;
      PO         : Protection_Access;
      TAS_Result : Boolean;
      Cancelled  : Boolean;

   begin
      Defer_Abortion;

      Assert (Caller.ATC_Nesting_Level > ATC_Level_Base'First,
        "Attempt to cancel a nonexistant task entry call.");

      Call := Caller.Entry_Calls (Caller.ATC_Nesting_Level)'access;

      Assert (Call.Mode = Asynchronous_Call,
        "Attempt to cancel a conditional or simple call");

      Assert (Call.Called_Task = Null_Task,
        "Attempt to use Cancel_Protected_Entry_Call on task entry call.");

      PO := Address_To_Protection_Access (Call.Called_PO);
      Vulnerable_Cancel_Protected_Entry_Call (Caller, Call, PO, Cancelled);
      Undefer_Abortion;

      Call_Cancelled := Cancelled;
   end Cancel_Protected_Entry_Call;

   --------------------------
   -- Wait_Until_Abortable --
   --------------------------

   procedure Wait_Until_Abortable (Block : in out Communication_Block) is
      Caller     : Utilities.ATCB_Ptr := ID_To_ATCB (Block.Self);
      Call       : Entry_Call_Link;
      PO         : Protection_Access;
      Error : Boolean;
   begin
      Assert (Caller.ATC_Nesting_Level > ATC_Level_Base'First,
        "Attempt to wait for a nonexistant call to be abortable.");
      Call := Caller.Entry_Calls (Caller.ATC_Nesting_Level)'access;
      Assert (Call.Mode = Asynchronous_Call,
        "Attempt to wait for a non-asynchronous call to be abortable");
      PO := Address_To_Protection_Access (Call.Called_PO);

      Write_Lock (Caller.L, Error);
      while not Call.Abortable loop
         Cond_Wait (Caller.Cond, Caller.L);
      end loop;
      Unlock (Caller.L);
   end Wait_Until_Abortable;

   ---------------------
   -- Next_Entry_Call --
   ---------------------

   --   This procedure assumes that a task will have to enter the eggshell to
   --   cancel a call, so there is no need to check for cancellation here.
   --   This seems to obviate the need to lock the task at this point, since
   --   the task will be forced to wait before doing the cancellation, meaning
   --   that it will not take place.

   procedure Next_Entry_Call
     (Object    : Protection_Access;
      Barriers  : Barrier_Vector;
      Uninterpreted_Data : out System.Address;
      E         : out Protected_Entry_Index)
   is
      TAS_Result        : Boolean;
   begin
      Object.Call_In_Progress := null;
      if Object.Pending_Call /= null then

         Assert (Self = Object.Pending_Call.Self,
           "Pending call handled by a task that did not pend it.");

         --   Note that the main cost of the above assertion is likely
         --   to be the call to Self.  If this is not optimized away,
         --   nulling out Assert will not be of much value.

         if Barriers (Protected_Entry_Index (Object.Pending_Call.E)) then
            Test_And_Set
              (Object.Pending_Call.Call_Claimed'Address, TAS_Result);

            if TAS_Result then
               Object.Call_In_Progress := Object.Pending_Call;
            else
               Object.Pending_Call := null;
            end if;

         else
            Enqueue (
              Object.Entry_Queues (
              Protected_Entry_Index (Object.Pending_Call.E)),
              Object.Pending_Call);
         end if;

         Object.Pending_Call := null;
      end if;

      if Object.Call_In_Progress = null then
         Select_Protected_Entry_Call
           (Object,
            Barriers,
            Object.Call_In_Progress);
      end if;

      if Object.Call_In_Progress /= null then
         E := Protected_Entry_Index (Object.Call_In_Progress.E);
         Uninterpreted_Data := Object.Call_In_Progress.Uninterpreted_Data;

      else
         E := Null_Protected_Entry;
      end if;

   end Next_Entry_Call;

   -------------------------
   -- Complete_Entry_Body --
   -------------------------

   procedure Complete_Entry_Body
     (Object           : Protection_Access;
      Pending_Serviced : out Boolean)
   is
   begin
      Exceptional_Complete_Entry_Body
        (Object, Pending_Serviced, Compiler_Exceptions.Null_Exception);

   end Complete_Entry_Body;

   -------------------------------------
   -- Exceptional_Complete_Entry_Body --
   -------------------------------------

   procedure Exceptional_Complete_Entry_Body
     (Object           : Protection_Access;
      Pending_Serviced : out Boolean;
      Ex               : Compiler_Exceptions.Exception_ID)
   is
      Caller : Utilities.ATCB_Ptr :=
                    ID_To_ATCB (Object.Call_In_Progress.Self);
      Error : Boolean;

   begin
      Pending_Serviced := False;
      Object.Call_In_Progress.Exception_To_Raise := Ex;

      if Object.Pending_Call /= null then
         Assert (Object.Pending_Call = Object.Call_In_Progress,
           "Serviced a protected entry call when another was pending");

         Pending_Serviced := True;
         Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level - 1;
         Object.Pending_Call := null;
      end if;

      --   If we have completed a pending entry call, pop it and set the
      --   Pending_Serviced flag to indicate that it is complete.

      Write_Lock (Caller.L, Error);
      Object.Call_In_Progress.Done := True;
      Unlock (Caller.L);

      if Object.Call_In_Progress.Mode = Asynchronous_Call then
         Utilities.Abort_To_Level
           (ATCB_To_ID (Caller), Object.Call_In_Progress.Level - 1);

      elsif Object.Call_In_Progress.Mode = Simple_Call then
         Cond_Signal (Caller.Cond);
      end if;

   end Exceptional_Complete_Entry_Body;

   -----------------------------
   -- Requeue_Protected_Entry --
   -----------------------------

   procedure Requeue_Protected_Entry
     (Object     : Protection_Access;
      New_Object : Protection_Access;
      E          : Protected_Entry_Index;
      With_Abort : Boolean)
   is
   begin
      Object.Call_In_Progress.Abortable := With_Abort;
      Object.Call_In_Progress.E := Entry_Index (E);

      if With_Abort then
         Object.Call_In_Progress.Call_Claimed := False;
      end if;

      if Object = New_Object then
         Enqueue (New_Object.Entry_Queues (E), Object.Call_In_Progress);
      else
         New_Object.Pending_Call := Object.Call_In_Progress;
      end if;

   end Requeue_Protected_Entry;

   -------------------------------------
   -- Requeue_Task_To_Protected_Entry --
   -------------------------------------

   procedure Requeue_Task_To_Protected_Entry
     (New_Object : Protection_Access;
      E          : Protected_Entry_Index;
      With_Abort : Boolean)
   is
      Old_Acceptor : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Entry_Call : Entry_Call_Link;
      Error : Boolean;

   begin
      Write_Lock (Old_Acceptor.L, Error);
      Entry_Call := Old_Acceptor.Call;
      Old_Acceptor.Call := null;
      Unlock (Old_Acceptor.L);
      Entry_Call.Abortable := With_Abort;
      Entry_Call.E := Entry_Index (E);
      Entry_Call.Called_PO := Protection_Access_To_Address (New_Object);

      if With_Abort then
         Entry_Call.Call_Claimed := False;
      end if;

      New_Object.Pending_Call := Entry_Call;
   end Requeue_Task_To_Protected_Entry;

   ---------------------
   -- Protected_Count --
   ---------------------

   function Protected_Count
     (Object : Protection;
      E      : Protected_Entry_Index)
      return   Natural
   is
   begin
      return Count_Waiting (Object.Entry_Queues (E));
   end Protected_Count;

   -----------------------------
   -- Broadcast_Program_Error --
   -----------------------------

   procedure Broadcast_Program_Error
     (Object        : Protection_Access) is
      Entry_Call    : Entry_Call_Link;
      Current_Task  : Utilities.ATCB_Ptr;
      Raise_In_Self : Boolean := True;
      Error : Boolean;

   begin
      for E in Object.Entry_Queues'range loop
         Dequeue_Head (Object.Entry_Queues (E), Entry_Call);

         while Entry_Call /= null loop
            Current_Task := ID_To_ATCB (Entry_Call.Self);
            Entry_Call.Exception_To_Raise :=
              Compiler_Exceptions.Program_Error_ID;
            Write_Lock (Current_Task.L, Error);
            Entry_Call.Done := True;
            Unlock (Current_Task.L);

            case Entry_Call.Mode is

               when Simple_Call =>
                  Utilities.Abort_To_Level
                    (ATCB_To_ID (Current_Task), Entry_Call.Level - 1);

               when Conditional_Call =>
                  Assert (False, "Conditional call found on entry queue.");

               when Asynchronous_Call =>
                  Utilities.Abort_To_Level
                    (ATCB_To_ID (Current_Task), Entry_Call.Level - 1);

            end case;

            Dequeue_Head (Object.Entry_Queues (E), Entry_Call);
         end loop;
      end loop;
   end Broadcast_Program_Error;

end System.Tasking.Protected_Objects;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.14
--  date: Wed Jul 13 10:29:13 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  revision 1.15
--  date: Thu Aug  4 15:40:16 1994;  author: giering
--  (Internal_Lock, Internal_Lock_Read_Only): Made Ceiling_Violation an
--   out parameter.
--  Added pragma Elaborate_All (System.Tasking.Stages) so that protected
--   objects can be used in the absence of tasks.
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.16
--  date: Fri Aug  5 16:44:42 1994;  author: giering
--  (Wait_For_Completion):  Fixed to return the Call_Completed parameter
--   from Vulnerable_Cancel_Protected_Entry_Call in the Call_Completed
--   parameter of Wait_For_Completion.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
