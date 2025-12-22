------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ C H A R                       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.5 $                              --
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

with System.Val_Util; use System.Val_Util;

package body System.Val_Char is

   ---------------------
   -- Value_Character --
   ---------------------

   function Value_Character (Str : String) return Character is
      F : Natural;
      L : Natural;
      S : String (Str'range) := Str;

   begin
      Normalize_String (S, F, L);

      --  Accept any single character enclosed in quotes

      if L - F = 2 and then S (F) = ''' and then S (L) = ''' then
         return Character'Val (Character'Pos (S (F + 1)));

      --  Check control character cases

      else
         for C in Character'Val (16#00#) .. Character'Val (16#1F#) loop
            if S (F .. L) = Character'Image (C) then
               return C;
            end if;
         end loop;

         for C in Character'Val (16#7F#) .. Character'Val (16#9F#) loop
            if S (F .. L) = Character'Image (C) then
               return C;
            end if;
         end loop;

         raise Constraint_Error;
      end if;

   end Value_Character;

end System.Val_Char;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Sat May 28 09:14:14 1994;  author: figueroa
--  Remove trailing spaces in header
--  ----------------------------
--  revision 1.4
--  date: Fri Aug  5 15:07:11 1994;  author: dewar
--  Handle names for control characters (like NUL)
--  ----------------------------
--  revision 1.5
--  date: Sat Aug  6 17:01:14 1994;  author: dewar
--  Make into package for Rtsfind
--  Change name from Value_C to Val_Char
--  Normalize_String is now in Val_Util
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
