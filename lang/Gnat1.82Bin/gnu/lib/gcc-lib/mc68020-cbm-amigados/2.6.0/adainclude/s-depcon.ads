------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--           S Y S T E M . D E P E N D E N T _ C O N S T A N T S            --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
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

--  This package defines some system dependent constants for GNAT.

package System.Dependent_Constants is
pragma Pure (Dependent_Constants);

   Count_Max : constant := Integer'Last;
   --  Upper bound of type Ada.Text_IO.Count

   Field_Max : constant := 100;
   --  Upper bound of type Ada.Text_IO.Field

end System.Dependent_Constants;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Jul 25 01:50:29 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
