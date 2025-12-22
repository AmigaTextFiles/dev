------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W C H _ S T W                        --
--                                                                          --
--                                 B o d y                                  --
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

with System.WCh_Con; use System.WCh_Con;
with System.WCh_JIS; use System.WCh_JIS;

package body System.WCh_StW is

   ---------------------------
   -- String_To_Wide_String --
   ---------------------------

   function String_To_Wide_String
     (S    : String;
      EM   : WC_Encoding_Method)
      return Wide_String
   is
      R  : Wide_String (1 .. S'Length);
      RP : Natural;
      SP : Natural;
      C1 : Natural;
      C2 : Natural;

      function Get_Hex (C : Character) return Natural;
      --  Converts character from hex digit to value in range 0-15. The
      --  input must be in 0-9, A-F (upper case), and no check is needed.

      function Get_Hex (C : Character) return Natural is
      begin
         if C in '0' .. '9' then
            return Character'Pos (C) - Character'Pos ('0');
         else
            return Character'Pos (C) - Character'Pos ('A') + 10;
         end if;
      end Get_Hex;

   --  Start of processing for Wide_Image

   begin
      SP := S'First;
      RP := 0;

      while SP <= S'Last loop
         RP := RP + 1;

         if (S (SP) = Ascii.ESC and then EM = WCEM_Hex) then
            R (RP) := Wide_Character'Val (
               Get_Hex (S (SP + 4)) + 16 *
                 (Get_Hex (S (SP + 3)) + 16 *
                   (Get_Hex (S (SP + 2)) + 16 *
                     (Get_Hex (S (SP + 1))))));
            SP := SP + 5;

         --  One-byte ASCII character

         elsif S (SP) <= Ascii.DEL or else EM = WCEM_Hex then
            R (RP) := Wide_Character'Val (Character'Pos (S (SP)));
            SP := SP + 1;

            --  Upper bit shift, internal code = external code

         elsif EM = WCEM_Upper then
            R (RP) := Wide_Character'Val (
                        Character'Pos (S (SP)) * 256 +
                        Character'Pos (S (SP + 1)));
            SP := SP + 2;

         --  Upper bit shift, EUC

         elsif EM = WCEM_EUC then
            R (RP) := EUC_To_JIS (S (SP), S (SP + 1));
            SP := SP + 2;

         --  Upper bit shift, shift-JIS

         else -- EM = WCEM_Shift_JIS
            R (RP) := Shift_JIS_To_JIS (S (SP), S (SP + 1));
            SP := SP + 2;
         end if;
      end loop;

      return R (1 .. RP);
   end String_To_Wide_String;

end System.WCh_StW;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Fri Jul 22 11:37:58 1994;  author: dewar
--  Fix some minor syntax errors
--  ----------------------------
--  revision 1.3
--  date: Mon Jul 25 19:08:41 1994;  author: dewar
--  Get codes for encoding method from System.WIde_Character_Constants
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 10 14:27:26 1994;  author: dewar
--  Change name of package to WCh_StW
--  Change name of function to String_To_Wide_String
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
