------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                        A D A . D I R E C T _ I O                         --
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

generic
   type Element_Type is private;

package Ada.Direct_IO is

   type File_Type is limited private;

   type File_Mode is (In_File, Inout_File, Out_File);
   type Count     is range 0 .. Long_Long_Integer'Last;
   subtype Positive_Count is Count range 1 .. Count'Last;

   ---------------------
   -- File Management --
   ---------------------

   procedure Create
     (File : in out File_Type;
      Mode : in File_Mode := Inout_File;
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
   procedure Reset  (File : in out File_Type);

   function Mode    (File : in File_Type) return File_Mode;
   function Name    (File : in File_Type) return String;
   function Form    (File : in File_Type) return String;

   function Is_Open (File : in File_Type) return Boolean;

   ---------------------------------
   -- Input and Output Operations --
   ---------------------------------

   procedure Read
     (File : in File_Type;
      Item : out Element_Type;
      From : in Positive_Count);

   procedure Read
     (File : in File_Type;
      Item : out Element_Type);

   procedure Write
     (File : in File_Type;
      Item : in  Element_Type;
      To   : in Positive_Count);

   procedure Write
     (File : in File_Type;
      Item : in Element_Type);

   procedure Set_Index (File : in File_Type; To : in Positive_Count);

   function Index (File : in File_Type) return Positive_Count;
   function Size  (File : in File_Type) return Count;

   function End_Of_File (File : in File_Type) return Boolean;

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
   --  Dummy definition (body not yet implemented) ???

   type File_Type is new Integer;
end Ada.Direct_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:29:24 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Mon Jul 11 17:25:15 1994;  author: banner
--  Minor Changes per RM9X 5.0
--  ----------------------------
--  revision 1.4
--  date: Thu Jul 21 02:46:11 1994;  author: dewar
--  Reformat specs to GNAT standard format
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
