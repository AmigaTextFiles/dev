------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                         A D A . N U M E R I C S                          --
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


package Ada.Numerics is
pragma Pure (Numerics);

   Argument_Error : exception;

   Pi : constant :=
          3.14159_26535_89793_23846_26433_83279_50288_41971_69399_37511;

   e : constant :=
          2.71828_18284_59045_23536_02874_71352_66249_77572_47093_69996;

end Ada.Numerics;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Mon Dec 27 12:21:46 1993;  author: figueroa
--  Improve the accuracy of the constants Pi and e to 51 digits of accuracy
--  ----------------------------
--  revision 1.3
--  date: Sun Jan  9 10:53:20 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.4
--  date: Tue Jul  5 03:54:19 1994;  author: dewar
--  Add pragma Pure, per RM 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
