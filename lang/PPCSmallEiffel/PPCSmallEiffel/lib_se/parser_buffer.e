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
class PARSER_BUFFER
   
inherit GLOBALS;
   
creation make
   
feature

   path: STRING;
	 -- When `is_ready', gives the `path' of the corresponding 
	 -- buffered file.
   
   count: INTEGER;
	 -- Number of lines in the source file.
   
feature {NONE}
   
   text: FIXED_ARRAY[STRING] is
	 -- To store the complete file to parse. Each line 
	 -- is one STRING without the '%N' end-of-line mark.
      once
	 !!Result.with_capacity(2048);
      end;

feature {NONE} -- Low level IO buffer :

   buffer_size: INTEGER is 4096;

   buffer: NATIVE_ARRAY[CHARACTER] is
      once
	 Result := Result.calloc(buffer_size);
      end;

feature {NONE}
   
   make is
      do
      end;

feature

   is_ready: BOOLEAN is
      do
	 Result := path /= Void;
      end;

feature {SMALL_EIFFEL,EIFFEL_PARSER}

   load_file(a_path: STRING) is
	 -- Try to load `a_path' and set `is_ready' when corresponding
	 -- file has been loaded.
      do
	 count := read_file(a_path);
	 if count >= 0 then
	    path := a_path;
	 else
	    path := Void;
	 end;
      end;

   unset_is_ready is
      do
	 path := Void;
      end;

feature {EIFFEL_PARSER}

   item(line: INTEGER): STRING is
      require 
	 is_ready;
	 1 <= line;
	 line <= count
      do
	 Result := text.item(line);
      ensure
	 Result /= Void
      end;
   
feature {NONE}
   
   read_file(a_path: STRING): INTEGER is
	 -- Result is -1 when `a_path' cannot be read.
	 -- Result gives the number of lines.
      local
	 p: POINTER;
	 file, i, nb_read: INTEGER;
	 c: CHARACTER;
	 line: STRING;
	 b: like buffer;
      do
	 p := a_path.to_external;
	 c_inline_c("_file=open(_p,O_RDONLY,0);");
	 if file >= 0 then
	    from
	       b := buffer; -- to speed up.
	       line := next_line(0); -- unused line.
	       line := next_line(1);
	       Result := 1;
	       nb_read := buffer_size;
	    until
	       nb_read < buffer_size
	    loop
	       nb_read := read(file,b,buffer_size);
	       from
		  i := 0;
	       until
		  i = nb_read
	       loop
		  c := b.item(i);
		  if c = '%N' then
		     Result := Result + 1;
		     line := next_line(Result);
		  elseif c = '%R' then
		  else
		     line.extend(c);
		  end;
		  i := i + 1;
	       end;
	    end;
	    if line.empty then
	       Result := Result - 1;
	    end;
	    file := close(file);
	 else
	    Result := -1;
	 end;
      end;
   
feature {NONE}

   read(file: INTEGER; buf: like buffer; n: INTEGER): INTEGER is
      external "C_InlineWithoutCurrent"
      end;

   close(file: INTEGER): INTEGER is
      external "C_InlineWithoutCurrent"
      end;

feature {NONE}

   next_line(i: INTEGER): STRING is
      require
	 i >= 0
      do
	 if i <= text.upper then
	    Result := text.item(i);
	    Result.clear;
	 else
	    !!Result.make(medium_line_size);
	    text.add_last(Result);
	 end;
      ensure
	 Result.empty;
	 Result.capacity >= medium_line_size;
	 text.item(i) = Result
      end;

   medium_line_size: INTEGER is 80;

end -- PARSER_BUFFER

