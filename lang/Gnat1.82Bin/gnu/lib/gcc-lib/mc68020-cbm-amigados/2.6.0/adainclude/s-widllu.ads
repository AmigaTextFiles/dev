------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W I D _ L L U                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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

--  This package contains the routine used for WIdth attribute for all
--  non-static unsigned integer (modular integer) subtypes. Note we only
--  have one routine, since this seems a fairly marginal function.

with System.Unsigned_Types;

package System.Wid_LLU is
pragma Pure (Wid_LLU);

   function Width_Long_Long_Unsigned
     (Lo, Hi : System.Unsigned_Types.Long_Long_Unsigned)
      return   Natural;
   --  Compute Width attribute for non-static type derived from a modular
   --  integer type. The arguments Lo, Hi are the bounds of the type.

end System.Wid_LLU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:44 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:33:15 1994;  author: dewar
--  New name of function is Width_Long_Long_Unsigned
--  New name of package is Wid_LLU
--  Remove use clause, not allowed by Rtsfind
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
