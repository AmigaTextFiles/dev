------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 S Y S T E M . S T O R A G E _ P O O L S                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.9 $                              --
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

with Ada.Finalization;
with System.Storage_Elements;

package System.Storage_Pools is

--   type Root_Storage_Pool is abstract
--     new Ada.Finalization.Limited_Controlled with private;
--   use above when private extensions are implemented ???

   type Root_Storage_Pool is abstract
     new Ada.Finalization.Limited_Controlled with null record;

   procedure Allocate
     (Pool                     : in out Root_Storage_Pool;
      Storage_Address          : out Address;
      Size_In_Storage_Elements : in Storage_Elements.Storage_Count;
      Alignment                : in Storage_Elements.Storage_Count)
   is abstract;

   procedure Deallocate
     (Pool                     : in out Root_Storage_Pool;
      Storage_Address          : in Address;
      Size_In_Storage_Elements : in Storage_Elements.Storage_Count;
      Alignment                : in Storage_Elements.Storage_Count)
   is abstract;

   function Storage_Size
     (Pool : Root_Storage_Pool)
      return Storage_Elements.Storage_Count
   is abstract;

private

--   type Root_Storage_Pool is abstract
--     new Ada.Finalization.Limited_Controlled with null record;
--   put in above when private extensions are implemented ???

end System.Storage_Pools;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.7
--  date: Fri Aug 19 20:27:55 1994;  author: comar
--  Introduce private extensions now that they work.
--  ----------------------------
--  revision 1.8
--  date: Thu Aug 25 18:40:12 1994;  author: comar
--  don't use private extension yet for the bootstrap sake
--  ----------------------------
--  revision 1.9
--  date: Mon Aug 29 23:42:16 1994;  author: dewar
--  Add some ??? comments
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
