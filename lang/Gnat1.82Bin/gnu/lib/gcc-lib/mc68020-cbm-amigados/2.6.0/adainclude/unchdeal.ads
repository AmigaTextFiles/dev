------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               U N C H E C K E D _ D E A L L O C A T I O N                --
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
   type Object (<>) is limited private;
   type Name is access Object;

procedure Unchecked_Deallocation (X : in out Name);
pragma Import (Intrinsic, Unchecked_Deallocation);


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Wed Jun  1 21:16:17 1994;  author: comar
--  Add Pragma Convention Intrinsic.
--  ----------------------------
--  revision 1.9
--  date: Mon Jun  6 12:05:04 1994;  author: dewar
--  Remove pragma Preelaborate, this unit is neither pure nor preelaborable
--  ----------------------------
--  revision 1.10
--  date: Sat Jul  2 11:44:03 1994;  author: schonber
--  Replace pragma Convention with pragma Import.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
