------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                     A D A . F I N A L I Z A T I O N                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.8 $                              --
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

with System.Finalization_Implementation;

package Ada.Finalization is

   type Controlled is abstract new
     System.Finalization_Implementation.Root_Controlled with null record;

--   type Controlled is abstract tagged private;

   procedure Initialize (Object : in out Controlled);
   procedure Adjust     (Object : in out Controlled);
   procedure Finalize   (Object : in out Controlled);

   type Limited_Controlled is abstract new
     System.Finalization_Implementation.Root_Limited_Controlled
       with null record;

--   type Limited_Controlled is abstract tagged limited private;

   procedure Initialize (Object : in out Limited_Controlled);
   procedure Finalize   (Object : in out Limited_Controlled);

private

--    type Controlled is abstract new
--      System.Finalization_Implementation.Root_Controlled with null record;

--    type Limited_Controlled is abstract new
--      System.Finalization_Implementation.Root_Limited_Controlled
--        with null record;

end Ada.Finalization;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.6
--  date: Wed Mar 30 14:02:03 1994;  author: comar
--  Finalize and Adjust are made nonabstract (Vilars resolution #3b)
--  ----------------------------
--  revision 1.7
--  date: Wed Jun  1 23:25:08 1994;  author: dewar
--  Remove use clause for System (unit is loaded by Rtsfind).
--  ----------------------------
--  revision 1.8
--  date: Fri Aug 19 20:27:18 1994;  author: comar
--  remove Root_Part which has disappeared from RM 5.0.
--  Preparation for introduction of private extensions.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
