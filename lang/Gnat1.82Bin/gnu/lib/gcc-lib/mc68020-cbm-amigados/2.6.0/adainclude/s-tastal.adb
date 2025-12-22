-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--       S Y S T E M . T A S K _ S T O R A G E _ A L L O C A T I O N       --
--                                                                         --
--                                 B o d y                                 --
--                                                                         --
--                            $Revision: 1.4 $                             --
--                                                                         --
--          Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                         --
-- GNARL is free software; you can redistribute it and/or modify it  under --
-- terms  of  the  GNU  Library General Public License as published by the --
-- Free Software Foundation; either version 2, or  (at  your  option)  any --
-- later  version.   GNARL is distributed in the hope that it will be use- --
-- ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
-- MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
-- eral Library Public License for more details.  You should have received --
-- a  copy of the GNU Library General Public License along with GNARL; see --
-- file COPYING. If not, write to the Free Software Foundation,  675  Mass --
-- Ave, Cambridge, MA 02139, USA.                                          --
--                                                                         --
-----------------------------------------------------------------------------

with System.Storage_Elements;
--  Used for, Storage_Count

with System.Task_Memory;
--  Used for, Low_Level_New
--            Low_Level_Free

package body System.Task_Storage_Allocation is

   --------------------
   -- Allocate_Block --
   --------------------

   --  Note: the Alignment parameter is ignored here, since Low_Level_New
   --  is guaranteed to return a block of the maximum possible alignment.

   procedure Allocate_Block
     (Storage_Address : out System.Address;
      Storage_Size    : Storage_Elements.Storage_Count;
      Alignment       : in Storage_Elements.Storage_Count)
   is
   begin
      Storage_Address := Task_Memory.Low_Level_New (Storage_Size);
   end Allocate_Block;

   ----------------------
   -- Deallocate_Block --
   ----------------------

   procedure Deallocate_Block (Storage_Address : System.Address) is
   begin
      Task_Memory.Low_Level_Free (Storage_Address);
   end Deallocate_Block;

   ---------------------
   -- Maximum_Storage --
   ---------------------

   --  Returns zero, indicating no fixed limit, since there is no fixed
   --  (determinable) limit on the memory available on a POSIX system.

   function Maximum_Storage return Storage_Elements.Storage_Count is
   begin
      return 0;
   end Maximum_Storage;

end System.Task_Storage_Allocation;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Mon Mar 28 11:59:17 1994;  author: giering
--  Checked out and back in to clean up the revision history at NYU.
--  ----------------------------
--  revision 1.3
--  date: Thu Apr 21 14:46:47 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.4
--  date: Fri Jun  3 15:24:35 1994;  author: giering
--  Minor Reformatting
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
