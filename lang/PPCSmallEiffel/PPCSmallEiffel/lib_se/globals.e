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
deferred class GLOBALS
   --   
   -- Global Tools for the SmallEiffel system.
   --

inherit 
   UNIQUE_STRING_LIST;
   FROZEN_STRING_LIST;
   
feature {NONE} -- Unique Globals objects :
      
   frozen small_eiffel: SMALL_EIFFEL is
	 -- The SmallEiffel system himself.
      once
	 !!Result.make;
      end; 
   
   frozen parser_buffer: PARSER_BUFFER is
      once
	 !!Result.make;
      end;

   frozen eiffel_parser : EIFFEL_PARSER is
	 -- The Eiffel Parser.
      once
	 !!Result.make;
      end; 

   frozen unique_string: UNIQUE_STRING is 
	 -- To share STRINGs.
      once
	 !!Result.make;
      end;

   frozen id_provider: ID_PROVIDER is 
      once
	 !!Result.make;
      end;

   frozen manifest_string_pool: MANIFEST_STRING_POOL is 
      once 
	 !!Result;
      end;

   frozen manifest_array_pool: MANIFEST_ARRAY_POOL is 
      once 
	 !!Result;
      end;

   frozen once_routine_pool: ONCE_ROUTINE_POOL is 
      once 
	 !!Result;
      end;

   frozen cecil_pool: CECIL_POOL is 
      once 
	 !!Result;
      end;

   frozen fmt: FMT is
      -- For the command `pretty'.
      once
	 !!Result.make;
      end;

   frozen short_print: SHORT_PRINT is
      once
	 !!Result.make;
      end;
   
   frozen eh: ERROR_HANDLER is
	 -- To report errors or warning in Eiffel code.
      once
	 !!Result.make
      end;

   frozen echo: ECHO is
	 -- To report errors during a process.
      once
	 !!Result.make;
      end;
   
   frozen run_control: RUN_CONTROL is
	 -- To set or to know run-time options.
      once
	 !!Result.make;
      end;
   
   frozen switch_collection: SWITCH_COLLECTION is
	 -- Handling of the switch collection.
      once 
      end;

   frozen cpp: C_PRETTY_PRINTER is
	 -- To print the C code.
      once
	 !!Result.make;
      end;
   
   frozen gc_handler: GC_HANDLER is
      once
	 !!Result.make;
      end;

   frozen jvm: JVM is
	 -- To print the Java Virtual Machine code.
      once
	 !!Result.make;
      end;

   frozen constant_pool: CONSTANT_POOL is
	 -- To print the Java Virtual Machine code.
      once
	 !!Result;
      end;

   frozen field_info: FIELD_INFO is
	 -- To handle a JVM field_info.
      once
	 !!Result;
      end;

   frozen code_attribute: CODE_ATTRIBUTE is
	 -- To handle a JVM Code_attribute_info.
      once
	 !!Result;
      end;

   frozen method_info: METHOD_INFO is
	 -- To handle a JVM method_info.
      once
	 !!Result;
      end;

feature {NONE} ------------------------------------------------------------
   -- Warning/Error/Fatal Error handling.
   --
   
   nb_errors: INTEGER is
      do
	 Result := eh.nb_errors;
      ensure
	 Result >= 0
      end;
   
   nb_warnings: INTEGER is
      do
	 Result := eh.nb_warnings;
      ensure
	 Result >= 0
      end;
   
   warning(p: POSITION; msg: STRING) is
	 -- Warning `msg' at position `p'.
      require
	 not msg.empty
      do
	 eh.add_position(p);
	 eh.warning(msg);
      ensure
	 nb_warnings = old nb_warnings + 1
      end;
   
   error(p: POSITION; msg: STRING) is
	 -- When error `msg' occurs at position `p'.
      require
	 not msg.empty
      do
	 eh.add_position(p);
	 eh.error(msg);
      ensure
	 nb_errors = old nb_errors + 1
      end;
   
   fatal_error(msg: STRING) is
	 -- Should not append but it is better to know :-)
      require
	 not msg.empty
      do
	 eh.fatal_error(msg);
      end;
   
feature {NONE} -- Miscellaneous information :
   
   small_eiffel_directory: STRING is
	 -- Compute the good one using the environment 
	 -- variable if any.
      local
	 i: INTEGER;
	 slash: CHARACTER;
      once
	 Result := get_environment_variable(fz_se);
	 if Result = Void then
	    Result := fz_se.twin;
	    Result.to_upper;
	    Result := get_environment_variable(Result);
	    if Result /= Void then
	       fz_se.to_upper;
	    end;
	 end;
	 if Result = Void then
	    Result := "/usr/local/logiciel/SmallEiffel";
	 end;
	 from  
	    i := Result.count;
	 until
	    i < 0
	 loop
	    slash := Result.item(i);
	    if slash.is_letter or else slash.is_digit then
	       i := i - 1;
	    else
	       i := -1;
	    end;
	 end;
	 if i = 0 then
	    Result.extend('/');
	 elseif not (Result.last = slash) then
	    Result.extend(slash);
	 end;
      ensure
	 not Result.last.is_letter;
	 not Result.last.is_digit;
      end;
   
   add_directory(path, dir: STRING) is
      require
	 path.count > 0;
	 dir.count > 0
      do
	 if unix_system = system_name then
	    path.set_last('/');
	    path.append(dir);
	    path.set_last('/');
	 elseif windows_system = system_name then
	    path.set_last('\');
	    path.append(dir);
	    path.set_last('\');
	 elseif macintosh_system = system_name then
	    path.set_last(':');
	    path.append(dir);
	    path.set_last(':');
	 elseif dos_system = system_name then
	    path.set_last('\');
	    path.append(dir);
	    path.set_last('\');
	 elseif os2_system = system_name then
	    path.set_last('\');
	    path.append(dir);
	    path.set_last('\');
	 elseif amiga_system = system_name then
	    path.set_last('/');
	    path.append(dir);
	    path.set_last('/');
	 elseif vms_system = system_name then
	    path.set_last(']');
	    path.remove_last(1);
	    path.set_last('.');
	    path.append(dir);
	    path.set_last(']');
	 end;
      end;
      
     start_directory(path, dir: STRING) is
         -- Start a new path from scratch.
      require
	 path /= Void;
	 dir.count > 0
      do
	 path.clear;
	 if unix_system = system_name then
	    path.append(dir);
	    path.set_last('/');
	 elseif windows_system = system_name then
	    path.append(dir);
	    path.set_last('\');
	 elseif macintosh_system = system_name then
	    path.append(dir);
	    path.set_last(':');
	 elseif dos_system = system_name then
	    path.append(dir);
	    path.set_last('\');
	 elseif os2_system = system_name then
	    path.append(dir);
	    path.set_last('\');
	 elseif amiga_system = system_name then
	    path.append(dir);
	    path.set_last('/');
	 elseif vms_system = system_name then
	    path.set_last('[');
	    path.append(dir);
	    path.set_last(']');
	 end;
      end;
      
feature {NONE} -- Common globals buffers :

   tmp_path: STRING is
      once
	 !!Result.make(256);
      end;

   tmp_file_read: STD_FILE_READ is
      once
	 !!Result.make;
      end;
   
   help_file_name: STRING is
      once
	 !!Result.make(256);
      end;

   print_help(name: STRING) is
      do
	 help_file_name.copy(small_eiffel_directory);
	 add_directory(help_file_name,"man");
	 help_file_name.append(name);
	 if not help_file_name.has_suffix(help_suffix) then
	    help_file_name.append(help_suffix);
	 end;
	 if not file_exists(help_file_name) then
	    echo.w_put_string("Unable to find help file %"");
	    echo.w_put_string(help_file_name);
	    echo.w_put_string(fz_b0);
	    die_with_code(exit_failure_code);
	 end;
	 std_output.append_file(help_file_name);
      end;
   
   more_help(cmd: STRING) is
      do
	 echo.w_put_string("Type help file for :");
	 echo.w_put_string(cmd);
	 echo.w_put_string(" (y/n) ? ");
	 std_input.read_character;
	 inspect
	    std_input.last_character
	 when 'y','Y' then
	    print_help(cmd);
	 else
	 end;
      end;

feature {NONE} -- Globals implicits expressions :
   
   e_void: E_VOID is
      once
	 !!implicit;
      end;
   
   class_with(str: STRING): BASE_CLASS is
      require
	 not str.empty;
      do
	 Result := small_eiffel.get_class(str);
      end;
   
   class_any: BASE_CLASS is
      once
	 Result := class_with(us_any);
      end;
   
   class_general: BASE_CLASS is
      once
	 Result := class_with(us_general);
      end;
   
feature {NONE} -- Globals implicits types :
   
   type_boolean_ref: TYPE_CLASS is
      local
	 boolean_ref: CLASS_NAME;
      once
	 !!boolean_ref.make(us_boolean_ref,Void);
	 !!Result.make(boolean_ref);
      end;
   
   type_character_ref: TYPE_CLASS is
      local
	 character_ref: CLASS_NAME;
      once
	 !!character_ref.make(us_character_ref,Void);
	 !!Result.make(character_ref);
      end;
   
   type_integer_ref: TYPE_CLASS is
      local
	 integer_ref: CLASS_NAME;
      once
	 !!integer_ref.make(us_integer_ref,Void);
	 !!Result.make(integer_ref);
      end;
   
   type_real_ref: TYPE_CLASS is
      local
	 real_ref: CLASS_NAME;
      once
	 !!real_ref.make(us_real_ref,Void);
	 !!Result.make(real_ref);
      end;
   
   type_double_ref: TYPE_CLASS is
      local
	 double_ref: CLASS_NAME;
      once
	 !!double_ref.make(us_double_ref,Void);
	 !!Result.make(double_ref);
      end;
   
   type_pointer_ref: TYPE_CLASS is
      local
	 pointer_ref: CLASS_NAME;
      once
	 !!pointer_ref.make(us_pointer_ref,Void);
	 !!Result.make(pointer_ref);
      end;
   
   type_boolean: TYPE_BOOLEAN is
      once
	 !!Result.make(Void);
      end;
   
   type_string: TYPE_STRING is
      once
	 !!Result.make(Void);
      end;
   
   type_any: TYPE_ANY is
      once
	 !!Result.make(Void);
      end;

   type_general: TYPE_CLASS is
      once
	 !!Result.make(class_with(us_general).base_class_name);
      end;

   type_none: TYPE_NONE is
      once
	 !!Result.make(Void);
      end;

   type_pointer: TYPE_POINTER is
      once
	 !!Result.make(Void);
      end;
   
feature {NONE} -- Globals procedures/functions :
   
   sort_running(run: ARRAY[RUN_CLASS]) is
	 -- Sort `run' to put small `id' first.
      require
	 run.lower = 1;
	 run.upper >= 2;
      local
	 min, max, buble: INTEGER;
	 moved: BOOLEAN;
      do
	 from  
	    max := run.upper;
	    min := 1;
	    moved := true;
	 until
	    not moved
	 loop
	    moved := false;
	    if max - min > 0 then
	       from  
		  buble := min + 1;
	       until
		  buble > max
	       loop
		  if run.item(buble - 1).id > run.item(buble).id then
		     run.swap(buble - 1,buble);
		     moved := true;
		  end;
		  buble := buble + 1;
	       end;
	       max := max - 1;
	    end;
	    if moved and then max - min > 0 then
	       from  
		  moved := false;
		  buble := max - 1;
	       until
		  buble < min
	       loop
		  if run.item(buble).id > run.item(buble + 1).id then
		     run.swap(buble,buble + 1);
		     moved := true;
		  end;
		  buble := buble - 1;
	       end;
	       min := min + 1;
	    end;
	 end;
      end;
   
feature {NONE}
      
   pos(line, column: INTEGER): POSITION is
      require
	 line >= 1;
	 column >= 1;
      do
	 !!Result.make(line,column);
      end;
   
feature {NONE}
   
   to_bcn(rc: STRING): STRING is
	 -- Compute the root class name using command argument `rc'.
      require
	 rc /= Void
      local
	 i: INTEGER;
	 c: CHARACTER;
      do
	 Result := rc.twin;
	 if Result.has_suffix(eiffel_suffix) then 
	    Result.remove_last(2);
	 end;
	 from  
	    i := Result.count;
	 until
	    i = 0
	 loop
	    c := Result.item(i);
	    if c.is_letter then
	       i := i - 1;
	    elseif c = '_' then
	       i := i - 1;
	    elseif c.is_digit then
	       i := i - 1;
	    else
	       Result.remove_first(i);
	       i := 0;
	    end;
	 end;
	 Result.to_upper;
      ensure
	 Result.count <= rc.count
      end;
   
feature {NONE}
   
   no_errors: BOOLEAN is
      do
	 Result := nb_errors = 0;
      end;
   
   code_require, code_ensure: INTEGER is unique;
   
feature {NONE}
   
   character_coding(c: CHARACTER; str: STRING) is
	 -- Append in `str' the Eiffel coding of the character (Table 
	 -- in chapter 25 of ETL, page 423).
	 -- When letter notation exists, it is returned in priority : 
	 --  '%N' gives "%N", '%T' gives "%T", ... 
	 -- When letter notation does not exists (not in ETL table), 
	 -- numbered coding is used ("%/1/", "%/2/" etc).
      local
	 special: CHARACTER
      do
	 inspect
	    c
	 when '%A' then
	    special := 'A';
	 when '%B' then
	    special := 'B';
	 when '%C' then
	    special := 'C';
	 when '%D' then
	    special := 'D';
	 when '%F' then
	    special := 'F';
	 when '%H' then
	    special := 'H';
	 when '%L' then
	    special := 'L';
	 when '%N' then
	    special := 'N';
	 when '%Q' then
	    special := 'Q';
	 when '%R' then
	    special := 'R';
	 when '%S' then
	    special := 'S';
	 when '%T' then
	    special := 'T';
	 when '%U' then
	    special := 'U';
	 when '%V' then
	    special := 'V';
	 when '%%' then
	    special := '%%';
	 when '%'' then
	    special := '%'';
	 when '%"' then
	    special := '"';
	 when '%(' then
	    special := '(';
	 when '%)' then
	    special := ')';
	 when '%<' then
	    special := '<';
	 when '%>' then
	    special := '>';
	 else
	 end;
	 str.extend('%%');
	 if special = '%U' then
	    str.extend('/');
	    c.code.append_in(str);
	    str.extend('/');
	 else
	    str.extend(special);
	 end;
      end;
   
feature {NONE}   
   
   runnable(collected: ARRAY[ASSERTION]; ct: TYPE; 
	    for:RUN_FEATURE): ARRAY[ASSERTION] is
	 -- Produce a runnable `collected'.
      require
	 collected.lower = 1;
	 for /= Void implies ct = for.current_type;
      local
	 i: INTEGER;
	 a: ASSERTION;
      do
	 if not collected.empty then
	    from  
	       Result := collected.twin;
	       i := Result.upper;
	    until
	       i = 0
	    loop
	       small_eiffel.push(for);
	       a := Result.item(i).to_runnable(ct);
	       if a = Void then
		  error(Result.item(i).start_position,fz_bad_assertion);
	       else
		  Result.put(a,i);
	       end;
	       small_eiffel.pop;
	       i := i - 1;
	    end;
	 end;
      end;
   
feature {NONE}

   sfw_connect(sfw: STD_FILE_WRITE; path: STRING) is
      require
	 not sfw.is_connected;
	 path /= Void
      do
	 sfw.connect_to(path);
	 if sfw.is_connected then
	    echo.put_string("Writing %"");
	    echo.put_string(path);
	    echo.put_string("%" file.%N");
	 else
	    echo.w_put_string("Cannot write file %"");
	    echo.w_put_string(path);
	    echo.w_put_string(fz_b0);
	    die_with_code(exit_failure_code);
	 end;
      ensure
	 sfw.is_connected
      end;

   bfw_connect(bfw: BINARY_FILE_WRITE; path: STRING) is
      require
	 not bfw.is_connected;
	 path /= Void
      do
	 bfw.connect_to(path);
	 if bfw.is_connected then
	    echo.put_string("Writing %"");
	    echo.put_string(path);
	    echo.put_string("%" file.%N");
	 else
	    echo.w_put_string("Cannot write file %"");
	    echo.w_put_string(path);
	    echo.w_put_string(fz_b0);
	    die_with_code(exit_failure_code);
	 end;
      ensure
	 bfw.is_connected
      end;

feature {NONE}   

   fatal_error_vtec_2 is
      do
	 fatal_error("Expanded class must have no creation procedure,% 
		      % or only one creation procedure with%
		      % no arguments (VTEC.2).");
      end;
   
feature {NONE} -- System List :
   
   amiga_system:       STRING is "Amiga";
   dos_system:         STRING is "DOS";
   macintosh_system:   STRING is "Macintosh";
   os2_system:         STRING is "OS2";
   unix_system:        STRING is "UNIX";
   vms_system:         STRING is "VMS";
   windows_system:     STRING is "Windows";

   system_list: ARRAY[STRING] is
      once
	 Result := <<amiga_system, dos_system, macintosh_system, 
		     os2_system, unix_system, vms_system, 
		     windows_system>>;
      end;
   
   system_name: STRING is
      local
	 i: INTEGER;
      once
	 tmp_path.copy(small_eiffel_directory);
	 if tmp_path.has('/') then
	    tmp_path.set_last('/');
	    tmp_path.append(fz_sys);
	    tmp_path.extend('/');
	    tmp_path.append(fz_system_se);
	    echo.sfr_connect(tmp_file_read,tmp_path);
	 end;
	 if not tmp_file_read.is_connected then
	    tmp_path.copy(small_eiffel_directory);
	    if tmp_path.has('\') then
	       tmp_path.set_last('\');
	       tmp_path.append(fz_sys);
	       tmp_path.extend('\');
	       tmp_path.append(fz_system_se);
	       echo.sfr_connect(tmp_file_read,tmp_path);
	    end;
	 end;
	 if not tmp_file_read.is_connected then
	    tmp_path.copy(small_eiffel_directory);
	    if tmp_path.has(':') then
	       tmp_path.set_last(':');
	       tmp_path.append(fz_sys);
	       tmp_path.extend(':');
	       tmp_path.append(fz_system_se);
	       echo.sfr_connect(tmp_file_read,tmp_path);
	    end;
	 end;
	 if not tmp_file_read.is_connected then
	    tmp_path.copy(small_eiffel_directory);
	    if tmp_path.has(']') then
	       tmp_path.set_last(']');
	       tmp_path.remove_last(1);
	       tmp_path.extend('.');
	       tmp_path.append(fz_sys);
	       tmp_path.extend(']');
	       tmp_path.append(fz_system_se);
	       echo.sfr_connect(tmp_file_read,tmp_path);
	    end;
	 end;
	 if not tmp_file_read.is_connected then
	    tmp_path.copy(small_eiffel_directory);
	    tmp_path.append(fz_system_se);
	    echo.sfr_connect(tmp_file_read,tmp_path);
	 end;
	 if not tmp_file_read.is_connected then
	    echo.w_put_string("Unable to find file%N%"");
	    echo.w_put_string(fz_system_se);
	    echo.w_put_string("%" using path %"");
	    echo.w_put_string(small_eiffel_directory);
	    echo.w_put_string(fz_b0);
	    die_with_code(exit_failure_code);
	 end;
	 tmp_file_read.read_line;
	 Result := tmp_file_read.last_string;
	 i := system_list.index_of(Result);
	 tmp_file_read.disconnect;
	 if i > system_list.upper then
	    echo.w_put_string("Unknown system name in file%N%"");
	    echo.w_put_string(tmp_path);
	    echo.w_put_string("%".%NCurrently handled system names :%N");
	    from
	       i := 1;
	    until
	       i > system_list.upper
	    loop
	       echo.w_put_string(system_list.item(i));
	       echo.w_put_character('%N');
	       i := i + 1;
	    end;
	 else
	    Result := system_list.item(i);
	    echo.put_string("System is %"");
	    echo.put_string(Result);
	    echo.put_string(fz_b0);
	 end;
      end;
   
feature {NONE} -- Handling of Files Suffix Names :
   
   eiffel_suffix: STRING is ".e";
	 -- Eiffel Source file suffix.

   c_suffix: STRING is ".c";
	 -- C files suffix.

   h_suffix: STRING is ".h";
	 -- Heading C files suffix.

   o_suffix: STRING is 
	 -- Object File produced by the C Compiler.
      local
	 sn: STRING;
      once
	 sn := system_name;
	 !!Result.make(4);
	 tmp_path.copy(small_eiffel_directory);
	 add_directory(tmp_path,fz_sys);
	 tmp_path.append("o_suffix.");
	 tmp_path.append(sn);
	 echo.sfr_connect(tmp_file_read,tmp_path);
	 tmp_file_read.read_line_in(Result);
	 tmp_file_read.disconnect;
      end;

   x_suffix: STRING is 
	 -- Executable files suffix.
      once
	 if dos_system = system_name or else
	    vms_system = system_name
	  then
	    Result := ".EXE";
	 elseif os2_system = system_name then
	    Result := ".exe";
	 elseif windows_system = system_name then
	    Result := ".exe";
	 else
	    Result := "";
	 end;
      end;

   make_suffix: STRING is
      -- Suffix for make file produced by `compile_to_c'.
      once
	 if dos_system = system_name then
	    Result := ".BAT";
	 elseif windows_system = system_name then
	    Result := ".bat";
	 elseif vms_system = system_name then
	    Result := ".COM";
	 elseif os2_system = system_name then
	    Result := ".CMD";
	 else
	    Result := ".make";
	 end;
      end;

   backup_suffix: STRING is ".bak";
	 -- Backup suffix for command `pretty'.

   help_suffix: STRING is ".txt";
	 -- Suffix for SmallEiffel On-line Help Files.

   class_suffix: STRING is ".class";

feature {NONE}

   echo_rename_file(path1, path2: STRING) is
      do
	 if file_exists(path1) then
	    echo.put_string("Renaming %"");
	    echo.put_string(path1);
	    echo.put_string("%" as %"");
	    echo.put_string(path2);
	    echo.put_string(fz_18);
	    rename_file(path1,path2);
	 end;
      end;

   empty_eh_check: BOOLEAN is
      do
	 if eh.empty then
	    Result := true;
	 else
	    eh.append(" Internal Warning : EH not empty.");
	    eh.print_as_warning;
	    Result := true;
	 end;
      end;

feature {NONE}

   dot_precedence: INTEGER is 12; 
	 -- The highest precedence value according to ETL.
   
   atomic_precedence: INTEGER is 13;
	 -- Used for atomic elements. 

feature {NONE}

   jvm_root_class: STRING is
	 -- Fully qualified name for the jvm SmallEiffel object's
	 -- added root : "<Package>/<fz_jvm_root>".
      once
	 !!Result.make(12);
	 Result.copy(jvm.output_name);
	 Result.extend('/');
	 Result.append(fz_jvm_root);
      end;
   
   jvm_root_descriptor: STRING is
      	 -- Descriptor for `jvm_root_class': "L<jvm_root_class>;"
      once
	 !!Result.make(12);
	 Result.extend('L');
	 Result.append(jvm_root_class);
	 Result.extend(';');
      end;

feature {NONE}

   append_u1(str: STRING; u1: INTEGER) is
      require
	 0 <= u1;
	 u1 <= 255
      do
	 str.extend(u1.to_character);
      end;

   append_u2(str: STRING; u2: INTEGER) is
      require
	 0 <= u2;
	 u2 <= 65536
      do
	 append_u1(str,u2 // 256);
	 append_u1(str,u2 \\ 256);
      end;

   append_u4(str: STRING; u4: INTEGER) is
      require
	 0 <= u4;
	 u4 <= ((2 ^ 31) - 1)
      do
	 append_u2(str,u4 // 65536);
	 append_u2(str,u4 \\ 65536);
      end;

feature {NONE}

   jvm_standard_is_equal_aux(rc: RUN_CLASS; wa: ARRAY[RUN_FEATURE_2]) is
      require
	 rc /= Void
      local
	 ca: like code_attribute;
	 rf2: RUN_FEATURE_2;
	 point1, point2, idx, space, i: INTEGER;
      do
	 ca := code_attribute;
	 if wa = Void then
	    if rc.current_type.is_expanded then
	       ca.opcode_pop;
	       ca.opcode_pop;
	       ca.opcode_iconst_1;
	    else
	       ca.opcode_swap;
	       ca.opcode_pop;
	       idx := rc.fully_qualified_constant_pool_index;
	       ca.opcode_instanceof(idx);
	    end;
	 else
	    ca.branches.clear;
	    ca.opcode_dup;
	    idx := rc.fully_qualified_constant_pool_index;
	    ca.opcode_instanceof(idx);
	    ca.branches.add_last(ca.opcode_ifeq);
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       idx := constant_pool.idx_fieldref(rf2);
	       space := rf2.result_type.jvm_stack_space - 1;
	       if i > 1 then
		  ca.opcode_dup2;
	       end;
	       ca.opcode_getfield(idx,space);
	       if space = 0 then
		  ca.opcode_swap;
	       else
		  ca.opcode_dup2_x1;
		  ca.opcode_pop2;
	       end;
	       ca.opcode_getfield(idx,space);
	       if i > 1 then
		  ca.branches.add_last(rf2.result_type.jvm_if_x_ne);
	       else
		  point1 := rf2.result_type.jvm_if_x_ne;
	       end;
	       i := i - 1;
	    end;
	    ca.opcode_iconst_1;
	    point2 := ca.opcode_goto;
	    ca.resolve_branches;
	    ca.opcode_pop;
	    ca.opcode_pop;
	    ca.resolve_u2_branch(point1);
	    ca.opcode_iconst_0;
	    ca.resolve_u2_branch(point2);
	 end;
      end;

end -- GLOBALS

