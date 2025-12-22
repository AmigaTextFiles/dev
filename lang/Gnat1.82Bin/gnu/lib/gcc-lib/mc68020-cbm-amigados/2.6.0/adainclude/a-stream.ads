------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                          A D A . S T R E A M S                           --
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


with System.Storage_Elements;

package Ada.Streams is
pragma Unimplemented_Unit;
pragma Pure (Ada.Streams);

   type Root_Stream_Type is abstract tagged limited private;

   procedure Read (
     Stream : in out Root_Stream_Type;
     Item   : out System.Storage_Elements.Storage_Array;

     Last   : out System.Storage_Elements.Storage_Offset) is abstract;

   procedure Write (
     Stream : in out Root_Stream_Type;
     Item   : in System.Storage_Elements.Storage_Array) is abstract;

private
   --  Dummy definition for now (body not implemented yet) ???

   type Root_Stream_Type is tagged null record;

end Ada.Streams;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Sat Feb 12 13:25:50 1994;  author: dewar
--  Remove unused with's
--  ----------------------------
--  revision 1.4
--  date: Thu May 12 14:03:37 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  revision 1.5
--  date: Mon Jun  6 12:03:18 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
