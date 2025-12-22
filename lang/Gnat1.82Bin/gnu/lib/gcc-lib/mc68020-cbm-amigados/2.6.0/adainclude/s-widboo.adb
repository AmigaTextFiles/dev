------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . W I D _ B O O L                       --
--                                                                          --
--                                 B o d y                                  --
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

package body System.Wid_Bool is

   -------------------
   -- Width_Boolean --
   -------------------

   function Width_Boolean (Lo, Hi : Boolean) return Natural is
   begin
      if Lo > Hi then
         return 0;

      elsif Lo = False then
         return 5;

      else
         return 4;
      end if;
   end Width_Boolean;

end System.Wid_Bool;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:32 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 19:32:16 1994;  author: dewar
--  New name of function is Width_Boolean
--  New name of package is Wid_Bool
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
