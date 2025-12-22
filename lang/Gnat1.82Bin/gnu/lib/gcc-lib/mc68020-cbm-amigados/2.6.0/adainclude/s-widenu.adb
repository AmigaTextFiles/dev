------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . W I D _ E N U M                       --
--                                                                          --
--                                 S p e c                                  --
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

with Unchecked_Conversion;

package body System.Wid_Enum is

   -----------------------
   -- Width_Enumeration --
   -----------------------

   function Width_Enumeration
     (Table  : Address;
      Lo, Hi : Natural)
      return   Natural
   is
      type String_Access is access String;
      type Enum_Table is array (Natural) of String_Access;
      type Enum_Table_Ptr is access Enum_Table;
      function A_To_T is new Unchecked_Conversion (Address, Enum_Table_Ptr);

      T : constant Enum_Table_Ptr := A_To_T (Table);
      W : Natural;

   begin
      W := 0;

      for J in Lo .. Hi loop
         W := Natural'Max (W, T (J)'Length);
      end loop;

      return W;
   end Width_Enumeration;

end System.Wid_Enum;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 01:02:14 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:32:42 1994;  author: dewar
--  New name of function is Width_Enumeration
--  New name of package is Wid_Enum
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
