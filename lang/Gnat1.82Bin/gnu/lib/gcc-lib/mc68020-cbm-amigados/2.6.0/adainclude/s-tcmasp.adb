------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--  S Y S T E M . T A S K _ C L O C K . M A C H I N E _ S P E C I F I C S   --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.6 $                             --
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

--  This package provides target machine specific Clock related definitions.
--  Portability of System.Task_Clock package is accomplished separating
--  this child package out. We only need to modify this package for
--  different targets.

--  This version of Clock uses the time() function, which is available
--  in most C libraries.  This is the "universal" version; it is
--  only accurate to 1 second and is not the same time base used by
--  the tasking library System.Real_Time.Clock and delays, but will
--  work on systems without tasking or POSIX.

with Interfaces.C; use Interfaces.C;

package body System.Task_Clock.Machine_Specifics is

   -----------
   -- Clock --
   -----------

   function Clock return Stimespec is

      type time_t is new long;
      type time_ptr is access all time_t;

      function time (tp : time_ptr) return int;
      pragma Import (C, time);

      Now    : aliased time_t;
      Result : int;

   begin
      Result := time (Now'access);
      return
        Stimespec'(Val => Stimespec_Sec_Unit.Val * Time_Base (Now));
   end Clock;

begin
   Stimespec_Ticks := Time_Of (0, 1000000);
   --  Sun os 4.1 has clock resoultion of 10ms.

end System.Task_Clock.Machine_Specifics;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Fri Jun  3 15:42:02 1994;  author: giering
--  Removing Stimespec_Impl_Max
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.5
--  date: Mon Aug 29 18:55:46 1994;  author: giering
--  Used Interfaces.C.POSIX_Timers in place of System.POSIX_Timers.
--  Checked in from FSU by giering.
--  ----------------------------
--  revision 1.6
--  date: Wed Aug 31 15:16:12 1994;  author: giering
--  Change interface to use Unix "time" function rather than POSIX 1003.4
--  timing function to break dependence of Calendar on Posix threads
--  emulation library.
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
