------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R I N G S . U N B O U N D E D                 --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.8 $                              --
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
--  versions of the Appendix C string handling packages.

with Ada.Strings.Fixed;
with Ada.Strings.Search;
with Ada.Unchecked_Deallocation;

package body Ada.Strings.Unbounded is

   ---------
   -- "=" --
   ---------

   function "=" (Left, Right : Unbounded_String) return Boolean is
   begin
      return Left.Reference.all = Right.Reference.all;
   end "=";

   function "="
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean
   is
      UBRight : Unbounded_String;

   begin
      UBRight := (Reference => new String (1 .. Right'Length));
      UBRight.Reference.all := Right;
      return Left.Reference.all = UBRight.Reference.all;
   end "=";

   function "="
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean
   is
      UBLeft : Unbounded_String;

   begin
      UBLeft := (Reference => new String (1 .. Left'Length));
      UBLeft.Reference.all := Left;
      return UBLeft.Reference.all = Right.Reference.all;
   end "=";

   ---------
   -- "<" --
   ---------

   function "<" (Left, Right : Unbounded_String) return Boolean is
   begin
      return Left.Reference.all < Right.Reference.all;
   end "<";

   function "<"
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean
   is
      UBRight : Unbounded_String;

   begin
      UBRight := (Reference => new String (1 .. Right'Length));
      UBRight.Reference.all := Right;
      return Left.Reference.all < UBRight.Reference.all;
   end "<";

   function "<"
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean
   is
      UBLeft : Unbounded_String;

   begin
      UBLeft := (Reference => new String (1 .. Left'Length));
      UBLeft.Reference.all := Left;
      return UBLeft.Reference.all < Right.Reference.all;
   end "<";

   ----------
   -- "<=" --
   ----------

   function "<=" (Left, Right : Unbounded_String) return Boolean is
   begin
      return Left.Reference.all <= Right.Reference.all;
   end "<=";

   function "<="
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean
   is
      UBRight : Unbounded_String;

   begin
      UBRight := (Reference => new String (1 .. Right'Length));
      UBRight.Reference.all := Right;
      return Left.Reference.all <= UBRight.Reference.all;
   end "<=";

   function "<="
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean
   is
      UBLeft : Unbounded_String;

   begin
      UBLeft := (Reference => new String (1 .. Left'Length));
      UBLeft.Reference.all := Left;
      return UBLeft.Reference.all <= Right.Reference.all;
   end "<=";

   ---------
   -- ">" --
   ---------

   function ">"  (Left, Right : Unbounded_String) return Boolean is
   begin
      return Left.Reference.all > Right.Reference.all;
   end ">";

   function ">"
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean
   is
      UBRight : Unbounded_String;

   begin
      UBRight := (Reference => new String (1 .. Right'Length));
      UBRight.Reference.all := Right;
      return Left.Reference.all > UBRight.Reference.all;
   end ">";

   function ">"
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean
   is
      UBLeft : Unbounded_String;

   begin
      UBLeft := (Reference => new String (1 .. Left'Length));
      UBLeft.Reference.all := Left;
      return UBLeft.Reference.all > Right.Reference.all;
   end ">";

   ----------
   -- ">=" --
   ----------

   function ">=" (Left, Right : Unbounded_String) return Boolean is
   begin
      return Left.Reference.all >= Right.Reference.all;
   end ">=";

   function ">="
     (Left  : in Unbounded_String;
      Right : in String)
      return  Boolean
   is
      UBRight : Unbounded_String;

   begin
      UBRight := (Reference => new String (1 .. Right'Length));
      UBRight.Reference.all := Right;
      return Left.Reference.all >= UBRight.Reference.all;
   end ">=";

   function ">="
     (Left  : in String;
      Right : in Unbounded_String)
      return  Boolean
   is
      UBLeft : Unbounded_String;

   begin
      UBLeft := (Reference => new String (1 .. Left'Length));
      UBLeft.Reference.all := Left;
      return UBLeft.Reference.all >= Right.Reference.all;
   end ">=";

   ---------
   -- "*" --
   ---------

   function "*"
     (Left  : Natural;
      Right : Character)
      return  Unbounded_String
   is
      Result : Unbounded_String := (Reference => new String (1 .. Left));

   begin
      Result.Reference.all := (1 .. Left => Right);
      return Result;
   end "*";

   function "*"
     (Left  : Natural;
      Right : String)
     return   Unbounded_String
   is
      Result : Unbounded_String :=
         (Reference => new String (1 .. Left * Right'Length));

   begin
      for J in 1 .. Left loop
         Result.Reference.all
           (Right'Length * J - Right'Length + 1 .. Right'Length * J) := Right;
      end loop;

      return Result;
   end "*";

   function "*"
     (Left  : Natural;
      Right : Unbounded_String)
      return  Unbounded_String
   is
      R_Length : constant Integer := Right.Reference.all'Length;
      Result   : Unbounded_String :=
        (Reference => new String (1 .. Left * Right.Reference.all'Length));

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

   function "&" (Left, Right : Unbounded_String) return Unbounded_String is
      L_Length : constant Integer := Left.Reference.all'Length;
      R_Length : constant Integer := Right.Reference.all'Length;
      Length   : constant Integer :=  L_Length + R_Length;
      Result   : Unbounded_String := (Reference => new String (1 .. Length));

   begin
      Result.Reference.all (1 .. L_Length)          := Left.Reference.all;
      Result.Reference.all (L_Length + 1 .. Length) := Right.Reference.all;
      return Result;
   end "&";

   function "&"
     (Left  : Unbounded_String;
      Right : String)
      return  Unbounded_String
   is
      L_Length : constant Integer := Left.Reference.all'Length;
      Length   : constant Integer := L_Length +  Right'Length;
      Result   : Unbounded_String := (Reference => new String (1 .. Length));

   begin
      Result.Reference.all (1 .. L_Length)          := Left.Reference.all;
      Result.Reference.all (L_Length + 1 .. Length) := Right;
      return Result;
   end "&";

   function "&"
     (Left  : String;
      Right : Unbounded_String)
      return  Unbounded_String
   is
      R_Length : constant Integer := Right.Reference.all'Length;
      Length   : constant Integer := Left'Length + R_Length;
      Result   : Unbounded_String := (Reference => new String (1 .. Length));

   begin
      Result.Reference.all (1 .. Left'Length)          := Left;
      Result.Reference.all (Left'Length + 1 .. Length) := Right.Reference.all;
      return Result;
   end "&";

   function "&"
     (Left  : Unbounded_String;
      Right : Character)
      return  Unbounded_String
   is
      Length : constant Integer := Left.Reference.all'Length + 1;
      Result : Unbounded_String := (Reference => new String (1 .. Length));

   begin
      Result.Reference.all (1 .. Length - 1) := Left.Reference.all;
      Result.Reference.all (Length)          := Right;
      return Result;
   end "&";

   function "&"
     (Left  : Character;
      Right : Unbounded_String)
      return  Unbounded_String
   is
      Length : constant Integer := Right.Reference.all'Length + 1;
      Result : Unbounded_String := (Reference => new String (1 .. Length));

   begin
      Result.Reference.all (1)           := Left;
      Result.Reference.all (2 .. Length) := Right.Reference.all;
      return Result;
   end "&";

   -----------
   -- Count --
   -----------

   function Count
     (Source   : Unbounded_String;
      Pattern  : String;
      Mapping  : Maps.Character_Mapping := Maps.Identity)
      return     Natural
   is
   begin
      return Search.Count (Source.Reference.all, Pattern, Mapping);
   end Count;

   function Count
     (Source   : in Unbounded_String;
      Pattern  : in String;
      Mapping  : in Maps.Character_Mapping_Function)
      return     Natural
   is
   begin
      return Search.Count (Source.Reference.all, Pattern, Mapping);
   end Count;

   function Count
     (Source   : Unbounded_String;
      Set      : Maps.Character_Set)
      return     Natural
   is
   begin
      return Search.Count (Source.Reference.all, Set);
   end Count;

   ------------
   -- Create --
   ------------

   procedure Create
     (Target : in out String_Access;
      Length : Natural)
   is
   begin
      Free (Target);
      Target := new String (1 .. Length);
   end Create;

   ------------
   -- Delete --
   ------------

   function Delete
     (Source  : Unbounded_String;
      From    : Positive;
      Through : Natural)
      return    Unbounded_String
   is
   begin
      return
        To_Unbounded_String
          (Fixed.Delete (Source.Reference.all, From, Through));
   end Delete;

   procedure Delete
     (Source  : in out Unbounded_String;
      From    : in Positive;
      Through : in Natural)
   is
   begin
      Source := To_Unbounded_String
        (Fixed.Delete (Source.Reference.all, From, Through));
   end Delete;

   -------------
   -- Element --
   -------------

   function Element
     (Source : Unbounded_String;
      Index  : Positive)
      return   Character
   is
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

   procedure Find_Token
     (Source : Unbounded_String;
      Set    : Maps.Character_Set;
      Test   : Strings.Membership;
      First  : out Positive;
      Last   : out Natural)
   is
   begin
      Search.Find_Token (Source.Reference.all, Set, Test, First, Last);
   end Find_Token;

   ----------
   -- Free --
   ----------

   procedure Free (X : in out String_Access) is
      procedure Deallocate is
         new Ada.Unchecked_Deallocation (String, String_Access);
   begin
      Deallocate (X);
   end Free;

   ----------
   -- Head --
   ----------

   function Head
     (Source : Unbounded_String;
      Count  : Natural;
      Pad    : Character := Space)
      return   Unbounded_String
   is
   begin
      return
        To_Unbounded_String (Fixed.Head (Source.Reference.all, Count, Pad));
   end Head;

   procedure Head
     (Source : in out Unbounded_String;
      Count  : in Natural;
      Pad    : in Character := Space)
   is
   begin
      Source := To_Unbounded_String
        (Fixed.Head (Source.Reference.all, Count, Pad));
   end Head;

   -----------
   -- Index --
   -----------

   function Index
     (Source   : Unbounded_String;
      Pattern  : String;
      Going    : Strings.Direction := Strings.Forward;
      Mapping  : Maps.Character_Mapping := Maps.Identity)
      return     Natural
   is
   begin
      return Search.Index (Source.Reference.all, Pattern, Going, Mapping);
   end Index;

   function Index
     (Source   : in Unbounded_String;
      Pattern  : in String;
      Going    : in Direction := Forward;
      Mapping  : in Maps.Character_Mapping_Function)
      return Natural
   is
   begin
      return Search.Index (Source.Reference.all, Pattern, Going, Mapping);
   end Index;

   function Index
     (Source : Unbounded_String;
      Set    : Maps.Character_Set;
      Test   : Strings.Membership := Strings.Inside;
      Going  : Strings.Direction  := Strings.Forward)
      return   Natural
   is
   begin
      return Search.Index (Source.Reference.all, Set, Test, Going);
   end Index;

   function Index_Non_Blank
     (Source : Unbounded_String;
      Going  : Strings.Direction := Strings.Forward)
      return   Natural
   is
   begin
      return Search.Index_Non_Blank (Source.Reference.all, Going);
   end Index_Non_Blank;

   ------------
   -- Insert --
   ------------

   function Insert
     (Source   : Unbounded_String;
      Before   : Positive;
      New_Item : String)
      return     Unbounded_String
   is
   begin
      return
        To_Unbounded_String
          (Fixed.Insert (Source.Reference.all, Before, New_Item));
   end Insert;

   procedure Insert
     (Source   : in out Unbounded_String;
      Before   : in Positive;
      New_Item : in String)
   is
   begin
      Source := To_Unbounded_String
        (Fixed.Insert (Source.Reference.all, Before, New_Item));
   end Insert;

   ------------
   -- Length --
   ------------

   function Length (Source : Unbounded_String) return Natural is
   begin
      return Source.Reference.all'Length;
   end Length;

   ----------
   -- Move --
   ----------

   --  Note: there is no sharing of pointers in this implementation

   procedure Move
     (Source : Unbounded_String;
      Target : in out String_Access)
   is
      Copy : String_Access := new String'(Source.Reference.all);

   begin
      Free (Target);
      Target := Copy;
   end Move;

   procedure Move
     (Source : String;
      Target : in out String_Access)
   is
      Copy : constant String_Access := new String'(Source);

   begin
      Free (Target);
      Target := Copy;
   end Move;

   ---------------
   -- Overwrite --
   ---------------

   function Overwrite
     (Source    : Unbounded_String;
      Position  : Positive;
      New_Item  : String)
      return      Unbounded_String is

   begin
      return To_Unbounded_String
        (Fixed.Overwrite (Source.Reference.all, Position, New_Item));
   end Overwrite;

   procedure Overwrite
     (Source    : in out Unbounded_String;
      Position  : in Positive;
      New_Item  : in String)
   is
   begin
      Source := To_Unbounded_String
        (Fixed.Overwrite (Source.Reference.all, Position, New_Item));
   end Overwrite;

   ---------------------
   -- Replace_Element --
   ---------------------

   procedure Replace_Element
     (Source : in out Unbounded_String;
      Index  : Positive;
      By     : Character)
   is
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
     (Source   : in Unbounded_String;
      Low      : Positive;
      High     : Natural;
      By       : String)
      return     Unbounded_String
   is
   begin
      return
        To_Unbounded_String
          (Fixed.Replace_Slice (Source.Reference.all, Low, High, By));
   end Replace_Slice;

   procedure Replace_Slice
     (Source   : in out Unbounded_String;
      Low      : in Positive;
      High     : in Natural;
      By       : in String)
   is
   begin
      Source := To_Unbounded_String
        (Fixed.Replace_Slice (Source.Reference.all, Low, High, By));
   end Replace_Slice;

   -----------
   -- Slice --
   -----------

   function Slice
     (Source : Unbounded_String;
      Low    : Positive;
      High   : Natural)
      return   String
   is
      Result : String (1 .. High - Low + 1);

   begin
      Result := Source.Reference.all (Low .. High);
      return Result;
   end Slice;

   ----------
   -- Tail --
   ----------

   function Tail
     (Source : Unbounded_String;
      Count  : Natural;
      Pad    : Character := Space)
      return   Unbounded_String is

   begin
      return
        To_Unbounded_String (Fixed.Tail (Source.Reference.all, Count, Pad));
   end Tail;

   procedure Tail
     (Source : in out Unbounded_String;
      Count  : in Natural;
      Pad    : in Character := Space)
   is
   begin
      Source := To_Unbounded_String
        (Fixed.Tail (Source.Reference.all, Count, Pad));
   end Tail;

   ---------------
   -- To_String --
   ---------------

   function To_String (Source : Unbounded_String) return String is
   begin
      return Source.Reference.all;
   end To_String;

   -------------------------
   -- To_Unbounded_String --
   -------------------------

   function To_Unbounded_String (Source : String) return Unbounded_String is
      Result : Unbounded_String;

   begin
      Result := (Reference => new String (1 .. Source'Length));
      Result.Reference.all := Source;
      return Result;
   end To_Unbounded_String;

   function To_Unbounded_String (Length : in Natural)
      return Unbounded_String
   is
      Result : Unbounded_String;

   begin
      Result := (Reference => new String (1 .. Length));
      return Result;
   end To_Unbounded_String;

   ------------
   -- Append --
   ------------

   procedure Append
     (Source   : in out Unbounded_String;
      New_Item : in Unbounded_String)
   is
      S_Length : constant Integer := Source.Reference.all'Length;
      Length   : constant Integer := S_Length + New_Item.Reference.all'Length;
      Temp     : Unbounded_String := (Reference => new String (1 .. S_Length));

   begin
      Temp.Reference.all := Source.Reference.all;
      Source := (Reference => new String (1 .. Length));
      Source.Reference.all (1 .. S_Length) := Temp.Reference.all;
      Source.Reference.all (S_Length + 1 .. Length) := New_Item.Reference.all;
   end Append;

   procedure Append
     (Source   : in out Unbounded_String;
      New_Item : in String)
   is
      S_Length : constant Integer := Source.Reference.all'Length;
      Length   : constant Integer := S_Length + New_Item'Length;
      Temp     : Unbounded_String := (Reference => new String (1 .. S_Length));

   begin
      Temp.Reference.all := Source.Reference.all;
      Source := (Reference => new String (1 .. Length));
      Source.Reference.all (1 .. S_Length) := Temp.Reference.all;
      Source.Reference.all (S_Length + 1 .. Length) := New_Item;
   end Append;

   procedure Append
     (Source   : in out Unbounded_String;
      New_Item : in character)
   is
      S_Length : constant Integer := Source.Reference.all'Length;
      Length   : constant Integer := S_Length + 1;
      Temp     : Unbounded_String := (Reference => new String (1 .. S_Length));

   begin
      Temp.Reference.all := Source.Reference.all;
      Source := (Reference => new String (1 .. Length));
      Source.Reference.all (1 .. S_Length) := Temp.Reference.all;
      Source.Reference.all (S_Length + 1) := New_Item;
   end Append;

   ---------------
   -- Translate --
   ---------------

   function Translate
     (Source  : Unbounded_String;
      Mapping : Maps.Character_Mapping)
      return    Unbounded_String
   is
   begin
      return
        To_Unbounded_String (Fixed.Translate (Source.Reference.all, Mapping));
   end Translate;

   procedure Translate
     (Source  : in out Unbounded_String;
      Mapping : Maps.Character_Mapping)
   is
   begin
      Fixed.Translate (Source.Reference.all, Mapping);
   end Translate;

   function Translate
     (Source  : in Unbounded_String;
      Mapping : in Maps.Character_Mapping_Function)
      return    Unbounded_String
   is
   begin
      return
        To_Unbounded_String (Fixed.Translate (Source.Reference.all, Mapping));
   end Translate;

   procedure Translate
     (Source  : in out Unbounded_String;
      Mapping : in Maps.Character_Mapping_Function)
   is
   begin
      Fixed.Translate (Source.Reference.all, Mapping);
   end Translate;

   ----------
   -- Trim --
   ----------

   function Trim
     (Source : in Unbounded_String;
      Side   : in Trim_End)
      return   Unbounded_String
   is
   begin
      return To_Unbounded_String (Fixed.Trim (Source.Reference.all, Side));
   end Trim;

   procedure Trim
     (Source : in out Unbounded_String;
      Side   : in Trim_End)
   is
   begin
      Fixed.Trim (Source.Reference.all, Side);
   end Trim;

   function Trim
     (Source : in Unbounded_String;
      Left   : in Maps.Character_Set;
      Right  : in Maps.Character_Set)
      return   Unbounded_String
   is
   begin
      return
        To_Unbounded_String (Fixed.Trim (Source.Reference.all, Left, Right));
   end Trim;

   procedure Trim
     (Source : in out Unbounded_String;
      Left   : in Maps.Character_Set;
      Right  : in Maps.Character_Set)
   is
   begin
      Fixed.Trim (Source.Reference.all, Left, Right);
   end Trim;

end Ada.Strings.Unbounded;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.6
--  date: Tue Jun 28 11:33:20 1994;  author: dewar
--  Undo revision of 1.5, because of GNAT bug that blows things up
--  ----------------------------
--  revision 1.7
--  date: Mon Aug 15 17:51:54 1994;  author: banner
--  Update to RM9X 5.0
--  (Checked in for Bin Li)
--  ----------------------------
--  revision 1.8
--  date: Tue Aug 16 02:36:02 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
