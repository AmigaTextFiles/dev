------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                  S Y S T E M . A D D R E S S _ I M A G E                 --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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

with Unchecked_Conversion;

function System.Address_Image (A : Address) return String is

   Result  : String (1 .. 2 * Address'Size / Storage_Unit);

   type Byte is mod 2 ** 8;
   for Byte'Size use 8;

   Hexdigs :
     constant array (Byte range 0 .. 15) of Character := "0123456789ABCDEF";

   type Bytes is array (1 .. Address'Size / Storage_Unit) of Byte;
   for Bytes'Size use Address'Size;

   function To_Bytes is new Unchecked_Conversion (Address, Bytes);

   Byte_Sequence : constant Bytes := To_Bytes (A);

begin
   for N in Bytes'range loop
      Result (2 * N - 1) := Hexdigs (Byte_Sequence (N) / 16);
      Result (2 * N)     := Hexdigs (Byte_Sequence (N) mod 16);
   end loop;

   return Result;

end System.Address_Image;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 19:24:35 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 11:13:11 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
