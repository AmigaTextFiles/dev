------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ L L U                        --
--                                                                          --
--                                 B o d y                                  --
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

with System.Unsigned_Types; use System.Unsigned_Types;

package body System.Img_LLU is

   ------------------------------
   -- Image_Long_Long_Unsigned --
   ------------------------------

   function Image_Long_Long_Unsigned
     (V    : Long_Long_Unsigned;
      S    : access String)
      return Natural
   is
      P : Natural;

   begin
      P := 1;
      S (P) := ' ';
      Set_Image_Long_Long_Unsigned (V, S.all, P);
      return P;
   end Image_Long_Long_Unsigned;

   -----------------------
   -- Set_Image_Long_Long_Unsigned --
   -----------------------

   procedure Set_Image_Long_Long_Unsigned
     (V : Long_Long_Unsigned;
      S : out String;
      P : in out Natural)
   is
      procedure Set_Digits (T : Long_Long_Unsigned);
      --  Set digits of absolute value of T

      procedure Set_Digits (T : Long_Long_Unsigned) is
      begin
         if T >= 10 then
            Set_Digits (T / 10);
            P := P + 1;
            S (P) := Character'Val (48 + (T rem 10));

         else
            P := P + 1;
            S (P) := Character'Val (48 + T);
         end if;
      end Set_Digits;

   --  Start of processing for Set_Image_Long_Long_Unsigned

   begin
      Set_Digits (V);

   end Set_Image_Long_Long_Unsigned;

end System.Img_LLU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Mon Jul 25 02:10:22 1994;  author: dewar
--  Another complete rewrite, introduce Set_Image_Long_Long_Unsigned
--   and Image_Long_Long_Unsigned
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 10 14:26:07 1994;  author: dewar
--  New calling sequence for Image_Long_Long_Unsigned
--  Fix bad name in header
--  ----------------------------
--  revision 1.5
--  date: Wed Aug 17 22:42:49 1994;  author: dewar
--  (Set_Image_Long_Long_Unsigned): Do not store leading space for pos case
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
