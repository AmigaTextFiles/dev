------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R I N G S . W I D E _ M A P S                 --
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


package Ada.Strings.Wide_Maps is

   --  Representation for a set of Wide_Character values:

   type Wide_Character_Set is array (Wide_Character range <>) of Boolean;
   pragma Pack (Wide_Character_Set);

   Null_Set : constant Wide_Character_Set;
   --  The null set has a null range

   function "="   (Left, Right : Wide_Character_Set) return Boolean;

   function "not" (Right : Wide_Character_Set)       return Wide_Character_Set;

   function "and" (Left, Right : Wide_Character_Set) return Wide_Character_Set;

   function "or"  (Left, Right : Wide_Character_Set) return Wide_Character_Set;

   function "xor" (Left, Right : Wide_Character_Set) return Wide_Character_Set;

   function Is_In (Element : in Wide_Character;
                   Set     : in Wide_Character_Set)
      return Boolean;

   function Is_Subset (Elements : in Wide_Character_Set;
                       Set      : in Wide_Character_Set)
      return Boolean;

   function "<=" (Left  : in Wide_Character_Set;
                  Right : in Wide_Character_Set)
      return Boolean renames Is_Subset;

   subtype Wide_Character_Sequence is Wide_String;
   --  Alternative representation for a set of Wide_Character values:

   function To_Set (Sequence : in Wide_Character_Sequence)
     return Wide_Character_Set;

   function To_Set (Singleton : in Wide_Character)
     return Wide_Character_Set;

   function To_Sequence (Set : in Wide_Character_Set)
     return Wide_Character_Sequence;

   --  Representation for a Wide_Character to Wide_Character mapping:

   type Wide_Character_Mapping is
     array (Wide_Character range <>) of Wide_Character;

   Identity : constant Wide_Character_Mapping;
   --  The identity mapping has a null range

   function To_Mapping (From, To : in Wide_Character_Sequence)
     return Wide_Character_Mapping;

   type Wide_Character_Mapping_Function is
      access function (From : in Wide_Character) return Wide_Character;

private
   Null_Set : constant Wide_Character_Set     := ('1' .. '0' => False);
   Identity : constant Wide_Character_Mapping := ('1' .. '0' => ' ');

end Ada.Strings.Wide_Maps;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 00:02:00 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:55:54 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Tue Feb 15 12:57:59 1994;  author: schonber
--  Introduce private part and full declarations for deferred constants.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
