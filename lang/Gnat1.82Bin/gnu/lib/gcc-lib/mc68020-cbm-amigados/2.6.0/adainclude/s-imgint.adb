------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ I N T                        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.10 $                             --
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

package body System.Img_Int is

   -------------------
   -- Image_Integer --
   -------------------

   function Image_Integer
     (V    : Integer;
      S    : access String)
      return Natural
   is
      P : Natural;

   begin
      if V >= 0 then
         P := 1;
         S (P) := ' ';
      else
         P := 0;
      end if;

      Set_Image_Integer (V, S.all, P);
      return P;
   end Image_Integer;

   -----------------------
   -- Set_Image_Integer --
   -----------------------

   procedure Set_Image_Integer
     (V  : Integer;
      S  : out String;
      P  : in out Natural)
   is
      procedure Set_Digits (T : Integer);
      --  Set digits of absolute value of T, which is zero or negative. We work
      --  with the negative of the value so that the largest negative number is
      --  not a special case.

      procedure Set_Digits (T : Integer) is
      begin
         if T <= -10 then
            Set_Digits (T / 10);
            P := P + 1;
            S (P) := Character'Val (48 - (T rem 10));

         else
            P := P + 1;
            S (P) := Character'Val (48 - T);
         end if;
      end Set_Digits;

   --  Start of processing for Set_Image_Integer

   begin
      if V >= 0 then
         Set_Digits (-V);

      else
         P := P + 1;
         S (P) := '-';
         Set_Digits (V);
      end if;
   end Set_Image_Integer;

end System.Img_Int;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Sat Aug  6 19:31:30 1994;  author: dewar
--  Change name of package Img_Int
--  ----------------------------
--  revision 1.9
--  date: Wed Aug 10 14:25:35 1994;  author: dewar
--  New calling sequence for Image_Integer
--  ----------------------------
--  revision 1.10
--  date: Wed Aug 17 22:42:23 1994;  author: dewar
--  (Set_Image_Integer): Do not store a leading space for positive case
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
