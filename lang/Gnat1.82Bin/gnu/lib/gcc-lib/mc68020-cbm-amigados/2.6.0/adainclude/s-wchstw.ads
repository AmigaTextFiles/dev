------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                       S Y S T E M . W C H _ S T W                        --
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

--  This package contains the routine used to convert strings to wide
--  strings for use by wide character attributes (value, image etc.)

with System.WCh_Con;

package System.WCh_StW is
pragma Pure (WCh_StW);

   function String_To_Wide_String
     (S    : String;
      EM   : System.WCh_Con.WC_Encoding_Method)
      return Wide_String;
   --  This routine simply takes its argument and converts it to wide string
   --  format. In the context of the Wide_Image attribute, the argument is
   --  the corresponding 'Image attribute. Any wide character escape sequences
   --  in the string are converted to the corresponding wide character value.
   --  No syntax checks are made, it is assumed that any such sequences are
   --  validly formed (this must be assured by the caller, and results from
   --  the fact that Wide_Image is only used on strings that have been built
   --  by the compiler, such as images of enumeration literals. If the method
   --  for encoding is a shift-in, shift-out convention, then it is assumed
   --  that normal (non-wide character) mode holds at the start and end of
   --  the argument string. EM indicates the wide character encoding method.

end System.WCh_StW;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Jul 22 01:06:23 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Mon Jul 25 19:08:47 1994;  author: dewar
--  Get codes for encoding method from System.WIde_Character_Constants
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 10 14:27:33 1994;  author: dewar
--  Change name of package to WCh_StW
--  Change name of function to String_To_Wide_String
--  Remove improper use clause (not allowed by Rtsfind)
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
