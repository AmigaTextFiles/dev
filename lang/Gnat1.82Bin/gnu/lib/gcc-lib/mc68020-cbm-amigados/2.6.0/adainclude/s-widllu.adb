------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W I D _ L L U                        --
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

with System.Unsigned_Types; use System.Unsigned_Types;

package body System.Wid_LLU is

   ------------------------------
   -- Width_Long_Long_Unsigned --
   ------------------------------

   function Width_Long_Long_Unsigned
     (Lo, Hi : Long_Long_Unsigned)
      return   Natural
   is
      W : Natural;
      T : Long_Long_Unsigned;

   begin
      if Lo > Hi then
         return 0;

      else
         --  Minimum value is 2, one for sign, one for digit

         W := 2;

         --  Get max of absolute values, but avoid bomb if we have the maximum
         --  negative number (note that First + 1 has same digits as First)

         T := Long_Long_Unsigned'Max (Lo, Hi);

         --  Increase value if more digits required

         while T >= 10 loop
            T := T / 10;
            W := W + 1;
         end loop;

         return W;
      end if;

   end Width_Long_Long_Unsigned;

end System.Wid_LLU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:42 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:33:08 1994;  author: dewar
--  New name of function is Width_Long_Long_Unsigned
--  New name of package is Wid_LLU
--  ----------------------------
--  revision 1.3
--  date: Tue Aug  9 07:29:44 1994;  author: dewar
--  Fix bad loop causing wrong value to be calculated
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
