------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ W I U                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
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

--  Contains the routine for computing the image  of signed and unsigned
--  integers whose size <= Integer'Size for use by Text_Io.Integer_Io,
--  Text_Io.Modular_Io, and the Img attribute when a width is given.

with System.Unsigned_Types;

package System.Img_WIU is
pragma Preelaborate (Img_WIU);

   procedure Set_Image_Width_Integer
     (V : Integer;
      W : Integer;
      S : out String;
      P : in out Natural);
   --  Sets the signed image of V in decimal format, starting at S (P + 1),
   --  updating P to point to the last character stored. The image includes
   --  a leading minus sign if necessary, but no leading spaces unless W is
   --  positive, in which case leading spaces are output if necessary to ensure
   --  that the output string is no less than W characters long. The caller
   --  promises that the buffer is large enough and no check is made for this.
   --  Constraint_Error will not necessarily be raised if this is violated,
   --  since it is perfectly valid to compile this unit with checks off.

   procedure Set_Image_Width_Unsigned
     (V : System.Unsigned_Types.Unsigned;
      W : Integer;
      S : out String;
      P : in out Natural);
   --  Sets the unsigned image of V in decimal format, starting at S (P + 1),
   --  updating P to point to the last character stored. The image includes no
   --  leading spaces unless W is positive, in which case leading spaces are
   --  output if necessary to ensure that the output string is no less than
   --  W characters long. The caller promises that the buffer is large enough
   --  and no check is made for this. Constraint_Error will not necessarily be
   --  raised if this is violated, since it is perfectly valid to compile this
   --  unit with checks off.

end System.Img_WIU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 08:46:34 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
