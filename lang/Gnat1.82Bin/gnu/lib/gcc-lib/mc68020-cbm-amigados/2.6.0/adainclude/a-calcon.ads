------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                     A D A . C A L E N D A R . C O N V                    --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.5 $                            --
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

--  Provides conversion between calendar.time and Task_Clock.Stimespec

with System.Task_Clock;
--  Used for, type Stimespec

package Ada.Calendar.Conv is

   function Time_To_Stimespec
     (T    : Ada.Calendar.Time)
      return System.Task_Clock.Stimespec;

   function Stimespec_To_Time
     (T    : System.Task_Clock.Stimespec)
      return Ada.Calendar.Time;

end Ada.Calendar.Conv;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Fri Apr 15 17:47:17 1994;  author: giering
--  This package provides conversion Calendar.Time <-> Stimespec.
--  ----------------------------
--  revision 1.4
--  date: Thu Apr 21 14:40:32 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 12:37:44 1994;  author: giering
--  Minor reformatting.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
