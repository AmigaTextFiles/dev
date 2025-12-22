------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--         A D A . N U M E R I C S . D I S C R E T E _ R A N D O M          --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.6 $                              --
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

--  This implementation is derived from LSN 1055 written by Ken Dritz.
--  What target dependent assumptions is it making ???

with Ada.Calendar;        use Ada.Calendar;
with Ada.Strings.Bounded; use Ada.Strings.Bounded;
--  ??? above with should be removed, too much stuff for trivial use

with Unchecked_Deallocation;

package body Ada.Numerics.Discrete_Random is

   package Random_Number_Image_Bounded_Length is
      new Generic_Bounded_Length (24);

   use Random_Number_Image_Bounded_Length;

   -----------------------
   -- Local Subprograms --
   -----------------------

   procedure Destroy_State is
      new Unchecked_Deallocation (Internal_State, Access_State);

   function Make_Internal_State (Starter : Integer) return Internal_State;
   --  This function is used in this implementation to produce a valid
   --  internal state for the Fibonacci generator based on an integer
   --  that is a valid internal state for a linear congruential generator
   --  It uses the latter to generate random bits with which to initialize
   --  the state vector.

   subtype Uniformly_Distributed is Float range 0.0 .. 1.0;

   -------------------------
   -- Make_Internal_State --
   -------------------------

   function Make_Internal_State (Starter : Integer) return Internal_State is
      Bit_Value      : Float;
      T              : State_Vector;
      LCG_State      : Float;
      LCG_Multiplier : constant := 16_807.0;
      LCG_Modulus    : constant := 2_147_483_647.0;

      function LCG_Random return Uniformly_Distributed is
         T : Float;
         J : Integer;

      begin
         T := LCG_State * LCG_Multiplier;
         J := Integer (T / LCG_Modulus);
         LCG_State := T - Float (J) * LCG_Modulus;

         if LCG_State < 0.0 then
            LCG_State := LCG_State + LCG_Modulus;
         end if;

         return LCG_State / LCG_Modulus;
      end LCG_Random;

   --  Start of processing for Make_Internal_State

   begin
      LCG_State := Float (Starter);

      for J in Lag_Range loop
         T (J) := 0.0;
         Bit_Value := 1.0;

         for K in 1 .. 24 loop
            Bit_Value := Bit_Value * 0.5;

            if LCG_Random >= 0.5 then
               T (J) := T (J) + Bit_Value;
            end if;
         end loop;
      end loop;

      return (Lagged_Outputs => T,
              Borrow         => 0.0,  -- arbitrary
              R              => Larger_Lag - 1,
              S              => Smaller_Lag - 1);
   end Make_Internal_State;

   ------------
   -- Random --
   ------------

   function Random (Gen : Generator) return Result_Subtype is
      U, N, J : Float;
      V, W    : Result_Subtype;

   begin
      U := Gen.State.Lagged_Outputs (Gen.State.R) -
           Gen.State.Lagged_Outputs (Gen.State.S) -
           Gen.State.Borrow;

      if U < 0.0 then
         U := U + 1.0;
         Gen.State.Borrow := 2#1.0#e-24;
      else
         Gen.State.Borrow := 0.0;
      end if;

      Gen.State.Lagged_Outputs (Gen.State.R) := U;
      Gen.State.R := Gen.State.R - 1;
      Gen.State.S := Gen.State.S - 1;

      N := 0.0;
      for V in Result_Subtype'Range loop
         N := N + 1.0;
      end loop;

      J := 0.0;
      W := Result_Subtype'First;

      for V in Result_Subtype'Range loop
         J := J + 1.0;
         if J / N >= U then
            return W;
         end if;

         W := Result_Subtype'Succ (W);
      end loop;

   end Random;

   -----------
   -- Reset --
   -----------

   procedure Reset (Gen : in Generator; Initiator : in Integer) is
   begin
      Gen.State.all :=
        Make_Internal_State (Initiator mod 2_147_483_646 + 1);
      --  ??? above statement is clear target dependent bug! ???
   end Reset;

   procedure Reset (Gen : in Generator) is
      Yr  : Year_Number;
      Mo  : Month_Number;
      Dy  : Day_Number;
      Se  : Day_Duration;
      S   : Natural range 0 .. 86_400;
      Sec : Natural range 0 .. 59;
      Min : Natural range 0 .. 59;
      Hr  : Natural range 0 .. 23;
      T   : Natural;

   begin
      Split (Clock, Yr, Mo, Dy, Se);
      S   := Natural (Se);
      Sec := S mod 60;
      S   := S / 60;
      Min := S mod 60;
      Hr  := S / 60;
      T   := ((((Sec * 60 + Min) * 24 + Hr) * 32 + Dy) * 13 + Mo) * 50 +
             (Yr mod 50) + 26_000_000;
      Gen.State.all := Make_Internal_State (T);
   end Reset;

   ----------
   -- Save --
   ----------

   procedure Save (Gen : in Generator; To_State : out State) is
   begin
      To_State := State (Gen.State.all);
   end Save;

   -----------
   -- Reset --
   -----------

   procedure Reset (Gen : in Generator; From_State : in State) is
   begin
      Gen.State.all := Internal_State (From_State);
   end Reset;

   -----------
   -- Image --
   -----------

   function Image (Of_State : State) return String is
      Result : Bounded_String;

      function Encode (Value : Float) return String;
      --  Encode float value as digit string

      function Encode (Value : Float) return String is
      begin
         return Integer'Image (Integer (2#1.0#e24 * Value));
      end Encode;

   --  Start processing for Image

   begin
      Result := Null_Bounded_String;

      for J in Lag_Range loop
         Result :=
            Result & Encode (Of_State.Lagged_Outputs (Of_State.R - J)) & ',';
      end loop;

      Result := Result & Encode (Of_State.Borrow);
      return To_String (Result);
   end Image;

   -----------
   -- Value --
   -----------

   function Value (Coded_State : String) return State is
      use Ada.Strings;

      Result : State;
      T      : Bounded_String;

      procedure Decode_Component (Max : in Natural; Component : out Float);
      --  Need description ???

      procedure Decode_Component (Max : in Natural; Component : out Float) is
         J : Natural;
         K : Natural range 0 .. Max;

      begin
         J := Index (T, ",");

         --  Case of Coded_State has too few commas to be a valid state

         if J = 0 then
            raise Constraint_Error;
         end if;

         K := Integer'Value (Slice (T, 1, J - 1));

         --  Propagate Constraint_Error if raised by Integer'Value or by the
         --  constraint check in the assignment to K.  The latter occurs
         --  when the integer in a component of the Coded_State is outside
         --  the allowed range (min = 0; max = 2e24-1 for a component of the
         --  state vector; max = 1 for the borrow component).

         Component := Float (K) * 2#1.0#e-24;
         Delete (T, 1, J);
      end Decode_Component;

   --  Start of processing for Value

   begin
      begin
         T := Trim (To_Bounded_String (Coded_State), Left) & ',';

      exception

         --  Length_Error raised means that the trimmed Coded_State is
         --  too long to be a valid state.

         when Length_Error =>
            raise Constraint_Error;
      end;

      for J in reverse Lag_Range loop
         Decode_Component (2**24 - 1, Result.Lagged_Outputs (J));
      end loop;

      --  If Coded_State is well formed, exactly one comma remains in T
      --  (the one tacked on at the end when T was initialized). In this
      --  case the following statement consumes the rest of T.

      Decode_Component (1, Result.Borrow);

      --  Case of Coded_State has too many commas to be a valid state

      if T /= Null_Bounded_String then
         raise Constraint_Error;
      end if;

      Result.R := Larger_Lag - 1;
      Result.S := Smaller_Lag - 1;
      return Result;
   end Value;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (Gen : in out Generator) is
   begin
      Destroy_State (Gen.State);
   end Finalize;

--  Package initialization initializes Initial_State

begin

   Initial_State := Make_Internal_State (30_000);

end Ada.Numerics.Discrete_Random;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Tue Aug 16 02:35:31 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.5
--  date: Mon Aug 22 13:13:08 1994;  author: banner
--  (Value): correct parameter list for call to Trim function. The
--   second parameter to Trim was omitted by accident in previous versions
--   causing a problem compiling this module.
--  ----------------------------
--  revision 1.6
--  date: Mon Aug 22 23:43:11 1994;  author: dewar
--  Add ??? line complaining about with of Ada.Strings.Bounded
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
