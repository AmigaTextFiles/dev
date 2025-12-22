------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 I N T E R F A C E S . C . S T R I N G S                  --
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

with System; use System;
with System.Storage_Elements; use System.Storage_Elements;

package body Interfaces.C.Strings is

   package Char_Access is new Address_To_Access_Conversions (char);

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Peek (From : chars_ptr) return char;
   pragma Inline (Peek);
   --  Given a chars_ptr value, obtain referenced character

   procedure Poke (Value : char; Into : chars_ptr);
   pragma Inline (Poke);
   --  Given a chars_ptr, modify referenced Character value

   function "+" (Left : chars_ptr; Right : Integer) return chars_ptr;
   pragma Inline ("+");
   --  Address arithmetic on chars_ptr value

   No_Nul_Found : constant Integer := -1;
   function Position_Of_Nul (Into : char_array) return Integer;
   --  Returns position of the first Nul in Into or No_Nul_Found (-1) if none.

   function C_Malloc (Size : Positive) return chars_ptr;
   pragma Import (C, C_Malloc, "malloc");

   procedure C_Free (Address : chars_ptr);
   pragma Import (C, C_Free, "free");

   ---------
   -- "+" --
   ---------

   function "+" (Left : chars_ptr; Right : Integer) return chars_ptr is
   begin
      return Left + chars_ptr (Right);
   end "+";

   ----------
   -- Free --
   ----------

   procedure Free (Item : in out chars_ptr) is
   begin
      if Item = Null_Ptr then
         return;
      end if;

      C_Free (Item);
      Item := Null_Ptr;
   end Free;

   --------------------
   -- New_Char_Array --
   --------------------

   function New_Char_Array (Chars : in char_array) return chars_ptr is
      Index   : Integer;
      Pointer : chars_ptr;

   begin
      Index := Position_Of_Nul (Into => Chars);

      if Index = No_Nul_Found then
         Index := Chars'Last;
      else
         Index := Index - 1;   --  Index may become -1; It's OK.
      end if;

      --  Returned value is length of signficant part + 1 for the nul character

      Pointer := C_Malloc ((Index - Chars'First + 1) + 1);
      Update (Item   => Pointer,
              Offset => 0,
              Chars  => Chars,
              Check  => False);
      return Pointer;
   end New_Char_Array;

   ----------------
   -- New_String --
   ----------------

   function New_String (Str : in String) return chars_ptr is
   begin
      return New_Char_Array (To_C (Str));
   end New_String;

   ----------
   -- Peek --
   ----------

   function Peek (From : chars_ptr) return char is
      use Char_Access;
   begin
      return To_Pointer (Address (To_Address (From))).all;
   end Peek;

   ----------
   -- Poke --
   ----------

   procedure Poke (Value : char; Into : chars_ptr) is
      use Char_Access;
   begin
      To_Pointer (Address (To_Address (Into))).all := Value;
   end Poke;

   ---------------------
   -- Position_Of_Nul --
   ---------------------

   function Position_Of_Nul (Into : char_array) return Integer is
   begin
      for J in Into'range loop
         if Into (J) = nul then
            return J;
         end if;
      end loop;

      return No_Nul_Found;
   end Position_Of_Nul;

   ------------
   -- Strlen --
   ------------

   function Strlen (Item : in chars_ptr) return Natural is
      Item_Index : Natural := 0;

   begin
      loop
         if Peek (Item + Item_Index) = nul then
            return Item_Index;
         end if;

         Item_Index := Item_Index + 1;
      end loop;
   end Strlen;

   ------------------
   -- To_chars_ptr --
   ------------------

   function To_chars_ptr
     (Item       : char_array_Ptr;
      Null_Check : in Boolean := False)
      return       chars_ptr
   is
   begin
      if Item = null then
         return Null_Ptr;
      elsif Null_Check and then
            Position_Of_Nul (Into => Item.all) = No_Nul_Found
      then
         raise Terminator_Error;
      else
         return To_Integer (Item (Item'First)'Address);
      end if;
   end To_chars_ptr;

   ------------
   -- Update --
   ------------

   procedure Update
     (Item   : in chars_ptr;
      Offset : in Natural;
      Chars  : in char_array;
      Check  : Boolean := True)
   is
      Index : chars_ptr := Item + Offset;

   begin
      if Check and then Offset + Chars'Length  > Strlen (Item) then
         raise Update_Error;
      end if;

      for J in Chars'range loop
         Poke (Chars (J), Into => Index);
         Index := Index + 1;
      end loop;
   end Update;

   procedure Update
     (Item   : in chars_ptr;
      Offset : in Natural;
      Str    : in String;
      Check  : Boolean := True)
   is
   begin
      Update (Item, Offset, To_C (Str), Check);
   end Update;

   -----------
   -- Value --
   -----------

   function Value (Item : in chars_ptr) return char_array is
      Result : char_array (0 .. Strlen (Item));

   begin
      if Item = Null_Ptr then
         raise Dereference_Error;
      end if;

      --  Note that the following loop will also copy the terminating Nul

      for J in Result'range loop
         Result (J) := Peek (Item + J);
      end loop;

      return Result;
   end Value;

   function Value
     (Item   : in chars_ptr;
      Length : in size_t)
      return   char_array
   is
      Result : char_array (0 .. Integer (Length) - 1);

   begin
      if Item = Null_Ptr then
         raise Dereference_Error;
      end if;

      for J in Result'range loop
         Result (J) := Peek (Item + J);
         if Result (J) = nul then
            return Result (0 .. J);
         end if;
      end loop;

      return Result;
   end Value;

   function Value (Item : in chars_ptr) return String is
   begin
      return To_Ada (Value (Item));
   end Value;

   function Value (Item : in chars_ptr; Length : in size_t) return String is
   begin
      return To_Ada (Value (Item, Length));
   end Value;

end Interfaces.C.Strings;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Apr 11 07:53:16 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Fri Jun  3 07:02:17 1994;  author: figueroa
--  (Allocate_Chars): fixed missing initialization (fixed by JPR)
--  ----------------------------
--  revision 1.3
--  date: Thu Aug 11 10:44:54 1994;  author: dewar
--  Changes to match RM 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
