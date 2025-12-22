------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . P O O L _ E M P T Y                     --
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

with System.Storage_Pools;    use System.Storage_Pools;
with System.Storage_Elements; use System.Storage_Elements;

package body System.Pool_Empty is

   ------------------
   -- Storage_Size --
   ------------------

   function  Storage_Size (Pool : Empty_Pool) return Storage_Count is
   begin
      return 0;
   end Storage_Size;

   --------------
   -- Allocate --
   --------------

   procedure Allocate
     (Pool         : in out Empty_Pool;
      Address      : out System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
   begin
      raise Storage_Error;
   end Allocate;

   ----------------
   -- Deallocate --
   ----------------

   procedure Deallocate
     (Pool         : in out Empty_Pool;
      Address      : System.Address;
      Storage_Size : Storage_Count;
      Alignment    : Storage_Count)
   is
   begin
      raise Storage_Error;
   end Deallocate;

   --------------
   -- Finalize --
   --------------

   procedure Finalize  (Pool : in out Empty_Pool) is
   begin
      null;
   end Finalize;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize  (Pool : in out Empty_Pool) is
   begin
      null;
   end Initialize;

end System.Pool_Empty;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri May 27 15:31:31 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Wed Jun  1 23:25:29 1994;  author: dewar
--  Minor reformatting
--  Add use clauses removed from spec
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
