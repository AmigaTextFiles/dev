------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                   I N T E R F A C E S . F O R T R A N                    --
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

with Ada.Numerics.Generic_Complex_Types;

pragma Elaborate_All (Ada.Numerics.Generic_Complex_Types);

package Interfaces.Fortran is
pragma Pure (Interfaces.Fortran);

   type Integer is new Standard_Integer;
   subtype Fortran_Integer is Integer;

   type Real             is new Standard.Float;
   type Double_Precision is new Standard.Long_Float;

   type Logical is new Boolean;

   package Single_Precision_Complex_Types is
      new Ada.Numerics.Generic_Complex_Types (Real);

   type Complex is new Single_Precision_Complex_Types.Complex;

   type Imaginary is new Single_Precision_Complex_Types.Imaginary;
   i : constant Imaginary := Imaginary (Single_Precision_Complex_Types.i);
   j : constant Imaginary := Imaginary (Single_Precision_Complex_Types.j);

   type Character_Set is new Character;

   type Character is array (Positive range <>) of Character_Set;
   pragma Pack (Character);

   subtype Fortran_Character is Character;

   Ada_To_Fortran : constant array (Standard.Character) of Character_Set := (
     Character_Set'Val (000), Character_Set'Val (001),
     Character_Set'Val (002), Character_Set'Val (003),
     Character_Set'Val (004), Character_Set'Val (005),
     Character_Set'Val (006), Character_Set'Val (007),
     Character_Set'Val (008), Character_Set'Val (009),
     Character_Set'Val (010), Character_Set'Val (011),
     Character_Set'Val (012), Character_Set'Val (013),
     Character_Set'Val (014), Character_Set'Val (015),
     Character_Set'Val (016), Character_Set'Val (017),
     Character_Set'Val (018), Character_Set'Val (019),
     Character_Set'Val (020), Character_Set'Val (021),
     Character_Set'Val (022), Character_Set'Val (023),
     Character_Set'Val (024), Character_Set'Val (025),
     Character_Set'Val (026), Character_Set'Val (027),
     Character_Set'Val (028), Character_Set'Val (029),
     Character_Set'Val (030), Character_Set'Val (031),
     Character_Set'Val (032), Character_Set'Val (033),
     Character_Set'Val (034), Character_Set'Val (035),
     Character_Set'Val (036), Character_Set'Val (037),
     Character_Set'Val (038), Character_Set'Val (039),
     Character_Set'Val (040), Character_Set'Val (041),
     Character_Set'Val (042), Character_Set'Val (043),
     Character_Set'Val (044), Character_Set'Val (045),
     Character_Set'Val (046), Character_Set'Val (047),
     Character_Set'Val (048), Character_Set'Val (049),
     Character_Set'Val (050), Character_Set'Val (051),
     Character_Set'Val (052), Character_Set'Val (053),
     Character_Set'Val (054), Character_Set'Val (055),
     Character_Set'Val (056), Character_Set'Val (057),
     Character_Set'Val (058), Character_Set'Val (059),
     Character_Set'Val (060), Character_Set'Val (061),
     Character_Set'Val (062), Character_Set'Val (063),
     Character_Set'Val (064), Character_Set'Val (065),
     Character_Set'Val (066), Character_Set'Val (067),
     Character_Set'Val (068), Character_Set'Val (069),
     Character_Set'Val (070), Character_Set'Val (071),
     Character_Set'Val (072), Character_Set'Val (073),
     Character_Set'Val (074), Character_Set'Val (075),
     Character_Set'Val (076), Character_Set'Val (077),
     Character_Set'Val (078), Character_Set'Val (079),
     Character_Set'Val (080), Character_Set'Val (081),
     Character_Set'Val (082), Character_Set'Val (083),
     Character_Set'Val (084), Character_Set'Val (085),
     Character_Set'Val (086), Character_Set'Val (087),
     Character_Set'Val (088), Character_Set'Val (089),
     Character_Set'Val (090), Character_Set'Val (091),
     Character_Set'Val (092), Character_Set'Val (093),
     Character_Set'Val (094), Character_Set'Val (095),
     Character_Set'Val (096), Character_Set'Val (097),
     Character_Set'Val (098), Character_Set'Val (099),
     Character_Set'Val (100), Character_Set'Val (101),
     Character_Set'Val (102), Character_Set'Val (103),
     Character_Set'Val (104), Character_Set'Val (105),
     Character_Set'Val (106), Character_Set'Val (107),
     Character_Set'Val (108), Character_Set'Val (109),
     Character_Set'Val (110), Character_Set'Val (111),
     Character_Set'Val (112), Character_Set'Val (113),
     Character_Set'Val (114), Character_Set'Val (115),
     Character_Set'Val (116), Character_Set'Val (117),
     Character_Set'Val (118), Character_Set'Val (119),
     Character_Set'Val (120), Character_Set'Val (121),
     Character_Set'Val (122), Character_Set'Val (123),
     Character_Set'Val (124), Character_Set'Val (125),
     Character_Set'Val (126), Character_Set'Val (127),
     Character_Set'Val (128), Character_Set'Val (129),
     Character_Set'Val (130), Character_Set'Val (131),
     Character_Set'Val (132), Character_Set'Val (133),
     Character_Set'Val (134), Character_Set'Val (135),
     Character_Set'Val (136), Character_Set'Val (137),
     Character_Set'Val (138), Character_Set'Val (139),
     Character_Set'Val (140), Character_Set'Val (141),
     Character_Set'Val (142), Character_Set'Val (143),
     Character_Set'Val (144), Character_Set'Val (145),
     Character_Set'Val (146), Character_Set'Val (147),
     Character_Set'Val (148), Character_Set'Val (149),
     Character_Set'Val (150), Character_Set'Val (151),
     Character_Set'Val (152), Character_Set'Val (153),
     Character_Set'Val (154), Character_Set'Val (155),
     Character_Set'Val (156), Character_Set'Val (157),
     Character_Set'Val (158), Character_Set'Val (159),
     Character_Set'Val (160), Character_Set'Val (161),
     Character_Set'Val (162), Character_Set'Val (163),
     Character_Set'Val (164), Character_Set'Val (165),
     Character_Set'Val (166), Character_Set'Val (167),
     Character_Set'Val (168), Character_Set'Val (169),
     Character_Set'Val (170), Character_Set'Val (171),
     Character_Set'Val (172), Character_Set'Val (173),
     Character_Set'Val (174), Character_Set'Val (175),
     Character_Set'Val (176), Character_Set'Val (177),
     Character_Set'Val (178), Character_Set'Val (179),
     Character_Set'Val (180), Character_Set'Val (181),
     Character_Set'Val (182), Character_Set'Val (183),
     Character_Set'Val (184), Character_Set'Val (185),
     Character_Set'Val (186), Character_Set'Val (187),
     Character_Set'Val (188), Character_Set'Val (189),
     Character_Set'Val (190), Character_Set'Val (191),
     Character_Set'Val (192), Character_Set'Val (193),
     Character_Set'Val (194), Character_Set'Val (195),
     Character_Set'Val (196), Character_Set'Val (197),
     Character_Set'Val (198), Character_Set'Val (199),
     Character_Set'Val (200), Character_Set'Val (201),
     Character_Set'Val (202), Character_Set'Val (203),
     Character_Set'Val (204), Character_Set'Val (205),
     Character_Set'Val (206), Character_Set'Val (207),
     Character_Set'Val (208), Character_Set'Val (209),
     Character_Set'Val (210), Character_Set'Val (211),
     Character_Set'Val (212), Character_Set'Val (213),
     Character_Set'Val (214), Character_Set'Val (215),
     Character_Set'Val (216), Character_Set'Val (217),
     Character_Set'Val (218), Character_Set'Val (219),
     Character_Set'Val (220), Character_Set'Val (221),
     Character_Set'Val (222), Character_Set'Val (223),
     Character_Set'Val (224), Character_Set'Val (225),
     Character_Set'Val (226), Character_Set'Val (227),
     Character_Set'Val (228), Character_Set'Val (229),
     Character_Set'Val (230), Character_Set'Val (231),
     Character_Set'Val (232), Character_Set'Val (233),
     Character_Set'Val (234), Character_Set'Val (235),
     Character_Set'Val (236), Character_Set'Val (237),
     Character_Set'Val (238), Character_Set'Val (239),
     Character_Set'Val (240), Character_Set'Val (241),
     Character_Set'Val (242), Character_Set'Val (243),
     Character_Set'Val (244), Character_Set'Val (245),
     Character_Set'Val (246), Character_Set'Val (247),
     Character_Set'Val (248), Character_Set'Val (249),
     Character_Set'Val (250), Character_Set'Val (251),
     Character_Set'Val (252), Character_Set'Val (253),
     Character_Set'Val (254), Character_Set'Val (255));

   Fortran_To_Ada : constant array (Character_Set) of Standard.Character := (
     Standard.Character'Val (000), Standard.Character'Val (001),
     Standard.Character'Val (002), Standard.Character'Val (003),
     Standard.Character'Val (004), Standard.Character'Val (005),
     Standard.Character'Val (006), Standard.Character'Val (007),
     Standard.Character'Val (008), Standard.Character'Val (009),
     Standard.Character'Val (010), Standard.Character'Val (011),
     Standard.Character'Val (012), Standard.Character'Val (013),
     Standard.Character'Val (014), Standard.Character'Val (015),
     Standard.Character'Val (016), Standard.Character'Val (017),
     Standard.Character'Val (018), Standard.Character'Val (019),
     Standard.Character'Val (020), Standard.Character'Val (021),
     Standard.Character'Val (022), Standard.Character'Val (023),
     Standard.Character'Val (024), Standard.Character'Val (025),
     Standard.Character'Val (026), Standard.Character'Val (027),
     Standard.Character'Val (028), Standard.Character'Val (029),
     Standard.Character'Val (030), Standard.Character'Val (031),
     Standard.Character'Val (032), Standard.Character'Val (033),
     Standard.Character'Val (034), Standard.Character'Val (035),
     Standard.Character'Val (036), Standard.Character'Val (037),
     Standard.Character'Val (038), Standard.Character'Val (039),
     Standard.Character'Val (040), Standard.Character'Val (041),
     Standard.Character'Val (042), Standard.Character'Val (043),
     Standard.Character'Val (044), Standard.Character'Val (045),
     Standard.Character'Val (046), Standard.Character'Val (047),
     Standard.Character'Val (048), Standard.Character'Val (049),
     Standard.Character'Val (050), Standard.Character'Val (051),
     Standard.Character'Val (052), Standard.Character'Val (053),
     Standard.Character'Val (054), Standard.Character'Val (055),
     Standard.Character'Val (056), Standard.Character'Val (057),
     Standard.Character'Val (058), Standard.Character'Val (059),
     Standard.Character'Val (060), Standard.Character'Val (061),
     Standard.Character'Val (062), Standard.Character'Val (063),
     Standard.Character'Val (064), Standard.Character'Val (065),
     Standard.Character'Val (066), Standard.Character'Val (067),
     Standard.Character'Val (068), Standard.Character'Val (069),
     Standard.Character'Val (070), Standard.Character'Val (071),
     Standard.Character'Val (072), Standard.Character'Val (073),
     Standard.Character'Val (074), Standard.Character'Val (075),
     Standard.Character'Val (076), Standard.Character'Val (077),
     Standard.Character'Val (078), Standard.Character'Val (079),
     Standard.Character'Val (080), Standard.Character'Val (081),
     Standard.Character'Val (082), Standard.Character'Val (083),
     Standard.Character'Val (084), Standard.Character'Val (085),
     Standard.Character'Val (086), Standard.Character'Val (087),
     Standard.Character'Val (088), Standard.Character'Val (089),
     Standard.Character'Val (090), Standard.Character'Val (091),
     Standard.Character'Val (092), Standard.Character'Val (093),
     Standard.Character'Val (094), Standard.Character'Val (095),
     Standard.Character'Val (096), Standard.Character'Val (097),
     Standard.Character'Val (098), Standard.Character'Val (099),
     Standard.Character'Val (100), Standard.Character'Val (101),
     Standard.Character'Val (102), Standard.Character'Val (103),
     Standard.Character'Val (104), Standard.Character'Val (105),
     Standard.Character'Val (106), Standard.Character'Val (107),
     Standard.Character'Val (108), Standard.Character'Val (109),
     Standard.Character'Val (110), Standard.Character'Val (111),
     Standard.Character'Val (112), Standard.Character'Val (113),
     Standard.Character'Val (114), Standard.Character'Val (115),
     Standard.Character'Val (116), Standard.Character'Val (117),
     Standard.Character'Val (118), Standard.Character'Val (119),
     Standard.Character'Val (120), Standard.Character'Val (121),
     Standard.Character'Val (122), Standard.Character'Val (123),
     Standard.Character'Val (124), Standard.Character'Val (125),
     Standard.Character'Val (126), Standard.Character'Val (127),
     Standard.Character'Val (128), Standard.Character'Val (129),
     Standard.Character'Val (130), Standard.Character'Val (131),
     Standard.Character'Val (132), Standard.Character'Val (133),
     Standard.Character'Val (134), Standard.Character'Val (135),
     Standard.Character'Val (136), Standard.Character'Val (137),
     Standard.Character'Val (138), Standard.Character'Val (139),
     Standard.Character'Val (140), Standard.Character'Val (141),
     Standard.Character'Val (142), Standard.Character'Val (143),
     Standard.Character'Val (144), Standard.Character'Val (145),
     Standard.Character'Val (146), Standard.Character'Val (147),
     Standard.Character'Val (148), Standard.Character'Val (149),
     Standard.Character'Val (150), Standard.Character'Val (151),
     Standard.Character'Val (152), Standard.Character'Val (153),
     Standard.Character'Val (154), Standard.Character'Val (155),
     Standard.Character'Val (156), Standard.Character'Val (157),
     Standard.Character'Val (158), Standard.Character'Val (159),
     Standard.Character'Val (160), Standard.Character'Val (161),
     Standard.Character'Val (162), Standard.Character'Val (163),
     Standard.Character'Val (164), Standard.Character'Val (165),
     Standard.Character'Val (166), Standard.Character'Val (167),
     Standard.Character'Val (168), Standard.Character'Val (169),
     Standard.Character'Val (170), Standard.Character'Val (171),
     Standard.Character'Val (172), Standard.Character'Val (173),
     Standard.Character'Val (174), Standard.Character'Val (175),
     Standard.Character'Val (176), Standard.Character'Val (177),
     Standard.Character'Val (178), Standard.Character'Val (179),
     Standard.Character'Val (180), Standard.Character'Val (181),
     Standard.Character'Val (182), Standard.Character'Val (183),
     Standard.Character'Val (184), Standard.Character'Val (185),
     Standard.Character'Val (186), Standard.Character'Val (187),
     Standard.Character'Val (188), Standard.Character'Val (189),
     Standard.Character'Val (190), Standard.Character'Val (191),
     Standard.Character'Val (192), Standard.Character'Val (193),
     Standard.Character'Val (194), Standard.Character'Val (195),
     Standard.Character'Val (196), Standard.Character'Val (197),
     Standard.Character'Val (198), Standard.Character'Val (199),
     Standard.Character'Val (200), Standard.Character'Val (201),
     Standard.Character'Val (202), Standard.Character'Val (203),
     Standard.Character'Val (204), Standard.Character'Val (205),
     Standard.Character'Val (206), Standard.Character'Val (207),
     Standard.Character'Val (208), Standard.Character'Val (209),
     Standard.Character'Val (210), Standard.Character'Val (211),
     Standard.Character'Val (212), Standard.Character'Val (213),
     Standard.Character'Val (214), Standard.Character'Val (215),
     Standard.Character'Val (216), Standard.Character'Val (217),
     Standard.Character'Val (218), Standard.Character'Val (219),
     Standard.Character'Val (220), Standard.Character'Val (221),
     Standard.Character'Val (222), Standard.Character'Val (223),
     Standard.Character'Val (224), Standard.Character'Val (225),
     Standard.Character'Val (226), Standard.Character'Val (227),
     Standard.Character'Val (228), Standard.Character'Val (229),
     Standard.Character'Val (230), Standard.Character'Val (231),
     Standard.Character'Val (232), Standard.Character'Val (233),
     Standard.Character'Val (234), Standard.Character'Val (235),
     Standard.Character'Val (236), Standard.Character'Val (237),
     Standard.Character'Val (238), Standard.Character'Val (239),
     Standard.Character'Val (240), Standard.Character'Val (241),
     Standard.Character'Val (242), Standard.Character'Val (243),
     Standard.Character'Val (244), Standard.Character'Val (245),
     Standard.Character'Val (246), Standard.Character'Val (247),
     Standard.Character'Val (248), Standard.Character'Val (249),
     Standard.Character'Val (250), Standard.Character'Val (251),
     Standard.Character'Val (252), Standard.Character'Val (253),
     Standard.Character'Val (254), Standard.Character'Val (255));

   function To_Fortran (Item : in String) return Fortran_Character;

   function To_Ada (Item : in Fortran_Character) return String;

   procedure To_Fortran (Item   : in String;
                         Target : out Fortran_Character;
                         Last   : out Natural);

   procedure To_Ada (Item   : in Fortran_Character;
                     Target : out String;
                     Last   : out Natural);

end Interfaces.Fortran;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 23:53:39 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:35:52 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Mon Jun  6 12:04:06 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
