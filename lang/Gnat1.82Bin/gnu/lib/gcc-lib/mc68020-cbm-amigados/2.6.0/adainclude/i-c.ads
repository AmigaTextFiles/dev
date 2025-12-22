-----------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                         I N T E R F A C E S . C                          --
--                                                                          --
--                                 S p e c                                  --
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

with Unchecked_Conversion;

package Interfaces.C is
pragma Pure (Interfaces.C);

   --  Declaration's based on C's <limits.h>

   CHAR_BIT  : constant := 8;
   SCHAR_MIN : constant := -128;
   SCHAR_MAX : constant := 127;
   UCHAR_MAX : constant := 255;

   --  Signed and Unsigned Integers. Note that in GNAT, we have ensured that
   --  the standard predefined Ada types correspond to the standard C types

   type int   is new Integer;
   type short is new Short_Integer;
   type long  is new Long_Integer;

   type signed_char is range SCHAR_MIN .. SCHAR_MAX;
   for signed_char'Size use CHAR_BIT;

   type unsigned       is mod 2 ** Integer'Size;
   type unsigned_short is mod 2 ** Short_Integer'Size;
   type unsigned_long  is mod 2 ** Long_Integer'Size;

   type unsigned_char is mod (UCHAR_MAX + 1);
   for unsigned_char'Size use CHAR_BIT;

   subtype plain_char is unsigned_char; -- ??? should be parametrized

   type ptrdiff_t is new Integer;       -- ??? should be parametrized

   type size_t is mod 2 ** 32;          -- ??? should be parametrized

   --  Floating-Point

   type C_float     is new Float;

   type double      is new Standard.Long_Float;

   type long_double is new Standard.Long_Long_Float;

   --  Characters and Strings

   --  type char is new Character;
   subtype char is Character;
   --  We don't yet allow derivation from type Character ???

   nul : constant char := char'First;

   function To_C   (Item : Character) return char;
   function To_Ada (Item : char)      return Character;

   type char_array is array (Natural range <>) of char;
   pragma Pack (char_array);
   for char_array'Component_Size use CHAR_BIT;

   function To_C
     (Item       : in String;
      Append_Nul : in Boolean := True)
      return       char_array;

   function To_Ada
     (Item     : in char_array;
      Trim_Nul : in Boolean := True)
      return     String;

   procedure To_C
     (Item       : in String;
      Target     : out char_array;
      Last       : out Integer;
      Append_Nul : in Boolean := True);

   procedure To_Ada
     (Item     : in char_array;
      Target   : out String;
      Last     : out Natural;
      Trim_Nul : in Boolean := True);

   --  Wide Character and Wide String

   --  type wchar_t is new Wide_Character;
   subtype wchar_t is Wide_Character;
   --  Derivation from type Wide_Character not yet supported ???

   wide_nul : constant wchar_t := wchar_t'First;

   function To_C   (Item : in Wide_Character) return wchar_t;
   function To_Ada (Item : in wchar_t)        return Wide_Character;

   type wchar_array is array (Natural range <>) of wchar_t;
   pragma Pack (wchar_array);

   function To_C
     (Item       : in Wide_String;
      Append_Nul : in Boolean := True)
      return       wchar_array;

   function To_Ada
     (Item     : in wchar_array;
      Trim_Nul : in Boolean := True)
      return     Wide_String;

   procedure To_C
     (Item       : in Wide_String;
      Target     : out wchar_array;
      Last       : out Integer;
      Append_Nul : in Boolean := True);

   procedure To_Ada
     (Item     : in wchar_array;
      Target   : out Wide_String;
      Last     : out Natural;
      Trim_Nul : in Boolean := True);

   Terminator_Error : exception;

private

   function Character_To_char is new
     Unchecked_Conversion (Character, char);

   function char_To_Character is new
     Unchecked_Conversion (char, Character);

   function wchar_t_To_Wide_Character is new
     Unchecked_Conversion (wchar_t, Wide_Character);

   function Wide_Character_To_wchar_t is new
     Unchecked_Conversion (Wide_Character, wchar_t);

   function To_C (Item : Character) return char
     renames Character_To_char;

   function To_Ada (Item : char) return Character
     renames char_To_Character;

   function To_C (Item : in Wide_Character) return wchar_t
     renames Wide_Character_To_wchar_t;

   function To_Ada (Item : in wchar_t) return Wide_Character
     renames wchar_t_To_Wide_Character;

end Interfaces.C;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Mon May 23 10:39:22 1994;  author: dewar
--  Remove big aggregates, replace by functions, as per RM plans
--  ----------------------------
--  revision 1.5
--  date: Mon Jun  6 12:03:59 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.6
--  date: Thu Aug 11 10:44:47 1994;  author: dewar
--  Lots of little changes to match 5.0 (mostly name changes and changes in
--   casing, use lower case for C related names)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
