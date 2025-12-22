------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUNTIME COMPONENTS                          --
--                                                                          --
--                         A D A . C A L E N D A R                          --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--                            $Revision: 1.21 $                             --
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

with System; use System;
with System.Task_Clock;
with System.Task_Clock.Machine_Specifics;

package body Ada.Calendar is

   ------------------------------
   -- Use of Pragma Unsuppress --
   ------------------------------

   --  This implementation of Calendar takes advantage of the permission in
   --  Ada 9X of using arithmetic overflow checks to check for out of bounds
   --  time values. This means that we must catch the constraint error that
   --  results from arithmetic overflow, so we use pragma Unsuppress to make
   --  sure that overflow is enabled, using software overflow checking if
   --  necessary. That way, compiling Calendar with options to suppress this
   --  checking will not affect its correctness.

   ------------------------
   -- Local Declarations --
   ------------------------

   type Char_Pointer is access Character;

   type tm is record
      tm_sec    : Integer range 0 .. 60;  -- seconds after the minute
      tm_min    : Integer range 0 .. 59;  -- minutes after the hour
      tm_hour   : Integer range 0 .. 23;  -- hours since midnight
      tm_mday   : Integer range 1 .. 31;  -- day of the month
      tm_mon    : Integer range 0 .. 11;  -- months since January
      tm_year   : Integer;                -- years since 1900
      tm_wday   : Integer range 0 .. 6;   -- days since Sunday
      tm_yday   : Integer range 0 .. 365; -- days since January 1
      tm_isdst  : Integer range -1 .. 1;  -- Daylight Savings Time flag
      tm_gmtoff : Long_Integer;           -- offset from CUT in seconds
      tm_zone   : Char_Pointer;           -- timezone abbreviation
   end record;

   type tm_Pointer is access tm;

   subtype time_t is Long_Integer;

   type time_t_Pointer is access time_t;

   function localtime (C : time_t_Pointer) return tm_Pointer;
   pragma Import (C, localtime);

   function mktime (TM : tm_Pointer) return time_t;
   pragma Import (C, mktime);
   --  mktime returns -1 in case the calendar time given by components of
   --  TM.all cannot be represented.

   --  The following constants are used in adjusting Ada dates so that they
   --  fit into the range that can be handled by Unix (1970 - 2038). The trick
   --  is that the number of days in any four year period in the Ada range of
   --  years (1901 - 2099) has a constant number of days. This is because we
   --  have the special case of 2000 which, contrary to the normal exception
   --  for centuries, is a leap year after all.

   Unix_Year_Min       : constant := 1970;
   Unix_Year_Max       : constant := 2038;

   --  These values is to find the maximum Duration vaules
   --  For Time used in Split. (MaxD and MinD)

   Unix_Year_Min_In_Duration : constant Duration :=
     Duration (Time_Of (Unix_Year_Min, 1, 1, 0.0));
   Unix_Year_Max_In_Duration : constant Duration :=
     Duration (Time_Of (Unix_Year_Max, 1, 1, 0.0));

   Ada_Year_Min        : constant := 1901;
   Ada_Year_Max        : constant := 2099;

   Days_In_Month       : constant array (Month_Number) of Day_Number :=
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

   Days_In_4_Years     : constant := 365 * 3 + 366;
   Seconds_In_4_Years  : constant := 86_400 * Days_In_4_Years;
   Seconds_In_4_YearsD : constant Duration := Duration (Seconds_In_4_Years);

   ---------
   -- "+" --
   ---------

   function "+" (Left : Time; Right : Duration) return Time is
      pragma Unsuppress (Overflow_Check);
   begin
      return (Left + Time (Right));
   exception
      when Constraint_Error => raise Time_Error;
   end "+";

   function "+" (Left : Duration; Right : Time) return Time is
      pragma Unsuppress (Overflow_Check);
   begin
      return (Time (Left) + Right);
   exception
      when Constraint_Error => raise Time_Error;
   end "+";

   ---------
   -- "-" --
   ---------

   function "-" (Left : Time; Right : Duration)  return Time is
      pragma Unsuppress (Overflow_Check);
   begin
      return Left - Time (Right);
   exception
      when Constraint_Error => raise Time_Error;
   end "-";

   function "-" (Left : Time; Right : Time) return Duration is
      pragma Unsuppress (Overflow_Check);
   begin
      return Duration (Left) - Duration (Right);
   exception
      when Constraint_Error => raise Time_Error;
   end "-";

   ---------
   -- "<" --
   ---------

   function "<" (Left, Right : Time) return Boolean is
   begin
      return Duration (Left) < Duration (Right);
   end "<";

   ----------
   -- "<=" --
   ----------

   function "<=" (Left, Right : Time) return Boolean is
   begin
      return Duration (Left) <= Duration (Right);
   end "<=";

   ---------
   -- ">" --
   ---------

   function ">" (Left, Right : Time) return Boolean is
   begin
      return Duration (Left) > Duration (Right);
   end ">";

   ----------
   -- ">=" --
   ----------

   function ">=" (Left, Right : Time) return Boolean is
   begin
      return Duration (Left) >= Duration (Right);
   end ">=";

   -----------
   -- Clock --
   -----------

   --  The Ada.Calendar.Clock function gets the time from the GNULLI
   --  interface routines. This ensures that Calendar is properly
   --  coordinated with the tasking runtime. Any system dependence
   --  involved in reading the clock is then hidden in the GNULLI
   --  implementation layer (in the body of System.Task_Clock).

   function Clock return Time is
   begin
      return Time (Task_Clock.Stimespec_To_Duration (
            Task_Clock.Machine_Specifics.Clock));
   end Clock;

   ---------
   -- Day --
   ---------

   function Day (Date : Time) return Day_Number is
      DY : Year_Number;
      DM : Month_Number;
      DD : Day_Number;
      DS : Day_Duration;

   begin
      Split (Date, DY, DM, DD, DS);
      return DD;
   end Day;

   -----------
   -- Month --
   -----------

   function Month (Date : Time) return Month_Number is
      DY : Year_Number;
      DM : Month_Number;
      DD : Day_Number;
      DS : Day_Duration;

   begin
      Split (Date, DY, DM, DD, DS);
      return DM;
   end Month;

   -------------
   -- Seconds --
   -------------

   function Seconds (Date : Time) return Day_Duration is
      DY : Year_Number;
      DM : Month_Number;
      DD : Day_Number;
      DS : Day_Duration;

   begin
      Split (Date, DY, DM, DD, DS);
      return DS;
   end Seconds;

   -----------
   -- Split --
   -----------

   procedure Split
     (Date    : Time;
      Year    : out Year_Number;
      Month   : out Month_Number;
      Day     : out Day_Number;
      Seconds : out Day_Duration)
   is
      pragma Unsuppress (Overflow_Check);

      --  The following declare bounds for duration that are comfortably
      --  wider than the maximum allowed output result for the Ada range
      --  of representable split values. These are used for a quick check
      --  that the value is not wildly out of range.

      Low  : constant := (Ada_Year_Min - Unix_Year_Min - 2) * 365 * 86_400;
      High : constant := (Ada_Year_Max - Unix_Year_Max + 2) * 365 * 86_400;

      LowD  : constant Duration :=
        Duration (Low) + Unix_Year_Min_In_Duration;
      HighD : constant Duration :=
        Duration (High) + Unix_Year_Max_In_Duration;

      --  The following declare the maximum duration value that can be
      --  successfully converted to a 32-bit integer suitable for passing
      --  to the localtime function. It might be more correct to use the
      --  value Integer'Last here, but it is actually more conservative
      --  to use the given value, since we are not really sure that the
      --  range of allowable times expands on 64-bit machines!

      Max_Time  : constant := 2 ** 31 - 1;
      Max_TimeD : constant Duration := Duration (Max_Time);

      --  Finally the actual variables used in the computation

      D                : Duration := Duration (Date);
      Years_Adjust     : Integer  := 0;
      Adjusted_Seconds : aliased time_t;
      Tm_Val           : tm_Pointer;

   begin
      --  First of all, filter out completely ludicrous values. Remember
      --  that we use the full stored range of duration values, which may
      --  be significantly larger than the allowed range of Ada times. Note
      --  that these checks are wider than required to make absolutely sure
      --  that there are no end effects from time zone differences.

      if D < LowD or else D > HighD then
         raise Time_Error;
      end if;

      --  The unix localtime function is more or less exactly what we need
      --  here. The less comes from the fact that it does not support the
      --  required range of years (the guaranteed range available is only
      --  EPOCH through EPOCH + N seconds). N is in practice 2 ** 31 - 1.

      --  If we have a value outside this range, then we first adjust it
      --  to be in the required range by adding multiples of four years.
      --  For the range we are interested in, the number of days in any
      --  consecutive four year period is constant. Then we do the split
      --  on the adjusted value, and readjust the years value accordingly.

      while D < 0.0 loop
         D := D + Seconds_In_4_YearsD;
         Years_Adjust := Years_Adjust - 4;
      end loop;

      while D > Max_TimeD loop
         D := D - Seconds_In_4_YearsD;
         Years_Adjust := Years_Adjust + 4;
      end loop;

      Adjusted_Seconds := time_t (D);
      Tm_Val := localtime (Adjusted_Seconds'access);

      Year   := Tm_Val.tm_year + 1900 + Years_Adjust;
      Month  := Tm_Val.tm_mon + 1;
      Day    := Tm_Val.tm_mday;

      --  The Seconds value is a little complex. The localtime function
      --  returns the integral number of seconds, which is what we want,
      --  but we want to retain the fractional part from the original
      --  Time value, since this is typically stored more accurately.

      Seconds := Duration (Tm_Val.tm_hour * 3600 +
                           Tm_Val.tm_min  * 60 +
                           Tm_Val.tm_sec)
                   + (D - Duration (Long_Long_Integer (D)));

   --  The exception handler catches the case of a result Year out of range.
   --  This can happen despite the entry test which was deliberately crude.
   --  Trying to make it accurate is impossible because of time zone adjust
   --  issues affecting the exact boundary (it is an interesting fact that
   --  whether or not a given time value gets Time_Error when split depends
   --  on the current time zone).

   exception
      when Constraint_Error => raise Time_Error;

   end Split;

   -------------
   -- Time_Of --
   -------------

   function Time_Of
     (Year    : Year_Number;
      Month   : Month_Number;
      Day     : Day_Number;
      Seconds : Day_Duration := 0.0)
      return    Time
   is
      Result_Secs : aliased time_t;
      TM_Val      : aliased tm;
      Int_Secs    : constant Integer := Integer (Seconds - 0.5);

      Year_Val        : Integer := Year;
      Duration_Adjust : Duration := 0.0;

   begin
      --  The following checks are redundant with respect to the constraint
      --  error checks that should normally be made on parameters, but we
      --  decide to raise Constraint_Error in any case if bad values come
      --  in (as a result of checks being off in the caller, or for other
      --  erroneous or bounded error cases). Note that eventually, when we
      --  implement the attribute 'Valid, it should be used here instead ???

      if Integer (Year) not in Year_Number
        or else Integer (Month) not in Month_Number
        or else Integer (Day) < 1
        or else Seconds < 0.0
        or else Seconds > 86_400.0
      then
         raise Constraint_Error;
      end if;

      --  Check for Day value too large

      if (Year mod 4 = 0) and then Month = 2 then
         if Day > 29 then
            raise Time_Error;
         end if;
      elsif Day > Days_In_Month (Month) then
         raise Time_Error;
      end if;

      --  Note: the mktime function supposedly does some error checking, but
      --  at least on some systems it isn't strong enough, which is why we
      --  do our own checking in the code above.

      TM_Val.tm_sec  := Int_Secs mod 60;
      TM_Val.tm_min  := (Int_Secs / 60) mod 60;
      TM_Val.tm_hour := (Int_Secs / 60) / 60;
      TM_Val.tm_mday := Day;
      TM_Val.tm_mon  := Month - 1;

      --  For the year, we have to adjust it to a year that Unix can handle.
      --  We do this in four year steps, since the number of days in four
      --  years is constant, so the timezone effect on the conversion from
      --  local time to GMT is unaffected.

      while Year_Val <= Unix_Year_Min loop
         Year_Val := Year_Val + 4;
         Duration_Adjust := Duration_Adjust - Seconds_In_4_YearsD;
      end loop;

      while Year_Val >= Unix_Year_Max loop
         Year_Val := Year_Val - 4;
         Duration_Adjust := Duration_Adjust + Seconds_In_4_YearsD;
      end loop;

      TM_Val.tm_year := Year_Val - 1900;

      --  Since we do not have information on daylight savings,
      --  rely on the default information.
      TM_Val.tm_isdst := -1;

      Result_Secs := mktime (TM_Val'access);

      --  That gives us the basic value in seconds. Two adjustments are
      --  needed. First we must undo the year adjustment carried out above.
      --  Second we put back the fraction seconds value since in general the
      --  Day_Duration value we received has additional precision which we
      --  do not want to lose in the constructed result.

      return
        Time (Duration (Result_Secs) +
              Duration_Adjust +
              (Seconds - Duration (Int_Secs)));
   end Time_Of;

   ----------
   -- Year --
   ----------

   function Year (Date : Time) return Year_Number is
      DY : Year_Number;
      DM : Month_Number;
      DD : Day_Number;
      DS : Day_Duration;

   begin
      Split (Date, DY, DM, DD, DS);
      return DY;
   end Year;

end Ada.Calendar;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.19
--  date: Sat May 21 09:02:06 1994;  author: dewar
--  Remove junk with of Text_Io
--  ----------------------------
--  revision 1.20
--  date: Sun May 22 16:53:07 1994;  author: giering
--  Changed "belt-and-suspenders" check on the parameters to Time_Of
--   to raise Constraint_Error instead of Time_Error.
--  ----------------------------
--  revision 1.21
--  date: Mon Jun  6 07:18:05 1994;  author: dewar
--  Remove obsolete pragma Checks_On
--  Replace with selective use of pragma Unsuppress at appropriate points
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
