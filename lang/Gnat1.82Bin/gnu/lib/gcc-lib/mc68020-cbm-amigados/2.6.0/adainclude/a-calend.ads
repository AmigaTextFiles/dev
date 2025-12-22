------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                         A D A . C A L E N D A R                          --
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

package Ada.Calendar is

   type Time is private;

   --  Declarations representing limits of allowed local time values. Note that
   --  these do NOT constrain the possible stored values of time which may well
   --  permit a larger range of times (this is explicitly allowed in Ada 9X).

   subtype Year_Number  is Integer range 1901 .. 2099;
   subtype Month_Number is Integer range 1 .. 12;
   subtype Day_Number   is Integer range 1 .. 31;

   subtype Day_Duration is Duration; -- range 0.0 .. 86_400.0
   --  We don't have subtype ranges yet for real types, fix this later ???

   function Clock return Time;

   function Year    (Date : Time) return Year_Number;
   function Month   (Date : Time) return Month_Number;
   function Day     (Date : Time) return Day_Number;
   function Seconds (Date : Time) return Day_Duration;

   procedure Split
     (Date    : Time;
      Year    : out Year_Number;
      Month   : out Month_Number;
      Day     : out Day_Number;
      Seconds : out Day_Duration);

   function Time_Of
     (Year    : Year_Number;
      Month   : Month_Number;
      Day     : Day_Number;
      Seconds : Day_Duration := 0.0)
      return    Time;

   function "+" (Left : Time;     Right : Duration) return Time;
   function "+" (Left : Duration; Right : Time)     return Time;
   function "-" (Left : Time;     Right : Duration) return Time;
   function "-" (Left : Time;     Right : Time)     return Duration;

   function "<"  (Left, Right : Time) return Boolean;
   function "<=" (Left, Right : Time) return Boolean;
   function ">"  (Left, Right : Time) return Boolean;
   function ">=" (Left, Right : Time) return Boolean;

   Time_Error : exception;

private
   pragma Inline (Clock);

   pragma Inline (Year);
   pragma Inline (Month);
   pragma Inline (Day);

   pragma Inline ("+");
   pragma Inline ("-");

   pragma Inline ("<");
   pragma Inline ("<=");
   pragma Inline (">");
   pragma Inline (">=");

   --  Time is represented as a signed duration from the base point which is
   --  what Unix calls the EPOCH (i.e. 12 midnight (24:00:00), Dec 31st, 1969,
   --  or if you prefer 0:00:00 on Jan 1st, 1970). Since Ada allows dates
   --  before this EPOCH value, the stored duration value may be negative.

   --  The time value stored is typically a GMT value, as provided in standard
   --  Unix environments. If this is the case then Split and Time_Of perform
   --  required conversions to and from local times. The range of times that
   --  can be stored in Time values depends on the declaration of the type
   --  Duration, which must at least cover the required Ada range represented
   --  by the declaration of Year_Number, but may be larger (we take full
   --  advantage of the new permission in Ada 9X to store time values outside
   --  the range that would be acceptable to Split). The Duration type is a
   --  real value representing a time interval in seconds.

   type Time is new Duration;

end Ada.Calendar;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.5
--  date: Wed Jan 19 01:26:58 1994;  author: banner
--  style conformance.
--  ----------------------------
--  revision 1.6
--  date: Fri Feb  4 11:07:28 1994;  author: dewar
--  (Clock): Add pragma Inline for Clock
--  ----------------------------
--  revision 1.7
--  date: Wed May  4 13:22:27 1994;  author: dewar
--  Time is now derived from Duration, instead of being a record with a single
--   field of type Duration
--  Minor reformatting
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
