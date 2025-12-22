------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                A D A . S T R E A M S . S T R E A M _ I O                 --
--                                                                          --
--                                 S p e c                                  --
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


with Ada.IO_Exceptions;

package Ada.Streams.Stream_IO is

   pragma Unimplemented_Unit;

   type Stream_Access is access Root_Stream_Type'Class;

   type File_Type is limited private;

   type File_Mode is (In_File, Out_File, Append_File);

   type    Count          is range 0 .. Long_Long_Integer'Last;
   subtype Positive_Count is Count range 1 .. Count'Last;

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

   procedure Close  (File  : in out File_Type);
   procedure Delete (File : in out File_Type);
   procedure Reset  (File  : in out File_Type; Mode : in File_Mode);
   procedure Reset  (File  : in out File_Type);

   function Mode    (File : in File_Type) return File_Mode;
   function Name    (File : in File_Type) return String;
   function Form    (File : in File_Type) return String;

   function Is_Open (File : in File_Type) return Boolean;

   function Stream  (File : in File_Type) return Stream_Access;

   -----------------------------
   -- Input-Output Operations --
   -----------------------------

   procedure Read (
     File : in File_Type;
     Item : out System.Storage_Elements.Storage_Array;
     Last : out System.Storage_Elements.Storage_Offset;
     From : in Positive_Count);

   procedure Read (
     File : in File_Type;
     Item : out System.Storage_Elements.Storage_Array;
     Last : out System.Storage_Elements.Storage_Offset);

   procedure Write (
     File : in File_Type;
     Item : in System.Storage_Elements.Storage_Array;
     To   : in Positive_Count);

   procedure Write (
     File : in File_Type;
     Item : in System.Storage_Elements.Storage_Array);

   ----------------------------------------
   -- Operations on Position within File --
   ----------------------------------------

   procedure Set_Index  (File : in File_Type; To : in Positive_Count);

   function Index       (File : in File_Type) return Positive_Count;
   function Size        (File : in File_Type) return Count;

   function End_Of_File (File : in File_Type) return Boolean;

   procedure Set_Mode   (File : in out File_Type; Mode : in File_Mode);

   procedure Flush      (File : in out File_Type);

   ----------------
   -- Exceptions --
   ----------------

   Status_Error : exception renames IO_Exceptions.Status_Error;
   Mode_Error   : exception renames IO_Exceptions.Mode_Error;
   Name_Error   : exception renames IO_Exceptions.Name_Error;
   Use_Error    : exception renames IO_Exceptions.Use_Error;
   Device_Error : exception renames IO_Exceptions.Device_Error;
   End_Error    : exception renames IO_Exceptions.End_Error;
   Data_Error   : exception renames IO_Exceptions.Data_Error;

private
   --  Dummy definition (body not writen yet) ???

   type File_Type is new Integer;
end Ada.Streams.Stream_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Wed Dec 22 07:41:31 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:53:50 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Thu May 12 14:03:49 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
