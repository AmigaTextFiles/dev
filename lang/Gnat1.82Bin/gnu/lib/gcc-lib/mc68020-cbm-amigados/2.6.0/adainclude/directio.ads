------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                            D I R E C T _ I O                             --
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

pragma Ada_9X;
with Ada.Direct_IO;
generic package Direct_IO renames Ada.Direct_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 11:02:02 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Tue Feb  8 08:37:24 1994;  author: dewar
--  Add pragma Ada_9X, required because of the with of a child unit
--  ----------------------------
--  revision 1.4
--  date: Thu May 12 12:43:16 1994;  author: schonber
--  Direct_IO must be a generic package renaming.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
