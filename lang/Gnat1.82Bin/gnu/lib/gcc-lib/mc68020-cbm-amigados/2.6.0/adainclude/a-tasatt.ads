------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                  A D A . T A S K _ A T T R I B U T E S                   --
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

with Ada.Task_Identification; use Ada.Task_Identification;

generic
   type Attribute is private;
   Initial_Value : in Attribute;

package Ada.Task_Attributes is

   type Attribute_Handle is access all Attribute;

   function Value
     (T    : Task_Identification.Task_Id := Task_Identification.Current_Task)
      return Attribute;
   pragma Inline (Value);

   function Reference
     (T    : Task_Identification.Task_Id := Task_Identification.Current_Task)
      return Attribute_Handle;

   procedure Set_Value
     (Val : Attribute;
      T   : Task_Identification.Task_Id := Task_Identification.Current_Task);
   pragma Inline (Set_Value);

   procedure Reinitialize
     (T : Task_Identification.Task_Id := Task_Identification.Current_Task);
   pragma Inline (Reinitialize);

end Ada.Task_Attributes;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:56:47 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Mon May  2 10:50:03 1994;  author: dewar
--  Minor reformatting
--  (Reinitialize): Add pragma Inline
--  (Value): Add pragma Inline
--  (Set_Value): Add pragma Inline
--  ----------------------------
--  revision 1.4
--  date: Mon Jul 11 17:28:59 1994;  author: banner
--  Update to RM9X 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
