------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--             A D A . S T R I N G S . W I D E _ B O U N D E D              --
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


with Ada.Strings.Wide_Maps;

package Ada.Strings.Wide_Bounded is

   Blank : constant Wide_Character := ' ';

   generic
      Max : Positive;    -- Maximum length of a Bounded_Wide_String

   package Generic_Bounded_Length is

      Max_Length : constant Positive := Max;

      type Bounded_Wide_String is private;

      Null_Bounded_Wide_String : constant Bounded_Wide_String;

      subtype Length_Range is Natural range 0 .. Max_Length;

      ------------
      -- Length --
      ------------

      function Length (Source : in Bounded_Wide_String) return Length_Range;

      -----------------------------------------------------
      -- Conversion, Catenation, and Selection Functions --
      -----------------------------------------------------

      function To_Bounded_Wide_String (Source : in Wide_String;
                                  Drop   : in Truncation := Error)
        return Bounded_Wide_String;

      function To_Wide_String (Source : in Bounded_Wide_String)
        return Wide_String;

      function Append (Left, Right : in Bounded_Wide_String;
                       Drop        : in Truncation  := Error)
         return Bounded_Wide_String;

      function Append (Left  : in Bounded_Wide_String;
                       Right : in Wide_String;
                       Drop  : in Truncation := Error)
         return Bounded_Wide_String;

      function Append (Left  : in Wide_String;
                       Right : in Bounded_Wide_String;
                       Drop  : in Truncation := Error)
         return Bounded_Wide_String;

      function Append (Left  : in Bounded_Wide_String;
                       Right : in Wide_Character;
                       Drop  : in Truncation := Error)
         return Bounded_Wide_String;

      function Append (Left  : in Wide_Character;
                       Right : in Bounded_Wide_String;
                       Drop  : in Truncation := Error)
         return Bounded_Wide_String;


      function "&" (Left, Right : in Bounded_Wide_String)
         return Bounded_Wide_String;

      function "&" (Left : in Bounded_Wide_String; Right : in Wide_String)
         return Bounded_Wide_String;

      function "&" (Left : in Wide_String; Right : in Bounded_Wide_String)
         return Bounded_Wide_String;

      function "&" (Left : in Bounded_Wide_String; Right : in Wide_Character)
         return Bounded_Wide_String;

      function "&" (Left : in Wide_Character; Right : in Bounded_Wide_String)
         return Bounded_Wide_String;

      function Element (Source : in Bounded_Wide_String;
                        Index  : in Positive)
        return Wide_Character;

      procedure Replace_Element
        (Source : in out Bounded_Wide_String;
         Index  : in Positive;
         By     : in Wide_Character);

      function Slice (Source : in Bounded_Wide_String;
                      Low    : in Positive;
                      High   : in Natural)
        return Wide_String;

      function "="  (Left, Right : in Bounded_Wide_String) return Boolean;

      function "<"  (Left, Right : in Bounded_Wide_String) return Boolean;

      function "<=" (Left, Right : in Bounded_Wide_String) return Boolean;

      function ">"  (Left, Right : in Bounded_Wide_String) return Boolean;

      function ">=" (Left, Right : in Bounded_Wide_String) return Boolean;

      ----------------------
      -- Search Functions --
      ----------------------

      function Index (Source   : in Bounded_Wide_String;
                      Pattern  : in Wide_String;
                      Going    : in Direction := Forward;
                      Mapping  : in Wide_Maps.Wide_Character_Mapping
                                 := Wide_Maps.Identity)
        return Natural;

      function Index (Source   : in Bounded_Wide_String;
                      Pattern  : in Wide_String;
                      Going    : in Direction := Forward;
                      Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
        return Natural;

      function Index (Source : in Bounded_Wide_String;
                      Set    : in Wide_Maps.Wide_Character_Set;
                      Test   : in Membership := Inside;
                      Going  : in Direction  := Forward) return Natural;


      function Index_Non_Blank (Source : in Bounded_Wide_String;
                                Going  : in Direction := Forward)
        return Natural;

      function Count (Source   : in Bounded_Wide_String;
                      Pattern  : in Wide_String;
                      Mapping  : in Wide_Maps.Wide_Character_Mapping
                                   := Wide_Maps.Identity)
        return Natural;

      function Count (Source   : in Bounded_Wide_String;
                      Pattern  : in Wide_String;
                      Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
        return Natural;

      function Count (Source   : in Bounded_Wide_String;
                      Set      : in Wide_Maps.Wide_Character_Set)
        return Natural;

      procedure Find_Token (Source : in Bounded_Wide_String;
                            Set    : in Wide_Maps.Wide_Character_Set;
                            Test   : in Membership;
                            First  : out Positive;
                            Last   : out Natural);

      ------------------------------------
      -- Wide_String Translation Subprograms --
      ------------------------------------

      function Translate
        (Source : in Bounded_Wide_String;
         Mapping  : in Wide_Maps.Wide_Character_Mapping)
         return Bounded_Wide_String;

      procedure Translate
        (Source : in out Bounded_Wide_String;
         Mapping  : in Wide_Maps.Wide_Character_Mapping);

      function Translate
        (Source : in Bounded_Wide_String;
         Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
         return Bounded_Wide_String;

      procedure Translate
        (Source : in out Bounded_Wide_String;
         Mapping  : in Wide_Maps.Wide_Character_Mapping_Function);

      ---------------------------------------
      -- Wide_String Transformation Subprograms --
      ---------------------------------------

      function Replace_Slice
         (Source   : in Bounded_Wide_String;
          Low      : in Positive;
          High     : in Natural;
          By       : in Wide_String;
          Drop     : in Truncation := Error)
         return Bounded_Wide_String;

      procedure Replace_Slice
         (Source   : in out Bounded_Wide_String;
          Low      : in Positive;
          High     : in Natural;
          By       : in Wide_String;
          Drop     : in Truncation := Error);

      function Insert (Source   : in Bounded_Wide_String;
                       Before   : in Positive;
                       New_Item : in Wide_String;
                       Drop     : in Truncation := Error)
         return Bounded_Wide_String;

      procedure Insert (Source   : in out Bounded_Wide_String;
                        Before   : in Positive;
                        New_Item : in Wide_String;
                        Drop     : in Truncation := Error);

      function Overwrite (Source    : in Bounded_Wide_String;
                          Position  : in Positive;
                          New_Item  : in Wide_String;
                          Drop      : in Truncation := Error)
         return Bounded_Wide_String;

      procedure Overwrite (Source    : in out Bounded_Wide_String;
                           Position  : in Positive;
                           New_Item  : in Wide_String;
                           Drop      : in Truncation := Error);

      function Delete (Source  : in Bounded_Wide_String;
                       From    : in Positive;
                       Through : in Natural)
         return Bounded_Wide_String;

      procedure Delete (Source  : in out Bounded_Wide_String;
                        From    : in Positive;
                        Through : in Natural);

      ---------------------------------
      -- Wide_String Selector Subprograms --
      ---------------------------------

      function Trim
         (Source : in Bounded_Wide_String)
         return Bounded_Wide_String;

      function Trim
         (Source : in Bounded_Wide_String;
          Left   : in Wide_Maps.Wide_Character_Set;
          Right  : in Wide_Maps.Wide_Character_Set)
         return Bounded_Wide_String;

      procedure Trim
         (Source : in out Bounded_Wide_String;
          Left   : in Wide_Maps.Wide_Character_Set;
          Right  : in Wide_Maps.Wide_Character_Set);

      function Head (Source : in Bounded_Wide_String;
                     Count  : in Natural;
                     Pad    : in Wide_Character := Blank;
                     Drop   : in Truncation := Error)
         return Bounded_Wide_String;

      function Tail (Source : in Bounded_Wide_String;
                     Count  : in Natural;
                     Pad    : in Wide_Character := Blank;
                     Drop   : in Truncation := Error)
         return Bounded_Wide_String;

      ------------------------------------
      -- Wide_String Constructor Subprograms --
      ------------------------------------

      function "*" (Left  : in Natural;
                    Right : in Wide_Character)
         return Bounded_Wide_String;

      function "*" (Left  : in Natural;
                    Right : in Wide_String)
         return Bounded_Wide_String;

      function "*" (Left  : in Natural;
                    Right : in Bounded_Wide_String)
         return Bounded_Wide_String;

      function Replicate (Count : in Natural;
                          Item  : in Wide_Character;
                          Drop  : in Truncation := Error)
         return Bounded_Wide_String;

      function Replicate (Count : in Natural;
                          Item  : in Wide_String;
                          Drop  : in Truncation := Error)
         return Bounded_Wide_String;

      function Replicate (Count : in Natural;
                          Item  : in Bounded_Wide_String;
                          Drop  : in Truncation := Error)
         return Bounded_Wide_String;

   private

      type Bounded_Wide_String is record
         Length : Length_Range;
         Data   : Wide_String (1 .. Max_Length);
      end record;

      Null_Bounded_Wide_String : constant Bounded_Wide_String :=
                   (Length => 0,
                    Data   => (1 .. Max_Length => Wide_Character'First));

      --  Pragma Inline declarations (GNAT specific additions)

      pragma Inline ("=");
      pragma Inline ("<");
      pragma Inline ("<=");
      pragma Inline (">");
      pragma Inline (">=");
      pragma Inline ("&");
      pragma Inline (Count);
      pragma Inline (Element);
      pragma Inline (Find_Token);
      pragma Inline (Index);
      pragma Inline (Index_Non_Blank);
      pragma Inline (Length);
      pragma Inline (Replace_Element);
      pragma Inline (Slice);
      pragma Inline (To_Bounded_Wide_String);
      pragma Inline (To_Wide_String);

   end Generic_Bounded_Length;

end Ada.Strings.Wide_Bounded;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Fri Jan  7 00:50:09 1994;  author: dewar
--  Move private types to private part where they belong
--  ----------------------------
--  revision 1.4
--  date: Sun Jan  9 10:55:23 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.5
--  date: Tue May  3 10:02:57 1994;  author: dewar
--  Change name Generic_Wide_Bounded_Length to Generic_Bounded_Length
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
