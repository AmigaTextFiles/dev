------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                  A D A . T A S K _ A T T R I B U T E S                   --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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

--  Temporary version, not task aware yet!

package body Ada.Task_Attributes is

   Attribute_Value : aliased Attribute;
   --  Stored value of attribute for environment task

   ---------------
   -- Reference --
   ---------------

   function Reference
     (T    : Task_Identification.Task_Id := Task_Identification.Current_Task)
      return Attribute_Handle
   is
   begin
      return Attribute_Value'Access;
   end Reference;

   ------------------
   -- Reinitialize --
   ------------------

   procedure Reinitialize
     (T : Task_Identification.Task_Id := Task_Identification.Current_Task)
   is
   begin
      Set_Value (Initial_Value, T);
   end Reinitialize;

   ---------------
   -- Set_Value --
   ---------------

   procedure Set_Value
     (Val : Attribute;
      T   : Task_Identification.Task_Id := Task_Identification.Current_Task)
   is
   begin
      Reference (T).all := Val;
   end Set_Value;

   -----------
   -- Value --
   -----------

   function Value
     (T    : Task_Identification.Task_Id := Task_Identification.Current_Task)
      return Attribute
   is
   begin
      return Reference (T).all;
   end Value;

end Ada.Task_Attributes;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon May  2 09:39:21 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Tue Jun 28 11:33:27 1994;  author: dewar
--  Remove redundant redeclaration of Attribute_Handle
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
