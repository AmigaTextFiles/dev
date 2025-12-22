------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          S Y S T E M . F I D                             --
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

package body System.Fid is

   package body Fid_Util is

      -------------------------
      --  Local_Subprograms  --
      -------------------------

      function Sign (Int_Val : Int_Type) return Int_Type;
      --  This function returns 1 when the given value is positive or null, and
      --  -1 otherwize

      function Sign_Minus (Int_Val : Int_Type) return Int_Type;
      --  This function returns -1 when the given value is strictly negative,
      --  and 0  otherwize.

      function Shift_Right_Arithmetic
        (Int_Val : Int_Type;
         M       : Natural)
         return    Int_Type;
      --  computes the shifted signed value towards the right of the given
      --  signed integer value with the given value M as parameter.

      pragma Import (Intrinsic, Shift_Right_Arithmetic);

      function Shift_Left (Int_Val : Int_Type; M : Natural) return Int_Type;
      --  computes the shifted signed value towards the left of the given
      --  signed integer value with the given value M as parameter.

      pragma Import (Intrinsic, Shift_Left);

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

      -----------------
      --  Sign_Minus --
      -----------------

      function Sign_Minus (Int_Val : Int_Type) return Int_Type is
      begin
         if Int_Val < 0 then
            return -1;
         else
            return 0;
         end if;
      end Sign_Minus;

      --------------------
      -- Compute_Result --
      --------------------

      function Compute_Result
        (X, Y, A, B, D, Beta1, Beta2 : Int_Type;
         M, N                        : Integer;
         Bool                        : Boolean)
         return                        Int_Type
      is
         Z     : constant Int_Type := X * Y;
         V, W  :          Int_Type := 0;

      begin
         if Bool then
            return Sign (Z) * (2 ** N - 1) + Sign_Minus (Z);

         elsif  M < 0 then

            if A = B and then Y = -1 then
               return Shift_Right_Arithmetic (
                        2 ** (-M - 1) + Sign_Minus (Z) - X, -M);

            elsif A <= B then
               return Shift_Right_Arithmetic (
                        (A * X / B) / Y + 2 ** (-M - 1) + Sign_Minus (Z), -M);

            elsif A < 2 * B then
               V := X + (A - B) * X / B;

               if Y = 1 or else Y = -1 then
                  return Shift_Right_Arithmetic (
                           Sign (Y) * V + 2 ** (-M - 1) + Sign_Minus (Z), -M);

               else
                  return Shift_Right_Arithmetic (
                            V / Y + 2 ** (-M - 1) + Sign_Minus (Z), -M);

               end if;
            end if;

         else
            if Y rem 2 = 1 then
               V := Sign (X) * ((B - 1) / 2);
            end if;

            V := (D * X + V) / B;
            W := Shift_Left (Beta1 * X, N) + Beta2 * X;

            return (W + V + Sign (X) * (abs (Y) / 2)) / Y;
         end if;

      end Compute_Result;

   end Fid_Util;

end System.Fid;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Jul 18 14:27:39 1994;  author: crozes
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
