------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                            S Y S T E M . I O                             --
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

package body System.IO is

   procedure Get (X : out Integer) is
      function Getint return Integer;
      pragma Interface (C, Getint);
      pragma Interface_Name (Getint, "get_int");
   begin
      X := Getint;
   end Get;

   procedure Put (X : Integer) is
      procedure Putint (X : Integer);
      pragma Interface (C, Putint);
      pragma Interface_Name (Putint, "put_int");
   begin
      Putint (X);
   end Put;

   procedure Get (C : out Character) is
      function Getchar return Character;
      pragma Interface (C, Getchar);
   begin
      C := Getchar;
   end Get;

   procedure Put (C : Character) is
      procedure Putchar (C : Character);
      pragma Interface (C, Putchar);
   begin
      Putchar (C);
   end Put;

   procedure Put (S : String) is
   begin
      for I in S'range loop
         Put (S (I));
      end loop;
   end Put;

   procedure Put_Line (S : String) is
   begin
      Put (S);
      New_Line;
   end Put_Line;

   procedure New_Line (Spacing : Positive := 1) is
   begin
      for I in 1 .. Spacing loop
         Put (Ascii.LF);
      end loop;
   end New_Line;

   procedure Get_Line (Item : in out String; Last : out Natural) is
      I_Length : Integer := Item'Length;
      Nstore : Integer := 0;
      C : Character;
   begin
      loop
         Get (C);
         exit when Nstore = I_Length;
         if C = Ascii.Lf then
            exit;
         end if;
         Item (Item'First + Nstore) := C;
         Nstore := Nstore + 1;
      end loop;
      Last := Item'First + Nstore - 1;
   end Get_Line;

end System.IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul  1 14:23:30 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
