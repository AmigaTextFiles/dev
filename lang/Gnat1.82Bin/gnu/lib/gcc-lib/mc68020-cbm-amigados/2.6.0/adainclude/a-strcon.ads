------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R I N G S . C O N S T A N T S                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.10 $                             --
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

--  Note: we anticipiate that this RM 5.0 package will become obsolete.
--  See package Ada.Strings.Maps.Constants in file a-stmaco.ads ???.


with Ada.Strings.Maps;       use Ada.Strings.Maps;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

package Ada.Strings.Constants is

--  RM 5.0 has this package as preelaborable, but that's clearly wrong since
--  we have to call functions in Ada.Strings.Maps to construct these values.
--  See package Ada.Strings.Maps.Constants which solves this problem

   Control_Set           : constant Maps.Character_Set;
   Graphic_Set           : constant Maps.Character_Set;
   Letter_Set            : constant Maps.Character_Set;
   Lower_Set             : constant Maps.Character_Set;
   Upper_Set             : constant Maps.Character_Set;
   Basic_Set             : constant Maps.Character_Set;
   Decimal_Digit_Set     : constant Maps.Character_Set;
   Hexadecimal_Digit_Set : constant Maps.Character_Set;
   Alphanumeric_Set      : constant Maps.Character_Set;
   Special_Set           : constant Maps.Character_Set;
   ISO_646_Set           : constant Maps.Character_Set;

   --  Maps to lower case for letters, else identity

   Lower_Case_Map        : constant Maps.Character_Mapping;
   Upper_Case_Map        : constant Maps.Character_Mapping;
   Basic_Map             : constant Maps.Character_Mapping;

private
   subtype Character_Ranges_2 is Character_Ranges (1 .. 2);
   subtype Character_Ranges_3 is Character_Ranges (1 .. 3);
   subtype Character_Ranges_5 is Character_Ranges (1 .. 5);
   subtype Character_Ranges_6 is Character_Ranges (1 .. 6);
   subtype Character_Ranges_7 is Character_Ranges (1 .. 7);
   subtype Character_Ranges_9 is Character_Ranges (1 .. 9);
   --  These subtype declarations should not be needed, but GNAT was having
   --  trouble dealing with unconstrained arrays as the types for expression
   --  actions at the outer level.

   Control_Set           : constant Maps.Character_Set := To_Set (
     Character_Ranges_2'(
       (Low => NUL,                 High => US),
       (Low => DEL,                 High => APC)));

   Graphic_Set           : constant Maps.Character_Set := To_Set (
     Character_Ranges_2'(
       (Low => ' ',                 High => '~'),
       (Low => No_Break_Space,      High => LC_Y_Diaeresis)));

   Letter_Set            : constant Maps.Character_Set := To_Set (
     Character_Ranges_5'(
       (Low => 'A',                 High => 'Z'),
       (Low => 'a',                 High => 'z'),
       (Low => UC_A_Grave,          High => UC_O_Diaeresis),
       (Low => UC_O_Oblique_Stroke, High => LC_O_Diaeresis),
       (Low => LC_O_Oblique_Stroke, High => LC_Y_Diaeresis)));

   Lower_Set             : constant Maps.Character_Set := To_Set (
     Character_Ranges_3'(
       (Low => 'a',                 High => 'z'),
       (Low => LC_German_Sharp_S,   High => LC_O_Diaeresis),
       (Low => LC_O_Oblique_Stroke, High => LC_Y_Diaeresis)));

   Upper_Set             : constant Maps.Character_Set := To_Set (
     Character_Ranges_3'(
       (Low => 'A',                 High => 'Z'),
       (Low => UC_A_Grave,          High => UC_O_Diaeresis),
       (Low => UC_O_Oblique_Stroke, High => UC_Icelandic_Thorn)));

   Basic_Set             : constant Maps.Character_Set := To_Set (
     Character_Ranges_9'(
       (Low => 'A',                 High => 'Z'),
       (Low => 'a',                 High => 'z'),
       (Low => UC_AE_Diphthong,     High => UC_AE_Diphthong),
       (Low => LC_AE_Diphthong,     High => LC_AE_Diphthong),
       (Low => LC_German_Sharp_S,   High => LC_German_Sharp_S),
       (Low => UC_Icelandic_Thorn,  High => UC_Icelandic_Thorn),
       (Low => LC_Icelandic_Thorn,  High => LC_Icelandic_Thorn),
       (Low => UC_Icelandic_Eth,    High => UC_Icelandic_Eth),
       (Low => LC_Icelandic_Eth,    High => LC_Icelandic_Eth)));

   Decimal_Digit_Set     : constant Maps.Character_Set := To_Set (
     Character_Range'
       (Low => '0',                 High => '9'));

   Hexadecimal_Digit_Set : constant Maps.Character_Set := To_Set (
     Character_Ranges_3'(
       (Low => '0',                 High => '9'),
       (Low => 'A',                 High => 'F'),
       (Low => 'a',                 High => 'f')));

   Alphanumeric_Set      : constant Maps.Character_Set := To_Set (
     Character_Ranges_6'(
       (Low => '0',                 High => '9'),
       (Low => 'A',                 High => 'Z'),
       (Low => 'a',                 High => 'z'),
       (Low => UC_A_Grave,          High => UC_O_Diaeresis),
       (Low => UC_O_Oblique_Stroke, High => LC_O_Diaeresis),
       (Low => LC_O_Oblique_Stroke, High => LC_Y_Diaeresis)));

   Special_Set           : constant Maps.Character_Set := To_Set (
     Character_Ranges_7'(
       (Low => Space,               High => Solidus),
       (Low => Colon,               High => Commercial_At),
       (Low => Left_Square_Bracket, High => Grave),
       (Low => Left_Curly_Bracket,  High => Tilde),
       (Low => No_Break_Space,      High => Inverted_Question),
       (Low => Multiplication_Sign, High => Multiplication_Sign),
       (Low => Division_Sign,       High => Division_Sign)));

   ISO_646_Set           : constant Maps.Character_Set := To_Set (
     Character_Range'
       (Low => Character'Val (0),   High => Character'Val (127)));

   Lower_Case_Map : constant Character_Mapping := To_Mapping (

     From => "ABCDEFGHIJKLMNOPQRSTUVWXYZ" &
              UC_A_Grave                  &
              UC_A_Acute                  &
              UC_A_Circumflex             &
              UC_A_Tilde                  &
              UC_A_Diaeresis              &
              UC_A_Ring                   &
              UC_AE_Diphthong             &
              UC_C_Cedilla                &
              UC_E_Grave                  &
              UC_E_Acute                  &
              UC_E_Circumflex             &
              UC_E_Diaeresis              &
              UC_I_Grave                  &
              UC_I_Acute                  &
              UC_I_Circumflex             &
              UC_I_Diaeresis              &
              UC_Icelandic_Eth            &
              UC_N_Tilde                  &
              UC_O_Grave                  &
              UC_O_Acute                  &
              UC_O_Circumflex             &
              UC_O_Tilde                  &
              UC_O_Diaeresis              &
              UC_U_Grave                  &
              UC_U_Acute                  &
              UC_U_Circumflex             &
              UC_U_Diaeresis              &
              UC_Y_Acute                  &
              UC_Icelandic_Thorn,

     To =>   "abcdefghijklmnopqrstuvwxyz" &
              LC_A_Grave                  &
              LC_A_Acute                  &
              LC_A_Circumflex             &
              LC_A_Tilde                  &
              LC_A_Diaeresis              &
              LC_A_Ring                   &
              LC_AE_Diphthong             &
              LC_C_Cedilla                &
              LC_E_Grave                  &
              LC_E_Acute                  &
              LC_E_Circumflex             &
              LC_E_Diaeresis              &
              LC_I_Grave                  &
              LC_I_Acute                  &
              LC_I_Circumflex             &
              LC_I_Diaeresis              &
              LC_Icelandic_Eth            &
              LC_N_Tilde                  &
              LC_O_Grave                  &
              LC_O_Acute                  &
              LC_O_Circumflex             &
              LC_O_Tilde                  &
              LC_O_Diaeresis              &
              LC_U_Grave                  &
              LC_U_Acute                  &
              LC_U_Circumflex             &
              LC_U_Diaeresis              &
              LC_Y_Acute                  &
              LC_Icelandic_Thorn);

   Upper_Case_Map : constant Character_Mapping := To_Mapping (

     From => "abcdefghijklmnopqrstuvwxuz" &
              LC_A_Grave                  &
              LC_A_Acute                  &
              LC_A_Circumflex             &
              LC_A_Tilde                  &
              LC_A_Diaeresis              &
              LC_A_Ring                   &
              LC_AE_Diphthong             &
              LC_C_Cedilla                &
              LC_E_Grave                  &
              LC_E_Acute                  &
              LC_E_Circumflex             &
              LC_E_Diaeresis              &
              LC_I_Grave                  &
              LC_I_Acute                  &
              LC_I_Circumflex             &
              LC_I_Diaeresis              &
              LC_Icelandic_Eth            &
              LC_N_Tilde                  &
              LC_O_Grave                  &
              LC_O_Acute                  &
              LC_O_Circumflex             &
              LC_O_Tilde                  &
              LC_O_Diaeresis              &
              LC_U_Grave                  &
              LC_U_Acute                  &
              LC_U_Circumflex             &
              LC_U_Diaeresis              &
              LC_Y_Acute                  &
              LC_Icelandic_Thorn,

     To   => "ABCDEFGHIJKLMNOPQRSTUVWXYZ" &
              UC_A_Grave                  &
              UC_A_Acute                  &
              UC_A_Circumflex             &
              UC_A_Tilde                  &
              UC_A_Diaeresis              &
              UC_A_Ring                   &
              UC_AE_Diphthong             &
              UC_C_Cedilla                &
              UC_E_Grave                  &
              UC_E_Acute                  &
              UC_E_Circumflex             &
              UC_E_Diaeresis              &
              UC_I_Grave                  &
              UC_I_Acute                  &
              UC_I_Circumflex             &
              UC_I_Diaeresis              &
              UC_Icelandic_Eth            &
              UC_N_Tilde                  &
              UC_O_Grave                  &
              UC_O_Acute                  &
              UC_O_Circumflex             &
              UC_O_Tilde                  &
              UC_O_Diaeresis              &
              UC_U_Grave                  &
              UC_U_Acute                  &
              UC_U_Circumflex             &
              UC_U_Diaeresis              &
              UC_Y_Acute                  &
              UC_Icelandic_Thorn);

   Basic_Map : constant Character_Mapping := To_Mapping (

     From =>  UC_A_Grave                  &
              UC_A_Acute                  &
              UC_A_Circumflex             &
              UC_A_Tilde                  &
              UC_A_Diaeresis              &
              UC_A_Ring                   &
              UC_C_Cedilla                &
              UC_E_Grave                  &
              UC_E_Acute                  &
              UC_E_Circumflex             &
              UC_E_Diaeresis              &
              UC_I_Grave                  &
              UC_I_Acute                  &
              UC_I_Circumflex             &
              UC_I_Diaeresis              &
              UC_N_Tilde                  &
              UC_O_Grave                  &
              UC_O_Acute                  &
              UC_O_Circumflex             &
              UC_O_Tilde                  &
              UC_O_Diaeresis              &
              UC_U_Grave                  &
              UC_U_Acute                  &
              UC_U_Circumflex             &
              UC_U_Diaeresis              &
              UC_Y_Acute                  &
              UC_Icelandic_Thorn          &

              LC_A_Grave                  &
              LC_A_Acute                  &
              LC_A_Circumflex             &
              LC_A_Tilde                  &
              LC_A_Diaeresis              &
              LC_A_Ring                   &
              LC_C_Cedilla                &
              LC_E_Grave                  &
              LC_E_Acute                  &
              LC_E_Circumflex             &
              LC_E_Diaeresis              &
              LC_I_Grave                  &
              LC_I_Acute                  &
              LC_I_Circumflex             &
              LC_I_Diaeresis              &
              LC_N_Tilde                  &
              LC_O_Grave                  &
              LC_O_Acute                  &
              LC_O_Circumflex             &
              LC_O_Tilde                  &
              LC_O_Diaeresis              &
              LC_U_Grave                  &
              LC_U_Acute                  &
              LC_U_Circumflex             &
              LC_U_Diaeresis              &
              LC_Y_Acute                  &
              LC_Y_Diaeresis,

     To   =>  "AAAAAACEEEEIIIINOOOOOUUUUY" &
              "aaaaaaceeeeiiiinooooouuuuyy");

end Ada.Strings.Constants;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Tue Jun 28 11:33:12 1994;  author: dewar
--  Avoid use of unconstrained arrays to get around Gigi bug
--  ----------------------------
--  revision 1.9
--  date: Wed Jul 13 18:32:59 1994;  author: schonber
--  Fix character typo in lower case alphabet.
--  ----------------------------
--  revision 1.10
--  date: Sat Aug  6 17:00:12 1994;  author: dewar
--  Add comments that this package is probably obsolete
--  Correct error in entry for LC_Y_Diaeresis in Basic_Map
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
