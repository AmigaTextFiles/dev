------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--          A D A . W I D E _ T E X T _ I O . C O M P L E X _ I O           --
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

with Ada.Numerics.Generic_Complex_Types;

generic
   with package Complex_Types is new Ada.Numerics.Generic_Complex_Types (<>);

package Ada.Wide_Text_IO.Complex_IO is

   use Complex_Types;

   Default_Fore : Field := 2;
   Default_Aft  : Field := Real'digits - 1;
   Default_Exp  : Field := 3;

   procedure Get
     (File  : in  File_Type;
      Item  : out Complex;
      Width : in  Field := 0);

   procedure Get
     (Item  : out Complex;
      Width : in  Field := 0);

   procedure Put
     (File : in File_Type;
      Item : in Complex;
      Fore : in Field := Default_Fore;
      Aft  : in Field := Default_Aft;
      Exp  : in Field := Default_Exp);

   procedure Put
     (Item : in Complex;
      Fore : in Field := Default_Fore;
      Aft  : in Field := Default_Aft;
      Exp  : in Field := Default_Exp);

   procedure Get
     (From : in  Wide_String;
      Item : out Complex;
      Last : out Positive);

   procedure Put
     (To   : out Wide_String;
      Item : in  Complex;
      Aft  : in  Field := Default_Aft;
      Exp  : in  Field := Default_Exp);

end Ada.Wide_Text_IO.Complex_IO;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.2
--  date: Sun Jan  9 10:58:08 1994;  author: dewar
--  New header with 1994 copyright
--  ----------------------------
--  revision 1.3
--  date: Tue Feb  1 12:08:33 1994;  author: dewar
--  Remove spurious character after end line
--  ----------------------------
--  revision 1.4
--  date: Fri Jul 22 11:31:23 1994;  author: dewar
--  Reformat specs to GNAT style
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
