------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--           A D A . S T R I N G S . W I D E _ U N B O U N D E D            --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
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


with Ada.Strings.Wide_Maps;

package Ada.Strings.Wide_Unbounded is

   Blank : constant Wide_Character := ' ';

   type Unbounded_Wide_String is private;

   Null_Unbounded_Wide_String : constant Unbounded_Wide_String;

   type Wide_String_Access is access all Wide_String;

   ---------------------------------
   -- Wide_String Length Function --
   ---------------------------------

   function Length (Source : in Unbounded_Wide_String) return Natural;

   -----------------------------------------------------
   -- Conversion, Catenation, and Selection Functions --
   -----------------------------------------------------

   function To_Unbounded_Wide_String (Source : in Wide_String)
      return Unbounded_Wide_String;

   function To_Wide_String (Source : in Unbounded_Wide_String)
     return Wide_String;

   function "&" (Left, Right : in Unbounded_Wide_String)
      return Unbounded_Wide_String;

   function "&" (Left : in Unbounded_Wide_String; Right : Wide_String)
      return Unbounded_Wide_String;

   function "&" (Left : in Wide_String; Right : Unbounded_Wide_String)
      return Unbounded_Wide_String;

   function "&" (Left : in Unbounded_Wide_String; Right : Wide_Character)
      return Unbounded_Wide_String;

   function "&" (Left : in Wide_Character; Right : Unbounded_Wide_String)
      return Unbounded_Wide_String;

   function Element (Source : in Unbounded_Wide_String;
                      Index  : in Positive)
      return Wide_Character;

   procedure Replace_Element
     (Source : in out Unbounded_Wide_String;
      Index  : in Positive;
      By     : in Wide_Character);

   function Slice (Source : in Unbounded_Wide_String;
                   Low    : in Positive;
                   High   : in Natural)
      return Wide_String;

   function "="  (Left, Right : in Unbounded_Wide_String) return Boolean;

   function "<"  (Left, Right : in Unbounded_Wide_String) return Boolean;
   function "<=" (Left, Right : in Unbounded_Wide_String) return Boolean;
   function ">"  (Left, Right : in Unbounded_Wide_String) return Boolean;
   function ">=" (Left, Right : in Unbounded_Wide_String) return Boolean;

   ------------------------
   -- Search Subprograms --
   ------------------------

   function Index (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Going    : in Direction := Forward;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping
                                := Wide_Maps.Identity)
      return Natural;

   function Index (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Going    : in Direction := Forward;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
      return Natural;

   function Index (Source : in Unbounded_Wide_String;
                   Set    : in Wide_Maps.Wide_Character_Set;
                   Test   : in Membership := Inside;
                   Going  : in Direction  := Forward) return Natural;


   function Index_Non_Blank (Source : in Unbounded_Wide_String;
                             Going  : in Direction := Forward)
      return Natural;

   function Count (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping
                                := Wide_Maps.Identity)
      return Natural;

   function Count (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
      return Natural;

   function Count (Source   : in Unbounded_Wide_String;
                   Set      : in Wide_Maps.Wide_Character_Set)
      return Natural;


   procedure Find_Token (Source : in Unbounded_Wide_String;
                         Set    : in Wide_Maps.Wide_Character_Set;
                         Test   : in Membership;
                         First  : out Positive;
                         Last   : out Natural);

   -----------------------------------------
   -- Wide_String Translation Subprograms --
   -----------------------------------------

   function Translate
     (Source : in Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping)
     return Unbounded_Wide_String;

   procedure Translate
     (Source : in out Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping);

   function Translate
     (Source : in Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
     return Unbounded_Wide_String;

   procedure Translate
     (Source : in out Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping_Function);

   --------------------------------------------
   -- Wide_String Transformation Subprograms --
   --------------------------------------------

   function Replace_Slice
      (Source   : in Unbounded_Wide_String;
       Low      : in Positive;
       High     : in Natural;
       By       : in Wide_String)
      return Unbounded_Wide_String;


   function Insert (Source   : in Unbounded_Wide_String;
                    Before   : in Positive;
                    New_Item : in Wide_String)
      return Unbounded_Wide_String;


   function Overwrite (Source    : in Unbounded_Wide_String;
                       Position  : in Positive;
                       New_Item  : in Wide_String)
      return Unbounded_Wide_String;


   function Delete (Source  : in Unbounded_Wide_String;
                    From    : in Positive;
                    Through : in Natural)
      return Unbounded_Wide_String;

   function Trim
      (Source : in Unbounded_Wide_String)
      return Unbounded_Wide_String;

   function Trim
      (Source : in Unbounded_Wide_String;
       Left   : in Wide_Maps.Wide_Character_Set;
       Right  : in Wide_Maps.Wide_Character_Set)
      return Unbounded_Wide_String;

   function Head (Source : in Unbounded_Wide_String;
                  Count  : in Natural;
                  Pad    : in Wide_Character := Blank)
      return Unbounded_Wide_String;

   function Tail (Source : in Unbounded_Wide_String;
                  Count  : in Natural;
                  Pad    : in Wide_Character := Blank)
      return Unbounded_Wide_String;

   function "*" (Left  : in Natural;
                 Right : in Wide_Character)
      return Unbounded_Wide_String;

   function "*" (Left  : in Natural;
                 Right : in Wide_String)
      return Unbounded_Wide_String;

   function "*" (Left  : in Natural;
                 Right : in Unbounded_Wide_String)
      return Unbounded_Wide_String;

private

   type Unbounded_Wide_String is record
      Reference : Wide_String_Access := new Wide_String'("");
   end record;

   Null_Unbounded_Wide_String : constant Unbounded_Wide_String :=
                                      (Reference => new Wide_String'(""));

end Ada.Strings.Wide_Unbounded;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Mon Dec 27 09:13:48 1993;  author: dewar
--  Add missing Translate functions (the ones using a mapping Function)
--  ----------------------------
--  revision 1.3
--  date: Fri Jan  7 00:50:16 1994;  author: dewar
--  Put private types where they belong in private part
--  ----------------------------
--  revision 1.4
--  date: Sun Jan  9 10:56:18 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
