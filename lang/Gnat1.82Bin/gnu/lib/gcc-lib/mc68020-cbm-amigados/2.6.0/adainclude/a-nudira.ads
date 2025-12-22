------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--         A D A . N U M E R I C S . D I S C R E T E _ R A N D O M          --
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

--  with Ada.Finalization; use Ada.Finalization;

generic
   type Result_Subtype is (<>);

package Ada.Numerics.Discrete_Random is

   --  Basic facilities

   type Generator is limited private;

   function Random (Gen : Generator) return Result_Subtype;

   procedure Reset (Gen : in Generator);
   procedure Reset (Gen : in Generator; Initiator : in Integer);

   --  Advanced facilities

   type State is private;

   procedure Save  (Gen : in  Generator; To_State   : out State);
   procedure Reset (Gen : in  Generator; From_State : in  State);

   Max_Image_Width : constant := 25;

   function Image (Of_State    : State)  return String;
   function Value (Coded_State : String) return State;

private
   Larger_Lag  : constant := 25;
   Smaller_Lag : constant := 11;

   type Lag_Range is mod Larger_Lag;

   type State_Vector is array (Lag_Range) of Float;

   type Internal_State is record
      Lagged_Outputs : State_Vector;
      Borrow         : Float;
      R, S           : Lag_Range;
   end record;

   type Access_State is access Internal_State;

   Initial_State : Internal_State;

   type Generator is
      --  new Limited_Controlled with
      record
         State : Access_State := new Internal_State'(Initial_State);
      end record;
   --  procedure Finalize (Gen : in out Generator);

   type State is new Internal_State;

end Ada.Numerics.Discrete_Random;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Mon Jul 11 17:32:01 1994;  author: banner
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Fri Jul 22 00:38:03 1994;  author: dewar
--  Fix revision history mess, minor reformatting
--  ----------------------------
--  revision 1.3
--  date: Mon Aug 22 13:12:53 1994;  author: banner
--  Correct full type declaration of "State". This removes the conversion
--   errors reported on previous attempts to compile this file.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
