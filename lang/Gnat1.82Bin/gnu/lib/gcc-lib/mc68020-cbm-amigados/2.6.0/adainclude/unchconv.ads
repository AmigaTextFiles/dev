------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                  U N C H E C K E D _ C O N V E R S I O N                 --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.10 $                              --
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
generic
   type Source (<>) is limited private;
   type Target (<>) is limited private;

function Unchecked_Conversion (Source_Object : Source) return Target;
pragma Import (Intrinsic, Unchecked_Conversion);
pragma Pure (Unchecked_Conversion);


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Mon Jun  6 12:04:56 1994;  author: dewar
--  Add commented out pragma Pure, to be activated later (GNAT 1.79 does not
--   handle pragma Pure for library subprograms)
--  ----------------------------
--  revision 1.9
--  date: Mon Jun 13 00:03:45 1994;  author: sheng
--  Enable Pragma Pure since it is handled now.
--  ----------------------------
--  revision 1.10
--  date: Sat Jul  2 11:43:56 1994;  author: schonber
--  Change pragma Convention to Import.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
