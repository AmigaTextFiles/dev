------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ U N S                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.5 $                              --
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
--  modular integer types up to Size Modular'Size, and also for conversion
--  operations required in Text_IO.Modular_IO for such types.

with System.Unsigned_Types;

package System.Img_Uns is
pragma Preelaborate (Img_Uns);

   function Image_Unsigned
     (V    : System.Unsigned_Types.Unsigned;
      S    : access String)
      return Natural;
   --  Computes Unsigned'Image (V) and stores the result in S (1 .. N) where
   --  N is the length of the image string. The value of N is returned as
   --  the result. The caller ensures that the string is long enough.

   procedure Set_Image_Unsigned
     (V : System.Unsigned_Types.Unsigned;
      S : out String;
      P : in out Natural);
   --  Sets the image of V starting at S (P + 1) with no leading spaces (i.e.
   --  Text_IO format where Width = 0), starting at S (P + 1), updating P
   --  to point to the last character stored. The caller promises that the
   --  buffer is large enough and no check is made for this (Constraint_Error
   --  will not be necessarily raised if this is violated since it is perfectly
   --  valid to compile this unit with checks off).

end System.Img_Uns;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Sat Aug  6 19:31:57 1994;  author: dewar
--  Change name of package to Img_Uns
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 10 14:26:43 1994;  author: dewar
--  New more efficient calling sequence for Image_Unsigned
--  Change pragma Pure to pragma Preelaborate
--  Remove improper use clause (rtsfind requirement)
--  ----------------------------
--  revision 1.5
--  date: Wed Aug 17 22:43:16 1994;  author: dewar
--  (Set_Image_Unsigned): Do not store a leading space for positive case
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
