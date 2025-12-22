------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--   A D A . N U M E R I C S . G E N E R I C _ C O M P L E X _ T Y P E S    --
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

with Ada.Numerics.Aux; use Ada.Numerics.Aux;
package body Ada.Numerics.Generic_Complex_Types is

   subtype R is Real'Base;

   ---------
   -- "+" --
   ---------

   function "+" (Right : Complex) return Complex is
   begin
      return Right;
   end "+";

   function "+" (Left, Right : Complex) return Complex is
   begin
      return Complex'(Left.Re + Right.Re, Left.Im + Right.Im);
   end "+";

   function "+" (Right : Imaginary) return Imaginary is
   begin
      return Right;
   end "+";

   function "+" (Left, Right : Imaginary) return Imaginary is
   begin
      return Imaginary (R (Left) + R (Right));
   end "+";

   function "+" (Left : Complex; Right : Real'Base) return Complex is
   begin
      return Complex'(Left.Re + Right, Left.Im);
   end "+";

   function "+" (Left : Real'Base; Right : Complex) return Complex is
   begin
      return Complex'(Left + Right.Re, Right.Im);
   end "+";

   function "+" (Left : Complex; Right : Imaginary) return Complex is
   begin
      return Complex'(Left.Re, Left.Im + R (Right));
   end "+";

   function "+" (Left : Imaginary; Right : Complex) return Complex is
   begin
      return Complex'(R (Left) + Right.Re, Right.Im);
   end "+";

   function "+" (Left : Imaginary; Right : Real'Base) return Complex is
   begin
      return Complex'(Right, R (Left));
   end "+";

   function "+" (Left : Real'Base; Right : Imaginary) return Complex is
   begin
      return Complex'(Left, R (Right));
   end "+";

   ---------
   -- "-" --
   ---------

   function "-" (Right : Complex) return Complex is
   begin
      return (-Right.Re, -Right.Im);
   end "-";

   function "-" (Left, Right : Complex) return Complex is
   begin
      return (Left.Re - Right.Re, Left.Im - Right.Im);
   end "-";

   function "-" (Right : Imaginary) return Imaginary is
   begin
      return Imaginary (-R (Right));
   end "-";

   function "-" (Left, Right : Imaginary) return Imaginary is
   begin
      return Imaginary (R (Left) - R (Right));
   end "-";

   function "-" (Left : Complex; Right : Real'Base) return Complex is
   begin
      return Complex'(Left.Re - Right, Left.Im);
   end "-";

   function "-" (Left : Real'Base; Right : Complex) return Complex is
   begin
      return Complex'(Left - Right.Re, -Right.Im);
   end "-";

   function "-" (Left : Complex; Right : Imaginary) return Complex is
   begin
      return Complex'(Left.Re, Left.Im - R (Right));
   end "-";

   function "-" (Left : Imaginary; Right : Complex) return Complex is
   begin
      return Complex'(R (Left) - Right.Re, -Right.Im);
   end "-";

   function "-" (Left : Imaginary; Right : Real'Base) return Complex is
   begin
      return Complex'(-Right, R (Left));
   end "-";

   function "-" (Left : Real'Base; Right : Imaginary) return Complex is
   begin
      return Complex'(Left, -R (Right));
   end "-";

   ---------
   -- "*" --
   ---------

   function "*" (Left, Right : Complex) return Complex is
   begin
      return  (Re => Left.Re * Right.Re - Left.Im * Right.Im,
               Im => Left.Re * Right.Im + Left.Im * Right.Re);
   end "*";

   function "*" (Left, Right : Imaginary) return Real'Base is
   begin
      return -R (Left) * R (Right);
   end "*";

   function "*" (Left : Complex; Right : Real'Base) return Complex is
   begin
      return Complex'(Left.Re * Right, Left.Im * Right);
   end "*";

   function "*" (Left : Real'Base; Right : Complex) return Complex is
   begin
      return (Left * Right.Re, Left * Right.Im);
   end "*";

   function "*" (Left : Complex; Right : Imaginary) return Complex is
   begin
      return Complex'(-(Left.Im * R (Right)), Left.Re * R (Right));
   end "*";

   function "*" (Left : Imaginary; Right : Complex) return Complex is
   begin
      return Complex'(-(R (Left) * Right.Im), R (Left) * Right.Re);
   end "*";

   function "*" (Left : Imaginary; Right : Real'Base) return Imaginary is
   begin
      return Left * Imaginary (Right);
   end "*";

   function "*" (Left : Real'Base; Right : Imaginary) return Imaginary is
   begin
      return Imaginary (Left * R (Right));
   end "*";

   ---------
   -- "/" --
   ---------

   function "/" (Left, Right : Complex) return Complex is
      a : constant R := Left.Re;
      b : constant R := Left.Im;
      c : constant R := Right.Re;
      d : constant R := Right.Im;

   begin
      return Complex'(Re => ((a * c) + (b * d)) / (c ** 2 + d ** 2),
                      Im => ((b * c) - (a * d)) / (c ** 2 + d ** 2));
   end "/";

   function "/" (Left, Right : Imaginary) return Real'Base is
   begin
      return R (Left) / R (Right);
   end "/";

   function "/" (Left : Complex; Right : Real'Base) return Complex is
   begin
      return Complex'(Left.Re / Right, Left.Im / Right);
   end "/";

   function "/" (Left : Real'Base; Right : Complex) return Complex is
      a : constant R := Left;
      c : constant R := Right.Re;
      d : constant R := Right.Im;
   begin
      return Complex'(Re =>  (a * c) / (c ** 2 + d ** 2),
                      Im => -(a * d) / (c ** 2 + d ** 2));
   end "/";

   function "/" (Left : Complex; Right : Imaginary) return Complex is
      a : constant R := Left.Re;
      b : constant R := Left.Im;
      d : constant R := R (Right);

   begin
      return (b / d,  -a / d);
   end "/";

   function "/" (Left : Imaginary; Right : Complex) return Complex is
      b : constant R := R (Left);
      c : constant R := Right.Re;
      d : constant R := Right.Im;

   begin
      return (Re => -b * d / (c ** 2 + d ** 2),
              Im => b * c / (c ** 2 + d ** 2));
   end "/";

   function "/" (Left : Imaginary; Right : Real'Base) return Imaginary is
   begin
      return Imaginary (R (Left) / Right);
   end "/";

   function "/" (Left : Real'Base; Right : Imaginary) return Imaginary is
   begin
      return Imaginary (-Left / R (Right));
   end "/";

   ----------
   -- "**" --
   ----------

   function "**" (Left : Complex; Right : Integer) return Complex is
      Result : Complex := (1.0, 0.0);
      Factor : Complex := Left;
      Exp    : Natural := Right;

   begin
      --  We use the standard logarithmic approach, Exp gets shifted right
      --  testing successive low order bits and Factor is the value of the
      --  base raised to the next power of 2. For positive exponents we
      --  multiply the result by this factor, for negative exponents, we
      --  divide by this factor.

      if Exp >= 0 then

         --  For a positive exponent, if we get a constraint error during
         --  this loop, it is an overflow, and the constraint error will
         --  simply be passed on to the caller.

         while Exp /= 0 loop
            if Exp rem 2 /= 0 then
               Result := Result * Factor;
            end if;

            Factor := Factor * Factor;
            Exp := Exp / 2;
         end loop;

         return Result;

      else -- Exp < 0 then

         --  For the negative exponent case, a constraint error during this
         --  calculation happens if Factor gets too large, and the proper
         --  response is to return 0.0, since what we essentially have is
         --  1.0 / infinity, and the closest model number will be zero.

         begin

            while Exp /= 0 loop
               if Exp rem 2 /= 0 then
                  Result := Result * Factor;
               end if;

               Factor := Factor * Factor;
               Exp := Exp / 2;
            end loop;

            return R ' (1.0) / Result;

         exception

            when Constraint_Error =>
               return (0.0, 0.0);
         end;
      end if;
   end "**";

   function "**" (Left : Imaginary; Right : Integer) return Complex is
      M : R := R (Left) ** Right;
   begin
      case Right mod 4 is
         when 0 => return (M,   0.0);
         when 1 => return (0.0, M);
         when 2 => return (-M,  0.0);
         when 3 => return (0.0, -M);
         when others => raise Program_Error;
      end case;
   end "**";

   ---------
   -- "<" --
   ---------

   function "<" (Left, Right : Imaginary) return Boolean is
   begin
      return R (Left) < R (Right);
   end "<";

   ----------
   -- "<=" --
   ----------

   function "<=" (Left, Right : Imaginary) return Boolean is
   begin
      return R (Left) <= R (Right);
   end "<=";

   ---------
   -- ">" --
   ---------

   function ">" (Left, Right : Imaginary) return Boolean is
   begin
      return R (Left) > R (Right);
   end ">";

   ----------
   -- ">=" --
   ----------

   function ">=" (Left, Right : Imaginary) return Boolean is
   begin
      return R (Left) >= R (Right);
   end ">=";

   -----------
   -- "abs" --
   -----------

   function "abs" (Right : Imaginary) return Real'Base is
   begin
      return R (Right);
   end "abs";

   --------------
   -- Argument --
   --------------

   function Argument (X : Complex) return Real'Base is
      a : constant R := X.Re;
      b : constant R := X.Im;

   begin
      if b = 0.0 then
         if a >= 0.0 then
            return 0.0;
         else
            return Pi;
         end if;
      else
         return R (Atan (Double (a / b)));
      end if;

   exception
      when Constraint_Error =>
         if a > 0.0 then
            return 0.0;
         else
            return Pi;
         end if;
   end Argument;

   function Argument (X : Complex; Cycle : Real'Base) return Real'Base is
   begin
      if Cycle > 0.0 then
         return Argument (X) * Cycle / (2.0 * Pi);
      else
         raise Constraint_Error;
      end if;
   end Argument;

   ----------------------------
   -- Compose_From_Cartesian --
   ----------------------------

   function Compose_From_Cartesian (Re, Im : Real'Base) return Complex is
   begin
      return (Re, Im);
   end Compose_From_Cartesian;

   function Compose_From_Cartesian (Re : Real'Base) return Complex is
   begin
      return (Re, 0.0);
   end Compose_From_Cartesian;

   function Compose_From_Cartesian (Im : Imaginary) return Complex is
   begin
      return (0.0, R (Im));
   end Compose_From_Cartesian;

   ------------------------
   -- Compose_From_Polar --
   ------------------------

   function Compose_From_Polar (
     Modulus, Argument : Real'Base)
     return Complex
   is
   begin
      if Modulus = 0.0 then
         return (0.0, 0.0);
      else
         return (Modulus * R (Cos (Double (Argument))),
                 Modulus * R (Sin (Double (Argument))));
      end if;
   end Compose_From_Polar;

   function Compose_From_Polar (
     Modulus, Argument, Cycle : Real'Base)
     return Complex
   is
      Arg : Real'Base;

   begin
      if Modulus = 0.0 then
         return (0.0, 0.0);

      elsif Cycle > 0.0 then
         if Argument = 0.0 then
            return (Modulus, 0.0);

         elsif Argument = Cycle / 4.0 then
            return (0.0, Modulus);

         elsif Argument = Cycle / 2.0 then
            return (-Modulus, 0.0);

         elsif Argument = 3.0 * Cycle / 4.0 then
            return (0.0, -Modulus);
         else
            Arg := 2.0 * Pi * Argument / Cycle;
            return (Modulus * R (Cos (Double (Arg))),
                    Modulus * R (Sin (Double (Arg))));
         end if;
      else
         raise Constraint_Error;
      end if;
   end Compose_From_Polar;

   ---------------
   -- Conjugate --
   ---------------

   function Conjugate (X : Complex) return Complex is
   begin
      return Complex'(X.Re, -X.Im);
   end Conjugate;

   --------
   -- Im --
   --------

   function Im (X : Complex) return Real'Base is
   begin
      return X.Im;
   end Im;

   function Im (X : Imaginary) return Real'Base is
   begin
      return R (X);
   end Im;

   -------------
   -- Modulus --
   -------------

   function Modulus (X : Complex) return Real'Base is
   begin
      return R (Sqrt (Double (X.Re ** 2 + X.Im ** 2)));
   end Modulus;

   --------
   -- Re --
   --------

   function Re (X : Complex) return Real'Base is
   begin
      return X.Re;
   end Re;

   ------------
   -- Set_Im --
   ------------

   procedure Set_Im (X : in out Complex; Im : in Real'Base) is
   begin
      X.Im := Im;
   end Set_Im;

   procedure Set_Im (X : out Imaginary; Im : in Real'Base) is
   begin
      X := Imaginary (Im);
   end Set_Im;

   ------------
   -- Set_Re --
   ------------

   procedure Set_Re (X : in out Complex; Re : in Real'Base) is
   begin
      X.Re := Re;
   end Set_Re;

end Ada.Numerics.Generic_Complex_Types;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Sat Jan 29 17:10:18 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Feb 17 00:29:46 1994;  author: schonber
--  Add missing bodies, correct miscellaneous typos. Remove renaming
--   definitions of operators, which were not type-correct.
--  ----------------------------
--  revision 1.3
--  date: Sun Feb 20 18:37:56 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
