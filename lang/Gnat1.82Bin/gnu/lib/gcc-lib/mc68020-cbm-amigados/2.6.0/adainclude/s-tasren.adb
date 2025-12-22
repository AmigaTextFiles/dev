-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--            S Y S T E M . T A S K I N G . R E N D E Z V O U S            --
--                                                                         --
--                                 B o d y                                 --
--                                                                         --
--                            $Revision: 1.18 $                             --
--                                                                         --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                         --
-- GNARL is free software; you can redistribute it and/or modify it  under --
-- terms  of  the  GNU  Library General Public License as published by the --
-- Free Software Foundation; either version 2,  or (at  your  option)  any --
-- later  version.   GNARL is distributed in the hope that it will be use- --
-- ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL; see --
-- file COPYING. If not, write to the Free Software Foundation,  675  Mass --
-- Ave, Cambridge, MA 02139, USA.                                          --
--                                                                         --
-----------------------------------------------------------------------------

with System.Task_Primitives; use System.Task_Primitives;

with System.Tasking.Abortion;
--  Used for, Abortion.Defer_Abortion,
--            Abortion.Undefer_Abortion,
--            Abortion.Change_Base_Priority

with System.Tasking.Queuing; use System.Tasking.Queuing;
--  Used for, Queuing.Enqueue,
--            Queuing.Dequeue,
--            Queuing.Dequeue_Head,
--            Queuing.Count_Waiting,
--            Queuing.Select_Task_Entry_Call

with System.Error_Reporting;
--  Used for, Error_Reporting.Assert

with System.Tasking.Utilities;
--  Used for, Utilities.ATCB_Ptr,
--            Utilities.ATCB_To_ID,
--            Utilities.ID_To_ATCB,
--            Utilities.Null_PO;
--            Utilities."<",
--            Utilities.">=",
--            Utilities."=",
--            Utilities.Task_Stage
--            Utilities.Accepting_State
--            Utilities.Vulnerable_Complete_Activation
--            Utilities.Abort_To_Level
--            Utilities.Reset_Priority
--            Utilities.Terminate_Alternative

with System.Compiler_Exceptions;
--  Used for, Compiler_Exceptions."="
--            Exception_ID
--            Null_Exception
--            Tasking_Error_ID

with Unchecked_Conversion;

package body System.Tasking.Rendezvous is

   function ID_To_ATCB (ID : Task_ID) return Utilities.ATCB_Ptr
     renames Tasking.Utilities.ID_To_ATCB;

   function ATCB_To_ID (Ptr : Utilities.ATCB_Ptr) return Task_ID
     renames Utilities.ATCB_To_ID;

   procedure Assert (B : Boolean; M : String)
     renames Error_Reporting.Assert;

   procedure Defer_Abortion
     renames Abortion.Defer_Abortion;

   procedure Undefer_Abortion renames
     Abortion.Undefer_Abortion;

   --  Following should be replaced by use type ???

   function "<" (L, R : Utilities.Task_Stage) return Boolean
     renames Utilities."<";

   function ">=" (L, R : Utilities.Task_Stage) return Boolean
     renames Utilities.">=";

   function "=" (L, R : Utilities.Accepting_State) return Boolean
     renames Utilities."=";

   function "=" (L, R : Compiler_Exceptions.Exception_ID)
     return Boolean renames Compiler_Exceptions."=";

   function Address_To_Protection_Access is new
     Unchecked_Conversion (System.Address, Protection_Access);

   function Protection_Access_To_Address is new
     Unchecked_Conversion (Protection_Access, System.Address);

   type Select_Treatment is (
     Accept_Alternative_Selected,
     Accept_Alternative_Completed,
     Else_Selected,
     Terminate_Selected,
     Accept_Alternative_Open,
     No_Alternative_Open);

   Default_Treatment : constant array (Select_Modes) of Select_Treatment :=
     (Simple_Mode         => No_Alternative_Open,
      Else_Mode           => Else_Selected,
      Terminate_Mode      => Terminate_Selected);

   -----------------------
   -- Local Subprograms --
   -----------------------

   procedure Boost_Priority
     (Call     : Entry_Call_Link;
      Acceptor : Utilities.ATCB_Ptr);
   pragma Inline (Boost_Priority);

   procedure Test_Call
     (Entry_Call           : in out Entry_Call_Link;
      Rendezvous_Completed : out Boolean);
   --  Test if a rendezvous can be made right away. Returns True if the
   --  rendezvous has occurred (and finished).
   --  Problem: Try not to call this when the acceptor is not accepting.
   --  What does problem mean??? advice??? why??? absolute rule???

   function Test_Selective_Wait
     (Acceptor     : Utilities.ATCB_Ptr;
      Open_Accepts : Accept_List_Access;
      Select_Mode  : Select_Modes)
      return         Select_Treatment;
   pragma Inline (Test_Selective_Wait);
   --  Test if there is a call waiting on any entry, and whether any selects
   --  are open. Set Acceptor.Chosen_Index to selected alternative if an
   --  accept alternative can be selected.

   procedure Universal_Complete_Rendezvous
     (Ex : Compiler_Exceptions.Exception_ID);
   pragma Inline (Universal_Complete_Rendezvous);
   --  Called by acceptor to wake up caller and optionally propagate exception

   --------------------
   -- Boost_Priority --
   --------------------

   procedure Boost_Priority
     (Call     : Entry_Call_Link;
      Acceptor : Utilities.ATCB_Ptr)
   is
      Caller : Utilities.ATCB_Ptr := ID_To_ATCB (Call.Self);

   begin
      if Get_Priority (Caller.LL_TCB'access) >
         Get_Priority (Acceptor.LL_TCB'access)
      then
         Call.Acceptor_Prev_Priority := Acceptor.Current_Priority;
         Acceptor.Current_Priority := Caller.Current_Priority;
         Set_Priority (Acceptor.LL_TCB'access, Acceptor.Current_Priority);
      else
         Call.Acceptor_Prev_Priority := Priority_Not_Boosted;
      end if;
   end Boost_Priority;

   ---------------
   -- Test_Call --
   ---------------

   procedure Test_Call
     (Entry_Call           : in out Entry_Call_Link;
      Rendezvous_Completed : out Boolean)
   is
      Temp_Entry  : Entry_Index;
      TAS_Result  : Boolean;
      Acceptor_ID : Task_ID;
      Acceptor    : Utilities.ATCB_Ptr;
      Caller      : Utilities.ATCB_Ptr := ID_To_ATCB (Entry_Call.Self);
      Error       : Boolean;

   begin
      Acceptor := ID_To_ATCB (Entry_Call.Called_Task);

      if Acceptor.Accepting = Utilities.Trivial_Accept then
         Temp_Entry := Entry_Index (Acceptor.Open_Accepts (1).S);

         --  Case of rendezvous accepted

         if Entry_Call.E = Temp_Entry then
            Acceptor.Accepting := Utilities.Not_Accepting;
            Entry_Call.Acceptor_Prev_Call := Acceptor.Call;
            Acceptor.Call := Entry_Call;
            Entry_Call.Done := True;
            Rendezvous_Completed := True;
            Cond_Signal (Acceptor.Cond); -- Inefficient ???

         --  Case of wait for acceptor

         else
            Rendezvous_Completed := False;
         end if;

      elsif Acceptor.Accepting = Utilities.Not_Accepting then
         if Callable (ATCB_To_ID (Acceptor)) then

            --  Wait for acceptor

            Rendezvous_Completed := False;

         else
            if Entry_Call.Mode /= Asynchronous_Call then
               Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level - 1;
            end if;

            Unlock (Acceptor.L);
            Undefer_Abortion;
            raise Tasking_Error;
         end if;

      else
         --  Try to do immediate rendezvous

         for J in Acceptor.Open_Accepts'range loop
            Temp_Entry := Entry_Index (Acceptor.Open_Accepts (J).S);

            if Entry_Call.E = Temp_Entry then --  do rendezvous
               Test_And_Set (Entry_Call.Call_Claimed'Address, TAS_Result);

               if not TAS_Result then

                  --  This task has been aborted

                  Unlock (Acceptor.L);
                  Write_Lock (Caller.L, Error);
                  Caller.Suspended_Abortably := True;

                  loop
                     if Caller.Pending_Action then
                        if Caller.Pending_Priority_Change then
                           Abortion.Change_Base_Priority (Caller);
                        end if;

                        exit when
                           Caller.Pending_ATC_Level < Caller.ATC_Nesting_Level;
                        Caller.Pending_Action := False;
                     end if;
                     Cond_Wait (Caller.Rend_Cond, Caller.L);
                  end loop;

                  Caller.Suspended_Abortably := False;
                  Unlock (Caller.L);
                  Write_Lock (Acceptor.L, Error);

               end if;

               Acceptor.Accepting := Utilities.Not_Accepting;

               if Acceptor.Open_Accepts (J).Null_Body then
                  Entry_Call.Done := True;
                  Acceptor.Chosen_Index := J;
                  Cond_Signal (Acceptor.Cond);
               else
                  Entry_Call.Acceptor_Prev_Call := Acceptor.Call;
                  Acceptor.Call := Entry_Call;
                  Acceptor.Chosen_Index := J;
                  Boost_Priority (Entry_Call, Acceptor);
                  Cond_Signal (Acceptor.Cond);

                  --  This needs to be protected by the caller's mutex, not
                  --  the acceptor's.  Otherwise, there is a risk of loosing a
                  --  signal.  This is dumb code, and probably could be
                  --  fixed to some extent by getting rid of Test_Call. ???

                  Unlock (Acceptor.L);
                  Write_Lock (Caller.L, Error);

                  while not Entry_Call.Done loop
                     Cond_Wait (Caller.Rend_Cond, Caller.L);
                  end loop;

                  Unlock (Caller.L);
                  Write_Lock (Acceptor.L, Error);
               end if;

               Rendezvous_Completed := True;
               return;
            end if;
         end loop;

         Rendezvous_Completed := False;
      end if;
   end Test_Call;

   ---------------------------------------
   -- Vulnerable_Cancel_Task_Entry_Call --
   ---------------------------------------

   procedure Vulnerable_Cancel_Task_Entry_Call
     (Call                  : Entry_Call_Link;
      Cancel_Was_Successful : out Boolean)
   is
      TAS_Result : Boolean;
      Caller     : Utilities.ATCB_Ptr := ID_To_ATCB (Call.Self);
      Acceptor   : Utilities.ATCB_Ptr := ID_To_ATCB (Call.Called_Task);
      Error      : Boolean;

   begin
      Cancel_Was_Successful := False;
      Test_And_Set (Call.Call_Claimed'Address, TAS_Result);

      if TAS_Result then
         if not Call.Done then

         --  We should be able to check this flag at this point; we have
         --  claimed the call, so no one will be able to service this call,
         --  so no one else should be able to change the Call.Done flag.

            Write_Lock (Acceptor.L, Error);
            if Onqueue (Call) then
               Dequeue (
                  Acceptor.Entry_Queues (Task_Entry_Index (Call.E)),
                  Call);
            end if;
            Unlock (Acceptor.L);
            Cancel_Was_Successful := True;

            --  Note: this will indicate failure to cancel if the acceptor has
            --  canceled the call due to completion.  Of course, we are going
            --  to raise an exception in that case, so I think that this is
            --  OK; the flag retuned to the application code should never be
            --  used.
         end if;

      else
         Write_Lock (Caller.L, Error);

         while not Call.Done loop
            Cond_Wait (Caller.Rend_Cond, Caller.L);
         end loop;

         Unlock (Caller.L);
      end if;

      Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level - 1;

      Write_Lock (Caller.L, Error);

      if Caller.Pending_ATC_Level = Caller.ATC_Nesting_Level then
         Caller.Pending_ATC_Level := ATC_Level_Infinity;
         Caller.Aborting := False;
      end if;

      Unlock (Caller.L);

      --  If we have reached the desired ATC nesting level, reset the
      --  requested level to effective infinity, to allow further calls.

      Caller.Exception_To_Raise := Call.Exception_To_Raise;

   end Vulnerable_Cancel_Task_Entry_Call;

   -----------------
   -- Call_Simple --
   -----------------

   procedure Call_Simple
     (Acceptor  : Task_ID;
      E         : Task_Entry_Index;
      Uninterpreted_Data : System.Address)
   is
      Caller : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);

      Acceptor_ATCB         : Utilities.ATCB_Ptr := ID_To_ATCB (Acceptor);
      Rendezvous_Completed  : Boolean;
      Level                 : ATC_Level;
      Entry_Call            : Entry_Call_Link;
      Cancel_Was_Successful : Boolean;
      Error                 : Boolean;

   begin
      Defer_Abortion;
      Write_Lock (Acceptor_ATCB.L, Error);
      Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level + 1;
      Level := Caller.ATC_Nesting_Level;

      Entry_Call := Caller.Entry_Calls (Level)'access;

      Entry_Call.Next := null;
      Entry_Call.Call_Claimed := False;
      Entry_Call.Mode := Simple_Call;
      Entry_Call.Abortable := True;
      Entry_Call.Done := False;
      Entry_Call.E := Entry_Index (E);
      Entry_Call.Prio := Caller.Current_Priority;
      Entry_Call.Uninterpreted_Data := Uninterpreted_Data;
      Entry_Call.Called_Task := Acceptor;
      Entry_Call.Exception_To_Raise := Compiler_Exceptions.Null_Exception;

      Test_Call (Entry_Call, Rendezvous_Completed);

      if not Rendezvous_Completed then
         Enqueue (Acceptor_ATCB.Entry_Queues (E), Entry_Call);
         Unlock (Acceptor_ATCB.L);
         Write_Lock (Caller.L, Error);
         Caller.Suspended_Abortably := True;

         while not Entry_Call.Done loop
            if Caller.Pending_Action then
               if Caller.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Caller);
                  --  requeue call at new priority
                  Unlock (Caller.L);
                  Write_Lock (Acceptor_ATCB.L, Error);
                  if Onqueue (Entry_Call) then  --  Dequeued by acceptor?
                     Dequeue (Acceptor_ATCB.Entry_Queues (E), Entry_Call);
                     Enqueue (Acceptor_ATCB.Entry_Queues (E), Entry_Call);
                  end if;
                  Unlock (Acceptor_ATCB.L);
                  Write_Lock (Caller.L, Error);
               end if;

               exit when
                  Caller.Pending_ATC_Level < Caller.ATC_Nesting_Level and then
                  not Entry_Call.Call_Claimed;
            end if;
            Cond_Wait (Caller.Rend_Cond, Caller.L);
         end loop;

         Caller.Suspended_Abortably := False;
         Unlock (Caller.L);

      else
         Unlock (Acceptor_ATCB.L);
      end if;

      --  NOTICE:
      --  There is a distinction made between asynchronous calls and the rest:
      --  The asynchronous calls are always cleaned up by
      --  Cancel_Task_Entry_Call, but the others get cleaned up by
      --  Task_Entry_Call or its equivalent.
      --  Complete no longer does a decrement, so who does if this task is
      --  aborted at this point?  The decrement should take
      --  place before undeferring abortion, and that this should include
      --  taking the call off any queue it might be on.
      --  Problem: What if it is claimed in the meantime by an acceptor?  The
      --  test for Call_Claimed in the wait loop is really vulnerable to race
      --  conditions on this point.  We can't get out of the loop until
      --  Call_Claimed is false, but there is nothing to keep it from
      --  staying false.  By the time we get here, rendezvous could be in
      --  progress.  The only solution is to claim the call here in order
      --  to cancel it.  However, what do we do if we loose?  Wait again?
      --  I think so.  I also think that that works: wait until done or
      --  aborted; if aborted, attempt to cancel the call; if that fails, wait
      --  until the call (now well and truly started) completes, without
      --  benefit of Suspended_Abortably.
      --  Problem: The acceptor might also claim the call on completion, to
      --  cancel it.  In that case, it has already awakened us, and won't do it
      --  again.
      --  I think this is OK.  Close_Entries already pretends that the
      --  call has been completed, and has already set the exception at that
      --  point.

      Vulnerable_Cancel_Task_Entry_Call (Entry_Call, Cancel_Was_Successful);
      Undefer_Abortion;

      Assert (Caller.Pending_ATC_Level >= Caller.ATC_Nesting_Level,
        "Continuing after aborting self!");

      Utilities.Check_Exception;
   end Call_Simple;

   ----------------------------
   -- Cancel_Task_Entry_Call --
   ----------------------------

   procedure Cancel_Task_Entry_Call (Cancelled : out Boolean) is
      Caller   : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Call     : Entry_Call_Link;
      Acceptor : Utilities.ATCB_Ptr;

   begin
      Assert (Caller.ATC_Nesting_Level > ATC_Level_Base'First,
        "Attempt to cancel nonexistant task entry call.");

      Call := Caller.Entry_Calls (Caller.ATC_Nesting_Level)'access;

      Assert (Call.Mode = Asynchronous_Call,
        "Attempt to perform ATC on a non-asynchronous task entry call");
      Assert (Address_To_Protection_Access (Call.Called_PO) =
          Utilities.Null_PO,
        "Attempt to use Cancel_Task_Entry_Call on protected entry call.");

      Acceptor := ID_To_ATCB (Call.Called_Task);
      Defer_Abortion;
      Vulnerable_Cancel_Task_Entry_Call (Call, Cancelled);
      Undefer_Abortion;
      Utilities.Check_Exception;
   end Cancel_Task_Entry_Call;

   ------------------------
   -- Requeue_Task_Entry --
   ------------------------

   procedure Requeue_Task_Entry
     (Acceptor   : Task_ID;
      E          : Task_Entry_Index;
      With_Abort : Boolean)
   is
      Old_Acceptor  : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Entry_Call    : Entry_Call_Link;
      Acceptor_ATCB : Utilities.ATCB_Ptr := ID_To_ATCB (Acceptor);
      Error         : Boolean;

   begin
      Write_Lock (Old_Acceptor.L, Error);
      Entry_Call := Old_Acceptor.Call;
      Old_Acceptor.Call := null;
      Unlock (Old_Acceptor.L);

      Entry_Call.Abortable := With_Abort;
      Entry_Call.E := Entry_Index (E);

      if With_Abort then
         Entry_Call.Call_Claimed := False;
      end if;

      Write_Lock (Acceptor_ATCB.L, Error);
      Enqueue (Acceptor_ATCB.Entry_Queues (E), Entry_Call);
      Unlock (Acceptor_ATCB.L);
   end Requeue_Task_Entry;

   -------------------------------------
   -- Requeue_Protected_To_Task_Entry --
   -------------------------------------

   procedure Requeue_Protected_To_Task_Entry
     (Object     : Protection_Access;
      Acceptor   : Task_ID;
      E          : Task_Entry_Index;
      With_Abort : Boolean)
   is
      Old_Acceptor  : Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Entry_Call    : Entry_Call_Link;
      Acceptor_ATCB : Utilities.ATCB_Ptr := ID_To_ATCB (Acceptor);
      Error         : Boolean;

   begin
      Object.Call_In_Progress.Abortable := With_Abort;
      Object.Call_In_Progress.E := Entry_Index (E);

      if With_Abort then
         Object.Call_In_Progress.Call_Claimed := False;
      end if;

      Write_Lock (Acceptor_ATCB.L, Error);
      Enqueue (Acceptor_ATCB.Entry_Queues (E), Object.Call_In_Progress);
      Unlock (Acceptor_ATCB.L);
   end Requeue_Protected_To_Task_Entry;

   ---------------------
   -- Task_Entry_Call --
   ---------------------

   procedure Task_Entry_Call
     (Acceptor              : Task_ID;
      E                     : Task_Entry_Index;
      Uninterpreted_Data             : System.Address;
      Mode                  : Call_Modes;
      Rendezvous_Successful : out Boolean)
   is
      Caller        : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Acceptor_ATCB : Utilities.ATCB_Ptr := ID_To_ATCB (Acceptor);

      Rendezvous_Completed  : Boolean;
      Entry_Call            : Entry_Call_Link;
      Cancel_Was_Successful : Boolean;
      Error                 : Boolean;

   begin
      --  Simple call

      if Mode = Simple_Call then
         Call_Simple (Acceptor, E, Uninterpreted_Data);
         Rendezvous_Successful := True;
         return;

      --  Conditional call

      elsif Mode = Conditional_Call then
         Defer_Abortion;
         Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level + 1;

         Entry_Call := Caller.Entry_Calls (Caller.ATC_Nesting_Level)'access;

         Entry_Call.Next := null;
         Entry_Call.Call_Claimed := False;
         Entry_Call.Mode := Mode;
         Entry_Call.Abortable := True;
         Entry_Call.Done := False;
         Entry_Call.E := Entry_Index (E);
         Entry_Call.Prio := Caller.Current_Priority;
         Entry_Call.Uninterpreted_Data := Uninterpreted_Data;
         Entry_Call.Called_Task := Acceptor;
         Entry_Call.Exception_To_Raise := Compiler_Exceptions.Null_Exception;
         Write_Lock (Acceptor_ATCB.L, Error);
         Test_Call (Entry_Call, Rendezvous_Completed);
         Unlock (Acceptor_ATCB.L);

         Vulnerable_Cancel_Task_Entry_Call (Entry_Call, Cancel_Was_Successful);

         Undefer_Abortion;

         Assert (Caller.Pending_ATC_Level >= Caller.ATC_Nesting_Level,
           "Continuing after aborting self!");

         Utilities.Check_Exception;
         Rendezvous_Successful := Entry_Call.Done;
         return;

      --  Asynchronous call

      else
         Defer_Abortion;
         Caller.ATC_Nesting_Level := Caller.ATC_Nesting_Level + 1;

         Entry_Call := Caller.Entry_Calls (Caller.ATC_Nesting_Level)'access;

         Entry_Call.Next := null;
         Entry_Call.Call_Claimed := False;
         Entry_Call.Mode := Mode;
         Entry_Call.Abortable := True;
         Entry_Call.Done := False;
         Entry_Call.E := Entry_Index (E);
         Entry_Call.Prio := Caller.Current_Priority;
         Entry_Call.Uninterpreted_Data := Uninterpreted_Data;
         Entry_Call.Called_Task := Acceptor;
         Entry_Call.Called_PO :=
             Protection_Access_To_Address (Utilities.Null_PO);
         Entry_Call.Exception_To_Raise := Compiler_Exceptions.Null_Exception;

         Write_Lock (Acceptor_ATCB.L, Error);
         Test_Call (Entry_Call, Rendezvous_Completed);

         if not Rendezvous_Completed then
            Enqueue (Acceptor_ATCB.Entry_Queues (E), Entry_Call);
         end if;

         Unlock (Acceptor_ATCB.L);
         Undefer_Abortion;
         Rendezvous_Successful := Entry_Call.Done;

         --  Amazingly, this seems to be all the work that is needed.

         --  Asynchronous calls are set up so that they are always explicitly
         --  canceled in in the compiled code. It might be worth considering
         --  unifying the various calls, and explitely cancelling all of them.
         --  This is not very efficiant, unfortunately.  Perhaps this call
         --  should unify them, with other calls for optimization?  Then who
         --  would want to use this call???

      end if;
   end Task_Entry_Call;

   -----------------
   -- Accept_Call --
   -----------------

   procedure Accept_Call
     (E         : Task_Entry_Index;
      Uninterpreted_Data : out System.Address)
   is
      Acceptor     : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Caller       : Utilities.ATCB_Ptr := null;
      TAS_Result   : Boolean;
      Open_Accepts : aliased Accept_List (1 .. 1);
      Entry_Call   : Entry_Call_Link;
      Error        : Boolean;

   begin
      Defer_Abortion;
      Write_Lock (Acceptor.L, Error);

      --  If someone is completing this task, it must be because they plan
      --  to abort it.  This task should not try to access its pending entry
      --  calls or queues in this case, as they are being emptied.  Wait for
      --  abortion to kill us.

      if Acceptor.Stage >= Utilities.Completing then

         loop
            if Acceptor.Pending_Action then
               if Acceptor.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Acceptor);
               end if;

               exit when
                  Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level;
               Acceptor.Pending_Action := False;
            end if;
            Cond_Wait (Acceptor.Cond, Acceptor.L);
         end loop;

         Unlock (Acceptor.L);
         Undefer_Abortion;
         Assert (False, "Continuing execution after being aborted.");
      end if;

      loop
         Dequeue_Head (Acceptor.Entry_Queues (E), Entry_Call);

         if Entry_Call /= null then
            Test_And_Set (Entry_Call.Call_Claimed'Address, TAS_Result);
            exit when TAS_Result;

            --  TAS_Result = False only when the caller is already aborted or
            --  timed out; in that case, go on to the next caller on the queue
         else
            exit;
         end if;
      end loop;

      if Entry_Call /= null then
         Caller := ID_To_ATCB (Entry_Call.Self);
         Boost_Priority (Entry_Call, Acceptor);
         Entry_Call.Acceptor_Prev_Call := Acceptor.Call;
         Acceptor.Call := Entry_Call;
         Uninterpreted_Data := Entry_Call.Uninterpreted_Data;

      else
         --  Wait for a caller

         Open_Accepts (1).Null_Body := false;
         Open_Accepts (1).S := E;
         Acceptor.Open_Accepts := Open_Accepts'access;

         Acceptor.Accepting := Utilities.Simple_Accept;

         --  Wait for normal call

         Acceptor.Suspended_Abortably := True;

         while Acceptor.Accepting /= Utilities.Not_Accepting loop
            if Acceptor.Pending_Action then
               if Acceptor.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Acceptor);
               end if;

               exit when
                  Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level;
               Acceptor.Pending_Action := False;
            end if;
            Cond_Wait (Acceptor.Cond, Acceptor.L);
         end loop;

         Acceptor.Suspended_Abortably := False;

         if Acceptor.Pending_ATC_Level >= Acceptor.ATC_Nesting_Level then
            Caller := ID_To_ATCB (Acceptor.Call.Self);
            Uninterpreted_Data :=
              Caller.Entry_Calls (Caller.ATC_Nesting_Level).Uninterpreted_Data;
         end if;

         --  If this task has been aborted, skip the Uninterpreted_Data load
         --  (Caller will not be reliable) and fall through to
         --  Undefer_Abortion which will allow the task to be killed.
      end if;

      --  At this point, the call has been claimed, either by the acceptor
      --  or by the caller on behalf of the acceptor.

      --  Acceptor.Call should already be updated by the Caller

      Unlock (Acceptor.L);
      Undefer_Abortion;

      --  Start rendezvous
   end Accept_Call;

   --------------------
   -- Accept_Trivial --
   --------------------

   procedure Accept_Trivial (E : Task_Entry_Index) is
      Acceptor     : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Caller       : Utilities.ATCB_Ptr := null;
      TAS_Result   : Boolean;
      Open_Accepts : aliased Accept_List (1 .. 1);
      Entry_Call   : Entry_Call_Link;
      Error        : Boolean;

   begin
      Defer_Abortion;
      Write_Lock (Acceptor.L, Error);

      --  If someone is completing this task, it must be because they plan
      --  to abort it.  This task should not try to access its pending entry
      --  calls or queues in this case, as they are being emptied.  Wait for
      --  abortion to kill us.

      if Acceptor.Stage >= Utilities.Completing then

         loop
            if Acceptor.Pending_Action then
               if Acceptor.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Acceptor);
               end if;

               exit when
                  Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level;
               Acceptor.Pending_Action := False;
            end if;
            Cond_Wait (Acceptor.Cond, Acceptor.L);
         end loop;

         Unlock (Acceptor.L);
         Undefer_Abortion;
         Assert (False, "Continuing execution after being aborted.");
      end if;

      loop
         Dequeue_Head (Acceptor.Entry_Queues (E), Entry_Call);

         if Entry_Call = null then

            --  Need to wait for call

            Open_Accepts (1).Null_Body := False;
            Open_Accepts (1).S := E;
            Acceptor.Open_Accepts := Open_Accepts'access;

            Acceptor.Accepting := Utilities.Trivial_Accept;

            --  Wait for normal entry call

            Acceptor.Suspended_Abortably := True;

            while Acceptor.Accepting /= Utilities.Not_Accepting loop
               if Acceptor.Pending_Action then
                  if Acceptor.Pending_Priority_Change then
                     Abortion.Change_Base_Priority (Acceptor);
                  end if;

                  exit when
                     Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level;
                  Acceptor.Pending_Action := False;
               end if;
               Cond_Wait (Acceptor.Cond, Acceptor.L);
            end loop;


            if Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level then
               Unlock (Acceptor.L);
               Undefer_Abortion;
               Assert (False, "Continuing after being aborted!");
            else
               Acceptor.Suspended_Abortably := False;
               Entry_Call := Acceptor.Call;
               Acceptor.Call := Entry_Call.Acceptor_Prev_Call;
               Caller := ID_To_ATCB (Entry_Call.Self);

               if Entry_Call.Mode = Asynchronous_Call then
                  Utilities.Abort_To_Level
                   (ATCB_To_ID (Caller),
                    Entry_Call.Level);
               end if;

               Unlock (Acceptor.L);
            end if;

            exit;
         end if;

         Test_And_Set (Entry_Call.Call_Claimed'Address, TAS_Result);

         if TAS_Result then

            --  Caller is waiting; there is no accept body

            Caller := ID_To_ATCB (Entry_Call.Self);
            Unlock (Acceptor.L);
            Write_Lock (Caller.L, Error);
            Entry_Call.Done := True;

            --  Done with mutex locked to make sure that signal is not lost.

            Unlock (Caller.L);
            Entry_Call.Call_Claimed := False;

            if Entry_Call.Mode = Asynchronous_Call then
               Utilities.Abort_To_Level (
                 ATCB_To_ID (Caller), Entry_Call.Level);
            else
               Cond_Signal (Caller.Rend_Cond);
            end if;

            exit;
         end if;

         --  TAS_Result = False only when the caller is already aborted or has
         --  timed out; in that case, we go on to the next caller on the queue

      end loop;

      Undefer_Abortion;
   end Accept_Trivial;

   -----------------------------------
   -- Universal_Complete_Rendezvous --
   -----------------------------------

   procedure Universal_Complete_Rendezvous
     (Ex : Compiler_Exceptions.Exception_ID)
   is
      Acceptor      : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Caller        : Utilities.ATCB_Ptr;
      Call          : Entry_Call_Link;
      Prev_Priority : Rendezvous_Priority;
      Error         : Boolean;

   begin
      Defer_Abortion;
      Call := Acceptor.Call;
      Acceptor.Call := Call.Acceptor_Prev_Call;
      Prev_Priority := Call.Acceptor_Prev_Priority;
      Call.Exception_To_Raise := Ex;
      Caller := ID_To_ATCB (Call.Self);
      Call.Call_Claimed := False;
      Write_Lock (Caller.L, Error);
      Call.Done := True;
      Unlock (Caller.L);

      if Call.Mode = Asynchronous_Call then
         Utilities.Abort_To_Level (ATCB_To_ID (Caller), Call.Level);
      else
         Cond_Signal (Caller.Rend_Cond);
      end if;

      Utilities.Reset_Priority (Prev_Priority, ATCB_To_ID (Acceptor));

      Acceptor.Exception_To_Raise := Ex;

      --  Save the exception for Complete_Rendezvous.

      Undefer_Abortion;
   end Universal_Complete_Rendezvous;

   -------------------------
   -- Complete_Rendezvous --
   -------------------------

   procedure Complete_Rendezvous is
   begin
      Universal_Complete_Rendezvous (Compiler_Exceptions.Null_Exception);
   end Complete_Rendezvous;

   -------------------------------------
   -- Exceptional_Complete_Rendezvous --
   -------------------------------------

   procedure Exceptional_Complete_Rendezvous
     (Ex : Compiler_Exceptions.Exception_ID)
   is
   begin
      Universal_Complete_Rendezvous (Ex);
   end Exceptional_Complete_Rendezvous;

   -------------------------
   -- Test_Selective_Wait --
   -------------------------


   function Test_Selective_Wait
     (Acceptor     : Utilities.ATCB_Ptr;
      Open_Accepts : Accept_List_Access;
      Select_Mode  : Select_Modes) return Select_Treatment
   is
      Temp_Entry : Task_Entry_Index;
      TAS_Result : Boolean;
      Treatment  : Select_Treatment;
      Entry_Call : Entry_Call_Link;
      Caller     : Utilities.ATCB_Ptr;
      Error      : Boolean;
      Selection  : Select_Index;
   begin
      Treatment := Default_Treatment (Select_Mode);
      Acceptor.Chosen_Index := No_Rendezvous;

      Select_Task_Entry_Call (Acceptor, Open_Accepts, Entry_Call, Selection);

      if Entry_Call /= null then
         if Open_Accepts (Selection).Null_Body then
            Caller := ID_To_ATCB (Entry_Call.Self);
            Entry_Call.Call_Claimed := False;
            Write_Lock (Caller.L, Error);
            Entry_Call.Done := True;
            Unlock (Caller.L);
            if Entry_Call.Mode = Asynchronous_Call then
               Utilities.Abort_To_Level (
               ATCB_To_ID (Caller),
               Entry_Call.Level);
            else
               Cond_Signal (Caller.Rend_Cond);
            end if;
            Treatment := Accept_Alternative_Completed;
         else
            Boost_Priority (Entry_Call, Acceptor);
            Entry_Call.Acceptor_Prev_Call := Acceptor.Call;
            Acceptor.Call := Entry_Call;
            Treatment := Accept_Alternative_Selected;
         end if;
         Acceptor.Chosen_Index := Selection;
      elsif Treatment = No_Alternative_Open then
         Treatment := Accept_Alternative_Open;
      end if;

      --  Do rendezvous

      return Treatment;

   end Test_Selective_Wait;

   --------------------
   -- Selective_Wait --
   --------------------

   procedure Selective_Wait
     (Open_Accepts : Accept_List_Access;
      Select_Mode  : Select_Modes;
      Uninterpreted_Data    : out System.Address;
      Index        : out Select_Index)
   is
      Acceptor  : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Treatment : Select_Treatment;
      I_Result  : Integer;
      Error     : Boolean;

   begin
      Defer_Abortion;
      Write_Lock (Acceptor.L, Error);

      --  If someone is completing this task, it must be because they plan
      --  to abort it.  This task should not try to access its pending entry
      --  calls or queues in this case, as they are being emptied.  Wait for
      --  abortion to kill us.

      if Acceptor.Stage >= Utilities.Completing then

         loop
            if Acceptor.Pending_Action then
               if Acceptor.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Acceptor);
               end if;

               exit when
                  Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level;
               Acceptor.Pending_Action := False;
            end if;
            Cond_Wait (Acceptor.Cond, Acceptor.L);
         end loop;

         Undefer_Abortion;
         Assert (False, "Continuing execution after being aborted.");
      end if;

      Treatment := Test_Selective_Wait (Acceptor, Open_Accepts, Select_Mode);

      case Treatment is

      when Accept_Alternative_Selected =>

         --  Ready to rendezvous already

         Uninterpreted_Data := Acceptor.Call.Uninterpreted_Data;

      when Accept_Alternative_Completed =>

         --  Rendezvous is over

         null;

      when Accept_Alternative_Open =>

         --  Wait for caller.

         Acceptor.Open_Accepts := Open_Accepts;

         Acceptor.Accepting := Utilities.Select_Wait;
         Acceptor.Suspended_Abortably := True;

         while Acceptor.Accepting /= Utilities.Not_Accepting
         loop
            if Acceptor.Pending_Action then
               if Acceptor.Pending_Priority_Change then
                  Abortion.Change_Base_Priority (Acceptor);
               end if;

               exit when
                  Acceptor.Pending_ATC_Level < Acceptor.ATC_Nesting_Level;
               Acceptor.Pending_Action := False;
            end if;
            Cond_Wait (Acceptor.Cond, Acceptor.L);
         end loop;

         Acceptor.Suspended_Abortably := False;

         if Acceptor.Pending_ATC_Level >= Acceptor.ATC_Nesting_Level and then
          not Open_Accepts (Acceptor.Chosen_Index).Null_Body then
            Uninterpreted_Data := Acceptor.Call.Uninterpreted_Data;
         end if;

         --  Acceptor.Call should already be updated by the Caller if
         --  not aborted.

      when Else_Selected =>
         Acceptor.Accepting := Utilities.Not_Accepting;

      when Terminate_Selected =>

         --  Terminate alternative is open

         Acceptor.Open_Accepts := Open_Accepts;

         Acceptor.Accepting := Utilities.Select_Wait;

         --  We need to check if a signal is pending on an open interrupt
         --  entry. Otherwise this task would become passive (since terminate
         --  alternative is open) and, if none of the siblings are active
         --  anymore, the task could not wake up anymore, even though a
         --  signal might be pending on an open interrupt entry.

         Unlock (Acceptor.L);
         Utilities.Terminate_Alternative;

         --  Wait for normal entry call or termination

         --  consider letting Terminate_Alternative assume mutex L
         --  is already locked, and return with it locked, so
         --  this code could be simplified???

         --  No return here if Acceptor completes, otherwise
         --  Acceptor.Call should already be updated by the Caller

         Index := Acceptor.Chosen_Index;
         if not Open_Accepts (Acceptor.Chosen_Index).Null_Body then
            Uninterpreted_Data := Acceptor.Call.Uninterpreted_Data;
         end if;
         Undefer_Abortion;
         return;

      when No_Alternative_Open =>

         --  Acceptor.Chosen_Index := No_Rendezvous; => Program_Error ???

         null;

      end case;

      --  Caller has been chosen

      --  Acceptor.Call should already be updated by the Caller

      --  Acceptor.Chosen_Index should either be updated by the Caller
      --  or by Test_Selective_Wait

      Index := Acceptor.Chosen_Index;
      Unlock (Acceptor.L);
      Undefer_Abortion;

      --  Start rendezvous

   end Selective_Wait;

   ----------------
   -- Task_Count --
   ----------------

   function Task_Count (E : Task_Entry_Index) return Natural is
      T            : constant Utilities.ATCB_Ptr := ID_To_ATCB (Self);
      Return_Count : Natural;
      Error        : Boolean;

   begin
      Write_Lock (T.L, Error);
      Return_Count := Count_Waiting (T.Entry_Queues (E));
      Unlock (T.L);
      return Return_Count;
   end Task_Count;

   --------------
   -- Callable --
   --------------

   function Callable (T : Task_ID) return Boolean is
   begin
      return     ID_To_ATCB (T).Stage < Utilities.Complete
        and then ID_To_ATCB (T).Pending_ATC_Level > ATC_Level_Base'First;
   end Callable;

end System.Tasking.Rendezvous;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.16
--  date: Tue Jul 26 12:56:27 1994;  author: giering
--  (Selective_Wait): Returned index of the chosen alternative in the
--   select list array, rather than the entry index of chosen alternative.
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.17
--  date: Wed Jul 27 21:54:45 1994;  author: giering
--  Not passing Uninterpreted_Data for Null_Body accept.
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.18
--  date: Fri Aug  5 16:45:15 1994;  author: giering
--  (Test_Selective_Wait): Set Acceptor.Chosen_Index in the Null_Body
--   case.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
