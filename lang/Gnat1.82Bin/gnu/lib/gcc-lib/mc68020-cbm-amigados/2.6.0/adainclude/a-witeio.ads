------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     A D A . W I D E _ T E X T _ I O                      --
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

with Ada.IO_Exceptions;

   pragma Unimplemented_Unit;

package Ada.Wide_Text_IO is

   type File_Type is limited private;
   type File_Mode is (In_File, Out_File, Append_File);

   type Count is range 0 .. Integer'Last;    --  implementation defined;
   subtype Positive_Count is Count range 1 .. Count'Last;
   Unbounded : constant Count := 0;          --  line and page length

   subtype Field is Integer range 0 .. 100;  --  implementation defined
   subtype Number_Base is Integer range 2 .. 16;

   type Type_Set is (Lower_Case, Upper_Case);

   ---------------------
   -- File Management --
   ---------------------

   procedure Create (File : in out File_Type;
                     Mode : in File_Mode := Out_File;
                     Name : in String := "";
                     Form : in String := "");

   procedure Open   (File : in out File_Type;
                     Mode : in File_Mode;
                     Name : in String;
                     Form : in String := "");

   procedure Close  (File : in out File_Type);
   procedure Delete (File : in out File_Type);
   procedure Reset  (File : in out File_Type;
                     Mode : in File_Mode);

   procedure Reset  (File : in out File_Type);

   function Mode    (File : in File_Type) return File_Mode;
   function Name    (File : in File_Type) return String;
   function Form    (File : in File_Type) return String;

   function Is_Open (File : in File_Type) return Boolean;

   ------------------------------------------------------
   -- Control of default input, output and error files --
   ------------------------------------------------------

   procedure Set_Input (File : in File_Type);
   procedure Set_Output (File : in File_Type);
   procedure Set_Error (File : in File_Type);

   function Standard_Input return File_Type;
   function Standard_Output return File_Type;
   function Standard_Error return File_Type;

   function Current_Input return File_Type;
   function Current_Output return File_Type;
   function Current_Error return File_Type;

   --------------------------------------------
   -- Specification of line and page lengths --
   --------------------------------------------

   procedure Set_Line_Length (File : in File_Type; To : in Count);
   procedure Set_Line_Length (To : in Count);

   procedure Set_Page_Length (File : in File_Type; To : in Count);
   procedure Set_Page_Length (To : in Count);

   function Line_Length (File : in File_Type) return Count;
   function Line_Length return Count;

   function Page_Length (File : in File_Type) return Count;
   function Page_Length return Count;

   ------------------------------------
   -- Column, Line, and Page Control --
   ------------------------------------

   procedure New_Line (File : in File_Type;
                       Spacing : in Positive_Count := 1);
   procedure New_Line (Spacing : in Positive_Count := 1);

   procedure Skip_Line (File : in File_Type;
                        Spacing : in Positive_Count := 1);
   procedure Skip_Line (Spacing : in Positive_Count := 1);

   function End_Of_Line (File : in File_Type) return Boolean;
   function End_Of_Line return Boolean;

   procedure New_Page (File : in File_Type);
   procedure New_Page;

   procedure Skip_Page (File : in File_Type);
   procedure Skip_Page;

   function End_Of_Page (File : in File_Type) return Boolean;
   function End_Of_Page return Boolean;

   function End_Of_File (File : in File_Type) return Boolean;
   function End_Of_File return Boolean;

   procedure Set_Col (File : in File_Type;
                      To : in Positive_Count);
   procedure Set_Col (To : in Positive_Count);

   procedure Set_Line (File : in File_Type;
                       To : in Positive_Count);
   procedure Set_Line (To : in Positive_Count);

   function Col (File : in File_Type) return Positive_Count;
   function Col return Positive_Count;

   function Line (File : in File_Type) return Positive_Count;
   function Line return Positive_Count;

   function Page (File : in File_Type) return Positive_Count;
   function Page return Positive_Count;

   -----------------------------
   -- Characters Input-Output --
   -----------------------------

   procedure Get (File : in File_Type; Item : out Wide_Character);
   procedure Get (Item : out Wide_Character);
   procedure Put (File : in File_Type; Item : in Wide_Character);
   procedure Put (Item : in Wide_Character);

   --------------------------
   -- Strings Input-Output --
   --------------------------

   procedure Get (File : in File_Type; Item : out Wide_String);
   procedure Get (Item : out Wide_String);
   procedure Put (File : in File_Type; Item : in Wide_String);
   procedure Put (Item : in Wide_String);

   procedure Get_Line (File : in File_Type;
                       Item : out Wide_String;
                       Last : out Natural);

   procedure Get_Line (Item : out Wide_String; Last : out Natural);
   procedure Put_Line (File : in File_Type; Item : in Wide_String);
   procedure Put_Line (Item : in Wide_String);

   -----------------------------------
   -- Input-Output of Integer Types --
   -----------------------------------

   generic
      type Num is range <>;

   package Integer_Io is

      Default_Width : Field := 10;  --  Num'Width
      Default_Base  : Number_Base := 10;

      procedure Get (File  : in File_Type;
                     Item  : out Num;
                     Width : in Field := 0);

      procedure Get (Item  : out Num;
                     Width : in Field := 0);

      procedure Put (File  : in File_Type;
                     Item  : in Num;
                     Width : in Field := Default_Width;
                     Base  : in Number_Base := Default_Base);

      procedure Put (Item  : in Num;
                     Width : in Field := Default_Width;
                     Base  : in Number_Base := Default_Base);

      procedure Get (From : in Wide_String;
                     Item : out Num;
                     Last : out Positive);

      procedure Put (To   : out Wide_String;
                     Item : in Num;
                     Base : in Number_Base := Default_Base);
   end Integer_Io;

   -----------------------------------
   -- Input-Output of Modular Types --
   -----------------------------------

   --  Not yet implemented ???

   --  generic
   --      type Num is mod <>;

   --  package Modular_IO is

   --      Default_Width : Field := Num'Width;
   --      Default_Base  : Number_Base := 10;

   --      procedure Get (File  : in  File_Type;
   --                     Item  : out Num;
   --                     Width : in Field := 0);

   --      procedure Get (Item : out Num;
   --                     Width : in Field := 0);

   --      procedure Put (File  : in File_Type;
   --                     Item  : in Num;
   --                     Width : in Field := Default_Width;
   --                     Base  : in Number_Base := Default_Base);

   --      procedure Put (Item  : in Num;
   --                     Width : in Field := Default_Width;
   --                     Base  : in Number_Base := Default_Base);

   --      procedure Get (From : in  Wide_String;
   --                     Item : out Num;
   --                     Last : out Positive);

   --      procedure Put (To   : out Wide_String;
   --                     Item : in Num;
   --                     Base : in Number_Base := Default_Base);
   --
   --  end Modular_IO;

   --------------------------------
   -- Input-Output of Real Types --
   --------------------------------

   generic
      type Num is digits <>;

   package Float_Io is

      Default_Fore : Field := 2;
      Default_Aft  : Field := 5; --  Num'Digits - 1;
      Default_Exp  : Field := 3;

      procedure Get (File : in File_Type;
                     Item : out Num;
                     Width : in Field := 0);

      procedure Get (Item : out Num;
                     Width : in Field := 0);

      procedure Put (File : in File_Type;
                     Item : in Num;
                     Fore : in Field := Default_Fore;
                     Aft : in Field := Default_Aft;
                     Exp : in Field := Default_Exp);

      procedure Put (Item : in Num;
                     Fore : in Field := Default_Fore;
                     Aft  : in Field := Default_Aft;
                     Exp  : in Field := Default_Exp);

      procedure Get (From : in Wide_String;
                     Item : out Num;
                     Last : out Positive);

      procedure Put (To : out Wide_String;
                     Item : in Num;
                     Aft : in Field := Default_Aft;
                     Exp : in Field := Default_Exp);

   end Float_Io;

   --  Fixed point I/O not yet implemented ???

   --  generic
   --     type Num is delta <>;

   --  package Fixed_Io is
   --     Default_Fore : Field := Num'For;
   --     Default_Aft  : Field := Num'Aft;
   --     Default_Exp  : Field := 0;

   --    procedure Get (File  : in File_Type;
   --                   Item  : out Num;
   --                   Width : in Field := 0);

   --    procedure Get (Item : out Num; Width : in Field := 0);

   --    procedure Put (File : in File_Type;
   --                   Item : in Num;
   --                   Fore : in Field := Default_Fore;
   --                   Aft  : in Field := Default_Aft;
   --                   Exp  : in Field := Default_Exp);

   --    procedure Put (Item : in Num;
   --                   Fore : in Field := Default_Fore;
   --                   Aft  : in Field := Default_Aft;
   --                   Exp  : in Field := Default_Expr);

   --    procedure Get (From : in Wide_String;
   --                   Item : out Num;
   --                   Last : out Positive);

   --    procedure Put (To   : out Wide_String;
   --                   Item : in Num;
   --                   Aft  : in Field := Default_Aft;
   --                   Exp  : in Field := Default_Exp);
   --  end Fixed_Io;


   --  generic
   --     type Num is delta <> digits <>;

   --  package Decimal_IO is
   --
   --     Default_Fore : Field := Num'Fore;
   --     Default_Aft  : Field := Num'Aft;
   --     Default_Exp  : Field := 0;

   --     procedure Get (File  : in File_Type;
   --                    Item  : out Num;
   --                    Width : in Field := 0);

   --     procedure Get (Item  : out Num;
   --                    Width : in Field := 0);

   --     procedure Put (File : in File_Type;
   --                    Item : in Num;
   --                    Fore : in Field := Default_Fore;
   --                    Aft  : in Field := Default_Aft;
   --                    Exp  : in Field := Default_Exp);

   --     procedure Put (Item : in Num;
   --                    Fore : in Field := Default_Fore;
   --                    Aft  : in Field := Default_Aft;
   --                    Exp  : in Field := Default_Exp);

   --    procedure Get (From : in  Wide_String;
   --                   Item : out Num;
   --                   Last : out Positive);

   --     procedure Put (To   : out Wide_String;
   --                    Item : in Num;
   --                    Aft  : in Field := Default_Aft;
   --                    Exp  : in Field := Default_Exp);
   --  end Decimal_IO;

   ---------------------------------------
   -- Input-Output of Enumeration Types --
   ---------------------------------------

   generic
      type Enum is (<>);

   package Enumeration_Io is

      Default_Width : Field := 0;
      Default_Setting : Type_Set := Upper_Case;

      procedure Get (File : in File_Type;
                     Item : out Enum);

      procedure Get (Item : out Enum);

      procedure Put (File  : in File_Type;
                     Item  : in Enum;
                     Width : in Field := Default_Width;
                     Set   : in Type_Set := Default_Setting);

      procedure Put (Item  : in Enum;
                     Width : in Field := Default_Width;
                     Set   : in Type_Set := Default_Setting);

      procedure Get (From : in Wide_String;
                     Item : out Enum;
                     Last : out positive);

      procedure Put (To   : out Wide_String;
                     Item : in Enum;
                     Set  : in Type_Set := Default_Setting);
   end Enumeration_Io;

   --  Exceptions

   Status_Error : exception renames IO_Exceptions.Status_Error;
   Mode_Error   : exception renames IO_Exceptions.Mode_Error;
   Name_Error   : exception renames IO_Exceptions.Name_Error;
   Use_Error    : exception renames IO_Exceptions.Use_Error;
   Device_Error : exception renames IO_Exceptions.Device_Error;
   End_Error    : exception renames IO_Exceptions.End_Error;
   Data_Error   : exception renames IO_Exceptions.Data_Error;
   Layout_Error : exception renames IO_Exceptions.Layout_Error;

private
   type File_Ptr is mod 2#1#E32;

   type Pstring is access String;

   --  Ada File Control Block (Afcb)

   type AFCB is record
      AFCB_In_Use : Boolean;
      Desc        : File_Ptr;
      Name        : Pstring;
      Form        : Pstring;
      Mode        : File_Mode;
      Page        : Count;
      Line        : Count;
      Col         : Positive_Count;
      Line_Length : Count;
      Page_Length : Count;
      Count       : Integer;
      Look_Ahead  : String (1 .. 3);
   end record;

   type File_Type is access AFCB;

end Ada.Wide_Text_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:58:22 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Wed Jan 19 01:24:16 1994;  author: banner
--  Style conformance.
--  ----------------------------
--  revision 1.4
--  date: Thu May 12 14:04:22 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
