------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          S Y S T E M . F F D                             --
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

package body System.Ffd is

   package body Ffd_Util is

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
        (X, Y, B : Int_Type;
         M       : Integer;
         Eps_Neg : Boolean)
         return    Int_Type
      is
         V, W : Int_Type          := 0;

      begin
         if M < 0 then
            W := Sign_Plus (-X) * (2 ** (-M) - 1);
         end if;

         if Eps_Neg then
            V := Sign (X * Y);
         end if;

         if M >= 0 then
            return V + Shift_Left (B * X + W, M) / Y;
         else
            return V + Shift_Right_Arithmetic (B * X + W, -M) / Y;
         end if;
      end Compute_Result;

   end Ffd_Util;

end System.Ffd;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul 15 13:28:17 1994;  author: crozes
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
