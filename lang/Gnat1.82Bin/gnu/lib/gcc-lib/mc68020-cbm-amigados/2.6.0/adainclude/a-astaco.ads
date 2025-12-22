------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--        A D A . A S Y N C H R O N O U S _ T A S K _ C O N T R O L         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.3 $                              --
--                                                                          --
--           Copyright (c) 1992,1993,1994 NYU, All Rights Reserved          --
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

with Ada.Task_Identification;

package Ada.Asynchronous_Task_Control is

   pragma Unimplemented_Unit;

   procedure Hold (T : Ada.Task_Identification.Task_Id);

   procedure Continue (T : Ada.Task_Identification.Task_Id);

   function Is_Held (T : Ada.Task_Identification.Task_Id) return Boolean;

end Ada.Asynchronous_Task_Control;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 23:52:51 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:28:14 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Thu May 12 14:02:31 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
