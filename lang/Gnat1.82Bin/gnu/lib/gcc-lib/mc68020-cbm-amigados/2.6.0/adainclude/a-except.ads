------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                       A D A . E X C E P T I O N S                        --
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


package Ada.Exceptions is

   pragma Unimplemented_Unit;

   type Exception_Occurrence is private;
   Null_Occurrence : constant Exception_Occurrence;

   function Exception_Name        (X : Exception_Occurrence) return String;
   function Exception_Message     (X : Exception_Occurrence) return String;
   function Exception_Information (X : Exception_Occurrence) return String;

   procedure Reraise_Occurrence   (X : Exception_Occurrence);

private
   --  Dummy definitions for now (body not implemented yet) ???

   type Exception_Occurrence is new Integer;

   Null_Occurrence : constant Exception_Occurrence := 0;

end Ada.Exceptions;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Tue Dec 21 08:34:58 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:29:37 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Thu May 12 14:03:04 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
