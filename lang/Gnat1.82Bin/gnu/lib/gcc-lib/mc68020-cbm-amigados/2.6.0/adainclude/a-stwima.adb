------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R I N G S . W I D E _ M A P S                 --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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


package body Ada.Strings.Wide_Maps is

   --  The following functions replace the use of 'Min and 'Max till we
   --  get those attributes implemented on type Wide_Character ???

   function Wide_Character_Min (A, B : Wide_Character)
     return Wide_Character is
   begin
      if A < B then
         return A;
      else
         return B;
      end if;
   end Wide_Character_Min;

   function Wide_Character_Max (A, B : Wide_Character)
     return Wide_Character is
   begin
      if A > B then
         return A;
      else
         return B;
      end if;
   end Wide_Character_Max;

   -----------------------
   -- Local Subprograms --
   -----------------------

   --  The following functions allow us simple arithmetic on wide character
   --  values, the caller knows that the result is in wide character range.

   function "+" (Left : Wide_Character; Right : Natural)
     return Wide_Character is
   begin
      return Wide_Character'Val (Wide_Character'Pos (Left) + Right);
   end "+";

   function "-" (Left : Wide_Character; Right : Natural)
     return Wide_Character is
   begin
      return Wide_Character'Val (Wide_Character'Pos (Left) - Right);
   end "-";

   ---------
   -- "=" --
   ---------

   function "=" (Left, Right : Wide_Character_Set) return Boolean is
      L1 : constant Wide_Character := Left'First;
      L2 : constant Wide_Character := Left'Last;
      R1 : constant Wide_Character := Right'First;
      R2 : constant Wide_Character := Right'Last;

      Min    : Wide_Character := Wide_Character_Min (L1, R1);
      Max    : Wide_Character := Wide_Character_Max (L2, R2);
      Result : Wide_Character_Set (Min .. Max);

   begin
      if Left'Length = Right'Length then
         return Standard."=" (Left, Right);

      else
         for J in Left'range loop
            if Left (J) and then J in Right'range and then not Right (J) then
               return False;
            end if;
         end loop;

         for J in Right'range loop
            if Right (J) and then J in Left'range and then not Left (J) then
               return False;
            end if;
         end loop;

         return True;
      end if;
   end "=";

   -----------
   -- "and" --
   -----------

   function "and" (Left, Right : Wide_Character_Set)
     return Wide_Character_Set
   is
      L1 : constant Wide_Character := Left'First;
      L2 : constant Wide_Character := Left'Last;
      R1 : constant Wide_Character := Right'First;
      R2 : constant Wide_Character := Right'Last;

   begin
      if L1 < R1 then
         if L2 < R2 then
            return Null_Set;
         elsif L2 < R2 then
            return Standard."and" (Left (R1 .. L2), Right (R1 .. L2));
         else
            return Standard."and" (Left (R1 .. R2), Right);
         end if;
      else
         return Right and Left;
      end if;
   end "and";

   -----------
   -- "not" --
   -----------

   function "not" (Right : Wide_Character_Set) return Wide_Character_Set is
      Min : Wide_Character := Wide_Character'First;
      Max : Wide_Character := Wide_Character'Last;

   begin
      if Right'First = Wide_Character'First then
         Min := Max;

         for J in Right'range loop
            if not Right (J) then
               Min := J;
               exit;
            end if;
         end loop;

         if Min = Max then
            return Null_Set;
         end if;
      end if;

      if Right'Last = Wide_Character'Last then
         for J in reverse Right'range loop
            if not Right (J) then
               Max := J;
            end if;
         end loop;
      end if;

      return Standard."not" (Right (Min .. Max));
   end "not";

   ----------
   -- "or" --
   ----------

   function "or" (Left, Right : Wide_Character_Set)
     return Wide_Character_Set
   is
      L1 : constant Wide_Character := Left'First;
      L2 : constant Wide_Character := Left'Last;
      R1 : constant Wide_Character := Right'First;
      R2 : constant Wide_Character := Right'Last;

      Result : Wide_Character_Set (Wide_Character'range);

   begin
      if L1 < R1 then
         if L2 < R2 then
            Result (L1 .. L2)         := Left;
            Result (L2 + 1 .. R1 - 1) := (others => False);
            Result (R1 .. R2)         := Right;
            return Result (L1 .. R2);

         elsif L2 < R2 then
            Result (L1 .. R1 - 1) := Left (L1 .. R1 - 1);
            Result (R1 .. L2)     := Standard."or" (Left  (R1 .. L2),
                                                    Right (R1 .. L2));
            Result (L2 + 1 .. R2) := Right (L2 + 1 .. R2);
            return Result (L1 .. R2);

         else
            Result (L1 .. R1 - 1) := Left (L1 .. R1 - 1);
            Result (R1 .. R2)     := Standard."or" (Left (R1 .. R2), Right);
            Result (R2 + 1 .. L2) := Left (R2 + 1 .. L2);
            return Result (L1 .. L2);
         end if;
      else
         return Right or Left;
      end if;
   end "or";

   -----------
   -- "xor" --
   -----------

   function "xor" (Left, Right : Wide_Character_Set)
     return Wide_Character_Set
   is
      L1 : constant Wide_Character := Left'First;
      L2 : constant Wide_Character := Left'Last;
      R1 : constant Wide_Character := Right'First;
      R2 : constant Wide_Character := Right'Last;

      Result : Wide_Character_Set (Wide_Character'range);

   begin
      if L1 < R1 then
         if L2 < R2 then
            Result (L1 .. L2)         := Standard."not" (Left);
            Result (L2 + 1 .. R1 - 1) := (others => False);
            Result (R1 .. R2)         := Standard."not" (Right);
            return Result (L1 .. R2);

         elsif L2 < R2 then
            Result (L1 .. R1 - 1) := Standard."not" (Left (L1 .. R1 - 1));
            Result (R1 .. L2)     := Standard."xor" (Left  (R1 .. L2),
                                                     Right (R1 .. L2));
            Result (L2 + 1 .. R2) := Standard."not" (Right (L2 + 1 .. R2));
            return Result (L1 .. R2);

         else
            Result (L1 .. R1 - 1) := Standard."not" (Left (L1 .. R1 - 1));
            Result (R1 .. R2)     := Standard."xor" (Left (R1 .. R2), Right);
            Result (R2 + 1 .. L2) := Standard."not" (Left (R2 + 1 .. L2));
            return Result (L1 .. L2);
         end if;
      else
         return Right xor Left;
      end if;
   end "xor";

   -----------
   -- Is_In --
   -----------

   function Is_In (Element : in Wide_Character; Set : in Wide_Character_Set)
     return Boolean is
   begin
      return Element in Set'range and then Set (Element);
   end Is_In;

   ---------------
   -- Is_Subset --
   ---------------

   function Is_Subset (Elements : in Wide_Character_Set;
                       Set      : in Wide_Character_Set)
     return Boolean is
   begin
      for J in Elements'range loop
         if Elements (J) and then not Set (J) then
            return False;
         end if;
      end loop;

      return True;
   end Is_Subset;

   ----------------
   -- To_Mapping --
   ----------------

   function To_Mapping (From, To : in Wide_Character_Sequence)
     return Wide_Character_Mapping
   is
      Max : Wide_Character := Wide_Character'First;
      Min : Wide_Character := Wide_Character'Last;

   begin
      if From'Length /= To'Length then
         raise Strings.Translation_Error;

      else
         for J in From'range loop
            Max := Wide_Character_Max (Max, From (J));
            Min := Wide_Character_Min (Min, From (J));
         end loop;

         declare
            Result   : Wide_Character_Mapping (Min .. Max);
            Inserted : Wide_Character_Set (Min .. Max) := (others => False);

         begin
            for J in Result'range loop
               Result (J) := J;
            end loop;

            for J in From'range loop
               if Inserted (From (I)) then
                  raise Strings.Translation_Error;
               else
                  Inserted (From (I)) := True;
                  Result (From (I)) := To (I - From'First + To'First);
               end if;
            end loop;

            return Result;
         end;
      end if;
   end To_Mapping;

   -----------------
   -- To_Sequence --
   -----------------

   function To_Sequence (Set : in Wide_Character_Set)
     return Wide_Character_Sequence
   is
      N : Natural := 0;

   begin
      for J in Set'range loop
         if Set (J) then
            N := N + 1;
         end if;
      end loop;

      declare
         Result : Wide_Character_Sequence (1 .. N);

      begin
         N := 0;

         for J in Set'range loop
            if Set (J) then
               N := N + 1;
               Result (N) := J;
            end if;
         end loop;

         return Result;
      end;
   end To_Sequence;

   ------------
   -- To_Set --
   ------------

   function To_Set (Sequence : in Wide_Character_Sequence)
     return Wide_Character_Set
   is
      Max : Wide_Character := Wide_Character'First;
      Min : Wide_Character := Wide_Character'Last;

   begin
      if Sequence'Length = 0 then
         return Null_Set;

      else
         for J in Sequence'range loop
            Max := Wide_Character_Max (Max, Sequence (J));
            Min := Wide_Character_Min (Min, Sequence (J));
         end loop;

         declare
            Result : Wide_Character_Set (Min .. Max) := (others => False);

         begin
            for J in Sequence'range loop
               Result (Sequence (J)) := True;
            end loop;

            return Result;
         end;
      end if;
   end To_Set;

   function To_Set (Singleton : in Wide_Character)
     return Wide_Character_Set
   is
      Result : Wide_Character_Set (Singleton .. Singleton);
   begin
      Result (Singleton) := True;
      return Result;
   end To_Set;

end Ada.Strings.Wide_Maps;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 00:01:58 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:55:48 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
