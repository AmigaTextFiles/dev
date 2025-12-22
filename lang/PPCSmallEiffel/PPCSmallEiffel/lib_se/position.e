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
class POSITION
--
-- A position in an Eiffel base class text.
--
   
inherit 
   GLOBALS 
      redefine is_equal, fill_tagged_out_memory 
      end;
   
creation make
   
creation {CLASS_NAME} with
   
feature 
   
   base_class_name: CLASS_NAME;
	 -- The corresponding Eiffel text of the position.

feature {NONE}

   mem_line_column: INTEGER;
	 -- Line and Column on a single INTEGER value (column must
	 -- less than 999).

feature
   
   line: INTEGER is
      do
	 Result := mem_line_column // 1000;
      end;

   column: INTEGER is
      do
	 Result := mem_line_column \\ 1000;
      end;
   
feature {NONE}
   
   with(li, co: INTEGER; bcn: like base_class_name) is
      require
	 li >= 1;
	 co >= 1;
	 bcn /= Void;
      do
	 mem_line_column := li * 1000 + co;
	 base_class_name := bcn;
      ensure	 
	 line = li;
	 column = co;
	 base_class_name = bcn;
      end;
   
   make(li, co: INTEGER) is
      require
	 li >= 1;
	 co >= 1;
	 eiffel_parser.is_running
      do
	 mem_line_column := li * 1000 + co;
	 base_class_name := eiffel_parser.current_class_name;
      ensure
	 line = li;
	 column = co;
	 base_class_name /= Void
      end;
   
feature    
   
   is_equal(other: like Current): BOOLEAN is
      do
	 Result := 
	    ((line = other.line) and then
	     (column = other.column) and then
	     (base_class_name /= Void) and then
	     (other.base_class_name /= Void) and then
	     (base_class_name.to_string = other.base_class_name.to_string));
      end;

   fill_tagged_out_memory is
      do
	 line.append_in(tagged_out_memory);
	 tagged_out_memory.extend('/');
	 column.append_in(tagged_out_memory);
	 if path /= Void then
	    tagged_out_memory.extend(' ');
	    tagged_out_memory.append(path);
	 end;
      end;

   before(other: like Current): BOOLEAN is
	 -- Is current position strictly before `other' (in 
	 -- the same base class).
      require
	 base_class_name = other.base_class_name
      do
	 if line < other.line then
	    Result := true;
	 elseif line = other.line then
	    Result := column < other.column;
	 end;
      end;

   base_class: BASE_CLASS is
      do
	 if eiffel_parser.is_running then
	    if base_class_name.to_string.empty then
	       fatal_error("Internal Error #1 in POSITION.");
	    elseif small_eiffel.is_used(base_class_name.to_string) then
	       Result := base_class_name.base_class;
	    else
	       fatal_error("Internal Error #2 in POSITION.");
	    end;
	 else
	    Result := base_class_name.base_class;
	 end;
      end;
   
   path: STRING is
      local
	 bcn: STRING;
	 bc: BASE_CLASS;
      do
	 bcn := base_class_name.to_string;
	 if bcn /= Void then
	    if small_eiffel.is_used(bcn) then
	       bc := base_class_name.base_class;
	    elseif eiffel_parser.is_running then
	       if eiffel_parser.current_class_name.to_string = bcn then
		  bc := eiffel_parser.current_class;
	       end;
	    else
	       bc := base_class_name.base_class;
	    end;
	    if bc /= Void then
	       Result := bc.path; 
	    end;
	 end;
      end;
   
   show is
      local
	 c: INTEGER;
	 nb: INTEGER;
	 n, str, the_line: STRING;
      do
	 n := base_class_name.to_string;
	 std_error.put_string("Line ");
	 std_error.put_integer(line);
	 std_error.put_string(" column ");
	 std_error.put_integer(column);
	 std_error.put_string(" in ");
	 std_error.put_string(n);
	 str := path; 
	 if str /= Void then
	    std_error.put_string(" (");
	    std_error.put_string(str);
	    std_error.put_character(')');
	 end;
	 std_error.put_string(" :%N");
	 the_line := get_line;
	 if the_line /= Void then
	    c := column;
	    std_error.put_string(the_line);
	    std_error.put_new_line;
	    from  
	       nb := 1;
	    until
	       nb = c
	    loop
	       if the_line.item(nb) = '%T' then
		  std_error.put_character('%T');
	       else
		  std_error.put_character(' ');
	       end;
	       nb := nb + 1;
	    end;
	    std_error.put_string("^%N");
	 else
	    std_error.put_string("SmallEiffel cannot load base class : ");
	    std_error.put_string(n);
	    std_error.put_string("%N");
	 end;
      end;

   append_in(str: STRING) is
      require
	 str /= Void
      do
	 str.append("Line ");
	 line.append_in(str);
	 str.append(" column ");
	 column.append_in(str);
	 str.append(" in %"");
	 str.append(path);
	 str.append(fz_03);
      end;

feature {EIFFEL_PARSER}

   set_line_column(li, co: INTEGER) is
      do
	 mem_line_column := li * 1000 + co;
      ensure 
	 line = li;
	 column = co
      end;

feature {NONE}

   get_line: STRING is
      local
	 p: like path;
	 i: INTEGER;
      do
	 p := path;
	 if p /= Void then
	    tmp_file_read.connect_to(p);
	    from
	    until
	       i = line
	    loop
	       tmp_file_read.read_line;
	       i := i + 1;
	    end;
	    Result := tmp_file_read.last_string;
	    tmp_file_read.disconnect;
	 end;
      end;

end -- POSITION

