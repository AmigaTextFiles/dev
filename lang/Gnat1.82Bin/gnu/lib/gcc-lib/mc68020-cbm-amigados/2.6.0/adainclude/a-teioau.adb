------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                      A D A . T E X T _ I O . A U X                       --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.28 $                             --
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

with Ada.Finalization; use Ada.Finalization;
with System;           use System;
with System.Img_BIU;   use System.Img_BIU;
with System.Img_Int;   use System.Img_Int;
with System.Img_LLB;   use System.Img_LLB;
with System.Img_LLI;   use System.Img_LLI;
with System.Img_LLU;   use System.Img_LLU;
with System.Img_LLW;   use System.Img_LLW;
with System.Img_Real;  use System.Img_Real;
with System.Img_Uns;   use System.Img_Uns;
with System.Img_WIU;   use System.Img_WIU;

package body Ada.Text_IO.Aux is

   ----------------
   -- Local Data --
   ----------------

   Max_Num_Of_Files : constant := 60;

   Line_Feed : constant Character := Ascii.Lf;  --  Character'Val (16#0A#);
   Nul       : constant Character := Ascii.Nul; --  Character'Val (16#00#);
   Page_Mark : constant Character := Ascii.Ff;  --  Character'Val (16#0C#);

   --  The term "file" here is used in the same way as in the Ada Reference
   --  Manual, that is it refers to an object of some "file_type". Otherwise
   --  "external file" is used.

   Open_Files : array (1 .. Max_Num_Of_Files) of File_Type;
   --  Used to make sure we don't open too many files and that we do not
   --  open the same file twice.

   Scanning_From_File : Boolean;
   --  Determines if characters are read from a File (True) or String (False).

   type Temp_File_Rec;
   type Link is access Temp_File_Rec;

   type Temp_File_Rec is record
      File_Name : Pstring;
      Next      : Link;
   end record;

   Temp_Files : Link;

   type Work_String_Type is array (0 .. 1023) of Character;
   Work_String  : Work_String_Type;
   WS_Length    : Natural := 0;
   WS_Index1    : Natural := 0;
   WS_Index2    : Natural := 0;
   Tmp          : String (1 .. 1024);

   ------------------------
   --  Local Subprograms --
   ------------------------

   procedure Allocate_AFCB;
   --  Determine which AFCB in the Open_Files table is available to be used
   --  for the current file.

   function Alpha (C : Character) return Boolean;
   --  Predicate to test if Character argument is an upper or lower case
   --  letter, returns True if the argument is a letter, False if not.

   function Alphanum (C : Character) return Boolean;
   --  Predicate to test if Character is an upper or lower case letter
   --  or a digit. Returns True if the arguement is a letter or a digit,
   --  False if not.

   procedure Check_Digit;
   --  Assert that the next Character is a digit otherwise raise Data_Error.

   procedure Check_Extended_Digit;
   --  Assert that the next Character is an extended digit otherwise raise
   --  Data_Error.

   procedure Check_File_Open;
   --  Check if the current file is open or not. If the file is not open,
   --  then Status_Error is raised. Otherwise control returns normally.

   procedure Check_Hash (C : Character);
   --  Determine if next Character is matching hash, raise Data_Error if not.
   --  Stores '#' in Work_String.

   procedure Check_Multiple_File_Opens;

   procedure Check_Opened_Ok;
   --  Check that an Fopen succeeded, raise Name_Error if not

   procedure Check_Status_And_Mode (C_Mode : File_Mode);
   --  If the current file is not open, then Status_Error is raised. If
   --  the file is open, then the mode is checked against the argument which
   --  is the desired mode for the operation. If it does not match, then
   --  Mode_Error is raised, otherwise control returns normally.

   procedure Check_Status_And_Mode (C_Mode1, C_Mode2 : File_Mode);
   --  If the current file is not open, then Status_Error is raised. If
   --  the file is open, then the mode is checked against the arguments which
   --  are the desired modes for the operation. If it does not match either
   --  one of them, Mode_Error is raised, otherwise control returns normally.

   procedure Close_File;
   --  Close file and deallocate the AFCB back to the pool.

   procedure Copy_Integer;
   --  This procedure copies a string with the syntax of "based_Integer" from
   --  the input to the Work_String. Underscores are allowed but not copied.

   procedure Copy_Based_Integer;
   --  This procedure copies a string with the syntax of "based_Integer" from
   --  the input to the Work_String. Underscores are allowed but not copied.

   procedure Copyc;
   --  Copy the next input Character to Work_String using WS_Index2

   function Digit (C : Character) return Boolean;
   --  Predicate if C corresponds to the digits 0 thru 9.

   function Extended_Digit (C : Character) return Boolean;
   --  Predicate if C corresponds to the digits 0 thru 9 or letters A thru F.

   function Graphic (C : Character) return Boolean;
   --  Predicate to test if the Character is an Ascii graphic letter.
   --  True if the argument is an Ascii graphic character, False otherwise.

   function Getcp return Character;
   --  Gets the next Character from the string or file being scanned according
   --  to the setting of Scanning_From_File. In string mode, WS_Index1 is
   --  updated. If no more Characters remain to be scanned, End_Error is
   --  raised.

   function Get_Char return Character;
   --  Get the next character from the current text input file. If no
   --  character is available, End_Error is raised.

   function  Is_Keyboard (F : Text_IO.File_Type) return Boolean;
   --  Indicates whether the input represents a tty (keyboard) rather than
   --  a stored file.
   pragma Inline (Is_Keyboard);

   procedure Make_Temp_File_Name;
   --  Generate a unique file name and use it for the name of the current file.

   function Nextc return Character;
   --  Return the next Character to be read from the string file being
   --  scanned, according to the setting of Scanning_From_File. In string
   --  mode WS_Index1 is updated. If we are currently at the end of string
   --  then a line feed is returned.

   function Page_Is_Not_Terminated return Boolean;
   --  Indicates whether the current page of current file is not terminated.

   procedure Put_Blanks (N : Integer);
   --  Write N blanks to the output. There is no check for line overflow, it
   --  is assumed that the caller has already checked for this.

   procedure Put_Buffer
     (Width    : Integer;
      Pad_Type : Character;
      Length : Integer);
   --  Need documentation ???

   procedure Put_Line1;
   --  Outputs a line feed to the current text file

   procedure Put_Page;
   --  Write a page mark to current text file.

   procedure Load_Look_Ahead (End_Of_File_Flag : Boolean);
   --  This procedure loads the lookahead for a TEXT_IO input file, leaving
   --  CHARS set to 3 (unless the file is less than 3 bytes long), and CHAR1
   --  CHAR2 and CHAR3 containing the initial characters of the file. A special
   --  exception occurs when the standard input file is the keyboard in which
   --  case we only read 1 character because of interactive I/O except when
   --  load_look_ahead is called in the case of END_OF_FILE where we want to
   --  read 2 characters to check for the EOT character. The parameter to this
   --  routine end_of_file_flag is TRUE when processing for and END_OF_FILE
   --  situation and is FALSE otherwise.

   procedure Range_Error;
   --  Procedure called if scanned number is out of range.

   function Scan_Based_Int (Base : Integer) return Integer;
   --  Need documentation ???

   procedure Scan_Blanks;
   --  Routine to scan past leading blanks to find first non-blank.
   --  Leaves WS_Index1 pointing to first non-blank character.

   procedure Scan_Enum (Last : out Natural);
   --  Procedure to scan an Ada enumeration literal, which maybe an identifier
   --  or a character literal. The input may be from a file or from a string
   --  depending the setting of the Scanning_From_File flag. The result is
   --  stored in Work_String.

   function Scan_Int return Integer;
   --  This routine scans an Integer value from the string pointed by the
   --  global Integer WS_Index2. On exit WS_Index2 is updated to point to
   --  the first
   --  non-digit. The result returned is always negative. This allows the
   --  largest negative Integer value to be properly stored and converted.
   --  A value of +1 returned indicated that overflow occured.

   procedure Scan_Integer (Width : Integer; Result : out Integer);
   --  Procedure to scan an Ada Integer value and return the Integer result
   --  The parameter Width specifies the width of the field (zero means an
   --  unlimited scan). The input is from the current TEXT_IO input file.

   procedure Scan_Integer_String (Last : out Integer; Result : out Integer);
   --  Procedure to scan an ada integer value and store it in Result.
   --  The input is from the string stored in Work_String. Last is set to
   --  the count of Characters scanned.

   procedure Scan_Integer_Val (Fixed_Field : Boolean; Result : out Integer);
   --  Procedure to scan an Ada Integer value and return the Integer result.

   function Scan_Float (Width : Natural) return LLF;
   --  Procedure to scan an Ada float value and return the float result.
   --  The width specifies the width of the field(zero = unlimited scan).
   --  For this case, the input is from the current TEXT_IO input file.

   procedure Scan_Float_String (Last : out Integer; Result : out LLF);
   --  Procedure to scan an Ada float value and return the integer result.
   --  The width specifies the width of the field(zero = unlimited scan).
   --  For this case, the input is from the string stored in work_string. On
   --  return, last is the count of characters scanned minus one.

   function Scan_Float_Val (Fixed_Field : Boolean) return LLF;
   --  Procedure to scan an Ada float value and return the float result. The
   --  parameter num_type is a pointer to the type template for the float type.

   function Scan_Real_Val (Fixed_Field : Boolean) return LLF;
   --  Procedure to scan a real value and return the result as a double real.
   --  A range exception is signalled if the value is out of range of allowed
   --  Ada real values, but no other range check is made.

   procedure Setup_Fixed_Field (Width : Integer);
   --  This procedure is used for numeric conversions where the field to be
   --  scanned has a fixed width (i.e. width parameter is non-zero).
   --  It acquires the field from the input file and copies it to Work_String.
   --  It returns to the caller ready to scan the data from work_string.

   function Sign (C : Character) return Boolean;
   --  Predicate indicating whether character C is '+' or '-'

   procedure Skipc;
   --  This procedure skips the next input Character.

   procedure Test_Fixed_Field_End;
   --  this procedure is called after scanning an item from a fixed length
   --  field to ensure that only blanks remain in the field. An exception
   --  is raised if there are any unexpected non-blank Characters left in
   --  the field.

   function Upper_Case (C : Character) return Character;
   --  Converts character C to upper case if necessary

   procedure Unimplemented (Message : String) is
   begin
      Text_IO.Put (Message);
      Text_IO.Put_Line (" not implemented yet");
   end Unimplemented;

   procedure Word_Mul
     (A : Integer;
      B : Integer;
      O : out Boolean;
      R : out Integer);
   --  Multiply with overflow check (use until trapping arithmetic works).

   procedure Word_Sub
     (A : Integer;
      B : Integer;
      O : out Boolean;
      R : out Integer);
   --  Subtraction with overflow check (use until trapping arithmetic works)

   --  Interface with system calls

   procedure C_Fgetc
     (F      : Text_IO.File_Ptr;
      C      : out Character;
      Is_Eof : out Boolean);

   procedure Fclose (P : Text_IO.File_Ptr);

   function  Fopen (Name : String; Typ : File_Mode) return Text_IO.File_Ptr;

   procedure Fputc (F : Text_IO.File_Ptr; C : Character);

   function  Isatty (F : Text_IO.File_Ptr) return Boolean;

   function  Stdin return Text_IO.File_Ptr;

   function  Stdout return Text_IO.File_Ptr;

   function  Stderr return Text_IO.File_Ptr;

   procedure Unlink (Name : String);

   -----------
   -- Chars --
   -----------

   function Chars return Integer is
   begin
      return The_File.Count;
   end Chars;

   ---------------
   -- Set_Chars --
   ---------------

   procedure Set_Chars (Val : Integer) is
   begin
      The_File.Count := Val;
   end Set_Chars;

   -----------
   -- Char1 --
   -----------

   function Char1 return Character is
   begin
      return The_File.Look_Ahead (1);
   end Char1;

   ---------------
   -- Set_Char1 --
   ---------------

   procedure Set_Char1 (Val : Character) is
   begin
      The_File.Look_Ahead (1) := Val;
   end Set_Char1;

   -----------
   -- Char2 --
   -----------

   function Char2 return Character is
   begin
      return The_File.Look_Ahead (2);
   end Char2;

   ---------------
   -- Set_Char2 --
   ---------------

   procedure Set_Char2 (Val : Character) is
   begin
      The_File.Look_Ahead (2) := Val;
   end Set_Char2;

   -----------
   -- Char3 --
   -----------

   function Char3 return Character is
   begin
      return The_File.Look_Ahead (3);
   end Char3;

   ---------------
   -- Set_Char3 --
   ---------------

   procedure Set_Char3 (Val : Character) is
   begin
      The_File.Look_Ahead (3) := Val;
   end Set_Char3;

   ------------
   -- Create --
   ------------

   procedure Create
     (File : in out File_Type;
      Mode : in File_Mode := Out_File;
      Name : in String := "";
      Form : in String := "") is

   begin
      The_File := File;

      if The_File /= null then
         raise Status_Error; --  File already open
      elsif Mode = In_File then
         raise Use_Error;    -- Unsupported file access
      end if;

      Allocate_AFCB;
      The_File.Name := new String'(Name);
      The_File.Form := new String'(Form);
      The_File.Mode := Mode;

      if Name'Length = 0 then
         Make_Temp_File_Name;
      end if;

      Check_Multiple_File_Opens;
      The_File.AFCB_In_Use := True;
      The_File.Desc := Fopen (The_File.Name.all, Mode);
      Check_Opened_Ok;

      The_File.Page := 1;
      The_File.Line := 1;
      The_File.Col := 1;
      The_File.Line_Length := 0;
      The_File.Page_Length := 0;
      File := The_File;
   end Create;

   ----------
   -- Open --
   ----------

   procedure Open
     (File : in out File_Type;
      Mode : in File_Mode;
      Name : in String;
      Form : in String := "")
   is
   begin
      The_File := File;

      if The_File /= null then
         raise Status_Error; --  File already open
      end if;

      Allocate_AFCB;
      The_File.Name := new String'(Name);
      The_File.Form := new String'(Form);
      The_File.Mode := Mode;

      if Name'Length = 0 then
         Make_Temp_File_Name;
      end if;

      Check_Multiple_File_Opens;
      The_File.AFCB_In_Use := True;

      The_File.Desc := Fopen (Name, Mode);
      Check_Opened_Ok;
      if Mode = In_File then
         Set_Chars (0);
      end if;

      The_File.Page := 1;
      The_File.Line := 1;
      The_File.Col := 1;
      The_File.Line_Length := 0;
      The_File.Page_Length := 0;
      The_File.Is_Keyboard := False;
      File := The_File;
   end Open;

   -----------
   -- Close --
   -----------

   procedure Close (File : in out File_Type) is
   begin
      The_File := File;
      Check_File_Open;

      if The_File.Mode = Out_File or else The_File.Mode = Append_File then

         --  Simulate effect of NEW_PAGE unless current page is terminated

         if Page_Is_Not_Terminated then
            if The_File.Col > 1
              or else (The_File.Col = 1 and then The_File.Line = 1)
            then
               Put_Line1;
            end if;

            Put_Page;
         end if;
      end if;

      --  If the file being closed is one of the default files, set the default
      --  file indicator to null to indicate that the file is closed.

      if The_File = Current_In then
         Current_In := null;
      elsif The_File = Current_Out then
         Current_Out := null;
      elsif The_File = Current_Err then
         Current_Err := null;
      end if;

      --  Sever the association between the given file and its associated
      --  external file. The given file is left closed. Do not perform system
      --  closes on the standard input, output and error files.

      if The_File /= Standard_In
        and then The_File /= Standard_Out
        and then The_File /= Standard_Err
      then
         Close_File;
      end if;

      The_File := null;
      File := The_File;
   end Close;

   ------------
   -- Delete --
   ------------

   procedure Delete (File : in out File_Type) is
      File_Name_To_Delete : Pstring;

   begin
      The_File := File;
      Check_File_Open;
      File_Name_To_Delete := new String'(The_File.Name.all);
      Close (The_File);
      Unlink (File_Name_To_Delete.all);
      File := The_File;
   end Delete;

   -----------
   -- Reset --
   -----------

   procedure Reset
     (File : in out File_Type;
      Mode : in File_Mode)
   is
   begin
      The_File := File;
      Check_File_Open;

      if (The_File = Current_In
           or else The_File = Current_Out
           or else The_File = Current_Err)
        and then The_File.Mode /= Mode
      then
         raise Mode_Error;  --  "Cannot change mode"
      end if;

      if The_File.Mode = Out_File or else The_File.Mode = Append_File then

         --  Simulate NEW_PAGE unless current page already terminated

         if Page_Is_Not_Terminated then
            if The_File.Col > 1
              or else (The_File.Col = 1 and then The_File.Line = 1)
            then
               Put_Line1;
            end if;

            Put_Page;
         end if;
      end if;

      Fclose (The_File.Desc);

      The_File.Desc := Fopen (The_File.Name.all, Mode);
      Check_Opened_Ok;

      if Mode /= In_File then
         The_File.Line_Length := 0;
         The_File.Page_Length := 0;
      end if;

      The_File.Mode := Mode;
      Set_Chars (0);
      The_File.Col  := 1;
      The_File.Line := 1;
      The_File.Page := 1;
      File := The_File;
   end Reset;

   ----------
   -- Mode --
   ----------

   function Mode (File : in File_Type) return File_Mode is
   begin
      The_File := File;
      Check_File_Open;
      return The_File.Mode;
   end Mode;

   ----------
   -- Name --
   ----------

   function Name (File : in File_Type) return String is
   begin
      The_File := File;
      Check_File_Open;
      return The_File.Name.all;
   end Name;

   ----------
   -- Form --
   ----------

   function Form (File : in File_Type) return String is
   begin
      The_File := File;
      Check_File_Open;
      return The_File.Form.all;
   end Form;

   -------------
   -- Is_Open --
   -------------

   function Is_Open (File : in File_Type) return Boolean is
   begin
      The_File := File;
      return The_File /= null;
   end Is_Open;

   ---------------
   -- Set_Input --
   ---------------

   procedure Set_Input (File : in File_Type) is
   begin
      The_File := File;
      Check_Status_And_Mode (In_File);
      Current_In := The_File;
   end Set_Input;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output (File : in File_Type) is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);
      Current_Out := The_File;
   end Set_Output;

   ---------------
   -- Set_Error --
   ---------------

   procedure Set_Error (File : in File_Type) is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);
      Current_Err := The_File;
   end Set_Error;

   --------------------
   -- Standard_Input --
   --------------------

   function Standard_Input return File_Type is
   begin
      return Standard_In;
   end Standard_Input;

   ---------------------
   -- Standard_Output --
   ---------------------

   function Standard_Output return File_Type is
   begin
      return Standard_Out;
   end Standard_Output;

   --------------------
   -- Standard_Error --
   --------------------

   function Standard_Error return File_Type is
   begin
      return Standard_Err;
   end Standard_Error;

   -------------------
   -- Current_Input --
   -------------------

   function Current_Input return File_Type is
   begin
      return Current_In;
   end Current_Input;

   --------------------
   -- Current_Output --
   --------------------

   function Current_Output return File_Type is
   begin
      return Current_Out;
   end Current_Output;

   -------------------
   -- Current_Error --
   -------------------

   function Current_Error return File_Type is
   begin
      return Current_Err;
   end Current_Error;

   ---------------------
   -- Set_Line_Length --
   ---------------------

   procedure Set_Line_Length (File : in File_Type; To : in Count) is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);
      The_File.Line_Length := To;
   end Set_Line_Length;

   -----------------
   -- Line_Length --
   -----------------

   function Line_Length (File : in File_Type) return Count is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);
      return The_File.Line_Length;
   end Line_Length;

   ---------------------
   -- Set_Page_Length --
   ---------------------

   procedure Set_Page_Length (File : in File_Type; To : in Count) is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);
      The_File.Page_Length := To;
   end Set_Page_Length;

   -----------------
   -- Page_Length --
   -----------------

   function Page_Length (File : in File_Type) return Count is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);
      return The_File.Page_Length;
   end Page_Length;

   --------------
   -- New_Line --
   --------------

   procedure New_Line
     (File    : in File_Type;
      Spacing : in Positive_Count := 1)
   is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);

      for J in 1 .. Spacing loop
         Put_Line1;
      end loop;
   end New_Line;

   ---------------
   -- Skip_Line --
   ---------------

   procedure Skip_Line
     (File    : in File_Type;
      Spacing : in Positive_Count := 1)
   is
      C : Character;

   begin
      The_File := File;
      Check_Status_And_Mode (In_File);

      for J in 1 .. Spacing loop
         loop
            Load_Look_Ahead (False);
            exit when Get_Char = Line_Feed;
         end loop;

         --  Ignore page marks when reading from a terminal.

         if Is_Keyboard (The_File) then
            return;
         end if;

         loop
            Load_Look_Ahead (False);
            exit when Char1 /= Page_Mark;
            C := Get_Char;
         end loop;
      end loop;
   end Skip_Line;

   -----------------
   -- End_Of_Line --
   -----------------

   function End_Of_Line (File : in File_Type) return boolean is
   begin
      The_File := File;
      Check_Status_And_Mode (In_File);
      Load_Look_Ahead (False);
      return Chars = 0 or else Char1 = Line_Feed;
   end End_Of_Line;

   --------------
   -- New_Page --
   --------------

   procedure New_Page (File : in File_Type) is
   begin
      The_File := File;
      Check_Status_And_Mode (Out_File, Append_File);

      if The_File.Col > 1
       or else (The_File.Col = 1 and then The_File.Line = 1)
      then
         Put_Line1;
      end if;

      Put_Page;
   end New_Page;

   ---------------
   -- Skip_Page --
   ---------------

   procedure Skip_Page (File : in File_Type) is
   begin
      The_File := File;
      Check_Status_And_Mode (In_File);

      while Get_Char /= Page_Mark loop
         null;
      end loop;
   end Skip_Page;

   -----------------
   -- End_Of_Page --
   -----------------

   function End_Of_Page (File : in File_Type) return Boolean is
   begin
      The_File := File;
      Check_Status_And_Mode (In_File);

      if Is_Keyboard (The_File) then
         return False;
      end if;

      Load_Look_Ahead (False);

      if Chars > 1 then
         return Char1 = Line_Feed and then Char2 = Page_Mark;
      elsif Chars = 1 then
         return Char1 = Line_Feed;
      else
         return True;
      end if;
   end End_Of_Page;

   -----------------
   -- End_Of_File --
   -----------------

   function End_Of_File (File : in File_Type) return Boolean is
   begin
      The_File := File;
      Check_Status_And_Mode (In_File);
      Load_Look_Ahead (True);

      if Is_Keyboard (The_File) then
         if Chars = 2 then
            return False;
         elsif Chars = 1 then
            return Char1 = Line_Feed;
         elsif Chars = 0 then
            return True;
         end if;
      else
         if Chars = 2 then
            return Char1 = Line_Feed and then Char2 = Page_Mark;
         elsif Chars = 1 then
            return Char1 = Line_Feed;
         elsif Chars = 0 then
            return True;
         else --  Chars = 3
            return False;
         end if;
      end if;
   end End_Of_File;

   -------------
   -- Set_Col --
   -------------

   procedure Set_Col (File : in File_Type; To : in Positive_Count) is
      C : Character;

   begin
      The_File := File;
      Check_File_Open;

      if The_File.Mode = In_File then

         --  SET_COL for file of mode In_File

         Load_Look_Ahead (False);

         while The_File.Col /= To
           or else Char1 = Line_Feed
           or else Char1 = Page_Mark
         loop
            C := Get_Char;
         end loop;

      else

         --  SET_COL for file of mode Out_File or Append_File

         if The_File.Line_Length > 0
           and then To > The_File.Line_Length
         then
            raise Layout_Error; --  "SET_COL past end of line"
         end if;

         if To > The_File.Col then
            Put_Blanks (Integer (To - The_File.Col));
            The_File.Col := To;
         elsif To < The_File.Col then
            Put_Line1;
            Put_Blanks (Integer (To - 1));
            The_File.Col := To;
         end if;
      end if;
   end Set_Col;

   --------------
   -- Set_Line --
   --------------

   procedure Set_Line (File : in File_Type; To : in Positive_Count) is
      C : Character;

   begin
      The_File := File;
      Check_File_Open;

      if The_File.Mode = In_File then

         --  SET_LINE for file of mode In_File

         Load_Look_Ahead (False);

         while The_File.Line /= To
           or else Char1 = Page_Mark
         loop
            C := Get_Char;
         end loop;

      else

         --  SET_LINE for file of mode Out_File or Append_File

         if The_File.Page_Length > 0
           and then To > The_File.Page_Length
         then
            raise Layout_Error;  --  "Set_Line > Page_Length"
         end if;

         if To > The_File.Line  then
            for I in 1 .. To - The_File.Line loop
               Put_Line1;
            end loop;

         elsif To < The_File.Line then
            if The_File.Col > 1
              or else (The_File.Col = 1 and then The_File.Line = 1)
            then
               Put_Line1;
            end if;

            Put_Page;

            for J in 1 .. To - 1 loop
               Put_Line1;
            end loop;
         end if;
      end if;
   end Set_Line;

   ---------
   -- Col --
   ---------

   function Col (File : in File_Type) return Positive_Count is
   begin
      The_File := File;
      Check_File_Open;

      if The_File.Col > Count'Last then
         raise Layout_Error; --  "Col > Count'Last"
      end if;

      return The_File.Col;
   end Col;

   ----------
   -- Line --
   ----------

   function Line (File : in File_Type) return Positive_Count is
   begin
      The_File := File;
      Check_File_Open;

      if The_File.Line > Count'Last then
         raise Layout_Error; --  "Line > Count'Last"
      end if;

      return The_File.Line;
   end Line;

   ----------
   -- Page --
   ----------

   function Page (File : in File_Type) return Positive_Count is
   begin
      The_File := File;
      Check_File_Open;

      if The_File.Page > Count'Last then
         raise Layout_Error; --  "Page > Count'Last"
      end if;

      return The_File.Page;
   end Page;

   ---------
   -- Get --
   ---------

   procedure Get (Item : out Character) is
   begin
      Check_Status_And_Mode (In_File);

      loop
         Item := Get_Char;
         exit when Item /= Page_Mark and then Item /= Line_Feed;
      end loop;
   end Get;

   ---------
   -- Put --
   ---------

   procedure Put (Item : in Character) is
   begin
      Check_Status_And_Mode (Out_File, Append_File);

      if The_File.Line_Length /= 0
        and then The_File.Col > The_File.Line_Length
      then
         Put_Line1;
      end if;

      Fputc (The_File.Desc, Item);
      The_File.Col := The_File.Col + 1;
   end Put;

   ---------
   -- Get --
   ---------

   procedure Get (Item : out String) is
      J : Integer := 0;
      C : Character;

   begin
      Check_Status_And_Mode (In_File);

      while J < Item'Length loop
         C := Get_Char;

         if C /= Line_Feed and then C /= Page_Mark then
            Item (Item'First + J) := C;
            J := J + 1;
         end if;
      end loop;
   end Get;

   ---------
   -- Put --
   ---------

   procedure Put (Item : in String) is
   begin
      for J in Item'range loop
         Put (Item (J));
      end loop;
   end Put;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line (File : in File_Type; Item : in String) is
   begin
      The_File := File;
      Put (Item);
      New_Line (File, 1);
   end Put_Line;

   --------------
   -- Get_Line --
   --------------

   procedure Get_Line
     (File : in File_Type;
      Item : out String;
      Last : out Natural)
   is
      I_Length : Integer := Item'Length;
      Nstore   : Integer := 0;

   begin
      The_File := File;
      Check_Status_And_Mode (In_File);

      loop
         Load_Look_Ahead (False);
         exit when Nstore = I_Length;

         if Char1 = Line_Feed then
            Skip_Line (File, 1);
            exit;
         end if;

         Item (Item'First + Nstore) := Get_Char;
         Nstore := Nstore + 1;
      end loop;

      Last := Item'First + Nstore - 1;
   end Get_Line;

   -------------
   -- Get_Int --
   -------------

   procedure Get_Int
     (Item  : out Integer;
      Width : in Field := 0)
   is
   begin
      Check_Status_And_Mode (In_File);
      Scan_Integer (Width, Item);
   end Get_Int;

   -----------------
   -- Put_Integer --
   -----------------

   procedure Put_Integer
     (Item  : in Integer;
      Width : in Field;
      Base  : in Number_Base)
   is
   begin
      Check_Status_And_Mode (Out_File, Append_File);
      WS_Length := 0;

      if Base = 10 and then Width = 0 then
         Set_Image_Integer (Item, Tmp, WS_Length);
      elsif Base = 10 then
         Set_Image_Width_Integer (Item, Width, Tmp, WS_Length);
      else
         Set_Image_Based_Integer (Item, Base, Width, Tmp, WS_Length);
      end if;

      for J in 1 .. WS_Length loop
         Work_String (J - 1) := Tmp (J);
      end loop;

      Put_Buffer (Width, 'L', WS_Length);
   end Put_Integer;

   -------------
   -- Put_LLI --
   -------------

   procedure Put_LLI
     (Item  : in LLI;
      Width : in Field;
      Base  : in Number_Base)
   is
   begin
      Check_Status_And_Mode (Out_File, Append_File);
      WS_Length := 0;

      if Base = 10 and then Width = 0 then
         Set_Image_Long_Long_Integer (Item, Tmp, WS_Length);
      elsif Base = 10 then
         Set_Image_Width_Long_Long_Integer (Item, Width, Tmp, WS_Length);
      else
         Set_Image_Based_Long_Long_Integer (Item, Base, Width, Tmp, WS_Length);
      end if;

      for J in 1 .. WS_Length loop
         Work_String (J - 1) := Tmp (J);
      end loop;

      Put_Buffer (Width, 'L', WS_Length);
   end Put_LLI;

   -------------
   -- Get_Int --
   -------------

   procedure Get_Int
     (From : in String;
      Item : out Integer;
      Last : out Positive)
   is
   begin
      WS_Length := From'Length;

      for J in 0 .. WS_Length - 1 loop
         Work_String (J) := From (From'First + J);
      end loop;

      Work_String (WS_Length) := ' ';
      WS_Index1 := 0;
      Scan_Integer_String (Last, Item);
      Last := From'First + Last - 1;
   end Get_Int;

   -----------------
   -- Put_Integer --
   -----------------

   procedure Put_Integer
     (To   : out String;
      Item : in Integer;
      Base : in Number_Base)
   is
      Length : Natural := 0;
      To_Len : Natural := To'Length;

   begin
      if Base = 10 then
         Set_Image_Width_Integer (Item, To_Len, Tmp, Length);
      else
         Set_Image_Based_Integer (Item, Base, To_Len, Tmp, Length);
      end if;

      if Length > To_Len then
         raise Layout_Error;
      end if;

      for J in 1 .. Length loop
         To (To'First + J - 1) := Tmp (J);
      end loop;

   end Put_Integer;

   -------------
   -- Put_LLI --
   -------------

   procedure Put_LLI
     (To   : out String;
      Item : in LLI;
      Base : in Number_Base)
   is
      Length : Natural := 0;
      To_Len : Natural := To'Length;

   begin
      if Base = 10 then
         Set_Image_Width_Long_Long_Integer (Item, To_Len, Tmp, Length);
      else
         Set_Image_Based_Long_Long_Integer (Item, Base, To_Len, Tmp, Length);
      end if;

      if Length > To_Len then
         raise Layout_Error;
      end if;

      for J in 1 .. Length loop
         To (To'First + J - 1) := Tmp (J);
      end loop;

   end Put_LLI;

   ------------------
   -- Put_Unsigned --
   ------------------

   procedure Put_Unsigned
     (Item  : in Unsigned;
      Width : in Field;
      Base  : in Number_Base)
   is
   begin
      Check_Status_And_Mode (Out_File, Append_File);
      WS_Length := 0;

      if Base = 10 and then Width = 0 then
         Set_Image_Unsigned (Item, Tmp, WS_Length);
      elsif Base = 10 then
         Set_Image_Width_Unsigned (Item, Width, Tmp, WS_Length);
      else
         Set_Image_Based_Unsigned (Item, Base, Width, Tmp, WS_Length);
      end if;

      for J in 1 .. WS_Length loop
         Work_String (J - 1) := Tmp (J);
      end loop;

      Put_Buffer (Width, 'L', WS_Length);
   end Put_Unsigned;

   -------------
   -- Put_LLU --
   -------------

   procedure Put_LLU
     (Item  : in LLU;
      Width : in Field;
      Base  : in Number_Base)
   is
   begin
      Check_Status_And_Mode (Out_File, Append_File);
      WS_Length := 0;

      if Base = 10 and then Width = 0 then
         Set_Image_Long_Long_Unsigned (Item, Tmp, WS_Length);
      elsif Base = 10 then
         Set_Image_Width_Long_Long_Unsigned (Item, Width, Tmp, WS_Length);
      else
         Set_Image_Based_Long_Long_Unsigned
           (Item, Base, Width, Tmp, WS_Length);
      end if;

      for J in 1 .. WS_Length loop
         Work_String (J - 1) := Tmp (J);
      end loop;

      Put_Buffer (Width, 'L', WS_Length);
   end Put_LLU;

   ------------------
   -- Put_Unsigned --
   ------------------

   procedure Put_Unsigned
     (To   : out String;
      Item : in Unsigned;
      Base : in Number_Base)
   is
      Length : Natural := 0;
      To_Len : Natural := To'Length;

   begin
      if Base = 10 then
         Set_Image_Width_Unsigned (Item, To_Len, Tmp, Length);
      else
         Set_Image_Based_Unsigned (Item, Base, To_Len, Tmp, Length);
      end if;

      if Length > To_Len then
         raise Layout_Error;
      end if;

      for J in 1 .. Length loop
         To (To'First + J - 1) := Tmp (J);
      end loop;

   end Put_Unsigned;

   -------------
   -- Put_LLU --
   -------------

   procedure Put_LLU
     (To   : out String;
      Item : in LLU;
      Base : in Number_Base)
   is
      Length : Natural := 0;
      To_Len : Natural := To'Length;

   begin
      if Base = 10 then
         Set_Image_Width_Long_Long_Unsigned (Item, To_Len, Tmp, Length);
      else
         Set_Image_Based_Long_Long_Unsigned (Item, Base, To_Len, Tmp, Length);
      end if;

      if Length > To_Len then
         raise Layout_Error;
      end if;

      for J in 1 .. Length loop
         To (To'First + J - 1) := Tmp (J);
      end loop;
   end Put_LLU;

   ---------------
   -- Get_Float --
   ---------------

   procedure Get_Float
     (Item : out LLF;
      Width : in Field)
   is
   begin
      Check_Status_And_Mode (In_File);
      Item := Scan_Float (Width);
   end Get_Float;

   ---------------
   -- Put_Float --
   ---------------

   procedure Put_Float
     (Item : in LLF;
      Fore : in Field;
      Aft  : in Field;
      Exp  : in Field)
   is
      Temp : String (1 .. 1024);
   begin
      Check_Status_And_Mode (Out_File, Append_File);
      WS_Length := 0;
      Set_Image_Real (Item, Temp, WS_Length, Fore, Aft, Exp);

      for J in 1 .. WS_Length loop
         Work_String (J - 1) := Temp (J);
      end loop;

      Put_Buffer (WS_Length, 'L', WS_Length);
   end Put_Float;

   ---------------
   -- Get_Float --
   ---------------

   procedure Get_Float
     (From : in String;
      Item : out LLF;
      Last : out Positive)
   is
   begin
      WS_Length := From'Length;

      for J in 0 .. WS_Length - 1 loop
         Work_String (J) := From (From'First + J);
      end loop;

      Work_String (WS_Length) := ' ';
      WS_Index1 := 0;
      Scan_Float_String (Last, Item);
      Last := From'First + Last - 1;
   end Get_Float;

   ---------------
   -- Put_Float --
   ---------------

   procedure Put_Float
     (To   : out String;
      Item : in LLF;
      Aft  : in Field;
      Exp  : in Field)
   is
      Length : Natural := 0;
      To_Len : Natural := To'Length;
      Temp   : String (1 .. 1024);
      --  ??? what is the 1024 here? should be symbolic

   begin
      Set_Image_Real (Item, Temp, Length, 0, Aft, Exp);

      if Length > To_Len then
         raise Layout_Error;
      end if;

      for J in 0 .. To_Len - Length - 1 loop
         To (To'First + J) :=  ' ';
      end loop;

      for J in 1 .. Length loop
         To (To'First + J - 1 + To_Len - Length) := Temp (J);
      end loop;
   end Put_Float;

   --------------
   -- Get_Enum --
   --------------

   procedure Get_Enum (Str : out String; Len : out Positive) is
      Last : Natural;

   begin
      Check_Status_And_Mode (In_File);
      Scanning_From_File := True;
      Scan_Enum (Last);

      for J in 1 .. WS_Length loop
         Str (J) := Upper_Case (Work_String (J - 1));
      end loop;

      Len := WS_Length;
   end Get_Enum;

   --------------
   -- Get_Enum --
   --------------

   procedure Get_Enum
     (Str  : out String;
      From : in String;
      Len  : out Positive;
      Last : out Positive)
   is
   begin
      WS_Length := From'Length;

      for J in 0 .. WS_Length - 1 loop
         Work_String (J) := From (From'First + J);
      end loop;

      WS_Index1 := 0;
      Scanning_From_File := False;
      Scan_Enum (Last);
      Last := From'First + Last - 1;

      for J in 1 .. WS_Length loop
         Str (J) := Upper_Case (Work_String (J - 1));
      end loop;

      Len := WS_Length;
   end Get_Enum;

   --------------
   -- Put_Enum --
   --------------

   procedure Put_Enum
     (Item  : in String;
      Width : in Field;
      Set   : in Type_Set)
   is
      C : Character;

   begin
      Check_Status_And_Mode (Out_File, Append_File);
      WS_Length := Item'Length;

      for J in 0 .. WS_Length - 1 loop
         C := Item (Item'First + J);

         --  This is wrong, must use proper casing stuff in strings packages
         --  ???

         if Set = Lower_Case and then C in 'A' .. 'Z' then
            Work_String (J) := Character'Val (Character'Pos (C) + 32);
         else
            Work_String (J) := C;
         end if;
      end loop;

      Put_Buffer (Width, 'T', WS_Length);
   end Put_Enum;

   --------------
   -- Put_Enum --
   --------------

   procedure Put_Enum
     (To   : out String;
      Item : in String;
      Set  : in Type_Set)
   is
      Length : Integer := Item'Length;
      C      : Character;

   begin
      if Length > To'Length then
         raise Layout_Error;
      else
         for J in 0 .. Length - 1 loop
            C := Item (Item'First + J);

            --  This is wrong, must use proper casing stuff in strings
            --  packages ???

            if Set = Lower_Case and then C in 'A' .. 'Z' then
               To (To'First + J) := Character'Val (Character'Pos (C) + 32);
            else
               To (To'First + J) := C;
            end if;
         end loop;

         for J in Length .. To'Length - 1 loop
            To (To'First + J) := ' ';
         end loop;
      end if;
   end Put_Enum;

   --------------
   -- Put_Page --
   --------------

   procedure Put_Page is
   begin
      Fputc (The_File.Desc, Page_Mark);
      The_File.Page := The_File.Page + 1;
      The_File.Line := 1;
      The_File.Col := 1;
   end Put_Page;

   ---------------
   -- Put_Line1 --
   ---------------

   procedure Put_Line1 is
   begin
      Fputc (The_File.Desc, Line_Feed);
      The_File.Col := 1;

      if The_File.Page_Length > 0
         and The_File.Line >= The_File.Page_Length
      then
         Put_Page;
      else
         The_File.Line := The_File.Line + 1;
      end if;
   end Put_Line1;

   ---------------------
   -- Check_Opened_Ok --
   ---------------------

   procedure Check_Opened_Ok is
   begin
      if The_File.Desc = 0 then
         raise Name_Error; --  Error opening file due to invalid name
      end if;
   end Check_Opened_Ok;

   ---------------------
   -- Check_File_Open --
   ---------------------

   procedure Check_File_Open is
   begin
      --  There are two ways a file can appear closed. Either it is null
      --  which indicates that it was not used as an argument of an Open_Create
      --  call or it is not null but its Is_Open field is False which indicates
      --  that the file was used in an Open/Create but subsequently was closed.

      if The_File = null then
         raise Status_Error; --  File not open
      end if;
   end Check_File_Open;

   ---------------------------
   -- Check_Status_And_Mode --
   ---------------------------

   procedure Check_Status_And_Mode (C_Mode : File_Mode) is
   begin
      Check_File_Open;

      if The_File.Mode /= C_Mode then
         raise Mode_Error;
      end if;
   end Check_Status_And_Mode;

   ---------------------------
   -- Check_Status_And_Mode --
   ---------------------------

   procedure Check_Status_And_Mode (C_Mode1, C_Mode2 : File_Mode) is
   begin
      Check_File_Open;

      if The_File.Mode /= C_Mode1 and then The_File.Mode /= C_Mode2 then
         raise Mode_Error;
      end if;
   end Check_Status_And_Mode;

   -------------------
   -- Allocate_AFCB --
   --------------------

   procedure Allocate_AFCB is
      File_Num : Integer := Open_Files'First;

   begin
      --  Loop through the array of AFCBs stopping at the first vacate spot
      --  that is not currently being used.

      while File_Num <= Max_Num_Of_Files
        and then Open_Files (File_Num) /= null
        and then Open_Files (File_Num).AFCB_In_Use
      loop
         File_Num := File_Num + 1;
      end loop;

      --  No vacant spots were available since too many file are open

      if File_Num > Max_Num_Of_Files then
         raise Use_Error;  --  Too many files open
      end if;

      if Open_Files (File_Num) = null then
         Open_Files (File_Num) := new AFCB;
      end if;

      The_File := Open_Files (File_Num);
   end Allocate_AFCB;

   -------------------------
   -- Make_Temp_File_Name --
   -------------------------

   procedure Make_Temp_File_Name is
      Temp_File_Name  : String (1 .. 14);
      --  The template for temporary file name creation using Mktemp.

      procedure mktemp (S : Address);
      pragma Import (C, mktemp);
      --  mktemp creates a unique temporary file name given the address of
      --  a null terminated template.

   begin
      --  Create a template string which the call to mktemp will fill in to
      --  generate unique name file name.

      Temp_File_Name (1 .. 13) := "ADATEMPXXXXXX";
      Temp_File_Name (14) := Ascii.Nul;
      mktemp (Temp_File_Name'Address);
      The_File.Name := new String'(Temp_File_Name (1 .. 13));

      --  Append the name of the temporary file to the beginning of the
      --  Temp_File list which will be used for deleting all the temporary
      --  files after completion of the main program.

      Temp_Files := new Temp_File_Rec'(The_File.Name, Temp_Files);
   end Make_Temp_File_Name;

   -------------------------------
   -- Check_Multiple_File_Opens --
   -------------------------------

   procedure Check_Multiple_File_Opens is
   begin
      --  Allow a several opens to read an external file, but not one open to
      --  read and another open to write a external file.

      for J in Open_Files'range loop
         if Open_Files (J) /= null and then Open_Files (J).AFCB_In_Use then
            if The_File.Name.all = Open_Files (J).Name.all
              and then (The_File.Mode /= In_File
                         or else Open_Files (J).Mode /= In_File)
            then
               raise Use_Error; --  File already open
            end if;
         end if;
      end loop;
   end Check_Multiple_File_Opens;

   -----------------------------
   --  Page_Is_Not_Terminated --
   -----------------------------

   function Page_Is_Not_Terminated return Boolean is
   begin
      return not (The_File.Col = 1
        and then The_File.Line = 1
        and then The_File.Page /= 1);
   end Page_Is_Not_Terminated;

   ----------------
   -- Close_File --
   ----------------

   procedure Close_File is
      procedure Fclose (F : Text_IO.File_Ptr);
      pragma Import (C, fclose);

      File_Num : Integer := Open_Files'First;

   begin
      while File_Num <= Max_Num_Of_Files
         and then Open_Files (File_Num) /= The_File
      loop
         File_Num := File_Num + 1;
      end loop;

      if File_Num > Max_Num_Of_Files then
         raise Status_Error;
      end if;

      Fclose (The_File.Desc);
      The_File.AFCB_In_Use := False;

   end Close_File;

   ---------------------
   -- Load_Look_Ahead --
   ---------------------

   procedure Load_Look_Ahead (End_Of_File_Flag : Boolean) is
      C      : Character;
      Is_Eof : Boolean;

   begin
      --  Load first character of look ahead

      if Chars = 0 then
         Set_Char2 (Nul);
         Set_Char3 (Nul);
         C_Fgetc (The_File.Desc, C, Is_Eof);

         if Is_Eof then
            Set_Char1 (Nul);
            return;
         else
            Set_Char1 (C);
            Set_Chars (1);
         end if;
      end if;

      --  In the case where reading from the keyboard do not read more than
      --  1 character unless you are processing an end_of_file test.

      if Is_Keyboard (The_File) and then not End_Of_File_Flag then
         return;
      end if;

      --  Load second character of look ahead

      if Chars = 1 then
         Set_Char3 (Nul);
         C_Fgetc (The_File.Desc, C, Is_Eof);

         if Is_Eof then
            Set_Char2 (Nul);
            return;
         else
            Set_Char2 (C);
            Set_Chars (2);
         end if;
      end if;

      --  Leave lookahead with at most two characters loaded if standard
      --  input is the keyboard.

      if not Is_Keyboard (The_File) then

         --  Load third character of look ahead

         if Chars = 2 then
            C_Fgetc (The_File.Desc, C, Is_Eof);

            if Is_Eof then
               Set_Char3 (Nul);
               return;
            else
               Set_Char3 (C);
               Set_Chars (3);
            end if;
         end if;
      end if;
   end Load_Look_Ahead;

   --------------
   -- Get_Char --
   --------------

   function Get_Char return Character is
      C : Character;

   begin
      Load_Look_Ahead (False);

      if Chars = 0 then
         raise End_Error;  --  End of file on TEXT_IO input
      end if;

      C := Char1;

      --  Update lookahead

      Set_Char1 (Char2);
      Set_Char2 (Char3);
      Set_Char3 (Nul);
      Set_Chars (Chars - 1);

      --  Update PAGE and LINE counters if page mark or line feed read

      if C = Page_Mark then
         The_File.Page := The_File.Page + 1;
         The_File.Line := 1;
         The_File.Col := 1;
      elsif C = Line_Feed then
         The_File.Line := The_File.Line + 1;
         The_File.Col := 1;
      else
         The_File.Col := The_File.Col  + 1;
      end if;

      if Character'Pos (C) > 127 then
         raise Data_Error;  --  Character > 127 for TEXT_IO input"
      end if;

      return C;
   end Get_Char;

   ----------------
   -- Upper_Case --
   ----------------

   function Upper_Case (C : Character) return Character is
      V : constant Integer := 32;

   begin
      if C in 'a' .. 'z' then
         return Character'Val (Character'Pos (C) - V);
      else
         return C;
      end if;
   end Upper_Case;

   --------------
   -- Word_Sub --
   --------------

   procedure Word_Sub
     (A : Integer;
      B : Integer;
      O : out Boolean;
      R : out Integer)
   is
   begin
      R := A - B;
      O := ((A < 0 and then B > 0) or else (A > 0 and then B < 0))
           and then ((A < 0 and then R > 0) or else (A > 0 and then R < 0));
   end Word_Sub;

   --------------
   -- Word_Mul --
   --------------

   procedure Word_Mul
     (A : Integer;
      B : Integer;
      O : out Boolean;
      R : out Integer)
   is
   begin
      if A /= 0 then
         R := A * B;
         O := (B /= R / A) or else (A = -1 and then B < 0 and then R < 0);
      else
         R := 0;
         O := False;
      end if;
   end Word_Mul;

   ----------------
   -- Put_Blanks --
   ----------------

   procedure Put_Blanks (N : Integer) is
   begin
      for J in 1 .. N loop
         Fputc (The_File.Desc, ' ');
      end loop;
   end Put_Blanks;

   ----------------
   -- Put_Buffer --
   ----------------

   procedure Put_Buffer
     (Width    : Integer;
      Pad_Type : Character;
      Length   : Integer)
   is
      Pad           : Character := Pad_Type;
      Target_Length : Integer;

   begin
      if Length >= Width then
         Target_Length := Length;
         Pad := ' ';
      else
         Target_Length := Width;
      end if;

      --  Ensure the buffer size does not exceed the line length

      if The_File.Line_Length > 0 then
         if Count (Target_Length) > The_File.Line_Length then
            raise Layout_Error; --  "Line too big"

         --  New line if does not fit on current line

         elsif The_File.Col +
           Count (Target_Length) - 1 > The_File.Line_Length
         then
            Put_Line1;
         end if;
      end if;

      --  Output data with the required padding

      if Pad = 'L' then
         Put_Blanks (Width - Length);
      end if;

      for N in 0 .. Length - 1 loop
         Fputc (The_File.Desc, Work_String (N));
      end loop;

      The_File.Col := The_File.Col + Count (Target_Length);

      if Pad = 'T' then
         Put_Blanks (Width - Length);
      end if;
   end Put_Buffer;

   -----------
   -- Getcp --
   -----------

   function Getcp return Character is
      C : Character;

   begin
      if Scanning_From_File then
         return Get_Char;
      else
         if WS_Index1 > WS_Length then
            raise End_Error;
         end if;

         WS_Index1 := WS_Index1 + 1;
         return Work_String (WS_Index1);
      end if;
   end Getcp;

   -----------
   -- Nextc --
   -----------

   function Nextc return Character is
   begin
      if Scanning_From_File then
         Load_Look_Ahead (False);
         return Char1;
      else
         if WS_Index1 < WS_Length then
            return Work_String (WS_Index1);
         else
            return Line_Feed;
         end if;
      end if;
   end Nextc;

   -----------
   -- Skipc --
   -----------

   procedure Skipc is
      C : Character;

   begin
      if Scanning_From_File then
         C := Get_Char;
      else
         WS_Index1 := WS_Index1 + 1;
      end if;
   end Skipc;

   -----------
   -- Copyc --
   -----------

   procedure Copyc is
      C : Character;

   begin
      if Scanning_From_File then
         C := Get_Char;
      else
         if WS_Index1 > WS_Length then
            raise Program_Error;
         else
            C := Work_String (WS_Index1);
            WS_Index1 := WS_Index1 + 1;
         end if;
      end if;

      Work_String (WS_Index2) := Upper_Case (C);
      WS_Index2 := WS_Index2 + 1;
   end Copyc;

   ------------------
   -- Copy_Integer --
   ------------------

   procedure Copy_Integer is
   begin
      Check_Digit;
      while Digit (Nextc) loop
         Copyc;

         if Nextc = '_' then
            Skipc;
            Check_Digit;
         end if;
      end loop;
   end Copy_Integer;

   ------------------------
   -- Copy_Based_Integer --
   ------------------------

   procedure Copy_Based_Integer is
   begin
      Check_Extended_Digit;

      while Extended_Digit (Nextc) loop
         Copyc;

         if Nextc = '_' then
            Skipc;
            Check_Extended_Digit;
         end if;
      end loop;
   end Copy_Based_Integer;

   -----------------
   -- Scan_Blanks --
   -----------------

   procedure Scan_Blanks is
      C : Character;
   begin
      if Scanning_From_File then
         loop
            Load_Look_Ahead (False);

            if Chars = 0 then
               raise End_Error;
            end if;

            C := Nextc;

            if C = ' '
              or else C = Ascii.HT
              or else C = Line_Feed
              or else C = Page_Mark
            then
               C := Getcp;
            else
               exit;
            end if;
         end loop;

      else
         while WS_Index1 <= WS_Length - 1 loop
            if Work_String (WS_Index1) = ' '
              or else Work_String (WS_Index1) = Ascii.HT
            then
               WS_Index1 := WS_Index1 + 1;
            else
               exit;
            end if;
         end loop;
      end if;
   end Scan_Blanks;

   ------------------------
   -- Setup_Fixed_Field --
   ------------------------

   procedure Setup_Fixed_Field (Width : Integer) is
      J : Integer := 0;

   begin
      loop
         Load_Look_Ahead (False);

         if Width /= J
           and then Chars /= 0
           and then Char1 /= Page_Mark
           and then Char1 /= Line_Feed
         then
            Work_String (J) := Get_Char;
            J := J + 1;
         else
            exit;
         end if;
      end loop;

      WS_Length := J;
      Scanning_From_File := False;
      WS_Index1 := 0;
   end Setup_Fixed_Field;

   --------------------------
   -- Test_Fixed_Field_End --
   --------------------------

   procedure Test_Fixed_Field_End is
   begin
      Scan_Blanks;

      if WS_Index1 < WS_Length then
         raise Data_Error;
      end if;
   end Test_Fixed_Field_End;

   -----------
   -- Alpha --
   -----------

   function Alpha (C : Character) return Boolean is
   begin
      return C in 'A' .. 'Z' or else C in 'a' .. 'z';
   end Alpha;

   --------------
   -- Alphanum --
   --------------

   function Alphanum (C : Character) return Boolean is
   begin
      return Alpha (C) or else C in '0' .. '9';
   end Alphanum;

   -------------
   -- Graphic --
   -------------

   function Graphic (C : Character) return Boolean is
      Low  : constant Integer := 32;
      High : constant Integer := 127;

   begin
      return Character'Pos (C) in Low .. High;
   end Graphic;

   -----------
   -- Digit --
   -----------

   function Digit (C : Character) return Boolean is
   begin
      return C in '0' .. '9';
   end Digit;

   --------------------
   -- Extended_Digit --
   --------------------

   function Extended_Digit (C : Character) return Boolean is
   begin
      return C in '0' .. '9' or else C in 'a' .. 'f' or else C in 'A' .. 'F';
   end Extended_Digit;

   ----------
   -- Sign --
   ----------

   function Sign (C : Character) return Boolean is
   begin
      return C = '-' or C = '+';
   end Sign;

   -----------------
   -- Check_Digit --
   -----------------

   procedure Check_Digit is
   begin
      if not (Nextc in '0' .. '9') then
         raise Data_Error;
      end if;
   end Check_Digit;

   ----------------
   -- Check_Hash --
   ----------------

   procedure Check_Hash (C : Character) is
   begin
      if Nextc /= C then
         raise Data_Error;
      end if;

      Skipc;
      Work_String (WS_Index2) := '#';
      WS_Index2 := WS_Index2 + 1;
   end Check_Hash;

   --------------------------
   -- Check_Extended_Digit --
   --------------------------

   procedure Check_Extended_Digit is
   begin
      if not Extended_Digit (Nextc) then
         raise Data_Error;
      end if;
   end Check_Extended_Digit;

   -----------------
   -- Range_Error --
   -----------------

   procedure Range_Error is
   begin
      raise Data_Error;
   end Range_Error;

   --------------
   -- Scan_Int --
   --------------

   function Scan_Int return Integer is
      Ival        : Integer := 0;
      Digit_Value : Integer;
      Overflow1   : Boolean;
      Overflow2   : Boolean;

   begin
      while WS_Index2 < WS_Length
        and then Digit (Work_String (WS_Index2))
      loop
         Digit_Value := Character'Pos (Work_String (WS_Index2))
                        - Character'Pos ('0');
         WS_Index2 := WS_Index2 + 1;
         Word_Mul (Ival, 10, Overflow1, Ival);
         Word_Sub (Ival, Digit_Value, Overflow2, Ival);

         if Overflow1 or else Overflow2 then
            while WS_Index2 < WS_Length
              and then Digit (Work_String (WS_Index2))
            loop
               WS_Index2 := WS_Index2 + 1;
            end loop;
            return 1;
         end if;
      end loop;

      return Ival;
   end Scan_Int;

   --------------------
   -- Scan_Based_Int --
   --------------------

   --  This routine scans a based Integer value fromt the string pointed by
   --  the global Integer WS_Index2. On exit WS_Index2 is updated to point
   --  to the first non-digit. The result returned is always negative. This
   --  allows the largest negative Integer value to be properly stored and
   --  converted. If overflow is detected, then the value +1 is returned to
   --  signal overflow.

   function Scan_Based_Int (Base : Integer) return Integer is
      Ival        : Integer := 0;
      Digit_Value : Integer;
      Overflow1   : Boolean;
      Overflow2   : Boolean;

   begin
      while WS_Index2 < WS_Length
        and then Extended_Digit (Work_String (WS_Index2))
      loop
         Word_Mul (Ival, Base, Overflow1, Ival);
         Digit_Value := Character'Pos (Work_String (WS_Index2))
                                       - Character'Pos ('0');
         WS_Index2 := WS_Index2 + 1;

         if Digit_Value > 9 then
            Digit_Value := Digit_Value - 7;
         end if;

         if Digit_Value >= Base then
            raise Data_Error;
         end if;

         Word_Sub (Ival, Digit_Value, Overflow2, Ival);

         if Overflow1 or else Overflow2 then
            while WS_Index2 < WS_Length
              and then Extended_Digit (Work_String (WS_Index2))
            loop
               WS_Index2 := WS_Index2 + 1;
            end loop;
            return 1;
         end if;
      end loop;

      return Ival;
   end Scan_Based_Int;

   ----------------------
   -- Scan_Integer_Val --
   ----------------------

   procedure Scan_Integer_Val (Fixed_Field : Boolean; Result : out Integer) is
      Ival     : Integer;
      Sign_Val : Character;
      C        : Character;
      Base     : Integer;
      Based    : Boolean;
      Exponent : Integer;
      Overflow : Boolean;

   begin
      --  First scan out item with the proper syntax and put it in Work_String

      WS_Index2 := 0;

      if Sign (Nextc) then
         Copyc;
      end if;

      Copy_Integer;
      C := Nextc;

      if C = '#' or else C = ':' then
         Skipc;
         Work_String (WS_Index2) := '#';
         WS_Index2 := WS_Index2 + 1;
         Copy_Based_Integer;
         Check_Hash (C);
         Based := True;
      else
         Based := False;
      end if;

      C := Nextc;

      if C = 'e' or else C = 'E' then
         Copyc;
         C := Nextc;

         if C = '+' or else C = '-' then
            Skipc;
         end if;

         Copy_Integer;

         if C = '-' then
            raise Data_Error;  --  Negative exponent in integer value
         end if;
      end if;

      if Fixed_Field then
         Test_Fixed_Field_End;
      end if;

      WS_Length := WS_Index2;
      Work_String (WS_Index2) := ' ';

      --  Now we have the Integer literal stored in Work_String

      WS_Index2 := 0;

      if Sign (Work_String (WS_Index2)) then
         Sign_Val := Work_String (WS_Index2);
         WS_Index2 := WS_Index2 + 1;
      else
         Sign_Val := '+';
      end if;

      if Based then
         Base := -Scan_Int;

         if not (Base in 2 .. 16) then
            raise Data_Error;
         end if;

         WS_Index2 := WS_Index2 + 1;
         Ival := Scan_Based_Int (Base);
         WS_Index2 := WS_Index2 + 1;

      else
         Ival := Scan_Int;
         Base := 10;
      end if;

      --  Number is in Ival (in negative form), deal with exponent.

      if Ival = 1 then
         Range_Error;
      end if;

      if Work_String (WS_Index2) = 'E' then
         WS_Index2 := WS_Index2 + 1;
         Exponent := Scan_Int;

         if Exponent < -64 or else Exponent = 1 then
            Range_Error;
         end if;

         while Exponent /= 0 loop
            Exponent := Exponent + 1;
            Word_Mul (Ival, Base, Overflow, Ival);

            if Overflow then
               Range_Error;
            end if;
         end loop;
      else
         WS_Index2 := WS_Index2 + 1;
      end if;

      if Sign_Val = '+' then
         Ival := -Ival;

         if Ival < 0 then
            Range_Error;
         end if;
      end if;

      Result := Ival;
   end Scan_Integer_Val;

   ------------------
   -- Scan_Integer --
   ------------------

   procedure Scan_Integer (Width : Integer; Result : out Integer) is
   begin
      if Width /= 0 then
         Setup_Fixed_Field (Width);
         Scan_Blanks;

         if WS_Index1 = WS_Length then
            raise Data_Error;  --  String is all blanks
         end if;

         Scan_Integer_Val (True, Result);
      else
         Scanning_From_File := True;
         Scan_Blanks;
         Scan_Integer_Val (False, Result);
      end if;
   end Scan_Integer;

   -------------------------
   -- Scan_Integer_String --
   -------------------------

   procedure Scan_Integer_String (Last : out Integer; Result : out Integer) is
   begin
      Scanning_From_File := False;
      Scan_Blanks;

      if WS_Index1 = WS_Length then
         raise End_Error;
      end if;

      Scan_Integer_Val (False, Result);
      Last := WS_Index1;
   end Scan_Integer_String;

   --------------------
   -- Scan_Real_Val --
   --------------------

   --  Procedure to scan a real value and return the result as a double real.
   --  A range exception is signalled if the value is out of range of allowed
   --  Ada real values, but no other range check is made.

   function Scan_Real_Val (Fixed_Field : Boolean) return LLF is
      Base         : Integer;        --  base as integer
      Based        : Boolean;        --  True if number is based
      Before_Point : Boolean;        --  True if before decimal point
      C            : Character;      --  character scanned
      Dbase        : LLF;            --  base as real
      Dig          : Integer;        --  next digit value
      Ddig         : LLF;            --  next digit as real
      Dval         : LLF;            --  value being scanned
      Exp_Sign_Val : Character;      --  sign of exponent
      Fraction     : LLF;            --  power of ten fraction after decimal pt
      Sign_Val     : Character;      --  sign of mantissa
      Exponent     : Integer;        --  value of exponent

   begin
      --  First scan out item with the proper syntax and put it in work_string

      WS_Index2 := 0;

      if Sign (Nextc) then
         Copyc;
      end if;

      Copy_Integer;
      C := Nextc;

      if C = '#' or else C = ':' then
         Skipc;
         Work_String (WS_Index2) := '#';
         WS_Index2 := WS_Index2 + 1;
         Copy_Based_Integer;

         if Nextc /= '.' then
            raise Data_Error; --  missing period in real value
         end if;

         Copyc;
         Copy_Based_Integer;
         Check_Hash (C);
         Based := True;

      else
         Based := False;

         if Nextc /= '.' then
            raise Data_Error; --  Missing period in real value
         end if;

         Copyc;
         Copy_Integer;
      end if;

      C := Nextc;

      if C = 'e' or else C = 'E' then
         Copyc;
         C := Nextc;

         if Sign (Nextc) then
            Copyc;
         end if;

         Copy_Integer;
      end if;

      if Fixed_Field then
         Test_Fixed_Field_End;
      end if;

      WS_Length := WS_Index2;

      --  Now we have the real literal stored in work_string, so prepare to
      --  convert the value, dealing first with setting the proper sign. Note
      --  that we can assume that the syntax of the literal is correct since
      --  we did all the checking above as we scanned it out.

      WS_Index2 := 0;

      if Sign (Work_String (WS_Index2)) then
         Sign_Val := Work_String (WS_Index2);
         WS_Index2 := WS_Index2 + 1;
      else
         Sign_Val := '+';
      end if;

      --  Acquire the proper base value. Note that scan_int returns the
      --  negative of the value scanned, with +1 indicating overflow which
      --  will be invalid.

      if Based then
         Base := Scan_Int;

         if Base not in -16 .. -2 then
            raise Data_Error;  --  Invalid base
         end if;

         Base := -Base;
         WS_Index2 := WS_Index2 + 1;
      else
         Base := 10;
      end if;

      Dbase := LLF (Base);

      --  Scan and convert digits

      Dval := 0.0;
      Before_Point := True;

      loop
         exit when WS_Index2 = WS_Length;

         if Work_String (WS_Index2) = '#' then
            WS_Index2 := WS_Index2 + 1;
            exit;
         end if;

         exit when (not Based) and then Work_String (WS_Index2) = 'E';
         C := Work_String (WS_Index2);
         WS_Index2 := WS_Index2 + 1;

         if C = '.' then
            Before_Point := False;
            Fraction := 1.0;
         else
            Dig := Character'Pos (C) - Character'Pos ('0');

            --  Convert hex digit

            if Dig > 9 then
               Dig := Dig - 7;
            end if;

            if Dig > Base then
               raise Data_Error; --  Digit > Base
            end if;

            Ddig := LLF (Dig);

            if Before_Point then
               Dval := Dval * Dbase + Ddig;
               --  ???
               --  if Dval > ADA_MAX_REAL then
               --     Range_Error;
               --  end if;
            else
               Fraction := Fraction / LLF (Base);
               Dval := Dval + Ddig * Fraction;
            end if;
         end if;
      end loop;

      --  Deal with exponent if present

      if Work_String (WS_Index2) = 'E' then
         WS_Index2 := WS_Index2 + 1;

         if Sign (Work_String (WS_Index2)) then
            Exp_Sign_Val := Work_String (WS_Index2);
            WS_Index2 := WS_Index2 + 1;
         else
            Exp_Sign_Val := '+';
         end if;

         Exponent := Scan_Int;

         --  A value of +1 in exponent means that scan_int detected overflow.
         --  This is not yet a range error. If the mantissa is 0 or 1, the
         --  effect is as if we had an exponent of 1.

         if Exponent = 1 then
            if Dval = 0.0 or else Dval = 1.0 then
               Exponent := 1;

            --  If we have a positive exponent, then if the mantissa is greater
            --  than 1.0, we do have an overflow, otherwise if the mantissa is
            --  less than 1.0, we have an underflow situation giving a result
            --  of zero.

            elsif Exp_Sign_Val = '+' then
               if Dval > 1.0 then
                  Range_Error;
               else
                  Dval := 0.0;
               end if;

            --  For a negative exponent, the situation is the other way round,
            --  since we want in effect the reciprocal of the value for the
            --  positive case.

            else
               if Dval > 1.0 then
                  Dval := 0.0;
               else
                  Range_Error;
               end if;
            end if;

         --  If no overflow, get abs value of exponent (scan_int returned -exp)

         else
            Exponent := -Exponent;
         end if;

         --  An optimization: if the mantissa is zero, save a lot of time
         --  in converting silly numbers like 0E+25000 by resetting exponent.

         if Dval = 0.0 then
            Exponent := 0;
         end if;

         --  Adjust mantissa by exponent, using proper exponent sign

         if Exp_Sign_Val = '+' then
            while Exponent > 0 loop
               Dval := Dval * Dbase;
               --  ???
               --  if Dval > ADA_MAX_REAL then
               --     Range_Error;
               --  end if;
               Exponent := Exponent - 1;
            end loop;
         else
            while Exponent > 0 loop
               Dval := Dval / Dbase;
               Exponent := Exponent - 1;
            end loop;
         end if;
      end if;

      --  Return scanned value with proper sign

      if Sign_Val = '+' then
         return Dval;
      else
         return -Dval;
      end if;
   end Scan_Real_Val;

   --------------------
   -- Scan_Float_Val --
   --------------------

   function Scan_Float_Val (Fixed_Field : Boolean) return LLF is
      Dval : LLF;

   begin
      Dval := Scan_Real_Val (Fixed_Field);
      --  ??? Check that value is in range. Unimplemented for now.
      return LLF (Dval);
   end Scan_Float_Val;

   ----------------
   -- Scan_Float --
   ----------------

   function Scan_Float (Width : Natural) return LLF is
      Result : LLF;

   begin
      if Width /= 0 then
         Setup_Fixed_Field (Width);
         Scan_Blanks;

         if WS_Index1 = WS_Length then
            raise Data_Error; --  String is all blanks
         end if;

         Result := Scan_Float_Val (True);
      else
         Scanning_From_File := True;
         Scan_Blanks;
         Result := Scan_Float_Val (False);
      end if;

      return Result;
   end Scan_Float;

   -----------------------
   -- Scan_Float_String --
   -----------------------

   procedure Scan_Float_String (Last : out Integer; Result : out LLF) is
   begin
      Scanning_From_File := False;
      Scan_Blanks;

      if WS_Index1 = WS_Length then
         raise End_Error; --  String is all blanks
      end if;

      Result := Scan_Float_Val (False);
      Last := WS_Index1;
   end Scan_Float_String;

   ---------------
   -- Scan_Enum --
   ---------------

   procedure Scan_Enum (Last : out Natural) is
   begin
      Scan_Blanks;

      if not Scanning_From_File and then WS_Index1 = WS_Length then
         raise End_Error;  --  String is all blanks
      end if;

      WS_Index2 := 0;

      --  Try identifier

      if Alpha (Nextc) then
         while Alphanum (Nextc) loop
            Copyc;

            if Nextc = '_' then
               Copyc;
            end if;
         end loop;

      elsif Nextc = ''' then

      --  Look for an ending quote.

         Copyc;

         if Graphic (Nextc) then
            Work_String (WS_Index2) := Getcp;
            WS_Index2 := WS_Index2 + 1;

            if Nextc = ''' then
               Copyc;
            end if;
         else
            raise Data_Error;
         end if;

      else
         raise Data_Error;
      end if;

      WS_Length := WS_Index2;
      Last := WS_Index1;
   end Scan_Enum;

   --  The closing of all open files and deletion of temporary files is an
   --  action which takes place at the end of execution of the main program.
   --  This action can be implemented using a library level object which
   --  gets finalized at the end of the main program execution. Below, a
   --  controlled type is introduced and an object is declared of this type
   --  for this purpose. The Finalize operation associated with this type
   --  will do all the necessary work.

   type Finalizable_Type is new Controlled with null record;
   procedure Finalize (V : in out Finalizable_Type);

   Finalizable_Object : Finalizable_Type;

   --------------
   -- Finalize --
   --------------

   procedure Finalize (V : in out Finalizable_Type) is
   begin
      --  Close all open files except stdin, stdout and stderr

      for J in 4 .. Open_Files'Last loop
         if Open_Files (J) /= null
           and then Open_Files (J).AFCB_In_Use
           and then Open_Files (J).Mode /= In_File
         then
            Close_File;
         end if;
      end loop;

      --  Delete temporary files upon completion of the main program

      while (Temp_Files /= null) loop
         Unlink (Temp_Files.File_Name.all);
         Temp_Files := Temp_Files.Next;
      end loop;
   end Finalize;

   -----------
   -- Fopen --
   -----------

   function Fopen (Name : String; Typ : File_Mode) return Text_IO.File_Ptr is
      function C_Fopen (Name, Typ : Address) return Text_IO.File_Ptr;
      pragma Import (C, C_Fopen, "fopen");

      Name1       : String (Name'First .. Name'Last + 1);
      Append_Only : constant String := "at" & Ascii.NUL;
      Read_Only   : constant String := "rt" & Ascii.NUL;
      Write_Only  : constant String := "wt" & Ascii.NUL;

   begin
      Name1 (Name'range) := Name;
      Name1 (Name1'Last) := Nul;

      if Typ = In_File then
         return C_Fopen (Name1'Address, Read_Only'Address);
      elsif Typ = Out_File then
         return C_Fopen (Name1'Address, Write_Only'Address);
      else  --  Append_File
         return C_Fopen (Name1'Address, Append_Only'Address);
      end if;
   end Fopen;

   ------------
   -- Fclose --
   ------------

   procedure Fclose (P : Text_IO.File_Ptr) is
      procedure C_Fclose (P : Text_IO.File_Ptr);
      pragma Import (C, C_Fclose, "fclose");

   begin
      C_Fclose (P);
   end Fclose;

   ------------
   -- Unlink --
   ------------

   procedure Unlink (Name : String) is
      procedure C_Unlink (Name : Address);
      pragma Import (C, C_Unlink, "unlink");

      Name1 : String (Name'First .. Name'Last + 1);

   begin
      Name1 (Name'range) := Name;
      Name1 (Name1'Last) := Nul;
      C_Unlink (Name1'Address);
   end Unlink;

   -----------------
   -- Is_Keyboard --
   -----------------

   function Is_Keyboard (F : Text_IO.File_Type) return Boolean is
   begin
      return F.Is_Keyboard;
   end Is_Keyboard;

   ------------
   -- Isatty --
   ------------

   function Isatty (F : Text_IO.File_Ptr) return Boolean is
      function C_Isatty (I : Integer) return Boolean;
      pragma Import (C, C_Isatty, "isatty");

      function C_Fileno (F : Text_IO.File_Ptr) return Integer;
      pragma Import (C, C_Fileno, "fileno");

   begin
      return C_Isatty (C_Fileno (F));
   end Isatty;

   -------------
   -- C_Fgetc --
   -------------

   procedure C_Fgetc
     (F      : Text_IO.File_Ptr;
      C      : out Character;
      Is_Eof : out Boolean)
   is
      I      : Integer;
      function Fgetc (F : Text_IO.File_Ptr) return Integer;
      pragma Import (C, Fgetc, "fgetc");

   begin
      I := Fgetc (F);
      Is_Eof := I = -1;

      if not Is_Eof then
         C := Character'Val (I);
      end if;
   end C_Fgetc;

   -------------
   -- C_Fputc --
   -------------

   procedure Fputc (F : Text_IO.File_Ptr; C : Character) is
      procedure C_Fputc (C : Character; F : Text_IO.File_Ptr);
      pragma Import (C, C_Fputc, "fputc");

   begin
      C_Fputc (C, F);
   end Fputc;

   -----------
   -- Stdin --
   ------------

   function Stdin return Text_IO.File_Ptr is
      function C_Stdin return Text_IO.File_Ptr;
      pragma Import (C, C_Stdin);

   begin
      return C_Stdin;
   end Stdin;

   ------------
   -- Stdout --
   ------------

   function Stdout return Text_IO.File_Ptr is
      function C_Stdout return Text_IO.File_Ptr;
      pragma Import (C, C_Stdout);

   begin
      return C_Stdout;
   end Stdout;

   ------------
   -- Stderr --
   ------------

   function Stderr return Text_IO.File_Ptr is
      function C_Stderr return Text_IO.File_Ptr;
      pragma Import (C, C_Stderr);

   begin
      return C_Stderr;
   end Stderr;

begin

   --  Initialization of Standard Input

   Standard_In := new AFCB'(AFCB_In_Use => True,
     Desc => Stdin,
     Name => new String'("Standard_Input"),
     Form => new String'("rt"),
     Mode => In_File,
     Col  => 1,
     Line => 1,
     Page => 1,
     Line_Length => 0,
     Page_Length => 0,
     Count => 0,
     Is_Keyboard => Isatty (Stdin),
     Look_Ahead => "   ");

   --  Initialization of Standard Output

   Standard_Out := new AFCB'(AFCB_In_Use => True,
     Desc => Stdout,
     Name => new String'("Standard_Output"),
     Form => new String'("wt"),
     Mode => Out_File,
     Col  => 1,
     Line => 1,
     Page => 1,
     Line_Length => 0,
     Page_Length => 0,
     Count => 0,
     Is_Keyboard => False,
     Look_Ahead => "   ");

   --  Initialization of Standard Error

   Standard_Err := new AFCB'(AFCB_In_Use => True,
     Desc => Stderr,
     Name => new String'("Standard_Error"),
     Form => new String'("wt"),
     Mode => Out_File,
     Col  => 1,
     Line => 1,
     Page => 1,
     Line_Length => 0,
     Page_Length => 0,
     Count => 0,
     Is_Keyboard => False,
     Look_Ahead => "   ");

   Current_In  := Standard_In;
   Current_Out := Standard_Out;
   Current_Err := Standard_Err;

   Open_Files (Open_Files'First + 0) := Standard_In;
   Open_Files (Open_Files'First + 1) := Standard_Out;
   Open_Files (Open_Files'First + 2) := Standard_Err;

end Ada.Text_IO.Aux;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.26
--  date: Thu Aug 25 17:41:58 1994;  author: banner
--  (Image_Float): delete
--  (Image_Integer): delete
--  add context clauses for System.Img_BIU, System.Img_Int, System.Img_LLB,
--   System.Img_LLI, System.Img_LLU, System.Img_LLW, System.Img_Real,
--   System.Img_Uns, System.Img_WIU
--  add additional temporary workspace string Tmp
--  (Put_Float, Put_Int): completely rewitten to use Img routines
--  (Put_Int): renamed to Put_Integer
--  (Put_LLI): new procedures to support Long_Long_Integer
--  (Put_Unsigned): new procedures to support Modular_IO
--  (Put_LLU): new procedures to support Modular_IO
--  ----------------------------
--  revision 1.27
--  date: Mon Aug 29 13:57:29 1994;  author: banner
--  (Is_Keyboard): new function which just queries the Is_Keyboard flag.
--  (Isatty): rename most calls to this Isatty to now call Is_Keyboard instead.
--  change initializations for Standard_In, Standard_Out and Standard_Err to
--   set a value for Is_Keyboard field.
--  (Open): set Is_Keyboard flag to False since any file which is explicitly
--   opened cannot be the keyboard (tty).
--  The above described changes now reduce the overhead of Isatty (a kernel
--   call) since it is now called exactly once (in the setting of Standard_In)
--   for the entire program.
--  ----------------------------
--  revision 1.28
--  date: Mon Aug 29 23:41:41 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
