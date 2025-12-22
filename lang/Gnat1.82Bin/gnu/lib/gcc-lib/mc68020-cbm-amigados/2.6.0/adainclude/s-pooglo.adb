------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                   S Y S T E M . P O O L _ G L O B A L                    --
--                                                                          --
--                                 B o d y                                  --
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

with System.Storage_Pools;    use System.Storage_Pools;
with System.Storage_Elements; use System.Storage_Elements;

package body System.Pool_Global is

   --------------------------
   -- Imported C Functions --
   --------------------------

   --  It is assumed that these functions are self-protected against concurrent
   --  access (should be true on a POSIX system with threads, and is part of
   --  the interface requirement for the implementation of Tasking.Primitives)

   function malloc (Size : Storage_Count) return System.Address;
   pragma Import (C, malloc, "malloc");

   procedure free (Address : System.Address);
   pragma Import (C, free, "free");


   ------------------
   -- Storage_Size --
   ------------------

   function Storage_Size
     (Pool : Unbounded_No_Reclaim_Pool)
     return  Storage_Count
   is
   begin
      --  Intuitively, should return System.Memory_Size. But on Sun/Alsys,
      --  System.Memory_Size > System.Max_Int, which means all you can do with
      --  it is raise CONSTRAINT_ERROR...

      return Storage_Count'Last;
   end Storage_Size;

   --------------
   -- Allocate --
   --------------

   procedure Allocate
     (Pool         : in out Unbounded_No_Reclaim_Pool;
      Address      : out System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
      Allocated : System.Address;

   begin
      Allocated := malloc (Storage_Size);

      --  The call to malloc returns an address whose alignment is compatible
      --  with the worst case alignment requirement for the machine; thus the
      --  Alignment argument can be safely ignored.

      if Allocated = Null_Address then
         raise Storage_Error;
      else
         Address := Allocated;
      end if;
   end Allocate;

   ----------------
   -- Deallocate --
   ----------------

   procedure Deallocate
     (Pool         : in out Unbounded_No_Reclaim_Pool;
      Address      : System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
   begin
      free (Address);
   end Deallocate;

end System.Pool_Global;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri May 27 15:31:34 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat May 28 00:34:09 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Wed Jun  1 23:25:41 1994;  author: dewar
--  Add use clauses that were removed from spec
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
