------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R I N G S . U N B O U N D E D                 --
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


with Ada.Strings.Maps;

package Ada.Strings.Unbounded is

   type Unbounded_String is private;

   Null_Unbounded_String : constant Unbounded_String;

   type String_Access is access all String;

   procedure Free (X : in out String_Access);

   ----------------------------
   -- String Length Function --
   ----------------------------

   function Length (Source : Unbounded_String) return Natural;

   -----------------------------------------------------
   -- Conversion, Concatenation, and Selection Functions --
   -----------------------------------------------------

   function To_Unbounded_String (Source : String)     return Unbounded_String;
   function To_Unbounded_String (Length : in Natural) return Unbounded_String;

   function To_String (Source : Unbounded_String) return String;

   procedure Append
     (Source   : in out Unbounded_String;
      New_Item : in Unbounded_String);

   procedure Append
     (Source   : in out Unbounded_String;
      New_Item : in String);

   procedure Append
     (Source   : in out Unbounded_String;
      New_Item : in Character);

   function "&" (Left, Right : Unbounded_String) return Unbounded_String;

   function "&"
     (Left  : Unbounded_String;
      Right : String)
      return  Unbounded_String;

   function "&"
     (Left  : String;
      Right : Unbounded_String)
      return  Unbounded_String;

   function "&"
     (Left  : Unbounded_String;
      Right : Character)
      return  Unbounded_String;

   function "&"
     (Left  : Character;
      Right : Unbounded_String)
      return  Unbounded_String;

   function Element
     (Source : Unbounded_String;
      Index  : Positive)
      return   Character;

   procedure Replace_Element
     (Source : in out Unbounded_String;
      Index  : Positive;
      By     : Character);

   function Slice
     (Source : Unbounded_String;
      Low    : Positive;
      High   : Natural)
      return   String;

   function "=" (Left, Right : in Unbounded_String) return Boolean;

   function "="
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean;

   function "="
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean;

   function "<" (Left, Right : in Unbounded_String) return Boolean;

   function "<"
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean;

   function "<"
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean;

   function "<=" (Left, Right : in Unbounded_String) return Boolean;

   function "<="
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean;

   function "<="
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean;

   function ">" (Left, Right : in Unbounded_String) return Boolean;

   function ">"
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean;

   function ">"
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean;

   function ">=" (Left, Right : in Unbounded_String) return Boolean;

   function ">="
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean;

   function ">="
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean;

   ------------------------
   -- Search Subprograms --
   ------------------------

   function Index
     (Source   : Unbounded_String;
      Pattern  : String;
      Going    : Direction := Forward;
      Mapping  : Maps.Character_Mapping := Maps.Identity)
      return     Natural;

   function Index
     (Source   : in Unbounded_String;
      Pattern  : in String;
      Going    : in Direction := Forward;
      Mapping  : in Maps.Character_Mapping_Function)
      return Natural;

   function Index
     (Source : Unbounded_String;
      Set    : Maps.Character_Set;
      Test   : Membership := Inside;
      Going  : Direction  := Forward)
      return   Natural;

   function Index_Non_Blank
     (Source : Unbounded_String;
      Going  : Direction := Forward)
      return   Natural;

   function Count
     (Source  : Unbounded_String;
      Pattern : String;
      Mapping : Maps.Character_Mapping := Maps.Identity)
      return    Natural;

   function Count
     (Source   : in Unbounded_String;
      Pattern  : in String;
      Mapping  : in Maps.Character_Mapping_Function)
      return Natural;

   function Count
     (Source : Unbounded_String;
      Set    : Maps.Character_Set)
      return   Natural;

   procedure Find_Token
     (Source : Unbounded_String;
      Set    : Maps.Character_Set;
      Test   : Membership;
      First  : out Positive;
      Last   : out Natural);

   ------------------------------------
   -- String Translation Subprograms --
   ------------------------------------

   function Translate
     (Source  : Unbounded_String;
      Mapping : Maps.Character_Mapping)
      return    Unbounded_String;

   procedure Translate
     (Source  : in out Unbounded_String;
      Mapping : Maps.Character_Mapping);

   function Translate
     (Source  : in Unbounded_String;
      Mapping : in Maps.Character_Mapping_Function)
      return Unbounded_String;

   procedure Translate
     (Source  : in out Unbounded_String;
      Mapping : in Maps.Character_Mapping_Function);

   ---------------------------------------
   -- String Transformation Subprograms --
   ---------------------------------------

   function Replace_Slice
     (Source : Unbounded_String;
      Low    : Positive;
      High   : Natural;
      By     : String)
      return   Unbounded_String;

   procedure Replace_Slice
     (Source   : in out Unbounded_String;
      Low      : in Positive;
      High     : in Natural;
      By       : in String);

   function Insert
     (Source   : Unbounded_String;
      Before   : Positive;
      New_Item : String)
      return     Unbounded_String;

   procedure Insert
     (Source   : in out Unbounded_String;
      Before   : in Positive;
      New_Item : in String);

   function Overwrite
     (Source   : Unbounded_String;
      Position : Positive;
      New_Item : String)
      return     Unbounded_String;

   procedure Overwrite
     (Source    : in out Unbounded_String;
      Position  : in Positive;
      New_Item  : in String);

   function Delete
     (Source  : Unbounded_String;
      From    : Positive;
      Through : Natural)
      return    Unbounded_String;

   procedure Delete
     (Source  : in out Unbounded_String;
      From    : in Positive;
      Through : in Natural);

   function Trim
     (Source : in Unbounded_String;
      Side   : in Trim_End)
      return Unbounded_String;

   procedure Trim
     (Source : in out Unbounded_String;
      Side   : in Trim_End);

   function Trim
     (Source : in Unbounded_String;
      Left   : in Maps.Character_Set;
      Right  : in Maps.Character_Set)
      return Unbounded_String;

   procedure Trim
     (Source : in out Unbounded_String;
      Left   : in Maps.Character_Set;
      Right  : in Maps.Character_Set);

   function Head
     (Source : Unbounded_String;
      Count  : Natural;
      Pad    : Character := Space)
      return   Unbounded_String;

   procedure Head
     (Source : in out Unbounded_String;
      Count  : in Natural;
      Pad    : in Character := Space);

   function Tail
     (Source : Unbounded_String;
      Count  : Natural;
      Pad    : Character := Space)
      return   Unbounded_String;

   procedure Tail
     (Source : in out Unbounded_String;
      Count  : in Natural;
      Pad    : in Character := Space);

   function "*"
     (Left  : Natural;
      Right : Character)
      return  Unbounded_String;

   function "*"
     (Left  : Natural;
      Right : String)
      return  Unbounded_String;

   function "*"
     (Left  : Natural;
      Right : Unbounded_String)
      return  Unbounded_String;

private

   type Unbounded_String is record
      Reference : String_Access := new String'("");
   end record;

   Null_Unbounded_String : constant Unbounded_String :=
                               (Reference => new String'(""));

end Ada.Strings.Unbounded;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Tue Mar  1 09:11:36 1994;  author: dewar
--  Minor reformatting of subprogram specs
--  ----------------------------
--  revision 1.5
--  date: Mon Aug 15 18:40:06 1994;  author: banner
--  Changes according to RM9X 5.0
--  (Checked in for Bin Li)
--  ----------------------------
--  revision 1.6
--  date: Tue Aug 16 02:36:10 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
