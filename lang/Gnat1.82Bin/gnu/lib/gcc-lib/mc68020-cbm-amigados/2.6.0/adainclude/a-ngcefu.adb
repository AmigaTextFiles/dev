------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . N U M E R I C S . G C E F                    --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
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

--  This is an early trial implementation, simplified for early gnat.
--  It is not a "strict" implementation.
--  All Ada required exception handling is provided.
--  Many special cases are handled locally to avoid unnecessary calls
 
with Ada.Numerics.Generic_Elementary_Functions;

package body Ada.Numerics.Generic_Complex_Elementary_Functions is

   package Elementary_Functions is new
      Ada.Numerics.Generic_Elementary_Functions (Real'Base);
   use Elementary_Functions;
 
   PI : constant := 3.14159_26535_89793_23846_26433_83279_50288_41971;
   PI_2 : constant := PI / 2.0;
   Log_Two : constant := 0.69314_71805_59945_30941_72321_21458_17656_80755;

   Epsilon : Real'Base;
   Square_Root_Epsilon     : Real'Base;
   Inv_Square_Root_Epsilon : Real'Base;
   Root_Root_Epsilon       : Real'Base;
   Log_Inverse_Epsilon_2   : Real'Base;
 
   Complex_Zero : constant Complex := Compose_From_Cartesian (0.0,  0.0);
   Complex_One  : constant Complex := Compose_From_Cartesian (1.0,  0.0);
   Complex_I    : constant Complex := Compose_From_Cartesian (0.0,  1.0);
   HALF_PI      : constant Complex := Compose_From_Cartesian (PI_2, 0.0);

   ----------
   -- Sqrt --
   ----------

   function Sqrt (X : Complex) return Complex is
      Z   : Complex := X; -- remove if definition gets fixed
      R   : Real'Base;
      R_X : Real'Base;
      R_Y : Real'Base;
      XR  : Real'Base := abs Re (Z);
      YR  : Real'Base := abs Im (Z);
      A   : Real'Base;
   begin

      if XR > YR then
         A := YR / XR;
         A := A * A;

         if A < 32.0 * Square_Root_Epsilon then

            if Re (Z) > 0.0 then
               R_X := Sqrt (XR + 0.5  *
                           (0.5 * YR * YR / XR - (YR * YR / XR) * A / 8.0));
               R_Y := Sqrt (0.5 *
                           (0.5 * YR * YR / XR - (YR * YR / XR) * A / 8.0));
            else
               R_X := Sqrt (0.5 *
                           (0.5 * YR * YR / XR - (YR * YR / XR) * A / 8.0));
               R_Y := Sqrt (XR + 0.5 *
                           (0.5 * YR * YR / XR - (YR * YR / XR) * A / 8.0));
            end if;

         else
            R  := XR * Sqrt (1.0 + A);
            R_X := Sqrt (0.5 *  (R + Re (Z)));
            R_Y := Sqrt (0.5 *  (R - Re (Z)));
         end if;

      else                                      -- YR > XR
         A := XR / YR;
         A := A * A;

         if A < 32.0 * Square_Root_Epsilon then -- YR >> XR
            R  := YR + 0.5 * XR * XR / YR - 0.125 *  (XR * XR / YR) * A;
            R_X := Sqrt (0.5 *  (YR + (0.5 * XR * XR / YR + Re (Z))));
            R_Y := Sqrt (0.5 *  (YR + (0.5 * XR * XR / YR - Re (Z))));
         else
            R  := YR * Sqrt (1.0 + A);
            R_X := Sqrt (0.5 *  (R + Re (Z)));
            R_Y := Sqrt (0.5 *  (R - Re (Z)));
         end if;
      end if;

      if Im (Z) < 0.0 then                 -- halve angle, Sqrt of magnitude
         R_Y := -R_Y;
      end if;
      return Compose_From_Cartesian (R_X, R_Y);

   exception
      when Constraint_Error =>
         R := Modulus (Compose_From_Cartesian (Re (Z / 4.0), Im (Z / 4.0)));
         R_X := 2.0 * Sqrt (0.5 * R + 0.5 * Re (Z / 4.0));
         R_Y := 2.0 * Sqrt (0.5 * R - 0.5 * Re (Z / 4.0));

         if Im (Z) < 0.0 then -- halve angle, Sqrt of magnitude
            R_Y := -R_Y;
         end if;

         return Compose_From_Cartesian (R_X, R_Y);
   end Sqrt;
 
   ---------
   -- Log --
   ---------
 
   function Log (X : Complex) return Complex is
      Z : Complex := X;
      RE_Z, IM_Z : Real'Base;
   begin

      if Re (Z) = 0.0 and then Im (Z) = 0.0 then
         raise Constraint_Error;

      elsif abs (1.0 - Re (Z)) < Root_Root_Epsilon and then
                      abs Im (Z) < Root_Root_Epsilon then
         Set_Re (Z, Re (Z) - 1.0);
         return (1.0 - (1.0 / 2.0 -
                       (1.0 / 3.0 - (1.0 / 4.0) * Z) * Z) * Z) * Z;
      end if;

      begin
         RE_Z := Log (Modulus (Z));
      exception
         when Constraint_Error =>
            RE_Z := Log (Modulus (Z / 2.0)) - Log_Two;
      end;

      IM_Z := Arctan (Im (Z), Re (Z));

      if IM_Z > PI then
         IM_Z := IM_Z - 2.0 * PI;
      end if;

      return Compose_From_Cartesian (RE_Z, IM_Z);
   end Log;
 
   ---------
   -- Exp --
   ---------
 
   function Exp (X : Complex) return Complex is
      Z : Complex := X;
      EXP_RE_Z : Real'Base := Exp (Re (Z));
   begin
      return Compose_From_Cartesian (EXP_RE_Z * Cos (Im (Z)),
                                     EXP_RE_Z * Sin (Im (Z)));
   end Exp;

 
   function Exp (X : Imaginary) return Complex is
      IM_Z : Real'Base := Im (X);
   begin
      return Compose_From_Cartesian (Cos (IM_Z), Sin (IM_Z));
   end Exp;

   --------
   -- ** --
   --------
  
   function "**"
     (Left : Complex;
     Right : Complex)
   return Complex is
      Z1 : Complex := Left;
      Z2 : Complex := Right;
   begin
      if Re (Z2) = 0.0 and then Im (Z2) = 0.0 and then
         Re (Z1) = 0.0 and then Im (Z1) = 0.0 then
         raise Argument_Error;

      elsif Re (Z1) = 0.0 and then Im (Z1) = 0.0 and then
             Re (Z2) < 0.0 then
         raise Constraint_Error;

      elsif Re (Z1) = 0.0 and then Im (Z1) = 0.0 then
         return Z1;

      elsif Re (Z2) = 0.0 and then Im (Z2) = 0.0 then
         return 1.0 + Z2;

      elsif Re (Z2) = 1.0 and then Im (Z2) = 0.0 then
         return Z1;

      else
         return Exp (Z2 * Log (Z1));
      end if;
   end "**";
 
 
   function "**"
     (Left : Real'Base;
      Right : Complex)
   return Complex is
      X : Real'Base := Left;
      Z : Complex := Right;
   begin
      if Re (Z) = 0.0 and then Im (Z) = 0.0 and then
         X = 0.0 then
         raise Argument_Error;

      elsif X = 0.0 and then Re (Z) < 0.0 then
         raise Constraint_Error;

      elsif X = 0.0 then
         return Compose_From_Cartesian (X, 0.0);

      elsif Re (Z) = 0.0 and then Im (Z) = 0.0 then
         return Complex_One;

      elsif Re (Z) = 1.0 and then Im (Z) = 0.0 then
         return Compose_From_Cartesian (X, 0.0);

      else
         return Exp (Log (X) * Z);
      end if;
   end "**";
 
 
   function "**" (Left : Complex;
                   Right : Real'Base) return Complex is
      Z : Complex := Left;
      Y : Real'Base := Right;
   begin
      if  Y = 0.0 and then
          Re (Z) = 0.0 and then Im (Z) = 0.0 then
         raise Argument_Error;
      elsif Re (Z) = 0.0 and then Im (Z) = 0.0 and then
            Y < 0.0 then
         raise Constraint_Error;

      elsif Re (Z) = 0.0 and then Im (Z) = 0.0 then
         return Z;

      elsif Y = 0.0 then
         return Complex_One;

      elsif Y = 1.0 then
         return Z;

      else
         return Exp (Y * Log (Z));
      end if;
   end "**";
 
   ---------
   -- Sin --
   ---------
 
   function Sin (X : Complex) return Complex is
      Z : Complex := X;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;
      end if;

      return Compose_From_Cartesian (Sin (Re (Z)) * Cosh (Im (Z)),
                                     Cos (Re (Z)) * Sinh (Im (Z)));
   end Sin;
  
   ---------
   -- Cos --
   ---------

   function Cos (X : Complex) return Complex is
      Z : Complex := X;
   begin
      return Compose_From_Cartesian (Cos (Re (Z)) * Cosh (Im (Z)),
                                   -Sin (Re (Z)) * Sinh (Im (Z)));
   end Cos;
  
   ---------
   -- Tan --
   ---------

   function Tan (X : Complex) return Complex is
      Z : Complex := X;
   begin
      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;

      elsif Im (Z) > Log_Inverse_Epsilon_2 then
         return Complex_I;

      elsif Im (Z) < -Log_Inverse_Epsilon_2 then
         return -Complex_I;
      end if;

      return Sin (Z) / Cos (Z);
   end Tan;
 
 
   ---------
   -- Cot --
   ---------

   function Cot (X : Complex) return Complex is
      Z : Complex := X;
   begin
      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Complex_One  /  Z;

      elsif Im (Z) > Log_Inverse_Epsilon_2 then
         return -Complex_I;

      elsif Im (Z) < -Log_Inverse_Epsilon_2 then
         return Complex_I;
      end if;

      return Cos (Z) / Sin (Z);
   end Cot;
 
   ------------
   -- Arcsin --
   ------------

   function Arcsin (X : Complex) return Complex is
      Z : Complex := X;
      ZA : Complex := Z;
      Result : Complex;
   begin
      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;

      elsif abs Re (Z) > Inv_Square_Root_Epsilon or
            abs Im (Z) > Inv_Square_Root_Epsilon then
         Result := -Complex_I * (Log (Complex_I * Z) + Log (2.0 * Complex_I));

         if Im (Result) > PI_2 then
            Set_Im (Result, PI - Im (Z));
         elsif Im (Result) < -PI_2 then
            Set_Im (Result, -(PI + Im (Z)));
         end if;
      end if;

      Result := -Complex_I * Log (Complex_I * Z + Sqrt (1.0 - Z * Z));

      if Re (Z) = 0.0 then
         Set_Re (Result, Re (Z));
      elsif Im (Z) = 0.0 then
         Set_Im (Result, Im (Z));
      end if;

      return Result;
   end Arcsin;
 
   ------------
   -- Arccos --
   ------------

   function Arccos (X : Complex) return Complex is
      Z : Complex := X;
      Result : Complex;
   begin
      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return HALF_PI - Z;

      elsif abs Re (Z) > Inv_Square_Root_Epsilon or
            abs Im (Z) > Inv_Square_Root_Epsilon then
         return -2.0 * Complex_I * Log (Sqrt ((1.0 + Z) / 2.0) +
                            Complex_I * Sqrt ((1.0 - Z) / 2.0));
      end if;

      Result := -Complex_I * Log (Z + Complex_I * Sqrt (1.0 - Z * Z));

      if Im (Z) = 0.0 then
         Set_Im (Result, Im (Z));
      end if;

      return Result;
   end Arccos;
 
 
   ------------
   -- Arctan --
   ------------

   function Arctan (X : Complex) return Complex is
      Z : Complex := X;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;
      end if;

      return -Complex_I * (Log (1.0 + Complex_I * Z)
                         - Log (1.0 - Complex_I * Z)) / 2.0;
   end Arctan;
 
 
   ------------
   -- Arccot --
   ------------

   function Arccot (X : Complex) return Complex is
      Z : Complex := X;
      Zt : Complex;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return HALF_PI - Z;

      elsif abs Re (Z) > 1.0 / Epsilon or
            abs Im (Z) > 1.0 / Epsilon then
         Zt := Complex_One  /  Z;

         if Re (Z) < 0.0 then
            Set_Re (Zt, PI - Re (Zt));
            return Zt;
         else
            return Zt;
         end if;
      end if;

      Zt := Complex_I * Log ((Z - Complex_I) / (Z + Complex_I)) / 2.0;

      if Re (Zt) < 0.0 then
         Zt := PI + Zt;
      end if;
      return Zt;
   end Arccot;
 
   ----------
   -- Sinh --
   ----------
 
   function Sinh (X : Complex) return Complex is
      Z : Complex := X;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;
      end if;

      return Compose_From_Cartesian (Sinh (Re (Z)) * Cos (Im (Z)),
                                     Cosh (Re (Z)) * Sin (Im (Z)));
   end Sinh;
 
   ----------
   -- Cosh --
   ----------
 
   function Cosh (X : Complex) return Complex is
      Z : Complex := X;
   begin
      return Compose_From_Cartesian (Cosh (Re (Z)) * Cos (Im (Z)),
                                     Sinh (Re (Z)) * Sin (Im (Z)));
   end Cosh;
 
   ----------
   -- Tanh --
   ----------
 
   function Tanh (X : Complex) return Complex is
      Z : Complex := X;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;

      elsif Re (Z) > Log_Inverse_Epsilon_2 then
         return Complex_One;

      elsif Re (Z) < -Log_Inverse_Epsilon_2 then
         return -Complex_One;
      end if;

      return Sinh (Z) / Cosh (Z);
   end Tanh;
 
   ----------
   -- Coth --
   ----------
 
   function Coth (X : Complex) return Complex is
      Z : Complex := X;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Complex_One  /  X;

      elsif Re (X) > Log_Inverse_Epsilon_2 then
         return Complex_One;

      elsif Re (X) < -Log_Inverse_Epsilon_2 then
         return -Complex_One;
      end if;

      return Cosh (Z) / Sinh (Z);
   end Coth;
 
   -------------
   -- Arcsinh --
   -------------
 
   function Arcsinh (X : Complex) return Complex is
      Z : Complex := X;
      Result : Complex;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;

      elsif abs Re (Z) > Inv_Square_Root_Epsilon or
            abs Im (Z) > Inv_Square_Root_Epsilon then

         Result := Log_Two + Log (Z); -- may have wrong sign

         if (Re (Z) < 0.0 and Re (Result) > 0.0)
           or else  (Re (Z) > 0.0 and Re (Result) < 0.0)
         then
            Set_Re  (Result, -Re (Result));
         end if;

         return Result;
      end if;

      Result := Log (Z + Sqrt (1.0 + Z*Z));

      if Re (Z) = 0.0 then
         Set_Re  (Result, Re (Z));
      elsif Im  (Z) = 0.0 then
         Set_Im (Result, Im  (Z));
      end if;

      return Result;
   end Arcsinh;
 
   -------------
   -- Arccosh --
   -------------
 
   function Arccosh (X : Complex) return Complex is
      Z : Complex := X;
      Result : Complex;
   begin

      if abs Re  (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         Result := Compose_From_Cartesian (-Im (Z), -PI_2 + Re (Z));

      elsif abs Re  (Z) > Inv_Square_Root_Epsilon or
            abs Im (Z) > Inv_Square_Root_Epsilon then
         Result := Log_Two + Log (Z);

      else
         Result := 2.0 * Log (Sqrt ((1.0 + Z) / 2.0) +
                              Sqrt ((Z - 1.0) / 2.0));
      end if;

      if Re (Result) <= 0.0 then
         Result := -Result;
      end if;

      return Result;
   end Arccosh;
 
   -------------
   -- Arctanh --
   -------------
 
   function Arctanh (X : Complex) return Complex is
      Z : Complex := X;
   begin

      if abs Re (Z) < Square_Root_Epsilon and then
         abs Im (Z) < Square_Root_Epsilon then
         return Z;
      end if;

      return (Log (1.0 + Z) - Log (1.0 - Z)) / 2.0;
   end Arctanh;
 
 
   --------------
   -- Arctcoth --
   --------------
 
   function Arccoth (X : Complex) return Complex is
      Z : Complex := X;
      R : Complex;
   begin

      if abs Re (Z) < Square_Root_Epsilon
         and then abs Im (Z) < Square_Root_Epsilon
      then
         return PI_2 * Complex_I + Z;

      elsif abs Re (Z) > 1.0 / Epsilon or else
            abs Im (Z) > 1.0 / Epsilon then
         if Im (Z) > 0.0 then
            return Complex_Zero;
         else
            return PI * Complex_I;
         end if;

      elsif Im (Z) = 0.0 and then Re (Z) = 1.0 then
         raise Constraint_Error;

      elsif Im (Z) = 0.0 and then Re (Z) = -1.0 then
         raise Constraint_Error;
      end if;

      begin
         R := Log ((1.0 + Z) / (Z - 1.0)) / 2.0;
      exception
         when Constraint_Error =>
            R := (Log (1.0 + Z) - Log (Z - 1.0)) / 2.0;
      end;

      if Im (R) < 0.0 then
         Set_Im (R, PI + Im (R));
      end if;

      if Re (Z) = 0.0 then
         Set_Re (R, Re (Z));
      end if;

      return R;
   end Arccoth;

begin                                 -- initialize needed pseudo-constants
   Epsilon := Real (Real'Model_Epsilon);

   while Epsilon / Real (Real'Machine_Radix) + 1.0 /= 1.0 loop
      Epsilon := Epsilon / Real (Real'Machine_Radix);
   end loop;

   Square_Root_Epsilon     := Sqrt (Epsilon);
   Inv_Square_Root_Epsilon := 1.0 / Square_Root_Epsilon;
   Root_Root_Epsilon       := Sqrt (Square_Root_Epsilon);
   Log_Inverse_Epsilon_2   := Log (1.0 / Epsilon) / 2.0;
 
end Ada.Numerics.Generic_Complex_Elementary_Functions;



----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Feb 25 00:28:26 1994;  author: schonber
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
