------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . E X P _ L L U                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
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

--  This procedure performs exponentiation of unsigned types (with binary
--  modulus values exceeding that of Unsigned_Types.Unsigned).

with System.Unsigned_Types;

package System.Exp_LLU is
pragma Pure (Exp_LLU);

   function Exp_Long_Long_Unsigned
     (Left  : System.Unsigned_Types.Long_Long_Unsigned;
      Right : Natural)
      return  System.Unsigned_Types.Long_Long_Unsigned;

end System.Exp_LLU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Wed Jun  1 23:26:46 1994;  author: dewar
--  Remove use clauses (this unit is with'ed from Rtsfind)
--  ----------------------------
--  revision 1.3
--  date: Tue Aug  2 19:27:54 1994;  author: dewar
--  Add pragma Pure
--  Make into package as required by Rtsfind
--  ----------------------------
--  revision 1.4
--  date: Mon Aug  8 02:28:56 1994;  author: dewar
--  Change function name to Exp_Long_Long_Unsigned
--  Change package name to Exp_Uns
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
