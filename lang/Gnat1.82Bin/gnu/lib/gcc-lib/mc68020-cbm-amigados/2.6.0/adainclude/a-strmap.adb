------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . S T R I N G S . M A P S                       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.7 $                              --
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

--  Note: parts of this code are derived from the ADAR.CSH public domain
--  Ada 83 versions of the Appendix C string handling packages. The main
--  differences are that we avoid the use of the minimize function which
--  is bit-by-bit or character-by-character and therefore rather slow.
--  Generally for character sets we favor the full 32-byte representation.

package body Ada.Strings.Maps is

   ------------
   -- To_Set --
   ------------

   function To_Set (Ranges : in Character_Ranges) return Character_Set is
      Result : Character_Set;

   begin
      for R in Ranges'range loop
         for C in Ranges (R).Low .. Ranges (R).High loop
            Result (C) := True;
         end loop;
      end loop;

      return Result;
   end To_Set;

   function To_Set (Span   : in Character_Range) return Character_Set is
      Result : Character_Set;

   begin
      for C in Span.Low .. Span.High loop
         Result (C) := True;
      end loop;

      return Result;
   end To_Set;

   ---------------
   -- To_Ranges --
   ---------------

   function To_Ranges (Set : in Character_Set) return Character_Ranges is
      Max_Ranges : Character_Ranges (1 .. Set'Length / 2 + 1);
      Range_Num  : Natural;
      C          : Character;

   begin
      C := Character'First;
      Range_Num := 0;

      loop
         --  Skip gap between subsets.

         while not Set (C) loop
            exit when C = Character'Last;
            C := Character'Succ (C);
         end loop;

         exit when not Set (C);

         Range_Num := Range_Num + 1;
         Max_Ranges (Range_Num). Low := C;

         --  Span a subset.

         loop
            exit when not Set (C) or else C = Character'Last;
            C := Character' Succ (C);
         end loop;

         if Set (C) then
            Max_Ranges (Range_Num). High := C;
            exit;
         else
            Max_Ranges (Range_Num). High := Character'Pred (C);
         end if;
      end loop;

      return Max_Ranges (1 .. Range_Num);
   end To_Ranges;

   ---------
   -- "-" --
   ---------

   function "-" (Left, Right : Character_Set) return Character_Set is
   begin
      return Left and not Right;
   end "-";

   -----------
   -- Is_In --
   -----------

   function Is_In
     (Element : Character;
      Set     : Character_Set)
      return    Boolean
   is
   begin
      return Set (Element);
   end Is_In;

   ---------------
   -- Is_Subset --
   ---------------

   function Is_Subset
     (Elements : Character_Set;
      Set      : Character_Set)
      return     Boolean
   is
   begin
      return (Elements and Set) = Elements;
   end Is_Subset;

   ----------------
   -- To_Mapping --
   ----------------

   function To_Mapping
     (From, To : Character_Sequence)
      return     Character_Mapping
   is
      Result   : Character_Mapping;
      Inserted : Character_Set := Null_Set;

   begin
      if From'Length /= To'Length then
         raise Strings.Translation_Error;
      end if;

      for Char in Character loop
         Result (Char) := Char;
      end loop;

      for J in From'range loop
         if Inserted (From (J)) then
            raise Strings.Translation_Error;
         end if;

         Result   (From (J)) := To (J - From'First + To'First);
         Inserted (From (J)) := True;
      end loop;

      return Result;
   end To_Mapping;

   -----------------
   -- To_Sequence --
   -----------------

   function To_Sequence
     (Set  : Character_Set)
      return Character_Sequence
   is
      Result : String (1 .. Character'Pos (Character'Last));
      Count  : Natural := 0;

   begin
      for Char in Set'range loop
         if Set (Char) then
            Count := Count + 1;
            Result (Count) := Char;
         end if;
      end loop;

      return Result (1 .. Count);
   end To_Sequence;

   ------------
   -- To_Set --
   ------------

   function To_Set
     (Sequence : in Character_Sequence)
      return     Character_Set
   is
      Result : Character_Set := Null_Set;

   begin
      for J in Sequence'range loop
         Result (Sequence (J)) := True;
      end loop;

      return Result;
   end To_Set;

   function To_Set
     (Singleton : in Character)
      return      Character_Set
   is
      Result : Character_Set := Null_Set;

   begin
      Result (Singleton) := True;
      return Result;
   end To_Set;

   -----------
   -- Value --
   -----------

   function Value (Map : in Character_Mapping; Element : in Character)
      return Character is

   begin
      return Map (Element);
   end Value;

   ---------------
   -- To_Domain --
   ---------------

   function To_Domain (Map : in Character_Mapping) return Character_Sequence
   is
      Result : String (1 .. Map'Length);
      J      : Natural;

   begin
      J := 0;
      for C in Map'range loop
         if Map (C) /= C then
            Result (J) := C;
            J := J + 1;
         end if;
      end loop;

      return Result (1 .. J);
   end To_Domain;

   --------------
   -- To_Range --
   --------------

   function To_Range (Map : in Character_Mapping) return Character_Sequence
   is
      Result : String (1 .. Map'Length);
      J      : Natural;

   begin
      J := 0;
      for C in Map'range loop
         if Map (C) /= C then
            Result (J) := Map (C);
            J := J + 1;
         end if;
      end loop;

      return Result (1 .. J);
   end To_Range;

end Ada.Strings.Maps;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Mon Jun 27 15:49:33 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.6
--  date: Wed Jul 13 18:28:15 1994;  author: schonber
--  Complete rewriting, using fixed-size arrays for Character_Set and
--   Character_Mapping.
--  ----------------------------
--  revision 1.7
--  date: Thu Jul 21 02:46:37 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
