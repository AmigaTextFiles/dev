------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--             S Y S T E M . T A S K _ T I M E R _ S E R V I C E            --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.6 $                             --
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

--  Server to manage delays. Written in terms of System.Real_Time.Time
--  and System.Task_Clock.Time.

with Ada.Calendar;
--  Used for, Calendar.Time

with Ada.Real_Time;
--  Used for, Real_Time.Time
--            Real_Time.Time_Span

with System.Task_Clock;
--  Used for, Stimespec

with System.Tasking;
--  Used for, Protection

package System.Task_Timer_Service is

--  Implementing a proteced type using a single package

   package Signal_Object is

      type O_Type is record
         Object : Tasking.Protection (Num_Entries => 1);
         Open   : Boolean := False;
      end record;

      procedure Signal (PO : in out O_Type);

      procedure Wait_Count (PO : in out O_Type; W : out Integer);
      --  This is a general purpose function.
      --  This can not be implemented using function in Ada83 because
      --  passing object has to be 'in out' mode (for read_lock in the
      --  body of the function). Therefore we use a procedure instead.

      procedure Service_Entries
        (PO : in out O_Type;
         Pending_Serviced : out Boolean);

   end Signal_Object;

   package Timer is

      Object : Tasking.Protection (Num_Entries => 4);

      --  Relative Delays

      type Time_Span_Params is record
         Param : Real_Time.Time_Span;
      end record;

      type Duration_Params is record
         Param : Duration;
      end record;

      --  Absolute Delays
      type Real_Time_Time_Params is record
         Param : Real_Time.Time;
      end record;

      type Calendar_Time_Params is record
         Param : Ada.Calendar.Time;
      end record;

      procedure Service (T : out Task_Clock.Stimespec);

      procedure Service_Entries (Pending_Serviced : out Boolean);

   end Timer;

end System.Task_Timer_Service;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Thu Apr 21 14:47:12 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 12:44:02 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  revision 1.6
--  date: Tue Jun  7 11:24:22 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
