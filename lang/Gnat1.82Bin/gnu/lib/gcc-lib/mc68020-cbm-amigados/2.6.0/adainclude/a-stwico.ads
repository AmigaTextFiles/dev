------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--           A D A . S T R I N G S . W I D E _ C O N S T A N T S            --
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
with Ada.Characters.Wide_Latin_1; use Ada.Characters.Wide_Latin_1;

package Ada.Strings.Wide_Constants is

   Control_Set           : constant Wide_Maps.Wide_Character_Set;
   Graphic_Set           : constant Wide_Maps.Wide_Character_Set;
   Letter_Set            : constant Wide_Maps.Wide_Character_Set;
   Lower_Set             : constant Wide_Maps.Wide_Character_Set;
   Upper_Set             : constant Wide_Maps.Wide_Character_Set;
   Basic_Set             : constant Wide_Maps.Wide_Character_Set;
   Decimal_Digit_Set     : constant Wide_Maps.Wide_Character_Set;
   Hexadecimal_Digit_Set : constant Wide_Maps.Wide_Character_Set;
   Alphanumeric_Set      : constant Wide_Maps.Wide_Character_Set;
   Special_Graphic_Set   : constant Wide_Maps.Wide_Character_Set;
   ISO_646_Set           : constant Wide_Maps.Wide_Character_Set;
   Character_Set         : constant Wide_Maps.Wide_Character_Set;

   Lower_Case_Map        : constant Wide_Maps.Wide_Character_Mapping;
   --  Maps to lower case for letters, else identity

private

   subtype Cset is Wide_Maps.Wide_Character_Set (
     Wide_Character'Val (0) .. Wide_Character'Val (255));
   --  Declare constrained subtype so we can use others in aggregates

   Control_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     NUL .. US                                 => True,
     DEL                                       => True,
     Reserved_128 .. APC                       => True,
     others                                    => False);

   Graphic_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     NUL .. US                                 => False,
     DEL                                       => False,
     Reserved_128 .. APC                       => False,
     others                                    => True);

   Letter_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     'A' .. 'Z'                                => True,
     'a' .. 'z'                                => True,
     UC_A_Grave .. UC_O_Diaeresis              => True,
     UC_O_Oblique_Stroke .. LC_O_Diaeresis     => True,
     LC_O_Oblique_Stroke .. LC_Y_Diaeresis     => True,
     others                                    => False);

   Lower_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     'a' .. 'z'                                => True,
     LC_German_Sharp_S   .. LC_O_Diaeresis     => True,
     LC_O_Oblique_Stroke .. LC_Y_Diaeresis     => True,
     others                                    => False);

   Upper_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     'A' .. 'Z'                                => True,
     UC_A_Grave          .. UC_O_Diaeresis     => True,
     UC_O_Oblique_Stroke .. UC_Icelandic_Thorn => True,
     others                                    => False);

   Basic_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     'A' .. 'Z'                                => True,
     'a' .. 'z'                                => True,
     UC_AE_Diphthong                           => True,
     LC_AE_Diphthong                           => True,
     LC_German_Sharp_S                         => True,
     UC_Icelandic_Thorn                        => True,
     LC_Icelandic_Thorn                        => True,
     UC_Icelandic_Eth                          => True,
     LC_Icelandic_Eth                          => True,
     others                                    => False);

   Decimal_Digit_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     '0' .. '9'                                => True,
     others                                    => False);

   Hexadecimal_Digit_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     '0' .. '9'                                => True,
     'A' .. 'F'                                => True,
     'a' .. 'f'                                => True,
     others                                    => False);

   Alphanumeric_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     '0' .. '9'                                => True,
     'A' .. 'Z'                                => True,
     'a' .. 'z'                                => True,
     UC_A_Grave .. UC_O_Diaeresis              => True,
     UC_O_Oblique_Stroke .. LC_O_Diaeresis     => True,
     LC_O_Oblique_Stroke .. LC_Y_Diaeresis     => True,
     others                                    => False);

   Special_Graphic_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     Space .. Solidus                          => True,
     Colon .. Commercial_At                    => True,
     Left_Square_Bracket .. Grave              => True,
     Left_Curly_Bracket  .. Tilde              => True,
     No_Break_Space      .. Inverted_Question  => True,
     Multiplication_Sign                       => True,
     Division_Sign                             => True,
     others                                    => False);

   ISO_646_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     NUL .. DEL                                => True,
     others                                    => False);

   Character_Set : constant Wide_Maps.Wide_Character_Set := Cset'(
     others                                    => True);

   subtype Lmap_Mapping is Wide_Maps.Wide_Character_Mapping
     (Wide_Character range 'A' .. UC_Icelandic_Thorn);

   Lower_Case_Map : constant Wide_Maps.Wide_Character_Mapping
                                                    := Lmap_Mapping'(
     'A'                         => 'a',                           -- 65
     'B'                         => 'b',                           -- 66
     'C'                         => 'c',                           -- 67
     'D'                         => 'd',                           -- 68
     'E'                         => 'e',                           -- 69
     'F'                         => 'f',                           -- 70
     'G'                         => 'g',                           -- 71
     'H'                         => 'h',                           -- 72
     'I'                         => 'i',                           -- 73
     'J'                         => 'j',                           -- 74
     'K'                         => 'k',                           -- 75
     'L'                         => 'l',                           -- 76
     'M'                         => 'm',                           -- 77
     'N'                         => 'n',                           -- 78
     'O'                         => 'o',                           -- 79
     'P'                         => 'p',                           -- 80
     'Q'                         => 'q',                           -- 81
     'R'                         => 'r',                           -- 82
     'S'                         => 's',                           -- 83
     'T'                         => 't',                           -- 84
     'U'                         => 'u',                           -- 85
     'V'                         => 'v',                           -- 86
     'W'                         => 'w',                           -- 87
     'X'                         => 'x',                           -- 88
     'Y'                         => 'y',                           -- 89
     'Z'                         => 'z',                           -- 90

     Left_Square_Bracket         => Left_Square_Bracket,           -- 91
     Reverse_Solidus             => Reverse_Solidus,               -- 92
     Right_Square_Bracket        => Right_Square_Bracket,          -- 93
     Circumflex                  => Circumflex,                    -- 94
     Low_Line                    => Low_Line,                      -- 95
     Grave                       => Grave,                         -- 96

     'a'                         => 'a',                           -- 97
     'b'                         => 'b',                           -- 98
     'c'                         => 'c',                           -- 99
     'd'                         => 'd',                           -- 100
     'e'                         => 'e',                           -- 101
     'f'                         => 'f',                           -- 102
     'g'                         => 'g',                           -- 103
     'h'                         => 'h',                           -- 104
     'i'                         => 'i',                           -- 105
     'j'                         => 'j',                           -- 106
     'k'                         => 'k',                           -- 107
     'l'                         => 'l',                           -- 108
     'm'                         => 'm',                           -- 109
     'n'                         => 'n',                           -- 110
     'o'                         => 'o',                           -- 111
     'p'                         => 'p',                           -- 112
     'q'                         => 'q',                           -- 113
     'r'                         => 'r',                           -- 114
     's'                         => 's',                           -- 115
     't'                         => 't',                           -- 116
     'u'                         => 'u',                           -- 117
     'v'                         => 'v',                           -- 118
     'w'                         => 'w',                           -- 119
     'x'                         => 'x',                           -- 120
     'y'                         => 'y',                           -- 121
     'z'                         => 'z',                           -- 122

     '{'                         => '{',                           -- 123
     '|'                         => '|',                           -- 124
     '}'                         => '}',                           -- 125
     '~'                         => '~',                           -- 126

     DEL                         => DEL,                           -- 127

     Reserved_128                => Reserved_128,                  -- 128
     Reserved_129                => Reserved_129,                  -- 129
     Reserved_130                => Reserved_130,                  -- 130
     Reserved_131                => Reserved_131,                  -- 131
     IND                         => IND,                           -- 132
     NEL                         => NEL,                           -- 133
     SSA                         => SSA,                           -- 134
     ESA                         => ESA,                           -- 135
     HTS                         => HTS,                           -- 136
     HTJ                         => HTJ,                           -- 137
     VTS                         => VTS,                           -- 138
     PLD                         => PLD,                           -- 139
     PLU                         => PLU,                           -- 140
     RI                          => RI,                            -- 141
     SS2                         => SS2,                           -- 142
     SS3                         => SS3,                           -- 143

     DCS                         => DCS,                           -- 144
     PU1                         => PU1,                           -- 145
     PU2                         => PU2,                           -- 146
     STS                         => STS,                           -- 147
     CCH                         => CCH,                           -- 148
     MW                          => MW,                            -- 149
     SPA                         => SPA,                           -- 150
     EPA                         => EPA,                           -- 151

     Reserved_152                => Reserved_152,                  -- 152
     Reserved_153                => Reserved_153,                  -- 153
     Reserved_154                => Reserved_154,                  -- 154
     CSI                         => CSI,                           -- 155
     ST                          => ST,                            -- 156
     OSC                         => OSC,                           -- 157
     PM                          => PM,                            -- 158
     APC                         => APC,                           -- 159

     No_Break_Space              => No_Break_Space,                -- 160
     Inverted_Exclamation        => Inverted_Exclamation,          -- 161
     Cent_Sign                   => Cent_Sign,                     -- 162
     Pound_Sign                  => Pound_Sign,                    -- 163
     Currency_Sign               => Currency_Sign,                 -- 164
     Yen_Sign                    => Yen_Sign,                      -- 165
     Broken_Bar                  => Broken_Bar,                    -- 166
     Section_Sign                => Section_Sign,                  -- 167
     Diaeresis                   => Diaeresis,                     -- 168
     Copyright_Sign              => Copyright_Sign,                -- 169
     Feminine_Ordinal_Indicator  => Feminine_Ordinal_Indicator,    -- 170
     Left_Angle_Quotation        => Left_Angle_Quotation,          -- 171
     Not_Sign                    => Not_Sign,                      -- 172
     Soft_Hyphen                 => Soft_Hyphen,                   -- 173
     Registered_Trade_Mark_Sign  => Registered_Trade_Mark_Sign,    -- 174
     Macron                      => Macron,                        -- 175
     Degree_Sign                 => Degree_Sign,                   -- 176
     Plus_Minus_Sign             => Plus_Minus_Sign,               -- 177
     Superscript_Two             => Superscript_Two,               -- 178
     Superscript_Three           => Superscript_Three,             -- 179
     Acute                       => Acute,                         -- 180
     Micro_Sign                  => Micro_Sign,                    -- 181
     Pilcrow_Sign                => Pilcrow_Sign,                  -- 182
     Middle_Dot                  => Middle_Dot,                    -- 183
     Cedilla                     => Cedilla,                       -- 184
     Superscript_One             => Superscript_One,               -- 185
     Masculine_Ordinal_Indicator => Masculine_Ordinal_Indicator,   -- 186
     Right_Angle_Quotation       => Right_Angle_Quotation,         -- 187
     Fraction_One_Quarter        => Fraction_One_Quarter,          -- 188
     Fraction_One_Half           => Fraction_One_Half,             -- 189
     Fraction_Three_Quarters     => Fraction_Three_Quarters,       -- 190
     Inverted_Question           => Inverted_Question,             -- 191

     UC_A_Grave                  => LC_A_Grave,                    -- 192
     UC_A_Acute                  => LC_A_Acute,                    -- 193
     UC_A_Circumflex             => LC_A_Circumflex,               -- 194
     UC_A_Tilde                  => LC_A_Tilde,                    -- 195
     UC_A_Diaeresis              => LC_A_Diaeresis,                -- 196
     UC_A_Ring                   => LC_A_Ring,                     -- 197
     UC_AE_Diphthong             => LC_AE_Diphthong,               -- 198
     UC_C_Cedilla                => LC_C_Cedilla,                  -- 199
     UC_E_Grave                  => LC_E_Grave,                    -- 200
     UC_E_Acute                  => LC_E_Acute,                    -- 201
     UC_E_Circumflex             => LC_E_Circumflex,               -- 202
     UC_E_Diaeresis              => LC_E_Diaeresis,                -- 203
     UC_I_Grave                  => LC_I_Grave,                    -- 204
     UC_I_Acute                  => LC_I_Acute,                    -- 205
     UC_I_Circumflex             => LC_I_Circumflex,               -- 206
     UC_I_Diaeresis              => LC_I_Diaeresis,                -- 207
     UC_Icelandic_Eth            => LC_Icelandic_Eth,              -- 208
     UC_N_Tilde                  => LC_N_Tilde,                    -- 209
     UC_O_Grave                  => LC_O_Grave,                    -- 210
     UC_O_Acute                  => LC_O_Acute,                    -- 211
     UC_O_Circumflex             => LC_O_Circumflex,               -- 212
     UC_O_Tilde                  => LC_O_Tilde,                    -- 213
     UC_O_Diaeresis              => LC_O_Diaeresis,                -- 214

     Multiplication_Sign         => Multiplication_Sign,           -- 215

     UC_O_Oblique_Stroke         => LC_O_Oblique_Stroke,           -- 216
     UC_U_Grave                  => LC_U_Grave,                    -- 217
     UC_U_Acute                  => LC_U_Acute,                    -- 218
     UC_U_Circumflex             => LC_U_Circumflex,               -- 219
     UC_U_Diaeresis              => LC_U_Diaeresis,                -- 220
     UC_Y_Acute                  => LC_Y_Acute,                    -- 221
     UC_Icelandic_Thorn          => LC_Icelandic_Thorn             -- 222
   );

end Ada.Strings.Wide_Constants;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Sat Jan 29 17:10:41 1994;  author: dewar
--  Remove deferred constants till GNAT bug fixed
--  ----------------------------
--  revision 1.4
--  date: Sun Jan 30 00:23:19 1994;  author: dewar
--  Put back deferred constants now that GNAT bug is fixed
--  ----------------------------
--  revision 1.5
--  date: Tue Feb 15 13:00:49 1994;  author: schonber
--  Fix typo.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
