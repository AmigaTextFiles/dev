------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                   S Y S T E M . P O O L _ G L O B A L                    --
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

with System;
with System.Storage_Pools;
with System.Storage_Elements;

package System.Pool_Global is

pragma Elaborate_Body;
--  Needed to ensure that library routines can execute allocators

   --  Allocation strategy:

   --    Call to malloc/free for each Allocate/Deallocate
   --    no user specifiable size
   --    no automatic reclaim
   --    minimal overhead

   --  Default pool in the compiler for access types globally declared

   type Unbounded_No_Reclaim_Pool is new
     System.Storage_Pools.Root_Storage_Pool with null record;

   function Storage_Size
     (Pool : Unbounded_No_Reclaim_Pool)
      return System.Storage_Elements.Storage_Count;

   procedure Allocate
     (Pool         : in out Unbounded_No_Reclaim_Pool;
      Address      : out System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   procedure Deallocate
     (Pool         : in out Unbounded_No_Reclaim_Pool;
      Address      : System.Address;
      Storage_Size : System.Storage_Elements.Storage_Count;
      Alignment    : System.Storage_Elements.Storage_Count);

   --  Pool object for the compiler

   Global_Pool_Object : Unbounded_No_Reclaim_Pool;

end System.Pool_Global;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri May 27 15:31:36 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat May 28 00:34:16 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Wed Jun  1 23:25:48 1994;  author: dewar
--  Remove use clauses (this unit is with'ed using Rtsfind)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
