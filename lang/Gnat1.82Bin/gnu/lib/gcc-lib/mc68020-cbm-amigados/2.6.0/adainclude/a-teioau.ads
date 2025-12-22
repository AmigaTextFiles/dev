------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                      A D A . T E X T _ I O . A U X                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.17 $                             --
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

with System.Unsigned_Type; use System.Unsigned_Type;

private package Ada.Text_Io.Aux is

   Standard_In  : aliased File_Type;
   Standard_Out : aliased File_Type;
   Standard_Err : aliased File_Type;
   Current_In   : aliased File_Type;
   Current_Out  : aliased File_Type;
   Current_Err  : aliased File_Type;
   The_File     : File_Type;

   subtype LLF is Long_Long_Float;
   subtype LLI is Long_Long_Integer;
   subtype LLU is Long_Long_Unsigned;

   procedure Create
     (File : in out File_Type;
      Mode : in File_Mode := Out_File;
      Name : in String := "";
      Form : in String := "");

   procedure Open
     (File : in out File_Type;
      Mode : in File_Mode;
      Name : in String;
      Form : in String := "");

   procedure Close  (File : in out File_Type);
   procedure Delete (File : in out File_Type);
   procedure Reset  (File : in out File_Type; Mode : in File_Mode);

   function Mode (File : in File_Type) return File_Mode;
   function Name (File : in File_Type) return String;
   function Form (File : in File_Type) return String;

   function Is_Open (File : in File_Type) return Boolean;

   ------------------------------------------------------
   -- Control of default input, output and error files --
   ------------------------------------------------------

   procedure Set_Input  (File : in File_Type);
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
   procedure Set_Page_Length (File : in File_Type; To : in Count);

   function Line_Length (File : in File_Type) return Count;
   function Page_Length (File : in File_Type) return Count;

   ------------------------------------
   -- Column, Line, and Page Control --
   ------------------------------------

   procedure New_Line
     (File    : in File_Type;
      Spacing : in Positive_Count := 1);

   procedure Skip_Line
     (File    : in File_Type;
      Spacing : in Positive_Count := 1);

   function End_Of_Line (File : in File_Type) return Boolean;

   procedure New_Page  (File : in File_Type);
   procedure Skip_Page (File : in File_Type);

   function End_Of_Page  (File : in File_Type) return boolean;
   function End_Of_File  (File : in File_Type) return boolean;

   procedure Set_Col  (File : in File_Type; To : in Positive_Count);
   procedure Set_Line (File : in File_Type; To : in Positive_Count);

   function Col   (File : in File_Type) return Positive_Count;
   function Line  (File : in File_Type) return Positive_Count;
   function Page  (File : in File_Type) return Positive_Count;

   -----------------------------
   -- Characters Input-Output --
   -----------------------------

   procedure Get (Item : out Character);
   procedure Put (Item : in Character);

   --------------------------
   -- Strings Input-Output --
   --------------------------

   procedure Get (Item : out String);
   procedure Put (Item : in String);

   procedure Get_Line
     (File : in File_Type;
      Item : out String;
      Last : out Natural);

   procedure Put_Line
     (File : in File_Type;
      Item : in String);

   -----------------------------------
   -- Input-Output of Integer Types --
   -----------------------------------

   procedure Get_Int
     (Item  : out Integer;
      Width : in Field := 0);

   procedure Put_Integer
     (Item  : in Integer;
      Width : in Field;
      Base  : in Number_Base);

   procedure Put_LLI
     (Item  : in LLI;
      Width : in Field;
      Base  : in Number_Base);

   procedure Get_Int
     (From : in String;
      Item : out Integer;
      Last : out Positive);

   procedure Put_Integer
     (To   : out String;
      Item : in Integer;
      Base : in Number_Base);

   procedure Put_LLI
     (To   : out String;
      Item : in LLI;
      Base : in Number_Base);

   -----------------------------------
   -- Input-Output of Modular Types --
   -----------------------------------

   procedure Put_Unsigned
     (Item  : in Unsigned;
      Width : in Field;
      Base  : in Number_Base);

   procedure Put_LLU
     (Item  : in LLU;
      Width : in Field;
      Base  : in Number_Base);

   procedure Put_Unsigned
     (To   : out String;
      Item : in Unsigned;
      Base : in Number_Base);

   procedure Put_LLU
     (To   : out String;
      Item : in LLU;
      Base : in Number_Base);

   -----------------------------------
   -- Input-Output of Float Types   --
   -----------------------------------

   procedure Get_Float
     (Item : out LLF;
      Width : in Field);

   procedure Put_Float
     (Item : in LLF;
      Fore : in Field;
      Aft  : in Field;
      Exp  : in Field);

   procedure Get_Float
     (From : in String;
      Item : out LLF;
      Last : out Positive);

   procedure Put_Float
     (To   : out String;
      Item : in LLF;
      Aft  : in Field;
      Exp  : in Field);

   ---------------------------------------
   -- Input-Output of Enumeration Types --
   ---------------------------------------

   procedure Get_Enum
     (Str : out String;
      Len : out Positive);

   procedure Get_Enum
     (Str  : out String;
      From : in String;
      Len  : out Positive;
      Last : out Positive);

   procedure Put_Enum
     (Item  : in String;
      Width : in Field;
      Set   : in Type_Set);

   procedure Put_Enum
     (To   : out String;
      Item : in String;
      Set  : in Type_Set);

end Ada.Text_Io.Aux;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.15
--  date: Mon Aug 22 14:49:13 1994;  author: banner
--  remove Text_IO_Finalization which is no longer needed since the same
--   functionality is now accomplished much cleaner using finalization.
--  ----------------------------
--  revision 1.16
--  date: Thu Aug 25 17:41:51 1994;  author: banner
--  add subtype LLI for Long_Long_Integer
--  add subtype LLU for Long_Long_Unsigned
--  remove Default_Base_Int which is unused
--  remove Default_Width_Int which is unused
--  (Put_Int): renamed to Put_Integer
--  (Put_LLI): new procedure to support Long_Long_Integer
--  (Put_LLU): new procedure to support Modular_IO
--  (Put_Unsigned): new procedure to support Modular_IO
--  ----------------------------
--  revision 1.17
--  date: Mon Aug 29 23:41:47 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
