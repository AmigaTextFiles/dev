------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--              S Y S T E M . T A S K I N G . U T I L I T I E S             --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.5 $                             --
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

--  This package provides RTS Internal Declarations.
--  These declarations are not part of the GNARLI

with System.Task_Primitives;  use System.Task_Primitives;

with System.Compiler_Exceptions;
--  Used for, Tasking_Error_ID

with System.Tasking.Abortion;
--  Used for, Undefer_Abortion,
--            Abort_To_Level

with System.Tasking.Queuing; use System.Tasking.Queuing;
--  Used for, Queuing.Dequeue_Head

with System.Error_Reporting;
--  Used for, Error_Reporting.Assert

package body System.Tasking.Utilities is

   ------------------
   -- Make_Passive --
   ------------------

   --  This is a local procedure

   procedure Make_Passive
     (T : Utilities.ATCB_Ptr);
   --  Record that task T is passive.

   ------------------------------------
   -- Vulnerable_Complete_Activation --
   ------------------------------------

   --  WARNING : Only call this procedure with abortion deferred.
   --  That's why the name has "Vulnerable" in it.

   procedure Vulnerable_Complete_Activation
     (T : ATCB_Ptr;
      Completed : Boolean)
   is
      Activator : ATCB_Ptr;
      Error     : Boolean;

   begin
      Activator := T.Activator;

      if Activator /= null then
      --  Should only be null for the environment task.

         --  Decrement the count of tasks to be activated by the
         --  activator and wake it up so it can check to see if
         --  all tasks have been activated.  Note that the locks
         --  of the activator and created task are locked here.
         --  This is necessary because C.Stage and
         --  T.Activation_Count have to be synchronized.  This is
         --  also done in Activate_Tasks and Init_Abortion.  So
         --  long as the activator lock is always locked first,
         --  this cannot lead to deadlock.

         Write_Lock (Activator.L, Error);
         Write_Lock (T.L, Error);

         if T.Stage = Can_Activate then
            T.Stage := Active;
            Activator.Activation_Count := Activator.Activation_Count - 1;
            Cond_Signal (Activator.Cond);
            if Completed then
               Activator.Exception_To_Raise :=
                 Compiler_Exceptions.Tasking_Error_ID;
            end if;
         end if;
         Unlock (T.L);
         Unlock (Activator.L);

      end if;

   end Vulnerable_Complete_Activation;

   --  PO related routines

   ---------------------
   -- Check_Exception --
   ---------------------

   procedure Check_Exception is
      T  : ATCB_Ptr := ID_To_ATCB (Self);
      Ex : Compiler_Exceptions.Exception_ID := T.Exception_To_Raise;

   begin
      T.Exception_To_Raise := Compiler_Exceptions.Null_Exception;
      Compiler_Exceptions.Raise_Exception (Ex);
   end Check_Exception;

   --  Rendezvous related routines

   -------------------
   -- Close_Entries --
   -------------------

   procedure Close_Entries (Target : Task_ID) is
      T           : ATCB_Ptr := ID_To_ATCB (Target);
      Temp_Call   : Entry_Call_Link;
      Null_Call   : Entry_Call_Link := null;
      Temp_Caller : ATCB_Ptr;
      TAS_Result  : Boolean;
      Error       : Boolean;

   begin
      --  Purging pending callers that are in the middle of rendezvous

      Temp_Call := T.Call;

      while Temp_Call /= null loop
         Temp_Call.Exception_To_Raise := Compiler_Exceptions.Tasking_Error_ID;

         Temp_Caller := ID_To_ATCB (Temp_Call.Self);

         --  Problem: Once this lock is unlocked, the target gan go on to
         --  accept other calls, which will be missed by loop.  The question
         --  is, is there something else that will prevent this???
         --  If the target is in an abortion deferred region at this point,
         --  I don't know what it would be.

         --  By the time we get here, we do know that the target is complete
         --  and not callable.  Callable is unprotected, but Stage is protected
         --  by T.L.  If all forms of accept made sure under the protection of
         --  T.L that they were not complete before accepting a call, then it
         --  should be safe to unlock this here.

         --  Problem: what about multiple aborters?  If two tasks are in this
         --  routine at once, then there could contention if this mutex is
         --  unlocked.  We need some other form of claim mechanism to prevent
         --  this.  I think that the mechanism outlined in the implementation
         --  sketch, where an aborter waits for a previous aborter to finish
         --  its work, might solve this.

         --  What if T itself is at exactly this point and gets aborted?  In
         --  that case, I think that the aborter has to wait for T to finish
         --  completing itself.  This was previously done by contending for the
         --  mutex; it might now have to be done with some kind of flag, or
         --  maybe another stage.  Perhaps we are setting Stage=Complete too
         --  soon, and abortion should wait on that.  That would require
         --  some other flag to claim the right to complete, however.  This
         --  flag could probably be protected by T.L; there should not be
         --  any need for a TAS or global mutex.  Perhaps the Aborting flag
         --  could do this, though right now all it means is that an abortion
         --  exception has been sent.  We really need a separate Completing
         --  flag (ugh).  On the bright side, this might mean that completion
         --  can be treated as once-and-once-only, and need not be reentrant.

         --  Problem: What does an acceptor do when it finds that it is being
         --  completed?  I guess it should wait until completion is finished,
         --  just like a second aborter.  Otherwise, it might continue on
         --  with a rendezvous that it never really accepted.

         Write_Lock (Temp_Caller.L, Error);
         Temp_Call.Done := True;
         Unlock (Temp_Caller.L);

         --  The caller can break out of its loop at this point, and never
         --  notice the abortion.

--       Temp_Call.Call_Claimed:= False;
--  Wrong, I think.  This should look like a completed call to everyone. ???

         Abort_To_Level (ATCB_To_ID (Temp_Caller), Temp_Call.Level - 1);

         --  I think this might be wrong; Abortion takes precedence over
         --  exceptions in the call block. ???
         --  Not true; the last call to be canceled won't raise Abortion again;
         --  it raises the chosen exception instead.  This is true of leaf
         --  (suspending) calls as well; they decrement the nesting level
         --  before undeferring abortion, which will prevent further abortion
         --  (providing that abortion is not to an outer level).
         --  Final resolution and removal of these comments, or replacement
         --  by comments saying what is happening without speculation
         --  is needed (RBKD) ???

         Temp_Call := Temp_Call.Acceptor_Prev_Call;
      end loop;

      --  Purging entry queues

      for J in 1 .. T.Entry_Num loop
         Dequeue_Head (T.Entry_Queues (J), Temp_Call);

         if Temp_Call /= Null_Call then
            loop
               Test_And_Set (Temp_Call.Call_Claimed'Address, TAS_Result);

               if TAS_Result then
                  Temp_Caller := ID_To_ATCB (Temp_Call.Self);
                  Temp_Call.Exception_To_Raise :=
                    Compiler_Exceptions.Tasking_Error_ID;
                  Temp_Call.Done := True;

                  Abort_To_Level (
                    ATCB_To_ID (Temp_Caller), Temp_Call.Level - 1);

               else
                  null;

                  --  Someone else claimed this call.  It must be to cancel it,
                  --  since the acceptor can't have accepted it at this point.
                  --  So far as we are concerned, this call is not on the
                  --  queue, and we don't have to raise tasking error in the
                  --  caller.
               end if;

               Dequeue_Head (T.Entry_Queues (J), Temp_Call);
               exit when Temp_Call = Null_Call;
            end loop;
         end if;
      end loop;

   end Close_Entries;

   ----------------------------
   -- Complete_On_Sync_Point --
   ----------------------------

   procedure Complete_on_Sync_Point (T : Task_ID) is
      Target     : ATCB_Ptr := ID_To_ATCB (T);
      Call       : Entry_Call_Link;
      TAS_Result : Boolean;
      Error      : Boolean;

   begin
      Write_Lock (Target.L, Error);

      if Target.Suspended_Abortably then

         if Target.Accepting /= Not_Accepting then
            Unlock (Target.L);
            Complete (T);

         else
            --  Hopefully suspended on an entry call by elimination.

            if Target.ATC_Nesting_Level > ATC_Level_Base'First then
               Call := Target.Entry_Calls (Target.ATC_Nesting_Level)'access;
               Test_And_Set (Call.Call_Claimed'Address, TAS_Result);

               if TAS_Result then
                  Unlock (Target.L);
                  Complete (T);
                  Call.Call_Claimed := False;

                  --  To allow abortion to claim it.

               else
                  Unlock (Target.L);
               end if;
            end if;
         end if;

      else
         Unlock (Target.L);
      end if;
   end Complete_on_Sync_Point;

   --------------------
   -- Reset_Priority --
   --------------------

   procedure Reset_Priority
     (Acceptor_Prev_Priority : Rendezvous_Priority;
       Acceptor              : Task_ID)
   is
      Acceptor_ATCB : ATCB_Ptr := ID_To_ATCB (Acceptor);

   begin
      if Acceptor_Prev_Priority /= Priority_Not_Boosted then
         Acceptor_ATCB.Current_Priority := Acceptor_Prev_Priority;
         Set_Priority
           (Acceptor_ATCB.LL_TCB'access, Acceptor_ATCB.Current_Priority);
      end if;
   end Reset_Priority;

   ---------------------------
   -- Terminate_Alternative --
   ---------------------------

   --  WARNING : Only call this procedure with abortion deferred. This
   --  procedure needs to have abortion deferred while it has the current
   --  task's lock locked. Since it is called from two procedures which
   --  also need abortion deferred, it is left controlled on entry to
   --  this procedure.

   procedure Terminate_Alternative is
      P, T  : ATCB_Ptr := ID_To_ATCB (Self);
      Taken : Boolean;
      Error : Boolean;

   begin
      Make_Passive (T);

      --  Note that abortion is deferred here (see WARNING above)

      Write_Lock (T.L, Error);

      while T.Accepting /= Not_Accepting
        and then T.Stage /= Complete
        and then T.Pending_ATC_Level >= T.ATC_Nesting_Level
      loop
         Cond_Wait (T.Cond, T.L);
      end loop;

      if T.Stage = Complete then
         Unlock (T.L);

         if T.Pending_ATC_Level < T.ATC_Nesting_Level then
            Abortion.Undefer_Abortion;
            Error_Reporting.Assert (False, "Continuing after being aborted!");
         end if;

         Abort_To_Level (ATCB_To_ID (T), 0);
         Abortion.Undefer_Abortion;
         Error_Reporting.Assert (False, "Continuing after being aborted!");
      end if;

      T.Stage := Active;
      T.Awake_Count := T.Awake_Count + 1;

      --  At this point, T.Awake_Count and P.Awaited_Dependent_Count could be
      --  out of synchronization.  However, we know that
      --  P.Awaited_Dependent_Count cannot be zero, and cannot go to zero,
      --  since some other dependent must have just called us.  There should
      --  therefore be no danger of the parent terminating before we increment
      --  P.Awaited_Dependent_Count below.

      if T.Awake_Count = 1 then
         Unlock (T.L);

         if T.Pending_ATC_Level < T.ATC_Nesting_Level then
            Abortion.Undefer_Abortion;
            Error_Reporting.Assert (False, "Continuing after being aborted!");
         end if;

         P := T.Parent;
         Write_Lock (P.L, Error);

         if P.Awake_Count /= 0 then
            P.Awake_Count := P.Awake_Count + 1;

         else
            Unlock (P.L);
            Abort_To_Level (ATCB_To_ID (T), 0);
            Abortion.Undefer_Abortion;
            Error_Reporting.Assert (False, "Continuing after being aborted!");
         end if;

         --  Conservative checks which should only matter when an interrupt
         --  entry was chosen. In this case, the current task completes if the
         --  parent has already been signaled that all children have
         --  terminated.

         if T.Master_of_Task = P.Master_Within then
            if P.Awaited_Dependent_Count /= 0 then
               P.Awaited_Dependent_Count := P.Awaited_Dependent_Count + 1;

            elsif P.Stage = Await_Dependents then
               Unlock (P.L);
               Abort_To_Level (ATCB_To_ID (T), 0);
               Abortion.Undefer_Abortion;
               Error_Reporting.Assert (
                 False, "Continuing after being aborted!");
            end if;
         end if;

         Unlock (P.L);

      else
         Unlock (T.L);

         if T.Pending_ATC_Level < T.ATC_Nesting_Level then
            Abortion.Undefer_Abortion;
            Error_Reporting.Assert (False, "Continuing after being aborted!");
         end if;
      end if;

      --  Note: the caller will undefer abortion on return (see WARNING above)

   end Terminate_Alternative;

   --------------
   -- Complete --
   --------------

   procedure Complete (Target : Task_ID) is
      T      : ATCB_Ptr := ID_To_ATCB (Target);
      Caller : ATCB_Ptr := ID_To_ATCB (Self);
      Task1  : ATCB_Ptr;
      Task2  : ATCB_Ptr;
      Error  : Boolean;

   begin
      --  Make_Passive used to be the last thing done in this routine in the
      --  original MRTSI code.  Make_Passive was modified not to process a
      --  completed task, so setting the complete flag conflicted with this.
      --  I don't see any reason why the task cannot be made passive before
      --  it is marked as completed, but I may find out. ???

      Make_Passive (T);
      Write_Lock (T.L, Error);

      if T.Stage < Completing then
         T.Stage := Completing;
         T.Accepting := Not_Accepting;

         --  *LATER* consider new value of this type  ???

         T.Awaited_Dependent_Count := 0;
         Unlock (T.L);
         Close_Entries (ATCB_To_ID (T));
         T.Stage := Complete;

         --  Wake up all the pending calls on Aborter_Link list

         Task1 := T.Aborter_Link;
         T.Aborter_Link := null;

         while (Task1 /= null) loop
            Task2 := Task1;
            Task1 := Task1.Aborter_Link;
            Task2.Aborter_Link := null;
            Cond_Signal (Task2.Cond);
         end loop;

      else
         --  Some other task is completing this task. So just wait until
         --  the completion is done. A list of such waiting tasks is
         --  maintained by Aborter_Link in ATCB.

         while T.Stage < Complete loop
            if T.Aborter_Link /= null then
               Caller.Aborter_Link := T.Aborter_Link;
            end if;

            T.Aborter_Link := Caller;
            Cond_Wait (Caller.Cond, T.L);
         end loop;

         Unlock (T.L);
      end if;
   end Complete;

   --  Task_Stage related routines

   ----------------------
   -- Make_Independent --
   ----------------------

   procedure Make_Independent is
      S : ATCB_Ptr := ID_To_ATCB (Self);
      Result : Boolean;
   begin
         S.Master_of_Task := Master_ID (0);
         S.Parent.Awake_Count := S.Parent.Awake_Count - 1;

         Remove_From_All_Tasks_List (S, Result);
         Error_Reporting.Assert (
           Result,
           "Failed to delete an entry from All_Tasks_List");


   end Make_Independent;

   --  Task Abortion related routines

   --------------------
   -- Abort_To_Level --
   --------------------

   procedure Abort_To_Level
     (Target : Task_ID;
      L      : ATC_Level)
   is
      T      : ATCB_Ptr := ID_To_ATCB (Target);
      Error  : Boolean;

   begin
      Write_Lock (T.L, Error);

      if T.Pending_ATC_Level > L then
         T.Pending_ATC_Level := L;
         T.Pending_Action := True;

         if not T.Aborting then
            T.Aborting := True;

            if T.Suspended_Abortably then
               Cond_Signal (T.Cond);
               Cond_Signal (T.Rend_Cond);

               --  Ugly; think about ways to have tasks suspend on one
               --  condition variable. ???

            else

               if Target =  Self then
                  Unlock (T.L);
                  Abort_Task (T.LL_TCB'access);
                  return;

               elsif T.Stage /= Terminated then
                  Abort_Task (T.LL_TCB'access);
               end if;

               --  If this task is aborting itself, it should unlock itself
               --  before calling abort, as it is unlikely to have the
               --  opportunity to do so afterwords. On the other hand, if
               --  another task is being aborted, we want to make sure it is
               --  not terminated, since there is no need to abort a terminated
               --  task, and it may be illegal if it has stopped executing.
               --  In this case, the Abort_Task must take place under the
               --  protection of the mutex, so we know that Stage/=Terminated.

            end if;
         end if;
      end if;

      Unlock (T.L);

   end Abort_To_Level;

   -------------------
   -- Abort_Handler --
   -------------------

   procedure Abort_Handler
     (Context : Task_Primitives.Pre_Call_State)
   is
      T : ATCB_Ptr := ID_To_ATCB (Self);

   begin
      if T.Deferral_Level = 0
        and then T.Pending_ATC_Level < T.ATC_Nesting_Level
      then
         raise Standard'Abort_Signal;

         --  Not a good idea; signal remains masked after the Abortion ???
         --  exception is handled.  There are a number of solutions :
         --  1. Change the PC to point to code that raises the exception and
         --     then jumps to the location that was interrupted.
         --  2. Longjump to the code that raises the exception.
         --  3. Unmask the signal in the Abortion exception handler
         --     (in the RTS).
      end if;
   end Abort_Handler;

   ----------------------
   -- Abort_Dependents --
   ----------------------

   --  Process abortion of child tasks.

   --  Abortion should be dererred when calling this routine.
   --  No mutexes should be locked when calling this routine.

   procedure Abort_Dependents (Abortee : Task_ID) is
      Temp_T                : ATCB_Ptr;
      Temp_P                : ATCB_Ptr;
      Old_Pending_ATC_Level : ATC_Level_Base;
      TAS_Result            : Boolean;
      A                     : ATCB_Ptr := ID_To_ATCB (Abortee);
      Error                 : Boolean;

   begin
      Write_Lock (All_Tasks_L, Error);
      Temp_T := All_Tasks_List;

      while Temp_T /= null loop
         Temp_P := Temp_T.Parent;

         while Temp_P /= null loop
            exit when Temp_P = A;
            Temp_P := Temp_P.Parent;
         end loop;

         if Temp_P = A then
            Temp_T.Accepting := Not_Accepting;

            --  Send cancel signal.
            Complete_on_Sync_Point (ATCB_To_ID (Temp_T));
            Abort_To_Level (ATCB_To_ID (Temp_T), 0);
         end if;

         Temp_T := Temp_T.All_Tasks_Link;
      end loop;

      Unlock (All_Tasks_L);

   end Abort_Dependents;

   ------------------
   -- Make_Passive --
   ------------------

   --  If T is the last dependent of some master in task P to become passive,
   --  then release P. A special case of this is when T has no dependents
   --  and is completed. In this case, T itself should be released.

   --  If the parent is made passive, this is repeated recursively, with C
   --  being the previous parent and P being the next parent up.

   --  Note that we have to hold the locks of both P and C (locked in that
   --  order) so that the Awake_Count of C and the Awaited_Dependent_Count of
   --  P will be synchronized.  Otherwise, an attempt by P to terminate can
   --  preempt this routine after C's Awake_Count has been decremented to zero
   --  but before C has checked the Awaited_Dependent_Count of P.  P would not
   --  count C in its Awaited_Dependent_Count since it is not awake, but it
   --  might count other awake dependents.  When C gained control again, it
   --  would decrement P's Awaited_Dependent_Count to indicate that it is
   --  passive, even though it was never counted as active.  This would cause
   --  P to wake up before all of its dependents are passive.

   --  Note : Any task with an interrupt entry should never become passive.
   --  Support for this feature needs to be added here.

   procedure Make_Passive (T : Utilities.ATCB_Ptr) is
      P : Utilities.ATCB_Ptr;
      --  Task whose Awaited_Dependent_Count may be decremented.

      C : Utilities.ATCB_Ptr;
      --  Task whose awake-count gets decremented.

      H : Utilities.ATCB_Ptr;
      --  Highest task that is ready to terminate dependents.

      Taken     : Boolean;
      Activator : Utilities.ATCB_Ptr;
      Error     : Boolean;

   begin
      Utilities.Vulnerable_Complete_Activation (T, Completed => False);

      Write_Lock (T.L, Error);

      if T.Stage >= Utilities.Passive then
         Unlock (T.L);
         return;
      else
         T.Stage := Utilities.Passive;
         Unlock (T.L);
      end if;

      H := null;
      P := T.Parent;
      C := T;

      while C /= null loop

         if P /= null then
            Write_Lock (P.L, Error);
            Write_Lock (C.L, Error);

            C.Awake_Count := C.Awake_Count - 1;

            if C.Awake_Count /= 0 then

               --  C is not passive; we cannot make anything above this point
               --  passive.

               Unlock (C.L);
               Unlock (P.L);
               exit;
            end if;

            if P.Awaited_Dependent_Count /= 0 then

               --  We have hit a non-task master; we will not be able to make
               --  anything above this point passive.

               P.Awake_Count := P.Awake_Count - 1;

               if C.Master_of_Task = P.Master_Within then
                  P.Awaited_Dependent_Count := P.Awaited_Dependent_Count - 1;

                  if P.Awaited_Dependent_Count = 0 then
                     H := P;
                  end if;
               end if;

               Unlock (C.L);
               Unlock (P.L);
               exit;
            end if;

            if C.Stage = Utilities.Complete then

               --  C is both passive (Awake_Count = 0) and complete; wake it
               --  up to await termination of its dependents.  It will not be
               --  complete if it is waiting on a terminate alternative. Such
               --  a task is not ready to wait for its dependents to terminate,
               --  though one of its ancestors may be.

               H := C;
            end if;

            Unlock (C.L);
            Unlock (P.L);
            C := P;
            P := C.Parent;

         else
            Write_Lock (C.L, Error);
            C.Awake_Count := C.Awake_Count - 1;

            if C.Awake_Count /= 0 then

               --  C is not passive; we cannot make anything above
               --  this point passive.

               Unlock (C.L);
               exit;
            end if;

            if C.Stage = Utilities.Complete then

               --  C is both passive (Awake_Count = 0) and complete; wake it
               --  up to await termination of its dependents.  It will not be
               --  complete if it is waiting on a terminate alternative. Such
               --  a task is not ready to wait for its dependents to terminate,
               --  though one of its ancestors may be.

               H := C;
            end if;

            Unlock (C.L);
            C := P;
         end if;

      end loop;

      if H /= null then
         Cond_Signal (H.Cond);
      end if;

   end Make_Passive;


   procedure Remove_From_All_Tasks_List (
      Source : Utilities.ATCB_Ptr;
      Result : out Boolean) is

      C        : Utilities.ATCB_Ptr;
      P        : Utilities.ATCB_Ptr;
      Previous : Utilities.ATCB_Ptr;
      Error    : Boolean;
   begin

      Write_Lock (Utilities.All_Tasks_L, Error);

      Result := False;

      Previous := null;
      C := Utilities.All_Tasks_List;

      while C /= null loop
         if C = Source then
            Result := True;

            if Previous = null then
               Utilities.All_Tasks_List :=
                 Utilities.All_Tasks_List.All_Tasks_Link;
            else
               Previous.All_Tasks_Link := C.All_Tasks_Link;
            end if;

            exit;

         end if;

         Previous := C;
         C := C.All_Tasks_Link;

      end loop;

      Unlock (Utilities.All_Tasks_L);

   end Remove_From_All_Tasks_List;

end System.Tasking.Utilities;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Wed Jul 13 10:29:44 1994;  author: giering
--  Dynamic priority support added.
--  Checked in from FSU by mueller.
--  ----------------------------
--  revision 1.4
--  date: Mon Aug  8 11:40:26 1994;  author: giering
--  (Vulnerable_Complete_Activation): Took case of environment task
--   (which has no activator) into account.
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.5
--  date: Thu Aug 18 17:56:44 1994;  author: giering
--  Change to Make_Independent.
--     Master becomes null master.
--     Decrease parent's Awake_Count by 1.
--     Take the entry out of All_Tasks_List.
--  Remove_From_All_Tasks_List moved from Task_Stages body.
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
