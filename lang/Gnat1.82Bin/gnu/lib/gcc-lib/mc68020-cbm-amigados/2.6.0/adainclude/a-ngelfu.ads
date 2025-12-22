------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                ADA.NUMERICS.GENERIC_ELEMENTARY_FUNCTIONS                 --
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

generic
   type Float_Type is digits <>;

package Ada.Numerics.Generic_Elementary_Functions is
pragma Pure (Generic_Elementary_Functions);

   function Sqrt    (X           : Float_Type'Base) return Float_Type'Base;
   function Log     (X           : Float_Type'Base) return Float_Type'Base;
   function Log     (X, Base     : Float_Type'Base) return Float_Type'Base;
   function Exp     (X           : Float_Type'Base) return Float_Type'Base;
   function "**"    (Left, Right : Float_Type'Base) return Float_Type'Base;

   function Sin     (X           : Float_Type'Base) return Float_Type'Base;
   function Sin     (X, Cycle    : Float_Type'Base) return Float_Type'Base;
   function Cos     (X           : Float_Type'Base) return Float_Type'Base;
   function Cos     (X, Cycle    : Float_Type'Base) return Float_Type'Base;
   function Tan     (X           : Float_Type'Base) return Float_Type'Base;
   function Tan     (X, Cycle    : Float_Type'Base) return Float_Type'Base;
   function Cot     (X           : Float_Type'Base) return Float_Type'Base;
   function Cot     (X, Cycle    : Float_Type'Base) return Float_Type'Base;

   function Arcsin  (X           : Float_Type'Base) return Float_Type'Base;
   function Arcsin  (X, Cycle    : Float_Type'Base) return Float_Type'Base;
   function Arccos  (X           : Float_Type'Base) return Float_Type'Base;
   function Arccos  (X, Cycle    : Float_Type'Base) return Float_Type'Base;

   function Arctan
     (Y   : Float_Type'Base;
      X   : Float_Type'Base := 1.0)
     return Float_Type'Base;

   function Arctan
     (Y     : Float_Type'Base;
      X     : Float_Type'Base;
      Cycle : Float_Type'Base)
      return  Float_Type'Base;

   function Arccot
     (X   : Float_Type'Base;
      Y   : Float_Type'Base := 1.0)
     return Float_Type'Base;

   function Arccot
     (X     : Float_Type'Base;
      Y     : Float_Type'Base := 1.0;
      Cycle : Float_Type'Base)
     return   Float_Type'Base;

   function Sinh    (X : Float_Type'Base) return Float_Type'Base;
   function Cosh    (X : Float_Type'Base) return Float_Type'Base;
   function Tanh    (X : Float_Type'Base) return Float_Type'Base;
   function Coth    (X : Float_Type'Base) return Float_Type'Base;
   function Arcsinh (X : Float_Type'Base) return Float_Type'Base;
   function Arccosh (X : Float_Type'Base) return Float_Type'Base;
   function Arctanh (X : Float_Type'Base) return Float_Type'Base;
   function Arccoth (X : Float_Type'Base) return Float_Type'Base;

end Ada.Numerics.Generic_Elementary_Functions;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.3
--  date: Thu Mar 10 15:27:32 1994;  author: schonber
--  Remove default value for Arctan with cycle, to avoid ambiguity.
--  ----------------------------
--  revision 1.4
--  date: Mon Jul 11 17:36:54 1994;  author: banner
--  Add pragma Pure (per RM9X 5.0)
--  ----------------------------
--  revision 1.5
--  date: Fri Jul 22 11:31:17 1994;  author: dewar
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
