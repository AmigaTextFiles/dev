------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                        S Y S T E M . X P _ B M L                         --
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

with System.Unsigned_Types; use System.Unsigned_Types;

package body System.Exp_LLU is

   ----------------------------
   -- Exp_Long_Long_Unsigned --
   ----------------------------

   function Exp_Long_Long_Unsigned
     (Left  : Long_Long_Unsigned;
      Right : Natural)
      return  Long_Long_Unsigned
   is
      Result : Long_Long_Unsigned := 1;
      Factor : Long_Long_Unsigned := Left;
      Exp    : Natural := Right;

   begin
      --  We use the standard logarithmic approach, Exp gets shifted right
      --  testing successive low order bits and Factor is the value of the
      --  base raised to the next power of 2.

      --  Note: it is not worth special casing the cases of base values -1,0,+1
      --  since the expander does this when the base is a literal, and other
      --  cases will be extremely rare.

      while Exp /= 0 loop
         if Exp rem 2 /= 0 then
            Result := Result * Factor;
         end if;

         Factor := Factor * Factor;
         Exp := Exp / 2;
      end loop;

      return Result;

   end Exp_Long_Long_Unsigned;

end System.Exp_LLU;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Wed Jun  1 23:26:40 1994;  author: dewar
--  Add use clause removed from spec
--  ----------------------------
--  revision 1.3
--  date: Tue Aug  2 19:27:47 1994;  author: dewar
--  Make into package as required by Rtsfind
--  ----------------------------
--  revision 1.4
--  date: Mon Aug  8 02:28:49 1994;  author: dewar
--  Change function name to Exp_Long_Long_Unsigned
--  Change package name to Exp_Uns
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
