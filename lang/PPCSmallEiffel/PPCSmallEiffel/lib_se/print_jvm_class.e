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
class PRINT_JVM_CLASS
   --
   -- The SmallEiffel bytecode disassembler.
   --

inherit CP_INFO_TAGS;

creation make

feature

   make is
      local
	 path: STRING;
      do
	 if argument_count /= 1 then
	    std_output.put_string(
             "Usage: print_jvm_class <ClassFilePath>[.class]%N");
	 else
	    path := argument(1).twin;
	    if not path.has_suffix(".class") then
	       path.append(".class");
	    end;
	    !!file_of_bytes.connect_to(path);
	    if file_of_bytes.is_connected then
	       print_jvm_class;
	       file_of_bytes.disconnect;
	    else
	       std_output.put_string("File %"");
	       std_output.put_string(path);
	       std_output.put_string("%" not found.%N");
	    end;
	 end;
      end;

feature {NONE}
   
   file_of_bytes: BINARY_FILE_READ;

   access_flag: STRING;

   fields_count: INTEGER;

   total_byte: INTEGER;

feature {NONE} -- To get result of basic read :

   last_u1: CHARACTER;

   last_u1_code: INTEGER is
      do
	 Result := last_u1.code;
      end;

   last_u2: STRING is
      once
	 !!Result.make(2);
      end;

   last_idx: INTEGER;

   last_u4: STRING is
      once
	 !!Result.make(4);
      end;

   last_u8: STRING is
      once
	 !!Result.make(8);
      end;

   last_uft8: STRING is
      once
	 !!Result.make(32);
      end;

feature {NONE} -- Basic read in *.class :

   read_u1 is
      do
	 if file_of_bytes.end_of_input then
	    bad_class_file("Unexpected end of file.");
	 else
	    file_of_bytes.read_byte;
	    last_u1 := file_of_bytes.last_byte.to_character;
	    total_byte := total_byte + 1;
	 end;
      end;

   read_u2 is
      do
	 last_u2.clear;
	 read_u1;
	 last_u2.extend(last_u1);
	 read_u1;
	 last_u2.extend(last_u1);
      end;

   read_u4 is
      do
	 read_u2;
	 last_u4.copy(last_u2);
	 read_u2;
	 last_u4.append(last_u2);
      end;

   read_u8 is
      do
	 read_u4;
	 last_u8.copy(last_u4);
	 read_u4;
	 last_u4.append(last_u4);
      end;

   read_uft8 is
      local
	 length: INTEGER;
      do
	 from
	    read_u2;
	    last_uft8.copy(last_u2);
	    length := last_u2_as_integer;
	 until
	    length = 0
	 loop
	    read_u1;
	    last_uft8.extend(last_u1);
	    length := length - 1;
	 end;
      end;

   read_u2_idx is
      do
	 read_u2;
	 last_idx := last_u2_as_integer;
	 if not constant_pool.valid_index(last_idx) then
	    tmp_string.copy("Constant pool index out of range: ");
	    last_idx.append_in(tmp_string);
	    bad_class_file(tmp_string);
	 end;
      end;

   last_u2_as_integer: INTEGER is
      do
	 Result := (last_u2.item(1).code * 256) + last_u2.item(2).code;
      end;

   last_u4_as_integer: INTEGER is
      do
	 Result := (last_u4.item(1).code * 256);
	 Result := Result + (last_u4.item(2).code * 256);
	 Result := Result + (last_u4.item(3).code * 256);
	 Result := Result + last_u4.item(4).code;
      end;

feature -- Basic print : 

   read_and_print_u1 is
      do
	 read_u1;
	 inspect
	    last_u1_code
	 when 32 .. 126 then
	    std_output.put_character(last_u1);
	 else
	    tmp_string.copy(" 0x");
	    last_u1.to_hexadecimal_in(tmp_string);
	    std_output.put_string(tmp_string);
	 end
      end;

   read_and_print_u2_idx is
      do
	 read_u2_idx;
	 std_output.put_integer(last_idx);
      end;

   read_and_print_u2 is
      do
	 read_u2;
	 print_hexadecimal(last_u2);
      end;

   read_and_print_u4 is
      do
	 read_u4;
	 print_hexadecimal(last_u4);
      end;

   read_and_print_u8 is
      do
	 read_u8;
	 print_hexadecimal(last_u8);
      end;

   print_hexadecimal(str: STRING) is
      require
	 str.count > 1
      local
	 i: INTEGER;
      do
	 tmp_string.copy("0x");
	 from
	    i := 1;
	 until
	    i > str.count
	 loop
	    str.item(i).to_hexadecimal_in(tmp_string);
	    i := i + 1;
	 end;
	 std_output.put_string(tmp_string);
      end;

feature {NONE}
   
   print_jvm_class is
      require
	 file_of_bytes.is_connected
      local 
	 c: CHARACTER;
	 i: INTEGER;
	 cp_count: INTEGER;
	 cp_info: CP_INFO;
	 methods_count, attributes_count: INTEGER;
      do
	 std_output.put_string("Contents of file %"");
	 std_output.put_string(file_of_bytes.path);
	 std_output.put_string("%".%N");
	 std_output.put_string("Magic number: ");
	 read_and_print_u4;
	 std_output.put_new_line;
	 std_output.put_string("Minor version: ");
	 read_and_print_u2;
	 std_output.put_new_line;
	 std_output.put_string("Major version: ");
	 read_and_print_u2;
	 std_output.put_new_line;
	 std_output.put_string("Constant pool count: ");
	 read_u2;
	 cp_count := last_u2_as_integer;
	 std_output.put_integer(cp_count);
	 std_output.put_new_line;
	 constant_pool.reset(cp_count - 1);
	 from
	    i := 1;
	 until
	    i = cp_count
	 loop
	    std_output.put_integer(i);
	    if i < 10 then
	       std_output.put_string("   ");
	    elseif i < 100 then
	       std_output.put_string("  ");
	    else
	       std_output.put_string(" ");
	    end;
	    std_output.put_string(": ");
	    print_cp_info(i);
	    std_output.put_new_line;
	    i := i + 1;
	 end;
	 std_output.put_string("Access flag: 0x");
	 read_u1;
	 access_flag := last_u1.to_hexadecimal;
	 read_u1;
	 last_u1.to_hexadecimal_in(access_flag);
	 std_output.put_string(access_flag);
	 std_output.put_character(' ');
	 if access_flag.item(4) = '1' then
	    std_output.put_string(" public ");
	 end;
	 if access_flag.item(3) = '1' then
	    std_output.put_string(" final (no subclass)");
	 end;
	 if access_flag.item(3) = '2' then
	    std_output.put_string(" super ");
	 end;
	 if access_flag.item(2) = '2' then
	    std_output.put_string(" interface ");
	 end;
	 if access_flag.item(2) = '4' then
	    std_output.put_string(" abstract ");
	 end;
	 std_output.put_new_line;
	 std_output.put_string("this_class: ");
	 read_and_print_u2_idx;
	 if constant_pool.is_class(last_idx) then
	    tmp_string.copy(" is ");
	    constant_pool.view_in(tmp_string,last_idx);
	    std_output.put_string(tmp_string);
	 else
	    bad_class_file("Bad `this_class' value.");
	 end;
	 std_output.put_new_line;
	 std_output.put_string("super_class: ");
	 read_and_print_u2_idx;
	 if constant_pool.is_class(last_idx) then
	    tmp_string.copy(" is ");
	    constant_pool.view_in(tmp_string,last_idx);
	    std_output.put_string(tmp_string);
	 else
	    bad_class_file("Bad `super_class' value.");
	 end;
	 std_output.put_new_line;
	 std_output.put_string("Interfaces count: ");
	 read_u2;
	 i := last_u2_as_integer;
	 std_output.put_integer(i);
	 if i > 0 then
	    std_output.put_string(" {");
	    from
	    until
	       i = 0
	    loop
	       read_and_print_u2_idx;
	       i := i - 1;
	       if i > 0 then
		  std_output.put_character(',');
	       end;
	    end;
	    std_output.put_character('}');
	 end;
	 std_output.put_new_line;
	 std_output.put_string("----- Fields count: ");
	 read_u2;
	 fields_count := last_u2_as_integer;
	 std_output.put_integer(fields_count);
	 std_output.put_new_line;
	 from
	    i := 1
	 until
	    i > fields_count
	 loop
	    std_output.put_integer(i);
	    if i < 10 then
	       std_output.put_string("   ");
	    elseif i < 100 then
	       std_output.put_string("  ");
	    else
	       std_output.put_string(" ");
	    end;
	    std_output.put_string(": ");
	    print_field_info;
	    std_output.put_new_line;
	    i := i + 1;
	 end;
	 std_output.put_string("----- Methods count: ");
	 read_u2;
	 methods_count := last_u2_as_integer;
	 std_output.put_integer(methods_count);
	 std_output.put_new_line;
	 from
	    i := 1
	 until
	    i > methods_count
	 loop
	    std_output.put_integer(i);
	    if i < 10 then
	       std_output.put_string("   ");
	    elseif i < 100 then
	       std_output.put_string("  ");
	    else
	       std_output.put_string(" ");
	    end;
	    std_output.put_string(": ");
	    print_method_info;
	    std_output.put_new_line;
	    i := i + 1;
	 end;
	 std_output.put_string("Attributes count: ");
	 read_u2;
	 attributes_count := last_u2_as_integer;
	 std_output.put_integer(attributes_count);
	 std_output.put_new_line;
	 from
	    i := 1
	 until
	    i > attributes_count
	 loop
	    std_output.put_integer(i);
	    if i < 10 then
	       std_output.put_string("   ");
	    elseif i < 100 then
	       std_output.put_string("  ");
	    else
	       std_output.put_string(" ");
	    end;
	    std_output.put_string(": ");
	    print_attribute_info;
	    std_output.put_new_line;
	    i := i + 1;
	 end;
	 read_u1;
	 if file_of_bytes.end_of_input then
	    std_output.put_string("Total bytes: ");
	    std_output.put_integer(total_byte - 1);
	    std_output.put_new_line;
	 else
	    bad_class_file("End of file expected.");
	 end;
      end;

   tmp_string: STRING is
      once
	 !!Result.make(32);
      end;

feature -- Read and brute printing of constant_pool :

   print_cp_info(i: INTEGER) is
      do
	 read_u1;
	 inspect
	    last_u1_code
	 when 7 then
	    std_output.put_string("class at ");
	    read_and_print_u2_idx;
	    constant_pool.set_class(i,last_u2);
	 when 9 then
	    std_output.put_string("fieldref class: ");
	    read_and_print_u2_idx;
	    last_u4.copy(last_u2);
	    std_output.put_string(" name_and_type: ");
	    read_and_print_u2_idx;
	    last_u4.append(last_u2);
	    constant_pool.set_fieldref(i,last_u4);
	 when 10 then
	    std_output.put_string("methodref class: ");
	    read_and_print_u2_idx;
	    last_u4.copy(last_u2);
	    std_output.put_string(" name_and_type: ");
	    read_and_print_u2_idx;
	    last_u4.append(last_u2);
	    constant_pool.set_methodref(i,last_u4);
	 when 11 then
	    std_output.put_string("interface methodref class: ");
	    read_and_print_u2_idx;
	    last_u4.copy(last_u2);
	    std_output.put_string(" name_and_type: ");
	    read_and_print_u2_idx;
	    last_u4.append(last_u2);
	    constant_pool.set_interface_methodref(i,last_u4);
	 when 8 then
	    std_output.put_string("string at ");
	    read_and_print_u2_idx;
	    constant_pool.set_string(i,last_u2);
	 when 3 then
	    std_output.put_string("integer: ");
	    read_and_print_u4;
	    constant_pool.set_integer(i,last_u4);
	 when 4 then
	    std_output.put_string("float: ");
	    read_and_print_u4;
	    constant_pool.set_float(i,last_u4);
	 when 5 then
	    std_output.put_string("long: ");
	    read_and_print_u4;
	    last_u8.copy(last_u4);
	    read_and_print_u4;
	    last_u8.append(last_u4);
	    constant_pool.set_long(i,last_u8);
	 when 6 then
	    std_output.put_string("double: ");
	    read_and_print_u4;
	    last_u8.copy(last_u4);
	    read_and_print_u4;
	    last_u8.append(last_u4);
	    constant_pool.set_double(i,last_u8);
	 when 12 then
	    std_output.put_string("name: ");
	    read_and_print_u2_idx;
	    last_u4.copy(last_u2);
	    std_output.put_string(" type: ");
	    read_and_print_u2_idx;
	    last_u4.append(last_u2);
	    constant_pool.set_name_and_type(i,last_u4);
	 when 1 then
	    std_output.put_string("uft8: ");
	    read_uft8;
	    constant_pool.set_uft8(i,last_uft8);
	    tmp_string.clear;
	    constant_pool.view_in(tmp_string,i);
	    std_output.put_string(tmp_string);
	 else
	    tmp_string.copy("Error in constant pool (bad tag: ");
	    last_u1_code.append_in(tmp_string);
	    tmp_string.append(").");
	    bad_class_file(tmp_string);
	 end;
      end;

feature {NONE}

   print_field_info is
      local
	 flag, attributes_count: INTEGER;
      do
	 -- access_flag :
	 read_and_print_u2;
	 flag_list_begin;
	 flag := last_u2.item(2).code;
	 inspect
	    flag \\ 10
	 when 1 then
	    flag_list_add("public");
	 when 2 then
	    flag_list_add("private");
	 when 4 then
	    flag_list_add("protected");
	 else
	 end;
	 if flag >= 10 then
	    if flag < 40 then
	       flag_list_add("final");
	    elseif flag > 40 then
	       flag_list_add("transient");
	    else 
	       flag_list_add("volatile");
	    end;
	 end;
	 flag_list_end;
	 -- name_index :
	 read_u2_idx;
	 tmp_string.clear;
	 constant_pool.view_in(tmp_string,last_idx);
	 std_output.put_string(tmp_string);
	 -- descriptor_index :
	 read_u2_idx;
	 tmp_string.copy(" ");
	 constant_pool.view_in(tmp_string,last_idx);
	 std_output.put_string(tmp_string);
	 -- attributes_count :
	 read_u2;
	 attributes_count := last_u2_as_integer;
	 if attributes_count > 0 then
	    std_output.put_string(" attributes_count: ");
	    std_output.put_integer(attributes_count);
	 end;
	 std_output.put_new_line;
	 from
	 until
	    attributes_count = 0
	 loop
	    print_attribute_info;
	    attributes_count := attributes_count - 1;
	 end;
      end;

   print_method_info is
      local
	 flag, attributes_count: INTEGER;
      do
	 -- access_flag :
	 read_and_print_u2;
	 flag_list_begin;
	 flag := last_u2.item(2).code;
	 inspect
	    flag \\ 10
	 when 1 then
	    flag_list_add("public");
	 when 2 then
	    flag_list_add("private");
	 when 4 then
	    flag_list_add("protected");
	 else
	 end;
	 if flag >= 10 then
	    if flag < 40 then
	       flag_list_add("final");
	    elseif flag > 40 then
	       flag_list_add("transient");
	    else 
	       flag_list_add("volatile");
	    end;
	 end;
	 flag_list_end;
	 -- name_index :
	 read_u2_idx;
	 tmp_string.clear;
	 constant_pool.view_in(tmp_string,last_idx);
	 std_output.put_string(tmp_string);
	 -- descriptor_index :
	 read_u2_idx;
	 tmp_string.clear;
	 constant_pool.view_in(tmp_string,last_idx);
	 std_output.put_string(tmp_string);
	 -- attributes_count :
	 read_u2;
	 attributes_count := last_u2_as_integer;
	 if attributes_count > 1 then
	    std_output.put_string(" attributes_count: ");
	    std_output.put_integer(attributes_count);
	 end;
	 std_output.put_new_line;
	 from
	 until
	    attributes_count = 0
	 loop
	    print_attribute_info;
	    attributes_count := attributes_count - 1;
	 end;
      end;

   print_attribute_info is
      local
	 i: INTEGER;
      do
	 read_u2_idx;
	 tmp_string.clear;
	 constant_pool.view_in(tmp_string,last_idx);
	 std_output.put_string(tmp_string);
	 if ("SourceFile").is_equal(tmp_string) then
	    read_u4;
	    read_u2_idx;
	    tmp_string.copy(" is ");
	    constant_pool.view_in(tmp_string,last_idx);
	    std_output.put_string(tmp_string);
	 elseif ("Code").is_equal(tmp_string) then
	    read_u4;
	    print_code_attribute(last_u4_as_integer);
	 else
	    std_output.put_string(" (Ignored attribute: ");
	    read_u4;
	    i := last_u4_as_integer;
	    std_output.put_integer(i);
	    std_output.put_string(" bytes)");
	    from
	    until
	       i = 0
	    loop
	       read_u1;
	       i := i - 1;
	    end;
	 end;
      end;

   print_code_attribute(length: INTEGER) is
      local
	 code_length, exception_length,
	 attributes_count: INTEGER;
      do
	 std_output.put_string(" (");
	 std_output.put_integer(length);
	 std_output.put_string(" bytes) max_stack: ");
	 read_u2;
	 std_output.put_integer(last_u2_as_integer);
	 std_output.put_string(" max_locals: ");
	 read_u2;
	 std_output.put_integer(last_u2_as_integer);
	 std_output.put_string(" code_length: ");
	 read_u4;
	 code_length := last_u4_as_integer;
	 std_output.put_integer(code_length);
	 read_and_print_byte_code(code_length);
	 read_u2;
	 exception_length := last_u2_as_integer;
	 if exception_length > 0 then
	    std_output.put_string("exception(s): ");
	    std_output.put_integer(exception_length);
	    std_output.put_new_line;
	    read_and_print_exception(exception_length);
	 end;
	 std_output.put_string("attributes_count: ");
	 read_u2;
	 attributes_count := last_u2_as_integer;
	 std_output.put_integer(attributes_count);
	 std_output.put_new_line;
	 from
	 until
	    attributes_count = 0
	 loop
	    print_attribute_info;
	    attributes_count := attributes_count - 1;
	 end;
      end;

feature {NONE}

   max_print: INTEGER is 50;

   bad_class_file(msg: STRING) is
      local
	 fz_visible, fz_hexadec, path: STRING;
      do
	 std_output.put_string("%NCorrupted class file.%N");
	 std_output.put_string(msg);
	 std_output.put_string("%NTotal bytes read :");
	 std_output.put_integer(total_byte);
	 std_output.put_string("%NClass file dump:%N");

	 path := file_of_bytes.path;
	 file_of_bytes.disconnect;
	 from
	    file_of_bytes.connect_to(path);
	    std_output.put_new_line;
	    fz_visible := "  ";
	    fz_hexadec := "Ox";
	 until
	    file_of_bytes.end_of_input
	 loop
	    read_u1;
	    last_u1.to_hexadecimal_in(fz_hexadec);
	    fz_hexadec.extend(' ');
	    inspect
	       last_u1_code
	    when 32 .. 126 then
	       fz_visible.extend(last_u1);
	    else
	       fz_visible.extend('.');
	    end
	    if fz_hexadec.count >= max_print then
	       std_output.put_string(fz_hexadec);
	       std_output.put_string("  ");
	       std_output.put_string(fz_visible);
	       std_output.put_new_line;
	       fz_visible.copy("  ");
	       fz_hexadec.copy("Ox");
	    end;
	 end;
	 from
	 until
	    fz_hexadec.count >= max_print + 2
	 loop
	    fz_hexadec.extend(' ');
	 end;
	 std_output.put_string(fz_hexadec);
	 std_output.put_string(fz_visible);
	 file_of_bytes.disconnect;
	 std_output.put_new_line;
	 die_with_code(exit_failure_code);
      end;

   read_and_print_byte_code(length: INTEGER) is
      require
	 length > 0
      local
	 old_total_byte, pc, opcode: INTEGER;
      do
	 std_output.put_new_line;
	 from
	    old_total_byte := total_byte;
	 until
	    total_byte - old_total_byte >= length
	 loop
	    std_output.put_string("   ");
	    pc := total_byte - old_total_byte;
	    from
	       tmp_string.clear;
	       pc.append_in(tmp_string);
	    until
	       tmp_string.count >= 4 
	    loop
	       tmp_string.extend(' ');
	    end;
	    std_output.put_string(tmp_string);
	    inst.clear;
	    read_u1;
	    last_u1.to_hexadecimal_in(inst);
	    std_output.put_string(inst);
	    inst.clear;
	    opcode := last_u1_code;
	    inspect
	       opcode
	    when 0 then
	       inst_opcode("nop");
	    when 1 then
	       inst_opcode("aconst_null");
	    when 2 then
	       inst_opcode("iconst_m1");
	    when 3 .. 8 then
	       inst_opcode("iconst_");
	       (last_u1_code - 3).append_in(inst);
	    when 9 then
	       inst_opcode("lconst_0");
	    when 10 then
	       inst_opcode("lconst_1");
	    when 11 .. 13 then
	       inst_opcode("fconst_");
	       (last_u1_code - 11).append_in(inst);
	    when 14 .. 15 then
	       inst_opcode("dconst_");
	       (last_u1_code - 14).append_in(inst);
	    when 16 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("bipush");
	    when 17 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("sipush");
	    when 18 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("ldc ");
	       constant_pool.view_in(inst,last_u1_code);
	    when 19 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("ldc_w ");
	       constant_pool.view_in(inst,last_idx);
	    when 21 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("iload ");
	       last_u1_code.append_in(inst);
	    when 22 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("lload ");
	       last_u1_code.append_in(inst);
	    when 23 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("fload ");
	       last_u1_code.append_in(inst);
	    when 25 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("aload ");
	       last_u1_code.append_in(inst);
	    when 26 .. 29 then
	       inst_opcode("iload_");
	       (last_u1_code - 26).append_in(inst);
	    when 34 .. 37 then
	       inst_opcode("fload_");
	       (last_u1_code - 34).append_in(inst);
	    when 38 .. 41 then
	       inst_opcode("dload_");
	       (last_u1_code - 38).append_in(inst);
	    when 42 .. 45 then
	       inst_opcode("aload_");
	       (last_u1_code - 42).append_in(inst);
	    when 46 then
	       inst_opcode("iaload");
	    when 47 then
	       inst_opcode("laload");
	    when 48 then
	       inst_opcode("faload");
	    when 49 then
	       inst_opcode("daload");
	    when 50 then
	       inst_opcode("aaload");
	    when 51 then
	       inst_opcode("baload");
	    when 52 then
	       inst_opcode("caload");
	    when 53 then
	       inst_opcode("saload");
	    when 54 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("istore");
	       last_u1_code.append_in(inst);
	    when 55 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("lstore ");
	       last_u1_code.append_in(inst);
	    when 56 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("fstore ");
	       last_u1_code.append_in(inst);
	    when 58 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("astore ");
	       last_u1_code.append_in(inst);
	    when 59 .. 62 then
	       inst_opcode("istore_");
	       (last_u1_code - 59).append_in(inst);
	    when 63 .. 66 then
	       inst_opcode("lstore_");
	       (last_u1_code - 63).append_in(inst);
	    when 67 .. 70 then
	       inst_opcode("fstore_");
	       (last_u1_code - 67).append_in(inst);
	    when 71 .. 74 then
	       inst_opcode("dstore_");
	       (last_u1_code - 71).append_in(inst);
	    when 75 .. 78 then
	       inst_opcode("astore_");
	       (last_u1_code - 75).append_in(inst);
	    when 79 then
	       inst_opcode("iastore");
	    when 80 then
	       inst_opcode("lastore");
	    when 81 then
	       inst_opcode("fastore");
	    when 82 then
	       inst_opcode("dastore");
	    when 83 then
	       inst_opcode("aastore");
	    when 84 then
	       inst_opcode("bastore");
	    when 85 then
	       inst_opcode("castore");
	    when 86 then
	       inst_opcode("sastore");
	    when 87 then
	       inst_opcode("pop");
	    when 88 then
	       inst_opcode("pop2");
	    when 89 then
	       inst_opcode("dup");
	    when 90 then
	       inst_opcode("dup_x1");
	    when 91 then
	       inst_opcode("dup_x2");
	    when 92 then
	       inst_opcode("dup2");
	    when 95 then
	       inst_opcode("swap");
	    when 96 then
	       inst_opcode("iadd");
	    when 97 then
	       inst_opcode("ladd");
	    when 98 then
	       inst_opcode("fadd");
	    when 99 then
	       inst_opcode("dadd");
	    when 100 then
	       inst_opcode("isub");
	    when 104 then
	       inst_opcode("imul");
	    when 108 then
	       inst_opcode("idiv");
	    when 112 then
	       inst_opcode("irem");
	    when 116 then
	       inst_opcode("ineg");
	    when 117 then
	       inst_opcode("lneg");
	    when 118 then
	       inst_opcode("fneg");
	    when 119 then
	       inst_opcode("dneg");
	    when 120 then
	       inst_opcode("ishl");
	    when 124 then
	       inst_opcode("iushr");
	    when 126 then
	       inst_opcode("iand");
	    when 128 then
	       inst_opcode("ior");
	    when 130 then
	       inst_opcode("ixor");
	    when 132 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("iinc loc");
	       last_u2.item(1).code.append_in(inst);
	       inst.append(",0x");
	       last_u2.item(2).to_hexadecimal_in(inst);
	    when 133 then
	       inst_opcode("i2l");
	    when 134 then
	       inst_opcode("i2f");
	    when 135 then
	       inst_opcode("i2d");
	    when 141 then
	       inst_opcode("f2d");
	    when 144 then
	       inst_opcode("d2f");
	    when 145 then
	       inst_opcode("i2b");
	    when 146 then
	       inst_opcode("i2c");
	    when 149 then
	       inst_opcode("fcmpl");
	    when 150 then
	       inst_opcode("fcmpg");
	    when 151 .. 152 then
	       inst_opcode("dcmp");
	       inspect
		  opcode
	       when 151 then
		  inst.append("l");
	       when 152 then
		  inst.append("g");
	       end;
	    when 153 .. 158 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("if");
	       inspect
		  opcode
	       when 153 then
		  inst.append("eq");
	       when 154 then
		  inst.append("ne");
	       when 155 then
		  inst.append("lt");
	       when 156 then
		  inst.append("ge");
	       when 157 then
		  inst.append("gt");
	       when 158 then
		  inst.append("le");
	       end;
	       inst.extend(' ');
	       view_pc(last_u2_as_integer,pc);
	    when 159 .. 166 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("if_");
	       inspect
		  opcode
	       when 159 .. 164 then
		  inst.extend('i');
	       else
		  inst.extend('a');
	       end;
	       inst.append("cmp");
	       inspect
		  opcode
	       when 159 then
		  inst.append("eq");
	       when 160 then
		  inst.append("ne");
	       when 161 then
		  inst.append("lt");
	       when 162 then
		  inst.append("ge");
	       when 163 then
		  inst.append("gt");
	       when 164 then
		  inst.append("le");
	       when 165 then
		  inst.append("eq");
	       when 166 then
		  inst.append("ne");
	       end;
	       inst.extend(' ');
	       view_pc(last_u2_as_integer,pc);
	    when 167 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("goto ");
	       view_pc(last_u2_as_integer,pc);
	    when 172 then
	       inst_opcode("ireturn");
	    when 173 then
	       inst_opcode("lreturn");
	    when 174 then
	       inst_opcode("freturn");
	    when 175 then
	       inst_opcode("dreturn");
	    when 176 then
	       inst_opcode("areturn");
	    when 177 then
	       inst_opcode("return");
	    when 178 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("getstatic ");
	       constant_pool.view_in(inst,last_idx);
	    when 179 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("putstatic ");
	       constant_pool.view_in(inst,last_idx);
	    when 180 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("getfield ");
	       constant_pool.view_in(inst,last_idx);
	    when 181 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("putfield ");
	       constant_pool.view_in(inst,last_idx);
	    when 182 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("invokevirtual ");
	       constant_pool.view_in(inst,last_idx);
	    when 183 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("invokespecial ");
	       constant_pool.view_in(inst,last_idx);
	    when 184 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("invokestatic ");
	       constant_pool.view_in(inst,last_idx);
	    when 187 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("new ");
	       constant_pool.view_in(inst,last_idx);
	    when 188 then
	       read_u1;
	       last_u1.to_hexadecimal_in(inst);
	       inst_opcode("newarray ");
	       inspect
		  last_u1_code
	       when 4 then
		  inst.append("boolean");
	       when 5 then
		  inst.append("character");
	       when 6 then
		  inst.append("float");
	       when 7 then
		  inst.append("double");
	       when 8 then
		  inst.append("byte");
	       when 9 then
		  inst.append("short");
	       when 10 then
		  inst.append("int");
	       when 11 then
		  inst.append("long");
	       end;
	    when 189 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("anewarray ");
	       constant_pool.view_in(inst,last_idx);
	    when 190 then
	       inst_opcode("arraylength");
	    when 191 then
	       inst_opcode("athrow");
	    when 193 then
	       read_u2_idx;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("instanceof ");
	       constant_pool.view_in(inst,last_idx);
	    when 198 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("ifnull ");
	       view_pc(last_u2_as_integer,pc);
	    when 199 then
	       read_u2;
	       last_u2.item(1).to_hexadecimal_in(inst);
	       last_u2.item(2).to_hexadecimal_in(inst);
	       inst_opcode("ifnonnull ");
	       view_pc(last_u2_as_integer,pc);
	    else
	       tmp_string.append("Unknown Opcode: ");
	       last_u1_code.append_in(tmp_string);
	       bad_class_file(tmp_string);
	    end;
	    std_output.put_string(inst);
	    std_output.put_new_line;
	 end;
      end;

   read_and_print_exception(length: INTEGER) is
      local
	 i: INTEGER;
      do
	 from
	    i := length
	 until
	    i = 0
	 loop
	    std_output.put_string("start: ");
	    read_u2;
	    std_output.put_integer(last_u2_as_integer);
	    std_output.put_string(" end: ");
	    read_u2;
	    std_output.put_integer(last_u2_as_integer);
	    std_output.put_string(" handler: ");
	    read_u2;
	    std_output.put_integer(last_u2_as_integer);
	    std_output.put_string(" type: ");
	    read_u2_idx;
	    tmp_string.clear;
	    constant_pool.view_in(tmp_string,last_idx);
	    std_output.put_string(tmp_string);
	    std_output.put_string("%N");
	    i := i - 1;
	 end;
      end;

   inst_opcode(msg: STRING) is
      do
	 from
	 until
	    inst.count >= 4
	 loop
	    inst.extend('.');
	 end;
	 inst.extend(' ');
	 inst.append(msg);
      end;

   inst: STRING is
      once
	 !!Result.make(80);
      end;

   flag_list: STRING is
      once
	 !!Result.make(80);
      end;

   flag_list_begin is
      do
	 flag_list.copy(" (");
      end;

   flag_list_add(item: STRING) is
      do
	 if flag_list.last /= '(' then
	    flag_list.extend(',');
	 end;
	 flag_list.append(item);
      end;

   flag_list_end is
      do
	 flag_list.append(")%N");
	 std_output.put_string(flag_list);
      end;

feature {NONE}

   view_pc(offset, pc: INTEGER) is
      local
	 view: INTEGER;
	 bits: BIT Integer_bits;
      do
	 if offset < ((2 ^ 15) - 1) then
	    view := pc + offset;
	 else
	    view := (offset - (2 ^ 16)) + pc;
	 end;
	 view.append_in(inst);
      end;
   
end -- PRINT_JVM_CLASS

