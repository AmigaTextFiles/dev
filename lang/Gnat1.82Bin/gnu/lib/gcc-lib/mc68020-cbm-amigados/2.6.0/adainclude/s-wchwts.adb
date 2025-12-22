------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W C H _ W T S                        --
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

package body System.WCh_WtS is

   ---------------------------
   -- Wide_String_To_String --
   ---------------------------

   function Wide_String_To_String
     (S    : Wide_String;
      EM   : WC_Encoding_Method)
      return String
   is
      R  : String (1 .. 5 * S'Length); -- worst case length!
      RP : Natural;
      B1 : Natural;
      B2 : Natural;
      C1 : Character;
      C2 : Character;

   begin
      RP := 0;

      for SP in S'Range loop
         declare
            C   : constant Wide_Character := S (SP);
            CV  : constant Natural        := Wide_Character'Pos (C);
            Hex : constant array (0 .. 15) of Character := "0123456789ABCDEF";

         begin
            if CV <= 127
              or else (CV <= 255 and then EM = WCEM_Hex) then
               RP := RP + 1;
               R (RP) := Character'Val (CV);

            else
               B1 := CV / 256;
               B2 := CV mod 256;

               --  Hex ESC sequence encoding

               if EM = WCEM_Hex then
                  R (RP + 1) := Ascii.ESC;
                  R (RP + 2) := Hex (B1 / 16);
                  R (RP + 3) := Hex (B1 rem 16);
                  R (RP + 4) := Hex (B2 / 16);
                  R (RP + 5) := Hex (B2 rem 16);
                  RP := RP + 5;

               --  Upper bit shift (internal code = external code)

               elsif EM = WCEM_Upper then
                  C1 := Character'Val (B1);
                  C2 := Character'Val (B2);

               --  Upper bit shift (EUC)

               elsif EM = WCEM_EUC then
                  JIS_To_EUC (C, C1, C2);

               --  Upper bit shift (Shift-JIS)

               else -- EM = WCEM_Shift_JIS
                  JIS_To_Shift_JIS (C, C1, C2);
               end if;

               R (RP + 1) := C1;
               R (RP + 2) := C2;
               RP := RP + 2;
            end if;
         end;
      end loop;

      return R (1 .. RP);
   end Wide_String_To_String;

end System.WCh_WtS;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Fri Jul 22 11:38:11 1994;  author: dewar
--  Fix minor syntax errors
--  ----------------------------
--  revision 1.3
--  date: Mon Jul 25 19:08:54 1994;  author: dewar
--  Get codes for encoding method from System.WIde_Character_Constants
--  ----------------------------
--  revision 1.4
--  date: Wed Aug 10 14:27:40 1994;  author: dewar
--  Change package name to WCh_WtS
--  Change function name to Wide_String_To_String
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
