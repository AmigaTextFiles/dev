------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . C O M M A N D _ L I N E                      --
--                                                                          --
--                                 S p e c                                  --
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

package Ada.Command_Line is
pragma Preelaborate (Command_Line);

   function Argument_Count return Natural;

   --  If the external execution environment supports passing arguments to a
   --  program, then Argument_Count returns the number of arguments passed to
   --  the program invoking the function. Otherwise it return 0.

   --  Corresponds to argc in C.

   --  Note in particular that the count is one more than might be expected,
   --  since it includes Argument (0) which is the command name.

   function Argument (Number : in Positive) return String;

   --  If the external execution environment supports passing arguments to a
   --  program, then Argument returns an implementation-defined value
   --  corresponding to the argument at relative position Number. If Number is
   --  outside the range 1 .. Argument_Count, then Constraint_Error is
   --  propagated.

   --  Corresponds to argv [n] (for n > 0) in C.

   function Command_Name return String;

   --  If the external execution environment supports passing arguments to a
   --  program, then Command_Name returns an implementation-defined value
   --  corresponding to the name of the command invoking the program; otherwise
   --  Command_Name returns the null string.

   type Status is range Integer'First .. Integer'Last;

   Success : constant Status;
   Failure : constant Status;

   procedure Set_Status (Code : in Status);
   pragma Import (C, Set_Status, Link_Name => "set_gnat_exit_status");

private

   Success : constant Status := 0;
   Failure : constant Status := 1;
   --  ??? Later these will be properly handled through Import variables.

end Ada.Command_Line;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Tue Jun 14 22:51:57 1994;  author: banner
--  Formatting pragma Preelaborable according to new style.
--  ----------------------------
--  revision 1.3
--  date: Mon Jul 11 17:27:49 1994;  author: banner
--  Update to RM9X 5.0
--  ----------------------------
--  revision 1.4
--  date: Thu Aug 25 09:41:32 1994;  author: dewar
--  Provide pragma Import for Set_Status
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
