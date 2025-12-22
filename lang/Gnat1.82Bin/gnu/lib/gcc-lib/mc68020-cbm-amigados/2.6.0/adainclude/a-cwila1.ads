------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--           A D A . C H A R A C T E R S . W I D E _ L A T I N 1            --
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


package Ada.Characters.Wide_Latin_1 is
pragma Pure (Ada.Characters.Wide_Latin_1);

   ------------------------
   -- Control Wide_Characters --
   ------------------------

   NUL                  : constant Wide_Character := Wide_Character'Val (0);
   SOH                  : constant Wide_Character := Wide_Character'Val (1);
   STX                  : constant Wide_Character := Wide_Character'Val (2);
   ETX                  : constant Wide_Character := Wide_Character'Val (3);
   EOT                  : constant Wide_Character := Wide_Character'Val (4);
   ENQ                  : constant Wide_Character := Wide_Character'Val (5);
   ACK                  : constant Wide_Character := Wide_Character'Val (6);
   BEL                  : constant Wide_Character := Wide_Character'Val (7);
   BS                   : constant Wide_Character := Wide_Character'Val (8);
   HT                   : constant Wide_Character := Wide_Character'Val (9);
   LF                   : constant Wide_Character := Wide_Character'Val (10);
   VT                   : constant Wide_Character := Wide_Character'Val (11);
   FF                   : constant Wide_Character := Wide_Character'Val (12);
   CR                   : constant Wide_Character := Wide_Character'Val (13);
   SO                   : constant Wide_Character := Wide_Character'Val (14);
   SI                   : constant Wide_Character := Wide_Character'Val (15);

   DLE                  : constant Wide_Character := Wide_Character'Val (16);
   DC1                  : constant Wide_Character := Wide_Character'Val (17);
   DC2                  : constant Wide_Character := Wide_Character'Val (18);
   DC3                  : constant Wide_Character := Wide_Character'Val (19);
   DC4                  : constant Wide_Character := Wide_Character'Val (20);
   NAK                  : constant Wide_Character := Wide_Character'Val (21);
   SYN                  : constant Wide_Character := Wide_Character'Val (22);
   ETB                  : constant Wide_Character := Wide_Character'Val (23);
   CAN                  : constant Wide_Character := Wide_Character'Val (24);
   EM                   : constant Wide_Character := Wide_Character'Val (25);
   SUB                  : constant Wide_Character := Wide_Character'Val (26);
   ESC                  : constant Wide_Character := Wide_Character'Val (27);
   FS                   : constant Wide_Character := Wide_Character'Val (28);
   GS                   : constant Wide_Character := Wide_Character'Val (29);
   RS                   : constant Wide_Character := Wide_Character'Val (30);
   US                   : constant Wide_Character := Wide_Character'Val (31);

   --------------------------------
   -- ISO 646 Graphic Wide_Characters --
   --------------------------------

   Space                : constant Wide_Character := Wide_Character'Val (32);
   Exclamation          : constant Wide_Character := Wide_Character'Val (33);
   Quotation            : constant Wide_Character := Wide_Character'Val (34);
   Number_Sign          : constant Wide_Character := Wide_Character'Val (35);
   Dollar_Sign          : constant Wide_Character := Wide_Character'Val (36);
   Percent_Sign         : constant Wide_Character := Wide_Character'Val (37);
   Ampersand            : constant Wide_Character := Wide_Character'Val (38);
   Apostrophe           : constant Wide_Character := Wide_Character'Val (39);
   Left_Parenthesis     : constant Wide_Character := Wide_Character'Val (40);
   Right_Parenthesis    : constant Wide_Character := Wide_Character'Val (41);
   Asterisk             : constant Wide_Character := Wide_Character'Val (42);
   Plus_Sign            : constant Wide_Character := Wide_Character'Val (43);
   Comma                : constant Wide_Character := Wide_Character'Val (44);
   Hyphen               : constant Wide_Character := Wide_Character'Val (45);
   Minus_Sign           : Wide_Character renames Hyphen;
   Full_Stop            : constant Wide_Character := Wide_Character'Val (46);
   Solidus              : constant Wide_Character := Wide_Character'Val (47);

   --  Decimal digits '0' though '9' are at positions 48 through 57

   Colon                : constant Wide_Character := Wide_Character'Val (58);
   Semicolon            : constant Wide_Character := Wide_Character'Val (59);
   Less_Than_Sign       : constant Wide_Character := Wide_Character'Val (60);
   Equals_Sign          : constant Wide_Character := Wide_Character'Val (61);
   Greater_Than_Sign    : constant Wide_Character := Wide_Character'Val (62);
   Question             : constant Wide_Character := Wide_Character'Val (63);
   Commercial_At        : constant Wide_Character := Wide_Character'Val (64);

   --  Letters 'A' through 'Z' are at positions 65 through 90

   Left_Square_Bracket  : constant Wide_Character := Wide_Character'Val (91);
   Reverse_Solidus      : constant Wide_Character := Wide_Character'Val (92);
   Right_Square_Bracket : constant Wide_Character := Wide_Character'Val (93);
   Circumflex           : constant Wide_Character := Wide_Character'Val (94);
   Low_Line             : constant Wide_Character := Wide_Character'Val (95);
   Grave                : constant Wide_Character := Wide_Character'Val (96);
   LC_A                 : constant Wide_Character := Wide_Character'Val (97);
   LC_B                 : constant Wide_Character := Wide_Character'Val (98);
   LC_C                 : constant Wide_Character := Wide_Character'Val (99);
   LC_D                 : constant Wide_Character := Wide_Character'Val (100);
   LC_E                 : constant Wide_Character := Wide_Character'Val (101);
   LC_F                 : constant Wide_Character := Wide_Character'Val (102);
   LC_G                 : constant Wide_Character := Wide_Character'Val (103);
   LC_H                 : constant Wide_Character := Wide_Character'Val (104);
   LC_I                 : constant Wide_Character := Wide_Character'Val (105);
   LC_J                 : constant Wide_Character := Wide_Character'Val (106);
   LC_K                 : constant Wide_Character := Wide_Character'Val (107);
   LC_L                 : constant Wide_Character := Wide_Character'Val (108);
   LC_M                 : constant Wide_Character := Wide_Character'Val (109);
   LC_N                 : constant Wide_Character := Wide_Character'Val (110);
   LC_O                 : constant Wide_Character := Wide_Character'Val (111);
   LC_P                 : constant Wide_Character := Wide_Character'Val (112);
   LC_Q                 : constant Wide_Character := Wide_Character'Val (113);
   LC_R                 : constant Wide_Character := Wide_Character'Val (114);
   LC_S                 : constant Wide_Character := Wide_Character'Val (115);
   LC_T                 : constant Wide_Character := Wide_Character'Val (116);
   LC_U                 : constant Wide_Character := Wide_Character'Val (117);
   LC_V                 : constant Wide_Character := Wide_Character'Val (118);
   LC_W                 : constant Wide_Character := Wide_Character'Val (119);
   LC_X                 : constant Wide_Character := Wide_Character'Val (120);
   LC_Y                 : constant Wide_Character := Wide_Character'Val (121);
   LC_Z                 : constant Wide_Character := Wide_Character'Val (122);
   Left_Curly_Bracket   : constant Wide_Character := Wide_Character'Val (123);
   Vertical_Line        : constant Wide_Character := Wide_Character'Val (125);
   Right_Curly_Bracket  : constant Wide_Character := Wide_Character'Val (125);
   Tilde                : constant Wide_Character := Wide_Character'Val (126);

   DEL                  : constant Wide_Character := Wide_Character'Val (127);

   ---------------------------------
   -- ISO 6429 Control Wide_Characters --
   ---------------------------------

   IS4 : Wide_Character renames FS;
   IS3 : Wide_Character renames GS;
   IS2 : Wide_Character renames RS;
   IS1 : Wide_Character renames US;

   Reserved_128         : constant Wide_Character := Wide_Character'Val (128);
   Reserved_129         : constant Wide_Character := Wide_Character'Val (129);
   Reserved_130         : constant Wide_Character := Wide_Character'Val (130);
   Reserved_131         : constant Wide_Character := Wide_Character'Val (131);
   IND                  : constant Wide_Character := Wide_Character'Val (132);
   NEL                  : constant Wide_Character := Wide_Character'Val (133);
   SSA                  : constant Wide_Character := Wide_Character'Val (134);
   ESA                  : constant Wide_Character := Wide_Character'Val (135);
   HTS                  : constant Wide_Character := Wide_Character'Val (136);
   HTJ                  : constant Wide_Character := Wide_Character'Val (137);
   VTS                  : constant Wide_Character := Wide_Character'Val (138);
   PLD                  : constant Wide_Character := Wide_Character'Val (139);
   PLU                  : constant Wide_Character := Wide_Character'Val (140);
   RI                   : constant Wide_Character := Wide_Character'Val (141);
   SS2                  : constant Wide_Character := Wide_Character'Val (142);
   SS3                  : constant Wide_Character := Wide_Character'Val (143);

   DCS                  : constant Wide_Character := Wide_Character'Val (144);
   PU1                  : constant Wide_Character := Wide_Character'Val (145);
   PU2                  : constant Wide_Character := Wide_Character'Val (146);
   STS                  : constant Wide_Character := Wide_Character'Val (147);
   CCH                  : constant Wide_Character := Wide_Character'Val (148);
   MW                   : constant Wide_Character := Wide_Character'Val (149);
   SPA                  : constant Wide_Character := Wide_Character'Val (150);
   EPA                  : constant Wide_Character := Wide_Character'Val (151);

   Reserved_152         : constant Wide_Character := Wide_Character'Val (152);
   Reserved_153         : constant Wide_Character := Wide_Character'Val (153);
   Reserved_154         : constant Wide_Character := Wide_Character'Val (154);
   CSI                  : constant Wide_Character := Wide_Character'Val (155);
   ST                   : constant Wide_Character := Wide_Character'Val (156);
   OSC                  : constant Wide_Character := Wide_Character'Val (157);
   PM                   : constant Wide_Character := Wide_Character'Val (158);
   APC                  : constant Wide_Character := Wide_Character'Val (159);

   ------------------------------
   -- Other Graphic Wide_Characters --
   ------------------------------

   No_Break_Space       : constant Wide_Character := Wide_Character'Val (160);
   NBSP                 : Wide_Character renames No_Break_Space;
   Inverted_Exclamation : constant Wide_Character := Wide_Character'Val (161);
   Cent_Sign            : constant Wide_Character := Wide_Character'Val (162);
   Pound_Sign           : constant Wide_Character := Wide_Character'Val (163);
   Currency_Sign        : constant Wide_Character := Wide_Character'Val (164);
   Yen_Sign             : constant Wide_Character := Wide_Character'Val (165);
   Broken_Bar           : constant Wide_Character := Wide_Character'Val (166);
   Section_Sign         : constant Wide_Character := Wide_Character'Val (167);
   Paragraph_Sign       : Wide_Character renames Section_Sign;
   Diaeresis            : constant Wide_Character := Wide_Character'Val (168);
   Copyright_Sign       : constant Wide_Character := Wide_Character'Val (169);
   Feminine_Ordinal_Indicator
                        : constant Wide_Character := Wide_Character'Val (170);
   Left_Angle_Quotation : constant Wide_Character := Wide_Character'Val (171);
   Not_Sign             : constant Wide_Character := Wide_Character'Val (172);
   Soft_Hyphen          : constant Wide_Character := Wide_Character'Val (173);
   Registered_Trade_Mark_Sign
                        : constant Wide_Character := Wide_Character'Val (174);
   Macron               : constant Wide_Character := Wide_Character'Val (175);
   Degree_Sign          : constant Wide_Character := Wide_Character'Val (176);
   Ring_Above           : Wide_Character renames Degree_Sign;
   Plus_Minus_Sign      : constant Wide_Character := Wide_Character'Val (177);
   Superscript_Two      : constant Wide_Character := Wide_Character'Val (178);
   Superscript_Three    : constant Wide_Character := Wide_Character'Val (179);
   Acute                : constant Wide_Character := Wide_Character'Val (180);
   Micro_Sign           : constant Wide_Character := Wide_Character'Val (181);
   Pilcrow_Sign         : constant Wide_Character := Wide_Character'Val (182);
   Middle_Dot           : constant Wide_Character := Wide_Character'Val (183);
   Cedilla              : constant Wide_Character := Wide_Character'Val (184);
   Superscript_One      : constant Wide_Character := Wide_Character'Val (185);
   Masculine_Ordinal_Indicator
                        : constant Wide_Character := Wide_Character'Val (186);
   Right_Angle_Quotation
                        : constant Wide_Character := Wide_Character'Val (187);
   Fraction_One_Quarter : constant Wide_Character := Wide_Character'Val (188);
   Fraction_One_Half    : constant Wide_Character := Wide_Character'Val (189);
   Fraction_Three_Quarters
                        : constant Wide_Character := Wide_Character'Val (190);
   Inverted_Question    : constant Wide_Character := Wide_Character'Val (191);
   UC_A_Grave           : constant Wide_Character := Wide_Character'Val (192);
   UC_A_Acute           : constant Wide_Character := Wide_Character'Val (193);
   UC_A_Circumflex      : constant Wide_Character := Wide_Character'Val (194);
   UC_A_Tilde           : constant Wide_Character := Wide_Character'Val (195);
   UC_A_Diaeresis       : constant Wide_Character := Wide_Character'Val (196);
   UC_A_Ring            : constant Wide_Character := Wide_Character'Val (197);
   UC_AE_Diphthong      : constant Wide_Character := Wide_Character'Val (198);
   UC_C_Cedilla         : constant Wide_Character := Wide_Character'Val (199);
   UC_E_Grave           : constant Wide_Character := Wide_Character'Val (200);
   UC_E_Acute           : constant Wide_Character := Wide_Character'Val (201);
   UC_E_Circumflex      : constant Wide_Character := Wide_Character'Val (202);
   UC_E_Diaeresis       : constant Wide_Character := Wide_Character'Val (203);
   UC_I_Grave           : constant Wide_Character := Wide_Character'Val (204);
   UC_I_Acute           : constant Wide_Character := Wide_Character'Val (205);
   UC_I_Circumflex      : constant Wide_Character := Wide_Character'Val (206);
   UC_I_Diaeresis       : constant Wide_Character := Wide_Character'Val (207);
   UC_Icelandic_Eth     : constant Wide_Character := Wide_Character'Val (208);
   UC_N_Tilde           : constant Wide_Character := Wide_Character'Val (209);
   UC_O_Grave           : constant Wide_Character := Wide_Character'Val (210);
   UC_O_Acute           : constant Wide_Character := Wide_Character'Val (211);
   UC_O_Circumflex      : constant Wide_Character := Wide_Character'Val (212);
   UC_O_Tilde           : constant Wide_Character := Wide_Character'Val (213);
   UC_O_Diaeresis       : constant Wide_Character := Wide_Character'Val (214);
   Multiplication_Sign  : constant Wide_Character := Wide_Character'Val (215);
   UC_O_Oblique_Stroke  : constant Wide_Character := Wide_Character'Val (216);
   UC_U_Grave           : constant Wide_Character := Wide_Character'Val (217);
   UC_U_Acute           : constant Wide_Character := Wide_Character'Val (218);
   UC_U_Circumflex      : constant Wide_Character := Wide_Character'Val (219);
   UC_U_Diaeresis       : constant Wide_Character := Wide_Character'Val (220);
   UC_Y_Acute           : constant Wide_Character := Wide_Character'Val (221);
   UC_Icelandic_Thorn   : constant Wide_Character := Wide_Character'Val (222);
   LC_German_Sharp_S    : constant Wide_Character := Wide_Character'Val (223);
   LC_A_Grave           : constant Wide_Character := Wide_Character'Val (224);
   LC_A_Acute           : constant Wide_Character := Wide_Character'Val (225);
   LC_A_Circumflex      : constant Wide_Character := Wide_Character'Val (226);
   LC_A_Tilde           : constant Wide_Character := Wide_Character'Val (227);
   LC_A_Diaeresis       : constant Wide_Character := Wide_Character'Val (228);
   LC_A_Ring            : constant Wide_Character := Wide_Character'Val (229);
   LC_AE_Diphthong      : constant Wide_Character := Wide_Character'Val (230);
   LC_C_Cedilla         : constant Wide_Character := Wide_Character'Val (231);
   LC_E_Grave           : constant Wide_Character := Wide_Character'Val (232);
   LC_E_Acute           : constant Wide_Character := Wide_Character'Val (233);
   LC_E_Circumflex      : constant Wide_Character := Wide_Character'Val (234);
   LC_E_Diaeresis       : constant Wide_Character := Wide_Character'Val (235);
   LC_I_Grave           : constant Wide_Character := Wide_Character'Val (236);
   LC_I_Acute           : constant Wide_Character := Wide_Character'Val (237);
   LC_I_Circumflex      : constant Wide_Character := Wide_Character'Val (238);
   LC_I_Diaeresis       : constant Wide_Character := Wide_Character'Val (239);
   LC_Icelandic_Eth     : constant Wide_Character := Wide_Character'Val (240);
   LC_N_Tilde           : constant Wide_Character := Wide_Character'Val (241);
   LC_O_Grave           : constant Wide_Character := Wide_Character'Val (242);
   LC_O_Acute           : constant Wide_Character := Wide_Character'Val (243);
   LC_O_Circumflex      : constant Wide_Character := Wide_Character'Val (244);
   LC_O_Tilde           : constant Wide_Character := Wide_Character'Val (245);
   LC_O_Diaeresis       : constant Wide_Character := Wide_Character'Val (246);
   Division_Sign        : constant Wide_Character := Wide_Character'Val (247);
   LC_O_Oblique_Stroke  : constant Wide_Character := Wide_Character'Val (248);
   LC_U_Grave           : constant Wide_Character := Wide_Character'Val (249);
   LC_U_Acute           : constant Wide_Character := Wide_Character'Val (250);
   LC_U_Circumflex      : constant Wide_Character := Wide_Character'Val (251);
   LC_U_Diaeresis       : constant Wide_Character := Wide_Character'Val (252);
   LC_Y_Acute           : constant Wide_Character := Wide_Character'Val (253);
   LC_Icelandic_Thorn   : constant Wide_Character := Wide_Character'Val (254);
   LC_Y_Diaeresis       : constant Wide_Character := Wide_Character'Val (255);

end Ada.Characters.Wide_Latin_1;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Fri Jun  3 13:02:37 1994;  author: sheng
--  Temporarily disable Pragma Pure.
--   Since package's parent is also temporarily disabled, otherwise
--   there will be Pure dependecy violation.
--  ----------------------------
--  revision 1.4
--  date: Fri Jun  3 15:58:41 1994;  author: sheng
--  Undo last changes. Enable Pragma Pure.
--  ----------------------------
--  revision 1.5
--  date: Mon Jun  6 12:02:56 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
