------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          S Y S T E M . F F M                             --
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

package body System.Ffm is

   package body Ffm_Util is

      -------------------------
      --  Local_Subprograms  --
      -------------------------

      function Sign (Int_Val : Int_Type) return Int_Type;
      --  This function returns 1 when the given value is positive or null, and
      --  -1 otherwize

      function Sign_Plus (Int_Val : Int_Type) return Int_Type;
      --  This function returns 1 when the given value is positive or null,
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

      ----------------
      --  Sign_Plus --
      ----------------

      function Sign_Plus (Int_Val : Int_Type) return Int_Type is
      begin
         if Int_Val >= 0 then
            return 1;
         else
            return 0;
         end if;
      end Sign_Plus;

      --------------------
      -- Compute_Result --
      --------------------

      function Compute_Result
        (X, Y, A         : Int_Type;
         M               : Integer;
         B1, B2, Eps_Neg : Boolean)
         return    Int_Type

      is
         V, W : Int_Type          := 0;
         Z    : constant Int_Type := X * Y;

      begin
         if B1 then
            V := Sign (Z) * (A - 1);
         end if;

         if B2 and then M < 0 then
            if Eps_Neg then
               W := Sign_Plus (Z) * (2 ** (-M) - 1);
            else
               W := Sign_Plus (-Z) * (2 ** (-M) - 1);
            end if;
         end if;

         if M >= 0 then
            return (Shift_Left (Z + W, M) + V) / A;
         else
            return (Shift_Right_Arithmetic (Z + W, -M) + V) / A;
         end if;
      end Compute_Result;

   end Ffm_Util;

end System.Ffm;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul 15 13:29:18 1994;  author: crozes
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
