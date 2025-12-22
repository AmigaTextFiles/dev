------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                             A D A . T A G S                              --
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

with System;

package Ada.Tags is

   type Tag is private;

   function Expanded_Name (T : Tag) return String;

   function External_Tag (T : Tag) return String;

   function Internal_Tag (External : String) return Tag;

   Tag_Error : exception;

private

   --  Tag is a pointer to the dispatch table. The actual type of the tag
   --  is different for each different tagged type, since the structure of
   --  each dispatch table is different. The definition given here is a
   --  dummy definition that has the right kind of type, but does not match
   --  any real dispatch table type.

   type Fake_Dispatch_Table is array (1 .. 0) of System.Address;

   type Tag is access all Fake_Dispatch_Table;

end Ada.Tags;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:56:41 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Sun May 29 15:35:09 1994;  author: comar
--  Redefine Tag as a general access rather than a pool-specific access.
--  ----------------------------
--  revision 1.4
--  date: Mon May 30 10:45:20 1994;  author: dewar
--  Provide additional comments
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
