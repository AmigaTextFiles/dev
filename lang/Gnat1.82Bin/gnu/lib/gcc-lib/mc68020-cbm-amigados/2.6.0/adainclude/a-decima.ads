------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          A D A . D E C I M A L                           --
--                                                                          --
--                                 S p e c                                  --
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

package Ada.Decimal is
pragma Pure (Ada.Decimal);

   pragma Unimplemented_Unit;

   Max_Scale : constant := +18;
   Min_Scale : constant := -18;

   Min_Delta : constant := 10.0E-18;
   Max_Delta : constant := 10.0E+18;

   Max_Decimal_Digits : constant := 18;

   generic
      type Dividend_Type  is delta <> digits <>;
      type Divisor_Type   is delta <> digits <>;
      type Quotient_Type  is delta <> digits <>;
      type Remainder_Type is delta <> digits <>;

   package Division is

      procedure Divide (Dividend  : in Dividend_Type;
                        Divisor   : in Divisor_Type;
                        Quotient  : out Quotient_Type;
                        Remainder : out Remainder_Type);

      procedure Divide (Dividend  : in Dividend_Type;
                        Divisor   : in Divisor_Type;
                        Quotient  : out Quotient_Type;
                        Rounded   : in Boolean := False);
   end Division;

end Ada.Decimal;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:29:18 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Thu May 12 14:02:45 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  revision 1.4
--  date: Mon Jun  6 12:03:03 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
