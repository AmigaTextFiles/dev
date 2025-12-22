------------------------------------------------------------------------------
--                                                                          --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS                --
--                                                                          --
--                    S Y S T E M _ T I M E _ T Y P E S                     --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
--                    (corresponds to FSU revision 1.6)                     --
--                                                                          --
--           Copyright (c) 1992,1993,1994 FSU, All Rights Reserved          --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 2,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License --
-- for  more details.  You should have  received  a copy of the GNU General --
-- Public License  distributed with GNAT;  see file COPYING.  If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------


with Calendar;

package System.Time_Types is

   type Time_Types is (Calendar_Time_Type, Real_Time_Type);
 
   type Time_Type (T : Time_Types) is record
      case T is
         when Calendar_Time_Type =>
            CT : Calendar.Time;
 
         when Real_Time_Type =>
            RT : integer;    --  to be defined later for GNAT ???
      end case;
   end record;

end System.Time_Types;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Sun Jan 30 13:46:48 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
