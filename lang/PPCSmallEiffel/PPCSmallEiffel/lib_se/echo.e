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
class ECHO
   -- **** CHATTER ?????? *****
   -- 
   -- Unique Global Object in charge of ECHOing some information
   -- messages during compilation for example.
   -- This object is used to implement the flag "-verbose".
   -- 
   --

inherit GLOBALS;

creation make

feature
   
   verbose: BOOLEAN;
	 -- Is `echo' verbose (default is false).

feature
   
   make is do end;

   set_verbose is
      do
	 verbose := true;
      end;

feature  -- To echo some additional information (echo is only done
	 -- when `verbose' is true).

   put_string(msg: STRING) is
      do
	 if verbose then
	    std_output.put_string(msg);
	    std_output.flush;
	 end;
      end;

   put_character(c: CHARACTER) is
      do
	 if verbose then
	    std_output.put_character(c);
	    std_output.flush;
	 end;
      end;

   put_new_line is
      do
	 if verbose then
	    std_output.put_new_line;
	 end;
      end;

   put_integer(i: INTEGER) is
      do
	 if verbose then
	    std_output.put_integer(i);
	    std_output.flush;
	 end;
      end;

   put_double_format(d: DOUBLE; f: INTEGER) is
      do
	 if verbose then
	    std_output.put_double_format(d,f);
	    std_output.flush;
	 end;
      end;

   file_removing(path: STRING) is
         -- If `path' is an existing file, echo a message on `std_output'
         -- while removing the file.
         -- Otherwise, do nothing.
      require
         path /= Void
      do
	 if file_exists(path) then
	    put_string("Removing %"");
	    put_string(path);
	    put_string("%"%N");
	    remove_file(path);
	 end;
      ensure
         not file_exists(path)
      end;

   sfr_connect(sfr: STD_FILE_READ; path: STRING) is
      require
	 not sfr.is_connected;
	 path /= Void
      do
	 put_string("Try to read file %"");
	 put_string(path);
	 put_string("%".%N");
	 sfr.connect_to(path);
      end;

   call_system(cmd: STRING) is 
      require
	 cmd.count > 0
      do
	 put_string("System call %"");
	 put_string(cmd);
         put_string(fz_18);
	 system(cmd);
      end;

   print_count(msg: STRING; count: INTEGER) is
      require
	 count >= 0;
      do
	 if verbose then
	    if count > 0 then
	       put_string("Total ");
	       put_string(msg);
	       if count > 1 then
		  put_character('s');
	       end;
	       put_string(": ");
	       put_integer(count);
	       put_string(fz_b6);
	    else
	       put_string("No ");
	       put_string(msg);
	       put_string(fz_b6);
	    end;
	 end;
      end;

feature  -- To echo some warning or some problem (echo is done whathever 
	 -- the value of `verbose').

   w_put_string(msg: STRING) is
      do
	 std_error.put_string(msg);
	 std_error.flush;
      end;

   w_put_character(c: CHARACTER) is
      do
	 std_error.put_character(c);
	 std_error.flush;
      end;
	 
   w_put_integer(i: INTEGER) is
      do
	 std_error.put_integer(i);
	 std_error.flush;
      end;

end -- ECHO


