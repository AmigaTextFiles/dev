------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . I M G _ B O O L                       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.6 $                              --
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

package body System.Img_Bool is

   -------------------
   -- Image_Boolean --
   -------------------

   function Image_Boolean
     (V    : Boolean;
      S    : access String)
      return Natural
   is
   begin
      if V then
         S (1 .. 4) := "TRUE";
         return 4;
      else
         S (1 .. 5) := "FALSE";
         return 5;
      end if;
   end Image_Boolean;

end System.Img_Bool;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Mon Jul 25 02:08:58 1994;  author: dewar
--  Change name of function to Image_Boolean
--  ----------------------------
--  revision 1.5
--  date: Sat Aug  6 19:31:04 1994;  author: dewar
--  Change name of package to Img_Bool
--  ----------------------------
--  revision 1.6
--  date: Wed Aug 10 14:25:08 1994;  author: dewar
--  New calling sequence for Image_Boolean
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
