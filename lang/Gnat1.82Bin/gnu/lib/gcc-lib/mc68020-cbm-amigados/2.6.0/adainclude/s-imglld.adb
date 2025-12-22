------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ L L D                        --
--                                                                          --
--                                 B o d y                                  --
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

with System.Img_Decimal; use System.Img_Decimal;
with System.Img_LLI;     use System.Img_LLI;

package body System.Img_LLD is

   -----------------------------
   -- Image_Long_Long_Decimal --
   -----------------------------

   function Image_Long_Long_Decimal
     (V     : Long_Long_Integer;
      S     : access String;
      Scale : Integer)
      return  Natural
   is
      P : Natural := 0;

   begin
      Set_Image_Long_Long_Decimal
        (V, S.all, P, Scale, 2, Integer'Max (1, Scale), 0);
      return P;
   end Image_Long_Long_Decimal;

   ---------------------------------
   -- Set_Image_Long_Long_Decimal --
   ---------------------------------

   procedure Set_Image_Long_Long_Decimal
     (V     : Long_Long_Integer;
      S     : out String;
      P     : in out Natural;
      Scale : Integer;
      Fore  : Natural;
      Aft   : Natural;
      Exp   : Natural)
   is
      Digs : aliased String (1 .. Long_Long_Integer'Width);
      --  Sign and digits of decimal value

      D : Natural;
      --  Number of characters in Digs buffer

   begin
      D := Image_Long_Long_Integer (V, Digs'Access);
      Set_Decimal_Digits (Digs, D, S, P, Scale, Fore, Aft, Exp);
   end Set_Image_Long_Long_Decimal;

end System.Img_LLD;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Tue Aug 23 11:58:06 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
