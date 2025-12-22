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
class UNIQUE_STRING
   --
   -- Unique global object to share constant strings.
   -- To ensure that only one STRING is used for the same frozen
   -- contents (for example, everywhere the name "INTEGER" is
   -- used, the same object of class STRING is shared).
   -- Assume (checked in mode -debug_check) that STRING are not 
   -- dynamically changed.
   --

inherit GLOBALS;

creation make

feature

   item(model: STRING): STRING is
      require
	 model /= Void
      do
	 initialize;
	 if memory.has(model) then
	    Result := read(model);
	 else
	    Result := model.twin;
	    add1(Result);
	 end;
      ensure
	 Result.is_equal(model)
      end;

   count: INTEGER is
      do
	 Result := memory.count;
      end;

feature {PREFIX_NAME}

   for_prefix(to_string: STRING): STRING is
      do
	 pfx_ifx.copy("_ix_");
	 key_pfx_ifx(to_string);
	 Result := item(pfx_ifx);
      end;

feature {INFIX_NAME}

   for_infix(to_string: STRING): STRING is
      do
	 pfx_ifx.copy("_px_");
	 key_pfx_ifx(to_string);
	 Result := item(pfx_ifx);
      end;

feature {NONE}

   make is
      do
      end;

   initialize is
      once
	 -- -------------------------------------- Class names :
	 add1(us_any);
	 add1(us_array);
	 add1(us_bit);
	 add1(us_bit_n);
	 add1(us_bit_n_ref);
	 add1(us_boolean);
	 add1(us_boolean_ref);
	 add1(us_character);
	 add1(us_character_ref);
	 add1(us_dictionary);
	 add1(us_double);
	 add1(us_double_ref);
	 add1(us_fixed_array);
	 add1(us_general);
	 add1(us_integer);
	 add1(us_integer_ref);
	 add1(us_memory);
	 add1(us_native_array);
	 add1(us_none);
	 add1(us_platform);
	 add1(us_pointer);
	 add1(us_pointer_ref);
	 add1(us_real);
	 add1(us_real_ref);
	 add1(us_string);
	 add1(us_std_file_read);
	 -- ----------------------- Operator/Infix/Prefix list :
	 add1(us_and);
	 add1(us_and_then);
	 add1(us_at);
	 add1(us_backslash_backslash);
	 add1(us_eq);
	 add1(us_ge);
	 add1(us_gt);
	 add1(us_implies);
	 add1(us_le);
	 add1(us_lt);
	 add1(us_minus);
	 add1(us_muls);
	 add1(us_neq);
	 add1(us_not);
	 add1(us_or);
	 add1(us_or_else);
	 add1(us_plus);
	 add1(us_pow);
	 add1(us_shift_left);
	 add1(us_shift_right);
	 add1(us_slash);
	 add1(us_slash_slash);
	 add1(us_std_neq);
	 add1(us_xor);
	 -- ------------------------------------ Feature names :
	 add1(us_blank);
	 add1(us_bitn);
	 add1(us_boolean_bits);
	 add1(us_calloc);
	 add1(us_capacity);
	 add1(us_character_bits);
	 add1(us_clear_all);
	 add1(us_compile_to_c);
	 add1(us_compile_to_jvm);
	 add1(us_count);
	 add1(us_crash);
	 add1(us_code);
	 add1(us_conforms_to);
	 add1(us_copy);
	 add1(us_c_inline_c);
	 add1(us_c_inline_h);
	 add1(us_double_bits);
	 add1(us_double_floor);
	 add1(us_die_with_code);
	 add1(us_element_sizeof);
	 add1(us_eof_code);
	 add1(us_fclose);
	 add1(us_feof);
	 add1(us_floor);
	 add1(us_flush_stream);
	 add1(us_free);
	 add1(us_from_pointer);
	 add1(us_generating_type);
	 add1(us_generator);
	 add1(us_io);
	 add1(us_integer_bits);
	 add1(us_is_basic_expanded_type);
	 add1(us_is_expanded_type);
	 add1(us_is_equal);
	 add1(us_is_not_void);
	 add1(us_item);
	 add1(us_lower);
	 add1(us_malloc);
	 add1(us_make);
	 add2(us_minimum_character_code);
	 add2(us_minimum_double);
	 add2(us_minimum_integer);
	 add2(us_minimum_real);
	 add2(us_maximum_character_code);
	 add2(us_maximum_double);
	 add2(us_maximum_integer);
	 add2(us_maximum_real);
	 add1(us_object_size);
	 add1(us_pointer_bits);
	 add1(us_pointer_size);
	 add1(us_print);
	 add1(us_print_on);
	 add1(us_print_run_time_stack);
	 add1(us_put);
	 add1(us_put_0);
	 add1(us_put_1);
	 add1(us_read_byte);
	 add1(us_real_bits);
	 add1(us_realloc);
	 add1(us_se_argc);
	 add1(us_se_argv);
	 add1(us_se_getenv);
	 add1(us_se_remove);
	 add1(us_se_rename);
	 add1(us_se_string2double);
	 add1(us_se_system);
	 add1(us_sfr_open);
	 add1(us_sfw_open);
	 add1(us_sprintf_double);
	 add1(us_sprintf_pointer);
	 add1(us_standard_copy);
	 add1(us_standard_is_equal);
	 add1(us_standard_twin);
	 add1(us_stderr);
	 add1(us_stdin);
	 add1(us_stdout);
	 add1(us_std_error);
	 add1(us_std_input);
	 add1(us_std_output);
	 add1(us_storage);
	 add1(us_to_bit);
	 add1(us_to_character);
	 add1(us_to_double);
	 add1(us_to_integer);
	 add1(us_to_pointer);
	 add1(us_to_real);
	 add1(us_trace_switch);
	 add1(us_truncated_to_integer);
	 add1(us_twin);
	 add1(us_upper);
	 add1(us_with_capacity);
	 add1(us_write_byte);
	 -- -------------------------------------- Other names :
	 add1(us_current);
	 add1(us_native_array_character);
	 add1(us_like_current);
	 add1(us_result);
	 add1(us_void);
      end;

   add1(str: STRING) is
      require
	 not memory.has(str)
      do
	 memory.put(str,str);
	 debug
	    check_memory.put(str.twin,str);
	 end
      end;

   add2(str: STRING) is
      do
	 if eiffel_parser.case_insensitive then
	    str.to_lower;
	 end;
	 add1(str);
      end;

   read(model: STRING): STRING is
      do
	 Result := memory.at(model);
	 debug
	    if not check_memory.at(Result).is_equal(Result) then
	       eh.append("UNIQUE_STRING error report : ");
	       eh.append(check_memory.at(Result));
	       eh.append("%" changed to %"");
	       eh.append(Result);
	       fatal_error("%".");
	    end;
	 end;
      end;

   memory: DICTIONARY[STRING,STRING] is
      once
	 !!Result.with_capacity(4096);
      end;

   pfx_ifx: STRING is 
      once
	 !!Result.make(16);
      end;

   key_pfx_ifx(to_string: STRING) is
      local
	 i: INTEGER;
	 c: CHARACTER;
      do
	 from
	    i := 1;
	 until
	    i > to_string.count
	 loop
	    c := to_string.item(i);
	    if c.is_letter then
	       pfx_ifx.extend(c);
	    else 
	       c.code.append_in(pfx_ifx);
	    end;
	    i := i + 1;
	 end;
      end;
end -- UNIQUE_STRING

