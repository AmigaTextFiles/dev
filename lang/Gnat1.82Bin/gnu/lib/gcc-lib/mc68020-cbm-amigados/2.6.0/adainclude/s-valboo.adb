------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ B O O L                       --
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

package body System.Val_Bool is

   -------------------
   -- Value_Boolean --
   -------------------

   function Value_Boolean (Str : String) return Boolean is
      F : Natural;
      L : Natural;
      S : String (Str'range) := Str;

   begin
      Normalize_String (S, F, L);

      if S (F .. L) = "TRUE" then
         return True;
      end if;

      if S (F .. L) = "FALSE" then
         return False;
      end if;

      raise Constraint_Error;

      --  Above should use elsif, but this doesn't work in GNAT version 1.81???

   end Value_Boolean;

end System.Val_Bool;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Sat May 28 06:32:58 1994;  author: figueroa
--  Remove trailing spaces in header
--  ----------------------------
--  revision 1.4
--  date: Fri Aug  5 15:07:03 1994;  author: dewar
--  Avoid elsif construction (ran into bug in GNAT version 1.81)
--  ----------------------------
--  revision 1.5
--  date: Sat Aug  6 17:01:01 1994;  author: dewar
--  Make into package for Rtsfind
--  Change name from Value_B to Val_Bool
--  Normalize_String moved to Val_Util
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
