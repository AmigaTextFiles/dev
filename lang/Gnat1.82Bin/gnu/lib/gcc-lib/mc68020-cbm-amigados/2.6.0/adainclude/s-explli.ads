------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . E X P _ L L I                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.7 $                              --
--                                                                          --
--             Copyright (c) 1992,1993, NYU, All Rights Reserved            --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms  of the GNU  General  Public  License  as  published  by the  Free --
-- Software  Foundation;  either version 2,  or (at your option)  any later --
-- version.  GNAT is distributed  in the hope  that it will be useful,  but --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANT- --
-- ABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public --
-- License  for  more details.  You should have received  a copy of the GNU --
-- General Public License along with GNAT;  see file COPYING. If not, write --
-- to the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. --
--                                                                          --
------------------------------------------------------------------------------

--  Long_Long_Integer exponentiation

with System.Exp_Gen;

package System.Exp_LLI is
pragma Pure (Exp_LLI);

   function Exp_Long_Long_Integer is
     new System.Exp_Gen.Exp_Integer_Type (Long_Long_Integer);

end System.Exp_LLI;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Wed Jun  1 23:27:24 1994;  author: dewar
--  Remove pragma Ada_9X, no longer needed
--  Remove use clause (this unit is with'ed by Rtsfind)
--  ----------------------------
--  revision 1.6
--  date: Tue Aug  2 19:28:36 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.7
--  date: Mon Aug  8 02:28:43 1994;  author: dewar
--  Change name of package to Exp_LLI
--  Change name of function to Exp_Long_Long_Integer
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
