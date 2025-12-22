------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                    S Y S T E M . T A S K _ M E M O R Y                   --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.7 $                             --
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

with System.Task_Primitives;
--  Used for, Lock
--            Unlock
--            Initialize_Lock
--            Write_Lock

package body System.Task_Memory is

   --  malloc() and free() are not currently thread-safe, though they should
   --  be. In the meantime, these protected versions are provided.

   Memory_Mutex : Task_Primitives.Lock;

   --------------------
   -- Low_Level_Free --
   --------------------

   procedure Low_Level_Free (A : System.Address) is

      Error : Boolean;

      procedure free (Addr : System.Address);
      pragma Import (C, free, "free");

   begin
      Task_Primitives.Write_Lock (Memory_Mutex, Error);
      free (A);
      Task_Primitives.Unlock (Memory_Mutex);
   end Low_Level_Free;

   -------------------
   -- Low_Level_New --
   -------------------

   function Low_Level_New
     (Size : in Storage_Elements.Storage_Count)
      return System.Address
   is
      Temp : System.Address;
      Error : Boolean;

      function malloc
        (Size : in Storage_Elements.Storage_Count)
         return System.Address;
      pragma Import (C, malloc, "malloc");

   begin
      Task_Primitives.Write_Lock (Memory_Mutex, Error);
      Temp := malloc (Size);
      Task_Primitives.Unlock (Memory_Mutex);
      return Temp;
   end Low_Level_New;

   --------------------------
   -- Unsafe_Low_Level_New --
   --------------------------

   function Unsafe_Low_Level_New
     (Size : in Storage_Elements.Storage_Count)
      return System.Address
   is
      function malloc
        (Size : in Storage_Elements.Storage_Count)
         return System.Address;
      pragma Import (C, malloc, "malloc");

   begin
      return malloc (Size);
   end Unsafe_Low_Level_New;

begin

   Task_Primitives.Initialize_Lock (Priority'Last, Memory_Mutex);
   --  Initialize the lock used to synchronize low-level memory allocation.

end System.Task_Memory;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Mon May  2 18:52:30 1994;  author: giering
--  Initialized the lock used to synchronize memory allocation in the
--     package body.
--  ----------------------------
--  revision 1.6
--  date: Fri Jun  3 15:23:28 1994;  author: giering
--  Minor Reformatting
--  Checked in from FSU by doh.
--  ----------------------------
--  revision 1.7
--  date: Wed Jul 13 10:26:18 1994;  author: giering
--  Error parameter added for Write_Lock.
--  Checked in from FSU by mueller.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
