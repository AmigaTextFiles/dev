------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                   A D A . C A L E N D A R . D E L A Y S                  --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--                             $Revision: 1.5 $                             --
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

--  This package implements Calendar.Time delays using protected objects.

--  Gnat currently does not support delays. However, there is a RTS
--  version of implementation which uses PO. Current version of gnat
--  does not support PO either. So, here we use hand translated code
--  to implement them.

with System.Tasking.Protected_Objects;
--  Used for, type Protection

package Ada.Calendar.Delays is

   package Delay_Object is

      Object : aliased System.Tasking.Protection (Num_Entries => 1);

      type Params is record
         Param : Duration;
      end record;

      procedure Service_Entries (Pending_Serviced : out Boolean);

   end Delay_Object;

   package Delay_Until_Object is

      Object : aliased System.Tasking.Protection (Num_Entries => 1);

      type Params is record
         Param : Time;
      end record;

      procedure Service_Entries (Pending_Serviced : out Boolean);

   end Delay_Until_Object;

end Ada.Calendar.Delays;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Thu Apr 21 14:40:51 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.4
--  date: Tue May 10 22:52:05 1994;  author: giering
--  Made all Protection objects aliased.
--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 12:38:47 1994;  author: giering
--  Minor Reformatting.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
