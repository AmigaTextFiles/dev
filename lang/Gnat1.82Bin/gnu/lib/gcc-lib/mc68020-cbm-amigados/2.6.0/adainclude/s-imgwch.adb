-----------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     S Y S T E M . I M G _ W C H A R                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.8 $                              --
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

with System.Img_Char; use System.Img_Char;
with System.WCh_Con;  use System.WCh_Con;
with System.WCh_WtS;  use System.Wch_WtS;

package body System.Img_WChar is

   --------------------------
   -- Image_Wide_Character --
   --------------------------

   function Image_Wide_Character
     (V    : Wide_Character;
      S    : access String;
      EM   : WC_Encoding_Method)
      return Natural
   is
      Val : constant Natural := Wide_Character'Pos (V);
      WS  : Wide_String (1 .. 3);

   begin
      --  If in range of standard character, use standard character routine

      if Val < 16#80#
        or else (Val <= 16#FF# and then EM = WCEM_Hex)
      then
         return Image_Character (Character'Val (Val), S);

      --  Otherwise return an appropriate escape sequence (i.e. one matching
      --  the convention implemented by Scn.Wide_Char). The easiest thing is
      --  to build a wide string for the result, and then use the Wide_Value
      --  function to build the resulting String.

      else
         WS (1) := ''';
         WS (2) := V;
         WS (3) := ''';

         declare
            W : constant String := Wide_String_To_String (WS, EM);

         begin
            S (1 .. W'Length) := W;
            return W'Length;
         end;
      end if;

   end Image_Wide_Character;

end System.Img_WChar;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.6
--  date: Mon Jul 25 19:08:14 1994;  author: dewar
--  Get codes for encoding method from System.WIde_Character_Constants
--  ----------------------------
--  revision 1.7
--  date: Sat Aug  6 19:32:03 1994;  author: dewar
--  Change name of package to Img_WChar
--  Change name Image_C to Image_Character
--  ----------------------------
--  revision 1.8
--  date: Wed Aug 10 14:26:51 1994;  author: dewar
--  New calling sequence for Image_Wide_Character
--  Change name Wide_Character_Constant to WCh_Con
--  Change name Wide_Value to WCh_WtS
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
