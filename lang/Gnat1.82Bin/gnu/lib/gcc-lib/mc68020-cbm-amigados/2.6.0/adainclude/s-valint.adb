------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       S Y S T E M . V A L _ I N T                        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
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
with System.Val_Uns;        use System.Val_Uns;
with System.Val_Util;       use System.Val_Util;

package body System.Val_Int is

   ------------------
   -- Scan_Integer --
   ------------------

   function Scan_Integer
     (Str  : String;
      Ptr  : access Positive'Base;
      Max  : Positive'Base)
      return Integer
   is
      Uval : Unsigned;
      --  Unsigned result

      Minus : Boolean := False;
      --  Set to True if minus sign is present, otherwise to False

      Start : Positive;
      --  Saves location of first non-blank (not used in this case)

   begin
      Scan_Sign (Str, Ptr, Max, Minus, Start);
      Uval := Scan_Unsigned (Str, Ptr, Max);

      --  Deal with overflow cases, and also with maximum negative number

      if Uval > Unsigned (Integer'Last) then
         if Minus and then Uval = Unsigned (-(Integer'First)) then
            return Integer'First;
         else
            raise Constraint_Error;
         end if;

      --  Negative values

      elsif Minus then
         return -(Integer (Uval));

      --  Positive values

      else
         return Integer (Uval);
      end if;

   end Scan_Integer;

   -------------------
   -- Value_Integer --
   -------------------

   function Value_Integer (Str : String) return Integer is
      V : Integer;
      P : aliased Natural := 1;

   begin
      V := Scan_Integer (Str, P'Access, Str'Last);
      Scan_Trailing_Blanks (Str, P);
      return V;
   end Value_Integer;

end System.Val_Int;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Fri Aug  5 15:06:37 1994;  author: dewar
--  Change name from System.Scan_xx to System.Scn_xx
--  ----------------------------
--  revision 1.3
--  date: Sat Aug  6 17:01:41 1994;  author: dewar
--  Make into package for Rtsfind
--  Move Scan_Integer here (was in separate package)
--  Change name of package from Value_Integer to Val_Int
--  (Value_Integer): Use Scan_Trailing_Blanks
--  Utilities are now in Val_Util
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 31 00:06:22 1994;  author: dewar
--  (Scan_Integer): Change Max/Ptr to Positive'Base (null string case)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
