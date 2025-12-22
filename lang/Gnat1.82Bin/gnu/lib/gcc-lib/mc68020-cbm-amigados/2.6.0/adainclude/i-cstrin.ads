------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 I N T E R F A C E S . C . S T R I N G S                  --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.5 $                              --
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

with System.Storage_Elements;

package Interfaces.C.Strings is
pragma Preelaborate (Strings);

   type char_array_Ptr is access all char_array;

   type chars_ptr is private;

   Null_Ptr : constant chars_ptr;

   function To_chars_ptr
     (Item       : in char_array_Ptr;
      Null_Check : in Boolean := False)
      return       chars_ptr;

   function New_Char_Array (Chars : in char_array) return chars_ptr;

   function New_String (Str : in String) return chars_ptr;

   procedure Free (Item : in out chars_ptr);

   Dereference_Error : exception;

   function Value (Item : in chars_ptr) return char_array;

   function Value
     (Item   : in chars_ptr;
      Length : in size_t)
      return   char_array;

   function Value (Item : in chars_ptr) return String;

   function Value
     (Item   : in chars_ptr;
      Length : in size_t)
      return   String;

   function Strlen (Item : in chars_ptr) return Natural;

   procedure Update
     (Item   : in chars_ptr;
      Offset : in Natural;
      Chars  : in char_array;
      Check  : Boolean := True);

   procedure Update
     (Item   : in chars_ptr;
      Offset : in Natural;
      Str    : in String;
      Check  : in Boolean := True);

   Update_Error : exception;

private
   type chars_ptr is new System.Storage_Elements.Integer_Address;

   Null_Ptr : constant chars_ptr := 0;
   --  A little cleaner might be To_Integer (System.Null_Address) but this is
   --  non-preelaborable, and in fact we jolly well know this value is zero.
   --  Indeed, given the C interface nature, it is probably more correct to
   --  write zero here (even if Null_Address were non-zero).

end Interfaces.C.Strings;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Mon Apr 11 07:53:22 1994;  author: dewar
--  Reformat specs to GNAT style
--  (following are JPR changes)
--  Add with of System.Storage_Elements
--  Change Chars_Ptr from access all Character to new Integer_Address
--  ----------------------------
--  revision 1.4
--  date: Fri Jul  1 14:23:15 1994;  author: dewar
--  Add pragma Preelaborate
--  Avoid violation of preelaborability in declaration of Null_Ptr
--  ----------------------------
--  revision 1.5
--  date: Thu Aug 11 10:45:01 1994;  author: dewar
--  Changes to match RM 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
