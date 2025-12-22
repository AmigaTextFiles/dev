------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W I D _ L L I                        --
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
--  non-static signed integer subtypes. Note we only have one routine,
--  since this seems a fairly marginal function.

package System.Wid_LLI is
pragma Pure (Wid_LLI);

   function Width_Long_Long_Integer
     (Lo, Hi : Long_Long_Integer)
      return   Natural;
   --  Compute Width attribute for non-static type derived from a signed
   --  Integer type. The arguments Lo, Hi are the bounds of the type.

end System.Wid_LLI;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:48 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:33:02 1994;  author: dewar
--  New name of function is Width_Long_Long_Integer
--  New name of package is Wid_LLI
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
