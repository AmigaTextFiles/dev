------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       A D A . S T O R A G E _ I O                        --
--                                                                          --
--                                 B o d y                                  --
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


package body Ada.Storage_IO is

   package Element_Ops is new
     System.Storage_Elements.Address_To_Access_Conversions (Element_Type);

   ----------
   -- Read --
   ----------

   procedure Read (Buffer : in  Buffer_Type; Item : out Element_Type) is
   begin
      Element_Ops.To_Pointer (Item'Address).all :=
        Element_Ops.To_Pointer (Buffer'Address).all;
   end Read;


   -----------
   -- Write --
   -----------

   procedure Write (Buffer : out Buffer_Type; Item : in  Element_Type) is
   begin
      Element_Ops.To_Pointer (Buffer'Address).all :=
        Element_Ops.To_Pointer (Item'Address).all;
   end Write;

end Ada.Storage_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:53:38 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Wed Mar  2 07:41:03 1994;  author: dewar
--  Remove unused with of Unchecked_Conversion
--  ----------------------------
--  revision 1.4
--  date: Thu Aug 11 10:44:06 1994;  author: dewar
--  Remove unused instantiation for Buffer_Ops
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
