------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . E X P _ M O D                        --
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

package body System.Exp_Mod is

   -----------------
   -- Exp_Modular --
   -----------------

   function Exp_Modular
     (Left    : Integer;
      Modulus : Integer;
      Right   : Natural)
      return    Integer
   is
      Result : Integer := 1;
      Factor : Integer := Left;
      Exp    : Natural := Right;

      function Mult (X, Y : Integer) return Integer;
      pragma Inline (Mult);
      --  Modular multiplication. Note that we can't take advantage of the
      --  compiler's circuit, because the modulus is not known statically.

      function Mult (X, Y : Integer) return Integer is
      begin
         return Integer
           (Long_Long_Integer (X) * Long_Long_Integer (Y)
             mod Long_Long_Integer (Modulus));
      end Mult;

   --  Start of processing for Exp_Modular

   begin
      --  We use the standard logarithmic approach, Exp gets shifted right
      --  testing successive low order bits and Factor is the value of the
      --  base raised to the next power of 2.

      --  Note: it is not worth special casing the cases of base values -1,0,+1
      --  since the expander does this when the base is a literal, and other
      --  cases will be extremely rare.

      while Exp /= 0 loop
         if Exp rem 2 /= 0 then
            Result := Mult (Result, Factor);
         end if;

         Factor := Mult (Factor, Factor);
         Exp := Exp / 2;
      end loop;

      return Result;

   end Exp_Modular;

end System.Exp_Mod;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Thu Apr  7 07:45:10 1994;  author: dewar
--  (Mult): Add pragma Inline
--  ----------------------------
--  revision 1.3
--  date: Tue Aug  2 19:28:42 1994;  author: dewar
--  Make into package, as required by Rtsfind
--  ----------------------------
--  revision 1.4
--  date: Mon Aug  8 02:29:03 1994;  author: dewar
--  Change name of package to Exp_Mod
--  Change name of function to Exp_Modular
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
