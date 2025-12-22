------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . F F M _ S I                          --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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

--  Instantiation of the Ffm package for Short_Integer.

with System.Ffm;

package System.Ffm_SI is
pragma Pure (Ffm_SI);

   package F_Util is new System.Ffm.Ffm_Util (Short_Integer);
   use F_Util;

   function Ffm_SI
     (X, Y, A         : Short_Integer;
      M               : Integer;
      B1, B2, Eps_Neg : Boolean)
      return            Short_Integer
   renames Compute_Result;

end System.Ffm_SI;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul 15 13:29:50 1994;  author: crozes
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Tue Aug  2 12:22:38 1994;  author: dewar
--  Remove use clause (not allowed in Rtsfind accessed spec)
--  Add pragma Pure
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
