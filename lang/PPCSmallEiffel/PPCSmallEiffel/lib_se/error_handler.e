--          This file is part of SmallEiffel The GNU Eiffel Compiler.
--          Copyright (C) 1994-98 LORIA - UHP - CRIN - INRIA - FRANCE
--            Dominique COLNET and Suzanne COLLIN - colnet@loria.fr 
--                       http://www.loria.fr/SmallEiffel
-- SmallEiffel is  free  software;  you can  redistribute it and/or modify it 
-- under the terms of the GNU General Public License as published by the Free
-- Software  Foundation;  either  version  2, or (at your option)  any  later 
-- version. SmallEiffel is distributed in the hope that it will be useful,but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-- or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU General Public License 
-- for  more  details.  You  should  have  received a copy of the GNU General 
-- Public  License  along  with  SmallEiffel;  see the file COPYING.  If not,
-- write to the  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
-- Boston, MA 02111-1307, USA.
--
class ERROR_HANDLER
   --
   -- The unique `eh' object for Warning, Error and Fatal Error
   -- handling.
   -- This handler use an assynchronous strategy.
   --
   
inherit
   GLOBALS 
      rename warning as global_warning, error as global_error
	 fatal_error as global_fatal_errror
      redefine nb_errors, nb_warnings 
      end;
   
creation make
   
feature 
   
   nb_errors, nb_warnings: INTEGER;
	 -- Global counters.

   no_warning: BOOLEAN;

feature {NONE}
   
   explanation: STRING is 
	 -- Current `explanation' text to be print with next Warning, 
	 -- the next Error or the next Fatal Error.
      once
	 !!Result.make(1024);
      end;
   
   positions: ARRAY[POSITION] is
	 -- Void or the list of `positions' to be show with next Warning, 
	 -- the next Error or the next Fatal Error.
      once
	 !!Result.with_capacity(5,1);
      end;

feature {NONE}
   
   make is
      do
      end;
   
feature 
   
   empty: BOOLEAN is
	 -- True when nothing stored in `explanation' and `positions'.
      do
	 Result := explanation.empty and then positions.empty;
      end;

   set_no_warning is
      do
	 no_warning := true;
      end;

feature 
   
   append(s: STRING) is
      -- Append text `s' to the current `explanation'.
      require
	 s /= Void;
	 not s.empty;
      do
	 explanation.append(s);
      ensure
	 not empty
      end;
   
   extend(c: CHARACTER) is
      -- Append `c' to the current `explanation'.
      do
	 explanation.extend(c);
      ensure
	 not empty
      end;
   
   add_position(p: POSITION) is
      -- If necessary, add `p' to the already known `positions'.
      do
	 if p /= Void then
	    if not positions.has(p) then
	       positions.add_last(p);
	    end;
	 end;
      end;
   
   add_type(t: TYPE; tail: STRING) is
      require
	 t /= Void
      do
	 append("Type ");
	 if t.is_run_type then
	    append(t.run_time_mark);
	 else
	    append(t.written_mark);
	 end;
	 append(tail);
	 add_position(t.start_position);
      end;
   
   print_as_warning is
	 -- Print `explanation' as a Warning report.
	 -- After printing, `explanation' and `positions' are reset.
      require
	 not empty
      do
	 if no_warning then
	    cancel;
	 else 
	    do_print("Warning");
	    incr_nb_warnings;
	 end;
      ensure
	 not no_warning implies (nb_warnings = old nb_warnings + 1);
      end;
   
   print_as_error is
	 -- Print `explanation' as an Error report.
	 -- After printing, `explanation' and `positions' are reset.
      require
	 not empty
      do
	 do_print("Error");
	 incr_nb_errors;
      ensure
	 nb_errors = old nb_errors + 1;
      end;
   
   print_as_fatal_error is
	 -- Print `explanation' as a Fatal Error.
	 -- Execution is stopped after this.
      do
	 do_print("Fatal Error");
	 die_with_code(exit_failure_code);
      end;
   
   warning(tail: STRING) is
	 -- Append the `tail' of the `explanation' an then `print_as_warning'.
      require
	 not tail.empty
      do
	 append(tail);
	 print_as_warning;
      ensure
	 empty
      end;
   
   error(tail: STRING) is
	 -- Append the `tail' of the `explanation' an then `print_as_error'.
      require
	 not tail.empty
      do
	 append(tail);
	 print_as_error;
      ensure
	 empty
      end;
   
   fatal_error(tail: STRING) is
	 -- Append the `tail' of the `explanation' an then 
	 -- `print_as_fatal_error'.
      require
	 not tail.empty
      do
	 explanation.append(tail);
	 print_as_fatal_error;
      end;
   
   cancel is
      -- Cancel a prepared report without printing it.
      do
	 explanation.clear;
	 positions.clear;
      ensure
	 empty
      end;
   
   incr_nb_errors is
      do
	 nb_errors := nb_errors + 1;
	 if nb_errors >= 6 then
	    std_error.put_string(fz_error_stars);
	    std_error.put_string("Too many errors.%N");
	    die_with_code(exit_failure_code);
	 end;
      end;
   
   incr_nb_warnings is
      do
	 nb_warnings := nb_warnings + 1;
      end;
   
feature {NONE}
   
   do_print(heading: STRING) is
      local
	 i, cpt: INTEGER;
	 cc, previous_cc: CHARACTER;
      do
	 std_error.put_string(fz_error_stars);
	 std_error.put_string(heading);
	 std_error.put_string(" : ");
	 from  
	    i := 1;
	    cpt := 9 + heading.count;
	 until 
	    i > explanation.count
	 loop
	    previous_cc := cc;
	    cc := explanation.item(i);
	    i := i + 1;
	    if cpt > 60 then
	       if cc = ' ' then
		  std_error.put_character('%N');
		  cpt := 0;
	       elseif previous_cc = ',' or else 
		  previous_cc = '/' 
		then
		  std_error.put_character('%N');
		  std_error.put_character(cc);
		  cpt := 1;
	       else
		  std_error.put_character(cc);
		  cpt := cpt + 1;
	       end;
	    else
	       std_error.put_character(cc);
	       inspect
		  cc
	       when '%N' then
		  cpt := 0;
	       else
		  cpt := cpt + 1;
	       end;
	    end;
	 end;
	 std_error.put_character('%N');
	 from  
	    i := positions.lower;
	 until
	    i > positions.upper
	 loop
	    positions.item(i).show;
	    i := i + 1;
	 end;
	 cancel;
	 std_error.put_string("------%N");
      ensure
	 empty
      end;

end -- ERROR_HANDLER

