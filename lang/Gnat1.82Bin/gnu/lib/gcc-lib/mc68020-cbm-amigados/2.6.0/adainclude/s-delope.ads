-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--              S y s t e m . D e l a y _ O p e r a t i o n s              --
--                                                                         --
--                                 S p e c                                 --
--                                                                         --
--                            $Revision: 1.4 $                            --
--                                                                         --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                         --
-- GNARL is free software; you can redistribute it and/or modify it  under --
-- terms  of  the  GNU  Library General Public License as published by the --
-- Free Software Foundation; either version 2, or  (at  your  option)  any --
-- later  version.   GNARL is distributed in the hope that it will be use- --
-- ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL; see --
-- file COPYING. If not, write to the Free Software Foundation,  675  Mass --
-- Ave, Cambridge, MA 02139, USA.                                          --
--                                                                         --
-----------------------------------------------------------------------------

with Ada.Calendar;
--  Used for, Calendar.Time

with Ada.Real_Time;
--  Used for, Real_Time.Time
--            Real_Time.Time_Span

package System.Delay_Operations is
   procedure Delay_For (D : Duration);
   procedure Delay_Until (T : Ada.Calendar.Time);
   procedure RT_Delay_For (TS : Real_Time.Time_Span);
   procedure RT_Delay_Until (T : Real_Time.Time);
end System.Delay_Operations;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Wed Jun  1 12:40:14 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  revision 1.3
--  date: Tue Jun  7 11:23:28 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.4
--  date: Fri Aug  5 16:42:14 1994;  author: giering
--  Put "RT_" in front of operations on Real_Time types, to avoid
--   overloading (which Rtsfind does not like).
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
