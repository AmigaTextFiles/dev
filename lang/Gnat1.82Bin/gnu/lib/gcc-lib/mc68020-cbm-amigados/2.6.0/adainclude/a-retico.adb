------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                     A D A . R E A L _ T I M E . C O N V                  --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.6 $                             --
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
--  Used for, Stimespec

package body Ada.Real_Time.Conv is

   -----------------------
   -- Time_To_Stimespec --
   -----------------------

   function Time_To_Stimespec
     (T    : Real_Time.time)
      return Task_Clock.Stimespec
   is
   begin
      return Task_Clock.Stimespec (T);
   end  Time_To_Stimespec;

   -----------------------
   -- Stimespec_To_Time --
   -----------------------

   function Stimespec_To_Time
     (T    : Task_Clock.Stimespec)
      return Real_Time.Time
   is
   begin
      return Real_Time.Time (T);
   end Stimespec_To_Time;

   ----------------------------
   -- Time_Span_To_Stimespec --
   ----------------------------

   function Time_Span_To_Stimespec
     (T    : Real_Time.Time_Span)
      return Task_Clock.Stimespec
   is
   begin
      return Task_Clock.Stimespec (T);
   end  Time_Span_To_Stimespec;

   ----------------------------
   -- Stimespec_To_Time_Span --
   ----------------------------

   function Stimespec_To_Time_Span
     (T    : Task_Clock.Stimespec)
      return Real_Time.Time_Span
   is
   begin
      return Real_Time.Time_Span (T);
   end Stimespec_To_Time_Span;

end Ada.Real_Time.Conv;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Thu Apr 21 14:43:25 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 12:41:27 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  revision 1.6
--  date: Tue Jun  7 11:24:55 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
