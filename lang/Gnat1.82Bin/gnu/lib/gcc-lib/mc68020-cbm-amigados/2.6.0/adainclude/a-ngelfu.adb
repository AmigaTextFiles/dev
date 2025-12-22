------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                ADA.NUMERICS.GENERIC_ELEMENTARY_FUNCTIONS                 --
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

--  This body is specifically for using an Ada interface to C math.h to get
--  the computation engine. Many special cases are handled locally to avoid
--  unnecessary calls. This is not a "strict" implementation, but takes full
--  advantage of the C functions, e.g. in providing interface to hardware
--  provided versions of the elementary functions.

--  A known weakness is that on the x86, all computation is done in Double,
--  which means that a lot of accuracy is lost for the Long_Long_Float case.

--  Uses functions sqrt, exp, log, pow, sin, asin, cos, acos, tan, atan,
--  sinh, cosh, tanh from C library via math.h

with Ada.Numerics.Aux;

package body Ada.Numerics.Generic_Elementary_Functions is

   Log_Two : constant := 0.69314_71805_59945_30941_72321_21458_17656_80755;

   Two_Pi     : constant Float_Type'Base := 2.0 * Pi;
   Half_Pi    : constant Float_Type'Base := Pi / 2.0;
   Fourth_Pi  : constant Float_Type'Base := Pi / 4.0;
   Epsilon    : constant Float_Type'Base := Float_Type'Base'Epsilon;
   IEpsilon   : constant Float_Type'Base := 1.0 / Epsilon;

   subtype Double is Aux.Double;

   DEpsilon    : constant Double := Double (Epsilon);
   DIEpsilon   : constant Double := Double (IEpsilon);
   DFloat_Last : constant Double := Double (Float_Type'Base'Last);

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Exact_Remainder
     (X    : Float_Type'Base;
      Y    : Float_Type'Base)
      return Float_Type'Base;
   --  Computes exact remainder of X divided by Y

   function Half_Log_Epsilon return Float_Type'Base;
   --  Function to provide constant: 0.5 * Log (Epsilon)

   function Local_Atan
     (Y    : Float_Type'Base;
      X    : Float_Type'Base := 1.0)
      return Float_Type'Base;
   --  Common code for arc tangent after cyele reduction

   function Log_Inverse_Epsilon return Float_Type'Base;
   --  Function to provide constant: Log (1.0 / Epsilon)

   function Log_Last return Float_Type'Base;
   --  Function to provide constant: Log (Float_Last)

   function Square_Root_Epsilon return Float_Type'Base;
   --  Function to provide constant: Sqrt (Epsilon)

   ----------
   -- "**" --
   ----------

   function "**" (Left, Right : Float_Type'Base) return Float_Type'Base is
      Result : Float_Type'Base;

   begin
      if Left = 0.0
        and then Right = 0.0
      then
         raise Argument_Error;

      elsif Left < 0.0 then
         raise Argument_Error;

      elsif Right = 0.0 then
         return 1.0;

      elsif Left = 0.0 then
         if Right < 0.0 then
            raise Constraint_Error;
         else
            return 0.0;
         end if;

      elsif Left = 1.0 then
         return 1.0;

      elsif Right = 1.0 then
         return Left;

      elsif Right = 2.0 then
         return Left * Left;
      end if;

      return Float_Type'Base (Aux.pow (Double (Left), Double (Right)));

   exception
      when others =>
         raise Constraint_Error;
   end "**";

   ------------
   -- Arccos --
   ------------

   --  Natural cycle

   function Arccos (X : Float_Type'Base) return Float_Type'Base is
      Temp : Float_Type'Base;

   begin
      if abs X > 1.0 then
         raise Argument_Error;

      elsif abs X < Square_Root_Epsilon then
         return Pi / 2.0;

      elsif X = 1.0 then
         return 0.0;

      elsif X = -1.0 then
         return Pi;
      end if;

      Temp := Float_Type'Base (Aux.acos (Double (X)));

      if Temp < 0.0 then
         Temp := Pi + Temp;
      end if;

      return Temp;
   end Arccos;

   --  Arbitrary cycle

   function Arccos (X, Cycle : Float_Type'Base) return Float_Type'Base is
      Temp : Float_Type'Base;

   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif abs X > 1.0 then
         raise Argument_Error;

      elsif abs X < Square_Root_Epsilon then
         return Cycle / 4.0;

      elsif X = 1.0 then
         return 0.0;

      elsif X = -1.0 then
         return Cycle / 2.0;
      end if;

      Temp := Arctan (Sqrt (1.0 - X * X) / X, 1.0, Cycle);

      if Temp < 0.0 then
         Temp := Cycle / 2.0 + Temp;
      end if;

      return Temp;
   end Arccos;

   -------------
   -- Arccosh --
   -------------

   function Arccosh (X : Float_Type'Base) return Float_Type'Base is
   begin
      --  Return Log (X - Sqrt (X * X - 1.0));  double valued,
      --    only positive value returned
      --  What is this comment ???

      if X < 1.0 then
         raise Argument_Error;

      elsif X < 1.0 + Square_Root_Epsilon then
         return X - 1.0;

      elsif abs X > 1.0 / Square_Root_Epsilon then
         return Log (X) + Log_Two;

      else
         return Log (X + Sqrt (X * X - 1.0));
      end if;
   end Arccosh;

   ------------
   -- Arccot --
   ------------

   --  Natural cycle

   function Arccot
     (X    : Float_Type'Base;
      Y    : Float_Type'Base := 1.0)
      return Float_Type'Base
   is
   begin
      --  Just reverse arguments

      return Arctan (Y, X);
   end Arccot;

   --  Arbitrary cycle

   function Arccot
     (X     : Float_Type'Base;
      Y     : Float_Type'Base := 1.0;
      Cycle : Float_Type'Base)
      return  Float_Type'Base
   is
   begin
      --  Just reverse arguments

      return Arctan (Y, X, Cycle);
   end Arccot;

   -------------
   -- Arccoth --
   -------------

   function Arccoth (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X = 1.0 then
         raise Constraint_Error;

      elsif abs X < 1.0 then
         raise Argument_Error;

      elsif abs X > 1.0 / Epsilon then
         return 0.0;

      else
         return 0.5 * Log ((1.0 + X) / (X - 1.0));
      end if;
   end Arccoth;

   ------------
   -- Arcsin --
   ------------

   --  Natural cycle

   function Arcsin (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X > 1.0 then
         raise Argument_Error;

      elsif abs X < Square_Root_Epsilon then
         return X;

      elsif X = 1.0 then
         return Pi / 2.0;

      elsif X = -1.0 then
         return -Pi / 2.0;
      end if;

      return Float_Type'Base (Aux.asin (Double (X)));
   end Arcsin;

   --  Arbitrary cycle

   function Arcsin (X, Cycle : Float_Type'Base) return Float_Type'Base is
   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif abs X > 1.0 then
         raise Argument_Error;

      elsif X = 0.0 then
         return X;

      elsif X = 1.0 then
         return Cycle / 4.0;

      elsif X = -1.0 then
         return -Cycle / 4.0;
      end if;

      return Arctan (X / Sqrt (1.0 - X * X), 1.0, Cycle);
   end Arcsin;

   -------------
   -- Arcsinh --
   -------------

   function Arcsinh (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X < Square_Root_Epsilon then
         return X;

      elsif X > 1.0 / Square_Root_Epsilon then
         return Log (X) + Log_Two;

      elsif X < -1.0 / Square_Root_Epsilon then
         return -(Log (-X) + Log_Two);

      elsif X < 0.0 then
         return -Log (abs X + Sqrt (X * X + 1.0));

      else
         return Log (X + Sqrt (X * X + 1.0));
      end if;
   end Arcsinh;

   ------------
   -- Arctan --
   ------------

   --  Natural cycle

   function Arctan
     (Y    : Float_Type'Base;
      X    : Float_Type'Base := 1.0)
      return Float_Type'Base
   is
      T : Float_Type'Base;

   begin
      if X = 0.0
        and then Y = 0.0
      then
         raise Argument_Error;

      elsif Y = 0.0 then
         if X > 0.0 then
            return 0.0;
         else -- X < 0.0
            return Pi;
         end if;

      elsif X = 0.0 then
         if Y > 0.0 then
            return Half_Pi;
         else -- Y < 0.0
            return -Half_Pi;
         end if;

      else
         return Local_Atan (Y, X);
      end if;
   end Arctan;

   --  Arbitrary cycle

   function Arctan
     (Y     : Float_Type'Base;
      X     : Float_Type'Base := 1.0;
      Cycle : Float_Type'Base)
      return  Float_Type'Base
   is
   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif X = 0.0
        and then Y = 0.0
      then
         raise Argument_Error;

      elsif Y = 0.0 then
         if X > 0.0 then
            return 0.0;
         else -- X < 0.0
            return Cycle / 2.0;
         end if;

      elsif X = 0.0 then
         if Y > 0.0 then
            return Cycle / 4.0;
         else -- Y < 0.0
            return -Cycle / 4.0;
         end if;

      else
         return Local_Atan (Y, X) *  Cycle / Two_Pi;
      end if;
   end Arctan;

   -------------
   -- Arctanh --
   -------------

   function Arctanh (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X = 1.0 then
         raise Constraint_Error;

      elsif abs X > 1.0 then
         raise Argument_Error;

      elsif abs X < Square_Root_Epsilon then
         return X;

      else
         return 0.5 * Log ((1.0 + X) / (1.0 - X));
      end if;
   end Arctanh;

   ---------
   -- Cos --
   ---------

   --  Natural cycle

   function Cos (X : Float_Type'Base) return Float_Type'Base is
   begin
      if X = 0.0 then
         return 1.0;

      elsif abs X < Square_Root_Epsilon then
         return 1.0;

      end if;

      return Float_Type'Base (Aux.Cos (Double (X)));
   end Cos;

   --  Arbitrary cycle

   function Cos (X, Cycle : Float_Type'Base) return Float_Type'Base is
      T : Float_Type'Base;

   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif X = 0.0 then
         return 1.0;
      end if;

      T := Exact_Remainder (abs (X), Cycle) / Cycle;

      if T = 0.25
        or else T = 0.75
        or else T = -0.25
        or else T = -0.75
      then
         return 0.0;

      elsif T = 0.5 or T = -0.5 then
         return -1.0;
      end if;

      return Float_Type'Base (Aux.Cos (Double (T * Two_Pi)));
   end Cos;

   ----------
   -- Cosh --
   ----------

   function Cosh (X : Float_Type'Base) return Float_Type'Base is
      Exp_X : Float_Type'Base;

   begin
      if abs X < Square_Root_Epsilon then
         return 1.0;

      elsif abs X > Log_Inverse_Epsilon then
         return Exp ((abs X) - Log_Two);
      end if;

      return Float_Type'Base (Aux.cosh (Double (X)));

   exception
      when others =>
         raise Constraint_Error;
   end Cosh;

   ---------
   -- Cot --
   ---------

   --  Natural cycle

   function Cot (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X < Square_Root_Epsilon then
         return 1.0 / X;
      end if;

      return 1.0 / Float_Type'Base (Aux.tan (Double (X)));
   end Cot;

   --  Arbitrary cycle

   function Cot (X, Cycle : Float_Type'Base) return Float_Type'Base is
   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif abs X < Square_Root_Epsilon then
         return 1.0 / X;
      end if;

      return  Cos (X, Cycle) / Sin (X, Cycle);
   end Cot;

   ----------
   -- Coth --
   ----------

   function Coth (X : Float_Type'Base) return Float_Type'Base is
   begin
      if X < Half_Log_Epsilon then
         return -1.0;

      elsif X > -Half_Log_Epsilon then
         return 1.0;

      elsif abs X < Square_Root_Epsilon then
         return 1.0 / X;
      end if;

      return 1.0 / Float_Type'Base (Aux.tanh (Double (X)));
   end Coth;

   ---------------------
   -- Exact_Remainder --
   ---------------------

   function Exact_Remainder
     (X    : Float_Type'Base;
      Y    : Float_Type'Base)
      return Float_Type'Base
   is
      Denominator : Float_Type'Base := abs X;
      Divisor     : Float_Type'Base := abs Y;
      Reducer     : Float_Type'Base;
      Sign        : Float_Type'Base := 1.0;

   begin
      if Y = 0.0 then
         raise Constraint_Error;

      elsif X = 0.0 then
         return 0.0;

      elsif X = Y then
         return 0.0;

      elsif Denominator < Divisor then
         return X;
      end if;

      while Denominator >= Divisor loop

         --  Put divisors mantissa with denominators exponent to make reducer

         Reducer := Divisor;

         begin
            while Reducer * 1_048_576.0 < Denominator loop
               Reducer := Reducer * 1_048_576.0;
            end loop;

         exception
            when others => null;
         end;

         begin
            while Reducer * 1_024.0 < Denominator loop
               Reducer := Reducer * 1_024.0;
            end loop;

         exception
            when others => null;
         end;

         begin
            while Reducer * 2.0 < Denominator loop
               Reducer := Reducer * 2.0;
            end loop;

         exception
            when others => null;
         end;

         Denominator := Denominator - Reducer;
      end loop;

      if X < 0.0 then
         return -Denominator;
      else
         return Denominator;
      end if;
   end Exact_Remainder;

   ---------
   -- Exp --
   ---------

   function Exp (X : Float_Type'Base) return Float_Type'Base is
      Result : Float_Type'Base;

   begin
      if X = 0.0 then
         return 1.0;
      elsif X > Log_Last then
         raise Constraint_Error;
      end if;

      return Float_Type'Base (Aux.Exp (Double (X)));

   exception
      when others =>
         raise Constraint_Error;
   end Exp;

   ----------------------
   -- Half_Log_Epsilon --
   ----------------------

   --  Cannot precompute this constant, because this is required to be a
   --  pure package, which allows no state. A pity, but no way around it!

   function Half_Log_Epsilon return Float_Type'Base is
   begin
      return 0.5 * Float_Type'Base (Aux.Log (DEpsilon));
   end Half_Log_Epsilon;

   ----------------
   -- Local_Atan --
   ----------------

   function Local_Atan
     (Y    : Float_Type'Base;
      X    : Float_Type'Base := 1.0)
      return Float_Type'Base
   is
      Z        : Float_Type'Base;
      Raw_Atan : Float_Type'Base;

   begin
      if abs Y > abs X then
         Z := abs (X / Y);
      else
         Z := abs (Y / X);
      end if;

      if Z < Square_Root_Epsilon then
         Raw_Atan := Z;

      elsif Z = 1.0 then
         Raw_Atan := Pi / 4.0;

      elsif Z < Square_Root_Epsilon then
         Raw_Atan := Z;

      else
         Raw_Atan := Float_Type'Base (Aux.Atan (Double (Z)));
      end if;

      if abs Y > abs X then
         Raw_Atan := Half_Pi - Raw_Atan;
      end if;

      if X > 0.0 then
         if Y > 0.0 then
            return Raw_Atan;
         else                 --  Y < 0.0
            return -Raw_Atan;
         end if;

      else                    --  X < 0.0
         if Y > 0.0 then
            return Pi - Raw_Atan;
         else                  --  Y < 0.0
            return -(Pi - Raw_Atan);
         end if;
      end if;
   end Local_Atan;

   ---------
   -- Log --
   ---------

   --  Natural base

   function Log (X : Float_Type'Base) return Float_Type'Base is
   begin
      if X < 0.0 then
         raise Argument_Error;

      elsif X = 0.0 then
         raise Constraint_Error;

      elsif X = 1.0 then
         return 0.0;
      end if;

      return Float_Type'Base (Aux.Log (Double (X)));
   end Log;

   --  Arbitrary base

   function Log (X, Base : Float_Type'Base) return Float_Type'Base is
   begin
      if X < 0.0 then
         raise Argument_Error;

      elsif Base <= 0.0 or else Base = 1.0 then
         raise Argument_Error;

      elsif X = 0.0 then
         raise Constraint_Error;

      elsif X = 1.0 then
         return 0.0;
      end if;

      return Float_Type'Base (Aux.Log (Double (X)) / Aux.Log (Double (Base)));
   end Log;

   -------------------------
   -- Log_Inverse_Epsilon --
   -------------------------

   --  Cannot precompute this constant, because this is required to be a
   --  pure package, which allows no state. A pity, but no way around it!

   function Log_Inverse_Epsilon return Float_Type'Base is
   begin
      return Float_Type'Base (Aux.Log (DIEpsilon));
   end Log_Inverse_Epsilon;

   --------------
   -- Log_Last --
   --------------

   --  Cannot precompute this constant, because this is required to be a
   --  pure package, which allows no state. A pity, but no way around it!

   function Log_Last return Float_Type'Base is
   begin
      return Float_Type'Base (Aux.log (DFloat_Last));
   end Log_Last;

   ---------
   -- Sin --
   ---------

   --  Natural cycle

   function Sin (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X < Square_Root_Epsilon then
         return X;
      end if;

      return Float_Type'Base (Aux.Sin (Double (X)));
   end Sin;

   --  Arbitrary cycle

   function Sin (X, Cycle : Float_Type'Base) return Float_Type'Base is
      T : Float_Type'Base;

   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif X = 0.0 then
         return X;
      end if;

      T := Exact_Remainder (X, Cycle) / Cycle;

      if T = 0.0 or T = 0.5 or T = -0.5 then
         return 0.0;

      elsif T = 0.25 or T = -0.75 then
         return 1.0;

      elsif T = -0.25 or T = 0.75 then
         return -1.0;

      end if;

      return  Float_Type'Base (Aux.Sin (Double (T * Two_Pi)));
   end Sin;

   ----------
   -- Sinh --
   ----------

   function Sinh (X : Float_Type'Base) return Float_Type'Base is
      Exp_X : Float_Type'Base;

   begin
      if abs X < Square_Root_Epsilon then
         return X;

      elsif  X > Log_Inverse_Epsilon then
         return Exp (X - Log_Two);

      elsif X < -Log_Inverse_Epsilon then
         return -Exp ((-X) - Log_Two);
      end if;

      return Float_Type'Base (Aux.Sinh (Double (X)));

   exception
      when others =>
         raise Constraint_Error;
   end Sinh;

   -------------------------
   -- Square_Root_Epsilon --
   -------------------------

   --  Cannot precompute this constant, because this is required to be a
   --  pure package, which allows no state. A pity, but no way around it!

   function Square_Root_Epsilon return Float_Type'Base is
   begin
      return Float_Type'Base (Aux.Sqrt (DEpsilon));
   end Square_Root_Epsilon;

   ----------
   -- Sqrt --
   ----------

   function Sqrt (X : Float_Type'Base) return Float_Type'Base is
   begin
      if X < 0.0 then
         raise Argument_Error;

      --  Special case Sqrt (0.0) to preserve possible minus sign per IEEE

      elsif X = 0.0 then
         return X;

      --  Sqrt (1.0) must be exact for good complex accuracy

      elsif X = 1.0 then
         return 1.0;

      end if;

      return Float_Type'Base (Aux.Sqrt (Double (X)));
   end Sqrt;

   ---------
   -- Tan --
   ---------

   --  Natural cycle

   function Tan (X : Float_Type'Base) return Float_Type'Base is
   begin
      if abs X < Square_Root_Epsilon then
         return X;
      end if;

      return Float_Type'Base (Aux.tan (Double (X)));
   end Tan;

   --  Arbitrary cycle

   function Tan (X, Cycle : Float_Type'Base) return Float_Type'Base is
   begin
      if Cycle <= 0.0 then
         raise Argument_Error;

      elsif X = 0.0 then
         return X;
      end if;

      return Sin (X, Cycle) / Cos (X, Cycle);
   end Tan;

   ----------
   -- Tanh --
   ----------

   function Tanh (X : Float_Type'Base) return Float_Type'Base is
   begin
      if X < Half_Log_Epsilon then
         return -1.0;

      elsif X > -Half_Log_Epsilon then
         return 1.0;

      elsif abs X < Square_Root_Epsilon then
         return X;
      end if;

      return Float_Type'Base (Aux.tanh (Double (X)));
   end Tanh;

end Ada.Numerics.Generic_Elementary_Functions;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Feb 14 23:16:04 1994;  author: schonber
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Tue Feb 15 12:51:52 1994;  author: schonber
--  Change name of interface package to Ada.Numerics.Aux.
--  ----------------------------
--  revision 1.3
--  date: Fri Jul 22 12:25:38 1994;  author: dewar
--  Fix pragma Pure problems by introducing functions for the constants
--  Fairly extensive reformatting to GNAT standards
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
