------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . E X N _ I N T                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.3 $                              --
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

--  Integer exponentiation (checks off)

with System.Exn_Gen;

package System.Exn_Int is
pragma Pure (Exn_Int);

   function Exn_Integer is
     new System.Exn_Gen.Exn_Integer_Type (Integer);

end System.Exn_Int;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Sun Jun  5 17:58:54 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Tue Aug  2 19:26:39 1994;  author: dewar
--  Add pragma Pure
--  ----------------------------
--  revision 1.3
--  date: Mon Aug  8 02:27:02 1994;  author: dewar
--  Change name of package to Exn_Int
--  Change name of function to Exn_Integer
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
