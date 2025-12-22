------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                           S Y S T E M . F I M                            --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
--                                                                          --
--             Copyright (c) 1992,1993, NYU, All Rights Reserved            --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms  of the GNU  General  Public  License  as  published  by the  Free --
-- Software  Foundation;  either version 2,  or (at your option)  any later --
-- version.  GNAT is distributed  in the hope  that it will be useful,  but --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANT- --
-- ABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public --
-- License  for  more details.  You should have received  a copy of the GNU --
-- General Public License along with GNAT;  see file COPYING. If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------

package body System.Fim is

   package body Fim_Util is

      -------------------------
      --  Local_Subprograms  --
      -------------------------

      function Sign (Int_Val : Int_Type) return Int_Type;
      --  This function returns 1 when the given value is positive or null, and
      --  -1 otherwize

      function Sign_Minus (Int_Val : Int_Type) return Int_Type;
      --  This function returns -1 when the given value is strictly negative,
      --  and 0  otherwize.

      function Half_Down (Int_Val : Int_Type) return Int_Type;
      --  This function returns half of the value given, after a rounding
      --  towards minus inifity.

      function Shift_Right_Arithmetic
        (Int_Val : Int_Type;
         M       : Natural)
         return    Int_Type;
      --  computes the shifted signed value towards the right of the given
      --  signed integer value with the given value M as parameter.

      pragma Import (Intrinsic, Shift_Right_Arithmetic);

      function Shift_Left
        (Int_Val : Int_Type;
         M       : Natural)
         return    Int_Type;
      --  computes the shifted signed value towards the left of the given
      --  signed integer value with the given value M as parameter.

      pragma Import (Intrinsic, Shift_Left);

      ----------------
      --  Half_Down --
      ----------------

      function Half_Down (Int_Val : Int_Type) return Int_Type is
      begin
         if Int_Val >= 0 then
            return Int_Val / 2;
         else
            return (Int_Val / 2) - 1;
         end if;
      end Half_Down;

      ------------
      --  Sign  --
      ------------

      function Sign (Int_Val : Int_Type) return Int_Type is
      begin
         if Int_Val >= 0 then
            return 1;
         else
            return -1;
         end if;
      end Sign;

      ------------------
      --  Sign_Minus  --
      ------------------

      function Sign_Minus (Int_Val : Int_Type) return Int_Type is
      begin
         if Int_Val >= 0 then
            return 0;
         else
            return -1;
         end if;
      end Sign_Minus;

      -------------
      --  Case1  --
      -------------

      function Case1
        (A, B, X, Y : Int_Type;
         M          : Natural)
         return       Int_Type
      is
         Z : constant Int_Type := X * Y;
         V : constant Int_Type := Shift_Left (Z * A, M);

      begin
         return (V + Sign (Z) * Half_Down (B)) / B;
      end Case1;

      -------------
      --  Case2  --
      -------------

      function Case2
        (A, B, X, Y : Int_Type;
         M          : Natural)
         return       Int_Type
      is
         V : constant Int_Type := A * X / B;
         W : constant Int_Type := (A * X rem B) * Y;

      begin
         return V + (W + Sign (X * Y) * Half_Down (B)) / B;
      end Case2;

      -------------
      --  Case3  --
      -------------

      function Case3
        (A, B, X, Y : Int_Type;
         M          : Natural)
         return       Int_Type
      is
         V : constant Int_Type := (A * X / B) * Y + (A * X rem B) * Y / B;

      begin
         return Shift_Right_Arithmetic (
           V + (2 ** (M - 1) + Sign_Minus (X * Y)), M);
      end Case3;

      -------------
      --  Case4  --
      -------------

      function Case4
        (A, B, X, Y : Int_Type;
         M          : Natural)
         return       Int_Type
      is
         Z : constant Int_Type := X * Y;
         V : constant Int_Type :=
               Z + ((A - B) * X / B) * Y + ((A - B) * X rem B) * Y / B;

      begin
         return Shift_Right_Arithmetic (
                  V + (2 ** (-M - 1) + Sign_Minus (Z)), M);
      end Case4;

   end Fim_Util;

end System.Fim;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul 15 13:30:11 1994;  author: crozes
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
