------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ I N T                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.7 $                              --
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

--  This package contains the routines for supporting the Image attribute for
--  signed integer types up to Size Integer'Size, and also for conversion
--  operations required in Text_IO.Integer_IO for such types.

package System.Img_Int is
pragma Pure (Img_Int);

   function Image_Integer
     (V    : Integer;
      S    : access String)
      return Natural;
   --  Computes Integer'Image (V) and stores the result in S (1 .. N) where
   --  N is the length of the image string. The value of N is returned as
   --  the result. The caller guarantees that the string is long enough.

   procedure Set_Image_Integer
     (V : Integer;
      S : out String;
      P : in out Natural);
   --  Sets the image of V starting at S (P + 1) with no leading spaces (i.e.
   --  Text_IO format where Width = 0), starting at S (P + 1), updating P
   --  to point to the last character stored. The caller promises that the
   --  buffer is large enough and no check is made for this (Constraint_Error
   --  will not be necessarily raised if this is violated since it is perfectly
   --  valid to compile this unit with checks off).

end System.Img_Int;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Sat Aug  6 19:31:36 1994;  author: dewar
--  Change name of package Img_Int
--  ----------------------------
--  revision 1.6
--  date: Wed Aug 10 14:25:44 1994;  author: dewar
--  New calling sequence for Image_Integer
--  Change pragma Pure to pragma Preelaborate
--  ----------------------------
--  revision 1.7
--  date: Wed Aug 17 22:42:30 1994;  author: dewar
--  (Set_Image_Integer): Do not store a leading space for positive case
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
