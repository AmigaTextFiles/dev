------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ B O O L                       --
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

package System.Val_Bool is
pragma Pure (Val_Bool);

   function Value_Boolean (Str : String) return Boolean;
   --  Computes Boolean'Value (Str).

end System.Val_Bool;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Wed May 25 18:27:20 1994;  author: banner
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat May 28 09:05:51 1994;  author: figueroa
--  Remove trailing spaces in header
--  ----------------------------
--  revision 1.3
--  date: Sat Aug  6 17:01:07 1994;  author: dewar
--  Make into package for Rtsfind
--  Add pragma Pure
--  Change name from Value_B to Val_Bool
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
