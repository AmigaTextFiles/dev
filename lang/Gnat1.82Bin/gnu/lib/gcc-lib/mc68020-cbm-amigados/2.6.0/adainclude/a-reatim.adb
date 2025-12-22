------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                          A D A . R E A L _ T I M E                       --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.12 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2,  or  (at  your  option) any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

with System;
--  Used for, Priority

with System.Task_Clock;
--  Used for, Time definitions and operations.

with System.Task_Clock.Machine_Specifics;
--  Used for, Task_Clock.Machine_Specifics.Clock

with System.Tasking.Protected_Objects;
--  Used for, temporary implementation for Delay_Object

with System.Compiler_Exceptions;
--  Used for, Compiler_Exception.Current_Exceptions

with System.Task_Timer_Service;
--  Used for, Task_Timer.Objects
--            Task_Timer.Service_Entries

with System.Tasking;
--  Used for, various PO related definitions.

with Unchecked_Conversion;

package body Ada.Real_Time is

   use Task_Clock;

   use Tasking.Protected_Objects;

   use Tasking;

   package Timer renames System.Task_Timer_Service.Timer;

   function To_Access is new
     Unchecked_Conversion (System.Address, Protection_Access);

   -----------
   -- Clock --
   -----------

   function Clock return Time is
   begin
      return Time (Task_Clock.Machine_Specifics.Clock);
   end Clock;

   ---------
   -- "<" --
   ---------

   function "<" (Left, Right : Time) return Boolean is
   begin
      return Task_Clock.Stimespec (Left) < Task_Clock.Stimespec (Right);
   end "<";

   function "<" (Left, Right : Time_Span) return Boolean is
   begin
      return Task_Clock.Stimespec (Left) < Task_Clock.Stimespec (Right);
   end "<";

   ---------
   -- ">" --
   ---------

   function ">" (Left, Right : Time) return Boolean is
   begin
      return Right < Left;
   end ">";

   function ">" (Left, Right : Time_Span) return Boolean is
   begin
      return Right < Left;
   end ">";

   ----------
   -- "<=" --
   ----------

   function "<=" (Left, Right : Time) return Boolean is
   begin
      return not (Left > Right);
   end "<=";

   function "<=" (Left, Right : Time_Span) return Boolean is
   begin
      return not (Left > Right);
   end "<=";

   ----------
   -- ">=" --
   ----------

   function ">=" (Left, Right : Time) return Boolean is
   begin
      return not (Left < Right);
   end ">=";

   function ">=" (Left, Right : Time_Span) return Boolean is
   begin
      return not (Left < Right);
   end ">=";

   ---------
   -- "+" --
   ---------

   --  Note that Constraint_Error may be propagated

   function "+" (Left : Time; Right : Time_Span) return Time is
   begin
      return Time (Task_Clock.Stimespec (Left) + Task_Clock.Stimespec (Right));
   end "+";

   function "+"  (Left : Time_Span; Right : Time) return Time is
   begin
      return Right + Left;
   end "+";

   function "+"  (Left, Right : Time_Span) return Time_Span is
   begin
      return Time_Span (Time (Right) + Left);
   end "+";

   ---------
   -- "-" --
   ---------

   --  Note that Constraint_Error may be propagated

   function "-"  (Left : Time; Right : Time_Span) return Time is
   begin
      return Time (Task_Clock.Stimespec (Left) - Task_Clock.Stimespec (Right));
   end "-";

   function "-"  (Left, Right : Time) return Time_Span is
   begin
      return Time_Span (Left - Time_Span (Right));
   end "-";

   function "-"  (Left, Right : Time_Span) return Time_Span is
   begin
      return Time_Span (Time (Left) - Right);
   end "-";

   function "-"  (Right : Time_Span) return Time_Span is
   begin
      return Time_Span_Zero - Right;
   end "-";

   ---------
   -- "/" --
   ---------

   --  Note that Constraint_Error may be propagated

   function "/"  (Left, Right : Time_Span) return integer is
   begin
      return Task_Clock.Stimespec (Left) / Task_Clock.Stimespec (Right);
   end "/";

   function "/"  (Left : Time_Span; Right : Integer) return Time_Span is
   begin
      return Time_Span (Task_Clock.Stimespec (Left) / Right);
   end "/";

   ---------
   -- "*" --
   ---------

   --  Note that Constraint_Error may be propagated

   function "*"  (Left : Time_Span; Right : Integer) return Time_Span is
   begin
      return Time_Span (Task_Clock.Stimespec (Left) * Right);
   end "*";

   function "*"  (Left : Integer; Right : Time_Span) return Time_Span is
   begin
      return Right * Left;
   end "*";

   -----------
   -- "abs" --
   -----------

   --  Note that Constraint_Error may be propagated

   function "abs" (Right : Time_Span) return Time_Span is
   begin
      if Right < Time_Span_Zero then
         return -Right;
      end if;

      return Right;
   end "abs";

   -----------------
   -- To_Duration --
   -----------------

   function To_Duration (FD : Time_Span) return Duration is
   begin
      return Task_Clock.Stimespec_To_Duration (Task_Clock.Stimespec (FD));
   end To_Duration;

   ------------------
   -- To_Time_Span --
   ------------------

   function To_Time_Span (D : Duration) return Time_Span is
   begin
      return Time_Span (Task_Clock.Duration_To_Stimespec (D));
   end To_Time_Span;

   -----------------
   -- Nanoseconds --
   -----------------

   function Nanoseconds (NS : integer) return Time_Span is
   begin
      return Time_Span_Unit * NS;
   end Nanoseconds;

   ------------------
   -- Microseconds --
   ------------------

   function Microseconds  (US : integer) return Time_Span is
   begin
      return Nanoseconds (US) * 1000;
   end Microseconds;

   -------------------
   --  Milliseconds --
   -------------------

   function Milliseconds (MS : integer) return Time_Span is
   begin
      return Microseconds (MS) * 1000;
   end Milliseconds;

   ------------------
   -- Delay_Object --
   ------------------

   package body Delay_Object is

      procedure Service_Entries (Pending_Serviced : out Boolean) is
         P : System.Address;

         subtype PO_Entry_Index is Protected_Entry_Index
           range Null_Protected_Entry .. 1;

         Barriers : Barrier_Vector (1 .. 1)  :=  (others => true);
         --  No barriers. always true barrier

         E : PO_Entry_Index;

         PS : Boolean;

         Cumulative_PS : Boolean := False;

      begin
         loop
            --  Get the next queued entry or the pending call
            --  (if no barriers are true)

            Next_Entry_Call (To_Access (Object'Address), Barriers, P, E);

            begin
               case E is
                  when Null_Protected_Entry =>  --  no call to serve
                     exit;

                  when 1 =>

                     --  Lock the object before requeueing

                     Lock (To_Access (Timer.Object'Address));

                     begin
                        --  Requeue on the timer for the service.
                        --  Parameter is passed along as
                        --  Object.Call_In_Progress.Param

                        Requeue_Protected_Entry (
                          Object => To_Access (Object'Address),
                          New_Object => To_Access (Timer.Object'Address),
                          E => 1,
                          With_Abort => true);

                        Timer.Service_Entries (PS);
                        Tasking.Protected_Objects.Unlock
                          (To_Access (Timer.Object'Address));

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

   begin

      --  Initialize the Time_Span delay object.  Any task might call this
      --  object, so give it the higest possible ceiling priority.

      Initialize_Protection
        (To_Access (Object'Address), System.Priority'Last);
   end Delay_Object;

   -----------
   -- Split --
   -----------

   --  D is nonnegative Time_Span

   procedure Split (T : Time; S : out Seconds_Count; D : out Time_Span) is
   begin
      S := Seconds_Count
        (Task_Clock.Stimespec_Seconds (Task_Clock.Stimespec (T)));
      D := T - Time_Of (S, Time_Span_Zero);
   end Split;

   -------------
   -- Time_Of --
   -------------

   function Time_Of (S : Seconds_Count; D : Time_Span) return Time is
   begin
      return (Time (Task_Clock.Time_Of (Integer (S), 0)) + D);
   end Time_Of;

end Ada.Real_Time;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.10
--  date: Tue Jun  7 11:27:42 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  ----------------------------
--  revision 1.11
--  date: Wed Jun  8 16:23:13 1994;  author: giering
--  Removed pragma Checks_On.
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.12
--  date: Fri Aug  5 16:40:31 1994;  author: giering
--  (Delay_Object):  Gave Delay_Object the highest possible
--   ceinling priority.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
