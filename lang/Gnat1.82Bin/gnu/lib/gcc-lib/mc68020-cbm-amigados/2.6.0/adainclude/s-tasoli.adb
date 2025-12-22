------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--            S Y S T E M . T A S K I N G _ S O F T _ L I N K S             --
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

with System.Task_Specific_Data;

package body System.Tasking_Soft_Links is

   --------------------
   -- Abort_Defer_NT --
   --------------------

   procedure Abort_Defer_NT is
   begin
      null;
   end Abort_Defer_NT;

   ----------------------
   -- Abort_Undefer_NT --
   ----------------------

   procedure Abort_Undefer_NT is
   begin
      null;
   end Abort_Undefer_NT;

   ------------------------
   -- Get_TSD_Address_NT --
   ------------------------

   function Get_TSD_Address_NT (Dummy : Boolean) return  Address is
   begin
      return System.Task_Specific_Data.Non_Tasking_TSD;
   end Get_TSD_Address_NT;

   ------------------
   -- Task_Lock_NT --
   ------------------

   procedure Task_Lock_NT is
   begin
      null;
   end Task_Lock_NT;

   --------------------
   -- Task_Unlock_NT --
   --------------------

   procedure Task_Unlock_NT is
   begin
      null;
   end Task_Unlock_NT;


end System.Tasking_Soft_Links;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr 28 02:38:41 1994;  author: dewar
--  (Allocate_Jmpbuf): New function to allocate a jump buffer
--  Initialize jump buffer address to jump buffer allocated at initialization
--  (Get/Set_Sec_Stack_Addr): New subprograms
--  Add Dummy param to Get_Address_Call, to avoid GNAT bug
--  ----------------------------
--  revision 1.3
--  date: Thu Apr 28 14:50:34 1994;  author: dewar
--  Replace the six Get/Set routines by a single Get_TSD_Address function
--  ----------------------------
--  revision 1.4
--  date: Mon May  2 10:51:03 1994;  author: dewar
--  (Task_Lock, Task_Unlock): New subprograms
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
