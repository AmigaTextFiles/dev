------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . I M G _ R E A L                       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.14 $                             --
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

with System.Img_LLU;             use System.Img_LLU;
with System.Img_Uns;             use System.Img_Uns;
with System.Dependent_Constants; use System.Dependent_Constants;
with System.Powten_Table;        use System.Powten_Table;
with System.Unsigned_Types;      use System.Unsigned_Types;

package body System.Img_Real is

   Maxdigs : constant := 19;
   --  Maximum decimal digits for type Long_Long_Unsigned. We assume that this
   --  is large enough for the most accurate floating-point type around, which
   --  is probably correct for pretty much all machines we are likely to see.
   --  At worst, if this assumption is false, then we just loose some precision
   --  for high accuracy floating-point, and that's OK, since we only promise
   --  support of the numerics annex accuracy for IEEE machines anyway (and so
   --  far ther is no IEEE machine that would violate this assumption.
   --
   --  The 19 here should be replaced by Long_Long_Unsigned'Width - 2 ???.
   --  The -2 comes from 1 for the sign, and one for the extra digit, since
   --  we need the maximum number of 9's that can be supported, e.g. for the
   --  normal 64 bit case, Long_Long_Integer'Width is 21, since the maximum
   --  value (approx 1.6 * 10**19) has 20 digits.

   Unsdigs : constant := 9;
   --  Number of digits that can be converted using type Unsigned
   --  The 9 here should be replaced by Unsigned'Width - 2 ???.
   --  See above for the explanation of the -2.

   --------------------------------
   -- Image_Ordinary_Fixed_Point --
   --------------------------------

   function Image_Ordinary_Fixed_Point
     (V    : Long_Long_Float;
      S    : access String;
      Aft  : Natural)
      return Natural
   is
      P : Natural := 0;

   begin
      Set_Image_Real (V, S.all, P, 2, Aft, 0);
      return P;
   end Image_Ordinary_Fixed_Point;

   --------------------------
   -- Image_Floating_Point --
   --------------------------

   function Image_Floating_Point
     (V    : Long_Long_Float;
      S    : access String;
      Digs : Natural)
      return Natural
   is
      P : Natural := 0;

   begin
      Set_Image_Real (V, S.all, P, 2, Digs - 1, 4);
      return P;
   end Image_Floating_Point;

   --------------------
   -- Set_Image_Real --
   --------------------

   procedure Set_Image_Real
     (V    : Long_Long_Float;
      S    : out String;
      P    : in out Natural;
      Fore : Natural;
      Aft  : Natural;
      Exp  : Natural)
   is
      NFrac : constant Natural := Natural'Max (Aft, 1);
      Minus : Boolean;
      X     : Long_Long_Float;
      X1    : Long_Long_Float;
      X2    : Long_Long_Float;
      Scale : Integer;
      Expon : Integer;

      Digs : String (1 .. 2 * Field_Max);
      --  Array used to hold digits of converted integer value. This is a
      --  large enough buffer to accomodate ludicrous values of Fore and Aft.

      Ndigs : Natural;
      --  Number of digits stored in Digs (and also subscript of last digit)

      procedure Adjust_Scale (S : Natural);
      --  Adjusts the value in X by multiplying or dividing by a power of
      --  ten so that it is in the range 10**(S-1) <= X < 10**S. Includes
      --  adding 0.5 to round the result, readjusting if the rounding causes
      --  the result to wander out of the range. Scale is adjusted to reflect
      --  the power of ten used to divide the result (i.e. one is added to
      --  the scale value for each division by 10.0, or one is subtracted
      --  for each multiplication by 10.0).

      procedure Convert_Integer;
      --  Takes the value in X, outputs integer digits into Digs. On return,
      --  Ndigs is set to the number of digits stored. The digits are stored
      --  in Digs (1 .. Ndigs),

      procedure Set (C : Character);
      --  Sets character C in output buffer

      procedure Set_Blanks_And_Sign (N : Integer);
      --  Sets leading blanks and minus sign if needed. N is the number of
      --  positions to be filled (a minus sign is output even if N is zero
      --  or negative, but for a positive value, if N is non-positive, then
      --  the call has no effect).

      procedure Set_Digs (S, E : Natural);
      --  Set digits S through E from Digs buffer. No effect if S > E

      procedure Set_Zeros (N : Integer);
      --  Set N zeros, no effect if N is negative

      pragma Inline (Set);
      pragma Inline (Set_Digs);
      pragma Inline (Set_Zeros);

      procedure Adjust_Scale (S : Natural) is
         Lo  : Natural;
         Hi  : Natural;
         Mid : Natural;
         XP  : Long_Long_Float;

      begin
         --  Cases where scaling up is required

         if X < Powten (S - 1) then

            --  What we are looking for is a power of ten to multiply X by
            --  so that the result lies within the required range.

            loop
               XP := X * Powten (40);
               exit when XP >= Powten (S - 1);
               X := XP;
               Scale := Scale - 40;
            end loop;

            --  Here we know that we must mutiply by at least 10**1 and 10**40
            --  takes us too far, so use a binary search to find the right one.

            Lo := 1;
            Hi := 40;

            loop
               Mid := (Lo + Hi) / 2;
               XP := X * Powten (Mid);

               if XP < Powten (S - 1) then
                  Lo := Mid + 1;

               elsif XP >= Powten (S) then
                  Hi := Mid - 1;

               else
                  X := XP;
                  Scale := Scale - Mid;
                  exit;
               end if;
            end loop;

         --  Cases where scaling down is required

         elsif X >= Powten (S) then

            --  What we are looking for is a power of ten to divide X by
            --  so that the result lies within the required range.

            loop
               XP := X / Powten (40);
               exit when XP < Powten (S);
               X := XP;
               Scale := Scale + 40;
            end loop;

            --  Here we know that we must divide by at least 10**1 and 10**40
            --  takes us too far, so use a binary search to find the right one.

            Lo := 1;
            Hi := 40;

            loop
               Mid := (Lo + Hi) / 2;
               XP := X / Powten (Mid);

               if XP < Powten (S - 1) then
                  Hi := Mid - 1;

               elsif XP >= Powten (S) then
                  Lo := Mid + 1;

               else
                  X := XP;
                  Scale := Scale + Mid;
                  exit;
               end if;
            end loop;

         --  Here we are already scaled right

         else
            null;
         end if;

         --  Round, readjusting scale if needed. Note that if a readjustment
         --  occurs, then it is never necessary to round again, because there
         --  is no possibility of such a second rounding causing a change.

         X := X + 0.5;

         if X > Powten (S) then
            X := X / 10.0;
            Scale := Scale + 1;
         end if;

      end Adjust_Scale;

      procedure Convert_Integer is
      begin
         --  Use Unsigned routine if possible, since on many machines it will
         --  be significantly more efficient than the Long_Long_Unsigned one.

         if X < Powten (Unsdigs) then
            Ndigs := 0;
            Set_Image_Unsigned
              (Unsigned (Long_Long_Float'Truncation (X)),
               Digs, Ndigs);

         --  But if we want more digits than fit in Unsigned, we have to use
         --  the Long_Long_Unsigned routine after all.

         else
            Ndigs := 0;
            Set_Image_Long_Long_Unsigned
              (Long_Long_Unsigned (Long_Long_Float'Truncation (X)),
               Digs, Ndigs);
         end if;
      end Convert_Integer;

      procedure Set (C : Character) is
      begin
         P := P + 1;
         S (P) := C;
      end Set;

      procedure Set_Blanks_And_Sign (N : Integer) is
         W : Integer := N;

      begin
         if Minus then
            for J in 1 .. N - 1 loop
               Set (' ');
            end loop;

            Set ('-');

         else
            for J in 1 .. N loop
               Set (' ');
            end loop;
         end if;
      end Set_Blanks_And_Sign;

      procedure Set_Digs (S, E : Natural) is
      begin
         for J in S .. E loop
            Set (Digs (J));
         end loop;
      end Set_Digs;

      procedure Set_Zeros (N : Integer) is
      begin
         for J in 1 .. N loop
            Set ('0');
         end loop;
      end Set_Zeros;

   --  Start of processing for Set_Image_Real

   begin
      Scale := 0;

      --  Deal with sign (should handle negative zero eventually ???)

      if V >= 0.0 then
         X := V;
         Minus := False;
      else
         X := -V;
         Minus := True;
      end if;

      --  Zero needs to be handled specially

      if X = 0.0 then
         Set_Blanks_And_Sign (Fore - 1);
         Set ('0');
         Set ('.');
         Set_Zeros (NFrac);

         if Exp /= 0 then
            Set ('E');
            Set ('+');
            Set_Zeros (Exp - 1);
         end if;

         return;

      --  Case of non-zero value with Exp = 0

      elsif Exp = 0 then

         --  Multiply by 10 ** NFrac to get an integer value to output
         --  except that if we are already greater than 10**Maxdigs,
         --  or the multiplication would make us larger than that,
         --  then we don't want to do the multiplication after all.

         X1 := X;

         if X < Powten (Maxdigs) then
            X1 := X * Powten (NFrac);
         end if;

         --  If that makes us too large, it means that we have some digits
         --  in the output that are non-significant, and will be output as
         --  zeroes, so in this case we need to scale so that:

         --    10 ** (Maxdigs - 1) <= X < 10 ** Maxdigs

         if X1 >= Powten (Maxdigs) then
            Adjust_Scale (Maxdigs);
         else
            X := X1;
         end if;

         Convert_Integer;

         --  If we had to scale, then we certainly scaled down, i.e. Scale is
         --  the number of insignificant zero digits to be output at the end,
         --  so add them to the resulting integer value.

         for J in 1 .. Scale loop
            Ndigs := Ndigs + 1;
            Digs (Ndigs) := '0';
         end loop;

         --  If number of available digits is less or equal to NFrac,
         --  then we need an extra zero before the decimal point.

         if Ndigs <= NFrac then
            Set_Blanks_And_Sign (Fore - 1);
            Set ('0');
            Set ('.');
            Set_Zeros (NFrac - Ndigs);
            Set_Digs (1, Ndigs);

         --  Normal case with some digits before the decimal point

         else
            Set_Blanks_And_Sign (Fore - (Ndigs - NFrac));
            Set_Digs (1, Ndigs - NFrac);
            Set ('.');
            Set_Digs (Ndigs - NFrac + 1, Ndigs);
         end if;

      --  Case of non-zero value with non-zero Exp value

      else
         --  If NFrac is less than Maxdigs, then all the fraction digits are
         --  significant, so we can scale the resulting integer accordingly.

         if NFrac < Maxdigs then
            Adjust_Scale (NFrac + 1);
            Convert_Integer;

         --  Otherwise, we get the maximum number of digits available

         else
            Adjust_Scale (Maxdigs);
            Convert_Integer;

            for J in 1 .. NFrac - Maxdigs + 1 loop
               Ndigs := Ndigs + 1;
               Digs (Ndigs) := '0';
               Scale := Scale - 1;
            end loop;
         end if;

         Set_Blanks_And_Sign (Fore - 1);
         Set (Digs (1));
         Set ('.');
         Set_Digs (2, Ndigs);

         --  The exponent is the scaling factor adjusted for the digits
         --  that we output after the decimal point, since these were
         --  included in the scaled digits that we output.

         Expon := Scale + NFrac;

         Set ('E');
         Ndigs := 0;

         if Expon >= 0 then
            Set ('+');
            Set_Image_Unsigned (Unsigned (Expon), Digs, Ndigs);
         else
            Set ('-');
            Set_Image_Unsigned (Unsigned (-Expon), Digs, Ndigs);
         end if;

         Set_Zeros (Exp - Ndigs - 1);
         Set_Digs (1, Ndigs);
      end if;

   end Set_Image_Real;

end System.Img_Real;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.12
--  date: Mon Aug 22 15:18:05 1994;  author: dewar
--  Minor comment fixes
--  ----------------------------
--  revision 1.13
--  date: Wed Aug 24 23:27:31 1994;  author: dewar
--  (Image_Floating_Point): Fix some bugs in Exp=0 case
--  ----------------------------
--  revision 1.14
--  date: Thu Aug 25 16:33:26 1994;  author: dewar
--  (Image_Floating_Point): Fix bug of minus sign output before blanks
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
