------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     S Y S T E M . W I D _ W C H A R                      --
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

with System.WCh_Con; use System.WCh_Con;

package body System.Wid_WChar is

   --------------------------
   -- Width_Wide_Character --
   --------------------------

   function Width_Wide_Character
     (Lo, Hi : Wide_Character;
      EM     : WC_Encoding_Method)
      return   Natural
   is
      W : Natural;
      P : Natural;

   begin
      W := 0;

      for C in Lo .. Hi loop
         P := Wide_Character'Pos (C);

         --  If we are in wide character range, just use width of encoding
         --  sequence (currently a constant for all encoding methods) and
         --  we are done.

         if P > 255 then
            if EM = WCEM_Hex then
               return Natural'Max (W, 5);
            else
               return Natural'Max (W, 2);
            end if;

         --  If we are in character range then use length of character image

         else
            declare
               S : String := Character'Image (Character'Val (P));

            begin
               W := Natural'Max (W, S'Length);
            end;
         end if;
      end loop;

      return W;
   end Width_Wide_Character;

end System.Wid_WChar;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Jul 28 00:29:51 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Aug  7 05:19:34 1994;  author: dewar
--  New name of function is Width_Wide_Character
--  New name of package is Wid_Wchar
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 10 14:27:53 1994;  author: dewar
--  Change name Wide_Character_Constants to WCh_Con
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
