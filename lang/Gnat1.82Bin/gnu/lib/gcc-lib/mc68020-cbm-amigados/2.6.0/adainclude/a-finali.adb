------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                     A D A . F I N A L I Z A T I O N                      --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.2 $                              --
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

package body Ada.Finalization is

   procedure Initialize (Object : in out Controlled) is
   begin
      null;
   end Initialize;

   procedure Adjust (Object : in out Controlled) is
   begin
      null;
   end Adjust;

   procedure Finalize (Object : in out Controlled) is
   begin
      null;
   end Finalize;

   procedure Initialize (Object : in out Limited_Controlled) is
   begin
      null;
   end Initialize;

   procedure Finalize (Object : in out Limited_Controlled) is
   begin
      null;
   end Finalize;

end Ada.Finalization;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Feb 25 19:00:33 1994;  author: comar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Wed Mar 30 14:03:30 1994;  author: comar
--  supply empty body for no more abstract Finalize and Adjust
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
