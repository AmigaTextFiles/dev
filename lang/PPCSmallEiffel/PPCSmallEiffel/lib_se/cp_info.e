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
class CP_INFO
   --  
   -- Print a human readable version of a JVM *.class generated
   -- by SmallEiffel.
   --

inherit 
   CP_INFO_TAGS
      redefine fill_tagged_out_memory 
      end;

creation clear

feature {NONE}

   tag: CHARACTER; -- Must be one defined in CP_INFO_TAGS.
   
   info: STRING; -- Contains the corresponding information.

feature {CONSTANT_POOL}

   clear is
      do
	 tag := empty_code;
	 if info = Void then
	    !!info.make(4);
	 else 
	    info.clear;
	 end;
      end;

   is_tagged(tag_value: CHARACTER): BOOLEAN is
      do
	 Result := tag = tag_value;
      end;

feature

   set_class(i: STRING) is
      require
	 i.count = 2
      do
	 tag := class_code;
	 info.copy(i);
      end;

   set_fieldref(i: STRING) is
      require
	 i.count = 4
      do
	 tag := fieldref_code;
	 info.copy(i);
      end;

   set_methodref(i: STRING) is
      require
	 i.count = 4
      do
	 tag := methodref_code;
	 info.copy(i);
      end;

   set_interface_methodref(i: STRING) is
      require
	 i.count = 4
      do
	 tag := interface_methodref_code;
	 info.copy(i);
      end;

   set_string(str: STRING) is
      require
	 str.count >= 2
      local
	 i: INTEGER;
	 c: CHARACTER;
      do
	 tag := string_code;
	 info.clear;
	 info.extend(str.item(1));
	 info.extend(str.item(2));
	 from
	    i := 3;
	 until
	    i > str.count
	 loop
	    c := str.item(i);
	    if c = '%U' then
	       info.extend('%/192/');
	       info.extend('%/128/');
	    else
	       info.extend(c);
	    end;
	    i := i + 1;
	 end;
      end;

   set_integer(i: STRING) is
      require
	 i.count = 4
      do
	 tag := integer_code;
	 info.copy(i);
      end;

   set_float(i: STRING) is
      require
	 i.count = 4
      do
	 tag := float_code;
	 info.copy(i);
      end;

   set_long(i: STRING) is
      require
	 i.count = 8
      do
	 tag := long_code;
	 info.copy(i);
      end;

   set_double(i: STRING) is
      require
	 i.count = 8
      do
	 tag := double_code;
	 info.copy(i);
      end;

   set_name_and_type(i: STRING) is
      require
	 i.count = 4
      do
	 tag := name_and_type_code;
	 info.copy(i);
      end;

   set_uft8(i: STRING) is
      require
	 i.count >= 2
      do
	 tag := uft8_code;
	 info.copy(i);
      ensure
	 info.count = u2_to_integer(1) + 2
      end;

feature -- Testing :

   is_class: BOOLEAN is
      do
	 Result := tag = class_code;
      end;

   is_fieldref: BOOLEAN is
      do
	 Result := tag = fieldref_code;
      end;

   is_methodref: BOOLEAN is
      do
	 Result := tag = methodref_code;
      end;

   is_interface_methodref: BOOLEAN is
      do
	 Result := tag = interface_methodref_code;
      end;

   is_string: BOOLEAN is
      do
	 Result := tag = string_code;
      end;

   is_integer: BOOLEAN is
      do
	 Result := tag = integer_code;
      end;

   is_float: BOOLEAN is
      do
	 Result := tag = float_code;
      end;

   is_long: BOOLEAN is
      do
	 Result := tag = long_code;
      end;

   is_double: BOOLEAN is
      do
	 Result := tag = double_code;
      end;

   is_name_and_type: BOOLEAN is
      do
	 Result := tag = name_and_type_code;
      end;

   is_uft8: BOOLEAN is
      do
	 Result := tag = uft8_code;
      end;

feature 

   view_in(str: STRING) is
	 -- Append in `str' a human readable version.
	 -- Note: assume `constant_pool' is checked.
      local
	 idx, length, i: INTEGER;
      do
	 inspect
	    tag
	 when class_code then
	    idx := u2_to_integer(1);
	    constant_pool.view_in(str,idx);
	 when fieldref_code then
	    idx := u2_to_integer(1);
	    constant_pool.view_in(str,idx);
	    str.extend('.');
	    idx := u2_to_integer(3);
	    constant_pool.view_in(str,idx);
	 when methodref_code then
	    idx := u2_to_integer(1);
	    constant_pool.view_in(str,idx);
	    str.extend('.');
	    idx := u2_to_integer(3);
	    constant_pool.view_in(str,idx);
	 when interface_methodref_code then
	 when string_code then
	    idx := u2_to_integer(1);
	    constant_pool.view_in(str,idx);
	 when integer_code then
	 when float_code then
	 when long_code then
	 when double_code then
	 when name_and_type_code then
	    idx := u2_to_integer(1);
	    constant_pool.view_in(str,idx);
	    str.extend(':');
	    idx := u2_to_integer(3);
	    constant_pool.view_in(str,idx);
	 when uft8_code then
	    from
	       length := u2_to_integer(1);
	       i := 3;
	    until
	       length = 0
	    loop
	       str.extend(info.item(i));
	       i := i + 1;
	       length := length - 1;
	    end;
	 end;
      end;

feature {CONSTANT_POOL}

   b_put is
      do
	 jvm.b_put_u1(tag)
	 jvm.b_put_byte_string(info);
      end;

feature {CONSTANT_POOL} -- Update and search :
   -- *** ACOMPLETER AU FUR ET A MESURE ***

   is_class_idx(uft8: INTEGER): BOOLEAN is
      do
	 if class_code = tag then
	    Result := u2_to_integer(1) = uft8;
	 end;
      end;

   is_fieldref_idx(c, nt: INTEGER): BOOLEAN is
      do
	 if fieldref_code = tag then
	    if u2_to_integer(1) = c then
	       Result := u2_to_integer(3) = nt;
	    end;
	 end;
      end;
   
   is_methodref_idx(c, nt: INTEGER): BOOLEAN is
      do
	 if methodref_code = tag then
	    if u2_to_integer(1) = c then
	       Result := u2_to_integer(3) = nt;
	    end;
	 end;
      end;

   is_name_and_type_idx(n, d: INTEGER): BOOLEAN is
      do
	 if name_and_type_code = tag then
	    if u2_to_integer(1) = n then
	       Result := u2_to_integer(3) = d;
	    end;
	 end;
      end;
   
   is_string_idx(uft8: INTEGER): BOOLEAN is
      do
	 if string_code = tag then
	    Result := u2_to_integer(1) = uft8;
	 end;
      end;

   is_uft8_idx(contents: STRING): BOOLEAN is
      local
	 i1, i2: INTEGER;
      do
	 if uft8_code = tag then
	    if u2_to_integer(1) = contents.count then
	       from
		  i1 := contents.count + 1;
		  i2 := info.count + 1;
		  check
		     i1 + 2 = i2
		  end;
		  Result := true;
	       until
		  not Result or else i1 = 1
	       loop
		  i1 := i1 - 1;
		  i2 := i2 - 1;
		  Result := contents.item(i1) = info.item(i2);
	       end;
	    end;
	 end;
      end;

feature

   fill_tagged_out_memory is
      do
	 tagged_out_memory.append("tag=");
	 tag.code.append_in(tagged_out_memory);
	 tagged_out_memory.extend('%"');
	 tagged_out_memory.append(info);	 
	 tagged_out_memory.extend('%"');
      end;

feature {NONE}

   u2_to_integer(i: INTEGER): INTEGER is
      do
	 Result := info.item(i).to_integer * 256;
	 Result := Result + info.item(i + 1).to_integer;
      end;

end -- CP_INFO

