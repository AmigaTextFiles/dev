------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                             A D A . T A G S                              --
--                                                                          --
--                                 B o d y                                  --
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

package body Ada.Tags is

   -------------------
   -- Expanded_Name --
   -------------------

   function Expanded_Name (T : Tag) return String is
   begin
      raise Program_Error; -- TBSL
      return "";
   end Expanded_Name;

   ------------------
   -- External_Tag --
   ------------------

   function External_Tag (T : Tag) return String is
   begin
      raise Program_Error; -- TBSL
      return "";
   end External_Tag;

   ------------------
   -- Internal_Tag --
   ------------------

   function Internal_Tag (External : String) return Tag is
   begin
      raise Program_Error; -- TBSL
      return null;
   end Internal_Tag;

end Ada.Tags;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Thu Oct 21 13:00:55 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:56:36 1994;  author: dewar
--  New header with 1994 copyright
--  Remove pragma Ada_9X, no longer needed
--  ----------------------------
--  revision 1.3
--  date: Wed Jan 19 01:22:41 1994;  author: banner
--  Style conformance.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
