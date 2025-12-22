------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--              A D A . U N C H E C K E D _ C O N V E R S I O N             --
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

generic
   type Source (<>) is limited private;
   type Target (<>) is limited private;

function Ada.Unchecked_Conversion (Source_Object : Source) return Target;

pragma Pure (Unchecked_Conversion);
pragma Import (Intrinsic, Unchecked_Conversion);


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Mon Jun 13 22:52:25 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.4
--  date: Mon Jun 27 14:43:40 1994;  author: dewar
--  Fix idiotic typo in pragma Convention
--  Names in trailing pragmas must be simple unit names
--  ----------------------------
--  revision 1.5
--  date: Thu Jul  7 23:10:28 1994;  author: schonber
--  Replace pragma Convention with pragma Import.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
