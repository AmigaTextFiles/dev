------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      S Y S T E M . I M G _ C H A R                       --
--                                                                          --
--                                 S p e c                                  --
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

--  Character'Image

package System.Img_Char is
pragma Preelaborate (Img_Char);

   function Image_Character
     (V    : Character;
      S    : access String)
      return Natural;
   --  Computes Character'Image (V) and stores the result in S (1 .. N) where
   --  N is the length of the image string. The value of N is returned as the
   --  result. The caller guarantees that the string is long enough.


end System.Img_Char;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Mon Jul 25 02:09:18 1994;  author: dewar
--  Change name of function to Image_Character
--  ----------------------------
--  revision 1.5
--  date: Sat Aug  6 19:31:23 1994;  author: dewar
--  Change name of package to Img_Char
--  ----------------------------
--  revision 1.6
--  date: Wed Aug 10 14:25:28 1994;  author: dewar
--  New more efficient calling sequence for Image_Character
--  Change pragma Pure to pragma Preelaborate
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
