------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--              A D A . S T R I N G S . W I D E _ S E A R C H               --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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
--  versions of the Appendix C string handling packages (code extracted
--  from Ada.Strings.Fixed). A significant change is that we optimize the
--  case of identity mappings for Count and Index, and also Index_Non_Blank
--  is specialized (rather than using the general Index routine).


with Ada.Characters;

package body Ada.Strings.Wide_Search is

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Belongs (Element : Wide_Character;
                     Set     : Wide_Maps.Wide_Character_Set;
                     Test    : Membership)
     return Boolean;
   pragma Inline (Belongs);
   --  Determines if the given element is in (Test = Inside) or not in
   --  (Test = Outside) the given character set.

   -------------
   -- Belongs --
   -------------

   function Belongs (Element : Wide_Character;
                     Set     : Wide_Maps.Wide_Character_Set;
                     Test    : Membership)
     return Boolean is
   begin
      if Test = Inside then
         return Element in Set'range and then Set (Element);
      else
         return Element not in Set'range or else not Set (Element);
      end if;
   end Belongs;

   -----------
   -- Count --
   -----------

   function Count (Source   : in Wide_String;
                   Pattern  : in Wide_String;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping :=
                                          Wide_Maps.Identity)
     return Natural
   is
      N : Natural;
      J : Natural;

   begin
      --  Handle the case of non-identity mappings by creating a mapped
      --  string and making a recursive call using the identity mapping
      --  on this mapped string. We identify the identity mapping by the
      --  fact that our standard representation for Identity is empty.

      if Mapping'Last < Mapping'First then
         declare
            Mapped_Source : Wide_String (Source'range);

         begin
            for J in Source'range loop
               if Source (J) in Mapping'range then
                  Mapped_Source (J) := Mapping (Source (J));
               else
                  Mapped_Source (J) := Source (J);
               end if;
            end loop;

            return Count (Mapped_Source, Pattern);
         end;
      end if;

      if Pattern = "" then
         raise Pattern_Error;
      end if;

      N := 0;
      J := Source'First;

      while J <= Source'Last - (Pattern'Length - 1) loop
         if Source (J .. J + (Pattern'Length - 1)) = Pattern then
            N := N + 1;
            J := J + Pattern'Length;
         else
            J := J + 1;
         end if;
      end loop;

      return N;
   end Count;

   function Count (Source   : in Wide_String;
                   Pattern  : in Wide_String;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
     return Natural
   is
      Mapped_Source : Wide_String (Source'range);

   begin
      for J in Source'range loop
         Mapped_Source (J) := Mapping (Source (J));
      end loop;

      return Count (Mapped_Source, Pattern);
   end Count;

   function Count (Source : in Wide_String;
                   Set    : in Wide_Maps.Wide_Character_Set)
     return Natural
   is
      N : Natural := 0;

   begin
      for I in Source'range loop
         if Source (I) in Set'range and then Set (Source (I)) then
            N := N + 1;
         end if;
      end loop;

      return N;
   end Count;

   ----------------
   -- Find_Token --
   ----------------

   procedure Find_Token (Source : in Wide_String;
                         Set    : in Wide_Maps.Wide_Character_Set;
                         Test   : in Membership;
                         First  : out Positive;
                         Last   : out Natural) is
   begin
      for I in Source'range loop
         if Belongs (Source (I), Set, Test) then
            First := I;

            for J in I + 1 .. Source'Last loop
               if not Belongs (Source (J), Set, Test) then
                  Last := J - 1;
                  return;
               end if;
            end loop;

            --  Here if I indexes 1st char of token, and all chars
            --  after I are in the token

            Last := Source'Last;
            return;
         end if;
      end loop;

      --  Here if no token found

      First := Source'First;
      Last  := 0;
   end Find_Token;

   -----------
   -- Index --
   -----------

   function Index (Source   : in Wide_String;
                   Pattern  : in Wide_String;
                   Going    : in Direction := Forward;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping :=
                                          Wide_Maps.Identity)
     return Natural is

   begin
      --  Handle the case of non-identity mappings by creating a mapped
      --  string and making a recursive call using the identity mapping
      --  on this mapped string. We identify the identity mapping by the
      --  fact that our standard representation for Identity is empty.

      if Mapping'Last < Mapping'First then
         declare
            Mapped_Source : Wide_String (Source'range);

         begin
            for J in Source'range loop
               if Source (J) in Mapping'range then
                  Mapped_Source (J) := Mapping (Source (J));
               else
                  Mapped_Source (J) := Source (J);
               end if;
            end loop;

            return Index (Mapped_Source, Pattern, Going);
         end;
      end if;

      if Pattern = "" then
         raise Pattern_Error;
      end if;

      if Going = Forward then
         for J in 1 .. Source'Length - Pattern'Length + 1 loop
            if Pattern = Source (J .. J + Pattern'Length - 1) then
               return J + Source'First - 1;
            end if;
         end loop;

      else -- Going = Backward
         for J in reverse 1 .. Source'Length - Pattern'Length + 1 loop
            if Pattern = Source (J .. J + Pattern'Length - 1) then
               return J + Source'First - J;
            end if;
         end loop;
      end if;

      --  Fall through if no match found. Note that the loops are skipped
      --  completely in the case of the pattern being longer than the source.

      return 0;
   end Index;

   -----------
   -- Index --
   -----------

   function Index (Source   : in Wide_String;
                   Pattern  : in Wide_String;
                   Going    : in Direction := Forward;
                   Mapping  : in Wide_Maps.Wide_Character_Mapping_Function)
     return Natural
   is
      Mapped_Source : Wide_String (Source'range);

   begin
      for J in Source'range loop
         Mapped_Source (J) := Mapping (Source (J));
      end loop;

      return Index (Mapped_Source, Pattern, Going);
   end Index;

   function Index (Source : in Wide_String;
                   Set    : in Wide_Maps.Wide_Character_Set;
                   Test   : in Membership := Inside;
                   Going  : in Direction  := Forward)
     return Natural is

   begin
      if Going = Forward then
         for J in Source'range loop
            if Belongs (Source (J), Set, Test) then
               return J;
            end if;
         end loop;

      else -- Going = Backward
         for J in reverse Source'range loop
            if Belongs (Source (J), Set, Test) then
               return J;
            end if;
         end loop;
      end if;

      --  Fall through if no match

      return 0;
   end Index;

   ---------------------
   -- Index_Non_Blank --
   ---------------------

   function Index_Non_Blank (Source : in Wide_String;
                             Going  : in Direction := Forward)
     return Natural is

   begin
      if Going = Forward then
         for J in Source'range loop
            if Source (J) /= ' ' then
               return J;
            end if;
         end loop;

      else -- Going = Backward
         for J in reverse Source'range loop
            if Source (J) /= ' ' then
               return J;
            end if;
         end loop;
      end if;

      --  Fall through if no match

      return 0;

   end Index_Non_Blank;

end Ada.Strings.Wide_Search;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 00:51:56 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:56:00 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
