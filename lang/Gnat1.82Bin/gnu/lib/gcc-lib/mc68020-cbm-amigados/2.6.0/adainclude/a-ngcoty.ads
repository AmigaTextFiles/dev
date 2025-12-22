------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--   A D A . N U M E R I C S . G E N E R I C _ C O M P L E X _ T Y P E S    --
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

generic
   type Real is digits <>;

package Ada.Numerics.Generic_Complex_Types is

pragma Pure (Generic_Complex_Types);

   type Complex is record
      Re, Im : Real'Base;
   end record;

   type Imaginary is private;

   i : constant Imaginary;
   j : constant Imaginary;

   function Re (X : Complex)   return Real'Base;
   function Im (X : Complex)   return Real'Base;
   function Im (X : Imaginary) return Real'Base;

   procedure Set_Re (X  : in out Complex;   Re : in Real'Base);
   procedure Set_Im (X  : in out Complex;   Im : in Real'Base);
   procedure Set_Im (X  :    out Imaginary; Im : in Real'Base);

   function Compose_From_Cartesian (Re, Im : Real'Base) return Complex;
   function Compose_From_Cartesian (Re     : Real'Base) return Complex;
   function Compose_From_Cartesian (Im     : Imaginary) return Complex;

   function Modulus (X     : Complex) return Real'Base;
   function "abs"   (Right : Complex) return Real'Base renames Modulus;

   function Argument (X : Complex)                    return Real'Base;
   function Argument (X : Complex; Cycle : Real'Base) return Real'Base;

   function Compose_From_Polar (
     Modulus, Argument : Real'Base)
     return Complex;

   function Compose_From_Polar (
     Modulus, Argument, Cycle : Real'Base)
     return Complex;

   function "+"       (Right : Complex) return Complex;
   function "-"       (Right : Complex) return Complex;
   function Conjugate (X     : Complex) return Complex;

   function "+"       (Left, Right : Complex) return Complex;
   function "-"       (Left, Right : Complex) return Complex;
   function "*"       (Left, Right : Complex) return Complex;
   function "/"       (Left, Right : Complex) return Complex;

   function "**"      (Left : Complex; Right : Integer) return Complex;

   function "+"       (Right : Imaginary) return Imaginary;
   function "-"       (Right : Imaginary) return Imaginary;
   function Conjugate (X     : Imaginary) return Imaginary renames "-";
   function "abs"     (Right : Imaginary) return Real'Base;

   function "+"       (Left, Right : Imaginary) return Imaginary;
   function "-"       (Left, Right : Imaginary) return Imaginary;
   function "*"       (Left, Right : Imaginary) return Real'Base;
   function "/"       (Left, Right : Imaginary) return Real'Base;

   function "**"      (Left : Imaginary; Right : Integer) return Complex;

   function "<"       (Left, Right : Imaginary) return Boolean;
   function "<="      (Left, Right : Imaginary) return Boolean;
   function ">"       (Left, Right : Imaginary) return Boolean;
   function ">="      (Left, Right : Imaginary) return Boolean;

   function "+"       (Left : Complex;   Right : Real'Base) return Complex;
   function "+"       (Left : Real'Base; Right : Complex)   return Complex;
   function "-"       (Left : Complex;   Right : Real'Base) return Complex;
   function "-"       (Left : Real'Base; Right : Complex)   return Complex;
   function "*"       (Left : Complex;   Right : Real'Base) return Complex;
   function "*"       (Left : Real'Base; Right : Complex)   return Complex;
   function "/"       (Left : Complex;   Right : Real'Base) return Complex;
   function "/"       (Left : Real'Base; Right : Complex)   return Complex;

   function "+"       (Left : Complex;   Right : Imaginary) return Complex;
   function "+"       (Left : Imaginary; Right : Complex)   return Complex;
   function "-"       (Left : Complex;   Right : Imaginary) return Complex;
   function "-"       (Left : Imaginary; Right : Complex)   return Complex;
   function "*"       (Left : Complex;   Right : Imaginary) return Complex;
   function "*"       (Left : Imaginary; Right : Complex)   return Complex;
   function "/"       (Left : Complex;   Right : Imaginary) return Complex;
   function "/"       (Left : Imaginary; Right : Complex)   return Complex;

   function "+"       (Left : Imaginary; Right : Real'Base) return Complex;
   function "+"       (Left : Real'Base; Right : Imaginary) return Complex;
   function "-"       (Left : Imaginary; Right : Real'Base) return Complex;
   function "-"       (Left : Real'Base; Right : Imaginary) return Complex;

   function "*"       (Left : Imaginary; Right : Real'Base) return Imaginary;
   function "*"       (Left : Real'Base; Right : Imaginary) return Imaginary;
   function "/"       (Left : Imaginary; Right : Real'Base) return Imaginary;
   function "/"       (Left : Real'Base; Right : Imaginary) return Imaginary;

private
   type Imaginary is new Real'Base;

   i : constant Imaginary := 1.0;
   j : constant Imaginary := 1.0;

   pragma Inline ("+");
   pragma Inline ("-");
   pragma Inline ("*");
   pragma Inline ("<");
   pragma Inline ("<=");
   pragma Inline (">");
   pragma Inline (">=");
   pragma Inline ("abs");
   pragma Inline (Compose_From_Cartesian);
   pragma Inline (Conjugate);
   pragma Inline (Im);
   pragma Inline (Re);
   pragma Inline (Set_Im);
   pragma Inline (Set_Re);

end Ada.Numerics.Generic_Complex_Types;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:52:45 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Sat Jan 29 17:10:25 1994;  author: dewar
--  Minor reformatting
--  Add pragma Inlines for many subprograms
--  ----------------------------
--  revision 1.4
--  date: Mon Jul 11 17:37:48 1994;  author: banner
--  Add pragma Pure per RM9X 5.0
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
