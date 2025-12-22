------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . E X N _ L I N T                       --
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

--  Long_Integer exponentiation (checks off)

with System.Exn_Gen;

package System.Exn_LInt is
pragma Pure (Exn_LInt);

   function Exn_Long_Integer is
     new System.Exn_Gen.Exn_Integer_Type (Long_Integer);

end System.Exn_LInt;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Sun Jun  5 17:58:58 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Tue Aug  2 19:26:52 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.3
--  date: Mon Aug  8 02:27:15 1994;  author: dewar
--  Change name of package to Exn_LInt
--  Change name of function to Exn_Long_Integer
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
