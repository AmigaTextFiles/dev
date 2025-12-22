------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       A D A . I N T E R R U P T S                        --
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

with System;

package Ada.Interrupts is

   pragma Unimplemented_Unit;

   type Interrupt_Id is new Natural;   -- temporary definition for now ???

   type Parameterless_Handler is
      access protected procedure;

   function Is_Reserved (Interrupt : Interrupt_Id)
      return Boolean;

   function Is_Attached (Interrupt : Interrupt_Id)
      return Boolean;

   function Current_Handler (Interrupt : Interrupt_Id)
      return Parameterless_Handler;

   procedure Attach_Handler
      (New_Handler : Parameterless_Handler;
       Interrupt   : Interrupt_Id);

   procedure Exchange_Handler
      (Old_Handler : out Parameterless_Handler;
       New_Handler : Parameterless_Handler;
       Interrupt   : Interrupt_Id);

   procedure Detach_Handler
      (Interrupt : Interrupt_Id);

   function Reference (Interrupt : Interrupt_Id)
      return System.Address;

end Ada.Interrupts;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Dec 27 19:24:25 1993;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 09:29:56 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Thu May 12 14:03:16 1994;  author: dewar
--  Add Unimplemented_Unit pragma
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
