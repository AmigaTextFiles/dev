------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--              A D A . T A S K _ I D E N T I F I C A T I O N               --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.6 $                              --
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
with System.Tasking;
with Unchecked_Conversion;

package Ada.Task_Identification is

   type Task_Id is private;

   Null_Task_Id : constant Task_Id;

   function  "=" (Left, Right : Task_Id) return Boolean;
   pragma Inline ("=");

   function Image (T : Task_Id) return String;

   function Current_Task return Task_Id;
   pragma Inline (Current_Task);

   procedure Abort_Task (T : in out Task_Id);
   pragma Inline (Abort_Task);

   function Is_Terminated (T : Task_Id) return Boolean;
   pragma Inline (Is_Terminated);

   function Is_Callable (T : Task_Id) return Boolean;
   pragma Inline (Is_Callable);

private
   type Task_Id is access Integer;

   function Convert_Ids is new
     Unchecked_Conversion (System.Tasking.Task_ID, Task_Id);

   function Convert_Ids is new
     Unchecked_Conversion (Task_Id, System.Tasking.Task_ID);

   Null_Task_ID : constant Task_Id := Convert_Ids (System.Tasking.Null_Task);

end Ada.Task_Identification;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Mon May  2 10:50:18 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.5
--  date: Thu May 12 13:26:51 1994;  author: dewar
--  Updates for new System.Tasking structures
--  ----------------------------
--  revision 1.6
--  date: Wed Jun  1 16:53:46 1994;  author: dewar
--  Change Task_Id to access type (gets by problems with GNAT when Task_Id
--   was declared as being derived from the System.Tasking.Task_ID).
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
