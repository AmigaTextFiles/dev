------------------------------------------------------------------------------
--                                                                          --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS                --
--                                                                          --
--                    S Y S T E M . S T R I N G _ O P S                     --
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

package body System.String_Ops is

   ----------------
   -- Str_Concat --
   ----------------

   function Str_Concat (X, Y : String) return String is
   begin
      if X'Length <= 0 then
         return Y;

      else
         declare
            L : constant Natural := X'Length + Y'Length;
            R : String (X'First .. X'First + L - 1);

         begin
            R (X'range) := X;
            R (X'First + X'Length .. R'Last) := Y;
            return R;
         end;
      end if;
   end Str_Concat;

   ---------------
   -- Str_Equal --
   ---------------

   function Str_Equal (A, B : String) return Boolean is
   begin
      if A'Length /= B'Length then
         return False;
      else

         for J in A'range loop
            if A (J) /= B (J + (B'First - A'First)) then
               return False;
            end if;
         end loop;

         return True;
      end if;

   end Str_Equal;

end System.String_Ops;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Sat Jun  4 09:31:06 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Jun  4 09:35:26 1994;  author: dewar
--  This package replaces the former separate library subprograms
--   System.Str_Concat (s-strcon) and System.Str_Equal (s-strequ)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
