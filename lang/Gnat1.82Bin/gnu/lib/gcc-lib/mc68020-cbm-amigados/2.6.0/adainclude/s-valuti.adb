------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ U T I L                       --
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

package body System.Val_Util is

   ----------------------
   -- Normalize_String --
   ----------------------

   procedure Normalize_String
     (S    : in out String;
      F, L : out Positive'Base)
   is
   begin
      F := S'First;
      L := S'Last;

      --  Scan for leading spaces

      while F <= L and then S (F) = ' ' loop
         F := F + 1;
      end loop;

      --  Check for case when the string contained no characters

      if F > L then
         raise Constraint_Error;
      end if;

      --  Scan for trailing spaces

      while S (L) = ' ' loop
         L := L - 1;
      end loop;

      if S (F) /= ''' then

         --  Upper case any lower case characters.
         --  This needs to be expanded to handle Latin-1 upper half ???

         for J in F .. L loop
            if S (J) in 'a' .. 'z' then
               S (J) := Character'Val (Character'Pos (S (J)) - 32);
            end if;
         end loop;
      end if;

   end Normalize_String;

   ---------------
   -- Scan_Sign --
   ---------------

   procedure Scan_Sign
     (Str   : String;
      Ptr   : access Positive'Base;
      Max   : Positive'Base;
      Minus : out Boolean;
      Start : out Positive)
   is
      P : Natural := Ptr.all;

   begin
      --  Deal with case of null string (all blanks!). As per spec, we
      --  return with Ptr > Max (i.e. no change, since Ptr already > Max)

      if P > Max then
         return;
      end if;

      --  Scan past initial blanks

      while Str (P) = ' ' loop
         P := P + 1;

         if P > Max then
            Ptr.all := P;
            raise Constraint_Error;
         end if;
      end loop;

      Start := P;

      --  Remember an initial minus sign

      if Str (P) = '-' then
         Minus := True;
         P := P + 1;

         if P > Max then
            Ptr.all := Start;
            raise Constraint_Error;
         end if;

      --  Skip past an initial plus sign

      elsif Str (P) = '+' then
         Minus := False;
         P := P + 1;

         if P > Max then
            Ptr.all := Start;
            raise Constraint_Error;
         end if;

      else
         Minus := False;
      end if;

      Ptr.all := P;
   end Scan_Sign;

   -------------------
   -- Scan_Exponent --
   -------------------

   function Scan_Exponent
     (Str  : String;
      Ptr  : access Positive'Base;
      Max  : Positive'Base;
      Real : Boolean := False)
      return Integer
   is
      P : Natural := Ptr.all;
      M : Boolean;
      X : Integer;

   begin
      if P >= Max
        or else (Str (P) /= 'E' and then Str (P) /= 'e')
      then
         return 0;
      end if;

      --  We have an E/e, see if sign follows

      P := P + 1;

      if Str (P) = '+' then
         P := P + 1;

         if P > Max then
            return 0;
         else
            M := False;
         end if;

      elsif Str (P) = '-' then
         P := P + 1;

         if P > Max or else not Real then
            return 0;
         else
            M := True;
         end if;

      else
         M := False;
      end if;

      if Str (P) not in '0' .. '9' then
         return 0;
      end if;

      --  Scan out the exponent value as an unsigned integer. Values larger
      --  than (Integer'Last / 10) are simply considered large enough here.
      --  This assumption is correct for all machines we know of (e.g. in
      --  the case of 16 bit integers it allows exponents up to 3276, which
      --  is large enough for the largest floating types in base 2.

      X := 0;

      loop
         if X < (Integer'Last / 10) then
            X := X * 10 + (Character'Pos (Str (P)) - Character'Pos ('0'));
            P := P + 1;
         end if;

         exit when P > Max;

         if Str (P) = '_' and then P < Max then
            P := P + 1;
         end if;

         exit when P > Max or else Str (P) not in '0' .. '9';
      end loop;

      if M then
         X := -X;
      end if;

      Ptr.all := P;
      return X;

   end Scan_Exponent;

   --------------------------
   -- Scan_Trailing_Blanks --
   --------------------------

   procedure Scan_Trailing_Blanks (Str : String; P : Positive) is
      Max : constant Natural := Str'Last;

   begin
      for J in P .. Str'Last loop
         if Str (P) /= ' ' then
            raise Constraint_Error;
         end if;
      end loop;
   end Scan_Trailing_Blanks;

end System.Val_Util;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Aug  5 14:51:42 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 17:02:47 1994;  author: dewar
--  Change name from Scn_Utilities to Val_Util
--  Move Normalize_String here (was in separate file)
--  New calling sequence for Scan_Trailing_Blanks
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 31 00:07:03 1994;  author: dewar
--  (Normalize_String): Change F,L to Positive'Base (deal with null string)
--  (Scan_Sign): Document handling of null string, and change calling
--   sequence to accomodate null strings
--  (Scan_Exponent): Change Ptr/Max to Positive'Base to handle null strings
--  (Scan_Trailing_Blanks): Change P to Positive
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
