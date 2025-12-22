------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . I M G _ B I U                        --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.3 $                              --
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

package body System.Img_BIU is

   -----------------------------
   -- Set_Image_Based_Integer --
   -----------------------------

   procedure Set_Image_Based_Integer
     (V : Integer;
      B : Natural;
      W : Integer;
      S : out String;
      P : in out Natural)
   is
      Start : Natural;

   begin
      --  Positive case can just use the unsigned circuit directly

      if V >= 0 then
         Set_Image_Based_Unsigned (Unsigned (V), B, W, S, P);

      --  Negative case has to set a minus sign. Note also that we have to be
      --  careful not to generate overflow with the largest negative number.

      else
         P := P + 1;
         S (P) := ' ';
         Start := P;

         begin
            pragma Suppress (Overflow_Check);
            pragma Suppress (Range_Check);
            Set_Image_Based_Unsigned (Unsigned (-V), B, W - 1, S, P);
         end;

         --  Set minus sign in last leading blank location. Because of the
         --  code above, there must be at least one such location.

         while S (Start + 1) = ' ' loop
            Start := Start + 1;
         end loop;

         S (Start) := '-';
      end if;

   end Set_Image_Based_Integer;

   ------------------------------
   -- Set_Image_Based_Unsigned --
   ------------------------------

   procedure Set_Image_Based_Unsigned
     (V : Unsigned;
      B : Natural;
      W : Integer;
      S : out String;
      P : in out Natural)
   is
      Start : constant Natural := P;
      F, T  : Natural;
      BU    : constant Unsigned := Unsigned (B);
      Hex   : constant array
                (Unsigned range 0 .. 15) of Character := "0123456789ABCDEF";

      procedure Set_Digits (T : Unsigned);
      --  Set digits of absolute value of T

      procedure Set_Digits (T : Unsigned) is
      begin
         if T >= BU then
            Set_Digits (T / BU);
            P := P + 1;
            S (P) := Hex (T mod BU);
         else
            P := P + 1;
            S (P) := Hex (T);
         end if;
      end Set_Digits;

   --  Start of processing for Set_Image_Based_Unsigned

   begin

      if B >= 10 then
         P := P + 1;
         S (P) := '1';
      end if;

      P := P + 1;
      S (P) := Character'Val (Character'Pos ('0') + B mod 10);

      P := P + 1;
      S (P) := '#';

      Set_Digits (V);

      P := P + 1;
      S (P) := '#';

      --  Add leading spaces if required by width parameter

      if P - Start < W then
         F := P;
         P := Start + W;
         T := P;

         while F > Start loop
            S (T) := S (F);
            T := T - 1;
            F := F - 1;
         end loop;

         for J in Start + 1 .. T loop
            S (J) := ' ';
         end loop;
      end if;

   end Set_Image_Based_Unsigned;

end System.Img_BIU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Aug 18 07:57:55 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Thu Aug 18 16:27:41 1994;  author: dewar
--  Minor comment fix
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 24 21:59:18 1994;  author: dewar
--  Fix bugs in placement of # characters
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
