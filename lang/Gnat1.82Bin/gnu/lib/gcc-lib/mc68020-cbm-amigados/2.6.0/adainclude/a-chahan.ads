-----------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--              A D A . C H A R A C T E R S . H A N D L I N G               --
--                                                                          --
--                                 S p e c                                  --
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


package Ada.Characters.Handling is

--  RM 5.0 has pragma Pure here, but that does not make sense, since we
--  obviously need to use Ada.Strings.Maps in the body of this package!

   ----------------------------------------
   -- Character Classification Functions --
   ----------------------------------------

   function Is_Control           (Item : in Character) return Boolean;
   function Is_Graphic           (Item : in Character) return Boolean;
   function Is_Letter            (Item : in Character) return Boolean;
   function Is_Lower             (Item : in Character) return Boolean;
   function Is_Upper             (Item : in Character) return Boolean;
   function Is_Basic             (Item : in Character) return Boolean;
   function Is_Digit             (Item : in Character) return Boolean;
   function Is_Decimal_Digit     (Item : in Character) return Boolean;
   function Is_Hexadecimal_Digit (Item : in Character) return Boolean;
   function Is_Alphanumeric      (Item : in Character) return Boolean;
   function Is_Special           (Item : in Character) return Boolean;

   --  Note: in RM 5.0, Is_Decimal_Digit is a renaming of Is_Decimal,
   --  but it seems neater to put this in the body rather than the spec.

   ------------------------------------
   -- Character Conversion Functions --
   ------------------------------------

   function To_Lower (Item : in Character) return Character;
   function To_Upper (Item : in Character) return Character;
   function To_Basic (Item : in Character) return Character;

   ---------------------------------
   -- String Conversion Functions --
   ---------------------------------

   function To_Lower (Item : in String) return String;
   function To_Upper (Item : in String) return String;
   function To_Basic (Item : in String) return String;

   ----------------------------------------------------------------------
   -- Classifications of and Conversions Between Character and ISO 646 --
   ----------------------------------------------------------------------

   subtype ISO_646 is
     Character range Character'Val (0) .. Character'Val (127);

   function Is_ISO_646 (Item : in Character) return Boolean;
   function Is_ISO_646 (Item : in String)    return Boolean;

   function To_ISO_646 (
     Item       : in Character;
     Substitute : in ISO_646 := ' ')
     return       ISO_646;

   function To_ISO_646
     (Item      : in String;
     Substitute : in ISO_646 := ' ')
     return       String;

   ------------------------------------------------------
   -- Classifications of Wide_Character and Characters --
   ------------------------------------------------------

   function Is_Character (Item : in Wide_Character) return Boolean;
   function Is_String    (Item : in Wide_String)    return Boolean;

   ------------------------------------------------------
   -- Conversions between Wide_Character and Character --
   ------------------------------------------------------

   function To_Character
     (Item       : in Wide_Character;
      Substitute : in Character := ' ')
      return       Character;

   function To_String
     (Item       : in Wide_String;
      Substitute : in Character := ' ')
      return       String;

   function To_Wide_Character
     (Item : in Character)
      return Wide_Character;

   function To_Wide_String
     (Item : in String)
      return Wide_String;

private
   pragma Inline (Is_Control);
   pragma Inline (Is_Graphic);
   pragma Inline (Is_Letter);
   pragma Inline (Is_Lower);
   pragma Inline (Is_Upper);
   pragma Inline (Is_Basic);
   pragma Inline (Is_Digit);
   pragma Inline (Is_Decimal_Digit);
   pragma Inline (Is_Hexadecimal_Digit);
   pragma Inline (Is_Alphanumeric);
   pragma Inline (Is_Special);
   pragma Inline (To_Lower);
   pragma Inline (To_Upper);
   pragma Inline (To_Basic);
   pragma Inline (Is_ISO_646);
   pragma Inline (Is_Character);
   pragma Inline (To_Character);
   pragma Inline (To_Wide_Character);

end Ada.Characters.Handling;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Tue Jun 28 22:28:08 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Tue Jun 28 22:38:35 1994;  author: dewar
--  This matches the spec in the 5.0 RM. Note that this package is new in
--   RM 5.0, but there was a similar package called Ada.Characters in RM
--   4.0. However, this file got lost in the great RCS catastrophe, and it
--   really doesn't matter anyway, since this is copied from the RM.
--  ----------------------------
--  revision 1.3
--  date: Mon Jul 11 16:37:13 1994;  author: banner
--  Rename Is_Special_Graphic to Is_Special per RM9X 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
