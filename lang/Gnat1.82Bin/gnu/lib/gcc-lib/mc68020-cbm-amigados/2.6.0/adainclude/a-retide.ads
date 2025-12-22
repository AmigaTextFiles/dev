------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                   A D A . R E A L _ T I M E . D E L A Y S                --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.7 $                             --
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

--  Implements Real_Time.Time absolute delays using protected objects

--  Gnat currently does not support delays. However, there is a RTS
--  version of implementation which uses PO. Current version of gnat
--  does not support PO either. So, here we use hand translated code
--  to implement them.

with System.Tasking;
--  Used for, Protection

package Ada.Real_Time.Delays is

   package Delay_Until_Object is

      Object : aliased Tasking.Protection (Num_Entries => 1);

      type Params is record
         Param : Real_Time.Time;
      end record;

      procedure Service_Entries (Pending_Serviced : out Boolean);

   end Delay_Until_Object;

end Ada.Real_Time.Delays;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Tue May 10 22:53:25 1994;  author: giering
--  Made all Protection objects aliased.
--  ----------------------------
--  revision 1.6
--  date: Wed Jun  1 12:43:04 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  revision 1.7
--  date: Tue Jun  7 11:26:48 1994;  author: giering
--  Changed name from System.Real_Time to Ada.Real_Time (per LRM 4.0).
--  Checked in from FSU by giering.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
