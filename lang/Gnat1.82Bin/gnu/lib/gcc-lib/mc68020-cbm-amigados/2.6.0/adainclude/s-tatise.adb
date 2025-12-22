------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--             S Y S T E M . T A S K _ T I M E R _ S E R V I C E            --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.14 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2, or  (at  your  option)  any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Calendar.Conv;
--  Used for, Time_To_Stimespec

with System.Compiler_Exceptions;
--  Used for, Current_Exception

with Ada.Real_Time.Conv;
--  Used for, Time_Span_To_Stimespec
--            Time_To_Stimespec

with System.Task_Primitives;
--  Used for, Condition_Variable
--            Lock, Unlock
--            Write_Lock
--            Cond_Signal
--            Initialize_Lock
--            Initialize_Cond
--            Cond_Timed_wait

with System.Tasking.Utilities;
--  Used for, Make_Independent

with System.Task_Clock;

with System.Task_Clock.Machine_Specifics;
--  Used for, Machine_Specifics.Clock

with System.Tasking.Protected_Objects;

with System.Tasking;

with Unchecked_Conversion;

package body System.Task_Timer_Service is

   use System.Tasking.Protected_Objects;
   use System.Tasking;

   use System.Task_Clock;
   --  Included use clause for comparison operators

   function Clock return Stimespec
     renames Task_Clock.Machine_Specifics.Clock;

   type Q_Rec;
   type Q_Link is access Q_Rec;

   type Q_Rec is record
      S_O      : Signal_Object.O_Type;
      T        : Task_Clock.Stimespec;    --  wake up time
      Next     : Q_Link;
      Previous : Q_Link;
   end record;

   Q_Head : Q_Link := null;


   Timer_Condition :  Task_Primitives.Condition_Variable;
   Timer_Lock      :  Task_Primitives.Lock;

   Stimespec_Day : constant Stimespec := Task_Clock.Time_Of (86400, 0);
   Stimespec_Large : Stimespec := Clock + Stimespec_Day;
   --  This value is used to make Timer.Server to sleep until some entry
   --  comes into the timer queue.

   function To_Access is new
     Unchecked_Conversion (System.Address, Protection_Access);

   -------------------
   -- Signal_Object --
   -------------------

   package body Signal_Object is

      --------------------------------------
      -- Signal_Object.Signal_Unprotected --
      --------------------------------------

      procedure Signal_Unprotected (Open : in out boolean) is
      begin
         Open := true;
      end Signal_Unprotected;

      procedure Signal (PO : in out O_Type) is
         PS : Boolean;

      begin
         Tasking.Protected_Objects.Lock (To_Access (PO.Object'Address));

         begin
            Signal_Unprotected (PO.Open);

         exception
            when others =>
               Service_Entries (PO, PS);
               Tasking.Protected_Objects.Unlock (
                     To_Access (PO.Object'Address));
               raise;
         end;

         Service_Entries (PO, PS);

         --  Barriers may have changed

         Tasking.Protected_Objects.Unlock (To_Access (PO.Object'Address));
      end Signal;

      ------------------------------------------
      -- Signal_Object.Wait_Count_Unprotected --
      ------------------------------------------

      function Wait_Count_Unprotected (Object : Protection) return integer is
      begin
         --  Find the number of calls waiting on the specified entry

         return Protected_Count (Object, 1);
      end Wait_Count_Unprotected;

      ------------------------------
      -- Signal_Object.Wait_Count --
      ------------------------------

      procedure Wait_Count (PO : in out O_Type; W : out integer) is
      begin
         Tasking.Protected_Objects.Lock_Read_Only
           (To_Access (PO.Object'Address));

         W := Wait_Count_Unprotected (PO.Object);
         Tasking.Protected_Objects.Unlock (To_Access (PO.Object'Address));

      exception
         when others =>
            Tasking.Protected_Objects.Unlock (To_Access (PO.Object'Address));
            raise;
      end Wait_Count;

      -----------------------------------
      -- Signal_Object.Service_Entries --
      -----------------------------------

      procedure Service_Entries
        (PO               : in out O_Type;
         Pending_Serviced : out Boolean)
      is
         subtype PO_Entry_Index is Protected_Entry_Index
           range Null_Protected_Entry .. 1;

         P             : System.Address;
         Barriers      : Tasking.Barrier_Vector (1 .. 1);
         E             : PO_Entry_Index;
         PS            : Boolean;
         Cumulative_PS : Boolean := False;

      begin
         loop
            begin
               Barriers (1) := PO.Open;

            exception
               when others =>
                  begin
                     Tasking.Protected_Objects.Broadcast_Program_Error
                       (To_Access (PO.Object'Address));

                  exception
                     when Program_Error =>
                        Tasking.Protected_Objects.Unlock
                          (To_Access (PO.Object'Address));
                        raise;
                  end;
            end;

            Tasking.Protected_Objects.Next_Entry_Call
              (To_Access (PO.Object'Address), Barriers, P, E);

            begin
               case E is

                  when Null_Protected_Entry =>

                     --  No pending call to serve

                     exit;

                  when 1 =>

                     --  Code from the entry Wait

                     PO.Open := False;
                     Tasking.Protected_Objects.Complete_Entry_Body
                       (To_Access (PO.Object'Address), PS);
               end case;

            exception
               when others =>
                  Tasking.Protected_Objects.Exceptional_Complete_Entry_Body (
                    Object => To_Access (PO.Object'Address),
                    Ex => Compiler_Exceptions.Current_Exception,
                    Pending_Serviced => PS);
            end;

            Cumulative_PS := Cumulative_PS or PS;
         end loop;

         Pending_Serviced := Cumulative_PS;
      end Service_Entries;

   end Signal_Object;

   -----------
   -- Timer --
   -----------

   package body Timer is

      -------------------------------
      -- Timer.Service_Unprotected --
      -------------------------------

      procedure Service_Unprotected (T : out Task_Clock.Stimespec) is
         Q_Ptr : Q_Link := Q_Head;
         W     : integer;

      begin
         while Q_Ptr /= null loop
            Signal_Object.Wait_Count (Q_Ptr.S_O, W);

            if Q_Ptr.T < Clock or else W = 0 then

               --  Wake up the waiting task

               Signal_Object.Signal (Q_Ptr.S_O);

               --  When it is done, all the pending calls are serviced
               --  Therefore it is safe to finalize it.

               Finalize_Protection (To_Access (Q_Ptr.S_O.Object'Address));

               --  Remove the entry, case of head entry

               if Q_Ptr = Q_Head then
                  Q_Head := Q_Ptr.Next;

                  if Q_Head /= null then
                     Q_Head.Previous := null;
                  end if;

               --  Case of tail entry

               elsif Q_Ptr.Next = null then
                  Q_Ptr.Previous.Next := null;

               --  Case of middle entry

               else
                  Q_Ptr.Previous.Next := Q_Ptr.Next;
                  Q_Ptr.Next.Previous := Q_Ptr.Previous;
               end if;
            end if;

            Q_Ptr := Q_Ptr.Next;
         end loop;

         if Q_Head = null then
            T := Stimespec_Large;
         else
            T := Q_Head.T;
         end if;

      end Service_Unprotected;

      -------------------
      -- Timer.Service --
      -------------------

      procedure Service (T : out Task_Clock.Stimespec) is
         PS : Boolean;

      begin
         Tasking.Protected_Objects.Lock (To_Access (Object'Address));

         begin
            Service_Unprotected (T);

         exception
            when others =>
               Service_Entries (PS);
               Tasking.Protected_Objects.Unlock (To_Access (Object'Address));
               raise;
         end;

         Service_Entries (PS);
         Tasking.Protected_Objects.Unlock (To_Access (Object'Address));
      end Service;

      -------------------------
      -- Timer.Timer_Enqueue --
      -------------------------

      procedure Time_Enqueue
        (T : in Task_Clock.Stimespec;
         N : in out Q_Link)
      is
         Q_Ptr : Q_Link := Q_Head;
         Tmp   : Task_Clock.Stimespec;
         Error : Boolean;

      begin
         --  Create a queue entry

         Tmp := T;
         N := new Q_Rec;

         --  A new protected object is created. So, initialize it.  This
         --  might be called by any task, so give it the highest possible
         --  ceiling priority.

         Initialize_Protection (
           To_Access (N.S_O.Object'Address), Priority'Last);

         N.T := T;

         --  If the new element becomes head of the queue, notify Timer Service

         if Q_Head = null then
            N.Next := null;
            N.Previous := null;
            Q_Head := N;
            Task_Primitives.Write_Lock (Timer_Lock, Error);
            Task_Primitives.Cond_Signal (Timer_Condition);

            --  Signal the timer server to wake up

            Task_Primitives.Unlock (Timer_Lock);

         elsif N.T < Q_Head.T then
            N.Next := Q_Head;
            N.Previous := null;
            Q_Head.Previous := N;
            Q_Head := N;
            Task_Primitives.Write_Lock (Timer_Lock, Error);
            Task_Primitives.Cond_Signal (Timer_Condition);

            --  Signal the timer server to wake up

            Task_Primitives.Unlock (Timer_Lock);

         else
            --  Place in the middle

            while Q_Ptr.Next /= null loop
               if Q_Ptr.Next.T >= N.T then
                  N.Next := Q_Ptr.Next;
                  N.Previous := Q_Ptr;
                  Q_Ptr.Next.Previous := N;
                  Q_Ptr.Next := N;
                  exit;
               end if;

               Q_Ptr := Q_Ptr.Next;
            end loop;

            if Q_Ptr.Next = null then

               --  Place in the last

               N.Next := null;
               N.Previous := Q_Ptr;
               Q_Ptr.Next := N;
            end if;
         end if;
      end Time_Enqueue;

      ---------------------------
      -- Timer.Service_Entries --
      ---------------------------

      procedure Service_Entries (Pending_Serviced : out Boolean) is

         subtype PO_Entry_Index is Protected_Entry_Index
           range Null_Protected_Entry .. 4;

         Barriers : Tasking.Barrier_Vector (1 .. 4) := (others => true);
         --  No barriers. always true

         P             : System.Address;
         E             : PO_Entry_Index;
         PS            : Boolean;
         Cumulative_PS : Boolean := False;

      begin
         loop
            Tasking.Protected_Objects.Next_Entry_Call
              (To_Access (Object'Address), Barriers, P, E);

            begin
               case E is

                  --  No pending call to serve

                  when Null_Protected_Entry =>
                     exit;

                  --  Code from entry Enqueue (T : in Time_Span);
                  --  Enqueues elements in wake-up time order

                  when 1 =>
                     declare
                        type Dummy is record
                           Val : Real_Time.Time_Span;
                        end record;

                        type Dummy_Ptr is access Dummy;

                        function Dummy_Conv is new
                          Unchecked_Conversion (System.Address, Dummy_Ptr);

                        D_Ptr : Dummy_Ptr := Dummy_Conv (P);
                        T : Real_Time.Time_Span;
                        N : Q_Link;

                     begin
                        T := D_Ptr.Val;
                        Time_Enqueue (Clock +
                          Real_Time.Conv.Time_Span_To_Stimespec (T), N);

                        Tasking.Protected_Objects.Lock
                          (To_Access (N.S_O.Object'Address));

                        --  Lock the target object before requeueing
                        --  Param is also passed with
                        --  Object.Call_In_Progress.Parameter

                        Requeue_Protected_Entry (
                          Object => To_Access (Object'Address),
                          New_Object => To_Access (N.S_O.Object'Address),
                          E => 1,
                          With_Abort => true);

                        Signal_Object.Service_Entries (N.S_O, PS);

                        Tasking.Protected_Objects.Unlock
                          (To_Access (N.S_O.Object'Address));
                     end;

                  when 2 =>
                     declare
                        type Dummy is record
                           Val : Duration;
                        end record;

                        type Dummy_Ptr is access Dummy;

                        function Dummy_Conv is new
                          Unchecked_Conversion (System.Address, Dummy_Ptr);

                        D_Ptr : Dummy_Ptr := Dummy_Conv (P);
                        T : Duration;
                        N : Q_Link;
                     begin
                        T := D_Ptr.Val;
                        Time_Enqueue (
                          Clock +
                          Task_Clock.Duration_To_Stimespec (T), N);

                        Tasking.Protected_Objects.Lock
                          (To_Access (N.S_O.Object'Address));

                        --  Lock the target object before requeueing
                        --  Param is also passed with
                        --  Object.Call_In_Progress.Parameter

                        Requeue_Protected_Entry (
                          Object => To_Access (Object'Address),
                          New_Object => To_Access (N.S_O.Object'Address),
                          E => 1,
                          With_Abort => true);

                        Signal_Object.Service_Entries (N.S_O, PS);

                        Tasking.Protected_Objects.Unlock
                          (To_Access (N.S_O.Object'Address));

                     end;

                  when 3 =>
                     declare
                        type Dummy is record
                           Val : Real_Time.Time;
                        end record;

                        type Dummy_Ptr is access Dummy;

                        function Dummy_Conv is new
                          Unchecked_Conversion (System.Address, Dummy_Ptr);

                        D_Ptr : Dummy_Ptr := Dummy_Conv (P);
                        T : Real_Time.Time;
                        N : Q_Link;

                     begin
                        T := D_Ptr.Val;
                        Time_Enqueue
                          (Real_Time.Conv.Time_To_Stimespec (T), N);

                        --  Put in the Timer Queue

                        Tasking.Protected_Objects.Lock
                          (To_Access (N.S_O.Object'Address));

                        --  Lock the target object before requeueing
                        --  Param is also passed with
                        --  Object.Call_In_Progress.Parameter

                        Requeue_Protected_Entry (
                          Object => To_Access (Object'Address),
                          New_Object => To_Access (N.S_O.Object'Address),
                          E => 1,
                          With_Abort => true);

                        Signal_Object.Service_Entries (N.S_O, PS);

                        Tasking.Protected_Objects.Unlock
                          (To_Access (N.S_O.Object'Address));

                     end;

                  when 4 =>
                     declare
                        type Dummy is record
                           Val : Ada.Calendar.Time;
                        end record;

                        type Dummy_Ptr is access Dummy;

                        function Dummy_Conv is new
                          Unchecked_Conversion (System.Address, Dummy_Ptr);

                        D_Ptr : Dummy_Ptr := Dummy_Conv (P);
                        T : Ada.Calendar.Time;
                        N : Q_Link;

                     begin
                        T := D_Ptr.Val;
                        Time_Enqueue
                          (Ada.Calendar.Conv.Time_To_Stimespec (T), N);

                        Tasking.Protected_Objects.Lock
                          (To_Access (N.S_O.Object'Address));

                        --  Lock the target object before requeueing
                        --  Param is also passed with
                        --  Object.Call_In_Progress.Parameter

                        Requeue_Protected_Entry (
                          Object => To_Access (Object'Address),
                          New_Object => To_Access (N.S_O.Object'Address),
                          E => 1,
                          With_Abort => true);

                        Signal_Object.Service_Entries (N.S_O, PS);

                        Tasking.Protected_Objects.Unlock
                          (To_Access (N.S_O.Object'Address));

                     end;
               end case;

            exception
               when others =>
                  Tasking.Protected_Objects.Exceptional_Complete_Entry_Body (
                    Object => To_Access (Object'Address),
                    Ex => Compiler_Exceptions.Current_Exception,
                    Pending_Serviced => PS);
            end;

            Cumulative_PS := Cumulative_PS or PS;
         end loop;

         Pending_Serviced := Cumulative_PS;
      end Service_Entries;

   --  Package initialization for package Timer.  Any task might call
   --  this, so give it the highest possible ceiling priority.

   begin
      Initialize_Protection
        (To_Access (Object'Address), Priority'Last);

   end Timer;

   -------------------
   -- Timer_Service --
   -------------------

   Next_Wakeup_Time : Task_Clock.Stimespec := Stimespec_Large;
   procedure Temp_Init is
   begin
      Tasking.Utilities.Make_Independent;
      Task_Primitives.Initialize_Lock (System.Priority'Last, Timer_Lock);
      Task_Primitives.Initialize_Cond (Timer_Condition);
   end Temp_Init;
   procedure Temp_Wait is
      Result           : Boolean;
      Error            : Boolean;
   begin
      Task_Primitives.Write_Lock (Timer_Lock, Error);
      Task_Primitives.Cond_Timed_Wait
        (Timer_Condition, Timer_Lock, Next_Wakeup_Time, Result);
      Task_Primitives.Unlock (Timer_Lock);
   end Temp_Wait;
   --  All of the above should be local to Timer_Server---GNAT workaround. ???

   task Timer_Server is
      pragma Priority (System.Priority'Last);
   end Timer_Server;

   task body Timer_Server is
   begin
      Temp_Init;
      loop
         Temp_Wait;
         if Q_Head = null and then Next_Wakeup_Time < Clock then
         --  In the case where current time passes Stimespec_Large
            Stimespec_Large := Stimespec_Large + Stimespec_Day;
            Next_Wakeup_Time := Stimespec_Large;
         else
            Timer.Service (Next_Wakeup_Time);
         end if;
      end loop;
   end Timer_Server;

--   task Timer_Server is
--      pragma Priority (System.Priority'Last);
--   end Timer_Server;
--
--   task body Timer_Server is
--      Next_Wakeup_Time : Task_Clock.Stimespec := Stimespec_Large;
--      Result           : Boolean;
--      Error : Boolean;
--
--   begin
--      Tasking.Utilities.Make_Independent;
--      Task_Primitives.Initialize_Lock (System.Priority'Last, Timer_Lock);
--      Task_Primitives.Initialize_Cond (Timer_Condition);
--      --  necessary for timed wait
--      Task_Primitives.Write_Lock (Timer_Lock, Error);
--
--      loop
--         Task_Primitives.Cond_Timed_wait
--           (Timer_Condition, Timer_Lock, Next_Wakeup_Time, Result);
--         if Q_Head = null and then Next_Wakeup_Time < Clock then
--         --  In the case where current time passes Stimespec_Large
--            Stimespec_Large := Stimespec_Large + Stimespec_Day;
--            Next_Wakeup_Time := Stimespec_Large;
--         else
--
--            Timer.Service (Next_Wakeup_Time);
--         end if;
--      end loop;
--   end Timer_Server;

end System.Task_Timer_Service;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.12
--  date: Tue Jun  7 11:23:56 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.13
--  date: Wed Jul 13 10:11:01 1994;  author: giering
--  Error parameter added to Write_Lock
--  Checked in from FSU by mueller.
--  ----------------------------
--  revision 1.14
--  date: Fri Aug  5 16:42:46 1994;  author: giering
--  (Time_Enqueue, Timer): Gave all protected objects the higest possible
--   ceiling priority.
--  (Temp_Wait): Locked and unlocked the Timer_Lock mutex each time
--   that Cond_Timed_Wait is called (it had been leaving the mutex locked).
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
