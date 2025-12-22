------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                     S Y S T E M . I M G _ W C H A R                      --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--                            $Revision: 1.7 $                              --
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

--  Wide_Character'Image

with System.WCh_Con;

package System.Img_WChar is
pragma Preelaborate (Img_WChar);

   function Image_Wide_Character
     (V    : Wide_Character;
      S    : access String;
      EM   : System.WCh_Con.WC_Encoding_Method)
      return Natural;
   --  Computes Wode_Character'Image (V) and stores the result in S (1 .. N)
   --  where N is the length of the image string. The value of N is returned
   --  as the result. The caller guarantees that the string is long enough.
   --  The argument EM is a constant representing the encoding method in use.
   --  The encoding method used is guaranteed to be consistent across a
   --  given program execution and to correspond to the method used in the
   --  source programs.

end System.Img_WChar;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Mon Jul 25 19:08:21 1994;  author: dewar
--  Get codes for encoding method from System.WIde_Character_Constants
--  ----------------------------
--  revision 1.6
--  date: Sat Aug  6 19:32:10 1994;  author: dewar
--  Change name of package to Img_WChar
--  ----------------------------
--  revision 1.7
--  date: Wed Aug 10 14:26:57 1994;  author: dewar
--  New more efficient calling sequence
--  Change pragma Pure to pragma Preelaborate
--  Remove use clause (not permitted by Rtsfind)
--  Change name Wide_Character_Constant to Wch_Con
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
