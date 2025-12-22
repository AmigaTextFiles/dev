------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--           A D A . U N C H E C K E D _ D E A L L O C A T I O N            --
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

generic
   type Object (<>) is limited private;
   type Name is access Object;

procedure Ada.Unchecked_Deallocation (X : in out Name);

pragma Import (Intrinsic, Unchecked_Deallocation);


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 23:53:17 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:58:02 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Thu Jul  7 23:10:35 1994;  author: schonber
--  Replace pragma Convention with pragma Import.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
