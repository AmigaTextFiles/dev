------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . E X P _ L I N T                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.7 $                              --
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

--  Long_Integer exponentiation (checks on)

with System.Exp_Gen;

package System.Exp_LInt is
pragma Pure (Exp_LInt);

   function Exp_Long_Integer is
     new System.Exp_Gen.Exp_Integer_Type (Long_Integer);

end System.Exp_LInt;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 23:27:12 1994;  author: dewar
--  Remove use clause (this unit is with'ed by Rtsfind)
--  ----------------------------
--  revision 1.6
--  date: Tue Aug  2 19:28:22 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.7
--  date: Mon Aug  8 02:28:29 1994;  author: dewar
--  Change name of package to Exp_LInt
--  Change name of function to Exp_Long_Integer
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
