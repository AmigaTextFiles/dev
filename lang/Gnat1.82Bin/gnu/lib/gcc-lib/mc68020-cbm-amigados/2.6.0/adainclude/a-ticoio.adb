------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--               A D A . T E X T _ I O . C O M P L E X _ I O                --
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

with Ada.Text_IO;

package body Ada.Text_IO.Complex_IO is

   package F_IO is new Ada.Text_IO.Float_IO (Real);
   --  Should be Real'Base, but that doesn't work in GNAT version 1.80 ???

   ---------
   -- Get --
   ---------

   procedure Get
     (File  : in  File_Type;
      Item  : out Complex;
      Width : in  Field := 0)
   is
      Temp       : String (1 .. Width);
      Length     : Natural;
      Real_Item  : Real'Base;
      Imag_Item  : Real'Base;
      Need_Paren : Boolean := False;
      A_Char     : Character;

   begin
      --  General note for following code, exceptions from the calls to
      --  Get for components of the complex value are propagated.

      if Width /= 0 then
         Ada.Text_IO.Get_Line (File, Temp, Length);
         Get (Temp (1 .. Length), Item, Length);

      --  Case of width = 0


      else
         --  Get either a real or an optional left paren
         --  Needs fix for 123 (1.23,2.5) ???

         begin
            F_IO.Get (File, Real_Item);

         exception
            when Ada.Text_IO.Data_Error =>
               Ada.Text_IO.Get (File, A_Char);

               if A_Char /= '(' then
                  raise;
               else
                  Need_Paren := True;
                  F_IO.Get (File, Real_Item);
               end if;
         end;

         --  Get either an imaginary part or an optional comma

         begin
            F_IO.Get (File, Imag_Item);

         exception
            when Ada.Text_IO.Data_Error =>

               Ada.Text_IO.Get (File, A_Char);
               if A_Char /= ',' then
                  raise;
               else
                  F_IO.Get (File, Imag_Item);
               end if;
         end;

         Item := (Real_Item, Imag_Item);

         while Need_Paren loop
            Ada.Text_IO.Get (File, A_Char);
            exit when A_Char = ')';

            if A_Char /= ' ' and A_Char /= Ascii.HT and
               A_Char /= Ascii.LF then
               raise Ada.Text_IO.Data_Error;
            end if;

         end loop;
      end if;
   end Get;

   ---------
   -- Get --
   ---------

   procedure Get
     (Item  : out Complex;
      Width : in  Field := 0)
   is
      Temp       : String (1 .. Width);
      Length     : Natural;
      Real_Item  : Real'Base;
      Imag_Item  : Real'Base;
      Need_Paren : Boolean := False;
      A_Char     : Character;

   begin
      if Width /= 0 then
         Ada.Text_IO.Get_Line (Temp, Length);
         Get (Temp (1 .. Length), Item, Length);

      else
         --  Get either a real or an optional left paren

         begin
            F_IO.Get (Real_Item);

         exception
            when Ada.Text_IO.Data_Error =>
               Ada.Text_IO.Get (A_Char);

               if A_Char /= '(' then
                  raise;
               else
                  Need_Paren := True;
                  F_IO.Get (Real_Item);
               end if;
         end;

         --  Get either an imaginary part or an optional comma

         begin
            F_IO.Get (Imag_Item);

         exception
            when Ada.Text_IO.Data_Error =>
               Ada.Text_IO.Get (A_Char);

               if A_Char /= ',' then
                  raise;
               else
                  F_IO.Get (Imag_Item);
               end if;
         end;

         Item := (Real_Item, Imag_Item);

         if Need_Paren then
            loop
               Ada.Text_IO.Get (A_Char);
               exit when A_Char = ')';

               if A_Char /= ' ' and A_Char /= Ascii.HT and
                  A_Char /= Ascii.LF then
                  raise Ada.Text_IO.Data_Error;
               end if;
            end loop;
         end if;
      end if;
   end Get;

   ---------
   -- Get --
   ---------

   procedure Get
     (From : in  String;
      Item : out Complex;
      Last : out Positive)
   is
      Real_Item : Real'Base;
      Imag_Item : Real'Base;
      Need_Paren : Boolean := False;
      Pos : Positive := From'First;

   begin
      while From (Pos) = ' ' or From (Pos) = Ascii.HT loop
         Pos := Pos + 1;
      end loop;

      if From (Pos) = '(' then
         Pos := Pos + 1;
         Need_Paren := True;
      end if;

      F_IO.Get (From (Pos .. From'Last), Real_Item, Pos);
      Pos := Pos + 1;

      while From (Pos) = ' ' or From (Pos) = Ascii.HT loop
         Pos := Pos + 1;
      end loop;

      if From (Pos) = ',' then
         Pos := Pos + 1;
      end if;

      F_IO.Get (From (Pos .. From'Last), Imag_Item, Pos);
      Pos := Pos + 1;

      if Need_Paren then
         while From (Pos) = ' ' or From (Pos) = Ascii.HT loop
            Pos := Pos + 1;
         end loop;

         if From (Pos) /= ')' then
            raise Ada.Text_IO.Data_Error;
         end if;
      end if;

      Item := (Real_Item, Imag_Item);
      Last := Pos;

   exception
      when Constraint_Error =>
         raise Ada.Text_IO.Data_Error;
   end Get;

   ---------
   -- Put --
   ---------

   procedure Put
     (File : in File_Type;
      Item : in Complex;
      Fore : in Field := Default_Fore;
      Aft  : in Field := Default_Aft;
      Exp  : in Field := Default_Exp)
   is

   begin
      Ada.Text_IO.Put (File, '(');
      F_IO.Put (File, Re (Item), Fore, Aft, Exp);  -- Item.Re
      Ada.Text_IO.Put (File, ',');
      F_IO.Put (File, Im (Item), Fore, Aft, Exp);  -- Item.Im
      Ada.Text_IO.Put (File, ')');
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put
     (Item : in Complex;
      Fore : in Field := Default_Fore;
      Aft  : in Field := Default_Aft;
      Exp  : in Field := Default_Exp)
   is
   begin
      Ada.Text_IO.Put ('(');
      F_IO.Put (Re (Item), Fore, Aft, Exp);        -- Item.Re
      Ada.Text_IO.Put (',');
      F_IO.Put (Im (Item), Fore, Aft, Exp);        -- Item.Im
      Ada.Text_IO.Put (')');
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put
     (To   : out String;
      Item : in  Complex;
      Aft  : in  Field := Default_Aft;
      Exp  : in  Field := Default_Exp)
   is
      Temp : String (To'Range);       --  so we can read from it
      End_Re : Positive := 1;
      Start_Re : Positive := 1;

   begin
      Temp (To'Last) := ')';
      F_IO.Put (Temp (To'First .. To'Last - 1), Im (Item), Aft, Exp);  --  Im

      for J in To'Range loop
         if Temp (J) /= ' ' then
            End_Re := J - 1;
            exit;
         end if;
      end loop;

      F_IO.Put (Temp (To'First .. End_Re), Re (Item), Aft, Exp);       --  Re

      for J in To'Range loop
         if Temp (J) /= ' ' then
            Start_Re := J;
            exit;
         end if;
      end loop;

      --  Ensure enough room for paren and comma

      if Start_Re <= To'First + 1 then
         raise Layout_Error;
      end if;

      Temp (To'First + 1 .. To'First + (End_Re - Start_Re + 1)) :=
         Temp (Start_Re .. End_Re);

      for J in To'First + (End_Re - Start_Re + 3) .. End_Re loop
         Temp (J) := ' ';
      end loop;

      Temp (To'First + (End_Re - Start_Re + 2)) := ',';
      Temp (To'First) := '(';
      To := Temp;

   exception
      --  Not enough room in the string means that Layout_Error is raised

      when Constraint_Error =>
         raise Layout_Error;
   end Put;

end Ada.Text_IO.Complex_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu May 12 13:39:50 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Mon Jun  6 08:42:07 1994;  author: schonber
--  Full implementation (from Jon Squires).
--  Minor reformatting.
--  ----------------------------
--  revision 1.3
--  date: Mon Jun  6 09:09:27 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
