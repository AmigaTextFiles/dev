------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ U N S                        --
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

with System.Unsigned_Types; use System.Unsigned_Types;

package body System.Img_Uns is

   --------------------
   -- Image_Unsigned --
   --------------------

   function Image_Unsigned
     (V    : System.Unsigned_Types.Unsigned;
      S    : access String)
      return Natural
   is
      P : Natural;

   begin
      P := 1;
      S (P) := ' ';
      Set_Image_Unsigned (V, S.all, P);
      return P;
   end Image_Unsigned;

   ------------------------
   -- Set_Image_Unsigned --
   ------------------------

   procedure Set_Image_Unsigned
     (V : Unsigned;
      S : out String;
      P : in out Natural)
   is
      procedure Set_Digits (T : Unsigned);
      --  Set decimal digits of value of T

      procedure Set_Digits (T : Unsigned) is
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

   --  Start of processing for Set_Image_Unsigned

   begin
      Set_Digits (V);

   end Set_Image_Unsigned;

end System.Img_Uns;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.4
--  date: Sat Aug  6 19:31:50 1994;  author: dewar
--  Change name of package to Img_Uns
--  ----------------------------
--  revision 1.5
--  date: Wed Aug 10 14:26:37 1994;  author: dewar
--  New calling sequence for Image_Unsigned
--  ----------------------------
--  revision 1.6
--  date: Wed Aug 17 22:43:09 1994;  author: dewar
--  Minor reformatting and fixing of comments
--  (Image_Unsigned): Change access String to out String
--  (Set_Image_Unsigned): Do not store a leading space for positive case
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
