------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          A D A . S T R I N G S                           --
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

package Ada.Strings is
pragma Pure (Strings);

   Space      : constant Character      := ' ';
   Wide_Space : constant Wide_Character := ' ';

   Length_Error, Pattern_Error, Index_Error, Translation_Error : exception;

   type Alignment  is (Left, Right, Center);
   type Truncation is (Left, Right, Error);
   type Membership is (Inside, Outside);
   type Direction  is (Forward, Backward);

   type Trim_End   is (Left, Right, Both);

end Ada.Strings;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:56:24 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Mon Jun  6 12:03:31 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  revision 1.4
--  date: Mon Jul 11 17:19:03 1994;  author: banner
--  Changes according to RM9X 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
