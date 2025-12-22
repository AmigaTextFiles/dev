------------------------------------------------------------------------------
--                                                                          --
--                 GNU ADA RUNTIME LIBRARY (GNARL) COMPONENTS               --
--                                                                          --
--                     S Y S T E M . T A S K _ C L O C K                    --
--                                                                          --
--                                  B o d y                                 --
--                                                                          --
--                             $Revision: 1.10 $                             --
--                                                                          --
--           Copyright (c) 1991,1992,1993, FSU, All Rights Reserved         --
--                                                                          --
--  GNARL is free software; you can redistribute it and/or modify it  under --
--  terms  of  the  GNU  Library General Public License as published by the --
--  Free Software Foundation; either version 2,  or (at  your  option)  any --
--  later  version.   GNARL is distributed in the hope that it will be use- --
--  ful, but but WITHOUT ANY WARRANTY; without even the implied warranty of --
--  MERCHANTABILITY  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Gen- --
--  eral Library Public License for more details.  You should have received --
--  a  copy of the GNU Library General Public License along with GNARL; see --
--  file COPYING. If not, write to the Free Software Foundation,  675  Mass --
--  Ave, Cambridge, MA 02139, USA.                                          --
--                                                                          --
------------------------------------------------------------------------------

package body System.Task_Clock is

   -----------------------
   -- Stimespec_Seconds --
   -----------------------

   function Stimespec_Seconds (TV : Stimespec) return Integer is
   begin
      return Integer (TV.Val / Stimespec_Sec_Unit.Val);
   end Stimespec_Seconds;

   ------------------------
   -- Stimespec_Nseconds --
   -------------------------

   function Stimespec_NSeconds (TV : Stimespec) return Integer is
   begin
      return
        Integer (TV.Val - Time_Base (Stimespec_Seconds (TV)) *
          Stimespec_Sec_Unit.Val);
   end Stimespec_NSeconds;

   -------------
   -- Time_Of --
   -------------

   function Time_Of (S, NS : Integer) return Stimespec is
   begin
      return Stimespec' (Val => Stimespec_Sec_Unit.Val * Time_Base (S) +
        Time_Base (NS));
   end Time_Of;

   ---------------------------
   -- Stimespec_To_Duration --
   ---------------------------

   function Stimespec_To_Duration (TV : Stimespec) return Duration is
   begin
      return Duration (long_float (TV.Val) / 10#1.0#E9);
   end Stimespec_To_Duration;

   ---------------------------
   -- Duration_To_Stimespec --
   ---------------------------

   function Duration_To_Stimespec (Time : Duration) return Stimespec is
   begin
      return Stimespec' (Val => Time_Base (Time * 10#1.0#E9));
   end Duration_To_Stimespec;

   ---------
   -- "-" --
   ---------

   --  Unary minus
   function "-" (TV : Stimespec) return Stimespec is
   begin
      return Stimespec' (Val => -TV.Val);
   end "-";

   ---------
   -- "+" --
   ---------

   function "+" (LTV, RTV : Stimespec) return Stimespec is
   begin
      return Stimespec' (Val => LTV.Val + RTV.Val);
   end "+";

   ---------
   -- "-" --
   ---------

   function "-" (LTV, RTV : Stimespec) return Stimespec is
   begin
      return Stimespec' (Val => LTV.Val - RTV.Val);
   end "-";

   ---------
   -- "*" --
   ---------

   function "*" (TV : Stimespec; N : Integer) return Stimespec is
   begin
      return Stimespec' (Val => TV.Val * Time_Base (N));
   end "*";

   ---------
   -- "/" --
   ---------

   --  Integer division of Stimespec

   function "/" (TV : Stimespec; N : Integer) return Stimespec is
   begin
      return Stimespec' (Val => TV.Val / Time_Base (N));
   end "/";

   ---------
   -- "/" --
   ---------

   function "/" (LTV, RTV : Stimespec) return Integer is
   begin
      return Integer (LTV.Val / RTV.Val);
   end "/";

   ---------
   -- "<" --
   ---------

   function "<" (LTV, RTV : Stimespec) return Boolean is
   begin
      return LTV.Val < RTV.Val;
   end "<";

   ----------
   -- "<=" --
   ----------

   function "<=" (LTV, RTV : Stimespec) return Boolean is
   begin
      return LTV.Val < RTV.Val or else RTV.Val = LTV.Val;
   end "<=";

   ---------
   -- ">" --
   ---------

   function ">" (LTV, RTV : Stimespec) return Boolean is
   begin
      return RTV.Val < LTV.Val;
   end ">";

   ----------
   -- ">=" --
   ----------

   function ">=" (LTV, RTV : Stimespec) return Boolean is
   begin
      return LTV.Val > RTV.Val or LTV.Val = RTV.Val;
   end ">=";

end System.Task_Clock;


----------------------
-- REVISION HISTORY --
----------------------

--  ----------------------------
--  revision 1.8
--  date: Thu May 12 15:53:13 1994;  author: giering
--  Fixing misused Stimespec_Unit. Fixing conversion errors
--  ----------------------------
--  revision 1.9
--  date: Tue May 17 13:23:09 1994;  author: giering
--  1) New definition for ( Stimespec / Stimespec ).
--  2) Function comments modification.
--  ----------------------------
--  revision 1.10
--  date: Thu Jun  2 18:08:51 1994;  author: giering
--  Deleting with System.Std
--  Checked in from FSU by doh.
--  ----------------------------
--  New changes after this line.  Each line starts with: "--  "
