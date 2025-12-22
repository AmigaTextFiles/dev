------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ R E A L                       --
--                                                                          --
--                                 S p e c                                  --
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

with System.Powten_Table; use System.Powten_Table;
with System.Val_Util;     use System.Val_Util;

package body System.Val_Real is

   ---------------
   -- Scan_Real --
   ---------------

   function Scan_Real
     (Str  : String;
      Ptr  : access Positive'Base;
      Max  : Positive'Base)
      return Long_Long_Float
   is
      P : Positive'Base;
      --  Local copy of string pointer

      Base   : Long_Long_Float;
      --  Base value

      Uval : Long_Long_Float;
      --  Accumulated float result

      subtype Digs is Character range '0' .. '9';
      --  Used to check for decimal digit

      Scale : Integer := 0;
      --  Power of Base to multiply result by

      Start : Positive;
      --  Position of starting non-blank character

      Minus : Boolean;
      --  Set to True if minus sign is present, otherwise to False

      Bad_Base : Boolean := False;
      --  Set True if Base out of range or if out of range digit

      After_Point : Natural := 0;
      --  Set to 1 after the point

      procedure Scanf;
      --  Scans integer literal value starting at current character position.
      --  For each digit encountered, Uval is multiplied by 10.0, and the new
      --  digit value is incremented. In addition Scale is decremented for each
      --  digit encountered if we are after the point (After_Point = 1). The
      --  longest possible syntactically valid numeral is scanned out, and on
      --  return P points past the last character. On entry, the current
      --  character is known to be a digit, so a numeral is definitely present.

      procedure Scanf is
         Digit : Natural;

      begin
         loop
            Digit := Character'Pos (Str (P)) - Character'Pos ('0');
            Uval := Uval * 10.0 + Long_Long_Float (Digit);
            P := P + 1;
            Scale := Scale - After_Point;

            --  Done if end of input field

            if P > Max then
               return;

            --  Non-digit encountered

            elsif Str (P) not in Digs then

               --  If syntactically valid underline, just skip it

               if Str (P) = '_'
                 and then P < Max
                 and then Str (P + 1) in Digs
               then
                  P := P + 1;

               --  If any other non-digit, return

               else
                  return;
               end if;
            end if;
         end loop;
      end Scanf;

   --  Start of processing for System.Scan_Real

   begin
      Scan_Sign (Str, Ptr, Max, Minus, Start);
      P := Ptr.all;
      Ptr.all := Start;

      --  If digit, scan numeral before point

      if Str (P) in Digs then
         Uval := 0.0;
         Scanf;

      --  Initial point, allowed only if followed by digit (RM 3.5(47))

      elsif Str (P) = '.'
        and then P < Max
        and then Str (P + 1) in Digs
      then
         Uval := 0.0;

      --  Any other initial character is an error

      else
         raise Constraint_Error;
      end if;

      --  Deal with based case

      if P < Max and then (Str (P) = ':' or else Str (P) = '#') then
         declare
            Base_Char : constant Character := Str (P);
            Digit     : Natural;
            Fdigit    : Long_Long_Float;

         begin
            if Uval < 2.0 or else Uval > 16.0 then
               Bad_Base := True;
            end if;

            Base := Uval;
            Uval := 0.0;
            P := P + 1;

            --  Special check to allow initial point (RM 3.5(49))

            if Str (P) = '.' then
               After_Point := 1;
               P := P + 1;
            end if;

            --  Loop to scan digits of based number. On entry to the loop we
            --  must have a valid digit. If we don't, then we have an illegal
            --  floating-point value, and we raise Constraint_Error, note that
            --  Ptr at this stage was reset to the proper (Start) value.

            loop
               if P > Max then
                  raise Constraint_Error;

               elsif Str (P) in Digs then
                  Digit := Character'Pos (Str (P)) - Character'Pos ('0');

               elsif Str (P) in 'A' .. 'F' then
                  Digit :=
                    Character'Pos (Str (P)) - (Character'Pos ('A') - 10);

               elsif Str (P) in 'a' .. 'f' then
                  Digit :=
                    Character'Pos (Str (P)) - (Character'Pos ('a') - 10);

               else
                  raise Constraint_Error;
               end if;

               P := P + 1;
               Fdigit := Long_Long_Float (Digit);

               if Fdigit >= Base then
                  Bad_Base := True;
               else
                  Scale := Scale - After_Point;
                  Uval := Uval * Base + Fdigit;
               end if;

               --  Error if no base character after digit scanned

               if P > Max then
                  raise Constraint_Error;

               --  Just skip past underline (we will require digit after it)

               elsif Str (P) = '_' then
                  P := P + 1;

               else
                  --  Skip past period after digit. Note that the processing
                  --  here will permit either a digit after the period, or the
                  --  terminating base character, as allowed in (RM 3.5(48))

                  if Str (P) = '.' and then After_Point = 0 then
                     P := P + 1;
                     After_Point := 1;

                     if P > Max then
                        raise Constraint_Error;
                     end if;
                  end if;

                  --  Terminating base character is recognized only if it
                  --  appears after a point, otherwise it is illegal

                  exit when Str (P) = Base_Char and then After_Point = 1;
               end if;
            end loop;

            --  Based number successfully scanned out (point was found)

            Ptr.all := P + 1;
         end;

      --  Non-based case, we must be at a point now

      else
         if Str (P) /= '.' then
            raise Constraint_Error;

         else
            Base := 10.0;
            After_Point := 1;
            P := P + 1;

            --  Scan digits after point if any are present (RM 3.5(46))

            if P <= Max and then Str (P) in Digs then
               Scanf;
            end if;

            Ptr.all := P;
         end if;
      end if;

      --  At this point, we have Uval containing the digits of the value as
      --  an integer, and Scale indicates the negative of the number of digits
      --  after the point. Base contains the base value (an integral value in
      --  the range 2.0 .. 16.0). Test for exponent, must be at least one
      --  character after the E for the exponent to be valid.

      Scale := Scale + Scan_Exponent (Str, Ptr, Max, Real => True);

      --  At this point the exponent has been scanned if one is present and
      --  Scale is adjusted to include the exponent value. Uval contains the
      --  the integral value which is to be multiplied by Base ** Scale.

      --  If base is not 10, use exponentiation for scaling

      if Base /= 10.0 then
         Uval := Uval * Base ** Scale;

      --  For base 10, use power of ten table if in range

      elsif Scale > 0 then
         if Scale > Powten'Length then
            Uval := Uval * 10.0 ** Scale;
         else
            Uval := Uval * Powten (Scale);
         end if;

      elsif Scale < 0 then
         if (-Scale) > Powten'Length then
            Uval := Uval * 10.0 ** Scale;
         else
            Uval := Uval / Powten (-Scale);
         end if;
      end if;

      --  Here is where we check for a bad based number

      if Bad_Base then
         raise Constraint_Error;

      --  If OK, then deal with initial minus sign, note that this processing
      --  is done even if Uval is zero, so that -0.0 is correctly interpreted.

      else
         if Minus then
            return -Uval;
         else
            return Uval;
         end if;
      end if;

   end Scan_Real;

   ----------------
   -- Value_Real --
   ----------------

   function Value_Real (Str : String) return Long_Long_Float is
      V : Long_Long_Float;
      P : aliased Natural := 1;

   begin
      V := Scan_Real (Str, P'Access, Str'Last);
      Scan_Trailing_Blanks (Str, P);
      return V;

   end Value_Real;

end System.Val_Real;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Fri Aug  5 15:06:57 1994;  author: dewar
--  Change name from System.Scan_xx to System.Scn_xx
--  ----------------------------
--  revision 1.3
--  date: Sat Aug  6 17:02:21 1994;  author: dewar
--  Change name of package from Value_Real to Val_Real
--  Move Scan_Real here (was in separate package)
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 31 00:06:47 1994;  author: dewar
--  (Scan_Real): Change Max/Ptr to Positive'Base to deal with null string
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
