------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ E N U M                       --
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

with System.Val_Utilities; use System.Val_Utilities;
with Unchecked_Conversion;

package body System.Val_Enum is

   -----------------------
   -- Value_Enumeration --
   -----------------------

   function Value_Enumeration
     (A        : Address;
      Last_Pos : Natural;
      Str      : String)
      return     Natural
   is
      type String_Access is access String;
      type Enum_Table is array (Natural) of String_Access;
      type Enum_Table_Ptr is access Enum_Table;
      function A_To_T is new Unchecked_Conversion (Address, Enum_Table_Ptr);

      F : Natural;
      L : Natural;
      S : String (Str'range) := Str;
      T : constant Enum_Table_Ptr := A_To_T (A);

   begin
      Normalize_String (S, F, L);

      for J in 0 .. Last_Pos loop
         if T (J).all = S (F .. L) then
            return J;
         end if;
      end loop;

      raise Constraint_Error;

   end Value_Enumeration;

end System.Val_Enum;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Wed May 25 18:27:19 1994;  author: banner
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu May 26 02:35:20 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Sat Aug  6 17:01:28 1994;  author: dewar
--  Make into package for Rtsfind
--  Add pragma Pure
--  Function name is now Value_Enumeration
--  Package name is Val_Enum
--  Normalize_String is now in Val_Utilities
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
