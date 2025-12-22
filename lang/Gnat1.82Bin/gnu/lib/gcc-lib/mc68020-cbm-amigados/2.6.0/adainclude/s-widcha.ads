------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . W I D _ C H A R                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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

--  This package contains the routine used for Character'Width

package System.Wid_Char is
pragma Pure (Wid_Char);

   function Width_Character (Lo, Hi : Character) return Natural;
   --  Compute Width attribute for non-static type derived from Character.
   --  The arguments are the low and high bounds for the type.

end System.Wid_Char;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:39 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:32:36 1994;  author: dewar
--  New name of function is Width_Character
--  New name of package is Wid_Char
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
