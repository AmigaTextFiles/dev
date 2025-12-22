------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . P O O L _ L O C A L                     --
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


package body System.Pool_Local is

   Pointer_Size  : constant Storage_Offset := Address'Size / Storage_Unit;
   Pointers_Size : constant Storage_Offset := 2 * Pointer_Size;

   type Acc_Address is access all Address;
   package Addr is new Address_To_Access_Conversions (Storage_Count);

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

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Next (A : Address) return Acc_Address;
   --  Given an address of a block, return an access to the next block

   function Prev (A : Address) return Acc_Address;
   --  Given an address of a block, return an access to the previous block

   --------------
   -- Allocate --
   --------------

   procedure Allocate
     (Pool         : in out Unbounded_Reclaim_Pool;
      Address      : out System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
      Allocated : constant System.Address
        := malloc (Storage_Size + Pointers_Size);

   begin
      --  The call to malloc returns an address whose alignment is compatible
      --  with the worst case alignment requirement for the machine; thus the
      --  Alignment argument can be safely ignored.

      if Allocated = Null_Address then
         raise Storage_Error;
      else
         Address := Allocated + Pointers_Size;
         Next (Allocated).all  := Pool.First;
         Prev (Allocated).all  := Null_Address;

         if Pool.First /= Null_Address then
            Prev (Pool.First).all := Allocated;
         end if;

         Pool.First := Allocated;
      end if;
   end Allocate;

   ----------------
   -- Deallocate --
   ----------------

   procedure Deallocate
     (Pool         : in out Unbounded_Reclaim_Pool;
      Address      : System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
      Allocated : constant System.Address := Address - Pointers_Size;

   begin
      if Prev (Allocated).all = Null_Address then
         Pool.First := Next (Allocated).all;
         Prev (Pool.First).all := Null_Address;
      else
         Next (Prev (Allocated).all).all := Next (Allocated).all;
      end if;

      if Next (Allocated).all /= Null_Address then
         Prev (Next (Allocated).all).all := Prev (Allocated).all;
      end if;

      free (Allocated);
   end Deallocate;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Pool : in out Unbounded_Reclaim_Pool) is
      N         : System.Address := Pool.First;
      Allocated : System.Address;

   begin
      while N /= Null_Address loop
         Allocated := N;
         N := Next (N).all;
         free (Allocated);
      end loop;
   end Finalize;

   ----------
   -- Next --
   ----------

   function Next (A : Address) return Acc_Address is
   begin
      return Acc_Address (Addr.To_Pointer (A));
   end Next;

   ----------
   -- Prev --
   ----------

   function Prev (A : Address) return Acc_Address is
   begin
      return Acc_Address (Addr.To_Pointer (A + Pointer_Size));
   end Prev;

end System.Pool_Local;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri May 27 15:31:37 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat May 28 00:34:22 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Wed Jun  1 23:25:55 1994;  author: dewar
--  Add use clauses removed from spec
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
