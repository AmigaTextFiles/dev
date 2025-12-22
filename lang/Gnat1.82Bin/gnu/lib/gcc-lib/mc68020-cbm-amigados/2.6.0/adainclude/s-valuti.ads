------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                      S Y S T E M . V A L _ U T I L                       --
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

--  This package provides some common utilities used by the s-valxxx files

package System.Val_Util is
pragma Pure (Val_Util);

   procedure Normalize_String
     (S    : in out String;
      F, L : out Positive'Base);
   --  This procedure scans the string S setting F to be the index of the first
   --  non-blank character of S and L to be the index of the last non-blank
   --  character of S. Any lower case characters present in S will be folded
   --  to their upper case equivalent except for character literals. If S
   --  consists of entirely blanks then Constraint_Error is raised.
   --
   --  Note: if S is the null string, F is set to S'First, L to S'Last

   procedure Scan_Sign
     (Str   : String;
      Ptr   : access Positive'Base;
      Max   : Positive'Base;
      Minus : out Boolean;
      Start : out Positive);
   --  The Str, Ptr, Max parameters are as for the scan routines (Str is the
   --  string to be scanned starting at Ptr.all, and Max is the index of the
   --  last character in the string). Scan_Sign first scans out any initial
   --  blanks, raising Constraint_Error if the field is all blank. It then
   --  checks for and skips an initial plus or minus, requiring a non-blank
   --  character to follow (Constraint_Error is raised if plus or minus
   --  appears at the end of the string or with a following blank). Minus is
   --  set True if a minus sign was skipped, and False otherwise. On exit
   --  Ptr.all points to the character after the sign, or to the first
   --  non-blank character if no sign is present. Start is set to the point
   --  to the first non-blank character (sign or digit after it).
   --
   --  Note: if Str is null, i.e. if Max is less than Ptr, then this is a
   --  special case of an all-blank string, and Ptr is unchanged, and hence
   --  is greater than Max as required in this case.

   function Scan_Exponent
     (Str  : String;
      Ptr  : access Positive'Base;
      Max  : Positive'Base;
      Real : Boolean := False)
      return Integer;
   --  Called to scan a possible exponent. Str, Ptr, Max are as described above
   --  for Scan_Sign. If Ptr.all < Max and Str (Ptr.all) = 'E' or 'e', then an
   --  exponent is scanned out, with the exponent value returned in Exp, and
   --  Ptr.all updated to point past the exponent. If the exponent field is
   --  incorrectly formed or not present, then Ptr.all is unchanged, and the
   --  returned exponent value is zero. Real indicates whether a minus sign
   --  is permitted (True = permitted). Very large exponents are handled by
   --  returning a suitable large value. If the base is zero, then any value
   --  is allowed, and otherwise the large value will either cause underflow
   --  or overflow during the scaling process which is fine.

   procedure Scan_Trailing_Blanks (Str : String; P : Positive);
   --  Checks that the remainder of the field Str (P .. Str'Last) is all
   --  blanks. Raises Constraint_Error if a non-blank character is found.

end System.Val_Util;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.1
--  date: Fri Aug  5 14:51:44 1994;  author: dewar
--  Initial revision
--  ----------------------------
--  revision 1.2
--  date: Sat Aug  6 17:02:53 1994;  author: dewar
--  Change name from Scn_Utilities to Val_Util
--  Move Normalize_String here (was in separate file)
--  (Scan_Trailing_Blanks): New calling sequence
--  ----------------------------
--  revision 1.3
--  date: Wed Aug 31 00:07:08 1994;  author: dewar
--  (Normalize_String): Change F,L to Positive'Base (deal with null string)
--  (Scan_Sign): Document handling of null string, and change calling
--   sequence to accomodate null strings
--  (Scan_Exponent): Change Ptr/Max to Positive'Base to handle null strings
--  (Scan_Trailing_Blanks): Change P to Positive
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
