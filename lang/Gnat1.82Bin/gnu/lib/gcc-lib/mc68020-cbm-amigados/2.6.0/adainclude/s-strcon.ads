------------------------------------------------------------------------------
--                                                                          --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS                --
--                                                                          --
--                    S Y S T E M . S T R _ C O N C A T                     --
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

--  Runtime function used to concatenate two strings (i.e. Standard."&")

function System.Str_Concat (X, Y : String) return String;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Feb  4 20:02:12 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Jun  4 02:35:20 1994;  author: dewar
--  Add a pragma Pure
--  ----------------------------
--  revision 1.3
--  date: Sat Jun  4 11:27:49 1994;  author: dewar
--  Remove pragma Pure so we can compile with earlier incorrect versions of
--   GNAT (note in any case that this file is obsoleted by s-strops, it is
--   present only to ease the bootstrap path).
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
