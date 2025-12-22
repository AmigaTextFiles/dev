------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          A D A . T E X T _ I O                           --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.18 $                             --
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

with Ada.Text_IO.Aux;
with System.Unsigned_Types;
package body Ada.Text_IO is

   procedure Unimplemented (Message : String) is
   begin
      Put (Message);
      Put_Line (" not implemented yet");
      raise Program_Error;
   end Unimplemented;

   ---------------------
   -- File Management --
   ---------------------

   procedure Create
     (File : in out File_Type;
      Mode : in File_Mode := Out_File;
      Name : in String := "";
      Form : in String := "")
   renames Text_IO.Aux.Create;

   procedure Open
     (File : in out File_Type;
      Mode : in File_Mode;
      Name : in String;
      Form : in String := "")
   renames Text_IO.Aux.Open;

   procedure Close  (File : in out File_Type) renames Text_IO.Aux.Close;
   procedure Delete (File : in out File_Type) renames Text_IO.Aux.Delete;

   procedure Reset
     (File : in out File_Type;
      Mode : in File_Mode)
   renames Text_IO.Aux.Reset;

   procedure Reset (File : in out File_Type) is
   begin
      Text_IO.Aux.Reset (File, Text_IO.Aux.Mode (File));
   end Reset;

   function Mode (File : in File_Type) return File_Mode
     renames Text_IO.Aux.Mode;

   function Name (File : in File_Type) return String renames Text_IO.Aux.Name;
   function Form (File : in File_Type) return String renames Text_IO.Aux.Form;

   function Is_Open (File : in File_Type) return Boolean
     renames Text_IO.Aux.Is_Open;

   procedure Set_Input  (File : in File_Type) renames Text_IO.Aux.Set_Input;
   procedure Set_Output (File : in File_Type) renames Text_IO.Aux.Set_Output;
   procedure Set_Error  (File : in File_Type) renames Text_IO.Aux.Set_Error;

   function Standard_Input return File_Type
     renames Text_IO.Aux.Standard_Input;

   function Standard_Output return File_Type
     renames Text_IO.Aux.Standard_Output;

   function Standard_Error return File_Type
     renames Text_IO.Aux.Standard_Error;

   function Current_Input  return File_Type renames Text_IO.Aux.Current_Input;
   function Current_Output return File_Type renames Text_IO.Aux.Current_Output;
   function Current_Error  return File_Type renames Text_IO.Aux.Current_Error;

   function Standard_Input return File_Access is
   begin
      return Text_IO.Aux.Standard_In'access;
   end Standard_Input;

   function Standard_Output return File_Access is
   begin
      return Text_IO.Aux.Standard_Out'access;
   end Standard_Output;

   function Standard_Error return File_Access is
   begin
      return Text_IO.Aux.Standard_Err'access;
   end Standard_Error;

   function Current_Input  return File_Access is
   begin
      return Text_IO.Aux.Current_In'access;
   end Current_Input;

   function Current_Output return File_Access is
   begin
      return Text_IO.Aux.Current_Out'access;
   end Current_Output;

   function Current_Error  return File_Access is
   begin
      return Text_IO.Aux.Current_Err'access;
   end Current_Error;

   --------------------
   -- Buffer control --
   --------------------

   procedure Flush (File : in out File_Type) is
   begin
      Unimplemented ("Flush");
      raise Program_Error;
   end Flush;

   procedure Flush is
   begin
      Unimplemented ("Flush");
      raise Program_Error;
   end Flush;

   --------------------------------------------
   -- Specification of line and page lengths --
   --------------------------------------------

   procedure Set_Line_Length (File : in File_Type; To : in Count)
     renames Text_IO.Aux.Set_Line_Length;

   procedure Set_Line_Length (To : in Count) is
   begin
      Text_IO.Aux.Set_Line_Length (Current_Output, To);
   end Set_Line_Length;

   function Line_Length (File : in File_Type) return Count
     renames Text_IO.Aux.Line_Length;

   function Line_Length return Count is
   begin
      return Text_IO.Aux.Line_Length (Current_Output);
   end Line_Length;

   procedure Set_Page_Length (File : in File_Type; To : in Count)
     renames Text_IO.Aux.Set_Page_Length;

   procedure Set_Page_Length (To : in Count) is
   begin
      Text_IO.Aux.Set_Page_Length (Current_Output, To);
   end Set_Page_Length;

   function Page_Length (File : in File_Type) return Count
     renames Text_IO.Aux.Page_Length;

   function Page_Length return Count is
   begin
      return Page_Length (Current_Output);
   end Page_Length;

   ------------------------------------
   -- Column, Line, and Page Control --
   ------------------------------------

   procedure New_Line (File : in File_Type; Spacing : in Positive_Count := 1)
     renames Text_IO.Aux.New_Line;

   procedure New_Line (Spacing : in Positive_Count := 1) is
   begin
      New_Line (Current_Output, Spacing);
   end New_Line;

   procedure Skip_Line
     (File    : in File_Type;
      Spacing : in Positive_Count := 1)
   renames Text_IO.Aux.Skip_Line;

   procedure Skip_Line (Spacing : in Positive_Count := 1) is
   begin
      Skip_Line (Current_Input, Spacing);
   end Skip_Line;

   function End_Of_Line (File : in File_Type) return Boolean
     renames Text_IO.Aux.End_Of_Line;

   function End_Of_Line return Boolean is
   begin
      return End_Of_Line (Current_Input);
   end End_Of_Line;

   procedure New_Page (File : in File_Type) renames Text_IO.Aux.New_Page;

   procedure New_Page is
   begin
      New_Page (Current_Output);
   end New_Page;

   procedure Skip_Page (File : in File_Type) renames Text_IO.Aux.Skip_Page;

   procedure Skip_Page is
   begin
      Skip_Page (Current_Input);
   end Skip_Page;

   function End_Of_Page (File : in File_Type) return Boolean
     renames Text_IO.Aux.End_Of_Page;

   function End_Of_Page return Boolean is
   begin
      return End_Of_Page (Current_Input);
   end End_Of_Page;

   function End_Of_File (File : in File_Type) return Boolean
     renames Text_IO.Aux.End_Of_File;

   function End_Of_File return Boolean is
   begin
      return End_Of_File (Current_Input);
   end End_Of_File;

   procedure Set_Col
     (File : in File_Type;
      To   : in Positive_Count)
   renames Text_IO.Aux.Set_Col;

   procedure Set_Col (To : in Positive_Count) is
   begin
      Set_Col (Current_Output, To);
   end Set_Col;

   procedure Set_Line
     (File : in File_Type;
      To   : in Positive_Count)
   renames Text_IO.Aux.Set_Line;

   procedure Set_Line (To : in Positive_Count) is
   begin
      Set_Line (Current_Output, To);
   end Set_Line;

   function Col (File : in File_Type) return Positive_Count
     renames Text_IO.Aux.Col;

   function Col return Positive_Count is
   begin
      return Col (Current_Output);
   end Col;

   function Line (File : in File_Type) return Positive_Count
     renames Text_IO.Aux.Line;

   function Line return Positive_Count is
   begin
      return Line (Current_Output);
   end Line;

   function Page (File : in File_Type) return Positive_Count
     renames Text_IO.Aux.Page;

   function Page return Positive_Count is
   begin
      return Page (Current_Output);
   end Page;

   -------------------------------
   --  Characters Input-Output  --
   -------------------------------

   procedure Get
     (File : in File_Type;
      Item : out Character)
   is
   begin
      Text_IO.Aux.The_File := File;
      Text_IO.Aux.Get (Item);
   end Get;


   procedure Get (Item : out Character) is
   begin
      Get (Current_Input, Item);
   end Get;

   procedure Put
     (File : in File_Type;
      Item : in Character)
   is
   begin
      Text_IO.Aux.The_File := File;
      Text_IO.Aux.Put (Item);
   end Put;

   procedure Put (Item : in Character) is
   begin
      Put (Current_Output, Item);
   end Put;

   procedure Look_Ahead
     (File        : in File_Type;
      Item        : out Character;
      End_Of_Line : out Boolean)
   is
   begin
      Unimplemented ("Look_Ahead");
      raise Program_Error;
   end Look_Ahead;

   procedure Look_Ahead
     (File        : out Character;
      End_of_Line : out Boolean)
   is
   begin
      Unimplemented ("Look_Ahead");
      raise Program_Error;
   end Look_Ahead;

   procedure Get_Immediate
     (File : in File_Type;
      Item : out Character)
   is
   begin
      Unimplemented ("Get_Immediate");
      raise Program_Error;
   end Get_Immediate;

   procedure Get_Immediate (Item : out Character) is
   begin
      Unimplemented ("Get_Immediate");
      raise Program_Error;
   end Get_Immediate;

   procedure Get_Immediate
     (File      : in File_Type;
      Item      : out Character;
      Available : out Boolean)
   is
   begin
      Unimplemented ("Get_Immediate");
      raise Program_Error;
   end Get_Immediate;

   procedure Get_Immediate
     (Item      : out Character;
      Available : out Boolean)
   is
   begin
      Unimplemented ("Get_Immediate");
      raise Program_Error;
   end Get_Immediate;

   ---------------------------
   -- Strings Input-Output  --
   ---------------------------

   procedure Get
     (File : in File_Type;
      Item : out String)
   is
   begin
      Text_IO.Aux.The_File := File;
      Text_IO.Aux.Get (Item);
   end Get;

   procedure Get (Item : out String) is
   begin
      Get (Current_Input, Item);
   end Get;

   procedure Put
     (File : in File_Type;
      Item : in String)
   is
   begin
      Text_IO.Aux.The_File := File;
      Text_IO.Aux.Put (Item);
   end Put;

   procedure Put (Item : in String) is
   begin
      Put (Current_Output, Item);
   end Put;

   procedure Get_Line
     (File : in File_Type;
      Item : out String;
      Last : out Natural)
   renames Text_IO.Aux.Get_Line;

   procedure Get_Line
     (Item : out String;
      Last : out Natural)
   is
   begin
      Get_Line (Current_Input, Item, Last);
   end Get_Line;

   procedure Put_Line
     (File : in File_Type;
      Item : in String)
   renames Text_IO.Aux.Put_Line;

   procedure Put_Line (Item : in String) is
   begin
      Put_Line (Current_Output, Item);
   end Put_Line;

   -------------------------------------
   --  Input-Output of Integer Types  --
   -------------------------------------

   package body Integer_Io is
      subtype LLI is Long_Long_Integer;

      Num_First : LLI := LLI (Num'First);
      Num_Last  : LLI := LLI (Num'Last);

      procedure Get
        (File  : in File_Type;
         Item  : out Num;
         Width : in Field := 0)
      is
         X : Integer;

      begin
         if Num'Size > Integer'Size then
            Unimplemented ("Get on this type (Num too big)");
         end if;

         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Get_Int (X, Width);

         if LLI (X) < Num_First or else LLI (X) > Num_Last then
            raise Data_Error;
         end if;

         Item := Num (X);
      end Get;

      procedure Get
        (Item  : out Num;
         Width : in Field := 0)
      is
      begin
         Get (Current_Input, Item, Width);
      end Get;

      procedure Put
        (File  : in File_Type;
         Item  : in Num;
         Width : in Field := Default_Width;
         Base  : in Number_Base := Default_Base)
      is
      begin
         Text_IO.Aux.The_File := File;

         if Num'Size > Integer'Size then
            Text_IO.Aux.Put_LLI (LLI (Item), Width, Base);
         else
            Text_IO.Aux.Put_Integer (Integer (Item), Width, Base);
         end if;
      end Put;

      procedure Put
        (Item  : in Num;
         Width : in Field := Default_Width;
         Base  : in Number_Base := Default_Base)
      is
      begin
         Put (Current_Output, Item, Width, Base);
      end Put;

      procedure Get
        (From : in String;
         Item : out Num;
         Last : out positive)
      is
         X : Integer;

      begin
         if Num'Size > Integer'Size then
            Unimplemented ("Get on this type (Num too big)");
         end if;

         Text_IO.Aux.Get_Int (From, X, Last);

         if LLI (X) < Num_First or else LLI (X) > Num_Last then
            raise Data_Error;
         end if;

         Item := Num (X);
      end Get;


      procedure Put
        (To   : out String;
         Item : in Num;
         Base : in Number_Base := Default_Base)
      is
      begin
         if Num'Size > Integer'Size then
            Text_IO.Aux.Put_LLI (To, LLI (Item), Base);
         else
            Text_IO.Aux.Put_Integer (To, Integer (Item), Base);
         end if;
      end Put;

   end Integer_Io;

   -------------------------------------
   --  Input-Output of Modular Types  --
   -------------------------------------

   package body Modular_IO is
      use System.Unsigned_Types;
      subtype LLU is Long_Long_Unsigned;

      procedure Get
        (File  : in File_Type;
         Item  : out Num;
         Width : in Field := 0)
      is
      begin
         Unimplemented ("Modular Get");
      end Get;

      procedure Get
        (Item  : out Num;
         Width : in Field := 0)
      is
      begin
         Get (Current_Input, Item, Width);
      end Get;

      procedure Put
        (File  : in File_Type;
         Item  : in Num;
         Width : in Field := Default_Width;
         Base  : in Number_Base := Default_Base)
      is
      begin
         Text_IO.Aux.The_File := File;

         if Num'Size > Unsigned'Size then
            Text_IO.Aux.Put_LLU (LLU (Item), Width, Base);
         else
            Text_IO.Aux.Put_Unsigned (Unsigned (Item), Width, Base);
         end if;
      end Put;

      procedure Put
        (Item  : in Num;
         Width : in Field := Default_Width;
         Base  : in Number_Base := Default_Base)
      is
      begin
         Put (Current_Output, Item, Width, Base);
      end Put;

      procedure Get
        (From : in String;
         Item : out Num;
         Last : out Positive)
      is
      begin
         Unimplemented ("Modular Get");
      end Get;

      procedure Put
        (To   : out String;
         Item : in Num;
         Base : in Number_Base := Default_Base)
      is
      begin
         if Num'Size > Unsigned'Size then
            Text_IO.Aux.Put_LLU (To, LLU (Item), Base);
         else
            Text_IO.Aux.Put_Unsigned (To, Unsigned (Item), Base);
         end if;
      end Put;

   end Modular_IO;

   ---------------------------------
   -- Input-Output of Float Types --
   ---------------------------------

   package body Float_Io is

      Num_First : Aux.LLF := Aux.LLF (Num'First);
      Num_Last  : Aux.LLF := Aux.LLF (Num'Last);

      procedure Get
        (File : in File_Type;
         Item : out Num;
         Width : in Field := 0)
      is
         X : Aux.LLF;

      begin
         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Get_Float (X, Width);

         if X < Num_First or else X > Num_Last then
            raise Data_Error;
         end if;

         Item := Num (X);
      end Get;

      procedure Get
        (Item : out Num;
         Width : in Field := 0)
      is
      begin
         Get (Current_Input, Item, Width);
      end Get;

      procedure Put
        (File : in File_Type;
         Item : in Num;
         Fore : in Field := Default_Fore;
         Aft  : in Field := Default_Aft;
         Exp  : in Field := Default_Exp)
      is
      begin
         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Put_Float (Aux.LLF (Item), Fore, Aft, Exp);
      end Put;

      procedure Put
        (Item : in Num;
         Fore : in Field := Default_Fore;
         Aft  : in Field := Default_Aft;
         Exp : in Field := Default_Exp)
      is
      begin
         Put (Current_Output, Item, Fore, Aft, Exp);
      end Put;

      procedure Get
        (From : in String;
         Item : out Num;
         Last : out Positive)
      is
      begin
         Text_IO.Aux.Get_Float (From, Aux.LLF (Item), Last);
      end Get;

      procedure Put
        (To : out String;
         Item : in Num;
         Aft : in Field := Default_Aft;
         Exp : in Field := Default_Exp)
      is
      begin
         Text_IO.Aux.Put_Float (To, Aux.LLF (Item), Aft, Exp);
      end Put;

   end Float_Io;

   package body Fixed_Io is

      X : Aux.LLF;

      procedure Get
        (File  : in File_Type;
         Item  : out Num;
         Width : in Field := 0)
      is
      begin
         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Get_Float (X, Width);
         --  ???
         --  if X < Aux.LLF (Num'First) or else X > Aux.LLF (Num'Last) then
         --     raise Data_Error;
         --  end if;
         Item := Num (X);
      end Get;

      procedure Get
        (Item  : out Num;
         Width : in Field := 0)
      is
      begin
         Get (Current_Input, Item, Width);
      end Get;

      procedure Put
        (File : in File_Type;
         Item : in Num;
         Fore : in Field := Default_Fore;
         Aft  : in Field := Default_Aft;
         Exp  : in Field := Default_Exp)
      is
      begin
         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Put_Float (Aux.LLF (Item), Fore, Aft, Exp);
      end Put;

      procedure Put
        (Item : in Num;
         Fore : in Field := Default_Fore;
         Aft  : in Field := Default_Aft;
         Exp  : in Field := Default_Exp)
      is
      begin
         Put (Current_Output, Item, Fore, Aft, Exp);
      end Put;

      procedure Get
        (From : in String;
         Item : out Num; Last : out Positive)
      is
      begin
         Text_IO.Aux.Get_Float (From, X, Last);
         --  ???
         --  if X < Aux.LLF (Num'First) or else X > Aux.LLF (Num'Last) then
         --     raise Data_Error;
         --  end if;
         Item := Num (X);
      end Get;

      procedure Put
        (To   : out String;
         Item : in Num;
         Aft  : in Field := Default_Aft;
         Exp  : in Field := Default_Exp)
      is
      begin
         Text_IO.Aux.Put_Float (To, Aux.LLF (Item), Aft, Exp);
      end Put;

   end Fixed_Io;

   ---------------------------------------
   -- Input-Output of Enumeration Types --
   ---------------------------------------

   package body Enumeration_Io is

      --  S : String (1 .. Enum'Width);
      S : String (1 .. 255); -- ???

      procedure Get
        (File : in File_Type;
         Item : out Enum)
      is
         Len : Positive;

      begin
         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Get_Enum (S, Len);

         for E in Enum'range loop
            if Enum'Image (E) = S (1 .. Len) then
               Item := E;
               return;
            end if;
         end loop;
         raise Data_Error;
      end Get;

      procedure Get (Item : out Enum) is
      begin
         Get (Current_Input, Item);
      end Get;

      procedure Put
        (File  : in File_Type;
         Item  : in Enum;
         Width : in Field := Default_Width;
         Set   : in Type_Set := Default_Setting)
      is
      begin
         Text_IO.Aux.The_File := File;
         Text_IO.Aux.Put_Enum (Enum'Image (Item), Width, Set);
      end Put;

      procedure Put
        (Item  : in Enum;
         Width : in Field := Default_Width;
         Set   : in Type_Set := Default_Setting)
      is
      begin
         Put (Current_Output, Item, Width, Set);
      end Put;

      procedure Get
        (From : in String;
         Item : out Enum;
         Last : out Positive)
      is
         Len : Positive;

      begin
         Text_IO.Aux.Get_Enum (S, From, Len, Last);

         for E in Enum'range loop
            if Enum'Image (E) = S (1 .. Len) then
               Item := E;
               return;
            end if;
         end loop;

         raise Data_Error;
      end Get;

      procedure Put
        (To   : out String;
         Item : in Enum;
         Set  : in Type_Set := Default_Setting)
      is
      begin
         Text_IO.Aux.Put_Enum (To, Enum'Image (Item), Set);
      end Put;

   end Enumeration_Io;

end Ada.Text_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.16
--  date: Thu Jul 28 12:26:10 1994;  author: banner
--  Remove versions of Set_Input, Set_Output, Set_Error that take File_Access.
--  ----------------------------
--  revision 1.17
--  date: Thu Aug 25 17:41:47 1994;  author: banner
--  (Integer_Io) rewrite to support Put for Long_Long_Integer
--   change unimplemented messages to apply only to Get for cases of
--    Num'Size > Integer'Size
--  introduce Num_First and Num_Last for checking bounds
--  changes calls of Put_Int to Put_Integer
--  (Modular_IO): add support for Put procedures, unimplemented message for Get
--  ----------------------------
--  revision 1.18
--  date: Mon Aug 29 23:41:53 1994;  author: dewar
--  Minor reformatting (mostly fixing of procedure spec formats)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
