------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--             I N T E R F A C E S . C . P O S I X _ T I M E R S            --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.2 $                             --
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

with System;
package body Interfaces.C.POSIX_Timers is

   -------------------
   -- clock_gettime --
   -------------------

   procedure clock_gettime
     (ID     : clock_id_t;
      CT     : out timespec;
      Result : out Return_Code)
   is
      function clock_gettime_base
        (ID     : clock_id_t;
         CT_Add : System.Address)
         return   Return_Code;
      pragma Import (C, clock_gettime_base, "clock_gettime");

   begin
      Result := clock_gettime_base (ID, CT'Address);
   end clock_gettime;

end Interfaces.C.POSIX_Timers;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 17:40:14 1994;  author: giering
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Aug 18 20:09:57 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
