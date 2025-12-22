------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                        S Y S T E M . F I M _ S I                         --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.4 $                              --
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

--  Instantiation of the Fim package for Short_Integer.

with System.Fim;

package System.Fim_SI is
pragma Pure (Fim_SI);

   package F_Util is new System.Fim.Fim_Util (Short_Integer);
   use F_Util;

   function Fim1_SI
     (A, B, X, Y : Short_Integer;
      M          : Natural)
      return       Short_Integer
   renames Case1;

   function Fim2_SI
     (A, B, X, Y : Short_Integer;
      M          : Natural)
      return       Short_Integer
   renames Case2;

   function Fim3_SI
     (A, B, X, Y : Short_Integer;
      M          : Natural)
      return       Short_Integer
   renames Case3;

   function Fim4_SI
     (A, B, X, Y : Short_Integer;
      M          : Natural)
      return       Short_Integer
   renames Case4;

end System.Fim_SI;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Fri Jul  8 22:16:27 1994;  author: dewar
--  Minor reformatting
--  Add pragma Pure
--  ----------------------------
--  revision 1.3
--  date: Fri Jul 15 13:31:07 1994;  author: crozes
--  Remove the body of this package, and change this spec to be an
--  instantiation of a generic package.
--  ----------------------------
--  revision 1.4
--  date: Tue Aug  2 12:23:44 1994;  author: dewar
--  Remove use clause (not allowed in Rtsfind accessed spec)
--  Add pragma Pure
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
