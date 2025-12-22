------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--           A D A . S T R I N G S . W I D E _ U N B O U N D E D            --
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

--  Note: This code is derived from the ADAR.CSH public domain Ada 83
--  version of Strings.Bounded of the Appendix C string handling packages.


with Ada.Strings.Wide_Fixed;
with Ada.Strings.Wide_Search;
with Unchecked_Deallocation;

package body Ada.Strings.Wide_Unbounded is

   -----------------------
   -- Local Subprograms --
   -----------------------

   procedure Free (Handle : in out Unbounded_Wide_String);
   --  Free an unbounded string using unchecked deallocation. This is used
   --  only internally to this package by those routines which must be sure
   --  to free a string before reassigning it. This is a temporary kludge
   --  to make up for the fact that we do not have finalization yet! ???

   ---------
   -- "=" --
   ---------

   function "="  (Left, Right : in Unbounded_Wide_String) return Boolean is
   begin
      return Left.Reference.all = Right.Reference.all;
   end "=";

   ---------
   -- "<" --
   ---------

   function "<"  (Left, Right : in Unbounded_Wide_String) return Boolean is
   begin
      return Left.Reference.all < Right.Reference.all;
   end "<";

   ----------
   -- "<=" --
   ----------

   function "<=" (Left, Right : in Unbounded_Wide_String) return Boolean is
   begin
      return Left.Reference.all <= Right.Reference.all;
   end "<=";

   ---------
   -- ">" --
   ---------

   function ">"  (Left, Right : in Unbounded_Wide_String) return Boolean is
   begin
      return Left.Reference.all > Right.Reference.all;
   end ">";

   ----------
   -- ">=" --
   ----------

   function ">=" (Left, Right : in Unbounded_Wide_String) return Boolean is
   begin
      return Left.Reference.all >= Right.Reference.all;
   end ">=";

   ---------
   -- "*" --
   ---------

   function "*" (Left : in Natural; Right : in Wide_Character)
     return Unbounded_Wide_String
   is
      Result : Unbounded_Wide_String :=
                 (Reference => new Wide_String (1 .. Left));

   begin
      Result.Reference.all := (1 .. Left => Right);
      return Result;
   end "*";

   function "*" (Left : in Natural; Right : in Wide_String)
     return Unbounded_Wide_String
   is
      Result : Unbounded_Wide_String :=
         (Reference => new Wide_String (1 .. Left * Right'Length));

   begin
      for I in 1 .. Left loop
         Result.Reference.all
           (Right'Length * I - Right'Length + 1 .. Right'Length * I) := Right;
      end loop;

      return Result;
   end "*";

   function "*" (Left : in Natural; Right : in Unbounded_Wide_String)
     return Unbounded_Wide_String
   is
      R_Length : constant Integer := Right.Reference.all'Length;
      Result   : Unbounded_Wide_String :=
        (Reference =>
          new Wide_String (1 .. Left * Right.Reference.all'Length));

   begin
      for I in 1 .. Left loop
         Result.Reference.all (R_Length * I - R_Length + 1 .. R_Length * I) :=
           Right.Reference.all;
      end loop;

      return Result;
   end "*";

   ---------
   -- "&" --
   ---------

   function "&" (Left, Right : in Unbounded_Wide_String)
     return Unbounded_Wide_String
   is
      L_Length : constant Integer := Left.Reference.all'Length;
      R_Length : constant Integer := Right.Reference.all'Length;
      Length   : constant Integer :=  L_Length + R_Length;
      Result   : Unbounded_Wide_String :=
                   (Reference => new Wide_String (1 .. Length));

   begin
      Result.Reference.all (1 .. L_Length)          := Left.Reference.all;
      Result.Reference.all (L_Length + 1 .. Length) := Right.Reference.all;
      return Result;
   end "&";

   function "&" (Left : in Unbounded_Wide_String; Right : Wide_String)
     return Unbounded_Wide_String
   is
      L_Length : constant Integer := Left.Reference.all'Length;
      Length   : constant Integer := L_Length +  Right'Length;
      Result   : Unbounded_Wide_String :=
                   (Reference => new Wide_String (1 .. Length));

   begin
      Result.Reference.all (1 .. L_Length)          := Left.Reference.all;
      Result.Reference.all (L_Length + 1 .. Length) := Right;
      return Result;
   end "&";

   function "&" (Left : in Wide_String; Right : Unbounded_Wide_String)
     return Unbounded_Wide_String
   is
      R_Length : constant Integer := Right.Reference.all'Length;
      Length   : constant Integer := Left'Length + R_Length;
      Result   : Unbounded_Wide_String :=
                   (Reference => new Wide_String (1 .. Length));

   begin
      Result.Reference.all (1 .. Left'Length)          := Left;
      Result.Reference.all (Left'Length + 1 .. Length) := Right.Reference.all;
      return Result;
   end "&";

   function "&" (Left : in Unbounded_Wide_String; Right : Wide_Character)
     return Unbounded_Wide_String
   is
      Length : constant Integer := Left.Reference.all'Length + 1;
      Result : Unbounded_Wide_String :=
                 (Reference => new Wide_String (1 .. Length));

   begin
      Result.Reference.all (1 .. Length - 1) := Left.Reference.all;
      Result.Reference.all (Length)          := Right;
      return Result;
   end "&";

   function "&" (Left : in Wide_Character; Right : Unbounded_Wide_String)
     return Unbounded_Wide_String
   is
      Length : constant Integer := Right.Reference.all'Length + 1;
      Result : Unbounded_Wide_String :=
                 (Reference => new Wide_String (1 .. Length));

   begin
      Result.Reference.all (1)           := Left;
      Result.Reference.all (2 .. Length) := Right.Reference.all;
      return Result;
   end "&";

   -----------
   -- Count --
   -----------

   function Count (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping
                                := Wide_Maps.Identity)
   return Natural is
   begin
      return Wide_Search.Count (Source.Reference.all, Pattern, Mapping);
   end Count;

   function Count (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
   return Natural is
   begin
      return Wide_Search.Count (Source.Reference.all, Pattern, Mapping);
   end Count;

   function Count (Source   : in Unbounded_Wide_String;
                   Set      : in Wide_Maps.Wide_Character_Set)
   return Natural is
   begin
      return Wide_Search.Count (Source.Reference.all, Set);
   end Count;

   ------------
   -- Create --
   ------------

   procedure Create (Target : in out Unbounded_Wide_String;
                     Length : in Natural) is
   begin
      Free (Target);
      Target := (Reference => new Wide_String (1 .. Length));
   end Create;

   ------------
   -- Delete --
   ------------

   function Delete (Source  : in Unbounded_Wide_String;
                    From    : in Positive;
                    Through : in Natural)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Delete (Source.Reference.all, From, Through));
   end Delete;

   -------------
   -- Element --
   -------------

   function Element (Source : in Unbounded_Wide_String;
                     Index  : in Positive)
     return Wide_Character is

   begin
      if Index <= Source.Reference.all'Last then
         return Source.Reference.all (Index);
      else
         raise Strings.Index_Error;
      end if;
   end Element;

   ----------------
   -- Find_Token --
   ----------------

   procedure Find_Token (Source : in Unbounded_Wide_String;
                         Set    : in Wide_Maps.Wide_Character_Set;
                         Test   : in Strings.Membership;
                         First  : out Positive;
                         Last   : out Natural) is
   begin
      Wide_Search.Find_Token (Source.Reference.all, Set, Test, First, Last);
   end Find_Token;

   ----------
   -- Free --
   ----------

   procedure Free (Handle : in out Unbounded_Wide_String) is
      procedure Deallocate is
         new Unchecked_Deallocation (Wide_String, Wide_String_Access);
   begin
      Deallocate (Handle.Reference);
   end Free;

   ----------
   -- Head --
   ----------

   function Head (Source : in Unbounded_Wide_String;
                  Count  : in Natural;
                  Pad    : in Wide_Character := Blank)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Head (Source.Reference.all, Count, Pad));
   end Head;

   -----------
   -- Index --
   -----------

   function Index (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Going    : in Strings.Direction := Strings.Forward;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping :=
                                   Wide_Maps.Identity)
     return Natural is
   begin
      return Wide_Search.Index (Source.Reference.all, Pattern, Going, Mapping);
   end Index;

   function Index (Source   : in Unbounded_Wide_String;
                   Pattern  : in Wide_String;
                   Going    : in Strings.Direction := Strings.Forward;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
     return Natural is
   begin
      return Wide_Search.Index (Source.Reference.all, Pattern, Going, Mapping);
   end Index;

   function Index (Source : in Unbounded_Wide_String;
                   Set    : in Wide_Maps.Wide_Character_Set;
                   Test   : in Strings.Membership := Strings.Inside;
                   Going  : in Strings.Direction  := Strings.Forward)
     return Natural is

   begin
      return Wide_Search.Index (Source.Reference.all, Set, Test, Going);
   end Index;

   function Index_Non_Blank (Source : in Unbounded_Wide_String;
                             Going  : in Strings.Direction := Strings.Forward)
   return Natural is
   begin
      return Wide_Search.Index_Non_Blank (Source.Reference.all, Going);
   end Index_Non_Blank;

   ------------
   -- Insert --
   ------------

   function Insert (Source   : in Unbounded_Wide_String;
                    Before   : in Positive;
                    New_Item : in Wide_String)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Insert (Source.Reference.all, Before, New_Item));
   end Insert;

   ------------
   -- Length --
   ------------

   function Length (Source : in Unbounded_Wide_String) return Natural is
   begin
      return Source.Reference.all'Length;
   end Length;

   ----------
   -- Move --
   ----------

   --  Note: there is no sharing of pointers in this implementation

   procedure Move (Source : Unbounded_Wide_String;
                   Target : in out Unbounded_Wide_String)
   is
      Copy : Unbounded_Wide_String :=
         (Reference => new Wide_String'(Source.Reference.all));
   begin
      Free (Target);
      Target := Copy;
   end Move;

   procedure Move (Source : Wide_String;
                   Target : in out Unbounded_Wide_String)
   is
      Copy : Unbounded_Wide_String :=
         (Reference => new Wide_String'(Source));

   begin
      Free (Target);
      Target := Copy;
   end Move;

   ---------------
   -- Overwrite --
   ---------------

   function Overwrite (Source    : in Unbounded_Wide_String;
                       Position  : in Positive;
                       New_Item  : in Wide_String)
     return Unbounded_Wide_String is

   begin
      return To_Unbounded_Wide_String
        (Wide_Fixed.Overwrite (Source.Reference.all, Position, New_Item));
   end Overwrite;

   ---------------------
   -- Replace_Element --
   ---------------------

   procedure Replace_Element
     (Source : in out Unbounded_Wide_String;
      Index  : in Positive;
      By     : in Wide_Character) is

   begin
      if Index <= Source.Reference.all'Last then
         Source.Reference.all (Index) := By;
      else
         raise Strings.Index_Error;
      end if;
   end Replace_Element;

   -------------------
   -- Replace_Slice --
   -------------------

   function Replace_Slice
      (Source   : in Unbounded_Wide_String;
       Low      : in Positive;
       High     : in Natural;
       By       : in Wide_String)
     return Unbounded_Wide_String is
   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Replace_Slice (Source.Reference.all, Low, High, By));
   end Replace_Slice;

   -----------
   -- Slice --
   -----------

   function Slice (Source : in Unbounded_Wide_String;
                   Low    : in Positive;
                   High   : in Natural)
     return Wide_String
   is
      Result : Wide_String (1 .. High - Low + 1);
   begin
      Result := Source.Reference.all (Low .. High);
      return Result;
   end Slice;

   ----------
   -- Tail --
   ----------

   function Tail (Source : in Unbounded_Wide_String;
                  Count  : in Natural;
                  Pad    : in Wide_Character := Blank)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Tail (Source.Reference.all, Count, Pad));
   end Tail;

   --------------------
   -- To_Wide_String --
   --------------------

   function To_Wide_String (Source : in Unbounded_Wide_String)
     return Wide_String is
   begin
      return Source.Reference.all;
   end To_Wide_String;

   ------------------------------
   -- To_Unbounded_Wide_String --
   ------------------------------

   function To_Unbounded_Wide_String (Source : in Wide_String)
     return Unbounded_Wide_String
   is
      Result : Unbounded_Wide_String;

   begin
      Result := (Reference => new Wide_String (1 .. Source'Length));
      Result.Reference.all := Source;
      return Result;
   end To_Unbounded_Wide_String;

   ---------------
   -- Translate --
   ---------------

   function Translate
     (Source   : in Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Translate (Source.Reference.all, Mapping));
   end Translate;

   procedure Translate
     (Source : in out Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping) is
   begin
      Wide_Fixed.Translate (Source.Reference.all, Mapping);
   end Translate;

   function Translate
     (Source   : in Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Translate (Source.Reference.all, Mapping));
   end Translate;

   procedure Translate
     (Source : in out Unbounded_Wide_String;
      Mapping  : in Wide_Maps.Wide_Character_Mapping_Function) is
   begin
      Wide_Fixed.Translate (Source.Reference.all, Mapping);
   end Translate;

   ----------
   -- Trim --
   ----------

   function Trim (Source : in Unbounded_Wide_String)
     return Unbounded_Wide_String is
   begin
      return To_Unbounded_Wide_String (Wide_Fixed.Trim (Source.Reference.all));
   end Trim;

   function Trim (Source : in Unbounded_Wide_String;
                  Left   : in Wide_Maps.Wide_Character_Set;
                  Right  : in Wide_Maps.Wide_Character_Set)
     return Unbounded_Wide_String is

   begin
      return
        To_Unbounded_Wide_String
          (Wide_Fixed.Trim (Source.Reference.all, Left, Right));
   end Trim;

end Ada.Strings.Wide_Unbounded;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 01:42:12 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Mon Dec 27 09:13:41 1993;  author: dewar
--  Add missing Translate functions (the ones using a mapping Function)
--  ----------------------------
--  revision 1.3
--  date: Sun Jan  9 10:56:12 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
