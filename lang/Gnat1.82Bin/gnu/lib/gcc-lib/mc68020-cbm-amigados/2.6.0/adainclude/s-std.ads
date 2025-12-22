-----------------------------------------------------------------------------
--                                                                         --
--                GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                         --
--                           S Y S T E M . S T D                           --
--                                                                         --
--                                 S p e c                                 --
--                                                                         --
--                            $Revision: 1.2 $                              --
--                                                                         --
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

--  This package contains some standard routines for operating on the
--  temporary (non-fixed-point) version of Duration used to support the
--  tasking routines. To be removed when fixed point is done ???

private package System.Std is

   function "*" (D : Duration; I : Integer)  return Duration;
   function "*" (I : Integer;  D : Duration) return Duration;
   function "/" (D : Duration; I : Integer)  return Duration;

end System.Std;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 19:25:31 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 11:17:41 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
