------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     S Y S T E M . W I D _ W C H A R                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.3 $                              --
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

--  This package contains the routine used for Wide_Character'Width

with System.WCh_Con;

package System.Wid_WChar is
pragma Pure (Wid_WChar);

   function Width_Wide_Character
     (Lo, Hi : Wide_Character;
      EM     : System.WCh_Con.WC_Encoding_Method)
      return   Natural;
   --  Compute Width attribute for non-static type derived from Wide_Character.
   --  The arguments are the low and high bounds for the type. EM is the
   --  wide-character encoding method.

end System.Wid_WChar;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:53 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Aug  7 05:19:40 1994;  author: dewar
--  New name of function is Width_Wide_Character
--  New name of package is Wid_Wchar
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 10 14:28:00 1994;  author: dewar
--  Change name Wide_Character_Constants to WCh_Con
--  Remove use clause not allowed by Rtsfind
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
