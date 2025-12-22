------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                    S Y S T E M . P O O L _ E M P T Y                     --
--                                                                          --
--                                 S p e c                                  --
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

with System.Storage_Pools;
with System.Storage_Elements;

package System.Pool_Empty is

pragma Elaborate_Body;
--  Needed to ensure that library routines can execute allocators

   ----------------
   -- Empty_Pool --
   ----------------

   --  Allocation strategy:

   --    Raise storage Error on Allocate

   --  Used in the compiler for access types with 'STORAGE_SIZE = 0
   --  Avoid any overhead for Init/Finalize

   type Empty_Pool is new
     System.Storage_Pools.Root_Storage_Pool with null record;

   function Storage_Size
     (Pool : Empty_Pool)
      return System.Storage_Elements.Storage_Count;

   procedure Allocate
     (Pool         : in out Empty_Pool;
      Address      : out System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Deallocate
     (Pool         : in out Empty_Pool;
      Address      : System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Initialize (Pool : in out Empty_Pool);
   procedure Finalize   (Pool : in out Empty_Pool);

   --  The only actual instance of this type

   Empty_Pool_Object : Empty_Pool;

end System.Pool_Empty;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri May 27 15:31:33 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat May 28 00:34:02 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Wed Jun  1 23:25:35 1994;  author: dewar
--  Remove use clauses (unit is with'ed by Rtsfind)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
