------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ L L U                        --
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

--  This package contains the routines for supporting the Image attribute for
--  unsigned (modular) integer types larger than Size Unsigned'Size, and also
--  for conversion operations required in Text_IO.Modular_IO for such types.

with System.Unsigned_Types;

package System.Img_LLU is
pragma Preelaborate (Img_LLU);

   function Image_Long_Long_Unsigned
     (V    : System.Unsigned_Types.Long_Long_Unsigned;
      S    : access String)
      return Natural;
   --  Computes Long_Long_Unsigned'Image (V), storing the result in S (1 .. N)
   --  where N is the length of the image string. The value of N is returned as
   --  the result. The caller guarantees that the string is long enough.

   procedure Set_Image_Long_Long_Unsigned
     (V : System.Unsigned_Types.Long_Long_Unsigned;
      S : out String;
      P : in out Natural);
   --  Sets the image of V starting at S (P + 1) with no leading spaces (i.e.
   --  Text_IO format where Width = 0), starting at S (P + 1), updating P
   --  to point to the last character stored. The caller promises that the
   --  buffer is large enough and no check is made for this (Constraint_Error
   --  will not be necessarily raised if this is violated since it is perfectly
   --  valid to compile this unit with checks off).

end System.Img_LLU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Mon Jul 25 02:10:29 1994;  author: dewar
--  Another complete rewrite, introduce Set_Image_Long_Long_Unsigned
--   and Image_Long_Long_Unsigned
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 10 14:26:15 1994;  author: dewar
--  New more efficient calling sequence for Image_Long_Long_Unsigned
--  Change pragma Pure to pragma Preelaborate
--  Remove improper use clause (not permitted by Rtsfind)
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 17 22:42:56 1994;  author: dewar
--  (Set_Image_Long_Long_Unsigned): Do not store leading space for pos case
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
