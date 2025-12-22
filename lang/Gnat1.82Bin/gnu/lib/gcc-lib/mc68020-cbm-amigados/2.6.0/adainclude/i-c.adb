------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                         I N T E R F A C E S . C                          --
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

package body Interfaces.C is

   ------------
   -- To_Ada --
   ------------

   --  Convert char_array to String (function form)

   function To_Ada
     (Item     : in char_array;
      Trim_Nul : in Boolean := True)
      return     String
   is
      Result : String (1 .. Item'Length);

   begin
      for J in Item'range loop
         if Item (J) = nul and then Trim_Nul then
            return Result (1 .. J - Item'First + Result'First - 1);
         else
            Result (J - Item'First + Result'First) := To_Ada (Item (J));
         end if;
      end loop;

      if Trim_Nul then
         raise Terminator_Error;
      end if;

      return Result;
   end To_Ada;

   --  Convert char_array to String (procedure form)

   procedure To_Ada
     (Item       : in  char_array;
      Target     : out String;
      Last       : out Natural;
      Trim_Nul   : in Boolean := True)
   is
   begin
      Last := 0;

      for J in Item'range loop
         if Item (J) = nul and then Trim_Nul then
            return;
         end if;

         Last := Last + 1;
         Target (Last) := To_Ada (Item (J));
      end loop;

      if Trim_Nul then
         raise Terminator_Error;
      end if;
   end To_Ada;

   --  Convert wchar_array to Wide_String (function form)

   function To_Ada
     (Item        : in  wchar_array;
      Trim_Nul    : in  Boolean := True)
      return        Wide_String
   is
      Result : Wide_String (1 .. Item'Length);

   begin
      for J in Item'range loop
         if Item (J) = wide_nul and then Trim_Nul then
            return Result (1 .. J - Item'First + Result'First - 1);
         else
            Result (J - Item'First + Result'First) :=
              Wide_Character (Item (J));
         end if;
      end loop;

      if Trim_Nul then
         raise Terminator_Error;
      end if;

      return Result;
   end To_Ada;

   --  Convert wchar_array to Wide_String (procedure form)

   procedure To_Ada
     (Item       : in  wchar_array;
      Target     : out Wide_String;
      Last       : out Natural;
      Trim_Nul   : in  Boolean := True)
   is
   begin
      Last := 0;

      for J in Item'range loop
         if Item (J) = wide_nul and then Trim_Nul then
            return;
         end if;

         Last := Last + 1;
         Target (Last) := Wide_Character (Item (J));
      end loop;

      if Trim_Nul then
         raise Terminator_Error;
      end if;
   end To_Ada;

   ----------
   -- To_C --
   ----------

   --  Convert String to char_array (function form)

   function To_C
     (Item       : in String;
      Append_Nul : in Boolean := True)
      return       char_array
   is
      Result : char_array (0 .. Item'Length - Boolean'Pos (not Append_Nul));

   begin
      for J in Item'range loop
         Result (J - Item'First) := To_C (Item (J));
      end loop;

      if Append_Nul then
         Result (Item'Length) := nul;
      end if;

      return Result;
   end To_C;

   --  Convert String to char_array (procedure form)

   --  Note: in the following procedure, we are relying on the built in
   --  constraint checking to propagate Constraint_Error when required,
   --  so checks must be on if this checking is required.

   procedure To_C
     (Item       : in  String;
      Target     : out char_array;
      Last       : out Integer;
      Append_Nul : in  Boolean := True)
   is
   begin
      Last := -1;

      for J in Item'range loop
         Last          := Last + 1;
         Target (Last) := To_C (Item (J));
      end loop;

      if Append_Nul then
         Last          := Last + 1;
         Target (Last) := nul;
      end if;
   end To_C;

   --  Convert Wide_String to wchar_array (function form)

   function To_C
     (Item        : in  Wide_String;
      Append_Nul  : in  Boolean := True)
      return        wchar_array
   is
      Result :
        wchar_array (0 .. Item'Length - Boolean'Pos (not Append_Nul));

   begin
      for J in Item'range loop
         Result (J - Item'First) := wchar_t (Item (J));
      end loop;

      if Append_Nul then
         Result (Item'Length) := wide_nul;
      end if;

      return Result;
   end To_C;

   --  Convert Wide_String to wchar_array (procedure form)

   --  Note: in the following procedure, we are relying on the built in
   --  constraint checking to propagate Constraint_Error when required,
   --  so checks must be on if this checking is required.

   procedure To_C
     (Item       : in  Wide_String;
      Target     : out wchar_array;
      Last       : out Integer;
      Append_Nul : in  Boolean := True)
   is
   begin
      Last := -1;

      for J in Item'range loop
         Last          := Last + 1;
         Target (Last) := wchar_t (Item (J));
      end loop;

      if Append_Nul then
         Last          := Last + 1;
         Target (Last) := wide_nul;
      end if;
   end To_C;

end Interfaces.C;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Apr 11 07:53:07 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Mon May 23 10:39:16 1994;  author: dewar
--  Remove To_C and To_Ada for wide character cases, now done in the spec
--  Change name C_To_Ada and Ada_To_C to To_Ada and To_C
--  ----------------------------
--  revision 1.3
--  date: Thu Aug 11 10:44:41 1994;  author: dewar
--  Lots of little changes to match 5.0 (mostly name changes and changes in
--   casing, use lower case for C related names)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
