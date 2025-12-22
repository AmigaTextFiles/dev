------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                     S Y S T E M . P O O L _ S I Z E                      --
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

package body System.Pool_Size is

   package SC is new Address_To_Access_Conversions (Storage_Count);

   ------------------
   -- Storage_Size --
   ------------------

   function  Storage_Size (Pool : Stack_Bounded_Pool) return Storage_Count is
   begin
      return Pool.Pool_Size;
   end Storage_Size;

   --------------
   -- Allocate --
   --------------

   procedure Allocate
     (Pool         : in out Stack_Bounded_Pool;
      Address      : out System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
   begin
      if Pool.First_Free /= 0 then
         Address := Pool.The_Pool (Pool.First_Free)'Address;
         Pool.First_Free := SC.To_Pointer (Address).all;

      elsif
        Pool.First_Empty <= (Pool.Pool_Size - Pool.Aligned_Elmt_Size + 1)
      then
         Address := Pool.The_Pool (Pool.First_Empty)'Address;
         Pool.First_Empty := Pool.First_Empty + Pool.Aligned_Elmt_Size;

      else
         raise Storage_Error;
      end if;
   end Allocate;

   ----------------
   -- Deallocate --
   ----------------

   procedure Deallocate
     (Pool         : in out Stack_Bounded_Pool;
      Address      : System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
   begin
      SC.To_Pointer (Address).all := Pool.First_Free;
      Pool.First_Free := Address - Pool.The_Pool'Address + 1;
   end Deallocate;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize  (Pool : in out Stack_Bounded_Pool) is
      Align : constant Storage_Count := Pool.Alignment;

   begin
      Pool.First_Free := 0;
      Pool.First_Empty := 1;

      --  Compute the size to allocate given the size of the element and the
      --  possible Alignment clause

      Pool.Aligned_Elmt_Size := ((Pool.Elmt_Size + Align - 1) / Align) * Align;
   end Initialize;
end System.Pool_Size;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri May 27 15:31:40 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat May 28 00:34:35 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Wed Jun  1 23:26:07 1994;  author: dewar
--  Add use clauses removed from spec
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
