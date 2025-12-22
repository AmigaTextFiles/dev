------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . W I D _ E N U M                       --
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

--  This package contains the routine used for Enumeration_Type'Width

package System.Wid_Enum is
pragma Pure (Wid_Enum);

   function Width_Enumeration
     (Table  : Address;
      Lo, Hi : Natural)
      return   Natural;
   --  Compute Width attribute for non-static user defined enumeration type.
   --  The first parameter is the address of the table of enumeration literal
   --  names, and the second and third parameters are the Pos values of the
   --  low bound and high bound of the subtype.

end System.Wid_Enum;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 01:02:09 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:32:49 1994;  author: dewar
--  New name of function is Width_Enumeration
--  New name of package is Wid_Enum
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
