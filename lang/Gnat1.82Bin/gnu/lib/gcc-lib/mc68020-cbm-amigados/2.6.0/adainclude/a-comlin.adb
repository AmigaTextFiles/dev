------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . C O M M A N D _ L I N E                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
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

with System;
package body Ada.Command_Line is

   function Arg_Count return Natural;
   pragma Import (C, Arg_Count, "arg_count");

   procedure Fill_Arg (A : System.Address; Arg_Num : Integer);
   pragma Interface (C, Fill_Arg);

   function Len_Arg (Arg_Num : Integer) return Integer;
   pragma Interface (C, Len_Arg);

   --------------------
   -- Argument_Count --
   --------------------

   function Argument_Count return Natural is
   begin
      return Arg_Count - 1;
   end Argument_Count;

   --------------
   -- Argument --
   --------------

   function Argument (Number : in Positive) return String is
      Arg : aliased String (1 .. Len_Arg (Number));

   begin
      Fill_Arg (Arg'Address, Number);
      return Arg;
   end Argument;

   ------------------
   -- Command_Name --
   ------------------

   function Command_Name return String is
      Arg : aliased String (1 .. Len_Arg (0));

   begin
      Fill_Arg (Arg'Address, 0);
      return Arg;
   end Command_Name;

end Ada.Command_Line;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Mon Jun 13 19:57:00 1994;  author: dewar
--  Remove unacceptable elaboration statements, instead do the Fill_Arg
--   call on demand.
--  ----------------------------
--  revision 1.3
--  date: Mon Jul 11 17:27:56 1994;  author: banner
--  Update to RM9X 5.0
--  ----------------------------
--  revision 1.4
--  date: Thu Aug 25 09:41:26 1994;  author: dewar
--  Remove body of Set_Status (done with pragma Interface in spec)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
