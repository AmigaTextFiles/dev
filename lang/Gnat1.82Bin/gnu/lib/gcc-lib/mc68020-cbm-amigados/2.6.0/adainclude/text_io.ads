------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                              T E X T _ I O                               --
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
with Ada.Text_IO;
package Text_IO renames Ada.Text_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Oct 14 15:19:06 1993;  author: banner
--  Add pragma Ada_9X in case user is compiling text_io while in Ada83 mode.
--  ----------------------------
--  revision 1.3
--  date: Sun Jan  9 11:20:23 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.4
--  date: Tue Feb  8 08:38:30 1994;  author: dewar
--  Put back pragma Ada_9X. It is needed, since this is not a child of
--   System or Ada, so we don't automatically get 9X mode.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
