------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                            S Y S T E M _ I O                             --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.1 $                              --
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

--  A simple text I/O package, used for diagnostic output in the runtime,
--  and can be used for simple I/O functions in user programs as required.
--  This package is also preelaborated, unlike Text_Io, and can thus be
--  with'ed by preelaborated library units.

package System.Io is
pragma Preelaborate (Io);

   procedure Get (X : out Integer);
   procedure Put (X : Integer);

   procedure Get (C : out Character);
   procedure Put (C : Character);

   procedure Put (S : String);
   procedure Put_Line (S : String);

   procedure New_Line (Spacing : Positive := 1);
   procedure Get_Line (Item : in out String; Last : out Natural);
   
end System.Io;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul  1 14:23:32 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
