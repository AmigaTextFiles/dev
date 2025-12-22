------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . E X P _ M O D                        --
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

--  This procedure performs exponentiation of a modular type with non-binary
--  modulus values. Arithmetic is done in Long_Long_Unsigned, with explicit
--  accounting for the modulus value which is passed as the second argument.

package System.Exp_Mod is
pragma Pure (Exp_Mod);

   function Exp_Modular
     (Left    : Integer;
      Modulus : Integer;
      Right   : Natural)
      return    Integer;

end System.Exp_Mod;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr  7 07:45:17 1994;  author: dewar
--  Remove unused with of System.Unsigned_Types
--  ----------------------------
--  revision 1.3
--  date: Tue Aug  2 19:28:50 1994;  author: dewar
--  Add pragma Pure
--  Make into package as required by Rtsfind
--  ----------------------------
--  revision 1.4
--  date: Mon Aug  8 02:29:09 1994;  author: dewar
--  Change name of package to Exp_Mod
--  Change name of function to Exp_Modular
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
