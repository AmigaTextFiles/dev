------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . E X P _ S F L T                       --
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

--  Short_Float exponentiation (checks on)

with System.Exp_Gen;

package System.Exp_SFlt is
pragma Pure (Exp_SFlt);

   function Exp_Short_Float is
     new System.Exp_Gen.Exp_Float_Type (Short_Float);

end System.Exp_SFlt;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 23:27:31 1994;  author: dewar
--  Remove use clause (this unit is with'ed by Rtsfind)
--  ----------------------------
--  revision 1.6
--  date: Tue Aug  2 19:28:56 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.7
--  date: Mon Aug  8 02:29:16 1994;  author: dewar
--  Change name of package to Exp_SFlt
--  Change name of function to Exp_Short_Float
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
