------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                          A D A . R E A L _ T I M E                       --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.13 $                             --
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


with System.Task_Clock;
--  Used for, Stimespec and associated constants

with System.Task_Clock.Machine_Specifics;
--  Used for, Stimespec_Ticks

with System.Tasking;
--  Used for, Protection

package Ada.Real_Time is

   type Time is private;
   Time_First : constant Time;
   Time_Last : constant Time;
   Time_Unit : constant := 10#1.0#E-9;

   type Time_Span is private;
   Time_Span_First : constant Time_Span;
   Time_Span_Last :  constant Time_Span;
   Time_Span_Zero :  constant Time_Span;
   Time_Span_Unit :  constant Time_Span;

   Tick :           constant Time_Span;

   function Clock return Time;

   function "+"  (Left : Time; Right : Time_Span) return Time;
   function "+"  (Left : Time_Span; Right : Time) return Time;
   function "-"  (Left : Time; Right : Time_Span) return Time;
   function "-"  (Left, Right : Time) return Time_Span;

   function "<"  (Left, Right : Time) return Boolean;
   function "<=" (Left, Right : Time) return Boolean;
   function ">"  (Left, Right : Time) return Boolean;
   function ">=" (Left, Right : Time) return Boolean;

   function "+"  (Left, Right : Time_Span) return Time_Span;
   function "-"  (Left, Right : Time_Span) return Time_Span;
   function "-"  (Right : Time_Span) return Time_Span;
   function "/"  (Left, Right : Time_Span) return Integer;
   function "/"  (Left : Time_Span; Right : Integer) return Time_Span;
   function "*"  (Left : Time_Span; Right : Integer) return Time_Span;
   function "*"  (Left : Integer; Right : Time_Span) return Time_Span;

   function "<"  (Left, Right : Time_Span) return Boolean;
   function "<=" (Left, Right : Time_Span) return Boolean;
   function ">"  (Left, Right : Time_Span) return Boolean;
   function ">=" (Left, Right : Time_Span) return Boolean;

   function "abs" (Right : Time_Span) return Time_Span;

   function To_Duration (FD : Time_Span) return Duration;
   function To_Time_Span (D : Duration) return Time_Span;

   function Nanoseconds  (NS : integer) return Time_Span;
   function Microseconds (US : integer) return Time_Span;
   function Milliseconds (MS : integer) return Time_Span;

--  Protected Delay_Object is
--     entry Wait (TS : Time_Span);
--  private
--  end Delay_Object;

   --  Gnat currently does not support delays. However, there is a RTS
   --  version of implementation which uses PO. Current version of gnat
   --  does not support PO either. So, here we use hand translated code
   --  to implement them.

   package Delay_Object is
      Object : aliased Tasking.Protection (Num_Entries => 1);
      type Params is record
         Param : Time_Span;
      end record;
      procedure Service_Entries (Pending_Serviced : out Boolean);
   end Delay_Object;

   type Seconds_Count is new integer range -integer'Last .. integer'Last;

   procedure Split (T : Time; S : out Seconds_Count; D : out Time_Span);
   function Time_Of (S : Seconds_Count; D : Time_Span) return Time;

private

   type Time is new Task_Clock.Stimespec;

   Time_First : constant Time := Time (Task_Clock.Stimespec_First);

   Time_Last :  constant Time := Time (Task_Clock.Stimespec_Last);

   type Time_Span is new Task_Clock.Stimespec;

   Time_Span_First : constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_First);

   Time_Span_Last :  constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_Last);

   Time_Span_Zero :  constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_Zero);

   Time_Span_Unit :  constant Time_Span :=
     Time_Span (Task_Clock.Stimespec_Unit);

   Tick :           constant Time_Span :=
     Time_Span (Task_Clock.Machine_Specifics.Stimespec_Ticks);


end Ada.Real_Time;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.11
--  date: Tue Jun  7 11:27:15 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  ----------------------------
--  revision 1.12
--  date: Mon Jul 11 17:29:27 1994;  author: banner
--  Minor changes per RM9X 5.0
--  ----------------------------
--  revision 1.13
--  date: Fri Jul 22 08:54:58 1994;  author: giering
--  Made Time and Time_Span private.
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
