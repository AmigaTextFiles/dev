------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       A D A . S T O R A G E _ I O                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.5 $                              --
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
with System.Storage_Elements;

generic
   type Element_Type is private;

package Ada.Storage_IO is
pragma Preelaborate (Storage_IO);

   Buffer_Size : constant System.Storage_Elements.Storage_Count :=
      (Element_Type'Size + System.Storage_Unit - 1) / System.Storage_Unit;

   subtype Buffer_Type is
     System.Storage_Elements.Storage_Array (1 .. Buffer_Size);

   ---------------------------------
   -- Input and Output Operations --
   ---------------------------------

   procedure Read  (Buffer : in  Buffer_Type; Item : out Element_Type);

   procedure Write (Buffer : out Buffer_Type; Item : in  Element_Type);

   ----------------
   -- Exceptions --
   ----------------

   Data_Error   : exception renames IO_Exceptions.Data_Error;

end Ada.Storage_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Sun Jan  9 10:53:44 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.4
--  date: Mon Jul 11 17:35:01 1994;  author: banner
--  Update to RM9X 5.0
--  ----------------------------
--  revision 1.5
--  date: Thu Jul 21 02:46:30 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
